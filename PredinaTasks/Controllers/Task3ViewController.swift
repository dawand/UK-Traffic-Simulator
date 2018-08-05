//
//  Task3ViewController.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class Task3ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var coordinates = [Coordinate]()
    var vehicles = [Vehicle]()
    var coordinateTimer: Timer!
    var vehicleTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        // 1. Load coordinates
        loadCoordinates()
        
        // 2. Load Vehicles for current time
        showVehicles()
        
        // 3. call updateTrafficMap method every second
        coordinateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
        
        // 4. update the vehicles location every minute
        vehicleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
    }
    
    func loadCoordinates() {
        
        if let csvRows = Utils.readDataFromCSV(fileName: "Coordinates_\(SAMPLE_SIZE)", fileType: "csv") {
            
            for row in csvRows {
                if let lat = Double(row[0]), let long = Double(row[1]) {
                    let coordinate = Coordinate(latitude: lat, longitude: long, traffic: 0)
                    coordinates.append(coordinate)
                }
            }
        }
    }

    func showVehicles() {
        
        // 2.a. load vehicles for the current hh:mm
        loadVehiclesData(time: Utils.getCurrentTime())
        //loadVehiclesData(time:"05:00")
        
        // 2.b. show the vehicle annotations for the current time
        showVehicleAnnotations()
    }
    
    func loadVehiclesData(time:String ){
        if let csvRows = Utils.readDataFromCSVForTime(fileName: "realtimelocation", fileType: "csv", time: time) {
            
            for row in csvRows {
                if let lat = Double(row[2]), let long = Double(row[3]) {
                    let vehicle = Vehicle(time: row[0], name: row[1], latitude: lat, longitude: long)
                    vehicles.append(vehicle)
                }
            }
        }
    }
    
    @objc func updateTafficMap(){
        // 3.a. generate the random traffic numbers between 1-10 for each coordinate
        
        coordinates.forEach {
            let randomTraffic = Int(arc4random_uniform(10) + 1)
            $0.traffic = randomTraffic
        }
        
        // 3.b. Only remove previous traffic annotations
        mapView.annotations.forEach {
            if $0.isKind(of: CoordinateAnnotation.self){
                mapView.removeAnnotation($0)
            }
        }
        
        // 3.c. plot them on the UK map
        for coordinate in coordinates {
            let annotation = CoordinateAnnotation(identifier: "\(coordinate.latitude)\(coordinate.longitude)", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), traffic: coordinate.traffic)
            
            mapView.addAnnotation(annotation)
        }
    }

    @objc func updateVehicles() {
        showVehicles()
    }
    
    func showVehicleAnnotations() {
        
        // 4.a. Only remove previous vehicle     annotations
        mapView.annotations.forEach {
            if $0.isKind(of: VehicleAnnotation.self){
                mapView.removeAnnotation($0)
            }
        }
        
        // 4.b. plot them on the UK map
        for vehicle in vehicles {
            let annotation = VehicleAnnotation(coordinate: CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude), time: vehicle.time, name: vehicle.name)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    // MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var trafficAnnotationView : CoordinateAnnotationView
        var vehicleAnnotationView : VehicleAnnotationView

        if let annotation = annotation as? CoordinateAnnotation {
            
            // reusing annotation by its identifier
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? CoordinateAnnotationView {
                trafficAnnotationView = dequeuedView
            }else {
                trafficAnnotationView = CoordinateAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            }
            
            trafficAnnotationView.setColor(traffic: annotation.traffic)
            
            return trafficAnnotationView
        }
        
        else if let annotation = annotation as? VehicleAnnotation {
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) as? VehicleAnnotationView {
                vehicleAnnotationView = dequeuedView
            }else {
                vehicleAnnotationView = VehicleAnnotationView(annotation: annotation, reuseIdentifier: annotation.title)
            }
            
            return vehicleAnnotationView
        } 
        return nil
    }
    
}

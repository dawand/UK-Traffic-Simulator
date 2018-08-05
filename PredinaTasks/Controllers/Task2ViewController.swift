//
//  SecondViewController.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class Task2ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var vehicles = [Vehicle]()
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        showVehicles()
        
        // update the vehicles location every minute
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
    }
    
    func showVehicles() {
        
        // 1. load vehicles for the current hh:mm
        loadVehiclesData(time: Utils.getCurrentTime())
        // loadVehiclesData(time:"05:00")
        
        // 2. show the vehicle annotations for the current time
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
    
    func showVehicleAnnotations() {
        
        // 2.a. remove previous locations of vehicles
        self.mapView.removeAnnotations(mapView.annotations)
        
        // 2.b. annotate the vehicles on the map
        for vehicle in vehicles {
            let annotation = VehicleAnnotation(coordinate: CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude), time: vehicle.time, name: vehicle.name)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func updateVehicles() {
        showVehicles()
    }
    
    // MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : VehicleAnnotationView
        
        if let annotation = annotation as? VehicleAnnotation {
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) as? VehicleAnnotationView {
                annotationView = dequeuedView
            }else {
                annotationView = VehicleAnnotationView(annotation: annotation, reuseIdentifier: annotation.title)
            }
            
            return annotationView
        }
        return nil
    }
}


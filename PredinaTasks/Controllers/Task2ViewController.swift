//
//  SecondViewController.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class Task2ViewController: UIViewController {

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
        
        // load vehicles for the current hh:mm
        loadVehiclesData(time: Utils.getCurrentTime())
        // loadVehiclesData(time:"05:00")
        
    }
    
    func loadVehiclesData(time:String ){
        
        if perform_locally {
            if let csvRows = Utils.readDataFromCSVForTime(fileName: "realtimelocation", fileType: "csv", time: time) {
                
                for row in csvRows {
                    if let lat = Double(row[2]), let long = Double(row[3]) {
                        let vehicle = Vehicle(time: row[0], name: row[1], latitude: lat, longitude: long)
                        vehicles.append(vehicle)
                    }
                }
                
                // show the vehicle annotations for the current time
                showVehicleAnnotations()
            }
        } else {
            ServiceManager.shared.getVehicles(from: "\(vehicles_api_link)\(Utils.getCurrentTime())", completion: { (vehicles : [Vehicle]) in
                self.vehicles = vehicles
                
                DispatchQueue.main.async {
                    // show the vehicle annotations for the current time
                    self.showVehicleAnnotations()
                }
            })
        }
    }
    
    func showVehicleAnnotations() {
        
        // remove previous locations of vehicles
        self.mapView.removeAnnotations(mapView.annotations)
        
        // annotate the vehicles on the map
        for vehicle in vehicles {
            let annotation = VehicleAnnotation(coordinate: CLLocationCoordinate2D(latitude: vehicle.Latitude, longitude: vehicle.Longitude), time: vehicle.Time, name: vehicle.Vehicle)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func updateVehicles() {
        showVehicles()
    }
    
    // MKMapViewDelegate methods
}

extension Task2ViewController: MKMapViewDelegate {
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

extension Task2ViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let timer = timer {
            timer.invalidate()
        }
    }
}

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
    
    var hour = 9
    var minute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        showVehicles(for: "0\(hour):0\(minute)")
        
        // update the vehicles location every minute
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
    }
    
    func showVehicles(for time: String) {
        
        // load vehicles for the current hh:mm
        //loadVehiclesData(time: Utils.getCurrentTime())
        loadVehiclesData(time:time)
        
    }
    
    func loadVehiclesData(time:String){
        
        if perform_locally {
            vehicles.removeAll(keepingCapacity: true)
            debugPrint("Getting cars locally for time: \(time)")
            
            if let csvRows = Utils.readDataFromCSVForTime(fileName: "realtimelocation", fileType: "csv", time: time) {
                
                for row in csvRows {
                    if let lat = Double(row[2]), let long = Double(row[3]) {
                        let vehicle = Vehicle(time: row[0], name: row[1], latitude: lat, longitude: long)
                        
                   //     if vehicle.Vehicle == "Vehicle_847" {
                            vehicles.append(vehicle)
                   //     }
                    }
                }
                
                debugPrint("Fetched \(vehicles.count) cars locally")
                
                // show the vehicle annotations for the current time
                showVehicleAnnotations()
            }
        } else {
            ServiceManager.shared.getVehicles(from: "\(vehicles_api_link)\(time)", completion: { (vehicles : [Vehicle]) in
                self.vehicles = vehicles
                
                print("The server returned \(vehicles.count) vehicles")
                
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
    //    showVehicles()
        minute += 1
        
        // to reset the minute back to zero
        if minute > 59 {
            minute = 0
            hour += 1
            if hour > 23 { hour = 0 }
        }
        
        var stringMin = String(minute)
        var stringHour = String(hour)
        
        // to add the leading zero
        if stringMin.count == 1 {
            stringMin = "0\(stringMin)"
        }
        if stringHour.count == 1 {
            stringHour = "0\(stringHour)"
        }
        
        loadVehiclesData(time:"\(stringHour):\(stringMin)")
    }
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
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let timer = timer {
            timer.invalidate()
        }
    }
}

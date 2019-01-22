//
//  Task3ViewController.swift
//  TrafficSimulator
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class CombinedViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var coordinates = [Coordinate]()
    var vehicles = [Vehicle]()
    var coordinateTimer: Timer!
    var vehicleTimer: Timer!
    
    var hour = 9
    var minute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
      //  registerAnnotationViewClasses()

        // 1. Load coordinates
        loadCoordinates()
        
        // 2. Load Vehicles for current time
        loadVehicles(time: "0\(hour):0\(minute)")
        
        // 3. call updateTrafficMap method every second
        coordinateTimer = Timer.scheduledTimer(timeInterval: coordinateUpdateTimeValue, target: self, selector: #selector(updateCoordinates), userInfo: nil, repeats: true)
        
        // 4. update the vehicles location every minute
        vehicleTimer = Timer.scheduledTimer(timeInterval: vehicleUpdateTimeValue, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
    }
    
    func loadCoordinates() {
        
        if perform_locally {
            
            coordinates.removeAll(keepingCapacity: true)
            
            if let csvRows = Utils.readDataFromCSV(fileName: "Coordinates_\(sample_size)", fileType: "csv") {
                
                for row in csvRows {
                    if let lat = Double(row[0]), let long = Double(row[1]) {
                        let coordinate = Coordinate(latitude: lat, longitude: long, color: 0)
                        coordinates.append(coordinate)
                    }
                }
                
                DispatchQueue.main.async {
                    self.showCoordinateAnnoations()
                }
            }
        } else {
            ServiceManager.shared.getCoordinates(from: coordinates_api_link, completion: { (coordinates : [Coordinate]) in
                self.coordinates = coordinates
                
                DispatchQueue.main.async {
                    self.showCoordinateAnnoations()
                }
            })
        }
    }
    
    func loadVehicles(time: String) {
        
        if perform_locally {
            
            vehicles.removeAll(keepingCapacity: true)
            debugPrint("Getting cars locally for time: \(time)")
            
            if let csvRows = Utils.readDataFromCSVForTime(fileName: "realtimelocation", fileType: "csv", time: time) {
                
                for row in csvRows {
                    if let lat = Double(row[2]), let long = Double(row[3]) {
                        let vehicle = Vehicle(time: row[0], name: row[1], latitude: lat, longitude: long)
                  //      if vehicle.Vehicle == "Vehicle_847" {
                            vehicles.append(vehicle)
                  //      }
                    }
                }
                
                debugPrint("Fetched \(vehicles.count) cars locally")

                DispatchQueue.main.async {
                    // 2.b. show the vehicle annotations for the current time
                    self.showVehicleAnnotations()
                }
            }
        } else {
            ServiceManager.shared.getVehicles(from: "\(vehicles_api_link)\(time)", completion: { (vehicles : [Vehicle]) in
                self.vehicles = vehicles
                print("The server returned \(vehicles.count) vehicles")
                
                DispatchQueue.main.async {
                    // 2.b. show the vehicle annotations for the current time
                    self.showVehicleAnnotations()
                }
            })
        }
    }
    
    func showCoordinateAnnoations() {
        
        // Only remove previous traffic annotations
        mapView.annotations.forEach {
            if $0.isKind(of: CoordinateAnnotation.self){
                mapView.removeAnnotation($0)
            }
        }
        
        if perform_locally {
            // generate the random traffic numbers between 1-10 for each coordinate
            coordinates.forEach {
                let randomTraffic = Int(arc4random_uniform(10) + 1)
                $0.Color = randomTraffic
            }
        }
        
        // plot them on the UK map
        for coordinate in coordinates {
            let annotation = CoordinateAnnotation(identifier: "\(coordinate.Latitude)\(coordinate.Longitude)", coordinate: CLLocationCoordinate2D(latitude: coordinate.Latitude, longitude: coordinate.Longitude), color: coordinate.Color)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func showVehicleAnnotations() {
        
        // Only remove previous vehicle annotations
        mapView.annotations.forEach {
            if $0.isKind(of: VehicleAnnotation.self){
                mapView.removeAnnotation($0)
            }
        }
        
        // plot them on the UK map
        for vehicle in vehicles {
            let annotation = VehicleAnnotation(coordinate: CLLocationCoordinate2D(latitude: vehicle.Latitude, longitude: vehicle.Longitude), time: vehicle.Time, name: vehicle.Vehicle)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func updateCoordinates(){
        
        if perform_locally {
            // generate the random traffic numbers between 1-10 for each coordinate
            coordinates.forEach {
                let randomTraffic = Int(arc4random_uniform(10) + 1)
                $0.Color = randomTraffic
            }
        } else {
            // fetch the updated colors from the server
            loadCoordinates()
        }
        
        showCoordinateAnnoations()
    }
    
    @objc func updateVehicles() {
        //  showVehicles()
        
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
        
        loadVehicles(time:"\(stringHour):\(stringMin)")
    }
    
//    func registerAnnotationViewClasses() {
//        mapView.register(CoordinateClusterView.self, forAnnotationViewWithReuseIdentifier: "CoordinateClusterView")
//        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: "VehicleClusterView")
//    }
}

extension CombinedViewController: MKMapViewDelegate {
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
            
            trafficAnnotationView.clusteringIdentifier = "Coordinate"
            trafficAnnotationView.setColor(traffic: annotation.color)

            return trafficAnnotationView
        }
            
        else if let annotation = annotation as? VehicleAnnotation {
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) as? VehicleAnnotationView {
                vehicleAnnotationView = dequeuedView
            }else {
                vehicleAnnotationView = VehicleAnnotationView(annotation: annotation, reuseIdentifier: annotation.title)
            }
            
            vehicleAnnotationView.clusteringIdentifier = "Vehicle"
            
            return vehicleAnnotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if #available(iOS 11.0, *) {
            if let cluster = view.annotation as? MKClusterAnnotation {
                // display all annotations in that cluster
                mapView.showAnnotations(cluster.memberAnnotations, animated: true)
            }
        }
    }
    
//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//        memberAnnotations.forEach {
//            if $0.isKind(of: VehicleAnnotation.self){
//                return ClusterView()
//            } else {
//                return CoordinateClusterView()
//            }
//        }
//
//        return ClusterView()
//    }
}

extension CombinedViewController {
    // Manage Timer
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !coordinateTimer.isValid {
            coordinateTimer = Timer.scheduledTimer(timeInterval: coordinateUpdateTimeValue, target: self, selector: #selector(updateCoordinates), userInfo: nil, repeats: true)
        }
        
        if !vehicleTimer.isValid {
            vehicleTimer = Timer.scheduledTimer(timeInterval: vehicleUpdateTimeValue, target: self, selector: #selector(updateVehicles), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let cTimer = coordinateTimer, let vTimer = vehicleTimer {
            cTimer.invalidate()
            vTimer.invalidate()
        }
    }
}

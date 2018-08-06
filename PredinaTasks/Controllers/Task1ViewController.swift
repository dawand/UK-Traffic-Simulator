//
//  FirstViewController.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class Task1ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var coordinates = [Coordinate]()
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self;
        
        // Load coordinates
        loadCoordinates()
        
        // call updateTrafficMap method every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
    }
    
    func loadCoordinates() {
        
        if perform_locally {
            if let csvRows = Utils.readDataFromCSV(fileName: "Coordinates_\(sample_size)", fileType: "csv") {
                
                for row in csvRows {
                    if let lat = Double(row[0]), let long = Double(row[1]) {
                        let coordinate = Coordinate(latitude: lat, longitude: long, color: 0)
                        coordinates.append(coordinate)
                    }
                }
            }
        } else {
            ServiceManager.shared.getCoordinates(from: coordinates_api_link, completion: { (coordinates : [Coordinate]) in
                self.coordinates = coordinates
            })
        }
    }
    
    @objc func updateTafficMap(){
        
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
        
        // remove previous annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // annotate them on the UK map
        for coordinate in coordinates {
            let annotation = CoordinateAnnotation(identifier: "\(coordinate.Latitude)\(coordinate.Longitude)", coordinate: CLLocationCoordinate2D(latitude: coordinate.Latitude, longitude: coordinate.Longitude), color: coordinate.Color)
            
            mapView.addAnnotation(annotation)
        }
    }
}

extension Task1ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : CoordinateAnnotationView
        
        if let annotation = annotation as? CoordinateAnnotation {
            
            // reusing annotation by its identifier (lat+long)
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? CoordinateAnnotationView {
                annotationView = dequeuedView
            } else{
                annotationView = CoordinateAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            }
            
            annotationView.setColor(traffic: annotation.color)
            
            return annotationView
        }
        
        return nil
    }
}

extension Task1ViewController {
    // Avoid running multiple timers simultaneously with the other tasks
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let timer = timer {
            timer.invalidate()
        }
    }
}


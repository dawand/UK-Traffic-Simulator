//
//  FirstViewController.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

let SAMPLE_SIZE = 100

class Task1ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var coordinates = [Coordinate]()
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self;

        // 1. Load coordinates
        loadCoordinates()
        
        // 2. call updateTrafficMap method every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
        
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
    
    @objc func updateTafficMap(){
        
        // 2.a. generate the random traffic numbers between 1-10 for each coordinate
        coordinates.forEach {
            let randomTraffic = Int(arc4random_uniform(10) + 1)
            $0.traffic = randomTraffic
        }
        
        // 2.b. remove previous annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // 2.c. annotate them on the UK map
        for coordinate in coordinates {
            let annotation = CoordinateAnnotation(identifier: "\(coordinate.latitude)\(coordinate.longitude)", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), traffic: coordinate.traffic)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    // MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : CoordinateAnnotationView

        if let annotation = annotation as? CoordinateAnnotation {
            
            // reusing annotation by its identifier (lat+long)
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? CoordinateAnnotationView {
                annotationView = dequeuedView
            } else{
                annotationView = CoordinateAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
            }
            
            annotationView.setColor(traffic: annotation.traffic)
            
            return annotationView
        }
        
        return nil
    }
}


//
//  FirstViewController.swift
//  TrafficSimulator
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class Task1ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var coordinates = [Coordinate]()
    var timer: Timer!
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self;
        
        // Load coordinates
        loadCoordinates()
        
        registerAnnotationViewClasses()

        // call updateTrafficMap method every second
        timer = Timer.scheduledTimer(timeInterval: coordinateUpdateTimeValue, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
    }
    
    func loadCoordinates() {
        loading = true
        updateMapInteractions(enable: false)

        if perform_locally {
            if let csvRows = Utils.readDataFromCSV(fileName: "Coordinates_\(sample_size)", fileType: "csv") {
                
                for row in csvRows {
                    if let lat = Double(row[0]), let long = Double(row[1]) {
                        let coordinate = Coordinate(latitude: lat, longitude: long, color: 0)
                        coordinates.append(coordinate)
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.coordinates.forEach {
                        let randomTraffic = Int(arc4random_uniform(10) + 1)
                        $0.Color = randomTraffic
                    }
                    
                    self.showCoordinates()
                }
            }
        } else {
            ServiceManager.shared.getCoordinates(from: coordinates_api_link, completion: { (coordinates : [Coordinate]) in
                self.coordinates = coordinates
                
                DispatchQueue.main.async {
                    self.showCoordinates()
                }
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
        
        showCoordinates()
    }
    
    func showCoordinates() {
        // remove previous annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKAnnotation]()
        // annotate them on the UK map
        for coordinate in coordinates {
            let annotation = CoordinateAnnotation(identifier: "\(coordinate.Latitude)\(coordinate.Longitude)", coordinate: CLLocationCoordinate2D(latitude: coordinate.Latitude, longitude: coordinate.Longitude), color: coordinate.Color)
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        
        loading = false
        updateMapInteractions(enable: true)
    }
    
    func updateMapInteractions(enable: Bool) {
        self.mapView.isZoomEnabled = enable
        self.mapView.isScrollEnabled = enable
        self.mapView.isUserInteractionEnabled = enable
    }
    
    func registerAnnotationViewClasses() {
        mapView.register(CoordinateAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CoordinateClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    deinit {
        self.mapView.delegate = nil
        self.mapView = nil
    }
}

extension Task1ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : CoordinateAnnotationView
        
        if let annotation = annotation as? CoordinateAnnotation {
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? CoordinateAnnotationView {
                annotationView = dequeuedView
            } else{
                annotationView = CoordinateAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
            
            annotationView.clusteringIdentifier = "Coordinate"
            annotationView.setColor(traffic: annotation.color)

            return annotationView
        } else if let cluster = annotation as? MKClusterAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? CoordinateClusterView
            if view == nil{
                //Very IMPORTANT
                print("nil for Cluster")
                view = CoordinateClusterView(annotation: cluster, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            }
            return view
        } else {
            return nil
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        updateMapInteractions(enable: false)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered {
            loading = false
            updateMapInteractions(enable: true)
        } else {
            loading = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
        print("Region did change - Zoom factor: \(zoomFactor)")
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if loading { return }

        if let cluster = view.annotation as? MKClusterAnnotation {
            // display all annotations in that cluster
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
        }
    }
}

extension Task1ViewController {
    // Avoid running multiple timers simultaneously with the other tasks
    
    override func viewDidAppear(_ animated: Bool) {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: coordinateUpdateTimeValue, target: self, selector: #selector(updateTafficMap), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let timer = timer {
            timer.invalidate()
        }
    }
}

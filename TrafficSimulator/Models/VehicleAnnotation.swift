//
//  VehicleAnnotation.swift
//  TrafficSimulator
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation
import MapKit

class VehicleAnnotation: NSObject, MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let time: String
    let title: String?
    
    init(coordinate: CLLocationCoordinate2D, time:String, name:String)
    {
        self.coordinate = coordinate
        self.time = time
        self.title = name
        super.init()
    }
}

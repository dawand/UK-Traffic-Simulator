//
//  MyAnnotation.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation
import MapKit

class CoordinateAnnotation: NSObject, MKAnnotation
{
    let identifier: String
    let coordinate: CLLocationCoordinate2D
    let traffic: Int

    init(identifier: String, coordinate: CLLocationCoordinate2D, traffic: Int)
    {
        self.identifier = identifier
        self.coordinate = coordinate
        self.traffic = traffic
        super.init()
    }
}

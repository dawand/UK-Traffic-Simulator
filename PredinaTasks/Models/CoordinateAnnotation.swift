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
    let color: Int

    init(identifier: String, coordinate: CLLocationCoordinate2D, color: Int)
    {
        self.identifier = identifier
        self.coordinate = coordinate
        self.color = color
        super.init()
    }
}

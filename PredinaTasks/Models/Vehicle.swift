//
//  Vehicle.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class Vehicle {
    var time: String
    var name: String
    let latitude: Double
    let longitude: Double
    
    init(time: String, name: String, latitude: Double, longitude: Double) {
        self.time = time
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}


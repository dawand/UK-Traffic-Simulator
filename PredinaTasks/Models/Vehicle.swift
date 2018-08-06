//
//  Vehicle.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class Vehicle: Codable {
    var Time: String
    var Vehicle: String
    let Latitude: Double
    let Longitude: Double
    
    init(time: String, name: String, latitude: Double, longitude: Double) {
        self.Time = time
        self.Vehicle = name
        self.Latitude = latitude
        self.Longitude = longitude
    }
}


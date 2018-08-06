//
//  Coordinate.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class Coordinate: Codable {
    let Latitude:Double
    let Longitude:Double
    var Color:Int
    
    init(latitude: Double, longitude: Double, color: Int) {
        self.Latitude = latitude
        self.Longitude = longitude
        self.Color = color
    }
}

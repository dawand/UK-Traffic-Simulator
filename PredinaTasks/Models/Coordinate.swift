//
//  Coordinate.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import Foundation

class Coordinate {
    let latitude:Double
    let longitude:Double
    var traffic:Int
    
    init(latitude: Double, longitude: Double, traffic: Int) {
        self.latitude = latitude
        self.longitude = longitude
        self.traffic = traffic
    }
}

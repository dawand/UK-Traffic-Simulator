//
//  CoordinateAnnotationView.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class CoordinateAnnotationView: MKPinAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setColor(traffic: Int){
        // set the color of the pin accordingly
        switch traffic
        {
        case 1...3:
            self.pinTintColor = UIColor.green
        case 4...5:
            self.pinTintColor = UIColor.yellow
        case 6...7:
            self.pinTintColor = UIColor.orange
        case 8...10:
            self.pinTintColor = UIColor.red
        default:
            debugPrint("It should never reach here!")
            self.pinTintColor = UIColor.black
        }
    }
}

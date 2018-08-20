//
//  CoordinateAnnotationView.swift
//  PredinaTasks
//
//  Created by Dawand Sulaiman on 05/08/2018.
//  Copyright © 2018 St Andrews. All rights reserved.
//

import UIKit
import MapKit

class CoordinateAnnotationView: MKAnnotationView {

    var imageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.imageView = UIImageView(frame: CGRect(x: self.center.x, y: self.center.y, width: 20, height: 20))
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.alpha = 0.6;
        self.addSubview(imageView)
        
        // Also set center offset for annotation
        self.centerOffset = CGPoint(x: -10, y: -20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setColor(traffic: Int){
        
       
        // set the color of the pin accordingly
        switch traffic
        {
        case 1...3:
            self.imageView.backgroundColor = UIColor.green
        case 4...5:
            self.imageView.backgroundColor = UIColor.yellow
        case 6...7:
            self.imageView.backgroundColor = UIColor.orange
        case 8...10:
            self.imageView.backgroundColor = UIColor.red
        default:
            debugPrint("It should never reach here!")
            self.imageView.backgroundColor = UIColor.black
        }
    }
}

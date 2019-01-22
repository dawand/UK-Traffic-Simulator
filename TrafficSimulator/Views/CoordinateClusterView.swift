/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A subclass of MKAnnotationView that configures itself for representing a MKClusterAnnotation with only Bike member annotations.
 */
import MapKit

class CoordinateClusterView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultLow
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                
                let count = cluster.memberAnnotations.count
                
                // counting the number of annotations for each color
                let yellowCount = cluster.memberAnnotations.filter { member -> Bool in return (member as! CoordinateAnnotation).color >= 3 && (member as! CoordinateAnnotation).color <= 5 }.count
                let orangeCount = cluster.memberAnnotations.filter { member -> Bool in return (member as! CoordinateAnnotation).color >= 6 && (member as! CoordinateAnnotation).color <= 7 }.count
                let redCount = cluster.memberAnnotations.filter { member -> Bool in return (member as! CoordinateAnnotation).color >= 8 && (member as! CoordinateAnnotation).color <= 10 }.count
                
                image = renderer.image { _ in
                    
                    // Fill full circle with green color
                    UIColor.green.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

                  //  Fill pie with yellow color
                    UIColor.yellow.setFill()
                    let yellowPiePath = UIBezierPath()
                    yellowPiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(yellowCount)) / CGFloat(count),
                                   clockwise: true)
                    yellowPiePath.addLine(to: CGPoint(x: 20, y: 20))
                    yellowPiePath.close()
                    yellowPiePath.fill()

                    // Fill pie with orange color
                    UIColor.orange.setFill()
                    let orangePiePath = UIBezierPath()
                    orangePiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: (CGFloat.pi * 2.0 * CGFloat(yellowCount)) / CGFloat(count), endAngle: (CGFloat.pi * 2.0 * CGFloat(orangeCount)) / CGFloat(count),
                                   clockwise: true)
                    orangePiePath.addLine(to: CGPoint(x: 20, y: 20))
                    orangePiePath.close()
                    orangePiePath.fill()

                    //   Fill pie with red color
                    UIColor.red.setFill()
                    let redPiePath = UIBezierPath()
                    redPiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: (CGFloat.pi * 2.0 * CGFloat(orangeCount)) / CGFloat(count), endAngle: (CGFloat.pi * 2.0 * CGFloat(redCount)) / CGFloat(count),
                                   clockwise: true)
                    redPiePath.addLine(to: CGPoint(x: 20, y: 20))
                    redPiePath.close()
                    redPiePath.fill()
                    
                    // Fill inner circle with white color
                    UIColor.white.setFill()
                    
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
                    
                    // Finally draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                }
            }
        }
    }
    
}

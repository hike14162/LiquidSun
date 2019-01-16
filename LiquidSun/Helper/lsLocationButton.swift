import UIKit

@IBDesignable
class lsLocationButton: UIBarButtonItem {
    var delegate: lsLocationButtonDelegate?
    
    override func prepareForInterfaceBuilder() {
        drawButton(color: self.tintColor!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawButton(color: self.tintColor!)
    }

    private let shapeLayer = CAShapeLayer()

    private func drawButton(color: UIColor) {
        customView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        customView?.backgroundColor = .clear
        customView?.layer.backgroundColor = UIColor.clear.cgColor
        
        customView?.layer.addSublayer(shapeLayer)
        
        //draw the path
        let path = UIBezierPath()
        path.move(to:    CGPoint(x: 20, y: 3))
        path.addLine(to: CGPoint(x: 4,  y: 12))
        path.addLine(to: CGPoint(x: 12, y: 12))
        path.addLine(to: CGPoint(x: 12, y: 20))
        path.addLine(to: CGPoint(x: 20, y: 3))
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 0.5
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        
        if let btnView = customView {
            btnView.addGestureRecognizer(tapGest)
        }
    }
    
    private func animateButton() {
        if let tint = self.tintColor {
            let anim = CABasicAnimation(keyPath: "fillColor")
            anim.fromValue = tint.cgColor
            anim.toValue = UIColor.lightGray.cgColor
            anim.duration = 0.2
            shapeLayer.add(anim, forKey: "color")
            
            let animback = CABasicAnimation(keyPath: "fillColor")
            animback.fromValue = UIColor.lightGray.cgColor
            animback.toValue = tint.cgColor
            animback.duration = 0.2
            shapeLayer.add(animback, forKey: "color")
        }
    }
    
    @objc func buttonTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let dlgt = delegate {
                animateButton()
                dlgt.locationRequested(_sender: self)
            }
        }
    }
}

protocol lsLocationButtonDelegate {
    func locationRequested(_sender: Any)
}

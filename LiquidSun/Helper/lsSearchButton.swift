import UIKit

@IBDesignable
class lsSearchButton: UIBarButtonItem {
    var delegate: lsSearchButtonDelegate?

    private let shapeLayer = CAShapeLayer()

    override func prepareForInterfaceBuilder() {
        drawButton(color: self.tintColor!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        drawButton(color: self.tintColor!)
    }
    
    private func drawButton(color: UIColor) {
        customView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        customView?.backgroundColor = .clear
        customView?.layer.backgroundColor = UIColor.clear.cgColor
        customView?.layer.addSublayer(shapeLayer)
        
        //draw the path
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 15, y: 8, width: 12, height: 12))

        let handlePath = UIBezierPath()
        handlePath.move(to:    CGPoint(x: 25, y: 18))
        handlePath.addLine(to: CGPoint(x: 32,  y: 25))

        let paths = [circlePath, handlePath]
        let myPath = UIBezierPath()
        for path in paths {
            myPath.append(path) 
        }

        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.path = myPath.cgPath
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        //CAShapeLayerLineCap.round
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        
        if let btnView = customView {
            btnView.addGestureRecognizer(tapGest)
        }
    }
    
    private func animateButton() {
        if let tint = self.tintColor {
            let anim = CABasicAnimation(keyPath: "strokeColor")
            anim.fromValue = tint.cgColor
            anim.toValue = UIColor.lightGray.cgColor
            anim.duration = 0.2
            shapeLayer.add(anim, forKey: "color")
            
            let animback = CABasicAnimation(keyPath: "strokeColor")
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
                dlgt.searchRequested(_sender: self)
            }
        }
    }

}

protocol lsSearchButtonDelegate {
    func searchRequested(_sender: Any)
}

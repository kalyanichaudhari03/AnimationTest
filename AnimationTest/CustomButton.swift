//
//  CustomButton.swift
//  AnimationsTest
//
//  Created by Kalyani on 24/11/20.
//

import UIKit
protocol ShadowableRoundableButton {

    var cornerRadius: CGFloat { get set }
    var boarderWidth : CGFloat {get set}
    var boarderColor : CGColor {get set}
    var shadowColor: UIColor { get set }
    var shadowOffsetWidth: CGFloat { get set }
    var shadowOffsetHeight: CGFloat { get set }
    var shadowOpacity: Float { get set }
    var shadowRadius: CGFloat { get set }
    var shadowLayer: CAShapeLayer { get }
        func setCornerRadiusAndShadow()
}
extension ShadowableRoundableButton where Self: UIButton {
    func setCornerRadiusAndShadow() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = boarderWidth
        layer.borderColor = boarderColor
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                            cornerRadius: cornerRadius ).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = titleLabel?.textColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowOffsetWidth ,
                                          height: shadowOffsetHeight )
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        
    }
}
@IBDesignable
class CustomButton: UIButton , ShadowableRoundableButton {
    var boarderColor: CGColor = UIColor(red: 25.0/255.0, green: 206.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
    
    var boarderWidth: CGFloat = 1.0
    
    var cornerRadius: CGFloat = 30

    var shadowOpacity: Float = 0.3

    var shadowRadius: CGFloat = 2

    var shadowColor: UIColor = UIColor(red: 25.0/255.0, green: 206.0/255.0, blue: 251.0/255.0, alpha: 0.5)

    var shadowOffsetWidth: CGFloat = 1

    var shadowOffsetHeight: CGFloat = 2

    private(set) lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        self.setNeedsLayout()
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCornerRadiusAndShadow()
    }
}




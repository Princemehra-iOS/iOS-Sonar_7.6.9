//  GradientView.swift
//  gradientDemo
//https://stackoverflow.com/questions/53704671/set-gradient-color-on-custom-uiview-boarder
//
//  Created by AVINASH on 02/02/20.
//  Copyright © 2020 AVINASH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadius: Double {
        
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 8.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
  
    @IBInspectable var outerColor: UIColor = .orange {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var innerColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
   
    
    @IBInspectable var isHorizontal: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
    
    var gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() -> Void {
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor,UIColor.clear.cgColor]
        gradient.cornerRadius = 10
         gradient.borderWidth = 5
        gradient.startPoint = CGPoint(x: 0.1, y: 0.78)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.78)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: bounds).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        gradient.mask = shapeLayer
        
    }

    func setBorderColor() {
        gradient.frame = bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        gradient.cornerRadius = 35
        gradient.borderWidth = 5
        gradient.startPoint = CGPoint(x: 0.1, y: 0.78)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.78)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(rect: bounds).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        gradient.mask = shapeLayer
    }
    
}

//
//  GradientButton.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

@IBDesignable
class GradientButton: UIView {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 1)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    @IBInspectable var cornerRadius: Double {
        
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
        
    }
    

    
    
    /* The color of the shadow. Defaults to opaque black. Colors created
       * from patterns are currently NOT supported. Animatable. */
       @IBInspectable var shadowColor: UIColor? {
           set {
            layer.shadowColor = newValue!.cgColor
           }
           get {
               if let color = layer.shadowColor {
                return UIColor(cgColor:color)
               }
               else {
                   return nil
               }
           }
       }

       /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
       * [0,1] range will give undefined results. Animatable. */
       @IBInspectable var shadowOpacity: Float {
           set {
               layer.shadowOpacity = newValue
           }
           get {
               return layer.shadowOpacity
           }
       }

       /* The shadow offset. Defaults to (0, -3). Animatable. */
       @IBInspectable var shadowOffset: CGPoint {
           set {
               layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
           }
           get {
               return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
           }
       }

       /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
       @IBInspectable var shadowRadius: CGFloat {
           set {
               layer.shadowRadius = newValue
           }
           get {
               return layer.shadowRadius
           }
       }

    @IBInspectable var borderWidth: Double {
        
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
        
    }
    @IBInspectable var borderColor: UIColor? {
        
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
        
    }

}

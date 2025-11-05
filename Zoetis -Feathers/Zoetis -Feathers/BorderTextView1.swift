//
//  BorderTextView1.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 11/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

@IBDesignable
class BorderTextView1: UITextView
{
    
    var red = UIColor(red: 100.0, green: 130.0, blue: 230.0, alpha: 1.0)
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = red.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = 2
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = 2.0
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
}

}

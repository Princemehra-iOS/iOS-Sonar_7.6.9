//
//  customText.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 11/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class customText :UITextView
{
    
    
    @IBInspectable var cornerRadius: Double {
        
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
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


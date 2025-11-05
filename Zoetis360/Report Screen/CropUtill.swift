//
//  CropUtill.swift
//  Zoetis -Feathers
//
//  Created by "" on 02/01/17.
//  Copyright © 2017 "". All rights reserved.

import UIKit

class AllValidSessions: NSObject {
    
    class var sharedInstance: AllValidSessions {
        struct Static {
            static let instance: AllValidSessions = AllValidSessions()
        }
        return Static.instance
    }
    
    var allValidSession = NSMutableArray()
    var meanValues = NSMutableArray()
    var complexName = NSString()
    var complexDate = NSString()
    var isHistory = Bool()
    var isDirect = Bool()
}

func observationNameCrop(values:[String]) -> NSArray {
    let observationsNames = NSMutableArray()
    for Nme in values{
        var frNme1 = Nme as NSString
        frNme1 = frNme1.length > 21 ? NSString(format:"\(frNme1.substring(to: 21))... " as NSString) : "\(frNme1)    " as NSString
        observationsNames.add(frNme1)
    }
    return observationsNames
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start...end])
    }
}
extension NSString{
    func crop()->NSString{
        
        var frNme1 = self
        if  frNme1.length > 21 {
            var index : Int = -1
            var loc = Int()
            let newTemp :String = frNme1 as String
            for c in 0...frNme1.length - 1 {
                index = index + 1
                if  newTemp[c] == "("
                {
                    loc = index
                }
            }
            let temp = frNme1.substring(from: loc) as NSString
            frNme1 = frNme1.substring(to: 15) as NSString
            frNme1 = NSString(format : "%@...%@",frNme1,temp)
        }
        else{
            let spaces = String(repeating: " ", count: 21 - frNme1.length)
            frNme1 = frNme1.appending(spaces) as NSString
        }
        return frNme1
    }
}
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return (Calendar.current as NSCalendar).date(byAdding: components, to: startOfDay, options: NSCalendar.Options())
    }
}
extension UIImage{
    
    func cropToBounds(_ image: UIImage, width: Double, height: Double , ismove : Bool) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let posX: CGFloat = 0
        let posY: CGFloat = ismove ? 116 : 63
        let cgwidth: CGFloat = CGFloat(width)
        let cgheight: CGFloat = CGFloat(ismove ? height : height + 63)
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}

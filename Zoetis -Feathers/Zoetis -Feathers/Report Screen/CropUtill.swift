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
func observationNameCrop(values: [String]) -> NSArray {
    let observationsNames = NSMutableArray()
    for Nme in values {
        var frNme1 = Nme as NSString
        frNme1 = frNme1.length > 21 ? NSString(format: "\(frNme1.substring(to: 21))... " as NSString) : "\(frNme1)    " as NSString
        observationsNames.add(frNme1)
    }
    return observationsNames
}

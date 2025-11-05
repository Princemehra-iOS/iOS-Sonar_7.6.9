//
//  BirdTypeFeatherpulpModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 21/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON

class BirdTypeFeatherpulpModel{
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var birdTypeArray: [BirdType]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        birdTypeArray = json["ResponseData"].arrayValue.map { BirdType($0) }
    }
    
    func getAllBirdTypes(array: [BirdType]) -> [BirdType] {
        var specimenTypeArray : [BirdType] = []
        for obj in array {
            specimenTypeArray.append(obj)
        }
        return specimenTypeArray
    }
}

public class BirdType {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        MicrobialFeatherPulpBirdType.saveBirdTypeValuesInDB(id: id as! NSNumber, birdText: text!)
    }
}

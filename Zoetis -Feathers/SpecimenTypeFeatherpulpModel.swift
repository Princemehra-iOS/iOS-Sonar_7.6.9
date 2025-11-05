//
//  SpecimenTypeFeatherpulpModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 20/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON

class SpecimenTypeFeatherpulpModel {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var specimenTypeArrayIs: [SpecimenType]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        specimenTypeArrayIs = json["ResponseData"].arrayValue.map { SpecimenType($0) }
    }
    
    func getAllSpecimenTypes(array: [SpecimenType]) -> [SpecimenType] {
        var specimenTypeArray : [SpecimenType] = []
        for obj in array {
            specimenTypeArray.append(obj)
        }
        return specimenTypeArray
    }
}



public class SpecimenType {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        MicrobialFeatherPulpSpecimenType.saveSpecimenTypeValuesInDB(id: id as! NSNumber, specimenText: text!)
    }
}

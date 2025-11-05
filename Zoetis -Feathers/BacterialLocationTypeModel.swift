//
//  EnvironmentalLocationTypeModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 17/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class BacterialLocationTypeModel {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var locationTypeArray: [BacterialLocationType]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        locationTypeArray = json["ResponseData"].arrayValue.map { BacterialLocationType($0) }
    }
    
    func getAllLocationTypes(customerArray: [BacterialLocationType]) -> [String] {
        var bacterialLocationTypeArray : [String] = []
        for obj in customerArray {
            bacterialLocationTypeArray.append(obj.text ?? "")
        }
        return bacterialLocationTypeArray
    }
}


class BacterialLocationType {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        Microbial_BacterialLocationTypes.saveLocationTypesInDB(NSNumber(value: id!), locationName: text!)
    }
}

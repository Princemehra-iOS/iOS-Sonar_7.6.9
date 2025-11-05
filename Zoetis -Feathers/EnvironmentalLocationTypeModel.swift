//
//  EnvironmentalLocationTypeModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 17/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

class EnvironmentalLocationTypeModel {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var locationTypeArray: [LocationType]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        locationTypeArray = json["ResponseData"].arrayValue.map { LocationType($0) }
    }
    
    func getAllLocationTypes(customerArray: [LocationType]) -> [String] {
        var allLocationTypeArray : [String] = []
        for obj in customerArray {
            allLocationTypeArray.append(obj.text ?? "")
        }
        return allLocationTypeArray
    }
}


class LocationType {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        Microbial_EnvironmentalLocationTypes.saveLocationTypesInDB(NSNumber(value: id!), locationName: text!)
    }
}

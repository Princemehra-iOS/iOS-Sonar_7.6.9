//
//  MicrobialAllConductTypes.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 20/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicroabialAllConnductTypesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [MicroabialAllConductTypes]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { MicroabialAllConductTypes($0) }
    }
    
    func getAllConductType(customerArray:[MicroabialAllConductTypes]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.text ?? "")
        }
        return customerNameArray
    }
    
}

public struct MicroabialAllConductTypes {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        CoreDataHandlerMicro().saveAllConductTypeDetailsInDB(NSNumber(value: id!), text: text!)
    }
    
}

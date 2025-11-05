//
//  SamplingMethodTypeResponse.swift
//  Zoetis -Feathers
//
//  Created by kuldeep Singh on 24/08/22.
//

import Foundation


import SwiftyJSON

class SamplingMethodTypeResponse {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var samplingMethodTypeValueArray: [SamplingMethodTypeValue]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        
        samplingMethodTypeValueArray = json["ResponseData"].arrayValue.map { SamplingMethodTypeValue($0) }
    }
    
    func getAllSamplingMethodTypes(samplingArray:[SamplingMethodTypeValue]) -> [String] {
        var customerNameArray : [String] = []
        for obj in samplingArray {
            customerNameArray.append(obj.text ?? "")
        }
        return customerNameArray
    }
}

public struct SamplingMethodTypeValue {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
         CoreDataHandlerMicro().saveAllsamplingMethodTypeDetailsInDB(NSNumber(value: id ?? 0), text: text ?? "")
    }
    
}

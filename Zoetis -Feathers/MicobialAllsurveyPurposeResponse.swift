//
//  MicobialAllsurveyPurposeResponse.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 23/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicobialAllsurveyPurposeResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [MicobialAllsurveyPurposeStruct]?
    
    
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { MicobialAllsurveyPurposeStruct($0) }
    }
    
    func getAllSurveyPurpose(customerArray:[MicobialAllsurveyPurposeStruct]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.text ?? "")
        }
        return customerNameArray
    }
    
}

public struct MicobialAllsurveyPurposeStruct {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
         CoreDataHandlerMicro().saveAllSurveyPurposeDetailsInDB(NSNumber(value: id ?? 0), text: text ?? "")
    }
    
}

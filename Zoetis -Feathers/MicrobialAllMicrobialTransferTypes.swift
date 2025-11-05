//
//  MicrobialAllMicrobialTransferTypes.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 23/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON
struct MicrobialAllMicrobialTransferTypesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [MicrobialAllMicrobialTransferTypesStruct]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { MicrobialAllMicrobialTransferTypesStruct($0) }
    }
    
    func getAllTransferTypeMicrobial(customerArray:[MicrobialAllMicrobialTransferTypesStruct]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.text ?? "")
        }
        return customerNameArray
    }
    
}

public struct MicrobialAllMicrobialTransferTypesStruct {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        CoreDataHandlerMicro().saveAllMicrobialTransferTypesDetailsInDB(NSNumber(value: id!), text: text!)
    }
    
}

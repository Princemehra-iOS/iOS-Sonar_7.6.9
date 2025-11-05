//
//  MicrobialAllVisitTypeResponse.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

//
//  MicrobialAllVisitType.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 17/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicrobialAllVisitTypeResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [MicrobialAllVisitTypeStruct]?
    
    
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { MicrobialAllVisitTypeStruct($0) }
    }
    
   func getAllVisitType(customerArray:[MicrobialAllVisitTypeStruct]) -> [String] {
           var customerNameArray : [String] = []
           for obj in customerArray {
               customerNameArray.append(obj.text ?? "")
           }
           return customerNameArray
       }
    
}

public struct MicrobialAllVisitTypeStruct {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
    
        
        // CoreDataHandlerMicro().saveAllMicrobialVisitTypesDetailsInDB(NSNumber(value: id!), text: text!)
        
        CoreDataHandlerMicro().saveAllMicrobialVisitTypesDetailsInDB(NSNumber(value: id!), text: text!)
    }
    
}


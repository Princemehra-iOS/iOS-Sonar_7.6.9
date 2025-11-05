//
//   PVESerotypeDetails.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVESerotypeDetailsResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVESerotypeDetailsRes]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVESerotypeDetailsRes($0) }
        
    }
    
    func getVaccineManDetails(dataArray:[PVESerotypeDetailsRes]) -> [String] {
        var typeArr : [String] = []
        for obj in dataArray {
            typeArr.append(obj.type ?? "")
        }
        return typeArr
    }
    
}

public struct PVESerotypeDetailsRes {
    
    let id: NSNumber?
    let type: String?
    let vaccineId : NSNumber?
    
    
    init(_ json: JSON) {
        id = json["Id"].numberValue
        type = json["Name"].stringValue
        vaccineId = json["Vaccine_Id"].numberValue
        
        CoreDataHandlerPVE().saveSerotypeDetailsInDB(json: self)
        
    }
    
}

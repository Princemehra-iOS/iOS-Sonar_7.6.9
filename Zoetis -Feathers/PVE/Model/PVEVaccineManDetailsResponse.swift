//
//  PVEVaccineManDetails.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEVaccineManDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVEVaccineManDetailsRes]?

    init(_ json: JSON) {
//        success = json["IsSuccess"].boolValue
//        statusCode = json["StatusCode"].intValue
//        message = json["DisplayMessage"].stringValue
//        complexArray = json["ResponseData"].arrayValue.map { PVEGetComplexRes($0) }
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVEVaccineManDetailsRes($0) }

    }
    
    func getVaccineManDetails(dataArray:[PVEVaccineManDetailsRes]) -> [String] {
        var nameArr : [String] = []
        for obj in dataArray {
            nameArr.append(obj.name ?? "")
        }
        return nameArr
    }

}

public struct PVEVaccineManDetailsRes {
    
    let id: NSNumber?
    let name: String?

    init(_ json: JSON) {
        id = json["Id"].numberValue
        name = json["Name"].stringValue

        CoreDataHandlerPVE().saveVaccineManDetailsInDB(json: self)

        //CoreDataHandlerPVE().saveComplexDetailsInDB(customerId!, userId: userId!, complexId: complexId!, complexName: complexName!)

    }

}

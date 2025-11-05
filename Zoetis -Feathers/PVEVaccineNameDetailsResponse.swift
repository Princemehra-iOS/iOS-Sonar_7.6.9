//
//  PVEVaccineNameDetailsResponse.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEVaccineNameDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVEVaccineNameDetailsRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVEVaccineNameDetailsRes($0) }

    }
    
    func getVaccineManDetails(dataArray:[PVEVaccineNameDetailsRes]) -> [String] {
        var nameArr : [String] = []
        for obj in dataArray {
            nameArr.append(obj.name ?? "")
        }
        return nameArr
    }

}

public struct PVEVaccineNameDetailsRes {
    
    let id: NSNumber?
    let name: String?
    let mfg_Id: NSNumber?

    init(_ json: JSON) {
        id = json["Id"].numberValue
        name = json["Name"].stringValue
        mfg_Id = json["Mfg_Id"].numberValue

        CoreDataHandlerPVE().saveVaccineNameDetailsInDB(json: self)

    }

}

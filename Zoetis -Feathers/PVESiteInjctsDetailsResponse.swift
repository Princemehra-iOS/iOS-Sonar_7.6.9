//
//  PVESiteInjctsDetails.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVESiteInjctsDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVESiteInjctsDetailsRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVESiteInjctsDetailsRes($0) }

    }
    
    func getSiteInjctsDetails(dataArray:[PVESiteInjctsDetailsRes]) -> [String] {
        var nameArr : [String] = []
        for obj in dataArray {
            nameArr.append(obj.name ?? "")
        }
        return nameArr
    }

}

public struct PVESiteInjctsDetailsRes {
    
    let id: NSNumber?
    let name: String?

    init(_ json: JSON) {
        id = json["Id"].numberValue
        name = json["Name"].stringValue

        CoreDataHandlerPVE().saveSiteInjctsDetailsInDB(json: self)
    }

}

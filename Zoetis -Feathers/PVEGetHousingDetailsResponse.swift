//
//  PVEGetHousingDetailsResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetHousingDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let housingArr: [PVEGetHousingDetailsRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        housingArr = json["ResponseData"].arrayValue.map { PVEGetHousingDetailsRes($0) }
    }
    
    func getHousingDetailsResponse(dataArray:[PVEGetHousingDetailsRes]) -> [String] {
        var housingDetailsArray : [String] = []
        for obj in dataArray {
            housingDetailsArray.append(obj.name ?? "")
        }
        return housingDetailsArray
    }

}

public struct PVEGetHousingDetailsRes {
    
    let id: Int?
    let name: String?

    init(_ json: JSON) {
        id = json["HousingId"].intValue
        name = json["HousingName"].stringValue
        
        CoreDataHandlerPVE().saveHousingDetailsInDB(id! as NSNumber, housingName: name!)
    }

}

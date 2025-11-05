//
//  PVEGetAssignUserDetailsResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetAssignUserDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let userDetailsArr: [PVEGetAssignUserDetailsRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        userDetailsArr = json["ResponseData"].arrayValue.map { PVEGetAssignUserDetailsRes($0) }
    }
    
    func getHousingDetailsResponse(dataArray:[PVEGetAssignUserDetailsRes]) -> [String] {
        var housingDetailsArray : [String] = []
        for obj in dataArray {
            housingDetailsArray.append(obj.fullName ?? "")
        }
        return housingDetailsArray
    }

}

public struct PVEGetAssignUserDetailsRes {
    
    let id: Int?
    let fullName: String?
    let firstName: String?
    let lastName: String?

    init(_ json: JSON) {
        id = json["Id"].intValue
        fullName = json["fullName"].stringValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
    }

}

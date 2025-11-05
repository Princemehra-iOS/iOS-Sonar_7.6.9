//
//  ComplexResponsePVE.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 13/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetComplexResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let complexArray: [PVEGetComplexRes]?

    init(_ json: JSON) {

        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        complexArray = json["ResponseData"].arrayValue.map { PVEGetComplexRes($0) }

    }
    
    func getAllComplexNames(complexArray:[PVEGetComplexRes]) -> [String] {
        var complexnameArray : [String] = []
        for obj in complexArray {
            complexnameArray.append(obj.complexName ?? "")
        }
        return complexnameArray
    }

}

public struct PVEGetComplexRes {
    
    let complexId: NSNumber?
    let complexName: String?
    let customerId: NSNumber?
    let userId: NSNumber?

    init(_ json: JSON) {
        complexId = json["ComplexId"].numberValue
        complexName = json["ComplexName"].stringValue
        customerId = json["CustomerId"].numberValue
        userId = json["UserId"].numberValue

        CoreDataHandlerPVE().saveComplexDetailsInDB(customerId!, userId: userId!, complexId: complexId!, complexName: complexName!)

    }

}

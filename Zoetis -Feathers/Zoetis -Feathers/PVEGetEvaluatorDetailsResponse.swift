//
//  PVEGetEvaluatorDetailsResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 24/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetEvaluatorDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluatorArr: [PVEGetEvaluatorDetailsRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        evaluatorArr = json["ResponseData"].arrayValue.map { PVEGetEvaluatorDetailsRes($0) }
    }
    
    func getEvaluatorDetails(dataArray:[PVEGetEvaluatorDetailsRes]) -> [String] {
        var evaluationForArray : [String] = []
        for obj in dataArray {
            evaluationForArray.append(obj.fullName ?? "")
        }
        return evaluationForArray
    }

}

public struct PVEGetEvaluatorDetailsRes {
    
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

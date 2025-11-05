//
//  PVEGetEvaluationForResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetEvaluationForResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluationForArr: [PVEEvaluationForRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        evaluationForArr = json["ResponseData"].arrayValue.map { PVEEvaluationForRes($0) }
    }
    
    func getEvaluationFor(dataArray:[PVEEvaluationForRes]) -> [String] {
        var evaluationForArray : [String] = []
        for obj in dataArray {
            evaluationForArray.append(obj.evaluationName ?? "")
        }
        return evaluationForArray
    }

}

public struct PVEEvaluationForRes {
    
    let evaluationId: Int?
    let evaluationName: String?
    let isDeleted: Int?

    init(_ json: JSON) {
        evaluationId = json["Id"].intValue
        evaluationName = json["Name"].stringValue
        isDeleted = json["IsDeleted"].intValue
    }

}

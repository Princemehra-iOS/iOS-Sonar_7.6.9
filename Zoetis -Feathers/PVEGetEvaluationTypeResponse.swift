//
//  GetEvaluationTypeResponsePVE.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 19/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetEvaluationTypeResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluationTypeArr: [PVEEvaluationTypeRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        evaluationTypeArr = json["ResponseData"].arrayValue.map { PVEEvaluationTypeRes($0) }
    }
    
    func getEvaluationTypes(dataArray:[PVEEvaluationTypeRes]) -> [String] {
        var evaluationTypeArray : [String] = []
        for obj in dataArray {
            evaluationTypeArray.append(obj.evaluationName ?? "")
        }
        return evaluationTypeArray
    }

}

public struct PVEEvaluationTypeRes {
    
    let evaluationId: Int?
    let evaluationName: String?
    let module_Id: Int?
    let isDeleted: Bool?

    init(_ json: JSON) {
        evaluationId = json["EvaluationId"].intValue
        evaluationName = json["EvaluationName"].stringValue
        module_Id = json["Module_Id"].intValue
        isDeleted = json["IsDeleted"].boolValue
        CoreDataHandlerPVE().saveEvaluationTypeInDB(evaluationId! as NSNumber, evaluationName: evaluationName!, isDeletd: isDeleted!, moduleId: NSNumber(value: module_Id!))
    }

}

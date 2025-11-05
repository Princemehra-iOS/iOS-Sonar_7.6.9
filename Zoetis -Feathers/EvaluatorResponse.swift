//
//  EvaluatorResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 18/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct EvaluatorResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluatorArray: [Evaluator]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        evaluatorArray = json["Data"].arrayValue.map { Evaluator($0) }
    }
    
    func getAllEvaluatorNames(evaluatorArray:[Evaluator]) -> [String] {
        var evaluatorNameArray : [String] = []
        for obj in evaluatorArray {
            evaluatorNameArray.append(obj.evaluatorName ?? "")
        }
        return evaluatorNameArray
    }
    
}

public struct Evaluator {
    
    let id: Int?
    let evaluatorName: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        evaluatorName = json["EvaluatorName"].stringValue
        var evaluatorNameIs = evaluatorName ?? ""
        var idN = id ?? 0
        CoreDataHandlerPE().saveEvaluatorInDB(NSNumber(value: idN), evaluatorName: evaluatorNameIs)
    }
    
}

public struct ApproverResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let approverArray: [Approver]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        approverArray = json["Data"].arrayValue.map { Approver($0) }
    }
    
    func getAllApproverrNames(approverArray:[Approver]) -> [String] {
        var evaluatorNameArray : [String] = []
        for obj in approverArray {
            evaluatorNameArray.append(obj.userName ?? "")
        }
        return evaluatorNameArray
    }
    
}

public struct Approver {
    
    let id: Int?
    let userName: String?
    
    init(_ json: JSON) {
        id = json["ApproverId"].intValue
        userName = json["UserName"].stringValue
        var evaluatorNameIs = userName ?? ""
        var idN = id ?? 0
        CoreDataHandlerPE().saveApproverInDB(NSNumber(value: idN), username: evaluatorNameIs)
    }
    
}


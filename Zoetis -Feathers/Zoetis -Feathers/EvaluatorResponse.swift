//
//  EvaluatorResponse.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 18/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
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
    }

}

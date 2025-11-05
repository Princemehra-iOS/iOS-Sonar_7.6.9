//
//  EvaluationTypeResponse.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 18/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//


import Foundation
import SwiftyJSON

public struct EvaluationTypeResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let evaluationTypeArray: [EvaluationType]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        evaluationTypeArray = json["Data"].arrayValue.map { EvaluationType($0) }
    }
    
    func getAllEvaluationTypeNames(evaluationTypeArray:[EvaluationType]) -> [String] {
         var evaluationTypeNameArray : [String] = []
         for obj in evaluationTypeArray {
             evaluationTypeNameArray.append(obj.evaluationName ?? "")
         }
         return evaluationTypeNameArray
     }

}

public struct EvaluationType {

    let id: Int?
    let evaluationName: String?
    let hatModuleId: Int?

    init(_ json: JSON) {
        id = json["Id"].intValue
        evaluationName = json["EvaluationName"].stringValue
        hatModuleId = json["HatModuleId"].intValue
    }

}

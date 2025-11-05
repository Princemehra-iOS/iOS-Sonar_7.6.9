//
//  PVEAssessmentCategoriesDetailsResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 23/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEAssessmentCategoriesDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let categoriesDetailsArr: [PVEAssessmentCategoriesDetailsRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        categoriesDetailsArr = json["ResponseData"].arrayValue.map { PVEAssessmentCategoriesDetailsRes($0) }
    }
    
    func getCategoriesDetailsResponse(dataArray:[PVEAssessmentCategoriesDetailsRes]) -> [String] {
        var categoriesDetailsArray : [String] = []
        for obj in dataArray {
            categoriesDetailsArray.append(obj.category_Name ?? "")
        }
        return categoriesDetailsArray
    }

}

public struct PVEAssessmentCategoriesDetailsRes {
    
    let id: Int?
    let hatchery_Module_Id: Int?
    let category_Name: String?
    let evaluation_Type_Id: Int?
    let max_Mark: Int?
    let seq_Number: Int?
    let assessmentQuestion: [[String : AnyObject]]

    init(_ json: JSON) {
        id = json["Id"].intValue
        hatchery_Module_Id = json["Hatchery_Module_Id"].intValue
        category_Name = json["Category_Name"].stringValue
        evaluation_Type_Id = json["Evaluation_Type_Id"].intValue
        max_Mark = json["Max_Mark"].intValue
        seq_Number = json["Seq_Number"].intValue
        assessmentQuestion = json["AssessmentQuestion"].arrayObject as! [[String : AnyObject]]
        
        CoreDataHandlerPVE().saveAssessmentCategoriesDetailsInDB(self)
        
        for (_, currentObj) in assessmentQuestion.enumerated() {
            let obj = currentObj as [String  :Any]
            CoreDataHandlerPVE().saveAssessmentQuestionInDB(obj, json: self)
        }

    }

}

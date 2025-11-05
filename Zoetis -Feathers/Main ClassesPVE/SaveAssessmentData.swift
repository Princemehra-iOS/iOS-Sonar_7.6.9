//
//  SaveAssessmentData.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 09/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON

class SaveAssessmentData: NSObject {
    
    let sharedManager = PVEShared.sharedInstance

    static let sharedInstanceAssessData = SaveAssessmentData()
    
    func assessmentData(json:PVEAssessmentCategoriesDetailsRes){
        
        var dict = [String : Any]()
        dict["Id"] = json.id ?? 0
        dict["Hatchery_Module_Id"] = json.hatchery_Module_Id ?? 0
        dict["Category_Name"] = json.category_Name ?? 0
        dict["Evaluation_Type_Id"] = json.evaluation_Type_Id ?? 0
        dict["Max_Mark"] = json.max_Mark ?? 0
        
        let assessmentQuestionResArr = json.assessmentQuestion
        var newAssessmentQuestionResArr = [[String : Any]]()
        
        for (_, currentObj) in assessmentQuestionResArr.enumerated() {
            var questionDict = [String : Any]()
            
            questionDict["id"] = currentObj["id"]
            questionDict["Assessment"] =  currentObj["Assessment"]
            questionDict["Assessment2"] =  currentObj["Assessment2"]
            questionDict["Min_Score"] = currentObj["Min_Score"]
            questionDict["Mid_Score"] = ["Mid_Score"]
            questionDict["Max_Score"] =  currentObj["Max_Score"]
            questionDict["Types"] = currentObj["Types"]
            questionDict["PVE_Vacc_Type"] = currentObj["PVE_Vacc_Type"]
            questionDict["Module_Cat_Id"] = currentObj["Module_Cat_Id"]
            questionDict["IsSelected"] =  false
            newAssessmentQuestionResArr.append(questionDict)
        }
        
        dict.merge(dict: ["AssessmentQuestion" : newAssessmentQuestionResArr ])
        sharedManager.assessmentQuestionDataArr.append(dict as [String : Any])
    }

}

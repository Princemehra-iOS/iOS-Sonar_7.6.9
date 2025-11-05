//
//  PECategoriesAssesments.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 31/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PECategoriesAssesmentsResponse {

    var Success: Bool?
    var StatusCode: Int?
    var Message: String?
    var peCategoryArray: [PECategory]
    var peNewAssessment: PENewAssessment?
   
    init(_ json: JSON?) {
        Success = json?["Success"].boolValue
        StatusCode = json?["StatusCode"].intValue
        Message = json?["Message"].stringValue
        peCategoryArray = json?["Data"].arrayValue.map { PECategory($0) } ?? []
    }
    
    
    func getCategoriesNamesArray(dataArray:[PECategory]) -> [String] {
           var categoriesDetailsArray : [String] = []
           for obj in dataArray {
               categoriesDetailsArray.append(obj.categoryName ?? "")
           }
           return categoriesDetailsArray
    }
}



public class InfoImageDataResponse {
    public var success : Bool?
    public var statusCode : Int?
    public var message : String?
    public var infoImageDataArray: [InfoImageData]

    
    init(_ json: JSON?) {
        success = json?["Success"].boolValue
        statusCode = json?["StatusCode"].intValue
        message = json?["Message"].stringValue
        infoImageDataArray = json?["Data"].arrayValue.map { InfoImageData($0) } ?? []
    }
    
    func getInfoTextByQuestionId(questionID:Int) -> String
    {
        var text = ""
        let bullet = "•  "
        
        var strings = [String]()
        
        for obj in infoImageDataArray {
            if obj.assessmentQuestionId == questionID {
                strings.append(obj.information ?? "")
            }
        }
        strings = strings.map { return bullet + $0 }
              
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.preferredFont(forTextStyle: .body)
        attributes[.foregroundColor] = UIColor.darkGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = (bullet as NSString).size(withAttributes: attributes).width
        attributes[.paragraphStyle] = paragraphStyle
        
        let string = strings.joined(separator: "\n")
        text =  strings.joined(separator: "\n")
        return text
    }
    

}


public class InfoImageData {
    public var id : Int?
    public var assessmentQuestionId : Int?
    public var information : String?
    public var createdAt : String?
    public var userId : String?

    

      init(_ json: JSON?) {
          id = json?["Id"].intValue
          assessmentQuestionId = json?["AssessmentQuestionId"].intValue
          information = json?["Information"].stringValue
          createdAt = json?["createdAt"].stringValue
          userId = json?["UserId"].stringValue
         
      }

}



extension PECategoriesAssesmentsResponse {
    func toJSON() -> Dictionary<String, Any> {
        return [
            "Success": self.Success,
            "StatusCode": self.StatusCode,
            "Message": self.Message,
            "peCategoryArray": self.peCategoryArray.map({ $0.toJSON() })

        ]
    }
}

extension PECategory {
    func toJSON() -> Dictionary<String, Any> {
        return [
            "id": self.id,
            "categoryName": self.categoryName,
            "maxMark": self.maxMark,
            "resultMark": self.resultMark,
            "assessmentQuestions": self.assessmentQuestions.map({ $0.toJSON() })
        ]
    }
}


extension AssessmentQuestions {
    func toJSON() -> Dictionary<String, Any> {
        return [
            "id": self.id,
            "assessment": self.assessment,
            "assessment2": self.assessment2,
            "minScore": self.minScore,
            "maxScore": self.maxScore,
            "cateType": self.cateType,
            "moduleCatId": self.moduleCatId,
            "moduleCatName": self.moduleCatName,
            "status": self.status
        ]
    }
}







public struct PECategory {

    var id: Int?
    var categoryName: String?
    var maxMark: Int?
    var resultMark: Int?
    var sequenceNo: Int?
    var assessmentQuestions: [AssessmentQuestions]
    var evaluationID: Int?
    var isSelected : Bool = false

    init(_ json: JSON?) {
        id = json?["Id"].intValue
        evaluationID = json?["EvaluationId"].intValue
        categoryName = json?["CategoryName"].stringValue
        maxMark = json?["MaxMark"].intValue
        sequenceNo = json?["SequenceNo"].intValue
        resultMark = 0
        assessmentQuestions = json?["AssessmentQuestions"].arrayValue.map { AssessmentQuestions($0) } ?? []
    }
    
  

}

public struct AssessmentQuestions {

    var id: Int?
    var assessment: String?
    var assessment2: String?
    var minScore: Int?
    var maxScore: Int?
    var cateType: String?
    var moduleCatId: Int?
    var moduleCatName: String?
    var informationText:String?
    var informationImage:String?
    var status: Bool = false
    var isAllowNA:Bool = false
    var rollOut: String?
    var isNA:Bool = false
    var qSeqNo:Int?
  

    init(_ json: JSON?) {
        id = json?["Id"].intValue
        isAllowNA =  json?["IsAllowNA"].boolValue ?? false
        isNA =  json?["IsNA"].boolValue ?? false
        qSeqNo = json?["QSeqNo"].intValue
        rollOut = json?["RollOut"].stringValue
        assessment = json?["Assessment"].stringValue
        assessment2 = json?["Assessment2"].stringValue
        minScore = json?["MinScore"].intValue
        maxScore = json?["MaxScore"].intValue
        cateType = json?["CateType"].stringValue
        moduleCatId = json?["ModuleCatId"].intValue
        moduleCatName = json?["ModuleCatName"].stringValue
        informationText = json?["InformationText"].stringValue
        var urlImage = json?["InformationImage"].stringValue
        informationImage = json?["InformationImage"].stringValue
        
    }

}

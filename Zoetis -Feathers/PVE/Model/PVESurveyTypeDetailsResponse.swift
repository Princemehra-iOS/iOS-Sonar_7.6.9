//
//  PVESurveyTypeDetails.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVESurveyTypeDetailsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVESurveyTypeDetailsRes]?

    init(_ json: JSON) {
//        success = json["IsSuccess"].boolValue
//        statusCode = json["StatusCode"].intValue
//        message = json["DisplayMessage"].stringValue
//        complexArray = json["ResponseData"].arrayValue.map { PVEGetComplexRes($0) }
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVESurveyTypeDetailsRes($0) }

    }
    
    func getVaccineManDetails(dataArray:[PVESurveyTypeDetailsRes]) -> [String] {
        var nameArr : [String] = []
        for obj in dataArray {
            nameArr.append(obj.surveyName ?? "")
        }
        return nameArr
    }

}

public struct PVESurveyTypeDetailsRes {
    
    let id: NSNumber?
    let surveyName: String?
    let surveyType: String?

    init(_ json: JSON) {
        id = json["Id"].numberValue
        surveyName = json["SurveyName"].stringValue
        surveyType = json["SurveyType"].stringValue

        CoreDataHandlerPVE().saveSurveyTypeDetailsInDB(json: self)

        //CoreDataHandlerPVE().saveComplexDetailsInDB(customerId!, userId: userId!, complexId: complexId!, complexName: complexName!)

    }

}

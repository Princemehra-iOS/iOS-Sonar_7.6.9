
//
//  MicrobialFeatherpulpTestModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 21/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON

class MicrobialCaseStatusModel {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var testTypeArray: [CaseStatus]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        testTypeArray = json["ResponseData"].arrayValue.map { CaseStatus($0) }
    }
}


public class CaseStatus{
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        MicrobialCaseStatus.saveCaseStatus(id: id as! NSNumber, text: text!)
    }
}

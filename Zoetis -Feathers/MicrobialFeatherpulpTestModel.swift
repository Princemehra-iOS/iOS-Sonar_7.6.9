
//
//  MicrobialFeatherpulpTestModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 21/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON

class MicrobialFeatherpulpTestModel {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var testTypeArray: [FeatherPulpTest]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        testTypeArray = json["ResponseData"].arrayValue.map { FeatherPulpTest($0) }
    }
}


public class FeatherPulpTest{
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
        MicrobialFeatherPulpTestOptions.saveTestOptionValuesInDB(id: id as! NSNumber, text: text!)
    }
}

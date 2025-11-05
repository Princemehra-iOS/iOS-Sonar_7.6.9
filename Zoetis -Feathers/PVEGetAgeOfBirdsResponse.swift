//
//  PVEGetEvaluatorResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetAgeOfBirdsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let ageOfBirdsArr: [PVEAgeOfBirdsRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        ageOfBirdsArr = json["ResponseData"].arrayValue.map { PVEAgeOfBirdsRes($0) }
    }
    
    func getAgeOfBirdsResponse(dataArray:[PVEAgeOfBirdsRes]) -> [String] {
        var ageOfBirdsArray : [String] = []
        for obj in dataArray {
            ageOfBirdsArray.append(obj.age ?? "")
        }
        return ageOfBirdsArray
    }

}

public struct PVEAgeOfBirdsRes {
    
    let id: Int?
    let age: String?
    let birdId: Int?

    init(_ json: JSON) {
        id = json["Id"].intValue
        age = json["Age"].stringValue
        birdId = json["Bird_Id"].intValue
        
        CoreDataHandlerPVE().saveAgeOfBirdsDetailsInDB(NSNumber(value: id!), birdId: NSNumber(value: birdId!), age: age!)

    }

}

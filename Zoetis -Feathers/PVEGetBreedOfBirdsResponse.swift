//
//  PVEGetBreedOfBirdsResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetBreedOfBirdsResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let breedOfBirdsArr: [PVEBreedOfBirdsRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        breedOfBirdsArr = json["ResponseData"].arrayValue.map { PVEBreedOfBirdsRes($0) }
    }
    
    func getBreedOfBirdsResponse(dataArray:[PVEBreedOfBirdsRes]) -> [String] {
        var ageOfBirdsArray : [String] = []
        for obj in dataArray {
            ageOfBirdsArray.append(obj.name ?? "")
        }
        return ageOfBirdsArray
    }

}

public struct PVEBreedOfBirdsRes {
    
    let id: Int?
    let name: String?
    let evaluationId: Int?
    let type: Int?

    init(_ json: JSON) {
        id = json["Id"].intValue
        name = json["Name"].stringValue
        evaluationId = json["EvaluationId"].intValue
        type = json["type"].intValue

        CoreDataHandlerPVE().saveBreedOfBirdsDetailsInDB(NSNumber(value: id!), name: name!, evaluationId: NSNumber(value: evaluationId!), type: NSNumber(value: type!))
    }

}

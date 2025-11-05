//
//  VisitTypesResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 18/12/19.
//  Copyright © 2019 . All rights reserved.
//


import Foundation
import SwiftyJSON

public struct VisitTypesResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let visitTypeArray: [VisitType]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        visitTypeArray = json["Data"].arrayValue.map { VisitType($0) }
    }
    
    func getAllVisitTypesNames(visitTypeArray:[VisitType]) -> [String] {
        var visitTypeNameArray : [String] = []
        for obj in visitTypeArray {
            visitTypeNameArray.append(obj.visitName ?? "")
        }
        return visitTypeNameArray
    }
}

public struct VisitType {
    
    let id: Int?
    let visitName: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        visitName = json["VisitName"].stringValue
        
        var visitNameIs = visitName ?? ""
        var idN = id ?? 0
        CoreDataHandlerPE().saveVisitTypeInDB(NSNumber(value: idN), visitName: visitNameIs)
        
    }
    
}

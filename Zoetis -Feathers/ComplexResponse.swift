//
//  ComplexResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 12/12/19.
//  Copyright © 2019 . All rights reserved.
//
import Foundation
import SwiftyJSON

public struct ComplexResponse {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let complexArray: [Complex]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        complexArray = json["Data"].arrayValue.map { Complex($0) }
    }
    
    func getAllComplexNames(complexArray:[Complex]) -> [String] {
        var complexnameArray : [String] = []
        for obj in complexArray {
            complexnameArray.append(obj.complexName ?? "")
        }
        return complexnameArray
    }
}

public struct Complex {
    
    let complexId: Int?
    let complexName: String?
    let customerId: Int?
    let userId: Int?
    
    init(_ json: JSON?) {
        complexId = json?["ComplexId"].intValue ?? 0
        complexName = json?["ComplexName"].stringValue
        customerId = json?["CustomerId"].intValue
        userId = json?["UserId"].intValue
        CoreDataHandlerPE().saveComplexInDB(customerId! as NSNumber, userId: NSNumber(value: userId!), complexId: NSNumber(value: complexId!), complexName: complexName!)
        
    }
    
}

//
//  CompanyResponse.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 12/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CompanyResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let companyArray: [Company]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        companyArray = json["Data"].arrayValue.map { Company($0) }
    }
    
    func getAllCompanyNames(companyArray:[Company]) -> [String] {
         var companyNameArray : [String] = []
         for obj in companyArray {
             companyNameArray.append(obj.customerName ?? "")
         }
         return companyNameArray
     }

}

public struct Company {

    let customerId: Int?
    let customerName: String?

    init(_ json: JSON) {
        customerId = json["CustomerId"].intValue
        customerName = json["CustomerName"].stringValue
    }

}

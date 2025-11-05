//
//  CustomerPVEResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 13/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//


import Foundation
import SwiftyJSON

struct CustomerPVEResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [CustomerPVE]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { CustomerPVE($0) }
    }
    
    func getAllCustomerNames(customerArray:[CustomerPVE]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.customerName ?? "")
        }
        return customerNameArray
    }

}

public struct CustomerPVE {
    
    let customerId: Int?
    let customerName: String?

    init(_ json: JSON) {
        customerId = json["CustomerId"].intValue
        customerName = json["CustomerName"].stringValue
        
        CoreDataHandlerPVE().saveCustomerDetailsInDB(NSNumber(value: customerId!), CustName: customerName!)

    }

}

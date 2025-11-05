//
//  CustomerResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 17/12/19.
//  Copyright © 2019 . All rights reserved.
//


import Foundation
import SwiftyJSON

public struct CustomerResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [Customer]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        customerArray = json["Data"].arrayValue.map { Customer($0) }
    }
    
    func getAllCustomerNames(customerArray:[Customer]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.customerName ?? "")
        }
        return customerNameArray
    }
    
}

public struct Customer {
    
    let customerId: Int?
    let customerName: String?
    
    init(_ json: JSON) {
        customerId = json["CustomerId"].intValue
        customerName = json["CustomerName"].stringValue
        CoreDataHandlerPE().saveCustomerInSessionWithCustomerNameAndId(NSNumber(value: customerId ?? 0), CustName: customerName ?? "")
    }
    
    init(_ customerManagedObject: PE_Customer) {
        customerId = customerManagedObject.customerID as? Int
        customerName = customerManagedObject.customerName
    }
}

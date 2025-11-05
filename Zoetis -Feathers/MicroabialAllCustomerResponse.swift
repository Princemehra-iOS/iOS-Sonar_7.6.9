//
//  MicroabialCompanyResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 19/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicroabialAllCustomerResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let customerArray: [MicroabialCustomer]?
    //let customerIDArray: [MicroabialCustomer]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        customerArray = json["ResponseData"].arrayValue.map { MicroabialCustomer($0) }
    }
    
    func getAllCustomerNames(customerArray:[MicroabialCustomer]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            
            //   print("customer  ID :\(obj.customerId!)")
            
            
            customerNameArray.append(obj.customerName ?? "")
        }
        return customerNameArray
    }

}

public struct MicroabialCustomer {
    
    let customerId: Int?
    let customerName: String?

    init(_ json: JSON) {
        customerId = json["Id"].intValue
        customerName = json["Text"].stringValue
        
        CoreDataHandlerMicro().saveCustomerDetailsInDB(NSNumber(value: customerId!), custName: customerName!)
    }
    
    

}

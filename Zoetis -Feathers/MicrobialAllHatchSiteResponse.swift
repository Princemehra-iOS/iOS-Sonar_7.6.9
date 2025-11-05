//
//  MicrobialAllHatchSiteResponse.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 19/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicrobialAllHatchSiteResponse
{
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let responseArray: [MicrobialHatcherySitesByCustomer]?
    
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        responseArray = json["ResponseData"].arrayValue.map { MicrobialHatcherySitesByCustomer($0) }
    }
    
    func getAllHatchSiteNames(customerArray:[MicrobialHatcherySitesByCustomer]) -> [String] {
        var customerNameArray : [String] = []
         var customerIdArray : [Int] = []
        for obj in customerArray {
            customerNameArray.append(obj.siteName ?? "")
            customerIdArray.append(obj.siteId ?? 0)
        }
        return customerNameArray
    }
    
    func getAllHatchSiteId(customerArray:[MicrobialHatcherySitesByCustomer]) -> [Int] {
         //  var customerNameArray : [String] = []
            var customerIdArray : [Int] = []
           for obj in customerArray {
             //  customerNameArray.append(obj.siteName ?? "")
               customerIdArray.append(obj.siteId ?? 0)
           }
           return customerIdArray
       }
    
}

public struct MicrobialHatcherySitesByCustomer {
    
      let id: Int?
      let siteName: String?
      let siteId: Int?
      let complexId: Int?
      let customerId: Int?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        siteId = json["Site_Id"].intValue
        siteName = json["Site_Name"].stringValue
        complexId = json["Complex_Id"].intValue
        customerId  = json["Customer_Id"].intValue
        
      CoreDataHandlerMicro().saveAllMicrobialHatcherySiteDetailsInDB(NSNumber(value: id!), siteId: NSNumber(value: siteId!) , SiteName: siteName ?? "",ComplexId:complexId ?? 0,customerId:customerId!)
    }
    
}

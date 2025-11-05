//
//  PVEGetSiteIdNameResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetSiteIdNameResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let siteIdNameArr: [PVESiteIdNameRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        siteIdNameArr = json["ResponseData"].arrayValue.map { PVESiteIdNameRes($0) }
    }
    
    func getSiteIdNameResponse(dataArray:[PVESiteIdNameRes]) -> [String] {
        var siteIdNameArray : [String] = []
        for obj in dataArray {
            siteIdNameArray.append(obj.siteName ?? "")
        }
        return siteIdNameArray
    }

}

public struct PVESiteIdNameRes {
    
    let id: Int?
    let siteId: Int?
    let complex_Id: Int?
    let customer_Id: Int?
    let siteName: String?

    init(_ json: JSON) {
        id = json["Id"].intValue
        siteId = json["Site_Id"].intValue
        siteName = json["Site_Name"].stringValue
        complex_Id = json["Complex_Id"].intValue
        customer_Id = json["Customer_Id"].intValue

        CoreDataHandlerPVE().saveSiteIDNameDetailsInDB(id! as NSNumber, siteId: siteId! as NSNumber, siteName: siteName!, complexId: NSNumber(value: complex_Id!),  customerId: NSNumber(value: customer_Id!))
    }

}

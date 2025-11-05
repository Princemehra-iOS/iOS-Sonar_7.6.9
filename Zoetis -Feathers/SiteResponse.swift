//
//  SiteResponse.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 18/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct SiteResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let siteArray: [Site]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        siteArray = json["Data"].arrayValue.map { Site($0) }
    }
    
    func getAllSiteNames(siteArray:[Site]) -> [String] {
        var siteNameArray : [String] = []
        for obj in siteArray {
            siteNameArray.append(obj.siteName ?? "")
        }
        return siteNameArray
    }
    
}

public struct Site {
    
    let siteId: Int?
    let siteName: String?
    let customerId : Int?
    let complexId : Int?
    
    init(_ json: JSON) {
        siteId = json["SiteId"].intValue
        siteName = json["SiteName"].stringValue
        customerId =  json["CustomerId"].intValue
        complexId =  json["CustomerId"].intValue
        let siteNametext = siteName ?? ""
        let idN =  siteId ?? 0
      
        let complexIdN = complexId ?? 0
        let customerIdN = customerId ?? 0
        CoreDataHandlerPE().saveSitesInDB(NSNumber(value: idN), siteId:NSNumber(value: idN ?? 0), complexId: NSNumber(value: complexIdN), customerId: NSNumber(value: customerIdN), siteName: siteNametext)
        
    }
    
}

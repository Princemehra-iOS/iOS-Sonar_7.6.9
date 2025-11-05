//
//  SiteResponse.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 18/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
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

    init(_ json: JSON) {
        siteId = json["Id"].intValue
        siteName = json["SiteName"].stringValue
    }

}

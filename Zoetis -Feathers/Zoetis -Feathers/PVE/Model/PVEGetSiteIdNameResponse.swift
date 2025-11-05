//
//  PVEGetSiteIdNameResponse.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 20/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PVEGetSiteIdNameResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let siteIdNameArr: [PVESiteIdNameRes]?

    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
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
    let siteName: String?
    let isDeleted: Int?

    init(_ json: JSON) {
        id = json["Id"].intValue
        siteId = json["Site_Id"].intValue
        siteName = json["Site_Name"].stringValue
        isDeleted = json["IsDeleted"].intValue
    }

}

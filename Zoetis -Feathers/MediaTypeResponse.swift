//
//  MediaTypeResponse.swift
//  Zoetis -Feathers
//
//  Created by Siva Preasad Reddy on 23/02/22.
//

import Foundation
import SwiftyJSON

class MediaTypeResponse {
    let success: Bool?
    let statusCode: Int?
    let message: String?
    
    var mediaTypeValueArray: [MediaTypeValue]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        
        mediaTypeValueArray = json["ResponseData"].arrayValue.map { MediaTypeValue($0) }
    }
    
    func getAllMediaTypes(mediaArray:[MediaTypeValue]) -> [String] {
        var customerNameArray : [String] = []
        for obj in mediaArray {
            customerNameArray.append(obj.text ?? "")
        }
        return customerNameArray
    }
}

public struct MediaTypeValue {
    
    let id: Int?
    let text: String?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        text = json["Text"].stringValue
        
         CoreDataHandlerMicro().saveAllMediaTypeDetailsInDB(NSNumber(value: id ?? 0), text: text ?? "")
    }
    
}


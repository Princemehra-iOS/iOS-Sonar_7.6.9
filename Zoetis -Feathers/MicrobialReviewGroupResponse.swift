//
//  MicrobialReviewGroupResponse.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 19/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

struct MicrobialReviewGroupResponse
{
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let reviewerResponseArray: [MicrobialHatcheryAllReviewerGroups]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        reviewerResponseArray = json["ResponseData"].arrayValue.map { MicrobialHatcheryAllReviewerGroups($0) }
    }
    
    func getAllHatcheryReviewerNames(customerArray:[MicrobialHatcheryAllReviewerGroups]) -> [String] {
        var customerNameArray : [String] = []
        for obj in customerArray {
            customerNameArray.append(obj.reviewerName ?? "")
        }
        return customerNameArray
    }
    
}

public struct MicrobialHatcheryAllReviewerGroups {
    
    let reviewerId: Int?
    let reviewerName: String?
    
    init(_ json: JSON) {
        reviewerId = json["Id"].intValue
        reviewerName = json["Text"].stringValue
        
         CoreDataHandlerMicro().saveReviewerDetailsInDB(NSNumber(value: reviewerId!), ReviewerName: reviewerName!)
    }
    
}

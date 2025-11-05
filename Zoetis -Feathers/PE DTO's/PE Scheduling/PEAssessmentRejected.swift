//
//  PEAssessmentRejected.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 24/06/21.
//

import Foundation

struct PEAssessmentRejected : Codable {
    let id : Int?
    let scheduleDate : String?
    let customerId : Int?
    let customerName : String?
    let siteId : Int?
    let siteName : String?
    let evaluationId : Int?
    let evaluationName : String?
    let evaluationTypeId : Int?
    let evaluationTypeName : String?
    let statusName:String?
    let peVisitTypeName:String?
    let peVisitTypeId:Int?
    let approverId:Int?
    let approverName:String?
    let updatedDate:String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case scheduleDate = "ScheduleDate"
        case customerId = "CustomerId"
        case customerName = "CustomerName"
        case siteId = "SiteId"
        case siteName = "SiteName"
        case evaluationId = "EvaluationId"
        case evaluationName = "EvaluationName"
        case evaluationTypeId = "EvaluationTypeId"
        case evaluationTypeName = "EvaluationTypeName"
        case statusName = "StatusName"
        case peVisitTypeName = "PeVisitTypeName"
        case peVisitTypeId = "PeVisitTypeId"
        case approverId = "ApproverId"
        case approverName = "ApproverName"
        case updatedDate = "UpdatedDate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        scheduleDate = try values.decodeIfPresent(String.self, forKey: .scheduleDate)
        customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        siteId = try values.decodeIfPresent(Int.self, forKey: .siteId)
        siteName = try values.decodeIfPresent(String.self, forKey: .siteName)
        evaluationId = try values.decodeIfPresent(Int.self, forKey: .evaluationId)
        evaluationName = try values.decodeIfPresent(String.self, forKey: .evaluationName)
        evaluationTypeId = try values.decodeIfPresent(Int.self, forKey: .evaluationTypeId)
        evaluationTypeName = try values.decodeIfPresent(String.self, forKey: .evaluationTypeName)
        statusName = try values.decodeIfPresent(String.self, forKey: .statusName)
        peVisitTypeId = try values.decodeIfPresent(Int.self, forKey: .peVisitTypeId)
        peVisitTypeName = try values.decodeIfPresent(String.self, forKey: .peVisitTypeName)
        approverId = try values.decodeIfPresent(Int.self, forKey: .approverId)
        approverName = try values.decodeIfPresent(String.self, forKey: .approverName)
        updatedDate = try values.decodeIfPresent(String.self, forKey: .updatedDate)
        //updatedDate
    }

}

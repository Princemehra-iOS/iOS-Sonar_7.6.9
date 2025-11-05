//
//  EnvironmentalLocationTypeModel.swift
//  Zoetis -Feathers
//
//  Created on 17/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

struct RequisitionGetDataModel {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    var requisitionArray: [RequisitionData]?
    
    init(_ json: JSON) {
        success = json["IsSuccess"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        requisitionArray = json["ResponseData"].arrayValue.map { RequisitionData($0) }
    }

}


struct RequisitionData {
    
    var SurveyType: SurveyTypeData?
    var microbialDetailsList: [MicrobialDetailsList]?
    
    init(_ json: JSON) {
        SurveyType = SurveyTypeData(json["SurveyType"])
        microbialDetailsList = json["MicrobialDetailsList"].arrayValue.map { MicrobialDetailsList($0) }
//
//        Microbial_BacterialLocationTypes.saveLocationTypesInDB(NSNumber(value: id!), locationName: text!)
    }
}

struct MicrobialDetailsList {
    
    let id: Int?
    let requestorId: Int?
    let customerId: Int?
    let siteId: Int?
    let reviewerIds: [Int]?
    let barcode: String?
    let conductedType: Int?
    let purposeType: Int?
    let transferType: Int?
    let sampleDate: String?
    let ack: Bool?
    let isDeleted: Bool?
    let caseId: String?
    let surveyType: Int?
    let deviceId: String?
    let status: Int?
    let timeStamp: String?
    let sessionStatus: Int?
    let notes: String?
    let visitReason: Int?
    let typeOfBirdId: Int?
    let requisitionNo: String?
    let microbialSampleDetailsList: [MicrobialSampleDetailsList]?
    let microbialFeatherDetailsList: [MicrobialFeatherDetailsList]?
    
    init(_ json: JSON) {
        id = json["Id"].intValue
        requestorId = json["Requestor_Id"].intValue
        customerId = json["Customer_Id"].intValue
        siteId = json["Site_Id"].intValue
        reviewerIds = json["ReviewerIds"].arrayValue.map{ $0.intValue }
        barcode = json["Barcode"].stringValue
        conductedType = json["Conducted_Type"].intValue
        purposeType = json["Purpose_Type"].intValue
        transferType = json["Transfer_Type"].intValue
        sampleDate = json["Sample_Date"].stringValue
        ack = json["Ack"].boolValue
        isDeleted = json["IsDeleted"].boolValue
        caseId = json["CaseId"].stringValue
        surveyType = json["SurveyType"].intValue
        deviceId = json["Device_Id"].stringValue
        status = json["Status"].intValue
        timeStamp = json["RequisitionId"].stringValue
        sessionStatus = json["RequisitionType"].intValue
        notes = json["Notes"].stringValue
        visitReason = json["VisitReason"].intValue
        typeOfBirdId = json["BirdType"].intValue
        requisitionNo = json["RequisitionNo"].stringValue
        microbialSampleDetailsList = json["MicrobialSampleDetailsList"].arrayValue.map { MicrobialSampleDetailsList($0) }
        microbialFeatherDetailsList = json["MicrobialFeatherDetailsList"].arrayValue.map { MicrobialFeatherDetailsList($0) }
    }
    
}


struct MicrobialFeatherDetailsList{
    let MicrobialDetailsId: Int?
    let Farm: String?
    let AgeWeeks: Int?
    let AgeDays: Int?
    let ServiceTestsList: [Int]?
    let SamplesCount: Int?
    let SpecimenTypeId: Int?
    
    init(_ json: JSON) {
        MicrobialDetailsId = json["MicrobialDetailsId"].intValue
        Farm = json["Farm"].stringValue
        AgeWeeks = json["AgeWeeks"].intValue
        AgeDays = json["AgeDays"].intValue
        ServiceTestsList = json["ServiceTestsList"].arrayValue.map{ $0.intValue }
        SamplesCount = json["SamplesCount"].intValue
        SpecimenTypeId = json["SpecimenTypeId"].intValue
    }
}


struct MicrobialSampleDetailsList {
    let id: Int?
    let plateId: String?
    let sampleDesc: String?
    let addMicro: Bool?
    let addBact: Bool?
    let locationType: Int?
    let locType: String?
    let locationValue: Int?
    let locVal: String?
    let section: Int?
    let row: Int?
    let mediaTypeId: Int?
    let notes: String?
    let samplingMethodId : Int?
    let microbialSamplePlates: [MicrobialSamplePlates]?
    var isHeaderIsCollapsed = false

    var noOfPlates: Int?
    let microbialDetailId: Int?

    
    init(_ json: JSON) {
        id = json["Id"].intValue
        plateId = json["Plate_Id"].stringValue
        sampleDesc = json["Sample_Desc"].stringValue
        addMicro = json["Add_Test"].boolValue
        addBact = json["Add_Bact"].boolValue
        locationType = json["Location_Type"].intValue
        locType = json["LocType"].stringValue
        locationValue = json["Location_Value"].intValue
        locVal = json["LocVal"].stringValue
        section = json["ParentId"].intValue + 1  //incremented so that section can start from 1 instead of 0
        row = json["ChildId"].intValue
        mediaTypeId = json["MediaType"].intValue
        notes = json["Notes"].stringValue
        samplingMethodId = json["SamplingMethod"].intValue
        microbialSamplePlates = json["MicrobialSamplePlateDetail"].arrayValue.map({MicrobialSamplePlates($0)})
        noOfPlates = json["No_Of_Plates"].intValue
        microbialDetailId = json["Microbial_Detail_Id"].intValue


    }
}

struct MicrobialSamplePlates {
    let id: Int?
    let plateId: String?
    let sampleDesc: String?
    let addMicro: Bool?
    let addBact: Bool?
    let locationType: Int?
    let locType: String?
    let locationValue: Int?
    let locVal: String?
    let section: Int?
    let row: Int?
    let mediaTypeId: Int?
    let notes: String?
    let samplingMethodId : Int?
    let samplingText: String?
    let mediaText: String?

    
    init(_ json: JSON) {
        id = json["Id"].intValue
        plateId = json["Plate_Id"].stringValue
        sampleDesc = json["Sample_Desc"].stringValue
        addMicro = json["Add_Test"].boolValue
        addBact = json["Add_Bact"].boolValue
        locationType = json["Location_Type"].intValue
        locType = json["LocType"].stringValue
        locationValue = json["Location_Value"].intValue
        locVal = json["LocVal"].stringValue
        section = json["ParentId"].intValue + 1  //incremented so that section can start from 1 instead of 0
        row = json["ChildId"].intValue
        mediaTypeId = json["MediaType"].intValue
        notes = json["Notes"].stringValue
        samplingMethodId = json["SamplingMethod"].intValue
        mediaText = json["MediaText"].stringValue
        samplingText = json["SamplingText"].stringValue

    }
}



struct SurveyTypeData {
    let Id: Int?
    let Text: String?
    
    init(_ json: JSON) {
        Id = json["Id"].int
        Text = json["Text"].stringValue
    }
}

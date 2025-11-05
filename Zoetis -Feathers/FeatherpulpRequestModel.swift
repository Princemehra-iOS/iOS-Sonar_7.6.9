//
//  FeatherpulpRequestModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 13/05/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

struct FeatherpulpRequestModel: Codable {
//    let MicrobialFeatherDetailsList: [MicrobialFeatherpulpSampleDetailsList]?
    let BirdType: Int?
    let Requestor_Id: Int?
    let VisitReason: Int?
    let Customer_Id: Int?
    let Site_Id: Int?
    let Sample_Date: String?
    let Barcode: String?
    let Notes: String?
    let RequisitionId: String?
    let RequisitionType: Int?
    let Device_Id: String?
    let reviewerIds: [Int]?
    let RequisitionNo: String?
}


struct MicrobialFeatherpulpSampleDetailsList: Codable{
    let SpecimenTypeId: Int?
    let Farm: String?
    let AgeWeeks: Int?
    let AgeDays: Int?
    let SamplesCount: Int?
    let ServiceTestsList: [Int]?
}

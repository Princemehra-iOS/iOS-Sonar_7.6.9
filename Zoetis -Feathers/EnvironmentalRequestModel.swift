//
//  EnvironmentalRequestModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 30/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

struct EnvironmentalRequestModel: Codable {
//    let MicrobialBacterialSampleDetailsList: [MicrobialBacterialSampleDetailsList]?
    let Requestor_Id: Int?
    let Customer_Id: Int?
    let Site_Id: Int?
    let ReviewerIds: [Int]?
    let Barcode: String?
    let Conducted_Type: Int?
    let Purpose_Type: Int?
    let Transfer_Type: Int?
    let Sample_Date: String?
    let Ack: Bool?
    let Device_Id: String?
    let RequisitionId: String?
    let RequisitionType: Int?
    let Notes: String?
    let VisitReason: Int?
    let RequisitionNo: String?
}



struct MicrobialBacterialSampleDetailsList: Codable{
    let Plate_Id: String?
    let Location_Type: Int?
    let Location_Value: Int?
    let Sample_Desc: String?
    let Add_Test: Bool?
    let Add_Bact: Bool?
    let ParentId: Int?
    let ChildId: Int?
    let MediaType: Int?
    let Notes: String?
    let SamplingMethod : Int?

}


//
//  VaccinationCertificationVM.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 06/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
public struct VaccinationCertificationVM{
    var certification_Type_Id : Int?
    var certificationId:String?
    var certificationTypeId:String = VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID
    var certificationTypeName:String?
    var customerId:String?
    var customerName:String?
    var customerShippingId:String?
    var fsmId:String?
    var fsmName:String?
    var selectedFsmId:String?
    var selectedFsmName:String?
    var isExistingSite:Bool = false
    var loginUserId:String?
    var scheduledDate:String?
    var siteId:String?
    var siteName:String?
    var fsrId:String?
    var fsrName:String?
    var certificationCategoryName:String?
    var certificationCategoryId:String?
    var trainingStatus:String?
    var createdDate:Date?

    var selectedUserId:String?
    var lastModuleName:String?
    var lastSubmoduleName:String?
    var certificationStatus:String?
    var syncStatus:String?
    var submittedDate:Date?// = Date()
    
    var approveRejectFsmId:Int?
    
    var hatcheryManagerSign:String?
    var fsrSignature:String?
    var supervisorName:String?
    var supervisorJobTitle:String?
    var colleagueName:String?
    var colleagueJobTitle:String?
    var deviceId:String?
    var systemCertificationId:String?
    var Id : Int?
    var TrainingId : Int?
    var FSSId : Int?
    var CountryId : Int?
    var StateId : Int?
    var FSSName : String?
    var City : String?
    var Address1 : String?
    var Address2 : String?
    var Pincode : String?
    var CountryName : String?
    var StateName : String?
    var isOtherAddress : Bool?
   
    
}

public struct VaccinationStartedCertificationVM{
    var certificationId:String?
    var certificationStatus:String?
    var lastModuleName:String?
    var lastSubmoduleName:String?
    var userId:String?
    var syncStatus:String?
    
    var assignedName:String?
    var assignedTo:String?
    var certificationCategoryId:String?
    var certificationCategoryName:String?
    var createdDate:Date = Date()
    var customerId:String?
    var customerName:String?
    var custShippingNum:String?
    var hatcheryManager:String?
    var scheduledDate:String?
    var siteid:String?
    var siteName:String?
    var submittedDate:String?
    
    var supervisorName:String?
    var supervisorJobTitle:String?
    var colleagueName:String?
    var colleagueJobTitle:String?
}

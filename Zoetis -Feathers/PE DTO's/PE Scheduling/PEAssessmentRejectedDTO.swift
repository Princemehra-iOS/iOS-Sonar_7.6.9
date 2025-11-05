//
//  PEAssessmentRejectedDTO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 22/06/21.
//

import Foundation


struct PE_AssessmentRejectedDTO : Codable {
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
    let serverAssessmentId:String?
    let scheduledDate:String?
    let userID:Int?
    let firstname:String?
    let username:String?
    let micro:String?
    let residue:String?
    let selectedTSR:String?
    let selectedTSRID:Int?
    let complexId:Int?
    let complexName:String?
    let sequenceNo:Int?
    let draftNumber:Int?
    let draftID:String?
    let dataToSubmitID:String?
    let dataToSubmitNumber:Int?
    let evaluationDate:String?
    let evaluatorName : String?
    let evaluatorID:Int?
    let visitName : String?
    let visitID:Int?
    let qcCount: String?
    let ampmValue: String?
    let frequency: String?
    let personName:String?
    let approver :  String?
    let notes :  String?
    let hatcheryAntibiotics :Int?
    let hatcheryAntibioticsDoaS :Int?
    let hatcheryAntibioticsDoa :Int?
    let hatcheryAntibioticsText:String?
    let hatcheryAntibioticsDoaText:String?
    let hatcheryAntibioticsDoaSText:String?
    let camera :Int?
    let isFlopSelected :Int?
    let breedOfBird:String?
    let breedOfBirdOther:String?
    let incubation:String?
    let incubationOthers:String?
    let note:String?
    let cID: Int?
    let catID: Int?
    let catName: String?
    let catMaxMark: Int?
    let catResultMark: Int?
    let catEvaluationID: Int?
    let catISSelected:Int?
    let assID: Int?
    let assDetail1: String?
    let informationText:String?
    let informationImage:String?
    let assDetail2: String?
    let assMinScore: Int?
    let assMaxScore: Int?
    let assCatType: String?
    let assModuleCatID: Int?
    let assModuleCatName: String?
    let noOfEggs: Int?
    let manufacturer: String?
    let sig: Int?
    let sig2: Int?
    let sig_Date: String?
    let sig_EmpID: String?
    let sig_EmpID2: String?
    let sig_Name: String?
    let sig_Name2: String?
    let sig_Phone: String?
    let iCS: String?
    let iDT: String?
    let dCS: String?
    let dDT: String?
    let dDCS: String?
    let dDDT: String?
    let assessmentStatus: String?
    let visitTypeId: Int?
    let visitType: String?
    let isNA:Bool?
    let isAllowNA:Bool?
    let rollOut:Bool?
    let qSeqNo:Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "AssessmentId"
        case scheduleDate = "scheduleDate"
        case customerId = "customerId"
        case customerName = "customerName"
        case siteId = "siteId"
        case siteName = "siteName"
        case evaluationId = "evaluationId"
        case evaluationName = "evaluationName"
        case evaluationTypeId = "evaluationTypeId"
        case evaluationTypeName = "evaluationTypeName"
        case statusName = "statusName"
        case peVisitTypeName = "peVisitTypeName"
        case peVisitTypeId = "peVisitTypeId"
        case approverId = "approverId"
        case approverName = "approverName"
        case updatedDate = "updatedDate"
        case serverAssessmentId = "serverAssessmentId"
        case scheduledDate = "scheduledDate"
        case userID = "userID"
        case firstname = "firstname"
        case username = "username"
        case micro = "micro"
        case residue = "residue"
        case selectedTSR = "selectedTSR"
        case selectedTSRID = "selectedTSRID"
        case complexId = "complexId"
        case complexName = "complexName"
        case sequenceNo = "sequenceNo"
        case draftNumber = "draftNumber"
        case draftID = "draftID"
        case dataToSubmitID = "dataToSubmitID"
        case dataToSubmitNumber = "dataToSubmitNumber"
        case evaluationDate = "evaluationDate"
        case evaluatorName = "evaluatorName"
        case evaluatorID = "evaluatorID"
        case visitName = "visitName"
        case visitID = "visitID"
        case qcCount = "qcCount"
        case ampmValue = "ampmValue"
        case frequency = "frequency"
        case personName = "personName"
        case approver = "approver"
        case notes = "notes"
        case hatcheryAntibiotics = "hatcheryAntibiotics"
        case hatcheryAntibioticsDoaS = "hatcheryAntibioticsDoaS"
        case hatcheryAntibioticsDoa = "hatcheryAntibioticsDoa"
        case hatcheryAntibioticsText = "hatcheryAntibioticsText"
        case hatcheryAntibioticsDoaText = "hatcheryAntibioticsDoaText"
        case hatcheryAntibioticsDoaSText = "hatcheryAntibioticsDoaSText"
        case camera = "camera"
        case isFlopSelected = "isFlopSelected"
        case breedOfBird = "breedOfBird"
        case breedOfBirdOther = "breedOfBirdOther"
        case incubation = "incubation"
        case incubationOthers = "incubationOthers"
        case note = "note"
        case cID = "cID"
        case catID = "catID"
        case catName = "catName"
        case catMaxMark = "catMaxMark"
        case catResultMark = "catResultMark"
        case catEvaluationID = "catEvaluationID"
        case catISSelected = "catISSelected"
        case assID = "assID"
        case assDetail1 = "assDetail1"
        case informationText = "informationText"
        case informationImage = "informationImage"
        case assDetail2 = "assDetail2"
        case assMinScore = "assMinScore"
        case assMaxScore = "assMaxScore"
        case assCatType = "assCatType"
        case assModuleCatID = "assModuleCatID"
        case assModuleCatName = "assModuleCatName"
        case noOfEggs = "noOfEggs"
        case manufacturer = "manufacturer"
        case sig = "sig"
        case sig2 = "sig2"
        case sig_Date = "sig_Date"
        case sig_EmpID = "sig_EmpID"
        case sig_EmpID2 = "sig_EmpID2"
        case sig_Name = "sig_Name"
        case sig_Name2 = "sig_Name2"
        case sig_Phone = "sig_Phone"
        case iCS = "iCS"
        case iDT = "iDT"
        case dCS = "dCS"
        case dDT = "dDT"
        case dDCS = "dDCS"
        case dDDT = "dDDT"
        case assessmentStatus = "assessmentStatus"
        case visitTypeId = "visitTypeId"
        case visitType = "visitType"
        case isNA = "isNA"
        case isAllowNA = "isAllowNA"
        case rollOut = "rollOut"
        case qSeqNo = "qSeqNo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        scheduleDate = try values.decodeIfPresent(String.self, forKey: .scheduleDate)
        customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        siteId = try values.decodeIfPresent(Int.self, forKey: .siteId)
        siteName = try values.decodeIfPresent(String.self, forKey: .siteName)
        evaluationId  = try values.decodeIfPresent(Int.self, forKey: .evaluationId)
        evaluationName = try values.decodeIfPresent(String.self, forKey: .evaluationName)
        evaluationTypeId = try values.decodeIfPresent(Int.self, forKey: .evaluationTypeId)
        evaluationTypeName = try values.decodeIfPresent(String.self, forKey: .evaluationTypeName)
        statusName = try values.decodeIfPresent(String.self, forKey: .statusName)
        peVisitTypeName = try values.decodeIfPresent(String.self, forKey: .peVisitTypeName)
        peVisitTypeId = try values.decodeIfPresent(Int.self, forKey: .peVisitTypeId)
        approverId = try values.decodeIfPresent(Int.self, forKey: .approverId)
        approverName = try values.decodeIfPresent(String.self, forKey: .approverName)
        updatedDate = try values.decodeIfPresent(String.self, forKey: .updatedDate)
        serverAssessmentId = try values.decodeIfPresent(String.self, forKey: .serverAssessmentId)
        scheduledDate = try values.decodeIfPresent(String.self, forKey: .scheduledDate)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        firstname  = try values.decodeIfPresent(String.self, forKey: .firstname)
        username  = try values.decodeIfPresent(String.self, forKey: .username)
        micro = try values.decodeIfPresent(String.self, forKey: .micro)
        residue = try values.decodeIfPresent(String.self, forKey: .residue)
        selectedTSR = try values.decodeIfPresent(String.self, forKey: .selectedTSR)
        selectedTSRID = try values.decodeIfPresent(Int.self, forKey: .selectedTSRID)
        complexId = try values.decodeIfPresent(Int.self, forKey: .complexId)
        complexName = try values.decodeIfPresent(String.self, forKey: .complexName)
        sequenceNo = try values.decodeIfPresent(Int.self, forKey: .sequenceNo)
        draftNumber = try values.decodeIfPresent(Int.self, forKey: .draftNumber)
        draftID = try values.decodeIfPresent(String.self, forKey: .draftID)
        dataToSubmitID = try values.decodeIfPresent(String.self, forKey: .dataToSubmitID)
        dataToSubmitNumber = try values.decodeIfPresent(Int.self, forKey: .dataToSubmitNumber)
        evaluationDate = try values.decodeIfPresent(String.self, forKey: .evaluationDate)
        evaluatorName = try values.decodeIfPresent(String.self, forKey: .evaluatorName)
        evaluatorID = try values.decodeIfPresent(Int.self, forKey: .evaluatorID)
        visitName = try values.decodeIfPresent(String.self, forKey: .visitName)
        visitID = try values.decodeIfPresent(Int.self, forKey: .visitID)
        qcCount = try values.decodeIfPresent(String.self, forKey: .qcCount)
        ampmValue = try values.decodeIfPresent(String.self, forKey: .ampmValue)
        frequency = try values.decodeIfPresent(String.self, forKey: .frequency)
        personName = try values.decodeIfPresent(String.self, forKey: .personName)
        approver = try values.decodeIfPresent(String.self, forKey: .approver)
        notes = try values.decodeIfPresent(String.self, forKey: .notes)
        hatcheryAntibiotics = try values.decodeIfPresent(Int.self, forKey: .hatcheryAntibiotics)
        hatcheryAntibioticsDoaS = try values.decodeIfPresent(Int.self, forKey: .hatcheryAntibioticsDoaS)
        hatcheryAntibioticsDoa = try values.decodeIfPresent(Int.self, forKey: .hatcheryAntibioticsDoa)
        hatcheryAntibioticsText = try values.decodeIfPresent(String.self, forKey: .hatcheryAntibioticsText)
        hatcheryAntibioticsDoaText = try values.decodeIfPresent(String.self, forKey: .hatcheryAntibioticsDoaText)
        hatcheryAntibioticsDoaSText = try values.decodeIfPresent(String.self, forKey: .hatcheryAntibioticsDoaSText)
        camera = try values.decodeIfPresent(Int.self, forKey: .camera)
        isFlopSelected = try values.decodeIfPresent(Int.self, forKey: .isFlopSelected)
        breedOfBird = try values.decodeIfPresent(String.self, forKey: .breedOfBird)
        breedOfBirdOther = try values.decodeIfPresent(String.self, forKey: .breedOfBirdOther)
        incubation = try values.decodeIfPresent(String.self, forKey: .incubation)
        incubationOthers = try values.decodeIfPresent(String.self, forKey: .incubationOthers)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        cID = try values.decodeIfPresent(Int.self, forKey: .cID)
        catID = try values.decodeIfPresent(Int.self, forKey: .catID)
        catName = try values.decodeIfPresent(String.self, forKey: .catName)
        catMaxMark = try values.decodeIfPresent(Int.self, forKey: .catMaxMark)
        catResultMark = try values.decodeIfPresent(Int.self, forKey: .catResultMark)
        catEvaluationID = try values.decodeIfPresent(Int.self, forKey: .catEvaluationID)
        catISSelected = try values.decodeIfPresent(Int.self, forKey: .catISSelected)
        assID  = try values.decodeIfPresent(Int.self, forKey: .assID)
        assDetail1 = try values.decodeIfPresent(String.self, forKey: .assDetail1)
        informationText = try values.decodeIfPresent(String.self, forKey: .informationText)
        informationImage = try values.decodeIfPresent(String.self, forKey: .informationImage)
        assDetail2 = try values.decodeIfPresent(String.self, forKey: .assDetail2)
        assMinScore = try values.decodeIfPresent(Int.self, forKey: .assMinScore)
        assMaxScore = try values.decodeIfPresent(Int.self, forKey: .assMaxScore)
        assCatType = try values.decodeIfPresent(String.self, forKey: .assCatType)
        assModuleCatID = try values.decodeIfPresent(Int.self, forKey: .assModuleCatID)
        assModuleCatName = try values.decodeIfPresent(String.self, forKey: .assModuleCatName)
        noOfEggs = try values.decodeIfPresent(Int.self, forKey: .noOfEggs)
        manufacturer = try values.decodeIfPresent(String.self, forKey: .manufacturer)
        sig = try values.decodeIfPresent(Int.self, forKey: .sig)
        sig2 = try values.decodeIfPresent(Int.self, forKey: .sig2)
        sig_Date = try values.decodeIfPresent(String.self, forKey: .sig_Date)
        sig_EmpID = try values.decodeIfPresent(String.self, forKey: .sig_EmpID)
        sig_EmpID2 = try values.decodeIfPresent(String.self, forKey: .sig_EmpID2)
        sig_Name = try values.decodeIfPresent(String.self, forKey: .sig_Name)
        sig_Name2 = try values.decodeIfPresent(String.self, forKey: .sig_Name2)
        sig_Phone = try values.decodeIfPresent(String.self, forKey: .sig_Phone)
        iCS = try values.decodeIfPresent(String.self, forKey: .iCS)
        iDT = try values.decodeIfPresent(String.self, forKey: .iDT)
        dCS = try values.decodeIfPresent(String.self, forKey: .dCS)
        dDT = try values.decodeIfPresent(String.self, forKey: .dDT)
        dDCS = try values.decodeIfPresent(String.self, forKey: .dDCS)
        dDDT = try values.decodeIfPresent(String.self, forKey: .dDDT)
        assessmentStatus = try values.decodeIfPresent(String.self, forKey: .assessmentStatus)
        visitTypeId = try values.decodeIfPresent(Int.self, forKey: .visitTypeId)
        visitType = try values.decodeIfPresent(String.self, forKey: .visitType)
        isNA = try values.decodeIfPresent(Bool.self, forKey: .isNA)
        isAllowNA = try values.decodeIfPresent(Bool.self, forKey: .isAllowNA)
        qSeqNo = try values.decodeIfPresent(Int.self, forKey: .qSeqNo)
        rollOut = try values.decodeIfPresent(Bool.self, forKey: .rollOut)
    }
}

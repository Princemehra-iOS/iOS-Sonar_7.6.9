//
//  CoreDataModels.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 06/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData


public class PE_Customer: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Customer> {
        return NSFetchRequest<PE_Customer>(entityName: "PE_Customer")
    }
    
    @NSManaged public var customerName: String?
    @NSManaged public var customerID: NSNumber?
    
}


public class PE_Complex: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Complex> {
        return NSFetchRequest<PE_Complex>(entityName: "PE_Complex")
    }
    
    @NSManaged public var complexName: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var userId: NSNumber?
    
}


public class PE_Sites: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Sites> {
        return NSFetchRequest<PE_Sites>(entityName: "PE_Sites")
    }
    
    @NSManaged public var siteName: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
}

public class PE_Evaluator: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Evaluator> {
        return NSFetchRequest<PE_Evaluator>(entityName: "PE_Evaluator")
    }
    
    @NSManaged public var evaluatorName: String?
    @NSManaged public var id: NSNumber?
}

public class PE_VisitTypes: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_VisitTypes> {
        return NSFetchRequest<PE_VisitTypes>(entityName: "PE_VisitTypes")
    }
    
    @NSManaged public var visitName: String?
    @NSManaged public var id: NSNumber?
}

public class PE_EvaluationType: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_EvaluationType> {
        return NSFetchRequest<PE_EvaluationType>(entityName: "PE_EvaluationType")
    }
    
    @NSManaged public var evaluationName: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var hatModuleId: NSNumber?
}




public class PE_Session: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_Session")
    }
    @NSManaged public var id: NSNumber?
    @NSManaged public var datetime: Date?
    
}

public class PE_Refrigator: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_Refrigator")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var labelText: String?
    @NSManaged public var rollOut: String?
    @NSManaged public var unit: String?
    @NSManaged @objc(value) var value: Double
    @NSManaged public var catID: NSNumber?
    @NSManaged public var schAssmentId: NSNumber?
    @NSManaged @objc(isCheck) var isCheck: Bool
    @NSManaged @objc(isNA) var isNA: Bool

}





public class PE_AssessmentInProgress: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_AssessmentInProgress")
    }
    @NSManaged @objc(isAllowNA) var isAllowNA: Bool
    @NSManaged @objc(isNA) var isNA: Bool
    @NSManaged public var qSeqNo: NSNumber?
    @NSManaged public var rollOut: String?
    @NSManaged public var draftNumber: NSNumber?
    @NSManaged public var draftID: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var cID: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userID: NSNumber?
    @NSManaged public var sequenceNo: NSNumber?
    @NSManaged public var sequenceNoo: NSNumber?
    @NSManaged public var rejectionComment: String?
    @NSManaged public var customerName: String?
    @NSManaged public var firstname: String?
    @NSManaged public var username: String?
    @NSManaged public var evaluationDate:String?
    @NSManaged public var evaluatorName : String?
    @NSManaged public var evaluatorID:NSNumber?
    @NSManaged public var visitName : String?
    @NSManaged public var visitID:NSNumber?
    @NSManaged public var evaluationName : String?
    @NSManaged public var evaluationID:NSNumber?
    @NSManaged public var approver :  String?
    @NSManaged public var notes :  String?
    @NSManaged public var assessmentStatus :  String?
    @NSManaged public var scheduledDate :  Date?
    @NSManaged public var statusType :  NSNumber?
    
    @NSManaged public var isFlopSelected : NSNumber?
    @NSManaged public var camera: NSNumber?
    @NSManaged public var isChlorineStrip : NSNumber?
    @NSManaged public var isAutomaticFail: NSNumber?
    
    @NSManaged public var catID: NSNumber?
    @NSManaged public var catName :  String?
    @NSManaged public var catMaxMark: NSNumber?
    
    @NSManaged public var catResultMark : NSNumber?
    @NSManaged public var catEvaluationID: NSNumber?
    @NSManaged public var catISSelected : NSNumber?
    @NSManaged public var assID: NSNumber?
    
    @NSManaged public var assDetail1 :  String?
    @NSManaged public var assDetail2 :  String?
    @NSManaged public var assMinScore : NSNumber?
    @NSManaged public var assMaxScore: NSNumber?
    @NSManaged public var assCatType :  String?
    @NSManaged public var assModuleCatID : NSNumber?
    @NSManaged public var assModuleCatName :  String?
    @NSManaged public var selectedTSR :  String?//selectedTSRID
    @NSManaged public var selectedTSRID :  NSNumber?//selectedTSRID
    @NSManaged public var assStatus : NSNumber?
    @NSManaged public var breedOfBird :  String?
    @NSManaged public var breedOfBirdOther :  String?
    @NSManaged public var incubation :  String?
    @NSManaged public var incubationOthers :  String?
    @NSManaged public var note :  String?
    @NSManaged public var images :  NSObject?
    
    @NSManaged public var sig2 : NSNumber?
    @NSManaged public var sig : NSNumber?
    @NSManaged public var sig_Date :  String?
    @NSManaged public var sig_EmpID2 :  String?
    @NSManaged public var sig_EmpID :  String?
    @NSManaged public var sig_Name2 :  String?
    @NSManaged public var sig_Name :  String?
    @NSManaged public var sig_Phone :  String?
    
    @NSManaged public var informationText :  String?
    @NSManaged public var informationImage :  String?
    @NSManaged public var vMixer :  NSObject?
    @NSManaged public var noOfEggs : NSNumber?
    @NSManaged public var manufacturer :  String?
    @NSManaged public var iCS :  String?
    @NSManaged public var iDT :  String?
    @NSManaged public var dCS :  String?
    @NSManaged public var dDT :  String?
    @NSManaged public var micro :  String?
    @NSManaged public var residue :  String?
    @NSManaged public var asyncStatus :  NSNumber?
    
    @NSManaged public var hatcheryAntibiotics : NSNumber?
    
    @NSManaged public var doa :  NSObject?
    
    @NSManaged public var inovoject :  NSObject?
    
    @NSManaged public var doaS :  NSObject?
    @NSManaged public var hatcheryAntibioticsText : String?
    @NSManaged public var hatcheryAntibioticsDoa : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaText : String?
    @NSManaged public var hatcheryAntibioticsDoaS : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaSText : String?
    @NSManaged public var qcCount : String?
    @NSManaged public var dDCS :  String?
    @NSManaged public var dDDT :  String?
    
    @NSManaged public var ampmValue :  String?
    @NSManaged public var frequency :  String?
    @NSManaged public var personName :  String?
    @NSManaged public var serverAssessmentId :  String?
    @NSManaged public var fsrSignatureImage :  String?
    
    
    @NSManaged public var countryID : NSNumber?
    @NSManaged public var countryName : String?
    
    @NSManaged public var clorineId : NSNumber?
    @NSManaged public var clorineName : String?
    @NSManaged public var refrigeratorNote : String?
    @NSManaged @objc(fluid) var fluid : Bool
    @NSManaged @objc(basic) var basic : Bool
    @NSManaged @objc(extndMicro) var extndMicro : Bool
    @NSManaged @objc(isEMRequested) var isEMRequested : Bool
    
    @NSManaged @objc(isHandMix) var isHandMix : Bool
    @NSManaged public var ppmValue : String?
    
    @NSManaged @objc(isPERejected) var isPERejected : Bool
    @NSManaged public var emRejectedComment : String?
    @NSManaged @objc(isEMRejected) var isEMRejected : Bool
    @NSManaged @objc(sanitationValue) var sanitationValue : Bool
    

    
}

public class PE_AssessmentIDraftInProgress: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_AssessmentIDraftInProgress> {
        return NSFetchRequest<PE_AssessmentIDraftInProgress>(entityName: "PE_AssessmentIDraftInProgress")
    }
    @NSManaged @objc(isAllowNA) var isAllowNA: Bool
    @NSManaged @objc(isNA) var isNA: Bool
    @NSManaged public var rollOut: String?
    @NSManaged public var qSeqNo: NSNumber?
    @NSManaged public var dataToSubmitNumber: NSNumber?
    @NSManaged public var dataToSubmitID: String?
    @NSManaged public var draftID: String?
    @NSManaged public var draftNumber: NSNumber?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var cID: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userID: NSNumber?
    @NSManaged public var sequenceNo: NSNumber?
    @NSManaged public var sequenceNoo: NSNumber?
    @NSManaged public var customerName: String?
    @NSManaged public var firstname: String?
    @NSManaged public var username: String?
    
    @NSManaged public var evaluationDate:String?
    @NSManaged public var evaluatorName : String?
    @NSManaged public var evaluatorID:NSNumber?
    @NSManaged public var visitName : String?
    @NSManaged public var visitID:NSNumber?
    @NSManaged public var evaluationName : String?
    @NSManaged public var evaluationID:NSNumber?
    @NSManaged public var approver :  String?
    @NSManaged public var notes :  String?
    @NSManaged public var hatcheryAntibiotics : NSNumber?
    @NSManaged public var isFlopSelected : NSNumber?
    @NSManaged public var camera: NSNumber?
    @NSManaged public var statusType: NSNumber?
    @NSManaged public var isChlorineStrip : NSNumber?
    @NSManaged public var isAutomaticFail: NSNumber?
    
    @NSManaged public var sig2 : NSNumber?
    @NSManaged public var sig : NSNumber?
    @NSManaged public var sig_Date :  String?
    @NSManaged public var sig_EmpID2 :  String?
    @NSManaged public var sig_EmpID :  String?
    @NSManaged public var sig_Name2 :  String?
    @NSManaged public var sig_Name :  String?
    @NSManaged public var sig_Phone :  String?
    
    @NSManaged public var catID: NSNumber?
    @NSManaged public var catName :  String?
    @NSManaged public var catMaxMark: NSNumber?
    
    @NSManaged public var catResultMark : NSNumber?
    @NSManaged public var catEvaluationID: NSNumber?
    @NSManaged public var catISSelected : NSNumber?
    @NSManaged public var assID: NSNumber?
    
    @NSManaged public var assDetail1 :  String?
    @NSManaged public var assDetail2 :  String?
    @NSManaged public var assMinScore : NSNumber?
    @NSManaged public var assMaxScore: NSNumber?
    @NSManaged public var assCatType :  String?
    @NSManaged public var assModuleCatID : NSNumber?
    @NSManaged public var assModuleCatName :  String?
    @NSManaged public var selectedTSR :  String?
    @NSManaged public var selectedTSRID : NSNumber?
    
    
    @NSManaged public var assStatus : NSNumber?
    @NSManaged public var breedOfBird :  String?
    @NSManaged public var breedOfBirdOther :  String?
    @NSManaged public var incubation :  String?
    @NSManaged public var incubationOthers :  String?
    @NSManaged public var note :  String?
    @NSManaged public var images :  NSObject?
    @NSManaged public var doa :  NSObject?
    @NSManaged public var inovoject :  NSObject?
    @NSManaged public var informationText :  String?
    @NSManaged public var informationImage :  String?
    @NSManaged public var vMixer :  NSObject?
    @NSManaged public var noOfEggs : NSNumber?
    @NSManaged public var manufacturer :  String?
    @NSManaged public var iCS :  String?
    @NSManaged public var iDT :  String?
    @NSManaged public var dCS :  String?
    @NSManaged public var dDT :  String?
    @NSManaged public var micro :  String?
    @NSManaged public var residue :  String?
    @NSManaged public var asyncStatus :  NSNumber?
    
    @NSManaged public var doaS :  NSObject?
    @NSManaged public var hatcheryAntibioticsText : String?
    @NSManaged public var hatcheryAntibioticsDoa : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaText : String?
    @NSManaged public var hatcheryAntibioticsDoaS : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaSText : String?
    @NSManaged public var qcCount : String?
    @NSManaged public var dDCS :  String?
    @NSManaged public var dDDT :  String?
    @NSManaged public var ampmValue :  String?
     @NSManaged public var frequency :  String?
     @NSManaged public var personName :  String?
     @NSManaged public var serverAssessmentId :  String?
    @NSManaged public var fsrSignatureImage :  String?
    
    @NSManaged public var countryID : NSNumber?
    @NSManaged public var countryName : String?
    
    @NSManaged public var clorineId : NSNumber?
    @NSManaged public var clorineName : String?
    
    @NSManaged public var refrigeratorNote : String?
    @NSManaged @objc(fluid) var fluid: Bool
    @NSManaged @objc(basicTransfer) var basicTransfer: Bool
    @NSManaged @objc(extndMicro) var extndMicro : Bool
    @NSManaged @objc(isEMRequested) var isEMRequested : Bool
    
    @NSManaged public var ppmValue : String?
    @NSManaged @objc(isHandMix) var isHandMix: Bool
    
    @NSManaged @objc(isPERejected) var isPERejected : Bool
    @NSManaged public var emRejectedComment : String?
    @NSManaged @objc(isEMRejected) var isEMRejected : Bool
    @NSManaged @objc(sanitationValue) var sanitationValue : Bool

}

public class PE_AssessmentInDraft: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_AssessmentInDraft")
    }
    @NSManaged @objc(isAllowNA) var isAllowNA: Bool
    @NSManaged @objc(isNA) var isNA: Bool
    @NSManaged public var rollOut: String?
    @NSManaged public var qSeqNo: NSNumber?
    @NSManaged public var dataToSubmitNumber: NSNumber?
    @NSManaged public var dataToSubmitID: String?
    @NSManaged public var draftNumber: NSNumber?
    @NSManaged public var draftID: String?
    @NSManaged public var cID: NSNumber?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userID: NSNumber?
    @NSManaged public var customerName: String?
    @NSManaged public var firstname: String?
    @NSManaged public var username: String?
    
    @NSManaged public var sequenceNo: NSNumber?
    @NSManaged public var sequenceNoo: NSNumber?
    @NSManaged public var evaluationDate:String?
    @NSManaged public var evaluatorName : String?
    @NSManaged public var evaluatorID:NSNumber?
    @NSManaged public var visitName : String?
    @NSManaged public var visitID:NSNumber?
    @NSManaged public var evaluationName : String?
    @NSManaged public var evaluationID:NSNumber?
    @NSManaged public var approver :  String?
    @NSManaged public var notes :  String?
    @NSManaged public var hatcheryAntibiotics : NSNumber?
    @NSManaged public var isFlopSelected : NSNumber?
    @NSManaged public var camera: NSNumber?
    
    @NSManaged public var sig2 : NSNumber?
    @NSManaged public var sig : NSNumber?
    @NSManaged public var sig_Date :  String?
    @NSManaged public var sig_EmpID2 :  String?
    @NSManaged public var sig_EmpID :  String?
    @NSManaged public var sig_Name2 :  String?
    @NSManaged public var sig_Name :  String?
    @NSManaged public var sig_Phone :  String?
    @NSManaged public var isChlorineStrip : NSNumber?
    @NSManaged public var isAutomaticFail: NSNumber?
    
    @NSManaged public var catID: NSNumber?
    @NSManaged public var catName :  String?
    @NSManaged public var catMaxMark: NSNumber?
    
    @NSManaged public var catResultMark : NSNumber?
    @NSManaged public var catEvaluationID: NSNumber?
    @NSManaged public var catISSelected : NSNumber?
    @NSManaged public var assID: NSNumber?
    
    @NSManaged public var assDetail1 :  String?
    @NSManaged public var assDetail2 :  String?
    @NSManaged public var assMinScore : NSNumber?
    @NSManaged public var assMaxScore: NSNumber?
    @NSManaged public var assCatType :  String?
    @NSManaged public var assModuleCatID : NSNumber?
    @NSManaged public var assModuleCatName :  String?
    @NSManaged public var selectedTSR :  String?
    @NSManaged public var assStatus : NSNumber?
    @NSManaged public var breedOfBird :  String?
    @NSManaged public var breedOfBirdOther :  String?
    @NSManaged public var incubation :  String?
    @NSManaged public var incubationOthers :  String?
    @NSManaged public var note :  String?
    @NSManaged public var images :  NSObject?
    @NSManaged public var doa :  NSObject?
    @NSManaged public var inovoject :  NSObject?
    @NSManaged public var informationText :  String?
    @NSManaged public var informationImage :  String?
    @NSManaged public var vMixer :  NSObject?
    @NSManaged public var noOfEggs : NSNumber?
    @NSManaged public var manufacturer :  String?
    @NSManaged public var iCS :  String?
    @NSManaged public var iDT :  String?
    @NSManaged public var dCS :  String?
    @NSManaged public var dDT :  String?
    @NSManaged public var micro :  String?
    @NSManaged public var residue :  String?
    @NSManaged public var asyncStatus :  NSNumber?
    
    @NSManaged public var doaS :  NSObject?
    @NSManaged public var hatcheryAntibioticsText : String?
    @NSManaged public var hatcheryAntibioticsDoa : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaText : String?
    @NSManaged public var hatcheryAntibioticsDoaS : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaSText : String?
    @NSManaged public var qcCount : String?
    @NSManaged public var dDCS :  String?
    @NSManaged public var dDDT :  String?
    @NSManaged public var ampmValue :  String?
    @NSManaged public var frequency :  String?
    @NSManaged public var personName :  String?
    @NSManaged public var serverAssessmentId :  String?
    @NSManaged public var FSTSignatureImage :  String?
    
    @NSManaged public var countryID : NSNumber?
    @NSManaged public var countryName : String?
    
    
    @NSManaged public var clorineId : NSNumber?
    @NSManaged public var clorineName : String?
    
    
    @NSManaged public var refrigeratorNote : String?
    @NSManaged @objc(fluid) var fluid: Bool
    @NSManaged @objc(basicTransfer) var basicTransfer: Bool
    @NSManaged @objc(extndMicro) var extndMicro : Bool
    @NSManaged @objc(isEMRequested) var isEMRequested : Bool
    
    @NSManaged public var isHandMix : Bool
    @NSManaged public var ppmValue : String?
    
    @NSManaged @objc(isPERejected) var isPERejected : Bool
    @NSManaged public var emRejectedComment : String?
    @NSManaged @objc(isEMRejected) var isEMRejected : Bool
    @NSManaged @objc(sanitationValue) var sanitationValue : Bool


}

public class PE_AssessmentInOffline: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_AssessmentInOffline")
    }
    @NSManaged @objc(isAllowNA) var isAllowNA: Bool
    @NSManaged @objc(isNA) var isNA: Bool
    @NSManaged public var rollOut: String?
    @NSManaged public var qSeqNo: NSNumber?
    @NSManaged public var draftNumber: NSNumber?
    @NSManaged public var dataToSubmitNumber: NSNumber?
    @NSManaged public var dataToSubmitID: String?
    @NSManaged public var cID: NSNumber?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userID: NSNumber?
    @NSManaged public var customerName: String?
    @NSManaged public var firstname: String?
    @NSManaged public var username: String?
    
    @NSManaged public var sequenceNo: NSNumber?
    @NSManaged public var sequenceNoo: NSNumber?
    @NSManaged public var evaluationDate:String?
    @NSManaged public var evaluatorName : String?
    @NSManaged public var evaluatorID:NSNumber?
    @NSManaged public var visitName : String?
    @NSManaged public var visitID:NSNumber?
    @NSManaged public var evaluationName : String?
    @NSManaged public var evaluationID:NSNumber?
    @NSManaged public var approver :  String?
    @NSManaged public var notes :  String?
    @NSManaged public var hatcheryAntibiotics : NSNumber?
    @NSManaged public var isFlopSelected : NSNumber?
    @NSManaged public var camera: NSNumber?
    
    @NSManaged public var isChlorineStrip : NSNumber?
    @NSManaged public var isAutomaticFail: NSNumber?
    @NSManaged public var catID: NSNumber?
    @NSManaged public var catName :  String?
    @NSManaged public var catMaxMark: NSNumber?
    
    @NSManaged public var catResultMark : NSNumber?
    @NSManaged public var catEvaluationID: NSNumber?
    @NSManaged public var catISSelected : NSNumber?
    @NSManaged public var assID: NSNumber?
    
    @NSManaged public var assDetail1 :  String?
    @NSManaged public var assDetail2 :  String?
    @NSManaged public var assMinScore : NSNumber?
    @NSManaged public var assMaxScore: NSNumber?
    @NSManaged public var assCatType :  String?
    @NSManaged public var assModuleCatID : NSNumber?
    @NSManaged public var assModuleCatName :  String?
    @NSManaged public var selectedTSR :  String?
    @NSManaged public var assStatus : NSNumber?
    @NSManaged public var breedOfBird :  String?
    @NSManaged public var breedOfBirdOther :  String?
    @NSManaged public var incubation :  String?
    @NSManaged public var incubationOthers :  String?
    @NSManaged public var note :  String?
    @NSManaged public var informationText :  String?
    @NSManaged public var informationImage :  String?
    @NSManaged public var images :  NSObject?
    @NSManaged public var doa :  NSObject?
    @NSManaged public var inovoject :  NSObject?
    @NSManaged public var vMixer :  NSObject?
    @NSManaged public var sig2 : NSNumber?
    @NSManaged public var sig : NSNumber?
    @NSManaged public var sig_Date :  String?
    @NSManaged public var sig_EmpID2 :  String?
    @NSManaged public var sig_EmpID :  String?
    @NSManaged public var sig_Name2 :  String?
    @NSManaged public var sig_Name :  String?
    @NSManaged public var sig_Phone :  String?
    @NSManaged public var noOfEggs : NSNumber?
    @NSManaged public var manufacturer :  String?
    @NSManaged public var iCS :  String?
    @NSManaged public var iDT :  String?
    @NSManaged public var dCS :  String?
    @NSManaged public var dDT :  String?
    @NSManaged public var micro :  String?
    @NSManaged public var residue :  String?
    @NSManaged public var asyncStatus :  NSNumber?
    @NSManaged public var draftID: String?
    @NSManaged public var doaS :  NSObject?
    @NSManaged public var hatcheryAntibioticsText : String?
    @NSManaged public var hatcheryAntibioticsDoa : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaText : String?
    @NSManaged public var hatcheryAntibioticsDoaS : NSNumber?
    @NSManaged public var hatcheryAntibioticsDoaSText : String?
    @NSManaged public var qcCount : String?
    @NSManaged public var dDCS :  String?
    @NSManaged public var dDDT :  String?
    @NSManaged public var ampmValue :  String?
    @NSManaged public var frequency :  String?
    @NSManaged public var personName :  String?
    @NSManaged public var serverAssessmentId :  String?
    @NSManaged public var FSTSignatureImage :  String?
    @NSManaged @objc(extndMicro) var extndMicro : Bool
    @NSManaged public var countryID : NSNumber?
    @NSManaged public var countryName : String?
    @NSManaged public var refrigeratorNote : String?
    @NSManaged @objc(fluid) var fluid: Bool
    @NSManaged @objc(basicTransfer) var basicTransfer: Bool
    
    @NSManaged @objc(isEMRequested) var isEMRequested : Bool
    @NSManaged public var clorineId : NSNumber?
    @NSManaged public var clorineName : String?
    
    @NSManaged public var isHandMix : Bool
    
    @NSManaged public var ppmValue : String?
    
    @NSManaged @objc(isPERejected) var isPERejected : Bool
    @NSManaged public var emRejectedComment : String?
    @NSManaged @objc(isEMRejected) var isEMRejected : Bool
    @NSManaged @objc(sanitationValue) var sanitationValue : Bool

}

public class PE_ImageEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_ImageEntity> {
        return NSFetchRequest<PE_ImageEntity>(entityName: "PE_ImageEntity")
    }
    
    @NSManaged public var imageId : NSNumber?
    @NSManaged public var imageData: NSData?
    @NSManaged public var isSync : NSNumber?
    
}

public class PE_DayOfAge: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_DayOfAge> {
        return NSFetchRequest<PE_DayOfAge>(entityName: "PE_DayOfAge")
    }
    
    @NSManaged public var doaId : NSNumber?
    @NSManaged public var doaName : String?
    @NSManaged public var doaVm : String?
    @NSManaged public var doaDosage : String?
    @NSManaged public var doaDiluentManufacturer : String?
    @NSManaged public var doaBagSize : String?
    @NSManaged public var doaAmpuleSize : String?
    @NSManaged public var doaAmpulePerBag : String?
//    doaDilManOther
//    invoHatchAntibiotic
//    invoHatchAntibioticText
//    invoProgramName
    
    @NSManaged public var bagSizeType : String?

    @NSManaged public var doaDilManOther : String?
    @NSManaged public var invoHatchAntibioticText : String?
    @NSManaged public var invoProgramName : String?
    @NSManaged public var invoHatchAntibiotic : NSNumber?
}

public class PE_VMixer: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_VMixer> {
        return NSFetchRequest<PE_VMixer>(entityName: "PE_VMixer")
    }
    @NSManaged public var vmid : NSNumber?
    @NSManaged public var certificateDate : String?
    @NSManaged public var certificateName : String?
}

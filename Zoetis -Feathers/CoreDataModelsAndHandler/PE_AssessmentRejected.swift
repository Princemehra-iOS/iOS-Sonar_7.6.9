//
//  PE_AssessmentRejected.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/07/21.
//

import Foundation
import CoreData

public class PE_AssessmentRejected: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PE_Session> {
        return NSFetchRequest<PE_Session>(entityName: "PE_AssessmentRejected")
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
    
    
    @NSManaged public var catID: NSNumber?
    @NSManaged public var catName :  String?
    @NSManaged public var catMaxMark: NSNumber?
    
    @NSManaged public var catResultMark : NSNumber?
    @NSManaged public var catEvaluationID: NSNumber?
    @NSManaged public var catISSelected : NSNumber?
    @NSManaged public var assID: NSNumber?
    @NSManaged public var loginUserId: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var evaluationTypeId: NSNumber?
    @NSManaged public var visitTypeId: NSNumber?
    @NSManaged public var visitType: String?
    @NSManaged public var approverId: NSNumber?
    @NSManaged public var approverName: String?
    @NSManaged public var updatedDate: Date?
    
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
    @NSManaged public var assessmentStatus :  String?
    @NSManaged public var scheduledDate :  Date?
    
    @NSManaged public var sig2 : NSNumber?
    @NSManaged public var sig : NSNumber?
    @NSManaged public var sig_Date :  String?
    @NSManaged public var sig_EmpID2 :  String?
    @NSManaged public var sig_EmpID :  String?
    @NSManaged public var sig_Name2 :  String?
    @NSManaged public var sig_Name :  String?
    @NSManaged public var sig_Phone :  String?
    
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
    
   
    @NSManaged public var emRejectedComment : String?
    @NSManaged public var isEMRejected : NSNumber?
    @NSManaged public var isPERejected : NSNumber?
    
    
}


public class ScoreData: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScoreData> {
        return NSFetchRequest<ScoreData>(entityName: "ScoreData")
    }
    @NSManaged public var id: NSNumber?
    @NSManaged public var scoreString: String?
}

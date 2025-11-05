//
//  PEAssessmentRejected.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 23/06/21.
//

import Foundation
import CoreData

public class PEAssessmentRejected: NSObject{
    var loginUserId: String?
    var updatedDate:Date?
    var serverAssessmentId:String?
    var scheduledDate:Date?
    var userID:Int?
    var firstname:String?
    var username:String?
    var micro:String?
    var residue:String?
    var selectedTSR:String?
    var selectedTSRID:Int?
    var customerId:Int?
    var customerName:String?
    var complexId:Int?
    var complexName:String?
    var sequenceNo:Int?
    var sequenceNoo:Int?
    var draftNumber:Int?
    var draftID:String?
    var dataToSubmitID:String?
    var dataToSubmitNumber:Int?
    var complex:Complex?
    var complexLocalBD : PE_Customer?
    var customer:Customer?
    var siteName:String?
    var siteId:Int?
    var evaluationDate:String?
    var evaluatorName : String?
    var evaluatorID:Int?
    var visitName : String?
    var visitID:Int?
    var evaluationName : String?
    var evaluationID:Int?
    var evaluationTypeId:Int?
    var qcCount: String?
        
    var ampmValue: String?
    var frequency: String?
    var personName:String?
        
    var approver :  String?
    var notes :  String?
    var hatcheryAntibiotics :Int?
    var hatcheryAntibioticsDoaS :Int?
    var hatcheryAntibioticsDoa :Int?
        
    var hatcheryAntibioticsText:String?
    var hatcheryAntibioticsDoaText:String?
    var hatcheryAntibioticsDoaSText:String?

    var camera :Int?
    var isFlopSelected :Int?
    var breedOfBird:String?
    var breedOfBirdOther:String?
    var incubation:String?
    var incubationOthers:String?
    var note:String?
    var cID: Int?
    var catID: Int?
    var catName: String?
    var catMaxMark: Int?
    var catResultMark: Int?
    var catEvaluationID: Int?
    var catISSelected:Int?
    var assID: Int?
    var assDetail1: String?
    var informationText:String?
    var informationImage:String?
    var assDetail2: String?
    var assMinScore: Int?
    var assMaxScore: Int?
    var assCatType: String?
    var assModuleCatID: Int?
    var assModuleCatName: String?
    var noOfEggs: Int64?
    var manufacturer: String?
    var sig: Int?
    var sig2: Int?
    var sig_Date: String?
    var sig_EmpID: String?
    var sig_EmpID2: String?
    var sig_Name: String?
    var sig_Name2: String?
    var sig_Phone: String?
    var iCS: String?
    var iDT: String?
    var dCS: String?
    var dDT: String?
    var dDCS: String?
    var dDDT: String?
    var id: Int?
    var assessmentStatus: String?
    var visitTypeId: Int?
    var visitType: String?
    var approverId: Int?
    var approverName: String?
        
    var images:[Int] = []
    var doa:[Int] = []
    var doaS:[Int] = []
    var inovoject:[Int] = []
    var vMixer:[Int] = []
    var assStatus:Int?
    var evalType : EvaluationType?
    var Evaluator : Evaluator?
    var reasonForVisit : VisitType?
    var isAllowNA:Bool?
    var qSeqNo:Int?
    var isNA: Bool?
    var rollOut: String?
    var peCategoriesAssesmentsResponseDraft : PECategoriesAssesmentsResponse?
    var peCategoriesAssesmentsResponseFinalize : PECategoriesAssesmentsResponse?
}

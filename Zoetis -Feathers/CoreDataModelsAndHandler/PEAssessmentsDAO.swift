//
//  PEAssessmentsDAO.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 07/10/20.
//

import Foundation
import CoreData
import UIKit

class PEAssessmentsDAO{
    static let sharedInstance = PEAssessmentsDAO()
    
    let loginAssStatus = "loginUserId = %@ AND  assessmentStatus = %@"
    let message = "test message"
    func getAssessmentObject()-> PE_ScheduledAssessments{
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_ScheduledAssessments" , into: managedContext) as! PE_ScheduledAssessments
        return vaccinationCertObj
    }
    
    func getRejectedAssessmentObject()-> PE_AssessmentInProgress {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_AssessmentRejected" , into: managedContext) as! PE_AssessmentInProgress
        return vaccinationCertObj
    }
    
    func deleteExisitingData(entityName:String, predicate:NSPredicate?) {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    managedContext.delete(result)
                }
                try managedContext.save()
            }
        } catch {
            managedContext.rollback()
            print("error executing fetch request: \(error)")
            
        }
    }
    // MARK: - Save Rejected Assessments
    func saveRejectedAssessments(certificationDTOArr:[PE_AssessmentRejectedDTO], loginUserId:String){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        do{
            if certificationDTOArr.count > 0{
                deleteExisitingData(entityName: "PE_RejectedAssessments", predicate: NSPredicate(format:"loginUserId = %@", loginUserId))
                for certificationDTOObj in certificationDTOArr{
                    
                    let moObj = getRejectedAssessmentObject()
                    
                    if let rejectedObj = getRejectedAssessment(result: certificationDTOObj){
                        moObj.assessmentStatus = "Rejected"
                        moObj.visitName = rejectedObj.visitName
                        moObj.visitID = rejectedObj.visitID as NSNumber?
                        moObj.scheduledDate = rejectedObj.scheduledDate
                    }
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
        }
    }
    // MARK: - Fetch Rejected Assessments
    func fetchRejectedAssessment() -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentRejected")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(message)
        }
        return dataArray
    }
    // MARK: - Save Scheduled Assessments
    func saveScheduledAssessments(certificationDTOArr:[ScheduledPEAssessmentsDTO], loginUserId:String) {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        do{
            if certificationDTOArr.count > 0{
                
                deleteExisitingData(entityName: "PE_ScheduledAssessments", predicate: NSPredicate(format:"loginUserId = %@", loginUserId))
                
                for certificationDTOObj in certificationDTOArr{
                    
                    var moObj = getAssessmentObject()
                    convertDtotoMo(userId: loginUserId, dtoObj: certificationDTOObj, moObj: &moObj)
                    if let draftObj = getDraftAssessment(userId: loginUserId, serverAssessmentId: (String(describing: certificationDTOObj.id ?? 0))){
                        moObj.assessmentStatus = "draft"
                        moObj.visitType = draftObj.visitName
                        moObj.visitTypeId = draftObj.visitID as NSNumber?
                        moObj.scheduledDate = draftObj.scheduledDate
                    }
                    let id = (String(describing: certificationDTOObj.id ?? 0))
                    var completed =  CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
                    let filteredArr = completed.filter{
                        $0.serverAssessmentId ?? "" == id
                    }
                    if filteredArr.count > 0{
                        moObj.assessmentStatus = "completed"
                        moObj.visitType = filteredArr[0].visitName
                        moObj.visitTypeId = filteredArr[0].visitID as NSNumber?
                    }
                    
                    let peNewAssessment = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject(serverAssessmentId: (String(describing: certificationDTOObj.id ?? 0)))
                    if peNewAssessment.visitName != nil &&  peNewAssessment.visitName != ""{
                        moObj.visitType = peNewAssessment.visitName
                        moObj.visitTypeId = peNewAssessment.visitID as NSNumber?
                        moObj.scheduledDate = peNewAssessment.scheduledDate
                    }
                    
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
        }
    }
    // MARK: - Update Assessments Status
    func updateAssessmentStatus(status:String = "Schedule",userId:String,serverAssessmentId:String,assessmentobj:PENewAssessment = PENewAssessment()) {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        var vaccinationCertificationArr = [PE_ScheduledAssessments]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ScheduledAssessments")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:" loginUserId = %@  AND id = %@", userId, serverAssessmentId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ScheduledAssessments]
            if vaccinationCertificationArr.count > 0{
                vaccinationCertificationArr[0].assessmentStatus = status
                vaccinationCertificationArr[0].scheduledDate = assessmentobj.scheduledDate
                if let approverId = assessmentobj.selectedTSRID{
                    vaccinationCertificationArr[0].approverId = approverId as NSNumber
                }
                
                if assessmentobj.visitName != nil && assessmentobj.visitName != ""{
                    vaccinationCertificationArr[0].visitType = assessmentobj.visitName
                    vaccinationCertificationArr[0].visitTypeId = assessmentobj.visitID as NSNumber?
                }
            }
            try managedContext.save()
        } catch{
            print(message)
        }
    }
    
    func convertDtotoMoNew(userId:String,dtoObj: PE_AssessmentRejectedDTO, moObj:PEAssessmentRejected ){
        moObj.loginUserId = userId
        if let customerId = dtoObj.customerId {
            moObj.customerId = customerId
        }
        if let customerName = dtoObj.customerName {
            moObj.customerName = customerName
        }
        if let evaluationId = dtoObj.evaluationId {
            moObj.evaluationID = evaluationId
        }
        if let evaluationName = dtoObj.evaluationName {
            moObj.evaluationName = evaluationName
        }
        moObj.assessmentStatus = "Rejected"
        if let id = dtoObj.id {
            moObj.id = id
        }
        if let siteId = dtoObj.siteId {
            moObj.siteId = siteId
        }
        if let siteName = dtoObj.siteName {
            moObj.siteName = siteName
        }
        let dateFormatterObj = DateFormatter()
        dateFormatterObj.timeZone = Calendar.current.timeZone
        dateFormatterObj.locale = Calendar.current.locale
        dateFormatterObj.dateFormat =  Constants.yyyyMMddHHmmss
        moObj.assessmentStatus = dtoObj.statusName
        
    }
    
    ///This function was re-written by Nitin on 13-02-2025 to fix the issue reported by sonarQube
    ///This new function has reduced cognitive complexity from 21 to 15
    func convertDtotoMo(userId: String, dtoObj: ScheduledPEAssessmentsDTO, moObj: inout PE_ScheduledAssessments) {
        moObj.loginUserId = userId
        // Assign numeric values
        if let customerId = dtoObj.customerId {
            moObj.customerId = customerId as NSNumber
        }
        if let year = dtoObj.year {
            moObj.year = year as NSNumber
        }
        if let evaluationId = dtoObj.evaluationId {
            moObj.evaluationId = evaluationId as NSNumber
        }
        if let evaluationTypeId = dtoObj.evaluationTypeId {
            moObj.evaluationTypeId = evaluationTypeId as NSNumber
        }
        if let id = dtoObj.id {
            moObj.id = id as NSNumber
        }
        if let siteId = dtoObj.siteId {
            moObj.siteId = siteId as NSNumber
        }
        if let countryID = dtoObj.countryID {
            moObj.countryID = countryID as NSNumber
        }
        if let visitTypeId = dtoObj.peVisitTypeId {
            moObj.visitTypeId = visitTypeId as NSNumber
        }
        if let approverId = dtoObj.approverId {
            moObj.approverId = approverId as NSNumber
        }
        
        // Assign string values
        moObj.quarter = dtoObj.quarter
        moObj.customerName = dtoObj.customerName
        moObj.evaluationName = dtoObj.evaluationName
        moObj.evaluationTypeName = dtoObj.evaluationTypeName
        moObj.siteName = dtoObj.siteName
        moObj.countryName = dtoObj.countryName
        moObj.assessmentStatus = dtoObj.statusName
        moObj.visitType = dtoObj.peVisitTypeName
        moObj.approverName = dtoObj.approverName

        // Assign boolean field as NSNumber (0 or 1)
        moObj.sanitationEmbrex = (dtoObj.sanitationEmbrex ?? false) ? 1 : 0

        // Convert and assign date values
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss

        moObj.scheduledDate = convertDate(dtoObj.scheduleDate, using: dateFormatter)
        moObj.updatedDate = convertDate(dtoObj.updatedDate?.components(separatedBy: ".").first, using: dateFormatter)
    }

    // Helper function for date conversion
    private func convertDate(_ dateString: String?, using formatter: DateFormatter) -> Date? {
        guard let dateString = dateString else { return nil }
        return formatter.date(from: dateString)
    }
    
    // MARK: - Get Scheduled Assessments
    func getAssesmentsMo(userId:String)->[PE_ScheduledAssessments] {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        var vaccinationCertificationArr = [PE_ScheduledAssessments]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ScheduledAssessments")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:loginAssStatus, userId,"Schedule")
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ScheduledAssessments]
        } catch {
            print(message)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat=Constants.MMddyyyyStr
        vaccinationCertificationArr.sort(by: {
            let date1Obj = dateFormatter.string(from: $0.scheduledDate ?? Date())
            let date2Obj = dateFormatter.string(from: $1.scheduledDate ?? Date())
            
            return date1Obj > date2Obj
        })
        return vaccinationCertificationArr
    }
    
    // MARK: - Get Rejected Assessments
    func getRejectedAssesmentsMo(userId:String)->[PE_AssessmentRejected] {
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
        var vaccinationCertificationArr = [PE_AssessmentRejected]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentRejected")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:loginAssStatus, userId,"Rejected")
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_AssessmentRejected]
        } catch{
            print(message)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat=Constants.MMddyyyyStr
        vaccinationCertificationArr.sort(by: {
            let date1Obj = dateFormatter.string(from: $0.scheduledDate ?? Date())
            let date2Obj = dateFormatter.string(from: $1.scheduledDate ?? Date())
            
            return date1Obj > date2Obj
        })
        return vaccinationCertificationArr
    }
    
    func getVMObj(userId:String)->[PENewAssessment]{
        var assessmentVMArr = [PENewAssessment]()
        let assessmentArr = getAssesmentsMo(userId:userId)
        for assessment in assessmentArr{
            let vmObj = convertDtotoMo( moObj:assessment )
            assessmentVMArr.append(vmObj)
        }
        
        return assessmentVMArr
    }
    
    func getVMRObj(userId:String)->[PENewAssessment] {
        var assessmentVMArr = [PENewAssessment]()
        let assessmentArr = getRejectedAssesmentsMo(userId:userId)
        for assessment in assessmentArr {
            let vmObj = convertDtotoMoNew(moObj:assessment)
            assessmentVMArr.append(vmObj)
        }
        
        return assessmentVMArr
    }
    
    func convertDtotoMo( moObj:PE_ScheduledAssessments )-> PENewAssessment {
        let peObj = PENewAssessment()
        if let userId = moObj.loginUserId{
            peObj.userID = Int(userId)
        }
        peObj.customerId = nil
        if let customerId = moObj.customerId{
            peObj.customerId = (customerId as? Int ?? 0)
        }
        peObj.customerName = moObj.customerName
        peObj.evaluationID = nil
        if let evaluationId = moObj.evaluationId{
            peObj.evaluationID = (evaluationId as? Int ?? 0)
        }
        peObj.evaluationName = moObj.evaluationName
        if let id = moObj.id{
            let strId:String = "\(id)"
            peObj.serverAssessmentId = strId
            
        }
        if let siteId = moObj.siteId{
            peObj.siteId = (siteId as? Int ?? 0)
        }
        peObj.siteName = moObj.siteName
        peObj.scheduledDate = moObj.scheduledDate
        if let extendedMicro = moObj.sanitationEmbrex{
            peObj.sanitationEmbrex = extendedMicro as? Int ?? 0
        }
        
        if let evaluationTypeId = moObj.evaluationTypeId {
            peObj.evaluationID = (evaluationTypeId  as? Int ?? 0)
        }
        if let evaluationTypeName = moObj.evaluationTypeName {
            peObj.evaluationName = evaluationTypeName
        }
        if let visitTypeId = moObj.visitTypeId{
            peObj.visitID = (visitTypeId as? Int ?? 0)
        }
        if let quarter = moObj.quarter {
            peObj.quarter = quarter
        }
        if let year = moObj.year {
            peObj.year = year as? Int ?? 0
        }
        peObj.visitName = moObj.visitType
        if let approverId = moObj.approverId{
            peObj.selectedTSRID = approverId as? Int ?? 0
        }
        peObj.selectedTSR = moObj.approverName
        peObj.updatedDate = moObj.updatedDate
        
        if let countryName = moObj.countryName {
            peObj.countryName = countryName
        }
        if let countryId = moObj.countryID{
            peObj.countryID = (countryId as? Int ?? 0)
        }
        return peObj
        
    }
    
    func convertDtotoMoNew( moObj: PE_AssessmentRejected )-> PENewAssessment{
        let peObj = PENewAssessment()
        if let userId = moObj.loginUserId{
            peObj.userID = Int(userId)
        }
        if let customerId = moObj.customerId{
            peObj.customerId = (customerId as? Int ?? 0)
        }else{
            peObj.customerId = nil
        }
        peObj.customerName = moObj.customerName
        if let evaluationId = moObj.evaluationID{
            peObj.evaluationID = (evaluationId as? Int ?? 0)
        }else{
            peObj.evaluationID = nil
        }
        peObj.evaluationName = moObj.evaluationName
        if let id = moObj.id{
            let strId:String = "\(id)"
            peObj.serverAssessmentId = strId
            
        }
        if let siteId = moObj.siteId{
            peObj.siteId = (siteId as? Int ?? 0)
        }
        peObj.siteName = moObj.siteName
        peObj.scheduledDate = moObj.scheduledDate
        
        if let evaluationTypeId = moObj.evaluationTypeId {
            peObj.evaluationID = (evaluationTypeId  as? Int ?? 0)
        }
        if let visitTypeId = moObj.visitTypeId{
            peObj.visitID = (visitTypeId as? Int ?? 0)
        }
        
        peObj.visitName = moObj.visitType
        if let approverId = moObj.approverId{
            peObj.selectedTSRID = approverId as? Int ?? 0
        }
        peObj.selectedTSR = moObj.approverName
        peObj.updatedDate = moObj.updatedDate
        
        return peObj
        
    }
    
    // MARK: - Get rejected Assessments
    func getRejectedAssessment(result: PE_AssessmentRejectedDTO)->PEAssessmentRejected? {
        let peNewAssessment = PEAssessmentRejected()
        peNewAssessment.userID =  result.userID
        peNewAssessment.customerId = result.customerId
        peNewAssessment.siteId = result.siteId
        peNewAssessment.siteName = result.siteName
        peNewAssessment.customerName = result.customerName
        peNewAssessment.evaluationDate = result.evaluationDate
        peNewAssessment.evaluatorID = result.evaluatorID
        peNewAssessment.visitName =  result.visitName
        peNewAssessment.visitID = result.visitID
        peNewAssessment.evaluationName = result.evaluationName
        peNewAssessment.evaluationID = result.evaluationId
        peNewAssessment.notes = result.notes
        let hatcheryAntibiotics =  result.hatcheryAntibiotics
        peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics == 1 ? 1 : 0
        peNewAssessment.camera = result.camera == 1 ? 1 : 0
        return peNewAssessment
    }
    
    // MARK: - Get Drafted Assessments
    func getDraftAssessment(userId:String, serverAssessmentId:String)->PENewAssessment? {
        var peNewAssessmentArray : [PENewAssessment] = []
        var loginUserId = Int(userId) ?? 0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        _ =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format:"userID == %d AND serverAssessmentId = %@", loginUserId,serverAssessmentId )
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics = result.value(forKey: "hatcheryAntibiotics") as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics == 1 ? 1 : 0
                    let camera = result.value(forKey: "camera")  as? Int
                    peNewAssessment.camera = camera == 1 ? 1 : 0
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.draftID = result.value(forKey: "draftID") as? String ?? ""
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(message)
        }
        if peNewAssessmentArray.count > 0{
            return peNewAssessmentArray[0]
        }
        return nil
    }
    
}

//
//  SanitationEmbrexQuestionMasterDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 08/11/20.
//

import Foundation
import CoreData
import UIKit

class SanitationEmbrexQuestionMasterDAO{
    
    let userIdStr = "userId = %@"
    let userIdAssId = "userId = %@ AND assessmentId = %@"

    static let sharedInstance = SanitationEmbrexQuestionMasterDAO()
    
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getQuestionObj() -> PE_ExtendedPEQuestionMaster{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_ExtendedPEQuestionMaster" , into: managedContext) as! PE_ExtendedPEQuestionMaster
        return vaccinationCertObj
    }
    
    func fetchMasterQuestions(userId:String)->[PE_ExtendedPEQuestionMaster]{
        var vaccinationCertificationArr = [PE_ExtendedPEQuestionMaster]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ExtendedPEQuestionMaster")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:userIdStr, userId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ExtendedPEQuestionMaster]
        } catch{
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        vaccinationCertificationArr.sort(by: {
            let date1Obj = $0.questionId ?? 0
            let date2Obj = $1.questionId ?? 0
            return Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue(date1Obj)) < Unicode.CanonicalCombiningClass(rawValue: Unicode.CanonicalCombiningClass.RawValue(date2Obj))
        })
        return vaccinationCertificationArr
    }
    
    func fetchMasterQuestionById(userId:String, questionId:Int64)->[PE_ExtendedPEQuestionMaster]{
        var vaccinationCertificationArr = [PE_ExtendedPEQuestionMaster]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ExtendedPEQuestionMaster")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND questionId = %i", userId, questionId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ExtendedPEQuestionMaster]
        } catch{
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func deleteExistingSanitationQues(_ assessmentId:String){
        let userId = UserContext.sharedInstance.userDetailsObj?.userId ?? ""
        let predicate = NSPredicate(format:userIdAssId, userId , assessmentId)
        deleteExisitingData(entityName: "PE_ExtendedPEAssessmentQuestions", predicate: predicate ?? NSPredicate())
    }
    
    func deleteExisitingData(entityName:String, predicate:NSPredicate?){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
            //Delete If exists
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
    
    func saveExtendedPEQuestions(userId:String, plateTypeDTO:[ExtendedPECategoryDTO]){
        do{
            if plateTypeDTO.count > 0{
                deleteExisitingData(entityName: "PE_ExtendedPEQuestionMaster", predicate: NSPredicate(format:userIdStr, userId))
                for plateTypeObj in plateTypeDTO{
                    
                    if let assessmentQuestions = plateTypeObj.assessmentQuestions{
                        for question in assessmentQuestions{
                            let moObj = getQuestionObj()
                            convertDTOToMO(dtoObj: question, userId: userId, moObj: moObj, extendedPEObj: plateTypeObj)
                        }
                    }
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
            print("Error while saving Upcoming Certifications in \(type(of: self))")
        }
    }
    
    func convertDTOToMO(dtoObj:AssessmentQuestionsExtendedPEDTO,userId:String, moObj:PE_ExtendedPEQuestionMaster, extendedPEObj:ExtendedPECategoryDTO){
        moObj.userId = userId
        if let categoryId = extendedPEObj.id{
            moObj.categoryId = String(categoryId)
        }
        moObj.categoryName = extendedPEObj.categoryName
        if let evaluationId = extendedPEObj.evaluationId{
            moObj.evaluationId = String(evaluationId)
        }
        
        moObj.maxScore = dtoObj.maxScore as NSNumber?
        moObj.minScore = dtoObj.minScore as NSNumber?
        moObj.questionDescription = dtoObj.assessment
        moObj.questionId = dtoObj.id as NSNumber?
        moObj.isAllowNA = dtoObj.IsAllowNA as NSNumber?
        moObj.qSeqNo = dtoObj.qSeqNo as NSNumber?
        
    }
    
    func getAssessmentQuestionObj() -> PE_ExtendedPEAssessmentQuestions{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_ExtendedPEAssessmentQuestions" , into: managedContext) as! PE_ExtendedPEAssessmentQuestions
        return vaccinationCertObj
    }
    
    func saveAssessmentQuestions(userId:String, assessmentId:String){
        let masterQuestions = fetchMasterQuestions(userId: userId)
        do{
            if masterQuestions.count > 0{
                deleteExisitingData(entityName: "PE_ExtendedPEAssessmentQuestions", predicate: NSPredicate(format:userIdAssId, userId,assessmentId))
                var index = 1
                for questObj in masterQuestions{
                    let moObj = getAssessmentQuestionObj()
                    convertMasterMoToMo(userId: userId, assessmentId: assessmentId, assessmentQuesObj: moObj, masterQuesObj: questObj, index: index)
                    index += 1
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
            print("Error while saving Upcoming Certifications in \(type(of: self))")
        }
    }
    
    func convertMasterMoToMo(userId:String, assessmentId:String,assessmentQuesObj:PE_ExtendedPEAssessmentQuestions, masterQuesObj: PE_ExtendedPEQuestionMaster, index:Int){
        assessmentQuesObj.userId = userId
        assessmentQuesObj.assessmentId = assessmentId
        assessmentQuesObj.categoryId = masterQuesObj.categoryId
        assessmentQuesObj.categoryName = masterQuesObj.categoryName
        assessmentQuesObj.evaluationId = masterQuesObj.evaluationId
        assessmentQuesObj.minScore = masterQuesObj.minScore
        assessmentQuesObj.maxScore = masterQuesObj.maxScore
        assessmentQuesObj.questionDescription = masterQuesObj.questionDescription
        assessmentQuesObj.questionId = masterQuesObj.questionId
        assessmentQuesObj.currentScore = masterQuesObj.maxScore
        assessmentQuesObj.bacteriaCount = 0
        assessmentQuesObj.blueGreenMoldCount = 0
        let dateFormatterObj = CodeHelper.sharedInstance.getDateFormatterObj("")
        dateFormatterObj.dateFormat = "MMddYYYY"
        let date = dateFormatterObj.string(from: Date())
        let sampleId = "E-" + date + "-" + "\(index)"
        assessmentQuesObj.sampleId = sampleId
        if index <= 19{
            assessmentQuesObj.plateTypeDescription = "TSA"
            assessmentQuesObj.plateTypeId = 3
        }else{
            assessmentQuesObj.plateTypeDescription = "MacConkey"
            assessmentQuesObj.plateTypeId = 1
        }
    }
    
    func fetchAssessmentSanitationQuestions(userId:String, assessmentId:String)-> [PE_ExtendedPEQuestion]{
        let vaccinationCertificationArr = fetchAssessmentQuestMO(userId: userId, assessmentId: assessmentId)
        var questAssesArr = [PE_ExtendedPEQuestion]()
        for assessQues in vaccinationCertificationArr{
            let questObj = convertAssessmentMOToVM(moObj:assessQues)
            questAssesArr.append(questObj)
        }
        questAssesArr.sort(by: {
            return $0.questionId ?? "" < $1.questionId ?? ""
        })
        return questAssesArr
    }
    
    func
    fetchAssessmentQuestMO(userId:String, assessmentId:String?) -> [PE_ExtendedPEAssessmentQuestions]{
        var vaccinationCertificationArr = [PE_ExtendedPEAssessmentQuestions]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ExtendedPEAssessmentQuestions")
        fetchRequest.returnsObjectsAsFaults = false
        if assessmentId == nil{
            fetchRequest.predicate = NSPredicate(format:userIdStr , userId)
        }else{
            fetchRequest.predicate = NSPredicate(format:userIdAssId, userId , assessmentId ?? "")
        }
        
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ExtendedPEAssessmentQuestions]
        } catch{
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func convertAssessmentMOToVM(moObj:PE_ExtendedPEAssessmentQuestions)-> PE_ExtendedPEQuestion{
        let questObj = PE_ExtendedPEQuestion()
        questObj.userId = moObj.userId
        questObj.assessmentId = moObj.assessmentId
        if let bacteriaCount = moObj.bacteriaCount{
            questObj.bacteriaCount = bacteriaCount as! Int32
        }
        if let blueGreenMoldCount = moObj.blueGreenMoldCount{
            questObj.blueGreenMoldCount = blueGreenMoldCount as! Int32
        }
        questObj.categoryId = moObj.categoryId
        questObj.categoryName =  moObj.categoryName
        if let currentScore = moObj.currentScore{
            questObj.currentScore =  currentScore as! Int
        }
        questObj.evaluationId = moObj.evaluationId
        if let maxScore = moObj.maxScore{
            questObj.maxScore = maxScore as! Int32
        }
        if let minScore = moObj.minScore{
            questObj.minScore = minScore as! Int32
        }
        questObj.plateTypeDescription = moObj.plateTypeDescription
        if let plateId = moObj.plateTypeId{
            questObj.plateTypeId = "\(plateId)"
        }
        questObj.questionDescription = moObj.questionDescription
        if let qId = moObj.questionId{
            questObj.questionId = "\(qId)"
        }
        questObj.userComments = moObj.userComments
        questObj.sampleId = moObj.sampleId
        return questObj
    }
    
    func updateAssessmentQuestion(userId:String,assessmentId:String,questionId:Int64,questionVM: PE_ExtendedPEQuestion){
        let questArr = fetchAssessmentQuestionById(userId: userId, assessmentId: assessmentId, questionId: questionId)
        do {
            for quest in questArr{
                updateAssessmentVMQuesObj(questObj: quest, moObj: questionVM)
            }
            try managedContext.save()
        } catch{
            managedContext.rollback()
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
    }
    
    //moObj -> VM, questObj
    func updateAssessmentVMQuesObj(questObj:PE_ExtendedPEAssessmentQuestions, moObj:PE_ExtendedPEQuestion){
        //let questObj = PE_ExtendedPEQuestion()
        questObj.userId = moObj.userId
        questObj.assessmentId = moObj.assessmentId
        questObj.bacteriaCount = moObj.bacteriaCount as NSNumber?
        questObj.blueGreenMoldCount = moObj.blueGreenMoldCount as NSNumber?
        questObj.categoryId = moObj.categoryId
        questObj.categoryName =  moObj.categoryName
        questObj.currentScore = moObj.currentScore as NSNumber?
        questObj.evaluationId = moObj.evaluationId
        questObj.maxScore = moObj.maxScore  as NSNumber?
        questObj.minScore = moObj.minScore  as NSNumber?
        questObj.plateTypeDescription = moObj.plateTypeDescription
        if let plateTypeId = moObj.plateTypeId{
            questObj.plateTypeId = Int64(plateTypeId) as NSNumber?
        }
        questObj.questionDescription = moObj.questionDescription
        if let questionId = moObj.questionId{
            questObj.questionId = Int64(questionId) as NSNumber?
        }
        questObj.userComments = moObj.userComments
        questObj.sampleId = moObj.sampleId
    }
    
    func fetchAssessmentQuestionById(userId:String,assessmentId:String,questionId:Int64)->[PE_ExtendedPEAssessmentQuestions]{
        var vaccinationCertificationArr = [PE_ExtendedPEAssessmentQuestions]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ExtendedPEAssessmentQuestions")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND assessmentId = %@ AND questionId = %i", userId , assessmentId,questionId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_ExtendedPEAssessmentQuestions]
        } catch{
            // managedContext.rollback()
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func saveServiceResponse(assessmentId:String, userId:String, dtoArr:[PESanitationDTO]){
        let questArr =  fetchAssessmentQuestMO(userId: userId, assessmentId: assessmentId)
        if questArr.count > 0{
            deleteExisitingData(entityName: "PE_ExtendedPEAssessmentQuestions", predicate: NSPredicate(format: userIdAssId, userId, assessmentId))
            do{
                for dto in dtoArr{
                    storeQuesDtoToMo(userId: userId, assessmentId: assessmentId, moObj: getAssessmentQuestionObj(), dtoObj: dto)
                }
                try managedContext.save()
            }catch{
                managedContext.rollback()
            }
            //Data Exists Don't do anytihing
        }else{
            do{
                for dto in dtoArr{
                    storeQuesDtoToMo(userId: userId, assessmentId: assessmentId, moObj: getAssessmentQuestionObj(), dtoObj: dto)
                }
                try managedContext.save()
            }catch{
                managedContext.rollback()
            }
            //InsertNewRecords
        }
        
    }
    
    func storeQuesDtoToMo(userId:String, assessmentId:String, moObj:PE_ExtendedPEAssessmentQuestions, dtoObj:PESanitationDTO){
        moObj.assessmentId = assessmentId
        moObj.userId = userId
        moObj.bacteriaCount = dtoObj.Baacteria as NSNumber?
        moObj.blueGreenMoldCount = dtoObj.BlueGreenMold as NSNumber?
        moObj.currentScore =  dtoObj.Score as NSNumber?
        moObj.plateTypeDescription = dtoObj.PlateTypeName
        moObj.plateTypeId = dtoObj.PlateTypeId as NSNumber?
        moObj.userComments = dtoObj.Comments
        moObj.sampleId = dtoObj.SampleNo
        moObj.questionId = dtoObj.AssessmentId as NSNumber?
        if moObj.questionId != nil{
            let questionArr = fetchMasterQuestionById(userId: userId, questionId: moObj.questionId as! Int64)
            if questionArr.count > 0{
                moObj.questionDescription = questionArr[0].questionDescription
            }
        }
    }
    
    func sendExtendedPEFilledDTO(userId:String,assessmentId:String)->[PESanitationDTO]{
        let filledArr = fetchAssessmentQuestMO(userId: userId, assessmentId: assessmentId)
        var dtoArr = [PESanitationDTO]()
        for filledQuesObj in filledArr{
            let dtoObj = convertMoToDTO(moObj: filledQuesObj)
            dtoArr.append(dtoObj)
        }
        return dtoArr
    }
    
    func convertMoToDTO(moObj:PE_ExtendedPEAssessmentQuestions)-> PESanitationDTO{
        let dtoObj = PESanitationDTO()
        
        if let assessmentId = moObj.assessmentId{
            dtoObj.AssessmentDetailId =  Int(assessmentId)
        }
        let dateFormateerObj = CodeHelper.sharedInstance.getDateFormatterObj("")
        dtoObj.CreatedAt = dateFormateerObj.string(from: Date())
        if let qId = moObj.questionId{
            dtoObj.AssessmentId =  Int(qId)
        }
        dtoObj.Baacteria = moObj.bacteriaCount as? Int ?? 0
        dtoObj.BlueGreenMold = moObj.blueGreenMoldCount as? Int ?? 0
        dtoObj.Comments = moObj.userComments
        if let plateTypeId = moObj.plateTypeId{
            dtoObj.PlateTypeId =  plateTypeId as! Int
            if plateTypeId == 0{
                dtoObj.PlateTypeId = nil
            }
        }
        dtoObj.PlateTypeName = moObj.plateTypeDescription
        dtoObj.SampleNo = moObj.sampleId
        dtoObj.Score = moObj.currentScore as! Int
        let arr = dtoObj.SampleNo?.components(separatedBy: "-")
        if arr != nil &&  arr!.count > 0{
            dtoObj.PlateNo = Int(arr![arr!.count-1])
        }
        dtoObj.CreatedBy = Int( UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        return dtoObj
    }
    
    
}

//
//  QuestionnaireDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 15/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final  public class QuestionnaireDAO{
    private init(){print("Initializer")}
    static let sharedInstance = QuestionnaireDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    let userIdStr = "userId = %@"
    
    
    fileprivate func handleQuestionCategories(_ questTypeObj: CertificateQuestionTypesInternalDTO, _ userId: String, _ moQuestTypeObj: VaccinationQuestionTypes) {
        if let questionCategoriesObj = questTypeObj.questionCategories {
            for questCategory in questionCategoriesObj{
                let questCategoryMOObj = getVaccinationQuestionsCategoryObj()
                questCategoryMOObj.categoryId = questCategory.catId?.description
                questCategoryMOObj.categoryName = questCategory.categorieName
                questCategoryMOObj.typeName = questTypeObj.typeName
                questCategoryMOObj.typeId = questTypeObj.typeId?.description
                questCategoryMOObj.userId = userId
                
                if let questions = questCategory.moduleAssessments {
                    for questionObj in questions{
                        let questionMOObj = getVaccinationQuestionsObj()
                        questionMOObj.userId = userId
                        questionMOObj.questionDescription = questionObj.assessment
                        questionMOObj.categoryId
                        = questCategory.catId?.description
                        questionMOObj.categoryName = questCategory.categorieName
                        questionMOObj.questionId = questionObj.id?.description
                        questionMOObj.typeId = questTypeObj.typeId?.description
                        questionMOObj.typeName = questTypeObj.typeName
                        questionMOObj.sequenceNo = questionObj.sequenceNo as NSNumber?
                        questionMOObj.questionType = questionObj.types
                        
                        questCategoryMOObj.addToQuestions(questionMOObj)
                    }
                }
                moQuestTypeObj.addToQuestionCategories(questCategoryMOObj)
            }
        }
    }
    
     private func convertDTOtoMO(dtoObj: CertificationQuestionTypesDTO, userId: String) {
        if let dtoObjQuestTypes = dtoObj.certificateQuestionTypes, dtoObjQuestTypes.count > 0 {
            for questTypeObj in dtoObjQuestTypes {
                let moQuestTypeObj = getVaccinationQuestionsTypeObj()
                moQuestTypeObj.userId = userId
                moQuestTypeObj.typeid = questTypeObj.typeId?.description
                moQuestTypeObj.typename = questTypeObj.typeName
                
                handleQuestionCategories(questTypeObj, userId, moQuestTypeObj)
            }
        }
    }

    
    
    private func convertMotoVM(moObj:[VaccinationQuestionTypes])-> QuestionnaireVM{
        
        var questionnaireVMObj = QuestionnaireVM()
        var questionTypeArr = [VaccinationQuestionTypeVM]()
        for questionTypeMoObj in moObj{
            questionTypeArr.append(getQuestionTypeVMObj(questionTypeMoObj))
        }
        questionnaireVMObj.questionTypeObj = questionTypeArr
        return questionnaireVMObj
    }
    
    func getQuestionTypeVMObj(_ moObj:VaccinationQuestionTypes)-> VaccinationQuestionTypeVM{
        
        var questionTypeObj = VaccinationQuestionTypeVM()
        questionTypeObj.typeId = moObj.typeid
        questionTypeObj.typeName = moObj.typename
        questionTypeObj.userId = moObj.userId
        
        var questionCategoryArr = [VaccinationQuestionCategoryVM]()
        if let questionCategories = moObj.questionCategories?.allObjects as? Array<VaccinationQuestionCategories>{
            for questionCatObj in questionCategories{
                questionCategoryArr.append(getQuestionCategoryVMObj(questionCatObj))
            }
        }
        questionTypeObj.questionCategories = questionCategoryArr
        
        
        
        
        return questionTypeObj
    }
    
    func getQuestionCategoryVMObj(_ moObj:VaccinationQuestionCategories)-> VaccinationQuestionCategoryVM{
        var vaccinationObj  = VaccinationQuestionCategoryVM()
        vaccinationObj.categoryId = moObj.categoryId
        vaccinationObj.categoryName = moObj.categoryName
        vaccinationObj.typeId = moObj.typeId
        
        vaccinationObj.typeName = moObj.typeName
        vaccinationObj.userId = moObj.userId
        var questionArr = [VaccinationQuestionVM]()
        
        if let questions = moObj.questions?.allObjects as? Array<VaccinationQuestions>{
            for question in questions{
                questionArr.append(getQuestionVMObj(question))
            }
        }
        
        vaccinationObj.questionArr = questionArr
        vaccinationObj.questionArr?.sort {first,second in
            (first.questionDescription?.lowercased())! < (second.questionDescription?.lowercased())!
        }
        
        return vaccinationObj
    }
    
    
    
    func getQuestionVMObj(_ moObj:VaccinationQuestions)-> VaccinationQuestionVM{
        var questionVMObj = VaccinationQuestionVM()
        questionVMObj.categoryId = moObj.categoryId
        questionVMObj.categoryName = moObj.categoryName
        questionVMObj.questionDescription = moObj.questionDescription
        questionVMObj.questionType  = moObj.questionType
        questionVMObj.questionId = moObj.questionId
        questionVMObj.typeId = moObj.typeId
        questionVMObj.typeName = moObj.typeName
        questionVMObj.userId = moObj.userId
       questionVMObj.sequenceNo = moObj.sequenceNo as? Int
        return questionVMObj
    }
    
    
    func saveQuestionData(dtoObj: CertificationQuestionTypesDTO, userId: String) {
        do {
            if let certificateQuestionTypes = dtoObj.certificateQuestionTypes, certificateQuestionTypes.count > 0, !checkIfQuestionnaireeDataExists(userId: userId) {
                deleteVaccinationQuestions(userId: userId)
                convertDTOtoMO(dtoObj: dtoObj, userId: userId)
                SyncStatusDAO.sharedInstance.saveSyncStatus(userLoginId: userId, evalParam1: nil, evalParam2: nil, evalParam1Id: nil, evalParam2Id: nil, entityName: EntityName.Questionnaire.rawValue)
                try managedContext.save()
            }
        } catch {
            managedContext.rollback()
            debugPrint("Error while saveQuestionData in \(type(of: self))")
        }
    }
    
    
    func getVaccinationQuestionsCategoryObj() ->VaccinationQuestionCategories{
        let vaccinationQuestionCategoriesObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationQuestionCategories" , into: managedContext) as! VaccinationQuestionCategories
        return vaccinationQuestionCategoriesObj
    }
    
    func getVaccinationQuestionsTypeObj() ->VaccinationQuestionTypes{
        let vaccinationQuestionTypeObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationQuestionTypes" , into: managedContext) as! VaccinationQuestionTypes
        
        return vaccinationQuestionTypeObj
    }
    
    func getVaccinationQuestionsObj() ->VaccinationQuestions{
        let vaccinationQuestionObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationQuestions" , into: managedContext) as! VaccinationQuestions
        
        return vaccinationQuestionObj
    }
    
    func deleteExisitingData(entityName:String, predicate:NSPredicate?){
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
            debugPrint("error executing fetch request: \(error)")
            
        }
    }
    
    func fetchQuestionnaireData(userId:String, typeId:String? )->QuestionnaireVM?{
        var questionnaireVM: QuestionnaireVM?
        questionnaireVM =  convertMotoVM(moObj:fetchQuestionnaireMOData(userId:userId, typeId: typeId))
        return questionnaireVM
    }
    
    func fetchQuestionnaireMOData(userId:String, typeId:String?) -> [VaccinationQuestionTypes]{
        var questionTypesArr = [VaccinationQuestionTypes]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationQuestionTypes")
        fetchRequest.returnsObjectsAsFaults = false
        if typeId != nil && typeId != "" {
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND typeid = %@", userId, typeId!)
            
        } else{
            fetchRequest.predicate = NSPredicate(format:userIdStr, userId)
        }
        
        do {
            questionTypesArr = try managedContext.fetch(fetchRequest) as! [VaccinationQuestionTypes]
        } catch{
            debugPrint("Error while fetching Employees in \(type(of: self))")
        }
        return questionTypesArr
    }
    
    func checkIfQuestionnaireeDataExists(_ forceDelete:Bool = false, userId:String) -> Bool{
        
        var response = false
        if forceDelete{
            
            deleteVaccinationQuestions(userId: userId)
            response = false
        } else{
          
            
            if let questionAireData = fetchQuestionnaireData(userId: userId, typeId: nil),
               let questionTypesArr = questionAireData.questionTypeObj, questionTypesArr.count > 0 {
                response = true
            }
            
            
        }
        return response
    }
    
    func deleteVaccinationQuestions(userId:String){
        deleteExisitingData(entityName: "VaccinationQuestionTypes", predicate: NSPredicate(format:userIdStr, userId))
        deleteExisitingData(entityName: "VaccinationQuestionCategories", predicate: NSPredicate(format:userIdStr, userId))
        deleteExisitingData(entityName: "VaccinationQuestions", predicate: NSPredicate(format:userIdStr, userId))
    }
    
}

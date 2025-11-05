//
//  UserFilledQuestionnaireDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 01/05/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final public  class UserFilledQuestionnaireDAO{
    private init(){}
    static let sharedInstance = UserFilledQuestionnaireDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getVaccinationQuestionsCategoryObj() ->VaccinationFilledQuestionCategories{
        let vaccinationQuestionCategoriesObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationFilledQuestionCategories" , into: managedContext) as! VaccinationFilledQuestionCategories
        return vaccinationQuestionCategoriesObj
    }
    
    func getVaccinationQuestionsTypeObj() ->VaccinationFilledQuestionTypes{
        let vaccinationQuestionTypeObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationFilledQuestionTypes" , into: managedContext) as! VaccinationFilledQuestionTypes
        return vaccinationQuestionTypeObj
    }
    
    func getVaccinationQuestionsObj() ->VaccinationFilledQuetions{
        let vaccinationQuestionObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationFilledQuetions" , into: managedContext) as! VaccinationFilledQuetions
        
        return vaccinationQuestionObj
    }
    
    private func convertQuestMOtoMO(dtoObjQuestTypes: [VaccinationQuestionTypes], userId:String, certificationId:String){
        
        if dtoObjQuestTypes.count  > 0{
            for questTypeObj in dtoObjQuestTypes{
                let moQuestTypeObj = getVaccinationQuestionsTypeObj()
                moQuestTypeObj.userId = userId
                moQuestTypeObj.typeid = questTypeObj.typeid
                moQuestTypeObj.typename = questTypeObj.typename
                moQuestTypeObj.certificationId = certificationId
                
                if let questionCategoriesObj = questTypeObj.questionCategories?.allObjects as? Array<VaccinationQuestionCategories>{
                    
                    for questCategory in questionCategoriesObj{
                        let questCategoryMOObj = getVaccinationQuestionsCategoryObj()
                        questCategoryMOObj.certificationId = certificationId
                        questCategoryMOObj.categoryId =    questCategory.categoryId
                        questCategoryMOObj.categoryName = questCategory.categoryName
                        
                        questCategoryMOObj.typeName = questTypeObj.typename
                        questCategoryMOObj.typeId
                        = questTypeObj.typeid
                        
                        questCategoryMOObj.userId = userId
                        
                        if let questions = questCategory.questions?.allObjects as? Array<VaccinationQuestions>{
                            
                            for questionObj in questions{
                                let questionMOObj = getVaccinationQuestionsObj()
                                questionMOObj.certificationId = certificationId
                                questionMOObj.userId = userId
                                questionMOObj.questionDescription = questionObj.questionDescription
                                questionMOObj.categoryId
                                = questCategory.categoryId
                                questionMOObj.categoryName = questCategory.categoryName
                                questionMOObj.questionId = questionObj.questionId
                                questionMOObj.typeId = questTypeObj.typeid
                                questionMOObj.typeName = questTypeObj.typename
                                
                                questionMOObj.sequenceNo = questionObj.sequenceNo
                                questionMOObj.questionType
                                = questionObj.questionType
                                
                                questCategoryMOObj.addToQuestions(questionMOObj)
                                
                            }
                        }
                        moQuestTypeObj.addToQuestionCategories(questCategoryMOObj)
                    }
                }
            }
        }
        
        
    }
    
    private func convertMotoVM(moObj:[VaccinationFilledQuestionTypes])-> QuestionnaireVM{
        var questionnaireVMObj = QuestionnaireVM()
        var questionTypeArr = [VaccinationQuestionTypeVM]()
        for questionTypeMoObj in moObj{
            questionTypeArr.append(getQuestionTypeVMObj(questionTypeMoObj))
        }
        
        questionnaireVMObj.questionTypeObj = questionTypeArr
        return questionnaireVMObj
    }
    
    func getQuestionTypeVMObj(_ moObj:VaccinationFilledQuestionTypes)-> VaccinationQuestionTypeVM{
        
        var questionTypeObj = VaccinationQuestionTypeVM()
        questionTypeObj.typeId = moObj.typeid
        questionTypeObj.typeName = moObj.typename
        questionTypeObj.userId = moObj.userId
        questionTypeObj.certificationId = moObj.certificationId
        
        var questionCategoryArr = [VaccinationQuestionCategoryVM]()
        if var questionCategories = moObj.questionCategories?.allObjects as? Array<VaccinationFilledQuestionCategories>{
            if questionCategories[0].categoryName == "Aseptic Technique & Vaccine Application" {
                questionCategories.swapAt(0, 1)
            }
            for questionCatObj in questionCategories{
                questionCategoryArr.append(getQuestionCategoryVMObj(questionCatObj))
            }
        }
        questionTypeObj.questionCategories = questionCategoryArr
        
        if moObj.typeid == "12" && questionTypeObj.questionCategories?[0].categoryName == "Vaccine Preparation & Sterility" {
            return questionTypeObj
        }
        else
        {
            questionTypeObj.questionCategories?.sort {first,second in
                if first.categoryName != nil && second.categoryName != nil{
                    return (first.categoryName?.lowercased())! < (second.categoryName?.lowercased())!
                }
                return false
                
            }
        }
        
        
        
        
        
        return questionTypeObj
    }
    
    func getQuestionCategoryVMObj(_ moObj:VaccinationFilledQuestionCategories)-> VaccinationQuestionCategoryVM{
        var vaccinationObj  = VaccinationQuestionCategoryVM()
        vaccinationObj.categoryId = moObj.categoryId
        vaccinationObj.categoryName = moObj.categoryName
        vaccinationObj.typeId = moObj.typeId
        vaccinationObj.certificationId = moObj.certificationId
        
        vaccinationObj.typeName = moObj.typeName
        vaccinationObj.userId = moObj.userId
        var questionArr = [VaccinationQuestionVM]()
        
        if let questions = moObj.questions?.allObjects as? Array<VaccinationFilledQuetions>{
            for question in questions{
                questionArr.append(getQuestionVMObj(question))
            }
        }
        
        
        
        if moObj.typeId == "12" {
            vaccinationObj.questionArr = questionArr
            
            
            vaccinationObj.questionArr?.sort {first,second in
                (first.sequenceNo) ?? 0 < (second.sequenceNo) ?? 0
            }
            vaccinationObj.employees = getCategoryEmployees(certificationId: moObj.certificationId ?? "", userId: moObj.userId ?? "", categoryId: moObj.categoryId ?? "", typeId: moObj.typeId ?? "")
            return vaccinationObj
        }
        else
        {
            vaccinationObj.questionArr = questionArr
            vaccinationObj.questionArr?.sort {first,second in
                (first.questionDescription?.lowercased())! < (second.questionDescription?.lowercased())!
            }
            
        }
        
        vaccinationObj.employees = getCategoryEmployees(certificationId: moObj.certificationId ?? "", userId: moObj.userId ?? "", categoryId: moObj.categoryId ?? "", typeId: moObj.typeId ?? "")
        
        return vaccinationObj
    }
    
    func getCategoryEmployees(certificationId:String, userId:String, categoryId:String, typeId:String) -> [VaccinationEmployeeVM]{
        var empArr = [VaccinationEmployeeVM]()
        let catEmpBridgeArr = AddEmployeesDAO.sharedInstance.fetchEmpByCatId(catId:categoryId, typeId:typeId, userId:userId, certificationId:certificationId)
        var predicateList = [NSPredicate]()
        for empBridgeObj in catEmpBridgeArr{
            let predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND employeeId = %@", userId, certificationId, empBridgeObj.empId ?? "")
            predicateList.append(predicate)
            
        }
        empArr = AddEmployeesDAO.sharedInstance.getAllCertEmployees(predicateArr:predicateList)
        return empArr
        
    }
    
    func getQuestionVMObj(_ moObj:VaccinationFilledQuetions) -> VaccinationQuestionVM{
        var questionVMObj = VaccinationQuestionVM()
        questionVMObj.categoryId = moObj.categoryId
        questionVMObj.categoryName = moObj.categoryName
        questionVMObj.questionDescription = moObj.questionDescription
        questionVMObj.questionType  = moObj.questionType
        questionVMObj.questionId = moObj.questionId
        questionVMObj.typeId = moObj.typeId
        questionVMObj.typeName = moObj.typeName
        questionVMObj.userId = moObj.userId
        questionVMObj.certificationId  = moObj.certificationId
        questionVMObj.selectedResponse = moObj.userSelectedResponse as? Bool ?? false
        questionVMObj.userComments = moObj.userComments
        questionVMObj.locationPhone = moObj.locationPhone
        questionVMObj.sequenceNo = moObj.sequenceNo as? Int
        return questionVMObj
    }
    
    func fetchQuestionnaireData(userId:String, certificationId:String )->QuestionnaireVM?{
        var questionnaireVM: QuestionnaireVM?
        questionnaireVM =  convertMotoVM(moObj:fetchQuestionnaireMOData(userId:userId, certificationId: certificationId))
        return questionnaireVM
    }
    
    func fetchQuestionnaireMOData(userId:String, certificationId:String) -> [VaccinationFilledQuestionTypes]{
        var questionTypesArr = [VaccinationFilledQuestionTypes]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationFilledQuestionTypes")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId)
        do {
            questionTypesArr = try managedContext.fetch(fetchRequest) as! [VaccinationFilledQuestionTypes]
            
        } catch{
            debugPrint("Error while fetching Employees in \(type(of: self))")
        }
        return questionTypesArr
    }
    
    
    func saveQuestionData( userId:String, certificationId:String, isSafetyCert:Bool = false){
        do{
            
            if !checkIfQuestionnaireeDataExists(userId: userId, certificationId: certificationId) && !(SyncStatusDAO.sharedInstance.checkIfRecordExists(for: EntityName.UserFilledQuestionnaire.rawValue, userId:userId, siteId:certificationId, customerId: nil, evalParam1: EntityParameters.certificationId.rawValue, evalParam2:nil) != nil){
                deleteVaccinationQuestions(userId: userId, certificationId: certificationId)
                if isSafetyCert{
                    let masterListQuestTypes = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_QUESTION_TYPE_ID)
                    `convertQuestMOtoMO`(dtoObjQuestTypes: masterListQuestTypes, userId: userId, certificationId: certificationId)
                    
                    
                } else{
                    let masterListQuestTypesSafety = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: VaccinationConstants.LookupMaster.SAFETY_AWARENESS_QUESTION_TYPE_ID)
                    convertQuestMOtoMO(dtoObjQuestTypes: masterListQuestTypesSafety, userId: userId, certificationId: certificationId)
                    let masterListQuestTypes = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: VaccinationConstants.LookupMaster.OPERATOR_CERTIFICATION_QUESTION_TYPE_ID)
                    convertQuestMOtoMO(dtoObjQuestTypes: masterListQuestTypes, userId: userId, certificationId: certificationId)
                    
                    let masterListQuestTypesVaccineMixing = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: VaccinationConstants.LookupMaster.VACCINE_MIXING_TYPE_ID)
                    `convertQuestMOtoMO`(dtoObjQuestTypes: masterListQuestTypesVaccineMixing, userId: userId, certificationId: certificationId)
                    
                }
                
                
                SyncStatusDAO.sharedInstance.saveSyncStatus(userLoginId: userId, evalParam1: EntityParameters.certificationId.rawValue , evalParam2: nil, evalParam1Id: nil, evalParam2Id: nil, entityName: EntityName.UserFilledQuestionnaire.rawValue)
                try managedContext.save()
            }
            
        } catch{
            managedContext.rollback()
            debugPrint("Error while saveQuestionData in \(type(of: self))")
        }
    }
    
    func checkIfQuestionnaireeDataExists(_ forceDelete:Bool = false, userId:String, certificationId:String) -> Bool{
        
        var response = false
        if forceDelete{
            
            deleteVaccinationQuestions(userId: userId, certificationId: certificationId)
            response = false
        } else{
            if  fetchQuestionnaireMOData(userId:userId, certificationId: certificationId).count > 0{
                response = true
            }
        }
        return response
    }
    
    func deleteVaccinationQuestions(userId:String, certificationId:String){
        deleteExisitingData(entityName: "VaccinationFilledQuestionTypes", predicate: NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId))
        deleteExisitingData(entityName: "VaccinationFilledQuetions", predicate: NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId))
        deleteExisitingData(entityName: "VaccinationFilledQuestionCategories", predicate: NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId))
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
            debugPrint("error executing fetch request: \(error)")
            
        }
    }
    
    func getUserQuestionnaire(userId:String, certificationId:String,quesId:String)->VaccinationFilledQuetions {
        var questionArr = [VaccinationFilledQuetions]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationFilledQuetions")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@ AND questionId = %@", userId, certificationId,quesId)
        
        do {
            questionArr = try managedContext.fetch(fetchRequest) as! [VaccinationFilledQuetions]
            return questionArr[0]
        } catch{
            debugPrint("Error while fetching User Questionnaire Data in \(type(of: self))")
        }
        return getVaccinationQuestionsObj()
    }
    
    func convertQuestVMtoMO(moObj: VaccinationFilledQuetions, vmObj:VaccinationQuestionVM){
        
        moObj.categoryId = vmObj.categoryId
        moObj.categoryName = vmObj.categoryName
        moObj.questionDescription = vmObj.questionDescription
        moObj.questionType  = vmObj.questionType
        moObj.questionId = vmObj.questionId
        moObj.typeId = vmObj.typeId
        moObj.typeName = vmObj.typeName
        moObj.userId = vmObj.userId
        moObj.certificationId  = vmObj.certificationId
        moObj.userSelectedResponse  = vmObj.selectedResponse as NSNumber
        moObj.userComments = vmObj.userComments
        moObj.locationPhone = vmObj.locationPhone
        moObj.sequenceNo = vmObj.sequenceNo as NSNumber?
    }
    
    func updateQuestionUserResponse(vmObj:VaccinationQuestionVM)-> VaccinationQuestionVM{
        let questObj = getUserQuestionnaire(userId:vmObj.userId ?? "", certificationId:vmObj.certificationId ?? "",quesId:vmObj.questionId ?? "")
        do {
            convertQuestVMtoMO(moObj: questObj, vmObj:vmObj)
            
            try managedContext.save()
        } catch {
            debugPrint(" Failed at updateQuestionUserResponse \(type(of: self))")
            managedContext.rollback()
        }
        return getQuestionVMObj(questObj)
    }
    
    private func convertQuestDTOtoMO( userId:String, certificationId:String, operatorCert:[GetSubmittedOperatorCertificationDTO]?, safetyCert:[GetSubmittedSafetyCertificationDTO]?, vaccineMixingCert:[GetSubmittedVaccineMixingCertificationDTO]? , shippingDetails : [ShippingAddressDTO]?){
        
        if operatorCert != nil && operatorCert!.count  > 0{
            let moQuestTypeObj = getVaccinationQuestionsTypeObj()
            moQuestTypeObj.userId = userId
            if let typeId = operatorCert?[0].typeID{
                moQuestTypeObj.typeid = String(typeId)
            }
            moQuestTypeObj.certificationId = certificationId
            
            for questCategory in operatorCert!{
                let questCategoryMOObj = getVaccinationQuestionsCategoryObj()
                questCategoryMOObj.certificationId = certificationId
                questCategoryMOObj.categoryName = questCategory.categorieName
                
                if let typeId = operatorCert?[0].typeID{
                    questCategoryMOObj.typeId = String(typeId)
                }
                
                if let categoryId = questCategory.catID{
                    questCategoryMOObj.categoryId = String(categoryId)
                }
                questCategoryMOObj.userId = userId
                if let questions = questCategory.moduleAssessments{
                    
                    for questionObj in questions{
                        let questionMOObj = getVaccinationQuestionsObj()
                        questionMOObj.certificationId = certificationId
                        questionMOObj.userId = userId
                        questionMOObj.questionDescription = questionObj.assessment
                        
                        if let qSeq = questionObj.sequenceNo{
                            
                            
                            questionMOObj.sequenceNo = ((qSeq)) as NSNumber?
                        }
                        
                        
                        if let typeId = operatorCert?[0].typeID{
                            questionMOObj.typeId = String(typeId)
                        }
                        
                        if let categoryId = questCategory.catID{
                            questionMOObj.categoryId = String(categoryId)
                        }
                        questionMOObj.categoryName = questCategory.categorieName
                        if let qId = questionObj.id{
                            
                            questionMOObj.questionId = String(qId)
                        }
                        questionMOObj.questionType  = questionObj.types
                        questionMOObj.userComments  = questionObj.comments
                        questionMOObj.userSelectedResponse  = questionObj.answer as NSNumber?
                        questCategoryMOObj.addToQuestions(questionMOObj)
                        
                    }
                }
                if let attendees = questCategory.attendeeList{
                    for attendee in attendees{
                        if let typeId = operatorCert?[0].typeID, let categoryId = questCategory.catID{
                            
                            AddEmployeesDAO.sharedInstance.linkEmployeeToQuestionnaireById(empId: attendee.text ?? "", userId: userId, certificationId: certificationId, quesTypeId: String(typeId), quesCategoryId: String(categoryId))
                        }
                    }
                }
                moQuestTypeObj.addToQuestionCategories(questCategoryMOObj)
            }
        }
        
        if safetyCert != nil && safetyCert!.count  > 0{
            
            let moQuestTypeObj = getVaccinationQuestionsTypeObj()
            moQuestTypeObj.userId = userId
            if let typeId = safetyCert?[0].typeId{
                moQuestTypeObj.typeid = String(typeId)
            }
            moQuestTypeObj.certificationId = certificationId
            
            for questCategory in safetyCert!{
                let questCategoryMOObj = getVaccinationQuestionsCategoryObj()
                questCategoryMOObj.certificationId = certificationId
                questCategoryMOObj.categoryName = questCategory.categorieName
                
                if let typeId = safetyCert?[0].typeId{
                    questCategoryMOObj.typeId = String(typeId)
                }
                
                if let categoryId = questCategory.catId{
                    questCategoryMOObj.categoryId = String(categoryId)
                }
                
                questCategoryMOObj.userId = userId
                
                if let questions = questCategory.moduleAssessments{
                    
                    for questionObj in questions{
                        let questionMOObj = getVaccinationQuestionsObj()
                        questionMOObj.certificationId = certificationId
                        questionMOObj.userId = userId
                        questionMOObj.questionDescription = questionObj.assessment
                        if let typeId = safetyCert?[0].typeId{
                            questionMOObj.typeId = String(typeId)
                        }
                        
                        if let categoryId = questCategory.catId{
                            questionMOObj.categoryId = String(categoryId)
                        }
                        questionMOObj.categoryName = questCategory.categorieName
                        if let qId = questionObj.id{
                            
                            questionMOObj.questionId = String(qId)
                        }
                        
                        if let qSeq = questionObj.sequenceNo{
                            
                            questionMOObj.sequenceNo = ((qSeq)) as NSNumber?
                        }
                        questionMOObj.questionType  = questionObj.types
                        questionMOObj.userComments  = questionObj.comments
                        questionMOObj.locationPhone = questionObj.locationPhone
                        questionMOObj.userSelectedResponse  = questionObj.answer as NSNumber?
                        questCategoryMOObj.addToQuestions(questionMOObj)
                        
                    }
                }
                if let attendees = questCategory.attendeeList{
                    for attendee in attendees{
                        if let typeId = safetyCert?[0].typeId, let categoryId = questCategory.catId{
                            
                            AddEmployeesDAO.sharedInstance.linkEmployeeToQuestionnaireById(empId: attendee.text ?? "", userId: userId, certificationId: certificationId, quesTypeId: String(typeId), quesCategoryId: String(categoryId))
                        }
                    }
                }
                moQuestTypeObj.addToQuestionCategories(questCategoryMOObj)
            }
        }
        
        
        if vaccineMixingCert != nil && vaccineMixingCert!.count  > 0{
            
            let moQuestTypeObj = getVaccinationQuestionsTypeObj()
            moQuestTypeObj.userId = userId
            if let typeId = vaccineMixingCert?[0].typeId{
                moQuestTypeObj.typeid = String(typeId)
            }
            moQuestTypeObj.certificationId = certificationId
          
            for questCategory in vaccineMixingCert!{
                let questCategoryMOObj = getVaccinationQuestionsCategoryObj()
                questCategoryMOObj.certificationId = certificationId
                questCategoryMOObj.categoryName = questCategory.categorieName
                
                if let typeId = vaccineMixingCert?[0].typeId{
                    questCategoryMOObj.typeId = String(typeId)
                }
                
                if let categoryId = questCategory.catId{
                    questCategoryMOObj.categoryId = String(categoryId)
                }
                
                questCategoryMOObj.userId = userId
                
                if let questions = questCategory.moduleAssessments{
                    
                    for questionObj in questions{
                        let questionMOObj = getVaccinationQuestionsObj()
                        questionMOObj.certificationId = certificationId
                        questionMOObj.userId = userId
                        questionMOObj.questionDescription = questionObj.assessment
                        if let typeId = vaccineMixingCert?[0].typeId{
                            questionMOObj.typeId = String(typeId)
                        }
                        
                        if let categoryId = questCategory.catId{
                            questionMOObj.categoryId = String(categoryId)
                        }
                        questionMOObj.categoryName = questCategory.categorieName
                        if let qId = questionObj.id{
                            
                            questionMOObj.questionId = String(qId)
                        }
                        
                        if let qSeq = questionObj.sequenceNo{
                            
                            questionMOObj.sequenceNo = (qSeq) as NSNumber?
                        }
                        questionMOObj.questionType  = questionObj.types
                        questionMOObj.userComments  = questionObj.comments
                        questionMOObj.userSelectedResponse  = questionObj.answer as NSNumber?
                        questCategoryMOObj.addToQuestions(questionMOObj)
                        
                    }
                }
                if let attendees = questCategory.attendeeList{
                    for attendee in attendees{
                        if let typeId = vaccineMixingCert?[0].typeId, let categoryId = questCategory.catId{
                            
                            AddEmployeesDAO.sharedInstance.linkEmployeeToQuestionnaireById(empId: attendee.text ?? "", userId: userId, certificationId: certificationId, quesTypeId: String(typeId), quesCategoryId: String(categoryId))
                        }
                    }
                }
                moQuestTypeObj.addToQuestionCategories(questCategoryMOObj)
            }
        }
        
        if shippingDetails != nil && shippingDetails!.count  > 0{
            
            var moQuestTypeObj : ShippingAddressDTO?
            
            if let cityName = shippingDetails?[0].city{
                moQuestTypeObj?.city = String(cityName)
            }
            if let address1 = shippingDetails?[0].address1{
                moQuestTypeObj?.address1 = String(address1)
            }
            if let address2 = shippingDetails?[0].address2{
                moQuestTypeObj?.address2 = String(address2)
            }
            if let pincode = shippingDetails?[0].pincode{
                moQuestTypeObj?.pincode = String(pincode)
            }
            if let fssName = shippingDetails?[0].fssName{
                moQuestTypeObj?.fssName = String(fssName)
            }
            if let CountryId = shippingDetails?[0].countryID{
                moQuestTypeObj?.countryID = Int(CountryId)
            }
            if let StateId = shippingDetails?[0].stateID{
                moQuestTypeObj?.stateID = Int(StateId)
            }
            if let FssId = shippingDetails?[0].fssID{
                moQuestTypeObj?.fssID = Int(FssId)
            }
            if let Id = shippingDetails?[0].id{
                moQuestTypeObj?.id = Int(Id)
            }
            if let trainingId = shippingDetails?[0].trainingID{
                moQuestTypeObj?.trainingID = Int(trainingId)
            }
            if let SiteId = shippingDetails?[0].siteId{
                moQuestTypeObj?.siteId = Int(SiteId)
            }
            if let CountryName = shippingDetails?[0].countryName{
                moQuestTypeObj?.countryName = String(CountryName)
            }
            if let StateName = shippingDetails?[0].stateName{
                moQuestTypeObj?.stateName = String(StateName)
            }
            if let AddressType = shippingDetails?[0].adddressType{
                moQuestTypeObj?.adddressType = Bool(AddressType)
            }
            if let siteName = shippingDetails?[0].siteName{
                moQuestTypeObj?.siteName = String(siteName)
            }
            
            
        }
    }
    
    func saveGetResponseQuestionData( userId:String, certificationId:String, operatorCert:[GetSubmittedOperatorCertificationDTO]?, safetyCert:[GetSubmittedSafetyCertificationDTO]?, vaccineMixCert:[GetSubmittedVaccineMixingCertificationDTO]? , shippingAddressDetails:[ShippingAddressDTO]? ){
        do{
            
            if let addresses = shippingAddressDetails, !addresses.isEmpty {
                     
                     // Save primary address (index 0) if exists
                     if addresses.indices.contains(0) {
                         VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: [addresses[0]])
                     }

                     // Save other address (index 1) if exists
                     if addresses.indices.contains(1) {
                         VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: [addresses[1]])
                     }
                 }

            
            
//            if shippingAddressDetails!.count > 0 {
//                for value in shippingAddressDetails! {
//                    //VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: shippingAddressDetails)
//                    VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: [shippingAddressDetails![0]])
//                    VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: [shippingAddressDetails![1]])
//
//                    
//                }
//            }
            deleteVaccinationQuestions(userId: userId, certificationId: certificationId)
            AddEmployeesDAO.sharedInstance.deleteEmpByCertificationId(userId: userId, certificationId: certificationId)
            convertQuestDTOtoMO( userId:userId, certificationId:certificationId, operatorCert:operatorCert, safetyCert:safetyCert, vaccineMixingCert: vaccineMixCert, shippingDetails: shippingAddressDetails)
            
            
            SyncStatusDAO.sharedInstance.saveSyncStatus(userLoginId: userId, evalParam1: EntityParameters.certificationId.rawValue , evalParam2: nil, evalParam1Id: nil, evalParam2Id: nil, entityName: EntityName.UserFilledQuestionnaire.rawValue)
            try managedContext.save()
            
        } catch{
            managedContext.rollback()
            debugPrint("Error while saveQuestionData in \(type(of: self))")
        }
    }
}

//
//  AddEmployeesDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum MasterDataDropdownStatus:String{
    case TShirtSize
    case Languages
    case UserRoles
}

public class AddEmployeesDAO{
    private init(){}
    static let sharedInstance = AddEmployeesDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func saveEmployees(loginUserId:String, customerId:String, siteId:String, empoyeeDTO: [EmployeesInformationDTO]){
        do{
            if empoyeeDTO.count > 0{
                if !checkIfEmployeeDataExists(userId: loginUserId, siteId: siteId, customerId: customerId
                ){
                    deleteEmployeeData(userId:loginUserId, siteId:siteId, customerId:customerId)
                    for employee in empoyeeDTO{
                        convertDTOtoMO(dtoObj: employee, moObj: getEmployeeObj(), loginUserId:loginUserId, customerId:customerId, siteId:siteId)
                    }
                    SyncStatusDAO.sharedInstance.saveSyncStatus(userLoginId: loginUserId, evalParam1: EntityParameters.siteId.rawValue, evalParam2: EntityParameters.customerId.rawValue, evalParam1Id: siteId, evalParam2Id: customerId, entityName: EntityName.Employees.rawValue)
                }
            }
            try managedContext.save()
        }catch{
            debugPrint("Error while saving hacthery employees information in \(type(of: self))")
            managedContext.rollback()
        }
    }
    
//    func saveEmployeesByCertification(loginUserId:String, certificationId:String, customerId:String, siteId:String, employeeObj: [VaccinationEmployeeVM]){
//
//    }
    
    func getEmployees(loginUserId:String, customerId:String, siteId:String)-> [VaccinationEmployeeVM]{
        var vaccinationEmployeeArr = [VaccinationHatcheryEmployees]()
        var vaccinationEmpoyeeVMArr = [VaccinationEmployeeVM]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationHatcheryEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND siteId =  %@ AND customerId =  %@", loginUserId, siteId, customerId)
        do {
            vaccinationEmployeeArr = try managedContext.fetch(fetchRequest) as! [VaccinationHatcheryEmployees]
            if vaccinationEmployeeArr.count > 0{
                for employeeObj in vaccinationEmployeeArr{
                    vaccinationEmpoyeeVMArr.append(convertMOtoVM(moObj: employeeObj))
                }
            }
        } catch{
            debugPrint("Error while fetching Employees in \(type(of: self))")
        }
        
        return vaccinationEmpoyeeVMArr
    }
    
    func checkIfEmployeeDataExists(_ forceDelete:Bool = false, userId:String, siteId:String, customerId:String) -> Bool{
        var response = false
        if forceDelete{
            
            deleteEmployeeData(userId:userId, siteId:siteId, customerId:customerId)
            response = false
        } else{
            if getEmployees(loginUserId:userId, customerId:customerId, siteId:siteId).count
                > 0{
                response = true
            }
        }
        return response
    }
    
    func deleteEmployeeData(userId:String, siteId:String, customerId:String){
        deleteExisitingData(entityName: "VaccinationHatcheryEmployees", predicate: NSPredicate(format:"userId = %@ AND siteId =  %@ AND customerId =  %@", userId, siteId, customerId))
    }
    
    func getEmployeeObj()-> VaccinationHatcheryEmployees{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationHatcheryEmployees" , into: managedContext) as! VaccinationHatcheryEmployees
        return vaccinationCertObj
    }
    
    
    func convertDTOtoMO(dtoObj:EmployeesInformationDTO, moObj:VaccinationHatcheryEmployees, loginUserId:String, customerId:String, siteId:String){
        moObj.customerId = customerId
        moObj.employeeId = dtoObj.id?.description
        moObj.firstName = dtoObj.firstName
        moObj.middleName = dtoObj.middleName
        moObj.lastName = dtoObj.lastName
        moObj.siteId = siteId
        moObj.userId = loginUserId
        moObj.rolesArrStr = dtoObj.roles?.description
        
    }
    
    func convertMOtoVM(moObj:VaccinationHatcheryEmployees)->VaccinationEmployeeVM{
        var empoyeeVm = VaccinationEmployeeVM()
        empoyeeVm.siteId =  moObj.siteId
        empoyeeVm.customerId = moObj.customerId
        empoyeeVm.employeeId = moObj.employeeId
        empoyeeVm.firstName = moObj.firstName
        empoyeeVm.middleName = moObj.middleName
        empoyeeVm.lastName = moObj.lastName
        empoyeeVm.userId = moObj.userId
        empoyeeVm.rolesArrStr = moObj.rolesArrStr
        return empoyeeVm
    }
    
    func getDropdownMasterObj()-> VaccinationMasterData{
        let vaccinationMasterDataObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationMasterData" , into: managedContext) as! VaccinationMasterData
        return vaccinationMasterDataObj
    }
    
    func convertMasterDataMOtoVM(moObj:VaccinationMasterData)-> DropwnMasterDataVM{
        var masterDataObj = DropwnMasterDataVM()
        masterDataObj.type = moObj.type
        masterDataObj.id = moObj.id
        masterDataObj.value = moObj.value
        masterDataObj.userId = moObj.userId
        
        return masterDataObj
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
    
    func convertDropdownMasterDTOtoMO(dtoObj:MasterDataTypesDTO, loginUserId:String){
        if let languages = dtoObj.languagesList{
            for languageObj in languages{
                let dropdownMasterMOObj = getDropdownMasterObj()
                dropdownMasterMOObj.id = languageObj.id?.description
                dropdownMasterMOObj.value = languageObj.text
                dropdownMasterMOObj.type = MasterDataDropdownStatus.Languages.rawValue
                dropdownMasterMOObj.userId = loginUserId
            }
        }
        if let languages = dtoObj.tshirtSizesList{
            for languageObj in languages{
                let dropdownMasterMOObj = getDropdownMasterObj()
                dropdownMasterMOObj.id = languageObj.id?.description
                dropdownMasterMOObj.value = languageObj.text
                dropdownMasterMOObj.type = MasterDataDropdownStatus.TShirtSize.rawValue
                dropdownMasterMOObj.userId = loginUserId
            }
        }
        if let languages = dtoObj.userRoles{
            for languageObj in languages{
                let dropdownMasterMOObj = getDropdownMasterObj()
                dropdownMasterMOObj.id = languageObj.id?.description
                dropdownMasterMOObj.value = languageObj.text
                dropdownMasterMOObj.type = MasterDataDropdownStatus.UserRoles.rawValue
                dropdownMasterMOObj.userId = loginUserId
            }
        }
    }
    
    func saveDropdownMasterData(dtoObj:MasterDataTypesDTO, loginUserId:String) {
        do{
            if !checkIfMasterDataExists(userId: loginUserId){
                if dtoObj.languagesList != nil && dtoObj.languagesList!.count > 0 && dtoObj.tshirtSizesList != nil && dtoObj.tshirtSizesList!.count > 0{
                    deleteMasterData(userId:loginUserId)
                    
                    convertDropdownMasterDTOtoMO(dtoObj: dtoObj, loginUserId: loginUserId)
                    
                    SyncStatusDAO.sharedInstance.saveSyncStatus(userLoginId: loginUserId, evalParam1: nil, evalParam2: nil, evalParam1Id: nil, evalParam2Id: nil, entityName: EntityName.MasterDropdownData.rawValue)
                    try managedContext.save()
                }
                
            }
            
        }catch{
            print("Error while saving Dropdown Master values in \(type(of: self))")
            managedContext.rollback()
        }
    }
        
    func checkIfMasterDataExists(_ forceDelete:Bool = false, userId:String) -> Bool{
        var response = false
        if forceDelete{
            deleteMasterData(userId:userId)
            response = false
        } else{
            if getMasterDropdownData(loginUserId: userId, valueType: nil).count
                > 0{
                response = true
            }
        }
        return response
    }
    
    func deleteMasterData(userId:String){
        deleteExisitingData(entityName: "VaccinationMasterData", predicate: NSPredicate.init(format:"userId = %@" , userId))
    }
    
    
    func getMasterDropdownData(loginUserId:String, valueType:MasterDataDropdownStatus?)->[DropwnMasterDataVM]{
        var vaccinationMasterDataArr = [VaccinationMasterData]()
        var vaccinationMasterDataVMArr = [DropwnMasterDataVM]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationMasterData")
        fetchRequest.returnsObjectsAsFaults = false
        if valueType != nil{
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND type = %@", loginUserId, valueType!.rawValue)
        } else{
            fetchRequest.predicate = NSPredicate(format:"userId = %@", loginUserId)
        }
        do {
            vaccinationMasterDataArr = try managedContext.fetch(fetchRequest) as! [VaccinationMasterData]
            if vaccinationMasterDataArr.count > 0{
                for masterDataObj in vaccinationMasterDataArr{
                    vaccinationMasterDataVMArr.append(convertMasterDataMOtoVM(moObj: masterDataObj))
                }
            }
        } catch{
            print("Error while fetching Dropdown Master Data in \(type(of: self))")
        }
        
        vaccinationMasterDataVMArr.sort { first, second in
            if first.id != nil && second.id != nil{
                return first.id! < second.id!
            }
            return false
        }
        return vaccinationMasterDataVMArr
    }
    
    func addCertEmployee(userId:String, certificationId:String, employeeObj: VaccinationEmployeeVM){
        
        do{
            let moObj = getCertEmployeeObj(empId:employeeObj.employeeId ?? UUID().uuidString, userId:userId, certificationId:certificationId)
            convertVMToMO(employeeObj: employeeObj, moObj:moObj)
            
            try managedContext.save()
        } catch{
            print("Error while saving certification employees information in \(type(of: self))")
            managedContext.rollback()
        }
    }
    
    func addEmpToCategory(empId:String, userId:String, certificationId:String, catId:String, typeId:String){
        let certBrdgeObj = getEmpCatBridgeObject()
        certBrdgeObj.userId = userId
        certBrdgeObj.certificationId = certificationId
        certBrdgeObj.empId = empId
        certBrdgeObj.quesCategoryId = catId
        certBrdgeObj.quesTypeId = typeId
        do{
            try managedContext.save()
        }catch{
            print("Error while adding employee to specific category in vaccination")
            managedContext.rollback()
        }
    }
    
    func linkEmployeeToQuestionnaireById(empId:String, userId:String, certificationId:String, quesTypeId:String, quesCategoryId :String){
      
        do{
            let certBrdgeObj = getEmpCatBridgeObject()
            certBrdgeObj.userId = userId
            certBrdgeObj.certificationId = certificationId
            certBrdgeObj.empId = empId
            certBrdgeObj.quesCategoryId = quesCategoryId
            certBrdgeObj.quesTypeId = quesTypeId
            
            try managedContext.save()
            
        } catch{
            print("Error while saving attendees operator details by id")
            managedContext.rollback()
        }
    }
    
    func linkEmpToQuestionnaire(empId:String, userId:String, certificationId:String){
        do{
            let safetyTypeId = VaccinationConstants.LookupMaster.SAFETY_AWARENESS_QUESTION_TYPE_ID
            let masterListQuestTypesSafety = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: safetyTypeId)
            if masterListQuestTypesSafety.count > 0{
                let questCategories = masterListQuestTypesSafety[0].questionCategories?.allObjects as? Array<VaccinationQuestionCategories>
                if let quesCatArr = questCategories{
                    let catIdArr = quesCatArr.map{ $0.categoryId}
                    for catId in catIdArr{
                        let certBrdgeObj = getEmpCatBridgeObject()
                        certBrdgeObj.userId = userId
                        certBrdgeObj.certificationId = certificationId
                        certBrdgeObj.empId = empId
                        certBrdgeObj.quesCategoryId = catId
                        certBrdgeObj.quesTypeId = safetyTypeId
                    }
                    try managedContext.save()
                }
            }
            
            
            let vaccineMixingTypeId = VaccinationConstants.LookupMaster.VACCINE_MIXING_TYPE_ID
            let masterListQuestTypesVAccineMixing = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: vaccineMixingTypeId)
            if masterListQuestTypesVAccineMixing.count > 0{
                let questCategories = masterListQuestTypesVAccineMixing[0].questionCategories?.allObjects as? Array<VaccinationQuestionCategories>
                if let quesCatArr = questCategories{
                    let catIdArr = quesCatArr.map{ $0.categoryId}
                    for catId in catIdArr{
                        let certBrdgeObj = getEmpCatBridgeObject()
                        certBrdgeObj.userId = userId
                        certBrdgeObj.certificationId = certificationId
                        certBrdgeObj.empId = empId
                        certBrdgeObj.quesCategoryId = catId
                        certBrdgeObj.quesTypeId = vaccineMixingTypeId
                    }
                    try managedContext.save()
                }
            }

            
            
            let operatorTypeId = VaccinationConstants.LookupMaster.OPERATOR_CERTIFICATION_QUESTION_TYPE_ID
            let masterListQuestTypes = QuestionnaireDAO.sharedInstance.fetchQuestionnaireMOData(userId: userId, typeId: operatorTypeId)
            if masterListQuestTypes.count > 0{
                let questCategories = masterListQuestTypes[0].questionCategories?.allObjects as? Array<VaccinationQuestionCategories>
                if let quesCatArr = questCategories{
                    let catIdArr = quesCatArr.map{ $0.categoryId}
                    for catId in catIdArr{
                        let certBrdgeObj = getEmpCatBridgeObject()
                        certBrdgeObj.userId = userId
                        certBrdgeObj.certificationId = certificationId
                        certBrdgeObj.empId = empId
                        certBrdgeObj.quesCategoryId = catId
                        certBrdgeObj.quesTypeId = operatorTypeId
                        
                    }
                    try managedContext.save()
                }
                
            }
        }catch{
            print("Error while saving attendees operator details")
            managedContext.rollback()
        }
        
    }
    
    func removeEmployeeFromBridge(empId:String, userId:String, certificationId:String){
        var vaccinationCertificationArr = [VaccinationQuestionEmpBridge]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationQuestionEmpBridge")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND empId = %@ ", userId, certificationId, empId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationQuestionEmpBridge]
            for empBridgeObj in vaccinationCertificationArr{
                managedContext.delete(empBridgeObj)
            }
            try managedContext.save()
        } catch{
            print("Error while deletiong Certification Employee Obj in \(type(of: self)) from bridge table in vaccination")
        }
        
    }
    
    func deleteEmpByCategory(empId:String, userId:String, certificationId:String, catId:String, typeId:String){
        var vaccinationCertificationArr = [VaccinationQuestionEmpBridge]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationQuestionEmpBridge")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND empId = %@ AND quesCategoryId = %@ AND quesTypeId = %@", userId, certificationId, empId,catId, typeId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationQuestionEmpBridge]
            for empBridgeObj in vaccinationCertificationArr{
                managedContext.delete(empBridgeObj)
            }
            try managedContext.save()
        } catch{
            print("Error while deletiong Certification Employee Obj in \(type(of: self)) from bridge table in vaccination")
        }
        
        
    }
    
    func fetchEmpByCatId(catId:String, typeId:String, userId:String, certificationId:String)-> [VaccinationQuestionEmpBridge]{
        var vaccinationCertificationArr = [VaccinationQuestionEmpBridge]()
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationQuestionEmpBridge")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND quesCategoryId = %@ AND quesTypeId= %@", userId, certificationId, catId, typeId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationQuestionEmpBridge]
            if vaccinationCertificationArr.count > 0{
                
                return vaccinationCertificationArr
            }
            
            
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func deleteEmpByCertificationId( userId:String, certificationId:String){
        var vaccinationCertificationArr = [VaccinationQuestionEmpBridge]()
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationQuestionEmpBridge")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  ", userId, certificationId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationQuestionEmpBridge]
            if vaccinationCertificationArr.count > 0{
                for empObj in vaccinationCertificationArr{
                    managedContext.delete(empObj)
                }
                
                
                try managedContext.save()
            }
            
            
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
    }
    
    
    func getEmpCatBridgeObject() -> VaccinationQuestionEmpBridge{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationQuestionEmpBridge" , into: managedContext) as! VaccinationQuestionEmpBridge
        return vaccinationCertObj
        
    }
    
    
    
    func convertVMToMO(employeeObj: VaccinationEmployeeVM, moObj:VaccinationCertificationEmployees){
        moObj.firstName = employeeObj.firstName
        moObj.middleName = employeeObj.middleName
        moObj.lastName = employeeObj.lastName
        moObj.selectedTshirtid = employeeObj.selectedTshirtId
        moObj.selectedTshirtVal = employeeObj.selectedTshirtValue
        moObj.selectedCertLangId = employeeObj.selectedLangId
        moObj.selectdLangal = employeeObj.selectedLangValue
        moObj.rolesArrStr = employeeObj.rolesArrStr
        moObj.selectedRolesStr = employeeObj.selectedRolesStr
        moObj.employeeId = employeeObj.employeeId
        moObj.sortOrder = employeeObj.sortOrder as NSNumber?
        moObj.customerId = employeeObj.customerId
        moObj.userId = employeeObj.userId
        moObj.siteId = employeeObj.siteId
        moObj.certificationId = employeeObj.certificationId
        moObj.signBase64 = employeeObj.signBase64
        moObj.startDate = employeeObj.startDate
        moObj.createdDate = employeeObj.createdDate
    }
    
    func convertMoToVM(moObj:VaccinationCertificationEmployees)->VaccinationEmployeeVM{
        var empObj = VaccinationEmployeeVM()
        empObj.firstName = moObj.firstName
        empObj.middleName = moObj.middleName
        empObj.lastName = moObj.lastName
        empObj.selectedTshirtId = moObj.selectedTshirtid
        empObj.selectedTshirtValue = moObj.selectedTshirtVal
        if moObj.selectedCertLangId != nil{
            empObj.selectedLangId = moObj.selectedCertLangId!
        }
        if moObj.selectdLangal != nil{
            empObj.selectedLangValue = moObj.selectdLangal!
        }
        
        empObj.rolesArrStr = moObj.rolesArrStr
        empObj.selectedRolesStr = moObj.selectedRolesStr
        empObj.employeeId = moObj.employeeId
        empObj.sortOrder = moObj.sortOrder as? Int32
        empObj.customerId = moObj.customerId
        empObj.userId = moObj.userId
        empObj.siteId = moObj.siteId
        empObj.certificationId = moObj.certificationId
        empObj.signBase64 = moObj.signBase64
        empObj.startDate = moObj.startDate
        empObj.createdDate = moObj.createdDate
        return empObj
    }
    
    func getCertEmployeeObj(empId:String, userId:String, certificationId:String) -> VaccinationCertificationEmployees{
        var vaccinationCertificationArr = [VaccinationCertificationEmployees]()
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertificationEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND employeeId = %@", userId, certificationId, empId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertificationEmployees]
            if vaccinationCertificationArr.count > 0{
                
                return vaccinationCertificationArr[0]
            }
            
            
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
        let empObj =  getCertEmpObject()
        empObj.userId = userId
        empObj.certificationId = certificationId
        empObj.employeeId = empId
        
        return empObj
    }
    
    func getCertEmpObject()-> VaccinationCertificationEmployees{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationCertificationEmployees" , into: managedContext) as! VaccinationCertificationEmployees
        vaccinationCertObj.createdDate = Date()
        return vaccinationCertObj
        
    }
    
    func getAllCertEmployees(userId:String, certificationId:String) -> [VaccinationEmployeeVM]{
        var vaccinationCertificationArr = [VaccinationCertificationEmployees]()
        var certEmpArr = [VaccinationEmployeeVM]()
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertificationEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertificationEmployees]
            if vaccinationCertificationArr.count > 0{
                for empObj in vaccinationCertificationArr{
                    certEmpArr.append(convertMoToVM(moObj: empObj))
                }
            }
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
        certEmpArr.sort{
            if $0.sortOrder != nil && $1.sortOrder != nil{
                return  $0.sortOrder! < $1.sortOrder!
            }
            return false
            
        }
        return certEmpArr
    }
    
    func getAllCertEmployees(predicateArr:[NSPredicate]) -> [VaccinationEmployeeVM]{
        var vaccinationCertificationArr = [VaccinationCertificationEmployees]()
        var certEmpArr = [VaccinationEmployeeVM]()
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertificationEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSCompoundPredicate.init(type: .or, subpredicates: predicateArr)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertificationEmployees]
            if vaccinationCertificationArr.count > 0{
                for empObj in vaccinationCertificationArr{
                    certEmpArr.append(convertMoToVM(moObj: empObj))
                }
                
            }
            
            
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
        certEmpArr.sort{
            if $0.sortOrder != nil && $1.sortOrder != nil{
                return  $0.sortOrder! < $1.sortOrder!
            }
            return false
            
        }
        return certEmpArr
    }
    
    func deleteEmployeeObj(empId:String, userId:String, certificationId:String){
        var vaccinationCertificationArr = [VaccinationCertificationEmployees]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertificationEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  AND employeeId = %@", userId, certificationId, empId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertificationEmployees]
            if vaccinationCertificationArr.count > 0{
                for empObj in vaccinationCertificationArr{
                    managedContext.delete(empObj)
                }
                try managedContext.save()
            }
            
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
    }
    
    func deleteEmployeeByCertification(userId:String, certificationId:String){
        var vaccinationCertificationArr = [VaccinationCertificationEmployees]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertificationEmployees")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@  ", userId, certificationId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertificationEmployees]
            if vaccinationCertificationArr.count > 0{
                for empObj in vaccinationCertificationArr{
                    managedContext.delete(empObj)
                }
                try managedContext.save()
            }
        } catch{
            print("Error while fetching Certification Employee Obj in \(type(of: self))")
        }
    }
}

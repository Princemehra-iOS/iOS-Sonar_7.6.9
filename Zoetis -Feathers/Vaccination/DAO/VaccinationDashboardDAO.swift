//
//  VaccinationServices.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 03/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public enum VaccinationCertificationStatus:String{
    case new
    case inProgress
    case draft
    case submitted
    case rejected
}

public enum VaccinationCertificationSyncStatus:String{
    case synced
    case syncReady
    case none
}

public enum VaccinationModuleNames:String{
    case QuestionnaireVC
    case AddEmployeesVC
    case ShippingAddressVC
    case VaccinationDashboardVC
    case none
}

public enum VaccinationSubModuleNames:String{
    case OperationCertification
    case SafetyAwareness
    case Acknowledgement
    case SafetyCertification
    case VaccineMixing
    case none
}

public class VaccinationDashboardDAO{
    private init(){}
    static let sharedInstance = VaccinationDashboardDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getScheduledCertifications(userId:String)-> [VaccinationCertificationVM]{
        var vaccinationCertificationArr = [VaccinationCertifications]()
        var vaccinationCertificationVMArr = [VaccinationCertificationVM]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertifications")
        fetchRequest.returnsObjectsAsFaults = false
        let pred1 = NSPredicate(format:"loginUserId = %@ AND trainingStatus == %@", userId,"1")
        let pred2 = NSPredicate(format:"loginUserId = %@ AND trainingStatus == %@", userId,"2")
        fetchRequest.predicate = NSCompoundPredicate.init(type: .or, subpredicates: [pred1, pred2])
        
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertifications]
            if vaccinationCertificationArr.count > 0{
                for certificationObj in vaccinationCertificationArr{
                    vaccinationCertificationVMArr.append(convertMotoVM(vaccinationMOObj: certificationObj))
                }
            }
            
        } catch{
            print("Error while fetching Upcoming Certifications in \(type(of: self))")
            
            
        }
        vaccinationCertificationVMArr.sort(by: {
            let dateFormatterObj = DateFormatter()
            
            dateFormatterObj.timeZone = Calendar.current.timeZone
            dateFormatterObj.locale = Calendar.current.locale
            dateFormatterObj.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss"
            
            if $0.scheduledDate != nil && $1.scheduledDate != nil{
                let date1Obj = dateFormatterObj.date(from: $0.scheduledDate!)
                let date2Obj = dateFormatterObj.date(from: $1.scheduledDate!)
                if date1Obj != nil && date2Obj != nil{
                    return date1Obj! > date2Obj!
                }
            }
            return false
        })
        return vaccinationCertificationVMArr
    }
    
    func getScheduledCertMOFilledObj(userId:String, certificatonId:String) -> VaccinationCertifications?{
        
        var vaccinationCertificationArr = [VaccinationCertifications]()
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationCertifications")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"loginUserId = %@ AND certificationId = %@", userId, certificatonId)
        
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationCertifications]
            
        } catch{
            print("Error while fetching Upcoming Certifications in \(type(of: self))")
            
            
        }
        if vaccinationCertificationArr.count > 0{
            return vaccinationCertificationArr[0]
        }
        return nil
    }
    
    func updateCertobj(userId:String, certificatonId:String, statusId:String){
        do{
            let moObj =  getScheduledCertMOFilledObj(userId: userId, certificatonId: certificatonId)
            moObj?.trainingStatus = statusId
            try managedContext.save()
            
        } catch{
            print("Unable to update status of cetification Object")
            managedContext.rollback()
        }
    }
    
    func convertMotoVM(vaccinationMOObj: VaccinationCertifications)->VaccinationCertificationVM{
        var vaccinationVMObj = VaccinationCertificationVM()
        vaccinationVMObj.certificationId = vaccinationMOObj.certificationId
        if let typeId = vaccinationMOObj.certificationTypeId{
            vaccinationVMObj.certificationTypeId =  typeId
        }
        vaccinationVMObj.certificationTypeName = vaccinationMOObj.certificationTypeName
        vaccinationVMObj.customerId = vaccinationMOObj.customerId
        vaccinationVMObj.customerName = vaccinationMOObj.customername
        vaccinationVMObj.customerShippingId = vaccinationMOObj.customerShippingId
        vaccinationVMObj.fsmId = vaccinationMOObj.fsmId
        vaccinationVMObj.fsmName = vaccinationMOObj.fsmName
        vaccinationVMObj.fsrId = vaccinationMOObj.fsrId
        vaccinationVMObj.fsrName = vaccinationMOObj.fsrName
        vaccinationVMObj.isExistingSite = vaccinationMOObj.isExistingSite as? Bool ?? false
        vaccinationVMObj.loginUserId = vaccinationMOObj.loginUserId
        vaccinationVMObj.scheduledDate = vaccinationMOObj.scheduledDate
        vaccinationVMObj.siteId = vaccinationMOObj.siteId
        vaccinationVMObj.siteName = vaccinationMOObj.siteName
        vaccinationVMObj.certificationCategoryName = vaccinationMOObj.certificationCategoryName
        vaccinationVMObj.certificationCategoryId = vaccinationMOObj.certificationCategoryId
        vaccinationVMObj.trainingStatus = vaccinationMOObj.trainingStatus
        vaccinationVMObj.supervisorName = vaccinationMOObj.supervisorName
        vaccinationVMObj.supervisorJobTitle = vaccinationMOObj.supervisorJobTitle
        vaccinationVMObj.colleagueName = vaccinationMOObj.colleagueName
        vaccinationVMObj.colleagueJobTitle = vaccinationMOObj.colleagueJobTitle
        return vaccinationVMObj
    }
    
    func getFilledMoObj(dtoObj:VaccinationCertificationsResponseDTO, moObj:VaccinationCertifications, loginUserId:String){
        moObj.trainingStatus = dtoObj.trainingStatus?.description ?? ""
        moObj.certificationId = dtoObj.id?.description ?? ""
        moObj.certificationTypeId = dtoObj.certificateTypeId?.description
        moObj.certificationTypeName = dtoObj.certificateType
        moObj.customerId = dtoObj.customerId?.description
        moObj.customername = dtoObj.customerName
        moObj.customerShippingId  = dtoObj.custShipping
        moObj.fsmId = dtoObj.fSMId?.description
        moObj.fsmName = dtoObj.fSMName
        moObj.fsrId = dtoObj.fSRId?.description
        moObj.fsrName = dtoObj.fSRName
        moObj.isExistingSite = dtoObj.existingSite as NSNumber? ?? false as NSNumber
        moObj.loginUserId = loginUserId
        moObj.scheduledDate = dtoObj.scheduleDate
        moObj.siteId = dtoObj.siteId?.description
        moObj.siteName = dtoObj.siteName
        moObj.certificationCategoryName = VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
        moObj.certificationCategoryId = VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
    }
    
    func getVaccinationCertificationsObject()-> VaccinationCertifications{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationCertifications" , into: managedContext) as! VaccinationCertifications
        return vaccinationCertObj
        
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
    
    func saveUpcomingCertifications(certificationDTOArr:[VaccinationCertificationsResponseDTO], loginUserId:String){
        do{
            if certificationDTOArr.count > 0{
                deleteExisitingData(entityName: "VaccinationCertifications", predicate: NSPredicate(format:"loginUserId = %@", loginUserId))
                for certificationDTOObj in certificationDTOArr{
                    let moObj = getVaccinationCertificationsObject()
                    getFilledMoObj(dtoObj: certificationDTOObj, moObj:moObj , loginUserId: loginUserId)
                    let startedMoObj = getStartedCertStatusMoObj(userId: loginUserId, certificationId: moObj.certificationId ?? "")
                    if startedMoObj != nil{
                        if startedMoObj?.certificationStatus == VaccinationCertificationStatus.draft.rawValue{
                            moObj.trainingStatus =  "2"
                        } else if startedMoObj?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                            moObj.trainingStatus =  "3"
                        }
                        moObj.fsmName = startedMoObj?.hatcheryManager
                    }
                }
                try managedContext.save()
            }
        } catch{
            managedContext.rollback()
            debugPrint("Error while saving Upcoming Certifications in \(type(of: self))")
        }
    }
    
    func getStartedCertificationsObject()-> VaccinationStartedCertifications{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationStartedCertifications" , into: managedContext) as! VaccinationStartedCertifications
        vaccinationCertObj.createdDate = Date()
        return vaccinationCertObj
        
    }
    
    func  getStartedCertStatusMoObj(userId:String, certificationId:String)->VaccinationStartedCertifications?{
        var vaccinationCertificationArr = [VaccinationStartedCertifications]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationStartedCertifications")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationId = %@", userId, certificationId)
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationStartedCertifications]
            if vaccinationCertificationArr.count > 0{
                return vaccinationCertificationArr[0]
            }
        } catch{
            debugPrint("Error while fetching Upcoming Certifications in \(type(of: self))")
        }
        return nil
    }
    
    func getStartedCertObjByCategory(userId:String, certificationCategoryId:String)  -> VaccinationCertificationVM?{
        if let startedCertMOObj = getStartedCertStatusMoObjByCategory(userId: userId, certificationCategoryId: certificationCategoryId){
            let obj  = convertMOtoVOStartedCert(startedCertMOObj)
            return obj
        }
        return nil
    }
    
    func deleteStartedCertObjByCategory(userId:String, certificationCategoryId:String) {
        if let startedCertMOObj = getStartedCertStatusMoObjByCategory(userId: userId, certificationCategoryId: certificationCategoryId){
            
            do {
                managedContext.delete(startedCertMOObj)
            } catch{
                debugPrint("Error while fetching Upcoming Certifications in \(type(of: self))")
            }
        }
    }
    
    func deleteStartedCertObjByCertificationId(userId:String, certificationId:String) {
        if let startedCertMOObj = getStartedCertStatusMoObj(userId:userId, certificationId:certificationId){
            
            do {
                managedContext.delete(startedCertMOObj)
            } catch{
                debugPrint("Error while fetching Upcoming Certifications in \(type(of: self))")
            }
        }
    }
    
    func  getStartedCertStatusMoObjByCategory(userId:String, certificationCategoryId:String)->VaccinationStartedCertifications?{
        var vaccinationCertificationArr = [VaccinationStartedCertifications]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationStartedCertifications")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationCategoryId = %@ AND certificationStatus = %@", userId, certificationCategoryId, VaccinationCertificationStatus.inProgress.rawValue)
        
        
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationStartedCertifications]
            if vaccinationCertificationArr.count > 0{
                return vaccinationCertificationArr[0]
            }
        } catch{
            debugPrint("Error while fetching Upcoming Certifications in \(type(of: self))")
        }
        return nil
    }
    
    func saveCertStartedObj(moObj: VaccinationStartedCertifications){
        do{
            try managedContext.save()
        }catch{
            debugPrint("Error while saving Started Certifications in \(type(of: self))")
        }
    }
    
    func getScheduledCertificationStatus(userId:String,certificationId:String, certCategoryId:String, certObj:VaccinationCertificationVM)-> VaccinationStartedCertifications{
        let moObj = getStartedCertStatusMoObj(userId:userId,certificationId:certificationId)
        if moObj != nil{
            return moObj!
        }
        let newStatusObj = getStartedCertificationsObject()
        
        updateStartedCertificationObj(moObj: newStatusObj, vmObj: certObj)
        newStatusObj.certificationCategoryId = certCategoryId
        
        newStatusObj.certificationStatus = VaccinationCertificationStatus.inProgress.rawValue
        newStatusObj.certificationId = certificationId
        newStatusObj.userId = userId
        return newStatusObj
    }
    
    func updateStartedCertificationObj(moObj: VaccinationStartedCertifications, vmObj: VaccinationCertificationVM){
        moObj.certificationCategoryId = vmObj.certificationCategoryId
        moObj.certificationCategoryName = vmObj.certificationCategoryName
        moObj.certificationId = vmObj.certificationId
        moObj.certificationTypeId = vmObj.certificationTypeId
        moObj.certificationTypeName = vmObj.certificationTypeName
        moObj.customerId = vmObj.customerId
        moObj.customerName = vmObj.customerName
        moObj.custShippingNum =  vmObj.customerShippingId
        moObj.assignedTo = vmObj.fsrId
        moObj.assignedName = vmObj.fsrName
        moObj.hatcheryManager = vmObj.fsmName
        moObj.isExistingSite = vmObj.isExistingSite as NSNumber?
        moObj.userId = vmObj.loginUserId
        moObj.scheduledDate = vmObj.scheduledDate
        moObj.siteid = vmObj.siteId
        moObj.siteName = vmObj.siteName
        moObj.hatcheryManagerSign = vmObj.hatcheryManagerSign
        moObj.fsrSign = vmObj.fsrSignature
//		if vmObj.certificationCategoryId
        
        if vmObj.selectedFsmId == nil {
            moObj.approvedRejectedById = "\(vmObj.approveRejectFsmId ?? 0)"
        }
        else
        {
            moObj.approvedRejectedById = vmObj.selectedFsmId
        }
		
        moObj.selectedFsmID = vmObj.selectedFsmId
        moObj.selectedFsmNme = vmObj.selectedFsmName
        
        moObj.supervisorName = vmObj.supervisorName
        moObj.supervisorJobTitle = vmObj.supervisorJobTitle
        moObj.colleagueName = vmObj.colleagueName
        moObj.colleagueJobTitle = vmObj.colleagueJobTitle
        moObj.deviceId = vmObj.deviceId
        moObj.systemCertificationId = vmObj.systemCertificationId
        moObj.certId = vmObj.Id as? NSNumber
        moObj.trainingId = vmObj.TrainingId as? NSNumber
        moObj.fssId = vmObj.FSSId as? NSNumber
        moObj.stateId = vmObj.StateId as? NSNumber
        moObj.countryId = vmObj.CountryId as? NSNumber
        moObj.fssName = vmObj.FSSName
        moObj.city = vmObj.City
        moObj.address1 = vmObj.Address1
        moObj.address2 = vmObj.Address2
        moObj.pincode = vmObj.Pincode
        moObj.addressType = vmObj.isOtherAddress as NSNumber?
        moObj.countryName = vmObj.CountryName
        moObj.stateName = vmObj.StateName
        
        moObj.certification_Type_Id = vmObj.certification_Type_Id as? NSNumber
        
    }
    
    func getStartedCertificationsByStatus(userId:String, status: VaccinationCertificationStatus, syncStatus:VaccinationCertificationSyncStatus?) -> [VaccinationStartedCertifications]{
        var vaccinationCertificationArr = [VaccinationStartedCertifications]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationStartedCertifications")
        fetchRequest.returnsObjectsAsFaults = false
        if syncStatus != nil{
            if syncStatus == VaccinationCertificationSyncStatus.synced{
                var predicateArr = [NSPredicate]()
                let syncPredicate = NSPredicate(format:"userId = %@ AND certificationStatus = %@ AND syncStatus != %@", userId, status.rawValue, syncStatus!.rawValue )
                predicateArr.append(syncPredicate)
                let draftPredicate = NSPredicate(format:"userId = %@ AND certificationStatus = %@ AND syncStatus != %@", userId, VaccinationCertificationStatus.draft.rawValue, syncStatus!.rawValue )
                predicateArr.append(draftPredicate)
                fetchRequest.predicate = NSCompoundPredicate.init(type: .or, subpredicates: predicateArr)
            }
        }else{
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND certificationStatus = %@", userId, status.rawValue)
        }
        
        
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [VaccinationStartedCertifications]
        } catch{
            debugPrint("Error while fetching Upcoming Certifications in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func getStartedCertificationsByStatusVM(userId:String, status: VaccinationCertificationStatus, syncStatus:VaccinationCertificationSyncStatus?) -> [VaccinationCertificationVM]{
        var startedCertArr = [VaccinationCertificationVM]()
        let vaccinationCertificationArr = getStartedCertificationsByStatus(userId:userId,status: status, syncStatus: syncStatus)
        for certObj in vaccinationCertificationArr{
            startedCertArr.append(convertMOtoVOStartedCert(certObj))
        }
        startedCertArr.sort(by: {
            let dateFormatterObj = DateFormatter()
            dateFormatterObj.timeZone = Calendar.current.timeZone
            dateFormatterObj.locale = Calendar.current.locale
            dateFormatterObj.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss"
            
            if $0.scheduledDate != nil && $1.scheduledDate != nil{
                let date1Obj =  $0.submittedDate!
                let date2Obj = $1.submittedDate!
                if date1Obj != nil && date2Obj != nil{
                    return date1Obj > date2Obj
                }
            }
            return false
        })
        return startedCertArr
    }
    
    func onlyScheduledCertStatusVM(userId:String,certificationId:String)->VaccinationCertificationVM?{
        let moObj = getStartedCertStatusMoObj(userId:userId,certificationId:certificationId)
        if moObj != nil{
            let voObj = convertMOtoVOStartedCert(moObj!)
            return voObj
        }
        return nil
    }
    
    func getScheduledCertificationStatusVM(userId:String,certificationId:String, certCategoryId:String, certObj: VaccinationCertificationVM) -> VaccinationCertificationVM{
        return  convertMOtoVOStartedCert(getScheduledCertificationStatus(userId:userId,certificationId:certificationId, certCategoryId: certCategoryId, certObj: certObj))
    }
    
    func convertMOtoVOStartedCert(_ moObj: VaccinationStartedCertifications)  -> VaccinationCertificationVM{
        var vaccinationStartedCertificationVMObj = VaccinationCertificationVM()
        vaccinationStartedCertificationVMObj.fsrName = moObj.assignedName
        vaccinationStartedCertificationVMObj.fsrId = moObj.assignedTo
        vaccinationStartedCertificationVMObj.certificationCategoryId = moObj.certificationCategoryId
        vaccinationStartedCertificationVMObj.certificationCategoryName = moObj.certificationCategoryName
        vaccinationStartedCertificationVMObj.certificationId = moObj.certificationId
        vaccinationStartedCertificationVMObj.certificationStatus = moObj.certificationStatus
        if let typeId = moObj.certificationTypeId{
            vaccinationStartedCertificationVMObj.certificationTypeId = typeId
        }
        vaccinationStartedCertificationVMObj.certification_Type_Id = moObj.certification_Type_Id as? Int
        vaccinationStartedCertificationVMObj.certificationTypeName = moObj.certificationTypeName
        vaccinationStartedCertificationVMObj.createdDate = moObj.createdDate
        vaccinationStartedCertificationVMObj.customerId = moObj.customerId
        vaccinationStartedCertificationVMObj.customerName = moObj.customerName
        vaccinationStartedCertificationVMObj.customerShippingId = moObj.custShippingNum
        vaccinationStartedCertificationVMObj.fsmName = moObj.hatcheryManager
        vaccinationStartedCertificationVMObj.isExistingSite = moObj.isExistingSite as? Bool ?? false
        vaccinationStartedCertificationVMObj.lastModuleName = moObj.lastModulename
        vaccinationStartedCertificationVMObj.lastSubmoduleName = moObj.lastSubModuleName
        vaccinationStartedCertificationVMObj.scheduledDate = moObj.scheduledDate
        vaccinationStartedCertificationVMObj.siteId = moObj.siteid
        vaccinationStartedCertificationVMObj.siteName = moObj.siteName
        vaccinationStartedCertificationVMObj.fsrSignature = moObj.fsrSign
        vaccinationStartedCertificationVMObj.hatcheryManagerSign = moObj.hatcheryManagerSign
        vaccinationStartedCertificationVMObj.selectedFsmId = moObj.approvedRejectedById
        let fieldServiceManagers = VaccinationCustomersDAO.sharedInstance.getFSMListVM(user_id: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        let index = fieldServiceManagers.firstIndex(where: { $0.fsmId == moObj.approvedRejectedById })
        
        if fieldServiceManagers.count > 0 {
            vaccinationStartedCertificationVMObj.selectedFsmName = fieldServiceManagers[index ?? 0].fsmName
        }
        
        if let submittedDate = moObj.submittedDate{
            vaccinationStartedCertificationVMObj.submittedDate = submittedDate
        }
        vaccinationStartedCertificationVMObj.syncStatus = moObj.syncStatus
        
        vaccinationStartedCertificationVMObj.loginUserId = moObj.userId
        
        vaccinationStartedCertificationVMObj.supervisorName = moObj.supervisorName
        vaccinationStartedCertificationVMObj.supervisorJobTitle = moObj.supervisorJobTitle
        vaccinationStartedCertificationVMObj.colleagueName = moObj.colleagueName
        vaccinationStartedCertificationVMObj.colleagueJobTitle = moObj.colleagueJobTitle
        
        vaccinationStartedCertificationVMObj.deviceId = moObj.deviceId
        vaccinationStartedCertificationVMObj.systemCertificationId = moObj.systemCertificationId
        
        return vaccinationStartedCertificationVMObj
    }
    
    func insertLastVisitedModuleName(userId:String, lastModuleName:VaccinationModuleNames, certificationId:String, subModule:String?, certificationCategoryId:String = "2",  certObj: VaccinationCertificationVM){
        do{
            let scheduledCertObj = getScheduledCertificationStatus(userId:userId,certificationId:certificationId, certCategoryId: certificationCategoryId, certObj: certObj)
            updateStartedCertificationObj(moObj:scheduledCertObj , vmObj:certObj )
            scheduledCertObj.lastModulename = lastModuleName.rawValue
            scheduledCertObj.certificationCategoryId = certificationCategoryId
            scheduledCertObj.userId = userId
            scheduledCertObj.lastSubModuleName = subModule
            scheduledCertObj.syncStatus = certObj.syncStatus
            scheduledCertObj.selectedFsmID = certObj.selectedFsmId
            scheduledCertObj.selectedFsmNme = certObj.selectedFsmName
            try managedContext.save()
        } catch{
            managedContext.rollback()
            debugPrint("Error while saving Started Certifications in \(type(of: self))")
        }
    }
    
    func updateCertificationStatus(userId:String,  certificationId:String, status: VaccinationCertificationStatus,certCategoryId:String, certObj: VaccinationCertificationVM){
        do{
            let scheduledCertObj = getScheduledCertificationStatus(userId:userId,certificationId:certificationId, certCategoryId: certCategoryId, certObj: certObj)
            if status == VaccinationCertificationStatus.submitted || status == VaccinationCertificationStatus.draft{
                scheduledCertObj.syncStatus = VaccinationCertificationSyncStatus.syncReady.rawValue
            } else{
                scheduledCertObj.syncStatus = ""
            }
            scheduledCertObj.certificationStatus = status.rawValue
            scheduledCertObj.userId = userId
            
            try managedContext.save()
        } catch{
            managedContext.rollback()
            debugPrint("Error while updating certification status in \(type(of: self))")
        }
    }
    
	func updateSubmittedDate(userId:String,  certificationId:String, status: VaccinationCertificationStatus,certCategoryId:String, certObj: VaccinationCertificationVM, submittedDate:Date?,approverId:Int? = nil){
        do{
            
            let scheduledCertObj = getScheduledCertificationStatus(userId:userId,certificationId:certificationId, certCategoryId: certCategoryId, certObj: certObj)
            scheduledCertObj.certificationStatus = status.rawValue
            scheduledCertObj.userId = userId
            scheduledCertObj.submittedDate =  Date()
			if let appId = approverId {
				scheduledCertObj.approvedRejectedById = "\(appId)"
			}
            if submittedDate != nil{
                scheduledCertObj.submittedDate = submittedDate
            }
            
            try managedContext.save()
        } catch{
            managedContext.rollback()
            debugPrint("Error while updating certification status in \(type(of: self))")
        }
    }
    
}

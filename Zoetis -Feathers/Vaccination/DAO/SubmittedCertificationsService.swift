//
//  SubmittedCertificationsService.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 21/07/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation

final  public class SubmittedCertificationsService{
    private init(){}
    static let sharedInstance = SubmittedCertificationsService()
    
    func insertData(userId:String, _ certificationArr:[GetSubmittedCertificationsDTO]){
        for certificationObj in certificationArr{
            let certObj = getCertificationVMObj(certificationObj.trainingSchedulesInfo)
            if certObj != nil{
                let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: userId, certificationId: certObj?.certificationId ?? "")
                if startedObj == nil{
                    
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId:userId, lastModuleName:VaccinationModuleNames.none, certificationId:certObj?.certificationId ?? "", subModule:"", certificationCategoryId: certObj?.certificationCategoryId ?? "",  certObj: certObj!)
                    var status = VaccinationCertificationStatus.inProgress
                    if let trainingId = certObj?.trainingStatus {
                        
                        switch Int64(trainingId) {
                        case 1:
                            var status = VaccinationCertificationStatus.inProgress
                        case 2:
                            status = VaccinationCertificationStatus.draft
                        case 3 :
                            status = VaccinationCertificationStatus.submitted
                        case 4:
                            status = VaccinationCertificationStatus.submitted
                        default:
                            status = VaccinationCertificationStatus.rejected
                        }                               }
                    let dateFormatterObj =  DateFormatter()
                    
                    dateFormatterObj.timeZone = Calendar.current.timeZone
                    dateFormatterObj.locale = Calendar.current.locale
                    dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    //                    dateFormatterObj.calendar = Calendar(identifier: .gregorian)
                    //                    dateFormatterObj.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    
                    VaccinationDashboardDAO.sharedInstance.updateSubmittedDate(userId:userId,  certificationId: certObj?.certificationId ?? "", status: status,certCategoryId:certObj?.certificationCategoryId ?? "", certObj: certObj!,submittedDate: certObj?.submittedDate )
                    
                    
                    if let employeeArr = certificationObj.operatorInfo{
                        let employeeArr = certificationObj.operatorInfo
                        var i:Int32 = 1
                        for employee in employeeArr!{
                            AddEmployeesDAO.sharedInstance.addCertEmployee(userId: userId, certificationId: certObj?.certificationId ?? "", employeeObj: getEmployeeObj(sortOrder: Int32(i),certId:certObj?.certificationId ?? "", userId:userId, dto:employee))
                            i += 1
                        }
                    }
                }
                UserFilledQuestionnaireDAO.sharedInstance.saveGetResponseQuestionData(userId: userId, certificationId: certObj?.certificationId ?? "", operatorCert: certificationObj.operatorCertification, safetyCert: certificationObj.safetyCertification ,vaccineMixCert: certificationObj.vaccineMixtureCertification , shippingAddressDetails : certificationObj.vacOperatorFSSgAddress)
            }
        }
    }
    
    func getEmployeeObj(sortOrder:Int32, certId:String, userId:String, dto:GetSubmittedOperatorInfoDTO?)->VaccinationEmployeeVM{
        var empObj = VaccinationEmployeeVM()
        empObj.certificationId = certId
        empObj.sortOrder = sortOrder
        empObj.createdDate = Date()
        if let customerId = dto?.customerID{
            empObj.customerId = String(customerId)
        }
        if let siteId = dto?.siteID{
            empObj.siteId = String(siteId)
        }
        empObj.employeeId = dto?.operatorUniqueID
        empObj.firstName = dto?.firstName
        empObj.middleName = dto?.middleName
        empObj.lastName = dto?.lastName
        if let langId = dto?.languageID{
            empObj.selectedLangId = String(langId)
        }
        empObj.selectedLangValue = dto?.languageName ?? ""
        empObj.selectedTshirtValue = dto?.tshirtSize
        if let tShirtSizeId = dto?.tshirtSizeID{
            empObj.selectedTshirtId = String(tShirtSizeId)
        }
        empObj.signBase64 = dto?.signatureBase64
        empObj.userId = userId
        empObj.startDate = dto?.fromDate
        
        if let id = dto?.id{
            empObj.selectedUserId = String(id)
        }
        if let roleArr = dto?.roles{
            var roleVMArr = [DropwnMasterDataVM]()
            for role in roleArr{
                var roleObj = DropwnMasterDataVM()
                if let id = role.roleID{
                    roleObj.id = String(id)
                }
                
                roleObj.userId = userId
                roleObj.value = role.roleName
                roleObj.isSelected = true
                roleVMArr.append(roleObj)
            }
            
            let  selectedValArr = roleVMArr.map{ $0.value ?? ""}
            let encoder = JSONEncoder()
            var selectedObjStr  = ""
            let dataObj = try? encoder.encode(roleVMArr)
            if dataObj != nil{
                let str = NSString(data: dataObj!, encoding: String.Encoding.utf8.rawValue)
                selectedObjStr = str as String?  ?? ""
                empObj.rolesArrStr = selectedObjStr
            }
            let selectedValStr =  selectedValArr.joined(separator: ", ")
            empObj.selectedRolesStr = selectedValStr
            
        }
        return empObj
    }
    
    func getCertificationVMObj(_ trainingData:GetSubmittedTrainingSchedulesInfoDTO?)-> VaccinationCertificationVM?{
        if let certData = trainingData{
            var certObj = VaccinationCertificationVM()
            
            certObj.syncStatus = VaccinationCertificationSyncStatus.synced.rawValue
            certObj.fsrName = certData.assignToName
            certObj.approveRejectFsmId = certData.approvedRejectedByID
            if let assignToId = certData.assingToID{
                certObj.fsrId = String(assignToId)
            }
            certObj.certificationTypeName = certData.certificateType
            certObj.certification_Type_Id = certData.certification_Type_Id
            if let certTypeId = certData.certificateTypeID{
                certObj.certificationTypeId = String(certTypeId)
            }
            if let customerId = certData.customerID{
                certObj.customerId = String(customerId)
            }
            certObj.customerName = certData.customerName
            if let siteId = certData.siteID{
                certObj.siteId = String(siteId)
            }
            certObj.siteName = certData.siteName
            certObj.customerShippingId = certData.custShipping
            certObj.deviceId = certData.deviceID
            
            if let existingSite  = certData.existingSite{
                certObj.isExistingSite = existingSite
            }else{
                certObj.isExistingSite = false
            }
            certObj.fsrSignature = certData.fsrSignatureBase64
            certObj.hatcheryManagerSign = certData.hatcheryManagerSignatureBase64
            certObj.fsmName = certData.hatcheryManagerName
            
            
            if let trainingId = certData.trainingStatus{
                certObj.trainingStatus = String(trainingId)
                switch trainingId {
                case 1:
                    certObj.certificationStatus
                    = VaccinationCertificationStatus.inProgress.rawValue
                case 2:
                    certObj.certificationStatus = VaccinationCertificationStatus.draft.rawValue
                    
                case 3 :
                    certObj.certificationStatus = VaccinationCertificationStatus.submitted.rawValue
                case 4:
                    certObj.certificationStatus = VaccinationCertificationStatus.submitted.rawValue
                default:
                    certObj.certificationStatus = VaccinationCertificationStatus.rejected.rawValue
                }
            }
            if let id = certData.id{
                certObj.systemCertificationId = String(id)
                certObj.certificationId = String(id)
            }
            
            certObj.scheduledDate = certData.scheduleDate
            if let submittedDate =  certData.submitedDate{
                let dateFormatterObj  = CodeHelper.sharedInstance.getDateFormatterObj(submittedDate)
                let dateObj = dateFormatterObj.date(from: submittedDate)
                certObj.submittedDate = dateObj
            }
            certObj.colleagueName = certData.gpColleagueName
            certObj.colleagueJobTitle = certData.gpColleagueJobTitle
            certObj.supervisorName = certData.gpSupervisorName
            certObj.supervisorJobTitle = certData.gpSupervisorJobTitle
            
            if certObj.certification_Type_Id == 1 {
                certObj.certificationCategoryId = "2"
                certObj.certificationCategoryName = "Operator"
            }
            else {
                certObj.certificationCategoryId = VaccinationConstants
                    .LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                certObj.certificationCategoryName = VaccinationConstants
                    .LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
                if let dId = certData.deviceID{
                    if dId != ""{
                        let deviceIdComponents = dId.components(separatedBy: "_")
                        if deviceIdComponents.count > 1{
                            let safetyCertId = deviceIdComponents[1]
                            certObj.certificationId = safetyCertId
                        }
                    }
                    
                }
            }
            return certObj
        }
        return nil
    }
    
}

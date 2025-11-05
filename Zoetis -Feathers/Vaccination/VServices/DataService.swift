//
//  DataService.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 03/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import UIKit

class DataService{
    private init(){}
    static let sharedInstance = DataService()
    
    func getScheduledCertifications(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        
        let url = ZoetisWebServices.EndPoint.getUpcomingCertifications.latestUrl + loginuserId
        debugPrint(url)
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else{ completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData {
							do {
								if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
									trainingScheduleArray = jsonArray
								}
							} catch {
								print("Error decoding JSON: \(error)")
							}

                            let vaccinationCertificationObj = try? jsonDecoder.decode([VaccinationCertificationsResponseDTO].self, from: data)
                            VaccinationDashboardDAO.sharedInstance.saveUpcomingCertifications(certificationDTOArr: vaccinationCertificationObj ?? [VaccinationCertificationsResponseDTO](), loginUserId: loginuserId)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }else{
                                completion("No Data Found", nil)
                            }
                        }
                    }
                }
            }
            else{
                completion("No Data Found", nil)
            }
        })
    }
    
    func getCertificationMasterQuestions(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        let url = ZoetisWebServices.EndPoint.getQuestionsMasterData.latestUrl
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else{ completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationMasterQuestionsResponseObj = try? jsonDecoder.decode(CertificationQuestionTypesDTO.self, from: data)
                            if vaccinationMasterQuestionsResponseObj != nil{
                                QuestionnaireDAO.sharedInstance.saveQuestionData(dtoObj: vaccinationMasterQuestionsResponseObj!, userId: loginuserId)
                            }
                            completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            
                        }
                    }
                    
                }
            }
        })
    }
    
    func getDropdownMasterData(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        let url = ZoetisWebServices.EndPoint.getVaccinationMasterDropdowndata.latestUrl
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationMasterQuestionsResponseObj = try? jsonDecoder.decode(MasterDataTypesDTO.self, from: data)
                            if vaccinationMasterQuestionsResponseObj != nil{
                                AddEmployeesDAO.sharedInstance.saveDropdownMasterData(dtoObj:vaccinationMasterQuestionsResponseObj! , loginUserId: loginuserId)
                            }
                            completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                        }
                    }
                    
                }
            }
        })
        
        
    }
    
    func getEmployeesById(loginuserId:String, viewController:UIViewController, customerId:String, siteId:String, completion: @escaping (String?, NSError?) -> Void){
        let url = ZoetisWebServices.EndPoint.getEmployessById.latestUrl + "?customerId=\(customerId)&siteId=\(siteId)"
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let employeesArr = try? jsonDecoder.decode([EmployeesInformationDTO].self, from: data)
                            if employeesArr != nil{
                                AddEmployeesDAO.sharedInstance.saveEmployees(loginUserId: loginuserId, customerId: customerId, siteId: siteId, empoyeeDTO: employeesArr!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                            
                        }
                    }
                    
                }
            }
        })
        
    }
    
	func getFilledCertObj(certificationId:String, userId:String, siteId:String, customerId:String, fssId: Int = 0 , FsrId: String, trainingId: Int = 0, approverId:Int? = nil)-> [String:Any]?{
        let mainCertObj = VaccinationCertificationDetail()
        let vacStartedCertObj = VaccinationDashboardDAO.sharedInstance.getStartedCertStatusMoObj(userId:userId , certificationId: certificationId)
        mainCertObj.OperatorInfo = fillOperatorInfo(certificationId:certificationId, userId:userId, customerId: customerId, siteId: siteId)
        mainCertObj.QuestionAnswer = fillQuestionAnsData(certificationId:certificationId, userId:userId)
        if vacStartedCertObj?.certificationCategoryId != "1" {
            if trainingId != 0 {
                
                let ccData = fetchCountryAndState(certId: certificationId)
                
                let primaryAddresses = fillShippingAddressInfo(certificationId:certificationId, userId:userId, customerId: customerId, siteId: siteId, fssId: fssId , fsrId: FsrId, trainingId: trainingId)
                let otherAddresses = fillOtherShippingAddressInfo(certificationId:certificationId, userId:userId, customerId: customerId, siteId: siteId, fssId: fssId , fsrId: FsrId, trainingId: trainingId)

                mainCertObj.VacOperatorFSSgAddress = (primaryAddresses ?? []) + (otherAddresses ?? [])
                
                if let savedCountry = ccData?.countryId,
                   let savedState = ccData?.stateId {
                }
            } else {
                
                let primaryAddresses = fillShippingAddressInfo(certificationId:certificationId, userId:userId, customerId: customerId, siteId: siteId, fssId: fssId , fsrId: FsrId, trainingId: trainingId)
                let otherAddresses = fillOtherShippingAddressInfo(certificationId:certificationId, userId:userId, customerId: customerId, siteId: siteId, fssId: fssId , fsrId: FsrId, trainingId: trainingId)

                mainCertObj.VacOperatorFSSgAddress = (primaryAddresses ?? []) + (otherAddresses ?? [])
            }
        }
        else {
            mainCertObj.VacOperatorFSSgAddress = []
        }
        
        var cstmrId: Int?
        var cstmName: String?
        var siteId: Int?
        var SiteName: String?
        var selectedFSM: Int?
        var shipping: String?
        var certDate: String?
        var mangerName : String?
        
        if let otherDetails = ApproverStore.shared.getOtherCertificateDetail(for: certificationId) {
            print("Approver ID: \(otherDetails.customerId), Name: \(otherDetails.customerName)")
            cstmrId = Int(otherDetails.customerId)
            cstmName = otherDetails.customerName
            
            siteId = Int(otherDetails.siteId)
            SiteName = otherDetails.siteName
            selectedFSM = Int(otherDetails.selectedFsmId)
            shipping = otherDetails.custShipping
            certDate = otherDetails.dateSchedule
            mangerName = otherDetails.htchMngr
        }
        
        if let userId = UserContext.sharedInstance.userDetailsObj?.userId{
            if userId != ""{
                mainCertObj.CreatedBy = Int64(userId)
            }
        }
        if certificationId != ""{
            mainCertObj.Id = Int64(certificationId)
        }
        
        if customerId != ""{
            mainCertObj.CustomerId = Int64(customerId)
        }
        else{
            mainCertObj.CustomerId = Int64(cstmrId ?? 0)
        }
        if let  vacObj = vacStartedCertObj{
            if vacObj.siteid != nil {
                mainCertObj.SiteId = Int64(vacObj.siteid!)
            }
            else{
                mainCertObj.SiteId = Int64(siteId ?? 0)
            }
            
            if vacObj.certificationCategoryId == "1"{
                mainCertObj.OperatorCertificate = false
                mainCertObj.Cretification_Type_Id = 2
            }else{
                mainCertObj.OperatorCertificate = true
                mainCertObj.Cretification_Type_Id = 1
            }
            if vacObj.siteName != nil {
                mainCertObj.SiteName = vacObj.siteName
            }
            else{
                mainCertObj.SiteName = SiteName
            }
            
            mainCertObj.AssignToName = vacObj.assignedName
            
            if vacObj.assignedTo != nil &&   vacObj.assignedTo != ""{
                mainCertObj.AssingToId = Int64(vacObj.assignedTo!)
            }
            if vacObj.certificationTypeId != nil && vacObj.certificationTypeId != ""{
                mainCertObj.CertificateTypeId = Int64(vacObj.certificationTypeId!)
            }
            mainCertObj.AssingToId = Int64(userId)
            
            if vacObj.custShippingNum != nil {
                mainCertObj.CustShipping = vacObj.custShippingNum
            }
            else{
                mainCertObj.CustShipping = shipping
            }
            
            mainCertObj.ExistingSite = vacObj.isExistingSite as? Bool
            if vacObj.certificationCategoryId == "1"{
                mainCertObj.OperatorCertificate = false
            } else{
                mainCertObj.OperatorCertificate = true
            }
            
            if vacObj.certificationStatus == VaccinationCertificationStatus.draft.rawValue {
                mainCertObj.TrainingStatus = "Draft"
                mainCertObj.TrainingStatusId = 2
            } else if vacObj.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {
                mainCertObj.IsAcknowledge = true
                if (UserContext.sharedInstance.userDetailsObj?.roleId?.contains(VaccinationConstants.Roles.ROLE_FSM_ID) ?? false || UserContext.sharedInstance.userDetailsObj?.roleId?.contains(VaccinationConstants.Roles.ROLE_TSR_ID) ?? false ) {
					mainCertObj.TrainingStatus = "Approved"
					mainCertObj.TrainingStatusId = 4
                } else {
                    if mainCertObj.OperatorCertificate {
                        mainCertObj.TrainingStatus = "Submitted"
                        mainCertObj.TrainingStatusId = 3
                    } else {
                        mainCertObj.TrainingStatus = "Approved"
                        mainCertObj.TrainingStatusId = 4
                    }
                }
            } else {
                mainCertObj.TrainingStatus = "Scheduled"
                mainCertObj.TrainingStatusId = 1
            }
            let dateFormatterObj = DateFormatter()
            
            dateFormatterObj.timeZone = Calendar.current.timeZone
            dateFormatterObj.locale = Calendar.current.locale
            dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let submittedDate = vacObj.submittedDate{
                mainCertObj.SubmitedDate = dateFormatterObj.string(from:submittedDate )
            }
            
            mainCertObj.GpColleagueName = vacObj.colleagueName
            mainCertObj.GpColleagueJobTitle = vacObj.colleagueJobTitle
            mainCertObj.GpSupervisorName = vacObj.supervisorName
            mainCertObj.GpSupervisorJobTitle = vacObj.supervisorJobTitle
            
            if vacObj.hatcheryManager != nil {
                mainCertObj.HatcheryManagerName = vacObj.hatcheryManager
            }
            else{
                mainCertObj.HatcheryManagerName = mangerName
            }
            
            mainCertObj.FSRSignature = vacObj.fsrSign
			if let appId = approverId {
				mainCertObj.ApprovedRejectedById = "\(appId)"
				mainCertObj.ApproverId = "\(appId)"
			} else {
				mainCertObj.ApprovedRejectedById = vacObj.approvedRejectedById
				mainCertObj.ApproverId = vacObj.approvedRejectedById
			}
            if mainCertObj.FSRSignature != nil && mainCertObj.FSRSignature != ""{
                mainCertObj.IsAcknowledge = true
            }
            
            if vacObj.hatcheryManagerSign != nil && vacObj.hatcheryManagerSign != ""{
                mainCertObj.IsAcknowledge = true
            }
            mainCertObj.HatcheryManagerSignature = vacObj.hatcheryManagerSign
            
            
            var formattedDateString = ""

            dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatterObj.locale = Locale(identifier: "en_US_POSIX")

            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM/dd/yyyy"

            if let rawDate = vacObj.scheduledDate, !rawDate.isEmpty,
               let parsedDate = dateFormatterObj.date(from: rawDate) {

                formattedDateString = dateFormatterObj.string(from: parsedDate)
                debugPrint("Formatted Scheduled Date: \(formattedDateString)")

            } else if let fallbackDate = dateFormatterObj.date(from: certDate ?? "") {
                formattedDateString = dateFormatterObj.string(from: fallbackDate)
                debugPrint("Fallback Cert Date Used: \(formattedDateString)")
            } else {
                debugPrint("⚠️ Failed to parse both scheduledDate and certDate.")
            }

            mainCertObj.ScheduleDate = formattedDateString            
            
            if vacObj.customerName != nil {
                mainCertObj.CustomerName = vacObj.customerName
            }
            else{
                mainCertObj.CustomerName = cstmName
            }
            
            if !(vacObj.deviceId != nil &&  vacObj.deviceId != ""){
                mainCertObj.DeviceId = getDeviceId(dateObj: vacObj.createdDate ?? (vacObj.submittedDate ?? Date() ), id: vacObj.certificationId ?? "")
                vacStartedCertObj?.deviceId = mainCertObj.DeviceId
                for value in mainCertObj.VacOperatorFSSgAddress! {
                    vacStartedCertObj?.fssId = NSNumber(value: value.fssID ?? 0)
                }
                VaccinationDashboardDAO.sharedInstance.saveCertStartedObj(moObj:vacStartedCertObj! )
            } else{
                mainCertObj.DeviceId =   vacObj.deviceId
            }
        }
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(mainCertObj)
        if data != nil{
            let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                debugPrint(jsonDict)
                return jsonDict
            } catch{
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getDeviceId(dateObj:Date, id:String)-> String{
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") ?? ""
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "MMddYYYYHHmmss"
        let dateStr = dateFormatter.string(from:dateObj)
        
        // var dateTimeOfAssessment = dateTimeOfAssessment  (format: )
        let deviceIdForServer = "\(dateStr)_\(id)_iOS_\(udid)"
        return deviceIdForServer
    }
    
    func postCertifications(loginuserId:String, viewController:UIViewController, param:[String:Any], completion: @escaping (String?, NSError?) -> Void){
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:param, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print("Post Request Params : \(jsonDataString)")
        } catch {
            // // print("JSON serialization failed:  \(error)")
        }
        
        let url = ZoetisWebServices.EndPoint.postvaccinationCertification.latestUrl
        ZoetisWebServices.shared.sendPostDataToServerVaccination(controller: viewController, parameters: param as JSONDictionary, url: url,  completion: {
            [weak self] (json, error) in
            guard let `self` = self, error == nil else { completion(nil, error) ;return  ;}
            if json["StatusCode"]  == 200{
                completion("SUCCESS", nil)
            } else {
                completion("FAILURE", nil)
            }
        })
    }
    
    func postNewCertifications(loginuserId:String, viewController:UIViewController, param:[String:Any], completion: @escaping (String?, NSError?) -> Void){
        let url = ZoetisWebServices.EndPoint.postNewvaccinationCertification.latestUrl
        var jsonDict : NSDictionary!
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:param, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print("Post Request Params : \(jsonDataString)")
        } catch {
        }
        ZoetisWebServices.shared.sendPostDataToServerVaccination(controller: viewController, parameters: param as JSONDictionary, url: url,  completion: {
            [weak self] (json, error) in
            guard let `self` = self, error == nil else { completion(nil, error) ;return  ;}
            if json["StatusCode"]  == 200{
                print("SUCCESS-\(json["Data"])")
                completion("SUCCESS-\(json["Data"])", nil)
            } else {
                completion("FAILURE", nil)
            }
        })
    }
    
    func fillShippingAddressInfo(certificationId:String, userId:String, customerId:String, siteId:String, fssId: Int , fsrId: String, trainingId: Int = 0) ->[ShippingAddressDTO]?{
        var shippingArr  = [ShippingAddressDTO]()
        if trainingId != 0  {
            let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: trainingId)
            let ccData = fetchCountryAndState(certId: certificationId)
            if let savedCountry = ccData?.countryId,
               let savedState = ccData?.stateId {
                
                shippingInfoDB?.countryID = shippingInfoDB?.countryID ?? savedCountry
                shippingInfoDB?.stateID = shippingInfoDB?.stateID ?? savedState
                shippingInfoDB?.address1 =   shippingInfoDB?.address1 ?? ccData?.addressLine1
                shippingInfoDB?.address2 =  shippingInfoDB?.address2 ?? ccData?.addressLine2
                shippingInfoDB?.city =  shippingInfoDB?.city ?? ccData?.city
                shippingInfoDB?.pincode =  shippingInfoDB?.pincode ?? ccData?.zip
                shippingInfoDB?.siteName = shippingInfoDB?.siteName
                shippingInfoDB?.siteId = shippingInfoDB?.siteId
                shippingInfoDB?.stateName = shippingInfoDB?.stateName
            }
            if shippingInfoDB != nil {
                shippingArr.append(shippingInfoDB!)
            }
        }
        else {
            let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(siteId) ?? 0)
            if fssId == 0 {
                shippingInfoDB?.id = 0
            } else {
                shippingInfoDB?.id =  Int(certificationId) ?? 0
            }
            let ccData = fetchCountryAndState(certId: certificationId)
            if let savedCountry = ccData?.countryId,
               let savedState = ccData?.stateId {
                
                shippingInfoDB?.countryID = shippingInfoDB?.countryID ?? savedCountry
                shippingInfoDB?.stateID = shippingInfoDB?.stateID ?? savedState
                shippingInfoDB?.address1 =   shippingInfoDB?.address1 ?? ccData?.addressLine1
                shippingInfoDB?.address2 =  shippingInfoDB?.address2 ?? ccData?.addressLine2
                shippingInfoDB?.city =  shippingInfoDB?.city ?? ccData?.city
                shippingInfoDB?.pincode =  shippingInfoDB?.pincode ?? ccData?.zip
                shippingInfoDB?.siteName = shippingInfoDB?.siteName
                shippingInfoDB?.siteId = shippingInfoDB?.siteId
                shippingInfoDB?.stateName = shippingInfoDB?.stateName
            }
            
            if let id = shippingInfoDB?.fssID {
                
                print("ID is: \(id)")
            } else {
            }
            shippingInfoDB?.trainingID =  Int(certificationId) ?? 0
            if shippingInfoDB != nil {
                shippingArr.append(shippingInfoDB!)
            }
        }
        return shippingArr
        
        
    }
    
    
    
    
    func fillOtherShippingAddressInfo(certificationId:String, userId:String, customerId:String, siteId:String, fssId: Int , fsrId: String, trainingId: Int = 0) ->[ShippingAddressDTO]?{
        var shippingArr  = [ShippingAddressDTO]()
        if trainingId != 0  {
            let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingAddressByTrainingId(trainingId: trainingId)
            let ccData = fetchCountryAndState(certId: certificationId)
            if let savedCountry = ccData?.countryId,
               let savedState = ccData?.stateId {
                shippingInfoDB?.countryID = shippingInfoDB?.countryID
                shippingInfoDB?.stateID = shippingInfoDB?.stateID
                shippingInfoDB?.stateName =  shippingInfoDB?.stateName
                shippingInfoDB?.countryName = shippingInfoDB?.countryName
                shippingInfoDB?.address1 = shippingInfoDB?.address1
                shippingInfoDB?.address2 =  shippingInfoDB?.address2
                shippingInfoDB?.city =  shippingInfoDB?.city
                shippingInfoDB?.pincode = shippingInfoDB?.pincode
                shippingInfoDB?.siteId =  shippingInfoDB?.siteId
                shippingInfoDB?.siteName = shippingInfoDB?.siteName
                
            }
            if shippingInfoDB != nil {
                shippingArr.append(shippingInfoDB!)
            }
        }
        else {
            let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(siteId) ?? 0)
            if fssId == 0 {
                shippingInfoDB?.id = 0
            } else {
                shippingInfoDB?.id =  Int(certificationId) ?? 0
            }
            let ccData = fetchCountryAndState(certId: certificationId)
            if let savedCountry = ccData?.countryId,
               let savedState = ccData?.stateId {
                shippingInfoDB?.countryID = shippingInfoDB?.countryID
                shippingInfoDB?.stateID = shippingInfoDB?.stateID
                shippingInfoDB?.stateName =  shippingInfoDB?.stateName
                shippingInfoDB?.countryName = shippingInfoDB?.countryName
                shippingInfoDB?.address1 = shippingInfoDB?.address1
                shippingInfoDB?.address2 =  shippingInfoDB?.address2
                shippingInfoDB?.city =  shippingInfoDB?.city
                shippingInfoDB?.pincode = shippingInfoDB?.pincode
                shippingInfoDB?.siteId =  shippingInfoDB?.siteId
                shippingInfoDB?.siteName = shippingInfoDB?.siteName
            }
            
            if let id = shippingInfoDB?.fssID {
                
                print("ID is: \(id)")
            } else {
            }
            shippingInfoDB?.trainingID =  Int(certificationId) ?? 0
            if shippingInfoDB != nil {
                shippingArr.append(shippingInfoDB!)
            }
        }
        return shippingArr
        
    }
    
    
    func fillOperatorInfo(certificationId:String, userId:String, customerId:String, siteId:String)->[OperatorInfoDTO]?{
        var operatorArr = [OperatorInfoDTO]()
        let moObjArr:[VaccinationEmployeeVM] = AddEmployeesDAO.sharedInstance.getAllCertEmployees(userId: userId, certificationId: certificationId)
        if moObjArr.count > 0{
            for moObj in moObjArr{
                let operatorObj = OperatorInfoDTO()
                if moObj.employeeId != nil && moObj.employeeId != ""{
                    operatorObj.Id = Int64.init(moObj.employeeId!)
                    operatorObj.OperatorUniqueId = moObj.employeeId
                }
                operatorObj.FirstName = moObj.firstName
                operatorObj.MiddleName = moObj.middleName
                operatorObj.LastName = moObj.lastName
                if userId != ""{
                    operatorObj.CreatedBy = Int64.init(userId)
                }
                operatorObj.CustomerId = Int64(customerId)
                operatorObj.SiteId = Int64(siteId)
                operatorObj.OperatorSignature = moObj.signBase64
                if moObj.selectedLangId != ""{
                    operatorObj.LanguageId = Int64(moObj.selectedLangId)
                }
                if let selectedTshirtId = moObj.selectedTshirtId{
                    operatorObj.TshirtSizeId = Int64(selectedTshirtId)
                }
                let selectedValueObjStr = moObj.rolesArrStr
                var selectedRoleArr = [DropwnMasterDataVM]()
                if selectedValueObjStr != "" && selectedValueObjStr != nil{
                    
                    let data = selectedValueObjStr?.data(using: .utf8)
                    let decoder = JSONDecoder()
                    do{
                        if data != nil{
                            selectedRoleArr =  try decoder.decode([DropwnMasterDataVM].self, from: data!)
                            var roleDTOArr = [RolesTransferDTO]()
                            for role in selectedRoleArr{
                                roleDTOArr.append(fillRolesObj(role))
                            }
                            operatorObj.Roles = roleDTOArr
                        }
                    } catch{
                        
                    }
                    
                    
                    let dateFormatterObj = DateFormatter()
                    dateFormatterObj.timeZone = Calendar.current.timeZone
                    dateFormatterObj.locale = Calendar.current.locale
                    dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    operatorObj.FromDate = moObj.startDate
                    operatorArr.append(operatorObj)
                }
            }
        }
        if operatorArr.count > 0{
            return operatorArr
        }
        return nil
    }
    
    
    func fillRolesObj(_ roleVMObj: DropwnMasterDataVM)-> RolesTransferDTO{
        let rolesDTO = RolesTransferDTO()
        if roleVMObj.id != nil && roleVMObj.id != ""{
            rolesDTO.RoleId = Int64(roleVMObj.id!)
        }
        
        rolesDTO.RoleName = roleVMObj.value
        rolesDTO.IsSelected = roleVMObj.isSelected
        return rolesDTO
    }
    
    
    func fillQuestionAnsData(certificationId:String, userId:String) -> [QuestionAnswerDTO]?{
        var questionArr = [QuestionAnswerDTO]()
        let questionnaireVMObj = UserFilledQuestionnaireDAO.sharedInstance.fetchQuestionnaireData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: certificationId )
        
        if questionnaireVMObj?.questionTypeObj != nil && (questionnaireVMObj?.questionTypeObj?.count)! > 0{
            for qustionTypeObj in (questionnaireVMObj?.questionTypeObj)!{
                if qustionTypeObj.questionCategories != nil && qustionTypeObj.questionCategories!.count > 0{
                    for categoryObj in qustionTypeObj.questionCategories!{
                        let questionAnswerDTO =  QuestionAnswerDTO()
                        if categoryObj.categoryId != nil && categoryObj.categoryId != ""
                        {
                            questionAnswerDTO.catId = Int64(categoryObj.categoryId!)
                        }
                        if categoryObj.typeId != nil && categoryObj.typeId != ""
                        {
                            questionAnswerDTO.TypeId = Int64(categoryObj.typeId!)
                        }
                        
                        questionAnswerDTO.CategorieName = categoryObj.categoryName
                        var moduleAssessmentArr =  [ModuleAssessmentsCertDTO]()
                        if categoryObj.questionArr != nil && categoryObj.questionArr!.count > 0{
                            for questionObj in categoryObj.questionArr!{
                                let  moduleAssObj = ModuleAssessmentsCertDTO()
                                if questionObj.questionId != nil && questionObj.questionId != ""{
                                    moduleAssObj.Assessment_Id = Int64( questionObj.questionId!)
                                }
                                if certificationId != ""{
                                    moduleAssObj.TrainingScheduleId = Int64(certificationId)
                                }
                                
                                moduleAssObj.Answer = questionObj.selectedResponse
                                moduleAssObj.LocationPhone = questionObj.locationPhone
                                moduleAssObj.SequenceNo = Int( questionObj.sequenceNo ?? 0)
                                if questionObj.categoryId != nil && questionObj.categoryId != ""{
                                    moduleAssObj.ModuleCatId = Int64(questionObj.categoryId!)
                                }
                                
                                moduleAssObj.Comments = questionObj.userComments
                                moduleAssessmentArr.append(moduleAssObj)
                            }
                        }
                        questionAnswerDTO.ModuleAssessments = moduleAssessmentArr
                        
                        var attendeeDetails = [AddAttendeeDetailsDTO]()
                        if let employees =  categoryObj.employees{
                            if employees.count > 0{
                                for categoryEmp in employees{
                                    let attendeeObj =  AddAttendeeDetailsDTO()
                                    if userId != nil && userId != ""{
                                        attendeeObj.CreatedBy = Int64(userId)
                                    }
                                    if categoryObj.categoryId != nil && categoryObj.categoryId != ""{
                                        attendeeObj.ModuleCatId = Int64(categoryObj.categoryId!)
                                    }
                                    if certificationId != nil && certificationId != ""{
                                        attendeeObj.TrainingId = Int64(certificationId)
                                    }
                                    if certificationId != nil && certificationId != ""{
                                        attendeeObj.TrainingId = Int64(certificationId)
                                    }
                                    if categoryEmp.employeeId != nil && categoryEmp.employeeId != ""{
                                        attendeeObj.OperatorId = Int64(categoryEmp.employeeId!)
                                        attendeeObj.OperatorUniqueId = categoryEmp.employeeId
                                    }
                                    
                                    attendeeDetails.append(attendeeObj)
                                }
                            }
                            
                        }
                        questionAnswerDTO.AddAttendeeDetails = attendeeDetails
                        questionArr.append(questionAnswerDTO)
                    }
                }
            }
        }
        
        if questionArr.count > 0{
            return questionArr
        }
        return nil
    }
    
    func getVaccinationCustomers(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        
        let url = ZoetisWebServices.EndPoint.getCustomersByUserId.latestUrl + loginuserId
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: {
            [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationCertificationObj = try? jsonDecoder.decode([CustomerDTO].self, from: data)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                VaccinationCustomersDAO.sharedInstance.insertCustomers(userId: loginuserId, customerDTOArr: vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                        }
                    }
                    
                }else{
                    
                }
            }
            
        })
    }
    
    
    func getVaccinationCustomerSites(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        
        let customers = VaccinationCustomersDAO.sharedInstance.getCustomersVM(userId: loginuserId)
        let customerIdsStr = customers.map{ $0.customerId ?? ""}.joined(separator: ",")
        
        let url = ZoetisWebServices.EndPoint.getSiteByCustomerIds.latestUrl + customerIdsStr
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationCertificationObj = try? jsonDecoder.decode([CustomerSitesDTO].self, from: data)
                            
                            
                            //  print(vaccinationCertificationObj!.count)// ?? 100)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                VaccinationCustomersDAO.sharedInstance.insertCustomerSites(userId: loginuserId
                                                                                           , customerDTOArr: vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
        })
    }
    
    func getVaccinationFSMList(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = ZoetisWebServices.EndPoint.getFSMList.latestUrl + String(countryId)
        
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationCertificationObj = try? jsonDecoder.decode([FSMListDTO].self, from: data)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                VaccinationCustomersDAO.sharedInstance.insertFSMList(userId: loginuserId, FSMListDTOArr:vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                        }
                    }
                    
                }
            }
            
        })
    }
    func getVaccinationStateList(countryId: String, viewController:UIViewController,stateId:Int? = nil, completion: @escaping (String?, NSError?) -> Void){
        // let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = ZoetisWebServices.EndPoint.getStateList.latestUrl + String(countryId)
        
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationCertificationObj = try? jsonDecoder.decode([StateListDTO].self, from: data)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0 {
                                
                                if let stateIdd = stateId {
                                    trainingStateName = self?.getStateName(from: stateIdd, in: vaccinationCertificationObj!)
                                }
                                VaccinationCustomersDAO.sharedInstance.insertStateList(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", StateListDTOArr:vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                        }
                    }
                    
                }
            }
        })
    }
        
    func getStateName(from stateId: Int, in states: [StateListDTO]) -> String? {
        return states.first { $0.stateId == stateId }?.stateName
    }
    
    fileprivate func handleVaccCountryList(_ loginuserId:String,_ responseStr: String, _ jsonDecoder: JSONDecoder, completion: @escaping (String?, NSError?) -> Void) {
        if responseStr != ""{
            let jsonData = try? Data(responseStr.utf8 )
            if let data = jsonData{
                let vaccinationCertificationObj = try? jsonDecoder.decode([CountryListDTO].self, from: data)
                if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                    VaccinationCustomersDAO.sharedInstance.insertCountryList(userId: loginuserId, CountryListDTOArr:vaccinationCertificationObj!)
                    completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                }
            }
        }
    }
    
    func getVaccinationCountryList(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        
        let url = ZoetisWebServices.EndPoint.getPECountry.latestUrl
        
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            let vaccinationCertificationObj = try? jsonDecoder.decode([CountryListDTO].self, from: data)
                            if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                VaccinationCustomersDAO.sharedInstance.insertCountryList(userId: loginuserId, CountryListDTOArr:vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                        }
                    }
                    
                }
            }
            
        })
    }
    
    
    //GetSubmittedCertificationsDTO
    func getSubmittedCertifications(loginuserId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        let url = ZoetisWebServices.EndPoint.getSubmittedCertifications.latestUrl + loginuserId
        print(url)
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{
                if let response = responseJSONDict["Data"]{
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            _ = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            do {
                                let model = try JSONDecoder().decode([GetSubmittedCertificationsDTO].self, from: data)
                                debugPrint(model)
                            }
                            catch {
                                //print(error.localizedDescription)
                                debugPrint(String(describing: error))
                            }
                            let vaccinationCertificationObj = try? jsonDecoder.decode([GetSubmittedCertificationsDTO].self, from: data)
                            if vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                VaccinationCustomersDAO.sharedInstance.deleteAllData("VaccinationStartedCertifications")
                                VaccinationCustomersDAO.sharedInstance.deleteAllData("VaccinationShippingAddress")
                                SubmittedCertificationsService.sharedInstance.insertData(userId: loginuserId, vaccinationCertificationObj!)
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                            }
                            completion("No Data Found", nil)
                            
                        }
                        
                    }
                    
                }
            }
            
        })
    }
    
   
    func getShippingDetails(loginuserId:String, SelectedFsmId:String,  SelectedSiteId:String, certId:String, viewController:UIViewController, completion: @escaping (String?, NSError?) -> Void){
        
        let url = ZoetisWebServices.EndPoint.getShippingAddressDetails.latestUrl + SelectedFsmId + "&SiteId=" + String(SelectedSiteId)
        print(url)
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else { completion(nil, error) ;return  ;}
            if let responseJSONDict = json.dictionary{

                if let response = responseJSONDict["Data"]{
                    if response == [] {
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let responseStr = response.description
                    if responseStr != ""{
                        let jsonData = try? Data(responseStr.utf8 )
                        if let data = jsonData{
                            
                            do {
                                let model = try JSONDecoder().decode([ShippingAddressDTO].self, from: data)
                                debugPrint(model)
                            }
                            catch {
                                //print(error.localizedDescription)
                                debugPrint(String(describing: error))
                            }
                            
                            let shippingInfoObj = try? jsonDecoder.decode([ShippingAddressDTO].self, from: data)
                            if  shippingInfoObj != nil && shippingInfoObj?.count ?? 0 > 0{
                                
                                if shippingInfoObj?[0].fssID == 0{
                                    VaccinationCustomersDAO.sharedInstance.deleteShippingInfoByFssId(shippingInfoObj?[0].fssID ?? 0)
                                }
                                else
                                {
                                    VaccinationCustomersDAO.sharedInstance.deleteShippingInfoByFssId(Int(SelectedFsmId) ?? 0)
                                }
                             
                                UserDefaults.standard.setValue(shippingInfoObj?[0].countryID, forKey: "countryId")
                                VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: shippingInfoObj)
                                
                                //MARK:  Setting other shipping address details blank
                                VaccinationCustomersDAO.sharedInstance.setOtherShippingInfo(siteId: shippingInfoObj?[0].siteId ?? 0, trainingId: shippingInfoObj?[0].trainingID ?? 0, sitname: shippingInfoObj?[0].siteName ?? "", fsName: shippingInfoObj?[0].fssName ?? "", fsId: shippingInfoObj?[0].fssID ?? 0, cntryId:  0, CntryName: "")
                                Constants.updateSiteAddress = false
                                if let shippingInfo = shippingInfoObj?.first {
                                    if (shippingInfo.address1?.isEmpty ?? true) ||
                                       (shippingInfo.pincode?.isEmpty ?? true) ||
                                       (shippingInfo.city?.isEmpty ?? true) ||
                                       (shippingInfo.stateName?.isEmpty ?? true) {
                                        Constants.updateSiteAddress = true
                                    }
                                }
                                completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
                                
                                saveSiteAddress(certId: certId, countryId: shippingInfoObj?[0].countryID,
                                                stateId: shippingInfoObj?[0].stateID,
                                                addressLine1: shippingInfoObj?[0].address1,
                                                addressLine2: shippingInfoObj?[0].address2,
                                                city: shippingInfoObj?[0].city,
                                                zip: shippingInfoObj?[0].pincode,
                                                siteId: shippingInfoObj?[0].siteId,
                                                siteName: shippingInfoObj?[0].siteName,
                                                countryName: shippingInfoObj?[0].countryName,
                                                stateName: shippingInfoObj?[0].stateName,
                                                isOtherAddress: shippingInfoObj?[0].adddressType)
                            }
                        }
                    }
                    
                }
                
            }
            
        })
    }
    
    
}



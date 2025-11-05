//
//  Usercontext.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 31/03/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

public enum VaccinationCertificationAPICalls:String{
    case getScheduledCertifications
    case getQuestionsMasterData
    case getDropdownMasterData
    case getEmployeesMasterData
    case getVaccinationCustomers
    case getVaccinationCustomersSites
    case getVaccinationFSMList
    case getSubmittedCertifications
    case getVaccinationStatesList
    case getVaccinationCountryList
    
}

public class UserContext{
    private init(){print("Initializer")}
    static let sharedInstance = UserContext()
    
    var userDetailsObj:UserDetails?
    
    var getScheduledCertifications:Bool = false
    var getQuestionsMasterData = false
    var getDropdownMasterData = false
    var getEmployeesMasterData = false
    var getVaccinationCustomers = false
    var getVaccinationCustomersSites = false
    var getVaccinationFSMList = false
    var getSubmittedCertifications = false
    var getVaccinationStatesList = false
    var getVaccinationCountryList = false
    
    func hasAllDataLoaded() -> Bool{
        return getScheduledCertifications && getQuestionsMasterData && getDropdownMasterData && getEmployeesMasterData && getVaccinationCustomers && getVaccinationCustomersSites && getSubmittedCertifications && getVaccinationFSMList && getVaccinationStatesList && getVaccinationCountryList
    }
    
    
    func markSynced(apiCallName:VaccinationCertificationAPICalls,_ flag:Bool = true){
        switch apiCallName {
        case .getScheduledCertifications:
            getScheduledCertifications = flag
            debugPrint("getDropdownMasterData    1")
            break;
        case .getQuestionsMasterData:
            getQuestionsMasterData = flag
            debugPrint("getDropdownMasterData    2")
            break;
        case .getDropdownMasterData:
            getDropdownMasterData = flag
            debugPrint("getDropdownMasterData    3")
            break;
        case .getEmployeesMasterData:
            getEmployeesMasterData = flag
            debugPrint("getEmployeesMasterData    4")
            break;
            
        case .getVaccinationCustomers:
            getVaccinationCustomers = flag
            debugPrint("getVaccinationCustomers     5")
            break;
        case .getVaccinationCustomersSites:
            getVaccinationCustomersSites = flag
            debugPrint("getVaccinationCustomersSites    6")
            break;
            
        case .getVaccinationFSMList:
            getVaccinationFSMList = flag
            debugPrint("getVaccinationFSMList    8")
            break;
            
        case .getVaccinationStatesList:
            getVaccinationStatesList = flag
            debugPrint("getVaccinationStatesList    9")
            break;
            
        case .getVaccinationCountryList:
            getVaccinationCountryList = flag
            debugPrint("getVaccinationCountryList    10")
            break;
            
        case .getSubmittedCertifications:
            getSubmittedCertifications = flag
            debugPrint("getSubmittedCertifications    7")
            break;            
            
        default:
            break;
        }
        
    }
    
    func setUserDetails(_ userResponseObj:UserResponseDTO){
        userDetailsObj = UserDetails()
        UserContextDAO.sharedInstance.insertUserContext(loginResponse: userResponseObj)
        userDetailsObj?.phoneNumber = userResponseObj.phone
        
        userDetailsObj?.firstname = userResponseObj.firstName
        userDetailsObj?.lastName = userResponseObj.lastName
        userDetailsObj?.roleId = userResponseObj.roleIds
        userDetailsObj?.roleName = userResponseObj.roleId
        userDetailsObj?.userTypeId = userResponseObj.userTypeId
        userDetailsObj?.userId = userResponseObj.id
    }
    
    func setUserDetailsObjFromDB(){
        if let userDetailsObj = UserContextDAO.sharedInstance.getUserContextFilledObj(){
            self.userDetailsObj = userDetailsObj
            Crashlytics.crashlytics().setUserID(userDetailsObj.userId ?? "")
            Crashlytics.crashlytics().setCustomValue(PasswordService.shared.getUsername(), forKey: "Username")
        }
    }
    
}

//
//  UserContextDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 14/07/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit


final  public class UserContextDAO{
    private init(){print("Initializer")}
    static let sharedInstance = UserContextDAO()
    
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getUserContextObj() -> VaccinationUserContext{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationUserContext" , into: managedContext) as! VaccinationUserContext
        return vaccinationCertObj
    }
    
    func fetchUserContext() -> [VaccinationUserContext]{
        var vaccinationMasterDataArr = [VaccinationUserContext]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationUserContext")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            vaccinationMasterDataArr = try managedContext.fetch(fetchRequest) as! [VaccinationUserContext]
            
            
        } catch{
            debugPrint("Error while fetching Customers Master Data in \(type(of: self))")
        }
        return vaccinationMasterDataArr
    }
    
    func deleteUserContext(){
        do {
            
            for userContextObj in fetchUserContext(){
                managedContext.delete(userContextObj)
            }
            
            try managedContext.save()
            
            
            
        } catch{
            debugPrint("Error while deletiong Certification Customers in \(type(of: self))  vaccination")
        }
    }
    
    func insertUserContext(loginResponse: UserResponseDTO ){
        do{
            deleteUserContext()
            let userContextObj = getUserContextObj()
            convertDTOToMO(moObj:userContextObj, dtoObj:loginResponse)
            try managedContext.save()
            
        } catch{
            managedContext.rollback()
            debugPrint("Error while saving Custiomers in \(type(of: self))")
        }
    }
    
    func convertDTOToMO(moObj:VaccinationUserContext, dtoObj:UserResponseDTO){
        moObj.phoneNumber = dtoObj.phone
        moObj.firstname = dtoObj.firstName
        moObj.lastName = dtoObj.lastName
        moObj.roleId = dtoObj.roleIds
        moObj.roleName = dtoObj.roleId
        moObj.userTypeId = dtoObj.userTypeId
        moObj.userId = dtoObj.id
    }
    
    func getUserContextFilledObj()-> UserDetails?{
        let userContextFilledObjArr = fetchUserContext()
        if userContextFilledObjArr.count > 0{
            return convertMotoVO(moObj: userContextFilledObjArr[0])
        }
        return nil
    }
    
    func convertMotoVO(moObj:VaccinationUserContext)-> UserDetails{
        
        var userDetailsObj = UserDetails()
        userDetailsObj.phoneNumber = moObj.phoneNumber
        userDetailsObj.firstname = moObj.firstname
        userDetailsObj.lastName = moObj.lastName
        userDetailsObj.roleId = moObj.roleId
        userDetailsObj.roleName = moObj.roleName
        userDetailsObj.userTypeId = moObj.userTypeId
        userDetailsObj.userId = moObj.userId
        return userDetailsObj
    }
    
    
}

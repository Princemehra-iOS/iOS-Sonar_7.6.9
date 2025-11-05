//
//  SyncStatusDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum EntityName:String{
    case Questionnaire
    case Employees
    case MasterDropdownData
    case UserFilledQuestionnaire

}

enum EntityParameters:String{
    case userId
    case customerId
    case siteId
    case questionTypeId
    case certificationId
}

class SyncStatusDAO{
    static let sharedInstance = SyncStatusDAO()
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func checkIfRecordExists(for entityName:String, userId:String, siteId:String?, customerId:String?, evalParam1:String?, evalParam2:String?)-> VaccinationSyncStatus?{
        

        var syncStatusArr = [VaccinationSyncStatus]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccinationSyncStatus")
                      fetchRequest.returnsObjectsAsFaults = false
        
        if siteId != nil && customerId != nil && evalParam1 != nil && evalParam2 != nil{
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND param1 = %@ AND param2 = %@  AND idParamVal1 = %@ AND idParamVal2 = %@ AND entityDesc = %@", userId, evalParam1!, evalParam2!, siteId!,customerId!, entityName  )
        } else if (evalParam1 != nil && siteId != nil){
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND entityDesc = %@ AND param1 = %@ AND idParamVal1 = %@ ", userId ,entityName, evalParam1!, siteId!)
        } else{
            fetchRequest.predicate = NSPredicate(format:"userId = %@ AND entityDesc = %@", userId ,entityName)
        }
                      
                          do {
                              syncStatusArr = try managedContext.fetch(fetchRequest) as! [VaccinationSyncStatus]
                            if syncStatusArr.count > 0{
                                //Determine on basis of the Current Date
                                
                                return syncStatusArr[0]
                            }
                          }catch{
                              debugPrint("Error while if record exists Fetch Operation Sync Status in \(type(of: self))")

        }
        return nil
    }
    
    func saveSyncStatus(userLoginId:String, evalParam1:String?, evalParam2:String?, evalParam1Id:String?, evalParam2Id:String?, entityName:String){
        do{
            
            if let syncStatusObj = checkIfRecordExists(for: entityName, userId:userLoginId, siteId:evalParam1Id, customerId: evalParam2Id, evalParam1: evalParam1, evalParam2:evalParam2) {
                fillSyncStatusObj(syncStatusObj: syncStatusObj, userLoginId: userLoginId, evalParam1: evalParam1, evalParam2: evalParam2, evalParam1Id: evalParam1Id, evalParam2Id: evalParam2Id, entityName: entityName)
            } else{
                 fillSyncStatusObj(syncStatusObj: getSyncStatusObj(), userLoginId: userLoginId, evalParam1: evalParam1, evalParam2: evalParam2, evalParam1Id: evalParam1Id, evalParam2Id: evalParam2Id, entityName: entityName)
            }
            
            try managedContext.save()
        }catch{
            debugPrint("Error while creating the savesync status Object in  \(type(of: self))")

            try managedContext.rollback()
        }
        

    }
    
    func fillSyncStatusObj(syncStatusObj: VaccinationSyncStatus, userLoginId:String, evalParam1:String?, evalParam2:String?, evalParam1Id:String?, evalParam2Id:String?, entityName:String? ){
        syncStatusObj.entityDesc = entityName
        syncStatusObj.idParamVal1 = evalParam1Id
        syncStatusObj.idParamVal2 = evalParam2Id
        syncStatusObj.param1 = evalParam1
        syncStatusObj.param2 = evalParam2
        syncStatusObj.userId = userLoginId
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss
        
        syncStatusObj.createdDate = CodeHelper.sharedInstance.convertDateFormater( dateFormatter.string(from: Date()))
    }
    
    func getSyncStatusObj()->VaccinationSyncStatus{
        let syncStatusObj = NSEntityDescription.insertNewObject(forEntityName: "VaccinationSyncStatus" , into: managedContext) as! VaccinationSyncStatus
        return syncStatusObj
    }
}

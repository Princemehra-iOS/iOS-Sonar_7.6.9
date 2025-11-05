//
//  PEInfoDAO.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 09/11/20.
//

import Foundation
import CoreData
import UIKit

class PEInfoDAO{
    private init(){}
    static let sharedInstance = PEInfoDAO()
    
    let managedContext = (UIApplication.shared.delegate as? AppDelegate)!.managedObjectContext
    
    func getPlateTypeObj() -> PE_Info{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_Info" , into: managedContext) as! PE_Info
        return vaccinationCertObj
    }
    
    func deleteInfoObj(_ assessmentId:String){
        let userId = UserContext.sharedInstance.userDetailsObj?.userId ?? ""
        let predicate = NSPredicate(format:"userId = %@ AND assesmentId = %@", userId, assessmentId )
        deleteExisitingData(entityName: "PE_Info", predicate: predicate)
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

    func saveData(vaccineData: CoreDataHandlerPEModels.doaVaccinationSaveData) {
        let vaccinationCertificationArr = fetchInfoMoObj(userId: vaccineData.userId, assessmentId: vaccineData.assessmentId)

        if vaccinationCertificationArr.count > 0 {
            if vaccineData.override ?? true {  // Default override to true if nil
                let obj = vaccinationCertificationArr[0]
                obj.subcutaneousAntibioticTxt = vaccineData.subcutaneousTxt
                obj.dayOfAgeTxtAntibiotic = vaccineData.dayOfAgeTxt
                obj.isExtendedPE = vaccineData.isExtendedPE as NSNumber
                obj.hasChlorineStrips = vaccineData.hasChlorineStrips as NSNumber? ?? false as NSNumber
                obj.isAutomaticFail = vaccineData.isAutomaticFail as NSNumber? ?? false as NSNumber

                if let date = vaccineData.date {
                    obj.submittedDate = date
                }
            }
        } else {
            let moObj = getPlateTypeObj()
            moObj.subcutaneousAntibioticTxt = vaccineData.subcutaneousTxt
            moObj.dayOfAgeTxtAntibiotic = vaccineData.dayOfAgeTxt
            moObj.isExtendedPE = vaccineData.isExtendedPE as NSNumber
            moObj.assesmentId = vaccineData.assessmentId
            moObj.userId = vaccineData.userId
            moObj.submittedDate = vaccineData.date
            moObj.hasChlorineStrips = vaccineData.hasChlorineStrips as NSNumber? ?? false as NSNumber
            moObj.isAutomaticFail = vaccineData.isAutomaticFail as NSNumber? ?? false as NSNumber
        }

        do {
            try managedContext.save()
        } catch {
            print("Error while saving info object")
            managedContext.rollback()
        }
    }

    func fetchInfoMoObj(userId:String, assessmentId:String)-> [PE_Info]{
        var vaccinationCertificationArr = [PE_Info]()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Info")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"userId = %@ AND assesmentId = %@", userId, assessmentId )
        do {
            vaccinationCertificationArr = try managedContext.fetch(fetchRequest) as! [PE_Info]
        } catch{
            // managedContext.rollback()
            print("Error while fetching PE Scheduled Assessments in \(type(of: self))")
        }
        return vaccinationCertificationArr
    }
    
    func fetchInfoVMObj(userId:String,  assessmentId:String)-> PENewInfoVM?{
        let arr = fetchInfoMoObj(userId: userId, assessmentId: assessmentId)
        if arr.count >  0{
            return convertMoToVM(moObj: fetchInfoMoObj(userId: userId, assessmentId: assessmentId)[0])
        }
        return nil
        
    }
    
    func convertMoToVM(moObj:PE_Info)-> PENewInfoVM{
        let infoObj = PENewInfoVM()
        infoObj.userId = moObj.userId
        infoObj.assessmentId = moObj.assesmentId
        if let extendedPE = moObj.isExtendedPE{
            infoObj.isExtendedPE = extendedPE as? Bool ?? false
        }
        infoObj.submittedDate = moObj.submittedDate
        infoObj.subcutaneousAntibioticTxt = moObj.subcutaneousAntibioticTxt
        infoObj.dayOfAgeTxtAntibiotic = moObj.dayOfAgeTxtAntibiotic
        infoObj.hasChlorineStrips = moObj.hasChlorineStrips as? Bool ?? false
        infoObj.isAutomaticFail = moObj.isAutomaticFail as? Bool ?? false
        return infoObj
    }
    
}

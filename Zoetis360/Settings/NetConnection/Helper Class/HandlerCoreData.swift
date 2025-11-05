//
//  CoreDataHandler.swift
//  Zoetis -Feathers
//
//  Created by Chandan Kumar on 14/09/16.
//  Copyright © 2016 "". All rights reserved.

import Foundation
import CoreData
import UIKit


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


class CoreDataHandler : NSObject  {
    
    var backgroundContext  = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    var hatcheryVaccinationObject = [NSManagedObject]()
    var settingsSkeletaObject = [NSManagedObject]()
    var settingsCocoii = [NSManagedObject]()
    var settingsGITract = [NSManagedObject]()
    var settingsRespiratory  = [NSManagedObject]()
    var settingsImmune = [NSManagedObject]()
    var routeData = [NSManagedObject]()
    var CustData = [NSManagedObject]()
    var SalesRepData = [NSManagedObject]()
    var VetData = [NSManagedObject]()
    var CocoiiProgram = [NSManagedObject]()
    var BirdSize = [NSManagedObject]()
    var SessionType = [NSManagedObject]()
    var BreedType = [NSManagedObject]()
    var complexNsObJECT = [NSManagedObject]()
    var loginType = [NSManagedObject]()
    var postingSession = [NSManagedObject]()
    var cocciCoccidiosControl = [NSManagedObject]()
    var cocciAlternative = [NSManagedObject]()
    var cocciAntibotic = [NSManagedObject]()
    var cocciMyCoxtinBinders = [NSManagedObject]()
    var FeddProgram = [NSManagedObject]()
    var CustmerRep = [NSManagedObject]()
    var necrpsystep1 = [NSManagedObject]()
    var captureSkeletaObject = [NSManagedObject]()
    var captureBirdWithNotesObject = [NSManagedObject]()
    var moleCule = [NSManagedObject]()
    var cocoivacc = [NSManagedObject]()
    var capturePhotoObject = [NSManagedObject]()
    var FarmsTypeObject = [NSManagedObject]()
    var ProductionNsObJECT = [NSManagedObject]()
    var GenerationNsObJECT = [NSManagedObject]()
    var custRep = NSArray ()
    var dataArray = NSArray ()
    var dataSkeletaArray = NSArray ()
    var dataCociiaArray = NSArray ()
    var dataGiTractArray = NSArray ()
    var dataRespiratoryArray = NSArray()
    var postingArrayVetArray = NSMutableArray()
    var dataImmuneArray = NSArray()
    var routeArray = NSArray()
    var custArray = NSArray()
    var SalesRepDataArray = NSArray()
    var BirdSizeArray = NSArray()
    var CocoiiProgramArray = NSArray()
    var SessionTypeArray = NSArray()
    var BreedTypeArray = NSArray()
    var VeterianTypeArray = NSArray()
    var complexArray = NSArray()
    var loginArray = NSArray()
    var postingArray = NSArray()
    var cocciControlArray = NSArray()
    var AlternativeArray = NSArray()
    var AntiboticArray = NSArray()
    var MyCoxtinBindersArray = NSArray()
    var feedprogramArray = NSArray()
    var openExistingArray = NSArray()
    var necropsyStep1Array = NSArray()
    var necropsySArray = NSMutableArray()
    var MoleCuleArray = NSMutableArray()
    var FieldVaccindataArray = NSArray ()
    var captureNecSkeltetonArray = NSArray ()
    var obsNameWithPoint = NSMutableArray ()
    var fecthPhotoArray = NSArray ()
    var fetchBirdNotesArray = NSArray ()
    var farmsArrReturn = NSArray ()
    var productionArray = NSArray()
    var necropsyNIdArray = NSMutableArray()
    var generationArray = NSArray()
    override init() {
        super.init()
        self.setupContext()
    }
    
    func setupContext()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.backgroundContext = appDelegate.managedObjectContext
        
    }
    
    /********* Add Vacination *******************************************/
    // MARK: 🟠 Save Hatchery Vaccination in Database
    
    func saveHatcheryVacinationInDatabase(details: chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataArray = dbArray
        
        if dataArray.count > 0 {
            if let objTable: HatcheryVac = dataArray[index] as? HatcheryVac {
                objTable.setValue(details.type, forKey: "type")
                objTable.setValue(details.strain, forKey: "strain")
                objTable.setValue(details.route, forKey: "route")
                objTable.setValue(details.age, forKey: "age")
                objTable.setValue(details.postingId, forKey: "postingId")
                objTable.setValue(details.vaciProgram, forKey: "vaciNationProgram")
                objTable.setValue(details.sessionId, forKey: "loginSessionId")
                objTable.setValue(details.isSync, forKey: "isSync")
                objTable.setValue(details.lngId, forKey: "lngId")
                objTable.setValue(details.routeID, forKey: "routeId")
            }
            
            do {
                try managedContext.save()
            } catch {
                // Handle error if needed
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(details.type, forKey: "type")
            person.setValue(details.strain, forKey: "strain")
            person.setValue(details.route, forKey: "route")
            person.setValue(details.age, forKey: "age")
            person.setValue(details.postingId, forKey: "postingId")
            person.setValue(details.vaciProgram, forKey: "vaciNationProgram")
            person.setValue(details.sessionId, forKey: "loginSessionId")
            person.setValue(details.isSync, forKey: "isSync")
            person.setValue(details.lngId, forKey: "lngId")
            person.setValue(details.routeID, forKey: "routeId")
            
            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
        }
    }
 
    // MARK: 🟠 Fetch Saved Vaccination Data
    func fetchAddvacinationDataAll() -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HatcheryVac")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }  else  {
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataArray
        
    }
    // MARK: 🟠 Fetch Saved Vaccination Data as per Posting Id
    func fetchAddvacinationData(_ postnigId : NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVac")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postnigId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataArray
    }
    // MARK: 🟠 Fetch Saved Vaccination Data as per Posting Id & Sync Availablity
    func fetchAddvacinationDataWithisSync(_ postnigId : NSNumber , isSync : Bool) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVac")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postIdStatusPredicator, postnigId , NSNumber(booleanLiteral: isSync))
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataArray
        
    }
    // MARK: 🟠 Fetch Saved Posting Session with Vetenarian Name
    func fetchAllPostingSessionWithVetId(_VetName :String) -> NSMutableArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "vetanatrionName == %@", _VetName)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult != nil
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: PostingSession = (fetchedResult![i] as? PostingSession)!
                    let pId =  objTable.postingId
                    if postingArrayVetArray.count > 0{
                        if postingArrayVetArray.contains(pId ?? 0) == false{
                            postingArrayVetArray.add(pId ?? 0)
                        }
                    }
                    else{
                        postingArrayVetArray.add(pId ?? 0)
                    }
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return postingArrayVetArray
    }
    // MARK: 🟠 Fetch Saved Field Strain Data  *******************************************/
    
    fileprivate func handleFieldStrain1Validation(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute1Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge1"), forKey:"age")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleFieldStrain2(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute2Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge2"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleFieldStrain3Validation(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute3Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge3"), forKey:"age")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain4(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain4"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute4Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge4"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain5(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute5Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge5"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain6(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute6Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge6"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain7(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute7Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge7"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain8(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute8Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge8"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain9(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute9Id") as? Int {
            
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge9"), forKey:"age")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain10(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute10Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge10"), forKey:"age")
        
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handlefieldStrain11(_ dict: NSDictionary, _ person: inout NSManagedObject) {
        switch dict.value(forKey: "fieldRoute11Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        
        person.setValue(dict.value(forKey: "fieldAge11"), forKey:"age")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    func getHatcheryDataFromServer(_ dict : NSDictionary) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: backgroundContext)
        
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        
        for j in 0..<allkeyArr.count {
            var person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            let stringValidate = allkeyArr.object(at: j) as! String
            
            switch stringValidate {
            case "fieldStrain1":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain1"), forKey:"strain")
                handleFieldStrain1Validation(dict, &person)
            case "fieldStrain2":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain2"), forKey:"strain")
                handleFieldStrain2(dict, &person)
            case "fieldStrain3":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain3"), forKey:"strain")
                handleFieldStrain3Validation(dict, &person)
            case "fieldStrain4":
                handlefieldStrain4(person, dict)
            case "fieldStrain5":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain5"), forKey:"strain")
                handlefieldStrain5(dict, &person)
            case "fieldStrain6":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain6"), forKey:"strain")
                handlefieldStrain6(dict, &person)
            case "fieldStrain7":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain7"), forKey:"strain")
                handlefieldStrain7(dict, &person)
            case "fieldStrain8":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain8"), forKey:"strain")
                handlefieldStrain8(dict, &person)
            case "fieldStrain9":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain9"), forKey:"strain")
                handlefieldStrain9(dict, &person)
            case "fieldStrain10":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain10"), forKey:"strain")
                handlefieldStrain10(dict, &person)
            case "fieldStrain11":
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "fieldStrain11"), forKey:"strain")
                handlefieldStrain11(dict, &person)
            default:
                break
            }
            do {
                try backgroundContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            hatcheryVaccinationObject.append(person)
        }
        
    }
    // MARK: 🟢 Get Field Strain for specific Posting ID
    fileprivate func handlefieldStrain1GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBDV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain1"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute1Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge1"), forKey:"age")
        person.setValue(postingId, forKey:"postingId")
        
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain2GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBDV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain2"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute2Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge2"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain3GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain3"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute3Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge3"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain4GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain4"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute4Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge4"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain5GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("TRT", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain5"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute5Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge5"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain6GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("TRT", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain6"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute6Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge6"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain7GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("NDV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain7"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute7Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        
        person.setValue(dict.value(forKey: "fieldAge7"), forKey:"age")
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain8GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("NDV", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain8"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute8Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge8"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain9GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("ST", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain9"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute9Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "fieldAge9"), forKey:"age")
        
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain10GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("E.coli", forKey:"type")
        person.setValue(dict.value(forKey: "fieldStrain10"), forKey:"strain")
        switch dict.value(forKey: "fieldRoute10Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        
        person.setValue(dict.value(forKey: "fieldAge10"), forKey:"age")
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handlefieldStrain11GetHatcheryDataFromServer(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryVac", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("Other", forKey:"type")
        switch dict.value(forKey: "fieldRoute11Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        
        person.setValue(dict.object(forKey: "fieldStrain11"), forKey:"strain")
        person.setValue(dict.object(forKey: "fieldAge11"), forKey:"age")
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.object(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.object(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        try? managedContext.save()
        
        
        hatcheryVaccinationObject.append(person)
    }
    
    func getHatcheryDataFromServerSingleFromDeviceId(_ dict : NSDictionary,postingId:NSNumber)  {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        for j in 0..<allkeyArr.count {
            
            let stringValidate = allkeyArr.object(at: j) as! String
            let str = "hatchery"
            let index = stringValidate.index(stringValidate.startIndex, offsetBy: 8)
            let mySubstring = stringValidate[..<index]
            if mySubstring != str {
                
                switch stringValidate {
                case "fieldStrain1":
                    handlefieldStrain1GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain2":
                    handlefieldStrain2GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain3":
                    handlefieldStrain3GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain4":
                    handlefieldStrain4GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain5":
                    handlefieldStrain5GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain6":
                    handlefieldStrain6GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain7":
                    handlefieldStrain7GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain8":
                    handlefieldStrain8GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain9":
                    handlefieldStrain9GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain10":
                    handlefieldStrain10GetHatcheryDataFromServer(managedContext, dict, postingId)
                case "fieldStrain11":
                    handlefieldStrain11GetHatcheryDataFromServer(managedContext, dict, postingId)
                default:
                    break
                }
            }
        }
    }
    // MARK: 🟢**********************************  get Field Data From Server /
    
    fileprivate func handlehatcheryStrain1GetFieldDataFromServer1(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain1"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute1Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain2(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain2"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute2Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain3(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain3"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute3Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain4(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain4"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute4Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain5(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain5"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute5Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain6(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain6"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute6Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain7(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain7"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute7Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain8(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain8"), forKey:"strain")
        
        switch dict.value(forKey: "hatcheryRoute8Id") as? Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain9(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain9"), forKey:"strain")
        
        switch dict.value(forKey: "hatcheryRoute9Id") as? Int {
            
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    fileprivate func handleGetFieldDataFromServerhatcheryStrain10(_ person: NSManagedObject, _ dict: NSDictionary) {
        person.setValue("", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain10"), forKey:"strain")
        
        switch dict.value(forKey: "hatcheryRoute10Id") as? Int {
            
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
    }
    
    func getFieldDataFromServer(_ dict : NSDictionary)  {
        
        let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: backgroundContext)
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        
        for j in 0..<allkeyArr.count {
            let person  = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            
            let stringValidate = allkeyArr.object(at: j) as! String
            
            switch stringValidate {
            case "hatcheryStrain1":
                handlehatcheryStrain1GetFieldDataFromServer1(person, dict)
            case "hatcheryStrain2":
                handleGetFieldDataFromServerhatcheryStrain2(person, dict)
            case "hatcheryStrain3":
                handleGetFieldDataFromServerhatcheryStrain3(person, dict)
            case "hatcheryStrain4":
                handleGetFieldDataFromServerhatcheryStrain4(person, dict)
            case "hatcheryStrain5":
                handleGetFieldDataFromServerhatcheryStrain5(person, dict)
            case "hatcheryStrain6":
                handleGetFieldDataFromServerhatcheryStrain6(person, dict)
            case "hatcheryStrain7":
                handleGetFieldDataFromServerhatcheryStrain7(person, dict)
            case "hatcheryStrain8":
                handleGetFieldDataFromServerhatcheryStrain8(person, dict)
            case "hatcheryStrain9":
                handleGetFieldDataFromServerhatcheryStrain9(person, dict)
            case "hatcheryStrain10":
                handleGetFieldDataFromServerhatcheryStrain10(person, dict)
            default:
                break
            }
            do {
                try backgroundContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            hatcheryVaccinationObject.append(person)
        }
    }
    // MARK: 🟢 Get Field Vaccination Data for specific Posting ID
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain1(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(dict.value(forKey: "hatcheryStrain1"), forKey:"strain")
        person.setValue("Marek", forKey:"type")
        switch dict.value(forKey: "hatcheryRoute1Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain2(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBDV", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain2"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute2Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain3(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("IBV", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain3"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute3Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain4(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("TRT", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain4"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute4Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain5(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("NDV", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain5"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute5Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain6(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("POX", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain6"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute6Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain7(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("Reo", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain7"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute7Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain8(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("ST", forKey:"type")
        let d = dict.mutableCopy() as! NSMutableDictionary
        let s = d.object(forKey: "hatcheryStrain8") as! String
        person.setValue(s, forKey:"strain")
        
        person.setValue(dict.value(forKey: "hatcheryStrain8"), forKey:"strain")
        
        switch dict.value(forKey: "hatcheryRoute8Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain9(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("E.coli", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain9"), forKey:"strain")
        switch dict.value(forKey: "hatcheryRoute9Id") as! Int {
            
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    fileprivate func handleGetFieldDataFromServerSingledataHatcheryStrain10(_ managedContext: NSManagedObjectContext, _ dict: NSDictionary, _ postingId: NSNumber) {
        let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue("Others", forKey:"type")
        person.setValue(dict.value(forKey: "hatcheryStrain10"), forKey:"strain")
        
        switch dict.value(forKey: "hatcheryRoute10Id") as! Int {
        case 1:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 2:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 3:
            person.setValue(Constants.spray, forKey:"route")
        case 4:
            person.setValue(Constants.inovo, forKey:"route")
        case 5:
            person.setValue("Subcutaneous", forKey:"route")
        case 6:
            person.setValue("Intramuscular", forKey:"route")
        case 7:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 12:
            person.setValue(Constants.wingWeb, forKey:"route")
        case 13:
            person.setValue(Constants.drinkingWater, forKey:"route")
        case 14:
            person.setValue(Constants.spray, forKey:"route")
        case 15:
            person.setValue(Constants.inovo, forKey:"route")
        case 16:
            person.setValue("Subcutaneous", forKey:"route")
        case 17:
            person.setValue("Intramuscular", forKey:"route")
        case 18:
            person.setValue(Constants.eyeDrop, forKey:"route")
        case 20:
            person.setValue(Constants.aguaDeBebida, forKey:"route")
        case 21:
            person.setValue(Constants.spray, forKey:"route")
        case 22:
            person.setValue(Constants.inovo, forKey:"route")
        case 24:
            person.setValue("Intramuscular", forKey:"route")
        case 19:
            person.setValue(Constants.membranaDaAsa, forKey:"route")
        case 25:
            person.setValue("Ocular", forKey:"route")
        case 23:
            person.setValue(Constants.Subcutânea, forKey:"route")
            
        default:
            person.setValue(" ", forKey:"route")
        }
        person.setValue(postingId, forKey:"postingId")
        person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        } catch {
            
        }
        
        hatcheryVaccinationObject.append(person)
    }
    
    func getFieldDataFromServerSingledata(_ dict : NSDictionary,postingId: NSNumber)  {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        
        for j in 0..<allkeyArr.count {
            
            let stringValidate = allkeyArr.object(at: j) as! String
            let str = "field"
            let index = stringValidate.index(stringValidate.startIndex, offsetBy: 8)
            let mySubstring = stringValidate[..<index]
            
            if mySubstring != str {
                
                switch stringValidate {
                case "hatcheryStrain1":
                    handleGetFieldDataFromServerSingledataHatcheryStrain1(managedContext, dict, postingId)
                case "hatcheryStrain2":
                    handleGetFieldDataFromServerSingledataHatcheryStrain2(managedContext, dict, postingId)
                case "hatcheryStrain3":
                    handleGetFieldDataFromServerSingledataHatcheryStrain3(managedContext, dict, postingId)
                case "hatcheryStrain4":
                    handleGetFieldDataFromServerSingledataHatcheryStrain4(managedContext, dict, postingId)
                case "hatcheryStrain5":
                    handleGetFieldDataFromServerSingledataHatcheryStrain5(managedContext, dict, postingId)
                case "hatcheryStrain6":
                    handleGetFieldDataFromServerSingledataHatcheryStrain6(managedContext, dict, postingId)
                case "hatcheryStrain7":
                    handleGetFieldDataFromServerSingledataHatcheryStrain7(managedContext, dict, postingId)
                case "hatcheryStrain8":
                    handleGetFieldDataFromServerSingledataHatcheryStrain8(managedContext, dict, postingId)
                case "hatcheryStrain9":
                    handleGetFieldDataFromServerSingledataHatcheryStrain9(managedContext, dict, postingId)
                case "hatcheryStrain10":
                    handleGetFieldDataFromServerSingledataHatcheryStrain10(managedContext, dict, postingId)
                default:
                    break
                }
            }
        }
    }
    
    /************************/
    // MARK: 🟢 Save Field Vaccination Data in Database
    
    func saveFieldVacinationInDatabase(details: chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        FieldVaccindataArray = dbArray
        
        if FieldVaccindataArray.count > 0 {
            if let objTable: FieldVaccination = FieldVaccindataArray[index] as? FieldVaccination {
                objTable.setValue(details.type, forKey: "type")
                objTable.setValue(details.strain, forKey: "strain")
                objTable.setValue(details.route, forKey: "route")
                objTable.setValue(details.postingId, forKey: "postingId")
                objTable.setValue(details.vaciProgram, forKey: "vaciNationProgram")
                objTable.setValue(details.sessionId, forKey: "loginSessionId")
                objTable.setValue(details.isSync, forKey: "isSync")
                objTable.setValue(details.lngId, forKey: "lngId")
                objTable.setValue(details.routeID, forKey: "routeId")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "FieldVaccination", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(details.type, forKey: "type")
            person.setValue(details.strain, forKey: "strain")
            person.setValue(details.route, forKey: "route")
            person.setValue(details.postingId, forKey: "postingId")
            person.setValue(details.vaciProgram, forKey: "vaciNationProgram")
            person.setValue(details.sessionId, forKey: "loginSessionId")
            person.setValue(details.isSync, forKey: "isSync")
            person.setValue(details.lngId, forKey: "lngId")
            person.setValue(details.routeID, forKey: "routeId")
            
            hatcheryVaccinationObject.append(person)
        }

        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    // MARK: 🟢Fetch All Saved Field Vacciantion Data
    func fetchFieldAddvacinationDataAll() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccination")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                FieldVaccindataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return FieldVaccindataArray
        
    }
    // MARK: 🟢 Fetch All Saved Field Vacciantion Data for specific Posting ID
    func fetchFieldAddvacinationData(_ postingId: NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccination")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                FieldVaccindataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return FieldVaccindataArray
        
    }
    // MARK: 🟢 Fetch All Saved Field Vacciantion Data for specific Posting ID & Sync Availability
    func fetchFieldAddvacinationDataWithisSyncTrue(_ postingId: NSNumber , isSync : Bool) -> NSArray
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccination")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postIdStatusPredicator, postingId, NSNumber(booleanLiteral: isSync))
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                FieldVaccindataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return FieldVaccindataArray
    }
    
    // MARK: 🟠 Update Filed Vaccination for Specific Posting ID
    func updateisSyncValOnFieldAddvacinationData(_ postingId: NSNumber , isSync  : Bool,_ completion: (_ status: Bool) -> Void){
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccination")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult?.count>0{
                for i in 0..<fetchedResult!.count
                {
                    let objTable: FieldVaccination = (fetchedResult![i] as? FieldVaccination)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }else{
                completion(true)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func updateisSyncValOnFieldAddvacinationData(_ postingId: NSNumber , isSync  : Bool)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccination")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult?.count>0{
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: FieldVaccination = (fetchedResult![i] as? FieldVaccination)!
                    objTable.setValue(isSync, forKey:"isSync")
                    
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    // MARK: 🟠 *****************************  Setting data Base ********************************************************/
    // MARK: 🟠 *************** save data Skleta ************************************************************************/
    
    func saveSettingsSkeletaInDatabase(_ settingsData: chickenCoreDataHandlerModels.saveSkeletaSettingsInDB) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataSkeletaArray = settingsData.dbArray
        
        if dataSkeletaArray.count > 0 {
            if let objTable: Skeleta = dataSkeletaArray[settingsData.index] as? Skeleta {
                objTable.setValue(settingsData.strObservationField, forKey:"observationField")
                objTable.setValue(NSNumber(value: settingsData.visibilityCheck), forKey:"visibilityCheck")
                objTable.setValue(NSNumber(value: settingsData.quicklinks), forKey:"quicklinks")
                objTable.setValue(settingsData.strInformation, forKey:"information")
                objTable.setValue(settingsData.obsId, forKey:"observationId")
                objTable.setValue(settingsData.measure, forKey:"measure")
                objTable.setValue(settingsData.lngId, forKey:"lngId")
                objTable.setValue(settingsData.refId, forKey:"refId")
                objTable.setValue(settingsData.isSync, forKey:"isSync")
                objTable.setValue(settingsData.quicklinkIndex, forKey:"quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
                print("Error saving context")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Skeleta", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(settingsData.strObservationField, forKey:"observationField")
            person.setValue(NSNumber(value: settingsData.visibilityCheck), forKey:"visibilityCheck")
            person.setValue(NSNumber(value: settingsData.quicklinks), forKey:"quicklinks")
            person.setValue(settingsData.strInformation, forKey:"information")
            person.setValue(settingsData.obsId, forKey:"observationId")
            person.setValue(settingsData.measure, forKey:"measure")
            person.setValue(settingsData.isSync, forKey:"isSync")
            person.setValue(settingsData.lngId, forKey:"lngId")
            person.setValue(settingsData.refId, forKey:"refId")
            person.setValue(settingsData.quicklinkIndex, forKey:"quicklinkIndex")
            
            do {
                try managedContext.save()
            } catch {
                print("Error saving new context")
            }
            
            settingsSkeletaObject.append(person)
        }
    }

    // MARK: 🟠 Update Setting for Skelta
    
    func updateSettingDataSkelta(_ settingData: chickenCoreDataHandlerModels.updateSkeletaSettingData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Skeleta")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settingData.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: Skeleta = (fetchedResult![i] as? Skeleta)!
                    objTable.setValue(NSNumber(value: settingData.visibilityCheck), forKey: "visibilityCheck")
                    objTable.setValue(NSNumber(value: settingData.quicklinks), forKey: "quicklinks")
                    objTable.setValue(settingData.strInformation, forKey: "information")
                    objTable.setValue(settingData.isSync, forKey: "isSync")
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error
                    }
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }

    // MARK: 🟢 *************** Fetch Settings data for Skleta *********************************************
    
    func fetchAllSeettingdata() -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "Skeleta")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataSkeletaArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataSkeletaArray
        
    }
    // MARK: 🟢 *************** Fetch Settings data for Skleta with Language ID *********************************************
    func fetchAllSeettingdataWithLngId(lngId:NSNumber) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "Skeleta")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataSkeletaArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataSkeletaArray
    }
    
    // MARK: 🟢 *************************** Save Setting  Data Cocoii Data ***********************************************/
    
    func saveSettingsCocoiiInDatabase(_ settingData: chickenCoreDataHandlerModels.saveCoccidiosisSettingDB) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataCociiaArray = settingData.dbArray
        
        if dataCociiaArray.count > 0 {
            if let objTable: Coccidiosis = dataCociiaArray[settingData.index] as? Coccidiosis {
                objTable.setValue(settingData.strObservationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settingData.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settingData.quicklinks), forKey: "quicklinks")
                objTable.setValue(settingData.strInformation, forKey: "information")
                objTable.setValue(settingData.obsId, forKey: "observationId")
                objTable.setValue(settingData.measure, forKey: "measure")
                objTable.setValue(settingData.lngId, forKey: "lngId")
                objTable.setValue(settingData.isSync, forKey: "isSync")
                objTable.setValue(settingData.refId, forKey: "refId")
                objTable.setValue(settingData.quicklinkIndex, forKey: "quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
                // Handle error
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Coccidiosis", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(settingData.strObservationField, forKey: "observationField")
            person.setValue(NSNumber(value: settingData.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settingData.quicklinks), forKey: "quicklinks")
            person.setValue(settingData.strInformation, forKey: "information")
            person.setValue(settingData.obsId, forKey: "observationId")
            person.setValue(settingData.measure, forKey: "measure")
            person.setValue(settingData.isSync, forKey: "isSync")
            person.setValue(settingData.lngId, forKey: "lngId")
            person.setValue(settingData.refId, forKey: "refId")
            person.setValue(settingData.quicklinkIndex, forKey: "quicklinkIndex")
            
            do {
                try managedContext.save()
            } catch {
                // Handle error
            }
            settingsCocoii.append(person)
        }
    }
    // MARK: 🟠 Update Settings for Coccidiosis Category
    
    func updateSettingDataCocoii(_ settingData: chickenCoreDataHandlerModels.updateCoccidiosisSettingData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coccidiosis")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settingData.refId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]

            if let fetchedResult = fetchedResult, fetchedResult.count > 0 {
                for obj in fetchedResult {
                    if let objTable = obj as? Coccidiosis {
                        objTable.setValue(NSNumber(value: settingData.visibilityCheck), forKey: "visibilityCheck")
                        objTable.setValue(NSNumber(value: settingData.quicklinks), forKey: "quicklinks")
                        objTable.setValue(settingData.isSync, forKey: "isSync")
                        
                        do {
                            try managedContext.save()
                        } catch {
                            // Handle error
                        }
                    }
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }

    // MARK: 🟠 Update Quick Link for All observation Category
    func updateSettingDataQuickIndex(_ strObservationField: String, obsId: NSNumber, quicklinkIndex: Int, entityName: String) {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "observationField == %@", strObservationField)
        
        do {
            
            guard let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return  }
            
            for entityObject in fetchedResult {
                
                switch entityName {
                case "Skeleta":
                    let objTable: Skeleta = (entityObject as? Skeleta)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "Coccidiosis":
                    let objTable: Coccidiosis = (entityObject as? Coccidiosis)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "GITract":
                    let objTable: GITract = (entityObject as? GITract)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "Respiratory":
                    let objTable: Respiratory = (entityObject as? Respiratory)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "Immune":
                    let objTable: Immune = (entityObject as? Immune)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                    
                default:
                    break
                }
                
                do {
                    try managedContext.save()
                } catch {
                    
                }
            }
            
        } catch {
            
        }
    }
    // MARK: 🟠 Fetch Necropsy Details with Farm NAme & Necropsy ID
    func FetchNecropsystep1NecIdWithFarmName(_ farmName : String,necropsyId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "farmName == %@ AND necropsyId == %@", farmName,necropsyId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return necropsyStep1Array
        
    }
    /***************** Fetch data Skleta ************************************************************************/
    // MARK: 🟠 Fetch All Coccidiosis Data
    func fetchAllCocoiiData() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "Coccidiosis")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataCociiaArray = results as NSArray
            } else {
                
            }
        }
        catch  {
            appDelegateObj.testFuntion()
        }
        
        return dataCociiaArray
        
    }
    // MARK: 🟠 Fetch All Coccidiosis Data with Language ID
    func fetchAllCocoiiDataUsinglngId(lngId:NSNumber) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "Coccidiosis")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                dataCociiaArray = results as NSArray
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataCociiaArray
        
    }
    
    // MARK: 🟠 ***************************** Saving data Of GiTract********************************************/
    func saveSettingsGITractDatabase(settingData: chickenCoreDataHandlerModels.saveGITractSettingData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataGiTractArray = settingData.dbArray
        
        if dataGiTractArray.count > 0 {
            if let objTable: GITract = dataGiTractArray[settingData.index] as? GITract {
                objTable.setValue(settingData.strObservationField, forKey:"observationField")
                objTable.setValue(NSNumber(value: settingData.visibilityCheck as Bool), forKey:"visibilityCheck")
                objTable.setValue(NSNumber(value: settingData.quicklinks as Bool), forKey:"quicklinks")
                objTable.setValue(settingData.strInformation, forKey:"information")
                objTable.setValue(settingData.obsId, forKey:"observationId")
                objTable.setValue(settingData.measure, forKey:"measure")
                objTable.setValue(settingData.lngId, forKey:"lngId")
                objTable.setValue(settingData.isSync, forKey:"isSync")
                objTable.setValue(settingData.refId, forKey:"refId")
                objTable.setValue(settingData.quicklinkIndex, forKey:"quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
                print("Failed to save updated GITract settings")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "GITract", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(settingData.strObservationField, forKey:"observationField")
            person.setValue(NSNumber(value: settingData.visibilityCheck as Bool), forKey:"visibilityCheck")
            person.setValue(NSNumber(value: settingData.quicklinks as Bool), forKey:"quicklinks")
            person.setValue(settingData.strInformation, forKey:"information")
            person.setValue(settingData.obsId, forKey:"observationId")
            person.setValue(settingData.measure, forKey:"measure")
            person.setValue(settingData.isSync, forKey:"isSync")
            person.setValue(settingData.lngId, forKey:"lngId")
            person.setValue(settingData.refId, forKey:"refId")
            person.setValue(settingData.quicklinkIndex, forKey:"quicklinkIndex")
            
            do {
                try managedContext.save()
            } catch {
                print("Failed to save new GITract settings")
            }
            
            settingsGITract.append(person)
        }
    }

    // MARK: 🟠 Update Settings data for Gitract
    
    func updateSettingDataGitract(settingData: chickenCoreDataHandlerModels.updateGITractSettingData) {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "GITract")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settingData.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: GITract = (fetchedResult![i] as? GITract)!
                    objTable.setValue(NSNumber(value: settingData.visibilityCheck), forKey:"visibilityCheck")
                    objTable.setValue(NSNumber(value: settingData.quicklinks), forKey:"quicklinks")
                    objTable.setValue(settingData.isSync, forKey:"isSync")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error if needed
                    }
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }

    // MARK: 🟠 ************ Fetch data Of GiTract* ***************************************/
    
    func fetchAllGITractData() -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "GITract")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataGiTractArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataGiTractArray
    }
    // MARK: 🟠 Fetch All Settings by obsname
    func fetchAllSeetingByObs(entityName:String,obsName: String) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "observationField == %@", obsName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataGiTractArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataGiTractArray
        
    }
    // MARK: 🟠 Fetch All Gitract Data using lang id
    func fetchAllGITractDataUsingLngId(lngId:NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "GITract")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataGiTractArray = results as NSArray
            }
            else
            {
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataGiTractArray
        
    }
    
    // MARK: 🟢****************** Saving data Of Respiratory *********************************/
    
    func saveSettingsRespiratoryDatabase(settings: chickenCoreDataHandlerModels.saveRespiratorySettings) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataRespiratoryArray = settings.dbArray

        if dataRespiratoryArray.count > 0 {
            if let objTable: Respiratory = dataRespiratoryArray[settings.index] as? Respiratory {
                objTable.setValue(settings.strObservationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                objTable.setValue(settings.strInformation, forKey: "information")
                objTable.setValue(settings.obsId, forKey: "observationId")
                objTable.setValue(settings.measure, forKey: "measure")
                objTable.setValue(settings.lngId, forKey: "lngId")
                objTable.setValue(settings.isSync, forKey: "isSync")
                objTable.setValue(settings.refId, forKey: "refId")
                objTable.setValue(settings.quicklinkIndex, forKey: "quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
                // Handle error
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Respiratory", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(settings.strObservationField, forKey: "observationField")
            person.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
            person.setValue(settings.strInformation, forKey: "information")
            person.setValue(settings.obsId, forKey: "observationId")
            person.setValue(settings.measure, forKey: "measure")
            person.setValue(settings.isSync, forKey: "isSync")
            person.setValue(settings.lngId, forKey: "lngId")
            person.setValue(settings.refId, forKey: "refId")
            person.setValue(settings.quicklinkIndex, forKey: "quicklinkIndex")

            do {
                try managedContext.save()
            } catch {
                // Handle error
            }

            settingsRespiratory.append(person)
        }
    }

    // MARK: 🟠 Update Settings Data for Respiratory
    
    func updateSettingDataResp(_ settings: chickenCoreDataHandlerModels.updateRespiratorySettings) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Respiratory")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settings.refId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let result = fetchedResult, result.count > 0 {
                for obj in result {
                    if let objTable = obj as? Respiratory {
                        objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                        objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                        objTable.setValue(settings.isSync, forKey: "isSync")
                    }
                }
                try managedContext.save()
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }

    // MARK: 🟠************ Fetch all Respiratory details* ***************************************/
    func fetchAllRespiratory() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "Respiratory")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataRespiratoryArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataRespiratoryArray
    }
    // MARK: 🟠************ Fetch all Respiratory details by language ID* ***************************************/
    func fetchAllRespiratoryusingLngId(lngId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "Respiratory")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataRespiratoryArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataRespiratoryArray
    }
    
    
    // MARK: 🟢***************************** Saving data Of immune ********************************************/
    func saveSettingsImmuneDatabase(_ settings: chickenCoreDataHandlerModels.saveImmuneSettings) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        dataImmuneArray = settings.dbArray

        if dataImmuneArray.count > 0 {
            if let objTable: Immune = dataImmuneArray[settings.index] as? Immune {
                objTable.setValue(settings.strObservationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                objTable.setValue(settings.strInformation, forKey: "information")
                objTable.setValue(settings.obsId, forKey: "observationId")
                objTable.setValue(settings.measure, forKey: "measure")
                objTable.setValue(settings.lngId, forKey: "lngId")
                objTable.setValue(settings.isSync, forKey: "isSync")
                objTable.setValue(settings.refId, forKey: "refId")
                objTable.setValue(settings.quicklinkIndex, forKey: "quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Immune", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(settings.strObservationField, forKey: "observationField")
            person.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
            person.setValue(settings.strInformation, forKey: "information")
            person.setValue(settings.obsId, forKey: "observationId")
            person.setValue(settings.measure, forKey: "measure")
            person.setValue(settings.isSync, forKey: "isSync")
            person.setValue(settings.lngId, forKey: "lngId")
            person.setValue(settings.refId, forKey: "refId")
            person.setValue(settings.quicklinkIndex, forKey: "quicklinkIndex")

            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }

            settingsImmune.append(person)
        }
    }

    // MARK: 🟠 Update Settings Data for Immune
    func updateSettingDataImmune(_ updateData: chickenCoreDataHandlerModels.ImmuneUpdateData, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Immune")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, updateData.refId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]

            if let fetchedResult = fetchedResult, fetchedResult.count > 0 {
                for obj in fetchedResult {
                    if let objTable = obj as? Immune {
                        objTable.setValue(NSNumber(value: updateData.visibilityCheck), forKey: "visibilityCheck")
                        objTable.setValue(NSNumber(value: updateData.quicklinks), forKey: "quicklinks")
                        objTable.setValue(updateData.strInformation, forKey: "information")

                        do {
                            try managedContext.save()
                        } catch {
                            // Handle error if needed
                        }
                    }
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }
    
    // MARK: 🟠************ Fetch All data Of immune* ***************************************/
    
    func fetchAllImmune() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Immune")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataImmuneArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return dataImmuneArray
    }
    // MARK: 🟠 Fetch All data for Immune usinf Language ID
    func fetchAllImmuneUsingLngId(lngId:NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Immune")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataImmuneArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return dataImmuneArray
        
    }
    // MARK: 🟠************** SAVING ROUTE DATA in Database ************************************
    
    func saveRouteDatabase(_ routeId : Int, routeName: String ,lngId : Int,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        routeArray = dbArray
        
        if  routeArray.count > 0 {
            if let objTable: Route = routeArray[index] as? Route {
                objTable.setValue(routeId, forKey:"routeId")
                objTable.setValue(routeName, forKey:"routeName")
                objTable.setValue(lngId, forKey:"lngId")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Route", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(routeId, forKey:"routeId")
            person.setValue(routeName, forKey:"routeName")
            person.setValue(lngId, forKey:"lngId")
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            routeData.append(person)
        }
    }
    // MARK: 🟠************** Fetch ROUTE data****************************************************************/
    
    func fetchRoute() -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Route")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                routeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return routeArray
        
    }
    // MARK: 🟠 Fetch Route Data with Langugae ID
    func fetchRouteLngId(lngId : NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Route")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                routeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return routeArray
        
    }
    
    // MARK: 🟠 ************** SAVING Customer's data ****************************************************************/
    func saveCustmerDatabase(_ custId : Int, CustName: String ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        custArray = dbArray
        
        if  custArray.count > 0 {
            
            if let objTable: Custmer = routeArray[index] as? Custmer {
                
                objTable.setValue(custId, forKey:"custId")
                objTable.setValue(CustName, forKey:"custName")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Custmer", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(custId, forKey:"custId")
            person.setValue(CustName, forKey:"custName")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            CustData.append(person)
        }
    }
    // MARK: 🟠************** Fetch Customers **********************************
    
    func fetchCustomer() -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Custmer")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                custArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return custArray
        
    }
    // MARK: 🟠 Fetch Customers with Customer ID **********************************
    func fetchCustomerWithCustId(_ custId: NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Custmer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "custId == %@", custId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                custArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return custArray
        
    }
    
    // MARK: 🟠**************  Saving Data  SalesRepData Posting    **********************************************/
    func SalesRepDataDatabase(_ salesReptId : Int?, salesRepName: String? ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        SalesRepDataArray = dbArray
        if  SalesRepDataArray.count > 0 {
            if let objTable: Salesrep = SalesRepDataArray[index] as? Salesrep {
                
                objTable.setValue(salesReptId, forKey:"salesReptId")
                objTable.setValue(salesRepName, forKey:"salesRepName")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Salesrep", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(salesReptId, forKey:"salesReptId")
            person.setValue(salesRepName, forKey:"salesRepName")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            SalesRepData.append(person)
        }
    }
    
    // MARK: 🟢************** Fetch Sales Representative **************************************
    func fetchSalesrep() -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Salesrep")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                SalesRepDataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return SalesRepDataArray
        
    }
  
    // MARK: 🟠 ///////////////////////////SAVING DATA VetData  /////////////////////////////////////
    
    func VetDataDatabase(_ vetarId : Int, vtName: String, complexId:NSNumber ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        VeterianTypeArray = dbArray
        
        if  VeterianTypeArray.count > 0 {
            
            if let objTable: Veteration = VeterianTypeArray[index] as? Veteration {
                objTable.setValue(vetarId, forKey:"vetarId")
                objTable.setValue(complexId, forKey:"complexId")
                objTable.setValue(vtName, forKey:"vtName")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Veteration", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(vetarId, forKey:"vetarId")
            person.setValue(complexId, forKey:"complexId")
            person.setValue(vtName, forKey:"vtName")
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            VetData.append(person)
        }
    }
    // MARK: 🟢************** Fetch Vet Data ****************************************************************/
    
    func fetchVetData() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Veteration")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                VeterianTypeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return VeterianTypeArray
        
    }
    // MARK: 🟢 Fetch Vet data with Complex ID
    func fetchVetDataPrdicate(_ complexId : NSNumber) -> NSArray {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Veteration")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "complexId == %@", complexId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                VeterianTypeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return VeterianTypeArray
        
    }
    
 
    // MARK: 🟠 SAVING DATA Cocci Program   //////////////////////////////
    
    func CocoiiProgramDatabase(_ cocoiiId : Int, cocoiProgram: String ,lngId : Int,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        CocoiiProgramArray = dbArray
        
        if  CocoiiProgramArray.count > 0 {
            
            if let objTable: CocciProgramPosting = CocoiiProgramArray[index] as? CocciProgramPosting {
                
                objTable.setValue(cocoiiId, forKey:"cocciProgramId")
                objTable.setValue(cocoiProgram, forKey:"cocciProgramName")
                objTable.setValue(lngId, forKey:"lngId")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "CocciProgramPosting", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(cocoiiId, forKey:"cocciProgramId")
            person.setValue(cocoiProgram, forKey:"cocciProgramName")
            person.setValue(lngId, forKey:"lngId")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            CocoiiProgram.append(person)
        }
    }
    // MARK: 🟢 /**************** Fetch Cooci  ****************************************************************/
    
    func fetchCocoiiProgram() -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocciProgramPosting")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                CocoiiProgramArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return CocoiiProgramArray
    }
    
    // MARK: 🟢 Fetch Cocciprogram details with Language ID
    
    func fetchCocoiiProgramLngId(lngId:NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocciProgramPosting")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                CocoiiProgramArray = results as NSArray
                
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return CocoiiProgramArray
        
    }
    
    // MARK: 🟢  SAVING DATA BirdSize   //////////////////////////////
    
    func BirdSizeDatabase(_ birddId : Int, birdSize: String,scaleType:String ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        BirdSizeArray = dbArray
        
        if  BirdSizeArray.count > 0 {
            if let objTable: BirdSizePosting = BirdSizeArray[index] as? BirdSizePosting {
                objTable.setValue(birddId, forKey:"birdSizeId")
                objTable.setValue(birdSize, forKey:"birdSize")
                objTable.setValue(scaleType, forKey:"scaleType")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "BirdSizePosting", in: managedContext)
            
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(birddId, forKey:"birdSizeId")
            person.setValue(birdSize, forKey:"birdSize")
            person.setValue(scaleType, forKey:"scaleType")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            BirdSize.append(person)
        }
    }
   
     // MARK: 🟢************** Fetch  BirdSize *******************************************/
    
    
    func fetchBirdSize() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdSizePosting")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                BirdSizeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return BirdSizeArray
        
    }
    
    // MARK: 🟢  SAVING DATA SessionType   //////////////////////////////
    
    func SessionTypeDatabase(_ sesionId : Int, sesionType: String ,lngId:NSNumber,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        SessionTypeArray = dbArray
        
        if  SessionTypeArray.count > 0 {
            if let objTable: Sessiontype = SessionTypeArray[index] as? Sessiontype {
                objTable.setValue(sesionId, forKey:"sesionId")
                objTable.setValue(lngId, forKey:"lngId")
                objTable.setValue(sesionType, forKey:"sesionType")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Sessiontype", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(sesionId, forKey:"sesionId")
            person.setValue(lngId, forKey:"lngId")
            person.setValue(sesionType, forKey:"sesionType")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            SessionType.append(person)
        }
    }
    // MARK: 🟢************** Fetch  SessionType *******************************************/
    
    func fetchSessiontype() -> NSArray {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Sessiontype")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                SessionTypeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return SessionTypeArray
        
    }
    // MARK: 🟢 Fetch Session type with Language ID
    func fetchSessiontypeLngId(lngId:NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Sessiontype")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                SessionTypeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return SessionTypeArray
        
    }
    // MARK: 🟢 SAVING Breed type
    
    func BreedTypeDatabase(_ breedId : Int, breedType: String ,breedName: String  ,lngId: Int,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        BreedTypeArray = dbArray
        
        if  BreedTypeArray.count > 0 {
            if let objTable: Breed = BreedTypeArray[index] as? Breed {
                objTable.setValue(breedId, forKey:"breedId")
                objTable.setValue(breedType, forKey:"breedType")
                objTable.setValue(breedName, forKey:"breedName")
                objTable.setValue(lngId, forKey:"languageId")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Breed", in: managedContext)
            
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(breedId, forKey:"breedId")
            person.setValue(breedType, forKey:"breedType")
            person.setValue(breedName, forKey:"breedName")
            person.setValue(lngId, forKey:"languageId")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            BreedType.append(person)
        }
    }
    
    // MARK: 🟢  ************** Fetch  breed *******************************************/
    func fetchBreedType() -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Breed")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                BreedTypeArray = results as NSArray
            }
            else  {
                
            }
        }
        catch {
            appDelegateObj.testFuntion()
        }
        
        return BreedTypeArray
    }
    
    // MARK: 🟢   //////////////////////// Save Complex name //////////////////////////////////
   func ComplexDatabase(_ comlexId : NSNumber, cutmerid: NSNumber ,complexName: String,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        complexArray = dbArray
        
        if  complexArray.count > 0 {
            
            if let objTable: ComplexPosting = complexArray[index] as? ComplexPosting {
                
                objTable.setValue(comlexId, forKey:"complexId")
                objTable.setValue(complexName, forKey:"complexName")
                objTable.setValue(cutmerid, forKey:"customerId")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "ComplexPosting", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(comlexId, forKey:"complexId")
            person.setValue(complexName, forKey:"complexName")
            person.setValue(cutmerid, forKey:"customerId")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            complexNsObJECT.append(person)
        }
    }
    // MARK: 🟢 Fetch All posted session with complex name & Session ID
    func fetchAllPostingExistingSessionwithFullSessionAndComplex(_ session : NSNumber, complexName : NSString) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@ AND complexName == %@", session,complexName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [PostingSession]
            
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                
                let sortedArray = results.sorted{[dateFormatter] one, two in
                    return dateFormatter.date(from:one.sessiondate!)! > dateFormatter.date(from: two.sessiondate!)! }
                postingArray = sortedArray as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return postingArray
        
    }
    // MARK: 🟢 Fetch All posted Session with Complex ID
    func fetchAllPostingExistingSessionwithFullSessionAndUniqueComplex(_ complexID : NSNumber) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "complexId == %@", complexID)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                postingArray  = results as NSArray
                
            } else {
                
            }
        } catch {
            appDelegateObj.testFuntion()
        }
        
        return postingArray
        
    }
    // MARK: 🟢Fetch  complex posting list *******************************************/
    
    func fetchCompexType() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "ComplexPosting")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                complexArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch {
            appDelegateObj.testFuntion()
        }
        
        return complexArray
    }
    // MARK: 🟢 ************** Save  Production Type Data *******************************************/
    func productionTypeDatabase(_ productionId : NSNumber ,productionName: String,dbArray :NSArray ,index : Int ,lngID: NSNumber)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        productionArray = dbArray
        
        if  productionArray.count > 0 {
            if let objTable: ProductionType = productionArray[index] as? ProductionType {
                objTable.setValue(productionId, forKey:"productionId")
                objTable.setValue(productionName, forKey:"productionName")
                objTable.setValue(lngID, forKey:"langID")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            let entity = NSEntityDescription.entity(forEntityName: "ProductionType", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(productionId, forKey:"productionId")
            person.setValue(productionName, forKey:"productionName")
            person.setValue(lngID, forKey:"langID")
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            ProductionNsObJECT.append(person)
        }
    }
    
    // MARK: 🟢 ************** Save  Generation Type Data *******************************************/
    func generationTypeDatabase(_ generationId : NSNumber ,generationName: String,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        generationArray = dbArray
        
        if  generationArray.count > 0 {
            
            if let objTable: ProductionType = generationArray[index] as? ProductionType {
                objTable.setValue(generationId, forKey:"generationId")
                objTable.setValue(generationName, forKey:"generationName")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            let entity = NSEntityDescription.entity(forEntityName: "GenerationType", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(generationId, forKey:"generationId")
            person.setValue(generationName, forKey:"generationName")
            
            do
            {
                try managedContext.save()
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
            
            GenerationNsObJECT.append(person)
        }
    }
    
    // MARK: 🟢************** Fetch  Generation Type *******************************************/
    
    func fetchGenerationType() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "GenerationType")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                generationArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch {
            appDelegateObj.testFuntion()
        }
        
        return generationArray
        
    }
    
    // MARK: 🟢************** Fetch  Production Type *******************************************/
    
    func fetchProductionType(lngID: Int) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "ProductionType")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "langID == %d ",  lngID)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                productionArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch {
            appDelegateObj.testFuntion()
        }
        
        return productionArray
        
    }
 
    // MARK: - 🔴 Delete All data
    func deleteAllData(_ entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  entity)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch let error as NSError {
            debugPrint("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
 
    // MARK: - 🔴 Delete All data with Entity Name
    func deleteAllData(_ entity: String, predicate:NSPredicate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  entity)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            
            debugPrint("Delete all data in \(entity) error : \(error) \(error.userInfo)")
            
        }
    }
    // MARK: 🟢 Fetch Complex Posting by Customer Id
    func fetchCompexTypePrdicate(_ CustomerId: NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "ComplexPosting")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId == %@", CustomerId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                complexArray = results as NSArray
                
            }
            else
            {
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return complexArray
        
    }
    
    
    // MARK: 🟢************** Fetch  Login Detail *******************************************/
    func fetchLoginType() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Login")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                loginArray = results as NSArray
                
            }
            else
            {
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return loginArray
        
    }
    
    func loginDatabase(_ userTypeId : NSNumber, userId: NSNumber ,userName: String,status: NSNumber,signal:String,loginId:NSNumber,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        loginArray = dbArray
        
        if  loginArray.count > 0 {
            
            if let objTable: Login = loginArray[index] as? Login {
                objTable.setValue(userTypeId, forKey:"userTypeId")
                objTable.setValue(userId, forKey:"userId")
                objTable.setValue(status, forKey:"status")
                objTable.setValue(userName, forKey:"username")
                objTable.setValue(signal, forKey:"signal")
                objTable.setValue(loginId, forKey:"loginId")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        } else {
            
            let entity = NSEntityDescription.entity(forEntityName: "Login", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(userTypeId, forKey:"userTypeId")
            person.setValue(userId, forKey:"userId")
            person.setValue(status, forKey:"status")
            person.setValue(userName, forKey:"username")
            person.setValue(signal, forKey:"signal")
            person.setValue(loginId, forKey:"loginId")
            
            do {
                try managedContext.save()
            }
            catch
            {
            }
            
            loginType.append(person)
        }
    }
    
    // MARK: 🟢 Fetch Login Detail with Email ID
    func fetchLoginTypeWithUserEmail(email:String) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "Login")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "username == %@", email)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                loginArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return loginArray
        
    }
    
    // MARK: 🟢 Customer representative Data **///////
    
    func postCustomerReps(_ customername : String,  userid : Int)
    
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "CustomerReprestative", in: managedContext)
        let arr =  fectCustomerRepresenttiveWithCustomername(customername)
        
        if arr.count > 0 {
            return
        }
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(customername, forKey:"customername")
        person.setValue(userid, forKey:"userid")
        do
        {
            try managedContext.save()
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        CustmerRep.append(person)
    }
    
    // MARK: 🟢 ** Fetch Cstomer repsentative Data Save In Add Vacination Button **///////
    func fectCustomerRepresenttiveWithCustomername ( _ customername : String) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustomerReprestative")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customername == %@ ",  customername)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                custRep  = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return custRep
    }
    
    // MARK: 🟢 ** Fetch Cstomer repsentative Data Save In Add Vacination Button **///////
    func fectCustomerRepWithCustomername ( _ usrid : Int) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustomerReprestative")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "userid == %d ",  usrid)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                custRep  = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return custRep
        
    }
    
    // MARK: - 🔴********** Delete object from posting seesion ***************************************/
    
    func deleteDataWithPostingId (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Necropsy Step 1 Data with Posting ID
    func deleteDataWithPostingIdStep1data (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete All View Necropsy Step 1 Data with Posting ID
    func deleteDataWithPostingIdStep2dataCaptureNecView (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    // MARK: - 🔴 Delete Birds Notes Step 2 Data with Posting ID
    func deleteDataWithPostingIdStep2NotesBird (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Captured Bird Image with Posting ID
    func deleteDataWithPostingIdStep2CameraIamge (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    // MARK: - 🔴 Delete Hatchery Vaccine Data with Posting ID
    func deleteDataWithPostingIdHatchery (_ postingId: NSNumber)
    {
        
        deleteHatcheryVacData(postingId: postingId)
    }
    
    func deleteHatcheryVacData(postingId: NSNumber) {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HatcheryVac")
        fetchRequest.predicate = fetchPredicate
        
        do {
            let results = try backgroundContext.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    backgroundContext.delete(managedObjectData)
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }
    
    
    // MARK: - 🔴 Delete Field Vaccination Data with Posting ID
    func deleteDataWithPostingIdFieldVacinationWithSingle (_ postingId: NSNumber)
    {
        deleteFieldVaccinationData(postingId: postingId)
    }
    
    // MARK: - 🔴 Delete Posting Session Detail Data with Posting ID
    func deleteDataWithDeviceSessionId (postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchUsers.predicate                = fetchPredicate
        
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Hatcher Vaccine Data with Posting ID
    func deleteHetcharyVacDataWithPostingId (_ postingId: NSNumber)
    {
        deleteHatcheryVacData(postingId: postingId)
    }
    // MARK: - 🔴 Delete Field Vaccine Data with Posting ID
    func deletefieldVACDataWithPostingId (_ postingId: NSNumber)
    {
        deleteFieldVaccinationData(postingId: postingId)
    }
    
    func deleteFieldVaccinationData(postingId: NSNumber) {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FieldVaccination")
        fetchRequest.predicate = fetchPredicate
        
        do {
            let results = try backgroundContext.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    backgroundContext.delete(managedObjectData)
                }
            }
        } catch {
            appDelegateObj.testFuntion()
        }
    }
    
    
    // MARK: - 🔴 Delete Feed Program Data with Posting ID
    func deleteDataWithPostingIdFeddProgram (_ postingIdFeed: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgram")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Coccidiosis Control Feed Data with Posting ID
    func deleteDataWithPostingIdFeddProgramCocoiiSinle (_ postingIdFeed: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Alternative Feed Data with Posting ID
    func deleteDataWithPostingIdFeddProgramAlternativeSinle (_ postingIdFeed: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchUsers.predicate                = fetchPredicate
        do
            
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Antibiotic Feed Data with Posting ID
    func deleteDataWithPostingIdFeddProgramAntiboiticSingle (_ postingIdFeed: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    // MARK: - 🔴 Delete MyCotoxin Binder Feed Data with Posting ID
    func deleteDataWithPostingIdFeddProgramMyCotoxinSingle (_ postingIdFeed: NSNumber)
    {
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    // MARK: - 🔴 Delete Captured Feed Data with Necropsy ID
    func deleteDataWithPostingIdCaptureStepData (_ necId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchUsers.predicate                = fetchPredicate
        
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    
    func updateisSyncOnHetcharyVacDataWithPostingId (_ postingId: NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVac")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let fetchedResult = try backgroundContext.fetch(fetchUsers) as? [NSManagedObject]
            
            if fetchedResult?.count>0{
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: HatcheryVac = (fetchedResult![i] as? HatcheryVac)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try backgroundContext.save()
                    }
                    catch{
                    }
                    
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func autoIncrementidtable(){
        var auto = self.fetchFromAutoIncrement()
        auto += 1
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Id", in: managedContext)
        let contact1 = NSManagedObject(entity: entity!, insertInto: managedContext)
        contact1.setValue(auto, forKey: "autoId")
        do
        {
            try managedContext.save()
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func fetchFromAutoIncrement() -> Int
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "Id")
        fetchRequest.returnsObjectsAsFaults = false
        var auto: Int?
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult , results.count > 0
            {
                    let ob: Id = results.last as! Id
                    auto = Int(ob.autoId!)
                
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        return auto ?? 0
        
    }
    ///////////////// ** Posting Session Data Save In Add Vacination Button **///////
   
    func PostingSessionDb(_ postingData: chickenCoreDataHandlerModels.chickenPostingSessionData) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        self.deleteDataWithPostingId(postingData.postingId)
        
        let entity = NSEntityDescription.entity(forEntityName: "PostingSession", in: managedContext)
        let contact1 = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        contact1.setValue(postingData.convential, forKey:"convential")
        contact1.setValue(postingData.antiboitic, forKey:"antiboitic")
        contact1.setValue(0, forKey:"birdBreedId")
        contact1.setValue(postingData.birdbreedName, forKey:"birdBreedName")
        contact1.setValue(postingData.birdBreedType, forKey:"birdBreedType")
        contact1.setValue(postingData.birdSize, forKey:"birdSize")
        contact1.setValue(postingData.birdSizeId, forKey:"birdSizeId")
        contact1.setValue(postingData.cocciProgramId, forKey:"cocciProgramId")
        contact1.setValue(postingData.cociiProgramName, forKey:"cociiProgramName")
        contact1.setValue(postingData.complexId, forKey:"complexId")
        contact1.setValue(postingData.complexName, forKey:"complexName")
        contact1.setValue(postingData.customerId, forKey:"customerId")
        contact1.setValue(postingData.customerName, forKey:"customerName")
        contact1.setValue(postingData.customerRepId, forKey:"customerRepId")
        contact1.setValue(postingData.customerRepName, forKey:"customerRepName")
        contact1.setValue(postingData.imperial, forKey:"imperial")
        contact1.setValue(postingData.metric, forKey:"metric")
        contact1.setValue(postingData.notes, forKey:"notes")
        contact1.setValue(postingData.salesRepId, forKey:"salesRepId")
        contact1.setValue(postingData.salesRepName, forKey:"salesRepName")
        contact1.setValue(postingData.sessiondate, forKey:"sessiondate")
        contact1.setValue(postingData.sessionTypeId, forKey:"sessionTypeId")
        contact1.setValue(postingData.sessionTypeName, forKey:"sessionTypeName")
        contact1.setValue(postingData.vetanatrionName, forKey:"vetanatrionName")
        contact1.setValue(postingData.veterinarianId, forKey:"veterinarianId")
        contact1.setValue(postingData.loginSessionId, forKey:"loginSessionId")
        contact1.setValue(postingData.postingId, forKey:"postingId")
        contact1.setValue(postingData.mail, forKey:"mail")
        contact1.setValue(postingData.female, forKey:"female")
        contact1.setValue(postingData.finilize, forKey:"finalizeExit")
        contact1.setValue(true, forKey:"isSync")
        contact1.setValue(postingData.timeStamp, forKey:"timeStamp")
        contact1.setValue(postingData.lngId, forKey:"lngId")
        contact1.setValue(postingData.productionTypId, forKey:"productionTypeId")
        contact1.setValue(postingData.productionTypName, forKey:"productionTypeName")
        contact1.setValue(postingData.mortality, forKey:"dayMortality")
        contact1.setValue(postingData.FCR, forKey:"fcr")
        contact1.setValue(postingData.outTime, forKey:"outTime")
        contact1.setValue(postingData.Livability, forKey:"livability")
        contact1.setValue(postingData.avgAge, forKey:"avgAge")
        contact1.setValue(postingData.avgWeight, forKey:"avgWeight")
        
        do {
            try managedContext.save()
        } catch {
            appDelegateObj.testFuntion()
        }
        
        postingSession.append(contact1)
    }

    /************* Update Posting session *****************/
    
    
    func updatePostingSessionForNextButton(postingData: chickenCoreDataHandlerModels.updatePostingSessionData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingData.postingId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let objTable = fetchedResult?.first as? PostingSession {
                objTable.setValue(postingData.convential, forKey: "convential")
                objTable.setValue(postingData.antiboitic, forKey: "antiboitic")
                objTable.setValue(0, forKey: "birdBreedId")
                objTable.setValue(postingData.birdbreedName, forKey: "birdBreedName")
                objTable.setValue(postingData.birdBreedType, forKey: "birdBreedType")
                objTable.setValue(postingData.birdSize, forKey: "birdSize")
                objTable.setValue(postingData.birdSizeId, forKey: "birdSizeId")
                objTable.setValue(postingData.cocciProgramId, forKey: "cocciProgramId")
                objTable.setValue(postingData.cociiProgramName, forKey: "cociiProgramName")
                objTable.setValue(postingData.complexId, forKey: "complexId")
                objTable.setValue(postingData.complexName, forKey: "complexName")
                objTable.setValue(postingData.customerId, forKey: "customerId")
                objTable.setValue(postingData.customerName, forKey: "customerName")
                objTable.setValue(postingData.customerRepId, forKey: "customerRepId")
                objTable.setValue(postingData.customerRepName, forKey: "customerRepName")
                objTable.setValue(postingData.imperial, forKey: "imperial")
                objTable.setValue(postingData.metric, forKey: "metric")
                objTable.setValue(postingData.notes, forKey: "notes")
                objTable.setValue(postingData.salesRepId, forKey: "salesRepId")
                objTable.setValue(postingData.salesRepName, forKey: "salesRepName")
                objTable.setValue(postingData.sessiondate, forKey: "sessiondate")
                objTable.setValue(postingData.sessionTypeId, forKey: "sessionTypeId")
                objTable.setValue(postingData.sessionTypeName, forKey: "sessionTypeName")
                objTable.setValue(postingData.vetanatrionName, forKey: "vetanatrionName")
                objTable.setValue(postingData.veterinarianId, forKey: "veterinarianId")
                objTable.setValue(postingData.loginSessionId, forKey: "loginSessionId")
                objTable.setValue(postingData.postingId, forKey: "postingId")
                objTable.setValue(postingData.mail, forKey: "mail")
                objTable.setValue(postingData.female, forKey: "female")
                objTable.setValue(postingData.finilize, forKey: "finalizeExit")
                objTable.setValue(postingData.isSync, forKey: "isSync")
                objTable.setValue(postingData.timeStamp, forKey: "timeStamp")
                objTable.setValue(postingData.lngId, forKey: "lngId")
                objTable.setValue(postingData.productionTypId, forKey: "productionTypeId")
                objTable.setValue(postingData.productionTypName, forKey: "productionTypeName")
                objTable.setValue(postingData.mortality, forKey: "dayMortality")
                objTable.setValue(postingData.FCR, forKey: "fcr")
                objTable.setValue(postingData.outTime, forKey: "outTime")
                objTable.setValue(postingData.Livability, forKey: "livability")
                objTable.setValue(postingData.avgAge, forKey: "avgAge")
                objTable.setValue(postingData.avgWeight, forKey: "avgWeight")

                do {
                    try managedContext.save()
                } catch {
                    // Handle error
                }
            }
        } catch {
            // Handle error
        }
    }

    /************* Update Posting on DashBoard session *****************/
    func updatePostingSessionOndashBoard(_ postingId : NSNumber,vetanatrionName:String,veterinarianId: NSNumber,captureNec: NSNumber)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(vetanatrionName, forKey:"vetanatrionName")
                objTable.setValue(veterinarianId, forKey:"veterinarianId")
                objTable.setValue("-Select-", forKey:"cociiProgramName")
                objTable.setValue("", forKey:"customerRepName")
                objTable.setValue("", forKey:"birdBreedName")
                objTable.setValue("", forKey:"birdBreedType")
                objTable.setValue("-Select-", forKey:"birdSize")
                objTable.setValue("", forKey:"convential")
                objTable.setValue("", forKey:"imperial")
                objTable.setValue("", forKey:"salesRepName")
                objTable.setValue("", forKey:"notes")
                objTable.setValue("Male", forKey:"mail")
                objTable.setValue("Female", forKey:"female")
                objTable.setValue(captureNec, forKey:"catptureNec")
                objTable.setValue("Field Visit", forKey:"sessionTypeName")
                objTable.setValue(true, forKey:"isSync")
                
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    /*************************** Get Api Method for Postong Session **********************/
    func getPostingData(_ dict : NSDictionary) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let postingId = dict.value(forKey: "SessionId") as! Int
        self.deleteDataWithPostingId(postingId as NSNumber)
        let entity = NSEntityDescription.entity(forEntityName: "PostingSession", in: managedContext)
        
        let contact1 = NSManagedObject(entity: entity!, insertInto: managedContext)
        contact1.setValue("NA", forKey:"convential")
        contact1.setValue("NA", forKey:"antiboitic")
        contact1.setValue(dict.value(forKey: "BirdTypeId"), forKey:"birdBreedId")
        contact1.setValue("NA", forKey:"birdBreedName")
        contact1.setValue("NA", forKey:"birdBreedType")
        contact1.setValue(dict.value(forKey: "BirdSize"), forKey:"birdSize")
        contact1.setValue(1, forKey:"birdSizeId")
        contact1.setValue(dict.value(forKey: "CocciProgramId"), forKey:"cocciProgramId")
        contact1.setValue(dict.value(forKey: "CocciProgram"), forKey:"cociiProgramName")
        contact1.setValue(dict.value(forKey: "ComplexId"), forKey:"complexId")
        contact1.setValue(dict.value(forKey: "ComplexName"), forKey:"complexName")
        contact1.setValue(dict.value(forKey: "CustomerId"), forKey:"customerId")
        contact1.setValue(dict.value(forKey: "CustomerName"), forKey:"customerName")
        contact1.setValue(dict.value(forKey: "SessionId"), forKey:"customerRepId")
        if let customerRep = dict.value(forKey: "CustomerRep"), !(customerRep is NSNull) {
            contact1.setValue(customerRep, forKey: "customerRepName")
        } else {
            contact1.setValue("", forKey: "customerRepName")
        }
        contact1.setValue("", forKey:"imperial")
        contact1.setValue("Scale", forKey:"metric")
        contact1.setValue(dict.value(forKey: "Notes"), forKey:"notes")
        contact1.setValue(dict.value(forKey: "SalesUserId"), forKey:"salesRepId")
        
        if dict.object(forKey: "AvgAge") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgAge") as? String ?? "", forKey:"avgAge")
        }
        if dict.object(forKey: "AvgOutTime") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgOutTime") as? String ?? "", forKey:"outTime")
        }
        if dict.object(forKey: "AvgWeight") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgWeight") as? String ?? "", forKey:"avgWeight")
        }
        if dict.object(forKey: "Avg7DayMortality") as? String != "" {
            contact1.setValue(dict.object(forKey: "Avg7DayMortality") as? String ?? "", forKey:"dayMortality")
        }
        if dict.object(forKey: "FCR") as? String != "" {
            contact1.setValue(dict.object(forKey: "FCR") as? String ?? "", forKey:"fcr")
        }
        if dict.object(forKey: "Livability") as? String != "" {
            contact1.setValue(dict.object(forKey: "Livability") as? String ?? "", forKey:"livability")
        }
        
        let salesFirstName = dict.value(forKey: "SalesRepFirstName")
        let salesLastname = dict.value(forKey: "SalesRepLastName")
        let salesRepName = "\(salesFirstName!) \(salesLastname!)"
        
        contact1.setValue(dict.value(forKey: salesRepName), forKey:"salesRepName")
        contact1.setValue(dict.value(forKey: "LanguageId"), forKey:"lngId")
        let sessionDa = convertDateFormater(dict.value(forKey: "SessionDate") as! String)
        contact1.setValue(sessionDa, forKey:"sessiondate")
        contact1.setValue(dict.value(forKey: "SessionTypeId"), forKey:"sessionTypeId")
        contact1.setValue(dict.value(forKey: "SessionType"), forKey:"sessionTypeName")
        
        let vetId = dict.value(forKey: "VetUserId") as! Int
        if vetId == 0{
            contact1.setValue("", forKey:"vetanatrionName")
        }
        else{
            let vetFirstName = dict.value(forKey: "VetFirstName")
            let vetLastname = dict.value(forKey: "VetLastName")
            let firstLastName = "\(vetFirstName!) \(vetLastname!)"
            contact1.setValue(firstLastName, forKey:"vetanatrionName")
        }
        contact1.setValue(dict.value(forKey: "VetUserId"), forKey:"veterinarianId")
        contact1.setValue(dict.value(forKey: "SessionId"), forKey:"loginSessionId")
        contact1.setValue(dict.value(forKey: "SessionId"), forKey:"postingId")
        contact1.setValue(dict.value(forKey: "MaleBreedName"), forKey:"mail")
        contact1.setValue(dict.value(forKey: "FemaleBreedName"), forKey:"female")
        contact1.setValue(dict.value(forKey: "Finalized"), forKey:"finalizeExit")
        contact1.setValue(false, forKey:"isSync")
      //  contact1.setValue(1, forKey:"catptureNec") // New line added becasue we are not getting the data for first time we launch the App and try to get the data which is already synced
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"timeStamp")
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"actualTimeStamp")
        UserDefaults.standard.set(dict.value(forKey: "DeviceSessionId"), forKey: "devTimeStamp")
        UserDefaults.standard.synchronize()
        do {
            try managedContext.save()
        } catch {
            appDelegateObj.testFuntion()
        }
        
        postingSession.append(contact1)
        
    }
    
    func getPostingDatWithSpecificId(_ dict : NSDictionary, postinngId: NSNumber) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        self.deleteDataWithDeviceSessionId(postingId : postinngId)
        let entity = NSEntityDescription.entity(forEntityName: "PostingSession", in: managedContext)
        
        let contact1 = NSManagedObject(entity: entity!, insertInto: managedContext)
        contact1.setValue("NA", forKey:"convential")
        contact1.setValue("NA", forKey:"antiboitic")
        contact1.setValue(1, forKey:"birdBreedId")
        contact1.setValue("NA", forKey:"birdBreedName")
        contact1.setValue("NA", forKey:"birdBreedType")
        contact1.setValue(dict.value(forKey: "BirdSize"), forKey:"birdSize")
        contact1.setValue(1, forKey:"birdSizeId")
        contact1.setValue(dict.value(forKey: "CocciProgramId"), forKey:"cocciProgramId")
        contact1.setValue(dict.value(forKey: "CocciProgram"), forKey:"cociiProgramName")
        contact1.setValue(dict.value(forKey: "ComplexId"), forKey:"complexId")
        contact1.setValue(dict.value(forKey: "ComplexName"), forKey:"complexName")
        contact1.setValue(dict.value(forKey: "CustomerId"), forKey:"customerId")
        contact1.setValue(dict.value(forKey: "CustomerName"), forKey:"customerName")
        contact1.setValue(dict.value(forKey: "SessionId"), forKey:"customerRepId")
        contact1.setValue(dict.value(forKey: "CustomerRep"), forKey:"customerRepName")
        contact1.setValue("", forKey:"imperial")
        contact1.setValue("Scale", forKey:"metric")
        contact1.setValue(dict.value(forKey: "Notes"), forKey:"notes")
        contact1.setValue(dict.value(forKey: "SalesUserId"), forKey:"salesRepId")
        let salesFirstName = dict.value(forKey: "SalesRepFirstName")
        let salesLastname = dict.value(forKey: "SalesRepLastName")
        let salesRepName = "\(salesFirstName!) \(salesLastname!)"
        contact1.setValue(salesRepName, forKey:"salesRepName")
        
        let sessionDa = convertDateFormater(dict.value(forKey: "SessionDate") as! String)
        contact1.setValue(sessionDa, forKey:"sessiondate")
        contact1.setValue(dict.value(forKey: "LanguageId"), forKey:"lngId")
        contact1.setValue(dict.value(forKey: "SessionTypeId"), forKey:"sessionTypeId")
        contact1.setValue(dict.value(forKey: "SessionType"), forKey:"sessionTypeName")
        
        let vetFirstName = dict.value(forKey: "VetFirstName")
        let vetLastname = dict.value(forKey: "VetLastName")
        let firstLastName = "\(vetFirstName!) \(vetLastname!)"
        contact1.setValue(firstLastName, forKey:"vetanatrionName")
        contact1.setValue(dict.value(forKey: "VetUserId"), forKey:"veterinarianId")
        contact1.setValue(dict.value(forKey: "SessionId"), forKey:"loginSessionId")
        contact1.setValue(postinngId, forKey:"postingId")
        contact1.setValue(dict.value(forKey: "MaleBreedName"), forKey:"mail")
        contact1.setValue(dict.value(forKey: "FemaleBreedName"), forKey:"female")
        contact1.setValue(dict.value(forKey: "Finalized"), forKey:"finalizeExit")
        contact1.setValue(false, forKey:"isSync")
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"timeStamp")
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"actualTimeStamp")
        contact1.setValue(dict.value(forKey: "ProductionTypeId") as! Int, forKey:"productionTypeId")
        contact1.setValue(dict.value(forKey: "ProductionTypeName") ?? "", forKey:"productionTypeName")
        
        if dict.object(forKey: "AvgAge") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgAge") as? String ?? "", forKey:"avgAge")
        }
        if dict.object(forKey: "AvgOutTime") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgOutTime") as? String ?? "", forKey:"outTime")
        }
        if dict.object(forKey: "AvgWeight") as? String != "" {
            contact1.setValue(dict.object(forKey: "AvgWeight") as? String ?? "", forKey:"avgWeight")
        }
        if dict.object(forKey: "Avg7DayMortality") as? String != "" {
            contact1.setValue(dict.object(forKey: "Avg7DayMortality") as? String ?? "", forKey:"dayMortality")
        }
        if dict.object(forKey: "FCR") as? String != "" {
            contact1.setValue(dict.object(forKey: "FCR") as? String ?? "", forKey:"fcr")
        }
        if dict.object(forKey: "Livability") as? String != "" {
            contact1.setValue(dict.object(forKey: "Livability") as? String ?? "", forKey:"livability")
        }
        
        UserDefaults.standard.set(dict.value(forKey: "DeviceSessionId"), forKey: "devTimeStamp")
        UserDefaults.standard.synchronize()
        contact1.setValue(1, forKey:"catptureNec")
        do {
            try managedContext.save()
        } catch {
            appDelegateObj.testFuntion()
        }
        
        postingSession.append(contact1)
        
    }
    /********* ConvertIng sessiondate *****************/
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss
        // New addition for below 2 line
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func updateFinalizeDataActual(_ postingId : NSNumber,deviceToken : String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(deviceToken, forKey:"actualTimeStamp")
                
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
    }
    
    func updateFinalizeDataActualNec(_ necId : NSNumber,deviceToken : String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyData = (fetchedResult![0] as? CaptureNecropsyData)!
                objTable.setValue(deviceToken, forKey:"actualTimeStamp")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            } }
        catch
        {
            
        }
    }
    
    
    func updateFeddProgramInStep1(_ necId : NSNumber,feedname:String,feedId:NSNumber)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND feedId == %@", necId,feedId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    
                    let objTable: CaptureNecropsyData = (fetchedResult![i] as? CaptureNecropsyData)!
                    //objTable.setValue(deviceToken, forKey:"feedId")
                    objTable.setValue(feedname, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    
    func updateFeddProgramInStep1UsingFarmName(_ necId : NSNumber,feedname:String,feedId:NSNumber,formName:String)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId,formName)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    
                    let objTable: CaptureNecropsyData = (fetchedResult![i] as? CaptureNecropsyData)!
                    objTable.setValue(feedname, forKey:"feedProgram")
                    objTable.setValue(feedId, forKey:"feedId")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func updateFinalizeData(_ postingId : NSNumber,finalize : NSNumber,isSync:Bool)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(finalize, forKey:"finalizeExit")
                objTable.setValue(isSync, forKey:"isSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func updatedeviceTokenForPostingId(_ postingId : NSNumber,timeStamp:String,actualTimestamp: String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(timeStamp, forKey:"actualTimeStamp")
                objTable.setValue(actualTimestamp, forKey:"timeStamp")
                
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func updatedPostigSessionwithIsFarmSyncPostingId(_ postingId : NSNumber,isFarmSync:Bool)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(isFarmSync, forKey:"isfarmSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            
        }
    }
    
    func searchTokenForPostingId(timeStampId:String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "timeStamp == %@", timeStampId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    func updateFinalizeDataWithNecGetApi(_ postingId : NSNumber,finalizeNec : NSNumber)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                
                objTable.setValue(finalizeNec, forKey:"catptureNec")
                objTable.setValue(0, forKey:"birdBreedId")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            
        }
        
    }
    
    func updateFinalizeDataWithNec(_ postingId : NSNumber,finalizeNec : NSNumber)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                
                objTable.setValue(finalizeNec, forKey:"catptureNec")
                objTable.setValue(finalizeNec, forKey:"birdBreedId")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            
        }
    }
    
    
    func updateFinalizeDataWithNecNotes(_ postingId : NSNumber,notes : String)
    
    { let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(notes, forKey:"notes")
                objTable.setValue(true, forKey:"isSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
                
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    
    func updateisSyncOnPostingSession(_ postingId : NSNumber,isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do{
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0{
                for i in 0..<fetchedResult!.count{
                    let objTable: PostingSession = (fetchedResult![i] as? PostingSession)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do{
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch{print(appDelegateObj.testFuntion())}
    }
    
    
    func updateisAllSyncFalseOnPostingSession(_ isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.predicateStatus, NSNumber(booleanLiteral: isSync))
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: PostingSession = (fetchedResult![i] as? PostingSession)!
                    objTable.setValue(false, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch {
            
        }
    }
    
    func updateisSyncTrueOnPostingSession(_ postingId : NSNumber) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(true, forKey:"isSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }}
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        
    }
    
    func updateisSyncTrueOnPostingSessionISSync(_ postingId : NSNumber) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: PostingSession = (fetchedResult![0] as? PostingSession)!
                objTable.setValue(false, forKey:"isfarmSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
    }
    
    
    func fetchAllPostingSessionWithNumber() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingSession(_ postingid :NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingid)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            appDelegateObj.testFuntion()
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingSessionWithisSyncisTrue(_ isSync : Bool) -> NSArray
   
    {
        return fetchPostingSession(Sync: isSync)
    }
    
    
    private func fetchPostingSession(Sync: Bool) -> NSArray {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.predicateStatus, NSNumber(value: Sync))

        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            return results as NSArray? ?? []
        } catch {
            print(appDelegateObj.testFuntion())
            return []
        }
    }

    
    
    func fetchPostingSessionWithisSyncisTrue(_ isSync : Bool) -> NSArray
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "isSync == %@", NSNumber(booleanLiteral: isSync))
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
            }
            else
            {
            }
        }
        catch
        {
        }
        return postingArray
    }
    func fetchAllPostingExistingSession() -> NSArray    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return postingArray
        
    }
    
    
    
    func fetchAllPostingExistingSessionwithFullSessionWithCapId(_ session : NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@", session)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [PostingSession]
            if let results = fetchedResult
            {
                
                postingArray  = results as NSArray
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                
                let sortedArray = results.sorted{[dateFormatter] one, two in
                    return dateFormatter.date(from:one.sessiondate!) > dateFormatter.date(from: two.sessiondate!) }
                postingArray = sortedArray as NSArray
                
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingExistingSessionwithFullSessionSessionDate(_ session : NSNumber,birdTypeId:NSNumber,todate:String,lasatdate:String) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        let datePredicate = NSPredicate(format: "catptureNec == %@ AND birdBreedId == %@ AND sessiondate >=  %@ AND sessiondate  <=  %@", session,birdTypeId,todate , lasatdate )
        fetchRequest.predicate = datePredicate
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "sessiondate", ascending: false)
                let sortedResults = postingArray.sortedArray(using: [descriptor])
                postingArray = sortedResults as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    /********************************* Save data in to CocoiPrgramFeed *************************************/
    func saveCoccoiControlDatabase(_ data: CoccidiosisControlData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        cocciControlArray = data.dbArray

        if cocciControlArray.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoccidiosisControlFeed")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, data.feedId)

            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    if results.count <= data.index {
                        let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeed", in: managedContext)!
                        let person = NSManagedObject(entity: entity, insertInto: managedContext)
                        setValues(for: person, with: data)
                        try? managedContext.save()
                        cocciCoccidiosControl.append(person)
                    } else {
                        if let objTable = results[data.index] as? CoccidiosisControlFeed {
                            setValues(for: objTable, with: data)
                            try? managedContext.save()
                        }
                    }
                }
            } catch {
                // handle error
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeed", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            setValues(for: person, with: data)
            try? managedContext.save()
            cocciCoccidiosControl.append(person)
        }
    }
    
    private func setValues(for object: NSManagedObject, with data: CoccidiosisControlData) {
        object.setValue(data.loginSessionId, forKey: "loginSessionId")
        object.setValue(data.postingId, forKey: "postingId")
        object.setValue(data.molecule, forKey: "molecule")
        object.setValue(data.dosage, forKey: "dosage")
        object.setValue(data.fromDays, forKey: "fromDays")
        object.setValue(data.toDays, forKey: "toDays")
        object.setValue(data.coccidiosisVaccine, forKey: "coccidiosisVaccine")
        object.setValue(data.targetWeight, forKey: "targetWeight")
        object.setValue(data.feedId, forKey: "feedId")
        object.setValue(data.feedProgram, forKey: "feedProgram")
        object.setValue(data.formName, forKey: "formName")
        object.setValue(data.isSync, forKey: "isSync")
        object.setValue(data.feedType, forKey: "feedType")
        object.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
        object.setValue(data.lngId, forKey: "lngId")
        object.setValue(data.lbldate, forKey: "feedDate")
        object.setValue(data.doseMoleculeId, forKey: "dosemoleculeId")
    }
    
    /********************** Get data from server forCocoidisControll **********************/
    func getDataFromCocoiiControll(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        
        let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingId , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        if let dose = dict.value(forKey: "dose"){
            person.setValue(dose as? String, forKey:"dosage")
        }else{
            person.setValue("", forKey:"dosage")
        }
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(dict.value(forKey: "cocciVaccineName"), forKey:"coccidiosisVaccine")
        person.setValue("", forKey:"targetWeight")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciCoccidiosControl.append(person)
    }
    func getDataFromCocoiiControllForSingleData(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingIdCocoii:NSNumber , feedDate:String ) {
        let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingIdCocoii , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(dict.value(forKey: "cocciVaccineName"), forKey:"coccidiosisVaccine")
        person.setValue("", forKey:"targetWeight")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciCoccidiosControl.append(person)
    }
    
    func insert(entity: String, attributeKey: String?, objectToSave: [String : Any]) {
        
        let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let content = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedObjectContext)
        content.setValuesForKeys(objectToSave)
        do {
            try managedObjectContext.save()
            
        } catch {
            
        }
    }
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAllCocciControl(_ feedId :NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                cocciControlArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return cocciControlArray
        
    }
    
    func fetchAllCocciControlAllData() -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                cocciControlArray = results as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return cocciControlArray
    }
    
    func fetchAllCocciControlviaPostingid(_ postingId :NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                cocciControlArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return cocciControlArray
    }
    
    func fetchAllCocciControlviaIsync(_ isSync :NSNumber , postinID : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, isSync,postinID)
        do
            
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                cocciControlArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return cocciControlArray
        
    }
    
    func updateisSyncOnAllCocciControlviaFeedProgram(_ postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "postingId == %@ AND feedId == %@", postingId,feedId)
        
        do
            
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CoccidiosisControlFeed = (fetchedResult![i] as? CoccidiosisControlFeed)!
                    objTable.setValue(feedProgram, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        
        catch
        {print(appDelegateObj.testFuntion())}
    }
    
    
    func updateisSyncOnAllCocciControlviaPostingid(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CoccidiosisControlFeed = (fetchedResult![i] as? CoccidiosisControlFeed)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateisSyncOnAntiboticViaPostingId(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
            
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AntiboticFeed = (fetchedResult![i] as? AntiboticFeed)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    
    func updateisSyncOnAntiboticViaFeedProgram(postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AntiboticFeed = (fetchedResult![i] as? AntiboticFeed)!
                    objTable.setValue(feedProgram, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func fetchAntiboticViaIsSync(_ isSync:Bool, postingID : NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, NSNumber(booleanLiteral: isSync),postingID)
        do
            
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                AntiboticArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
            
        }
        catch{print(appDelegateObj.testFuntion())}
        return AntiboticArray
    }
    
    func fetchAntiboticViaPostingId(_ postingId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
                
            {
                AntiboticArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return AntiboticArray
    }
    ///////Fetch alternative via postingId //////
    
    func updateisSyncOnAlternativeFeedPostingid(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AlternativeFeed = (fetchedResult![i] as? AlternativeFeed)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {print(appDelegateObj.testFuntion())}
    }
    
    
    func updateisSyncOnAlterNativeViaFeedProgram(postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AlternativeFeed = (fetchedResult![i] as? AlternativeFeed)!
                    objTable.setValue(feedProgram, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func fetchAlternativeFeedWithIsSync(_ isSync : Bool,postingID:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, NSNumber(booleanLiteral: isSync),postingID)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                AlternativeArray = results as NSArray
            }
            else
            
            {
            }
            
        }
        catch{print(appDelegateObj.testFuntion())}
        return AlternativeArray
    }
    
    
    func fetchAlternativeFeedPostingid(_ postingId : NSNumber) -> NSArray
    {     let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
                
            {
                AlternativeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {print(appDelegateObj.testFuntion())}
        return AlternativeArray
        
    }
    
    func updateisSyncOnMyBindersViaPostingId(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: MyCotoxinBindersFeed = (fetchedResult![i] as? MyCotoxinBindersFeed)!
                    
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                    completion(true)
                }
            }
            else{
                completion(true)
            }
        }
        catch
        {print(appDelegateObj.testFuntion())}
    }
    
    func updateisSyncOnMyCotxinViaFeedProgram(postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        
        do
            
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: MyCotoxinBindersFeed = (fetchedResult![i] as? MyCotoxinBindersFeed)!
                    objTable.setValue(feedProgram, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func fetchMyBindersViaPostingId(_ postingId : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                MyCoxtinBindersArray = results as NSArray
            }
            else{print(appDelegateObj.testFuntion())}
        }
        
        catch{print(appDelegateObj.testFuntion())}
        return MyCoxtinBindersArray
        
    }
    
    
    func fetchMyBindersViaIsSync(_ isSync : Bool , postingID : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContextForBinderFeed = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, NSNumber(booleanLiteral: isSync),postingID)
        
        do
        {
            let fetchedResult = try managedContextForBinderFeed.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                MyCoxtinBindersArray = results as NSArray
            }
        }
        
        catch{print(appDelegateObj.testFuntion())}
        return MyCoxtinBindersArray
        
    }
    
    func saveAntiboticDatabase(feedData: chickenCoreDataHandlerModels.saveChknAntibioticFeedData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        let antibioticArray = feedData.dbArray
        
        if antibioticArray.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AntiboticFeed")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedData.feedId)
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let fetchedResult = fetchedResult, fetchedResult.count > 0 {
                    if fetchedResult.count <= feedData.index {
                        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeed", in: managedContext)
                        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                        
                        person.setValue(feedData.loginSessionId, forKey: "loginSessionId")
                        person.setValue(feedData.postingId, forKey: "postingId")
                        person.setValue(feedData.molecule, forKey: "molecule")
                        person.setValue(feedData.dosage, forKey: "dosage")
                        person.setValue(feedData.fromDays, forKey: "fromDays")
                        person.setValue(feedData.toDays, forKey: "toDays")
                        person.setValue(feedData.feedId, forKey: "feedId")
                        person.setValue(feedData.feedProgram, forKey: "feedProgram")
                        person.setValue(feedData.isSync, forKey: "isSync")
                        person.setValue(feedData.feedType, forKey: "feedType")
                        person.setValue(feedData.cocoVacId, forKey: "coccidiosisVaccineId")
                        person.setValue(feedData.lngId, forKey: "lngId")
                        person.setValue(feedData.lblDate, forKey: "feedDate")
                        
                        try? managedContext.save()
                        
                        cocciAntibotic.append(person)
                    } else {
                        let objTable: AntiboticFeed = fetchedResult[feedData.index] as! AntiboticFeed
                        
                        objTable.setValue(feedData.loginSessionId, forKey: "loginSessionId")
                        objTable.setValue(feedData.postingId, forKey: "postingId")
                        objTable.setValue(feedData.molecule, forKey: "molecule")
                        objTable.setValue(feedData.dosage, forKey: "dosage")
                        objTable.setValue(feedData.fromDays, forKey: "fromDays")
                        objTable.setValue(feedData.toDays, forKey: "toDays")
                        objTable.setValue(feedData.feedId, forKey: "feedId")
                        objTable.setValue(feedData.feedProgram, forKey: "feedProgram")
                        objTable.setValue(feedData.formName, forKey: "formName")
                        objTable.setValue(feedData.isSync, forKey: "isSync")
                        objTable.setValue(feedData.feedType, forKey: "feedType")
                        objTable.setValue(feedData.cocoVacId, forKey: "coccidiosisVaccineId")
                        objTable.setValue(feedData.lngId, forKey: "lngId")
                        objTable.setValue(feedData.lblDate, forKey: "feedDate")
                        
                        try? managedContext.save()
                    }
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeed", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    person.setValue(feedData.loginSessionId, forKey: "loginSessionId")
                    person.setValue(feedData.postingId, forKey: "postingId")
                    person.setValue(feedData.molecule, forKey: "molecule")
                    person.setValue(feedData.dosage, forKey: "dosage")
                    person.setValue(feedData.fromDays, forKey: "fromDays")
                    person.setValue(feedData.toDays, forKey: "toDays")
                    person.setValue(feedData.feedId, forKey: "feedId")
                    person.setValue(feedData.feedProgram, forKey: "feedProgram")
                    person.setValue(feedData.isSync, forKey: "isSync")
                    person.setValue(feedData.feedType, forKey: "feedType")
                    person.setValue(feedData.cocoVacId, forKey: "coccidiosisVaccineId")
                    person.setValue(feedData.lngId, forKey: "lngId")
                    person.setValue(feedData.lblDate, forKey: "feedDate")
                    
                    try? managedContext.save()
                    
                    cocciAntibotic.append(person)
                }
            } catch {
                // Handle the error
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeed", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(feedData.loginSessionId, forKey: "loginSessionId")
            person.setValue(feedData.postingId, forKey: "postingId")
            person.setValue(feedData.molecule, forKey: "molecule")
            person.setValue(feedData.dosage, forKey: "dosage")
            person.setValue(feedData.fromDays, forKey: "fromDays")
            person.setValue(feedData.toDays, forKey: "toDays")
            person.setValue(feedData.feedId, forKey: "feedId")
            person.setValue(feedData.feedProgram, forKey: "feedProgram")
            person.setValue(feedData.isSync, forKey: "isSync")
            person.setValue(feedData.feedType, forKey: "feedType")
            person.setValue(feedData.cocoVacId, forKey: "coccidiosisVaccineId")
            person.setValue(feedData.lngId, forKey: "lngId")
            person.setValue(feedData.lblDate, forKey: "feedDate")
            
            try? managedContext.save()
            
            cocciAntibotic.append(person)
        }
    }

    /********************************* Save data in to AntiboticArray *************************************/

    /********************************* Get Api from server for antoboitic *************************************/
    
    
    func getDataFromAntiboitic(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingId , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        if let dose = dict.value(forKey: "dose"){
            person.setValue(dose as? String, forKey:"dosage")
        }else{
            person.setValue("", forKey:"dosage")
        }
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAntibotic.append(person)
    }
    
    func getDataFromAntiboiticWithSigleData(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingIdAlterNative: NSNumber  , feedDate:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingIdAlterNative , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAntibotic.append(person)
    }
    
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAntibotic(_ feedId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                AntiboticArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AntiboticArray
        
    }
    
    func fetchAntiboticPostingId(_ postingId:NSNumber) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                
                AntiboticArray = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return AntiboticArray
    }
    
    func fetchAntiboticAlldata() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeed")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                
                AntiboticArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AntiboticArray
    }
    
    func saveAlternativeDatabase(_ data: AlternativeFeedData, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        AlternativeArray = dbArray
        
        if AlternativeArray.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlternativeFeed")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, data.feedId)
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if fetchedResult!.count > 0 {
                    if (fetchedResult?.count ?? 0 <= index) {
                        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeed", in: managedContext)
                        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                        person.setValue(data.loginSessionId, forKey: "loginSessionId")
                        person.setValue(data.postingId, forKey: "postingId")
                        person.setValue(data.molecule, forKey: "molecule")
                        person.setValue(data.dosage, forKey: "dosage")
                        person.setValue(data.fromDays, forKey: "fromDays")
                        person.setValue(data.toDays, forKey: "toDays")
                        person.setValue(data.feedId, forKey: "feedId")
                        person.setValue(data.feedProgram, forKey: "feedProgram")
                        person.setValue(data.isSync, forKey: "isSync")
                        person.setValue(data.feedType, forKey: "feedType")
                        person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                        person.setValue(data.lngId, forKey: "lngId")
                        person.setValue(data.lblDate, forKey: "feedDate")
                        
                        try? managedContext.save()
                        cocciAlternative.append(person)
                    } else {
                        let objTable: AlternativeFeed = (fetchedResult![index] as? AlternativeFeed)!
                        objTable.setValue(data.loginSessionId, forKey: "loginSessionId")
                        objTable.setValue(data.postingId, forKey: "postingId")
                        objTable.setValue(data.molecule, forKey: "molecule")
                        objTable.setValue(data.dosage, forKey: "dosage")
                        objTable.setValue(data.fromDays, forKey: "fromDays")
                        objTable.setValue(data.toDays, forKey: "toDays")
                        objTable.setValue(data.feedId, forKey: "feedId")
                        objTable.setValue(data.feedProgram, forKey: "feedProgram")
                        objTable.setValue(data.formName, forKey: "formName")
                        objTable.setValue(data.isSync, forKey: "isSync")
                        objTable.setValue(data.feedType, forKey: "feedType")
                        objTable.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                        objTable.setValue(data.lngId, forKey: "lngId")
                        objTable.setValue(data.lblDate, forKey: "feedDate")
                        
                        try? managedContext.save()
                    }
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeed", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue(data.loginSessionId, forKey: "loginSessionId")
                    person.setValue(data.postingId, forKey: "postingId")
                    person.setValue(data.molecule, forKey: "molecule")
                    person.setValue(data.dosage, forKey: "dosage")
                    person.setValue(data.fromDays, forKey: "fromDays")
                    person.setValue(data.toDays, forKey: "toDays")
                    person.setValue(data.feedId, forKey: "feedId")
                    person.setValue(data.feedProgram, forKey: "feedProgram")
                    person.setValue(data.isSync, forKey: "isSync")
                    person.setValue(data.feedType, forKey: "feedType")
                    person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                    person.setValue(data.lngId, forKey: "lngId")
                    person.setValue(data.lblDate, forKey: "feedDate")
                    try? managedContext.save()
                    cocciAlternative.append(person)
                }
            } catch {
                // Handle error
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeed", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(data.loginSessionId, forKey: "loginSessionId")
            person.setValue(data.postingId, forKey: "postingId")
            person.setValue(data.molecule, forKey: "molecule")
            person.setValue(data.dosage, forKey: "dosage")
            person.setValue(data.fromDays, forKey: "fromDays")
            person.setValue(data.toDays, forKey: "toDays")
            person.setValue(data.feedId, forKey: "feedId")
            person.setValue(data.feedProgram, forKey: "feedProgram")
            person.setValue(data.isSync, forKey: "isSync")
            person.setValue(data.feedType, forKey: "feedType")
            person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
            person.setValue(data.lngId, forKey: "lngId")
            person.setValue(data.lblDate, forKey: "feedDate")
            try? managedContext.save()
            cocciAlternative.append(person)
        }
    }

    
    /******************** getApi  AlterNative data from server *****************/
    func getDataFromAlterNative(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingId , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        if let dose = dict.value(forKey: "dose"){
            person.setValue(dose as? String, forKey:"dosage")
        }else{
            person.setValue("", forKey:"dosage")
        }
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAlternative.append(person)
    }
    
    func getDataFromAlterNativeForSingleDevToken(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingAlterNative:NSNumber  , feedDate:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingAlterNative , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAlternative.append(person)
    }
    
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAlternative(_ feedId : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                AlternativeArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AlternativeArray
        
    }
    
    
    func fetchAlternativePostingId(_ postingId : NSNumber) -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                AlternativeArray = results as NSArray
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        
        return AlternativeArray
    }
    
    
    func fetchAlternativeAlldata() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeed")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                AlternativeArray = results as NSArray
            }  else   {
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        return AlternativeArray
        
    }
        
    func saveMyCoxtinDatabase(input: chickenCoreDataHandlerModels.MyCoxtinBinderInput, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        MyCoxtinBindersArray = dbArray

        if MyCoxtinBindersArray.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCotoxinBindersFeed")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, input.feedId)

            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let fetched = fetchedResult, fetched.count > 0 {
                    if fetched.count <= index {
                        let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeed", in: managedContext)
                        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                        person.setValue(input.loginSessionId, forKey: "loginSessionId")
                        person.setValue(input.postingId, forKey: "postingId")
                        person.setValue(input.molecule, forKey: "molecule")
                        person.setValue(input.dosage, forKey: "dosage")
                        person.setValue(input.fromDays, forKey: "fromDays")
                        person.setValue(input.toDays, forKey: "toDays")
                        person.setValue(input.feedId, forKey: "feedId")
                        person.setValue(input.feedProgram, forKey: "feedProgram")
                        person.setValue(input.formName, forKey: "formName")
                        person.setValue(input.isSync, forKey: "isSync")
                        person.setValue(input.feedType, forKey: "feedType")
                        person.setValue(input.cocoVacId, forKey: "coccidiosisVaccineId")
                        person.setValue(input.lngId, forKey: "lngId")
                        person.setValue(input.lblDate, forKey: "feedDate")
                        try? managedContext.save()
                        cocciMyCoxtinBinders.append(person)
                    } else if let objTable = fetched[index] as? MyCotoxinBindersFeed {
                        objTable.setValue(input.loginSessionId, forKey: "loginSessionId")
                        objTable.setValue(input.postingId, forKey: "postingId")
                        objTable.setValue(input.molecule, forKey: "molecule")
                        objTable.setValue(input.dosage, forKey: "dosage")
                        objTable.setValue(input.fromDays, forKey: "fromDays")
                        objTable.setValue(input.toDays, forKey: "toDays")
                        objTable.setValue(input.feedId, forKey: "feedId")
                        objTable.setValue(input.feedProgram, forKey: "feedProgram")
                        objTable.setValue(input.formName, forKey: "formName")
                        objTable.setValue(input.isSync, forKey: "isSync")
                        objTable.setValue(input.feedType, forKey: "feedType")
                        objTable.setValue(input.cocoVacId, forKey: "coccidiosisVaccineId")
                        objTable.setValue(input.lngId, forKey: "lngId")
                        objTable.setValue(input.lblDate, forKey: "feedDate")
                        try? managedContext.save()
                    }
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeed", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue(input.loginSessionId, forKey: "loginSessionId")
                    person.setValue(input.postingId, forKey: "postingId")
                    person.setValue(input.molecule, forKey: "molecule")
                    person.setValue(input.dosage, forKey: "dosage")
                    person.setValue(input.fromDays, forKey: "fromDays")
                    person.setValue(input.toDays, forKey: "toDays")
                    person.setValue(input.feedId, forKey: "feedId")
                    person.setValue(input.feedProgram, forKey: "feedProgram")
                    person.setValue(input.formName, forKey: "formName")
                    person.setValue(input.isSync, forKey: "isSync")
                    person.setValue(input.feedType, forKey: "feedType")
                    person.setValue(input.cocoVacId, forKey: "coccidiosisVaccineId")
                    person.setValue(input.lngId, forKey: "lngId")
                    person.setValue(input.lblDate, forKey: "feedDate")
                    try? managedContext.save()
                    cocciMyCoxtinBinders.append(person)
                }
            } catch {
                print(appDelegateObj.testFuntion())
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeed", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(input.loginSessionId, forKey: "loginSessionId")
            person.setValue(input.postingId, forKey: "postingId")
            person.setValue(input.molecule, forKey: "molecule")
            person.setValue(input.dosage, forKey: "dosage")
            person.setValue(input.fromDays, forKey: "fromDays")
            person.setValue(input.toDays, forKey: "toDays")
            person.setValue(input.feedId, forKey: "feedId")
            person.setValue(input.feedProgram, forKey: "feedProgram")
            person.setValue(input.formName, forKey: "formName")
            person.setValue(input.isSync, forKey: "isSync")
            person.setValue(input.feedType, forKey: "feedType")
            person.setValue(input.cocoVacId, forKey: "coccidiosisVaccineId")
            person.setValue(input.lngId, forKey: "lngId")
            person.setValue(input.lblDate, forKey: "feedDate")
            try? managedContext.save()
            cocciMyCoxtinBinders.append(person)
        }
    }
    
    /************************** Ge api for MycocxoBinder *********************************/
    func getDataFromMyCocotinBinder(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        
        let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingId , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        if let dose = dict.value(forKey: "dose"){
            person.setValue(dose as? String, forKey:"dosage")
        }else{
            person.setValue("", forKey:"dosage")
        }
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciMyCoxtinBinders.append(person)
    }
    
    func getDataFromMyCocotinBinderWithSingleData(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingidMycotxin:NSNumber, feedDate:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeed", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingidMycotxin , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciMyCoxtinBinders.append(person)
    }
    
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchMyBinders(_ feedId : NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                MyCoxtinBindersArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return MyCoxtinBindersArray
    }
    
    
    func fetchMyBindersAllData() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeed")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                MyCoxtinBindersArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return MyCoxtinBindersArray
    }
    
    
    func getFeedNameFromGetApi (_ postingId : NSNumber, sessionId: NSNumber ,feedProgrameName: String,feedId: NSNumber,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FeedProgram", in: backgroundContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(feedProgrameName, forKey:"feddProgramNam")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(sessionId, forKey:"loginSessionId")
        person.setValue(postingId, forKey:"postingId")
        person.setValue("", forKey:"formName")
        person.setValue(false, forKey:"isSync")
        person.setValue(startDate, forKey:"feedDate")
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        FeddProgram.append(person)
    }
    
    func getFeedNameFromGetApiSingleDeviceToken (_ postingId : NSNumber, sessionId: NSNumber ,feedProgrameName: String,feedId: NSNumber,postingIdFeed: NSNumber) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FeedProgram", in: backgroundContext)
        let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        person.setValue(feedProgrameName, forKey:"feddProgramNam")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(sessionId, forKey:"loginSessionId")
        person.setValue(postingIdFeed, forKey:"postingId")
        person.setValue("", forKey:"formName")
        person.setValue(false, forKey:"isSync")
        do
        {
            try backgroundContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        FeddProgram.append(person)
    }
    
    /************************** Feed Program *******************************************************/
    
    
    func SaveFeedProgram(_ feedData: chickenCoreDataHandlerModels.saveChickenFeedProgramData) {
        feedprogramArray = feedData.dbArray
        
        if feedprogramArray.count > 0 {
            let objTable: FeedProgram = (feedprogramArray[feedData.index] as? FeedProgram)!
            
            do {
                if objTable.feedId == feedData.feedId {
                    objTable.setValue(feedData.feedProgrameName, forKey:"feddProgramNam")
                    objTable.setValue(feedData.feedId, forKey:"feedId")
                    objTable.setValue(feedData.sessionId, forKey:"loginSessionId")
                    objTable.setValue(feedData.postingId, forKey:"postingId")
                    objTable.setValue(feedData.formName, forKey:"formName")
                    objTable.setValue(feedData.isSync, forKey:"isSync")
                    objTable.setValue(feedData.lngId, forKey:"lngId")
                    
                    do {
                        try backgroundContext.save()
                    } catch {
                        // Handle error
                    }
                }
            }
            return
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "FeedProgram", in: backgroundContext)
            let person = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            person.setValue(feedData.feedProgrameName, forKey:"feddProgramNam")
            person.setValue(feedData.feedId, forKey:"feedId")
            person.setValue(feedData.sessionId, forKey:"loginSessionId")
            person.setValue(feedData.postingId, forKey:"postingId")
            person.setValue(feedData.formName, forKey:"formName")
            person.setValue(feedData.isSync, forKey:"isSync")
            person.setValue(feedData.lngId, forKey:"lngId")
            
            do {
                try backgroundContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            
            FeddProgram.append(person)
        }
    }

    func updateFeedProgram(_ feedId: NSNumber,isSync : Bool,feedProgrameName:String,formName: String)
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgram")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: FeedProgram = (fetchedResult![0] as? FeedProgram)!
                
                objTable.setValue(feedProgrameName, forKey:"feddProgramNam")
                objTable.setValue(formName, forKey:"formName")
                objTable.setValue(isSync, forKey:"isSync")
                
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            
        }
        
    }
    /**************** Fetch complex posting *******************************************/
    
    
    func FetchFeedProgram(_ postingId : NSNumber) -> NSArray
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgram")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                feedprogramArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return feedprogramArray
        
    }
    
    /***************************************************/
    
    func FetchFeedProgramAll() -> NSArray
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgram")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                feedprogramArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "feedId", ascending: true)
                let sortedResults = feedprogramArray.sortedArray(using: [descriptor])
                feedprogramArray = sortedResults as NSArray
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return feedprogramArray
        
    }
    
    
    /*************** Create database capture necropsy step 1 *************************************/
    
    func SaveNecropsystep1(data: chickenCoreDataHandlerModels.saveNecropsyStep1Data) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CaptureNecropsyData", in: backgroundContext)
        
        let contact = CaptureNecropsyData(entity: entityDescription!, insertInto: backgroundContext)
        contact.age = data.age
        contact.farmName = data.farmName
        contact.feedProgram = data.feedProgram
        contact.flockId = data.flockId
        contact.sick = data.sick
        contact.houseNo = data.houseNo
        contact.noOfBirds = data.noOfBirds
        contact.postingId = data.postingId
        contact.necropsyId = data.necId
        contact.complexName = data.compexName
        contact.complexDate = data.complexDate
        contact.complexId = data.complexId
        contact.custmerId = data.custmerId
        contact.feedId = data.feedId
        contact.isChecked = false
        contact.isSync = data.isSync as NSNumber
        contact.timeStamp = data.timeStamp
        contact.actualTimeStamp = data.actualTimeStamp
        contact.lngId = data.lngId
        contact.farmId = data.farmId
        contact.imageId = data.imageId
        contact.farmcount = data.count
        
        do {
            try backgroundContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        necrpsystep1.append(contact)
    }

    func SaveNecropsystep1SingleData(data: chickenCoreDataHandlerModels.SaveNecropsystep1SingleNecropsyData) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CaptureNecropsyData", in: backgroundContext)
        let contact = CaptureNecropsyData(entity: entityDescription!, insertInto: backgroundContext)

        contact.age = data.age
        contact.farmName = data.farmName
        contact.feedProgram = data.feedProgram
        contact.flockId = data.flockId
        contact.sick = data.sick
        contact.houseNo = data.houseNo
        contact.noOfBirds = data.noOfBirds
        contact.postingId = data.necIdSingle
        contact.necropsyId = data.necIdSingle
        contact.complexName = data.compexName
        contact.complexDate = data.complexDate
        contact.complexId = data.complexId
        contact.custmerId = data.custmerId
        contact.feedId = data.feedId
        contact.isChecked = false
        contact.isSync = data.isSync as NSNumber
        contact.timeStamp = data.timeStamp
        contact.actualTimeStamp = data.actualTimeStamp
        contact.farmId = data.farmId
        contact.imageId = data.imgId

        do {
            try backgroundContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        necrpsystep1.append(contact)
    }

    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1(_ postingId : NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
    }
    
    
    
    func FetchNecropsystep1AllWithNecId(_ necId : NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1All() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            { }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1WithisSyncandPostingId(_ isSync : Bool , postingId : NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "isSync == %@ AND necropsyId == %@", NSNumber(booleanLiteral: isSync) , postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1WithisSync(_ isSync : Bool) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "isSync == %@ AND postingId == 0", NSNumber(booleanLiteral: isSync))
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    /********************************************************************/
    
    func FetchNecropsystep1NecId(_ necropsyId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necropsyId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "farmId", ascending: true)
                let sortedResults = necropsyStep1Array.sortedArray(using: [descriptor])
                necropsyStep1Array = sortedResults as NSArray
                
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    func fetchAllPostingExistingSessionwithFullSession(_ session : NSNumber,birdTypeId:NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@ AND birdBreedId == %@", session,birdTypeId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [PostingSession]
            if let results = fetchedResult
                
            {
                postingArray  = results as NSArray
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let sortedArray = results.sorted{[dateFormatter] one, two in
                    return dateFormatter.date(from:one.sessiondate!) > dateFormatter.date(from: two.sessiondate!)
                }
                
                postingArray = sortedArray as NSArray
            }
           
        }
        catch  {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    /***************************************************************************/
    func FetchNecropsystep1UpdateFromUnlinked(_ postingId : NSNumber) -> NSMutableArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                
                for captureNecropsyData in results {
                    let necId = captureNecropsyData.value(forKey: "necropsyId") as! NSNumber
                    
                    for c in necropsySArray {
                        let n = (c as AnyObject).value(forKey: "necropsyId") as! NSNumber
                        if n == necId {
                            necropsySArray.remove(c)
                        }
                    }
                    
                    necropsySArray.add(captureNecropsyData)
                }
            }
            else {
                
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsySArray
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1neccId(_ necId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "farmId", ascending: true)
                let sortedResults = necropsyStep1Array.sortedArray(using: [descriptor])
                necropsyStep1Array = sortedResults as NSArray
                
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func fetchNecropsystep1neccIdFeedProgram(_ necId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND feedProgram == %@ " , necId, "")
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1neccIdAll() -> NSArray
    {
        fetchAllNecropsyStep1Data()
        
    }
    
    
    func FetchNecropsystep1neccIdAllwithId(sessiondate:String,newstring:String) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.predicate = NSPredicate(format: "complexDate == %@ AND complexName == %@", sessiondate,newstring)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return necropsyStep1Array
        
    }
    
    
    func FetchNecropsystep1neccIdWithCheckFarm(_ necId : NSNumber) -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND isChecked == 0", necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    func FetchFarmNameOnNecropsystep1neccId(_ necId : NSNumber , feedProgramName : String , feedId : NSNumber) -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@  AND isChecked == 1 AND feedId == %@", necId , feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                necropsyStep1Array = results as NSArray
            }
           
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        return necropsyStep1Array
    }
    
    func updateisSyncNecropsystep1neccId(_ postingId : NSNumber, isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyData = (fetchedResult![i] as? CaptureNecropsyData)!
                    
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateisSyncNecropsystep1WithneccId(_ necId : NSNumber, isSync : Bool) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: CaptureNecropsyData = (fetchedResult![i] as? CaptureNecropsyData)!
                    
                    objTable.setValue(isSync, forKey:"isSync")
                    do {
                        try managedContext.save()
                    } catch{
                        
                    }
                }
            }
        }
        catch {
            
        }
    }
    
    func updatComplexIdandComplexIDInNecropsystep1neccId(_ necId : NSNumber , complexName : String , complexId : NSNumber) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyData = (fetchedResult![0] as? CaptureNecropsyData)!
                
                objTable.setValue(complexName, forKey:"complexName")
                objTable.setValue(complexId, forKey:"complexId")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch {
            
        }
    }
    
    func FetchNecropsystep1neccIdTrueVal(_ necId : NSNumber,formTrueValue: Bool , feedProgram : String , feedId: NSNumber ) -> NSArray {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        
        if formTrueValue == true
        {
            fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND isChecked == 1 AND feedId == %@", necId,feedId)
        }
        else
        {
            fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND isChecked == 0 AND feedId == %@", necId,feedId)
        }
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func updatePostingIdWithNecIdNecropsystep1(_ necId : NSNumber , postingId : NSNumber )
    {
        
        updatePostingIdWithNecId(necId, postingId: postingId)
        
    }
    
    func updatePostingIdWithNecIdNecropsystep1WithZero(_ necId : NSNumber , postingId : NSNumber )
    
    {
        
        updatePostingIdWithNecId(necId, postingId: postingId)
    }
    
    func updatePostingIdWithNecId(_ necId: NSNumber, postingId: NSNumber) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do {
            if let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject], !fetchedResult.isEmpty {
                for obj in fetchedResult {
                    if let objTable = obj as? CaptureNecropsyData {
                        objTable.setValue(postingId, forKey: "postingId")
                    }
                }
                try managedContext.save()
            }
        } catch {
            print("Failed to update postingId: \(error.localizedDescription)")
        }
    }

    
    
    func updateFeedProgramNameoNNecropsystep1neccId(_ necId : NSNumber , feedProgramName : String , formName : String , isCheckForm : Bool , feedId : NSNumber)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId , formName , feedProgramName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                
                let objTable: CaptureNecropsyData = (fetchedResult![0] as? CaptureNecropsyData)!
                objTable.setValue(feedProgramName, forKey:"feedProgram")
                objTable.setValue(feedId, forKey:"feedId")
                objTable.setValue(NSNumber(value: isCheckForm as Bool), forKey: "isChecked")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            
        }
    }
    
    func updateFeedProgramNameoNNecropsystep1neccIdFeddprogramBlank(_ necId : NSNumber,formName : String , feedId : NSNumber)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId , formName )
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyData = (fetchedResult![0] as? CaptureNecropsyData)!
                objTable.setValue("", forKey:"feedProgram")
                objTable.setValue(000, forKey:"feedId")
                
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1AllNecId() -> NSArray
    {
        fetchAllNecropsyStep1Data()
    }
    
    func fetchAllNecropsyStep1Data() -> NSArray {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            if let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                necropsyStep1Array = fetchedResult as NSArray
            } else {
                print(appDelegateObj.testFuntion())
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
    }
    
    
    
    func FetchNecropsystep1AllNecIdWithPostingIDZero() -> NSMutableArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "postingId == 0")
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                for i in 0..<results.count
                {
                    let c = results[i] as! CaptureNecropsyData
                    let nId = c.necropsyId as!  Int
                    
                    necropsyNIdArray.add(c)
                    
                    for j in 0..<necropsyNIdArray.count - 1
                    {
                        let d = necropsyNIdArray.object(at: j)  as! CaptureNecropsyData
                        let n = d.necropsyId as!  Int
                        if n == nId
                        {
                            necropsyNIdArray.remove(c)
                        }
                    }
                }
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyNIdArray
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func updateBirdNumberInNecropsystep1(_ postingId : NSNumber , index : Int)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let objTable: CaptureNecropsyData = (fetchedResult![index] as? CaptureNecropsyData)!
            let noof : String = objTable.noOfBirds!
            let i  : Int = Int(noof)!
            
            if i < 11
            {
                let insertNumOfBirds : String = String(i + 1)
                
                objTable.setValue(insertNumOfBirds, forKey:"noOfBirds")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateBirdNumberInNecropsystep1withNecId(_ necId : NSNumber , index : Int,isSync : Bool)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let objTable: CaptureNecropsyData = (fetchedResult![index] as? CaptureNecropsyData)!
            let noof : String = objTable.noOfBirds!
            let i  : Int = Int(noof)!
            
            if i < 11
            {
                let insertNumOfBirds : String = String(i + 1)
                
                objTable.setValue(insertNumOfBirds, forKey:"noOfBirds")
                objTable.setValue(isSync, forKey:"isSync")
                do
                {
                    try managedContext.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func reduceBirdNumberInNecropsystep1(_ postingId : NSNumber , index : Int) ->Bool
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            var isBirdAvailable : Bool = true
            let objTable: CaptureNecropsyData = (fetchedResult![index] as? CaptureNecropsyData)!
            let noof : String = objTable.noOfBirds!
            let i  : Int = Int(noof)!
            
            if i > 1
            {
                let deleteNumOfBirds : String = String(i - 1)
                objTable.setValue(deleteNumOfBirds, forKey:"noOfBirds")
                do
                {
                    try managedContext.save()
                    isBirdAvailable = true
                    return isBirdAvailable
                }
                catch{
                    isBirdAvailable = false
                    return isBirdAvailable
                }
            }
            else
            {
                isBirdAvailable = false
                return isBirdAvailable
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    /******************** Delete Bird Using NecId *****************************************/
    
    func reduceBirdNumberInNecropsystep1WithNecId(_ necId : NSNumber , index : Int) ->Bool
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            var isBirdAvailable : Bool = true
            let objTable: CaptureNecropsyData = (fetchedResult![index] as? CaptureNecropsyData)!
            let noof : String = objTable.noOfBirds!
            let i  : Int = Int(noof)!
            
            if i > 1
            {
                let deleteNumOfBirds : String = String(i - 1)
                objTable.setValue(deleteNumOfBirds, forKey:"noOfBirds")
                do
                {
                    try managedContext.save()
                    isBirdAvailable = true
                    return isBirdAvailable
                }
                catch{
                    isBirdAvailable = false
                    return isBirdAvailable
                }
            }
            else
            {
                isBirdAvailable = false
                return isBirdAvailable
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    func fecthFrmWithBirdAndObservation(_ birdnumber: NSNumber,farmname : String, obsId : NSNumber , necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND obsID == %@ AND formName == %@ AND necropsyId == %@", birdnumber,obsId,farmname , necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    /******************************************************************/
    
    func fecthFrmWithBirdAndObservationAll()-> NSArray
    {
        self.fetchCaptureNecropsyData()
    }
    
    
    func fetchCaptureNecropsyData() -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                return results as NSArray
            } else {
                print(appDelegateObj.testFuntion())
                return NSArray() // Return an empty array if no results
            }
        } catch {
            print(appDelegateObj.testFuntion())
            return NSArray() // Return an empty array in case of error
        }
    }
    
    
    /****************************************************************************/
    func fecthFrmWithCatnameWithBirdAndObservation(_ birdnumber: NSNumber,farmname : String, catName : String,necId:NSNumber)-> NSArray
    {
        fetchObservationData(birdNumber: birdnumber, farmName: farmname, catName: catName, necId: necId)
    }
    
    func fecthFrmWithCatnameWithBirdAndObservationWithDelete(farmname : String,necId:NSNumber)-> NSArray {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "refId != 58 AND necropsyId == %@ AND formName == %@",necId,farmname)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                return sortedResults as  NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return captureNecSkeltetonArray
    }
    
    func fecthFrmWithCatname(_ farmname : String, catName : String , birdNo : NSNumber,necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "catName == %@ AND formName == %@ AND birdNo == %@ AND necropsyId == %@ ", catName,farmname,birdNo,necId)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    func updateQuickLinkOnCaptureNec(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber,necId: NSNumber , quickLink : NSNumber)
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID ==%@ AND necropsyId == %@", birdnumber,catName,farmname,Obsid,necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewData = (fetchedResult![i] as? CaptureNecropsyViewData)!
                    
                    objTable.setValue(quickLink, forKey:"quickLink")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            
        }
    }
    
    
    func fecthFrmWithCatnameWithBirdAndObservationID(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber,necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID ==%@ AND necropsyId == %@", birdnumber,catName,farmname,Obsid,necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    func fecthobsDataWithCatnameAndFarmNameAndBirdNumber(_ birdnumber: NSNumber,farmname : String, catName : String , necId: NSNumber)-> NSArray
    {
        fetchObservationData(birdNumber: birdnumber, farmName: farmname, catName: catName, necId: necId)
    }
    
    func fetchObservationData(birdNumber: NSNumber, farmName: String, catName: String, necId: NSNumber) -> NSArray {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateCatNameBirdsFarmNecID, birdNumber, catName, farmName, necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            if let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                captureNecSkeltetonArray = fetchedResult as NSArray
                let descriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            } else {
                print(appDelegateObj.testFuntion())
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    
    // MARK: 🟢 Fetch Observation name with bird & farm Name
    fileprivate func handleNecropsyValdiationsFetchObsWithBirdFarmName(_ captureNecropsyViewData: CaptureNecropsyViewData, _ d: NSMutableDictionary, _ trimmedString: String) {
        if captureNecropsyViewData.measure == "Y,N"
        {
            if captureNecropsyViewData.objsVisibilty != nil{
                d.setValue(captureNecropsyViewData.objsVisibilty!, forKey: trimmedString)
            }
            
        }
        else if captureNecropsyViewData.measure == "Actual" || captureNecropsyViewData.measure == "F,M"
        {
            
            if captureNecropsyViewData.actualText?.isEmpty == false
            {
                d.setValue(captureNecropsyViewData.actualText!, forKey: trimmedString)
            }
            
        }
      
        
        else
        {
            if captureNecropsyViewData.obsPoint != nil{
                d.setValue(captureNecropsyViewData.obsPoint!, forKey: trimmedString)
            }
        }
    }
    
    fileprivate func handleNecropsyTrimmedStringValidations(_ c: NSArray, _ d: NSMutableDictionary) {
        for i in 0..<c.count {
            let captureNecropsyViewData = c.object(at: i) as! CaptureNecropsyViewData
            
            var trimmedString = captureNecropsyViewData.obsName!.replacingOccurrences(of: "/", with: "")
            trimmedString = trimmedString.replacingOccurrences(of: " ", with: "")
            
            
            if trimmedString == "BursaLesions"{
                trimmedString = "BursaLesionScore"
            }
            else if  trimmedString == "MuscularHemorrhages"{
                trimmedString = "MuscularHemorrhagies"
            }
            else if  trimmedString == "Cardiovascular/Hydropericardium"{
                trimmedString = "CardiovascularHydropericardium"
            }
            else if  trimmedString == "TBD1"{
                trimmedString = "WoodyBreast"
            }
            else if  trimmedString == "TBD2"{
                trimmedString = "Pigmentation"
            }
            else if  trimmedString == "TBD3"{
                trimmedString = "IntestinalContents"
            }
            else if  trimmedString == "TBD4"{
                trimmedString = "ThickenedIntestine"
            }
            else if  trimmedString == "TBD5"{
                trimmedString = "ThinIntestine"
            }
            else if  trimmedString == "TBD6"{
                trimmedString = "Dehydrated"
            }
            else if  trimmedString == "TBD7"{
                trimmedString = "ThymusAtrophy"
            }
            else if  trimmedString == "FemoralHeadSeparation(FHS)"{
                trimmedString = "FemoralHeadSeparationFHS"
            }
            else if  trimmedString == "EimeriaTenellaMicro"{
                trimmedString = "TenellaMicro"
            }
            else if trimmedString == Constants.maleFemaleStr
            {
                trimmedString = "MaleFemale"
            }
            handleNecropsyValdiationsFetchObsWithBirdFarmName(captureNecropsyViewData, d, trimmedString)
        }
    }
    
    func fetchObsWithBirdandFarmName(_ formName : String , birdNo : NSNumber , necId : NSNumber)-> NSMutableDictionary {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchPredicate = NSPredicate(format: "birdNo == %@  AND formName == %@ AND necropsyId == %@", birdNo, formName,necId)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = fetchPredicate
        fetchRequest.returnsObjectsAsFaults = false
        let d = NSMutableDictionary()
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                captureNecSkeltetonArray = results as NSArray
                let c = results as NSArray
                handleNecropsyTrimmedStringValidations(c, d)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return d
        
    }
  
    // MARK: - 🔴 Delete Captured Necropsy for specific observation id & Necropsy ID
    func deleteCaptureNecropsyViewDataWithObsID (_ obsId: NSNumber,necId:NSNumber)
    {
        let fetchPredicate = NSPredicate(format: "obsID == %@ AND necropsyId == %@", obsId,necId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchUsers.predicate  = fetchPredicate
        
        do
            
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }

    // MARK: - 🔴 Delete necropsy detail for specific farm
    func deleteCaptureNecropsyViewDataWithFarmnameandBirdsize (_ obsId: NSNumber,formName : String ,catName : String, birdNo : NSNumber , necId : NSNumber)
    {
        let fetchPredicate = NSPredicate(format: "birdNo == %@  AND formName == %@ AND necropsyId == %@", birdNo, formName,necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchUsers.predicate                = fetchPredicate
        do
            
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            
        }
        
    }
    
    /*******************************  Capture  data Base ********************************************************/
    /***************** save data Skleta ************************************************************************/
    // MARK: 🟢 Save Captured Skeletan Database on switch case

    func saveCaptureSkeletaInDatabaseOnSwithCase(_ data: SkeletalObservationData, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewData", in: managedContext) {
            let person = NSManagedObject(entity: entity, insertInto: managedContext)

            person.setValue(data.catName, forKey: "catName")
            person.setValue(data.birdNo, forKey: "birdNo")
            person.setValue(data.formName, forKey: "formName")
            person.setValue(data.obsId, forKey: "obsID")
            person.setValue(data.obsName, forKey: "obsName")
            person.setValue(data.obsPoint, forKey: "obsPoint")
            person.setValue(NSNumber(value: data.obsVisibility), forKey: "objsVisibilty")
            person.setValue(data.measure, forKey: "measure")
            person.setValue(data.quickLink, forKey: "quickLink")
            person.setValue(data.necId, forKey: "necropsyId")
            person.setValue(data.isSync, forKey: "isSync")
            person.setValue(data.lngId, forKey: "lngId")
            person.setValue(data.refId, forKey: "refId")
            person.setValue(data.actualText, forKey: "actualText")
            
            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            
            captureSkeletaObject.append(person)
        }
    }

    // MARK: 🟢 Save Captured Necropsy Detail
    
    func saveCaptureSkeletaInDatabaseOnSwithCaseSingleData(data: chickenCoreDataHandlerModels.updateSkeletaSingleSyncSkeletaData) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewData", in: managedContext)
        
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(data.catName, forKey: "catName")
        person.setValue(data.birdNo, forKey: "birdNo")
        person.setValue(data.formName, forKey: "formName")
        person.setValue(data.obsId, forKey: "obsID")
        person.setValue(data.obsName, forKey: "obsName")
        person.setValue(data.obsPoint, forKey: "obsPoint")
        person.setValue(NSNumber(value: data.obsVisibility as Bool), forKey: "objsVisibilty")
        person.setValue(data.measure, forKey: "measure")
        person.setValue(data.quickLink, forKey: "quickLink")
        person.setValue(data.necIdSingle, forKey: "necropsyId")
        person.setValue(data.isSync, forKey: "isSync")
        person.setValue(data.lngId, forKey: "lngId")
        person.setValue(data.refId, forKey: "refId")
        person.setValue(data.actualText, forKey: "actualText")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        captureSkeletaObject.append(person)
    }

    
    
    /*
    func saveCaptureSkeletaInDatabaseOnSwithCaseSingleData(catName : String,obsName : String,formName : String, obsVisibility : Bool,  birdNo : NSNumber,obsPoint:NSInteger, index : Int,obsId: NSInteger ,measure: String,quickLink: NSNumber,necId:NSNumber,isSync : Bool,necIdSingle:NSNumber,lngId:NSNumber,refId:NSNumber,actualText:String)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewData", in: managedContext)
        
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(catName, forKey:"catName")
        person.setValue(birdNo, forKey:"birdNo")
        person.setValue(formName, forKey:"formName")
        person.setValue(obsId, forKey:"obsID")
        person.setValue(obsName, forKey:"obsName")
        person.setValue(obsPoint, forKey:"obsPoint")
        person.setValue(NSNumber(value: obsVisibility as Bool), forKey:"objsVisibilty")
        person.setValue(measure, forKey:"measure")
        person.setValue(quickLink, forKey:"quickLink")
        person.setValue(necIdSingle, forKey:"necropsyId")
        person.setValue(isSync, forKey:"isSync")
        person.setValue(lngId, forKey:"lngId")
        person.setValue(refId, forKey:"refId")
        person.setValue(actualText, forKey:"actualText")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        captureSkeletaObject.append(person)
    }
   */
    // MARK: - 🔴 Delete Step 2 data for Captured Necropsy
    func deleteDataWithStep2data (_ necId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers            = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchUsers.predicate   = fetchPredicate
        do
            
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
  
    // MARK: 🟠 Update captured Necropsy Sync Status and Bird Weight
    func updateCaptureSkeletaInDatabaseOnActualClick(data: chickenCoreDataHandlerModels.actualClickUpdateCaptureSkeletaData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND necropsyId == %@ AND refId == %@", data.birdNo, data.catName, data.formName, data.necId, data.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let objTable = fetchedResult?.first as? CaptureNecropsyViewData {
                objTable.setValue(data.actualName, forKey: "actualText")
                objTable.setValue(data.isSync, forKey: "isSync")
                
                do {
                    try objTable.managedObjectContext?.save()
                } catch {
                    print("Failed to save data.")
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    // MARK: 🟠 Update captured Necropsy status for Skeletan Category

    func updateisSyncOnCaptureSkeletaInDatabase(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@", necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewData = (fetchedResult![i] as? CaptureNecropsyViewData)!
                    objTable.setValue(isSync, forKey:"isSync")
                    
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
                
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            
        }
    }

    // MARK: 🟠 update captured Necropsy Sync Status

    func updateisSyncOnCaptureInDatabase(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@", necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewData = (fetchedResult![i] as? CaptureNecropsyViewData)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
                
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            
        }
    }
    func updateIsSyncForEntity(entityName: String, predicateFormat: String, predicateValue: CVarArg, isSync: Bool) -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // Ensure predicateValue is properly cast to CVarArg type
        fetchRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: [predicateValue])

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let fetchedResult = fetchedResult, fetchedResult.count > 0 {
                for obj in fetchedResult {
                    obj.setValue(isSync, forKey: "isSync")
                    try obj.managedObjectContext?.save()
                }
                return true
            }
        } catch {
            print("Error: \(error)")
        }
        return false
    }

    

    // MARK: 🟠 Update Observation's Points in Captured Necropsy

    func updateCaptureSkeletaInDatabaseOnStepper(_ catName : String,obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , index : Int, necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@", birdNo,catName,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(index, forKey:"obsPoint")
                
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            
        }
    }

    // MARK: 🟠 Update bird Weight in Captured Necropsy
   func updateObsDataInCaptureSkeletaInDatabaseOnActual(_ obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , actualName : String , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(actualName, forKey:"actualText")
                objTable.setValue(true, forKey:"isSync")
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            
        }
    }

    // MARK: 🟠- Update Swich Method //
    
    func updateCaptureSkeletaInDatabaseOnSwitchMethod(_ catName : String,obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , switchValue : Bool , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@", birdNo,catName,formName,obsId,necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(switchValue, forKey:"objsVisibilty")
                
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            
        }
    }
 
    // MARK: 🟠 Update Captured Necropsy View Details
    
    func updateCaptureSkeletaInDatabaseOnSwitchCase(_ data: chickenCoreDataHandlerModels.updateSkeletalSwitchCaseCaptureData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.managedObjectContext
        let imageData = data.cameraImage.jpegData(compressionQuality: 0.5)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateCatNameBirdsFarmNecID,
                                             data.birdNo, data.catName, data.formName, data.necId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                fecthPhotoArray = results as NSArray
                let descriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])
                
                if let objTable = (sortedResults as NSArray)[data.index] as? CaptureNecropsyViewData {
                    objTable.setValue(NSNumber(value: data.obsVisibility), forKey: "objsVisibilty")
                    objTable.setValue(imageData, forKey: "cameraImage")
                    objTable.setValue(data.obsPoint, forKey: "obsPoint")
                    objTable.setValue(data.birdNo, forKey: "birdNo")
                    objTable.setValue(data.formName, forKey: "formName")
                    objTable.setValue(data.isSync, forKey: "isSync")
                    
                    do {
                        try objTable.managedObjectContext?.save()
                    } catch {
                        print("Failed to save context")
                    }
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    // MARK: - 🔴 Delete Captured Necropsy View Data
    func deleteCaptureNecropsyViewData ()
    {
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: 🟢 Save Bird Photo & other Details
    
    func getSaveImageFromServer(_ dict : NSDictionary)  {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let encodedImageData = String(describing: dict.value(forKey: "image")!)
        let imageData = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions(rawValue: 0))
        let image = UIImage(data: imageData!)
        let imageData1 = image!.jpegData(compressionQuality: 0.5)
        let entity   = NSEntityDescription.entity(forEntityName: "BirdPhotoCapture", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(dict.value(forKey: "farmName"), forKey:"farmName")
        person.setValue(dict.value(forKey: "categoryName"), forKey:"catName")
        person.setValue(dict.value(forKey: "birdNumber"), forKey:"birdNum")
        person.setValue(dict.value(forKey: "observationName"), forKey:"obsName")
        person.setValue(dict.value(forKey: "observationId"), forKey:"obsId")
        person.setValue(imageData1, forKey:"photo")
        person.setValue(dict.value(forKey: "sessionId"), forKey:"necropsyId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        capturePhotoObject.append(person)
        
    }

    // MARK: 🟠 get Saved image for Necropsy from server

    func getSaveImageFromServerSingledata(_ dict : NSDictionary,necIdSingle:NSNumber)  {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let encodedImageData = String(describing: dict.value(forKey: "image")!)
        let imageData = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions(rawValue: 0))
        let image = UIImage(data: imageData!)
        let imageData1 = image!.jpegData(compressionQuality: 0.5)
        let entity   = NSEntityDescription.entity(forEntityName: "BirdPhotoCapture", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(dict.value(forKey: "farmName"), forKey:"farmName")
        person.setValue(dict.value(forKey: "categoryName"), forKey:"catName")
        person.setValue(dict.value(forKey: "birdNumber"), forKey:"birdNum")
        person.setValue(dict.value(forKey: "observationName"), forKey:"obsName")
        person.setValue(dict.value(forKey: "observationId"), forKey:"obsId")
        person.setValue(imageData1, forKey:"photo")
        person.setValue(necIdSingle, forKey:"necropsyId")
        person.setValue(false, forKey:"isSync")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        capturePhotoObject.append(person)
        
    }
   
    // MARK: - 🔴 Delete Bird's captured Photo's for Specific Necropsy Id
    func deleteImageForSingle (_ necId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }

    // MARK: 🟠 Save Captured Birds Photo's for Necropsy
    
    func saveCaptureSkeletaImageInDatabase(data: chickenCoreDataHandlerModels.saveSkeletalBirdPhotoCaptureData) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        data.viewController.showtoast(message: "Image Conversion")
        
        data.viewController.showtoast(message: "Image Converted")
        
        let entity = NSEntityDescription.entity(forEntityName: "BirdPhotoCapture", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        data.viewController.showtoast(message: "Data Saving")
        person.setValue(data.formName, forKey: "farmName")
        data.viewController.showtoast(message: "farm Saved")
        
        person.setValue(data.catName, forKey: "catName")
        data.viewController.showtoast(message: "catName Saved")
        
        person.setValue(data.birdNo, forKey: "birdNum")
        data.viewController.showtoast(message: "birdNum Saved")
        
        person.setValue(data.obsName, forKey: "obsName")
        data.viewController.showtoast(message: "obsName Saved")
        
        person.setValue(data.obsId, forKey: "obsId")
        data.viewController.showtoast(message: "obsId Saved")
        
        var imageData = Data(data.cameraImage.jpegData(compressionQuality: 1.0) ?? Data())
        person.setValue(imageData, forKey: "photo")
        data.viewController.showtoast(message: "photo Saved")
        
        person.setValue(data.necropsyId, forKey: "necropsyId")
        data.viewController.showtoast(message: "necropsyId Saved")
        
        person.setValue(data.isSync, forKey: "isSync")
        data.viewController.showtoast(message: "Data Saved")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        capturePhotoObject.append(person)
    }

    // MARK: 🟠 Update Captured photo's for Birds in Necropsy
   
    func updateisSyncOnBirdPhotoCaptureDatabase(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: BirdPhotoCapture = (fetchedResult![i] as? BirdPhotoCapture)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
                completion(true)
            }
            else{
                completion(true)
            }
        }
        catch
        {
            
        }
        
    }
    // MARK: 🟢Fetch Photo's for Specific Farm Name & Necropsy Id
    func fecthPhotoWithFormName(_ farmname : String,necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: "farmName == %@ AND necropsyId == %@", farmname,necId)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fecthPhotoArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fecthPhotoArray
    }
    // MARK: 🟢Fetch Photo's for Specific Necropsy ID
    func fecthPhotoWithFormNameWithNecId(necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate,necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fecthPhotoArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {
                
            }
        }
        catch
        {
            
        }
        
        return fecthPhotoArray
    }
    // MARK: 🟢 Fetch If any Captured Image is Available for Sync
    func fecthPhotoWithiSynsTrue(_ isSync : Bool)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateStatus, NSNumber(booleanLiteral: isSync))
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fecthPhotoArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fecthPhotoArray
    }
    // MARK: 🟢 Fetch Captured Photo's for Cat Name & Farm Name
    
    func fecthPhotoWithCatnameWithBirdAndObservationID(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber , obsName : String,necId :NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: "birdNum == %@ AND catName == %@ AND farmName == %@ AND obsId ==%@ AND obsName ==%@  AND necropsyId ==%@", birdnumber,catName,farmname,Obsid,obsName, necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                
                fecthPhotoArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fecthPhotoArray
    }
    // MARK: 🟢Fertch Captured photo's for Birds Necropsy's Observation
    func fecthPhotoWithCatnameWithBirdAndObservationIDandIsync(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber , isSync : Bool,necId :NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: "birdNum == %@ AND catName == %@ AND farmName == %@ AND obsId ==%@ AND isSync ==%@  AND necropsyId ==%@", birdnumber,catName,farmname,Obsid,NSNumber(booleanLiteral: isSync), necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fecthPhotoArray = results as NSArray
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])
                return sortedResults as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fecthPhotoArray
    }
    // MARK: 🟠 Save Number of birds with Notes
    func saveNoofBirdWithNotes(_ catName : String,notes : String,formName : String,   birdNo : NSNumber, index : Int , necId : NSNumber , isSync : Bool)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "NotesBird", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(formName, forKey:"formName")
        person.setValue(catName, forKey:"catName")
        person.setValue(notes, forKey:"notes")
        person.setValue(birdNo, forKey:"noofBirds")
        person.setValue(necId, forKey:"necropsyId")
        person.setValue(isSync, forKey:"isSync")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        captureBirdWithNotesObject.append(person)
        
    }
 
    // MARK: 🟠 Save Number of birds with Notes for single Data
    func saveNoofBirdWithNotesSingledata(_ birdData: chickenCoreDataHandlerModels.BirdNotesData) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "NotesBird", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(birdData.formName, forKey:"formName")
        person.setValue(birdData.catName, forKey:"catName")
        person.setValue(birdData.notes, forKey:"notes")
        person.setValue(birdData.birdNo, forKey:"noofBirds")
        person.setValue(birdData.necIdSingle, forKey:"necropsyId")
        person.setValue(birdData.isSync, forKey:"isSync")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        captureBirdWithNotesObject.append(person)
    }

    // MARK: 🟠 Save Molecule data
    func saveMoleCule(_ catId : Int,decscMolecule : String,moleculeId : Int, lngId : Int)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "MoleCuleFeed", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(catId, forKey:"catId")
        person.setValue(decscMolecule, forKey:"desc")
        person.setValue(lngId, forKey:"lngId")
        person.setValue(moleculeId, forKey:"moleculeId")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        moleCule.append(person)
        
    }
    
    // MARK: 🟠 Save Coccidiosis Vaccine responce
    func saveCocoiiVac(_ catId : Int,decscMolecule : String, lngId : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "CocoiVaccine", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(catId, forKey:"cocvaccId")
        person.setValue(decscMolecule, forKey:"cocoiiVacname")
        person.setValue(lngId, forKey:"lngId")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        cocoivacc.append(person)
    }
    
    // MARK: 🟢 Fetching Coccidiosis vaccine list
    func fetchCociVac() -> NSArray{
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocoiVaccine")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
        
    }
    // MARK: 🟢 Fetching Coccidiosis vaccine list on language basis.
    func fetchCociVacLngId(lngId:NSNumber) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocoiVaccine")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    // MARK: 🟢 Fetching Molecule feed list
    func fetchMoleCule() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MoleCuleFeed")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    // MARK: 🟢 Fetching Molecule Feed list as per lanugage
    func fetchMoleCuleLngId(lngId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MoleCuleFeed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    // MARK: - 🔴 Delete Specific Bird number with necropsy ID.
    func deleteDataBirdNotesWithId (_ necId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers   = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchUsers.predicate   = fetchPredicate
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: 🟢 Update Birds Note as per necropsy ID
    func updateisSyncOnNotesBirdDatabase(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: NotesBird = (fetchedResult![i] as? NotesBird)!
                    objTable.setValue(isSync, forKey:"isSync")
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
                completion(true)
                
            }
            else{
                completion(true)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: 🟢 Update Birds Notes for Specific Necropsy & Farm
    func updateNoofBirdWithNotes(_ catName : String,formName : String,   birdNo : NSNumber , notes: String , necId : NSNumber,isSync : Bool)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateBirdsFarmNecID, birdNo,formName,necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: NotesBird = (fetchedResult![0] as? NotesBird)!
                objTable.setValue(notes, forKey: "notes")
                objTable.setValue(isSync, forKey: "isSync")
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }

    
    // MARK: 🟢 Fetching Number of Birds with farm name necropsy id & category
    func fetchNoofBirdWithForm(_ catName : String,formName : String , necId: NSNumber )-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesBird")
        fetchRequest.predicate = NSPredicate(format: "catName == %@ AND formName == %@ AND necropsyId = %@",catName,formName, necId)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fetchBirdNotesArray = results as NSArray
                return fetchBirdNotesArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fetchBirdNotesArray
    }
    
    // MARK: 🟢 Fetching Notes with Bird Number farm name & Necropsy ID
    func fetchNotesWithBirdNumandFarmName(_ birdNo : NSNumber,formName : String , necId: NSNumber )-> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchRequest.predicate = NSPredicate(format: "formName == %@ AND noofBirds == %@ AND necropsyId == %@",formName,birdNo, necId)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fetchBirdNotesArray = results as NSArray
                return fetchBirdNotesArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return fetchBirdNotesArray
    }
    
    // MARK: 🟢 Fetching Number of birds with Notes
    func fetchNoofBirdWithNotes(_ catName : String,formName : String,   birdNo : NSNumber ,necId : NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesBird")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateBirdsFarmNecID, birdNo,formName,necId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                fetchBirdNotesArray = results as NSArray
                return fetchBirdNotesArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return fetchBirdNotesArray
    }
    
    
    // MARK: - 🔴 Delete Birds Notes for Specific Farm , Bird No & Necropsy ID
    func deleteNotesBirdWithFarmname (_ formName : String ,  birdNo : NSNumber , necId : NSNumber)
    {
        let fetchPredicate = NSPredicate(format: "noofBirds == %@  AND formName == %@ AND necropsyId = %@", birdNo, formName , necId)
        let fetchUsers     = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchUsers.predicate  = fetchPredicate
        
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: - 🔴********* Delete Birds Notes
    func deleteNotesBird ()
    {
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        
        do
        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    //MARK: 🟠********* Fetch Captured Necropsy View Data
    func fetchCaptureWithFormNameNecSkeltonData(farmName:String, necID : NSNumber) -> NSArray    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "formName == %@ AND necropsyId == %@", farmName,necID)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            
        }
        return captureNecSkeltetonArray
    }
    //MARK: 🟠********* Update Cell Index in View Necropsy Data
    func updateCellIndex(_ formName : String , necID : NSNumber , cellIndex: NSNumber)    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "formName == %@ AND necropsyId == %@", formName,necID)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(cellIndex, forKey: "cellIndex")
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    //MARK: 🟠****************************    ************************************/
    
    func AllCappNecdata() -> NSArray
    {
        
        self.fetchCaptureNecropsyData()
        
    }
    
    // MARK: 🟠************************  Quick Link Methods ****************************************/
    
    func updateObsDataInCaptureSkeletaInDatabaseOnStepper(_ obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , index : Int , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(index, forKey:"obsPoint")
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    //MARK: 🟠***************************** Switch Methods *************************************************/
    
    func updateSwitchDataInCaptureSkeletaInDatabaseOnSwitch(_ formName : String,   birdNo : NSNumber ,  obsId : NSNumber , obsVisibility : Bool , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(NSNumber(value: obsVisibility as Bool), forKey:"objsVisibilty")
                
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: 🟠 Update Bird Sex in Chicken Necropsy View Data
    func updateBirdSexDataInCaptureSkeletaInDatabase(_ formName : String,   birdNo : NSNumber ,  obsId : NSNumber , BirdSex : String , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewData = (fetchedResult![0] as? CaptureNecropsyViewData)!
                objTable.setValue(BirdSex, forKey:"actualText")
                
                do
                {
                    try objTable.managedObjectContext!.save()
                }
                catch{
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: 🟢 **************Fetch Report Screen Data***************/////////////
    
    func fetchLastSessionDetails(_ postingId : NSNumber) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        let fetchPredicate = NSPredicate(format:Constants.postincIdPredicate, postingId)
        fetchRequest.predicate = fetchPredicate
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                return results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
    }
    // MARK: 🟢 Fetch GI_Tract Data with Farm Name & Posting ID
    func fetch_GI_Tract_AllData(_ farmName : NSString , postingId : NSNumber) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.returnsObjectsAsFaults = false
        let fetchPredicate = NSPredicate(format: Constants.predicateNecFarmName,postingId,farmName)
        fetchRequest.predicate = fetchPredicate
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                return results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
    }
    // MARK: 🟠  Save Hatchery Strain's in DB
    func SaveStrainDataDatabase(_ StrainName: String,StrainId: Int,lngId: Int){
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "HatcheryStrain", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(StrainName, forKey:"strainName")
        person.setValue(StrainId, forKey:"strainId")
        person.setValue(lngId, forKey:"lngId")
        do {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        FarmsTypeObject.append(person)
        
    }
    // MARK: 🟠  Save field Strain's in DB
    func SaveStrainDataDatabaseField(_ StrainName: String,StrainId: Int,lngId: Int){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "GetFieldStrain", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(StrainName, forKey:"strainName")
        person.setValue(StrainId, forKey:"strainId")
        person.setValue(lngId, forKey:"lngId")
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        FarmsTypeObject.append(person)
    }
    // MARK: 🟠  Save Dossage in DB
    func SaveDosageDataDatabaseField(_ doseName: String,doseId: Int){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "GetDosage", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(doseName, forKey:"doseName")
        person.setValue(doseId, forKey:"doseId")
        
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        FarmsTypeObject.append(person)
    }
    
    // MARK: 🟠 Save Dossage Data with Molecule ID
    func SaveDosageDataWithMoleculeIDDatabaseField(_ doseName: String,doseId: Int,molecukeId: Int){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "GetDosageWithMoleculeID", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(doseName, forKey:"doseName")
        person.setValue(doseId, forKey:"doseId")
        person.setValue(molecukeId, forKey:"moleculeId")
        do {
            try managedContext.save()
        }
        
        catch {
            print(appDelegateObj.testFuntion())
        }
        FarmsTypeObject.append(person)
    }
    
    // MARK: 🟠 Save Turkey Dossage with Molecule ID
    func SaveTurkeyDosageDataWithMoleculeIDDatabaseField(_ doseName: String,doseId: Int,molecukeId: Int){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "GetDosageTurkeyWithMoleculeID", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(doseName, forKey:"doseName")
        person.setValue(doseId, forKey:"doseId")
        person.setValue(molecukeId, forKey:"moleculeId")
        do {
            try managedContext.save()
        }
        
        catch {
            print(appDelegateObj.testFuntion())
        }
        FarmsTypeObject.append(person)
    }
    
    // MARK: 🟢  ********************** Set Farms Details ***************************/
    
    func FarmsDataDatabase(_ stateName: String,stateId: NSNumber,farmName: String,farmId: NSNumber,countryName: String,countryId: NSNumber,city: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "FarmsList", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(city, forKey:"City")
        person.setValue(countryId, forKey:"CountryId")
        person.setValue(countryName, forKey:Constants.countryNamStr)
        person.setValue(farmId, forKey:"FarmId")
        person.setValue(farmName, forKey:"FarmName")
        person.setValue(stateId, forKey:"StateId")
        person.setValue(stateName, forKey:"StateName")
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
        FarmsTypeObject.append(person)
    }
    // MARK: 🟢 Fetch All Farm's List.
    func fetchFarmsDataDatabase() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FarmsList")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                farmsArrReturn = results as NSArray
            }
            else{
            }
        }
        catch
        {
            
        }
        return farmsArrReturn
    }
    func fetchDataDatabaseWithEntity(entityName:String) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  entityName)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                farmsArrReturn = results as NSArray
            }
            else{
            }
            
        }
        
        catch{
            print(appDelegateObj.testFuntion())
        }
        return farmsArrReturn
    }
    // MARK: 🟢 Fetch Dossage with Mollecule Id
    func fetchDossgaeWithMoleculeId(_ moliculeId: NSNumber) -> NSArray {
        
        var dossagesDataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "GetDosageWithMoleculeID")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "moleculeId == %@", moliculeId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dossagesDataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dossagesDataArray
    }
    // MARK: 🟢 Fetch Turkeuy Dossage with Molecule ID
    func fetchTurkeyDossgaeWithMoleculeId(_ moliculeId: NSNumber) -> NSArray {
        
        var turkeyDosageArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "GetDosageTurkeyWithMoleculeID")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "moleculeId == %@", moliculeId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                turkeyDosageArray = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return turkeyDosageArray
        
    }
    // MARK: 🟢 Fetch Strain with Language ID
    func fetchStrainWithlanguage(entityName:String , lngID: Int) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  entityName)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "lngId == %d ",  lngID)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                farmsArrReturn = results as NSArray
            }
           
            
        }
        catch
        {
            
        }
        return farmsArrReturn
    }
    
    // MARK: 🟢 ******** Fetch farm using ComlexId **********************/
    
    func fetchFarmsDataDatabaseUsingCompexId(complexId:NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FarmsList")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        let fetchPredicate  = NSPredicate(format: "countryId == %@", complexId)
        fetchRequest.predicate = fetchPredicate
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
                
            {
                farmsArrReturn = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return farmsArrReturn
    }
    
    // MARK: - 🔴  Remove Duplicates
    func removeDuplicates(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("no duplicate data.")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
        
        return result
    }
    // MARK: 🟠  sync available
    func checkPostingSessionHasiSyncTrue(_ postingID : NSNumber,isSync:NSNumber)-> Bool
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "PostingSession")
        fetchRequest.predicate = NSPredicate(format: Constants.postIdStatusPredicator, postingID , NSNumber(booleanLiteral: isSync as! Bool))
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult, results.count > 0 {
               
                    return true
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return false
    }
    // MARK: 🟠 Check if any necropsy session is available for sync
    func checkNecropcySessionHasiSyncTrue(_ postingID : NSNumber,isSync:NSNumber)-> Bool
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND isSync == %@", postingID , NSNumber(booleanLiteral: isSync as! Bool))
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult, results.count > 0 {
            
                    return true
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return false
    }
    // MARK: 🟠 ************ Update FarmName , Age , House Number ********************/
    func updateNecropsystep1WithNecIdAndFarmName(_ necropsyId : NSNumber , farmName : NSString , newFarmName : NSString , age : String,  newHouseNo : NSString ,isSync:Bool)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necropsyId, farmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyData = (fetchedResult![i] as? CaptureNecropsyData)!
                    objTable.setValue(newFarmName, forKey:"farmName")
                    objTable.setValue(isSync, forKey:"isSync")
                    objTable.setValue(age, forKey:"age")
                    objTable.setValue(newHouseNo, forKey:"houseNo")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: 🟠 ***** Update Farm Name In Step ! ****************/
    func updateNewFarmAndAgeOnCaptureNecropsyViewData(_ necId : NSNumber , oldFarmName : String , newFarmName : String ,isSync:Bool)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND formName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewData = (fetchedResult![i] as? CaptureNecropsyViewData)!
                    objTable.setValue(isSync, forKey:"isSync")
                    objTable.setValue(newFarmName, forKey:"formName")
                    
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: 🟠 Update Farm name
    func updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdPhoto(_ necId : NSNumber , oldFarmName : String , newFarmName : String ) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND farmName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: BirdPhotoCapture = (fetchedResult![i] as? BirdPhotoCapture)!
                    objTable.setValue(newFarmName, forKey:"farmName")
                    
                    do
                    {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch  {
            
        }
        
    }
    // MARK: 🟠 Update Farm name with Sync Veriable
    func updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdNotes(_ necId : NSNumber , oldFarmName : String , newFarmName : String ,isSync:Bool){
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND formName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: NotesBird = (fetchedResult![i] as? NotesBird)!
                    objTable.setValue(isSync, forKey:"isSync")
                    objTable.setValue(newFarmName, forKey:"formName")
                    
                    do {
                        try objTable.managedObjectContext!.save()
                    }
                    catch{
                    }
                }
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: 🟢 Fetch observations name Under GITract for Reference Id & Language
    
    func getObservationNameForGITract(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"GITract")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let results = fetchedResult , results.count > 0
                {
                        let ob: GITract = results.last as! GITract
                        nameArray.append(ob.observationField!)
                    
                }
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
        }
        return nameArray
    }
    // MARK: 🟢 Fetch observations name Under Skelatal for Reference Id & Language
    func getObservationNameForSkelatal(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"Skeleta")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult , results.count > 0
                {
                    
                        let ob: Skeleta = results.last as! Skeleta
                        nameArray.append(ob.observationField!)
                    
                }
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
        }
        return nameArray
    }
    // MARK: 🟢 Fetch observations name Under Immune/Other for Reference Id & Language
    func getObservationNameForImmune(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"Immune")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult , results.count > 0
                {
                 
                        let ob: Immune = results.last as! Immune
                        nameArray.append(ob.observationField!)
                    
                }
            }
            catch {
            }
        }
        return nameArray
    }
    // MARK: 🟢 Fetch observations name Under Respiratory for Reference Id
    func getObservationNameForRespiratory(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"Respiratory")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do  {
                
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let results = fetchedResult , results.count > 0 {
                  
                        let ob: Respiratory = results.last as! Respiratory
                        nameArray.append(ob.observationField!)
                    
                }
            } catch  {
            }
        }
        return nameArray
    }
    // MARK: 🟢 Fetch observations name Under Coccidiosis for Reference Id
    func getObservationNameForCoccidiosis(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"Coccidiosis")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let results = fetchedResult ,  results.count > 0
                {
                
                        let ob: Coccidiosis = results.last as! Coccidiosis
                        if ob.visibilityCheck == true{
                            nameArray.append(ob.observationField!)}
                    
                }
            }
            catch
            {
                print(appDelegateObj.testFuntion())
            }
        }
        return nameArray
    }
    // MARK: 🟢 Fetch All Posted Session with Complex Name & Session Date
    func fetchAllPostingExistingSessionWithId(sessionDate: String,newString:String) -> NSArray    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.predicate = NSPredicate(format: "sessiondate == %@ AND complexName == %@", sessionDate,newString)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                postingArray  = results as NSArray
            }
            else
            {
                print(appDelegateObj.testFuntion())
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    //MARK: - 🔴 Delete Captured Necropsy Data for specific Posting ID & Farm details
    func deleteDataWithPostingIdStep1dataWithfarmName (_ postingId: NSNumber,farmName:String, _ completion: (_ status: Bool) -> Void)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necFarmNamePredicate, postingId,farmName)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyData")
        fetchUsers.predicate = fetchPredicate
        do        {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        completion(true)
    }
    //MARK: - 🔴 Delete Captured Necropsy View Data for specific Posting ID & Farm details
    func deleteDataWithPostingIdStep2dataCaptureNecViewWithfarmName (_ postingId: NSNumber,farmName:String, _ completion: (_ status: Bool) -> Void)
    {
        let fetchPredicate = NSPredicate(format: Constants.predicateNecFarmName, postingId,farmName)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewData")
        fetchUsers.predicate                = fetchPredicate
        
        do {
            
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        completion(true)
    }
    //MARK: - 🔴 Delete Birds Notes for specific Posting ID
    func deleteDataWithPostingIdStep2NotesBirdWithFarmName (_ postingId: NSNumber,farmName:String, _ completion: (_ status: Bool) -> Void) {
        
        let fetchPredicate = NSPredicate(format: Constants.predicateNecFarmName, postingId,farmName)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBird")
        fetchUsers.predicate = fetchPredicate
        do {
            
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        completion(true)
    }
    // MARK: - 🔴 Delete Necropsy capyured Image for specific Posting ID
    func deleteDataWithPostingIdStep2CameraIamgeWithFarmName (_ postingId:NSNumber,farmName:String, _ completion: (_ status: Bool) -> Void) {
        
        let fetchPredicate = NSPredicate(format: Constants.necFarmNamePredicate, postingId,farmName)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCapture")
        fetchUsers.predicate = fetchPredicate
        do {
            let results = try backgroundContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                backgroundContext.delete(managedObjectData)
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        completion(true)
    }
    // MARK: 🟢 Fetch Complete Posting Session with ID
    func fetchCompletePostingSession(_ postingid :NSNumber) -> PostingSession {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSession")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:Constants.postincIdPredicate, postingid)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult?[0]
            {
                return results as! PostingSession
            }
            
        }
        catch
        {
        }
        return PostingSession()
    }
    // MARK: 🟠 Save All Birds Swaped Indexes
    func saveAllBirdsSwapedIndexes(_ birdName: String, index: Int) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "AllBirdsSwapedArray", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(birdName, forKey:"birdName")
        person.setValue(index, forKey:"index")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        FarmsTypeObject.append(person)
    }
    // MARK: - 🔴 Delete All Birds Swaped Indexes
    func deleteAllBirdsSwapedIndexes() {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AllBirdsSwapedArray")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            for item in objects ?? []  {
                managedContext.delete(item)
                try managedContext.save()
            }
        } catch {
            debugPrint("Somthing went wrong on fetching")
        }
    }
    // // MARK: 🟢  Fetch All Birds Swaped Indexes
    func fetchAllBirdsSwapedIndexes() -> [AllBirdsSwapedArray] {
        var result = [AllBirdsSwapedArray]()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AllBirdsSwapedArray")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as? [AllBirdsSwapedArray]
            if objects!.count != 0 {
                result = objects ?? []
            }
        } catch {
            debugPrint("Somthing went wrong on fetching")
        }
        return result
    }
}

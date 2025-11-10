//
//  CoreDataHandlerPVE.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 29/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON



class CoreDataHandlerPVE: NSObject {
    
    let sharedManager = PVEShared.sharedInstance
    
    private var managedContext  = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    
    private var custData = [NSManagedObject]()
    private var ageOfBirdsData = [NSManagedObject]()
    private var breedOfBirdsData = [NSManagedObject]()
    private var siteIDData = [NSManagedObject]()
    private var evaluatorData = [NSManagedObject]()
    private var assignUserData = [NSManagedObject]()
    private var housingData = [NSManagedObject]()
    
    private var assessmentCat = [NSManagedObject]()
    private var sessionPVE = [NSManagedObject]()
    private var assessmentQ = [NSManagedObject]()
    
    private var pveSync = [NSManagedObject]()
    
    private var serotype = [NSManagedObject]()
    private var vaccineNames = [NSManagedObject]()
    private var vaccineMan = [NSManagedObject]()
    private var surveyType = [NSManagedObject]()
    private var siteInjects = [NSManagedObject]()
    
    private var routeArray = NSArray()
    let predicateStr = "userId == %@ AND customer == %@ AND complexName == %@"
    let predicateUserId = "userId == %@"
    let predicateSync = "syncId == %@"
    let predicateSeqStr = "seq_Number == %@"
    let predicateSeqisSelectedStr = "seq_Number == %@ AND isSelected == %@"
    let predicateSeqTypeSyncId = "seq_Number == %@ AND id == %@ AND type == %@ AND syncId == %@"
    let predicateSeqId = "seq_Number == %@ AND id == %@"
    let message = "test message"
    override init() {
        super.init()
        self.setupContext()
    }
    
    func setupContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
    }
    
    func saveVaccineNameDetailsInDB(json:PVEVaccineNameDetailsRes) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_VaccineNamesDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.name, forKey: "name")
        person.setValue(json.mfg_Id, forKey: "mfg_Id")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        vaccineNames.append(person)
    }
    
    func saveVaccineManDetailsInDB(json:PVEVaccineManDetailsRes) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_VaccineManDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        vaccineMan.append(person)
    }
    
    func saveSurveyTypeDetailsInDB(json:PVESurveyTypeDetailsRes) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_SurveyTypeDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.surveyName, forKey: "surveyName")
        person.setValue(json.surveyType, forKey: "surveyType")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        surveyType.append(person)
    }
    
    func saveSiteInjctsDetailsInDB(json:PVESiteInjctsDetailsRes) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_SiteInjctsDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        siteInjects.append(person)
    }
    
    func saveSerotypeDetailsInDB(json:PVESerotypeDetailsRes) {
        let entity = NSEntityDescription.entity(forEntityName: "PVE_SerotypeDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.type, forKey: "type")
        person.setValue(json.vaccineId, forKey: "vaccine_Id")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        serotype.append(person)
    }
    
    func saveCustomerDetailsInDB(_ custId: NSNumber, custName: String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "Customer_PVE", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(custId, forKey: "customerId")
        person.setValue(custName, forKey: "customerName")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        custData.append(person)
        
    }
    
    
    
    func saveBlankPdfInDB(fileName: String, pdfPathStr: String , pdfCompletePathStr: String ) {

        let entity = NSEntityDescription.entity(forEntityName: "PVE_PdfDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(fileName, forKey: "fileName")
        person.setValue(pdfPathStr, forKey: "pdfPath")
        person.setValue(pdfCompletePathStr, forKey: "pdfCompletePath")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        vaccineMan.append(person)
    }
    
    
    
    func saveOtherPdfInDB(fileName: String, otherPdfPath: String , otherPdfCompletePath: String ) {
        
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_OtherPdfDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(fileName, forKey: "fileName")
        person.setValue(otherPdfPath, forKey: "pdfPath")
        person.setValue(otherPdfCompletePath, forKey: "pdfCompletePath")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        vaccineMan.append(person)
    }
    
    func fetchpdf(_ fileName: NSString) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_PdfDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "fileName == %@", fileName)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchCustomerWithCustId(_ custId: NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Complex_PVE")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId == %@", custId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        return dataArray
        
    }
    
    func fetchDetailsForSyncDataForSync(syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let siteNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let siteNameStr = siteNameArr[0] as! String
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "syncId != %@ AND complexName == %@", argumentArray: [syncId, siteNameStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchDetailsForSyncData() -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let siteNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let siteNameStr = siteNameArr[0] as! String
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: predicateStr, argumentArray: [currentUserId, customerStr, siteNameStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    ///Same implementatio of function fetchDraftAssementArr()
    func getSyncdAssementsArr(selectedBirdTypeId:Int, type:String, syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentCategoriesDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id != %d AND syncId == %@", argumentArray: [selectedBirdTypeId, syncId])
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchDetailsForAssessmentCategoriesDetails() -> NSArray {
        
        let selectedBirdTypeId = sharedManager.getSessionValueForKeyFromDB(key: "selectedBirdTypeId")
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentCategoriesDetails")
        fetchRequest.returnsObjectsAsFaults = false
        // comment this for now so that we can see all the data as per our new ticket 2025
        fetchRequest.predicate = NSPredicate(format: "id != %d", argumentArray: [selectedBirdTypeId])
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } 
        catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchAllUserSavedDataInComplexPopup() -> NSArray {
        
        let userId =  UserDefaults.standard.value(forKey: "Id") as? Int
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_CustomerComplexPopup")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateUserId, argumentArray: [userId!])
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    
    func fetchUnsyncDetails(type:String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let customerIdArr = valuee.value(forKey: "customerId")  as! NSArray
            let customerId = customerIdArr[0] as! Int
            
            let complexIdArr = valuee.value(forKey: "complexId")  as! NSArray
            let complexIdStr = complexIdArr[0] as! Int
            //   print("complexId----\(complexIdStr)")
            
            let userIdArr = valuee.value(forKey: "userId")  as! NSArray
            let userIdStr = userIdArr[0] as! Int
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "syncedStatus == %@ AND type == %@ AND customerId == %@ AND complexId == %@ AND userId == %@", argumentArray: [false, type, customerId, complexIdStr, userIdStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchDataForSync() -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
       
            let userIdArr = valuee.value(forKey: "userId")  as! NSArray
            let userIdStr = userIdArr[0] as! Int
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "syncedStatus == %@ AND userId == %@", argumentArray: [false, userIdStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchSingleDataForSync(id: String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            let userIdArr = valuee.value(forKey: "userId")  as! NSArray
            let userIdStr = userIdArr[0] as! Int
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "syncId == %@ AND userId == %@", argumentArray: [id, userIdStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchSyncDataDetailsForTypeOfData(type:String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let userIdArr = valuee.value(forKey: "userId")  as! NSArray
            let userIdStr = userIdArr[0] as! Int
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "syncedStatus == %@ AND userId == %@", argumentArray: [false, userIdStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchDetailsForTypeOfData(type:String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let customerIdArr = valuee.value(forKey: "customerId")  as! NSArray
            let customerId = customerIdArr[0] as! Int
            
            let complexIdArr = valuee.value(forKey: "complexId")  as! NSArray
            let complexIdStr = complexIdArr[0] as! Int
            //   print("complexId----\(complexIdStr)")
            
            let userIdArr = valuee.value(forKey: "userId")  as! NSArray
            let userIdStr = userIdArr[0] as! Int
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "type == %@ AND customerId == %@ AND complexId == %@ AND userId == %@", argumentArray: [type, customerId, complexIdStr, userIdStr])
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        
        return dataArray
        
    }
    
    func fetchSyncAssCatDetails(type:String, syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentCategoriesDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type == %@ AND syncId == %@", argumentArray: [type, syncId])
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func deleteDraftForSyncId(_ syncId:String) {
        let fetchPredicate = NSPredicate(format: predicateSync, syncId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
        fetchUsers.predicate = fetchPredicate
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch {
            print(message)
        }
        
    }
    
    
    func fetchDraftForSyncId(type:String, syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    
    
    func fetchDetailsFor(entityName:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchDetailsForEntity(entityName:String, id:Int, keyStr:String) -> NSArray {
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "\(keyStr) == %@", argumentArray: [id])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    
    func saveComplexDetailsInDB(_ custId: NSNumber, userId: NSNumber, complexId: NSNumber, complexName: String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "Complex_PVE", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(complexName, forKey: "complexName")
        person.setValue(complexId, forKey: "complexId")
        person.setValue(custId, forKey: "customerId")
        person.setValue(userId, forKey: "userId")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        custData.append(person)
        
    }
    
    func saveEvaluationTypeInDB(_ evaluationId: NSNumber, evaluationName: String, isDeletd: Bool, moduleId:NSNumber) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_EvaluationType", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(evaluationId, forKey: "evaluationId")
        person.setValue(evaluationName, forKey: "evaluationName")
        person.setValue(isDeletd, forKey: "isDeletd")
        person.setValue(moduleId, forKey: "module_Id")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        breedOfBirdsData.append(person)
        
    }
    
    func saveEvaluationForInDB(_ id: NSNumber, name: String, isDeletd: Bool) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_EvaluationFor", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(name, forKey: "name")
        person.setValue(isDeletd, forKey: "isDeletd")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        breedOfBirdsData.append(person)
        
    }
    
    
    func saveAgeOfBirdsDetailsInDB(_ id: NSNumber, birdId: NSNumber, age: String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_AgeOfBirds", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(birdId, forKey: "bird_Id")
        person.setValue(age, forKey: "age")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        ageOfBirdsData.append(person)
        
    }
    
    func fetchDetailsForBreedOfBirds(evaluationForId:NSNumber, type:NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_BreedOfBirds")
        fetchRequest.returnsObjectsAsFaults = false
        
        if evaluationForId == 4{
            fetchRequest.predicate = NSPredicate(format: "evaluationId == %@", evaluationForId)
        }
        else if evaluationForId == 5{
            fetchRequest.predicate = NSPredicate(format: "evaluationId == %@ AND type == %@", argumentArray: [evaluationForId, type])
        }
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(message)
        }
        return dataArray
        
    }
    
    func saveBreedOfBirdsDetailsInDB(_ id: NSNumber, name: String, evaluationId: NSNumber, type: NSNumber) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_BreedOfBirds", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(name, forKey: "name")
        person.setValue(evaluationId, forKey: "evaluationId")
        person.setValue(type, forKey: "type")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        breedOfBirdsData.append(person)
        
    }
    
    
    func saveSiteIDNameDetailsInDB(_ id: NSNumber, siteId: NSNumber, siteName:String, complexId:NSNumber, customerId:NSNumber) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_SiteIDName", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(siteId, forKey: "site_Id")
        person.setValue(siteName, forKey: "site_Name")
        person.setValue(complexId, forKey: "complex_Id")
        person.setValue(customerId, forKey: "customer_Id")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        siteIDData.append(person)
        
    }
    
    func fetchSiteNameAsPercustomerId(_ customerId: NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SiteIDName")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customer_Id == %@", customerId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func saveEvaluatorDetailsInDB(_ id: NSNumber, firstName: String, lastName: String, fullName:String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_Evaluator", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(firstName, forKey: "firstName")
        person.setValue(lastName, forKey: "lastName")
        person.setValue(fullName, forKey: "fullName")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        evaluatorData.append(person)
        
    }
    
    func saveAssignUserDetailsInDB(_ id: NSNumber, firstName: String, lastName: String, fullName:String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_AssignUserDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "id")
        person.setValue(firstName, forKey: "firstName")
        person.setValue(lastName, forKey: "lastName")
        person.setValue(fullName, forKey: "fullName")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        assignUserData.append(person)
        
    }
    
    func saveHousingDetailsInDB(_ id: NSNumber, housingName: String) {
        
        

        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_Housing", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(id, forKey: "housingId")
        person.setValue(housingName, forKey: "housingName")
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        housingData.append(person)
        
    }
    
    
    func saveAssessmentCategoriesDetailsInDB(_ json:PVEAssessmentCategoriesDetailsRes) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_AssessmentCategoriesDetails", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(json.id, forKey: "id")
        person.setValue(json.evaluation_Type_Id, forKey: "evaluation_Type_Id")
        person.setValue(json.hatchery_Module_Id, forKey: "hatchery_Module_Id")
        person.setValue(json.max_Mark, forKey: "max_Mark")
        person.setValue(json.seq_Number, forKey: "seq_Number")
        person.setValue(json.category_Name, forKey: "category_Name")
        person.setValue(json.assessmentQuestion as NSObject, forKey: "assessmentQuestion")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        assessmentCat.append(person)
        
    }
    
    func saveAssessmentQuestionInDB(_ dict: [String  :Any], json:PVEAssessmentCategoriesDetailsRes) {
        
        

        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_AssessmentQuestion", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(dict["Id"] ?? 0, forKey: "id")
        person.setValue(dict["Assessment"] ?? "", forKey: "assessment")
        person.setValue(dict["Assessment2"] ?? "", forKey: "assessment2")
        person.setValue(dict["Min_Score"] ?? 0, forKey: "min_Score")
        person.setValue(dict["Mid_Score"] ?? 0, forKey: "mid_Score")
        person.setValue(dict["Max_Score"] ?? 0, forKey: "max_Score")
        person.setValue(dict["Types"] ?? "", forKey: "types")
        person.setValue(dict["PVE_Vacc_Type"] ?? "", forKey: "pVE_Vacc_Type")
        person.setValue(dict["Module_Cat_Id"] ?? 0, forKey: "module_Cat_Id")
        person.setValue(dict["Information"] ?? 0, forKey: "information")
        person.setValue("", forKey: "comment")
        person.setValue(dict["Image_Name"] ?? "", forKey: "image_Name")
        person.setValue(dict["Folder_Path"] ?? "", forKey: "folder_Path")
        person.setValue("", forKey: "enteredText")
        person.setValue(false, forKey: "isSelected")
        person.setValue(json.evaluation_Type_Id, forKey: "evaluation_Type_Id")
        person.setValue(json.hatchery_Module_Id, forKey: "hatchery_Module_Id")
        person.setValue(json.max_Mark, forKey: "max_Mark")
        person.setValue(json.seq_Number, forKey: "seq_Number")
        person.setValue(true, forKey: "inactiveVaccineSwitch")
        person.setValue(true, forKey: "liveVaccineSwitch")
        person.setValue("", forKey: "inactiveComment")
        person.setValue("", forKey: "liveComment")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        assessmentQ.append(person)
    }
    
    func fetchImgDetailsFromDB(_ seq_Number: NSNumber, syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_ImageEntitySync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND syncId == %@", seq_Number, syncId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        return dataArray
        
    }
    
    func deleteSyncImageDetails(_ syncId:String)   {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_ImageEntitySync")
        request.predicate = NSPredicate(format: "id = %@", syncId)
        
        do {
            let fetchResult = try managedContext.fetch(request)
            if fetchResult.count > 0 {
                for doubledData in fetchResult {
                    managedContext.delete(doubledData as! NSManagedObject)
                }
            }
        }
        catch {
            print(message)
        }
        
    }
    
    func fetchDraftAssQuestion(_ seq_Number: NSNumber, type:String, syncId:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND syncId == %@", seq_Number, syncId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchAssessmentQuestion(_ seq_Number: NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqStr, seq_Number)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func fetchDraftSumOfSelectedMarks(_ seqNo: NSNumber, type:String, syncId:String) -> String {
        var sumMarks = Int()
        var maxMarks = Int()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND isSelected == %@ AND type == %@ AND syncId == %@", argumentArray: [seqNo, true, type, syncId])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                var dataArray = results as NSArray
                
                let maxScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                for (_, obj) in maxScoreArr!.enumerated() {
                    sumMarks = sumMarks + obj
                }
                
                fetchRequest.predicate = NSPredicate(format: predicateSeqStr, argumentArray: [seqNo])
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    let maxMarksArr = dataArray.value(forKey: "max_Mark") as? [Int]
                    if maxMarksArr!.count > 0{
                        maxMarks = maxMarksArr![0]
                    }
                }
            }
        } catch {
            print(message)
        }
        
        return "\(sumMarks)/\(maxMarks)"
    }
    
    
    func fetchSumOfSelectedMarks(_ seqNo: NSNumber) -> String {
        
        var isSelected = true
        var sumMarks = Int()
        var maxMarks = Int()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqisSelectedStr, argumentArray: [seqNo, isSelected])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                var dataArray = results as NSArray
                
                let max_ScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                for (_, obj) in max_ScoreArr!.enumerated() {
                    sumMarks = sumMarks + obj
                }
                
                fetchRequest.predicate = NSPredicate(format: predicateSeqStr, argumentArray: [seqNo])
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    let max_MarksArr = dataArray.value(forKey: "max_Mark") as? [Int]
                    if max_MarksArr!.count > 0{
                        maxMarks = max_MarksArr![0]
                    }
                }
            }
        } catch {
            print(message)
        }
        
        return "\(sumMarks)/\(maxMarks)"
    }
    
    
    func fetchSumOfSelectedMarksModify(_ seqNo: NSNumber) -> (Int, Int) {
        
        var isSelected =  true
        var sumMarks = Int()
        var maxMarks = Int()
       
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqisSelectedStr, argumentArray: [seqNo, true])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                var  dataArray = results as NSArray
                
                let maxScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                for (_, obj) in maxScoreArr!.enumerated() {
                    sumMarks = sumMarks + obj
                }
                
                
                fetchRequest.predicate = NSPredicate(format: predicateSeqStr, argumentArray: [seqNo])
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    let maxMarksArr = dataArray.value(forKey: "max_Mark") as? [Int]
                    if maxMarksArr!.count > 0{
                        maxMarks = maxMarksArr![0]
                    }
                }
            }
        } catch {
            print(message)
        }
        
        return (sumMarks , maxMarks)
    }
    
    func fetchDraftSumOfSelectedMarksModify(_ seqNo: NSNumber, type:String, syncId:String) -> (Int, Int) {
        
        var isSelected =  true
        var sumMarks = Int()
        var maxMarks = Int()
       
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND isSelected == %@ AND type == %@ AND syncId == %@", argumentArray: [seqNo, isSelected, type, syncId])
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                var dataArray = results as NSArray
                
                let maxScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                for (_, obj) in maxScoreArr!.enumerated() {
                    sumMarks = sumMarks + obj
                }
                
                fetchRequest.predicate = NSPredicate(format: predicateSeqStr, argumentArray: [seqNo])
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    let maxMarksArr = dataArray.value(forKey: "max_Mark") as? [Int]
                    if maxMarksArr!.count > 0{
                        maxMarks = maxMarksArr![0]
                    }
                }
            }
        } catch {
            print(message)
        }
        
        return (sumMarks , maxMarks)
    }
    
    func fetchScoredArrForSyncId(_ syncId: String, seqNoArr: NSArray) -> (scoreArr:NSArray, max_MarksArr:NSArray){
        
        var scoreArr = [Int]()
        var max_MarksArr = [Int]()
        
        for (ind, seqNo) in seqNoArr.enumerated() {
            
            var isSelected =  true
            var dataArray = NSArray()
            var sumMarks = Int()
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND isSelected == %@ AND syncId == %@", argumentArray: [seqNo, isSelected, syncId])
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    
                    let max_ScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                    for (_, obj) in max_ScoreArr!.enumerated() {
                        sumMarks = sumMarks + obj
                    }
                    scoreArr.append(sumMarks)
                    
                    var arr = [Int]()
                    if ind == 4 { //----------- for Vaccine Evaluation
                    }else{
                        arr = dataArray.value(forKey: "max_Mark") as? [Int] ?? []
                        if arr.count > 0{
                            max_MarksArr.append(arr[0])
                        }
                    }
                }
            } catch {
            }
            
        }
        
        return (scoreArr: scoreArr as NSArray, max_MarksArr:max_MarksArr as NSArray)
    }
    
    func fetchScoredArr(_ seqNoArr: NSArray) -> (scoreArr:NSArray, max_MarksArr:NSArray){
        
        var scoreArr = [Int]()
        var max_MarksArr = [Int]()
        
        for (ind, seqNo) in seqNoArr.enumerated() {
            
            var dataArray = NSArray()
            var sumMarks = Int()
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: predicateSeqisSelectedStr, argumentArray: [seqNo, true])
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                    
                    let max_ScoreArr = dataArray.value(forKey: "max_Score") as? [Int]
                    for (_, obj) in max_ScoreArr!.enumerated() {
                        sumMarks = sumMarks + obj
                    }
                    scoreArr.append(sumMarks)
                    
                    var arr = [Int]()
                    if ind == 4 { //----------- for Vaccine Evaluation
                        //max_MarksArr.append(80)
                    }else{
                        arr = dataArray.value(forKey: "max_Mark") as? [Int] ?? []
                        if arr.count > 0 {
                            max_MarksArr.append(arr[0])
                        }
                    }
                }
            } catch {
            }
            
        }
        
        return (scoreArr: scoreArr as NSArray, max_MarksArr:max_MarksArr as NSArray)
    }
    
    func updateDraftAssDetails(_ seqNo: Int, id:Int, isSel:Bool, type:String, syncId:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqTypeSyncId, argumentArray: [seqNo, id, type, syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                results![0].setValue(isSel, forKey: "isSelected")
            }
        } catch {
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
    func updateAssementDetails(_ seqNo: Int, id:Int, isSel:Bool ) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNo, id])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(isSel, forKey: "isSelected")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        catch {
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
    func updateDraftAssFieldTextDetails(_ seqNo: Int, id:Int, text:String, type:String, syncId:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqTypeSyncId, argumentArray: [seqNo, id, type, syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(text, forKey: "enteredText")
            }
        } catch {
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
        do {
            try managedContext.save()
            // NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
    func updateAssementFieldTextDetails(_ seqNo: Int, id:Int, text:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNo, id])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(text, forKey: "enteredText")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
    func updateDraftCommentAssDetails(_ seqNo: Int, rowId:Int, commentStr:String, type:String, syncId:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqTypeSyncId, argumentArray: [seqNo, rowId, type, syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(commentStr, forKey: "comment")
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
        
    }
    
    func updateCommentAssementDetails(_ seqNo: Int, rowId:Int, commentStr:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNo, rowId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(commentStr, forKey: "comment")
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
        
    }
    
    
    func updateStatusSyncImageDataInAssementDetails(_ imgSyncId:String) {
        
        

        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_ImageEntitySync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "imgSyncId == %@", argumentArray: [imgSyncId])
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue("synced", forKey: "type")
            }
        } catch {
            print(message)
        }
        
        do {
            try managedContext.save()
        }
        catch {
            print(message)
        }
    }
    
    
    
    func updateSyncImageDataInAssementDetails(_ syncId:String, seqNo: Int, rowId:Int, imageData:Data) {
        
        var managedObject = [NSManagedObject]()
        
        

        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_ImageEntitySync", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(imageData, forKey: "imageData")
        person.setValue(rowId, forKey: "id")
        person.setValue(seqNo, forKey: "seq_Number")
        person.setValue(syncId, forKey: "syncId")
        person.setValue(syncId, forKey: "imgSyncId")
        person.setValue("", forKey: "type")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        managedObject.append(person)
    }
    
    
    //
    func updateImageDataInAssementDetails(_ seqNo: Int, rowId:Int, imageData:Data) {
        
        var managedObject = [NSManagedObject]()
        
        

        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_ImageEntity", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(imageData, forKey: "imageData")
        person.setValue(rowId, forKey: "id")
        person.setValue(seqNo, forKey: "seq_Number")
        
        let timeStampStr = sharedManager.generateCurrentTimeStamp()
        person.setValue(timeStampStr, forKey: "imgSyncId")
        person.setValue("", forKey: "type")
        
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        managedObject.append(person)
    }
    
    
    
    func getImageDataForCurrentAssementDetails(_ syncId:String, seqNumber: NSNumber, rowId:Int, entity:String) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        if syncId.count > 0 {
            fetchRequest.predicate = NSPredicate(format: "seq_Number == %@ AND id == %@ AND syncId == %@", argumentArray: [seqNumber, rowId, syncId])
        }else{
            fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNumber, rowId, syncId])
        }
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    
    
    ///// to unselect aLL Questions
    func updateQuestionstoDeselect() {
        
        

        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for (indx, _) in results!.enumerated() {
                    results![indx].setValue(false, forKey: "isSelected")
                    results![indx].setValue("", forKey: "comment")
                    results![indx].setValue("", forKey: "enteredText")
                    results![indx].setValue(true, forKey: "liveVaccineSwitch")
                    results![indx].setValue(true, forKey: "inactiveVaccineSwitch")
                    results![indx].setValue("", forKey: "inactiveComment")
                    results![indx].setValue("", forKey: "liveComment")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    func getSessionDetailsFromDB() -> NSArray {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Session")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let userIDArray = (results as NSArray).value(forKey: "userId")  as! NSArray
                return userIDArray
            }
        } catch {
            print(message)
        }
        return []
    }
    
    func saveUserInfoInDB(userId:Any) {
        let entity = NSEntityDescription.entity(forEntityName: "PVE_UserInfo", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(userId, forKey: "userId")
        person.setValue("", forKey: "customer")
        person.setValue(0, forKey: "customerId")
        person.setValue("", forKey: "siteName")
        person.setValue(0, forKey: "siteId")
        person.setValue(false, forKey: "session")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        assessmentCat.append(person)
        
    }
    
    func updateUserInfoSavedInDB(_ text: Any, forAttribute:String ) {
        
        let userId =  UserDefaults.standard.value(forKey: "Id") as? Int
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_UserInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateUserId, argumentArray: [userId!])
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue(text, forKey: forAttribute)
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
    }
    
    func fetchUserInfoSavedInDB(_ userId: NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_UserInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateUserId, userId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    
    // MARK: Update Switch State
    func updateLiveVaccineSavedInDB(id: Int, _ isSel:Bool , forAttribute:String , comment: String ,forComment:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                for (index , obj) in results!.enumerated() {
                    if results![index].value(forKey: "id") as! Int == id
                    {
                        results![index].setValue(isSel, forKey: forAttribute)
                        results![index].setValue(comment, forKey: forComment)
                    }
                }
                
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
        
    }
    
    // MARK: Update Switch State in Draft
    func updateLiveVaccineSavedInDraft(_ isSel:Bool, id: Int, type:String, syncId:String , forAttribute:String  , comment:String ,forComment:String ) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                results![0].setValue(type, forKey: "type")
                
                for (index , obj) in results!.enumerated() {
                    
                    if  id == results![index].value(forKey: "id") as! Int
                    {
                        results![index].setValue(isSel, forKey: forAttribute)
                        results![index].setValue(comment, forKey: forComment)
                    }
                }
                
                
            }
        } catch {
            print(message)
        }
        
        do {
            try managedContext.save()
            //   NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        catch {
            print(message)
        }
    }
    
    // MARK: Update Switch Comment
    func updateComment(_ comment: String, forAttribute:String, type: String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue(comment, forKey: forAttribute)
                results![0].setValue(type, forKey: "type")
            }
        } catch {
            print(message)
        }
        
        do {
            try managedContext.save()
        }
        catch {
            print(message)
        }
        
    }
    
    
    func fetchCurrentSessionInDB() -> NSArray {
        
        
        var dataArray = NSArray()
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Session")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: predicateStr, argumentArray: [currentUserId, customerStr, complexNameStr])
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        return dataArray
        
    }
    
    
    func saveSessionDetailsInDB() {
        
        CoreDataHandlerPVE().updateQuestionstoDeselect()
        let entity = NSEntityDescription.entity(forEntityName: "PVE_Session", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        person.setValue(currentUserId, forKey: "userId")
        
        
        person.setValue("", forKey: "customer")
        person.setValue(0, forKey: "customerId")
        person.setValue("", forKey: "complexName")
        person.setValue(0, forKey: "complexId")
        
        person.setValue("", forKey: "evaluationDate")
        person.setValue("", forKey: "evaluationFor")
        person.setValue("", forKey: "serveyNo")
        person.setValue(1, forKey: "sessionId")
        person.setValue("", forKey: "accountManager")
        
        var evaluatorNameStr = (UserDefaults.standard.string(forKey: "FirstName") ?? "") + " " + (UserDefaults.standard.string(forKey: "LastName") ?? "")
        
        let evalArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_Evaluator", id: currentUserId , keyStr: "id")
        if evalArr.count > 0 {
            person.setValue(evaluatorNameStr, forKey: "evaluator")
            person.setValue(currentUserId, forKey: "evaluatorId")
            print("EvaluatorIdExistInList")
        } else {
            person.setValue("", forKey: "evaluator")
            person.setValue(0, forKey: "evaluatorId")
            print("EvaluatorId Not ExistInList")
        }
        
        person.setValue("", forKey: "breedOfBirds")
        person.setValue(0, forKey: "ageOfBirds")
        person.setValue("", forKey: "housing")
        person.setValue("", forKey: "notes")
        
        person.setValue("", forKey: "farm")
        person.setValue("", forKey: "houseNumber")
        person.setValue(0, forKey: "noOfBirds")
        person.setValue("", forKey: "breedOfBirdsOther")
        person.setValue("", forKey: "breedOfBirdsFemaleOther")
        person.setValue("", forKey: "breedOfBirdsFemale")
        person.setValue(14, forKey: "selectedBirdTypeId")
        person.setValue("false", forKey: "cameraEnabled")
        person.setValue(0, forKey: "xSelectedCategoryIndex")
        
        //********************** Category Page Values ***********************
        
        person.setValue(false, forKey: "isFreeSerology")
        person.setValue("contract", forKey: "cat_selectedVaccineInfoType")
        
        person.setValue("", forKey: "cat_companyRepEmail")
        person.setValue("", forKey: "cat_companyRepMobile")
        person.setValue("", forKey: "cat_companyRepName")
        
        person.setValue("", forKey: "cat_crewLeaderName")
        person.setValue("", forKey: "cat_crewLeaderEmail")
        person.setValue("", forKey: "cat_crewLeaderMobile")
        
        let catchersDetailArr = [[String : String]]()
        person.setValue(catchersDetailArr, forKey: "cat_NoOfCatchersDetailsArr")
        
        let vaccinatorsDetailArr = [[String : String]]()
        person.setValue(vaccinatorsDetailArr, forKey: "cat_NoOfVaccinatorsDetailsArr")
        
        let vaccinInfoDetailArr = [[String : Any]]()
        person.setValue(vaccinInfoDetailArr, forKey: "cat_vaccinInfoDetailArr")
        
        //********************** Category Page Values ***********************
        
        
        // ************ Vac Eval *******************
        
        person.setValue(0, forKey: "injCenter_LeftWing_Field")
        person.setValue(0, forKey: "injWingBand_LeftWing_Field")
        person.setValue(0, forKey: "injMuscleHit_LeftWing_Field")
        person.setValue(0, forKey: "injMissed_LeftWing_Field")
        
        person.setValue(0, forKey: "injCenter_RightWing_Field")
        person.setValue(0, forKey: "injWingBand_RightWing_Field")
        person.setValue(0, forKey: "injMuscleHit_RightWing_Field")
        person.setValue(0, forKey: "injMissed_RightWing_Field")
        
        person.setValue(0, forKey: "injCenter_LeftWing_Percent")
        person.setValue(0, forKey: "injWingBand_LeftWing_Percent")
        person.setValue(0, forKey: "injMuscleHit_LeftWing_Percent")
        person.setValue(0, forKey: "injMissed_LeftWing_Percent")
        
        person.setValue(0, forKey: "injCenter_RightWing_Percent")
        person.setValue(0, forKey: "injWingBand_RightWing_Percent")
        person.setValue(0, forKey: "injMuscleHit_RightWing_Percent")
        person.setValue(0, forKey: "injMissed_RightWing_Percent")
        
        person.setValue(0, forKey: "centerTotalLbl")
        person.setValue(0, forKey: "wingBandTotalLbl")
        person.setValue(0, forKey: "muscleHitTotalLbl")
        person.setValue(0, forKey: "missedTotalLbl")
        person.setValue(0, forKey: "leftRightInjTotalLbl")
        
        person.setValue(0, forKey: "injCenter_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injWingBand_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injMuscleHit_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injMissed_LeftRight_PercentLbl")
        
        person.setValue(0, forKey: "subQLeftTotal")
        person.setValue(0, forKey: "subQRightTotal")
        person.setValue(0, forKey: "leftRightInjTotalLbl")
        
        
        person.setValue(0, forKey: "injMuscleHit_IntramusculerInj_Percent")
        person.setValue(0, forKey: "injMissed_IntramusculerInj_Percent")
        person.setValue(0, forKey: "injMuscleHit_SubcutaneousInj_Percent")
        person.setValue(0, forKey: "injMissed_SubcutaneousInj_Percent")
        
        person.setValue(0, forKey: "injMuscleHit_Total")
        person.setValue(0, forKey: "injMissed_Total")
        person.setValue(0, forKey: "injTotal_For_Inactivated")
        person.setValue(0, forKey: "injMuscleHit_Percent")
        person.setValue(0, forKey: "injMissed_Percent")
        
        person.setValue(0, forKey: "scoreCholeraVaccine")
        person.setValue(0, forKey: "scoreInactivatedVaccine")
        
        person.setValue(0, forKey: "injMuscleHit_IntramusculerInj_Field")
        person.setValue(0, forKey: "injMissed_IntramusculerInj_Field")
        person.setValue(0, forKey: "injMuscleHit_SubcutaneousInj_Field")
        person.setValue(0, forKey: "injMissed_SubcutaneousInj_Field")
        
        person.setValue(false, forKey: "vacEval_DyeAdded")
        person.setValue("", forKey: "vacEval_Comment")
        person.setValue(0, forKey: "intraInjLeftTotal")
        person.setValue(0, forKey: "subInjRightTotal")
        person.setValue(0, forKey: "injTotal_For_Inactivated")
        
        // *********** Vac Eval  ******************
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        sessionPVE.append(person)
        
    }
    
    func resetCurrentSessionDetailsInDB() {
        
        CoreDataHandlerPVE().updateQuestionstoDeselect()
        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_Session", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let currentUserId = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        person.setValue(currentUserId, forKey: "userId")
        
        // ---- Add Additional Fields Values In DB
        person.setValue("", forKey: "evaluationDate")
        person.setValue("", forKey: "evaluationFor")
        person.setValue("", forKey: "serveyNo")
        person.setValue(1, forKey: "sessionId")
        person.setValue("", forKey: "accountManager")
        
        let evaluatorNameStr = (UserDefaults.standard.string(forKey: "FirstName") ?? "") + " " + (UserDefaults.standard.string(forKey: "LastName") ?? "")
        let evalArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_Evaluator", id: currentUserId , keyStr: "id")
        if evalArr.count > 0 {
            person.setValue(evaluatorNameStr, forKey: "evaluator")
            person.setValue(currentUserId, forKey: "evaluatorId")
        } else {
            person.setValue("", forKey: "evaluator")
            person.setValue(0, forKey: "evaluatorId")
        }
        
        person.setValue("", forKey: "breedOfBirds")
        person.setValue(0, forKey: "breedOfBirdsId")
        person.setValue(0, forKey: "ageOfBirds")
        person.setValue("", forKey: "housing")
        person.setValue("", forKey: "notes")
        
        person.setValue("", forKey: "breedOfBirdsFemale")
        person.setValue(0, forKey: "breedOfBirdsFemaleId")
        
        person.setValue("", forKey: "farm")
        person.setValue("", forKey: "houseNumber")
        person.setValue(0, forKey: "noOfBirds")
        person.setValue("", forKey: "breedOfBirdsOther")
        person.setValue("", forKey: "breedOfBirdsFemaleOther")
        
        person.setValue(14, forKey: "selectedBirdTypeId")
        person.setValue("false", forKey: "cameraEnabled")
        person.setValue(0, forKey: "xSelectedCategoryIndex")
        
        
        //********************** Category Page Values ***********************
        
        person.setValue("contract", forKey: "cat_selectedVaccineInfoType")
        person.setValue(false, forKey: "isFreeSerology")
        
        person.setValue("", forKey: "cat_companyRepEmail")
        person.setValue("", forKey: "cat_companyRepMobile")
        person.setValue("", forKey: "cat_companyRepName")
        
        person.setValue("", forKey: "cat_crewLeaderName")
        person.setValue("", forKey: "cat_crewLeaderEmail")
        person.setValue("", forKey: "cat_crewLeaderMobile")
        
        let catchersDetailArr = [[String : String]]()
        person.setValue(catchersDetailArr, forKey: "cat_NoOfCatchersDetailsArr")
        
        let vaccinatorsDetailArr = [[String : String]]()
        person.setValue(vaccinatorsDetailArr, forKey: "cat_NoOfVaccinatorsDetailsArr")
        
        let vaccinInfoDetailArr = [[String : Any]]()
        person.setValue(vaccinInfoDetailArr, forKey: "cat_vaccinInfoDetailArr")
        
        //********************** Category Page Values ***********************
        
        
        // ************ Vac Eval *******************
        
        person.setValue(0, forKey: "injCenter_LeftWing_Field")
        person.setValue(0, forKey: "injWingBand_LeftWing_Field")
        person.setValue(0, forKey: "injMuscleHit_LeftWing_Field")
        person.setValue(0, forKey: "injMissed_LeftWing_Field")
        
        person.setValue(0, forKey: "injCenter_RightWing_Field")
        person.setValue(0, forKey: "injWingBand_RightWing_Field")
        person.setValue(0, forKey: "injMuscleHit_RightWing_Field")
        person.setValue(0, forKey: "injMissed_RightWing_Field")
        
        person.setValue(0, forKey: "injCenter_LeftWing_Percent")
        person.setValue(0, forKey: "injWingBand_LeftWing_Percent")
        person.setValue(0, forKey: "injMuscleHit_LeftWing_Percent")
        person.setValue(0, forKey: "injMissed_LeftWing_Percent")
        
        person.setValue(0, forKey: "injCenter_RightWing_Percent")
        person.setValue(0, forKey: "injWingBand_RightWing_Percent")
        person.setValue(0, forKey: "injMuscleHit_RightWing_Percent")
        person.setValue(0, forKey: "injMissed_RightWing_Percent")
        
        
        person.setValue(0, forKey: "centerTotalLbl")
        person.setValue(0, forKey: "wingBandTotalLbl")
        person.setValue(0, forKey: "muscleHitTotalLbl")
        person.setValue(0, forKey: "missedTotalLbl")
        person.setValue(0, forKey: "leftRightInjTotalLbl")
        
        person.setValue(0, forKey: "injCenter_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injWingBand_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injMuscleHit_LeftRight_PercentLbl")
        person.setValue(0, forKey: "injMissed_LeftRight_PercentLbl")
        
        person.setValue(0, forKey: "subQLeftTotal")
        person.setValue(0, forKey: "subQRightTotal")
        person.setValue(0, forKey: "leftRightInjTotalLbl")
        
        person.setValue(0, forKey: "injMuscleHit_IntramusculerInj_Percent")
        person.setValue(0, forKey: "injMissed_IntramusculerInj_Percent")
        person.setValue(0, forKey: "injMuscleHit_SubcutaneousInj_Percent")
        person.setValue(0, forKey: "injMissed_SubcutaneousInj_Percent")
        
        
        person.setValue(0, forKey: "injMuscleHit_Total")
        person.setValue(0, forKey: "injMissed_Total")
        person.setValue(0, forKey: "injTotal_For_Inactivated")
        person.setValue(0, forKey: "injMuscleHit_Percent")
        person.setValue(0, forKey: "injMissed_Percent")
        
        person.setValue(0, forKey: "scoreCholeraVaccine")
        person.setValue(0, forKey: "scoreInactivatedVaccine")
        
        person.setValue(0, forKey: "intraInjLeftTotal")
        person.setValue(0, forKey: "subInjRightTotal")
        
        person.setValue(0, forKey: "injMuscleHit_IntramusculerInj_Field")
        person.setValue(0, forKey: "injMissed_IntramusculerInj_Field")
        person.setValue(0, forKey: "injMuscleHit_SubcutaneousInj_Field")
        person.setValue(0, forKey: "injMissed_SubcutaneousInj_Field")
        
        
        person.setValue(false, forKey: "vacEval_DyeAdded")
        person.setValue("", forKey: "vacEval_Comment")
        person.setValue(0, forKey: "intraInjLeftTotal")
        person.setValue(0, forKey: "subInjRightTotal")
        person.setValue(0, forKey: "injTotal_For_Inactivated")
        
        // *********** Vac Eval  ******************
        
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            
            let customerIdArr = valuee.value(forKey: "customerId")  as! NSArray
            let customerId = customerIdArr[0] as! Int
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            
            let complexIdArr = valuee.value(forKey: "complexId")  as! NSArray
            let complexIdStr = complexIdArr[0] as! Int
            
            person.setValue(customerStr, forKey: "customer")
            person.setValue(customerId, forKey: "customerId")
            person.setValue(complexNameStr, forKey: "complexName")
            person.setValue(complexIdStr, forKey: "complexId")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        
        sessionPVE.append(person)
        
    }
    
    func updateSessionDetails(_ sessionId: Int, text: Any, forAttribute:String ) {
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            
            let customerIdArr = valuee.value(forKey: "customerId")  as! NSArray
            let customerIdStr = customerIdArr[0] as! Int
            
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            
            let complexIdArr = valuee.value(forKey: "complexId")  as! NSArray
            let complexIdStr = complexIdArr[0] as! Int
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Session")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: predicateUserId, argumentArray: [currentUserId])
            do {
                let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 { // Atleast one was returned
                    
                    if forAttribute != "" {
                        results![0].setValue(text, forKey: forAttribute)
                    }
                    results![0].setValue(customerStr, forKey: "customer")
                    results![0].setValue(customerIdStr, forKey: "customerId")
                    results![0].setValue(complexNameStr, forKey: "complexName")
                    results![0].setValue(complexIdStr, forKey: "complexId")
                    
                }
            } catch {
            }
            
            do {
                try managedContext.save()
            }
            catch {
            }
            
        }
        
    }
    
    
    func saveDratDetailsInDB(value: Any, forAttribute:String ) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_Draft", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(value, forKey: "dateCreated")
        
        let custSiteDetails = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if custSiteDetails.count > 0 {
            
            let customerArr = custSiteDetails.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            
            let customerIdArr = custSiteDetails.value(forKey: "customerId")  as! NSArray
            let customerIdStr = customerIdArr[0] as! Int
            
            let siteNameArr = custSiteDetails.value(forKey: "siteName")  as! NSArray
            let siteNameStr = siteNameArr[0] as! String
            
            let siteIdArr = custSiteDetails.value(forKey: "siteId")  as! NSArray
            let siteIdStr = siteIdArr[0] as! Int
            
            person.setValue(customerStr, forKey: "customer")
            person.setValue(customerIdStr, forKey: "customerId")
            person.setValue(siteNameStr, forKey: "siteName")
            person.setValue(siteIdStr, forKey: "siteId")
            
        }
        
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        assessmentCat.append(person)
    }
    
    
    
    func updateDraft(_ assessmentId: Int, text: Any, forAttribute:String ) {
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Draft")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionId == %@", argumentArray: [assessmentId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if forAttribute == "dateCreated" {
                results?[0].setValue(text, forKey: "dateCreated")
            } else {
                if let results = results {
                    let draftCountArr = (results as NSArray).value(forKey: "draftCount") as? [Int]
                    var currentCount = draftCountArr?[0]
                    currentCount = (currentCount ?? 0) + 1
                    results[0].setValue(currentCount, forKey: forAttribute)
                }
            }
            
        } catch {
            print(message)
        }
        
        do {
            try managedContext.save()
        }
        catch {
            print(message)
        }
        
    }
    
    
    func updateSyncAssCatDetailsFor(_ syncId: String, text: Any, forAttribute:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentCategoriesDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0,forAttribute != "" { // Atleast one was returned
                results![0].setValue(text, forKey: forAttribute)
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
    }
    
    func saveSyncAssCatDetails(type:String, syncId:String) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentCategoriesDetails")
        fetchRequest.returnsObjectsAsFaults = false
        
        ///// Save Value In Table
        
        do {
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj?.count != 0 { // Atleast one was returned
                let results = tempObj! as NSArray
                ////   print("results--\(results)")
                for (_, obj) in results.enumerated() {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "PVE_SyncAssessmentCategoriesDetails", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    let id = ((obj as AnyObject).value(forKey: "id") ?? 0)
                    let evaluation_Type_Id = ((obj as AnyObject).value(forKey: "evaluation_Type_Id") ?? 0)
                    let hatchery_Module_Id = ((obj as AnyObject).value(forKey: "hatchery_Module_Id") ?? 0)
                    let max_Mark = ((obj as AnyObject).value(forKey: "max_Mark") ?? 0)
                    let seq_Number = ((obj as AnyObject).value(forKey: "seq_Number") ?? 0)
                    let category_Name = ((obj as AnyObject).value(forKey: "category_Name") ?? "")
                    let assessmentQuestion = (obj as AnyObject).value(forKey: "assessmentQuestion")
                    
                    person.setValue(id, forKey: "id")
                    person.setValue(evaluation_Type_Id, forKey: "evaluation_Type_Id")
                    person.setValue(hatchery_Module_Id, forKey: "hatchery_Module_Id")
                    person.setValue(max_Mark, forKey: "max_Mark")
                    person.setValue(seq_Number, forKey: "seq_Number")
                    person.setValue(category_Name, forKey: "category_Name")
                    person.setValue(assessmentQuestion, forKey: "assessmentQuestion")
                    
                    person.setValue(type, forKey: "type")
                    person.setValue(syncId, forKey: "syncId")
                    
                    do {
                        try managedContext.save()
                    }
                    
                }
            }
        } catch {
            print(message)
        }
        
        
    }
    
    
    func updateSyncAssQuestionsFor(_ syncId: String, text: Any, forAttribute:String ) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj!.count > 0 { // Atleast one was returned
                let results = tempObj! as NSArray
                
                for (_, obj) in results.enumerated() {
                    (obj as AnyObject).setValue(text, forKey: forAttribute)
                }
            }
            
            do {
                try managedContext.save()
            }
            catch {
            }
        }
        catch {
            print(message)
        }
        
    }
    
    func saveSyncAssQuestions(type:String, syncId:String) {
        
        

        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj!.count > 0 { // Atleast one was returned
                let results = tempObj! as NSArray
                
                for (_, obj) in results.enumerated() {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "PVE_SyncAssessmentQuestion", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    let assessment = ((obj as AnyObject).value(forKey: "assessment") ?? "")
                    let assessment2 = ((obj as AnyObject).value(forKey: "assessment2") ?? "")
                    let comment = ((obj as AnyObject).value(forKey: "comment") ?? "")
                    let enteredText = ((obj as AnyObject).value(forKey: "enteredText") ?? "")
                    let evaluation_Type_Id = ((obj as AnyObject).value(forKey: "evaluation_Type_Id") ?? 0)
                    let folder_Path = ((obj as AnyObject).value(forKey: "folder_Path") ?? "")
                    let hatchery_Module_Id = ((obj as AnyObject).value(forKey: "hatchery_Module_Id") ?? 0)
                    let id = ((obj as AnyObject).value(forKey: "id") ?? 0)
                    let image_Name = ((obj as AnyObject).value(forKey: "image_Name") ?? "")
                    let information = ((obj as AnyObject).value(forKey: "information") ?? "")
                    let isSelected = ((obj as AnyObject).value(forKey: "isSelected") ?? 0)
                    let max_Mark = ((obj as AnyObject).value(forKey: "max_Mark") ?? 0)
                    let max_Score = ((obj as AnyObject).value(forKey: "max_Score") ?? 0)
                    let mid_Score = ((obj as AnyObject).value(forKey: "mid_Score") ?? 0)
                    let min_Score = ((obj as AnyObject).value(forKey: "min_Score") ?? 0)
                    let module_Cat_Id = ((obj as AnyObject).value(forKey: "module_Cat_Id") ?? 0)
                    let pVE_Vacc_Type = ((obj as AnyObject).value(forKey: "pVE_Vacc_Type") ?? "")
                    let seq_Number = ((obj as AnyObject).value(forKey: "seq_Number") ?? 0)
                    let types = ((obj as AnyObject).value(forKey: "types") ?? "")
                    
                    let inactiveVaccineSwitch = ((obj as AnyObject).value(forKey: "inactiveVaccineSwitch") ?? 0)
                    let liveVaccineSwitch = ((obj as AnyObject).value(forKey: "liveVaccineSwitch") ?? 0)
                    let inactiveComment = ((obj as AnyObject).value(forKey: "inactiveComment") ?? "")
                    let liveComment = ((obj as AnyObject).value(forKey: "liveComment") ?? "")
                    
                    person.setValue(inactiveVaccineSwitch, forKey: "inactiveVaccineSwitch")
                    person.setValue(liveVaccineSwitch, forKey: "liveVaccineSwitch")
                    person.setValue(inactiveComment, forKey: "inactiveComment")
                    person.setValue(liveComment, forKey: "liveComment")
                    
                    
                    
                    person.setValue(assessment, forKey: "assessment")
                    person.setValue(assessment2, forKey: "assessment2")
                    person.setValue(comment, forKey: "comment")
                    person.setValue(enteredText, forKey: "enteredText")
                    person.setValue(evaluation_Type_Id, forKey: "evaluation_Type_Id")
                    person.setValue(folder_Path, forKey: "folder_Path")
                    person.setValue(hatchery_Module_Id, forKey: "hatchery_Module_Id")
                    person.setValue(id, forKey: "id")
                    person.setValue(image_Name, forKey: "image_Name")
                    person.setValue(information, forKey: "information")
                    person.setValue(isSelected, forKey: "isSelected")
                    person.setValue(max_Mark, forKey: "max_Mark")
                    person.setValue(max_Score, forKey: "max_Score")
                    person.setValue(mid_Score, forKey: "mid_Score")
                    person.setValue(min_Score, forKey: "min_Score")
                    person.setValue(module_Cat_Id, forKey: "module_Cat_Id")
                    person.setValue(pVE_Vacc_Type, forKey: "pVE_Vacc_Type")
                    person.setValue(seq_Number, forKey: "seq_Number")
                    person.setValue(types, forKey: "types")
                    
                    person.setValue(type, forKey: "type")
                    person.setValue(syncId, forKey: "syncId")
                    
                    do {
                        try managedContext.save()
                    } catch {
                    }
                    
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    func getsessionForDraft(key:String) -> Any {
        return  sharedManager.getSessionValueForKeyFromDB(key: key)
    }
    
    func saveSyncImageDetailsInDB(syncId:String) {
        
        

        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        ///// Save Value In Table
        
        do {
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj?.count != 0 { // Atleast one was returned
                let results = tempObj! as NSArray
                ////   print("results--\(results)")
                for (_, obj) in results.enumerated() {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "PVE_ImageEntitySync", in: managedContext)
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    let id = (obj as AnyObject).value(forKey: "id")
                    let imageData = (obj as AnyObject).value(forKey: "imageData")
                    let seq_Number = (obj as AnyObject).value(forKey: "seq_Number")
                    let imgSyncId = (obj as AnyObject).value(forKey: "imgSyncId")
                    let type = (obj as AnyObject).value(forKey: "type")
                    
                    person.setValue(id, forKey: "id")
                    person.setValue(imageData, forKey: "imageData")
                    person.setValue(syncId, forKey: "syncId")
                    person.setValue(seq_Number, forKey: "seq_Number")
                    
                    person.setValue(imgSyncId, forKey: "imgSyncId")
                    person.setValue(type, forKey: "type")
                    
                    
                    do {
                        try managedContext.save()
                    }
                    
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    
    func saveSyncedImageDetailsInDBFromResponse(json:JSON) {
        
        let device_Id = json["Device_Id"].stringValue
        let device_IdArr = device_Id.components(separatedBy: "_")
        if device_IdArr[2] == "iOS"{
            
            let syncId = device_IdArr[0]
            let id = json["Assessment_Id"].intValue
            let imageDataBase64 = json["ImageBase64"].stringValue
            let seq_Number = 1
            
            let entity = NSEntityDescription.entity(forEntityName: "PVE_ImageEntitySync", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(syncId, forKey: "syncId")
            person.setValue(id, forKey: "id")
            person.setValue("", forKey: "imgSyncId")
            person.setValue("synced", forKey: "type")
            
            if imageDataBase64.count > 0 {
                let imageData = Data(base64Encoded: imageDataBase64, options: .ignoreUnknownCharacters)
                person.setValue(imageData, forKey: "imageData")
                
                let seqNumberArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_SyncAssessmentQuestion", id: id, keyStr: "id")
                if seqNumberArr.count > 0{
                    let seq_Number = (seqNumberArr.object(at: 0) as AnyObject).value(forKey: "seq_Number")
                    print("*seq_Number------\(seq_Number ?? 0)")
                    person.setValue(seq_Number, forKey: "seq_Number")
                }
            }
            do {
                try managedContext.save()
            } catch {
            }
            pveSync.append(person)
        }
    }
    
    fileprivate func dataPopulationMethod1(_ person: NSManagedObject, _ vaccineInfoDetailsViewModel: [JSON]) {
        person.setValue(vaccineInfoDetailsViewModel, forKey: "cat_vaccinInfoDetailArr")
        guard !vaccineInfoDetailsViewModel.isEmpty else { return }
        
        var vaccinatorInfoArr = [[String: Any]]()
        
        for currntSyncObj in vaccineInfoDetailsViewModel {
            let manufecturer = fetchEntityName(entity: "PVE_VaccineManDetails", id: currntSyncObj["Vaccine_Mfg_Id"].intValue, key: "name")
            let vaccine = fetchEntityName(entity: "PVE_VaccineNamesDetails", id: currntSyncObj["Vaccine_Id"].intValue, key: "name")
            //let serotype = fetchEntityName(entity: "PVE_SerotypeDetails", id: currntSyncObj["Serotype_Id"].intValue, key: "type")
            let siteInj = fetchEntityName(entity: "PVE_SiteInjctsDetails", id: currntSyncObj["Site_Injct_Id"].intValue, key: "name")
            let antigentype = fetchEntityInt(entity: "PVE_SerotypeDetails", id: currntSyncObj["Vaccine_Id"].intValue, key: "vaccine_Id") ?? 23
            
            let expDateString = formatExpirationDate(currntSyncObj["Exp_Date"].stringValue)
            let (tempVacName, tempVaccine_Id) = getVaccineDetails(currntSyncObj, vaccine: vaccine)
            let antigenDetails = getAntigenDetails(currntSyncObj["antigenDetailsViewModel"].arrayValue)
            
            vaccinatorInfoArr.append([
                "man_id": currntSyncObj["Vaccine_Mfg_Id"].intValue,
                "man": manufecturer,
                "name_id": tempVaccine_Id,
                "name": tempVacName,
                "serotype_id": antigenDetails.ids,
                "serotype": antigenDetails.names,
                "siteOfInj_id": currntSyncObj["Site_Injct_Id"].intValue,
                "siteOfInj": siteInj,
                "serial": currntSyncObj["Serial"].stringValue,
                "expDate": expDateString,
                "note": currntSyncObj["Note"].stringValue,
                "showMore": currntSyncObj["ShowMore"].stringValue,
                "vaccine_id": antigentype,
                "otherAntigen": antigenDetails.otherAntigens
            ])
        }
        person.setValue(vaccinatorInfoArr, forKey: "cat_vaccinInfoDetailArr")
    }

    private func fetchEntityName(entity: String, id: Int, key: String) -> String {
        let results = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: entity, id: id, keyStr: "id")
        return (results.firstObject as? NSManagedObject)?.value(forKey: key) as? String ?? ""
    }


    private func fetchEntityInt(entity: String, id: Int, key: String) -> Int? {
        let results = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: entity, id: id, keyStr: "vaccine_Id")
        return (results.firstObject as? NSManagedObject)?.value(forKey: key) as? Int
    }

    private func formatExpirationDate(_ expDate: String) -> String {
        guard expDate != "1900-12-12T00:00:00" else { return "" }
        let dateTempArr = expDate.components(separatedBy: "T")
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.yyyyMMddStr
        if let showDate = inputFormatter.date(from: dateTempArr[0]) {
            inputFormatter.dateFormat = Constants.MMddyyyyStr
            return inputFormatter.string(from: showDate)
        }
        return ""
    }
    
    private func getVaccineDetails(_ json: JSON, vaccine: String) -> (String, Int) {
        if json["Vaccine_Mfg_Id"].intValue == 17 {
            return (json["Vaccine_Other"].stringValue, 1000)
        }
        return (vaccine, json["Vaccine_Id"].intValue)
    }

    private func getAntigenDetails(_ antigenModel: [JSON]) -> (ids: [String], names: [String], otherAntigens: String) {
        var antigenIdArr = [String]()
        var antigenNameArr = [String]()
        var otherAntigenArr = [String]()
        
        for antigen in antigenModel {
            antigenIdArr.append("\(antigen["Antigen_Id"].intValue)")
            antigenNameArr.append(antigen["ProperAntigenName"].stringValue)
            otherAntigenArr.append(antigen["Antigen_Other"].stringValue)
        }
        return (antigenIdArr, antigenNameArr, otherAntigenArr.joined(separator: ""))
    }
    
    fileprivate func dataPopulationMethod2(_ json: JSON, _ syncId: String, _ saveType: String, _ selectedBirdTypeId: Int, _ inactivatedVaccinesViewModel: [JSON], _ choleraVaccinesViewModel: [JSON]) {
        let assessmentScoresViewModelArr = json["assessmentScoresViewModel"].arrayValue
        
        for (_, currntObj) in assessmentScoresViewModelArr.enumerated(){
            // "Assessment_Id": 104,
            // "Module_Assessment_Cat_Id": 11
            let score = currntObj["Score"].intValue
            let enteredTxt = currntObj["TextFieldValue"].stringValue
            self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: enteredTxt, forAttribute: "enteredText")
            
            if score == 0 {
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: false, forAttribute: "isSelected")
                
            }else{
                
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: true, forAttribute: "isSelected")
                
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: currntObj["InactivatedVaccineType"].boolValue as Any, forAttribute: "inactiveVaccineSwitch")
                
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text:  currntObj["LiveVaccineType"].boolValue as Any, forAttribute: "liveVaccineSwitch")
                
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: currntObj["LiveVaccineTypeComment"].stringValue, forAttribute: "liveComment")
                
                self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: currntObj["InactivatedVaccineTypeComment"].stringValue, forAttribute: "inactiveComment")
                
            }
        }
        
        
        
        let assessmentCommentsViewModelArr = json["assessmentCommentsViewModel"].arrayValue
        for (_, currntObj) in assessmentCommentsViewModelArr.enumerated(){
            let comment = currntObj["Comment"].stringValue
            self.updateSyncAssQuestionsFor(syncId, id: currntObj["Assessment_Id"].intValue, text: comment, forAttribute: "comment")
        }
        
        if saveType != "draft" {
            
            let assessmentArr = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId, type: saveType, syncId: syncId)
            let catArray = assessmentArr.value(forKey: "category_Name") as? NSArray ?? NSArray()
            let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
            var scoreArr = CoreDataHandlerPVE().fetchScoredArrForSyncId(syncId, seqNoArr: seq_NumberArr).scoreArr as! [Any]
            if scoreArr.count > 0 {
                scoreArr.removeLast()
            }
            let evalScore = inactivatedVaccinesViewModel[0]["Score"].doubleValue + choleraVaccinesViewModel[0]["Score"].doubleValue
            scoreArr.append(evalScore)
            
            var max_MarksArr = (CoreDataHandlerPVE().fetchScoredArrForSyncId(syncId, seqNoArr: seq_NumberArr).max_MarksArr as! [Int])
            max_MarksArr.append(30)
            
            CoreDataHandlerPVE().updateDraftSNAFor(syncId, syncedStatus: true, text: catArray, forAttribute: "categoryArray")
            CoreDataHandlerPVE().updateDraftSNAFor(syncId, syncedStatus: true, text: scoreArr as NSObject, forAttribute: "scoreArray")
            CoreDataHandlerPVE().updateDraftSNAFor(syncId, syncedStatus: true, text: max_MarksArr as NSObject, forAttribute: "maxScoreArray")
            
        }
    }
    
    fileprivate func dataPopulationMethod3(_ catchersViewModel: [JSON], _ person: NSManagedObject, _ vaccinatorsViewModel: [JSON]) {
        if catchersViewModel.count > 0 {
            var catchersArr = [[String : String]]()
            for (_, currntSyncObj) in catchersViewModel.enumerated() {
                let name = currntSyncObj["MemberName"].stringValue
                catchersArr.append(["name" : name ,"serology" : ""])
            }
            person.setValue(catchersArr, forKey: "cat_NoOfCatchersDetailsArr")
        }
        
        
        person.setValue(vaccinatorsViewModel, forKey: "cat_NoOfVaccinatorsDetailsArr")
        if vaccinatorsViewModel.count > 0 {
            var vaccinatorArr = [[String : String]]()
            for (_, currntSyncObj) in vaccinatorsViewModel.enumerated(){
                let name = currntSyncObj["MemberName"].stringValue
                let IsSerology = currntSyncObj["IsSerology"].boolValue
                //catchersArr.append(["name" : name])
                if IsSerology == true {
                    vaccinatorArr.append(["name" : name ,"serology" : "selected"])
                }else{
                    vaccinatorArr.append(["name" : name ,"serology" : ""])
                }
            }
            person.setValue(vaccinatorArr, forKey: "cat_NoOfVaccinatorsDetailsArr")
        }
    }
    
    func saveSyncDetailsInDBFromResponse(json:JSON) {
        
        let syncId = json["App_Assessment_Detail_Id"].stringValue
        
        let syncIdArr = syncId.components(separatedBy: "-")
        
        let saveType = json["Save_Type"].stringValue
        
        if syncIdArr.count == 1{
            
            let vaccineInformationCrewDetailsViewModel = json["vaccineInformationCrewDetailsViewModel"].dictionaryObject
            let choleraVaccinesViewModel = json["choleraVaccinesViewModel"].arrayValue
            let inactivatedVaccinesViewModel = json["inactivatedVaccinesViewModel"].arrayValue
            let evaluationNoteViewModel = json["evaluationNoteViewModel"].dictionaryObject
            let catchersViewModel = json["catchersViewModel"].arrayValue
            let vaccinatorsViewModel = json["vaccinatorsViewModel"].arrayValue
            let vaccineInfoDetailsViewModel = json["vaccineInfoDetailsViewModel"].arrayValue
            
            let entity = NSEntityDescription.entity(forEntityName: "PVE_Sync", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(true, forKey: "syncedStatus")
            person.setValue(syncId, forKey: "syncId")
            
            let UserId = json["UserId"].intValue
            
            person.setValue(UserId, forKey: "userId")
            person.setValue(json["Zoetis_Account_Manager_Name"].stringValue, forKey: "accountManager")
            person.setValue(json["Zoetis_Account_Manager_Id"].intValue, forKey: "accountManagerId")
            person.setValue(json["Age_of_Birds"].intValue, forKey: "ageOfBirds")
            person.setValue(json["Evaluation_For_Id"].intValue, forKey: "evaluationForId")
            person.setValue(json["Breed_Female_Name"].stringValue, forKey: "breedOfBirdsFemale")
            person.setValue(json["Breed_Female_Id"].intValue, forKey: "breedOfBirdsFemaleId")
            person.setValue(json["Breed_Female_Other"].stringValue, forKey: "breedOfBirdsFemaleOther")
            person.setValue(json["Breed_Id"].intValue, forKey: "breedOfBirdsId")
            person.setValue(json["Breed_of_Birds_Other"].stringValue, forKey: "breedOfBirdsOther")
            person.setValue(json["Breed_Name"].stringValue, forKey: "breedOfBirds")
            
            if json["Breed_Male_Name"].stringValue != ""{
                person.setValue(json["Breed_Male_Name"].stringValue, forKey: "breedOfBirds")
            }
            
            person.setValue(json["Device_Id"].stringValue, forKey: "deviceId")
            person.setValue(json["CreatedAt"].stringValue, forKey: "createdAt")
            person.setValue("true", forKey: "cameraEnabled")

            if json["Camera"].boolValue == false {
                person.setValue("false", forKey: "cameraEnabled")
            }
            
            person.setValue(vaccineInformationCrewDetailsViewModel?["CompFieldRepEmailId"], forKey: "cat_companyRepEmail")
            person.setValue(vaccineInformationCrewDetailsViewModel?["CompFieldRepPhone"], forKey: "cat_companyRepMobile")
            person.setValue(vaccineInformationCrewDetailsViewModel?["CompFieldRepName"], forKey: "cat_companyRepName")
            person.setValue(vaccineInformationCrewDetailsViewModel?["CrewEmailId"], forKey: "cat_crewLeaderEmail")
            person.setValue(vaccineInformationCrewDetailsViewModel?["CrewTelephoneNo"], forKey: "cat_crewLeaderMobile")
            person.setValue(vaccineInformationCrewDetailsViewModel?["CrewLeaderName"], forKey: "cat_crewLeaderName")
            person.setValue(vaccineInformationCrewDetailsViewModel?["VaccineInfoType"], forKey: "cat_selectedVaccineInfoType")
            person.setValue(vaccineInformationCrewDetailsViewModel?["IsSerology"], forKey: "isFreeSerology")
            person.setValue(catchersViewModel, forKey: "cat_NoOfCatchersDetailsArr")
            dataPopulationMethod3(catchersViewModel, person, vaccinatorsViewModel)
            dataPopulationMethod1(person, vaccineInfoDetailsViewModel)
            person.setValue(json["Evaluation_Date"].string ?? "", forKey: "evaluationDate")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            
            let objEvaluationDate = dateFormatter.date (from: json["Evaluation_Date"].string ?? "")
            person.setValue(objEvaluationDate, forKey: "objEvaluationDate")
            
            person.setValue(json["Evaluator_Name"].stringValue,  forKey: "evaluator")
            person.setValue(json["Evaluator_Id"].intValue, forKey: "evaluatorId")
            
            person.setValue(json["Evaluation_Name"].stringValue, forKey: "evaluationFor")
            
            person.setValue(json["Customer_Name"].stringValue, forKey: "customer")
            person.setValue(json["Customer_Id"].intValue, forKey: "customerId")
            
            person.setValue(json["Complex_Name"].stringValue, forKey: "complexName")
            person.setValue(json["Complex_Id"].intValue, forKey: "complexId")
            
            person.setValue(json["Farm_Name"].stringValue, forKey: "farm")
            person.setValue(json["House_No"].stringValue, forKey: "houseNumber")
            
            person.setValue(vaccineInformationCrewDetailsViewModel?["IsSerology"], forKey: "isFreeSerology")
            
            person.setValue(json["Housing_Name"].stringValue, forKey: "housing")
            person.setValue(json["Housing_Id"].intValue, forKey: "housingId")
            
            person.setValue(choleraVaccinesViewModel[0]["LeftWingInj"].intValue, forKey: "injCenter_LeftWing_Field")
            person.setValue(choleraVaccinesViewModel[0]["RightWingInj"].intValue, forKey: "injCenter_RightWing_Field")
            person.setValue(choleraVaccinesViewModel[1]["LeftWingInj"].intValue, forKey: "injWingBand_LeftWing_Field")
            person.setValue(choleraVaccinesViewModel[1]["RightWingInj"].intValue, forKey: "injWingBand_RightWing_Field")
            person.setValue(choleraVaccinesViewModel[2]["LeftWingInj"].intValue, forKey: "injMuscleHit_LeftWing_Field")
            person.setValue(choleraVaccinesViewModel[2]["RightWingInj"].intValue, forKey: "injMuscleHit_RightWing_Field")
            person.setValue(choleraVaccinesViewModel[3]["LeftWingInj"].intValue, forKey: "injMissed_LeftWing_Field")
            person.setValue(choleraVaccinesViewModel[3]["RightWingInj"].intValue, forKey: "injMissed_RightWing_Field")
            person.setValue(inactivatedVaccinesViewModel[0]["IntraInj"].intValue, forKey: "injMuscleHit_IntramusculerInj_Field")
            person.setValue(inactivatedVaccinesViewModel[0]["SubInj"].intValue, forKey: "injMuscleHit_SubcutaneousInj_Field")
            
            person.setValue(inactivatedVaccinesViewModel[1]["IntraInj"].intValue, forKey: "injMissed_IntramusculerInj_Field")
            person.setValue(inactivatedVaccinesViewModel[1]["SubInj"].intValue, forKey: "injMissed_SubcutaneousInj_Field")
            
            person.setValue(json["No_of_Birds"].intValue, forKey: "noOfBirds")
            person.setValue(json["Notes"].stringValue, forKey: "notes")
            
            person.setValue(13, forKey: "selectedBirdTypeId")
            var selectedBirdTypeId = 13
            if json["Type_of_Bird"].intValue == 1 {
                person.setValue(14, forKey: "selectedBirdTypeId")
                selectedBirdTypeId = 14
            }
            
            if json["evaluationNoteViewModel"].isEmpty{
                person.setValue( "", forKey: "vacEval_Comment")
                person.setValue( 0, forKey: "vacEval_DyeAdded")
            } else {
                if evaluationNoteViewModel != nil{
                    person.setValue(evaluationNoteViewModel!["Note"] ?? "", forKey: "vacEval_Comment")
                    person.setValue(evaluationNoteViewModel!["WasDyeAdded"] ?? 0, forKey: "vacEval_DyeAdded")
                }
            }
            
            person.setValue(saveType, forKey: "type")
            
            do {
                try managedContext.save()
            } catch {
            }
            pveSync.append(person)
            
            CoreDataHandlerPVE().deleteSyncAssCatDetails(syncId)
            CoreDataHandlerPVE().deleteSyncAssQuestions(syncId)
            CoreDataHandlerPVE().deleteSyncSwitch(syncId)
            CoreDataHandlerPVE().saveSyncAssCatDetails(type: saveType, syncId: syncId)
            CoreDataHandlerPVE().saveSyncAssQuestions(type: saveType, syncId: syncId)
            
            dataPopulationMethod2(json, syncId, saveType, selectedBirdTypeId, inactivatedVaccinesViewModel, choleraVaccinesViewModel)
        }
    }
    
    
    func updateSyncAssQuestionsFor(_ syncId: String, id:Int, text: Any, forAttribute:String ) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "syncId == %@ AND id == %@", argumentArray: [syncId, id])
        
        do {
            
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj!.count > 0 { // Atleast one was returned
                let results = tempObj! as NSArray
                for (_, obj) in results.enumerated() {
                    (obj as AnyObject).setValue(text, forKey: forAttribute)
                }
            }
            
            do {
                try managedContext.save()
            }
            catch {
                //   print("Saving Core Data Failed: \(error)")
            }
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
        
    }
    
    func deleteSyncAssCatDetails(_ syncId:String) {
        
        let fetchPredicate = NSPredicate(format: predicateSync, syncId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentCategoriesDetails")
        fetchUsers.predicate = fetchPredicate
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch {
            print(message)
        }
        
    }
    
    func deleteSyncAssQuestions(_ syncId:String) {
        
        let fetchPredicate = NSPredicate(format: predicateSync, syncId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SyncAssessmentQuestion")
        fetchUsers.predicate = fetchPredicate
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch {
            print(message)
        }
        
    }
    
    func deleteSyncSwitch(_ syncId:String) {
        
        let fetchPredicate = NSPredicate(format: predicateSync, syncId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "VaccineSwitchToggle_Sync")
        fetchUsers.predicate = fetchPredicate
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch {
            print(message)
        }
        
    }
    
    func saveSyncDetailsInDB(maxScoreArray:NSArray, scoreArray:NSArray, categoryArray:NSArray, syncId:String, dataTypeStr:String) {
        
        

        let entity = NSEntityDescription.entity(forEntityName: "PVE_Sync", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as! Int
        person.setValue(false, forKey: "syncedStatus")
        person.setValue(syncId, forKey: "syncId")
        person.setValue(currentUserId, forKey: "userId")
        person.setValue(maxScoreArray as NSObject, forKey: "maxScoreArray")
        person.setValue(scoreArray as NSObject, forKey: "scoreArray")
        person.setValue(categoryArray as NSObject, forKey: "categoryArray")
        
        person.setValue(getsessionForDraft(key: "accountManager"), forKey: "accountManager")
        person.setValue(getsessionForDraft(key: "accountManagerId"), forKey: "accountManagerId")
        person.setValue(getsessionForDraft(key: "ageOfBirds"), forKey: "ageOfBirds")
        person.setValue(getsessionForDraft(key: "breedOfBirds"), forKey: "breedOfBirds")
        person.setValue(getsessionForDraft(key: "breedOfBirdsFemale"), forKey: "breedOfBirdsFemale")
        person.setValue(getsessionForDraft(key: "breedOfBirdsFemaleId"), forKey: "breedOfBirdsFemaleId")
        person.setValue(getsessionForDraft(key: "breedOfBirdsFemaleOther"), forKey: "breedOfBirdsFemaleOther")
        person.setValue(getsessionForDraft(key: "breedOfBirdsId"), forKey: "breedOfBirdsId")
        person.setValue(getsessionForDraft(key: "breedOfBirdsOther"), forKey: "breedOfBirdsOther")
        person.setValue(getsessionForDraft(key: "cameraEnabled"), forKey: "cameraEnabled")
        person.setValue(getsessionForDraft(key: "cat_NoOfCatchersDetailsArr"), forKey: "cat_NoOfCatchersDetailsArr")
        person.setValue(getsessionForDraft(key: "cat_NoOfVaccinatorsDetailsArr"), forKey: "cat_NoOfVaccinatorsDetailsArr")
        person.setValue(getsessionForDraft(key: "cat_companyRepEmail"), forKey: "cat_companyRepEmail")
        person.setValue(getsessionForDraft(key: "cat_companyRepMobile"), forKey: "cat_companyRepMobile")
        person.setValue(getsessionForDraft(key: "cat_companyRepName"), forKey: "cat_companyRepName")
        person.setValue(getsessionForDraft(key: "cat_crewLeaderEmail"), forKey: "cat_crewLeaderEmail")
        person.setValue(getsessionForDraft(key: "cat_crewLeaderMobile"), forKey: "cat_crewLeaderMobile")
        person.setValue(getsessionForDraft(key: "cat_crewLeaderName"), forKey: "cat_crewLeaderName")
        person.setValue(getsessionForDraft(key: "cat_selectedVaccineInfoType"), forKey: "cat_selectedVaccineInfoType")
        person.setValue(getsessionForDraft(key: "cat_vaccinInfoDetailArr"), forKey: "cat_vaccinInfoDetailArr")
        person.setValue(getsessionForDraft(key: "cat_vaccinInfoDetailArr"), forKey: "cat_vaccinInfoDetailArr")
        person.setValue(getsessionForDraft(key: "complexName"), forKey: "complexName")
        person.setValue(getsessionForDraft(key: "complexId"), forKey: "complexId")
        person.setValue(getsessionForDraft(key: "customer"), forKey: "customer")
        person.setValue(getsessionForDraft(key: "customerId"), forKey: "customerId")
        person.setValue(getsessionForDraft(key: "evaluationDate"), forKey: "evaluationDate")
        person.setValue(getsessionForDraft(key: "evaluationFor"), forKey: "evaluationFor")
        person.setValue(getsessionForDraft(key: "evaluationForId"), forKey: "evaluationForId")
        person.setValue(getsessionForDraft(key: "evaluationForId"), forKey: "evaluationForId")
        person.setValue(getsessionForDraft(key: "evaluator"), forKey: "evaluator")
        person.setValue(getsessionForDraft(key: "evaluatorId"), forKey: "evaluatorId")
        person.setValue(getsessionForDraft(key: "farm"), forKey: "farm")
        person.setValue(getsessionForDraft(key: "houseNumber"), forKey: "houseNumber")
        person.setValue(getsessionForDraft(key: "isFreeSerology"), forKey: "isFreeSerology")
        
        person.setValue(getsessionForDraft(key: "housing"), forKey: "housing")
        person.setValue(getsessionForDraft(key: "housingId"), forKey: "housingId")
        person.setValue(getsessionForDraft(key: "injCenter_LeftWing_Field"), forKey: "injCenter_LeftWing_Field")
        person.setValue(getsessionForDraft(key: "injCenter_RightWing_Field"), forKey: "injCenter_RightWing_Field")
        person.setValue(getsessionForDraft(key: "injMissed_IntramusculerInj_Field"), forKey: "injMissed_IntramusculerInj_Field")
        person.setValue(getsessionForDraft(key: "injMissed_LeftWing_Field"), forKey: "injMissed_LeftWing_Field")
        person.setValue(getsessionForDraft(key: "injMissed_RightWing_Field"), forKey: "injMissed_RightWing_Field")
        person.setValue(getsessionForDraft(key: "injMissed_SubcutaneousInj_Field"), forKey: "injMissed_SubcutaneousInj_Field")
        person.setValue(getsessionForDraft(key: "injMuscleHit_IntramusculerInj_Field"), forKey: "injMuscleHit_IntramusculerInj_Field")
        person.setValue(getsessionForDraft(key: "injMuscleHit_LeftWing_Field"), forKey: "injMuscleHit_LeftWing_Field")
        person.setValue(getsessionForDraft(key: "injMuscleHit_RightWing_Field"), forKey: "injMuscleHit_RightWing_Field")
        person.setValue(getsessionForDraft(key: "injMuscleHit_SubcutaneousInj_Field"), forKey: "injMuscleHit_SubcutaneousInj_Field")
        person.setValue(getsessionForDraft(key: "injWingBand_LeftWing_Field"), forKey: "injWingBand_LeftWing_Field")
        person.setValue(getsessionForDraft(key: "injWingBand_RightWing_Field"), forKey: "injWingBand_RightWing_Field")
        
        //-----
        person.setValue(getsessionForDraft(key: "injCenter_LeftWing_Percent"), forKey: "injCenter_LeftWing_Percent")
        person.setValue(getsessionForDraft(key: "injWingBand_LeftWing_Percent"), forKey: "injWingBand_LeftWing_Percent")
        person.setValue(getsessionForDraft(key: "injMuscleHit_LeftWing_Percent"), forKey: "injMuscleHit_LeftWing_Percent")
        person.setValue(getsessionForDraft(key: "injMissed_LeftWing_Percent"), forKey: "injMissed_LeftWing_Percent")
        
        
        person.setValue(getsessionForDraft(key: "injCenter_RightWing_Percent"), forKey: "injCenter_RightWing_Percent")
        person.setValue(getsessionForDraft(key: "injWingBand_RightWing_Percent"), forKey: "injWingBand_RightWing_Percent")
        person.setValue(getsessionForDraft(key: "injMuscleHit_RightWing_Percent"), forKey: "injMuscleHit_RightWing_Percent")
        person.setValue(getsessionForDraft(key: "injMissed_RightWing_Percent"), forKey: "injMissed_RightWing_Percent")
        
        
        person.setValue(getsessionForDraft(key: "centerTotalLbl"), forKey: "centerTotalLbl")
        person.setValue(getsessionForDraft(key: "wingBandTotalLbl"), forKey: "wingBandTotalLbl")
        person.setValue(getsessionForDraft(key: "muscleHitTotalLbl"), forKey: "muscleHitTotalLbl")
        person.setValue(getsessionForDraft(key: "missedTotalLbl"), forKey: "missedTotalLbl")
        person.setValue(getsessionForDraft(key: "leftRightInjTotalLbl"), forKey: "leftRightInjTotalLbl")
        
        
        person.setValue(getsessionForDraft(key: "injCenter_LeftRight_PercentLbl"), forKey: "injCenter_LeftRight_PercentLbl")
        person.setValue(getsessionForDraft(key: "injWingBand_LeftRight_PercentLbl"), forKey: "injWingBand_LeftRight_PercentLbl")
        person.setValue(getsessionForDraft(key: "injMuscleHit_LeftRight_PercentLbl"), forKey: "injMuscleHit_LeftRight_PercentLbl")
        person.setValue(getsessionForDraft(key: "injMissed_LeftRight_PercentLbl"), forKey: "injMissed_LeftRight_PercentLbl")
        
        person.setValue(getsessionForDraft(key: "subQLeftTotal"), forKey: "subQLeftTotal")
        person.setValue(getsessionForDraft(key: "subQRightTotal"), forKey: "subQRightTotal")
        
        person.setValue(getsessionForDraft(key: "leftRightInjTotalLbl"), forKey: "leftRightInjTotalLbl")
        person.setValue(getsessionForDraft(key: "injMuscleHit_IntramusculerInj_Percent"), forKey: "injMuscleHit_IntramusculerInj_Percent")
        person.setValue(getsessionForDraft(key: "injMissed_IntramusculerInj_Percent"), forKey: "injMissed_IntramusculerInj_Percent")
        person.setValue(getsessionForDraft(key: "injMuscleHit_SubcutaneousInj_Percent"), forKey: "injMuscleHit_SubcutaneousInj_Percent")
        person.setValue(getsessionForDraft(key: "injMissed_SubcutaneousInj_Percent"), forKey: "injMissed_SubcutaneousInj_Percent")
        
        person.setValue(getsessionForDraft(key: "injMuscleHit_Total"), forKey: "injMuscleHit_Total")
        person.setValue(getsessionForDraft(key: "injMissed_Total"), forKey: "injMissed_Total")
        person.setValue(getsessionForDraft(key: "injTotal_For_Inactivated"), forKey: "injTotal_For_Inactivated")
        person.setValue(getsessionForDraft(key: "injMuscleHit_Percent"), forKey: "injMuscleHit_Percent")
        person.setValue(getsessionForDraft(key: "injMissed_Percent"), forKey: "injMissed_Percent")
        
        person.setValue(getsessionForDraft(key: "scoreCholeraVaccine"), forKey: "scoreCholeraVaccine")
        person.setValue(getsessionForDraft(key: "scoreInactivatedVaccine"), forKey: "scoreInactivatedVaccine")
        person.setValue(getsessionForDraft(key: "intraInjLeftTotal"), forKey: "intraInjLeftTotal")
        person.setValue(getsessionForDraft(key: "subInjRightTotal"), forKey: "subInjRightTotal")
        
        person.setValue(getsessionForDraft(key: "noOfBirds"), forKey: "noOfBirds")
        person.setValue(getsessionForDraft(key: "notes"), forKey: "notes")
        person.setValue(getsessionForDraft(key: "objEvaluationDate"), forKey: "objEvaluationDate")
        person.setValue(getsessionForDraft(key: "selectedBirdTypeId"), forKey: "selectedBirdTypeId")
        person.setValue(getsessionForDraft(key: "sessionId"), forKey: "sessionId")
        
        person.setValue(getsessionForDraft(key: "vacEval_Comment"), forKey: "vacEval_Comment")
        person.setValue(getsessionForDraft(key: "vacEval_DyeAdded"), forKey: "vacEval_DyeAdded")
        person.setValue(getsessionForDraft(key: "xSelectedCategoryIndex"), forKey: "xSelectedCategoryIndex")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat=Constants.MMddYYYYHHmmss
        let dateCreatedAt = dateFormatter.string(from: NSDate() as Date) as String
        person.setValue(dateCreatedAt, forKey: "createdAt")
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Sync")
        
        let deviceIdForServer = "\(syncId)_\(valuee.count)_iOS_\(udid)"
        
        person.setValue(deviceIdForServer, forKey: "deviceId")
        
        person.setValue(dataTypeStr, forKey: "type")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        pveSync.append(person)
    }
    
    fileprivate func extractedFunc(_ currentField: String, _ tempArr: inout [[String : Any]], _ dict: [String : Any], _ text: Any, _ id: Any) {
        if currentField == "otherAntigen"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : text,
                            "showMore" : dict["showMore"]!])
        }
        
        
        if currentField == "showMore"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : text])
        }
        
        if currentField == "vaccine_id"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : id,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
    }
    
    fileprivate func extractedFunc1(_ currentField: String, _ tempArr: inout [[String : Any]], _ dict: [String : Any], _ text: Any, _ id: Any) {
        if currentField == "expDate"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : text,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
        if currentField == "siteOfInj"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : text,
                            "siteOfInj_id" : id,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
        if currentField == "note"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : text,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
    }
    
    fileprivate func extractedFunc2(_ currentField: String, _ text: Any, _ tempArr: inout [[String : Any]], _ dict: [String : Any], _ id: Any) {
        if currentField == "serotype"{
            
            if text as? String == ""
            {
                tempArr.append(["man" : dict["man"]!,
                                "man_id" : dict["man_id"]!,
                                "name" : dict["name"]!,
                                "name_id" : dict["name_id"]!,
                                "serotype" : "",
                                "serotype_id" : 0,
                                "serial" : dict["serial"]!,
                                "expDate" : dict["expDate"]!,
                                "siteOfInj" : dict["siteOfInj"]!,
                                "siteOfInj_id" : dict["siteOfInj_id"]!,
                                "note" : dict["note"]!,
                                "vaccine_id" : dict["vaccine_id"]!,
                                "otherAntigen" : dict["otherAntigen"]!,
                                "showMore" : dict["showMore"]!])
            }
            else
            {
                tempArr.append(["man" : dict["man"]!,
                                "man_id" : dict["man_id"]!,
                                "name" : dict["name"]!,
                                "name_id" : dict["name_id"]!,
                                "serotype" : text,
                                "serotype_id" : id,
                                "serial" : dict["serial"]!,
                                "expDate" : dict["expDate"]!,
                                "siteOfInj" : dict["siteOfInj"]!,
                                "siteOfInj_id" : dict["siteOfInj_id"]!,
                                "note" : dict["note"]!,
                                "vaccine_id" : dict["vaccine_id"]!,
                                "otherAntigen" : dict["otherAntigen"]!,
                                "showMore" : dict["showMore"]!])
            }
            
        }
        if currentField == "serial"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : text,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
    }
    
    fileprivate func extractedFunc3(_ currentField: String, _ tempArr: inout [[String : Any]], _ text: Any, _ id: Any, _ dict: [String : Any]) {
        if currentField == "man"{
            tempArr.append(["man" : text,
                            "man_id" : id,
                            "name" : dict["name"]!,
                            "name_id" : dict["name_id"]!,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
        if currentField == "name"{
            tempArr.append(["man" : dict["man"]!,
                            "man_id" : dict["man_id"]!,
                            "name" : text,
                            "name_id" : id,
                            "serotype" : dict["serotype"]!,
                            "serotype_id" : dict["serotype_id"]!,
                            "serial" : dict["serial"]!,
                            "expDate" : dict["expDate"]!,
                            "siteOfInj" : dict["siteOfInj"]!,
                            "siteOfInj_id" : dict["siteOfInj_id"]!,
                            "note" : dict["note"]!,
                            "vaccine_id" : dict["vaccine_id"]!,
                            "otherAntigen" : dict["otherAntigen"]!,
                            "showMore" : dict["showMore"]!])
        }
    }
    
    fileprivate func extractedFunc4(_ fetchRequest: NSFetchRequest<any NSFetchRequestResult>, _ forAttribute: String, _ currentIndPath: NSIndexPath, _ currentField: String, _ text: Any, _ id: Any) {
        do {
            let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj!.count > 0 { // Atleast one was returned
                let dataArray = tempObj! as NSArray
                let catchersArr = (dataArray[0] as AnyObject).value(forKey: forAttribute) as? [[String: Any]]
                
                var tempArr = [[String : Any]]()
                
                for (indx, obj) in catchersArr!.enumerated() {
                    
                    let dict = obj as [String: Any]
                    if (indx == currentIndPath.row) {
                        extractedFunc3(currentField, &tempArr, text, id, dict)
                        extractedFunc2(currentField, text, &tempArr, dict, id)
                        extractedFunc1(currentField, &tempArr, dict, text, id)
                        extractedFunc(currentField, &tempArr, dict, text, id)
                        
                    }else{
                        tempArr.append(["man" : dict["man"]!,
                                        "man_id" : dict["man_id"]!,
                                        "name" : dict["name"]!,
                                        "name_id" : dict["name_id"]!,
                                        "serotype" : dict["serotype"]!,
                                        "serotype_id" : dict["serotype_id"]!,
                                        "serial" : dict["serial"]!,
                                        "expDate" : dict["expDate"]!,
                                        "siteOfInj" : dict["siteOfInj"]!,
                                        "siteOfInj_id" : dict["siteOfInj_id"]!,
                                        "note" : dict["note"]!,
                                        "otherAntigen" : dict["otherAntigen"]!,
                                        "vaccine_id" : dict["vaccine_id"]!,
                                        "showMore" : dict["showMore"]!])
                    }
                }
                
                tempObj![0].setValue(tempArr, forKey: forAttribute)
            }
            
            do {
                try managedContext.save()
            }
            catch {
                //   print("Saving Core Data Failed: \(error)")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    func updateVacInfoArrFor(_ syncId: String, currentField:String, currentIndPath: NSIndexPath, text: Any, id: Any, forAttribute:String, entityName:String) {
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            if syncId.count > 0 {
                fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
            } else {
                fetchRequest.predicate = NSPredicate(format: predicateStr, argumentArray: [currentUserId, customerStr, complexNameStr])
            }
            extractedFunc4(fetchRequest, forAttribute, currentIndPath, currentField, text, id)
        }
    }
    
    
    func updateSaroNameVacInfoArrFor(_ syncId: String, currentField:String, currentIndPath: NSIndexPath, text: Any, id: Any, forAttribute:String, entityName:String) {
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        
        if valuee.count > 0 {
            // let arrDraft = ssss.value(forKey: "session")  as! NSArray
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: predicateStr, argumentArray: [currentUserId, customerStr, complexNameStr])
            if syncId.count > 0 {
                fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
            }
            do {
                let tempObj = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if tempObj!.count > 0 { // Atleast one was returned
                    let dataArray = tempObj! as NSArray
                    let catchersArr = (dataArray[0] as AnyObject).value(forKey: forAttribute) as? [[String: Any]]
                    
                    ///This code was changed to fix the issues reported by sonarQube.
                    ///https://sonarcloud.io/project/issues?open=AZUTWckX0tSHff4msruI&id=nitinAgnihotri-MP_ZoetisNewTest
                    var tempArr = catchersArr?.enumerated().map { (indx, obj) -> [String: Any] in
                        var dict = obj as [String: Any]
                        dict["saroName"] = (indx == currentIndPath.row) ? text : dict["saroName"]
                        return dict
                    } ?? []
                    
                    tempObj![0].setValue(tempArr, forKey: forAttribute)
                }
                do {
                    try managedContext.save()
                } catch {
                    print("Saving Core Data Failed: \(error)")
                }
            } catch {
                print("Fetch Failed: \(error)")
            }
        }
    }
    
    
    
    func updateArrayForSerology(_ syncId: String, currentIndPath: NSIndexPath, text: Any, forAttribute:String, entityName:String) {
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            // let arrDraft = ssss.value(forKey: "session")  as! NSArray
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            let predicateStr1 = syncId.count > 0 ? predicateSync : predicateStr
            let predicateArr = syncId.count > 0 ? [syncId] : [currentUserId, customerStr, complexNameStr]
            fetchRequest.predicate = NSPredicate(format: predicateStr1, argumentArray: predicateArr)
            let tempObj = try? managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if tempObj!.count > 0 { // Atleast one was returned
                let dataArray = tempObj! as NSArray
                let catchersArr = (dataArray[0] as AnyObject).value(forKey: forAttribute) as? [[String: String]]
                ///This code was changed to fix the issues reported by sonarQube.
                ///https://sonarcloud.io/project/issues?open=AZUTWckX0tSHff4msruJ&id=nitinAgnihotri-MP_ZoetisNewTest
                let catchersDetailArr = catchersArr?.enumerated().map { (indx, obj) -> [String: Any] in
                    guard let dict = obj as? [String: Any] else { return [:] }
                    return [
                        "name": dict["name"] ?? "",
                        "serology": (indx == currentIndPath.row) ? text : dict["serology"] ?? ""
                    ]
                } ?? []
                
                tempObj![0].setValue(catchersDetailArr, forKey: forAttribute)
            }
            try? managedContext.save()
        }
    }
    
    func updateArrayInfoFor(_ syncId: String, currentIndPath: NSIndexPath? = nil, text: Any, forAttribute:String, entityName:String) {
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            // let arrDraft = ssss.value(forKey: "session")  as! NSArray
            let customerArr = valuee.value(forKey: "customer")  as! NSArray
            let customerStr = customerArr[0] as! String
            let complexNameArr = valuee.value(forKey: "complexName")  as! NSArray
            let complexNameStr = complexNameArr[0] as! String
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.returnsObjectsAsFaults = false
            
            let predicateStr1 = syncId.count > 0 ? predicateSync : predicateStr
            let predicateArr = syncId.count > 0 ? [syncId] : [currentUserId, customerStr, complexNameStr]
            fetchRequest.predicate = NSPredicate(format: predicateStr1, argumentArray: predicateArr)
                let tempObj = try? managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if tempObj!.count > 0 { // Atleast one was returned
                   
                    tempObj![0].setValue(text, forKey: forAttribute)
                }
                
                try? managedContext.save()
//            }
        }
    }
    
    
    func updateStatusForSync(_ syncId: String, text: Any, forAttribute:String ) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0,forAttribute != "" { // Atleast one was returned
                results![0].setValue(text, forKey: forAttribute)
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    
    
    func updateDraftSNAFor(_ syncId: String, syncedStatus:Bool, text: Any, forAttribute:String ) {
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSync, argumentArray: [syncId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 ,forAttribute != "" { // Atleast one was returned
                results![0].setValue(text, forKey: forAttribute)
                results![0].setValue(syncedStatus, forKey: "syncedStatus")
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            
        }
        
    }
    
    func updateDraftToSync(_ syncId: String, type: String, maxScoreArray:NSArray, scoreArray:NSArray, categoryArray:NSArray) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "syncId == %@ AND type == %@", argumentArray: [syncId, type])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue("sync", forKey: "type")
                
                results![0].setValue(syncId, forKey: "syncId")
                results![0].setValue(maxScoreArray as NSObject, forKey: "maxScoreArray")
                results![0].setValue(scoreArray as NSObject, forKey: "scoreArray")
                results![0].setValue(categoryArray as NSObject, forKey: "categoryArray")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
        }
        catch {
            print(message)
        }
        
    }
    
    func getDataToSyncInDB(type:String) -> NSArray {
        
        var dataArray = NSArray()
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            let customerIdArr = valuee.value(forKey: "customerId")  as! NSArray
            let customerId = customerIdArr[0] as! Int
            let complexIdArr = valuee.value(forKey: "complexId")  as! NSArray
            let complexId = complexIdArr[0] as! Int
            
            let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_Sync")
            fetchRequest.returnsObjectsAsFaults = false
            let sort = NSSortDescriptor(key: "objEvaluationDate", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.predicate = NSPredicate(format: "customerId == %d AND complexId == %d AND userId == %d AND type == %@", argumentArray: [customerId, complexId, currentUserId, type])
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    dataArray = results as NSArray
                } else {
                    
                }
            } catch {
            }
        }
        return dataArray
        
    }
    
    
    
    
    func saveCustomerComplexDetailsPoupInDB(_ customer: String, customerId:Int, complexName:String, complexId:Int) {
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup")
        if valuee.count > 0 {
            CoreDataHandler().deleteAllData("PVE_CustomerComplexPopup")
        }
        
        var siteDetailsArray = CoreDataHandlerPVE().fetchSiteNameAsComplexId( complexId as NSNumber)
        var siteIdArr = siteDetailsArray.value(forKey: "site_Id") as? NSArray ?? NSArray()
        var siteNameArr = siteDetailsArray.value(forKey: "site_Name") as? NSArray ?? NSArray()
        
        let userId =  UserDefaults.standard.value(forKey: "Id") as? Int
        
        let entity = NSEntityDescription.entity(forEntityName: "PVE_CustomerComplexPopup", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(customer, forKey: "customer")
        person.setValue(customerId, forKey: "customerId")
        person.setValue(complexName, forKey: "complexName")
        person.setValue(complexId, forKey: "complexId")
        person.setValue(userId, forKey: "userId")
        
        if siteIdArr.count > 0{
            person.setValue(siteIdArr[0], forKey: "siteId")
            person.setValue(siteNameArr[0], forKey: "siteName")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        assessmentCat.append(person)
        
    }
    
    
    func updateCustomerComplexDetailsPoupInDB(_ customer: String, customerId:Int, complexName:String, complexId:Int) {
        
        var siteDetailsArray = CoreDataHandlerPVE().fetchSiteNameAsComplexId( complexId as NSNumber)
        var siteIdArr = siteDetailsArray.value(forKey: "site_Id") as? NSArray ?? NSArray()
        var siteNameArr = siteDetailsArray.value(forKey: "site_Name") as? NSArray ?? NSArray()
        let entity = NSEntityDescription.entity(forEntityName: "PVE_CustomerComplexPopup", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(customer, forKey: "customer")
        person.setValue(customerId, forKey: "customerId")
        person.setValue(complexName, forKey: "complexName")
        person.setValue(complexId, forKey: "complexId")
        person.setValue(siteIdArr[0], forKey: "siteId")
        person.setValue(siteNameArr[0], forKey: "siteName")
        
        do {
            try managedContext.save()
        } catch {
            print(message)
        }
        assessmentCat.append(person)
        
    }
    
    func fetchSiteNameAsComplexId(_ complexId: NSNumber) -> NSArray {
        
        var dataArray = NSArray()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_SiteIDName")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "complex_Id == %@", complexId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(message)
        }
        
        return dataArray
        
    }
    
    func updateLiveVaccineDetails(_ seqNo: Int, id:Int, isSel:Bool) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNo, id])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(isSel, forKey: "isLiveVacine")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
    
    func updateInactiveDetails(_ seqNo: Int, id:Int, isSel:Bool) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PVE_AssessmentQuestion")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSeqId, argumentArray: [seqNo, id])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                // In my case, I only updated the first item in results
                results![0].setValue(isSel, forKey: "inActiveVaccine")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        }
        
    }
    
}


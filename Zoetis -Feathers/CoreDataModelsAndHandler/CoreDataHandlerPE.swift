//
//  CoreDataHandler.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 06/01/20.
//  Copyright © 2020 . All rights reserved.
//


import Foundation
import CoreData
import UIKit

class CoreDataHandlerPE: NSObject {
    
    let predicateId = "id = %d AND schAssmentId = %d "
    let schAssmentId = "schAssmentId == %d"
    let idStr = "id = %d"
    let serverAssessmentId = "serverAssessmentId == %@"
    let serverUserId = "userID == %d AND serverAssessmentId = %@"
    let userIdStr = "userID == %d"
    let draftNo = "draftNumber == %d"
    let userIdAsync = "userID == %d AND asyncStatus == 0"
    let catServerId = " catID == %@ AND userID == %d AND serverAssessmentId == %@"
    let assServerId = " assID == %@ AND userID == %d AND serverAssessmentId == %@"
    let imageId = "imageId == %d"
    let dateFormatMMDDYY = "MM/dd/YYYY HH:mm:ss"
    let dateFormatDDMMYY = "dd/MM/YYYY HH:mm:ss"
    let catIdStr = " catID == %@ "
    let catIdServerAssId = " catID == %@ AND serverAssessmentId == %@"
    let catIdServerAssId2 = " catID == %d AND serverAssessmentId == %@"
    let vmID = "vmid == %d"
    
    private var managedContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    private var customerData = [NSManagedObject]()
    override init() {
        super.init()
        self.setupContext()
    }
    func setupContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
    }
    
    func saveRefrigatorInDB(refrigeratorData: CoreDataHandlerPEModels.refrigeratorData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Refrigator", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        // Using the struct to set values
        person.setValue(refrigeratorData.id, forKey: "id")
        person.setValue(refrigeratorData.labelText, forKey: "labelText")
        person.setValue(refrigeratorData.rollOut, forKey: "rollOut")
        person.setValue(refrigeratorData.unit, forKey: "unit")
        person.setValue(refrigeratorData.value, forKey: "value")
        person.setValue(refrigeratorData.catID, forKey: "catID")
        person.setValue(refrigeratorData.isCheck, forKey: "isCheck")
        person.setValue(refrigeratorData.isNA, forKey: "isNA")
        person.setValue(refrigeratorData.schAssmentId, forKey: "schAssmentId")
        
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegate?.testFuntion() ?? "Error in saving")
        }
        
        customerData.append(person)
    }

    // save Refri for View
    func saveOfflineRefrigatorInDB(_ data: CoreDataHandlerPEModels.offlineRefrigatorData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PE_Refrigator_Offline", in: appDelegate!.managedObjectContext) else {
            return
        }
        
        let person = NSManagedObject(entity: entity, insertInto: appDelegate!.managedObjectContext)
        
        person.setValue(data.id, forKey: "id")
        person.setValue(data.labelText, forKey: "labelText")
        person.setValue(data.rollOut, forKey: "rollOut")
        person.setValue(data.unit, forKey: "unit")
        person.setValue(data.value, forKey: "value")
        person.setValue(data.catID, forKey: "catID")
        person.setValue(data.isCheck, forKey: "isCheck")
        person.setValue(data.isNA, forKey: "isNA")
        person.setValue(data.schAssmentId, forKey: "schAssmentId")
        
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegate!.testFuntion())
        }
        
        customerData.append(person)
    }

    
    //    Save Draft Refrigator Data
    func saveDraftRefrigatorInDB(_ data: CoreDataHandlerPEModels.RefrigatorDraftData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.managedObjectContext
        if let entity = NSEntityDescription.entity(forEntityName: "PE_Refrigator_InDraft", in: context) {
            let person = NSManagedObject(entity: entity, insertInto: context)
            person.setValue(data.id, forKey: "id")
            person.setValue(data.labelText, forKey: "labelText")
            person.setValue(data.rollOut, forKey: "rollOut")
            person.setValue(data.unit, forKey: "unit")
            person.setValue(data.value, forKey: "value")
            person.setValue(data.catID, forKey: "catID")
            person.setValue(data.isCheck, forKey: "isCheck")
            person.setValue(data.isNA, forKey: "isNA")
            person.setValue(data.schAssmentId, forKey: "schAssmentId")

            do {
                try context.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }

            customerData.append(person)
        }
    }

    //    Save Draft Refrigator Data
    
    func saveRejectRefrigatorInDB(data: CoreDataHandlerPEModels.rejectedRefrigatorData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Refrigator_Rejected", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(data.id, forKey: "id")
        person.setValue(data.labelText, forKey: "labelText")
        person.setValue(data.rollOut, forKey: "rollOut")
        person.setValue(data.unit, forKey: "unit")
        person.setValue(data.value, forKey: "value")
        person.setValue(data.catID, forKey: "catID")
        person.setValue(data.isCheck, forKey: "isCheck")
        person.setValue(data.isNA, forKey: "isNA")
        person.setValue(data.schAssmentId, forKey: "schAssmentId")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        customerData.append(person)
    }

    //    Update Draft Refrigator Data
    
    func updateDraftRefrigatorInDB(_ data: CoreDataHandlerPEModels.updateDraftRefrigeratorData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.predicate = NSPredicate(format: predicateId, data.id, data.serverAssessmentId)

        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            for re in results {
                re.setValue(data.labelText, forKey: "labelText")
                re.setValue(data.rollOut, forKey: "rollOut")
                re.setValue(data.unit, forKey: "unit")
                re.setValue(data.value, forKey: "value")
                re.setValue(data.catID, forKey: "catID")
                re.setValue(data.isCheck, forKey: "isCheck")
                re.setValue(data.isNA, forKey: "isNA")
            }
            try appDelegate.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    func updateOfflineRefrigatorInDB(_ data: CoreDataHandlerPEModels.updateOfflineRefrigeratorData) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_Offline")
        fetchRequest.predicate = NSPredicate(format: predicateId, data.id, data.serverAssessmentId)

        var results: [NSManagedObject] = []

        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                for re in results {
                    re.setValue(data.labelText, forKey: "labelText")
                    re.setValue(data.rollOut, forKey: "rollOut")
                    re.setValue(data.unit, forKey: "unit")
                    re.setValue(data.value, forKey: "value")
                    re.setValue(data.catID, forKey: "catID")
                    re.setValue(data.isCheck, forKey: "isCheck")
                    re.setValue(data.isNA, forKey: "isNA")
                    do {
                        try appDelegate.managedObjectContext.save()
                    } catch {
                        // handle save error
                    }
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    //    Update Refrigator Data
    func updateRefrigatorInDB(data: CoreDataHandlerPEModels.updateRefrigatorData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator")
        fetchRequest.predicate = NSPredicate(format: predicateId, data.id, data.serverAssessmentId)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if results.count > 0 {
                for re in results {
                    re.setValue(data.labelText, forKey: "labelText")
                    re.setValue(data.rollOut, forKey: "rollOut")
                    re.setValue(data.unit, forKey: "unit")
                    re.setValue(data.value, forKey: "value")
                    re.setValue(data.catID, forKey: "catID")
                    re.setValue(data.isCheck, forKey: "isCheck")
                    re.setValue(data.isNA, forKey: "isNA")
                    
                    do {
                        try appDelegate.managedObjectContext.save()
                    } catch {
                        // Handle save error
                        print("Failed to save context: \(error)")
                    }
                }
            }
        } catch {
            // Handle fetch error
            print("Error fetching data: \(error)")
        }
    }

    //    get Rejected Refrigator Data
    func getRejectREfriData(id:Int) -> [PE_Refrigators] {
        var peNewAssessmentArray : [PE_Refrigators] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator_Rejected")
        fetchRequest.predicate = NSPredicate(format: schAssmentId, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    
                    let refrigatorDetails = CoreDataHandlerPEModels.RefrigatorDetails(
                           id: result.value(forKey: "id") as! NSNumber,
                            labelText: result.value(forKey: "labelText") as! String,
                            rollOut: result.value(forKey: "rollOut") as! String,
                            unit: result.value(forKey: "unit") as! String,
                            value: result.value(forKey: "value") as! Double,
                            catID: result.value(forKey: "catID") as! NSNumber,
                            isCheck: result.value(forKey: "isCheck") as! Bool,
                            isNA: result.value(forKey: "isNA") as! Bool,
                            schAssmentId: result.value(forKey: "schAssmentId") as! Int
                    )
                    let datanew = PE_Refrigators(details: refrigatorDetails)
                    
                    
                    peNewAssessmentArray.append(datanew)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    // get Refri for View
    func getOfflineREfriData(id:Int) -> [PE_Refrigators] {
        var peNewAssessmentArray : [PE_Refrigators] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator_Offline")
        fetchRequest.predicate = NSPredicate(format: schAssmentId, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    
                    let refrigatorDetails = CoreDataHandlerPEModels.RefrigatorDetails(
                           id: result.value(forKey: "id") as! NSNumber,
                           labelText: result.value(forKey: "labelText") as! String,
                           rollOut: result.value(forKey: "rollOut") as! String,
                           unit: result.value(forKey: "unit") as! String,
                           value: result.value(forKey: "value") as! Double,
                           catID: result.value(forKey: "catID") as! NSNumber,
                           isCheck: result.value(forKey: "isCheck") as! Bool,
                           isNA: result.value(forKey: "isNA") as! Bool,
                           schAssmentId: result.value(forKey: "schAssmentId") as! Int
                    )
                    let refData = PE_Refrigators(details: refrigatorDetails)
                    peNewAssessmentArray.append(refData)
                    
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    //    get Draft Refrigator Data
    func getDraftREfriData(id:Int) -> [PE_Refrigators] {
        var peNewAssessmentArray : [PE_Refrigators] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.predicate = NSPredicate(format: schAssmentId, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            if let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in fetchedResult {
                    
                    let refrigatorDetails = CoreDataHandlerPEModels.RefrigatorDetails(
                          id: result.value(forKey: "id") as! NSNumber,
                          labelText: result.value(forKey: "labelText") as! String,
                          rollOut: result.value(forKey: "rollOut") as! String,
                          unit: result.value(forKey: "unit") as! String,
                          value: result.value(forKey: "value") as! Double,
                          catID: result.value(forKey: "catID") as! NSNumber,
                          isCheck: result.value(forKey: "isCheck") as! Bool,
                          isNA: result.value(forKey: "isNA") as! Bool,
                          schAssmentId: result.value(forKey: "schAssmentId") as! Int
                    )
                    let refData = PE_Refrigators(details: refrigatorDetails)
                    peNewAssessmentArray.append(refData)
                    
                    
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    // GetRefrigtorQuesArray
    
    func getREfriData(id:Int) -> [PE_Refrigators] {
        var peNewAssessmentArray : [PE_Refrigators] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator")
        fetchRequest.predicate = NSPredicate(format: schAssmentId, id )
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    
                    let refrigatorDetails = CoreDataHandlerPEModels.RefrigatorDetails(
                            id: result.value(forKey: "id") as! NSNumber,
                            labelText: result.value(forKey: "labelText") as! String,
                            rollOut: result.value(forKey: "rollOut") as! String,
                            unit: result.value(forKey: "unit") as! String,
                            value: result.value(forKey: "value") as! Double,
                            catID: result.value(forKey: "catID") as! NSNumber,
                            isCheck: result.value(forKey: "isCheck") as! Bool,
                            isNA: result.value(forKey: "isNA") as! Bool,
                            schAssmentId: result.value(forKey: "schAssmentId") as! Int
                    )
                    let refData = PE_Refrigators(details: refrigatorDetails)
                    
                    
                    peNewAssessmentArray.append(refData)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func someEntityExists(id: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator")
        fetchRequest.predicate = NSPredicate(format: idStr, id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func checkDraftSameAssesmentEntityExists(id: Int, serverAssessmentId: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.predicate = NSPredicate(format: predicateId, id,serverAssessmentId)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func checkSameAssesmentEntityExists(id: Int, serverAssessmentId: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator")
        fetchRequest.predicate = NSPredicate(format: predicateId, id,serverAssessmentId)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func checkOfflineSameAssesmentEntityExists(id: Int, serverAssessmentId: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_Offline")
        fetchRequest.predicate = NSPredicate(format: predicateId, id,serverAssessmentId)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    func someDraftRefriEntityExists(id: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.predicate = NSPredicate(format: idStr, id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    func someRejectedRefriEntityExists(id: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_Rejected")
        fetchRequest.predicate = NSPredicate(format: idStr, id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func saveComplexInDB(_ custId: NSNumber, userId: NSNumber, complexId: NSNumber, complexName: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Complex", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(complexName, forKey: "complexName")
        person.setValue(complexId, forKey: "complexId")
        person.setValue(custId, forKey: "customerId")
        person.setValue(userId, forKey: "userId")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveSitesInDB(_ id: NSNumber, siteId: NSNumber, complexId: NSNumber, customerId: NSNumber, siteName: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Sites", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(siteId, forKey: "siteId")
        person.setValue(complexId, forKey: "complexId")
        person.setValue(customerId, forKey: "customerId")
        person.setValue(siteName, forKey: "siteName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    
    func fetchCustomerWithCustId(_ custId: NSNumber) -> NSArray {
        var dataArray = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Complex_PVE")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId == %@", custId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    fileprivate func updateInGIInDB(_ fetchedResult: [PE_AssessmentInProgress], _ newAssessment: PENewAssessment, _ fromDoa: Bool?, _ fromDoaS: Bool?, _ fromInvo: Bool?, _ managedContext: NSManagedObjectContext) {
        for i in 0..<fetchedResult.count {
            let assessmentObj: PE_AssessmentInProgress = (fetchedResult[i])
            assessmentObj.serverAssessmentId = newAssessment.serverAssessmentId
            
            
            if fromDoa ?? false {
                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibioticsDoa ?? 0
                assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibioticsDoa")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
                
            }
            if fromDoaS ?? false {
                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibioticsDoaS ?? 0
                assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibioticsDoaS")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText
                                       , forKey: "hatcheryAntibioticsDoaSText")
                
            }
            if fromInvo ?? false {
                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
            }
            assessmentObj.setValue(newAssessment.personName, forKey: "personName")
            assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
            assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
            assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
            assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
            assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
            assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
            assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
            assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
            assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
            assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
            assessmentObj.setValue(newAssessment.micro, forKey: "micro")
            assessmentObj.setValue(newAssessment.residue, forKey: "residue")
            assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
            
            do {
                try managedContext.save()
                
            } catch {
                print(appDelegateObj.testFuntion())
            }
        }
    }
    
    func updateInDoGInProgressInDB(newAssessment:PENewAssessment,fromDoa:Bool? = false ,fromDoaS:Bool? = false,fromInvo:Bool? = false,fromDraft:Bool?=false) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, currentServerAssessmentId)
        if fromDraft ?? false {
            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResult = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if let fetchedResult = fetchResult, fetchedResult.count > 0 {
                updateInGIInDB(fetchedResult, newAssessment, fromDoa, fromDoaS, fromInvo, managedContext)
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateDraftInDoGInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResult = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if let fetchedResult = fetchResult,fetchedResult.count > 0 {
                for i in 0..<fetchedResult.count {
                    let assessmentObj: PE_AssessmentInProgress = (fetchedResult[i] )//as? PE_AssessmentInProgress)!
                    let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                    assessmentObj.serverAssessmentId = newAssessment.serverAssessmentId
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
                    assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
                    assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
                    assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
                    assessmentObj.setValue(newAssessment.micro, forKey: "micro")
                    assessmentObj.setValue(newAssessment.residue, forKey: "residue")
                    assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                    assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                    do {
                        try managedContext.save()
                    } catch {
                    }
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    fileprivate func updateSeesmentInDB(_ fetchedResult: [PE_AssessmentInProgress], _ newAssessment: PENewAssessment, _ managedContext: NSManagedObjectContext) {
        for i in 0..<fetchedResult.count {
            let assessmentObj: PE_AssessmentInProgress = (fetchedResult[i])// as? PE_AssessmentInProgress)!
            assessmentObj.serverAssessmentId = newAssessment.serverAssessmentId
            assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
            assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
            assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
            assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
            assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
            assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
            assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
            assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
            assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
            assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
            assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
            assessmentObj.setValue(newAssessment.username, forKey: "username")
            assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
            assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
            assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
            assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
            assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
            assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
            assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
            assessmentObj.setValue(newAssessment.approver, forKey: "approver")
            assessmentObj.setValue(newAssessment.notes, forKey: "notes")
            let camera = newAssessment.camera == 1 ? 1 : 0
            let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
            assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
            
            assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
            assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
            
            assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
            assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
            assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
            assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
            assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
            assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
            assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
            assessmentObj.setValue(newAssessment.FSTSignatureImage, forKey: "fsrSignatureImage")
            assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
            assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
            assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
            assessmentObj.setValue(newAssessment.sequenceNo, forKey: "sequenceNo")
            assessmentObj.setValue(newAssessment.sequenceNoo, forKey: "sequenceNoo")
            assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
            assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
            assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
            assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
            assessmentObj.setValue(newAssessment.note, forKey: "note")
            assessmentObj.setValue(newAssessment.images, forKey: "images")
            assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
            assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
            assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
            assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
            
            assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
            assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
            assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
            assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
            assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
            assessmentObj.setValue(newAssessment.micro, forKey: "micro")
            assessmentObj.setValue(newAssessment.residue, forKey: "residue")
            assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
            //PE International changes
            assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
            assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
            assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
            assessmentObj.setValue(NSNumber(value:newAssessment.countryID ?? 0), forKey: "countryID")
            assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
            assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
            assessmentObj.setValue(NSNumber(value:newAssessment.clorineId ?? 0), forKey: "clorineId")
            assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
            assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
            assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
            do {
                try managedContext.save()
            } catch {
            }
        }
    }
    
    func updateAssessmentInProgressInDB(newAssessment:PENewAssessment,serverAssessmentId:String,deleteFlag:Bool = false) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: serverUserId, userID,serverAssessmentId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchResult = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if let fetchedResult = fetchResult{
                if fetchedResult.count > 0 {
                    updateSeesmentInDB(fetchedResult, newAssessment, managedContext)
                } else {
                    saveNewAssessmentInProgressInDB(newAssessment:newAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateDraftAssessmentInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResult = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            guard let fetchedResult = fetchResult else {return}
            if fetchedResult.count > 0 {
                for i in 0..<fetchedResult.count {
                    let assessmentObj: PE_AssessmentInProgress = (fetchedResult[i])// as? PE_AssessmentInProgress)!
                    assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
                    assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
                    assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
                    assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
                    assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
                    assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
                    assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
                    assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
                    assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
                    assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
                    assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
                    assessmentObj.setValue(newAssessment.username, forKey: "username")
                    assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
                    assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
                    assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
                    assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
                    assessmentObj.setValue(newAssessment.approver, forKey: "approver")
                    assessmentObj.setValue(newAssessment.notes, forKey: "notes")
                    let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
                    assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
                    assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
                    assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
                    assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
                    assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
                    assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
                    assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
                    assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                    assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                    let camera = newAssessment.camera == 1 ? 1 : 0
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
                    assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
                    assessmentObj.setValue(newAssessment.sequenceNo, forKey: "sequenceNo")
                    assessmentObj.setValue(newAssessment.sequenceNoo, forKey: "sequenceNoo")
                    assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
                    assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
                    assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
                    assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
                    assessmentObj.setValue(newAssessment.note, forKey: "note")
                    assessmentObj.setValue(newAssessment.images, forKey: "images")
                    assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
                    assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
                    
                    // PE International chnages
                    assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
                    assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
                    assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
                    assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
                    assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
                    assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
                    assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
                    assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
                    
                    assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
                    assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
                    assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                    assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
                    assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                    do {
                        try managedContext.save()
                    } catch {
                    }
                }
            }  else {
                saveNewAssessmentInProgressInDB(newAssessment:newAssessment)
            }
            //            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func saveDraftAssessmentInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentIDraftInProgress", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
        assessmentObj.setValue(newAssessment.draftID, forKey: "draftID")
        assessmentObj.setValue(newAssessment.draftNumber, forKey: "draftNumber")
        assessmentObj.setValue(0, forKey: "asyncStatus")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
        
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.catID ?? 0), forKey: "catID")
        assessmentObj.setValue(NSNumber(value:newAssessment.cID ?? 0), forKey: "cID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catResultMark ?? 0), forKey: "catResultMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catISSelected ?? 0), forKey: "catISSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.assID ?? 0), forKey: "assID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMinScore ?? 0), forKey: "assMinScore")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMaxScore ?? 0), forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(NSNumber(value:newAssessment.assModuleCatID ?? 0), forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.assStatus ?? 0), forKey: "assStatus")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNo ?? 0), forKey: "sequenceNo")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNoo ?? 0), forKey: "sequenceNoo")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.images, forKey: "images")
        assessmentObj.setValue(newAssessment.doa, forKey: "doa")
        assessmentObj.setValue(newAssessment.inovoject, forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer, forKey: "vMixer")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
        assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
        assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
        assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
        assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
        assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
        assessmentObj.setValue(newAssessment.FSTSignatureImage, forKey: "fsrSignatureImage")
        assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        
        // PE International chnages
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.IsEMRequested, forKey: "isEMRequested")
        
        // March relese
        assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
        assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
        assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(assessmentObj)
    }
    
    
    func saveNewAssessmentInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInProgress", in: appDelegate!.managedObjectContext)
        
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(NSNumber(value:newAssessment.assStatus ?? 0), forKey: "assStatus")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.catID ?? 0), forKey: "catID")
        assessmentObj.setValue(NSNumber(value:newAssessment.cID ?? 0), forKey: "cID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catResultMark ?? 0), forKey: "catResultMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catISSelected ?? 0), forKey: "catISSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.assID ?? 0), forKey: "assID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMinScore ?? 0), forKey: "assMinScore")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMaxScore ?? 0), forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(NSNumber(value:newAssessment.assModuleCatID ?? 0), forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNo ?? 0), forKey: "sequenceNo")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNoo ?? 0), forKey: "sequenceNoo")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.images, forKey: "images")
        assessmentObj.setValue(newAssessment.doa, forKey: "doa")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.inovoject, forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer, forKey: "vMixer")
        assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
        assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
        assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
        assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
        assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
        assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
        assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
        assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.FSTSignatureImage, forKey: "fsrSignatureImage")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.rejectionComment, forKey: "rejectionComment")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        // chnages
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        assessmentObj.setValue(NSNumber(value:newAssessment.clorineId ?? 0), forKey: "clorineId")
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.IsEMRequested, forKey: "isEMRequested")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        
        assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
        assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
        assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(assessmentObj)
    }
    
    func getSavedOfflineAssessmentPEObject(id:Int) -> PENewAssessment {
        let peNewAssessment = PENewAssessment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitNumber == %d AND userID == %d", id,userID)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let dataArray = results as NSArray
                var userIDArray = dataArray.value(forKey: "userID")  as? NSArray ?? []
                
                peNewAssessment.userID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "serverAssessmentId")  as? NSArray ?? []
                peNewAssessment.serverAssessmentId = userIDArray.firstObject as? String
                userIDArray = dataArray.value(forKey: "complexId")  as? NSArray ?? []
                peNewAssessment.complexId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "draftNumber")  as? NSArray ?? []
                peNewAssessment.draftNumber = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "customerId")  as? NSArray ?? []
                peNewAssessment.customerId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteId")  as? NSArray ?? []
                peNewAssessment.siteId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteName")  as? NSArray ?? []
                peNewAssessment.siteName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "customerName")  as? NSArray ?? []
                peNewAssessment.customerName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "firstname")  as? NSArray ?? []
                peNewAssessment.firstname = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationDate")  as? NSArray ?? []
                peNewAssessment.evaluationDate = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorName")  as? NSArray ?? []
                peNewAssessment.evaluatorName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorID")  as? NSArray ?? []
                peNewAssessment.evaluatorID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "visitName")  as? NSArray ?? []
                peNewAssessment.visitName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "visitID")  as? NSArray ?? []
                peNewAssessment.visitID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "evaluationName")  as? NSArray ?? []
                peNewAssessment.evaluationName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationID")  as? NSArray ?? []
                peNewAssessment.evaluationID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "approver")  as? NSArray ?? []
                peNewAssessment.approver = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "notes")  as? NSArray ?? []
                peNewAssessment.notes = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "hatcheryAntibiotics")  as? NSArray ?? []
                let hatcheryAntibiotics =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                userIDArray = dataArray.value(forKey: "camera")  as? NSArray ?? []
                let camera =  userIDArray.firstObject as? Int
                camera == 1 ? 1 : 0
                peNewAssessment.camera = camera
                userIDArray = dataArray.value(forKey: "selectedTSR")  as? NSArray ?? []
                peNewAssessment.selectedTSR = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "selectedTSRID")  as? NSArray ?? []
                peNewAssessment.selectedTSRID = userIDArray.firstObject as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "sig")  as? NSArray ?? []
                peNewAssessment.sig = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig2")  as? NSArray ?? []
                peNewAssessment.sig2 = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig_EmpID")  as? NSArray ?? []
                peNewAssessment.sig_EmpID = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_EmpID2")  as? NSArray ?? []
                peNewAssessment.sig_EmpID2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name")  as? NSArray ?? []
                peNewAssessment.sig_Name = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name2")  as? NSArray ?? []
                peNewAssessment.sig_Name2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Date")  as? NSArray ?? []
                peNewAssessment.sig_Date = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Phone")  as? NSArray ?? []
                peNewAssessment.sig_Phone = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "isChlorineStrip") as? NSArray ?? []
                peNewAssessment.isChlorineStrip = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "isAutomaticFail") as? NSArray ?? []
                peNewAssessment.isAutomaticFail = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "isFlopSelected")  as? NSArray ?? []
                let isFlopSelected =  userIDArray.firstObject as? Int
                peNewAssessment.isFlopSelected = isFlopSelected
                userIDArray = dataArray.value(forKey: "breedOfBird")  as? NSArray ?? []
                peNewAssessment.breedOfBird = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "breedOfBirdOther")  as? NSArray ?? []
                peNewAssessment.breedOfBirdOther = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubation")  as? NSArray ?? []
                peNewAssessment.incubation = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubationOthers")  as? NSArray ?? []
                peNewAssessment.incubationOthers = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "note")  as? NSArray ?? []
                peNewAssessment.note = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "images")  as? NSArray ?? []
                peNewAssessment.images = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "doa")  as? NSArray ?? []
                peNewAssessment.doa = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "sequenceNo")  as? NSArray ?? []
                peNewAssessment.sequenceNo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sequenceNoo")  as? NSArray ?? []
                peNewAssessment.sequenceNoo = userIDArray.firstObject  as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "informationText")  as? NSArray ?? []
                peNewAssessment.informationText = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "informationImage")  as? NSArray ?? []
                peNewAssessment.informationImage = userIDArray.firstObject as? String ?? ""
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "countryID")  as? NSArray ?? []
                peNewAssessment.countryID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: Constants.countryNamStrSmall)  as? NSArray ?? []
                peNewAssessment.countryName = userIDArray.firstObject as? String ?? ""
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "clorineId")  as? NSArray ?? []
                peNewAssessment.clorineId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "clorineName")  as? NSArray ?? []
                peNewAssessment.clorineName = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "fluid")  as? NSArray ?? []
                peNewAssessment.fluid = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "basic")  as? NSArray ?? []
                peNewAssessment.basicTransfer = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "extndMicro")  as? NSArray ?? []
                peNewAssessment.extndMicro = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "refrigeratorNote")  as? NSArray ?? []
                peNewAssessment.refrigeratorNote = userIDArray.firstObject as? String ?? ""
                return peNewAssessment
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessment
    }
    
    
    func getSavedSavedAssessmentPEObject(dataToSubmitNumber:Int) -> PENewAssessment {
        let peNewAssessment = PENewAssessment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        //dataToSubmitNumber
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitNumber == %d", dataToSubmitNumber)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let dataArray = results as NSArray
                var userIDArray = dataArray.value(forKey: "userID")  as? NSArray ?? []
                peNewAssessment.userID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "serverAssessmentId")  as? NSArray ?? []
                peNewAssessment.serverAssessmentId = userIDArray.firstObject as? String
                userIDArray = dataArray.value(forKey: "complexId")  as? NSArray ?? []
                peNewAssessment.complexId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "customerId")  as? NSArray ?? []
                peNewAssessment.customerId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteId")  as? NSArray ?? []
                peNewAssessment.siteId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteName")  as? NSArray ?? []
                peNewAssessment.siteName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "customerName")  as? NSArray ?? []
                peNewAssessment.customerName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "firstname")  as? NSArray ?? []
                peNewAssessment.firstname = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationDate")  as? NSArray ?? []
                peNewAssessment.evaluationDate = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorName")  as? NSArray ?? []
                peNewAssessment.evaluatorName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorID")  as? NSArray ?? []
                peNewAssessment.evaluatorID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "visitName")  as? NSArray ?? []
                peNewAssessment.visitName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "visitID")  as? NSArray ?? []
                peNewAssessment.visitID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "evaluationName")  as? NSArray ?? []
                peNewAssessment.evaluationName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationID")  as? NSArray ?? []
                peNewAssessment.evaluationID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "approver")  as? NSArray ?? []
                peNewAssessment.approver = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "notes")  as? NSArray ?? []
                peNewAssessment.notes = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "hatcheryAntibiotics")  as? NSArray ?? []
                let hatcheryAntibiotics =  userIDArray.firstObject as? Int
                
                userIDArray = dataArray.value(forKey: "sig")  as? NSArray ?? []
                peNewAssessment.sig = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig2")  as? NSArray ?? []
                peNewAssessment.sig2 = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig_EmpID")  as? NSArray ?? []
                peNewAssessment.sig_EmpID = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_EmpID2")  as? NSArray ?? []
                peNewAssessment.sig_EmpID2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name")  as? NSArray ?? []
                peNewAssessment.sig_Name = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name2")  as? NSArray ?? []
                peNewAssessment.sig_Name2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Date")  as? NSArray ?? []
                peNewAssessment.sig_Date = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Phone")  as? NSArray ?? []
                peNewAssessment.sig_Phone = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "isChlorineStrip") as? NSArray ?? []
                peNewAssessment.isChlorineStrip = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "isAutomaticFail") as? NSArray ?? []
                peNewAssessment.isAutomaticFail = userIDArray.firstObject as? Int ?? 0
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                userIDArray = dataArray.value(forKey: "camera")  as? NSArray ?? []
                let camera =  userIDArray.firstObject as? Int
                camera == 1 ? 1 : 0
                peNewAssessment.camera = camera
                userIDArray = dataArray.value(forKey: "selectedTSR")  as? NSArray ?? []
                peNewAssessment.selectedTSR = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "selectedTSRID")  as? NSArray ?? []
                peNewAssessment.selectedTSRID = userIDArray.firstObject as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "isFlopSelected")  as? NSArray ?? []
                let isFlopSelected =  userIDArray.firstObject as? Int
                peNewAssessment.isFlopSelected = isFlopSelected
                userIDArray = dataArray.value(forKey: "breedOfBird")  as? NSArray ?? []
                peNewAssessment.breedOfBird = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "breedOfBirdOther")  as? NSArray ?? []
                peNewAssessment.breedOfBirdOther = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubation")  as? NSArray ?? []
                peNewAssessment.incubation = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubationOthers")  as? NSArray ?? []
                peNewAssessment.incubationOthers = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "note")  as? NSArray ?? []
                peNewAssessment.note = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "images")  as? NSArray ?? []
                peNewAssessment.images = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "doa")  as? NSArray ?? []
                peNewAssessment.doa = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "sequenceNo")  as? NSArray ?? []
                peNewAssessment.sequenceNo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sequenceNoo")  as? NSArray ?? []
                peNewAssessment.sequenceNoo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "informationText")  as? NSArray ?? []
                peNewAssessment.informationText = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "informationImage")  as? NSArray ?? []
                peNewAssessment.informationImage = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "micro")  as? NSArray ?? []
                peNewAssessment.micro = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "residue")  as? NSArray ?? []
                peNewAssessment.residue = userIDArray.firstObject as? String ?? ""
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "countryID")  as? NSArray ?? []
                peNewAssessment.countryID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: Constants.countryNamStrSmall)  as? NSArray ?? []
                peNewAssessment.countryName = userIDArray.firstObject as? String ?? ""
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "clorineId")  as? NSArray ?? []
                peNewAssessment.clorineId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "clorineName")  as? NSArray ?? []
                peNewAssessment.clorineName = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "fluid")  as? NSArray ?? []
                peNewAssessment.fluid = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "basic")  as? NSArray ?? []
                peNewAssessment.basicTransfer = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "extndMicro")  as? NSArray ?? []
                peNewAssessment.extndMicro = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "refrigeratorNote")  as? NSArray ?? []
                peNewAssessment.refrigeratorNote = userIDArray.firstObject as? String ?? ""
                return peNewAssessment
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessment
    }
    
    
    func getOfflineAssessmentArrayPEObject(ofCurrentDate:Bool?=false) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let onGoingPeNewAssessment = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        
        if ofCurrentDate ?? false {
            fetchRequest.predicate = NSPredicate(format: "customerId == %d AND siteId == %d AND userID == %d AND evaluationDate == %@", onGoingPeNewAssessment.customerId ?? 0,onGoingPeNewAssessment.siteId ?? 0,userID,onGoingPeNewAssessment.evaluationDate ?? "")
        } else {
            fetchRequest.predicate = NSPredicate(format: userIdStr, userID)
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    
                    peNewAssessment.serverAssessmentId = result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    
                    
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.fluid = result.value(forKey: "hatcheryAntibioticsDoa")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    
    func getDraftOnGoingAssessmentArrayPEObject() -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.statusType = result.value(forKey: "statusType")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.fluid = result.value(forKey: "hatcheryAntibioticsDoa")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func getOfflineAssessmentArray(id:String) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitID == %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId = result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID = result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId = result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.dataToSubmitNumber = result.value(forKey: "dataToSubmitNumber") as? Int ?? 0
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.FSTSignatureImage = result.value(forKey: "fsrSignatureImage") as? String ?? ""
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    
                    
                    
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue
                    = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")   as? Bool ?? false
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    
                    // PE International changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.fluid = result.value(forKey: "hatcheryAntibioticsDoa")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    
    func getDraftAssessmentArray(id:Int) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.predicate = NSPredicate(format: draftNo, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.draftNumber =  result.value(forKey: "draftNumber")  as? Int ?? 0
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    
                    peNewAssessment.draftID =  result.value(forKey: "draftID") as? String ?? ""
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.FSTSignatureImage = result.value(forKey: "fsrSignatureImage") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    // PE International changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.fluid = result.value(forKey: "hatcheryAntibioticsDoa")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    
    fileprivate func extractedFunc2(_ ofCurrentAssessment: Bool?, _ fetchRequest: NSFetchRequest<any NSFetchRequestResult>, _ userID: Int, _ ofCurrentDate: Bool?) -> NSFetchRequest<NSFetchRequestResult> {
        if ofCurrentAssessment ?? false {
            let onGoingPeNewAssessment = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
            fetchRequest.predicate = NSPredicate(format: userIdStr,userID)
            
            if ofCurrentDate ?? false {
                fetchRequest.predicate = NSPredicate(format: "userID == %d AND evaluationDate == %@", userID,onGoingPeNewAssessment.evaluationDate ?? "")
            }
        }
        
        return fetchRequest
    }
    
    func getDraftAssessmentArrayPEObject(ofCurrentAssessment:Bool?=false,ofCurrentDate:Bool?=false) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: userIdStr, userID)
        if ofCurrentDate ?? false {
            let onGoingPeNewAssessment = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
            fetchRequest.predicate = NSPredicate(format: " userID == %d AND evaluationDate == %@", userID,onGoingPeNewAssessment.evaluationDate ?? "")
        }
        
        fetchRequest = extractedFunc2(ofCurrentAssessment, fetchRequest, userID, ofCurrentDate)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        if let results = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
            for result in results {
                let peNewAssessment = PENewAssessment()
                peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics == 1 ? 1 : 0
                
                let camera =  result.value(forKey: "camera")  as? Int
                peNewAssessment.camera = camera == 1 ? 1 : 0
                
                let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                peNewAssessment.isFlopSelected = isFlopSelected == 1 ? 1 : 0
                
                peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                peNewAssessment.rejectionComment = result.value(forKey: "rejectionComment") as? String ?? ""
                peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                peNewAssessment.draftID = result.value(forKey: "draftID") as? String ?? ""
                
                // PE International Changes
                peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                
                // PE International Changes
                peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                
                peNewAssessment.isHandMix = result.value(forKey: "isHandMix") as? Bool ?? false
                peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                
                peNewAssessment.fluid = result.value(forKey: "hatcheryAntibioticsDoa")  as? Bool ?? false
                peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                
                peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected") as? Bool ?? false
                peNewAssessment.isPERejected = result.value(forKey: "isPERejected") as? Bool ?? false
                peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue") as? Bool ?? false
                
                peNewAssessmentArray.append(peNewAssessment)
            }
        }
        return peNewAssessmentArray
    }
    
    
    func getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:Bool?=false, serverAssessmentId:String = "") -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        if ofCurrentAssessment ?? false {
            fetchRequest.predicate = NSPredicate(format: "userID == %d ", userID)
            
            if serverAssessmentId != ""{
                fetchRequest.predicate = NSPredicate(format: serverUserId, userID,serverAssessmentId)
            }
            
        } else {
            fetchRequest.predicate = NSPredicate(format: userIdAsync, userID)
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.dataToSubmitNumber = result.value(forKey: "dataToSubmitNumber")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs") as? Int64 ?? 0
                    peNewAssessment.manufacturer = result.value(forKey: "manufacturer") as? String ?? ""
                    peNewAssessment.iCS = result.value(forKey: "iCS") as? String ?? ""
                    peNewAssessment.iDT = result.value(forKey: "iDT") as? String ?? ""
                    peNewAssessment.dCS = result.value(forKey: "dCS") as? String ?? ""
                    peNewAssessment.dDT = result.value(forKey: "dDT") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue
                    = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.dataToSubmitID
                    = result.value(forKey: "dataToSubmitID") as? String ?? ""
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR") as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue") as? String ?? ""
                    peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue")  as? Bool ?? false
                    
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    
                    peNewAssessment.frequency
                    = result.value(forKey: "frequency") as? String ?? ""
                    
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested") as? Bool ?? false
                    
                    // New Addition for march release
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected") as? Bool ?? false
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected") as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment") as? String ?? ""
                    
                    
                    peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func getSessionAssessmentArrayPEObject(ofCurrentAssessment:Bool?=false) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        if ofCurrentAssessment ?? false {
            fetchRequest.predicate = NSPredicate(format: " userID == %d AND asyncStatus == 0", userID)
        } else {
            fetchRequest.predicate = NSPredicate(format: userIdAsync, userID)
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR") as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.dataToSubmitID = result.value(forKey: "dataToSubmitID")   as? String ?? ""
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.dataToSubmitNumber = result.value(forKey: "dataToSubmitNumber")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs") as? Int64 ?? 0
                    peNewAssessment.manufacturer = result.value(forKey: "manufacturer") as? String ?? ""
                    peNewAssessment.iCS = result.value(forKey: "iCS") as? String ?? ""
                    peNewAssessment.iDT = result.value(forKey: "iDT") as? String ?? ""
                    peNewAssessment.dCS = result.value(forKey: "dCS") as? String ?? ""
                    peNewAssessment.dDT = result.value(forKey: "dDT") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue
                    = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")   as? Bool ?? false
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int
                    
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested") as? Bool ?? false
                    
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    
                    
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected")  as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected")  as? Bool ?? false
                    peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue")  as? Bool ?? false
                    
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func getSessionAssessmentArrayPEObjectDraft(ofCurrentAssessment:Bool?=false) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        if ofCurrentAssessment ?? false {
            fetchRequest.predicate = NSPredicate(format: " userID == %d AND asyncStatus == 0", userID)
            
        } else {
            fetchRequest.predicate = NSPredicate(format: userIdAsync, userID)
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR")  as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                    peNewAssessment.draftID = result.value(forKey: "draftID")   as? String ?? ""
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs") as? Int64 ?? 0
                    peNewAssessment.manufacturer = result.value(forKey: "manufacturer") as? String ?? ""
                    peNewAssessment.iCS = result.value(forKey: "iCS") as? String ?? ""
                    peNewAssessment.iDT = result.value(forKey: "iDT") as? String ?? ""
                    peNewAssessment.dCS = result.value(forKey: "dCS") as? String ?? ""
                    peNewAssessment.dDT = result.value(forKey: "dDT") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    
                    // PE Internation Update's
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int
                    
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested") as? Bool ?? false
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected")  as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected")  as? Bool ?? false
                    peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue")  as? Bool ?? false
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func deleteDraftByDrafyNumber(_ draftId: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.returnsObjectsAsFaults = false
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "draftID == %@ AND userID == %d", draftId,userID)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedContext.delete(item)// as! NSManagedObject)
            }
            // Save Changes
            try managedContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
    }
    
    func deleteRefriDataBySchAssNumber(_ id: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: schAssmentId,id)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedContext.delete(item)// as! NSManagedObject)
            }
            // Save Changes
            try managedContext.save()
        } catch {
            // Error Handling
        }
    }
    
    func deleteAssessmentByAssId(_ assId: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "serverAssessmentId == %@ AND userID == %d", assId,userID)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)// as! NSManagedObject)
            }
            try managedContext.save()
        } catch {
            // Error Handling
        }
    }
    
    func deleteDraftByAssessmentId(_ draftId: String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "draftID == %@ AND userID == %d", draftId,userID)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)// as! NSManagedObject)
            }
            try managedContext.save()
        } catch {
            // Error Handling
        }
    }
    
    
    func deleteDraftedRefregratorDataByAssessmentId(_ draftId: String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.returnsObjectsAsFaults = false
        // fetchRequest.predicate = NSPredicate(format: "schAssmentId == %@ AND userID == %d", draftId,userID)
        fetchRequest.predicate = NSPredicate(format: "schAssmentId == %@ ", draftId)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch {
            // Error Handling
        }
    }
    
    
    func deleteRefregratorDataByStartAssessment(_ draftId: String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Refrigator")
        fetchRequest.returnsObjectsAsFaults = false
        //   fetchRequest.predicate = NSPredicate(format: "schAssmentId == %@ AND userID == %d", draftId,userID)
        fetchRequest.predicate = NSPredicate(format: "schAssmentId == %@ ", draftId)
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
            
        } catch {
            // Error Handling
        }
    }
    
    func deleteOfflineBySubmitId(_ dataToSubmitID: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.returnsObjectsAsFaults = false
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitID == %@ AND userID == %d", dataToSubmitID,userID)
        
        do {
            let items = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedContext.delete(item)
            }
            
            try managedContext.save()
            
        } catch {
            // Error Handling
        }
    }
    
    
    func deleteDraftAndMoveToSessionInProgress(_ draftNumber:Int)-> Bool  {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: "serverAssessmentId  == %@ AND userID == %d", currentServerAssessmentId,userID)
        fetchRequest.returnsObjectsAsFaults = false
        
        if let results = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
            CoreDataHandler().deleteAllData("PE_AssessmentIDraftInProgress")
            for result in results {
                
                let peNewAssessment = PENewAssessment()
                peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                peNewAssessment.draftNumber =  result.value(forKey: "draftNumber")  as? Int ?? 0
                peNewAssessment.draftID =  result.value(forKey: "draftID")  as? String ?? ""
                peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR")  as? String ?? ""
                peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                let camera =  result.value(forKey: "camera")  as? Int
                peNewAssessment.camera = camera
                let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                peNewAssessment.isFlopSelected = isFlopSelected
                peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                peNewAssessment.statusType =  result.value(forKey: "statusType") as? Int ?? 0
                
                peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo")  as? Int ?? 0
                peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                peNewAssessment.notes = result.value(forKey: "notes") as? String ?? ""
                peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                peNewAssessment.catResultMark = result.value(forKey: "catResultMark")  as? Int ?? 0
                peNewAssessment.draftID = result.value(forKey: "draftID")  as? String ?? ""
                peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                
                peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs")  as? Int64 ?? 0
                peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR")  as? String ?? ""
                peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                
                peNewAssessment.manufacturer = result.value(forKey: "manufacturer")  as? String ?? ""
                
                peNewAssessment.iCS = result.value(forKey: "iCS")  as? String ?? ""
                peNewAssessment.iDT = result.value(forKey: "iDT")  as? String ?? ""
                peNewAssessment.dCS = result.value(forKey: "dCS")  as? String ?? ""
                peNewAssessment.dDT = result.value(forKey: "dDT")  as? String ?? ""
                peNewAssessment.informationText = result.value(forKey: "informationText") as? String ?? ""
                peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                peNewAssessment.informationImage = result.value(forKey: "informationImage") as? String ?? ""
                
                
                peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                
                peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                
                peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue") as? Bool ?? false
                
                peNewAssessment.countryID = result.value(forKey: "countryID")   as? Int ?? 0
                peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                
                
                // PE International Changes
                peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested")  as? Bool ?? false
                
                peNewAssessment.isPERejected = result.value(forKey: "isPERejected")  as? Bool ?? false
                peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected")  as? Bool ?? false
                
                
                peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                peNewAssessment.basicTransfer = result.value(forKey: "basic")  as? Bool ?? false
                peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                CoreDataHandlerPE().saveDraftAssessmentInProgressInDB(newAssessment:peNewAssessment)
            }
            
            do {
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    
    func fetchViewAssessmentCustomerWithCatID(_ catID: NSNumber,dataToSubmitNumber: Int) -> NSArray {
        var dataArray = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND userID == %d AND serverAssessmentId == %@ " ,argumentArray:[catID,userID,currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    func deleteExisitingData(entityName:String, predicate:NSPredicate?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil{
            fetchRequest.predicate = predicate
        }
        var results: [NSManagedObject] = []
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
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
    
    
    func fetchCustomerForSyncWithCatID(_ catID: NSNumber,dataToSubmitNumber:NSNumber) -> [PENewAssessment]{
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "sequenceNo == %@ AND userID == %d AND dataToSubmitNumber == %d",argumentArray:[catID,userID,dataToSubmitNumber])
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId = result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID = result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.dataToSubmitNumber = result.value(forKey: "dataToSubmitNumber")  as? Int ?? 0
                    peNewAssessment.dataToSubmitID = result.value(forKey: "dataToSubmitID") as? String ?? ""
                    peNewAssessment.complexId = result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName = result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics = result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera = result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo")  as? Int ?? 0
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue") as? String ?? ""
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID") as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    
                    peNewAssessment.fluid = result.value(forKey: "fluid") as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic") as? Bool ?? false
                    
                    //                    peNewAssessment = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
            
            return peNewAssessmentArray
        } catch {
            return peNewAssessmentArray
            
        }
        
    }
    
    func getRejectedAssessmentArrayPEObject(ofCurrentAssessment:Bool?=false,ofCurrentDate:Bool?=false) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentRejected")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId =  UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        if ofCurrentAssessment ?? false{
            fetchRequest.predicate = NSPredicate(format: "userID == %d AND serverAssessmentId == %@", userID,currentServerAssessmentId )
        }else{
            fetchRequest.predicate = NSPredicate(format: userIdStr, userID)
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.manufacturer = result.value(forKey: "manufacturer") as? String ?? ""
                    peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs") as? Int64 ?? 0
                    peNewAssessment.rejectionComment = result.value(forKey: "rejectionComment") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID") as? Int ?? 0
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    
                    peNewAssessment.basicTransfer = result.value(forKey: "basic") as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.fluid = result.value(forKey: "fluid") as? Bool ?? false
                    
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR") as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    peNewAssessment.dataToSubmitID = result.value(forKey: "dataToSubmitID") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName") as? String ?? ""
                    peNewAssessment.frequency = result.value(forKey: "frequency") as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount") as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue") as? String ?? ""
                    peNewAssessment.draftID = result.value(forKey: "draftID") as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.dCS = result.value(forKey: "dCS") as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS") as? String ?? ""
                    peNewAssessment.dDT = result.value(forKey: "dDT") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT") as? String ?? ""
                    peNewAssessment.iCS = result.value(forKey: "iCS") as? String ?? ""
                    peNewAssessment.iDT = result.value(forKey: "iDT") as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                    let hatcheryAntibioticsDoa =  result.value(forKey: "hatcheryAntibioticsDoa")   as? Int
                    peNewAssessment.hatcheryAntibioticsDoa = hatcheryAntibioticsDoa ?? 0
                    let hatcheryAntibioticsDoaS =  result.value(forKey: "hatcheryAntibioticsDoaS")   as? Int
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = hatcheryAntibioticsDoaS ?? 0
                    
                    let hatcheryAntibioticsDoaSText =  result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaSText = hatcheryAntibioticsDoaSText
                    let hatcheryAntibioticsDoaText =  result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = hatcheryAntibioticsDoaText
                    let hatcheryAntibioticsText =  result.value(forKey: "hatcheryAntibioticsText")   as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = hatcheryAntibioticsText
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested") as? Bool ?? false
                    peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue") as? Bool ?? false
                    // New Addition for march release
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected") as? Bool ?? false
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected") as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment") as? String ?? ""
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func saveRejectedAssessmentInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentRejected", in: appDelegate!.managedObjectContext)
        
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
        assessmentObj.setValue(newAssessment.rejectionComment, forKey: "rejectionComment")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
        assessmentObj.setValue(newAssessment.dataToSubmitID, forKey: "dataToSubmitID")
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.catID ?? 0), forKey: "catID")
        assessmentObj.setValue(NSNumber(value:newAssessment.cID ?? 0), forKey: "cID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catResultMark ?? 0), forKey: "catResultMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.catISSelected ?? 0), forKey: "catISSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.assID ?? 0), forKey: "assID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMinScore ?? 0), forKey: "assMinScore")
        assessmentObj.setValue(NSNumber(value:newAssessment.assMaxScore ?? 0), forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(NSNumber(value:newAssessment.assModuleCatID ?? 0), forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
        assessmentObj.setValue(NSNumber(value:newAssessment.assStatus ?? 0), forKey: "assStatus")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNo ?? 0), forKey: "sequenceNo")
        assessmentObj.setValue(NSNumber(value:newAssessment.sequenceNoo ?? 0), forKey: "sequenceNoo")
        assessmentObj.setValue(NSNumber(value:newAssessment.catMaxMark ?? 0), forKey: "catMaxMark")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(newAssessment.images, forKey: "images")
        assessmentObj.setValue(newAssessment.doa, forKey: "doa")
        assessmentObj.setValue(newAssessment.inovoject, forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer, forKey: "vMixer")
        assessmentObj.setValue(NSNumber(value:newAssessment.draftNumber ?? 0), forKey: "draftNumber")
        assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        
        // PE International Changes
        assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(assessmentObj)
    }
    
    func fetchCustomerForSyncWithCatIDDraft(_ catID: NSNumber,draftNumber:NSNumber) -> [PENewAssessment]{
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "sequenceNo == %@ AND userID == %d AND draftNumber == %d",argumentArray:[catID,userID,draftNumber])
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                for result in results {
                    var peNewAssessment = PENewAssessment()
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.serverAssessmentId =  result.value(forKey: "serverAssessmentId")  as? String
                    peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                    peNewAssessment.draftID = result.value(forKey: "draftID") as? String ?? ""
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    hatcheryAntibiotics == 1 ? 1 : 0
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    camera == 1 ? 1 : 0
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    isFlopSelected == 1 ? 1 : 0
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo")  as? Int ?? 0
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType")  as? Int ?? 0
                    
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    
                    // PE International Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID") as? Int ?? 0
                    
                    // PE International Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId") as? Int ?? 0
                    
                    peNewAssessment.fluid = result.value(forKey: "fluid") as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic") as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro")  as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote")  as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
            
            return peNewAssessmentArray
        } catch {
            return peNewAssessmentArray
            
        }
        
    }
    
    func fetchCustomerWithCatID(_ catID: NSNumber) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND userID == %d AND serverAssessmentId == %@ ",argumentArray:[catID,userID,currentServerAssessmentId])
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    func fetchCustomerWithCatIDCount(_ catID: Int64 ,isDraft: Bool = false) -> Int {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var entityNameAssessment = "PE_AssessmentInProgress"
        if isDraft {
            entityNameAssessment = "PE_AssessmentIDraftInProgress"
        }
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityNameAssessment)
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "sumOftotalAssessmentMarks"
        expressionDesc.expression = NSExpression(forFunction: "sum:",
                                                 arguments:[NSExpression(forKeyPath: "assMaxScore")])
        expressionDesc.expressionResultType = .integer32AttributeType
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND userID == %d AND serverAssessmentId == %@ AND assStatus == 1", argumentArray:[catID,userID,currentServerAssessmentId])
        
        var finalResult = 0
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if fetchedResult?.count ?? 0 > 0{
                finalResult = fetchedResult?.map({$0.assMaxScore?.intValue as? Int ?? 0}).reduce(0,+) ?? 0
            }
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return finalResult
    }
    
    func fetchDraftCustomerWithCatID(_ catID: NSNumber,peNewAssessment:PENewAssessment) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "sequenceNo == %@ AND userID == %d AND  draftNumber == %d AND  evaluationID == %d", argumentArray: [catID,userID,peNewAssessment.draftNumber,peNewAssessment.evaluationID]
        )
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
        }
        return dataArray
    }
    
    func fetchRejectedDraftCustomerWithCatID(assessmentId: String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "userID == %d AND  serverAssessmentId == %d", argumentArray: [userID,assessmentId])
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    func getSavedOnGoingAssessmentUserIdArray() -> NSArray {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: userIdStr, userID)
        do {
            let fetchedResult = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let dataArray = results as NSArray
                let userIDArray = dataArray.value(forKey: "userID")  as?  NSArray ?? NSArray()
                return userIDArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return []
    }
    
    
    func saveEvaluatorInDB(_ id: NSNumber, evaluatorName: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Evaluator", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(evaluatorName, forKey: "evaluatorName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
        
    }
    
    func saveApproverInDB(_ id: NSNumber, username: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Approvers", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(username, forKey: "username")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
        
    }
    
    
    func saveVisitTypeInDB(_ id: NSNumber, visitName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VisitTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(visitName, forKey: "visitName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
        
    }
    
    func saveVaccineMixerInDB(_ id: NSNumber,
                              Name: String,
                              certificationDate: String,
                              isCertExpired: Bool,
                              signatureImg: String,
                              certCreatedById:Int? = nil,
                              certCreatedByName:String? = nil,
                              source:String? = nil,
                              isManuallyAdded: Bool? = nil) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VaccineMixerDetail", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(Name, forKey: "name")
        person.setValue(certificationDate, forKey: "certificationDate")
        person.setValue(isCertExpired, forKey: "isCertExpired")
        person.setValue(signatureImg, forKey: "signatureImage")
        
        if let isManuallyAdded = isManuallyAdded {
            person.setValue(isManuallyAdded, forKey: "isManuallyAdded")
        }
        if let createdById = certCreatedById {
            person.setValue(createdById, forKey: "certCeatedby")
        }
        if let createdByNm = certCreatedByName {
            person.setValue(createdByNm, forKey: "certCeatedbyName")
        }
        if let src = source {
            person.setValue(src, forKey: "source")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
        
    }
    
    func saveScoreDataInDB(_ score: String, _ id: NSNumber) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "ScoreData", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(score, forKey: "scoreString")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
        
    }
    
    func saveEvaluationInDB(_ id: NSNumber, evaluationName: String, hatModuleId:NSNumber) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_EvaluationType", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(evaluationName, forKey: "evaluationName")
        person.setValue(hatModuleId, forKey: "hatModuleId")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    
    
    func saveManufacturerInDB(mFG_Id:NSNumber,mFG_Name: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Manufacturer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(mFG_Id, forKey: "mFG_Id")
        person.setValue(mFG_Name, forKey: "mFG_Name")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveBreedBirdddInDB(birdId:NSNumber,birdBreedName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_BirdBreed", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(birdId, forKey: "birdId")
        person.setValue(birdBreedName, forKey: "birdBreedName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    
    func saveEggsInDB(EggId:NSNumber,EggCount: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Eggs", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(EggId, forKey: "eggId")
        person.setValue(EggCount, forKey: "eggCount")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveVManufacturerInDB(id:NSNumber,mfgName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VManufacturer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(mfgName, forKey: "mfgName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveVNamesInDB(id:NSNumber,mfgId:NSNumber,name: String,isSubVaccine:Bool=false,vaccineTypeId: Int64 = 0, vaccineTypeName:String = "" ) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        var entity = NSEntityDescription.entity(forEntityName: "PE_VNames", in: appDelegate!.managedObjectContext)
        if isSubVaccine {
            entity = NSEntityDescription.entity(forEntityName: "PE_VSubNames", in: appDelegate!.managedObjectContext)
        }
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(mfgId, forKey: "mfgId")
        person.setValue(name, forKey: "name")
        if isSubVaccine {
            person.setValue(vaccineTypeId, forKey: "vaccineTypeId")
            person.setValue(vaccineTypeName, forKey: "vaccineTypeName")
        }
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveDManufacturerInDB(diluentMfgId:NSNumber,diluentMfgName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_DManufacturer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(diluentMfgId, forKey: "diluentMfgId")
        person.setValue(diluentMfgName, forKey: "diluentMfgName")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    ///Same implementation of function: saveAmpleSizeInDB()
    func saveBagSizeInDB(id:NSNumber,size: String,forEntityName:String,firstKey:String,secondKey:String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName:forEntityName, in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: firstKey)
        person.setValue(size, forKey: secondKey)
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveCountriesInDB(id:NSNumber,country: String, regionId:NSNumber, forEntityName:String,firstKey:String,secondKey:String  ,thirdKey:String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName:forEntityName, in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: firstKey)
        person.setValue(country, forKey: secondKey)
        person.setValue(regionId, forKey: thirdKey)
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func savePDFDetails(fileId:NSNumber,fileName: String, fileExtension:String , docxfile:String) {
                
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "BlankAssessmentFiles", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(fileName, forKey: "fileName")
        
        person.setValue(fileId, forKey: "fileId")
        person.setValue(fileExtension, forKey: "fileExtension")
        person.setValue(docxfile, forKey: "docxFile")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    func saveClorineInDB(id:NSNumber,clorineName: String, forEntityName:String,firstKey:String,secondKey:String ) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName:forEntityName, in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: firstKey)
        person.setValue(clorineName, forKey: secondKey)
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    
    func saveStatesInDB(id:NSNumber,StateName: String, forEntityName:String,firstKey:String,secondKey:String ) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName:forEntityName, in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: firstKey)
        person.setValue(StateName, forKey: secondKey)
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    
    
    func fetchCustomerWithCustName(_ custName: String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Complex")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerName == %@", custName)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    
    //Pending
    func saveCustomerInSessionWithCustomerNameAndId(_ custId: NSNumber, CustName: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Customer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(custId, forKey: "customerID")
        person.setValue(CustName, forKey: "customerName")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        customerData.append(person)
    }
    
    //pending
    func saveCustomerInSession(_ customer: PE_Customer) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_Session", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(customer, forKey: "customer")
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        customerData.append(person)
        
    }
    
    
    
    func fetchSitesWithCustId(_ custId: NSNumber) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Sites")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId == %@", custId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    
    //fetchCustomer
    func fetchCustomerWithCustnameNew(_ custName: String) -> NSArray {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_Customer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerName == %@", custName)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                customerData = (results as NSArray) as! [NSManagedObject]
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return customerData as NSArray
    }
    
    //fetchDetails
    
    func fetchDetailsWithUserIDWithSiteForAny(entityName:String,siteId:Int) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: "userID == %d AND siteId == %d", userID,siteId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    
    func fetchDetailsWithUserIDForAny(entityName:String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: userIdStr, userID)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return dataArray
    }
    
    func fetchDetailsWithUserIDFor(entityName:String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: "userID == %d AND asyncStatus == 0 ", userID)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func fetchDetailsWithAssIDFor(entityName:String, assId: String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: "userID == %d AND asyncStatus == 0 AND serverAssessmentId == %@", userID, assId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func fetchDetailsFor(entityName:String) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func fetchDetailsForVaccineNames(typeId:Int64) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VSubNames")
        fetchRequest.predicate = NSPredicate(format:"vaccineTypeId == %i",typeId)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    
    
    func fetchSitesForCoustomerDetailsFor(entityName:String,customerId:Int) -> NSArray {
        var dataArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "customerId == %d", argumentArray: [customerId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func updateOfflineStatus(assessment: PENewAssessment) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
         managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitNumber == %d", argumentArray: [assessment.dataToSubmitNumber])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for  obj in results {
                obj.setValue(1, forKey: "asyncStatus")
                
            }
        } catch {
            return false
        }
        do {
            try managedContext.save()
            
        } catch {
            return false
        }
        return false
    }
    
    
    func updateDraftStatus(assessment: PENewAssessment) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: draftNo, argumentArray: [assessment.draftNumber ?? 0])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for  obj in results {
                obj.setValue(1, forKey: "asyncStatus")
            }
            
        } catch {
            return false
        }
        do {
            try managedContext.save()
            
        }
        catch {
            return false
        }
        return false
    }
    
    func updateAssementDetailsForStatus(assessment: PE_AssessmentInProgress) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: " catID == %@ AND assID == %@ AND userID == %d AND serverAssessmentId == %@", argumentArray: [assessment.catID,assessment.assID,userID,currentServerAssessmentId])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue(assessment.assStatus, forKey: "assStatus")
                results![0].setValue(assessment.catResultMark, forKey: "catResultMark")
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            self.updateCatDetailsForStatus(assessment:assessment)
            
        }
        catch {
            
        }
    }
    
    func updateCatDetailsForStatus(assessment: PE_AssessmentInProgress) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catServerId, argumentArray: [assessment.catID,userID,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.catResultMark, forKey: "catResultMark")
                    result.setValue(assessment.catMaxMark, forKey: "catMaxMark")
                    result.setValue(assessment.catISSelected, forKey: "catISSelected")
                    
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    
    //for getting assessment
    func updateChangeInAnsInProgressTable(catISSelected:Int,catResultMark:Int,catID: Int,assID: Int,userID:Int) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catServerId, argumentArray: [catID,userID,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(catResultMark, forKey: "catResultMark")
                    result.setValue(catISSelected, forKey: "catISSelected")
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            updateAssIDSatus(assID: assID)
        }
        catch {
            
        }
    }
    
    //for getting assessment
    func updateChangeInTotalAnsInProgressTable(catISSelected:Int,catMaxMark:Int,catID: Int,assID: Int,userID:Int) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catServerId, argumentArray: [catID,userID,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(catMaxMark, forKey: "catMaxMark")
                    result.setValue(catISSelected, forKey: "catISSelected")
                    
                    
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            updateAssIDSatus(assID: assID)
        }
        catch {
            
        }
    }
    
    func updateNoteInProgressTable(assID: Int,text:String) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: assServerId, argumentArray: [assID,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(text, forKey: "note")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    
    /// Same implementation as function: updateDraftRefrigetorInProgressTable()
    func updateRefrigetorInProgressTable(text:String) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: " userID == %d AND serverAssessmentId == %@", argumentArray: [userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(text, forKey: "refrigeratorNote")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateQCCountInAssessmentInProgress(qcCount:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(qcCount, forKey: "qcCount")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    
    func updatePPMInAssessmentInProgress(ppmValue:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    
                    result.setValue(ppmValue, forKey: "ppmValue")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateAMPMInAssessmentInProgress(ampmValue:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(ampmValue, forKey: "ampmValue")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func updatePPMValueInAssessmentInProgress(PpmValue:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(PpmValue, forKey: "ppmValue")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    
    
    func update_isNAInAssessmentInProgress(isNA:Bool,assID :Int) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: assServerId, argumentArray: [assID,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isNA, forKey: "isNA")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    
    
    
    func updatePersonNameInAssessmentInProgress(personName:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(personName, forKey: "personName")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateIsEMRequestedInAssessmentInProgress(isEMRequested:Bool) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRequested, forKey: "isEMRequested")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func updateIsEMRequestedInAssessmentSwitch(isEMRequested:Bool  , AssessmentId:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [AssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRequested, forKey: "isEMRequested")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func updateIsEMRequestedInAssessmentSwitchOffline(isEMRequested:Bool  , AssessmentId:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [AssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRequested, forKey: "isEMRequested")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    func fetchDraftEMRequestedData(assessmentId: String) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, assessmentId )
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                if let records = results {
                    for record in records {
                        let serverAssessmentId = record.value(forKey: "serverAssessmentId") as? String
                        if assessmentId == serverAssessmentId {
                            let isEMRequested = record.value(forKey: "isEMRequested") as?
                            Bool ?? false
                            return isEMRequested
                        }
                    }
                }
                return false
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    func updateDraftIsEMRequested(isEMRequested:Bool) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRequested, forKey: "isEMRequested")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateDraftIsEMRejected(isEMRejected:Bool) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRejected, forKey: "isEMRejected")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func updateOfflineIsEMRequested(isEMRequested:Bool) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRequested, forKey: "isEMRequested")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateOfflineIsEMRejected(isEMRejected:Bool) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(isEMRejected, forKey: "isEMRejected")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateFrequencyInAssessmentInProgress(frequency:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, argumentArray: [currentServerAssessmentId])
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(frequency, forKey: "frequency")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    
    func updateAssIDSatus(assID: Int) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: assServerId, argumentArray: [assID,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for result in results ?? [] {
                    result.setValue(0, forKey: "assStatus")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    
    func updateNoteAssessmentInProgress(assessment: PE_AssessmentInProgress) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: assServerId, argumentArray: [assessment.assID!,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.note, forKey: "note")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    func update_ISNA_AssessmentInProgress(assessment: PE_AssessmentInProgress) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: " assID == %@", argumentArray:  [assessment.assID])
        
        do {
            let result = try appDelegate.managedObjectContext.fetch(fetchRequest) as? NSManagedObject
            result?.setValue(assessment.isNA, forKey: "isNA")
            
        } catch {
            
        }
        
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    func updateCatMaxMarks(assessment: PE_AssessmentInProgress) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: assServerId, argumentArray: [assessment.assID,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.note, forKey: "catMaxMark")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    
    
    
    func updateCategortIsSelcted(assessment: PENewAssessment) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catServerId, argumentArray: [assessment.catID,userID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.catISSelected, forKey: "catISSelected")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func updateDraftAssementDetailsForStatus(assessment: PE_AssessmentInProgress) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND assID == %@ AND userID == %d", argumentArray: [assessment.catID,assessment.assID,userID])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue(assessment.assStatus, forKey: "assStatus")
                results![0].setValue(assessment.catResultMark, forKey: "catResultMark")
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        do {
            try managedContext.save()
            var _ = self.updateCatDetailsForStatus(assessment:assessment)
            
        }
        catch {
            
        }
    }
    
    func updateDraftCatDetailsForStatus(assessment: PE_AssessmentInProgress) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: " catID == %@ AND userID == %d", argumentArray: [assessment.catID,userID
                                                                                                     ])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.catResultMark, forKey: "catResultMark")
                    result.setValue(assessment.catISSelected, forKey: "catISSelected")
                    result.setValue(assessment.catMaxMark, forKey: "catMaxMark")
                }
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
    
    func updateUnitRefrigatorInDB(_ serverAssessmentId: Int,unit:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator")
        fetchRequest.predicate = NSPredicate(format: "schAssmentId = %d", serverAssessmentId)
        var results: [NSManagedObject] = []
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            if(results.count>0){
                for i in 0..<results.count{
                    var re = results[i]
                    re.setValue(unit, forKey: "unit")
                    do {
                        try managedContext.save()
                    } catch {
                    }
                }
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateUnitDraftRefrigatorInDB(_ serverAssessmentId: Int,unit:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PE_Refrigator_InDraft")
        fetchRequest.predicate = NSPredicate(format: "schAssmentId = %d", serverAssessmentId)
        var results: [NSManagedObject] = []
        do {
            results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            if(results.count>0){
                for i in 0..<results.count{
                    var re = results[i]
                    re.setValue(unit, forKey: "unit")
                    do {
                        try managedContext.save()
                    } catch {
                    }
                }
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
    func updateDraftNoteAssessmentInProgress(assessment: PE_AssessmentInProgress) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: " assID == %@ AND userID == %d", argumentArray: [assessment.assID,userID])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.note, forKey: "note")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateDraftRefriNoteAssessmentInProgress(text:String) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: " serverAssessmentId == %@ AND userID == %d", argumentArray: [currentServerAssessmentId,userID])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(text, forKey: "refrigeratorNote")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateDraft_ISNA_AssessmentInProgress(assessment: PE_AssessmentInProgress) -> Bool {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: " assID == %@ AND userID == %d", argumentArray: [assessment.assID,userID])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.isNA, forKey: "isNA")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    func updateDraftCategortIsSelcted(assessment: PENewAssessment) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        fetchRequest.predicate = NSPredicate(format: " catID == %@ AND userID == %d", argumentArray: [assessment.catID,userID])
        
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(assessment.catISSelected, forKey: "catISSelected")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
}

extension CoreDataHandlerPE {
    
    func saveImageInPEFinishModule(imageId:Int,imageData:Data) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_ImageEntity", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(imageId, forKey: "imageId")
        assessmentObj.setValue(imageData, forKey: "imageData")
        assessmentObj.setValue(0, forKey: "isSync")
        do {
            try managedContext.save()
        } catch {
        }
        
    }
    
    func saveImageInPEModule(assessment: PE_AssessmentInProgress,imageId:Int,imageData:Data,fromDraft:Bool?=false) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_ImageEntity", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(imageId, forKey: "imageId")
        assessmentObj.setValue(imageData, forKey: "imageData")
        assessmentObj.setValue(0, forKey: "isSync")
        do {
            try managedContext.save()
            saveImageIdToCurrentQuestion(assessment: assessment, imageId: imageId,fromDraft: fromDraft)
        } catch {
        }
        
    }
    
    func saveImageInPEModuleDraft(assessment: PE_AssessmentInProgress,imageId:Int,imageData:Data) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_ImageEntity", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(imageId, forKey: "imageId")
        assessmentObj.setValue(imageData, forKey: "imageData")
        assessmentObj.setValue(0, forKey: "isSync")
        do {
            try managedContext.save()
            saveImageIdToCurrentQuestionDraft(assessment: assessment, imageId: imageId)
            
        } catch {
        }
    }
    
    func saveImageInGetApi(imageId:Int,imageData:Data) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_ImageEntity", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(imageId, forKey: "imageId")
        assessmentObj.setValue(imageData, forKey: "imageData")
        assessmentObj.setValue(1, forKey: "isSync")
        do {
            try managedContext.save()
        } catch {
        }
    }
    
    func imageAlreadySyncStatus(imageId:Int) -> Bool {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: " imageId == %@ AND isSync == 1 ", argumentArray: [imageId])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    return true
                }
            }else {
                return false
            }
        } catch {
            return false
        }
        return false
    }
    
    
    func saveImageIdGetApi(imageId:Int,userID:Int,catID:Int,assID:Int,dataToSubmitID:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "dataToSubmitID == %@ AND catID == %@ AND assID == %@ AND userID == %d", argumentArray: [dataToSubmitID,catID,assID,userID])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    imagesPreviousArray.append(imageId)
                    result.setValue(imagesPreviousArray, forKey: "images")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    
    func saveImageDraftIdGetApi(imageId:Int,userID:Int,catID:Int,assID:Int,dataToSubmitID:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "draftID == %@ AND catID == %@ AND assID == %@ AND userID == %d", argumentArray: [dataToSubmitID,catID,assID,userID])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    imagesPreviousArray.append(imageId)
                    result.setValue(imagesPreviousArray, forKey: "images")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    func saveImageOngoingDraftIdGetApi(imageId:Int,userID:Int,catID:Int,assID:Int,dataToSubmitID:String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "draftID == %@ AND catID == %@ AND assID == %@ AND userID == %d", argumentArray: [dataToSubmitID,catID,assID,userID])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    imagesPreviousArray.append(imageId)
                    result.setValue(imagesPreviousArray, forKey: "images")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    
    func saveImageIdToCurrentQuestionDraft(assessment: PE_AssessmentInProgress,imageId:Int) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND assID == %@ AND userID == %d", argumentArray: [assessment.catID,assessment.assID,userID])
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    imagesPreviousArray.append(imageId)
                    result.setValue(imagesPreviousArray, forKey: "images")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    func saveImageIdToCurrentQuestion(assessment: PE_AssessmentInProgress,imageId:Int,fromDraft:Bool?=false) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft ?? false {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND assID == %@ AND userID == %d AND serverAssessmentId == %@", argumentArray: [assessment.catID,assessment.assID,userID,currentServerAssessmentId])
        
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    imagesPreviousArray.append(imageId)
                    result.setValue(imagesPreviousArray, forKey: "images")
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
    
    func getImagecountOfQuestion(assessment: PE_AssessmentInProgress,fromDraft:Bool?=false) -> Int{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft ?? false {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        
        fetchRequest.predicate = NSPredicate(format: "catID == %@ AND assID == %@ AND userID == %d  AND serverAssessmentId == %@", argumentArray: [assessment.catID,assessment.assID,userID,currentServerAssessmentId])
        
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "images")  as? [Int] ?? []
                    return imagesPreviousArray.count
                }
            }
        } catch {
            
        }
        
        do {
            try managedContext.save()
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
        return 0
    }
    
    func getImageByImageID(idArray: Int)-> Data {
        var imageDataToReturn : Data = Data()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "imageId == %d",idArray)
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    let imageData =  result.value(forKey: "imageData")  as? Data ?? Data()
                    imageDataToReturn = imageData
                }
            }
            return imageDataToReturn
        } catch {
            //   print("Fetch Failed: \(error)")
            return imageDataToReturn
        }
    }
    
    func getImageBase64ByImageID(idArray: Int)-> String {
        var imageDataToReturn : Data = Data()
        var str = ""
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "imageId == %d",idArray)
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    let imageData =  result.value(forKey: "imageData")  as? Data ?? Data()
                    imageDataToReturn = imageData
                    str = imageData.base64EncodedString(options: .lineLength64Characters)                  }
            }
            return str
        } catch {
            //   print("Fetch Failed: \(error)")
            return str
        }
    }
    
    //""__
    func setImageStatusTrue(idArray: Int) {
        var imageDataToReturn : Data = Data()
        var str = ""
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_ImageEntity")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "imageId == %d",idArray)
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    result.setValue(1, forKey: "isSync")
                }
            }
            
        } catch {
            
        }
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    
    
    
    
    
    func checkDraftByDate(newAssessment:PENewAssessment,draftNumber:Int) -> Bool{
        var peNewAssessmentArray : [PENewAssessment] = []
        var dataArray = NSArray()
        var userIDArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let evaluationID =  newAssessment.evaluationID ?? 0
        if evaluationID == 0 {
            fetchRequest.predicate = NSPredicate(format: "evaluationDate == %@ AND userID == %d ", newAssessment.evaluationDate ?? "",userID)
        }else {
            fetchRequest.predicate = NSPredicate(format: "evaluationDate == %@ AND userID == %d AND evaluationID == %d AND draftNumber == %d", argumentArray: [newAssessment.evaluationDate ?? "",userID,newAssessment.evaluationID ?? 0,draftNumber])
        }
        if let results = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
            if results.count ?? 0 > 0 {
                for result in results ?? []{
                    var draftNum = result.value(forKey: "draftID") as? String ?? ""
                    self.deleteDraftByDrafyNumber(draftNum)
                    return false
                }
                return false
            } else {
                return false
            }
            return false
        }
        return false
    }
    
    
    func checkDraftByDates(newAssessment:PE_AssessmentIDraftInProgress,draftNumber:Int) -> Bool{
        //        var peNewAssessmentArray : [PENewAssessment] = []
        //        var dataArray = NSArray()
        //        var userIDArray = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInDraft")
        fetchRequest.returnsObjectsAsFaults = false
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let evaluationID =  newAssessment.evaluationID ?? 0
        if evaluationID == 0 {
            fetchRequest.predicate = NSPredicate(format: "evaluationDate == %@ AND userID == %d ", newAssessment.evaluationDate ?? "",userID)
        }else {
            fetchRequest.predicate = NSPredicate(format: "evaluationDate == %@ AND userID == %d AND evaluationID == %d AND draftNumber == %d", argumentArray: [newAssessment.evaluationDate ?? "",userID,newAssessment.evaluationID ?? 0,draftNumber])
        }
        if let results = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
            if results.count > 0 {
                for result in results {
                    let draftNum = result.value(forKey: "draftID") as? String ?? ""
                    self.deleteDraftByDrafyNumber(draftNum)
                    return false
                }
                return false
            } else {
                return false
            }
            return false
        }
        return false
    }
    
    //    func saveDraftPEInDB(newAssessmentArray:[PE_AssessmentIDraftInProgress],draftNumber:Int,isfromDraft:Bool? = false,isfromRejected:Bool? = false ) {
    //
    //
    //        let date = Date()
    //        var formate = ""
    //        if formate == "" {
    //            formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss") // Set output formate
    //        }
    //
    //        if checkDraftByDates(newAssessment:newAssessmentArray[0] , draftNumber: draftNumber){
    //
    //        } else {
    //            for newAssessment in newAssessmentArray {
    //                let appDelegate    = UIApplication.shared.delegate as? AppDelegate
    //                let managedContext = appDelegate!.managedObjectContext
    //                let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInDraft", in: managedContext)
    //                let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
    //
    //                formate = formate.replacingOccurrences(of:" ", with: "")
    //                formate = formate.replacingOccurrences(of:"/", with: "")
    //                formate = formate.replacingOccurrences(of:":", with: "")
    //                formate = formate.replacingOccurrences(of:"Z", with: "")
    //                print(formate)
    //                assessmentObj.setValue(1, forKey: "asyncStatus")
    //                if isfromDraft ?? false {
    //                    assessmentObj.setValue(newAssessment.draftID, forKey: "draftID")
    //                } else if isfromRejected ?? false {
    //                    assessmentObj.setValue(newAssessment.dataToSubmitID, forKey: "dataToSubmitID")
    //                }
    //
    //                else {
    //                    assessmentObj.setValue(formate, forKey: "draftID")
    //                }
    //                let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
    //                assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
    //
    //
    //                assessmentObj.setValue(NSNumber(value:draftNumber), forKey: "draftNumber")
    //                assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
    //                assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
    //
    //                assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
    //                assessmentObj.setValue(newAssessment.assID, forKey: "assID")
    //                assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
    //                assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
    //                assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
    //                assessmentObj.setValue(newAssessment.userID, forKey: "userID")
    //                assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
    //                assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
    //                assessmentObj.setValue(newAssessment.username, forKey: "username")
    //                assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
    //                assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
    //                assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
    //                assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
    //                assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
    //                assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
    //                assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
    //                assessmentObj.setValue(newAssessment.approver, forKey: "approver")
    //                assessmentObj.setValue(newAssessment.noOfEggs ?? 0, forKey: "noOfEggs")
    //                assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
    //                assessmentObj.setValue(newAssessment.notes, forKey: "notes")
    //                assessmentObj.setValue(newAssessment.note, forKey: "note")
    //                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
    //                let camera = newAssessment.camera == 1 ? 1 : 0
    //                let flock = newAssessment.isFlopSelected == 1 ? 1:0
    //                assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
    //                assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
    //                assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
    //                assessmentObj.setValue(newAssessment.catID, forKey: "catID")
    //                assessmentObj.setValue(newAssessment.catName, forKey: "catName")
    //                assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
    //                assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
    //                assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
    //                assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
    //                assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
    //                assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
    //                assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
    //                assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
    //                assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
    //                assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
    //                assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
    //                assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
    //                assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
    //                assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
    //                assessmentObj.setValue(newAssessment.images , forKey: "images")
    //                assessmentObj.setValue(newAssessment.doa , forKey: "doa")
    //                assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
    //                assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
    //                assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
    //                assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
    //                assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
    //                assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
    //                assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
    //                assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
    //                assessmentObj.setValue(newAssessment.sig, forKey: "sig")
    //                assessmentObj.setValue(newAssessment.sig2, forKey: "sig2")
    //                assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
    //                assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
    //                assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
    //                assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
    //                assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
    //                assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
    //                assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
    //                assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
    //                assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
    //                assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
    //                assessmentObj.setValue(newAssessment.micro, forKey: "micro")
    //                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
    //                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
    //                assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
    //                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
    //                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
    //                assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
    //                assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
    //                assessmentObj.setValue(newAssessment.personName, forKey: "personName")
    //                assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
    //                assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
    //                assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
    //                assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
    //                assessmentObj.setValue(newAssessment.residue, forKey: "residue")
    //                assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
    //                assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
    //                assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
    //                do {
    //                    try managedContext.save()
    //                } catch {
    //                }
    //                customerData.append(assessmentObj)
    //            }
    //        }
    //    }
    
    
    
    
    func   saveDraftPEInDB(newAssessmentArray:[PENewAssessment],draftNumber:Int,isfromDraft:Bool? = false,isfromRejected:Bool? = false) {
        
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        let date = Date()
        var formate = ""
        if formate == "" {
            
            if regionID == 3{
                formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")   // Set output formate
                let random = newAssessmentArray[0].serverAssessmentId
                formate = "\(formate)\(random ?? "")"
            }
            else
            {
                formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")   // Set output formate
                let random = newAssessmentArray[0].serverAssessmentId
                formate = "\(formate)\(random ?? "")"
            }
            
        }
        
        if checkDraftByDate(newAssessment:newAssessmentArray[0] , draftNumber: draftNumber){
            
        } else {
            for newAssessment in newAssessmentArray {
                let appDelegate    = UIApplication.shared.delegate as? AppDelegate
                let managedContext = appDelegate!.managedObjectContext
                let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInDraft", in: managedContext)
                let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                formate = formate.replacingOccurrences(of:" ", with: "")
                formate = formate.replacingOccurrences(of:"/", with: "")
                formate = formate.replacingOccurrences(of:":", with: "")
                formate = formate.replacingOccurrences(of:"Z", with: "")
                formate = formate.replacingOccurrences(of:"PM", with: "")
                formate = formate.replacingOccurrences(of:"AM", with: "")
                
                print(formate)
                assessmentObj.setValue(0, forKey: "asyncStatus")
                if isfromDraft ?? false {
                    assessmentObj.setValue(newAssessment.draftID, forKey: "draftID")
                }  else if isfromRejected ?? false {
                    assessmentObj.setValue(newAssessment.dataToSubmitID, forKey: "draftID")
                } else {
                    assessmentObj.setValue(formate, forKey: "draftID")
                }
                let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
                assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
                
                assessmentObj.setValue(NSNumber(value:draftNumber), forKey: "draftNumber")
                assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
                assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
                assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
                assessmentObj.setValue(newAssessment.assID, forKey: "assID")
                assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
                assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
                assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
                assessmentObj.setValue(newAssessment.userID, forKey: "userID")
                assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
                assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
                assessmentObj.setValue(newAssessment.username, forKey: "username")
                assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
                assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
                assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
                assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
                assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
                assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
                assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
                assessmentObj.setValue(newAssessment.approver, forKey: "approver")
                assessmentObj.setValue(newAssessment.notes, forKey: "notes")
                assessmentObj.setValue(newAssessment.note, forKey: "note")
                
                assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
                assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                if isfromRejected == true
                {
                    if newAssessment.isEMRejected == true && newAssessment.isPERejected == true {
                        assessmentObj.setValue(2, forKey: "statusType")
                    }
                    else if newAssessment.isEMRejected == true && newAssessment.isPERejected == false{
                        assessmentObj.setValue(2, forKey: "statusType")
                    }
                    else if newAssessment.isEMRejected == false && newAssessment.isPERejected == true{
                        assessmentObj.setValue(2, forKey: "statusType")
                    }
                    
                    else
                    {
                        assessmentObj.setValue(0, forKey: "statusType")
                    }
                }
                else
                {
                    assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
                }
                
                //
                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                let camera = newAssessment.camera == 1 ? 1 : 0
                let flock = newAssessment.isFlopSelected == 1 ? 1:0
                assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
                assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
                assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
                assessmentObj.setValue(newAssessment.catID, forKey: "catID")
                assessmentObj.setValue(newAssessment.catName, forKey: "catName")
                assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
                assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
                assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
                assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
                assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
                assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
                assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
                assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
                assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
                assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
                assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
                assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
                assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
                assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
                assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
                assessmentObj.setValue(newAssessment.images , forKey: "images")
                assessmentObj.setValue(newAssessment.doa , forKey: "doa")
                assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
                assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
                assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
                assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
                assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
                assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
                assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
                assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
                assessmentObj.setValue(newAssessment.noOfEggs ?? 0, forKey: "noOfEggs")
                assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
                assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
                assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
                assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
                assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
                assessmentObj.setValue(newAssessment.micro, forKey: "micro")
                assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
                assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
                assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
                assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
                assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
                assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
                assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
                assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
                assessmentObj.setValue(newAssessment.rejectionComment, forKey: "rejectionComment")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
                assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
                assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
                
                assessmentObj.setValue(newAssessment.personName, forKey: "personName")
                assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
                assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
                assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
                assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
                assessmentObj.setValue(newAssessment.residue, forKey: "residue")
                assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
                assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
                
                
                
                //   PE International Changes
                assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
                assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
                assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
                assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
                assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
                assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
                assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
                assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
                assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
                assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
                
                assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
                assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
                assessmentObj.setValue(newAssessment.IsEMRequested, forKey: "isEMRequested")
                
                
                assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
                assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
                assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
                
                
                
                do {
                    try managedContext.save()
                } catch {
                }
                customerData.append(assessmentObj)
            }
        }
    }
    
    
    func saveDraftPEInDBDraft(newAssessmentArray:[PENewAssessment],draftId:String) {
        
        self.deleteDraftByDrafyNumber(draftId)
        
        for newAssessment in newAssessmentArray {
            let appDelegate    = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInDraft", in: managedContext)
            let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
            assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
            assessmentObj.setValue(0, forKey: "asyncStatus")
            assessmentObj.setValue(newAssessment.draftID, forKey: "draftID")
            assessmentObj.setValue(newAssessment.draftNumber, forKey: "draftNumber")
            assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
            assessmentObj.setValue(newAssessment.assID, forKey: "assID")
            assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
            assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
            assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
            assessmentObj.setValue(newAssessment.userID, forKey: "userID")
            assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
            assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
            assessmentObj.setValue(newAssessment.username, forKey: "username")
            assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
            assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
            assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
            assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
            assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
            assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
            assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
            assessmentObj.setValue(newAssessment.approver, forKey: "approver")
            assessmentObj.setValue(newAssessment.notes, forKey: "notes")
            assessmentObj.setValue(newAssessment.note, forKey: "note")
            let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
            let camera = newAssessment.camera == 1 ? 1 : 0
            let flock = newAssessment.isFlopSelected == 1 ? 1:0
            assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
            assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
            assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
            assessmentObj.setValue(newAssessment.catID, forKey: "catID")
            assessmentObj.setValue(newAssessment.catName, forKey: "catName")
            assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
            assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
            assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
            assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
            assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
            assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
            assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
            assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
            assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
            assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
            assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
            assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
            assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
            assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
            assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
            assessmentObj.setValue(newAssessment.images , forKey: "images")
            assessmentObj.setValue(newAssessment.doa , forKey: "doa")
            assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
            assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
            assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
            assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
            assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
            assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
            assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
            assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
            assessmentObj.setValue(newAssessment.noOfEggs ?? 0, forKey: "noOfEggs")
            assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
            assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
            assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
            assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
            assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
            
            assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
            assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
            assessmentObj.setValue(NSNumber(value: newAssessment.sig ?? 0), forKey: "sig")
            assessmentObj.setValue(NSNumber(value: newAssessment.sig2 ?? 0), forKey: "sig2")
            assessmentObj.setValue(newAssessment.sig_Date, forKey: "sig_Date")
            assessmentObj.setValue(newAssessment.sig_EmpID, forKey: "sig_EmpID")
            assessmentObj.setValue(newAssessment.sig_EmpID2, forKey: "sig_EmpID2")
            assessmentObj.setValue(newAssessment.sig_Name, forKey: "sig_Name")
            assessmentObj.setValue(newAssessment.sig_Name2, forKey: "sig_Name2")
            assessmentObj.setValue(newAssessment.sig_Phone, forKey: "sig_Phone")
            assessmentObj.setValue(newAssessment.micro, forKey: "micro")
            assessmentObj.setValue(newAssessment.residue, forKey: "residue")
            assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
            assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
            assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
            assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
            assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
            assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
            assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
            assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
            assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
            assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
            assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
            assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
            assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
            assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
            assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
            assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
            assessmentObj.setValue(newAssessment.personName, forKey: "personName")
            assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
            assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
            assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
            
            // PE Intrenational Changes
            assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
            assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
            
            assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
            assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
            assessmentObj.setValue(newAssessment.IsEMRequested, forKey: "isEMRequested")
            
            
            assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
            assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
            assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
            
            
            // PE International Changes
            
            assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
            assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
            assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
            assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
            assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
            assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
            assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
            assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
            do {
                try managedContext.save()
            } catch {
            }
            customerData.append(assessmentObj)
            
        }
    }
    //PE_AssessmentIDraftInProgress
    
    
    
    func saveDataToSyncPEInDBArray(newAssessmentArray:[PENewAssessment],dataToSubmitNumber:Int,param:[String:String]?,fromDraft:Bool? = false) -> Bool{
        
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        let date = Date()
        var formate = ""
        if formate == "" {
            
            if regionID == 3{
                formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
            }
            else
            {
                formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
            }
        }
        
        // Set output formate
        formate = formate.replacingOccurrences(of:" ", with: "")
        formate = formate.replacingOccurrences(of:"/", with: "")
        formate = formate.replacingOccurrences(of:":", with: "")
        formate = formate.replacingOccurrences(of:"Z", with: "")
        formate = formate.replacingOccurrences(of:":", with: "")
        formate = formate.replacingOccurrences(of:"Z", with: "")
        formate = formate.replacingOccurrences(of:"PM", with: "")
        formate = formate.replacingOccurrences(of:"AM", with: "")
        
        if  newAssessmentArray.count > 0 {
            let random = newAssessmentArray[0].serverAssessmentId
            formate = "\(formate)\(random ?? "")"
            print(formate)
            let dd = formate
            var count = 0
            for newAssessment in newAssessmentArray {
                count = count + 1
                let appDelegate    = UIApplication.shared.delegate as? AppDelegate
                let managedContext = appDelegate!.managedObjectContext
                let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInOffline", in: managedContext)
                let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                if newAssessment.isPERejected == false && newAssessment.isEMRejected == true
                {
                    assessmentObj.setValue(1, forKey: "asyncStatus")
                }
                else
                {
                    assessmentObj.setValue(0, forKey: "asyncStatus")
                }
                
                if fromDraft ?? false {
                    formate = newAssessment.draftID ?? dd
                    newAssessment.isEMRejected = false
                }
                let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
                assessmentObj.setValue(currentServerAssessmentId, forKey: "serverAssessmentId")
                assessmentObj.setValue(formate, forKey: "dataToSubmitID")
                assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "dataToSubmitNumber")
                assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
                assessmentObj.setValue(newAssessment.assID, forKey: "assID")
                assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
                assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
                assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
                assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
                assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
                assessmentObj.setValue(newAssessment.userID, forKey: "userID")
                assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
                assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
                assessmentObj.setValue(newAssessment.username, forKey: "username")
                assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
                assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
                assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
                assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
                assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
                assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
                assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
                assessmentObj.setValue(newAssessment.approver, forKey: "approver")
                assessmentObj.setValue(newAssessment.notes, forKey: "notes")
                assessmentObj.setValue(newAssessment.note, forKey: "note")
                let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
                let camera = newAssessment.camera == 1 ? 1 : 0
                let flock = newAssessment.isFlopSelected == 1 ? 1:0
                assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
                assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
                assessmentObj.setValue(newAssessment.catID, forKey: "catID")
                assessmentObj.setValue(newAssessment.catName, forKey: "catName")
                assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
                assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
                assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
                assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
                assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
                assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
                assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
                assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
                assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
                assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
                assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
                assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
                assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
                assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
                assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
                assessmentObj.setValue(newAssessment.images , forKey: "images")
                assessmentObj.setValue(newAssessment.doa , forKey: "doa")
                assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
                assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
                assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
                assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
                assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
                assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
                assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
                assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
                assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
                assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
                assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
                assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
                assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
                assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
                assessmentObj.setValue(newAssessment.micro, forKey: "micro")
                assessmentObj.setValue(newAssessment.residue, forKey: "residue")
                assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
                assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
                assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
                assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                assessmentObj.setValue(newAssessment.personName, forKey: "personName")
                assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
                assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
                assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
                assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
                assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                let sig = (param?["sig"] ?? "") as String
                assessmentObj.setValue(Int(sig) , forKey: "sig")
                assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
                assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
                let sig2 = (param?["sig2"] ?? "") as String
                assessmentObj.setValue(Int(sig2) , forKey: "sig2")
                assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
                assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
                
                assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
                
                assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
                
                
                assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
                assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
                assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
                assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
                assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
                assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
                assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
                assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
                assessmentObj.setValue(newAssessment.personName, forKey: "personName")
                assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
                assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
                
                // PE Intrenational Changes
                assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
                assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
                assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
                assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
                assessmentObj.setValue(newAssessment.IsEMRequested, forKey: "isEMRequested")
                
                assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
                assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
                assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
                assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
                assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
                assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
                assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
                assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
                
                assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
                assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                
                assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
                assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
                assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
                
                do {
                    try managedContext.save()
                    
                } catch {
                }
                customerData.append(assessmentObj)
                if fromDraft ?? false {
                    self.deleteDraftByDrafyNumber(String(newAssessment.draftID ?? ""))
                }
                appDelegate?.saveContext()
                if count == newAssessmentArray.count {
                    return true
                }
            }
        }
        return false
    }
    
    func saveDataToSyncPEInDB(newAssessment:PE_AssessmentInProgress,dataToSubmitNumber:Int,param:[String:String]?,fromDraft:Bool? = false) {
        
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInOffline", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(0, forKey: "asyncStatus")
        
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        let date = Date()
        var formate = ""
        if formate == "" {
            
            if regionID == 3{
                formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
            }
            else
            {
                formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
            }
        }
        
        //    var formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss") // Set output formate
        let random = newAssessment.serverAssessmentId
        formate = "\(formate)\(random ?? "")"
        formate = formate.replacingOccurrences(of:" ", with: "")
        formate = formate.replacingOccurrences(of:"/", with: "")
        formate = formate.replacingOccurrences(of:":", with: "")
        formate = formate.replacingOccurrences(of:"Z", with: "")
        formate = formate.replacingOccurrences(of:":", with: "")
        formate = formate.replacingOccurrences(of:"Z", with: "")
        formate = formate.replacingOccurrences(of:"PM", with: "")
        formate = formate.replacingOccurrences(of:"AM", with: "")
        print(formate)
        let dd = formate
        if fromDraft ?? false {
            formate = newAssessment.draftID ?? dd
        }
        assessmentObj.setValue(formate, forKey: "dataToSubmitID")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        assessmentObj.setValue(currentServerAssessmentId, forKey: "serverAssessmentId")
        
        self.deleteDraftByDrafyNumber(newAssessment.draftID ?? "")
        assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "dataToSubmitNumber")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.assID, forKey: "assID")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(newAssessment.userID, forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.catID, forKey: "catID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
        assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
        assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
        assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
        assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
        assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
        assessmentObj.setValue(newAssessment.images , forKey: "images")
        assessmentObj.setValue(newAssessment.doa , forKey: "doa")
        assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
        assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        
        let sig = (param?["sig"] ?? "") as String
        assessmentObj.setValue(Int(sig) , forKey: "sig")
        assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
        assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
        let sig2 = (param?["sig2"] ?? "") as String
        assessmentObj.setValue(Int(sig2) , forKey: "sig2")
        assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
        assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
        
        assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
        
        assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
        
        
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        
        
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basic, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        do {
            try managedContext.save()
        } catch {
        }
        customerData.append(assessmentObj)
    }
    
    
    func saveDataToRejectedSyncPEInDBFromGet(newAssessment:PE_AssessmentInProgress,dataToSubmitNumber:Int,param:[String:String]?,formateFromServer:String? = "", rejectionComment:String) {
        print(newAssessment)
        self.deleteOfflineBySubmitId(formateFromServer ?? "")
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentRejected", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(1, forKey: "asyncStatus")
        
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        
        if formateFromServer == "" {
            let date = Date()
            var formate = ""
            if formate == "" {
                
                if regionID == 3{
                    formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
                }
                else
                {
                    formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
                }
            }
            
            let random = newAssessment.serverAssessmentId
            formate = "\(formate)\(random ?? "")"
            formate = formate.replacingOccurrences(of:" ", with: "")
            formate = formate.replacingOccurrences(of:"/", with: "")
            formate = formate.replacingOccurrences(of:":", with: "")
            formate = formate.replacingOccurrences(of:"Z", with: "")
            formate = formate.replacingOccurrences(of:"PM", with: "")
            formate = formate.replacingOccurrences(of:"AM", with: "")
            print(formate)
            assessmentObj.setValue(formate, forKey: "dataToSubmitID")
        } else {
            assessmentObj.setValue(formateFromServer, forKey: "dataToSubmitID")
        }
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        assessmentObj.setValue(currentServerAssessmentId, forKey: "serverAssessmentId")
        
        assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "dataToSubmitNumber")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.assID, forKey: "assID")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(newAssessment.userID, forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.catID, forKey: "catID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(rejectionComment, forKey: "rejectionComment")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
        assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
        assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
        assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
        assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
        assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
        assessmentObj.setValue(newAssessment.images , forKey: "images")
        assessmentObj.setValue(newAssessment.doa , forKey: "doa")
        assessmentObj.setValue(newAssessment.statusType , forKey: "statusType")
        assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
        assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
        //  let noOfEGGS = newAssessment.noOfEggs ?? 0
        assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        let sig = (param?["sig"] ?? "") as String
        let sig2 = (param?["sig2"] ?? "") as String
        assessmentObj.setValue(Int(sig2) , forKey: "sig2")
        assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
        assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
        
        assessmentObj.setValue(Int(sig) , forKey: "sig")
        assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
        assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
        assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
        assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basic, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        assessmentObj.setValue(newAssessment.isEMRequested, forKey: "isEMRequested")
        
        assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
        assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
        assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
        
        do {
            try managedContext.save()
        } catch {
        }
        customerData.append(assessmentObj)
    }
    
    func saveDataToSyncPEInDBFromGet(newAssessment:PE_AssessmentInProgress,dataToSubmitNumber:Int,param:[String:String]?,formateFromServer:String? = "") {
        //        self.deleteOfflineBySubmitId(formateFromServer ?? "")
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInOffline", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(1, forKey: "asyncStatus")
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if formateFromServer == "" {
            let date = Date()
            var formate = ""
            if formate == "" {
                
                if regionID == 3{
                    formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
                }
                else
                {
                    formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
                }
            }
            
            
            //  var formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss") // Set output formate
            let random = newAssessment.serverAssessmentId
            formate = "\(formate)\(random ?? "")"
            formate = formate.replacingOccurrences(of:" ", with: "")
            formate = formate.replacingOccurrences(of:"/", with: "")
            formate = formate.replacingOccurrences(of:":", with: "")
            formate = formate.replacingOccurrences(of:"Z", with: "")
            formate = formate.replacingOccurrences(of:"PM", with: "")
            formate = formate.replacingOccurrences(of:"AM", with: "")
            print(formate)
            assessmentObj.setValue(formate, forKey: "dataToSubmitID")
        } else {
            assessmentObj.setValue(formateFromServer, forKey: "dataToSubmitID")
        }
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        assessmentObj.setValue(currentServerAssessmentId, forKey: "serverAssessmentId")
        
        assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "dataToSubmitNumber")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.assID, forKey: "assID")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(newAssessment.userID, forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.catID, forKey: "catID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
        assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
        assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
        assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
        assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
        assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
        assessmentObj.setValue(newAssessment.images , forKey: "images")
        assessmentObj.setValue(newAssessment.doa , forKey: "doa")
        assessmentObj.setValue(newAssessment.statusType , forKey: "statusType")
        assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
        assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
        //  let noOfEGGS = newAssessment.noOfEggs ?? 0
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        let sig = (param?["sig"] ?? "") as String
        let sig2 = (param?["sig2"] ?? "") as String
        assessmentObj.setValue(Int(sig2) , forKey: "sig2")
        assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
        assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
        
        assessmentObj.setValue(Int(sig) , forKey: "sig")
        assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
        assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
        assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
        assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basic, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        assessmentObj.setValue(newAssessment.isEMRequested, forKey: "isEMRequested")
        
        assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
        assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
        assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
        
        do {
            try managedContext.save()
        } catch {
        }
        customerData.append(assessmentObj)
    }
    
    
    
    func saveDraftDataToSyncPEInDBFromGet(newAssessment:PE_AssessmentInProgress,dataToSubmitNumber:Int,param:[String:String]?,formateFromServer:String? = "") {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInDraft", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(1, forKey: "asyncStatus")
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        if formateFromServer == "" {
            let date = Date()
            var formate = ""
            if formate == "" {
                
                if regionID == 3{
                    formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
                }
                else
                {
                    formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
                }
            }
            
            //  var formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss") // Set output formate
            let random = newAssessment.serverAssessmentId
            formate = "\(formate)\(random ?? "")"
            formate = formate.replacingOccurrences(of:" ", with: "")
            formate = formate.replacingOccurrences(of:"/", with: "")
            formate = formate.replacingOccurrences(of:":", with: "")
            formate = formate.replacingOccurrences(of:"Z", with: "")
            formate = formate.replacingOccurrences(of:"PM", with: "")
            formate = formate.replacingOccurrences(of:"AM", with: "")
            
            print(formate)
            assessmentObj.setValue(formate, forKey: "draftID")
            self.deleteDraftByDrafyNumber(formate)
        } else {
            assessmentObj.setValue(formateFromServer, forKey: "draftID")
            self.deleteDraftByDrafyNumber(formateFromServer ?? "")
        }
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        assessmentObj.setValue(currentServerAssessmentId, forKey: "serverAssessmentId")
        
        
        assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.assID, forKey: "assID")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(newAssessment.userID, forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.catID, forKey: "catID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
        assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
        assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assDetail2, forKey: "assDetail2")
        assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
        assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
        assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
        assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
        assessmentObj.setValue(newAssessment.images , forKey: "images")
        assessmentObj.setValue(newAssessment.doa , forKey: "doa")
        assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
        assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
        //  let noOfEGGS = newAssessment.noOfEggs ?? 0
        let sig = (param?["sig"] ?? "") as String
        let sig2 = (param?["sig2"] ?? "") as String
        assessmentObj.setValue(Int(sig2) , forKey: "sig2")
        assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
        assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        assessmentObj.setValue(Int(sig) , forKey: "sig")
        assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
        assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
        assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
        assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basic, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        
        do {
            try managedContext.save()
        } catch {
        }
        customerData.append(assessmentObj)
    }
    
    
    
    func saveGetDraftDataToSyncPEInDBFromGet(newAssessment:PE_AssessmentInProgress,dataToSubmitNumber:Int,param:[String:String]?,formateFromServer:String? = "",deviceID:String? = "") {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "PE_AssessmentInDraft", in: managedContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        assessmentObj.setValue(1, forKey: "asyncStatus")
        var regionID = Int()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        
        if formateFromServer == "" {
            let date = Date()
            var formate = ""
            if formate == "" {
                
                if regionID == 3{
                    formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss")
                }
                else
                {
                    formate = date.getFormattedDate(format: "dd/MM/YYYY HH:mm:ss")
                }
            }
            
            // var formate = date.getFormattedDate(format: "MM/dd/YYYY HH:mm:ss") // Set output formate
            let random = newAssessment.serverAssessmentId
            formate = "\(formate)\(random ?? "")"
            formate = formate.replacingOccurrences(of:" ", with: "")
            formate = formate.replacingOccurrences(of:"/", with: "")
            formate = formate.replacingOccurrences(of:":", with: "")
            formate = formate.replacingOccurrences(of:"Z", with: "")
            formate = formate.replacingOccurrences(of:"PM", with: "")
            formate = formate.replacingOccurrences(of:"AM", with: "")
            print(formate)
            assessmentObj.setValue(formate, forKey: "draftID")
            self.deleteDraftByDrafyNumber(formate)
        } else {
            assessmentObj.setValue(formateFromServer, forKey: "draftID")
            assessmentObj.setValue(deviceID, forKey: "assDetail2")
        }
        
        assessmentObj.setValue(NSNumber(value:dataToSubmitNumber ), forKey: "draftNumber")
        assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
        assessmentObj.setValue(newAssessment.siteId, forKey: "siteId")
        assessmentObj.setValue(newAssessment.assID, forKey: "assID")
        assessmentObj.setValue(newAssessment.customerId, forKey: "customerId")
        assessmentObj.setValue(newAssessment.complexId, forKey: "complexId")
        assessmentObj.setValue(newAssessment.siteName, forKey: "siteName")
        assessmentObj.setValue(newAssessment.userID, forKey: "userID")
        assessmentObj.setValue(newAssessment.customerName, forKey: "customerName")
        assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
        assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
        assessmentObj.setValue(newAssessment.firstname, forKey: "firstname")
        assessmentObj.setValue(newAssessment.username, forKey: "username")
        assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
        assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
        assessmentObj.setValue(newAssessment.evaluatorID, forKey: "evaluatorID")
        assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
        assessmentObj.setValue(newAssessment.visitID , forKey: "visitID")
        assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
        assessmentObj.setValue(newAssessment.evaluationID , forKey: "evaluationID")
        assessmentObj.setValue(newAssessment.approver, forKey: "approver")
        assessmentObj.setValue(newAssessment.notes, forKey: "notes")
        assessmentObj.setValue(newAssessment.note, forKey: "note")
        let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
        assessmentObj.setValue(hatcheryAntibioticsInt, forKey: "hatcheryAntibiotics")
        let camera = newAssessment.camera == 1 ? 1 : 0
        let flock = newAssessment.isFlopSelected == 1 ? 1:0
        assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
        assessmentObj.setValue(NSNumber(value:flock ), forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.catID, forKey: "catID")
        assessmentObj.setValue(newAssessment.catName, forKey: "catName")
        assessmentObj.setValue(newAssessment.catMaxMark, forKey: "catMaxMark")
        assessmentObj.setValue(newAssessment.catResultMark, forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.catEvaluationID, forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.catISSelected, forKey: "catISSelected")
        assessmentObj.setValue(newAssessment.catEvaluationID , forKey: "catEvaluationID")
        assessmentObj.setValue(newAssessment.assDetail1, forKey: "assDetail1")
        assessmentObj.setValue(newAssessment.assMinScore , forKey: "assMinScore")
        assessmentObj.setValue(newAssessment.assMaxScore , forKey: "assMaxScore")
        assessmentObj.setValue(newAssessment.assCatType, forKey: "assCatType")
        assessmentObj.setValue(newAssessment.assModuleCatID , forKey: "assModuleCatID")
        assessmentObj.setValue(newAssessment.assModuleCatName, forKey: "assModuleCatName")
        assessmentObj.setValue(newAssessment.assStatus , forKey: "assStatus")
        assessmentObj.setValue(newAssessment.sequenceNo , forKey: "sequenceNo")
        assessmentObj.setValue(newAssessment.sequenceNoo , forKey: "sequenceNoo")
        assessmentObj.setValue(newAssessment.images , forKey: "images")
        assessmentObj.setValue(newAssessment.doa , forKey: "doa")
        assessmentObj.setValue(newAssessment.inovoject , forKey: "inovoject")
        assessmentObj.setValue(newAssessment.vMixer , forKey: "vMixer")
        assessmentObj.setValue(newAssessment.isFlopSelected , forKey: "isFlopSelected")
        assessmentObj.setValue(newAssessment.breedOfBird , forKey: "breedOfBird")
        assessmentObj.setValue(newAssessment.breedOfBirdOther , forKey: "breedOfBirdOther")
        assessmentObj.setValue(newAssessment.incubation , forKey: "incubation")
        assessmentObj.setValue(newAssessment.incubationOthers , forKey: "incubationOthers")
        assessmentObj.setValue(newAssessment.catResultMark , forKey: "catResultMark")
        assessmentObj.setValue(newAssessment.noOfEggs, forKey: "noOfEggs")
        assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
        assessmentObj.setValue(newAssessment.iCS, forKey: "iCS")
        assessmentObj.setValue(newAssessment.iDT, forKey: "iDT")
        assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
        assessmentObj.setValue(newAssessment.dCS, forKey: "dCS")
        assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        let sig = (param?["sig"] ?? "") as String
        let sig2 = (param?["sig2"] ?? "") as String
        assessmentObj.setValue(Int(sig2) , forKey: "sig2")
        assessmentObj.setValue(param?["sig_EmpID2"] ?? "", forKey: "sig_EmpID2")
        assessmentObj.setValue(param?["sig_Name2"] ?? "" , forKey: "sig_Name2")
        
        assessmentObj.setValue(Int(sig) , forKey: "sig")
        assessmentObj.setValue(param?["sig_Date"] ?? "", forKey: "sig_Date")
        assessmentObj.setValue(param?["sig_EmpID"] ?? "", forKey: "sig_EmpID")
        assessmentObj.setValue(param?["sig_Name"] ?? "" , forKey: "sig_Name")
        assessmentObj.setValue(param?["sig_Phone"] ?? "", forKey: "sig_Phone")
        assessmentObj.setValue(newAssessment.rejectionComment, forKey: "rejectionComment")
        assessmentObj.setValue(newAssessment.dDT, forKey: "dDT")
        assessmentObj.setValue(newAssessment.micro, forKey: "micro")
        assessmentObj.setValue(newAssessment.residue, forKey: "residue")
        assessmentObj.setValue(newAssessment.informationText, forKey: "informationText")
        assessmentObj.setValue(newAssessment.informationImage, forKey: "informationImage")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaSText, forKey: "hatcheryAntibioticsDoaSText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaText, forKey: "hatcheryAntibioticsDoaText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsText, forKey: "hatcheryAntibioticsText")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoaS, forKey: "hatcheryAntibioticsDoaS")
        assessmentObj.setValue(newAssessment.hatcheryAntibioticsDoa, forKey: "hatcheryAntibioticsDoa")
        assessmentObj.setValue(newAssessment.doaS, forKey: "doaS")
        assessmentObj.setValue(newAssessment.qcCount, forKey: "qcCount")
        assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
        assessmentObj.setValue(newAssessment.dDDT, forKey: "dDDT")
        assessmentObj.setValue(newAssessment.dDCS, forKey: "dDCS")
        assessmentObj.setValue(newAssessment.personName, forKey: "personName")
        assessmentObj.setValue(newAssessment.ampmValue, forKey: "ampmValue")
        assessmentObj.setValue(newAssessment.frequency, forKey: "frequency")
        assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
        assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
        // PE Intrenational Changes
        assessmentObj.setValue(newAssessment.countryName, forKey: "countryName")
        assessmentObj.setValue(newAssessment.countryID, forKey: "countryID")
        assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
        assessmentObj.setValue(newAssessment.basic, forKey: "basic")
        assessmentObj.setValue(newAssessment.isNA, forKey: "isNA")
        assessmentObj.setValue(newAssessment.isAllowNA, forKey: "isAllowNA")
        assessmentObj.setValue(newAssessment.rollOut, forKey: "rollOut")
        assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
        assessmentObj.setValue(newAssessment.qSeqNo, forKey: "qSeqNo")
        
        assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
        assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
        assessmentObj.setValue(newAssessment.isEMRequested, forKey: "isEMRequested")
        
        assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
        
        
        
        assessmentObj.setValue(newAssessment.isPERejected, forKey: "isPERejected")
        assessmentObj.setValue(newAssessment.emRejectedComment, forKey: "emRejectedComment")
        assessmentObj.setValue(newAssessment.isEMRejected, forKey: "isEMRejected")
        
        //  error: Execution was interrupted, reason: internal ObjC exception breakpoint(-5)..
        //  The process has been returned to the state before expression evaluation.
        // Got this issue due to which i have to change the value it to integer tye
        
        do {
            try managedContext.save()
        } catch {
        }
        customerData.append(assessmentObj)
    }
    
    
    func getLastTwoOfflineDataForGraph(siteName:String , customerName:String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "userID == %d", userID)
        
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let resultsGetIs : [NSManagedObject] = []
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                
            }
        }
        catch {
            //   print("Fetch Failed: \(error)")
        }
    }
    
}

//Saving Day of Age
extension CoreDataHandlerPE {
    
    func saveDOAPEModule(assessment: PE_AssessmentInProgress,doaId:Int,inovojectData:InovojectData,fromDoaS:Bool?=false,fromDraft:Bool?=false) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_DayOfAge", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(doaId, forKey: "doaId")
        assessmentObj.setValue(inovojectData.name, forKey: "doaName")
        assessmentObj.setValue(inovojectData.vaccineMan, forKey: "doaVm")
        assessmentObj.setValue(inovojectData.dosage, forKey: "doaDosage")
        assessmentObj.setValue(inovojectData.dilute, forKey: "doaDiluentManufacturer")
        assessmentObj.setValue(inovojectData.bagSizeType, forKey: "doaBagSize")
        assessmentObj.setValue(inovojectData.ampuleSize, forKey: "doaAmpuleSize")
        assessmentObj.setValue(inovojectData.ampulePerBag, forKey: "doaAmpulePerBag")
        do {
            try managedContext.save()
            updateDOACategortIsSelcted(assessment: assessment, doaId: doaId,fromDoaS: fromDoaS,fromDraft:fromDraft)
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func saveDraftDOAPEModule(assessment: PE_AssessmentInProgress,doaId:Int,inovojectData:InovojectData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_DayOfAge", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(doaId, forKey: "doaId")
        assessmentObj.setValue(inovojectData.name, forKey: "doaName")
        assessmentObj.setValue(inovojectData.vaccineMan, forKey: "doaVm")
        assessmentObj.setValue(inovojectData.dosage, forKey: "doaDosage")
        assessmentObj.setValue(inovojectData.dilute, forKey: "doaDiluentManufacturer")
        assessmentObj.setValue(inovojectData.bagSizeType, forKey: "doaBagSize")
        assessmentObj.setValue(inovojectData.ampuleSize, forKey: "doaAmpuleSize")
        assessmentObj.setValue(inovojectData.ampulePerBag, forKey: "doaAmpulePerBag")
        do {
            try managedContext.save()
            //  //   print("PE_DayOfAge---\(CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DayOfAge"))")
            updateDraftDOACategortIsSelcted(assessment: assessment, doaId: doaId)
            //   //   print("PE_AssessmentInProgress---\(CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress"))")
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    ///Identicle implementation of function: saveMinusDraftVMixerPEModule()
    func saveVMixerPEModule(assessment: PE_AssessmentInProgress,id:Int,peCertificateData:PECertificateData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VMixer", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(id, forKey: "vmid")
        assessmentObj.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
        assessmentObj.setValue(peCertificateData.name, forKey: "certificateName")
        
        if let createdById = peCertificateData.certCeatedby {
            assessmentObj.setValue(createdById, forKey: "certCeatedby")
        }
        if let createdByNm = peCertificateData.certCeatedbyName {
            assessmentObj.setValue(createdByNm, forKey: "certCeatedbyName")
        }
        if let src = peCertificateData.source {
            assessmentObj.setValue(src, forKey: "source")
        }
        do {
            try managedContext.save()
            _ = updateUpdateVMixerMinusCategortIsSelcted(assessment: assessment, doaId: id)
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func saveVMixerPEModuleGet(peCertificateData:PECertificateData,evalutionID:Int? = 1 , CategoryID:Int? = 0) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VMixer", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        var certificateID = 0
        certificateID = peCertificateData.id ?? 0
        assessmentObj.setValue(peCertificateData.id, forKey: "vmid")
        assessmentObj.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
        assessmentObj.setValue(peCertificateData.name, forKey: "certificateName")
        assessmentObj.setValue(peCertificateData.isReCert, forKey: "isReCert")
        assessmentObj.setValue(peCertificateData.isCertExpired, forKey: "isCertExpired")
        assessmentObj.setValue(peCertificateData.signatureImg, forKey: "signatureImg")
        assessmentObj.setValue(peCertificateData.fsrSign, forKey: "fsrSign")
        do {
            try managedContext.save()
            _ = updateUpdateVMixerGet(doaId: certificateID,evalutionID: evalutionID , NewCatID:CategoryID)
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func saveDraftVMixerPEModule(assessment: PE_AssessmentInProgress,id:Int,peCertificateData:PECertificateData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_VMixer", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(id, forKey: "vmid")
        assessmentObj.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
        assessmentObj.setValue(peCertificateData.name, forKey: "certificateName")
        assessmentObj.setValue(peCertificateData.isReCert, forKey: "isReCert")
        assessmentObj.setValue(peCertificateData.isCertExpired, forKey: "isCertExpired")
        assessmentObj.setValue(peCertificateData.signatureImg, forKey: "signatureImg")
        assessmentObj.setValue(peCertificateData.vacOperatorId, forKey: "vacOperatorId")
        // assessmentObj.setValue(peCertificateData.vacOperatorId, forKey: "fsrSign")
        
        
        do {
            try managedContext.save()
            //  //   print("PE_DayOfAge---\(CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VMixer"))")
            _ = updateDraftVMixerAddCategortIsSelcted(assessment: assessment, doaId: id)
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    
    func saveInovojectPEModule(assessment: PE_AssessmentInProgress,doaId:Int,inovojectData:InovojectData,fromDraft:Bool?=false) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_DayOfAge", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(doaId, forKey: "doaId")
        assessmentObj.setValue(inovojectData.name, forKey: "doaName")
        assessmentObj.setValue(inovojectData.vaccineMan, forKey: "doaVm")
        assessmentObj.setValue(inovojectData.dosage, forKey: "doaDosage")
        assessmentObj.setValue(inovojectData.dilute, forKey: "doaDiluentManufacturer")
        assessmentObj.setValue(inovojectData.bagSizeType, forKey: "doaBagSize")
        assessmentObj.setValue(inovojectData.ampuleSize, forKey: "doaAmpuleSize")
        assessmentObj.setValue(inovojectData.ampulePerBag, forKey: "doaAmpulePerBag")
        
        assessmentObj.setValue(inovojectData.invoHatchAntibioticText, forKey: "invoHatchAntibioticText")
        assessmentObj.setValue(inovojectData.invoProgramName, forKey: "invoProgramName")
        assessmentObj.setValue(inovojectData.doaDilManOther, forKey: "doaDilManOther")
        assessmentObj.setValue(inovojectData.invoHatchAntibiotic, forKey: "invoHatchAntibiotic")
        assessmentObj.setValue(inovojectData.bagSizeType, forKey: "bagSizeType")
        do {
            try managedContext.save()
            updateInovojectCategortIsSelcted(assessment: assessment, doaId: doaId,fromDraft:fromDraft)
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func saveDraftInovojectPEModule(assessment: PE_AssessmentInProgress,doaId:Int,inovojectData:InovojectData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "PE_DayOfAge", in: appDelegate!.managedObjectContext)
        let assessmentObj = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        assessmentObj.setValue(doaId, forKey: "doaId")
        assessmentObj.setValue(inovojectData.name, forKey: "doaName")
        assessmentObj.setValue(inovojectData.vaccineMan, forKey: "doaVm")
        assessmentObj.setValue(inovojectData.dosage, forKey: "doaDosage")
        assessmentObj.setValue(inovojectData.dilute, forKey: "doaDiluentManufacturer")
        assessmentObj.setValue(inovojectData.bagSizeType, forKey: "doaBagSize")
        assessmentObj.setValue(inovojectData.ampuleSize, forKey: "doaAmpuleSize")
        assessmentObj.setValue(inovojectData.ampulePerBag, forKey: "doaAmpulePerBag")
        do {
            try managedContext.save()
            _ = updateDraftInovojectCategortIsSelcted(assessment: assessment, doaId: doaId)
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func updateDraftDOACategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: catIdStr, argumentArray: [assessment.catID])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "doa")  as? [Int] ?? []
                    imagesPreviousArray.append(doaId)
                    result.setValue(imagesPreviousArray, forKey: "doa")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
        
    }
    
    func updateDOACategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int,fromDoaS:Bool?=false,fromDraft:Bool?=false) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft ?? false {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        fetchRequest.returnsObjectsAsFaults = false
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID ?? 0,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    if fromDoaS ?? false {
                        var imagesPreviousArray =  result.value(forKey: "doaS")  as? [Int] ?? []
                        imagesPreviousArray.append(doaId)
                        result.setValue(imagesPreviousArray, forKey: "doaS")
                    } else {
                        var imagesPreviousArray =  result.value(forKey: "doa")  as? [Int] ?? []
                        imagesPreviousArray.append(doaId)
                        result.setValue(imagesPreviousArray, forKey: "doa")
                    }
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
        
    }
    
    
    func updateInovojectCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int,fromDraft:Bool? = false) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft ?? false {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        fetchRequest.returnsObjectsAsFaults = false
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "inovoject")  as? [Int] ?? []
                    imagesPreviousArray.append(doaId)
                    result.setValue(imagesPreviousArray, forKey: "inovoject")
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
        
    }
    
    //srj
    
    func updateDraftInovojectCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: catIdStr, argumentArray: [assessment.catID])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "inovoject")  as? [Int] ?? []
                    imagesPreviousArray.append(doaId)
                    result.setValue(imagesPreviousArray, forKey: "inovoject")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateDOAMinusCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int,fromDraft:Bool? = false,fromDoaS:Bool? = false) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft == true {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        fetchRequest.returnsObjectsAsFaults = false
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID ?? 0,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    if fromDoaS ?? false {
                        var imagesPreviousArray =  result.value(forKey: "doaS")  as? [Int] ?? []
                        imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                        result.setValue(imagesPreviousArray, forKey: "doaS")
                    } else {
                        var imagesPreviousArray =  result.value(forKey: "doa")  as? [Int] ?? []
                        imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                        result.setValue(imagesPreviousArray, forKey: "doa")
                    }
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
            
        }
        catch {
            
        }
    }
    
    
    func updateDraftVMixerAddCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: catIdStr, argumentArray: [assessment.catID])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "vMixer")  as? [Int] ?? []
                    
                    imagesPreviousArray.append(doaId)
                    //   imagesPreviousArray.remove(at: <#T##[Int]#>)(doaId)
                    //   imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                    result.setValue(imagesPreviousArray, forKey: "vMixer")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateUpdateVMixerGet(doaId: Int,evalutionID:Int? = 1 , NewCatID:Int? = 1) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        
        if evalutionID != 1 {
            fetchRequest.predicate = NSPredicate(format: catIdServerAssId2, 30,currentServerAssessmentId)
            
        } else {
            let countryId = UserDefaults.standard.integer(forKey: "Regionid")
            
            if countryId != 3 {
                fetchRequest.predicate = NSPredicate(format: catIdServerAssId2, NewCatID ?? 0,currentServerAssessmentId)
            }
            else{
                fetchRequest.predicate = NSPredicate(format: catIdServerAssId2, evalutionID ?? 0,currentServerAssessmentId)
            }
        }
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "vMixer")  as? [Int] ?? []
                    imagesPreviousArray.append(doaId)
                    result.setValue(imagesPreviousArray, forKey: "vMixer")
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func updateUpdateVMixerMinusCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID,currentServerAssessmentId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "vMixer")  as? [Int] ?? []
                    imagesPreviousArray.append(doaId)
                    result.setValue(imagesPreviousArray, forKey: "vMixer")
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func subtractVMixerMinusCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "vMixer")  as? [Int] ?? []
                    imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                    result.setValue(imagesPreviousArray, forKey: "vMixer")
                    
                }
            }
        } catch {
            
        }
        do {
            try managedContext.save()
            return true
        }
        catch {
            return false
        }
    }
    
    //Same implementation of function: subtractVMixerMinusCategortIsSelctedDraft()
    func updateDraftVMixerMinusCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: catIdStr, argumentArray: [assessment.catID])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "vMixer")  as? [Int] ?? []
                    imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                    result.setValue(imagesPreviousArray, forKey: "vMixer")
                }
            }
        } catch {
        }
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func updateInovojectMinusCategortIsSelcted(assessment: PE_AssessmentInProgress, doaId: Int,fromDraft:Bool? = false)  {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if fromDraft == true {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        fetchRequest.returnsObjectsAsFaults = false
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: catIdServerAssId, argumentArray: [assessment.catID,currentServerAssessmentId])
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? []{
                    var imagesPreviousArray =  result.value(forKey: "inovoject")  as? [Int] ?? []
                    imagesPreviousArray.index(of: doaId).map { imagesPreviousArray.remove(at: $0) }
                    result.setValue(imagesPreviousArray, forKey: "inovoject")
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        do {
            try managedContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
    }
        
    func getPEDOAData(doaId: Int) -> InovojectData? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_DayOfAge")
        fetchRequest.predicate = NSPredicate(format: "doaId == %d", doaId)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
            guard let result = fetchedResults?.first else { return nil }
            
            let doaId = result.value(forKey: "doaId") as? Int ?? 0
            let name = result.value(forKey: "doaName") as? String ?? ""
            let vaccineMan = result.value(forKey: "doaVm") as? String ?? ""
            let dosage = result.value(forKey: "doaDosage") as? String ?? ""
            let dilute = result.value(forKey: "doaDiluentManufacturer") as? String ?? ""
            let bagSizeType = result.value(forKey: "doaBagSize") as? String ?? ""
            let ampuleSize = result.value(forKey: "doaAmpuleSize") as? String ?? ""
            let ampulePerBag = result.value(forKey: "doaAmpulePerBag") as? String ?? ""
            let invoHatchAntibiotic = result.value(forKey: "invoHatchAntibiotic") as? Int ?? 0
            let invoHatchAntibioticText = result.value(forKey: "invoHatchAntibioticText") as? String ?? ""
            let invoProgramName = result.value(forKey: "invoProgramName") as? String ?? ""
            let doaDilManOther = result.value(forKey: "doaDilManOther") as? String ?? ""
            
            
            let info = CoreDataHandlerPEModels.InovojectInfo(
                 id: doaId,
                 vaccineMan: vaccineMan,
                 name: name,
                 ampuleSize: ampuleSize,
                 ampulePerBag: ampulePerBag,
                 bagSizeType: bagSizeType,
                 dosage: dosage,
                 dilute: dilute,
                 invoHatchAntibiotic: invoHatchAntibiotic,
                 invoHatchAntibioticText: invoHatchAntibioticText,
                 invoProgramName: invoProgramName,
                 doaDilManOther: doaDilManOther
                          
              )
              let inovojectData = InovojectData(info: info)
              return inovojectData
            
        } catch {
            print("Fetch error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func getCertificateData(doaId:Int) -> PECertificateData? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VMixer")
        fetchRequest.predicate = NSPredicate(format: vmID, doaId)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let result = fetchedResult?.first else { return nil }
            
            let doaId = result.value(forKey: "vmid") as? Int ?? 0
            let name = result.value(forKey: "certificateName") as? String ?? ""
            let certificateDate = result.value(forKey: "certificateDate") as? String ?? ""
            let isManuallyAdded = result.value(forKey: "isManuallyAdded") as? Bool ?? false
            let isCertExpired = result.value(forKey: "isCertExpired") as? Bool ?? false
            let isReCert = result.value(forKey: "isReCert") as? Bool ?? false
            let signatureImg = result.value(forKey: "signatureImg") as? String ?? ""
            let vacOperatorId = result.value(forKey: "vacOperatorId") as? Int ?? 0
            let fsrSign = result.value(forKey: "fsrSign") as? String ?? ""
            
            let certCreatedById = result.value(forKey: "certCeatedby") as? Int ?? 0
            let certCreatedByName = result.value(forKey: "certCeatedbyName") as? String ?? ""
            let source = result.value(forKey: "source") as? String ?? ""

//            if let createdById = peCertificateData.certCeatedby {
//                assessmentObj.setValue(createdById, forKey: "certCeatedby")
//            }
//            if let createdByNm = peCertificateData.certCeatedbyName {
//                assessmentObj.setValue(createdByNm, forKey: "certCeatedbyName")
//            }
//            if let src = peCertificateData.source {
//                assessmentObj.setValue(src, forKey: "source")
//            }
            let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id: doaId, name: name, date: certificateDate, isCertExpired: isCertExpired, isReCert: isReCert, vacOperatorId: vacOperatorId, signatureImg: signatureImg, fsrSign: fsrSign,certCeatedbyName: certCreatedByName,source: source,certCeatedby: certCreatedById,isManuallyAdded: isManuallyAdded)
            
            let data = PECertificateData(info: certificModel)
            
            return data
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return nil
    }
    
    func updateDOAInDB(inovojectData: InovojectData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_DayOfAge")
        guard let doaId = inovojectData.id else { return }
        fetchRequest.predicate = NSPredicate(format: "doaId == %d", doaId)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject],
               let result = results.first {
                result.setValue(inovojectData.id, forKey: "doaId")
                result.setValue(inovojectData.name, forKey: "doaName")
                result.setValue(inovojectData.vaccineMan, forKey: "doaVm")
                result.setValue(inovojectData.dosage, forKey: "doaDosage")
                result.setValue(inovojectData.dilute, forKey: "doaDiluentManufacturer")
                result.setValue(inovojectData.bagSizeType, forKey: "doaBagSize")
                result.setValue(inovojectData.ampuleSize, forKey: "doaAmpuleSize")
                result.setValue(inovojectData.ampulePerBag, forKey: "doaAmpulePerBag")
                result.setValue(inovojectData.invoHatchAntibioticText, forKey: "invoHatchAntibioticText")
                result.setValue(inovojectData.invoProgramName, forKey: "invoProgramName")
                result.setValue(inovojectData.doaDilManOther, forKey: "doaDilManOther")
                result.setValue(inovojectData.invoHatchAntibiotic, forKey: "invoHatchAntibiotic")
                result.setValue(inovojectData.bagSizeType, forKey: "bagSizeType")
                try context.save()
            }
        } catch {
            print("Failed to update DOA: \(error.localizedDescription)")
            NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil)
        }
    }
    
    func updateVMixerInDB(peCertificateData:PECertificateData,id:Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VMixer")
        fetchRequest.predicate = NSPredicate(format: vmID, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? [] {
                    result.setValue(id, forKey: "vmid")
                    result.setValue(peCertificateData.name, forKey: "certificateName")
                    if peCertificateData.certificateDate == "" {
                        result.setValue(true, forKey: "isReCert")
                    } else {
                        result.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
                        result.setValue(peCertificateData.isReCert, forKey: "isReCert")
                    }
                }
            }
            do {
                try managedContext.save()
            } catch {
            }
        } catch {
            
        }
        
    }
    //id:0,name:"",date:"",isCertExpired: false,isReCert: false,vacOperatorId: 0, signatureImg: ""
    func updateVMixerNewInDB(peCertificateData:PECertificateData,id:Int) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VMixer")
        fetchRequest.predicate = NSPredicate(format: vmID, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? [] {
                    result.setValue(id, forKey: "vmid")
                    result.setValue(peCertificateData.isManuallyAdded, forKey: "isManuallyAdded")
                    result.setValue(peCertificateData.name, forKey: "certificateName")
                    result.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
                    result.setValue(peCertificateData.isCertExpired, forKey: "isCertExpired")
                    result.setValue(peCertificateData.signatureImg, forKey: "signatureImg")
                    result.setValue(peCertificateData.fsrSign, forKey: "fsrSign")
                    result.setValue(peCertificateData.vacOperatorId, forKey: "vacOperatorId")
                    
                    if let createdById = peCertificateData.certCeatedby {
                        result.setValue(createdById, forKey: "certCeatedby")
                    }
                    if let createdByNm = peCertificateData.certCeatedbyName {
                        result.setValue(createdByNm, forKey: "certCeatedbyName")
                    }
                    if let src = peCertificateData.source {
                        result.setValue(src, forKey: "source")
                    }
                    
                    if let fsrSign = UserDefaults.standard.value(forKey: "FsrSign") as? String {
                        //  fSRSign = fsrSign
                        peCertificateData.fsrSign = fsrSign
                        UserDefaults.standard.set(nil, forKey: "FsrSign")
                        UserDefaults.standard.set(false, forKey: "isSignedFSR")
                    }
                    
                    
                }
            } 
            do {
                try managedContext.save()
            } catch {
            }
        } catch {
            
            
        }
        
    }
    
    
    func updateVMixerNewInDBandReplaceNewID(peCertificateData:PECertificateData,id:Int , replaceNewID : Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VMixer")
        fetchRequest.predicate = NSPredicate(format: vmID, id)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for result in results ?? [] {
                    result.setValue(replaceNewID, forKey: "vmid")
                    result.setValue(peCertificateData.name, forKey: "certificateName")
                    result.setValue(peCertificateData.certificateDate, forKey: "certificateDate")
                    result.setValue(peCertificateData.isReCert, forKey: "isReCert")
                    result.setValue(peCertificateData.isCertExpired, forKey: "isCertExpired")
                    result.setValue(peCertificateData.signatureImg, forKey: "signatureImg")
                    result.setValue(peCertificateData.fsrSign, forKey: "fsrSign")
                    if let fsrSign = UserDefaults.standard.value(forKey: "FsrSign") as? String {
                        //  fSRSign = fsrSign
                        peCertificateData.fsrSign = fsrSign
                        UserDefaults.standard.set(nil, forKey: "FsrSign")
                        UserDefaults.standard.set(false, forKey: "isSignedFSR")
                    }
                    
                    
                }
            }
            do {
                try managedContext.save()
            } catch {
            }
        } catch {
            
        }
        
    }
    func updateAlreadyInProgressInDB(newAssessment:PENewAssessment) {
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        fetchRequest.predicate = NSPredicate(format: serverAssessmentId, currentServerAssessmentId)
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            //            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            let res = try? managedContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if let results = res, results.count != 0 {
                for result in results {
                    let assessmentObj: PE_AssessmentInProgress = (result )//as? PE_AssessmentInProgress)!
                    assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
                    assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
                    assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
                    assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
                    assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
                    assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
                    assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
                    assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
                    assessmentObj.setValue(newAssessment.approver, forKey: "approver")
                    assessmentObj.setValue(newAssessment.notes, forKey: "notes")
                    assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
                    assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                    assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                    let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    let camera = newAssessment.camera == 1 ? 1 : 0
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
                    assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
                    assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
                    assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
                    assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
                    assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
                    assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
                    assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
                    assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
                    assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
                    assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
                    assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
                    assessmentObj.setValue(NSNumber(value:newAssessment.countryID ?? 0), forKey: "countryID")
                    assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
                    assessmentObj.setValue(NSNumber(value:newAssessment.clorineId ?? 0), forKey: "clorineId")
                    assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
                    assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
                    assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                    assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                    do {
                        try managedContext.save()
                    } catch {
                    }
                }
                
            }
            do {
                try managedContext.save()
            } catch {
            }
        }
    }
    
    func updateDraftAlreadyInProgressInDB(newAssessment:PENewAssessment) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.predicate = NSPredicate(format: draftNo, newAssessment.draftNumber ?? 0)
        
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        fetchRequest.predicate = NSPredicate(format: serverUserId, userID,currentServerAssessmentId)
        
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let res = try appDelegate?.managedObjectContext.fetch(fetchRequest) as? [PE_AssessmentInProgress]
            if let results = res, results.count != 0 {
                for result in results {
                    let assessmentObj: PE_AssessmentInProgress = (result)// as? PE_AssessmentInProgress)!
                    assessmentObj.setValue(newAssessment.serverAssessmentId, forKey: "serverAssessmentId")
                    assessmentObj.setValue(0, forKey: "asyncStatus")
                    assessmentObj.setValue(newAssessment.selectedTSR, forKey: "selectedTSR")
                    assessmentObj.setValue(newAssessment.selectedTSRID, forKey: "selectedTSRID")
                    assessmentObj.setValue(NSNumber(value:newAssessment.userID ?? 0), forKey: "userID")
                    assessmentObj.setValue(newAssessment.evaluationDate, forKey: "evaluationDate")
                    assessmentObj.setValue(newAssessment.evaluatorName, forKey: "evaluatorName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluatorID ?? 0), forKey: "evaluatorID")
                    assessmentObj.setValue(newAssessment.visitName, forKey: "visitName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.visitID ?? 0), forKey: "visitID")
                    assessmentObj.setValue(newAssessment.evaluationName, forKey: "evaluationName")
                    assessmentObj.setValue(NSNumber(value:newAssessment.evaluationID ?? 0), forKey: "evaluationID")
                    assessmentObj.setValue(newAssessment.approver, forKey: "approver")
                    assessmentObj.setValue(newAssessment.notes, forKey: "notes")
                    assessmentObj.setValue(newAssessment.statusType, forKey: "statusType")
                    let hatcheryAntibioticsInt = newAssessment.hatcheryAntibiotics ?? 0
                    assessmentObj.setValue(NSNumber(value:hatcheryAntibioticsInt), forKey: "hatcheryAntibiotics")
                    assessmentObj.setValue(newAssessment.isChlorineStrip, forKey: "isChlorineStrip")
                    assessmentObj.setValue(newAssessment.isAutomaticFail, forKey: "isAutomaticFail")
                    let camera = newAssessment.camera == 1 ? 1 : 0
                    assessmentObj.setValue(NSNumber(value:camera ), forKey: "camera")
                    assessmentObj.setValue(newAssessment.isFlopSelected, forKey: "isFlopSelected")
                    assessmentObj.setValue(newAssessment.breedOfBird, forKey: "breedOfBird")
                    assessmentObj.setValue(newAssessment.breedOfBirdOther, forKey: "breedOfBirdOther")
                    assessmentObj.setValue(newAssessment.incubation, forKey: "incubation")
                    assessmentObj.setValue(newAssessment.incubationOthers, forKey: "incubationOthers")
                    assessmentObj.setValue(NSNumber(value:newAssessment.noOfEggs ?? 0), forKey: "noOfEggs")
                    assessmentObj.setValue(newAssessment.manufacturer, forKey: "manufacturer")
                    // PE International Changes
                    assessmentObj.setValue(newAssessment.countryName, forKey: Constants.countryNamStrSmall)
                    assessmentObj.setValue(NSNumber(value:newAssessment.countryID ?? 0), forKey: "countryID")
                    assessmentObj.setValue(newAssessment.basicTransfer, forKey: "basic")
                    assessmentObj.setValue(newAssessment.fluid, forKey: "fluid")
                    assessmentObj.setValue(newAssessment.extndMicro, forKey: "extndMicro")
                    assessmentObj.setValue(newAssessment.refrigeratorNote, forKey: "refrigeratorNote")
                    
                    assessmentObj.setValue(newAssessment.clorineName, forKey: "clorineName")
                    assessmentObj.setValue(newAssessment.clorineId, forKey: "clorineId")
                    assessmentObj.setValue(newAssessment.isHandMix, forKey: "isHandMix")
                    assessmentObj.setValue(newAssessment.ppmValue, forKey: "ppmValue")
                    assessmentObj.setValue(newAssessment.sanitationValue, forKey: "sanitationValue")
                    do {
                        try managedContext.save()
                        
                    } catch {
                    }
                }
                
            }
            do {
                try managedContext.save()
            } catch {
            }
        } catch {
            //   print("Fetch Failed: \(error)")
            
        }
        
    }
}



extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}





//PE_AssessmentInOffline

extension CoreDataHandlerPE {
    
    func getOnGoingAssessmentArrayPEObject(isFromDraft:Bool? = false, serverAssessmentId:String) -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        if isFromDraft == true {
            fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        }
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: serverUserId, userID, serverAssessmentId)
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.serverAssessmentId = result.value(forKey: "serverAssessmentId")  as? String ?? ""
                    if isFromDraft == true {
                        peNewAssessment.draftID = result.value(forKey: "draftID")  as? String ?? ""
                        peNewAssessment.draftNumber = result.value(forKey: "draftNumber")  as? Int ?? 0
                    }
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    
                    
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    
                    peNewAssessment.noOfEggs = result.value(forKey: "noOfEggs") as? Int64 ?? 0
                    
                    peNewAssessment.manufacturer = result.value(forKey: "manufacturer") as? String ?? ""
                    
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR") as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    
                    
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                    let hatcheryAntibioticsDoa =  result.value(forKey: "hatcheryAntibioticsDoa")   as? Int
                    peNewAssessment.hatcheryAntibioticsDoa = hatcheryAntibioticsDoa ?? 0
                    let hatcheryAntibioticsDoaS =  result.value(forKey: "hatcheryAntibioticsDoaS")   as? Int
                    peNewAssessment.hatcheryAntibioticsDoaS = hatcheryAntibioticsDoaS ?? 0
                    let hatcheryAntibioticsDoaSText =  result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaSText = hatcheryAntibioticsDoaSText
                    let hatcheryAntibioticsDoaText =  result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = hatcheryAntibioticsDoaText
                    let hatcheryAntibioticsText =  result.value(forKey: "hatcheryAntibioticsText")   as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = hatcheryAntibioticsText
                    
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.informationText = result.value(forKey: "informationText") as? String ?? ""
                    let camera =  result.value(forKey: "camera")  as? Int
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.micro = result.value(forKey: "micro") as? String ?? ""
                    peNewAssessment.residue = result.value(forKey: "residue") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.dCS = result.value(forKey: "dCS") as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS") as? String ?? ""
                    peNewAssessment.dDT = result.value(forKey: "dDT") as? String ?? ""
                    peNewAssessment.dDDT = result.value(forKey: "dDDT") as? String ?? ""
                    peNewAssessment.iCS = result.value(forKey: "iCS") as? String ?? ""
                    peNewAssessment.iDT = result.value(forKey: "iDT") as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName") as? String ?? ""
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.qcCount = result.value(forKey: "qcCount") as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue") as? String ?? ""
                    peNewAssessment.frequency = result.value(forKey: "frequency") as? String ?? ""
                    peNewAssessment.sanitationValue = result.value(forKey: "sanitationValue") as? Bool ?? false
                    
                    // PE Intrenational Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic") as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro") as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo") as? Int ?? 0
                    
                    // PE Intrenational Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested")  as? Bool ?? false
                    
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected")  as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected")  as? Bool ?? false
                    
                    
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    peNewAssessmentArray.append(peNewAssessment)
                    
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
    
    func getAssessmentInProgressObject()-> PE_AssessmentInProgress{
        let vaccinationCertObj = NSEntityDescription.insertNewObject(forEntityName: "PE_AssessmentInProgress" , into: managedContext) as! PE_AssessmentInProgress
        return vaccinationCertObj
        //vaccinationCertObj.user
        
    }
    
    func getSavedOnGoingAssessmentPEObject(serverAssessmentId:String,createNewObject:Bool=false) -> PENewAssessment {
        let peNewAssessment = PENewAssessment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: serverUserId, userID,serverAssessmentId)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                if results.count > 0{
                    var dataArray = results as NSArray
                    var userIDArray = dataArray.value(forKey: "userID")  as? NSArray ?? []
                    peNewAssessment.userID = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "serverAssessmentId")  as? NSArray ?? []
                    peNewAssessment.serverAssessmentId = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "complexId")  as? NSArray ?? []
                    peNewAssessment.complexId = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "draftNumber")  as? NSArray ?? []
                    peNewAssessment.draftNumber = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "customerId")  as? NSArray ?? []
                    peNewAssessment.customerId = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "siteId")  as? NSArray ?? []
                    peNewAssessment.siteId = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "siteName")  as? NSArray ?? []
                    peNewAssessment.siteName = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "customerName")  as? NSArray ?? []
                    peNewAssessment.customerName = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "firstname")  as? NSArray ?? []
                    peNewAssessment.firstname = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "evaluationDate")  as? NSArray ?? []
                    peNewAssessment.evaluationDate = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "evaluatorName")  as? NSArray ?? []
                    peNewAssessment.evaluatorName = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "evaluatorID")  as? NSArray ?? []
                    peNewAssessment.evaluatorID = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "visitName")  as? NSArray ?? []
                    peNewAssessment.visitName = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "visitID")  as? NSArray ?? []
                    peNewAssessment.visitID = userIDArray.firstObject  as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "evaluationName")  as? NSArray ?? []
                    peNewAssessment.evaluationName = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "evaluationID")  as? NSArray ?? []
                    peNewAssessment.evaluationID = userIDArray.firstObject  as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "approver")  as? NSArray ?? []
                    peNewAssessment.approver = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "isChlorineStrip")  as? NSArray ?? []
                    peNewAssessment.isChlorineStrip = userIDArray.firstObject  as? Int ?? 0
                    
                    userIDArray = dataArray.value(forKey: "isAutomaticFail")  as? NSArray ?? []
                    peNewAssessment.isAutomaticFail = userIDArray.firstObject  as? Int ?? 0
                    
                    userIDArray = dataArray.value(forKey: "qcCount")  as? NSArray ?? []
                    peNewAssessment.qcCount = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "isHandMix")  as? NSArray ?? []
                    peNewAssessment.isHandMix = userIDArray.firstObject   as? Bool ?? false
                    
                    userIDArray = dataArray.value(forKey: "ppmValue")  as? NSArray ?? []
                    peNewAssessment.ppmValue = userIDArray.firstObject   as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "personName")  as? NSArray ?? []
                    peNewAssessment.personName = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "ampmValue")  as? NSArray ?? []
                    peNewAssessment.ampmValue = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "frequency")  as? NSArray ?? []
                    peNewAssessment.frequency = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "isNA")  as? NSArray ?? []
                    peNewAssessment.isNA = userIDArray.firstObject as? Bool ?? false
                    
                    
                    userIDArray = dataArray.value(forKey: "isAllowNA")  as? NSArray ?? []
                    peNewAssessment.isAllowNA = userIDArray.firstObject as? Bool ?? false
                    
                    
                    userIDArray = dataArray.value(forKey: "qSeqNo")  as? NSArray ?? []
                    peNewAssessment.qSeqNo = userIDArray.firstObject as? Int ?? 0
                    
                    userIDArray = dataArray.value(forKey: "rollOut")  as? NSArray ?? []
                    peNewAssessment.rollOut = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "notes")  as? NSArray ?? []
                    peNewAssessment.notes = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "hatcheryAntibiotics")  as? NSArray ?? []
                    let hatcheryAntibiotics =  userIDArray.firstObject as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                    
                    userIDArray = dataArray.value(forKey: "hatcheryAntibioticsText")  as? NSArray ?? []
                    let hatcheryAntibioticsText =  userIDArray.firstObject as? String
                    peNewAssessment.hatcheryAntibioticsText = hatcheryAntibioticsText ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoa")  as? NSArray ?? []
                    let hatcheryAntibioticsDoa =  userIDArray.firstObject as? Int
                    peNewAssessment.hatcheryAntibioticsDoa = hatcheryAntibioticsDoa ?? 0
                    
                    userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaText")  as? NSArray ?? []
                    let hatcheryAntibioticsDoaText =  userIDArray.firstObject as? String
                    peNewAssessment.hatcheryAntibioticsDoaText
                    = hatcheryAntibioticsDoaText ?? ""
                    
                    userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaS")  as? NSArray ?? []
                    let hatcheryAntibioticsDoaS =  userIDArray.firstObject as? Int
                    peNewAssessment.hatcheryAntibioticsDoaS = hatcheryAntibioticsDoaS ?? 0
                    
                    userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaSText")  as? NSArray ?? []
                    let hatcheryAntibioticsDoaSText =  userIDArray.firstObject as? String
                    peNewAssessment.hatcheryAntibioticsDoaSText
                    = hatcheryAntibioticsDoaSText ?? ""
                    
                    userIDArray = dataArray.value(forKey: "camera")  as? NSArray ?? []
                    let camera =  userIDArray.firstObject as? Int
                    peNewAssessment.camera = camera
                    userIDArray = dataArray.value(forKey: "selectedTSR")  as? NSArray ?? []
                    peNewAssessment.selectedTSR = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "selectedTSRID")  as? NSArray ?? []
                    peNewAssessment.selectedTSRID = userIDArray.firstObject as? Int ?? 0
                    
                    userIDArray = dataArray.value(forKey: "isFlopSelected")  as? NSArray ?? []
                    let isFlopSelected =  userIDArray.firstObject as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected
                    userIDArray = dataArray.value(forKey: "breedOfBird")  as? NSArray ?? []
                    peNewAssessment.breedOfBird = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "breedOfBirdOther")  as? NSArray ?? []
                    peNewAssessment.breedOfBirdOther = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "incubation")  as? NSArray ?? []
                    peNewAssessment.incubation = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "incubationOthers")  as? NSArray ?? []
                    peNewAssessment.incubationOthers = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "note")  as? NSArray ?? []
                    peNewAssessment.note = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "images")  as? NSArray ?? []
                    peNewAssessment.images = userIDArray.firstObject as? [Int] ?? []
                    userIDArray = dataArray.value(forKey: "doa")  as? NSArray ?? []
                    peNewAssessment.doa = userIDArray.firstObject as? [Int] ?? []
                    
                    userIDArray = dataArray.value(forKey: "doaS")  as? NSArray ?? []
                    peNewAssessment.doaS = userIDArray.firstObject as? [Int] ?? []
                    
                    userIDArray = dataArray.value(forKey: "statusType")  as? NSArray ?? []
                    peNewAssessment.statusType = userIDArray.firstObject as? Int ?? 0
                    
                    userIDArray = dataArray.value(forKey: "sequenceNo")  as? NSArray ?? []
                    peNewAssessment.sequenceNo = userIDArray.firstObject  as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "sequenceNoo")  as? NSArray ?? []
                    peNewAssessment.sequenceNoo = userIDArray.firstObject  as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "informationText")  as? NSArray ?? []
                    peNewAssessment.informationText = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "informationImage")  as? NSArray ?? []
                    peNewAssessment.informationImage = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "manufacturer")  as? NSArray ?? []
                    peNewAssessment.manufacturer = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "noOfEggs")  as? NSArray ?? []
                    peNewAssessment.noOfEggs = userIDArray.firstObject as? Int64 ?? 0
                    
                    userIDArray = dataArray.value(forKey: "iCS")  as? NSArray ?? []
                    peNewAssessment.iCS = userIDArray.firstObject as? String ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "iDT")  as? NSArray ?? []
                    peNewAssessment.iDT = userIDArray.firstObject as? String ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "dCS")  as? NSArray ?? []
                    peNewAssessment.dCS = userIDArray.firstObject as? String ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "dDT")  as? NSArray ?? []
                    peNewAssessment.dDT = userIDArray.firstObject as? String ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "dDCS")  as? NSArray ?? []
                    peNewAssessment.dDCS = userIDArray.firstObject as? String ?? ""
                    
                    
                    userIDArray = dataArray.value(forKey: "dDDT")  as? NSArray ?? []
                    peNewAssessment.dDDT = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "micro")  as? NSArray ?? []
                    peNewAssessment.micro = userIDArray.firstObject as? String ?? ""
                    userIDArray = dataArray.value(forKey: "residue")  as? NSArray ?? []
                    peNewAssessment.residue = userIDArray.firstObject as? String ?? ""
                    
                    // PE Inte. Changes
                    userIDArray = dataArray.value(forKey: "countryID")  as? NSArray ?? []
                    peNewAssessment.countryID = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: Constants.countryNamStrSmall)  as? NSArray ?? []
                    peNewAssessment.countryName = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "isEMRequested")  as? NSArray ?? []
                    peNewAssessment.IsEMRequested = userIDArray.firstObject as? Bool ?? false
                    
                    userIDArray = dataArray.value(forKey: "isHandMix")  as? NSArray ?? []
                    peNewAssessment.isHandMix = userIDArray.firstObject as? Bool ?? false
                    
                    userIDArray = dataArray.value(forKey: "isEMRejected")  as? NSArray ?? []
                    peNewAssessment.isEMRejected = userIDArray.firstObject as? Bool ?? false
                    
                    userIDArray = dataArray.value(forKey: "isPERejected")  as? NSArray ?? []
                    peNewAssessment.isPERejected = userIDArray.firstObject as? Bool ?? false
                    
                    userIDArray = dataArray.value(forKey: "emRejectedComment")  as? NSArray ?? []
                    peNewAssessment.emRejectedComment = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "sanitationValue")  as? NSArray ?? []
                    peNewAssessment.sanitationValue = userIDArray.firstObject as? Bool ?? false
                    
                    // PE Inte. Changes
                    userIDArray = dataArray.value(forKey: "clorineId")  as? NSArray ?? []
                    peNewAssessment.clorineId = userIDArray.firstObject as? Int ?? 0
                    userIDArray = dataArray.value(forKey: "clorineName")  as? NSArray ?? []
                    peNewAssessment.clorineName = userIDArray.firstObject as? String ?? ""
                    
                    userIDArray = dataArray.value(forKey: "fluid")  as? NSArray ?? []
                    peNewAssessment.fluid = userIDArray.firstObject as? Bool ?? false
                    userIDArray = dataArray.value(forKey: "basic")  as? NSArray ?? []
                    peNewAssessment.basicTransfer = userIDArray.firstObject as? Bool ?? false
                    userIDArray = dataArray.value(forKey: "extndMicro")  as? NSArray ?? []
                    peNewAssessment.extndMicro = userIDArray.firstObject as? Bool ?? false
                    userIDArray = dataArray.value(forKey: "refrigeratorNote")  as? NSArray ?? []
                    peNewAssessment.refrigeratorNote = userIDArray.firstObject as? String ?? ""
                }else{
                    if createNewObject {
                        let obj = getAssessmentInProgressObject()
                        obj.userID = userID as NSNumber
                        obj.serverAssessmentId = serverAssessmentId
                        
                        do {
                            try managedContext.save()
                        } catch {
                            managedContext.rollback()
                            print("error executing fetch request: \(error)")
                        }
                        
                        peNewAssessment.userID = userID
                        // peNewAssessment.serverAssessmentId = serverAssessmentId
                    }
                }
                
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return peNewAssessment
    }
    
    
    
    func getSavedOnGoingAssessmentPEObject() -> PENewAssessment {
        let peNewAssessment = PENewAssessment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInProgress")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let currentServerAssessmentId = UserDefaults.standard.string(forKey: "currentServerAssessmentId") ?? ""
        
        
        fetchRequest.predicate = NSPredicate(format: "userID == %d AND serverAssessmentId == %@", userID,currentServerAssessmentId)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let dataArray = results as NSArray
                var userIDArray = dataArray.value(forKey: "userID")  as? NSArray ?? []
                peNewAssessment.userID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "serverAssessmentId")  as? NSArray ?? []
                peNewAssessment.serverAssessmentId = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "complexId")  as? NSArray ?? []
                peNewAssessment.complexId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "draftNumber")  as? NSArray ?? []
                peNewAssessment.draftNumber = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "customerId")  as? NSArray ?? []
                peNewAssessment.customerId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteId")  as? NSArray ?? []
                peNewAssessment.siteId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteName")  as? NSArray ?? []
                peNewAssessment.siteName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "customerName")  as? NSArray ?? []
                peNewAssessment.customerName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "firstname")  as? NSArray ?? []
                peNewAssessment.firstname = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationDate")  as? NSArray ?? []
                peNewAssessment.evaluationDate = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorName")  as? NSArray ?? []
                peNewAssessment.evaluatorName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorID")  as? NSArray ?? []
                peNewAssessment.evaluatorID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "visitName")  as? NSArray ?? []
                peNewAssessment.visitName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "visitID")  as? NSArray ?? []
                peNewAssessment.visitID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "evaluationName")  as? NSArray ?? []
                peNewAssessment.evaluationName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationID")  as? NSArray ?? []
                peNewAssessment.evaluationID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "approver")  as? NSArray ?? []
                peNewAssessment.approver = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "assStatus")  as? NSArray ?? []
                peNewAssessment.assStatus = userIDArray.firstObject as? Int
                
                userIDArray = dataArray.value(forKey: "qcCount")  as? NSArray ?? []
                peNewAssessment.qcCount = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "ppmValue")  as? NSArray ?? []
                peNewAssessment.ppmValue = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "isHandMix")  as? NSArray ?? []
                peNewAssessment.isHandMix = userIDArray.firstObject   as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "personName")  as? NSArray ?? []
                peNewAssessment.personName = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "ampmValue")  as? NSArray ?? []
                peNewAssessment.ampmValue = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "isChlorineStrip")  as? NSArray ?? []
                peNewAssessment.isChlorineStrip = userIDArray.firstObject  as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "isAutomaticFail")  as? NSArray ?? []
                peNewAssessment.isAutomaticFail = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "frequency")  as? NSArray ?? []
                peNewAssessment.frequency = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "sig")  as? NSArray ?? []
                peNewAssessment.sig = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig2")  as? NSArray ?? []
                peNewAssessment.sig2 = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig_EmpID")  as? NSArray ?? []
                peNewAssessment.sig_EmpID = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_EmpID2")  as? NSArray ?? []
                peNewAssessment.sig_EmpID2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name")  as? NSArray ?? []
                peNewAssessment.sig_Name = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name2")  as? NSArray ?? []
                peNewAssessment.sig_Name2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Date")  as? NSArray ?? []
                peNewAssessment.sig_Date = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Phone")  as? NSArray ?? []
                peNewAssessment.sig_Phone = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "notes")  as? NSArray ?? []
                peNewAssessment.notes = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "hatcheryAntibiotics")  as? NSArray ?? []
                let hatcheryAntibiotics =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsText")  as? NSArray ?? []
                let hatcheryAntibioticsText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsText = hatcheryAntibioticsText ?? ""
                
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoa")  as? NSArray ?? []
                let hatcheryAntibioticsDoa =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibioticsDoa = hatcheryAntibioticsDoa ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaText")  as? NSArray ?? []
                let hatcheryAntibioticsDoaText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsDoaText
                = hatcheryAntibioticsDoaText ?? ""
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaS")  as? NSArray ?? []
                let hatcheryAntibioticsDoaS =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibioticsDoaS = hatcheryAntibioticsDoaS ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaSText")  as? NSArray ?? []
                let hatcheryAntibioticsDoaSText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsDoaSText
                = hatcheryAntibioticsDoaSText ?? ""
                
                userIDArray = dataArray.value(forKey: "camera")  as? NSArray ?? []
                let camera =  userIDArray.firstObject as? Int
                peNewAssessment.camera = camera
                userIDArray = dataArray.value(forKey: "selectedTSR")  as? NSArray ?? []
                peNewAssessment.selectedTSR = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "selectedTSRID")  as? NSArray ?? []
                peNewAssessment.selectedTSRID = userIDArray.firstObject as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "statusType")  as? NSArray ?? []
                peNewAssessment.statusType = userIDArray.firstObject as? Int
                
                userIDArray = dataArray.value(forKey: "isFlopSelected")  as? NSArray ?? []
                let isFlopSelected =  userIDArray.firstObject as? Int
                peNewAssessment.isFlopSelected = isFlopSelected
                userIDArray = dataArray.value(forKey: "breedOfBird")  as? NSArray ?? []
                peNewAssessment.breedOfBird = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "breedOfBirdOther")  as? NSArray ?? []
                peNewAssessment.breedOfBirdOther = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubation")  as? NSArray ?? []
                peNewAssessment.incubation = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubationOthers")  as? NSArray ?? []
                peNewAssessment.incubationOthers = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "note")  as? NSArray ?? []
                peNewAssessment.note = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "images")  as? NSArray ?? []
                peNewAssessment.images = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "doa")  as? NSArray ?? []
                peNewAssessment.doa = userIDArray.firstObject as? [Int] ?? []
                
                userIDArray = dataArray.value(forKey: "doaS")  as? NSArray ?? []
                peNewAssessment.doaS = userIDArray.firstObject as? [Int] ?? []
                
                
                
                userIDArray = dataArray.value(forKey: "sequenceNo")  as? NSArray ?? []
                peNewAssessment.sequenceNo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sequenceNoo")  as? NSArray ?? []
                peNewAssessment.sequenceNoo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "informationText")  as? NSArray ?? []
                peNewAssessment.informationText = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "informationImage")  as? NSArray ?? []
                peNewAssessment.informationImage = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "manufacturer")  as? NSArray ?? []
                peNewAssessment.manufacturer = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "noOfEggs")  as? NSArray ?? []
                peNewAssessment.noOfEggs = userIDArray.firstObject as? Int64 ?? 0
                
                userIDArray = dataArray.value(forKey: "iCS")  as? NSArray ?? []
                peNewAssessment.iCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "iDT")  as? NSArray ?? []
                peNewAssessment.iDT = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dCS")  as? NSArray ?? []
                peNewAssessment.dCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dDT")  as? NSArray ?? []
                peNewAssessment.dDT = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dDCS")  as? NSArray ?? []
                peNewAssessment.dDCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dDDT")  as? NSArray ?? []
                peNewAssessment.dDDT = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "micro")  as? NSArray ?? []
                peNewAssessment.micro = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "residue")  as? NSArray ?? []
                peNewAssessment.residue = userIDArray.firstObject as? String ?? ""
                
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "countryID")  as? NSArray ?? []
                peNewAssessment.countryID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: Constants.countryNamStrSmall)  as? NSArray ?? []
                peNewAssessment.countryName = userIDArray.firstObject as? String ?? ""
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "clorineId")  as? NSArray ?? []
                peNewAssessment.clorineId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "clorineName")  as? NSArray ?? []
                peNewAssessment.clorineName = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "fluid")  as? NSArray ?? []
                peNewAssessment.fluid = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "basic")  as? NSArray ?? []
                peNewAssessment.basicTransfer = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "isNA")  as? NSArray ?? []
                peNewAssessment.isNA = userIDArray.firstObject as? Bool ?? false
                
                
                userIDArray = dataArray.value(forKey: "isAllowNA")  as? NSArray ?? []
                peNewAssessment.isAllowNA = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "qSeqNo")  as? NSArray ?? []
                peNewAssessment.qSeqNo = userIDArray.firstObject as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "rollOut")  as? NSArray ?? []
                peNewAssessment.rollOut = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "extndMicro")  as? NSArray ?? []
                peNewAssessment.extndMicro = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "refrigeratorNote")  as? NSArray ?? []
                peNewAssessment.refrigeratorNote = userIDArray.firstObject as? String ?? ""
                //  return peNewAssessment
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        let siteId  = UserDefaults.standard.integer(forKey: "PE_Selected_Site_Id")
        let customerId  = UserDefaults.standard.integer(forKey:"PE_Selected_Customer_Id" )
        let siteName = UserDefaults.standard.string(forKey:"PE_Selected_Site_Name" )
        let customerName = UserDefaults.standard.string(forKey:"PE_Selected_Customer_Name" )
        
        peNewAssessment.userID = userID
        peNewAssessment.siteName = siteName
        peNewAssessment.siteId = siteId
        peNewAssessment.customerId = customerId
        peNewAssessment.customerName = customerName
        return peNewAssessment
    }
    
    
    //for draft
    func getSavedDraftOnGoingAssessmentPEObject() -> PENewAssessment {
        let peNewAssessment = PENewAssessment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                let dataArray = results as NSArray
                var userIDArray = dataArray.value(forKey: "serverAssessmentId")  as? NSArray ?? []
                peNewAssessment.serverAssessmentId = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "draftID")  as? NSArray ?? []
                peNewAssessment.draftID = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "userID")  as? NSArray ?? []
                peNewAssessment.userID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "complexId")  as? NSArray ?? []
                peNewAssessment.complexId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "draftNumber")  as? NSArray ?? []
                peNewAssessment.draftNumber = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "customerId")  as? NSArray ?? []
                peNewAssessment.customerId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteId")  as? NSArray ?? []
                peNewAssessment.siteId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "siteName")  as? NSArray ?? []
                peNewAssessment.siteName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "customerName")  as? NSArray ?? []
                peNewAssessment.customerName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "firstname")  as? NSArray ?? []
                peNewAssessment.firstname = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationDate")  as? NSArray ?? []
                peNewAssessment.evaluationDate = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorName")  as? NSArray ?? []
                peNewAssessment.evaluatorName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluatorID")  as? NSArray ?? []
                peNewAssessment.evaluatorID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "visitName")  as? NSArray ?? []
                peNewAssessment.visitName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "visitID")  as? NSArray ?? []
                peNewAssessment.visitID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "evaluationName")  as? NSArray ?? []
                peNewAssessment.evaluationName = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "evaluationID")  as? NSArray ?? []
                peNewAssessment.evaluationID = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "approver")  as? NSArray ?? []
                peNewAssessment.approver = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "notes")  as? NSArray ?? []
                peNewAssessment.notes = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "hatcheryAntibiotics")  as? NSArray ?? []
                let hatcheryAntibiotics =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics ?? 0
                userIDArray = dataArray.value(forKey: "camera")  as? NSArray ?? []
                let camera =  userIDArray.firstObject as? Int
                camera == 1 ? 1 : 0
                
                peNewAssessment.camera = camera
                userIDArray = dataArray.value(forKey: "isChlorineStrip")  as? NSArray ?? []
                peNewAssessment.isChlorineStrip = userIDArray.firstObject  as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "isAutomaticFail")  as? NSArray ?? []
                peNewAssessment.isAutomaticFail = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "selectedTSR")  as? NSArray ?? []
                peNewAssessment.selectedTSR = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "selectedTSRID")  as? NSArray ?? []
                peNewAssessment.selectedTSRID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "isFlopSelected")  as? NSArray ?? []
                let isFlopSelected =  userIDArray.firstObject as? Int
                peNewAssessment.isFlopSelected = isFlopSelected
                userIDArray = dataArray.value(forKey: "breedOfBird")  as? NSArray ?? []
                peNewAssessment.breedOfBird = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "breedOfBirdOther")  as? NSArray ?? []
                peNewAssessment.breedOfBirdOther = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubation")  as? NSArray ?? []
                peNewAssessment.incubation = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "incubationOthers")  as? NSArray ?? []
                peNewAssessment.incubationOthers = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "note")  as? NSArray ?? []
                peNewAssessment.note = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "images")  as? NSArray ?? []
                peNewAssessment.images = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "doa")  as? NSArray ?? []
                peNewAssessment.doa = userIDArray.firstObject as? [Int] ?? []
                userIDArray = dataArray.value(forKey: "sequenceNo")  as? NSArray ?? []
                peNewAssessment.sequenceNo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sequenceNoo")  as? NSArray ?? []
                peNewAssessment.sequenceNoo = userIDArray.firstObject  as? Int ?? 0
                userIDArray = dataArray.value(forKey: "informationText")  as? NSArray ?? []
                peNewAssessment.informationText = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "informationImage")  as? NSArray ?? []
                peNewAssessment.informationImage = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "manufacturer")  as? NSArray ?? []
                peNewAssessment.manufacturer = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "noOfEggs")  as? NSArray ?? []
                peNewAssessment.noOfEggs = userIDArray.firstObject as? Int64 ?? 0
                userIDArray = dataArray.value(forKey: "iCS")  as? NSArray ?? []
                peNewAssessment.iCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "iDT")  as? NSArray ?? []
                peNewAssessment.iDT = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "sig")  as? NSArray ?? []
                peNewAssessment.sig = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig2")  as? NSArray ?? []
                peNewAssessment.sig2 = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "sig_EmpID")  as? NSArray ?? []
                peNewAssessment.sig_EmpID = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_EmpID2")  as? NSArray ?? []
                peNewAssessment.sig_EmpID2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name")  as? NSArray ?? []
                peNewAssessment.sig_Name = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Name2")  as? NSArray ?? []
                peNewAssessment.sig_Name2 = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Date")  as? NSArray ?? []
                peNewAssessment.sig_Date = userIDArray.firstObject as? String ?? ""
                userIDArray = dataArray.value(forKey: "sig_Phone")  as? NSArray ?? []
                peNewAssessment.sig_Phone = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "dCS")  as? NSArray ?? []
                peNewAssessment.dCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dDT")  as? NSArray ?? []
                peNewAssessment.dDT = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "micro")  as? NSArray ?? []
                peNewAssessment.micro = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "residue")  as? NSArray ?? []
                peNewAssessment.residue = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "qcCount")  as? NSArray ?? []
                peNewAssessment.qcCount = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "isHandMix")  as? NSArray ?? []
                peNewAssessment.isHandMix = userIDArray.firstObject   as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "ppmValue")  as? NSArray ?? []
                peNewAssessment.ppmValue = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "personName")  as? NSArray ?? []
                peNewAssessment.personName = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "ampmValue")  as? NSArray ?? []
                peNewAssessment.ampmValue = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "frequency")  as? NSArray ?? []
                peNewAssessment.frequency = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "isNA")  as? NSArray ?? []
                peNewAssessment.isNA = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "isAllowNA")  as? NSArray ?? []
                peNewAssessment.isAllowNA = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "rollOut")  as? NSArray ?? []
                peNewAssessment.rollOut = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "qSeqNo")  as? NSArray ?? []
                peNewAssessment.qSeqNo = userIDArray.firstObject as? Int ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsText")  as? NSArray ?? []
                let hatcheryAntibioticsText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsText = hatcheryAntibioticsText ?? ""
                
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoa")  as? NSArray ?? []
                let hatcheryAntibioticsDoa =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibioticsDoa = hatcheryAntibioticsDoa ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaText")  as? NSArray ?? []
                let hatcheryAntibioticsDoaText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsDoaText
                = hatcheryAntibioticsDoaText ?? ""
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaS")  as? NSArray ?? []
                let hatcheryAntibioticsDoaS =  userIDArray.firstObject as? Int
                peNewAssessment.hatcheryAntibioticsDoaS = hatcheryAntibioticsDoaS ?? 0
                
                userIDArray = dataArray.value(forKey: "hatcheryAntibioticsDoaSText")  as? NSArray ?? []
                let hatcheryAntibioticsDoaSText =  userIDArray.firstObject as? String
                peNewAssessment.hatcheryAntibioticsDoaSText
                = hatcheryAntibioticsDoaSText ?? ""
                userIDArray = dataArray.value(forKey: "dDCS")  as? NSArray ?? []
                peNewAssessment.dDCS = userIDArray.firstObject as? String ?? ""
                
                
                userIDArray = dataArray.value(forKey: "dDDT")  as? NSArray ?? []
                peNewAssessment.dDDT = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "doaS")  as? NSArray ?? []
                peNewAssessment.doaS = userIDArray.firstObject as? [Int] ?? []
                
                userIDArray = dataArray.value(forKey: "statusType")  as? NSArray ?? []
                peNewAssessment.statusType = userIDArray.firstObject as? Int ?? 0
                
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "countryID")  as? NSArray ?? []
                peNewAssessment.countryID = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: Constants.countryNamStrSmall)  as? NSArray ?? []
                peNewAssessment.countryName = userIDArray.firstObject as? String ?? ""
                
                
                
                userIDArray = dataArray.value(forKey: "fluid")  as? NSArray ?? []
                peNewAssessment.fluid = userIDArray.firstObject as? Bool ?? false
                userIDArray = dataArray.value(forKey: "basic")  as? NSArray ?? []
                peNewAssessment.basicTransfer = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "refrigeratorNote")  as? NSArray ?? []
                peNewAssessment.refrigeratorNote = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "extndMicro")  as? NSArray ?? []
                peNewAssessment.extndMicro = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "isEMRequested")  as? NSArray ?? []
                peNewAssessment.IsEMRequested = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "isEMRejected")  as? NSArray ?? []
                peNewAssessment.isEMRejected = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "isPERejected")  as? NSArray ?? []
                peNewAssessment.isPERejected = userIDArray.firstObject as? Bool ?? false
                
                userIDArray = dataArray.value(forKey: "emRejectedComment")  as? NSArray ?? []
                peNewAssessment.emRejectedComment = userIDArray.firstObject as? String ?? ""
                
                // PE Inte. Changes
                userIDArray = dataArray.value(forKey: "clorineId")  as? NSArray ?? []
                peNewAssessment.clorineId = userIDArray.firstObject as? Int ?? 0
                userIDArray = dataArray.value(forKey: "clorineName")  as? NSArray ?? []
                peNewAssessment.clorineName = userIDArray.firstObject as? String ?? ""
                
                userIDArray = dataArray.value(forKey: "sanitationValue")  as? NSArray ?? []
                peNewAssessment.sanitationValue = userIDArray.firstObject as? Bool ?? false
                
                return peNewAssessment
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessment
    }
    
    func getOnGoingDraftAssessmentArrayPEObject() -> [PENewAssessment] {
        var peNewAssessmentArray : [PENewAssessment] = []
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentIDraftInProgress")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                for result in results {
                    let peNewAssessment = PENewAssessment()
                    peNewAssessment.serverAssessmentId = result.value(forKey: "serverAssessmentId")  as? String ?? ""
                    peNewAssessment.userID =  result.value(forKey: "userID")  as? Int ?? 0
                    peNewAssessment.complexId =  result.value(forKey: "complexId") as? Int ?? 0
                    peNewAssessment.customerId = result.value(forKey: "customerId")  as? Int ?? 0
                    peNewAssessment.siteId = result.value(forKey: "siteId") as? Int ?? 0
                    peNewAssessment.siteName = result.value(forKey: "siteName")  as? String ?? ""
                    peNewAssessment.customerName = result.value(forKey: "customerName") as? String ?? ""
                    peNewAssessment.firstname = result.value(forKey: "firstname")  as? String ?? ""
                    peNewAssessment.evaluationDate = result.value(forKey: "evaluationDate") as? String ?? ""
                    peNewAssessment.evaluatorName = result.value(forKey: "evaluatorName") as? String ?? ""
                    peNewAssessment.evaluatorID = result.value(forKey: "evaluatorID")  as? Int ?? 0
                    peNewAssessment.visitName =  result.value(forKey: "visitName") as? String ?? ""
                    peNewAssessment.visitID = result.value(forKey: "visitID") as? Int ?? 0
                    peNewAssessment.evaluationName = result.value(forKey: "evaluationName") as? String ?? ""
                    peNewAssessment.evaluationID = result.value(forKey: "evaluationID")   as? Int ?? 0
                    peNewAssessment.approver = result.value(forKey: "approver") as? String ?? ""
                    peNewAssessment.notes = result.value(forKey: "notes")  as? String ?? ""
                    let hatcheryAntibiotics =  result.value(forKey: "hatcheryAntibiotics")   as? Int
                    peNewAssessment.hatcheryAntibiotics = hatcheryAntibiotics
                    let camera =  result.value(forKey: "camera")  as? Int
                    peNewAssessment.camera = camera
                    let isFlopSelected =  result.value(forKey: "isFlopSelected")  as? Int
                    peNewAssessment.isFlopSelected = isFlopSelected
                    peNewAssessment.catID = result.value(forKey: "catID")  as? Int ?? 0
                    peNewAssessment.cID = result.value(forKey: "cID")  as? Int ?? 0
                    peNewAssessment.catName = result.value(forKey: "catName")  as? String ?? ""
                    peNewAssessment.catMaxMark = result.value(forKey: "catMaxMark")  as? Int ?? 0
                    peNewAssessment.catResultMark =  result.value(forKey: "catResultMark") as? Int ?? 0
                    peNewAssessment.catEvaluationID = result.value(forKey: "catEvaluationID")  as? Int ?? 0
                    peNewAssessment.catISSelected = result.value(forKey: "catISSelected")  as? Int ?? 0
                    peNewAssessment.assID = result.value(forKey: "assID")  as? Int ?? 0
                    peNewAssessment.assDetail1 = result.value(forKey: "assDetail1") as? String ?? ""
                    peNewAssessment.assDetail2 = result.value(forKey: "assDetail2") as? String ?? ""
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore") as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.assCatType = result.value(forKey: "assCatType")  as? String ?? ""
                    peNewAssessment.assModuleCatID = result.value(forKey: "assModuleCatID") as? Int ?? 0
                    peNewAssessment.assModuleCatName = result.value(forKey: "assModuleCatName") as? String ?? ""
                    peNewAssessment.assStatus =  result.value(forKey: "assStatus")  as? Int ?? 0
                    peNewAssessment.assMaxScore = result.value(forKey: "assMaxScore")  as? Int ?? 0
                    peNewAssessment.assMinScore = result.value(forKey: "assMinScore")  as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo")  as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo")  as? Int ?? 0
                    peNewAssessment.note = result.value(forKey: "note") as? String ?? ""
                    peNewAssessment.images = result.value(forKey: "images") as? [Int] ?? []
                    peNewAssessment.doa = result.value(forKey: "doa") as? [Int] ?? []
                    peNewAssessment.inovoject = result.value(forKey: "inovoject") as? [Int] ?? []
                    peNewAssessment.vMixer = result.value(forKey: "vMixer") as? [Int] ?? []
                    peNewAssessment.FSTSignatureImage = result.value(forKey: "fsrSignatureImage") as? String ?? ""
                    peNewAssessment.sig = result.value(forKey: "sig") as? Int ?? 0
                    peNewAssessment.sig2 = result.value(forKey: "sig2") as? Int ?? 0
                    peNewAssessment.sig_Date = result.value(forKey: "sig_Date") as? String ?? ""
                    peNewAssessment.sig_EmpID = result.value(forKey: "sig_EmpID") as? String ?? ""
                    peNewAssessment.sig_EmpID2 = result.value(forKey: "sig_EmpID2") as? String ?? ""
                    peNewAssessment.sig_Name = result.value(forKey: "sig_Name") as? String ?? ""
                    peNewAssessment.sig_Name2 = result.value(forKey: "sig_Name2") as? String ?? ""
                    peNewAssessment.sig_Phone = result.value(forKey: "sig_Phone") as? String ?? ""
                    peNewAssessment.isChlorineStrip = result.value(forKey: "isChlorineStrip") as? Int ?? 0
                    peNewAssessment.isAutomaticFail = result.value(forKey: "isAutomaticFail") as? Int ?? 0
                    peNewAssessment.isFlopSelected = result.value(forKey: "isFlopSelected") as? Int ?? 0
                    peNewAssessment.sequenceNo = result.value(forKey: "sequenceNo") as? Int ?? 0
                    peNewAssessment.sequenceNoo = result.value(forKey: "sequenceNoo") as? Int ?? 0
                    peNewAssessment.breedOfBird = result.value(forKey: "breedOfBird") as? String ?? ""
                    peNewAssessment.breedOfBirdOther = result.value(forKey: "breedOfBirdOther") as? String ?? ""
                    peNewAssessment.incubation = result.value(forKey: "incubation") as? String ?? ""
                    peNewAssessment.incubationOthers = result.value(forKey: "incubationOthers") as? String ?? ""
                    peNewAssessment.selectedTSR = result.value(forKey: "selectedTSR") as? String ?? ""
                    peNewAssessment.selectedTSRID = result.value(forKey: "selectedTSRID") as? Int ?? 0
                    peNewAssessment.statusType = result.value(forKey: "statusType") as? Int ?? 0
                    peNewAssessment.dDDT = result.value(forKey: "dDDT")  as? String ?? ""
                    peNewAssessment.dDCS = result.value(forKey: "dDCS")  as? String ?? ""
                    peNewAssessment.qcCount = result.value(forKey: "qcCount")  as? String ?? ""
                    peNewAssessment.isHandMix = result.value(forKey: "isHandMix")  as? Bool ?? false
                    peNewAssessment.ppmValue = result.value(forKey: "ppmValue")  as? String ?? ""
                    
                    peNewAssessment.frequency = result.value(forKey: "frequency")  as? String ?? ""
                    peNewAssessment.ampmValue = result.value(forKey: "ampmValue")  as? String ?? ""
                    peNewAssessment.personName = result.value(forKey: "personName")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaSText = result.value(forKey: "hatcheryAntibioticsDoaSText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsDoaText = result.value(forKey: "hatcheryAntibioticsDoaText")  as? String ?? ""
                    peNewAssessment.hatcheryAntibioticsText = result.value(forKey: "hatcheryAntibioticsText")  as? String ?? ""
                    
                    peNewAssessment.hatcheryAntibioticsDoaS = result.value(forKey: "hatcheryAntibioticsDoaS")  as? Int ?? 0
                    peNewAssessment.hatcheryAntibioticsDoa = result.value(forKey: "hatcheryAntibioticsDoa")  as? Int ?? 0
                    peNewAssessment.doaS = result.value(forKey: "doaS") as? [Int] ?? []
                    
                    // PE Intrenational Changes
                    peNewAssessment.countryName = result.value(forKey: Constants.countryNamStrSmall)  as? String ?? ""
                    peNewAssessment.countryID = result.value(forKey: "countryID")  as? Int ?? 0
                    peNewAssessment.fluid = result.value(forKey: "fluid")  as? Bool ?? false
                    peNewAssessment.basicTransfer = result.value(forKey: "basic") as? Bool ?? false
                    peNewAssessment.isNA = result.value(forKey: "isNA") as? Bool ?? false
                    peNewAssessment.rollOut = result.value(forKey: "rollOut") as? String ?? ""
                    peNewAssessment.isAllowNA = result.value(forKey: "isAllowNA") as? Bool ?? false
                    peNewAssessment.extndMicro = result.value(forKey: "extndMicro") as? Bool ?? false
                    peNewAssessment.refrigeratorNote = result.value(forKey: "refrigeratorNote") as? String ?? ""
                    peNewAssessment.qSeqNo = result.value(forKey: "qSeqNo")  as? Int ?? 0
                    
                    // PE Intrenational Changes
                    peNewAssessment.clorineName = result.value(forKey: "clorineName")  as? String ?? ""
                    peNewAssessment.clorineId = result.value(forKey: "clorineId")  as? Int ?? 0
                    peNewAssessment.IsEMRequested = result.value(forKey: "isEMRequested")  as? Bool ?? false
                    
                    peNewAssessment.isPERejected = result.value(forKey: "isPERejected")  as? Bool ?? false
                    peNewAssessment.emRejectedComment = result.value(forKey: "emRejectedComment")  as? String ?? ""
                    peNewAssessment.isEMRejected = result.value(forKey: "isEMRejected")  as? Bool ?? false
                    
                    peNewAssessmentArray.append(peNewAssessment)
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return peNewAssessmentArray
    }
}


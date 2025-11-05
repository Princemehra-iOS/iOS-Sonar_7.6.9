//
//  CoreDataHandlerMicro.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 09/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandlerMicro: NSObject {
    
    private var managedContext  = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType) 
    
    private var CustData = [NSManagedObject]()
    var CustData1 = [NSManagedObject]()
    
    private var ManagedCustData = [NSManagedObject]()
    var dataArray = NSArray()
    
    private var routeArray = NSArray()
    let predicateSessionId = "sessionId == %d AND noOfPlates ==%@"
    
    override init() {
        super.init()
        self.setupContext()
    }
    
    func setupContext() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
    }
    
    func saveCustomerDetailsInDB(_ custId: NSNumber, custName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //let managedContext1 = appDelegate!.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_Customer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(custId, forKey: "customerId")
        person.setValue(custName, forKey: "customerName")
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func saveCustomerDetailsInDBSessionData(_ data: CoreDataHandlerMicrodataModels.CustomerSessionData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "SessionMicrobial", in: context) else { return }

        let session = NSManagedObject(entity: entity, insertInto: context)
        session.setValue(data.company, forKey: "companyName")
        session.setValue(data.companyId, forKey: "companyId")
        session.setValue(data.barcode, forKey: "barcode")
        session.setValue(data.emailId, forKey: "emailId")
        session.setValue(data.requestor, forKey: "requestor")
        session.setValue(data.reviewer, forKey: "reviewer")
        session.setValue(data.sampleCollectedBy, forKey: "sampleCollectedBy")
        session.setValue(data.sampleCollectionDate, forKey: "sampleColectionDate")
        session.setValue(data.sessionId, forKey: "sessionId")
        session.setValue(data.site, forKey: "site")
        session.setValue(data.siteId, forKey: "siteId")

        do {
            try context.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    
    func fetchSampleInfoDataForATimeStamp(_ entityName: String, predicate: NSPredicate) -> NSArray {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
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
    
    
    func deleteWithPredicatesFeaherPulpSampleInfo(_ entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate.init(format: "isSessionPlate==\(1)")
        let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest)
        if let objects1 = objects {
            for obj in objects1 {
                appDelegate.managedObjectContext.delete(obj as! NSManagedObject)
            }
            do {
                try appDelegate.managedObjectContext.save() // <- remember to put this :)
            } catch {
                // Do something... fatalerror
            }
        }
    }

    func saveFeatherPulpSampleInfoDataInDB(_ data: CoreDataHandlerMicrodataModels.FeatherPulpSampleInfoDataSave) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpSampleInfo", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)

        person.setValue(data.plateIdGenerated, forKey: "plateIdGenerated")
        person.setValue(data.plateId, forKey: "plateId")
        person.setValue(data.flockId, forKey: "flockId")
        person.setValue(data.houseNo, forKey: "houseNo")
        person.setValue(data.sampleDescription, forKey: "sampleDescription")
        person.setValue(data.additionalTests, forKey: "additionalTests")
        person.setValue(data.checkMark, forKey: "checkMark")
        person.setValue(data.sessionId, forKey: "sessionId")
        person.setValue(data.microsporeCheck, forKey: "microsporeCheckMark")
        person.setValue(data.timeStamp, forKey: "timeStamp")
        person.setValue(data.isSessionPlate, forKey: "isSessionPlate")

        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }

        CustData.append(person)
    }

    
    
    func saveCustomerDetailsInDBSubmitData(_ details: CoreDataHandlerMicrodataModels.submitDataCustomerDetails) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let entity = NSEntityDescription.entity(forEntityName: "MicrobialSession", in: appDelegate.managedObjectContext) else {
            return
        }

        let person = NSManagedObject(entity: entity, insertInto: appDelegate.managedObjectContext)
        person.setValue(details.company, forKey: "company")
        person.setValue(details.companyId, forKey: "companyId")
        person.setValue(details.barcode, forKey: "barcode")
        person.setValue(details.emailId, forKey: "emailId")
        person.setValue(details.requestor, forKey: "requestor")
        person.setValue(details.reviewer, forKey: "reviewer")
        person.setValue(details.sampleCollectedBy, forKey: "sampleCollectedBy")
        person.setValue(details.sampleCollectionDate, forKey: "sampleCollectionDate")
        person.setValue(details.sessionId, forKey: "sessionId")
        person.setValue(details.site, forKey: "site")
        person.setValue(details.siteId, forKey: "siteId")

        do {
            try appDelegate.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    func updateFeatherPulpDetailsAsSubmittedData(timeStramp: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp, argumentArray: [timeStramp])
        let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest)
        if let objects1 = objects {
            for obj in objects1 {
                (obj as! Microbial_EnviromentalSurveyFormSubmitted).setValue(SessionStatus.submitted.rawValue, forKey: "sessionStatus")
                (obj as! Microbial_EnviromentalSurveyFormSubmitted).setValue(false, forKey: "isSynced")
                do {
                    try appDelegate.managedObjectContext.save() // <- remember to put this :)
                } catch {
                }
            }
        }
    }
    
    
    func saveCaseInfoDataInToDB(info: CoreDataHandlerMicrodataModels.CaseInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Microbial_EnviromentalSurveyFormSubmitted", in: context) else { return }

        let managedObject = NSManagedObject(entity: entity, insertInto: context)

        managedObject.setValue(info.reasonForVisitId, forKey: "reasonForVisitId")
        managedObject.setValue(info.surveyConductedOnId, forKey: "surveyConductedOnId")
        managedObject.setValue(info.purposeOfSurveyId, forKey: "purposeOfSurveyId")
        managedObject.setValue(info.reviewerId, forKey: "reviewerId")
        managedObject.setValue(info.requestor, forKey: "requestor")
        managedObject.setValue(info.sampleCollectedBy, forKey: "sampleCollectedBy")
        managedObject.setValue(info.company, forKey: "company")
        managedObject.setValue(info.companyId, forKey: "companyId")
        managedObject.setValue(info.site, forKey: "site")
        managedObject.setValue(info.siteId, forKey: "siteId")
        managedObject.setValue(info.email, forKey: "email")
        managedObject.setValue(info.reviewer, forKey: "reviewer")
        managedObject.setValue(info.surveyConductedOn, forKey: "surveyConductedOn")
        managedObject.setValue(info.sampleCollectionDate, forKey: "sampleCollectionDate")
        managedObject.setValue(info.sampleCollectionDateWithTimeStamp, forKey: "sampleCollectionDateWithTimeStamp")
        managedObject.setValue(info.purposeOfSurvey, forKey: "purposeOfSurvey")
        managedObject.setValue(info.transferIn, forKey: "transferIn")
        managedObject.setValue(info.barCode, forKey: "barcode")
        managedObject.setValue(info.barCodeManualEntered, forKey: "barcodeManualEntered")
        managedObject.setValue(info.notes, forKey: "notes")
        managedObject.setValue(info.reasonForVisit, forKey: "reasonForVisit")
        managedObject.setValue(info.typeOfBird, forKey: "typeOfBird")
        managedObject.setValue(info.typeOfBirdId, forKey: "typeOfBirdId")
        managedObject.setValue(info.currentdate, forKey: "currentdate")
        managedObject.setValue(info.customerId, forKey: "customerId")
        managedObject.setValue(info.requisitionType, forKey: "requisitionType")
        managedObject.setValue(info.sessionStatus, forKey: "sessionStatus")
        managedObject.setValue(info.requisitionId, forKey: "requisition_Id")
        managedObject.setValue(info.timeStamp, forKey: "timeStamp")
        managedObject.setValue(info.isPlateIdGenerated, forKey: "isPlateIdGenerated")
        managedObject.setValue(false, forKey: "isSynced")
        managedObject.setValue(UserDefaults.standard.value(forKey:"Id") ?? 0, forKey: "userId")

        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String ?? ""
        let syncDeviceId = "\(info.timeStamp)_\(UserDefaults.standard.value(forKey:"Id") ?? 0)_iOS_\(udid)"
        managedObject.setValue(syncDeviceId, forKey: "syncDeviceId")
        managedObject.setValue("C-\(info.timeStamp)", forKey: "reqNo")

        if let caseStatusArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialCaseStatus") as? [MicrobialCaseStatus] {
            managedObject.setValue(caseStatusArray.first?.id ?? 0, forKey: "reqStatus")
        } else {
            managedObject.setValue(0, forKey: "reqStatus")
        }

        do {
            try context.save()
        } catch {
            // Handle save error
        }
    }
    func saveSamplePlatesInToDB_Enviromental(info: MicrobialSampleDetailsList) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext

        guard let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeadersSubmitted", in: context) else { return }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(info.noOfPlates, forKey: "noOfPlates")
        managedObject.setValue(info.microbialDetailId, forKey: "microbialDetailId")
        managedObject.setValue(info.locVal, forKey: "locVal")
        managedObject.setValue(info.microbialSamplePlates, forKey: "microbialSamplePlates")
       
        
        do {
            try context.save()
        } catch {
            // handle save error
        }
    }

    
    func saveSampleInfoHeaderDataInToDB_Enviromental(info: CoreDataHandlerMicrodataModels.SampleInfoHeader) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext

        guard let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeadersSubmitted", in: context) else { return }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(info.currentdate, forKey: "currentdate")
        managedObject.setValue(info.customerId, forKey: "customerId")
        managedObject.setValue(info.requisitionType, forKey: "requisitionType")
        managedObject.setValue(info.sessionStatus, forKey: "sessionStatus")
        managedObject.setValue(info.locationType, forKey: "locationType")
        managedObject.setValue(info.locationTypeId, forKey: "locationTypeId")
        managedObject.setValue(info.noOfPlates, forKey: "noOfPlates")
        managedObject.setValue(info.section, forKey: "section")
        managedObject.setValue(info.requisitionId, forKey: "requisition_Id")
        managedObject.setValue(info.timeStamp, forKey: "timeStamp")
        
        do {
            try context.save()
        } catch {
            // handle save error
        }
    }
        
    func saveRequisitionalIDs_Enviromental(requisition_Id: String, requisitionType: Int, sessionStatus: Int, totalHeader: Int, totalPlates: Int, timeStamp: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_Enviromental_RequisitionIDs", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        managedObject.setValue(requisition_Id, forKey: "requisition_Id")
        managedObject.setValue(requisitionType, forKey: "requisitionType")
        managedObject.setValue(sessionStatus, forKey: "sessionStatus")
        managedObject.setValue(totalHeader, forKey: "totalHeader")
        managedObject.setValue(totalPlates, forKey: "totalPlates")
        managedObject.setValue(timeStamp, forKey: "timeStamp")
        
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            
        }
    }
    
    func fetchEnviromentalHeadersWith(requisition_Id: String, requisitionType: NSNumber) -> [Microbial_LocationTypeHeadersSubmitted] {
        
        var dataArray2 = [Microbial_LocationTypeHeadersSubmitted]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "requisition_Id == %@", "\(requisition_Id)")
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeadersSubmitted]
            if let results = fetchedResult {
                dataArray2 = results
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray2
    }
    
    func fetchEnviromentalPlatesWith(section: String, requisition_Id: String, locationTypeId: NSNumber, timeStamp: String) -> [Microbial_LocationTypeHeaderPlatesSubmitted] {
        
        var dataArray4 = [Microbial_LocationTypeHeaderPlatesSubmitted]()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlatesSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "section == %@ AND requisition_Id == %@ AND locationTypeId == %@ AND timeStamp == %@", section, requisition_Id, "\(locationTypeId)", timeStamp)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeaderPlatesSubmitted]
            if let results = fetchedResult {
                dataArray4 = results
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray4
    }
    
    
    
    func fetchSubmittedOrSaveAsDraftRequisitions(sessionStatus: Int, requisitionType: Int) -> NSArray {
        var dataArray2 = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        let userId = UserDefaults.standard.value(forKey: "Id") ?? 0
        fetchRequest.predicate = NSPredicate(format: "sessionStatus == \(sessionStatus) AND requisitionType == \(requisitionType) AND userId == \(userId) AND isSynced == 0")
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_EnviromentalSurveyFormSubmitted]
            if let results = fetchedResult {
                dataArray2 = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray2
    }
    
    //MARK: - Save Enviromental Session In Progress
    func saveEnviromentalSessionInProgress(info: CoreDataHandlerMicrodataModels.EnvironmentalSessionInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Microbial_EnviromentalSessionInProgress", in: context) else { return }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(info.requestor, forKey: "requestor")
        managedObject.setValue(info.sampleCollectedBy, forKey: "sampleCollectedBy")
        managedObject.setValue(info.company, forKey: "company")
        managedObject.setValue(info.companyId, forKey: "companyId")
        managedObject.setValue(info.site, forKey: "site")
        managedObject.setValue(info.siteId, forKey: "siteId")
        managedObject.setValue(info.email, forKey: "email")
        managedObject.setValue(info.reviewer, forKey: "reviewer")
        managedObject.setValue(info.surveyConductedOn, forKey: "surveyConductedOn")
        managedObject.setValue(info.sampleCollectionDate, forKey: "sampleCollectionDate")
        managedObject.setValue(info.sampleCollectionDateWithTimeStamp, forKey: "sampleCollectionDateWithTimeStamp")
        managedObject.setValue(info.purposeOfSurvey, forKey: "purposeOfSurvey")
        managedObject.setValue(info.transferIn, forKey: "transferIn")
        managedObject.setValue(info.barCode, forKey: "barcode")
        managedObject.setValue(info.barCodeManualEntered, forKey: "barcodeManualEntered")
        managedObject.setValue(info.notes, forKey: "notes")
        managedObject.setValue(info.reasonForVisit, forKey: "reasonForVisit")
        managedObject.setValue(info.requisitionId, forKey: "requisition_Id")
        managedObject.setValue(info.requisitionType, forKey: "requisitionType")
        managedObject.setValue(info.isPlateIdGenerated, forKey: "isPlateIdGenerated")
        managedObject.setValue(info.typeOfBird, forKey: "typeOfBird")
        managedObject.setValue(info.typeOfBirdId, forKey: "typeOfBirdId")
        
        do {
            try context.save()
        } catch {
            // Handle error
        }
    }

    
    func saveEnviromentalLocationTypeHeaderInfo(locationType: String, locationTypeId: Int,
                                                noOfPlates: Int, section: Int, requisition_Id: String, requisitionType: Int) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeaders", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        managedObject.setValue(locationType, forKey: "locationType")
        managedObject.setValue(locationTypeId, forKey: "locationTypeId")
        managedObject.setValue(noOfPlates, forKey: "noOfPlates")
        managedObject.setValue(section, forKey: "section")
        managedObject.setValue(requisition_Id, forKey: "requisition_Id")
        managedObject.setValue(requisitionType, forKey: "requisitionType")
        
        do {
            try appDelegate?.managedObjectContext.save()
        } catch { }
    }
    
    func saveEnviromentalLocationTypePlatesInfo(data: CoreDataHandlerMicrodataModels.EnviromentalLocationPlateData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeaderPlates", in: context) else { return }

        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(data.isBacterialChecked, forKey: "isBacterialChecked")
        managedObject.setValue(data.isMicoscoreChecked, forKey: "isMicoscoreChecked")
        managedObject.setValue(data.locationValue, forKey: "locationValue")
        managedObject.setValue(data.plateId, forKey: "plateId")
        managedObject.setValue(data.row, forKey: "row")
        managedObject.setValue(data.section, forKey: "section")
        managedObject.setValue(data.sampleDescription, forKey: "sampleDescription")
        managedObject.setValue(data.locationTypeId, forKey: "locationTypeId")
        managedObject.setValue(data.requisitionId, forKey: "requisition_Id")
        managedObject.setValue(data.requisitionType, forKey: "requisitionType")
        managedObject.setValue(data.mediaTypeValue, forKey: "mediaTypeValue")
        managedObject.setValue(data.mediaTypeId, forKey: "mediaTypeId")
        managedObject.setValue(data.notes, forKey: "notes")
        managedObject.setValue(data.samplingMethodId, forKey: "samplingMethodTypeId")
        managedObject.setValue(data.samplingMethodTypeValue, forKey: "samplingMethodTypeValue")

        do {
            try context.save()
        } catch {
            print("Failed to save plate info: \(error)")
        }
    }

    
    func fetchEnviromentalLocationTypeHeaderInfoFor() -> NSArray {
        
        var dataArray7 = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaders")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeaders]
            if let results = fetchedResult {
                dataArray7 = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray7
    }
    
    func fetchEnviromentalLocationTypePlatesInfoFor(section: Int, locationTypeId: Int) -> NSArray {
        
        var dataArray3 = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlates")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "locationTypeId == %@ AND section == %d", "\(locationTypeId)", section)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeaderPlates]
            if let results = fetchedResult {
                dataArray3 = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray3
    }
    
    func saveSessionProgress(data: CoreDataHandlerMicrodataModels.SessionProgressData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "ProgressSessionMicrobial", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)

        person.setValue(data.company, forKey: "company")
        person.setValue(data.companyId, forKey: "companyId")
        person.setValue(data.barcode, forKey: "barcode")
        person.setValue(data.emailId, forKey: "emailId")
        person.setValue(data.requestor, forKey: "requestor")
        person.setValue(data.reviewer, forKey: "reviewer")
        person.setValue(data.sampleCollectedBy, forKey: "sampleCollectedBy")
        person.setValue(data.sampleCollectionDate, forKey: "sampleCollectionDate")
        person.setValue(data.sessionId, forKey: "sessionId")
        person.setValue(data.site, forKey: "site")
        person.setValue(data.siteId, forKey: "siteId")
        person.setValue(data.sampleCollectionDateWithTimeStamp, forKey: "sampleCollectionDateWithTimeStamp")
        person.setValue(data.manualEnteredBarCode, forKey: "manualEnteredBarCode")

        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegate?.testFuntion() ?? "Error saving session progress.")
        }
    }

    
    func saveSampleInfoDataInDB(_ noOfPlates: String ,plateId : Int,sampleDescriptiopn:String , additionalTests : String , checkMark:String, microsporeCheck: String, sessionId : Int) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialSampleInfo", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(noOfPlates, forKey: "noOfPlates")
        person.setValue(plateId, forKey: "plateId")
        person.setValue(sampleDescriptiopn, forKey: "sampleDescription")
        person.setValue(additionalTests, forKey: "additionalTests")
        person.setValue(checkMark, forKey: "checkMark")
        person.setValue(sessionId, forKey: "sessionId")
        person.setValue(microsporeCheck, forKey: "microsporeCheckMark")
        
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func fetchSampleInfo(_ sessionId: Int) -> NSArray {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionId == %d", sessionId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "plateId", ascending: true)
                let sortedResults = dataArray.sortedArray(using: [descriptor])
                dataArray = sortedResults as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func fetchFeatherPulpSampleInfo(_ sessionId: Int) -> [MicrobialFeatherPulpSampleInfo] {
        var dataArray3 = [MicrobialFeatherPulpSampleInfo]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionId == %d", sessionId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "plateId", ascending: true)]
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [MicrobialFeatherPulpSampleInfo]
            if let results = fetchedResult {
                dataArray3 = results
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray3
        
    }
    
    func deleteLastRowFeatherPulpData(predicate: NSPredicate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchUsers.predicate = predicate
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchUsers)
            if let lastObject = results.last as? NSManagedObject {
                managedContext.delete(lastObject)
                try appDelegate.managedObjectContext.save()
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func fetchDataFromDraftsAndRequisition(draftOrSubmit: Int, entityName: String)-> NSArray{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionStatus == \(draftOrSubmit) AND userId == \(String(describing: UserDefaults.standard.value(forKey: "Id") ?? 0))")
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
                return dataArray
                
            } else {
                return []
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
    }
    
    func fetchAllData1(_ entityName: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        var dataArrayNew = [NSManagedObject()]
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                dataArrayNew = results
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArrayNew
    }
    func fetchAllData(_ entityName: String) -> NSArray {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
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
    func updateSampledesc(_ sessionId: Int,plateId: String,sampleDesc: String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0 {
                let objTable: MicrobialSampleInfo = (fetchedResult![0] as? MicrobialSampleInfo)!
                objTable.setValue(sampleDesc, forKey: "sampleDescription")
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
        } catch {}
    }
    
    func updateFeatherPulpSampledesc(plateData: MicrobialFeatherPulpSampleInfo, predicate: NSPredicate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0 {
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateFeatherPulpCheckMark(_ sessionId: Int,plateId: String,checkMark: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                
                let objTable: MicrobialFeatherPulpSampleInfo = (fetchedResult![0] as? MicrobialFeatherPulpSampleInfo)!
                
                objTable.setValue(checkMark, forKey: "checkMark")
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
            
        } catch {
            
        }
    }
    
    func updateFeatherPulpMicrosporeCheckMark(_ sessionId: Int,plateId: String,checkMark: String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                
                let objTable: MicrobialFeatherPulpSampleInfo = (fetchedResult![0] as? MicrobialFeatherPulpSampleInfo)!
                
                objTable.setValue(checkMark, forKey: "microsporeCheckMark")
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
            
        } catch {
            
        }
    }
    
    
    func deleteRowData ( sessionId: Int,plateId: String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchPredicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        fetchUsers.predicate                = fetchPredicate
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    
    func deleteRowDataOfAnEntity(predicate: NSPredicate, entityName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchPredicate = predicate
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchUsers.predicate = fetchPredicate
        
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchUsers)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            do {
                try appDelegate.managedObjectContext.save()
            } catch {
            }
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func deleteLastRowData( sessionId: Int,plateId: String) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchUsers)
            if let lastObject = results.last as? NSManagedObject {
                print(lastObject)
                managedContext.delete(lastObject)
                try appDelegate.managedObjectContext.save()
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateMicrosporeCheckMark(_ sessionId: Int,plateId: String,checkMark: String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                
                let objTable: MicrobialSampleInfo = (fetchedResult![0] as? MicrobialSampleInfo)!
                
                objTable.setValue(checkMark, forKey: "microsporeCheckMark")
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
            
        } catch {
            
        }
    }
    
    func updateCheckMark(_ sessionId: Int,plateId: String,checkMark: String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSampleInfo")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: predicateSessionId, sessionId,plateId)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                
                let objTable: MicrobialSampleInfo = (fetchedResult![0] as? MicrobialSampleInfo)!
                
                objTable.setValue(checkMark, forKey: "checkMark")
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
            
        } catch {
            
        }
    }
    
    func saveCustomerDetailsInDraftData(customerDetails: CoreDataHandlerMicrodataModels.CustomerDetails) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialDraft", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        person.setValue(customerDetails.company, forKey: "company")
        person.setValue(customerDetails.companyId, forKey: "companyId")
        person.setValue(customerDetails.barcode, forKey: "barcode")
        person.setValue(customerDetails.emailId, forKey: "emailId")
        person.setValue(customerDetails.requestor, forKey: "requestor")
        person.setValue(customerDetails.reviewer, forKey: "reviewer")
        person.setValue(customerDetails.sampleCollectedBy, forKey: "sampleCollectedBy")
        person.setValue(customerDetails.sampleCollectionDate, forKey: "sampleCollectionDate")
        person.setValue(customerDetails.sessionId, forKey: "sessionId")
        person.setValue(customerDetails.site, forKey: "site")
        person.setValue(customerDetails.siteId, forKey: "siteId")
        person.setValue(customerDetails.draftCheck, forKey: "draftCheck")
        
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
    }
    
    
    func fetchCustomerWithCustId(_ custId: NSNumber) -> NSArray {
        
        var dataArray10 = NSArray()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Micro_Customer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId == %@", custId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray10 = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray10
        
    }
    
    func saveReviewerDetailsInDB(_ custId: NSNumber, ReviewerName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_Reviewer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(custId, forKey: "reviewerId")
        person.setValue(ReviewerName, forKey: "reviewerName")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func saveAllConductTypeDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_AllConductType", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    
    func saveAllSitesIdInDB(_ id: Int, text: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "Micro_siteByCustomer", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(text, forKey: "text")
        do {
            try appDelegate!.managedObjectContext.save()
        } catch {
            
        }
        CustData.append(managedObject)
    }
    
    func fectAllSitesIdFromDB(_ entityName: String) -> NSArray {
        var result = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                result = results as NSArray
            } else {print(appDelegateObj.testFuntion())}
        } catch {
            
        }
        return result
    }
    
    func saveLocationTypeValuesInDB(_ values: CoreDataHandlerMicrodataModels.saveLocationTypeValues) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext

        if let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationValues", in: context) {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)

            managedObject.setValue(values.locationId, forKey: "locationTypeId")
            managedObject.setValue(values.id, forKey: "id")
            managedObject.setValue(values.value, forKey: "text")
            managedObject.setValue(values.std20, forKey: "std20")
            managedObject.setValue(values.std40, forKey: "std40")
            managedObject.setValue(values.rep40, forKey: "rep40")
            managedObject.setValue(values.rep20, forKey: "rep20")
            managedObject.setValue(values.standard, forKey: "standard")
            managedObject.setValue(values.stnRep, forKey: "stnRep")
            managedObject.setValue(values.mediaTypeDefault, forKey: "media")
            managedObject.setValue(values.samplingMethodDefault, forKey: "sampling")

            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }

            CustData.append(managedObject)
        }
    }

    
    
    func fetchLocationValueFor(locationId: Int) -> NSArray {
        
        var dataArray4 = NSArray()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationValues")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "locationTypeId == %@", "\(locationId)")
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationValues]
            if let results = fetchedResult {
                dataArray4 = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray4
        
    }
    
    func fetchMediaTypesFor() -> NSArray {
        
        var dataArray8 = NSArray()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_AllMediaTypes")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_AllMediaTypes]
            if let results = fetchedResult {
                dataArray8 = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray8
        
    }
    
    func saveAllMediaTypeDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_AllMediaTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    
    func saveAllsamplingMethodTypeDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_SamplingMethodTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func saveAllSurveyPurposeDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_AllSurveyPurpose", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func saveAllMicrobialTransferTypesDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_AllMicrobialTransferTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    func fetchDetailsFor(entityName:String, customerId: Int? = nil, companyName: String? = nil) -> NSArray {
        
        var dataArray5 = NSArray()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        if let customerId = customerId {
            fetchRequest.predicate = NSPredicate(format: "customerId == %d", customerId)
        }
        
        if let companyName = companyName {
            fetchRequest.predicate = NSPredicate(format: "customerName == %@", companyName)
        }
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray5 = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray5
        
    }
    
    func deleteAllData(_ entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                try appDelegate.managedObjectContext.save()
            }
            
        } catch let error as NSError {
            
        }
    }
    
    func autoIncrementidtable() {
        var auto = self.fetchFromAutoIncrement()
        auto += 1
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Id", in: appDelegate!.managedObjectContext)
        let contact1 = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        contact1.setValue(auto, forKey: "autoId")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func fetchFromAutoIncrement() -> Int {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "Id")
        fetchRequest.returnsObjectsAsFaults = false
        var auto = 0
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult, results.count > 0, let ob = results.last as? Id {
                auto = Int(ob.autoId!)
            }
            
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return auto
    }
    
    
    
    func updateRequestorBacterialServeyFormDetails(_ sessionId: Int, text: String, forAttribute:String ) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "SessionMicrobial", in: appDelegate.managedObjectContext)
        let contact1 = NSManagedObject(entity: entity!, insertInto: appDelegate.managedObjectContext)
        contact1.setValue(text, forKey: forAttribute)
        contact1.setValue(sessionId, forKey: "sessionId")
        do {
            try appDelegate.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    
    func fetchDataForBacterialServeyForm(_ sessionId: NSNumber) -> NSArray {
        
        var dataArray11 = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "SessionMicrobial")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionId == %@", sessionId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataArray11 = results as NSArray
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray11
        
    }
    
    func fetchCertificationDateForMixer(_ mixerId: NSNumber) -> String {
        
        var data = String()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_VaccineMixerDetail")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id == %@", mixerId)
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult?[0] {
                data = results.value(forKey: "certificationDate") as? String ?? ""
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return data
        
    }
    
    
    func saveStartNewAsessmentFormDetailsInDB() {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "SessionMicrobial", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue("", forKey: "customer")
        person.setValue("company", forKey: "company")
        person.setValue("companyId", forKey: "companyId")
        person.setValue("emailId", forKey: "emailId")
        person.setValue("requestor", forKey: "requestor")
        person.setValue("reviewer", forKey: "reviewer")
        person.setValue(1, forKey: "sessionId")
        person.setValue("site", forKey: "site")
        person.setValue("siteId", forKey: "siteId")
        person.setValue("sampleCollectedBy", forKey: "sampleCollectedBy")
        person.setValue("sampleCollectionDate", forKey: "sampleCollectionDate")
        person.setValue("barcode", forKey: "barcode")
        
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        ManagedCustData.append(person)
        
    }
    
    func updateStartNewAsessmentFormDetails(_ sessionId: Int, text: String, forAttribute:String ) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "SessionMicrobial")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "sessionId == %@", argumentArray: [sessionId])
        do {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                results![0].setValue(text, forKey: forAttribute)
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        do {
            try appDelegate.managedObjectContext.save()
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func saveAllMicrobialHatcherySiteDetailsInDB(_ id :NSNumber, siteId :NSNumber, SiteName:String, ComplexId:Int,customerId:Int!) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_siteByCustomer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(siteId, forKey: "siteId")
        person.setValue(SiteName, forKey: "siteName")
        person.setValue(ComplexId, forKey: "complexId")
        person.setValue(customerId, forKey: "customerId")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }
    
    
    func saveAllMicrobialVisitTypesDetailsInDB(_ id: NSNumber, text: String) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Micro_AllMicrobialVisitTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(id, forKey: "id")
        person.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        CustData.append(person)
        
    }

    
    func updateDataInTheEntityWithPredicates(predicate: NSPredicate,entity: String, updateData: CoreDataHandlerMicrodataModels.SessionUpdateData
    ) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let record = results?.first {
                record.setValue(updateData.requestor, forKey: "requestor")
                record.setValue(updateData.sampleCollectedBy, forKey: "sampleCollectedBy")
                record.setValue(updateData.company, forKey: "company")
                record.setValue(updateData.companyId, forKey: "companyId")
                record.setValue(updateData.site, forKey: "site")
                record.setValue(updateData.siteId, forKey: "siteId")
                record.setValue(updateData.email, forKey: "email")
                record.setValue(updateData.reviewer, forKey: "reviewer")
                record.setValue(updateData.surveyConductedOn, forKey: "surveyConductedOn")
                record.setValue(updateData.sampleCollectionDate, forKey: "sampleCollectionDate")
                record.setValue(updateData.sampleCollectionDateWithTimeStamp, forKey: "sampleCollectionDateWithTimeStamp")
                record.setValue(updateData.purposeOfSurvey, forKey: "purposeOfSurvey")
                record.setValue(updateData.transferIn, forKey: "transferIn")
                record.setValue(updateData.barCode, forKey: "barcode")
                record.setValue(updateData.barCodeManualEntered, forKey: "barcodeManualEntered")
                record.setValue(updateData.notes, forKey: "notes")
                record.setValue(updateData.reasonForVisit, forKey: "reasonForVisit")
                record.setValue(updateData.currentdate, forKey: "currentdate")
                record.setValue(updateData.customerId, forKey: "customerId")
                record.setValue(updateData.requisitionType, forKey: "requisitionType")
                record.setValue(updateData.sessionStatus, forKey: "sessionStatus")
                record.setValue(updateData.requisition_Id, forKey: "requisition_Id")
                record.setValue(updateData.timeStamp, forKey: "timeStamp")
                record.setValue(updateData.isPlateIdGenerated, forKey: "isPlateIdGenerated")
                record.setValue(updateData.typeOfBirdId, forKey: "typeOfBirdId")
                record.setValue(updateData.typeOfBird, forKey: "typeOfBird")
                record.setValue(updateData.reviewerId, forKey: "reviewerId")
                record.setValue(updateData.purposeOfSurveyId, forKey: "purposeOfSurveyId")
                record.setValue(updateData.surveyConductedOnId, forKey: "surveyConductedOnId")
                record.setValue(updateData.reasonForVisitId, forKey: "reasonForVisitId")
                record.setValue(false, forKey: "isSynced")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        } catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    func updateSampleInfoHeaderDataInToDB_Enviromental(_ info: CoreDataHandlerMicrodataModels.EnvSampleHeaderUpdateInfo) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")

        fetchRequest.predicate = NSPredicate(
            format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i",
            argumentArray: [info.timeStamp, info.requisitionId, info.requisitionType, info.section]
        )

        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if let results = results, !results.isEmpty {
                for data in results {
                    data.setValue(info.currentDate, forKey: "currentdate")
                    data.setValue(info.customerId, forKey: "customerId")
                    data.setValue(info.requisitionType, forKey: "requisitionType")
                    data.setValue(info.sessionStatus, forKey: "sessionStatus")
                    data.setValue(info.locationType, forKey: "locationType")
                    data.setValue(info.locationTypeId, forKey: "locationTypeId")
                    data.setValue(info.noOfPlates, forKey: "noOfPlates")
                    data.setValue(info.section, forKey: "section")
                    data.setValue(info.requisitionId, forKey: "requisition_Id")
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeadersSubmitted", in: context)!
                let managedObject = NSManagedObject(entity: entity, insertInto: context)

                managedObject.setValue(info.currentDate, forKey: "currentdate")
                managedObject.setValue(info.customerId, forKey: "customerId")
                managedObject.setValue(info.requisitionType, forKey: "requisitionType")
                managedObject.setValue(info.sessionStatus, forKey: "sessionStatus")
                managedObject.setValue(info.locationType, forKey: "locationType")
                managedObject.setValue(info.locationTypeId, forKey: "locationTypeId")
                managedObject.setValue(info.noOfPlates, forKey: "noOfPlates")
                managedObject.setValue(info.section, forKey: "section")
                managedObject.setValue(info.requisitionId, forKey: "requisition_Id")
                managedObject.setValue(info.timeStamp, forKey: "timeStamp")

                try context.save()
            }
        } catch {
            // Handle fetch error
        }

        do {
            try context.save()
        } catch {
            // Handle save error
        }
    }

    
    func deleteHeaderPlates(timeStamp: String, barcode: String, locationId: Int, section: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequestOfHeaders = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        fetchRequestOfHeaders.predicate = NSPredicate(format: "timeStamp = %@ AND locationTypeId = %i AND section = %i", argumentArray: [timeStamp, locationId, section])
        do {
            let results = try context.fetch(fetchRequestOfHeaders)
            for obj in results{
                context.delete(obj as! NSManagedObject)
                try context.save()
            }
        } catch {
            //   print("ERROR - deleting")
        }
        
        
    }
    
    func reArrangeHeaders(timeStamp: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequestOfHeaders = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        let predicate = NSPredicate(format: appDelegate.timeStamp, argumentArray: [timeStamp])
        fetchRequestOfHeaders.predicate = predicate
        do {
            let results = try context.fetch(fetchRequestOfHeaders) as! [Microbial_LocationTypeHeadersSubmitted]
            if results.count > 0{
                for index in 0..<results.count{
                    Microbial_LocationTypeHeaderPlatesSubmitted.updateSection(prevSection: results[index].section?.intValue ?? 0, newSection: index + 1, timeStamp: timeStamp)
                    (results[index] as AnyObject).setValue(index + 1, forKey: "section")
                }
            }
        } catch {
            //   print("ERROR - deleting")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    
    
    func updateNumberOfPlates(predicate: NSPredicate, noOfPlates: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequestOfHeaders = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        fetchRequestOfHeaders.predicate = predicate
        //NSPredicate(format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i", argumentArray: [timeStamp, requisition_Id, requisitionType, section])
        do {
            let results = try context.fetch(fetchRequestOfHeaders) as? [NSManagedObject]
            if results?.count != 0 {
                for data in results ?? []{
                    data.setValue(noOfPlates, forKey: "noOfPlates")
                    try appDelegate.managedObjectContext.save()
                }
            }else{print(appDelegateObj.testFuntion())}
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
    }
    
    func updatePlateIDInfoForFeatherPulp(timeStamp: String){
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "isSessionPlate == 1")
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0 {
                for plate in fetchedResult!{
                    plate.setValue(false, forKey: "isSessionPlate")
                    plate.setValue(timeStamp, forKey: "timeStamp")
                }
                do {
                    try appDelegate.managedObjectContext.save()
                } catch {
                }
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
}

//MARK:- MicrobialFeatherPulpBirdType
extension MicrobialFeatherPulpBirdType{
    class func saveBirdTypeValuesInDB(id: NSNumber, birdText: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpBirdType", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(birdText, forKey: "birdText")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
}


//MARK:- MicrobialFeatherPulpSpecimenType
extension MicrobialFeatherPulpSpecimenType{
    class func saveSpecimenTypeValuesInDB(id: NSNumber, specimenText: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpSpecimenType", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(specimenText, forKey: "specimenText")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
}

//MARK:- MicrobialFeatherPulpSampleInfo
extension MicrobialFeatherPulpSampleInfo{
    class func fetchDataPlatesToBeSynced(predicate: NSPredicate) -> [MicrobialFeatherPulpSampleInfo] {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherPulpSampleInfo]
            if let arrPlate = results {
                return arrPlate
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
        return []
    }
    
    
    class func updateSpecimenTypeId(value: Int, predicate: NSPredicate) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherPulpSampleInfo]
            if let arrPlate = results {
                for i in 0..<arrPlate.count{
                    results?[i].setValue(value, forKey: "specimenTypeId")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func updateFarmDetails(key: String, value: String, predicate: NSPredicate) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherPulpSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherPulpSampleInfo]
            if let arrPlate = results {
                for i in 0..<arrPlate.count{
                    results?[i].setValue(value, forKey: key)
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func addSingleFarmDetails(isSessionPlate: Bool, plateId: Int, timeStamp: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpSampleInfo", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(isSessionPlate, forKey: "isSessionPlate")
        person.setValue(plateId, forKey: "plateId")
        person.setValue(timeStamp, forKey: "timeStamp")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    class func insertAlreadySyncedFarmData(microbialFeatherDetailsList: MicrobialFeatherDetailsList, timeStamp: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpSampleInfo", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(false, forKey: "isSessionPlate")
        person.setValue(1, forKey: "plateId")
        person.setValue(timeStamp, forKey: "timeStamp")
        person.setValue("\(microbialFeatherDetailsList.AgeDays ?? 0)", forKey: "days")
        person.setValue("\(microbialFeatherDetailsList.Farm ?? "")", forKey: "farmName")
        person.setValue("\(microbialFeatherDetailsList.SamplesCount ?? 0)", forKey: "noOfSamples")
        person.setValue(FeatherPulpVC.getSpecimenFromItsId(id: microbialFeatherDetailsList.SpecimenTypeId ?? 0), forKey: "specimenType")
        person.setValue(microbialFeatherDetailsList.SpecimenTypeId ?? 0, forKey: "specimenTypeId")
        person.setValue("\(microbialFeatherDetailsList.AgeWeeks ?? 0)", forKey: "weeks")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    class func updatePlateIdGenerates(entity: String, predicate: NSPredicate, barcode: String) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherPulpSampleInfo]
            if let arrPlate = results {
                for i in 0..<arrPlate.count{
                    results?[i].setValue("\(barcode)-\(i + 1)", forKey: "plateIdGenerated")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
}


//MARK:- MicrobialFeatherpulpServiceTestSampleInfo
extension MicrobialFeatherpulpServiceTestSampleInfo{
    
    class func deleteWithPredicatesFeaherPulpSampleInfo() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherpulpServiceTestSampleInfo")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate.init(format: "isSessionType==\(1)")
        if let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            for obj in objects {
                appDelegate.managedObjectContext.delete(obj as! NSManagedObject)
            }
            
            do {
                try appDelegate.managedObjectContext.save() // <- remember to put this :)
            } catch {
                // Do something... fatalerror
            }
        }
    }
    
    class func saveFirstTimeTestOptionValuesInDB(timeStamp: String, testId: NSNumber, testType: String, isSessionType: Bool, isCheckBoxSelected: Bool) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherpulpServiceTestSampleInfo", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(timeStamp, forKey: "timeStamp")
        managedObject.setValue(testId, forKey: "testId")
        managedObject.setValue(testType, forKey: "testType")
        managedObject.setValue(isSessionType, forKey: "isSessionType")
        managedObject.setValue(isCheckBoxSelected, forKey: "isCheckBoxSelected")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    class func fetchDataOfTestOptions(predicate: NSPredicate) -> [MicrobialFeatherpulpServiceTestSampleInfo] {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherpulpServiceTestSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherpulpServiceTestSampleInfo]
            if let arrPlate = results {
                return arrPlate
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
        return []
    }
    
    class func updateBoolTypesTestOptions(key: String, value: Bool, predicate: NSPredicate) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherpulpServiceTestSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherpulpServiceTestSampleInfo]
            if let arrPlate = results {
                for i in 0..<arrPlate.count{
                    results?[i].setValue(value, forKey: key)
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func updateDataOfTestOptions(key: String, value: String, predicate: NSPredicate) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialFeatherpulpServiceTestSampleInfo")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [MicrobialFeatherpulpServiceTestSampleInfo]
            if let arrPlate = results {
                for i in 0..<arrPlate.count{
                    results?[i].setValue(value, forKey: key)
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
}



//MARK:- MicrobialFeatherPulpTestOptions
extension MicrobialFeatherPulpTestOptions{
    class func saveTestOptionValuesInDB(id: NSNumber, text: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialFeatherPulpTestOptions", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
}


extension MicrobialCaseStatus{
    class func saveCaseStatus(id: NSNumber, text: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialCaseStatus", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(id, forKey: "id")
        managedObject.setValue(text, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
}

extension Microbial_EnviromentalSurveyFormSubmitted{
    
    class func saveDataWhichIsAlreadySynced(reqData: MicrobialDetailsList, reqText: String, reqId: Int, isPlateIdGenerated: Bool, reviewerText: String) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_EnviromentalSurveyFormSubmitted", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        managedObject.setValue(reqData.timeStamp, forKey: "timeStamp")
        managedObject.setValue(UserDefaults.standard.value(forKey: "Id") ?? 0, forKey: "userId")
        managedObject.setValue(reqData.visitReason ?? 0, forKey: "reasonForVisitId")
        
        if let typeOfBirdId = reqData.typeOfBirdId{
            managedObject.setValue(FeatherPulpVC.getTypeOfBirdFromItsId(id: typeOfBirdId), forKey: "typeOfBird")
        }else{
            managedObject.setValue("", forKey: "typeOfBird")
        }
        
        managedObject.setValue(reqData.typeOfBirdId ?? 0, forKey: "typeOfBirdId")
        managedObject.setValue(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "", forKey: "requestor")
        managedObject.setValue(isPlateIdGenerated, forKey: "isPlateIdGenerated")
        managedObject.setValue(reqData.deviceId ?? "", forKey: "syncDeviceId")
        
        if let visitReasonId = reqData.visitReason {
            managedObject.setValue(RequisitionModel().getReasonForVisitFromItsId(reasonForVisitId: visitReasonId), forKey: "reasonForVisit")
        } else {
            managedObject.setValue("", forKey: "reasonForVisit")
        }
        managedObject.setValue(reqData.conductedType ?? 0, forKey: "surveyConductedOnId")
        managedObject.setValue(reqData.purposeType ?? 0, forKey: "purposeOfSurveyId")
        
        if let purposeType = reqData.purposeType {
            managedObject.setValue(RequisitionModel().getPurposeOfSurveyFromItsId(purposeOfSurveyId: purposeType), forKey: "purposeOfSurvey")
        } else {
            managedObject.setValue("", forKey: "purposeOfSurvey")
        }
        
        managedObject.setValue(0, forKey: "reviewerId")
        managedObject.setValue(reviewerText, forKey: "reviewer")
        managedObject.setValue(reqData.customerId ?? 0, forKey: "companyId")
        
        if let customerId = reqData.customerId{
            managedObject.setValue(RequisitionModel().getCompanyfromId(id: customerId), forKey: "company")
        } else {
            managedObject.setValue("", forKey: "company")
        }
        
        managedObject.setValue(reqData.siteId ?? 0, forKey: "siteId")
        
        if let siteId = reqData.siteId {
            managedObject.setValue(RequisitionModel().getSiteIdforSelectedSite(id: siteId), forKey: "site")
        } else {
            managedObject.setValue("", forKey: "site")
        }
        
        managedObject.setValue(reqData.barcode ?? "", forKey: "barcode")
        managedObject.setValue(reqData.sampleDate ?? "", forKey: "sampleCollectionDate")
        managedObject.setValue(true, forKey: "isSynced")
        managedObject.setValue(reqData.deviceId ?? "", forKey: "syncDeviceId")
        managedObject.setValue(reqData.notes ?? "", forKey: "notes")
        managedObject.setValue(reqData.conductedType ?? 0, forKey: "surveyConductedOnId")
        
        if let conductedType = reqData.conductedType {
            managedObject.setValue(RequisitionModel().getSurveyConductedOnFromItsId(surveyConductedOnId: conductedType), forKey: "surveyConductedOn")
        } else {
            managedObject.setValue("", forKey: "surveyConductedOn")
        }
        managedObject.setValue(reqId, forKey: "requisitionType")
        managedObject.setValue(reqData.barcode ?? "", forKey: "requisition_Id")
        managedObject.setValue(reqData.sessionStatus ?? 0, forKey: "sessionStatus")
        managedObject.setValue(reqData.status ?? 0, forKey: "reqStatus")
        managedObject.setValue(reqData.requisitionNo ?? "", forKey: "reqNo")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
    class func doReqOfSameSiteAndSameDateExists(siteId: Int, sampleCollectionDate: String, reqType: Int, sessionStatus: SessionStatus) -> Bool{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        let userId = UserDefaults.standard.value(forKey: "Id") ?? 0
        if sessionStatus == .submitted {
            fetchRequest.predicate = NSPredicate(format: "siteId == %@ AND userId == %d AND sampleCollectionDate == %@ AND requisitionType == %d AND sessionStatus == %d", argumentArray: [siteId, userId, sampleCollectionDate, reqType, SessionStatus.submitted.rawValue])
        } else {
            fetchRequest.predicate = NSPredicate(format: "siteId == %@ AND userId == %d AND sampleCollectionDate == %@ AND requisitionType == %d", argumentArray: [siteId, userId, sampleCollectionDate, reqType])
        }
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_EnviromentalSurveyFormSubmitted]
            if let results = fetchedResult {
                return results.count > 0
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    class func isSameTimeStampAndUserIdAlreadyExisits(reqData: MicrobialDetailsList) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        let userId = UserDefaults.standard.value(forKey: "Id") ?? 0
        fetchRequest.predicate = NSPredicate(format: "timeStamp == %@ AND userId == %d", argumentArray: [reqData.timeStamp ?? "", userId])
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_EnviromentalSurveyFormSubmitted]
            if let results = fetchedResult {
                return results.count > 0
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    
    class func dataToBeSynced(requisitionType: Int) -> NSArray {
        var dataArray6 = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        let userId = UserDefaults.standard.value(forKey: "Id") ?? 0
        fetchRequest.predicate = NSPredicate(format: "requisitionType == \(requisitionType) AND userId == \(userId) AND isSynced == 0")
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_EnviromentalSurveyFormSubmitted]
            if let results = fetchedResult {
                dataArray6 = results as NSArray
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray6
    }
    
    class func fetchSubmittedOrSaveAsDraftRequisitionsForGraphs(sessionStatus: Int, requisitionType: Int) -> NSArray {
        var dataArray9 = NSArray()
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        let userId = UserDefaults.standard.value(forKey: "Id") ?? 0
        fetchRequest.predicate = NSPredicate(format: "sessionStatus == \(sessionStatus) AND requisitionType == \(requisitionType) AND userId == \(userId)")
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_EnviromentalSurveyFormSubmitted]
            if let results = fetchedResult {
                dataArray9 = results as NSArray
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray9
    }
    
    class func updateCaseStatusOfReq(timeStamp: String, caseStatus: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp2, argumentArray: [timeStamp])
        if let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            for obj in objects {
                (obj as! Microbial_EnviromentalSurveyFormSubmitted).setValue(caseStatus, forKey: "reqStatus")
                do {
                    try appDelegate.managedObjectContext.save() // <- remember to put this :)
                } catch {
                    // Do something... fatalerror
                }
            }
        }
    }
    
    class func updateSyncCheckForAll(reqType: Int, sessionStatus: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        fetchRequest.predicate = NSPredicate(format: "requisitionType == \(reqType) AND sessionStatus == \(sessionStatus)", argumentArray: [])
        if let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            for obj in objects {
                (obj as! Microbial_EnviromentalSurveyFormSubmitted).setValue(true, forKey: "isSynced")
                do {
                    try appDelegate.managedObjectContext.save() // <- remember to put this :)
                } catch {
                    // Do something... fatalerror
                }
            }
        }
    }
}

extension Microbial_LocationTypeHeadersSubmitted{
    
    class func isSameTimeStampAlreadyExistsInHeader(reqData: MicrobialDetailsList, section: Int) -> Bool{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "timeStamp == %@ AND section == %d", argumentArray: [reqData.timeStamp ?? "", section])
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeadersSubmitted]
            if let results = fetchedResult {
                return results.count > 0
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    class func saveSampleInfoHeaderDataInToDB_Enviromental(reqDetails: MicrobialDetailsList, headerDetails: MicrobialSampleDetailsList, reqId: Int, reqName: String, numOfPlates: Int) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeadersSubmitted", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        managedObject.setValue(reqDetails.sampleDate ?? "", forKey: "currentdate")
        managedObject.setValue("", forKey: "customerId")
        managedObject.setValue(reqId, forKey: "requisitionType")
        managedObject.setValue(reqDetails.status ?? 0, forKey: "sessionStatus")
        
        managedObject.setValue(RequisitionModel().getLocationType(id: headerDetails.locationType ?? 0, reqType: reqId), forKey: "locationType")
        managedObject.setValue(headerDetails.locationType ?? 0, forKey: "locationTypeId")
        managedObject.setValue(numOfPlates, forKey: "noOfPlates")
        managedObject.setValue(headerDetails.section ?? 0, forKey: "section")
        managedObject.setValue(reqDetails.barcode ?? "", forKey: "requisition_Id")
        managedObject.setValue(reqDetails.timeStamp ?? "", forKey: "timeStamp")
        
        do {
            try appDelegate?.managedObjectContext.save()
        } catch { }
    }
    
    class func incrementNumOfPlates(reqDetails: MicrobialDetailsList, section: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        
        fetchRequest.predicate = NSPredicate(format: "timeStamp = %@  AND section == %d", argumentArray: [reqDetails.timeStamp ?? "", section])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for data in results ?? []{
                    data.setValue((data.value(forKey: "noOfPlates") as! Int) + 1, forKey: "noOfPlates")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func updateBarcode(barCode: String, timeStamp: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeadersSubmitted")
        
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp, argumentArray: [timeStamp])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for data in results ?? []{
                    data.setValue(barCode, forKey: "requisition_Id")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
}


extension Microbial_LocationTypeHeaderPlatesSubmitted{
    
    class func updateSection(prevSection: Int, newSection: Int, timeStamp: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlatesSubmitted")
        let predicate = NSPredicate(format: "timeStamp = %@ AND section = %i", argumentArray: [timeStamp, prevSection])
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [Microbial_LocationTypeHeaderPlatesSubmitted]
            if results?.count != 0 { // Atleast one was returned
                for index in 0..<results!.count{
                    results![index].setValue(newSection , forKey: "section")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    class func updateBarcode(barCode: String, timeStamp: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlatesSubmitted")
        
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp, argumentArray: [timeStamp])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for data in results ?? []{
                    data.setValue(barCode, forKey: "requisition_Id")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func saveSampleInfoPlateDataInToDB_Enviromental(_ data: CoreDataHandlerMicrodataModels.envPlateSampleInfo) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeaderPlatesSubmitted", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(data.currentDate, forKey: "currentdate")
        managedObject.setValue(data.customerId, forKey: "customerId")
        managedObject.setValue(data.requisitionType, forKey: "requisitionType")
        managedObject.setValue(data.sessionStatus, forKey: "sessionStatus")
        managedObject.setValue(data.isMicoscoreChecked, forKey: "isMicoscoreChecked")
        managedObject.setValue(data.isBacterialChecked, forKey: "isBacterialChecked")
        managedObject.setValue(data.locationTypeId, forKey: "locationTypeId")
        managedObject.setValue(data.mediaTypeId, forKey: "mediaTypeId")
        managedObject.setValue(data.samplingMethodTypeId, forKey: "samplingMethodTypeId")
        managedObject.setValue(data.plateId, forKey: "plateId")
        managedObject.setValue(data.row, forKey: "row")
        managedObject.setValue(data.sampleDescription, forKey: "sampleDescription")
        managedObject.setValue(data.section, forKey: "section")
        managedObject.setValue(data.requisitionId, forKey: "requisition_Id")
        managedObject.setValue(data.timeStamp, forKey: "timeStamp")
        managedObject.setValue(data.locationValueId, forKey: "locationValueId")
        managedObject.setValue(data.notes, forKey: "notes")
        managedObject.setValue(RequisitionModel().getLocationValuesFromIds(id: data.locationValueId), forKey: "locationValue")
        
        do {
            try context.save()
        } catch { }
    }

    class func saveSampleInfoPlateDataInToDB(sampleInfo: CoreDataHandlerMicrodataModels.SampleInfoPlate) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeaderPlatesSubmitted", in: appDelegate!.managedObjectContext)
        let managedObject = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        
        managedObject.setValue(sampleInfo.currentdate, forKey: "currentdate")
        managedObject.setValue(sampleInfo.customerId, forKey: "customerId")
        managedObject.setValue(sampleInfo.requisitionType, forKey: "requisitionType")
        managedObject.setValue(sampleInfo.sessionStatus, forKey: "sessionStatus")
        managedObject.setValue(sampleInfo.isMicoscoreChecked, forKey: "isMicoscoreChecked")
        managedObject.setValue(sampleInfo.isBacterialChecked, forKey: "isBacterialChecked")
        managedObject.setValue(sampleInfo.locationTypeId, forKey: "locationTypeId")
        managedObject.setValue(sampleInfo.plateId, forKey: "plateId")
        managedObject.setValue(sampleInfo.row, forKey: "row")
        managedObject.setValue(sampleInfo.sampleDescription, forKey: "sampleDescription")
        managedObject.setValue(sampleInfo.section, forKey: "section")
        managedObject.setValue(sampleInfo.requisition_Id, forKey: "requisition_Id")
        managedObject.setValue(sampleInfo.timeStamp, forKey: "timeStamp")
        managedObject.setValue(RequisitionModel().getLocationValues(selectedValue: sampleInfo.locationValue), forKey: "locationValueId")
        managedObject.setValue(sampleInfo.locationValue, forKey: "locationValue")
        managedObject.setValue(sampleInfo.mediaTypeValue, forKey: "mediaTypeValue")
        managedObject.setValue(sampleInfo.mediaTypeId, forKey: "mediaTypeId")
        managedObject.setValue(sampleInfo.notes, forKey: "notes")
        managedObject.setValue(sampleInfo.samplingMethodTypeValue, forKey: "samplingMethodTypeValue")
        managedObject.setValue(sampleInfo.samplingMethodTypeId, forKey: "samplingMethodTypeId")

        do {
            try appDelegate?.managedObjectContext.save()
        } catch { }
    }

    
    class func deleteAndUpdateCountSampleInfoPlateDataInToDB_Enviromental(predicate: NSPredicate){
        let entity = "Microbial_LocationTypeHeaderPlatesSubmitted"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequestOfPlates = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequestOfPlates.predicate = predicate
        //NSPredicate(format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i AND locationTypeId = %i AND row = %i", argumentArray: [timeStamp, requisition_Id, requisitionType, section, locationTypeId, row])
        do {
            let results = try context.fetch(fetchRequestOfPlates)
            if results.count > 0{
                for obj in results{
                    context.delete(obj as! NSManagedObject)
                    try context.save()
                }
            }
        } catch {
            //   print("ERROR - deleting")
        }
    }
    
    class func fetchEnviromentalPlatesWith(timeStamp: String) -> [Microbial_LocationTypeHeaderPlatesSubmitted] {
        
        var dataArray1 = [Microbial_LocationTypeHeaderPlatesSubmitted]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlatesSubmitted")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp2, timeStamp)
        
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [Microbial_LocationTypeHeaderPlatesSubmitted]
            if let results = fetchedResult {
                dataArray1 = results
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray1
    }
    
    class func updateSampleInfoPlateDataInToDB_Enviromental(sampleInfo: CoreDataHandlerMicrodataModels.environmentalSampleInfoPlate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Microbial_LocationTypeHeaderPlatesSubmitted")
        
        fetchRequest.predicate = NSPredicate(format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i AND locationTypeId = %i AND row = %i", argumentArray: [sampleInfo.timeStamp, sampleInfo.requisition_Id, sampleInfo.requisitionType, sampleInfo.section, sampleInfo.locationTypeId, sampleInfo.row])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                for data in results ?? [] {
                    data.setValue(sampleInfo.currentdate, forKey: "currentdate")
                    data.setValue(sampleInfo.customerId, forKey: "customerId")
                    data.setValue(sampleInfo.requisitionType, forKey: "requisitionType")
                    data.setValue(sampleInfo.sessionStatus, forKey: "sessionStatus")
                    data.setValue(sampleInfo.isBacterialChecked, forKey: "isBacterialChecked")
                    data.setValue(sampleInfo.isMicoscoreChecked, forKey: "isMicoscoreChecked")
                    data.setValue(sampleInfo.locationTypeId, forKey: "locationTypeId")
                    data.setValue(sampleInfo.locationValue, forKey: "locationValue")
                    data.setValue(sampleInfo.mediaTypeValue, forKey: "mediaTypeValue")
                    data.setValue(sampleInfo.plateId, forKey: "plateId")
                    data.setValue(sampleInfo.row, forKey: "row")
                    data.setValue(sampleInfo.sampleDescription, forKey: "sampleDescription")
                    data.setValue(sampleInfo.section, forKey: "section")
                    data.setValue(sampleInfo.requisition_Id, forKey: "requisition_Id")
                    data.setValue(sampleInfo.timeStamp, forKey: "timeStamp")
                    data.setValue(sampleInfo.locationValueId, forKey: "locationValueId")
                    data.setValue(sampleInfo.mediaTypeId, forKey: "mediaTypeId")
                    data.setValue(sampleInfo.notes, forKey: "notes")
                    data.setValue(sampleInfo.samplingMethodTypeId, forKey: "samplingMethodTypeId")
                    data.setValue(sampleInfo.samplingMethodTypeValue, forKey: "samplingMethodTypeValue")
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Microbial_LocationTypeHeaderPlatesSubmitted", in: context)
                let managedObject = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObject.setValue(sampleInfo.currentdate, forKey: "currentdate")
                managedObject.setValue(sampleInfo.customerId, forKey: "customerId")
                managedObject.setValue(sampleInfo.requisitionType, forKey: "requisitionType")
                managedObject.setValue(sampleInfo.sessionStatus, forKey: "sessionStatus")
                managedObject.setValue(sampleInfo.isMicoscoreChecked, forKey: "isMicoscoreChecked")
                managedObject.setValue(sampleInfo.isBacterialChecked, forKey: "isBacterialChecked")
                managedObject.setValue(sampleInfo.locationTypeId, forKey: "locationTypeId")
                managedObject.setValue(sampleInfo.locationValue, forKey: "locationValue")
                managedObject.setValue(sampleInfo.mediaTypeValue, forKey: "mediaTypeValue")
                managedObject.setValue(sampleInfo.plateId, forKey: "plateId")
                managedObject.setValue(sampleInfo.row, forKey: "row")
                managedObject.setValue(sampleInfo.sampleDescription, forKey: "sampleDescription")
                managedObject.setValue(sampleInfo.section, forKey: "section")
                managedObject.setValue(sampleInfo.requisition_Id, forKey: "requisition_Id")
                managedObject.setValue(sampleInfo.timeStamp, forKey: "timeStamp")
                managedObject.setValue(sampleInfo.locationValueId, forKey: "locationValueId")
                managedObject.setValue(sampleInfo.mediaTypeId, forKey: "mediaTypeId")
                managedObject.setValue(sampleInfo.notes, forKey: "notes")
                managedObject.setValue(sampleInfo.samplingMethodTypeId, forKey: "samplingMethodTypeId")
                managedObject.setValue(sampleInfo.samplingMethodTypeValue, forKey: "samplingMethodTypeValue")
            }
        } catch {
            // Handle fetch error
        }
        
        do {
            try context.save()
        } catch {
            // Handle save error
        }
    }
}

extension Microbial_EnvironmentalLocationTypes{
    class func saveLocationTypesInDB(_ locationId: NSNumber, locationName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_EnvironmentalLocationTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(locationId, forKey: "id")
        person.setValue(locationName, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
}

extension Microbial_BacterialLocationTypes{
    class func saveLocationTypesInDB(_ locationId: NSNumber, locationName: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Microbial_BacterialLocationTypes", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(locationId, forKey: "id")
        person.setValue(locationName, forKey: "text")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
}


extension MicrobialSelectedUnselectedReviewer{
    
    class func deleteReviewer(predicate: NSPredicate){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        if let fetchedResult = try? appDelegate.managedObjectContext.fetch(fetchRequest) as? [MicrobialSelectedUnselectedReviewer] {
                for obj in fetchedResult {
                    appDelegate.managedObjectContext.delete(obj as NSManagedObject)
                }
            do {
                try appDelegate.managedObjectContext.save() // <- remember to put this :)
            } catch {
            }
        }
    }
    
    class func fetchDetailsForReviewer(predicate: NSPredicate) -> [MicrobialSelectedUnselectedReviewer] {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [MicrobialSelectedUnselectedReviewer]
            if let results = fetchedResult {
                return results
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return []
        
    }
    
    
    class func deleteDraftType(timeStamp: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: appDelegate.timeStamp, timeStamp)
        if let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            for obj in objects {
                appDelegate.managedObjectContext.delete(obj as! NSManagedObject)
            }
            
            do {
                try appDelegate.managedObjectContext.save() // <- remember to put this :)
            } catch {
                // Do something... fatalerror
            }
        }
    }
    
    class func deleteSessionType() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate.init(format: "isSessionType==\(1)")
        if let objects = try? appDelegate.managedObjectContext.fetch(fetchRequest) {
            for obj in objects {
                appDelegate.managedObjectContext.delete(obj as! NSManagedObject)
            }
            
            do {
                try appDelegate.managedObjectContext.save() // <- remember to put this :)
            } catch {
                // Do something... fatalerror
            }
        }
    }
    
    
    class func updateBoolValueOfReviewer(predicate: NSPredicate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for data in results ?? []{
                    let isSelected = data.value(forKey: "isSelected") as! Bool
                    data.setValue(!isSelected, forKey: "isSelected")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    
    class func updateTimeStampFromSession(predicate: NSPredicate, timeStamp: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                for data in results ?? []{
                    data.setValue(timeStamp, forKey: "timeStamp")
                    data.setValue(false, forKey: "isSessionType")
                }
            }
        } catch {
            //   print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            //   print("Saving Core Data Failed: \(error)")
        }
    }
    
    class func doReviewersExisitsFortheTimeStamp(predicate: NSPredicate) -> Bool{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "MicrobialSelectedUnselectedReviewer")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        do {
            let fetchedResult = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [MicrobialSelectedUnselectedReviewer]
            if let results = fetchedResult {
                return results.count > 0
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return false
    }
    
    class func saveReviewersInDB(_ timeStamp: String, reviewerId: Int, reviewerName: String, isSelected: Bool, isSessionType: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let entity = NSEntityDescription.entity(forEntityName: "MicrobialSelectedUnselectedReviewer", in: appDelegate!.managedObjectContext)
        let person = NSManagedObject(entity: entity!, insertInto: appDelegate!.managedObjectContext)
        person.setValue(isSelected, forKey: "isSelected")
        person.setValue(isSessionType, forKey: "isSessionType")
        person.setValue(reviewerId, forKey: "reviewerId")
        person.setValue(reviewerName, forKey: "reviewerName")
        person.setValue(timeStamp, forKey: "timeStamp")
        do {
            try appDelegate?.managedObjectContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
}

//
//  CoreDataHandlerTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 02/04/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandlerTurkey: NSObject {
    
    override init() {
        super.init()
        self.setupContext()
    }
    
    func setupContext()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
    }
    
    // MARK: - VARIABLES
    //// Posting Session Turkey Methods ////
    var postingSession = [NSManagedObject]()
    var postingArray = NSArray()
    var postingArrayVetArray = NSMutableArray()
    var managedContext : NSManagedObjectContext! = nil
    //
    //// Skelta Turkey Methods ////
    var dataSkeletaArray = NSArray ()
    var settingsSkeletaObject = [NSManagedObject]()
    var cocoivacc = [NSManagedObject]()
    
    //// Cocci Turkey Methods ////
    var dataCociiaArray = NSArray ()
    var settingsCocoii = [NSManagedObject]()
    
    //// Gitract Turkey Methods ////
    var dataGiTractArray = NSArray ()
    var settingsGITract = [NSManagedObject]()
    
    //// Resp Turkey Methods ////
    var dataRespiratoryArray = NSArray()
    var settingsRespiratory  = [NSManagedObject]()
    
    //// Immune Turkey Methods ////
    var settingsImmune = [NSManagedObject]()
    var dataImmuneArray = NSArray()
    
    // addvaccination ///
    var hatcheryVaccinationObject = [NSManagedObject]()
    var dataArray = NSArray ()
    var FieldVaccindataArray = NSArray ()
    
    /// Sales Rep////
    var SalesRepDataArray = NSArray()
    var SalesRepData = [NSManagedObject]()
    
    /// Cocci Program Array////
    
    var CocoiiProgramArray = NSArray()
    var CocoiiProgram = [NSManagedObject]()
    var SessionTypeArray = NSArray()
    var BirdSizeArray = NSArray()
    var necropsyNIdArray = NSMutableArray()
    var complexArray = NSArray()
    var routeData = [NSManagedObject]()
    var  moleCule = [NSManagedObject]()
    var CustData = [NSManagedObject]()
    var VetData = [NSManagedObject]()
    var BirdSize = [NSManagedObject]()
    var SessionType = [NSManagedObject]()
    var BreedType = [NSManagedObject]()
    var complexNsObJECT = [NSManagedObject]()
    var loginType = [NSManagedObject]()
    var cocciCoccidiosControl = [NSManagedObject]()
    var cocciAlternative = [NSManagedObject]()
    var cocciAntibotic = [NSManagedObject]()
    var cocciMyCoxtinBinders = [NSManagedObject]()
    var FeddProgram = [NSManagedObject]()
    var CustmerRep = [NSManagedObject]()
    var necrpsystep1 = [NSManagedObject]()
    var captureSkeletaObject = [NSManagedObject]()
    var captureBirdWithNotesObject = [NSManagedObject]()
    var capturePhotoObject = [NSManagedObject]()
    var FarmsTypeObject = [NSManagedObject]()
    
    var farmsArrReturn = NSArray ()
    var custRep = NSArray ()
    var routeArray = NSArray()
    var custArray = NSArray()
    var BreedTypeArray = NSArray()
    var VeterianTypeArray = NSArray()
    var loginArray = NSArray()
    var cocciControlArray = NSArray()
    var AlternativeArray = NSArray()
    var AntiboticArray = NSArray()
    var MyCoxtinBindersArray = NSArray()
    var feedprogramArray = NSArray()
    var openExistingArray = NSArray()
    var necropsyStep1Array = NSArray()
    var necropsySArray = NSMutableArray()
    var captureNecSkeltetonArray = NSArray ()
    var obsNameWithPoint = NSMutableArray ()
    var fecthPhotoArray = NSArray ()
    var fetchBirdNotesArray = NSArray ()
    
    /********* ConvertIng sessiondate *****************/
    
    // MARK: - METHODS AND FUNCTIONS
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
    
    /********* Add Vacination *******************************************/
    
    func saveHatcheryVacinationInDatabaseTurkey(vaccination:CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataArray = vaccination.dbArray
        
        if dataArray.count > 0 {
            if let objTable: HatcheryVacTurkey = dataArray[vaccination.index] as? HatcheryVacTurkey {
                objTable.setValue(vaccination.type, forKey: "type")
                objTable.setValue(vaccination.strain, forKey: "strain")
                objTable.setValue(vaccination.route, forKey: "route")
                objTable.setValue(vaccination.age, forKey: "age")
                objTable.setValue(vaccination.postingId, forKey: "postingId")
                objTable.setValue(vaccination.vaciProgram, forKey: "vaciNationProgram")
                objTable.setValue(vaccination.sessionId, forKey: "loginSessionId")
                objTable.setValue(vaccination.isSync, forKey: "isSync")
                objTable.setValue(vaccination.lngId, forKey: "lngId")
            }
            do {
                try managedContext.save()
            }
            catch {
                // Handle error
            }
        }
        else {
            let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(vaccination.type, forKey: "type")
            person.setValue(vaccination.strain, forKey: "strain")
            person.setValue(vaccination.route, forKey: "route")
            person.setValue(vaccination.age, forKey: "age")
            person.setValue(vaccination.postingId, forKey: "postingId")
            person.setValue(vaccination.vaciProgram, forKey: "vaciNationProgram")
            person.setValue(vaccination.sessionId, forKey: "loginSessionId")
            person.setValue(vaccination.isSync, forKey: "isSync")
            person.setValue(vaccination.lngId, forKey: "lngId")
            
            do {
                try managedContext.save()
            }
            catch {
                // Handle error
            }
            
            hatcheryVaccinationObject.append(person)
        }
    }
    
    func fetchAddvacinationDataAllTurkey() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "HatcheryVacTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
            } else {
                
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
    }
    
    
    func fetchAddvacinationDataTurkey(_ postnigId : NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVacTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postnigId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    
    func fetchAddvacinationDataWithisSyncTurkey(_ postnigId : NSNumber , isSync : Bool) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVacTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postnigId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                
                dataArray = results as NSArray
                
            } else {
                
            }
        }
        catch {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
    }
    
    func fetchAllPostingSessionWithVetIdTurkey(_VetName :String) -> NSMutableArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "vetanatrionName == %@", _VetName)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult != nil
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: PostingSessionTurkey = (fetchedResult![i] as? PostingSessionTurkey)!
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
        catch {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArrayVetArray
    }

    
    
    func getHatcheryDataFromServerSingleFromDeviceIdTurkey(_ dict : NSDictionary,postingId:NSNumber)  {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
       
        self.managedContext = appDelegate!.managedObjectContext
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        for  j in 0..<allkeyArr.count {
            
            let stringValidate = allkeyArr.object(at: j) as! String
            let str = "hatchery"
            
            let index = stringValidate.index(stringValidate.startIndex, offsetBy: 8)
            let mySubstring = stringValidate[..<index]
            if  mySubstring != str {
                if  (stringValidate == "fieldStrain1") {
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("IBDV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain1"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute1Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge1"), forKey:"age")
                    person.setValue(postingId, forKey:"postingId")
                    
                    person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                    person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                    person.setValue(false, forKey:"isSync")
                    do {
                        try managedContext.save()
                    }
                    catch {
                    }
                    
                    hatcheryVaccinationObject.append(person)
                }
                
                
                else if(stringValidate == "fieldStrain2")   {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    person.setValue("IBDV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain2"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute2Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge2"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain3")  {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("IBV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain3"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute3Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge3"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain4")  {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("IBV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain4"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute4Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge4"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain5")  {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("TRT", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain5"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute5Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge5"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain6")  {
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("TRT", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain6"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute6Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge6"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain7")  {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("NDV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain7"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute7Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge7"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain8") {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("NDV", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain8"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute8Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge8"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain9") {
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("ST", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain9"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute9Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge9"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain10") {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("E.coli", forKey:"type")
                    person.setValue(dict.value(forKey: "fieldStrain10"), forKey:"strain")
                    switch dict.value(forKey: "fieldRoute10Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    person.setValue(dict.value(forKey: "fieldAge10"), forKey:"age")
                    
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
                else if (stringValidate == "fieldStrain11") {
                    
                    
                    
                    let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext)
                    
                    let person = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("Other", forKey:"type")
                    switch dict.value(forKey: "fieldRoute11Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
                    default:
                        person.setValue(" ", forKey:"route")
                    }
                    
                    
                    person.setValue(dict.object(forKey: "fieldStrain11"), forKey:"strain")
                    person.setValue(dict.object(forKey: "fieldAge11"), forKey:"age")
                    
                    person.setValue(postingId, forKey:"postingId")
                    person.setValue(dict.object(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                    person.setValue(dict.object(forKey: "sessionId"), forKey:"loginSessionId")
                    person.setValue(false, forKey:"isSync")
                    do
                    {
                        try managedContext.save()
                    }
                    catch {
                    }
                    
                    hatcheryVaccinationObject.append(person)
                }
            }
        }
        
    }

    func getFieldDataFromServerSingledataTurkey(_ dict : NSDictionary,postingId: NSNumber)  {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        
        for  j in 0..<allkeyArr.count{
            
            let stringValidate = allkeyArr.object(at: j) as! String
            let str = "field"
            
            let index = stringValidate.index(stringValidate.startIndex, offsetBy: 8)
            let mySubstring = stringValidate[..<index]
            if  mySubstring != str {
                
                
                if  (stringValidate == "hatcheryStrain1") {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    
                    person.setValue(dict.value(forKey: "hatcheryStrain1"), forKey:"strain")
                    person.setValue("Marek", forKey:"type")
                    switch dict.value(forKey: "hatcheryRoute1Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if(stringValidate == "hatcheryStrain2")   {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("IBDV", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain2"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute2Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain3")  {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("IBV", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain3"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute3Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain4")  {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("TRT", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain4"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute4Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain5")  {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("NDV", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain5"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute5Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain6")  {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("POX", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain6"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute6Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain7")  {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("Reo", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain7"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute7Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                
                
                else if (stringValidate == "hatcheryStrain8") {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("ST", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain8"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute8Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain9") {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("E.coli", forKey:"type")
                    person.setValue(dict.value(forKey: "hatcheryStrain9"), forKey:"strain")
                    switch dict.value(forKey: "hatcheryRoute9Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                else if (stringValidate == "hatcheryStrain10") {
                    let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
                    
                    let person         = NSManagedObject(entity: entity!, insertInto: managedContext)
                    person.setValue("Others", forKey:"type")
                    
                    
                    let d = dict.mutableCopy() as! NSMutableDictionary
                    let s = d.object(forKey: "hatcheryStrain10") as! String
                    person.setValue(s, forKey:"strain")
                    
                    switch dict.value(forKey: "hatcheryRoute10Id") as! Int {
                    case 1:
                        person.setValue("Wing-Web", forKey:"route")
                    case 2:
                        person.setValue("Drinking Water", forKey:"route")
                    case 3:
                        person.setValue("Spray", forKey:"route")
                    case 4:
                        person.setValue("In Ovo", forKey:"route")
                    case 5:
                        person.setValue("Subcutaneous", forKey:"route")
                    case 6:
                        person.setValue("Intramuscular", forKey:"route")
                    case 7:
                        person.setValue("Eye Drop", forKey:"route")
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
                
            }
            
        }
        
    }
    
    
    
    func getFieldDataFromServerTurkey(_ dict : NSDictionary)  {
        let entity         = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
        
        var allkeyArr = dict.allKeys as NSArray
        allkeyArr = allkeyArr.sorted(by: {($0 as! String).localizedStandardCompare($1 as! String) == .orderedAscending}) as NSArray
        for  j in 0..<allkeyArr.count{
            
            let person  = NSManagedObject(entity: entity!, insertInto: managedContext)
            let stringValidate = allkeyArr.object(at: j) as! String
            
            if  (stringValidate == "hatcheryStrain1") {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain1"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute1Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
                
            }
            else if(stringValidate == "hatcheryStrain2")   {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain2"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute2Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
                
            }
            else if (stringValidate == "hatcheryStrain3")  {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain3"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute3Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain4")  {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain4"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute4Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain5")  {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain5"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute5Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain6")  {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain6"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute6Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain7")  {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain7"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute7Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain8") {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain8"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute8Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
                
            }
            else if (stringValidate == "hatcheryStrain9") {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain9"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute9Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
            }
            else if (stringValidate == "hatcheryStrain10") {
                person.setValue("", forKey:"type")
                person.setValue(dict.value(forKey: "hatcheryStrain10"), forKey:"strain")
                switch dict.value(forKey: "hatcheryRoute10Id") as! Int {
                case 1:
                    person.setValue("Wing-Web", forKey:"route")
                case 2:
                    person.setValue("Drinking Water", forKey:"route")
                case 3:
                    person.setValue("Spray", forKey:"route")
                case 4:
                    person.setValue("In Ovo", forKey:"route")
                case 5:
                    person.setValue("Subcutaneous", forKey:"route")
                case 6:
                    person.setValue("Intramuscular", forKey:"route")
                case 7:
                    person.setValue("Eye Drop", forKey:"route")
                default:
                    person.setValue(" ", forKey:"route")
                }
                person.setValue(dict.value(forKey: "sessionId"), forKey:"postingId")
                person.setValue(dict.value(forKey: "vaccinationName"), forKey:"vaciNationProgram")
                person.setValue(dict.value(forKey: "sessionId"), forKey:"loginSessionId")
                person.setValue(false, forKey:"isSync")
                
            }
            do
            {
                try managedContext.save()
            }
            catch
            {
            }
            hatcheryVaccinationObject.append(person)
        }
    }
    // MARK: - Save Vaccination's Field Strain's Data for Turkey..
    func getHatcheryDataFromServerTurkey(_ dict : NSDictionary) {
        guard let entity = NSEntityDescription.entity(forEntityName: "HatcheryVacTurkey", in: managedContext) else {
            return
        }
        
        for i in 1...11 {
            guard let strain = dict["fieldStrain\(i)"] else { continue }
            
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            
            person.setValue("", forKey: "type")
            person.setValue(strain, forKey: "strain")
            
            if let routeId = dict["fieldRoute\(i)Id"] as? Int {
                let route = routeName(for: routeId)
                person.setValue(route, forKey: "route")
            }
            
            person.setValue(dict["fieldAge\(i)"], forKey: "age")
            person.setValue(dict["sessionId"], forKey: "postingId")
            person.setValue(dict["vaccinationName"], forKey: "vaciNationProgram")
            person.setValue(dict["sessionId"], forKey: "loginSessionId")
            person.setValue(false, forKey: "isSync")
            
            hatcheryVaccinationObject.append(person)
        }
        
        do {
            try managedContext.save()   // ✅ save once
        } catch {
            print("❌ Failed to save: \(error.localizedDescription)")
        }
    }

    /// Helper: Maps route IDs to names
    private func routeName(for id: Int) -> String {
        switch id {
        case 1: return "Wing-Web"
        case 2: return "Drinking Water"
        case 3: return "Spray"
        case 4: return "In Ovo"
        case 5: return "Subcutaneous"
        case 6: return "Intramuscular"
        case 7: return "Eye Drop"
        default: return " "
        }
    }

    
  
    /************************/
    
    func saveFieldVacinationInDatabaseTurkey(vaccinationData: CoreDataHandlerTurkeyModels.turkyVaccinationData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        FieldVaccindataArray = vaccinationData.dbArray

        if FieldVaccindataArray.count > 0 {
            if let objTable: FieldVaccinationTurkey = FieldVaccindataArray[vaccinationData.index] as? FieldVaccinationTurkey {
                objTable.setValue(vaccinationData.type, forKey: "type")
                objTable.setValue(vaccinationData.strain, forKey: "strain")
                objTable.setValue(vaccinationData.route, forKey: "route")
                objTable.setValue(vaccinationData.postingId, forKey: "postingId")
                objTable.setValue(vaccinationData.vaciProgram, forKey: "vaciNationProgram")
                objTable.setValue(vaccinationData.sessionId, forKey: "loginSessionId")
                objTable.setValue(vaccinationData.isSync, forKey: "isSync")
                objTable.setValue(vaccinationData.lngId, forKey: "lngId")
            }
            do {
                try managedContext.save()
            } catch {
                print("Error saving data")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "FieldVaccinationTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)

            person.setValue(vaccinationData.type, forKey: "type")
            person.setValue(vaccinationData.strain, forKey: "strain")
            person.setValue(vaccinationData.route, forKey: "route")
            person.setValue(vaccinationData.postingId, forKey: "postingId")
            person.setValue(vaccinationData.vaciProgram, forKey: "vaciNationProgram")
            person.setValue(vaccinationData.sessionId, forKey: "loginSessionId")
            person.setValue(vaccinationData.isSync, forKey: "isSync")
            person.setValue(vaccinationData.lngId, forKey: "lngId")

            do {
                try managedContext.save()
            } catch {
                print("Error saving data")
            }

            hatcheryVaccinationObject.append(person)
        }
    }
    
    func fetchFieldAddvacinationDataAllTurkey() -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
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
                
                
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return FieldVaccindataArray
        
    }
    
    func fetchFieldAddvacinationDataTurkey(_ postingId: NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                
                FieldVaccindataArray = results as NSArray
                
            }
            else
            {
                
                
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return FieldVaccindataArray
        
    }
    
    func fetchFieldAddvacinationDataWithisSyncTrueTurkey(_ postingId: NSNumber , isSync : Bool) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "postingId == %@ AND isSync == %@", postingId, NSNumber(booleanLiteral: isSync))
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                FieldVaccindataArray = results as NSArray
                
            }
            else
            {
                
                
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return FieldVaccindataArray
        
    }
    
    func updateisSyncValOnFieldAddvacinationDataTurkey(_ postingId: NSNumber , isSync  : Bool)
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let fetchArr = fetchedResult! as NSArray
            if fetchArr.count > 0 {
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
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    /*******************************  Setting data Base ********************************************************/
    /***************** save data Skleta ************************************************************************/
    
    
    func saveSettingsSkeletaInDatabaseTurkey(settingsData: CoreDataHandlerTurkeyModels.turkeySettingsSkeletaData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataSkeletaArray = settingsData.dbArray

        if dataSkeletaArray.count > 0 {
            if let objTable: SkeletaTurkey = dataSkeletaArray[settingsData.index] as? SkeletaTurkey {
                objTable.setValue(settingsData.strObservationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settingsData.visibilityCheck as Bool), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settingsData.quicklinks as Bool), forKey: "quicklinks")
                objTable.setValue(settingsData.strInformation, forKey: "information")
                objTable.setValue(settingsData.obsId, forKey: "observationId")
                objTable.setValue(settingsData.measure, forKey: "measure")
                objTable.setValue(settingsData.lngId, forKey: "lngId")
                objTable.setValue(settingsData.refId, forKey: "refId")
                objTable.setValue(settingsData.isSync, forKey: "isSync")
                objTable.setValue(settingsData.quicklinkIndex, forKey: "quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "SkeletaTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)

            person.setValue(settingsData.strObservationField, forKey: "observationField")
            person.setValue(NSNumber(value: settingsData.visibilityCheck as Bool), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settingsData.quicklinks as Bool), forKey: "quicklinks")
            person.setValue(settingsData.strInformation, forKey: "information")
            person.setValue(settingsData.obsId, forKey: "observationId")
            person.setValue(settingsData.measure, forKey: "measure")
            person.setValue(settingsData.isSync, forKey: "isSync")
            person.setValue(settingsData.lngId, forKey: "lngId")
            person.setValue(settingsData.refId, forKey: "refId")
            person.setValue(settingsData.quicklinkIndex, forKey: "quicklinkIndex")

            do {
                try managedContext.save()
            } catch {
                print(error)
            }

            settingsSkeletaObject.append(person)
        }
    }
    func updateSettingDataSkeltaTurkey(_ data: CoreDataHandlerTurkeyModels.updateTurkySkeletaSettings) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SkeletaTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, data.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let fetchedResult = fetchedResult, fetchedResult.count > 0 {
                for i in 0..<fetchedResult.count {
                    let objTable = fetchedResult[i] as! SkeletaTurkey
                    objTable.setValue(NSNumber(value: data.visibilityCheck), forKey: "visibilityCheck")
                    objTable.setValue(NSNumber(value: data.quicklinks), forKey: "quicklinks")
                    objTable.setValue(data.strInformation, forKey: "information")
                    objTable.setValue(data.isSync, forKey: "isSync")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        print("Error saving managed context: \(error)")
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAllSeettingdataTurkey() -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "SkeletaTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return dataSkeletaArray
        
    }
    
    func fetchAllSeettingdataWithLngIdTurkey(lngId:NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "SkeletaTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataSkeletaArray
        
    }
    
    /***************************** Save Setting  Data Cocoii Data ***********************************************/
    func saveSettingsCocoiiInDatabaseTurkey(data: CoreDataHandlerTurkeyModels.turkeyCoccidiosisSettings) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataCociiaArray = data.dbArray
        
        if dataCociiaArray.count > 0 {
            if let objTable: CoccidiosisTurkey = dataCociiaArray[data.index] as? CoccidiosisTurkey {
                objTable.setValue(data.strObservationField, forKey:"observationField")
                objTable.setValue(NSNumber(value: data.visibilityCheck as Bool), forKey:"visibilityCheck")
                objTable.setValue(NSNumber(value: data.quicklinks as Bool), forKey:"quicklinks")
                objTable.setValue(data.strInformation, forKey:"information")
                objTable.setValue(data.obsId, forKey:"observationId")
                objTable.setValue(data.measure, forKey:"measure")
                objTable.setValue(data.lngId, forKey:"lngId")
                objTable.setValue(data.isSync, forKey:"isSync")
                objTable.setValue(data.refId, forKey:"refId")
                objTable.setValue(data.quicklinkIndex, forKey:"quicklinkIndex")
            }
            
            do {
                try managedContext.save()
            } catch {
                // Handle the error if needed
            }
        } else {
            let entity  = NSEntityDescription.entity(forEntityName: "CoccidiosisTurkey", in: managedContext)
            let person  = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(data.strObservationField, forKey:"observationField")
            person.setValue(NSNumber(value: data.visibilityCheck as Bool), forKey:"visibilityCheck")
            person.setValue(NSNumber(value: data.quicklinks as Bool), forKey:"quicklinks")
            person.setValue(data.strInformation, forKey:"information")
            person.setValue(data.obsId, forKey:"observationId")
            person.setValue(data.measure, forKey:"measure")
            person.setValue(data.isSync, forKey:"isSync")
            person.setValue(data.lngId, forKey:"lngId")
            person.setValue(data.refId, forKey:"refId")
            person.setValue(data.quicklinkIndex, forKey:"quicklinkIndex")
            
            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            
            settingsCocoii.append(person)
        }
    }
    
    func updateSettingDataCocoiiTurkey(data: CoreDataHandlerTurkeyModels.updateCoccidiosisTurkeySettings) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoccidiosisTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, data.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: CoccidiosisTurkey = (fetchedResult![i] as? CoccidiosisTurkey)!
                    objTable.setValue(NSNumber(value: data.visibilityCheck), forKey: "visibilityCheck")
                    objTable.setValue(NSNumber(value: data.quicklinks), forKey: "quicklinks")
                    objTable.setValue(data.isSync, forKey: "isSync")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error here
                    }
                }
            }
        } catch {
            // Handle fetch error here
        }
    }

    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAllCocoiiDataTurkey() -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataCociiaArray = results as NSArray
                
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataCociiaArray
        
    }
    
    func fetchAllCocoiiDataUsinglngIdTurkey(lngId:NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.langIdPredicate, lngId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataCociiaArray = results as NSArray
                
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataCociiaArray
        
    }
    
    /******************************* Saving data Of GiTract********************************************/
    
    func saveSettingsGITractDatabaseTurkey(_ data: CoreDataHandlerTurkeyModels.turkeyGITractSettingsData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataGiTractArray = data.dbArray

        if dataGiTractArray.count > 0 {
            if let objTable = dataGiTractArray[data.index] as? GITractTurkey {
                objTable.setValue(data.observationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: data.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: data.quicklinks), forKey: "quicklinks")
                objTable.setValue(data.information, forKey: "information")
                objTable.setValue(data.obsId, forKey: "observationId")
                objTable.setValue(data.measure, forKey: "measure")
                objTable.setValue(data.lngId, forKey: "lngId")
                objTable.setValue(data.isSync, forKey: "isSync")
                objTable.setValue(data.refId, forKey: "refId")
                objTable.setValue(data.quicklinkIndex, forKey: "quicklinkIndex")
            }
            do {
                try managedContext.save()
            } catch {
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "GITractTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)

            person.setValue(data.observationField, forKey: "observationField")
            person.setValue(NSNumber(value: data.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: data.quicklinks), forKey: "quicklinks")
            person.setValue(data.information, forKey: "information")
            person.setValue(data.obsId, forKey: "observationId")
            person.setValue(data.measure, forKey: "measure")
            person.setValue(data.isSync, forKey: "isSync")
            person.setValue(data.lngId, forKey: "lngId")
            person.setValue(data.refId, forKey: "refId")
            person.setValue(data.quicklinkIndex, forKey: "quicklinkIndex")

            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }

            settingsGITract.append(person)
        }
    }
    
    func updateSettingDataGitractTurkey(_ data: CoreDataHandlerTurkeyModels.updateGITractSettingsData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GITractTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, data.refId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult, !results.isEmpty {
                for obj in results {
                    if let objTable = obj as? GITractTurkey {
                        objTable.setValue(NSNumber(value: data.visibilityCheck), forKey: "visibilityCheck")
                        objTable.setValue(NSNumber(value: data.quicklinks), forKey: "quicklinks")
                        objTable.setValue(data.isSync, forKey: "isSync")
                    }
                }
                try managedContext.save()
            }
        } catch {
            // Handle error if needed
        }
    }

    /************** Fetch data Of GiTract* ***************************************/
    
    func fetchAllGITractDataTurkey() -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "GITractTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                dataGiTractArray = results as NSArray
            }
            else {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataGiTractArray
        
    }
    
    func fetchAllGITractDataUsingLngIdTurkey(lngId:NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "GITractTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return dataGiTractArray
        
    }
    
    /******************** Saving data Of Respiratory *********************************/
    func saveSettingsRespiratoryDatabaseTurkey(_ settings: CoreDataHandlerTurkeyModels.turkeyRespiratorySettings) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataRespiratoryArray = settings.dbArray

        if dataRespiratoryArray.count > 0 {
            if let objTable = dataRespiratoryArray[settings.index] as? RespiratoryTurkey {
                objTable.setValue(settings.observationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                objTable.setValue(settings.information, forKey: "information")
                objTable.setValue(settings.observationId, forKey: "observationId")
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
            let entity = NSEntityDescription.entity(forEntityName: "RespiratoryTurkey", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)

            person.setValue(settings.observationField, forKey: "observationField")
            person.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
            person.setValue(settings.information, forKey: "information")
            person.setValue(settings.observationId, forKey: "observationId")
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

            settingsRespiratory.append(person)
        }
    }
    
    func updateSettingDataRespTurkey(_ settings: CoreDataHandlerTurkeyModels.turkeyRespiratorySettingsUpdate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RespiratoryTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settings.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: RespiratoryTurkey = (fetchedResult![i] as? RespiratoryTurkey)!
                    objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                    objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                    objTable.setValue(settings.isSync, forKey: "isSync")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error
                    }
                }
            }
            
        } catch {
            // Handle error
        }
    }

    /************** Fetch data Of Respiratory* ***************************************/
    
    func fetchAllRespiratoryTurkey() -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "RespiratoryTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                dataRespiratoryArray = results as NSArray
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataRespiratoryArray
        
    }
    
    func fetchAllRespiratoryusingLngIdTurkey(lngId:NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "RespiratoryTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return dataRespiratoryArray
        
    }
    
    
    /******************************* Saving data Of immune ********************************************/
    
    func saveSettingsImmuneDatabaseTurkey(_ settings: CoreDataHandlerTurkeyModels.turkeyImmuneSettings) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        dataImmuneArray = settings.dbArray
        
        if dataImmuneArray.count > 0 {
            if let objTable = dataImmuneArray[settings.index] as? ImmuneTurkey {
                objTable.setValue(settings.observationField, forKey: "observationField")
                objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                objTable.setValue(settings.information, forKey: "information")
                objTable.setValue(settings.observationId, forKey: "observationId")
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
            let entity = NSEntityDescription.entity(forEntityName: "ImmuneTurkey", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)

            person.setValue(settings.observationField, forKey: "observationField")
            person.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
            person.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
            person.setValue(settings.information, forKey: "information")
            person.setValue(settings.observationId, forKey: "observationId")
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
    
    func updateSettingDataImmuneTurkey(_ settings: CoreDataHandlerTurkeyModels.ImmuneSettingsUpdate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImmuneTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.refIdPredicater, settings.refId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable = fetchedResult![i] as! ImmuneTurkey
                    objTable.setValue(NSNumber(value: settings.visibilityCheck), forKey: "visibilityCheck")
                    objTable.setValue(NSNumber(value: settings.quicklinks), forKey: "quicklinks")
                    objTable.setValue(settings.information, forKey: "information")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error
                    }
                }
            }
        } catch {
            // Handle error
        }
    }

    
    /************** Fetch data Of immune* ***************************************/
    
    func fetchAllImmuneTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "ImmuneTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataImmuneArray
        
    }
    
    
    func fetchAllImmuneUsingLngIdTurkey(lngId:NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "ImmuneTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataImmuneArray
        
    }
    
    func updateSettingDataQuickIndex(_ strObservationField: String, obsId: NSNumber, quicklinkIndex: Int, entityName: String) {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "observationField == %@", strObservationField)
        
        do {
            
            guard let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return  }
            
            for entityObject in fetchedResult {
                
                switch entityName {
                    
                case "SkeletaTurkey":
                    let objTable: SkeletaTurkey = (entityObject as? SkeletaTurkey)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "CoccidiosisTurkey":
                    let objTable: CoccidiosisTurkey = (entityObject as? CoccidiosisTurkey)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "GITractTurkey":
                    let objTable: GITractTurkey = (entityObject as? GITractTurkey)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "RespiratoryTurkey":
                    let objTable: RespiratoryTurkey = (entityObject as? RespiratoryTurkey)!
                    objTable.setValue(quicklinkIndex, forKey:"quicklinkIndex")
                case "ImmuneTurkey":
                    let objTable: ImmuneTurkey = (entityObject as? ImmuneTurkey)!
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
    /**************** SAVING DATA ROUTE ****************************************************************/
    
    
    func saveRouteDatabaseTurkey(_ routeId : Int, routeName: String ,lngId:Int,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        routeArray = dbArray
        
        if routeArray.count > 0 {
            
            if let objTable: RouteTurkey = routeArray[index] as? RouteTurkey {
                
                objTable.setValue(routeId, forKey:"routeId")
                objTable.setValue(lngId, forKey:"lngId")
                objTable.setValue(routeName, forKey:"routeName")
                
                
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "RouteTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(routeId, forKey:"routeId")
            person.setValue(lngId, forKey:"lngId")
            person.setValue(routeName, forKey:"routeName")
            
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
    /**************** Fetch ROUTE ****************************************************************/
    
    
    func fetchRouteTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "RouteTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return routeArray
        
    }
    
    func fetchRouteTurkeyLngId(lngId:NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "RouteTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return routeArray
        
    }
    
    /**************** SAVING DATA ROUTE ****************************************************************/
    
    
    func saveCustmerDatabaseTurkey(_ custId : Int, CustName: String ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        custArray = dbArray
        
        if custArray.count > 0 {
            
            if let objTable: CustmerTurkey = routeArray[index] as? CustmerTurkey {
                
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
            
            let entity = NSEntityDescription.entity(forEntityName: "CustmerTurkey", in: managedContext)
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
    /**************** Fetch ROUTE ****************************************************************/
    
    
    func fetchCustomerTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustmerTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return custArray
        
    }
    
    func fetchCustomerWithComplexIdTurkey(_ complexId: NSNumber) -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustmerTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.complexIdPredicate, complexId)
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return custArray
        
    }
    
    func fetchCustomerWithCustIdTurkey(_ custId: NSNumber) -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustmerTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return custArray
        
    }
    
    /****************  Saving Data  SalesRepData Posting    **********************************************/
    func SalesRepDataDatabaseTurkey(_ salesReptId : Int, salesRepName: String ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        SalesRepDataArray = dbArray
        if SalesRepDataArray.count > 0 {
            if let objTable: SalesrepTurkey = SalesRepDataArray[index] as? SalesrepTurkey {
                
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
            
            let entity = NSEntityDescription.entity(forEntityName: "SalesrepTurkey", in: managedContext)
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
    /**************** Fetch ROUTE ****************************************************************/
    
    
    func fetchSalesrepTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "SalesrepTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return SalesRepDataArray
        
    }
    
    /**************** Fetch Sales Rep Name using Sales rep ID ****************************************************************/
    func fetchSalesrepName(byId salesId: Int) -> String? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SalesrepTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "salesReptId == %d", salesId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let result = fetchedResult?.first {
                return result.value(forKey: "salesRepName") as? String
            }
        } catch {
            print("Failed to fetch sales rep name for id \(salesId): \(error)")
        }
        
        return nil
    }
    /////////////////////////////SAVING DATA VetData  /////////////////////////////////////
    
    func VetDataDatabaseTurkey(_ vetarId : Int, vtName: String, complexId:NSNumber ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        VeterianTypeArray = dbArray
        
        if VeterianTypeArray.count > 0 {
            
            if let objTable: VeterationTurkey = VeterianTypeArray[index] as? VeterationTurkey {
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
            
            let entity = NSEntityDescription.entity(forEntityName: "VeterationTurkey", in: managedContext)
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
    /**************** Fetch ROUTE ****************************************************************/
    
    
    func fetchVetDataTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "VeterationTurkey")
        
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return VeterianTypeArray
        
    }
    
    
    
    func fetchVetDataPrdicateTurkey(_ complexId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "VeterationTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.complexIdPredicate, complexId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                VeterianTypeArray = results as NSArray
                
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        
        return VeterianTypeArray
        
    }
    
    ///////////////////   SAVING DATA Cocci Program   //////////////////////////////
    
    
    func CocoiiProgramDatabaseTurkey(_ cocoiiId : Int, cocoiProgram: String ,lngId: Int,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        CocoiiProgramArray = dbArray
        
        if CocoiiProgramArray.count > 0 {
            
            if let objTable: CocciProgramPostingTurkey = CocoiiProgramArray[index] as? CocciProgramPostingTurkey {
                
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
            
            let entity = NSEntityDescription.entity(forEntityName: "CocciProgramPostingTurkey", in: managedContext)
            
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
    /**************** Fetch Cooci  ****************************************************************/
    
    
    func fetchCocoiiProgramTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocciProgramPostingTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return CocoiiProgramArray
        
    }
    
    func fetchCocoiiProgramTurkeyLngId(lngId:NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocciProgramPostingTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return CocoiiProgramArray
        
    }
    
    
    ///////////////////   SAVING DATA BirdSize   //////////////////////////////
    
    func BirdSizeDatabaseTurkey(_ birddId : Int, birdSize: String,scaleType:String ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        BirdSizeArray = dbArray
        
        if BirdSizeArray.count > 0 {
            if let objTable: BirdSizePostingTurkey = BirdSizeArray[index] as? BirdSizePostingTurkey {
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
            
            let entity = NSEntityDescription.entity(forEntityName: "BirdSizePostingTurkey", in: managedContext)
            
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
    /**************** Fetch  BirdSize *******************************************/
    
    
    func fetchBirdSizeTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdSizePostingTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return BirdSizeArray
        
    }
    
    ///////////////////   SAVING DATA SessionType   //////////////////////////////
    
    func SessionTypeDatabaseTurkey(_ sesionId : Int, sesionType: String ,lngId:Int ,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        SessionTypeArray = dbArray
        
        if SessionTypeArray.count > 0 {
            if let objTable: SessiontypeTurkey = SessionTypeArray[index] as? SessiontypeTurkey {
                objTable.setValue(sesionId, forKey:"sesionId")
                objTable.setValue(sesionType, forKey:"sesionType")
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
            
            let entity = NSEntityDescription.entity(forEntityName: "SessiontypeTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(sesionId, forKey:"sesionId")
            person.setValue(sesionType, forKey:"sesionType")
            person.setValue(lngId, forKey:"lngId")
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
    /**************** Fetch  SessionType *******************************************/
    
    
    func fetchSessiontypeTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "SessiontypeTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return SessionTypeArray
        
    }
    func fetchSessiontypeTurkeyLngId(lngId: NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "SessiontypeTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return SessionTypeArray
        
    }
    func saveMoleCuleTurkey(_ catId : Int,decscMolecule : String,moleculeId : Int, lngId : Int)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "MoleculeFeeedTurkey", in: managedContext)
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
            
        }
        
        moleCule.append(person)
        
        
    }
    
    func fetchMoleCuleTurkeyLngId(lngId:NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MoleculeFeeedTurkey")
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
                
                
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return dataArray
        
    }
    ///////////////////   SAVING DATA SessionType   //////////////////////////////
    
    func BreedTypeDatabaseTurkey(_ breedId : Int, breedType: String ,breedName: String,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        BreedTypeArray = dbArray
        
        if BreedTypeArray.count > 0 {
            if let objTable: BreedTurkey = BreedTypeArray[index] as? BreedTurkey {
                objTable.setValue(breedId, forKey:"breedId")
                objTable.setValue(breedType, forKey:"breedType")
                objTable.setValue(breedName, forKey:"breedName")
            }
            do
            {
                try managedContext.save()
            }
            catch{
            }
        }
        else {
            
            let entity = NSEntityDescription.entity(forEntityName: "BreedTurkey", in: managedContext)
            
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(breedId, forKey:"breedId")
            person.setValue(breedType, forKey:"breedType")
            person.setValue(breedName, forKey:"breedName")
            
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
    
    /**************** Fetch  breed *******************************************/
    
    
    func fetchBreedTypeTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BreedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                
                BreedTypeArray = results as NSArray
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return BreedTypeArray
        
    }
    
    //////////////////////// compex //////////////////////////////////
    
    
    func ComplexDatabaseTurkey(_ comlexId : NSNumber, cutmerid: NSNumber ,complexName: String,dbArray :NSArray ,index : Int)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        complexArray = dbArray
        
        if complexArray.count > 0 {
            
            if let objTable: ComplexPostingTurkey = complexArray[index] as? ComplexPostingTurkey {
                
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
            
            let entity = NSEntityDescription.entity(forEntityName: "ComplexPostingTurkey", in: managedContext)
            
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
    func fetchAllPostingExistingSessionwithFullSessionAndComplexTurkey(_ session : NSNumber, complexName : NSString) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@ AND complexName == %@", session,complexName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [PostingSessionTurkey]
            
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingExistingSessionwithFullSessionAndUniqueComplexTurkey(_ complexID : NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.complexIdPredicate, complexID)
        
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
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    /**************** Fetch  complex posting *******************************************/
    
    
    func fetchCompexTypeTurkey() -> NSArray{
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "ComplexPostingTurkey")
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
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return complexArray
        
    }
    
    func deleteAllDataTurkey(_ entity: String)
    
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
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
            
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            
        }
    }
    func fetchCompexTypePrdicateTurkey(_ CustomerId: NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "ComplexPostingTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return complexArray
        
    }
    
    
    
    /**************** Fetch  complex posting *******************************************/
    func fetchLoginTypeTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "LoginTurkey")
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
            print(appDelegateObj.testFuntion())
        }
        
        return loginArray
        
    }
    
    func fetchLoginTypeWithUserEmailTurkey(email:String) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "LoginTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return loginArray
        
    }
    
    
    // MARK: ** Posting Customer representative Data Save In Add Vacination Button **
    
    func postCustomerRepsTurkey(_ customername : String,  userid : Int)
    
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "CustomerReprestativeTurkey", in: managedContext)
        let arr =  fectCustomerRepresenttiveWithCustomernameTurkey(customername)
        
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
            print(appDelegateObj.testFuntion())
        }
        
        CustmerRep.append(person)
    }
    
    // MARK: ** Fetch Cstomer repsentative Data Save In Add Vacination Button **
    func fectCustomerRepresenttiveWithCustomernameTurkey ( _ customername : String) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustomerReprestativeTurkey")
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
                
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return custRep
        
    }
    
    // MARK: ** Fetch Cstomer repsentative Data Save In Add Vacination Button **
    func fectCustomerRepWithCustomernameTurkey ( _ usrid : Int) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CustomerReprestativeTurkey")
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
                
                
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return custRep
        
    }
    
    // MARK: ********** Delete object from posting seesion ***************************************/
    
    func deleteDataWithPostingIdTurkey (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Farms Details in Turkey
    func deleteDataWithPostingIdStep1dataTurkey (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete All data of Necropsy with posting ID in TURKEY
    func deleteDataWithPostingIdStep2dataCaptureNecViewTurkey (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Notes With Posting ID in TURKEY
    func deleteDataWithPostingIdStep2NotesBirdTurkey (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Images with Posting ID in Turket Necropsy
    func deleteDataWithPostingIdStep2CameraIamgeTurkey (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Data with Posting Id TURKEY
    func deleteDataWithPostingIdHatcheryTurkey (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVacTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            debugPrint(results)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            debugPrint(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Field Vaccinations in Turkey
    func deleteDataWithPostingIdFieldVacinationWithSingleTurkey (_ postingId: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            debugPrint(results)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            debugPrint(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete full session with session Id in  TUrkey
    func deleteDataWithDeviceSessionIdTurkey (postingId: NSNumber){
        
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchUsers.predicate  = fetchPredicate
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Hatchery Vaccination Data in Turkey
    func deleteHetcharyVacDataWithPostingIdTurkey (_ postingId: NSNumber)
    {
         let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVacTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Field Vaccine data with Posting Id in Turkey
    func deletefieldVACDataWithPostingIdTurkey (_ postingId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "FieldVaccinationTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Feed Program Data with Popsting ID IN Turkey
    func deleteDataWithPostingIdFeddProgramTurkey (_ postingIdFeed: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgramTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: Delete Feed Program Data in Turkey for Coccidiosis
    func deleteDataWithPostingIdFeddProgramCocoiiSinleTurkey (_ postingIdFeed: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Feed Program Data in Turkey for Alternative
    func deleteDataWithPostingIdFeddProgramAlternativeSinleTurkey(_ postingIdFeed: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    // MARK: Delete Feed Program Data in Turkey for Antibiotic
    func deleteDataWithPostingIdFeddProgramAntiboiticSingleTurkey (_ postingIdFeed: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    // MARK: Delete Feed Program Data in Turkey for Cotoxin
    func deleteDataWithPostingIdFeddProgramMyCotoxinSingleTurkey (_ postingIdFeed: NSNumber)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingIdFeed)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: Delete Necropsy Data in Turkey
    func deleteDataWithPostingIdCaptureStepDataTurkey (_ necId: NSNumber)
    {
 
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: Update Hatchery Vaccine Data in Turkey
    func updateisSyncOnHetcharyVacDataWithPostingIdTurkey (_ postingId: NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        let fetchUsers    = NSFetchRequest<NSFetchRequestResult>(entityName:  "HatcheryVacTurkey")
        fetchUsers.predicate                = fetchPredicate
        do
        {
            let fetchedResult = try managedContext.fetch(fetchUsers) as? [NSManagedObject]
            let fetchArr = fetchedResult as! NSArray
            if fetchArr.count > 0{
                for i in 0..<fetchedResult!.count
                {
                    let objTable: HatcheryVacTurkey = (fetchedResult![i] as? HatcheryVacTurkey)!
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
    
    // MARK: Auto Increment ID in Turkey.
    func autoIncrementidtableTurkey(){
        var auto = self.fetchFromAutoIncrementTurkey()
        auto += 1
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "IdTurkey", in: managedContext)
        let contact1 = NSManagedObject(entity: entity!, insertInto: managedContext)
        contact1.setValue(auto, forKey: "autoId")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: Fetch Auto Increment ID in Turkey.
    func fetchFromAutoIncrementTurkey() -> Int
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "IdTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        var auto: Int?
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]          
            auto = fetchedResult?.count == 0 ? 0 : fetchedResult?.count ?? 0
            if let results = fetchedResult
            {
                if results.count > 0{
                    let ob: IdTurkey = results.last as! IdTurkey
                    auto = Int(ob.autoId!)
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
        return auto!
    }
    
    // MARK: ** Posting Session Data Save In Add Vacination Button **
    
    func PostingSessionDbTurkey(with data: CoreDataHandlerTurkeyModels.PostingSessionTurkeyDBData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.managedObjectContext
        self.deleteDataWithPostingIdTurkey(data.postingId)

        let entity = NSEntityDescription.entity(forEntityName: "PostingSessionTurkey", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)

        contact.setValue(data.convential, forKey: "convential")
        contact.setValue(data.antobotic, forKey: "antiboitic")
        contact.setValue(data.birdBreesId, forKey: "birdBreedId")
        contact.setValue(data.birdbreedName, forKey: "birdBreedName")
        contact.setValue(data.birdBreedType, forKey: "birdBreedType")
        contact.setValue(data.birdSize, forKey: "birdSize")
        contact.setValue(data.birdSizeId, forKey: "birdSizeId")
        contact.setValue(data.cocciProgramId, forKey: "cocciProgramId")
        contact.setValue(data.cociiProgramName, forKey: "cociiProgramName")
        contact.setValue(data.complexId, forKey: "complexId")
        contact.setValue(data.complexName, forKey: "complexName")
        contact.setValue(data.customerId, forKey: "customerId")
        contact.setValue(data.customerName, forKey: "customerName")
        contact.setValue(data.customerRepId, forKey: "customerRepId")
        contact.setValue(data.customerRepName, forKey: "customerRepName")
        contact.setValue(data.imperial, forKey: "imperial")
        contact.setValue(data.metric, forKey: "metric")
        contact.setValue(data.notes, forKey: "notes")
        contact.setValue(data.salesRepId, forKey: "salesRepId")
        contact.setValue(data.salesRepName, forKey: "salesRepName")
        contact.setValue(data.sessiondate, forKey: "sessiondate")
        contact.setValue(data.sessionTypeId, forKey: "sessionTypeId")
        contact.setValue(data.sessionTypeName, forKey: "sessionTypeName")
        contact.setValue(data.vetanatrionName, forKey: "vetanatrionName")
        contact.setValue(data.veterinarianId, forKey: "veterinarianId")
        contact.setValue(data.loginSessionId, forKey: "loginSessionId")
        contact.setValue(data.postingId, forKey: "postingId")
        contact.setValue(data.mail, forKey: "mail")
        contact.setValue(data.female, forKey: "female")
        contact.setValue(data.finilize, forKey: "finalizeExit")
        contact.setValue(data.isSync, forKey: "isSync")
        contact.setValue(data.timeStamp, forKey: "timeStamp")
        contact.setValue(data.lngId, forKey: "lngId")
        contact.setValue(data.capNec, forKey: "catptureNec")
        contact.setValue(data.mortality, forKey: "dayMortality")
        contact.setValue(data.FCR, forKey: "fcr")
        contact.setValue(data.outTime, forKey: "outTime")
        contact.setValue(data.Livability, forKey: "livability")
        contact.setValue(data.avgAge, forKey: "avgAge")
        contact.setValue(data.avgWeight, forKey: "avgWeight")

        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }

        postingSession.append(contact)
    }

    // MARK: ************* Update Posting session *****************/
    
    func updatePostingSessionForNextButtonTurkey(data: CoreDataHandlerTurkeyModels.updatePostingSessionTurkeyDBData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, data.postingId)
        
        do {
            if let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let objTable = fetchedResult.first as? PostingSessionTurkey {
                
                objTable.setValue(data.convential, forKey: "convential")
                objTable.setValue(data.antobotic, forKey: "antiboitic")
                objTable.setValue(data.birdBreedId, forKey: "birdBreedId")
                objTable.setValue(data.birdBreedName, forKey: "birdBreedName")
                objTable.setValue(data.birdBreedType, forKey: "birdBreedType")
                objTable.setValue(data.birdSize, forKey: "birdSize")
                objTable.setValue(data.birdSizeId, forKey: "birdSizeId")
                objTable.setValue(data.cocciProgramId, forKey: "cocciProgramId")
                objTable.setValue(data.cociiProgramName, forKey: "cociiProgramName")
                objTable.setValue(data.complexId, forKey: "complexId")
                objTable.setValue(data.complexName, forKey: "complexName")
                objTable.setValue(data.customerId, forKey: "customerId")
                objTable.setValue(data.customerName, forKey: "customerName")
                objTable.setValue(data.customerRepId, forKey: "customerRepId")
                objTable.setValue(data.customerRepName, forKey: "customerRepName")
                objTable.setValue(data.imperial, forKey: "imperial")
                objTable.setValue(data.metric, forKey: "metric")
                objTable.setValue(data.notes, forKey: "notes")
                objTable.setValue(data.salesRepId, forKey: "salesRepId")
                objTable.setValue(data.salesRepName, forKey: "salesRepName")
                objTable.setValue(data.sessionDate, forKey: "sessiondate")
                objTable.setValue(data.sessionTypeId, forKey: "sessionTypeId")
                objTable.setValue(data.sessionTypeName, forKey: "sessionTypeName")
                objTable.setValue(data.vetanatrionName, forKey: "vetanatrionName")
                objTable.setValue(data.veterinarianId, forKey: "veterinarianId")
                objTable.setValue(data.loginSessionId, forKey: "loginSessionId")
                objTable.setValue(data.postingId, forKey: "postingId")
                objTable.setValue(data.mail, forKey: "mail")
                objTable.setValue(data.female, forKey: "female")
                objTable.setValue(data.finalize, forKey: "finalizeExit")
                objTable.setValue(data.isSync, forKey: "isSync")
                objTable.setValue(data.timeStamp, forKey: "timeStamp")
                objTable.setValue(data.lngId, forKey: "lngId")
                objTable.setValue(data.mortality, forKey: "dayMortality")
                objTable.setValue(data.FCR, forKey: "fcr")
                objTable.setValue(data.outTime, forKey: "outTime")
                objTable.setValue(data.livability, forKey: "livability")
                objTable.setValue(data.avgAge, forKey: "avgAge")
                objTable.setValue(data.avgWeight, forKey: "avgWeight")

                try managedContext.save()
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    // MARK: ************* Update Posting on DashBoard session *****************/
    func updatePostingSessionOndashBoardTurkey(_ postingId : NSNumber,vetanatrionName:String,veterinarianId: NSNumber,captureNec: NSNumber
    )
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
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
                do {
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
    
    // MARK: *************************** Get Api Method for Postong Session **********************/
    func getPostingDataTurkey(_ dict : NSDictionary) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let postingId = dict.value(forKey: "SessionId") as! Int
        self.deleteDataWithPostingIdTurkey(postingId as NSNumber)
        let entity = NSEntityDescription.entity(forEntityName: "PostingSessionTurkey", in: managedContext)
        
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
        contact1.setValue(dict.value(forKey: "CustomerRep"), forKey:"customerRepName")
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
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"timeStamp")
        contact1.setValue(dict.value(forKey: "DeviceSessionId"), forKey:"actualTimeStamp")
        UserDefaults.standard.set(dict.value(forKey: "DeviceSessionId"), forKey: "devTimeStamp")
        UserDefaults.standard.synchronize()
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        postingSession.append(contact1)
        
    }
    // MARK: Get Posting Data with Specific ID in Turkey
    func getPostingDatWithSpecificIdTurkey(_ dict : NSDictionary, postinngId: NSNumber) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        self.deleteDataWithDeviceSessionIdTurkey(postingId : postinngId)
        let entity = NSEntityDescription.entity(forEntityName: "PostingSessionTurkey", in: managedContext)
        
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
            print(appDelegateObj.testFuntion())
        }
        
        postingSession.append(contact1)
        
    }
        
    // MARK: Update Finalize Data in Turkey
    func updateFinalizeDataActualTurkey(_ postingId : NSNumber,deviceToken : String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: Update Necropsy Data in Finalized Turkey
    func updateFinalizeDataActualNecTurkey(_ necId : NSNumber,deviceToken : String){
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyDataTurkey = (fetchedResult![0] as? CaptureNecropsyDataTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: Update Feed Program In Step 1 Turkey
    func updateFeddProgramInStep1Turkey(_ necId : NSNumber,feedname:String,feedId:NSNumber)
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND feedId == %@", necId,feedId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    objTable.setValue(feedname, forKey:"feedProgram")
                    do
                    {
                        try managedContext.save()
                    }
                    catch{
                    }
                }
            }
        } catch {
            
        }
    }
    
    // MARK: Update Feed Program in Step 1 using farm name in Turkey
    func updateFeddProgramInStep1UsingFarmNameTurkey(_ necId : NSNumber,feedname:String,feedId:NSNumber,formName:String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId,formName)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    
    // MARK: Update Bird Sex in Step 1 using farm name in Turkey (Unlinked Sessions)
    func updateStep1BirdSexUsingFarmNameTurkey(_ necId : NSNumber,BirdSex:String,formName:String , _ age:String , _ houseNum:String , _ farmname:String) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId,formName)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    objTable.setValue(BirdSex, forKey:"sex")
                    objTable.setValue(age, forKey:"age")
                    objTable.setValue(houseNum, forKey:"houseNo")
                  //  objTable.setValue(farmname, forKey:"farmName") // break in case of unlinkded session if we update the farm name ..take time to fix this
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
    
    
    // MARK: Update finalized data in turkey  with Posting ID
    func updateFinalizeDataTurkey(_ postingId : NSNumber,finalize : NSNumber,isSync:Bool)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: Update Device token for Posting ID in Turkey
    func updatedeviceTokenForPostingIdTurkey(_ postingId : NSNumber,timeStamp:String,actualTimestamp: String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: Update Posting Session with Posting ID and IsFarmSync
    func updatedPostigSessionwithIsFarmSyncPostingIdTurkey(_ postingId : NSNumber,isFarmSync:Bool)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
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
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: Search Token for Posting ID TUrkey
    func searchTokenForPostingIdTurkey(timeStampId:String)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
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
            
        }
    }
    
    func updateFinalizeDataWithNecGetApiTurkey(_ postingId : NSNumber,finalizeNec : NSNumber)
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
                
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
    
    func updateFinalizeDataWithNecTurkey(_ postingId : NSNumber,finalizeNec : NSNumber) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        { let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
                
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
    
    
    func updateFinalizeDataWithNecNotesTurkey(_ postingId : NSNumber,notes : String)
    
    { let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
                
                objTable.setValue(notes, forKey:"notes")
                objTable.setValue(true, forKey:"isSync")
                
                do {
                    try managedContext.save()
                } catch {
                }
            }
        } catch {
            
        }
    }
    
    
    func updateisSyncOnPostingSessionTurkey(_ postingId : NSNumber,isSync : Bool,_ completion: (_ status: Bool) -> Void){
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    
                    let objTable: PostingSessionTurkey = (fetchedResult![i] as? PostingSessionTurkey)!
                    
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
            
        }
        
    }
    
    
    func updateisAllSyncFalseOnPostingSessionTurkey(_ isSync : Bool,_ completion: (_ status: Bool) -> Void)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.predicateStatus, NSNumber(booleanLiteral: isSync))
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    
                    let objTable: PostingSessionTurkey = (fetchedResult![i] as? PostingSessionTurkey)!
                    
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
        catch
        {
            
        }
        
        
    }
    
    func updateisSyncTrueOnPostingSessionTurkey(_ postingId : NSNumber)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
  
                let objTable: PostingSessionTurkey = (fetchedResult![0] as? PostingSessionTurkey)!
                
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
            
        }
        
        
    }
    
    
    
    func fetchAllPostingSessionWithNumberTurkey() -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
                debugPrint(postingArray)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingSessionTurkey(_ postingid :NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingid)
        
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
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingSessionWithisSyncisTrueTurkey(_ isSync : Bool) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.predicateStatus, NSNumber(booleanLiteral: isSync))
        
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
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingExistingSessionTurkey() -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    func fetchAllPostingExistingSessionwithFullSessionTurkeyCapNic(_ session : NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@", session)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [PostingSessionTurkey]
            if let results = fetchedResult
                
            {
                postingArray  = results as NSArray
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let sortedArray = results.sorted{[dateFormatter] one, two in
                    return dateFormatter.date(from:one.sessiondate!)! > dateFormatter.date(from: two.sessiondate!)! }
                postingArray = sortedArray as NSArray
                
            } else {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
    }
 
    func fetchAllPostingExistingSessionwithFullSessionTurkey(_ session : NSNumber,birdTypeId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@ AND birdBreedId == %@", session,birdTypeId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                postingArray  = results as NSArray
           }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    
    
    func fetchAllWithOutFeddTurkey(capNec : NSNumber,birdTypeId:NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "catptureNec == %@ AND birdBreedId == %@", capNec,birdTypeId)
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
            else {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return postingArray
    }
    
    func fetchAllPostingExistingSessionwithFullSessionSessionDateTurkey(_ session : NSNumber,birdTypeId:NSNumber,todate:String,lasatdate:String) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
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
            { }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return postingArray
    }
    
    /********************************* Save data in to CocoiPrgramFeed *************************************/
    
    func saveCoccoiControlDatabaseTurkey(_ data: CoreDataHandlerTurkeyModels.saveCoccoiControlFeedData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.managedObjectContext
        cocciControlArray = data.dbArray

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoccidiosisControlFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, data.feedId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]

            if let results = fetchedResult, results.count > 0 {
                if results.count <= data.index {
                    let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeedTurkey", in: managedContext)!
                    let person = NSManagedObject(entity: entity, insertInto: managedContext)

                    person.setValue(data.loginSessionId, forKey: "loginSessionId")
                    person.setValue(data.postingId, forKey: "postingId")
                    person.setValue(data.molecule, forKey: "molecule")
                    person.setValue(data.dosage, forKey: "dosage")
                    person.setValue(data.fromDays, forKey: "fromDays")
                    person.setValue(data.toDays, forKey: "toDays")
                    person.setValue(data.coccidiosisVaccine, forKey: "coccidiosisVaccine")
                    person.setValue(data.targetWeight, forKey: "targetWeight")
                    person.setValue(data.feedId, forKey: "feedId")
                    person.setValue(data.feedProgram, forKey: "feedProgram")
                    person.setValue(data.isSync, forKey: "isSync")
                    person.setValue(data.feedType, forKey: "feedType")
                    person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                    person.setValue(data.lngId, forKey: "lngId")
                    person.setValue(data.lbldate, forKey: "feedDate")
                    person.setValue(data.dosemoleculeId, forKey: "dosemoleculeId")

                    try? managedContext.save()
                    cocciCoccidiosControl.append(person)
                } else {
                    let objTable = results[data.index] as! CoccidiosisControlFeedTurkey

                    objTable.setValue(data.loginSessionId, forKey: "loginSessionId")
                    objTable.setValue(data.postingId, forKey: "postingId")
                    objTable.setValue(data.molecule, forKey: "molecule")
                    objTable.setValue(data.dosage, forKey: "dosage")
                    objTable.setValue(data.fromDays, forKey: "fromDays")
                    objTable.setValue(data.toDays, forKey: "toDays")
                    objTable.setValue(data.coccidiosisVaccine, forKey: "coccidiosisVaccine")
                    objTable.setValue(data.targetWeight, forKey: "targetWeight")
                    objTable.setValue(data.feedId, forKey: "feedId")
                    objTable.setValue(data.feedProgram, forKey: "feedProgram")
                    objTable.setValue(data.formName, forKey: "formName")
                    objTable.setValue(data.isSync, forKey: "isSync")
                    objTable.setValue(data.feedType, forKey: "feedType")
                    objTable.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                    objTable.setValue(data.lngId, forKey: "lngId")
                    objTable.setValue(data.lbldate, forKey: "feedDate")
                    objTable.setValue(data.dosemoleculeId, forKey: "dosemoleculeId")

                    try? managedContext.save()
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeedTurkey", in: managedContext)!
                let person = NSManagedObject(entity: entity, insertInto: managedContext)

                person.setValue(data.loginSessionId, forKey: "loginSessionId")
                person.setValue(data.postingId, forKey: "postingId")
                person.setValue(data.molecule, forKey: "molecule")
                person.setValue(data.dosage, forKey: "dosage")
                person.setValue(data.fromDays, forKey: "fromDays")
                person.setValue(data.toDays, forKey: "toDays")
                person.setValue(data.coccidiosisVaccine, forKey: "coccidiosisVaccine")
                person.setValue(data.targetWeight, forKey: "targetWeight")
                person.setValue(data.feedId, forKey: "feedId")
                person.setValue(data.feedProgram, forKey: "feedProgram")
                person.setValue(data.isSync, forKey: "isSync")
                person.setValue(data.feedType, forKey: "feedType")
                person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                person.setValue(data.lngId, forKey: "lngId")
                person.setValue(data.lbldate, forKey: "feedDate")
                person.setValue(data.dosemoleculeId, forKey: "dosemoleculeId")

                try? managedContext.save()
                cocciCoccidiosControl.append(person)
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    // MARK: ******************** Get data from server forCocoidisControll **********************/
    func getDataFromCocoiiControllTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
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
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(startDate, forKey:"feedDate")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciCoccidiosControl.append(person)
    }
    
    func getDataFromCocoiiControllForSingleDataTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingIdCocoii:NSNumber, feedDate:String) {
        let entity = NSEntityDescription.entity(forEntityName: "CoccidiosisControlFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
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
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciCoccidiosControl.append(person)
    }
    // MARK: *************** Fetch data Skleta ************************************************************************/
    
    func fetchAllCocciControlTurkey(_ feedId :NSNumber) -> NSArray{
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
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
    
    func fetchAllCocciControlAllDataTurkey() -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
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
    
    // MARK: fETCH FEED PROGRAM VIA POSTING ID////////////
    func fetchAllCocciControlviaPostingidTurkey(_ postingId :NSNumber) -> NSArray    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
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
    
    func fetchAllCocciControlviaIsyncTurkey(_ isSync :NSNumber , postinID : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
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
            
        }
        return cocciControlArray
        
    }
    
    func updateisSyncOnAllCocciControlviaFeedProgramTurkey(_ postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "postingId == %@ AND feedId == %@", postingId,feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CoccidiosisControlFeedTurkey = (fetchedResult![i] as? CoccidiosisControlFeedTurkey)!
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
    
    func updateisSyncOnAllCocciControlviaPostingidTurkey(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CoccidiosisControlFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CoccidiosisControlFeedTurkey = (fetchedResult![i] as? CoccidiosisControlFeedTurkey)!
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
    
    func updateisSyncOnAntiboticViaPostingIdTurkey(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AntiboticFeedTurkey = (fetchedResult![i] as? AntiboticFeedTurkey)!
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
    
    func updateisSyncOnAntiboticViaFeedProgramTurkey(postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AntiboticFeedTurkey = (fetchedResult![i] as? AntiboticFeedTurkey)!
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
    
    
    func fetchAntiboticViaIsSyncTurkey(_ isSync:Bool, postingID : NSNumber) -> NSArray    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
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
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return AntiboticArray
   }
    
    func fetchAntiboticViaPostingIdTurkey(_ postingId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
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
    // MARK: Fetch alternative via postingId
    
    func updateisSyncOnAlternativeFeedPostingidTurkey(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AlternativeFeedTurkey = (fetchedResult![i] as? AlternativeFeedTurkey)!
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
    
    
    func updateisSyncOnAlterNativeViaFeedProgramTurkey(postingId :NSNumber , feedId : NSNumber,feedProgram:String)
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: AlternativeFeedTurkey = (fetchedResult![i] as? AlternativeFeedTurkey)!
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
    
    func fetchAlternativeFeedWithIsSyncTurkey(_ isSync : Bool,postingID:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, NSNumber(booleanLiteral: isSync),postingID)
        
        do {
            
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
    
    
    func fetchAlternativeFeedPostingidTurkey(_ postingId : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
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
    
    func updateisSyncOnMyBindersViaPostingIdTurkey(_ postingId :NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: MyCotoxinBindersFeedTurkey = (fetchedResult![i] as? MyCotoxinBindersFeedTurkey)!
                    
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
        {
         }
        
    }
    
    func updateisSyncOnMyCotxinViaFeedProgramTurkey(postingId :NSNumber , feedId : NSNumber,feedProgram:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postingIdFeedPredicate, postingId,feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: MyCotoxinBindersFeedTurkey = (fetchedResult![i] as? MyCotoxinBindersFeedTurkey)!
                    objTable.setValue(feedProgram, forKey:"feedProgram")
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
    
    func fetchMyBindersViaPostingIdTurkey(_ postingId : NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                MyCoxtinBindersArray = results as NSArray
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return MyCoxtinBindersArray
    }
    
    
    func fetchMyBindersViaIsSyncTurkey(_ isSync : Bool , postingID : NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.statusPostingIdPredicate, NSNumber(booleanLiteral: isSync),postingID)
        
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
    
    /********************************* Save data in to AntiboticArray *************************************/
    
    func saveAntiboticDatabaseTurkey(_ data: CoreDataHandlerTurkeyModels.AntiboticControlData, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        AntiboticArray = dbArray
        
        if AntiboticArray.count > 0 {
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AntiboticFeedTurkey")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, data.feedId)
            
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if fetchedResult!.count > 0 {
                    if fetchedResult?.count ?? 0 <= index {
                        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeedTurkey", in: managedContext)
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
                        person.setValue(data.lbldate, forKey: "feedDate")
                        try? managedContext.save()
                        cocciAntibotic.append(person)
                    } else {
                        let objTable: AntiboticFeedTurkey = (fetchedResult![index] as? AntiboticFeedTurkey)!
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
                        objTable.setValue(data.lbldate, forKey: "feedDate")
                        try? managedContext.save()
                    }
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeedTurkey", in: managedContext)
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
                    person.setValue(data.lbldate, forKey: "feedDate")
                    try? managedContext.save()
                    cocciAntibotic.append(person)
                }
            } catch {
                print(appDelegateObj.testFuntion())
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeedTurkey", in: managedContext)
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
            person.setValue(data.lbldate, forKey: "feedDate")
            try? managedContext.save()
            cocciAntibotic.append(person)
        }
    }
    /********************************* Get Api from server for antoboitic *************************************/
    
    func getDataFromAntiboiticTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
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
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAntibotic.append(person)
    }
    
    func getDataFromAntiboiticWithSigleDataTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingIdAlterNative: NSNumber , feedDate:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AntiboticFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingIdAlterNative , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        cocciAntibotic.append(person)
    }

    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAntiboticTurkey(_ feedId:NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
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
    
    func fetchAntiboticPostingIdTurkey(_ postingId:NSNumber) -> NSArray {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult
            {
                AntiboticArray = results as NSArray
                debugPrint(AntiboticArray)
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
    
    func fetchAntiboticAlldataTurkey() -> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "AntiboticFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do  {
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
    
    
    func saveAlternativeDatabaseTurkey(data: CoreDataHandlerTurkeyModels.AlternativeFeedData, index: Int, dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        AlternativeArray = dbArray

        if AlternativeArray.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AlternativeFeedTurkey")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, data.feedId)

            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult {
                    if results.count <= index {
                        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeedTurkey", in: managedContext)!
                        let person = NSManagedObject(entity: entity, insertInto: managedContext)
                        person.setValue(data.loginSessionId, forKey: "loginSessionId")
                        person.setValue(data.postingId, forKey: "postingId")
                        person.setValue(data.molecule, forKey: "molecule")
                        person.setValue(data.dosage, forKey: "dosage")
                        person.setValue(data.fromDays, forKey: "fromDays")
                        person.setValue(data.toDays, forKey: "toDays")
                        person.setValue(data.feedId, forKey: "feedId")
                        person.setValue(data.feedProgram, forKey: "feedProgram")
                        person.setValue(data.formName, forKey: "formName")
                        person.setValue(data.isSync, forKey: "isSync")
                        person.setValue(data.feedType, forKey: "feedType")
                        person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
                        person.setValue(data.lngId, forKey: "lngId")
                        person.setValue(data.lbldate, forKey: "feedDate")
                        try? managedContext.save()
                        cocciAlternative.append(person)
                    } else {
                        let objTable = results[index] as! AlternativeFeedTurkey
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
                        objTable.setValue(data.lbldate, forKey: "feedDate")
                        try? managedContext.save()
                    }
                }
            } catch {
                // Handle error appropriately
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeedTurkey", in: managedContext)!
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(data.loginSessionId, forKey: "loginSessionId")
            person.setValue(data.postingId, forKey: "postingId")
            person.setValue(data.molecule, forKey: "molecule")
            person.setValue(data.dosage, forKey: "dosage")
            person.setValue(data.fromDays, forKey: "fromDays")
            person.setValue(data.toDays, forKey: "toDays")
            person.setValue(data.feedId, forKey: "feedId")
            person.setValue(data.feedProgram, forKey: "feedProgram")
            person.setValue(data.formName, forKey: "formName")
            person.setValue(data.isSync, forKey: "isSync")
            person.setValue(data.feedType, forKey: "feedType")
            person.setValue(data.cocoVacId, forKey: "coccidiosisVaccineId")
            person.setValue(data.lngId, forKey: "lngId")
            person.setValue(data.lbldate, forKey: "feedDate")
            try? managedContext.save()
            cocciAlternative.append(person)
        }
    }

    func saveCocoiiVacTurkey(_ catId : Int,decscMolecule : String, lngId : Int)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "CocoiVaccineTurkey", in: managedContext)
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
    
    func fetchCociVacTurkeyLngId(lngId:NSNumber) -> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CocoiVaccineTurkey")
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
    
    /******************** getApi  AlterNative data from server *****************/
    
    func getDataFromAlterNativeTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
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
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciAlternative.append(person)
    }
    
    func getDataFromAlterNativeForSingleDevTokenTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingAlterNative:NSNumber, feedDate:String) {
        let entity = NSEntityDescription.entity(forEntityName: "AlternativeFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingAlterNative , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        cocciAlternative.append(person)
    }
    
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchAlternativeTurkey(_ feedId : NSNumber) -> NSArray{
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
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
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AlternativeArray
        
    }
    
    
    func fetchAlternativePostingIdTurkey(_ postingId : NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
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
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AlternativeArray
        
    }
    
    
    func fetchAlternativeAlldataTurkey() -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "AlternativeFeedTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        // fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
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
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return AlternativeArray
        
    }
    
    fileprivate func handleIfFetchedResultLessThan4(
        _ fetchedResult: [NSManagedObject]?,
        _ index: Int,
        _ managedContext: NSManagedObjectContext,
        _ feedData: CoreDataHandlerTurkeyModels.myCoxtinFeedData) {

        if ((fetchedResult?.count)! <= index) {
            let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeedTurkey", in: managedContext)
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
            person.setValue(feedData.lbldate, forKey: "feedDate")

            do {
                try managedContext.save()
            } catch {
                // Handle error
            }
            
            cocciMyCoxtinBinders.append(person)
        } else {
            let objTable: MyCotoxinBindersFeedTurkey = (fetchedResult![index] as? MyCotoxinBindersFeedTurkey)!
            
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
            objTable.setValue(feedData.lbldate, forKey: "feedDate")

            do {
                try managedContext.save()
            } catch {
                // Handle error
            }
        }
    }

    fileprivate func handleCoxinVal(_ input: CoreDataHandlerTurkeyModels.TurkeyCoxinmodel) {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, input.feedId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let fetchedResult = fetchedResult, !fetchedResult.isEmpty {
                let feedData = CoreDataHandlerTurkeyModels.myCoxtinFeedData(
                    loginSessionId: input.loginSessionId,
                    postingId: input.postingId,
                    molecule: input.molecule,
                    dosage: input.dosage,
                    fromDays: input.fromDays,
                    toDays: input.toDays,
                    feedId: input.feedId,
                    feedProgram: input.feedProgram,
                    isSync: input.isSync,
                    feedType: input.feedType,
                    cocoVacId: input.cocoVacId,
                    lngId: input.lngId,
                    lbldate: input.lbldate,
                    formName: input.formName
                )
                
                handleIfFetchedResultLessThan4(fetchedResult, input.index, managedContext, feedData)
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeedTurkey", in: managedContext)!
                let person = NSManagedObject(entity: entity, insertInto: managedContext)
                
                person.setValue(input.loginSessionId, forKey: "loginSessionId")
                person.setValue(input.postingId, forKey: "postingId")
                person.setValue(input.molecule, forKey: "molecule")
                person.setValue(input.dosage, forKey: "dosage")
                person.setValue(input.fromDays, forKey: "fromDays")
                person.setValue(input.toDays, forKey: "toDays")
                person.setValue(input.feedId, forKey: "feedId")
                person.setValue(input.feedProgram, forKey: "feedProgram")
                person.setValue(input.isSync, forKey: "isSync")
                person.setValue(input.feedType, forKey: "feedType")
                person.setValue(input.cocoVacId, forKey: "coccidiosisVaccineId")
                person.setValue(input.lngId, forKey: "lngId")
                person.setValue(input.lbldate, forKey: "feedDate")
                
                do {
                    try managedContext.save()
                } catch {
                    // handle error appropriately
                }
                
                cocciMyCoxtinBinders.append(person)
            }
        } catch {
            // handle fetch error
        }
    }

    
    /////////////
    ///
    func saveMyCoxtinDatabaseTurkey(coxtinData: CoreDataHandlerTurkeyModels.TurkeyCoxinmodel,dbArray: NSArray) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        MyCoxtinBindersArray = dbArray
        
        if MyCoxtinBindersArray.count > 0 {
            let coxinInput = CoreDataHandlerTurkeyModels.TurkeyCoxinmodel(
                feedId: coxtinData.feedId,
                index: coxtinData.index,
                loginSessionId: coxtinData.loginSessionId,
                postingId: coxtinData.postingId,
                molecule: coxtinData.molecule,
                dosage: coxtinData.dosage,
                fromDays: coxtinData.fromDays,
                toDays: coxtinData.toDays,
                feedProgram: coxtinData.feedProgram,
                isSync: coxtinData.isSync,
                feedType: coxtinData.feedType,
                cocoVacId: coxtinData.cocoVacId,
                lngId: coxtinData.lngId,
                lbldate: coxtinData.lbldate,
                formName: coxtinData.formName
            )

            handleCoxinVal(coxinInput)
//            handleCoxinVal(coxtinData.feedId, coxtinData.index, coxtinData.loginSessionId, coxtinData.postingId, coxtinData.molecule, coxtinData.dosage, coxtinData.fromDays, coxtinData.toDays, coxtinData.feedProgram, coxtinData.isSync, coxtinData.feedType, coxtinData.cocoVacId, coxtinData.lngId, coxtinData.lbldate, coxtinData.formName)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeedTurkey", in: managedContext)
            let person  = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(coxtinData.loginSessionId, forKey: "loginSessionId")
            person.setValue(coxtinData.postingId, forKey: "postingId")
            person.setValue(coxtinData.molecule, forKey: "molecule")
            person.setValue(coxtinData.dosage, forKey: "dosage")
            person.setValue(coxtinData.fromDays, forKey: "fromDays")
            person.setValue(coxtinData.toDays, forKey: "toDays")
            person.setValue(coxtinData.feedId, forKey: "feedId")
            person.setValue(coxtinData.feedProgram, forKey: "feedProgram")
            person.setValue(coxtinData.isSync, forKey: "isSync")
            person.setValue(coxtinData.feedType, forKey: "feedType")
            person.setValue(coxtinData.cocoVacId, forKey: "coccidiosisVaccineId")
            person.setValue(coxtinData.lngId, forKey: "lngId")
            person.setValue(coxtinData.lbldate, forKey: "feedDate")
            
            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            
            cocciMyCoxtinBinders.append(person)
        }
    }

    /************************** Ge api for MycocxoBinder *********************************/
    func getDataFromMyCocotinBinderTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,startDate: String) {
        
        
        let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
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
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciMyCoxtinBinders.append(person)
    }
    
    func getDataFromMyCocotinBinderWithSingleDataTurkey(_ dict:NSDictionary,feedId:NSNumber,postingId:NSNumber,feedProgramName:String,postingidMycotxin:NSNumber , feedDate:String) {
        
        
        let entity = NSEntityDescription.entity(forEntityName: "MyCotoxinBindersFeedTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(postingId, forKey:"loginSessionId")
        person.setValue( postingidMycotxin , forKey:"postingId")
        person.setValue( dict.value(forKey: "molecule") , forKey:"molecule")
        person.setValue((dict.value(forKey: "dose") as? String ?? ""), forKey:"dosage")
        person.setValue((dict.value(forKey: "durationFrom") as AnyObject).stringValue, forKey:"fromDays")
        person.setValue((dict.value(forKey: "durationTo") as AnyObject).stringValue , forKey:"toDays")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(feedDate, forKey:"feedDate")
        person.setValue(feedProgramName, forKey:"feedProgram")
        person.setValue(false , forKey:"isSync")
        person.setValue(dict.value(forKey: "feedType"), forKey:"feedType")
        person.setValue(dict.value(forKey: "cocciVaccineId"), forKey:"coccidiosisVaccineId")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        cocciMyCoxtinBinders.append(person)
    }
    
    
    
    /***************** Fetch data Skleta ************************************************************************/
    
    func fetchMyBindersTurkey(_ feedId : NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        
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
    
    
    func fetchMyBindersAllDataTurkey() -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "MyCotoxinBindersFeedTurkey")
        
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
    
    
    func getFeedNameFromGetApiTurkey (_ postingId : NSNumber, sessionId: NSNumber ,feedProgrameName: String,feedId: NSNumber,startDate:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FeedProgramTurkey", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
        person.setValue(feedProgrameName, forKey:"feddProgramNam")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(sessionId, forKey:"loginSessionId")
        person.setValue(postingId, forKey:"postingId")
        person.setValue("", forKey:"formName")
        person.setValue(false, forKey:"isSync")
        //person.setValue(startDate, forKey:"feedDate")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        FeddProgram.append(person)
       
    }
    
    func getFeedNameFromGetApiSingleDeviceTokenTurkey (_ postingId : NSNumber, sessionId: NSNumber ,feedProgrameName: String,feedId: NSNumber,postingIdFeed: NSNumber) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FeedProgramTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(feedProgrameName, forKey:"feddProgramNam")
        person.setValue(feedId, forKey:"feedId")
        person.setValue(sessionId, forKey:"loginSessionId")
        person.setValue(postingIdFeed, forKey:"postingId")
        person.setValue("", forKey:"formName")
        person.setValue(false, forKey:"isSync")
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        FeddProgram.append(person)
    }
    
    
    
    
    
    /************************** Feed Program *******************************************************/
    
    func SaveFeedProgramTurkey(_ index: Int, dbArray: NSArray, feedProgramData: CoreDataHandlerTurkeyModels.turkeyFeedProgramData) {
        feedprogramArray = dbArray
        
        if feedprogramArray.count > 0 {
            let objTable: FeedProgramTurkey = (feedprogramArray[index] as? FeedProgramTurkey)!
            
            do {
                if objTable.feedId == feedProgramData.feedId {
                    objTable.setValue(feedProgramData.feedProgrameName, forKey: "feddProgramNam")
                    objTable.setValue(feedProgramData.feedId, forKey: "feedId")
                    objTable.setValue(feedProgramData.sessionId, forKey: "loginSessionId")
                    objTable.setValue(feedProgramData.postingId, forKey: "postingId")
                    objTable.setValue(feedProgramData.formName, forKey: "formName")
                    objTable.setValue(feedProgramData.isSync, forKey: "isSync")
                    objTable.setValue(feedProgramData.lngId, forKey: "lngId")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        // Handle error
                    }
                }
            }
            return
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "FeedProgramTurkey", in: managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            person.setValue(feedProgramData.feedProgrameName, forKey: "feddProgramNam")
            person.setValue(feedProgramData.feedId, forKey: "feedId")
            person.setValue(feedProgramData.sessionId, forKey: "loginSessionId")
            person.setValue(feedProgramData.postingId, forKey: "postingId")
            person.setValue(feedProgramData.formName, forKey: "formName")
            person.setValue(feedProgramData.isSync, forKey: "isSync")
            person.setValue(feedProgramData.lngId, forKey: "lngId")
            
            do {
                try managedContext.save()
            } catch {
                print(appDelegateObj.testFuntion())
            }
            
            FeddProgram.append(person)
        }
    }

    func updateFeedProgramTurkey(_ feedId: NSNumber,isSync : Bool,feedProgrameName:String,formName: String)
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgramTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.feedIdPredicate, feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: FeedProgramTurkey = (fetchedResult![0] as? FeedProgramTurkey)!
                
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
    
    
    func FetchFeedProgramTurkey(_ postingId : NSNumber) -> NSArray
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgramTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                feedprogramArray = results as NSArray
                
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
    
    /***************************************************/
    
    func FetchFeedProgramAllTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FeedProgramTurkey")
        
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
    
    func SaveNecropsystep1Turkey(_ necropsyData: CoreDataHandlerTurkeyModels.saveTurkeyNecropsyStep1Data) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CaptureNecropsyDataTurkey", in: managedContext)
        
        let contact = CaptureNecropsyDataTurkey(entity: entityDescription!, insertInto: managedContext)
        
        contact.age = necropsyData.age
        contact.farmName = necropsyData.farmName
        contact.feedProgram = necropsyData.feedProgram
        contact.flockId = necropsyData.flockId
        contact.sick = necropsyData.sick
        contact.houseNo = necropsyData.houseNo
        contact.noOfBirds = necropsyData.noOfBirds
        contact.postingId = necropsyData.postingId
        contact.necropsyId = necropsyData.necId
        contact.complexName = necropsyData.compexName
        contact.complexDate = necropsyData.complexDate
        contact.complexId = necropsyData.complexId
        contact.custmerId = necropsyData.customerId
        contact.feedId = necropsyData.feedId
        contact.isChecked = false
        contact.isSync = necropsyData.isSync as NSNumber
        contact.timeStamp = necropsyData.timeStamp
        contact.actualTimeStamp = necropsyData.actualTimeStamp
        contact.lngId = necropsyData.lngId
        
        contact.farmWeight = necropsyData.farmWeight.isEmpty ? "0" : necropsyData.farmWeight
        contact.abf = necropsyData.abf
        contact.breed = necropsyData.breed
        contact.sex = necropsyData.sex
        contact.farmId = necropsyData.farmId
        contact.imageId = necropsyData.imageId
        contact.farmcount = necropsyData.count
        contact.generName = necropsyData.genName
        contact.generID = necropsyData.genId
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        necrpsystep1.append(contact)
    }
    
    func SaveNecropsystep1SingleDataTurkey(data: CoreDataHandlerTurkeyModels.singleNecropsyDataTurkey) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CaptureNecropsyDataTurkey", in: managedContext)
        
        let contact = CaptureNecropsyDataTurkey(entity: entityDescription!, insertInto: managedContext)
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
        contact.sex = data.sex
        contact.abf = data.abf
        contact.breed = data.breed
        contact.farmWeight = data.farmweight
        contact.feedId = data.feedId
        contact.isChecked = false
        contact.isSync = data.isSync as NSNumber
        contact.timeStamp = data.timeStamp
        contact.actualTimeStamp = data.actualTimeStamp
        contact.farmId = data.farmId
        contact.imageId = data.imgId
        contact.generName = data.generationName
        contact.generID = data.generationId as NSNumber

        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        necrpsystep1.append(contact)
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1Turkey(_ postingId : NSNumber) -> NSArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                necropsyStep1Array = results as NSArray
                
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    
    func FetchNecropsystep1AllWithNecIdTurkey(_ necId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        // fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                necropsyStep1Array = results as NSArray
                
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    
    func FetchNecropsystep1AllTurkey() -> NSArray
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResult
            {
                necropsyStep1Array = results as NSArray
                debugPrint(necropsyStep1Array)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        return necropsyStep1Array
    }
    
    
    func FetchNecropsystep1WithisSyncandPostingIdTurkey(_ isSync : Bool , postingId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1WithisSyncTurkey(_ isSync : Bool) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    /********************************************************************/
    
    func FetchNecropsystep1NecIdTurkey(_ necropsyId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    /************** Fetch Farm Name *****************************/
    func FetchNecropsystep1NecIdTurkeyWithFarmName(_ farmName : String,necropsyId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        // let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
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
                
                
            }
        }
        catch
        {
        }
        
        return necropsyStep1Array
        
    }
    /***************************************************************************/
    func FetchNecropsystep1UpdateFromUnlinkedTurkey(_ postingId : NSNumber) -> NSMutableArray {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do {
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
            } else {
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsySArray
        
    }
    
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1neccIdTurkey(_ necId : NSNumber) -> NSArray{
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func fetchNecropsystep1neccIdFeedProgramTurkey(_ necId : NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    
    
    func FetchNecropsystep1neccIdAllTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    func FetchNecropsystep1neccIdWithCheckFarmTurkey(_ necId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    func FetchFarmNameOnNecropsystep1neccIdTurkey(_ necId : NSNumber , feedProgramName : String , feedId : NSNumber) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@  AND isChecked == 1 AND feedId == %@", necId , feedId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                necropsyStep1Array = results as NSArray
                
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    
    func updateisSyncNecropsystep1neccIdTurkey(_ postingId : NSNumber, isSync : Bool,_ completion: (_ status: Bool) -> Void)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    
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
            
        }
        
        
    }
    
    ///******>>>>///
    
    
    
    /****/
    
    
    func updateisSyncNecropsystep1WithneccIdTurkey(_ necId : NSNumber, isSync : Bool) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    
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
    
    func updatComplexIdandComplexIDInNecropsystep1neccIdTurkey(_ necId : NSNumber , complexName : String , complexId : NSNumber) {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyDataTurkey = (fetchedResult![0] as? CaptureNecropsyDataTurkey)!
                
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
    
    func FetchNecropsystep1neccIdTrueValTurkey(_ necId : NSNumber,formTrueValue: Bool , feedProgram : String , feedId: NSNumber ) -> NSArray {
        
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
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
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    
    
    func updatePostingIdWithNecIdNecropsystep1Turkey(_ necId : NSNumber , postingId : NSNumber )
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    
                    objTable.setValue(postingId, forKey:"postingId")
                    do
                    {
                        try managedContext.save()
                        debugPrint("posting session updated with Posting Id.")
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
    
    func updatePostingIdWithNecIdNecropsystep1WithZeroTurkey(_ necId : NSNumber , postingId : NSNumber )
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    
                    objTable.setValue(postingId, forKey:"postingId")
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
    
    func updateFeedProgramNameoNNecropsystep1neccIdTurkey(_ necId : NSNumber , feedProgramName : String , formName : String , isCheckForm : Bool , feedId : NSNumber)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId , formName , feedProgramName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: CaptureNecropsyDataTurkey = (fetchedResult![0] as? CaptureNecropsyDataTurkey)!
                
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
    
    func updateFeedProgramNameoNNecropsystep1neccIdFeddprogramBlankTurkey(_ necId : NSNumber,formName : String , feedId : NSNumber)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necId , formName )
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: CaptureNecropsyDataTurkey = (fetchedResult![0] as? CaptureNecropsyDataTurkey)!
                
                objTable.setValue("", forKey:"feedProgram")
                objTable.setValue(1200, forKey:"feedId")
                
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
    
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    func FetchNecropsystep1AllNecIdTurkey() -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                necropsyStep1Array = results as NSArray
              //  debugPrint("necropsy data fecthec" ,  necropsyStep1Array)
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1AllNecIdTurkeyWithId(sessiondate:String,newString:String) -> NSArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "complexDate == %@ AND complexName == %@", sessiondate,newString)
        
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyStep1Array
        
    }
    
    func FetchNecropsystep1AllNecIdWithPostingIDZeroTurkey() -> NSMutableArray
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "postingId == 0")
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                for i in 0..<results.count
                {
                    let c = results[i] as! CaptureNecropsyDataTurkey
                    
                    let nId = c.necropsyId as!  Int
                    
                    necropsyNIdArray.add(c)
                    
                    for j in 0..<necropsyNIdArray.count - 1
                    {
                        let d = necropsyNIdArray.object(at: j)  as! CaptureNecropsyDataTurkey
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return necropsyNIdArray
        
    }
    
    
    /************************ Fetch Data Of Necropsy data 1 *******************************/
    
    
    
    func updateBirdNumberInNecropsystep1Turkey(_ postingId : NSNumber , index : Int)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            let objTable: CaptureNecropsyDataTurkey = (fetchedResult![index] as? CaptureNecropsyDataTurkey)!
            
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
    
    func updateBirdNumberInNecropsystep1withNecIdTurkey(_ necId : NSNumber , index : Int,isSync : Bool)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            let objTable: CaptureNecropsyDataTurkey = (fetchedResult![index] as? CaptureNecropsyDataTurkey)!
            
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
    
    
    func reduceBirdNumberInNecropsystep1Turkey(_ postingId : NSNumber , index : Int) ->Bool
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            var isBirdAvailable : Bool = true
            let objTable: CaptureNecropsyDataTurkey = (fetchedResult![index] as? CaptureNecropsyDataTurkey)!
            
            
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
    
    func reduceBirdNumberInNecropsystep1WithNecIdTurkey(_ necId : NSNumber , index : Int) ->Bool
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            var isBirdAvailable : Bool = true
            let objTable: CaptureNecropsyDataTurkey = (fetchedResult![index] as? CaptureNecropsyDataTurkey)!
            
            
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
        }
        return false
    }
    
    func fecthFrmWithBirdAndObservationTurkey(_ birdnumber: NSNumber,farmname : String, obsId : NSNumber , necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    
    
    /******************************************************************/
    
    
    func fecthFrmWithBirdAndObservationAllTurkey()-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        
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
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    
    
    
    /****************************************************************************/
    func fecthFrmWithCatnameWithBirdAndObservationTurkey(_ birdnumber: NSNumber,farmname : String, catName : String,necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        
        
        fetchRequest.predicate = NSPredicate(format: Constants.predicateCatNameBirdsFarmNecID, birdnumber,catName,farmname,necId)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                captureNecSkeltetonArray = results as NSArray
                
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                debugPrint(sortedResults)
                return sortedResults as  NSArray
                
               
                
            }
            else
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    func fecthFrmWithCatnameWithBirdAndObservationTurkeyBodyWeight(farmname : String, catName : String,necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        
        
        fetchRequest.predicate = NSPredicate(format: "catName == %@ AND formName == %@ AND necropsyId == %@",catName,farmname,necId)
        
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
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    
    func fecthFrmWithCatnameTurkey(_ farmname : String, catName : String , birdNo : NSNumber,necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    func updateQuickLinkOnCaptureNecTurkey(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber,necId: NSNumber , quickLink : NSNumber)
    
    {
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID ==%@ AND necropsyId == %@", birdnumber,catName,farmname,Obsid,necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![i] as? CaptureNecropsyViewDataTurkey)!
                    
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
    
    
    func fecthFrmWithCatnameWithBirdAndObservationIDTurkey(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber,necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
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
            {
                
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
    }
    
    func fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey(_ birdnumber: NSNumber,farmname : String, catName : String , necId: NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateCatNameBirdsFarmNecID, birdnumber,catName,farmname,necId)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                
                captureNecSkeltetonArray = results as NSArray
                
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = captureNecSkeltetonArray.sortedArray(using: [descriptor])
                debugPrint("sortedObs Name")
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
        
        return captureNecSkeltetonArray
    }
    
    fileprivate func handleCaptureNecropsyViewDataValidation(_ captureNecropsyViewData: CaptureNecropsyViewDataTurkey, _ d: NSMutableDictionary, _ trimmedString: String) {
        if captureNecropsyViewData.measure == "Y,N" {
            if captureNecropsyViewData.objsVisibilty != nil{
                d.setValue(captureNecropsyViewData.objsVisibilty!, forKey: trimmedString)
            }
        } else if captureNecropsyViewData.measure == "Actual" || captureNecropsyViewData.measure == "F,M" {
            if captureNecropsyViewData.actualText?.isEmpty == false {
                d.setValue(captureNecropsyViewData.actualText!, forKey: trimmedString)
            }
        } else {
            if captureNecropsyViewData.obsPoint != nil {
                d.setValue(captureNecropsyViewData.obsPoint!, forKey: trimmedString)
            }
        }
    }
    
    fileprivate func handleTrimmedStringAndValidations(_ trimmedString: inout String) {
        switch trimmedString {
        case "BursaLesions":
            trimmedString = "BursaLesionScore"
        case "MuscularHemorrhages":
            trimmedString = "MuscularHemorrhagies"
        case "RoundHeart":
            trimmedString = "CardiovascularHydropericardium"
        case "TBD1":
            trimmedString = "WoodyBreast"
        case "TBD2":
            trimmedString = "Pigmentation"
        case "TBD3":
            trimmedString = "IntestinalContents"
        case "TBD4":
            trimmedString = "ThickenedIntestine"
        case "TBD5":
            trimmedString = "ThinIntestine"
        case "TBD6":
            trimmedString = "Dehydrated"
        case "TBD7":
            trimmedString = "ThymusAtrophy"
        case "FemoralHeadSeparation(FHS)":
            trimmedString = "FemoralHeadSeparationFHS"
        case "EimeriaTenellaMicro":
            trimmedString = "TenellaMicro"
        case "Content":
            trimmedString = "MucousContent"
        case "Bacteria,Motile":
            trimmedString = "BacteriaMotile"
        case "Bacteria,Nonmotile":
            trimmedString = "BacteriaNonmotile"
        case "Cochlosoma":
            trimmedString = "ProtozoaCochlosoma"
        case "Trichomonas":
            trimmedString = "ProtozoaTrichomonas"
        case "Hexamita":
            trimmedString = "ProtozoaHexamita"
        case "Protozoa,Undefined":
            trimmedString = "ProtozoaUndefined"
        case Constants.maleFemaleStr:
            trimmedString = "MaleFemale"
        default:
            break
        }
    }
    
    func fetchObsWithBirdandFarmNameTurkey(_ formName : String , birdNo : NSNumber , necId : NSNumber)-> NSMutableDictionary {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchPredicate = NSPredicate(format: "birdNo == %@  AND formName == %@ AND necropsyId == %@", birdNo, formName,necId)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = fetchPredicate
        
        
        fetchRequest.returnsObjectsAsFaults = false
        let d = NSMutableDictionary()
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                captureNecSkeltetonArray = results as NSArray
                let c = results as NSArray
                
                for i in 0..<c.count {
                    let captureNecropsyViewData = c.object(at: i) as! CaptureNecropsyViewDataTurkey
                    guard let obsName = captureNecropsyViewData.obsName else { continue }
                    
                    var trimmedString = obsName
                        .replacingOccurrences(of: "/", with: "")
                        .replacingOccurrences(of: " ", with: "")
                    
                    handleTrimmedStringAndValidations(&trimmedString)
                    handleCaptureNecropsyViewDataValidation(captureNecropsyViewData, d, trimmedString)
                }
                
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        return d
        
    }
    
    func deleteCaptureNecropsyViewDataWithObsIDTurkey (_ obsId: NSNumber,necId:NSNumber) {
        let fetchPredicate = NSPredicate(format: "obsID == %@ AND necropsyId == %@", obsId,necId)
        
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey (_ obsId: NSNumber,formName : String ,catName : String, birdNo : NSNumber , necId : NSNumber)
    {
        let fetchPredicate = NSPredicate(format: "birdNo == %@  AND formName == %@ AND necropsyId == %@", birdNo, formName,necId)
        
        let fetchUsers    = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
    }
    
    /*******************************  Capture  data Base ********************************************************/
    /***************** save data Skleta ************************************************************************/
    
    func saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(_ data: CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext

        let entity = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewDataTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)

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
    
    func saveCaptureSkeletaInDatabaseOnSwithCaseTurkeySex(data: CoreDataHandlerTurkeyModels.turkeySexNecropsyData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewDataTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(data.catName, forKey:"catName")
        person.setValue(data.birdNo, forKey:"birdNo")
        person.setValue(data.formName, forKey:"formName")
        person.setValue(data.obsId, forKey:"obsID")
        person.setValue(data.obsName, forKey:"obsName")
        person.setValue(data.obsPoint, forKey:"obsPoint")
        person.setValue(NSNumber(value: data.obsVisibility), forKey:"objsVisibilty")
        person.setValue(data.measure, forKey:"measure")
        person.setValue(data.quickLink, forKey:"quickLink")
        person.setValue(data.necId, forKey:"necropsyId")
        person.setValue(data.isSync, forKey:"isSync")
        person.setValue(data.lngId, forKey:"lngId")
        person.setValue(data.refId, forKey:"refId")
        person.setValue(data.actualText, forKey: "actualText")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        captureSkeletaObject.append(person)
    }

    func saveCaptureSkeletaInDatabaseOnSwithCaseTurkeyImmuneCase(data: CoreDataHandlerTurkeyModels.imumneSwithcCaptureData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext

        let entity = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewDataTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)

        person.setValue(data.catName, forKey: "catName")
        person.setValue(data.birdNo, forKey: "birdNo")
        person.setValue(data.formName, forKey: "formName")
        person.setValue(data.obsId, forKey: "obsID")
        person.setValue(data.obsName, forKey: "obsName")
        person.setValue(data.obsPoint, forKey: "obsPoint")
        person.setValue(NSNumber(value: data.obsVisibility as Bool), forKey: "objsVisibilty")
        person.setValue(data.measure, forKey: "measure")
        person.setValue(data.quickLink, forKey: "quickLink")
        person.setValue(data.necId, forKey: "necropsyId")
        person.setValue(data.isSync, forKey: "isSync")
        person.setValue(data.lngId, forKey: "lngId")
        person.setValue(data.refId, forKey: "refId")
        person.setValue("\(data.obsPoint)", forKey: "actualText")

        do {
            try managedContext.save()
        } catch {
            print(appDelegate!.testFuntion())
        }

        captureSkeletaObject.append(person)
    }
    
    func saveCaptureSkeletaInDatabaseOnSwithCaseSingleDataTurkey(data: CoreDataHandlerTurkeyModels.singleNecroSwithCaseData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewDataTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        person.setValue(data.catName, forKey: "catName")
        person.setValue(data.birdNo, forKey: "birdNo")
        person.setValue(data.formName, forKey: "formName")
        person.setValue(data.obsId, forKey: "obsID")
        person.setValue(data.obsName, forKey: "obsName")
        person.setValue(data.obsPoint, forKey: "obsPoint")
        person.setValue(NSNumber(value: data.obsVisibility), forKey: "objsVisibilty")
        person.setValue(data.measure, forKey: "measure")
        person.setValue(data.quickLink, forKey: "quickLink")
        person.setValue(data.necIdSingle, forKey: "necropsyId")
        person.setValue(data.isSync, forKey: "isSync")
        person.setValue(data.lngId, forKey: "lngId")
        person.setValue(data.refId, forKey: "refId")
        person.setValue("\(data.obsPoint)", forKey: "actualText")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        captureSkeletaObject.append(person)
    }

    
/*
    func saveCaptureSkeletaInDatabaseOnSwithCaseSingleDataTurkey(catName : String,obsName : String,formName : String, obsVisibility : Bool,  birdNo : NSNumber,obsPoint:NSInteger, index : Int,obsId: NSInteger ,measure: String,quickLink: NSNumber,necId:NSNumber,isSync : Bool,necIdSingle:NSNumber,lngId:NSNumber,refId:NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "CaptureNecropsyViewDataTurkey", in: managedContext)
        
        
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
        person.setValue("\(obsPoint)", forKey: "actualText")
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
    func deleteDataWithStep2dataTurkey (_ necId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers            = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchUsers.predicate   = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: CoreDataHandlerTurkeyModels.updateWeightSkeletaData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND necropsyId == %@ AND obsName == %@", data.birdNo, data.catName, data.formName, data.necId, data.obsName)
        
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            let objTable = (fetchedResult![data.index] as? CaptureNecropsyViewDataTurkey)!
            objTable.setValue(data.actualName, forKey: "actualText")
            objTable.setValue(data.isSync, forKey: "isSync")
            
            do {
                try objTable.managedObjectContext!.save()
            } catch {
                // handle error
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }

    /********* Update BodyWeight in immune ************/
    
    func updateCaptureSkeletaInDatabaseOnActualClickTurkeyBodyWeight(_ catName : String,obsName : String,formName : String,  obsPoint :Int, index : Int , necId : NSNumber , isSync : Bool)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "catName == %@ AND formName == %@ AND necropsyId == %@ AND obsName == %@",catName,formName,necId,obsName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            //let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![index] as? CaptureNecropsyViewDataTurkey)!
            
            for i in 0..<fetchedResult!.count
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![i] as? CaptureNecropsyViewDataTurkey)!
                objTable.setValue(obsPoint, forKey:"obsPoint")
                objTable.setValue(isSync, forKey:"isSync")
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
    
    
    func updateCaptureSkeletaInDatabaseOnActualClickTurkeySex(_ catName : String,obsName : String,formName : String,  actualText :String, index : Int , necId : NSNumber , isSync : Bool)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "catName == %@ AND formName == %@ AND necropsyId == %@ AND obsName == %@",catName,formName,necId,obsName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            for i in 0..<fetchedResult!.count
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![i] as? CaptureNecropsyViewDataTurkey)!
                objTable.setValue(actualText, forKey:"actualText")
                objTable.setValue(isSync, forKey:"isSync")
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
    
    
    func updateisSyncOnCaptureSkeletaInDatabaseTurkey(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![i] as? CaptureNecropsyViewDataTurkey)!
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
            //print("There is some error.")
        }
    }
    
    func updateisSyncOnCaptureInDatabaseTurkey(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
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
            //print("There is some error.")
        }
    }
    
    func updateCaptureSkeletaInDatabaseOnStepperTurkey(_ catName : String,obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , index : Int, necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@", birdNo,catName,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
                
                
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
            //print("There is some error.")
        }
    }
    
    
    func updateObsDataInCaptureSkeletaInDatabaseOnActualTurkey(_ obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , actualName : String , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@", birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
                
                
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
            //print("There is some error.")
        }
    }
    
    
    //MARK: - Update Swich Method //
    
    func updateCaptureSkeletaInDatabaseOnSwitchMethodTurkey(_ catName : String,obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , switchValue : Bool , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "birdNo == %@ AND catName == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@", birdNo,catName,formName,obsId,necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
                
                
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
            //print("There is some error.")
        }
        
    }
    
    func updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        self.managedContext = appDelegate.managedObjectContext

        let imageData = input.camraImage.jpegData(compressionQuality: 0.5)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateCatNameBirdsFarmNecID, input.birdNo, input.catName, input.formName, input.necId)

        do {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult {
                fecthPhotoArray = results as NSArray

                let descriptor = NSSortDescriptor(key: "obsName", ascending: true)
                let sortedResults = fecthPhotoArray.sortedArray(using: [descriptor])

                if let objTable = (sortedResults as NSArray)[index] as? CaptureNecropsyViewDataTurkey {
                    objTable.setValue(NSNumber(value: input.obsVisibility), forKey: "objsVisibilty")
                    objTable.setValue(imageData, forKey: "cameraImage")
                    objTable.setValue(input.obsPoint, forKey: "obsPoint")
                    objTable.setValue(input.birdNo, forKey: "birdNo")
                    objTable.setValue(input.formName, forKey: "formName")
                    objTable.setValue(input.isSync, forKey: "isSync")

                    try objTable.managedObjectContext?.save()
                }
            }
        } catch {
            // Log error if needed
        }
    }

    func updateCaptureSkeletaInDatabaseTurkeySexValue(_ data: CoreDataHandlerTurkeyModels.updateSkeletaTurkeySexValueObs, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(
            format: "birdNo == %@ AND catName == %@ AND formName == %@ AND necropsyId == %@",
            data.birdNo, data.catName, data.formName, data.necId
        )

        do {
            if let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                fecthPhotoArray = fetchedResult as NSArray

                let sortedResults = fecthPhotoArray.sortedArray(using: [NSSortDescriptor(key: "obsName", ascending: true)])
                if let objTable = sortedResults[index] as? CaptureNecropsyViewDataTurkey {
                    objTable.setValue(NSNumber(value: data.obsVisibility), forKey: "objsVisibilty")
                    objTable.setValue(data.obsPoint, forKey: "obsPoint")
                    objTable.setValue(data.birdNo, forKey: "birdNo")
                    objTable.setValue(data.formName, forKey: "formName")
                    objTable.setValue(data.isSync, forKey: "isSync")
                    objTable.setValue(data.actualText, forKey: "actualText")
                    
                    try objTable.managedObjectContext?.save()
                }
            }
        } catch {
            // Handle error
        }
    }

    func deleteCaptureNecropsyViewDataTurkey () {
        
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    //MARK: Bird Photo
    
    func getSaveImageFromServerTurkey(_ dict : NSDictionary)  {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        
        let encodedImageData = String(describing: dict.value(forKey: "image")!)
        let imageData = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions(rawValue: 0))
        let image = UIImage(data: imageData!)
        let imageData1 = image!.jpegData(compressionQuality: 0.5)
        let entity   = NSEntityDescription.entity(forEntityName: "BirdPhotoCaptureTurkey", in: managedContext)
        let person   = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(dict.value(forKey: "farmName"), forKey:"farmName")
        person.setValue(dict.value(forKey: "categoryName"), forKey:"catName")
        person.setValue(dict.value(forKey: "birdNumber"), forKey:"birdNum")
        person.setValue(dict.value(forKey: "observationName"), forKey:"obsName")
        //person.setValue(" ", forKey:"obsName")
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
            //print("There is some error.")
        }
        
        capturePhotoObject.append(person)
        
    }
    
    func getSaveImageFromServerSingledataTurkey(_ dict : NSDictionary,necIdSingle:NSNumber)  {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        
        let encodedImageData = String(describing: dict.value(forKey: "image")!)
        let imageData = Data(base64Encoded: encodedImageData, options: NSData.Base64DecodingOptions(rawValue: 0))
        let image = UIImage(data: imageData!)
        let imageData1 = image!.jpegData(compressionQuality: 0.5)
        let entity   = NSEntityDescription.entity(forEntityName: "BirdPhotoCaptureTurkey", in: managedContext)
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
            //print("There is some error.")
        }
        
        capturePhotoObject.append(person)
        
    }
    
    func deleteImageForSingleTurkey(_ necId: NSNumber) {
        
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers   = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
        fetchUsers.predicate  = fetchPredicate
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    /************************** Get Api for Save Image from server **************************************/
    
    func saveCaptureSkeletaImageInDatabaseTurkey(_ data: CoreDataHandlerTurkeyModels.SkeletalTurkeyImageData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        guard let imageData = data.camraImage.jpegData(compressionQuality: 1.0) else { return }

        let entity = NSEntityDescription.entity(forEntityName: "BirdPhotoCaptureTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)

        person.setValue(data.formName, forKey: "farmName")
        person.setValue(data.catName, forKey: "catName")
        person.setValue(data.birdNo, forKey: "birdNum")
        person.setValue(data.obsName, forKey: "obsName")
        person.setValue(data.obsId, forKey: "obsId")
        person.setValue(imageData, forKey: "photo")
        person.setValue(data.necropsyId, forKey: "necropsyId")
        person.setValue(data.isSync, forKey: "isSync")

        do {
            try managedContext.save()
        } catch {
            // handle error if needed
        }

        capturePhotoObject.append(person)
    }

    /******************************************************************/
    func updateisSyncOnBirdPhotoCaptureDatabaseTurkey(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: BirdPhotoCaptureTurkey = (fetchedResult![i] as? BirdPhotoCaptureTurkey)!
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
    func fecthPhotoWithFormNameTurkey(_ farmname : String,necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCaptureTurkey")
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
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fecthPhotoArray
    }
    
    
    func fecthPhotoWithiSynsTrueTurkey(_ isSync : Bool)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
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
                //print("Could not fetch result")
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fecthPhotoArray
    }
    
    
    func fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber , obsName : String,necId :NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCaptureTurkey")
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
                print(appDelegateObj.testFuntion())
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return fecthPhotoArray
    }
    
    func fecthPhotoWithCatnameWithBirdAndObservationIDandIsyncTurkey(_ birdnumber: NSNumber,farmname : String, catName : String , Obsid : NSNumber , isSync : Bool,necId :NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "BirdPhotoCaptureTurkey")
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
                //print("Could not fetch result")
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fecthPhotoArray
    }
    
    func saveNoofBirdWithNotesTurkey(_ catName : String,notes : String,formName : String,   birdNo : NSNumber, index : Int , necId : NSNumber , isSync : Bool)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity   = NSEntityDescription.entity(forEntityName: "NotesBirdTurkey", in: managedContext)
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
            //print("There is some error.")
        }
        
        captureBirdWithNotesObject.append(person)
        
        
    }
    
    func saveNoofBirdWithNotesSingledataTurkey(_ data: CoreDataHandlerTurkeyModels.saveTurkeyNoteData) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "NotesBirdTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)

        person.setValue(data.formName, forKey: "formName")
        person.setValue(data.catName, forKey: "catName")
        person.setValue(data.notes, forKey: "notes")
        person.setValue(data.birdNo, forKey: "noofBirds")
        person.setValue(data.necIdSingle, forKey: "necropsyId")
        person.setValue(data.isSync, forKey: "isSync")

        do {
            try managedContext.save()
        } catch {
            // Handle error here
        }

        captureBirdWithNotesObject.append(person)
    }

    
    
    func deleteDataBirdNotesWithIdTurkey (_ necId: NSNumber)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necIdPredicate, necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func updateisSyncOnNotesBirdDatabaseTurkey(_ necId : NSNumber , isSync : Bool,_ completion: (_ status: Bool) -> Void)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.necIdPredicate, necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: NotesBirdTurkey = (fetchedResult![i] as? NotesBirdTurkey)!
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
            //print("There is some error.")
        }
        
        
        
    }
    func updateNoofBirdWithNotesTurkey(_ catName : String,formName : String,   birdNo : NSNumber , notes: String , necId : NSNumber,isSync : Bool)
    {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateBirdsFarmNecID, birdNo,formName,necId)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: NotesBirdTurkey = (fetchedResult![0] as? NotesBirdTurkey)!
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
            //print("There is some error.")
        }
        
    }
    
    func stTurkey(_ catName : String,formName : String,   birdNo : NSNumber ,necId : NSNumber)-> NSArray {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
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
    
    
    func fetchNoofBirdWithFormTurkey(_ catName : String,formName : String , necId: NSNumber )-> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesBirdTurkey")
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
                
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fetchBirdNotesArray
    }
    
    func fetchNotesWithBirdNumandFarmNameTurkey(_ birdNo : NSNumber,formName : String , necId: NSNumber )-> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
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
                
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fetchBirdNotesArray
    }
    
    
    
    
    func fetchNoofBirdWithNotesTurkey(_ catName : String,formName : String,   birdNo : NSNumber ,necId : NSNumber)-> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesBirdTurkey")
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
                
            }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return fetchBirdNotesArray
    }
    
    
    
    func deleteNotesBirdWithFarmnameTurkey (_ formName : String ,  birdNo : NSNumber , necId : NSNumber)
    {
        let fetchPredicate = NSPredicate(format: "noofBirds == %@  AND formName == %@ AND necropsyId = %@", birdNo, formName , necId)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func deleteNotesBirdTurkey ()
    {
        let fetchUsers = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        
        do {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    
    func fetchCaptureWithFormNameNecSkeltonDataTurkey(farmName:String, necID : NSNumber) -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        
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
            {print(appDelegateObj.testFuntion())}
        }
        catch
        {
            //print("There is some error.")
        }
        
        return captureNecSkeltetonArray
        
    }
    
    func updateCellIndexTurkey(_ formName : String , necID : NSNumber , cellIndex: NSNumber)
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "formName == %@ AND necropsyId == %@", formName,necID)
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
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
    
    func AllCappNecdataTurkey() -> NSArray
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                captureNecSkeltetonArray = results as NSArray
                debugPrint(captureNecSkeltetonArray)
            }
            else
            {
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return captureNecSkeltetonArray
        
    }
    
    /**************************  Quick Link Methods ****************************************/
    func updateObsDataInCaptureSkeletaInDatabaseOnStepperTurkey(_ obsName : String,formName : String,   birdNo : NSNumber ,  obsId : NSNumber , index : Int , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
                
                
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
            //print("There is some error.")
        }
        
    }
    
    
    /******************************* Switch Methods *************************************************/
    
    
    func updateSwitchDataInCaptureSkeletaInDatabaseOnSwitchTurkey(_ formName : String,   birdNo : NSNumber ,  obsId : NSNumber , obsVisibility : Bool , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
                
                
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
            //print("There is some error.")
        }
    }
    
    /******************************* Bird Sex Button Methods *************************************************/
    
    func updateBirdSexDataInCaptureSkeletaInDatabaseTurkey(_ formName : String,   birdNo : NSNumber ,  obsId : NSNumber , BirdSex : String , necId : NSNumber)
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: Constants.predicateObsIdBirdsFarmNecID, birdNo,formName,obsId , necId)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![0] as? CaptureNecropsyViewDataTurkey)!
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
            //print("There is some error.")
        }
    }
    
    
    
    ////////**************Fetch Report Screen Data***************/////////////
    
    func fetchLastSessionDetailsTurkey(_ postingId : NSNumber) -> NSArray {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        let fetchPredicate = NSPredicate(format: Constants.postincIdPredicate, postingId)
        fetchRequest.predicate = fetchPredicate
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult
            {
                return results as NSArray
                
            }
            else
            { }
            
            
        }
        catch
        {
            //print("There is some error.")
        }
        
        return dataArray
    }
    
    func fetch_GI_Tract_AllDataTurkey(_ farmName : NSString , postingId : NSNumber) -> NSArray
    
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        
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
            { }
        }
        catch
        {
            //print("There is some error.")
        }
        
        return dataArray
    }
    
    /********************** ***************************/
    
    func FarmsDataDatabaseTurkey(_ stateName: String,stateId: NSNumber,farmName: String,farmId: NSNumber,countryName: String,countryId: NSNumber,city: String)
    
    {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "FarmsListTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(city, forKey:"City")
        
        person.setValue(countryId, forKey:"CountryId")
        person.setValue(countryName, forKey:Constants.countryNamStr)
        person.setValue(farmId, forKey:"FarmId")
        person.setValue(farmName, forKey:"FarmName")
        person.setValue(stateId, forKey:"StateId")
        person.setValue(stateName, forKey:"StateName")
        
        do
            
        {
            try managedContext.save()
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        FarmsTypeObject.append(person)
        
    }
    
    func fetchFarmsDataDatabaseTurkey() -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FarmsListTurkey")
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        
        
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
    
    /********** Fetch farm using ComlexId **********************/
    
    func fetchFarmsDataDatabaseUsingCompexIdTurkey(complexId:NSNumber) -> NSArray
    
    {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "FarmsListTurkey")
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
    
    
    func removeDuplicatesTurkey(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value as! String)
                // ... Append the value.
                result.add(value as! String)
            }
        }
        
        return result
    }
    //MARK: sync available
    func checkPostingSessionHasiSyncTrueTurkey(_ postingID : NSNumber,isSync: NSNumber)-> Bool
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "PostingSessionTurkey")
        fetchRequest.predicate = NSPredicate(format: "postingId == %@ AND isSync == %@", postingID , NSNumber(booleanLiteral: isSync as! Bool))
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
            //print("There is some error.")
        }
        
        return false
    }
    func checkNecropcySessionHasiSyncTrueTurkey(_ postingID : NSNumber,isSync: NSNumber)-> Bool
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND isSync == %@", postingID , NSNumber(booleanLiteral: isSync as! Bool))
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResult ,  results.count>0{
               
                    return true
                
            }
        }
        catch {
            //print("There is some error.")
        }
        
        return false
    }
    /************** Update FarmName ********************/
    func updateNecropsystep1WithNecIdAndFarmNameTurkey(_ necropsyId : NSNumber , farmName : NSString , newFarmName : NSString , age : String,isSync:Bool,farmWeight : String , newHouseNoTurkey : NSString , _ birdSexTurkey : NSString){
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necropsyId, farmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    objTable.setValue(newFarmName, forKey:"farmName")
                    objTable.setValue(isSync, forKey:"isSync")
                    objTable.setValue(age, forKey:"age")
                    objTable.setValue(farmWeight, forKey:"farmWeight")
                    objTable.setValue(newHouseNoTurkey, forKey:"houseNo")
                    objTable.setValue(birdSexTurkey, forKey: "sex")
                    do
                    {
                        try managedContext.save()
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
    
    
    /************** Update FarmWeight ****************** feedback changes**/
    func updateNecropsyFarmWeightstep1WithNecIdTurkey(_ necropsyId : NSNumber,isSync:Bool,farmWeight : String ,farmName : NSString){
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.necFarmNamePredicate, necropsyId ,farmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyDataTurkey = (fetchedResult![i] as? CaptureNecropsyDataTurkey)!
                    
                    objTable.setValue(farmWeight, forKey:"farmWeight")
                    //  objTable.setValue(farmName, forKey:"farmName")
                    do
                    {
                        try managedContext.save()
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
    
    
    /******* Update Farm Name In Step ! ****************/
    func updateNewFarmAndAgeOnCaptureNecropsyViewDataTurkey(_ necId : NSNumber , oldFarmName : String , newFarmName : String ,isSync:Bool) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND formName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: CaptureNecropsyViewDataTurkey = (fetchedResult![i] as? CaptureNecropsyViewDataTurkey)!
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
    
    func updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdPhotoTurkey(_ necId : NSNumber , oldFarmName : String , newFarmName : String ,isSync:Bool) {
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND farmName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0
            {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: BirdPhotoCaptureTurkey = (fetchedResult![i] as? BirdPhotoCaptureTurkey)!
                    objTable.setValue(isSync, forKey:"isSync")
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
        catch
        {
            print(appDelegateObj.testFuntion())
        }
    }
    
    func updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdNotesTurkey(_ necId : NSNumber , oldFarmName : String , newFarmName : String ,isSync:Bool) {
        
        let appDelegate  = UIApplication.shared.delegate as? AppDelegate
        
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchRequest.predicate = NSPredicate(format: "necropsyId == %@ AND formName == %@ ", necId , oldFarmName)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if fetchedResult!.count > 0 {
                for i in 0..<fetchedResult!.count
                {
                    let objTable: NotesBirdTurkey = (fetchedResult![i] as? NotesBirdTurkey)!
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
            
        } catch {
            //print("There is some error.")
        }
    }
    
    //MARK: - Methods To get observation names
    
    func getObservationNameForGITractTurkey(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"GITractTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let results = fetchedResult, results.count > 0 {
                        
                        let ob: GITractTurkey = results.last as! GITractTurkey
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
    func getObservationNameForSkelatalTurkey(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"SkeletaTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                if let results = fetchedResult, results.count > 0 {
                    let ob: SkeletaTurkey = results.last as! SkeletaTurkey
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
    func getObservationNameForImmuneTurkey(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"ImmuneTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult , results.count > 0
                {
                   
                        let ob: ImmuneTurkey = results.last as! ImmuneTurkey
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
    func getObservationNameForMicroscopy(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"CoccidiosisTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResult , results.count > 0
                {
                    
                        let ob: CoccidiosisTurkey = results.last as! CoccidiosisTurkey
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
    func getObservationNameForRespiratoryTurkey(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"RespiratoryTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do
            {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                
                
                if let results = fetchedResult ,  results.count > 0
                {
                    let ob: RespiratoryTurkey = results.last as! RespiratoryTurkey
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
    func getObservationNameForCoccidiosisTurkey(refID: Array<Any>) -> Array<Any> {
        var nameArray = Array<Any>()
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName:"CoccidiosisTurkey")
        let languageID = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
        
        for item in refID {
            fetchRequest.predicate = NSPredicate(format: Constants.predicateRefLang, item as! NSNumber,languageID)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]           
                
                if let results = fetchedResult, results.count > 0, let ob = results.last as? CoccidiosisTurkey, ob.visibilityCheck == true {
                    nameArray.append(ob.observationField!)
                }

                
            }
            catch {
            }
        }
        return nameArray
    }
    func fetchAllPostingExistingSessionWithId(sessionDate: String,newString:String) -> NSArray    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.managedObjectContext
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.predicate = NSPredicate(format: "sessiondate == %@ AND complexName == %@", sessionDate,newString)
        
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
                
            }
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
        return postingArray
        
    }
    func deleteDataWithPostingIdStep1dataWithfarmNameTurkey (_ postingId: NSNumber,farmName:String)
    {
        let fetchPredicate = NSPredicate(format: Constants.necFarmNamePredicate, postingId,farmName)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    func deleteDataWithPostingIdStep2dataCaptureNecViewWithfarmNameTurkey (_ postingId: NSNumber,farmName:String)
    {
        let fetchPredicate = NSPredicate(format: Constants.predicateNecFarmName, postingId,farmName)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "CaptureNecropsyViewDataTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    func deleteDataWithPostingIdStep2NotesBirdWithFarmNameTurkey (_ postingId: NSNumber,farmName:String)
    {
        let fetchPredicate = NSPredicate(format: Constants.predicateNecFarmName, postingId,farmName)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "NotesBirdTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    func deleteDataWithPostingIdStep2CameraIamgeWithFarmNameTurkey (_ postingId: NSNumber,farmName:String)
    {
        
        let fetchPredicate = NSPredicate(format: Constants.necFarmNamePredicate, postingId,farmName)
        let fetchUsers                      = NSFetchRequest<NSFetchRequestResult>(entityName:  "BirdPhotoCaptureTurkey")
        fetchUsers.predicate                = fetchPredicate
        
        do
            
        {
            let results = try managedContext.fetch(fetchUsers)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        }
        catch
        {
            print(appDelegateObj.testFuntion())
        }
        
    }
    func fecthFrmWithCatnameWithBirdAndObservationWithDeleteTurkey(farmname : String,necId:NSNumber)-> NSArray
    {
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName: "CaptureNecropsyViewDataTurkey")
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
    
    func fetchCompletePostingSessionTurkey(_ postingid :NSNumber) -> PostingSessionTurkey {
        
        let appDelegate    = UIApplication.shared.delegate as! AppDelegate
        
        self.managedContext = appDelegate.managedObjectContext
        
        let fetchRequest   = NSFetchRequest<NSFetchRequestResult>(entityName:  "PostingSessionTurkey")
        
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: Constants.postincIdPredicate, postingid)
        
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            
            if let results = fetchedResult?[0]
            {
                return results as! PostingSessionTurkey
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
        return PostingSessionTurkey()
    }
    
    func fetchAllBirdsSwapedIndexes() -> [AllBirdsSwapedArrayTurkey] {
        
        var result = [AllBirdsSwapedArrayTurkey]()
        
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AllBirdsSwapedArrayTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as? [AllBirdsSwapedArrayTurkey]
            if objects!.count != 0 {
                result = objects ?? []
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
        
        return result
        
    }
    
    func saveAllBirdsSwapedIndexes(_ birdName: String, index: Int) {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "AllBirdsSwapedArrayTurkey", in: managedContext)
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(birdName, forKey:"birdName")
        person.setValue(index, forKey:"index")
        
        do {
            try managedContext.save()
        } catch {
            print(appDelegateObj.testFuntion())
        }
        
    }
    
    func deleteAllBirdsSwapedIndexes() {
        let appDelegate    = UIApplication.shared.delegate as? AppDelegate
        self.managedContext = appDelegate!.managedObjectContext
        
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "AllBirdsSwapedArrayTurkey")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let objects = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            for item in objects ?? []  {
                managedContext.delete(item)
                try managedContext.save()
            }
        } catch {
            print(appDelegateObj.testFuntion())
        }
    }
    
}


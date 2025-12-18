//
//  SyncJSONManager.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 11/12/25.
//

import Foundation


class SyncJSONManager {

    static let shared = SyncJSONManager() // Singleton for easy access
    var postingIdArr = NSMutableArray()
    private init() {}
    
    func getNecropsyJSONForTurkey(postingId: NSNumber) -> [String:Any]?{
        var complexId = Int()
        var postingArrWithAllData = NSMutableArray()

        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
        let a = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            a.add(captureNecropsyData)
            for w in 0..<a.count - 1
            {
                let c = a.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId {
                    a.remove(c)
                }
            }
        }
        
        let sessionWithAllforms = NSMutableDictionary()
        let sessionArr = NSMutableArray()
        for i in 0..<a.count
        {
            let allArray = NSMutableArray()
            let captureNecropsyData = a.object(at: i)  as! CaptureNecropsyDataTurkey
            
            complexId = Int(captureNecropsyData.complexId!)
            
            let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
            let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
            for x in 0..<cNec.count
            {
                let birdArry = NSMutableArray()
                let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
                
                let age = cNData.age
                let flock = cNData.flockId
                let sick = cNData.sick
                let imgId = cNData.imageId
                complexId = cNData.complexId as! Int
                
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexdate = cNData.complexDate
                let abf = cNData.abf
                let farmWeight = cNData.farmWeight
                let breedString = cNData.breed
                let sex = cNData.sex
                let farmId = cNData.farmId
                let genName = cNData.generName
                let genId = cNData.generID
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                
                for j in 0..<noOfBird!
                {
                    let obsNameWithValue =   CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                    let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                    if notesWithFarm.count > 0
                    {
                        let n = notesWithFarm.object(at: 0) as! NotesBirdTurkey
                        let notes = n.notes
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue(notes, forKey: "birdNotes")
                    } else {
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue("", forKey: "birdNotes")
                    }
                    birdArry.add(obsNameWithValue)
                }
                
                formWithcatNameWithBirdAndAllObs.setValue(birdArry, forKey: "BirdDetails")
                formWithcatNameWithBirdAndAllObs.setValue(farmName, forKey: "farmName")
                formWithcatNameWithBirdAndAllObs.setValue(houseNo, forKey: "houseNo")
                formWithcatNameWithBirdAndAllObs.setValue(noOfBird!, forKey: "birds")
                formWithcatNameWithBirdAndAllObs.setValue(farmId, forKey: "SortId")
                formWithcatNameWithBirdAndAllObs.setValue(imgId, forKey: "ImgId")
                formWithcatNameWithBirdAndAllObs.setValue(feedProgram, forKey: "feedProgram")
                formWithcatNameWithBirdAndAllObs.setValue(feedId, forKey: "DeviceFeedId")
                formWithcatNameWithBirdAndAllObs.setValue(age, forKey: "age")
                formWithcatNameWithBirdAndAllObs.setValue(customerId, forKey: "customerId")
                formWithcatNameWithBirdAndAllObs.setValue(customerName, forKey: "customerName")
                formWithcatNameWithBirdAndAllObs.setValue(sick, forKey: "sick")
                formWithcatNameWithBirdAndAllObs.setValue(flock, forKey: "flockId")
                formWithcatNameWithBirdAndAllObs.setValue(complexdate, forKey: "ComplexDate")
                formWithcatNameWithBirdAndAllObs.setValue(abf, forKey: "ABF")
                formWithcatNameWithBirdAndAllObs.setValue(farmWeight, forKey: "Farm_Weight")
                formWithcatNameWithBirdAndAllObs.setValue(breedString, forKey: "Breed")
                formWithcatNameWithBirdAndAllObs.setValue(sex, forKey: "Sex")
                
                formWithcatNameWithBirdAndAllObs.setValue(genName, forKey: "GenerationName")
                formWithcatNameWithBirdAndAllObs.setValue(genId, forKey: "GenerationId")
                allArray.add(formWithcatNameWithBirdAndAllObs)
            }
            
            var fullData = captureNecropsyData.timeStamp!
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.necropsyId!, forKey: "SessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(lngId, forKey: "LanguageId")
            formWithcatNameWithBirdAndAllObs1.setValue(fullData, forKey: "deviceSessionId")
            if complexId > 0{
                formWithcatNameWithBirdAndAllObs1.setValue(complexId, forKey: "ComplexId")
            }
            
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.complexDate!, forKey: "sessionDate")
            formWithcatNameWithBirdAndAllObs1.setValue(allArray, forKey: "farmDetails")
            let Id = UserDefaults.standard.integer(forKey: "Id")
            formWithcatNameWithBirdAndAllObs1.setValue(Id, forKey: "UserId")
            
            sessionArr.add(formWithcatNameWithBirdAndAllObs1)
        }
        postingArrWithAllData.removeAllObjects()
        postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        
        for i in 0..<postingArrWithAllData.count {
            
            let allArray = NSMutableArray()
            let captureNecropsyData = postingArrWithAllData.object(at: i)  as! PostingSessionTurkey
            
            let cid = captureNecropsyData.complexId!
            let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
            
            let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
            
            for x in 0..<cNec.count {
                
                let birdArry = NSMutableArray()
                let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
                if let value =  (cNData.feedId  as? Int){
                    feedId = value
                }
                let age = cNData.age
                
                let flock = cNData.flockId
                let imgId = cNData.imageId
                let farmId = cNData.farmId
                let sick = cNData.sick
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexDate = cNData.complexDate
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                let abf = cNData.abf
                let farmWeight = cNData.farmWeight
                let breedString = cNData.breed
                let sex = cNData.sex
                let genName = cNData.generName
                let genId = cNData.generID
                
                for j in 0..<noOfBird! {
                    
                    let obsNameWithValue =   CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                    let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                    
                    if notesWithFarm.count > 0 {
                        let n = notesWithFarm.object(at: 0) as! NotesBirdTurkey
                        let notes = n.notes
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue(notes, forKey: "birdNotes")
                    }  else  {
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue("", forKey: "birdNotes")
                    }
                    birdArry.add(obsNameWithValue)
                }
                
                formWithcatNameWithBirdAndAllObs.setValue(abf, forKey: "ABF")
                formWithcatNameWithBirdAndAllObs.setValue(farmWeight, forKey: "Farm_Weight")
                formWithcatNameWithBirdAndAllObs.setValue(breedString, forKey: "Breed")
                formWithcatNameWithBirdAndAllObs.setValue(sex, forKey: "Sex")
                formWithcatNameWithBirdAndAllObs.setValue(farmId, forKey: "SortId")
                formWithcatNameWithBirdAndAllObs.setValue(imgId, forKey: "ImgId")
                formWithcatNameWithBirdAndAllObs.setValue(birdArry, forKey: "BirdDetails")
                formWithcatNameWithBirdAndAllObs.setValue(farmName, forKey: "farmName")
                formWithcatNameWithBirdAndAllObs.setValue(houseNo, forKey: "houseNo")
                formWithcatNameWithBirdAndAllObs.setValue(noOfBird!, forKey: "birds")
                formWithcatNameWithBirdAndAllObs.setValue(feedProgram, forKey: "feedProgram")
                formWithcatNameWithBirdAndAllObs.setValue(feedId, forKey: "DeviceFeedId")
                formWithcatNameWithBirdAndAllObs.setValue(age, forKey: "age")
                formWithcatNameWithBirdAndAllObs.setValue(customerId, forKey: "customerId")
                formWithcatNameWithBirdAndAllObs.setValue(customerName, forKey: "customerName")
                formWithcatNameWithBirdAndAllObs.setValue(sick, forKey: "sick")
                formWithcatNameWithBirdAndAllObs.setValue(flock, forKey: "flockId")
                formWithcatNameWithBirdAndAllObs.setValue(complexDate, forKey: "ComplexDate")
                formWithcatNameWithBirdAndAllObs.setValue(genName, forKey: "GenerationName")
                formWithcatNameWithBirdAndAllObs.setValue(genId, forKey: "GenerationId")
                allArray.add(formWithcatNameWithBirdAndAllObs)
                
            }
            
            var fullData = captureNecropsyData.timeStamp!
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.postingId!, forKey: "SessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(fullData, forKey: "deviceSessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(lngId, forKey: "LanguageId")
            formWithcatNameWithBirdAndAllObs1.setValue(cid, forKey: "ComplexId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.sessiondate!, forKey: "sessionDate")
            formWithcatNameWithBirdAndAllObs1.setValue(allArray, forKey: "farmDetails")
            let Id = UserDefaults.standard.integer(forKey: "Id")
            formWithcatNameWithBirdAndAllObs1.setValue(Id, forKey: "UserId")
            sessionArr.add(formWithcatNameWithBirdAndAllObs1)
        }
        
        sessionWithAllforms.setValue(sessionArr, forKey: "Session")
        
        return sessionWithAllforms as? [String: Any]
    }
    
    
    func getPostingJSONForTurkey(postingId :NSNumber) -> [String: Any]? {
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let SessionPostingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        
        self.postingIdArr.removeAllObjects()
        let postingServerArray = NSMutableArray()
        let  postingDictOnServer = NSMutableDictionary()
        
        for i in 0..<SessionPostingArrWithAllData.count {
            let postingDataDict = NSMutableDictionary()
            let pSession = SessionPostingArrWithAllData.object(at: i) as! PostingSessionTurkey
            let sessionDate = pSession.sessiondate
            var sessionTypeId  = Int ()
            let sessiontype = pSession.sessionTypeName
            if sessiontype == "Farm Visit" {
                sessionTypeId = 2
            } else if sessiontype == "Posting Visit" {
                sessionTypeId = 1
            }
            else {
                sessionTypeId = 0
            }
            let customerId = pSession.customerId
            let complexId = pSession.complexId
            let customerRep = pSession.customerRepName
            let vetUserId = pSession.veterinarianId
            let salesUserId = pSession.salesRepId
            let cocciProgramId = pSession.cocciProgramId
            let breedName = pSession.birdBreedName
            let notes = pSession.notes
            let maleBreedName = pSession.mail
            let femaleBreedName = pSession.female
            let birdSize = pSession.birdSize
            let catptureNec = pSession.catptureNec
            let cociiProgramName = pSession.cociiProgramName
            let sessionId = pSession.postingId
            let finalize = pSession.finalizeExit
            
            let avgAGe = pSession.avgAge
            let avgWght = pSession.avgWeight
            let outTime = pSession.outTime
            let fcr = pSession.fcr
            let livability = pSession.livability
            let mortality = pSession.dayMortality
            
            self.postingIdArr.add(sessionId!)
            
            
            var  fullData =  pSession.timeStamp!
            let udid1 = UserDefaults.standard.value(forKey: "ApplicationIdentifier")! as! String
            postingDataDict.setValue(finalize, forKey: "finalized")
            postingDataDict.setValue(sessionDate, forKey: "sessionDate")
            postingDataDict.setValue(sessionTypeId, forKey: "sessionTypeId")
            postingDataDict.setValue(lngId, forKey: "LanguageId")
            postingDataDict.setValue(customerId, forKey: "customerId")
            postingDataDict.setValue(complexId, forKey: "complexId")
            postingDataDict.setValue(fullData, forKey: "deviceSessionId")
            postingDataDict.setValue(customerRep, forKey: "customerRep")
            postingDataDict.setValue(vetUserId, forKey: "vetUserId")
            postingDataDict.setValue(salesUserId, forKey: "salesUserId")
            postingDataDict.setValue(cocciProgramId, forKey: "cocciProgramId")
            postingDataDict.setValue(breedName, forKey: "breedName")
            postingDataDict.setValue(1, forKey: "birdTypeId")
            postingDataDict.setValue(notes, forKey: "notes")
            postingDataDict.setValue(maleBreedName, forKey: "maleBreedName")
            postingDataDict.setValue(femaleBreedName, forKey: "femaleBreedName")
            postingDataDict.setValue(birdSize, forKey: "birdSize")
            postingDataDict.setValue(catptureNec, forKey: "catptureNec")
            postingDataDict.setValue(cociiProgramName, forKey: "cociiProgramName")
            postingDataDict.setValue(sessionId, forKey: "sessionId")
            let id = UserDefaults.standard.integer(forKey: "Id")
            postingDataDict.setValue(id, forKey: "UserId")
            postingDataDict.setValue(udid1, forKey: "udid")
            postingDataDict.setValue(fcr, forKey: "FCR")
            postingDataDict.setValue(avgWght, forKey: "AvgWeight")
            postingDataDict.setValue(avgAGe, forKey: "AvgAge")
            postingDataDict.setValue(outTime, forKey: "AvgOutTime")
            postingDataDict.setValue(livability, forKey: "Livability")
            postingDataDict.setValue(mortality, forKey: "Avg7DayMortality")
            postingServerArray.add(postingDataDict)
        }
        
        postingDictOnServer.setValue(postingServerArray, forKey: "PostingSessions")
        
        return postingDictOnServer as? [String : Any]
    }
    func getVaccinationForTurkey(postingId:NSNumber) -> [String: Any]? {
        
        let vaccinationPostingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
        let necArrWithoutPosting = NSMutableArray()
        
        handlecNecArray(cNecArr, necArrWithoutPosting)
        self.postingIdArr.removeAllObjects()
        var sessionId = NSNumber()
        var timeStamp = String()
        let tempArrTime = NSMutableArray()
        let actualTemp  = NSMutableArray()
        var vaccinationName = String ()
        
        handlePostingArrWithAllData(vaccinationPostingArrWithAllData, &sessionId, &timeStamp, actualTemp, tempArrTime)
        
        let sessionArr = NSMutableArray()
        let sessionDictWithVac = NSMutableDictionary()
        
        handlePostingIdArr(&vaccinationName, vaccinationPostingArrWithAllData, sessionArr)
        sessionDictWithVac.setValue(sessionArr, forKey: "Vaccinations")
        return sessionDictWithVac as? [String: Any]
    }
    fileprivate func handlePostingIdArr(_ vaccinationName: inout String, _ postingArrWithAllData: NSMutableArray, _ sessionArr: NSMutableArray) {
        for i in 0..<self.postingIdArr.count {
            
            let pId = self.postingIdArr.object(at: i) as! NSNumber
            let addVacinationAll = CoreDataHandlerTurkey().fetchFieldAddvacinationDataTurkey(pId)
            
            let vaccinationDetail = NSMutableDictionary()
            handleAddVacinationAll(addVacinationAll, &vaccinationName, vaccinationDetail)
            
            let FieldVacinationAll = CoreDataHandlerTurkey().fetchAddvacinationDataTurkey(pId)
            handleFieldVacinationAllArr(FieldVacinationAll, vaccinationDetail)
            
            if FieldVacinationAll.count > 0 || addVacinationAll.count > 0 {
                let vaccinationArray = NSMutableArray()
                vaccinationArray .add(vaccinationDetail)
                let mainDict = NSMutableDictionary()
                mainDict .setObject(vaccinationArray, forKey: "vaccinationDetail" as NSCopying)
                let id = UserDefaults.standard.integer(forKey: "Id")
                mainDict.setValue(id, forKey: "UserId")
                mainDict.setValue(pId, forKey: "sessionId")
                mainDict.setValue(pId, forKey: "vaccinationId")
                mainDict.setValue(vaccinationName, forKey: "vaccinationName")
                
                let data = postingArrWithAllData.object(at: 0) as! PostingSessionTurkey
                let acttimeStamp = data.timeStamp
                
                var fullData = acttimeStamp!
                mainDict.setValue(fullData, forKey: "deviceSessionId")
                sessionArr.add(mainDict)
            }
        }
    }
    fileprivate func handleFieldVacinationAllArr(_ FieldVacinationAll: NSArray, _ vaccinationDetail: NSMutableDictionary) {
        for i in 0..<FieldVacinationAll.count {
            let pSession = FieldVacinationAll.object(at: i) as! HatcheryVacTurkey
            let routeName = pSession.route
            
            
            var routeId = NSNumber()
            if routeName == Constants.drinkingWater {
                routeId = 2
            }
            else if routeName == Constants.wingWeb {
                routeId = 1
            }
            else if routeName == Constants.spray {
                routeId = 3
            }
            else if routeName == Constants.inOvoStr {
                routeId = 4
            }
            else if routeName == "Subcutaneous" {
                routeId = 5
            }
            else if routeName == "Intramuscular" {
                routeId = 6
            }
            else  if  routeName == Constants.eveDrop{
                routeId = 7
            }
            else{
                routeId = 0
            }
            let age = pSession.age
            var  strain = pSession.strain!
            let fieldStrainKey = "fieldStrain\(i + 1)"
            let fieldrouteKey = "fieldRoute\(i+1)Id"
            let fieldAgeKey = "fieldAge\(i + 1)"
            
            vaccinationDetail .setObject(strain, forKey: fieldStrainKey as NSCopying)
            vaccinationDetail .setObject(routeId, forKey: fieldrouteKey as NSCopying)
            vaccinationDetail .setObject(age!, forKey: fieldAgeKey as NSCopying)
        }
    }
    fileprivate func handleAddVacinationAll(_ addVacinationAll: NSArray, _ vaccinationName: inout String, _ vaccinationDetail: NSMutableDictionary) {
        for i in 0..<addVacinationAll.count {
            let pSession = addVacinationAll.object(at: i) as! FieldVaccinationTurkey
            if i == 0{
                vaccinationName = pSession.vaciNationProgram!
            }
            
            let routeName = pSession.route
            var routeId = NSNumber()
            if routeName == Constants.drinkingWater {
                routeId = 2
            } else if routeName == Constants.wingWeb {
                routeId = 1
            } else if routeName == Constants.spray {
                routeId = 3
            } else if routeName == Constants.inOvoStr {
                routeId = 4
            } else if routeName == "Subcutaneous" {
                routeId = 5
            } else if routeName == "Intramuscular" {
                routeId = 6
            } else  if  routeName == Constants.eveDrop{
                routeId = 7
            }
            else{
                routeId = 0
            }
            
            var strain = pSession.strain!
            let strainKey = "hatcheryStrain\(i + 1)"
            let routeKey = "hatcheryRoute\(i+1)Id"
            
            vaccinationDetail .setObject(strain, forKey: strainKey as NSCopying)
            vaccinationDetail .setObject(routeId, forKey: routeKey as NSCopying)
        }
    }
    fileprivate func handlecNecArray(_ cNecArr: NSArray, _ necArrWithoutPosting: NSMutableArray) {
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
                
            }
            
        }
    }
    fileprivate func handlePostingArrWithAllData(_ postingArrWithAllData: NSMutableArray, _ sessionId: inout NSNumber, _ timeStamp: inout String, _ actualTemp: NSMutableArray, _ tempArrTime: NSMutableArray) {
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            sessionId = pSession.postingId!
            timeStamp = pSession.timeStamp!
            var actualtimeStr = pSession.actualTimeStamp
            if actualtimeStr == nil{
                actualtimeStr = ""
            }
            actualTemp.add(actualtimeStr!)
            tempArrTime.add(timeStamp)
            self.postingIdArr.add(sessionId)
        }
    }
    
    func getFeedProgramJSONForTurkey(forPostingId postingId: NSNumber) -> [String: Any]? {

        let savedPostingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
        let necArrWithoutPosting = NSMutableArray()
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData =  cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c =  necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        self.postingIdArr.removeAllObjects()
        let tempArrTime = NSMutableArray()
        let actualTmestamp = NSMutableArray()
        var sessionId = NSNumber()
        for i in 0..<savedPostingArrWithAllData.count
        {
            let pSession =  savedPostingArrWithAllData.object(at: i) as! PostingSessionTurkey
            sessionId = pSession.postingId!
            var timestamp = pSession.timeStamp!
            var actualTimestampStr =  pSession.actualTimeStamp
            if actualTimestampStr == nil {
                actualTimestampStr = ""
            }
            self.postingIdArr.add(sessionId)
            tempArrTime.add(timestamp)
            actualTmestamp.add(actualTimestampStr!)
        }
        
        let sessionArray = NSMutableArray()
        var sessionDictMain = NSMutableDictionary()
        
        for i in 0..<self.postingIdArr.count {
            
            let mainDict = NSMutableDictionary()
            var FinalArray1 = NSMutableArray()
            let allCocciControl =  CoreDataHandlerTurkey().fetchAllCocciControlviaPostingidTurkey(self.postingIdArr[i] as! NSNumber)
            var dataSet = Int()
            var  index = Int()
            let mainFeeds = NSMutableArray()
            var feeds = NSMutableDictionary()
            for i in 0..<allCocciControl.count {
                dataSet+=1
                
                let mainDict = NSMutableDictionary()
                let cocciControl =  allCocciControl.object(at: i) as! CoccidiosisControlFeedTurkey
                let coccidiosisVaccine = cocciControl.coccidiosisVaccine
                let dosage = cocciControl.dosage
                let fromDays = cocciControl.fromDays
                let molecule = cocciControl.molecule
                let toDays = cocciControl.toDays
                let moleculeId = cocciControl.dosemoleculeId
                let cocoId = cocciControl.coccidiosisVaccineId
                let feedType = cocciControl.feedType
                let startDate =  cocciControl.feedDate
                mainDict.setValue(startDate, forKey: "startDate")
                mainDict.setValue(coccidiosisVaccine, forKey: "coccidiosisVaccine")
                mainDict.setValue(dosage, forKey: "dose")
                mainDict.setValue(fromDays, forKey: "durationFrom")
                mainDict.setValue(molecule, forKey: "molecule")
                mainDict.setValue(toDays, forKey: "durationTo")
                mainDict.setValue(5, forKey: "feedProgramCategoryId")
                mainDict.setValue(moleculeId, forKey: "moleculeId")
                mainDict.setValue(cocoId, forKey: "cocciVaccineId")
                mainDict.setValue(feedType, forKey: "feedType")
                FinalArray1.add(mainDict)
                
                if dataSet == 7 {
                    dataSet = 0
                    
                    let feedId = cocciControl.feedId as! Int
                    let feedProgram = cocciControl.feedProgram
                    
                    feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : FinalArray1]
                    FinalArray1 = NSMutableArray()
                    mainFeeds.add(feeds)
                    feeds = NSMutableDictionary()
                }
            }
            
            let fetchAntibotic = CoreDataHandlerTurkey().fetchAntiboticViaPostingIdTurkey(self.postingIdArr[i] as! NSNumber)
            
            
            for i in 0..<fetchAntibotic.count {
                
                dataSet+=1
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchAntibotic.object(at: i) as! AntiboticFeedTurkey
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let feedProgram = antiboticFeed.feedProgram
                let fromDays = antiboticFeed.fromDays
                let molecule = antiboticFeed.molecule
                let toDays = antiboticFeed.toDays
                let feedType = antiboticFeed.feedType
                let startDate =  antiboticFeed.feedDate
                mainDict.setValue(dosage, forKey: "dose")
                mainDict.setValue(feedId, forKey: "feedId")
                mainDict.setValue(feedProgram, forKey: "feedName")
                mainDict.setValue(fromDays, forKey: "durationFrom")
                mainDict.setValue(molecule, forKey: "molecule")
                mainDict.setValue(toDays, forKey: "durationTo")
                mainDict.setValue(12, forKey: "feedProgramCategoryId")
                mainDict.setValue(0, forKey: "moleculeId")
                mainDict.setValue(feedType, forKey: "feedType")
                FinalArray1.add(mainDict)
                
                if dataSet == 6 {
                    dataSet = 0
                    
                    let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as! NSMutableArray
                    if (tempArray.count > 0) {
                        tempArray.addObjects(from: FinalArray1 as [AnyObject])
                        feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray]
                    }
                    mainFeeds.replaceObject(at: index, with: feeds)
                    index+=1
                    FinalArray1 = NSMutableArray()
                    feeds = NSMutableDictionary()
                }
            }
            
            let fetchAlternative = CoreDataHandlerTurkey().fetchAlternativeFeedPostingidTurkey(self.postingIdArr[i] as! NSNumber)
            
            index = 0
            for i in 0..<fetchAlternative.count {
                
                dataSet+=1
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchAlternative.object(at: i) as! AlternativeFeedTurkey
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let feedProgram = antiboticFeed.feedProgram
                let fromDays = antiboticFeed.fromDays
                let molecule = antiboticFeed.molecule
                let startDate = antiboticFeed.feedDate
                let toDays = antiboticFeed.toDays
                let feedType = antiboticFeed.feedType
                mainDict.setValue(dosage, forKey: "dose")
                mainDict.setValue(feedId, forKey: "feedId")
                mainDict.setValue(feedProgram, forKey: "feedName")
                mainDict.setValue(fromDays, forKey: "durationFrom")
                mainDict.setValue(molecule, forKey: "molecule")
                mainDict.setValue(toDays, forKey: "durationTo")
                mainDict.setValue(6, forKey: "feedProgramCategoryId")
                mainDict.setValue(0, forKey: "moleculeId")
                mainDict.setValue(feedType, forKey: "feedType")
                
                FinalArray1.add(mainDict)
                
                if dataSet == 6 {
                    dataSet = 0
                    
                    if mainFeeds.count>0 {
                        
                        let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as! NSMutableArray
                        if tempArray.count > 0 {
                            tempArray.addObjects(from: FinalArray1 as [AnyObject])
                            feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray]
                        }
                        mainFeeds.replaceObject(at: index, with: feeds)
                        index+=1
                        FinalArray1 = NSMutableArray()
                        feeds = NSMutableDictionary()
                    }
                }
            }
            
            let fetchMyBinde = CoreDataHandlerTurkey().fetchMyBindersViaPostingIdTurkey(self.postingIdArr[i] as! NSNumber)
            
            index = 0
            for i in 0..<fetchMyBinde.count {
                
                dataSet+=1
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchMyBinde.object(at: i) as! MyCotoxinBindersFeedTurkey
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let feedProgram = antiboticFeed.feedProgram
                let fromDays = antiboticFeed.fromDays
                let molecule = antiboticFeed.molecule
                let toDays = antiboticFeed.toDays
                let feedType = antiboticFeed.feedType
                let startDate = antiboticFeed.feedDate
                mainDict.setValue(dosage, forKey: "dose")
                mainDict.setValue(feedId, forKey: "feedId")
                mainDict.setValue(feedProgram, forKey: "feedName")
                mainDict.setValue(fromDays, forKey: "durationFrom")
                mainDict.setValue(molecule, forKey: "molecule")
                mainDict.setValue(toDays, forKey: "durationTo")
                mainDict.setValue(18, forKey: "feedProgramCategoryId")
                mainDict.setValue(0, forKey: "moleculeId")
                mainDict.setValue(feedType, forKey: "feedType")
                
                FinalArray1.add(mainDict)
                
                if dataSet == 6 {
                    dataSet = 0
                    if mainFeeds.count>0 {
                        let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as! NSMutableArray
                        if tempArray.count > 0 {
                            tempArray.addObjects(from: FinalArray1 as [AnyObject])
                            feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray]
                        }
                        mainFeeds.replaceObject(at: index, with: feeds)
                        index+=1
                        FinalArray1 = NSMutableArray()
                        feeds = NSMutableDictionary()
                    }
                }
            }
            var sessionDict = NSMutableDictionary()
            
            if ( allCocciControl.count > 0 || fetchAntibotic.count > 0 || fetchAlternative.count > 0 || fetchMyBinde.count > 0){
                
                mainDict.setValue(sessionId, forKey: "sessionId")
                let data = savedPostingArrWithAllData.object(at: 0) as! PostingSessionTurkey
                let acttimeStamp = data.timeStamp
                
                let  fullData = acttimeStamp!
                mainDict.setValue(fullData, forKey: "deviceSessionId")
                
                let id = UserDefaults.standard.integer(forKey: "Id")
                mainDict.setValue(id, forKey: "UserId")
                mainDict.setValue(false, forKey: "finalized")
                sessionDict = ["deviceSessionId" : fullData,"sessionId" : postingIdArr[i] as! NSNumber, "userId" : id,"feeds" : mainFeeds]
                sessionArray.add(sessionDict)
                sessionDict = NSMutableDictionary()
                sessionDictMain = ["Sessions" : sessionArray]
            }
        }
       
        return ["Sessions" : sessionArray]
    }
    func getCompleteSyncJSONForTurkey(forPostingId postingId: NSNumber) -> [String: Any] {
        var fullJSON = [String: Any]()
        // Feed Program JSON
        if let feedProgramJSON = getFeedProgramJSONForTurkey(forPostingId: postingId) {
            fullJSON["FeedProgram"] = feedProgramJSON["Sessions"] ?? []
        }
        // Vaccination JSON
        if let vaccinationJSON = getVaccinationForTurkey(postingId: postingId) {
            fullJSON["Vaccinations"] = vaccinationJSON["Vaccinations"] ?? []
        }
        // Session Detail JSON
        if let sessionDetailJSON = getPostingJSONForTurkey(postingId: postingId) {
            fullJSON["PostingSessions"] = sessionDetailJSON["PostingSessions"] ?? []
        }
        
        // Necropsy JSON
        if let necropsyJSON = getNecropsyJSONForTurkey(postingId: postingId) {
            fullJSON["CaptureNecropsyData"] = necropsyJSON["Session"] ?? []
        }
        
        return fullJSON

    }
    // Combine all JSONs for a postingId
    func getFullSyncJSON(forPostingId postingId: NSNumber) -> [String: Any] {
        var fullJSON = [String: Any]()

        // Feed Program JSON
        if let feedProgramJSON = getFeedProgramJSON(forPostingId: postingId) {
            fullJSON["FeedProgram"] = feedProgramJSON["Sessions"] ?? []
        }

        // Vaccination JSON
        if let vaccinationJSON = getVaccinationJSON(forPostingId: postingId) {
            fullJSON["Vaccinations"] = vaccinationJSON["Vaccinations"] ?? []
        }

        // Session Detail JSON
        if let sessionDetailJSON = getSessionDetailJSON(forPostingId: postingId) {
            fullJSON["PostingSessions"] = sessionDetailJSON["PostingSessions"] ?? []
        }

        // Necropsy JSON
        if let necropsyJSON = getNecropsyJSON(forPostingId: postingId) {
            fullJSON["CaptureNecropsyData"] = necropsyJSON["Session"] ?? []
        }

        return fullJSON
    }
    
    func getFeedProgramJSON(forPostingId postingId: NSNumber) -> [String: Any]? {
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        // Remove duplicates
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j) as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w) as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        var postingIdArr = NSMutableArray()
        let tempArrTime = NSMutableArray()
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            postingIdArr.add(pSession.postingId!)
            tempArrTime.add(pSession.timeStamp ?? "")
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            postingIdArr.add(nIdSession.necropsyId!)
        }
        
        let sessionArray = NSMutableArray()
        
        for i in 0..<postingIdArr.count {
            let sessionId = postingIdArr[i] as! NSNumber
            let mainFeeds = NSMutableArray()
            var dataSet = 0
            var index = 0
            var FinalArray1 = NSMutableArray()
            
            // --- Build Feed Program details ---
            let allCocciControl = CoreDataHandler().fetchAllCocciControlviaIsync(true, postinID: sessionId)
            for item in allCocciControl {
                let cocciControl = item as! CoccidiosisControlFeed
                dataSet += 1
                
                let mainDict = NSMutableDictionary()
                mainDict.setValue(cocciControl.coccidiosisVaccine, forKey: "coccidiosisVaccine")
                mainDict.setValue(cocciControl.dosage, forKey: "dose")
                mainDict.setValue(cocciControl.fromDays, forKey: "durationFrom")
                mainDict.setValue(cocciControl.molecule, forKey: "molecule")
                mainDict.setValue(cocciControl.toDays, forKey: "durationTo")
                mainDict.setValue(5, forKey: "feedProgramCategoryId")
                mainDict.setValue(cocciControl.dosemoleculeId, forKey: "moleculeId")
                mainDict.setValue(cocciControl.coccidiosisVaccineId, forKey: "cocciVaccineId")
                mainDict.setValue(cocciControl.feedType, forKey: "feedType")
                mainDict.setValue(cocciControl.feedDate, forKey: "startDate")
                
                FinalArray1.add(mainDict)
                
                if dataSet == 7 {
                    dataSet = 0
                    let feeds: [String: Any] = [
                        "feedName": cocciControl.feedProgram ?? "",
                        "feedId": cocciControl.feedId ?? 0,
                        "startDate": cocciControl.feedDate ?? "",
                        "feedProgramDetails": FinalArray1
                    ]
                    mainFeeds.add(feeds)
                    FinalArray1 = NSMutableArray()
                }
            }
            
            // --- Repeat similar logic for Antibiotic, Alternative, MyBinder feeds ---
            // You can copy/paste and wrap them here like above, but instead of posting, just build mainFeeds
            
            // Add session info if feeds exist
            if mainFeeds.count > 0 {
                let acttimeStamp = tempArrTime.object(at: i) as! String
                let userId = UserDefaults.standard.integer(forKey: "Id")
                let sessionDict: [String: Any] = [
                    "deviceSessionId": acttimeStamp,
                    "sessionId": sessionId,
                    "userId": userId,
                    "feeds": mainFeeds
                ]
                sessionArray.add(sessionDict)
            }
        }
        
        if sessionArray.count > 0 {
            return ["Sessions": sessionArray]
        }
        
        return nil
    }

    func getVaccinationJSON(forPostingId postingId: NSNumber) -> [String: Any]? {

        let vaccinationPostingArrAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
            }
        }

        self.postingIdArr.removeAllObjects()
        var sessionId = NSNumber()
        let tempArrTime = NSMutableArray()
        let actualTemp  = NSMutableArray()
        var vaccinationName = String ()

        for i in 0..<vaccinationPostingArrAllData.count {
            let pSession = vaccinationPostingArrAllData.object(at: i) as! PostingSession
            sessionId = pSession.postingId!
            var timeStamp = pSession.timeStamp!
            var actualtimeStr = pSession.actualTimeStamp
            if actualtimeStr == nil {
                actualtimeStr = ""
            }
            actualTemp.add(actualtimeStr!)
            tempArrTime.add(timeStamp)
            self.postingIdArr.add(sessionId)
        }

        let sessionArr = NSMutableArray()
        let sessionDictWithVac = NSMutableDictionary()

        for i in 0..<self.postingIdArr.count {

            let pId = self.postingIdArr.object(at: i) as! NSNumber
            let addVacinationAll = CoreDataHandler().fetchFieldAddvacinationData(pId)
            let vaccinationDetail = NSMutableDictionary()

            for i in 0..<addVacinationAll.count {
                let pSession = addVacinationAll.object(at: i) as! FieldVaccination
                if i == 0 {
                    vaccinationName = pSession.vaciNationProgram!
                }

                let routeName = pSession.route
                var routeId = NSNumber()
                let newLngId = UserDefaults.standard.integer(forKey: "lngId")

                if newLngId == 1 || newLngId == 3 {
                    if routeName == Constants.wingWeb { routeId = 1 }
                    else if routeName == Constants.drinkingWater { routeId = 2 }
                    else if routeName == Constants.spray { routeId = 3 }
                    else if routeName == Constants.inOvoStr { routeId = 4 }
                    else if routeName == "Subcutaneous" { routeId = 5 }
                    else if routeName == "Intramuscular" { routeId = 6 }
                    else if routeName == Constants.eveDrop { routeId = 7 }
                    else { routeId = 0 }
                }
                else if newLngId == 4 {
                    if routeName == Constants.spray { routeId = 21 }
                    else if routeName == Constants.inOvoStr { routeId = 22 }
                    else if routeName == "Intramuscular" { routeId = 24 }
                    else if routeName == Constants.aguaDeBebida { routeId = 20 }
                    else if routeName == "Membrana Da Asa" { routeId = 19 }
                    else if routeName == "Ocular" { routeId = 25 }
                    else if routeName == Constants.Subcutânea { routeId = 23 }
                    else { routeId = 0 }
                }

                let strainKey = "hatcheryStrain\(i + 1)"
                let routeKey = "hatcheryRoute\(i+1)Id"

                vaccinationDetail.setObject(pSession.strain, forKey: strainKey as NSCopying)
                vaccinationDetail.setObject(routeId, forKey: routeKey as NSCopying)
            }

            let FieldVacinationAll = CoreDataHandler().fetchAddvacinationData(pId)
            for i in 0..<FieldVacinationAll.count {
                let pSession = FieldVacinationAll.object(at: i) as! HatcheryVac
                let routeName = pSession.route

                var routeId = NSNumber()
                let newLngId = UserDefaults.standard.integer(forKey: "lngId")

                if newLngId == 1 || newLngId == 3 {
                    if routeName == Constants.wingWeb { routeId = 1 }
                    else if routeName == Constants.drinkingWater { routeId = 2 }
                    else if routeName == Constants.spray { routeId = 3 }
                    else if routeName == Constants.inOvoStr { routeId = 4 }
                    else if routeName == "Subcutaneous" { routeId = 5 }
                    else if routeName == "Intramuscular" { routeId = 6 }
                    else if routeName == Constants.eveDrop { routeId = 7 }
                    else { routeId = 0 }
                }
                else if newLngId == 4 {
                    if routeName == Constants.spray { routeId = 21 }
                    else if routeName == Constants.inOvoStr { routeId = 22 }
                    else if routeName == "Intramuscular" { routeId = 24 }
                    else if routeName == Constants.aguaDeBebida { routeId = 20 }
                    else if routeName == "Membrana Da Asa" { routeId = 19 }
                    else if routeName == "Ocular" { routeId = 25 }
                    else if routeName == Constants.Subcutânea { routeId = 23 }
                    else { routeId = 0 }
                }

                let fieldStrainKey = "fieldStrain\(i + 1)"
                let fieldrouteKey = "fieldRoute\(i+1)Id"
                let fieldAgeKey = "fieldAge\(i + 1)"

                vaccinationDetail.setObject(pSession.strain!, forKey: fieldStrainKey as NSCopying)
                vaccinationDetail.setObject(routeId, forKey: fieldrouteKey as NSCopying)
                vaccinationDetail.setObject(pSession.age!, forKey: fieldAgeKey as NSCopying)
            }

            if FieldVacinationAll.count > 0 || addVacinationAll.count > 0 {
                let vaccinationArray = NSMutableArray()
                vaccinationArray.add(vaccinationDetail)
                let mainDict = NSMutableDictionary()
                mainDict.setObject(vaccinationArray, forKey: "vaccinationDetail" as NSCopying)
                let id = UserDefaults.standard.integer(forKey: "Id")
                mainDict.setValue(id, forKey: "UserId")
                mainDict.setValue(pId, forKey: "sessionId")
                mainDict.setValue(pId, forKey: "vaccinationId")
                mainDict.setValue(vaccinationName, forKey: "vaccinationName")

                let data = vaccinationPostingArrAllData.object(at: 0) as! PostingSession
                let acttimeStamp = data.timeStamp
                
                var fullData = acttimeStamp!
                mainDict.setValue(fullData, forKey: "deviceSessionId")
                sessionArr.add(mainDict)
            }
        }

        sessionDictWithVac.setValue(sessionArr, forKey: "Vaccinations")

        // 🔥 YOUR ORIGINAL CODE ENDS HERE 🔥

        return sessionDictWithVac as? [String: Any]
    }



    // MARK: - Individual JSON functions
    func getSessionDetailJSON(forPostingId postingId: NSNumber) -> [String: Any]? {
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let savePostingArrWithAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        var postingIdArr = NSMutableArray()
        let postingServerArray = NSMutableArray()

        for i in 0..<savePostingArrWithAllData.count {
            let postingDataDict = NSMutableDictionary()
            let pSession = savePostingArrWithAllData.object(at: i) as! PostingSession
            let sessionDate = pSession.sessiondate
            var sessionTypeId = 0
            let sessionType = pSession.sessionTypeName
            if sessionType == "Farm Visit"  {
                sessionTypeId = 2
            } else if  sessionType == "Visite De Ferme" {
                sessionTypeId = 3
            } else if  sessionType == "Visite De Publication" {
                sessionTypeId = 4
            } else if  (sessionType == "Visita Em Andamento") || (sessionType == "Visita em andamento") {
                sessionTypeId = 5
            } else if  (sessionType == "Visita Na Unidade") || (sessionType ==  "Visita na unidade") {
                sessionTypeId = 6
            } else if sessionType == "Posting Visit"  {
                sessionTypeId = 1
            } else {
                sessionTypeId = 0
            }

            let customerId = pSession.customerId ?? UserDefaults.standard.value(forKey: "SelectedCustmer") as? NSNumber
            let complexId = pSession.complexId
            let customerRep = pSession.customerRepName
            let vetUserId = pSession.veterinarianId
            let salesUserId = pSession.salesRepId
            let cocciProgramId = pSession.cocciProgramId
            let breedName = pSession.birdBreedName
            let notes = pSession.notes
            let maleBreedName = pSession.mail
            let femaleBreedName = pSession.female
            let birdSize = pSession.birdSize
            let catptureNec = pSession.catptureNec
            let cociiProgramName = pSession.cociiProgramName
            let sessionId = pSession.postingId
            let finalize = pSession.finalizeExit
            let proName = pSession.productionTypeName
            let proId = pSession.productionTypeId
            let avgAge = pSession.avgAge ?? ""
            let avgWeight = pSession.avgWeight ?? ""
            let outTime = pSession.outTime ?? ""
            let fcr = pSession.fcr ?? ""
            let livability = pSession.livability ?? ""
            let mortality = pSession.dayMortality ?? ""

            postingIdArr.add(sessionId ?? 0)
            let fullData = pSession.timeStamp ?? ""
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String ?? ""

            postingDataDict.setValue(finalize, forKey: "finalized")
            postingDataDict.setValue(sessionDate, forKey: "sessionDate")
            postingDataDict.setValue(sessionTypeId, forKey: "sessionTypeId")
            postingDataDict.setValue(lngId, forKey: "LanguageId")
            postingDataDict.setValue(customerId, forKey: "customerId")
            postingDataDict.setValue(complexId, forKey: "complexId")
            postingDataDict.setValue(fullData, forKey: "deviceSessionId")
            postingDataDict.setValue(customerRep, forKey: "customerRep")
            postingDataDict.setValue(vetUserId, forKey: "vetUserId")
            postingDataDict.setValue(salesUserId, forKey: "salesUserId")
            postingDataDict.setValue(cocciProgramId, forKey: "cocciProgramId")
            postingDataDict.setValue(breedName, forKey: "breedName")
            postingDataDict.setValue(1, forKey: "birdTypeId")
            postingDataDict.setValue(notes, forKey: "notes")
            postingDataDict.setValue(maleBreedName, forKey: "maleBreedName")
            postingDataDict.setValue(femaleBreedName, forKey: "femaleBreedName")
            postingDataDict.setValue(birdSize, forKey: "birdSize")
            postingDataDict.setValue(catptureNec, forKey: "catptureNec")
            postingDataDict.setValue(cociiProgramName, forKey: "cociiProgramName")
            postingDataDict.setValue(sessionId, forKey: "sessionId")
            postingDataDict.setValue(proId, forKey: "productionTypeId")
            postingDataDict.setValue(proName, forKey: "productionTypeName")
            postingDataDict.setValue(fcr, forKey: "FCR")
            postingDataDict.setValue(avgWeight, forKey: "AvgWeight")
            postingDataDict.setValue(avgAge, forKey: "AvgAge")
            postingDataDict.setValue(outTime, forKey: "AvgOutTime")
            postingDataDict.setValue(livability, forKey: "Livability")
            postingDataDict.setValue(mortality, forKey: "Avg7DayMortality")
            postingDataDict.setValue(UserDefaults.standard.integer(forKey: "Id"), forKey: "UserId")
            postingDataDict.setValue(udid, forKey: "udid")

            postingServerArray.add(postingDataDict)
        }

        if postingServerArray.count > 0 {
            let postingDictOnServer = NSMutableDictionary()
            postingDictOnServer.setValue(postingServerArray, forKey: "PostingSessions")
            return postingDictOnServer as? [String: Any]
        }
        return nil
    }

    
    
    func getNecropsyJSON(forPostingId postingId: NSNumber) -> [String: Any]? {
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cNecArr = CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let uniqueNecArr = NSMutableArray()

        // Remove duplicates
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j) as! CaptureNecropsyData
            uniqueNecArr.add(captureNecropsyData)
            for w in 0..<uniqueNecArr.count - 1 {
                let c = uniqueNecArr.object(at: w) as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId {
                    uniqueNecArr.remove(c)
                }
            }
        }

        let sessionArr = NSMutableArray()
        for i in 0..<uniqueNecArr.count {
            let captureNecropsyData = uniqueNecArr.object(at: i) as! CaptureNecropsyData
            let allArray = NSMutableArray()
            let cNec = CoreDataHandler().FetchNecropsystep1NecId(postingId)

            for x in 0..<cNec.count {
                let cNData = cNec.object(at: x) as! CaptureNecropsyData
                let birdArry = NSMutableArray()
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
                let age = cNData.age
                let imgId = cNData.imageId
                let complexId = cNData.complexId as? Int ?? 0
                let flock = cNData.flockId
                let sick = cNData.sick
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexDate = cNData.complexDate
                let farmId = cNData.farmId

                for j in 0..<noOfBird! {
                    let obsNameWithValue = CoreDataHandler().fetchObsWithBirdandFarmName(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                    let notesWithFarm = CoreDataHandler().fetchNotesWithBirdNumandFarmName((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                    if notesWithFarm.count > 0 {
                        let n = notesWithFarm.object(at: 0) as! NotesBird
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue(n.notes, forKey: "birdNotes")
                    } else {
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue("", forKey: "birdNotes")
                    }
                    birdArry.add(obsNameWithValue)
                }

                let farmDict = NSMutableDictionary()
                farmDict.setValue(birdArry, forKey: "BirdDetails")
                farmDict.setValue(farmName, forKey: "farmName")
                farmDict.setValue(houseNo, forKey: "houseNo")
                farmDict.setValue(noOfBird, forKey: "birds")
                farmDict.setValue(farmId, forKey: "SortId")
                farmDict.setValue(imgId, forKey: "ImgId")
                farmDict.setValue(feedProgram, forKey: "feedProgram")
                farmDict.setValue(age, forKey: "age")
                farmDict.setValue(customerId, forKey: "customerId")
                farmDict.setValue(customerName, forKey: "customerName")
                farmDict.setValue(sick, forKey: "sick")
                farmDict.setValue(flock, forKey: "flockId")
                farmDict.setValue(complexDate, forKey: "ComplexDate")

                allArray.add(farmDict)
            }

            let sessionDict = NSMutableDictionary()
            sessionDict.setValue(captureNecropsyData.necropsyId!, forKey: "SessionId")
            sessionDict.setValue(lngId, forKey: "LanguageId")
            sessionDict.setValue(captureNecropsyData.timeStamp!, forKey: "deviceSessionId")
            if captureNecropsyData.complexId != nil {
                sessionDict.setValue(captureNecropsyData.complexId!, forKey: "ComplexId")
            }
            sessionDict.setValue(captureNecropsyData.complexDate!, forKey: "sessionDate")
            sessionDict.setValue(allArray, forKey: "farmDetails")
            sessionDict.setValue(UserDefaults.standard.integer(forKey: "Id"), forKey: "UserId")
            sessionArr.add(sessionDict)
        }

        if sessionArr.count > 0 {
            let sessionWithAllForms = NSMutableDictionary()
            sessionWithAllForms.setValue(sessionArr, forKey: "Session")
            return sessionWithAllForms as? [String: Any]
        }
        return nil
    }

}

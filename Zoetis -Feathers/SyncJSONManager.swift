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
            fullJSON["NecropsySessions"] = necropsyJSON["Session"] ?? []
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

//
//  SingleSyncDataTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 23/05/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Reachability
import SystemConfiguration
import CoreData


// MARK: - PROTOCOLS
protocol SyncApiDataTurkey{
    func failWithErrorSyncdata(statusCode:Int)
    func failWithErrorInternalSyncdata()
    func failWithInternetSyncdata()
    func startLoader()
    func didFinishApiSyncdata()
    func failWithInternetConnectionSyncdata()
    func didFailDuringPostApi(message: String)   // 🔥 new function
}

class SingleSyncDataTurkey: NSObject {
    
    // MARK: - VARIABLES
    var reachability: Reachability!
    var delegeteSyncApiData : SyncApiDataTurkey!
    var postingIdArr = NSMutableArray()
    var postingArrWithAllData = NSMutableArray()
    var strdateTimeStamp = String()
    var accestoken = String()
    var networkStatus : Reachability.Connection!
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    
    // MARK: - METHODS AND FUNCTIONS
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ApiSyncTurkey.networkStatusChanged(_:)),
                                               name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification),
                                               object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(ReachabilityStatusChangedNotification)
    }
    
    func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let value = userInfo.values.first as? String {
            switch value {
            case "Online (WiFi)", "Online (WWAN)":
                print(value)
            default:
                break
            }
        }
    }
    
    
    // MARK: - Get All Session's Array
    func allSessionArr(postinId:NSNumber) ->NSMutableArray{
        
        let postingSessionArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postinId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postinId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        for i in 0..<postingSessionArrWithAllData.count {
            let pSession = postingSessionArrWithAllData.object(at: i) as! PostingSessionTurkey
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        return allPostingSessionArr
    }
    
    // MARK: - Resize the Image
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - Convert image to Base 64
    func imageToNSString(_ image: UIImage) -> String {
        let data = image.pngData()
        return data!.base64EncodedString(options: .lineLength64Characters)
    }
    
    // MARK: 📡  POST API Call - Feed Program
    func feedprogram(postingId:NSNumber)  {
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
            
            if ( allCocciControl.count > 0 || fetchAntibotic.count > 0 || fetchAlternative.count > 0 || fetchMyBinde.count > 0){
                
                mainDict.setValue(sessionId, forKey: "sessionId")
                let data = savedPostingArrWithAllData.object(at: 0) as! PostingSessionTurkey
                let acttimeStamp = data.timeStamp
                
                var  fullData = acttimeStamp!
                mainDict.setValue(fullData, forKey: "deviceSessionId")
                
                let id = UserDefaults.standard.integer(forKey: "Id")
                mainDict.setValue(id, forKey: "UserId")
                mainDict.setValue(false, forKey: "finalized")
                var sessionDict = NSMutableDictionary()
                sessionDict = ["deviceSessionId" : fullData,"sessionId" : postingIdArr[i] as! NSNumber, "userId" : id,"feeds" : mainFeeds]
                sessionArray.add(sessionDict)
                sessionDict = NSMutableDictionary()
                sessionDictMain = ["Sessions" : sessionArray]
            }
        }
        do {
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: -1009) // no internet
                return
            }
            
            let Url = "PostingSession/SaveMultipleFeedsSyncData"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = [Constants.authorization: accestoken]
            
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: sessionDictMain, options: [])
            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 401  {
                        self.loginMethod(postingId: postingId)
                        return
                    }
                    else if  statusCode == 502
                    {
                        self.delegeteSyncApiData.failWithInternetSyncdata()
                        self.showRetryAlert(apiName: "FeedProgram", postingId: postingId, message: Constants.internetErrorMessage)
                    }
                    else if [400,403,404,408,500,501,503,504].contains(statusCode) {
                        self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode)
                        return
                    }
                }
                switch response.result {
                case .success(_):
                    self.addVaccination(postingId: postingId)
                    
                case .failure(let encodingError):
                    let userMessage = NetworkErrorHandler.getUserFriendlyMessage(from: encodingError)
                    self.delegeteSyncApiData.didFailDuringPostApi(message: userMessage)
                }
            }
        }
        
    }
    
    // MARK: - ⚠️ Alert Helpers 🔔
    
    func showRetryAlert(apiName: String, postingId: NSNumber, message: String) {
        // 1️⃣ Create the alert controller without default title/message
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // 2️⃣ Styled title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.systemRed
        ]
        let attributedTitle = NSAttributedString(string: "⚠️ Error", attributes: titleAttributes)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        // 3️⃣ Styled message
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // 4️⃣ Retry action with blue text
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.retryApiCall(apiName: apiName, postingId: postingId)
        }
        retryAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        // 5️⃣ Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        // 6️⃣ Present alert on top view controller
        if let topVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topVC.present(alert, animated: true)
        }
    }
    
    
    /*
     func showRetryAlert(apiName: String, postingId: NSNumber, message: String) {
     let alert = UIAlertController(title: "Error",
     message: message,
     preferredStyle: .alert)
     
     let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
     // Call your retry function
     self.retryApiCall(apiName: apiName, postingId: postingId)
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
     
     alert.addAction(retryAction)
     alert.addAction(cancelAction)
     
     // Present the alert
     if let topVC = UIApplication.shared.keyWindow?.rootViewController {
     topVC.present(alert, animated: true)
     }
     }
     */
    
    func deduplicatedNecropsies(from array: NSArray) -> [CaptureNecropsyDataTurkey] {
        var seen = Set<String>()
        var result: [CaptureNecropsyDataTurkey] = []
        
        for case let item as CaptureNecropsyDataTurkey in array {
            let idStr = String(describing: item.necropsyId)
            guard !seen.contains(idStr) else { continue }
            seen.insert(idStr)
            result.append(item)
        }
        
        return result
    }
    
    
    func fetchFeeds(from array: NSArray, categoryId: Int) -> [[String: Any]] {
        var feedDicts: [[String: Any]] = []
        
        for case let item as NSObject in array {
            var feed: [String: Any] = [:]
            
            // Safely read values using KVC
            let dosage = item.value(forKey: "dosage") as? String ?? ""
            let feedId = item.value(forKey: "feedId") as? Int ?? 0
            let feedProgram = item.value(forKey: "feedProgram") as? String ?? ""
            let fromDays = item.value(forKey: "fromDays") as? Int ?? 0
            let toDays = item.value(forKey: "toDays") as? Int ?? 0
            let molecule = item.value(forKey: "molecule") as? String ?? ""
            let feedType = item.value(forKey: "feedType") as? String ?? ""
            let startDate = item.value(forKey: "feedDate") as? String ?? ""
            
            feed["dose"] = dosage
            feed["feedId"] = feedId
            feed["feedName"] = feedProgram
            feed["durationFrom"] = fromDays
            feed["durationTo"] = toDays
            feed["molecule"] = molecule
            feed["feedType"] = feedType
            feed["startDate"] = startDate
            feed["feedProgramCategoryId"] = categoryId
            feed["moleculeId"] = 0 // Default or placeholder unless moleculeId exists
            
            feedDicts.append(feed)
        }
        
        return feedDicts
    }
    
    func buildFeedDict(from item: NSObject, categoryId: Int) -> [String: Any]? {
        guard let dose = item.value(forKey: "dosage"),
              let feedId = item.value(forKey: "feedId"),
              let feedName = item.value(forKey: "feedProgram"),
              let fromDays = item.value(forKey: "fromDays"),
              let toDays = item.value(forKey: "toDays"),
              let molecule = item.value(forKey: "molecule"),
              let feedType = item.value(forKey: "feedType")
        else { return nil }
        
        var dict: [String: Any] = [
            "dose": dose,
            "feedId": feedId,
            "feedName": feedName,
            "durationFrom": fromDays,
            "durationTo": toDays,
            "molecule": molecule,
            "feedType": feedType,
            "feedProgramCategoryId": categoryId,
            "moleculeId": 0
        ]
        
        if categoryId == 5 {
            dict["moleculeId"] = item.value(forKey: "dosemoleculeId") ?? 0
            dict["cocciVaccineId"] = item.value(forKey: "coccidiosisVaccineId") ?? 0
            dict["coccidiosisVaccine"] = item.value(forKey: "coccidiosisVaccine") ?? ""
            dict["startDate"] = item.value(forKey: "feedDate") ?? ""
        }
        
        return dict
    }
    
    func mergeFeeds(_ base: inout [[String: Any]], with additions: [[String: Any]]) {
        for (i, item) in additions.enumerated() {
            guard i < base.count else { continue }
            var baseDetails = base[i]["feedProgramDetails"] as? [[String: Any]] ?? []
            let addDetails = item["feedProgramDetails"] as? [[String: Any]] ?? []
            baseDetails.append(contentsOf: addDetails)
            base[i]["feedProgramDetails"] = baseDetails
        }
    }
    
    
    // MARK: - ******************* Save Add Vacination data On Server ***************************/
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
    
    fileprivate func handleSaveMultipleVaccAPIResponse(postingId:NSNumber,_ statusCode: Int?, _ response: AFDataResponse<Any>) {
        if statusCode == 401  {
            self.loginMethod(postingId: postingId)
        }
        else if  statusCode == 502
        {
            self.delegeteSyncApiData.failWithInternetSyncdata()
            self.showRetryAlert(apiName: "addVaccination", postingId: postingId, message: Constants.internetErrorMessage)
        }
        else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501  || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
            self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
        }
        switch response.result {
            
        case .success(let responseObject):
            self.savePostingDataOnServer(postingId: postingId)
            
        case .failure(let encodingError):
            let userMessage = NetworkErrorHandler.getUserFriendlyMessage(from: encodingError)
            self.delegeteSyncApiData.didFailDuringPostApi(message: userMessage)
        }
    }
    
    /**************************************************************************/
    // MARK: 📡  POST API Call - Add Vaccination ..
    func addVaccination(postingId:NSNumber)  {
        
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
        
        do {
            
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: -1009) // no internet
                return
            }
            
            let Url = "/PostingSession/SaveMultipleVaccinationsSyncData"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: sessionDictWithVac, options: [])
            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                self.handleSaveMultipleVaccAPIResponse(postingId: postingId, statusCode, response)
            }
            
        }
    }
    // MARK: - ********************* Save Posting data On Server ***************************/
    
    fileprivate func failuerOfPostedSessionAPI(_ encodingError: AFError, _ response: AFDataResponse<Any>, _ statusCode: Int?) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
        }else if response.data != nil {
            if let s = statusCode {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
            }
            else {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
        }
    }
    
    
    func retryApiCall(apiName: String,postingId: NSNumber,retryCount: Int = 1,delay: TimeInterval = 0.5) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            print("🔄 Retrying \(apiName)... remaining: \(retryCount)")
            
            DispatchQueue.main.async {
                // 👉 Show loader again before retrying
                self.delegeteSyncApiData.startLoader()
                
                switch apiName {
                case"FeedProgram":
                    self.feedprogram(postingId: postingId)
                case "addVaccination":
                    self.addVaccination(postingId: postingId)
                case "savePostingDataOnServer":
                    self.savePostingDataOnServer(postingId: postingId)
                case "saveNecropsyDataOnServer":
                    self.saveNecropsyDataOnServer(postingId: postingId)
                case"saveObservationImageOnServer":
                    self.saveObservationImageOnServer(postingId: postingId)
                default:
                    print("⚠️ Unknown API name: \(apiName)")
                }
            }
        }
    }
    
    // MARK: 📡  POST API Call - Session's Details
    func savePostingDataOnServer(postingId :NSNumber){
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
        
        do {
            
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: -1009) // no internet
                return
            }
            let Url = "PostingSession/TurkeySaveMultiplePostingsSyncData"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: postingDictOnServer, options: [])
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                if statusCode == 401  {
                    self.loginMethod(postingId: postingId)
                }
                else if  statusCode == 502
                {
                    self.delegeteSyncApiData.failWithInternetSyncdata()
                    self.showRetryAlert(apiName: "savePostingDataOnServer", postingId: postingId, message: Constants.internetErrorMessage)
                }
                else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501  || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                }
                switch response.result {
                    
                case .success(let responseObject):
                    self.saveNecropsyDataOnServer(postingId: postingId)
                    
                case .failure(let encodingError):
                    let userMessage = NetworkErrorHandler.getUserFriendlyMessage(from: encodingError)
                    self.delegeteSyncApiData.didFailDuringPostApi(message: userMessage)
                }
            }
            
        }
    }
    // MARK: - ********************* Save Farms  data On Server **************/
    fileprivate func ApiFailuerHandleForPostedData(_ encodingError: AFError, _ response: AFDataResponse<Any>, _ statusCode: Int?) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
        } else if let statusResult = response.data{
            debugPrint(statusResult)
            if let s = statusCode {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
                
            } else  {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
        }
    }
    
    fileprivate func handleBirdArray(_ noOfBird: Int?, _ farmName: String?, _ cNData: CaptureNecropsyDataTurkey, _ birdArry: NSMutableArray) {
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
    }
    
    fileprivate func handlecNecArrayAndAllArr(_ cNec: NSArray, _ complexId: inout Int, _ allArray: NSMutableArray) {
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
            
            handleBirdArray(noOfBird, farmName, cNData, birdArry)
            
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
    }
    
    fileprivate func handleNoOfBirdsValidation(_ noOfBird: Int?, _ farmName: String?, _ cNData: CaptureNecropsyDataTurkey, _ birdArry: NSMutableArray) {
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
    }
    
    fileprivate func handlecNecArrayValidation(_ cNec: NSArray, _ complexId: inout Int, _ allArray: NSMutableArray) {
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
            complexId = cNData.complexId as! Int
            let flock = cNData.flockId
            let imgId = cNData.imageId
            let farmId = cNData.farmId
            let sick = cNData.sick
            let customerId = cNData.custmerId
            let customerName = cNData.complexName
            let complexDate = cNData.complexDate
            let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
            var abf = cNData.abf
            let farmWeight = cNData.farmWeight
            let breedString = cNData.breed
            let sex = cNData.sex
            let genName = cNData.generName
            let genId = cNData.generID
            
            handleNoOfBirdsValidation(noOfBird, farmName, cNData, birdArry)
            
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
    }
    
    fileprivate func callloginMethod(_ statusCode: Int? , postingsessionId: NSNumber) {
        if statusCode == 401  {
            self.loginMethod(postingId:postingsessionId)
        }
        else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
            self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
        }
    }
    
    /************************************/
    // MARK: 📡  POST API Call - Necropsy Data
    func saveNecropsyDataOnServer(postingId: NSNumber){
        var complexId = Int()
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
            let nId = captureNecropsyData.necropsyId!
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
                if let value = cNData.feedId {
                    var feedId = value
                }
                let age = cNData.age
                let flock = cNData.flockId
                let sick = cNData.sick
                let imgId = cNData.imageId
                complexId = cNData.complexId as! Int
                let timestamp = cNData.timeStamp
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexdate = cNData.complexDate
                var abf = cNData.abf
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
            var fullData = String()
            
            fullData = captureNecropsyData.timeStamp!
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
            let nId = captureNecropsyData.postingId!
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
                complexId = cNData.complexId as! Int
                let timestamp = cNData.timeStamp
                let flock = cNData.flockId
                let imgId = cNData.imageId
                let farmId = cNData.farmId
                let sick = cNData.sick
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexDate = cNData.complexDate
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                var abf = cNData.abf
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
            
            var fullData = String()
            fullData = captureNecropsyData.timeStamp!
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
        
        do {
            
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: -1009) // no internet
                return
            }
            
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = ["Authorization":accestoken]
            let Url = "PostingSession/TurkeySaveMultipleNecropsySyncData"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           // request.httpBody = try! JSONSerialization.data(withJSONObject: sessionWithAllforms, options: [])
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: sessionWithAllforms, options: [])
            } catch {
                print("❌ Failed to serialize JSON for request body: \(error)")
                request.httpBody = nil
            }

            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                if statusCode == 401  {
                    self.loginMethod(postingId:postingId)
                }
                else if  statusCode == 502
                {
                    self.delegeteSyncApiData.failWithInternetSyncdata()
                    self.showRetryAlert(apiName: "saveNecropsyDataOnServer", postingId: postingId, message: Constants.internetErrorMessage)
                }
                else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                }
                
                switch response.result {
                    
                case .success(let responseObject):
                    self.saveObservationImageOnServer(postingId: postingId)
                    
                case .failure(let encodingError):
                    let userMessage = NetworkErrorHandler.getUserFriendlyMessage(from: encodingError)
                    self.delegeteSyncApiData.didFailDuringPostApi(message: userMessage)
                    
                }
            }
            
        }
    }
    
    // MARK: -********************* Save Image  On Server ***************************/
    
    fileprivate func statusUpdateForPostedSession(postingId: NSNumber) {
        let handler = CoreDataHandlerTurkey()
        
        let updateOperations: [(NSNumber, @escaping (Bool) -> Void) -> Void] = [
            { id, completion in handler.updateisSyncOnMyBindersViaPostingIdTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnAlternativeFeedPostingidTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnAntiboticViaPostingIdTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnAllCocciControlviaPostingidTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnHetcharyVacDataWithPostingIdTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnPostingSessionTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnBirdPhotoCaptureDatabaseTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnNotesBirdDatabaseTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncNecropsystep1neccIdTurkey(id, isSync: false, completion)},
            { id, completion in handler.updateisSyncOnCaptureSkeletaInDatabaseTurkey(id, isSync: false, completion)}
        ]
        
        executeUpdatesSequentially(operations: updateOperations, postingId: postingId) {
            self.delegeteSyncApiData.didFinishApiSyncdata()
        }
    }
    
    private func executeUpdatesSequentially(operations: [(NSNumber, @escaping (Bool) -> Void) -> Void],postingId: NSNumber,completion: @escaping () -> Void) {
        var index = 0
        func executeNext() {
            guard index < operations.count else {
                completion()
                return
            }
            
            let operation = operations[index]
            operation(postingId) { success in
                if success {
                    index += 1
                    executeNext()
                }
            }
        }
        
        executeNext()
    }
    
    fileprivate func postImagesApiFailer(_ encodingError: AFError, _ response: AFDataResponse<Any>, _ statusCode: Int?) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
        } else if let respinceData = response.data {
            debugPrint(respinceData)
            if let s = statusCode {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
            }  else  {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
        }
    }
    
    fileprivate func handleCNecArr(_ cNecArr: NSArray, _ totalSession: NSMutableArray) {
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            totalSession.add(captureNecropsyData)
            for w in 0..<totalSession.count - 1
            {
                let c = totalSession.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    totalSession.remove(c)
                }
            }
        }
    }
    
    fileprivate func handleObsArr(_ obsArr: NSArray, _ j: Int, _ farmName: String?, _ catArr: NSArray, _ w: Int, _ necId: Int, _ obsWithImageArr: NSMutableArray) {
        for y in 0..<obsArr.count {
            let obsWithAllImageDataDict = NSMutableDictionary()
            let cData = obsArr.object(at: y) as! CaptureNecropsyViewDataTurkey
            let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDandIsyncTurkey( (j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, Obsid: cData.obsID!, isSync: true,necId: necId as NSNumber)
            obsWithAllImageDataDict.setValue(farmName!, forKey: "farmName")
            obsWithAllImageDataDict.setValue(j + 1, forKey: "birdNumber")
            
            var catName1 = catArr.object(at: w) as! String
            if catName1 == "Coccidiosis"{
                catName1 = "Microscopy"
            }
            
            obsWithAllImageDataDict.setValue(catName1, forKey: "categoryName")
            obsWithAllImageDataDict.setValue(cData.obsID!, forKey: "observationId")
            
            let photoValArr = NSMutableArray()
            var yImage =  UIImage()
            for z in 0..<photoArr.count
            {
                let objBirdPhotoCapture = photoArr.object(at: z) as! BirdPhotoCaptureTurkey
                var image : UIImage = UIImage(data: objBirdPhotoCapture.photo! as Data)!
                
                if let imageData = image.jpeg(.lowest) {
                    image = UIImage(data: imageData)!
                }
                
                let w : CGFloat = image.size.width / 7
                yImage = self.resizeImage(image, newWidth: w)!
                let imageDict =  NSMutableDictionary()
                imageDict.setValue(self.imageToNSString(yImage), forKey: "Image")
                photoValArr.add(imageDict)
            }
            obsWithAllImageDataDict.setValue(photoValArr, forKey: "images")
            obsWithImageArr.add(obsWithAllImageDataDict)
        }
    }
    
    fileprivate func handleNoOfBirdaArr(_ noOfBird: Int?, _ farmName: String?, _ necId: Int, _ obsWithImageArr: NSMutableArray) {
        for j in 0..<noOfBird! {
            let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
            for w in 0..<catArr.count {
                let obsArr = CoreDataHandlerTurkey().fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, necId: necId as NSNumber)
                
                handleObsArr(obsArr, j, farmName, catArr, w, necId, obsWithImageArr)
            }
        }
    }
    
    fileprivate func totalSessionItertion(_ totalSession: NSMutableArray, _ postingId: NSNumber, _ sessionArr: NSMutableArray) {
        for i in 0..<totalSession.count {
            let sessionDetails = NSMutableDictionary()
            let captureNecropsyData = totalSession.object(at: i)  as! CaptureNecropsyDataTurkey
            
            let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
            let obsWithImageArr = NSMutableArray()
            for x in 0..<cNec.count {
                let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let necId = Int(cNData.necropsyId!)
                handleNoOfBirdaArr(noOfBird, farmName, necId, obsWithImageArr)
            }
            
            var fullData = captureNecropsyData.timeStamp!
            sessionDetails.setValue(obsWithImageArr, forKey: "ImageDetails")
            let id = UserDefaults.standard.integer(forKey: "Id")
            sessionDetails.setValue(id, forKey: "UserId")
            sessionDetails.setValue(fullData, forKey: "deviceSessionId")
            sessionArr.add(sessionDetails)
        }
    }
    
    fileprivate func handlePhotoArrSaveObsImageOnServerValidations(_ photoArr: NSArray, _ yImage: inout UIImage, _ photoValArr: NSMutableArray) {
        for z in 0..<photoArr.count {
            let objBirdPhotoCapture = photoArr.object(at: z) as! BirdPhotoCaptureTurkey
            
            var image : UIImage = UIImage(data: objBirdPhotoCapture.photo! as Data)!
            
            
            if let imageData = image.jpeg(.lowest) {
                
                image = UIImage(data: imageData)!
            }
            let w : CGFloat = image.size.width / 7
            yImage = self.resizeImage(image, newWidth: w)!
            
            let imageDict =  NSMutableDictionary()
            imageDict.setValue(self.imageToNSString(yImage), forKey: "Image")
            photoValArr.add(imageDict)
            
        }
    }
    
    fileprivate func handleCatArrValidationsSaveObsImageOnServer(_ catArr: NSArray, _ j: Int, _ farmName: String?, _ necId: Int, _ obsWithImageArr: NSMutableArray) {
        for w in 0..<catArr.count {
            let obsArr = CoreDataHandlerTurkey().fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, necId: necId as NSNumber)
            
            for y in 0..<obsArr.count {
                let obsWithAllImageDataDict = NSMutableDictionary()
                let cData = obsArr.object(at: y) as! CaptureNecropsyViewDataTurkey
                let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDandIsyncTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, Obsid: cData.obsID!, isSync: true,necId: necId as NSNumber)
                obsWithAllImageDataDict.setValue(farmName!, forKey: "farmName")
                obsWithAllImageDataDict.setValue(j + 1, forKey: "birdNumber")
                var catName = catArr.object(at: w) as! String
                if catName == "Coccidiosis"{
                    catName = "Microscopy"
                }
                
                obsWithAllImageDataDict.setValue(catName, forKey: "categoryName")
                obsWithAllImageDataDict.setValue(cData.obsID!, forKey: "observationId")
                
                let photoValArr = NSMutableArray()
                var yImage = UIImage()
                handlePhotoArrSaveObsImageOnServerValidations(photoArr, &yImage, photoValArr)
                obsWithAllImageDataDict.setValue(photoValArr, forKey: "images")
                obsWithImageArr.add(obsWithAllImageDataDict)
            }
        }
    }
    
    fileprivate func handleSaveBirdImageSyncDataResponse(_ statusCode: Int?, _ response: AFDataResponse<Any>,postingId:NSNumber) {
        if statusCode == 401  {
            self.loginMethod(postingId: postingId)
        }
        else if  statusCode == 502
        {
            self.delegeteSyncApiData.failWithInternetSyncdata()
            self.showRetryAlert(apiName: "saveObservationImageOnServer", postingId: postingId, message: Constants.internetErrorMessage)
        }
        else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
            self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
        }
        
        switch response.result {
            
        case .success(let responseObject):
            Constants.isFromPsotingTurkey = false
            UserDefaults.standard.removeObject(forKey: "postingTurkey")
            CoreDataHandlerTurkey().updateisSyncOnBirdPhotoCaptureDatabaseTurkey(postingId , isSync: false, { (success) in
                
                if success == true{
                    self.statusUpdateForPostedSession(postingId: postingId)
                }
            })
            
        case .failure(let encodingError):
            let userMessage = NetworkErrorHandler.getUserFriendlyMessage(from: encodingError)
            self.delegeteSyncApiData.didFailDuringPostApi(message: userMessage)
        }
    }
    
    /**************************************************************************/
    // MARK: 📡  POST API Call - Session's Images ⏰
    func saveObservationImageOnServer (postingId:NSNumber) {
        
        let imageArrWithIsyncIsTrue = CoreDataHandlerTurkey().fecthPhotoWithiSynsTrueTurkey(true)
        let sessionDict = NSMutableDictionary()
        let sessionArr = NSMutableArray()
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
        let totalSession = NSMutableArray()
        
        handleCNecArr(cNecArr, totalSession)
        postingArrWithAllData.removeAllObjects()
        postingArrWithAllData =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        
        if imageArrWithIsyncIsTrue.count > 0 {
            totalSessionItertion(totalSession, postingId, sessionArr)
            
            for i in 0..<postingArrWithAllData.count {
                let sessionDetails = NSMutableDictionary()
                let captureNecropsyData = postingArrWithAllData.object(at: i)  as! PostingSessionTurkey
                _ = captureNecropsyData.timeStamp
                
                let cNec = CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
                let obsWithImageArr = NSMutableArray()
                for x in 0..<cNec.count {
                    let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                    let farmName = cNData.farmName
                    let noOfBird = Int(cNData.noOfBirds!)
                    let necId = Int(cNData.necropsyId!)
                    for j in 0..<noOfBird! {
                        let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
                        handleCatArrValidationsSaveObsImageOnServer(catArr, j, farmName, necId, obsWithImageArr)
                    }
                }
                
                _ = Int()
                let fullData = captureNecropsyData.timeStamp!
                sessionDetails.setValue(obsWithImageArr, forKey: "ImageDetails")
                let id = UserDefaults.standard.integer(forKey: "Id")
                sessionDetails.setValue(id, forKey: "UserId")
                sessionDetails.setValue(fullData, forKey: "deviceSessionId")
                sessionArr.add(sessionDetails)
                
            }
        }
        sessionDict.setValue(sessionArr, forKey: "Sessions")
        
        do {
            
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: -1009) // no internet
                return
            }
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = [Constants.authorization:accestoken]
            let Url = "PostingSession/SaveBirdImageSyncData"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: sessionDict, options: [])
            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                self.handleSaveBirdImageSyncDataResponse(statusCode, response, postingId: postingId)
            }
            
        }
    }
    
    // MARK: -*************** Login Method call Again  ***************************************************/
    
    func loginMethod(postingId:NSNumber){
        
        if WebClass.sharedInstance.connected() {
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
            let userName =  PasswordService.shared.getUsername()
            let pass =  PasswordService.shared.getPassword()
            
            let Url = "Token"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            let headers: HTTPHeaders = [Constants.contentType: "application/x-www-form-urlencoded", "Accept": Constants.applicationJson]
            let parameters:[String:String] = ["grant_type": "password","UserName" : CryptoHelper.encrypt(input: userName) as! String, "Password" : CryptoHelper.encrypt(input: pass) as! String, "LoginType": "Web", "DeviceId":udid as! String]
            sessionManager.request(urlString, method: .post, parameters: parameters, headers: headers).responseJSON { response in
                switch response.result {
                case let .success(value):
                    let statusCode = response.response?.statusCode
                    let dict : NSDictionary = value as! NSDictionary
                    if statusCode == 400{
                        _ = dict["error_description"]
                    }
                    
                    else if statusCode == 401{
                        _ = dict["error_description"]
                    }
                    else{
                        let acessToken = (dict.value(forKey: "access_token") as? String)!
                        let tokenType = (dict.value(forKey: "token_type") as? String)!
                        let aceesTokentype: String = tokenType + " " + acessToken
                        _ = dict.value(forKey: "HasAccess")! as AnyObject
                        let keychainHelper = AccessTokenHelper()
                        keychainHelper.saveToKeychain(valued: aceesTokentype, keyed: Constants.accessToken)
                        self.feedprogram(postingId: postingId)
                    }
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    break
                }
            }
        }
    }
    // MARK: - Update Data on Data Base
    fileprivate func handleSyncOnPostingSessionTurkey(pId: NSNumber, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnPostingSessionTurkey(pId , isSync: false, { (success) in
            if success == true {
                self.updadateNacDataOnCoreData(nId: pId, { (success) in
                    if success == true {
                        completion(success)
                        self.delegeteSyncApiData.didFinishApiSyncdata()
                    }
                })
            }
        })
    }
    
    fileprivate func handleUpdateIsSyncCocciSaveDB(pId: NSNumber, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAllCocciControlviaPostingidTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            
            CoreDataHandlerTurkey().updateisSyncOnHetcharyVacDataWithPostingIdTurkey(pId, isSync: false) { success in
                guard success else {
                    completion(false)
                    return
                }
                
                handleSyncOnPostingSessionTurkey(pId: pId, completion)
            }
        }
    }
    
    func updadateDataOnCoreData(pId: NSNumber, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnMyBindersViaPostingIdTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.updateAlternativeFeedSync(pId: pId, completion: completion)
        }
    }
    
    private func updateAlternativeFeedSync(pId: NSNumber, completion: @escaping (Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAlternativeFeedPostingidTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.updateAntibioticSync(pId: pId, completion: completion)
        }
    }
    
    private func updateAntibioticSync(pId: NSNumber, completion: @escaping (Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAntiboticViaPostingIdTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.handleUpdateIsSyncCocciSaveDB(pId: pId, completion)
        }
    }
    
    // MARK: - Update Necropsy Data on Core DB
    fileprivate func updateIsSyncInDB(_ nId: NSNumber,_ success: Bool, _ completion: (_ status: Bool) -> Void) {
        if success == true{
            
            CoreDataHandlerTurkey().updateisSyncOnBirdPhotoCaptureDatabaseTurkey(nId , isSync: false, { (success) in
                if success == true{
                    CoreDataHandlerTurkey().updateisSyncOnNotesBirdDatabaseTurkey(nId , isSync: false, { (success) in
                        if success == true{
                            completion(success)
                        }
                    })
                }
            })
        }
    }
    
    func updadateNacDataOnCoreData(nId: NSNumber, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnCaptureSkeletaInDatabaseTurkey(nId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.updateStep1Sync(nId: nId, completion: completion)
        }
    }
    
    private func updateStep1Sync(nId: NSNumber, completion: @escaping (Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncNecropsystep1neccIdTurkey(nId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.updateStep2Sync(nId: nId, completion: completion)
        }
    }
    
    private func updateStep2Sync(nId: NSNumber, completion: @escaping (Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnCaptureInDatabaseTurkey(nId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.updateIsSyncInDB(nId, success: success, completion: completion)
        }
    }
    
    private func updateIsSyncInDB(_ nId: NSNumber, success: Bool, completion: @escaping (Bool) -> Void) {
        updateIsSyncInDB(nId, success) { status in
            completion(status)
        }
    }
    
    
}


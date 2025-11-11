//
//  ApiSyncTurkey.swift
//  Zoetis -Feathers
//
//  Created by  on 4/4/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Reachability
import SystemConfiguration
import CoreData
import SwiftyJSON

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

protocol syncApiTurkey{
    func failWithError(statusCode:Int)
    func failWithErrorInternal()
    func didFinishApi()
    func startLoaderTurkey()
    func didFinishApiLoader()
    func failWithInternetConnection()
}

class ApiSyncTurkey: NSObject {
    
    // static let sharedInstance = ApiSync()
    var reachability: Reachability!
    var delegeteSyncApiTurkey : syncApiTurkey!
    var postingIdArr = NSMutableArray()
    var postingArrWithAllData = NSMutableArray()
    var strdateTimeStamp = String()
    var accestoken = String()
    var networkStatus : Reachability.Connection!
    var isSyncPostingIdArr : Bool = false
    var isSyncPostingArrWithData : Bool = false
    var isDelegateCalled : Bool = false
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    
    
    // MARK: - METHOD & FUNCTIONS
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
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo, let value = userInfo.values.first as? String {
            switch value {
            case "Online (WiFi)", "Online (WWAN)":
                debugPrint(value)
            default: break
            }
        }
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let sessionPostingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
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
        
        for i in 0..<sessionPostingArrWithAllData.count
        {
            let pSession = sessionPostingArrWithAllData.object(at: i) as! PostingSessionTurkey
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageToNSString(_ image: UIImage) -> String {
        let data = image.pngData()
        return data!.base64EncodedString(options: .lineLength64Characters)
    }
    fileprivate func handleSaveMultipleFeedSyncDataAPIResponseMain(_ statusCode: Int?, _ response: AFDataResponse<Any>) {
        switch statusCode {
        case 401:
            self.loginMethod()
        case 500, 503, 403, 501, 502, 400, 504, 404, 408:
            self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
        default:
            break
        }
        
        switch response.result {
        case .success(let responseObject):
            self.isSyncPostingArrWithData = false
            self.isSyncPostingIdArr = false
            self.addVaccination()
            
        case .failure(let encodingError):
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                self.delegeteSyncApiTurkey.failWithErrorInternal()
                debugPrint(err)
            } else if let _ = response.data {
                if let s = statusCode {
                    self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                }  else {
                    self.delegeteSyncApiTurkey.failWithErrorInternal()
                }
            }
        }
    }
    
    fileprivate func handleFetchMyBindeForLoopAndValidation(_ fetchMyBinde: NSArray, _ dataSet: inout Int, _ FinalArray1: inout NSMutableArray, _ mainFeeds: NSMutableArray, _ index: inout Int, _ feeds: inout NSMutableDictionary) {
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
                // let tempArray =
                let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                if tempArray?.count > 0 {
                    tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                    feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
                }
                mainFeeds.replaceObject(at: index, with: feeds)
                index+=1
                FinalArray1 = NSMutableArray()
                feeds = NSMutableDictionary()
            }
        }
    }
    
    fileprivate func handleFetchAlternativeDataForLoopValidations(_ fetchAlternative: NSArray, _ dataSet: inout Int, _ FinalArray1: inout NSMutableArray, _ mainFeeds: NSMutableArray, _ index: inout Int, _ feeds: inout NSMutableDictionary) {
        for i in 0..<fetchAlternative.count {
            
            dataSet+=1
            
            let mainDict = NSMutableDictionary()
            let antiboticFeed = fetchAlternative.object(at: i) as! AlternativeFeedTurkey
            let dosage = antiboticFeed.dosage
            
            var feedId = antiboticFeed.feedId as! Int
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
            mainDict.setValue(6, forKey: "feedProgramCategoryId")
            mainDict.setValue(0, forKey: "moleculeId")
            mainDict.setValue(feedType, forKey: "feedType")
            
            FinalArray1.add(mainDict)
            
            if dataSet == 6 {
                dataSet = 0
                
                let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                if tempArray?.count > 0 {
                    tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                    feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
                }
                mainFeeds.replaceObject(at: index, with: feeds)
                index+=1
                FinalArray1 = NSMutableArray()
                feeds = NSMutableDictionary()
            }
        }
    }
    
    fileprivate func handleFetchAntiboticDataAndValidations(_ fetchAntibotic: NSArray, _ dataSet: inout Int, _ FinalArray1: inout NSMutableArray, _ mainFeeds: NSMutableArray, _ index: inout Int, _ feeds: inout NSMutableDictionary) {
        for i in 0..<fetchAntibotic.count {
            dataSet+=1
            
            let mainDict = NSMutableDictionary()
            let antiboticFeed = fetchAntibotic.object(at: i) as! AntiboticFeedTurkey
            let dosage = antiboticFeed.dosage
            var feedId = antiboticFeed.feedId as! Int
            let feedProgram = antiboticFeed.feedProgram
            let fromDays = antiboticFeed.fromDays
            let molecule = antiboticFeed.molecule
            let toDays = antiboticFeed.toDays
            let feedType = antiboticFeed.feedType
            
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
                
                let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                if tempArray?.count > 0 {
                    tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                    feeds = ["feedName" : feedProgram!, "feedId" : feedId,"feedProgramDetails" : tempArray!]
                }
                mainFeeds.replaceObject(at: index, with: feeds)
                index+=1
                FinalArray1 = NSMutableArray()
                feeds = NSMutableDictionary()
                
            }
        }
    }
    
    fileprivate func handleAllCocciControlValidations(_ allCocciControl: NSArray, _ dataSet: inout Int, _ FinalArray1: inout NSMutableArray, _ feeds: inout NSMutableDictionary, _ mainFeeds: NSMutableArray) {
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
                
                var feedId = cocciControl.feedId as! Int
                let feedProgram = cocciControl.feedProgram
                
                feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : FinalArray1]
                FinalArray1 = NSMutableArray()
                mainFeeds.add(feeds)
                feeds = NSMutableDictionary()
            }
        }
    }
    
    
    fileprivate func handleIfWebConnectedAndCallAPI(_ sessionDictMain: NSMutableDictionary) {
        do {
            if WebClass.sharedInstance.connected() {
                
                let Url = "PostingSession/SaveMultipleFeedsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = [Constants.authorization:accestoken]
                
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                if let jsonData = try? JSONSerialization.data(withJSONObject: sessionDictMain, options: []) {
                    request.httpBody = jsonData
                } else {
                    print(Constants.failedSerilazedJSON)
                }
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    self.handleSaveMultipleFeedSyncDataAPIResponseMain(statusCode, response)
                }
            }
        }
    }
    
    /********************* Save Feed Program data On Server *****************************************************************************************************/
    
    // MARK: - API Retry Logic
    func retryApiCall(apiName: String,
                      retryCount: Int = 2,
                      delay: TimeInterval = 0.5) {
        guard retryCount > 0 else {
            print("❌ Max retries reached for \(apiName)")
            return
        }

        self.delegeteSyncApiTurkey.startLoaderTurkey()

        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            print("🔄 Retrying \(apiName)... remaining attempts: \(retryCount)")

            DispatchQueue.main.async {
                switch apiName {
                case "FeedProgram":
                    self.feedprogram()
                case "addVaccination":
                    self.addVaccination()
                case "savePostingDataOnServer":
                    self.savePostingDataOnServer()
                case "saveNecropsyDataOnServer":
                    self.saveNecropsyDataOnServer()
                case "saveObservationImageOnServer":
                    self.saveObservationImageOnServer()
                default:
                    print("⚠️ Unknown API name: \(apiName)")
                }

                // 👇 If still fails, show alert with SAME retryCount
                self.showRetryAlert(apiName: apiName,
                                    message: "Failed again, want to retry?",
                                    retryCount: retryCount)
            }
        }
    }
    
    // MARK: - ⚠️ Alert Helpers 🔔
    func showRetryAlert(apiName: String, message: String, retryCount: Int = 2) {
        // 1️⃣ Create alert controller without default title/message
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // 2️⃣ Add warning icon to title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.systemRed
        ]
        let attributedTitle = NSAttributedString(string: "⚠️ Error", attributes: titleAttributes)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        // 3️⃣ Add styled message
        let messageAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        // 4️⃣ Retry action (blue text) with dynamic count
        let retryTitle = "Retry (\(retryCount) left)"
        let retryAction = UIAlertAction(title: retryTitle, style: .default) { _ in
            if retryCount > 0 {
                self.retryApiCall(apiName: apiName, retryCount: retryCount - 1)
            } else {
                print("⚠️ No more retries left for \(apiName)")
            }
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
    
    // MARK: 📡 POST API Call - Feed Program data On Server 🌾
    func feedprogram() {
        self.isSyncPostingIdArr = false
        let feedArrWithAllData =   CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
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
        for i in 0..<feedArrWithAllData.count
        {
            if self.isSyncPostingArrWithData == false {
                self.isSyncPostingArrWithData = true
                let pSession =  feedArrWithAllData.object(at: i) as! PostingSessionTurkey
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
            
            
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession =  necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            sessionId = nIdSession.necropsyId!
            self.postingIdArr.add(sessionId)
        }
        let sessionArray = NSMutableArray()
        //
        var sessionDictMain = NSMutableDictionary()
        
        for i in 0..<self.postingIdArr.count {
            
            if self.isSyncPostingIdArr == false{
                self.isSyncPostingIdArr = true
                let mainDict = NSMutableDictionary()
                var FinalArray1 = NSMutableArray()
                let allCocciControl =  CoreDataHandlerTurkey().fetchAllCocciControlviaIsyncTurkey(true,postinID: self.postingIdArr[i] as! NSNumber)
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
                        
                        var feedId = cocciControl.feedId as! Int
                        let feedProgram = cocciControl.feedProgram
                        
                        feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : FinalArray1]
                        FinalArray1 = NSMutableArray()
                        mainFeeds.add(feeds)
                        feeds = NSMutableDictionary()
                    }
                }
                
                let fetchAntibotic = CoreDataHandlerTurkey().fetchAntiboticViaIsSyncTurkey(true,postingID: self.postingIdArr[i] as! NSNumber)
                
                for i in 0..<fetchAntibotic.count {
                    dataSet+=1
                    
                    let mainDict = NSMutableDictionary()
                    let antiboticFeed = fetchAntibotic.object(at: i) as! AntiboticFeedTurkey
                    let dosage = antiboticFeed.dosage
                    var feedId = antiboticFeed.feedId as! Int
                    let feedProgram = antiboticFeed.feedProgram
                    let fromDays = antiboticFeed.fromDays
                    let molecule = antiboticFeed.molecule
                    let toDays = antiboticFeed.toDays
                    let feedType = antiboticFeed.feedType
                    
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
                        
                        let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                        if tempArray?.count > 0 {
                            tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                            feeds = ["feedName" : feedProgram!, "feedId" : feedId,"feedProgramDetails" : tempArray!]
                        }
                        mainFeeds.replaceObject(at: index, with: feeds)
                        index+=1
                        FinalArray1 = NSMutableArray()
                        feeds = NSMutableDictionary()
                        
                    }
                }
                
                let fetchAlternative = CoreDataHandlerTurkey().fetchAlternativeFeedWithIsSyncTurkey(true,postingID: self.postingIdArr[i] as! NSNumber)
                
                index = 0
                for i in 0..<fetchAlternative.count {
                    
                    dataSet+=1
                    
                    let mainDict = NSMutableDictionary()
                    let antiboticFeed = fetchAlternative.object(at: i) as! AlternativeFeedTurkey
                    let dosage = antiboticFeed.dosage
                    
                    var feedId = antiboticFeed.feedId as! Int
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
                    mainDict.setValue(6, forKey: "feedProgramCategoryId")
                    mainDict.setValue(0, forKey: "moleculeId")
                    mainDict.setValue(feedType, forKey: "feedType")
                    
                    FinalArray1.add(mainDict)
                    
                    if dataSet == 6 {
                        dataSet = 0
                        
                        let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                        if tempArray?.count > 0 {
                            tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                            feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
                        }
                        mainFeeds.replaceObject(at: index, with: feeds)
                        index+=1
                        FinalArray1 = NSMutableArray()
                        feeds = NSMutableDictionary()
                    }
                }
                
                let fetchMyBinde = CoreDataHandlerTurkey().fetchMyBindersViaIsSyncTurkey(true,postingID: self.postingIdArr[i] as! NSNumber)
                
                index = 0
                for i in 0..<fetchMyBinde.count {
                    
                    dataSet+=1
                    
                    let mainDict = NSMutableDictionary()
                    
                    let antiboticFeed = fetchMyBinde.object(at: i) as! MyCotoxinBindersFeedTurkey
                    let dosage = antiboticFeed.dosage
                    var feedId = antiboticFeed.feedId as! Int
                    
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
                        // let tempArray =
                        let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                        if tempArray?.count > 0 {
                            tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                            feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
                        }
                        mainFeeds.replaceObject(at: index, with: feeds)
                        index+=1
                        FinalArray1 = NSMutableArray()
                        feeds = NSMutableDictionary()
                    }
                }
                
                if ( allCocciControl.count > 0 || fetchAntibotic.count > 0 || fetchAlternative.count > 0 || fetchMyBinde.count > 0){
                    mainDict.setValue(sessionId, forKey: "sessionId")
                    let acttimeStamp = tempArrTime.object(at: i)
                    
                    
                    let fullData = acttimeStamp as! String
                    mainDict.setValue(fullData, forKey: "deviceSessionId")
                    let id = UserDefaults.standard.integer(forKey: "Id")
                    mainDict.setValue(id, forKey: "UserId")
                    mainDict.setValue(false, forKey: "finalized")
                    
                    let sessionDict: NSMutableDictionary = [
                        "deviceSessionId" : fullData,
                        "sessionId" : postingIdArr[i] as! NSNumber,
                        "userId" : id,
                        "feeds" : mainFeeds
                    ]
                    
                    sessionArray.add(sessionDict)
                    sessionDict = NSMutableDictionary()
                    sessionDictMain = ["Sessions" : sessionArray]
                }
            }
            
        }
        do {
            
            // ✅ Check internet first
            if !WebClass.sharedInstance.connected() {
                print("❌ No internet at all")
                self.delegeteSyncApiTurkey.failWithErrorInternal()
                return
            }
            
            let Url = "PostingSession/SaveMultipleFeedsSyncData"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict = [Constants.authorization:accestoken]
            
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            if let jsonData = try? JSONSerialization.data(withJSONObject: sessionDictMain, options: []) {
                request.httpBody = jsonData
            } else {
                print(Constants.failedSerilazedJSON)
            }
            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                // Feed Program Data
                if statusCode == 401  {
                    self.loginMethod()
                }
                else if statusCode == 502
                {
                    self.delegeteSyncApiTurkey.didFinishApiLoader()
                    self.showRetryAlert(apiName: "FeedProgram", message: Constants.internetErrorMessage)
                }
                else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501  || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
                }
                
                switch response.result {
                    
                case .success(let responseObject):
                    self.isSyncPostingArrWithData = false
                    self.isSyncPostingIdArr = false
                    self.addVaccination()
                    
                case .failure(let encodingError):
                    
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        
                        self.delegeteSyncApiTurkey.failWithErrorInternal()
                        debugPrint(err)
                    } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        // other failures
                        debugPrint (encodingError)
                        debugPrint (responseString)
                        if let s = statusCode {
                            
                            self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                            
                        }  else {
                            self.delegeteSyncApiTurkey.failWithErrorInternal()
                        }
                    }
                }
            }
            
        }
    }
    
    
    fileprivate func handleFieldVacinationAllForLoopValidations(_ FieldVacinationAll: NSArray, _ vaccinationDetail: inout NSMutableDictionary) {
        for i in 0..<FieldVacinationAll.count {
            let pSession = FieldVacinationAll.object(at: i) as! HatcheryVacTurkey
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
            } else {
                routeId = 0
            }
            let age = pSession.age
            var strain = pSession.strain!
            let fieldStrainKey = "fieldStrain\(i + 1)"
            let fieldrouteKey = "fieldRoute\(i+1)Id"
            let fieldAgeKey = "fieldAge\(i + 1)"
            
            vaccinationDetail.setObject(strain, forKey: fieldStrainKey as NSCopying)
            vaccinationDetail.setObject(routeId, forKey: fieldrouteKey as NSCopying)
            vaccinationDetail.setObject(age!, forKey: fieldAgeKey as NSCopying)
        }
    }
    
    
    fileprivate func handleSaveMultipleVaccinationAPIResponseMain(_ statusCode: Int?, _ response: AFDataResponse<Any>) {
        switch statusCode {
        case 401:
            self.loginMethod()
        case 500, 503, 403, 501, 502, 400, 504, 404, 408:
            self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
        default:
            break
        }
        
        switch response.result {
            
        case .success(let responseObject):
            
            self.isSyncPostingArrWithData = false
            self.isSyncPostingIdArr = false
            self.savePostingDataOnServer()
            
        case .failure(let encodingError):
            
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                
                self.delegeteSyncApiTurkey.failWithErrorInternal()
                print(err)
            } else if response.data != nil {
                
                if let s = statusCode {
                    
                    self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                    
                }  else  {
                    self.delegeteSyncApiTurkey.failWithErrorInternal()
                }
            }
        }
    }
    
    fileprivate func handleCNecArrForLoopValidations(_ cNecArr: NSArray, _ necArrWithoutPosting: NSMutableArray) {
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
    }
    
    
    /********************* Save Add Vacination data On Server ***************************/
    /**************************************************************************/
    // MARK: 📡 POST API Call - Add Vacination data On Server 💉
    func addVaccination(){
        
        let vacciPostingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
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
        self.postingIdArr.removeAllObjects()
        let tempArrTime = NSMutableArray()
        let actualTemp  = NSMutableArray()
        
        for i in 0..<vacciPostingArrWithAllData.count
        {
            if self.isSyncPostingArrWithData == false{
                self.isSyncPostingArrWithData = true
                let pSession = vacciPostingArrWithAllData.object(at: i) as! PostingSessionTurkey
                var sessionId = pSession.postingId!
                var timeStamp = pSession.timeStamp!
                var actualtimeStr = pSession.actualTimeStamp
                if actualtimeStr == nil{
                    actualtimeStr = ""
                }
                actualTemp.add(actualtimeStr!)
                tempArrTime.add(timeStamp)
                self.postingIdArr.add(sessionId)
            }
            
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            self.postingIdArr.add(sessionId)
        }
        
        let sessionArr = NSMutableArray()
        let sessionDictWithVac = NSMutableDictionary()
        
        for i in 0..<self.postingIdArr.count {
            
            if self.isSyncPostingIdArr == false{
                self.isSyncPostingIdArr = true
                let pId = self.postingIdArr.object(at: i) as! NSNumber
                let addVacinationAll = CoreDataHandlerTurkey().fetchFieldAddvacinationDataWithisSyncTrueTurkey(pId , isSync : true)
                var vaccinationName = String ()
                
                let vaccinationDetail = NSMutableDictionary()
                for i in 0..<addVacinationAll.count {
                    let pSession = addVacinationAll.object(at: i) as! FieldVaccinationTurkey
                    vaccinationName = pSession.vaciNationProgram!
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
                    
                    var strain = pSession.strain!
                    let strainKey = "hatcheryStrain\(i + 1)"
                    let routeKey = "hatcheryRoute\(i+1)Id"
                    
                    vaccinationDetail .setObject(strain, forKey: strainKey as NSCopying)
                    vaccinationDetail .setObject(routeId, forKey: routeKey as NSCopying)
                }
                
                
                let FieldVacinationAll = CoreDataHandlerTurkey().fetchAddvacinationDataWithisSyncTurkey(pId , isSync : true)
                for i in 0..<FieldVacinationAll.count
                {
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
                    var strain = pSession.strain!
                    let fieldStrainKey = "fieldStrain\(i + 1)"
                    let fieldrouteKey = "fieldRoute\(i+1)Id"
                    let fieldAgeKey = "fieldAge\(i + 1)"
                    
                    vaccinationDetail .setObject(strain, forKey: fieldStrainKey as NSCopying)
                    vaccinationDetail .setObject(routeId, forKey: fieldrouteKey as NSCopying)
                    vaccinationDetail .setObject(age!, forKey: fieldAgeKey as NSCopying)
                }
                
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
                    let acttimeStamp = tempArrTime.object(at: i)
                    
                    var fullData = acttimeStamp as! String
                    mainDict.setValue(fullData, forKey: "deviceSessionId")
                    sessionArr.add(mainDict)
                }
            }
            
        }
        sessionDictWithVac.setValue(sessionArr, forKey: "Vaccinations")
        
        do {
            
            
            if WebClass.sharedInstance.connected() {
                let Url = "/PostingSession/SaveMultipleVaccinationsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = [Constants.authorization:accestoken]
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: sessionDictWithVac, options: []) {
                    request.httpBody = jsonData
                } else {
                    print(Constants.failedSerilazedJSON)
                    // Handle error case, such as not making the request
                }
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod()
                    }
                    else if  statusCode == 502
                    {
                        self.delegeteSyncApiTurkey.didFinishApiLoader()
                        self.showRetryAlert(apiName: "addVaccination", message: Constants.internetErrorMessage)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501  || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        
                        self.isSyncPostingArrWithData = false
                        self.isSyncPostingIdArr = false
                        self.savePostingDataOnServer()
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            
                            self.delegeteSyncApiTurkey.failWithErrorInternal()
                            print(err)
                        } else if let data = response.data{
                            
                            if let s = statusCode {
                                
                                self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                                
                            }  else  {
                                self.delegeteSyncApiTurkey.failWithErrorInternal()
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func necropsyDataApiFailed(_ encodingError: AFError, _ response: AFDataResponse<Any>) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet,let data = response.data, let _ = String(data: data, encoding: String.Encoding.utf8) {
            self.syncFail()
        }
    }
    
    func syncFail() {
        self.delegeteSyncApiTurkey.failWithErrorInternal()
    }
    
    fileprivate func handleSaveMultiplePostingsSyncDataSavePostingData(_ statusCode: Int?, _ response: AFDataResponse<Any>) {
        switch statusCode {
        case 401:
            self.loginMethod()
        case  502:
            self.delegeteSyncApiTurkey.didFinishApiLoader()
            self.showRetryAlert(apiName: "savePostingDataOnServer", message: Constants.internetErrorMessage)
            
        case 500, 503, 403, 501, 400, 504, 404, 408:
            self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
        default:
            break
        }
        
        switch response.result {
            
        case .success(let responseObject):
            
            self.isSyncPostingArrWithData = false
            self.isSyncPostingIdArr = false
            self.saveNecropsyDataOnServer()
            
        case .failure(let encodingError):
            
            self.necropsyDataApiFailed(encodingError, response)
        }
    }
    
    fileprivate func handleFetchNecropsystep1WithisSyncTurkeySavePostingDataServer(_ cNecArr: NSArray, _ necArrWithoutPosting: NSMutableArray) {
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
    }
    
    fileprivate func handleFarmVisitValidation(_ sessiontype: String?, _ sessionTypeId: inout Int, _ vetUserId: NSNumber?, _ birdTypeId: inout Int) {
        if sessiontype == "Farm Visit" {
            sessionTypeId = 2
        } else if sessiontype == "Posting Visit" {
            sessionTypeId = 1
        } else {
            sessionTypeId = 0
        }
        
        if vetUserId == 0 {
            birdTypeId = 0
        } else {
            birdTypeId = 2
        }
    }
    
    fileprivate func handleSaveMultiplePostingsSyncDataPostingData(_ postingDictOnServer: NSMutableDictionary) {
        do {
            if WebClass.sharedInstance.connected() {
                let Url = "PostingSession/TurkeySaveMultiplePostingsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = [Constants.authorization:accestoken]
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: postingDictOnServer, options: []) {
                    request.httpBody = jsonData
                    // print(jsonData)
                } else {
                    print(Constants.failedSerilazedJSON)
                }
                
                
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    self.handleSaveMultiplePostingsSyncDataSavePostingData(statusCode, response)
                }
            }
        }
    }
    
    /********************* Save Posting data On Server ***************************/
    
    func savePostingDataOnServer(){
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        
        self.postingIdArr.removeAllObjects()
        let postingServerArray = NSMutableArray()
        let  postingDictOnServer = NSMutableDictionary()
        
        for i in 0..<postingArrWithAllData.count {
            if self.isSyncPostingArrWithData == false {
                self.isSyncPostingArrWithData = true
                let postingDataDict = NSMutableDictionary()
                let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
                let sessionDate = pSession.sessiondate
                var sessionTypeId  = Int ()
                let sessiontype = pSession.sessionTypeName
                let vetUserId = pSession.veterinarianId
                let customerId = pSession.customerId
                let complexId = pSession.complexId
                let customerRep = pSession.customerRepName
                var birdTypeId = 0
                
                self.handleFarmVisitValidation(sessiontype, &sessionTypeId, vetUserId, &birdTypeId)
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
                let timestamp = pSession.timeStamp
                
                let avgAGe = pSession.avgAge
                let avgWght = pSession.avgWeight
                let outTime = pSession.outTime
                let fcr = pSession.fcr
                let livability = pSession.livability
                let mortality = pSession.dayMortality
                
                
                self.postingIdArr.add(sessionId!)
                
                
                
                var udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")! as! String
                _ =   timestamp! + "_" + String(describing: sessionId!)
                
                var  fullData = timestamp!
                
                
                postingDataDict.setValue(finalize, forKey: "finalized")
                postingDataDict.setValue(sessionDate, forKey: "sessionDate")
                postingDataDict.setValue(lngId, forKey: "LanguageId")
                postingDataDict.setValue(sessionTypeId, forKey: "sessionTypeId")
                postingDataDict.setValue(customerId, forKey: "customerId")
                postingDataDict.setValue(complexId, forKey: "complexId")
                postingDataDict.setValue(fullData, forKey: "deviceSessionId")
                postingDataDict.setValue(customerRep, forKey: "customerRep")
                postingDataDict.setValue(vetUserId, forKey: "vetUserId")
                postingDataDict.setValue(salesUserId, forKey: "salesUserId")
                postingDataDict.setValue(cocciProgramId, forKey: "cocciProgramId")
                postingDataDict.setValue(breedName, forKey: "breedName")
                postingDataDict.setValue(birdTypeId, forKey: "birdTypeId")
                postingDataDict.setValue(notes, forKey: "notes")
                postingDataDict.setValue(maleBreedName, forKey: "maleBreedName")
                postingDataDict.setValue(femaleBreedName, forKey: "femaleBreedName")
                postingDataDict.setValue(birdSize, forKey: "birdSize")
                postingDataDict.setValue(catptureNec, forKey: "catptureNec")
                postingDataDict.setValue(cociiProgramName, forKey: "cociiProgramName")
                postingDataDict.setValue(sessionId, forKey: "sessionId")
                let id = UserDefaults.standard.integer(forKey: "Id")
                postingDataDict.setValue(id, forKey: "UserId")
                postingDataDict.setValue(udid, forKey: "udid")
                
                
                postingDataDict.setValue(fcr, forKey: "FCR")
                postingDataDict.setValue(avgWght, forKey: "AvgWeight")
                
                postingDataDict.setValue(avgAGe, forKey: "AvgAge")
                postingDataDict.setValue(outTime, forKey: "AvgOutTime")
                
                postingDataDict.setValue(livability, forKey: "Livability")
                postingDataDict.setValue(mortality, forKey: "Avg7DayMortality")
                postingServerArray.add(postingDataDict)
                
            }
            
        }
        
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        handleFetchNecropsystep1WithisSyncTurkeySavePostingDataServer(cNecArr, necArrWithoutPosting)
        
        for j in 0..<necArrWithoutPosting.count {
            let postingDataDict = NSMutableDictionary()
            let pSession = necArrWithoutPosting.object(at: j) as! CaptureNecropsyDataTurkey
            let sessionDate = pSession.complexDate
            let sessionTypeId : Int = 0
            let customerId = pSession.custmerId
            let complexId = pSession.complexId
            let customerRep = ""
            let vetUserId = 0
            let salesUserId = 0
            let cocciProgramId = 0
            let breedName = ""
            let notes = ""
            let maleBreedName = ""
            let femaleBreedName = ""
            let birdSize = ""
            let catptureNec = 0
            let cociiProgramName = ""
            let sessionId = pSession.necropsyId
            let finalize = false
            let TimeStamp = pSession.timeStamp
            self.postingIdArr.add(sessionId!)
            
            let udid = String()
            _ = String()
            _ = String()
            
            let avgAGe = ""
            let avgWght = ""
            let outTime = ""
            let fcr = ""
            let livability = ""
            let mortality = ""
            var fullData = TimeStamp!
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
            postingDataDict.setValue(notes, forKey: "notes")
            postingDataDict.setValue(maleBreedName, forKey: "maleBreedName")
            postingDataDict.setValue(femaleBreedName, forKey: "femaleBreedName")
            postingDataDict.setValue(birdSize, forKey: "birdSize")
            postingDataDict.setValue(catptureNec, forKey: "catptureNec")
            postingDataDict.setValue(cociiProgramName, forKey: "cociiProgramName")
            postingDataDict.setValue(sessionId, forKey: "sessionId")
            let id = UserDefaults.standard.integer(forKey: "Id")
            postingDataDict.setValue(id, forKey: "UserId")
            postingDataDict.setValue(udid, forKey: "udid")
            postingDataDict.setValue(fullData, forKey: "sessionGUID")
            
            postingDataDict.setValue(fcr, forKey: "FCR")
            postingDataDict.setValue(avgWght, forKey: "AvgWeight")
            
            postingDataDict.setValue(avgAGe, forKey: "AvgAge")
            postingDataDict.setValue(outTime, forKey: "AvgOutTime")
            
            postingDataDict.setValue(livability, forKey: "Livability")
            postingDataDict.setValue(mortality, forKey: "Avg7DayMortality")
            postingServerArray.add(postingDataDict)
        }
        
        postingDictOnServer.setValue(postingServerArray, forKey: "PostingSessions")
        handleSaveMultiplePostingsSyncDataPostingData(postingDictOnServer)
    }
    
    fileprivate func handleFetchObsWithBirdandFarmNameTurkeyValidation(_ noOfBird: Int?, _ farmName: String?, _ cNData: CaptureNecropsyDataTurkey, _ birdArry: NSMutableArray) {
        for j in 0..<noOfBird! {
            
            let obsNameWithValue = CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
            let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
            
            if notesWithFarm.count > 0 {
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
    
    fileprivate func handleIsSyncPostingArrWithData(_ i: Int, _ lngId: Int, _ sessionArr: NSMutableArray) {
        if self.isSyncPostingArrWithData == false {
            self.isSyncPostingArrWithData = true
            var timestamp = NSString()
            let allArray = NSMutableArray()
            
            let captureNecropsyData = postingArrWithAllData.object(at: i)  as! PostingSessionTurkey
            let nId = captureNecropsyData.postingId!
            let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncandPostingIdTurkey(true , postingId:nId)
            let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
            
            for x in 0..<cNec.count {
                let birdArry = NSMutableArray()
                let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                let farmName = cNData.farmName
                let farmWeight = cNData.farmWeight
                let breedString = cNData.breed
                let abf = cNData.abf
                let sex = cNData.sex
                
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
                var feedID:Int = 0
                if let feedId  = cNData.feedId as? Int{
                    feedID = feedId
                }
                let age = cNData.age
                let imgId = cNData.imageId
                timestamp = cNData.timeStamp! as NSString
                let flock = cNData.flockId
                let sick = cNData.sick
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexDate = cNData.complexDate
                let farmId = cNData.farmId
                let GeneID = cNData.generID
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                handleFetchObsWithBirdandFarmNameTurkeyValidation(noOfBird, farmName, cNData, birdArry)
                
                formWithcatNameWithBirdAndAllObs.setValue(birdArry, forKey: "BirdDetails")
                formWithcatNameWithBirdAndAllObs.setValue(farmName, forKey: "farmName")
                formWithcatNameWithBirdAndAllObs.setValue(houseNo, forKey: "houseNo")
                formWithcatNameWithBirdAndAllObs.setValue(noOfBird!, forKey: "birds")
                formWithcatNameWithBirdAndAllObs.setValue(farmId, forKey: "SortId")
                formWithcatNameWithBirdAndAllObs.setValue(imgId, forKey: "ImgId")
                formWithcatNameWithBirdAndAllObs.setValue(feedProgram, forKey: "feedProgram")
                formWithcatNameWithBirdAndAllObs.setValue(abf, forKey: "ABF")
                formWithcatNameWithBirdAndAllObs.setValue(farmWeight, forKey: "Farm_Weight")
                formWithcatNameWithBirdAndAllObs.setValue(breedString, forKey: "Breed")
                formWithcatNameWithBirdAndAllObs.setValue(sex, forKey: "Sex")
                formWithcatNameWithBirdAndAllObs.setValue(feedID, forKey: "DeviceFeedId")
                formWithcatNameWithBirdAndAllObs.setValue(age, forKey: "age")
                formWithcatNameWithBirdAndAllObs.setValue(customerId, forKey: "customerId")
                formWithcatNameWithBirdAndAllObs.setValue(customerName, forKey: "customerName")
                formWithcatNameWithBirdAndAllObs.setValue(sick, forKey: "sick")
                formWithcatNameWithBirdAndAllObs.setValue(flock, forKey: "flockId")
                formWithcatNameWithBirdAndAllObs.setValue(complexDate, forKey: "ComplexDate")
                formWithcatNameWithBirdAndAllObs.setValue(GeneID, forKey: "GenerationId")
                allArray.add(formWithcatNameWithBirdAndAllObs)
            }
            formWithcatNameWithBirdAndAllObs1.setValue(timestamp, forKey: "deviceSessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.postingId!, forKey: "SessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(lngId, forKey: "LanguageId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.complexId!, forKey: "ComplexId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.sessiondate!, forKey: "sessionDate")
            formWithcatNameWithBirdAndAllObs1.setValue(allArray, forKey: "farmDetails")
            let Id = UserDefaults.standard.integer(forKey: "Id")
            formWithcatNameWithBirdAndAllObs1.setValue(Id, forKey: "UserId")
            sessionArr.add(formWithcatNameWithBirdAndAllObs1)
        }
    }
    
    fileprivate func handleCnecArraSaveNecropsyDataOnServer(_ cNec: NSArray, _ timestamp: inout String, _ allArray: NSMutableArray) {
        for x in 0..<cNec.count {
            
            let birdArry = NSMutableArray()
            let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
            let farmName = cNData.farmName
            let noOfBird = Int(cNData.noOfBirds!)
            let houseNo = cNData.houseNo
            let feedProgram = cNData.feedProgram
            let feedId  = cNData.feedId  as! Int
            let age = cNData.age
            let farmId = cNData.farmId
            let flock = cNData.flockId
            let imgId = cNData.imageId
            let sick = cNData.sick
            timestamp = cNData.timeStamp!
            let customerId = cNData.custmerId
            let customerName = cNData.complexName
            let complexdate = cNData.complexDate
            let GeneID = cNData.generID
            
            let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
            for j in 0..<noOfBird! {
                
                let obsNameWithValue =   CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                if notesWithFarm.count > 0 {
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
            formWithcatNameWithBirdAndAllObs.setValue(GeneID, forKey: "GenerationId")
            allArray.add(formWithcatNameWithBirdAndAllObs)
        }
    }
    
    fileprivate func handleSaveMultipleNecropsySyncDataSaveNecropsyDataOnServer(_ response: AFDataResponse<Any>) {
        switch response.result {
            
        case .success(let responseObject):
            // internet works.
            
            self.isSyncPostingArrWithData = false
            self.isSyncPostingIdArr = false
            self.saveObservationImageOnServer()
            
        case .failure(let encodingError):
            
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                // no internet connection
                self.delegeteSyncApiTurkey.failWithErrorInternal()
                debugPrint(err)
            } else if let data = response.data{
                debugPrint (encodingError)
                debugPrint (data)
                
                self.delegeteSyncApiTurkey.failWithErrorInternal()
            }
        }
    }
    
    fileprivate func handleAPIResponseStatusCodeHandler(_ statusCode: Int?) {
        if statusCode == 401 {
            self.loginMethod()
        } else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
            self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
        }
    }
    
    /********************* Save Farms  data On Server ***************************/
    /**************************************************************************/
    // MARK: 📡 POST API Call - Session Details On Server ⏱️
    func saveNecropsyDataOnServer(){
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let a = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            a.add(captureNecropsyData)
            for w in 0..<a.count - 1
            {
                let c = a.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    a.remove(c)
                }
            }
        }
        
        let sessionWithAllforms = NSMutableDictionary()
        let sessionArr = NSMutableArray()
        for i in 0..<a.count
        {
            var timestamp = String()
            let allArray = NSMutableArray()
            let captureNecropsyData = a.object(at: i)  as! CaptureNecropsyDataTurkey
            let nId = captureNecropsyData.necropsyId!
            let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncandPostingIdTurkey(true , postingId:nId)
            let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
            for x in 0..<cNec.count {
                
                let birdArry = NSMutableArray()
                let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
                let feedId  = cNData.feedId  as! Int
                let age = cNData.age
                let farmId = cNData.farmId
                let flock = cNData.flockId
                let imgId = cNData.imageId
                let sick = cNData.sick
                timestamp = cNData.timeStamp!
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexdate = cNData.complexDate
                let GeneID = cNData.generID
                
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                for j in 0..<noOfBird! {
                    
                    let obsNameWithValue =   CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                    let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                    if notesWithFarm.count > 0
                    {
                        let n = notesWithFarm.object(at: 0) as! NotesBirdTurkey
                        let notes = n.notes
                        obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                        obsNameWithValue.setValue(notes, forKey: "birdNotes")
                    }  else {
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
                formWithcatNameWithBirdAndAllObs.setValue(GeneID, forKey: "GenerationId")
                allArray.add(formWithcatNameWithBirdAndAllObs)
            }
            
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.necropsyId!, forKey: "SessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(lngId, forKey: "LanguageId")
            formWithcatNameWithBirdAndAllObs1.setValue(timestamp, forKey: "deviceSessionId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.complexId!, forKey: "ComplexId")
            formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.complexDate!, forKey: "sessionDate")
            formWithcatNameWithBirdAndAllObs1.setValue(allArray, forKey: "farmDetails")
            let Id = UserDefaults.standard.integer(forKey: "Id")
            formWithcatNameWithBirdAndAllObs1.setValue(Id, forKey: "UserId")
            
            sessionArr.add(formWithcatNameWithBirdAndAllObs1)
        }
        postingArrWithAllData.removeAllObjects()
        postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        
        for i in 0..<postingArrWithAllData.count
        {
            if self.isSyncPostingArrWithData == false {
                self.isSyncPostingArrWithData = true
                var timestamp = NSString()
                let allArray = NSMutableArray()
                
                let captureNecropsyData = postingArrWithAllData.object(at: i)  as! PostingSessionTurkey
                let nId = captureNecropsyData.postingId!
                let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncandPostingIdTurkey(true , postingId:nId)
                let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
                
                for x in 0..<cNec.count {
                    let birdArry = NSMutableArray()
                    let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                    let farmName = cNData.farmName
                    let farmWeight = cNData.farmWeight
                    let breedString = cNData.breed
                    let abf = cNData.abf
                    let sex = cNData.sex
                    
                    let noOfBird = Int(cNData.noOfBirds!)
                    let houseNo = cNData.houseNo
                    let feedProgram = cNData.feedProgram
                    var feedID:Int = 0
                    if let feedId  = cNData.feedId as? Int{
                        feedID = feedId
                    }
                    let age = cNData.age
                    let imgId = cNData.imageId
                    timestamp = cNData.timeStamp! as NSString
                    let flock = cNData.flockId
                    let sick = cNData.sick
                    let customerId = cNData.custmerId
                    let customerName = cNData.complexName
                    let complexDate = cNData.complexDate
                    let farmId = cNData.farmId
                    let GeneID = cNData.generID
                    let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                    for j in 0..<noOfBird! {
                        
                        let obsNameWithValue =   CoreDataHandlerTurkey().fetchObsWithBirdandFarmNameTurkey(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                        let notesWithFarm = CoreDataHandlerTurkey().fetchNotesWithBirdNumandFarmNameTurkey((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                        
                        if notesWithFarm.count > 0
                        {
                            let n = notesWithFarm.object(at: 0) as! NotesBirdTurkey
                            let notes = n.notes
                            obsNameWithValue.setValue(j + 1, forKey: "BirdId")
                            obsNameWithValue.setValue(notes, forKey: "birdNotes")
                        }
                        else
                        {
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
                    formWithcatNameWithBirdAndAllObs.setValue(abf, forKey: "ABF")
                    formWithcatNameWithBirdAndAllObs.setValue(farmWeight, forKey: "Farm_Weight")
                    formWithcatNameWithBirdAndAllObs.setValue(breedString, forKey: "Breed")
                    formWithcatNameWithBirdAndAllObs.setValue(sex, forKey: "Sex")
                    formWithcatNameWithBirdAndAllObs.setValue(feedID, forKey: "DeviceFeedId")
                    formWithcatNameWithBirdAndAllObs.setValue(age, forKey: "age")
                    formWithcatNameWithBirdAndAllObs.setValue(customerId, forKey: "customerId")
                    formWithcatNameWithBirdAndAllObs.setValue(customerName, forKey: "customerName")
                    formWithcatNameWithBirdAndAllObs.setValue(sick, forKey: "sick")
                    formWithcatNameWithBirdAndAllObs.setValue(flock, forKey: "flockId")
                    formWithcatNameWithBirdAndAllObs.setValue(complexDate, forKey: "ComplexDate")
                    formWithcatNameWithBirdAndAllObs.setValue(GeneID, forKey: "GenerationId")
                    allArray.add(formWithcatNameWithBirdAndAllObs)
                }
                formWithcatNameWithBirdAndAllObs1.setValue(timestamp, forKey: "deviceSessionId")
                formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.postingId!, forKey: "SessionId")
                formWithcatNameWithBirdAndAllObs1.setValue(lngId, forKey: "LanguageId")
                formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.complexId!, forKey: "ComplexId")
                formWithcatNameWithBirdAndAllObs1.setValue(captureNecropsyData.sessiondate!, forKey: "sessionDate")
                formWithcatNameWithBirdAndAllObs1.setValue(allArray, forKey: "farmDetails")
                let Id = UserDefaults.standard.integer(forKey: "Id")
                formWithcatNameWithBirdAndAllObs1.setValue(Id, forKey: "UserId")
                sessionArr.add(formWithcatNameWithBirdAndAllObs1)
            }
            
        }
        sessionWithAllforms.setValue(sessionArr, forKey: "Session")
        
        do {
 
            if WebClass.sharedInstance.connected() {
                
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = ["Authorization":accestoken]
                let Url = "PostingSession/TurkeySaveMultipleNecropsySyncData"
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: sessionWithAllforms, options: [])
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod()
                    }
                    else if statusCode == 502 {
                        self.delegeteSyncApiTurkey.didFinishApiLoader()
                        self.showRetryAlert(apiName: "saveNecropsyDataOnServer", message: Constants.internetErrorMessage)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        // internet works.
                        
                        self.isSyncPostingArrWithData = false
                        self.isSyncPostingIdArr = false
                        self.saveObservationImageOnServer()
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            // no internet connection
                            self.delegeteSyncApiTurkey.failWithErrorInternal()
                            debugPrint(err)
                        } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            // other failures
                            debugPrint (encodingError)
                            debugPrint (responseString)
                            if let s = statusCode {
                                
                                self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                            }  else {
                                self.delegeteSyncApiTurkey.failWithErrorInternal()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handleSuccessBirdImageSyncValidation(success:Bool) {
        if success == true {
            self.delegeteSyncApiTurkey.didFinishApi()
        }
    }
    
    fileprivate func handleIsDelegateCallAndSuccessValidations(_ success: Bool) {
        if success == true,self.isDelegateCalled == false {
            self.isDelegateCalled = true
            self.delegeteSyncApiTurkey.didFinishApi()
        }
    }
    
    fileprivate func handleSaveBirdImageSyncDataSuccessResponseUpdateNacDataOnCoreDataValidations(_ cNecArr: NSArray) {
        if cNecArr.count > 0 && self.postingIdArr.count == 0 {
            self.updadateNacDataOnCoreData(cNecArr: cNecArr, { (success) in
                self.handleSuccessBirdImageSyncValidation(success: success)
            })
        } else if cNecArr.count > 0 && self.postingIdArr.count > 0 {
            self.updateDataOnCoreData(cNecArr: cNecArr) { success in
                self.handleSuccessBirdImageSyncValidation(success: success)
            }
        } else if cNecArr.count == 0 && self.postingIdArr.count > 0 {
            self.updateDataOnCoreData(cNecArr: cNecArr,{ (success) in
                self.handleIsDelegateCallAndSuccessValidations(success)
            })
        }
    }
    
    fileprivate func handleSaveBirdmageSyncDataSuccessResponse(_ response: AFDataResponse<Any>, _ statusCode: Int?,cNecArr: NSArray) {
        switch response.result {
        case .success(let responseObject):
            self.isSyncPostingArrWithData = false
            self.isSyncPostingIdArr = false
            self.isDelegateCalled = false
            handleSaveBirdImageSyncDataSuccessResponseUpdateNacDataOnCoreDataValidations(cNecArr)
        case .failure(let encodingError):
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                self.delegeteSyncApiTurkey.failWithErrorInternal()
                
            } else if let data = response.data, let _ = String(data: data, encoding: String.Encoding.utf8) {
                if let s = statusCode {
                    self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                } else {
                    self.delegeteSyncApiTurkey.failWithErrorInternal()
                }
            }
        }
    }
    
    fileprivate func handleObsArrObserverValidationsOnServerValidation(_ obsArr: NSArray, _ j: Int, _ farmName: String?, _ catArr: NSArray, _ w: Int, _ necId: Int, _ obsWithImageArr: NSMutableArray) {
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
            var yImage =  UIImage()
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
            
            obsWithAllImageDataDict.setValue(photoValArr, forKey: "images")
            obsWithImageArr.add(obsWithAllImageDataDict)
        }
    }
    
    fileprivate func handleCNecAndObsWithImageArrValidations(_ cNec: NSArray, _ obsWithImageArr: NSMutableArray) {
        for x in 0..<cNec.count {
            let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
            let farmName = cNData.farmName
            let noOfBird = Int(cNData.noOfBirds!)
            let necId = Int(cNData.necropsyId!)
            for j in 0..<noOfBird! {
                let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
                
                for w in 0..<catArr.count {
                    let obsArr = CoreDataHandlerTurkey().fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, necId: necId as NSNumber)
                    
                    self.handleObsArrObserverValidationsOnServerValidation(obsArr, j, farmName, catArr, w, necId, obsWithImageArr)
                }
            }
        }
    }
    
    fileprivate func handleTotalSessionArrHandlingAndValidations(_ obsArr: NSArray, _ j: Int, _ farmName: String?, _ catArr: NSArray, _ w: Int, _ necId: Int, _ obsWithImageArr:inout NSMutableArray) {
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
    
    
    
    /********************* Save Image  On Server ***************************/
    /**************************************************************************/
    
    // MARK: 📡  POST API Call - For Necropsy Images 🖼️
    func  saveObservationImageOnServer (){
        
        let imageArrWithIsyncIsTrue = CoreDataHandlerTurkey().fecthPhotoWithiSynsTrueTurkey(true)
        let sessionDict = NSMutableDictionary()
        let sessionArr = NSMutableArray()
        
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let totalSession = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
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
        
        postingArrWithAllData.removeAllObjects()
        postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        
        if imageArrWithIsyncIsTrue.count > 0
        {
            for i in 0..<totalSession.count
            {
                let sessionDetails = NSMutableDictionary()
                let captureNecropsyData = totalSession.object(at: i)  as! CaptureNecropsyDataTurkey
                let nId = captureNecropsyData.necropsyId!
                let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncandPostingIdTurkey(true , postingId:nId)
                let obsWithImageArr = NSMutableArray()
                for x in 0..<cNec.count
                {
                    let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                    let farmName = cNData.farmName
                    let noOfBird = Int(cNData.noOfBirds!)
                    let necId = Int(cNData.necropsyId!)
                    for j in 0..<noOfBird!
                    {
                        let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
                        for w in 0..<catArr.count
                        {
                            let obsArr = CoreDataHandlerTurkey().fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, necId: necId as NSNumber)
                            
                            for y in 0..<obsArr.count
                            {
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
                    }
                }
                
               
                var fullData = captureNecropsyData.timeStamp!
                sessionDetails.setValue(obsWithImageArr, forKey: "ImageDetails")
                let id = UserDefaults.standard.integer(forKey: "Id")
                sessionDetails.setValue(id, forKey: "UserId")
                sessionDetails.setValue(fullData, forKey: "deviceSessionId")
                sessionArr.add(sessionDetails)
                
            }
            
            for i in 0..<postingArrWithAllData.count {
                if isSyncPostingArrWithData == false{
                    isSyncPostingArrWithData = true
                    let sessionDetails = NSMutableDictionary()
                    let captureNecropsyData = postingArrWithAllData.object(at: i)  as! PostingSessionTurkey
                    let nId = captureNecropsyData.postingId!
                    _ = captureNecropsyData.timeStamp
                    
                    let cNec =  CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncandPostingIdTurkey(true , postingId:nId)
                    let obsWithImageArr = NSMutableArray()
                    for x in 0..<cNec.count
                    {
                        let cNData = cNec.object(at: x) as! CaptureNecropsyDataTurkey
                        let farmName = cNData.farmName
                        let noOfBird = Int(cNData.noOfBirds!)
                        let necId = Int(cNData.necropsyId!)
                        for j in 0..<noOfBird!
                        {
                            let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
                            
                            for w in 0..<catArr.count
                            {
                                let obsArr = CoreDataHandlerTurkey().fecthobsDataWithCatnameAndFarmNameAndBirdNumberTurkey((j + 1) as NSNumber, farmname: farmName!, catName: catArr.object(at: w) as! String, necId: necId as NSNumber)
                                
                                for y in 0..<obsArr.count
                                {
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
                        }
                    }
                    
                    var fullData = captureNecropsyData.timeStamp!
                    sessionDetails.setValue(obsWithImageArr, forKey: "ImageDetails")
                    let id = UserDefaults.standard.integer(forKey: "Id")
                    sessionDetails.setValue(id, forKey: "UserId")
                    sessionDetails.setValue(fullData, forKey: "deviceSessionId")
                    sessionArr.add(sessionDetails)
                }
                
            }
        }
        sessionDict.setValue(sessionArr, forKey: "Sessions")
        
        do {
            
            if WebClass.sharedInstance.connected() {
                
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = ["Authorization":accestoken]
                
                let Url = "PostingSession/SaveBirdImageSyncData"
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: sessionDict, options: [])
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod()
                    }
                    else if statusCode == 502 {
                        self.delegeteSyncApiTurkey.didFinishApiLoader()
                        self.showRetryAlert(apiName: "saveObservationImageOnServer", message: Constants.internetErrorMessage)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501  || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiTurkey.failWithError(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        
                        self.isSyncPostingArrWithData = false
                        self.isSyncPostingIdArr = false
                        self.isDelegateCalled = false
                        if cNecArr.count > 0 && self.postingIdArr.count == 0{
                            self.updadateNacDataOnCoreData(cNecArr: cNecArr, { (success) in
                                if success == true{
                                    self.delegeteSyncApiTurkey.didFinishApi()
                                }
                            })
                        }
                        else if cNecArr.count > 0 && self.postingIdArr.count > 0 {
                            self.updadateDataOnCoreData(cNecArr: cNecArr,{ (success) in
                                if success == true{
                                    self.delegeteSyncApiTurkey.didFinishApi()
                                }
                            })
                            
                        }
                        else if cNecArr.count == 0 && self.postingIdArr.count > 0 {
                            self.updadateDataOnCoreData(cNecArr: cNecArr,{ (success) in
                                if success == true{
                                    if self.isDelegateCalled == false{
                                        self.isDelegateCalled = true
                                        self.delegeteSyncApiTurkey.didFinishApi()
                                        
                                    }
                                }
                            })
                        }
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            // no internet connection
                            self.delegeteSyncApiTurkey.failWithErrorInternal()
                            
                        } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            // other failures
                            print (encodingError)
                            print (responseString)
                            if let s = statusCode {
                                
                                self.delegeteSyncApiTurkey.failWithError(statusCode: s)
                            } else {
                                self.delegeteSyncApiTurkey.failWithErrorInternal()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func updadateDataOnCoreData(cNecArr: NSArray, _ completion: (_ status: Bool) -> Void){
        
        for i in 0..<self.postingIdArr.count
        {
            if isSyncPostingIdArr == false {
                isSyncPostingIdArr = true
                let pId = self.postingIdArr.object(at: i) as! NSNumber
                CoreDataHandlerTurkey().updateisSyncOnMyBindersViaPostingIdTurkey(pId, isSync: false, { (success) in
                    if success == true{
                        CoreDataHandlerTurkey().updateisSyncOnAlternativeFeedPostingidTurkey(pId , isSync: false, { (success) in
                            if success == true{
                                
                                CoreDataHandlerTurkey().updateisSyncOnAntiboticViaPostingIdTurkey(pId , isSync: false, { (success) in
                                    if success == true{
                                        CoreDataHandlerTurkey().updateisSyncOnAllCocciControlviaPostingidTurkey(pId , isSync: false, { (success) in
                                            if success == true{
                                                
                                                CoreDataHandlerTurkey().updateisSyncOnHetcharyVacDataWithPostingIdTurkey(pId , isSync: false, { (success) in
                                                    if success == true{
                                                        
                                                        CoreDataHandlerTurkey().updateisSyncOnPostingSessionTurkey(pId , isSync: false, { (success) in
                                                            if success == true{
                                                                
                                                                CoreDataHandlerTurkey().updateisSyncOnCaptureSkeletaInDatabaseTurkey(pId , isSync: false, { (success) in
                                                                    if success == true{
                                                                        
                                                                        CoreDataHandlerTurkey().updateisSyncOnBirdPhotoCaptureDatabaseTurkey(pId , isSync: false, { (success) in
                                                                            if success == true{
                                                                                
                                                                                CoreDataHandlerTurkey().updateisSyncOnNotesBirdDatabaseTurkey(pId , isSync: false, { (success) in
                                                                                    if success == true{
                                                                                        if cNecArr.count > 0{
                                                                                            self.updadateNacDataOnCoreData(cNecArr: cNecArr, { (success) in
                                                                                                if success == true{
                                                                                                    completion(success)
                                                                                                }
                                                                                            })
                                                                                        }else{
                                                                                            completion(success)
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                        })
                                                                    }
                                                                })
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
        
    }
    
    func updadateNacDataOnCoreData(cNecArr: NSArray, _ completion: (_ status: Bool) -> Void){
        
        for i in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: i)  as! CaptureNecropsyDataTurkey
            let nId = captureNecropsyData.necropsyId!
            
            CoreDataHandlerTurkey().updateisSyncOnCaptureSkeletaInDatabaseTurkey(nId , isSync: false, { (success) in
                if success == true{
                    
                    CoreDataHandlerTurkey().updateisSyncNecropsystep1neccIdTurkey(nId , isSync: false, { (success) in
                        if success == true{
                            
                            CoreDataHandlerTurkey().updateisSyncOnCaptureInDatabaseTurkey(nId , isSync: false, { (success) in
                                if success == true{
                                    
                                    CoreDataHandlerTurkey().updateisSyncOnBirdPhotoCaptureDatabaseTurkey(nId , isSync: false, { (success) in
                                        if success == true{
                                            CoreDataHandlerTurkey().updateisSyncOnNotesBirdDatabaseTurkey(nId , isSync: false, { (success) in
                                                if success == true{
                                                    
                                                    CoreDataHandlerTurkey().updateisAllSyncFalseOnPostingSessionTurkey(true, { (success) in
                                                        if success == true{
                                                            completion(success)
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    }
    
    fileprivate func handleUpdateIsSyncOnBirdPhotoCapture(pId:NSNumber,cNecArr: NSArray, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnNotesBirdDatabaseTurkey(pId , isSync: false, { (success) in
            if success == true {
                if cNecArr.count > 0 {
                    self.updadateNacDataOnCoreData(cNecArr: cNecArr, { (success) in
                        if success == true {
                            completion(success)
                        }
                    })
                } else {
                    completion(success)
                }
            }
        })
    }
    
    fileprivate func handleUpdateisSyncOnBirdPhotoCaptureDatabaseTurkey(pId:NSNumber,cNecArr: NSArray, _ completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnBirdPhotoCaptureDatabaseTurkey(pId , isSync: false, { (success) in
            if success == true {
                handleUpdateIsSyncOnBirdPhotoCapture(pId: pId, cNecArr: cNecArr) { status in
                    completion(status)
                }
            }
        })
    }
    
    
    fileprivate func handleUpdateisSyncOnPostingSessionTurkey(pId: NSNumber, cNecArr: NSArray, _ completion: @escaping (_ status: Bool) -> Void) {
        updateSyncOnPostingSession(pId: pId) { success in
            guard success else {
                completion(false)
                return
            }
            
            self.handleUpdateSyncOnCaptureSkeleta(pId: pId, cNecArr: cNecArr, completion: completion)
        }
    }
    
    private func handleUpdateSyncOnCaptureSkeleta(pId: NSNumber, cNecArr: NSArray, completion: @escaping (_ status: Bool) -> Void) {
        updateSyncOnCaptureSkeleta(pId: pId) { success in
            guard success else {
                completion(false)
                return
            }
            
            self.handleUpdateisSyncOnBirdPhotoCaptureDatabaseTurkey(pId: pId, cNecArr: cNecArr, completion)
        }
    }
    
    
    private func updateSyncOnPostingSession(pId: NSNumber, _ completion: @escaping (_ success: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnPostingSessionTurkey(pId, isSync: false, completion)
    }
    
    private func updateSyncOnCaptureSkeleta(pId: NSNumber, _ completion: @escaping (_ success: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnCaptureSkeletaInDatabaseTurkey(pId, isSync: false, completion)
    }
    
    fileprivate func handleUpdateIsSyncOnAntibioticCoredataSave(pId: NSNumber, cNecArr: NSArray, _ completion: @escaping (_ status: Bool) -> Void) {
        updateSyncOnAntibiotic(pId: pId) { success in
            guard success else {
                completion(false)
                return
            }
            
            self.updateSyncOnCocciControl(pId: pId) { cocciSuccess in
                guard cocciSuccess else {
                    completion(false)
                    return
                }
                self.handleHatcherySyncAndContinue(pId: pId, cNecArr: cNecArr, completion: completion)
            }
        }
    }
    
    private func handleHatcherySyncAndContinue(pId: NSNumber, cNecArr: Any, completion: @escaping (Bool) -> Void) {
        self.updateSyncOnHatcheryVac(pId: pId) { hatcherySuccess in
            guard hatcherySuccess else {
                completion(false)
                return
            }
            
            guard let safeCnecArr = cNecArr as? [Any] else {
                completion(false)
                return
            }
            
            self.continueSyncUpdate(pId: Int(truncating: pId), cNecArr: safeCnecArr, completion: completion)
        }
    }
    
    private func continueSyncUpdate(pId: Int, cNecArr: [Any], completion: @escaping (Bool) -> Void) {
        self.handleUpdateisSyncOnPostingSessionTurkey(pId: pId as NSNumber, cNecArr: cNecArr as NSArray) { status in
            completion(status)
        }
    }
    
    private func updateSyncOnAntibiotic(pId: NSNumber, _ completion: @escaping (_ success: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAntiboticViaPostingIdTurkey(pId, isSync: false, completion)
    }
    
    private func updateSyncOnCocciControl(pId: NSNumber, _ completion: @escaping (_ success: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAllCocciControlviaPostingidTurkey(pId, isSync: false, completion)
    }
    
    private func updateSyncOnHatcheryVac(pId: NSNumber, _ completion: @escaping (_ success: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnHetcharyVacDataWithPostingIdTurkey(pId, isSync: false, completion)
    }
    
    func updateDataOnCoreData(cNecArr: NSArray, _ completion: @escaping (_ status: Bool) -> Void) {
        for i in 0..<self.postingIdArr.count {
            if isSyncPostingIdArr == false {
                isSyncPostingIdArr = true
                let pId = self.postingIdArr.object(at: i) as! NSNumber
                updateSyncFlagsForPostingId(pId, cNecArr: cNecArr, completion: completion)
            }
        }
    }
    
    private func updateSyncFlagsForPostingId(_ pId: NSNumber, cNecArr: NSArray, completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnMyBindersViaPostingIdTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.continueAlternativeFeedSyncUpdate(pId: pId, cNecArr: cNecArr, completion: completion)
        }
    }
    
    private func continueAlternativeFeedSyncUpdate(pId: NSNumber, cNecArr: NSArray, completion: @escaping (_ status: Bool) -> Void) {
        CoreDataHandlerTurkey().updateisSyncOnAlternativeFeedPostingidTurkey(pId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.handleUpdateIsSyncOnAntibioticCoredataSave(pId: pId, cNecArr: cNecArr, completion)
        }
    }
    
    
    private func processNextNecropsy(_ dataArray: [CaptureNecropsyDataTurkey], index: Int, completion: @escaping (_ status: Bool) -> Void) {
        guard index < dataArray.count else {
            completion(true) // All items processed
            return
        }
        
        let captureNecropsyData = dataArray[index]
        guard let nId = captureNecropsyData.necropsyId else {
            processNextNecropsy(dataArray, index: index + 1, completion: completion)
            return
        }
        
        let handler = CoreDataHandlerTurkey()
        
        updateSyncFlagsSequentially(handler: handler, necropsyId: nId) { [self] success in
            if success {
                processNextNecropsy(dataArray, index: index + 1, completion: completion)
            } else {
                completion(false)
            }
        }
    }
    
    private func updateSyncFlagsSequentially(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (_ status: Bool) -> Void) {
        updateCaptureSkeletaSync(handler: handler, necropsyId: necropsyId) { success in
            guard success else {
                completion(false)
                return
            }
            self.continueUpdateAfterSkeleton(handler: handler, necropsyId: necropsyId, completion: completion)
        }
    }
    
    private func continueUpdateAfterSkeleton(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (_ status: Bool) -> Void) {
        updateNecropsystep1Sync(handler: handler, necropsyId: necropsyId) { success in
            guard success else {
                completion(false)
                return
            }
            self.continueUpdateAfterStep1(handler: handler, necropsyId: necropsyId, completion: completion)
        }
    }
    
    private func continueUpdateAfterStep1(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (_ status: Bool) -> Void) {
        updateCaptureSync(handler: handler, necropsyId: necropsyId) { success in
            guard success else {
                completion(false)
                return
            }
            self.handleUpdateIsSyncOnNotesBirdDataBase(handler: handler, necropsyId: necropsyId, completion: completion)
        }
    }
    
    
    private func updateCaptureSkeletaSync(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (Bool) -> Void) {
        handler.updateisSyncOnCaptureSkeletaInDatabaseTurkey(necropsyId, isSync: false, completion)
    }
    
    private func updateNecropsystep1Sync(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (Bool) -> Void) {
        handler.updateisSyncNecropsystep1neccIdTurkey(necropsyId, isSync: false, completion)
    }
    
    private func updateCaptureSync(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (Bool) -> Void) {
        handler.updateisSyncOnCaptureInDatabaseTurkey(necropsyId, isSync: false, completion)
    }
    
    private func handleUpdateIsSyncOnNotesBirdDataBase(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (_ status: Bool) -> Void) {
        
        handler.updateisSyncOnBirdPhotoCaptureDatabaseTurkey(necropsyId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.handleUpdateNotesBirdDatabase(handler: handler, necropsyId: necropsyId, completion: completion)
        }
    }
    
    private func handleUpdateNotesBirdDatabase(handler: CoreDataHandlerTurkey, necropsyId: NSNumber, completion: @escaping (_ status: Bool) -> Void) {
        handler.updateisSyncOnNotesBirdDatabaseTurkey(necropsyId, isSync: false) { success in
            guard success else {
                completion(false)
                return
            }
            self.handleUpdateSessionSync(handler: handler, completion: completion)
        }
    }
    
    private func handleUpdateSessionSync(handler: CoreDataHandlerTurkey, completion: @escaping (_ status: Bool) -> Void) {
        handler.updateisAllSyncFalseOnPostingSessionTurkey(true, completion)
    }
    
   // MARK:   *************** 👤 Login Method Call Again 🔑 ***************
    
    func loginMethod(){
        
        if WebClass.sharedInstance.connected() {
            
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
            let userName =  PasswordService.shared.getUsername()
            let pass = PasswordService.shared.getPassword()
            
            let Url = "Token"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            let header: HTTPHeaders = [Constants.contentType: "application/x-www-form-urlencoded","Accept": Constants.applicationJson]
            let parameters:[String: String] = ["grant_type": "password","UserName" : CryptoHelper.encrypt(input: userName) as! String, "Password" : CryptoHelper.encrypt(input: pass) as! String,"LoginType": "Web","DeviceId":udid as! String]
            sessionManager.request(urlString, method: .post,parameters: parameters, headers: header).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    let statusCode = response.response?.statusCode
                    let dict : NSDictionary = value as! NSDictionary
                    if statusCode == 400{
                        _ = dict["error_description"]
                    } else if statusCode == 401{
                        _ = dict["error_description"]
                        
                    } else {
                        
                        let acessToken = (dict.value(forKey: "access_token") as? String)!
                        let tokenType = (dict.value(forKey: "token_type") as? String)!
                        let aceesTokentype: String = tokenType + " " + acessToken
                        _ = dict.value(forKey: "HasAccess")! as AnyObject
                        
                        let keychainHelper = AccessTokenHelper()
                        keychainHelper.saveToKeychain(valued: aceesTokentype, keyed: Constants.accessToken)
                        self.feedprogram()
                    }
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    break
                }
            }
        }
    }
}


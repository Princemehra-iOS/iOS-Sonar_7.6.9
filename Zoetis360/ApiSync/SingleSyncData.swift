//
//  SingleSyncData.swift
//  Zoetis -Feathers
//
//  Created by    on 11/13/17.
//  Copyright © 2017   . All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Reachability
import SystemConfiguration
import CoreData

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

// MARK: - PROTOCOLS & METHODS
protocol SyncApiData{
    func failWithErrorSyncdata(statusCode:Int)
    func failWithErrorInternalSyncdata()
    func didFinishApiSyncdata()
    func failWithInternetConnectionSyncdata()
}

// MARK: - Single Sync Data
class SingleSyncData: NSObject {
    /***************** Create Singloton Objcet for this class ****************/
    // static let sharedInstance = ApiSync()
    // MARK: - VARIABLES
    var reachability: Reachability!
    var delegeteSyncApiData : SyncApiData!
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
    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ApiSync.networkStatusChanged(_:)),
                                               name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification),
                                               object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(ReachabilityStatusChangedNotification)
    }
    
    // MARK: - Network Status
    func networkStatusChanged(_ notification: Notification) {
        if let value = notification.userInfo?.values.first as? String {
            switch value {
            case "Online (WiFi)", "Online (WWAN)":
                print(value)
            default:
                break
            }
        }
    }
    
    // MARK: - Session Array with Posting ID
    func allSessionArr(postinId:NSNumber) ->NSMutableArray{
        
        let allPostingArrWithAllData = CoreDataHandler().fetchAllPostingSession(postinId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandler().FetchNecropsystep1NecId(postinId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
      
        for i in 0..<allPostingArrWithAllData.count
        {
            let pSession = allPostingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    // MARK: - Resize Image
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    // MARK: - Convert Image to String
    func imageToNSString(_ image: UIImage) -> String {
        let data = image.pngData()
        return data!.base64EncodedString(options: .lineLength64Characters)
    }
    /********************* Save Feed Program data On Server *****************************************************************************************************/
    // MARK: - Feed Program with PostingD
    func feedprogram(postingId:NSNumber)  {
        
        let postingArrWithAllData =   CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        var timestamp = String()
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData =  cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c =  necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
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
        for i in 0..<postingArrWithAllData.count
        {
            let pSession =  postingArrWithAllData.object(at: i) as! PostingSession
            sessionId = pSession.postingId!
            timestamp = pSession.timeStamp!
            var actualTimestampStr =  pSession.actualTimeStamp
            if actualTimestampStr == nil {
                actualTimestampStr = ""
            }
            self.postingIdArr.add(sessionId)
            tempArrTime.add(timestamp)
            actualTmestamp.add(actualTimestampStr!)
            
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession =  necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            sessionId = nIdSession.necropsyId!
            self.postingIdArr.add(sessionId)
        }
        
        let sessionArray = NSMutableArray()
        var sessionDict = NSMutableDictionary()
        var sessionDictMain = NSMutableDictionary()
        
        for i in 0..<self.postingIdArr.count
        {
            
            let mainDict = NSMutableDictionary()
            var FinalArray1 = NSMutableArray()
            let allCocciControl =  CoreDataHandler().fetchAllCocciControlviaIsync(true,postinID: self.postingIdArr[i] as! NSNumber)
            var dataSet = Int()
            var  index = Int()
            let mainFeeds = NSMutableArray()
            var feeds = NSMutableDictionary()
            for i in 0..<allCocciControl.count
                    
            {
                dataSet+=1
                
                let mainDict = NSMutableDictionary()
                let cocciControl =  allCocciControl.object(at: i) as! CoccidiosisControlFeed
                let coccidiosisVaccine = cocciControl.coccidiosisVaccine
                let dosage = cocciControl.dosage
                let fromDays = cocciControl.fromDays
                let molecule = cocciControl.molecule
                let toDays = cocciControl.toDays
                let moleculeId = cocciControl.dosemoleculeId
                let cocoId = cocciControl.coccidiosisVaccineId
                let feedType = cocciControl.feedType
                let startDate =  cocciControl.feedDate
                
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
            
            let fetchAntibotic = CoreDataHandler().fetchAntiboticViaIsSync(true,postingID: self.postingIdArr[i] as! NSNumber)
            for i in 0..<fetchAntibotic.count {
                dataSet+=1
                
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchAntibotic.object(at: i) as! AntiboticFeed
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let startDate =  antiboticFeed.feedDate
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
                        feeds = ["feedName" : feedProgram!, "feedId" : feedId, "startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
                    }
                    mainFeeds.replaceObject(at: index, with: feeds)
                    index+=1
                    FinalArray1 = NSMutableArray()
                    feeds = NSMutableDictionary()
                    
                }
            }
            
            let fetchAlternative = CoreDataHandler().fetchAlternativeFeedWithIsSync(true,postingID: self.postingIdArr[i] as! NSNumber)
            
            index = 0
            for i in 0..<fetchAlternative.count
                    
            {
                dataSet+=1
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchAlternative.object(at: i) as! AlternativeFeed
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let startDate = antiboticFeed.feedDate
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
            
            let fetchMyBinde = CoreDataHandler().fetchMyBindersViaIsSync(true,postingID: self.postingIdArr[i] as! NSNumber)
            index = 0
            for i in 0..<fetchMyBinde.count
                    
            {
                dataSet+=1
                
                let mainDict = NSMutableDictionary()
                let antiboticFeed = fetchMyBinde.object(at: i) as! MyCotoxinBindersFeed
                let dosage = antiboticFeed.dosage
                let feedId = antiboticFeed.feedId as! Int
                let startDate = antiboticFeed.feedDate
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
                mainDict.setValue(18, forKey: "feedProgramCategoryId")
                mainDict.setValue(0, forKey: "moleculeId")
                mainDict.setValue(feedType, forKey: "feedType")
                FinalArray1.add(mainDict)
                
                if dataSet == 6 {
                    dataSet = 0
                    
                    let tempArray = (mainFeeds.object(at: index) as AnyObject).value(forKey: "feedProgramDetails") as? NSMutableArray
                    if tempArray?.count > 0 {
                        tempArray?.addObjects(from: FinalArray1 as [AnyObject])
                        feeds = ["feedName" : feedProgram!, "feedId" : feedId,"startDate" : startDate ?? "","feedProgramDetails" : tempArray!]
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
                var  fullData  = String()
                fullData = acttimeStamp as! String
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
        
        do {
            
            let jsonData = try! JSONSerialization.data(withJSONObject: sessionDictMain, options: JSONSerialization.WritingOptions.prettyPrinted)
            var jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            jsonString = jsonString.trimmingCharacters(in: CharacterSet.whitespaces)
            
            if WebClass.sharedInstance.connected() {
                
                let Url = "PostingSession/SaveMultipleFeedsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: "aceesTokentype")!
                //accestoken = (UserDefaults.standard.value(forKey: "aceesTokentype") as? String)!
                let headerDict = ["Authorization":accestoken]
                
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try! JSONSerialization.data(withJSONObject: sessionDictMain, options: [])
                
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod(postingId: postingId)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        print(responseObject)
                        self.addVaccination(postingId:postingId )
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                            //  print(err)
                        } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            print (encodingError)
                            print (responseString)
                            if let s = statusCode {
                                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
                            }
                            else
                            {
                                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - ********************* Save Add Vacination data On Server ***************************
    func addVaccination(postingId:NSNumber)  {
        
        let vaccinationPostingArrAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        self.postingIdArr.removeAllObjects()
        var sessionId = NSNumber()
        let tempArrTime = NSMutableArray()
        let actualTemp  = NSMutableArray()
        var vaccinationName = String ()
        
        for i in 0..<vaccinationPostingArrAllData.count
        {
            let pSession = vaccinationPostingArrAllData.object(at: i) as! PostingSession
            sessionId = pSession.postingId!
            var timeStamp = pSession.timeStamp!
            var actualtimeStr = pSession.actualTimeStamp
            if actualtimeStr == nil{
                actualtimeStr = ""
            }
            actualTemp.add(actualtimeStr!)
            tempArrTime.add(timeStamp)
            self.postingIdArr.add(sessionId)
        }
        
        let sessionArr = NSMutableArray()
        let sessionDictWithVac = NSMutableDictionary()
        
        for i in 0..<self.postingIdArr.count
        {
            
            let pId = self.postingIdArr.object(at: i) as! NSNumber
            let addVacinationAll = CoreDataHandler().fetchFieldAddvacinationData(pId)
            let vaccinationDetail = NSMutableDictionary()
            
            for i in 0..<addVacinationAll.count {
                let pSession = addVacinationAll.object(at: i) as! FieldVaccination
                if i == 0{
                    vaccinationName = pSession.vaciNationProgram!
                }
                
                let routeName = pSession.route
                var routeId = NSNumber()
                let newLngId = UserDefaults.standard.integer(forKey: "lngId")
                
                if newLngId == 1 || newLngId == 3 {
                    if routeName == Constants.wingWeb {
                        routeId = 1
                    }
                    else if routeName == Constants.drinkingWater {
                        routeId = 2
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
                }
                else if newLngId == 4
                {
                    if routeName == Constants.spray {
                        routeId = 21
                    }
                    else if routeName == Constants.inOvoStr {
                        routeId = 22
                    }
                    else if routeName == "Intramuscular" {
                        routeId = 24
                    }
                    else if routeName == Constants.aguaDeBebida {
                        routeId = 20
                    }
                    else if routeName == "Membrana Da Asa" {
                        routeId = 19
                    }
                    else if routeName == "Ocular" {
                        routeId = 25
                    }
                    else if routeName == Constants.Subcutânea {
                        routeId = 23
                    }
                    else{
                        routeId = 0
                    }
                }
                
                else{
                }
                
                let strainKey = "hatcheryStrain\(i + 1)"
                let routeKey = "hatcheryRoute\(i+1)Id"
                
                vaccinationDetail .setObject(pSession.strain, forKey: strainKey as NSCopying)
                vaccinationDetail .setObject(routeId, forKey: routeKey as NSCopying)
            }
            
            let FieldVacinationAll = CoreDataHandler().fetchAddvacinationData(pId)
            for i in 0..<FieldVacinationAll.count
            {
                let pSession = FieldVacinationAll.object(at: i) as! HatcheryVac
             
                let routeName = pSession.route
               
                var routeId = NSNumber()
                let newLngId = UserDefaults.standard.integer(forKey: "lngId")
                
                if newLngId == 1  || newLngId == 3 {
                    if routeName == Constants.wingWeb {
                        routeId = 1
                    }
                    else if routeName == Constants.drinkingWater {
                        routeId = 2
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
                }
                else if newLngId == 4
                {
                    if routeName == Constants.spray {
                        routeId = 21
                    }
                    else if routeName == Constants.inOvoStr {
                        routeId = 22
                    }
                    else if routeName == "Intramuscular" {
                        routeId = 24
                    }
                    else if routeName == Constants.aguaDeBebida {
                        routeId = 20
                    }
                    else if routeName == "Membrana Da Asa" {
                        routeId = 19
                    }
                    else if routeName == "Ocular" {
                        routeId = 25
                    }
                    else if routeName == Constants.Subcutânea {
                        routeId = 23
                    }
                    else{
                        routeId = 0
                    }
                }
                
                let fieldStrainKey = "fieldStrain\(i + 1)"
                let fieldrouteKey = "fieldRoute\(i+1)Id"
                let fieldAgeKey = "fieldAge\(i + 1)"
                
                vaccinationDetail .setObject(pSession.strain!, forKey: fieldStrainKey as NSCopying)
                vaccinationDetail .setObject(routeId, forKey: fieldrouteKey as NSCopying)
                vaccinationDetail .setObject(pSession.age!, forKey: fieldAgeKey as NSCopying)
                
            }
            
            
            if FieldVacinationAll.count > 0 || addVacinationAll.count > 0
            {
                let vaccinationArray = NSMutableArray()
                vaccinationArray .add(vaccinationDetail)
                let mainDict = NSMutableDictionary()
                mainDict .setObject(vaccinationArray, forKey: "vaccinationDetail" as NSCopying)
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
        
        do {

            
            if WebClass.sharedInstance.connected() {
                
             // Avinash Asked to do this change    let Url = "/PostingSession//SaveMultipleVaccinationsSyncData"
                let Url = "/PostingSession/SaveMultipleVaccinationsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
              //  accestoken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
                let headerDict = [Constants.authorization:accestoken]
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                request.httpBody = try? JSONSerialization.data(withJSONObject: sessionDictWithVac, options: [])
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod(postingId: postingId)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        self.savePostingDataOnServer(postingId: postingId)
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                        }
                        else if response.data != nil {
                            if let s = statusCode {
                                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
                            }
                            else
                            {
                                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func handleAPIResponseSaveMultiplePosting(_ statusCode: Int?, _ response: AFDataResponse<Any>,postingId :NSNumber) {
        if statusCode == 401 {
            self.loginMethod(postingId: postingId)
        }
        else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
            self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
        }
        
        switch response.result {
            
        case .success(let responseObject):
            self.saveNecropsyDataOnServer(postingId: postingId)
            
        case .failure(let encodingError):
            
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
            else if response.data != nil {
                
                if let s = statusCode {
                    self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
                }
                else
                {
                    self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                }
            }
        }
    }
    
    fileprivate func handleSessionTypeValidation(_ sessiontype: String?, _ sessionTypeId: inout Int) {
        if sessiontype == "Farm Visit"  {
            sessionTypeId = 2
        } else if  sessiontype == "Visite De Ferme" {
            sessionTypeId = 3
        } else if  sessiontype == "Visite De Publication" {
            sessionTypeId = 4
        } else if  (sessiontype == "Visita Em Andamento") || (sessiontype == "Visita em andamento") {
            sessionTypeId = 5
        } else if  (sessiontype == "Visita Na Unidade") || (sessiontype ==  "Visita na unidade") {
            sessionTypeId = 6
        } else if sessiontype == "Posting Visit"  {
            sessionTypeId = 1
        } else {
            sessionTypeId = 0
        }
    }
    
    /********************* Save Posting data On Server ***************************/
    
    func savePostingDataOnServer(postingId :NSNumber){
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let savePostingArrWithAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        self.postingIdArr.removeAllObjects()
        let postingServerArray = NSMutableArray()
        let  postingDictOnServer = NSMutableDictionary()
        
        for i in 0..<savePostingArrWithAllData.count
        {
            let postingDataDict = NSMutableDictionary()
            let pSession = savePostingArrWithAllData.object(at: i) as! PostingSession
            let sessionDate = pSession.sessiondate
            var sessionTypeId  = Int ()
            let sessiontype = pSession.sessionTypeName
            
            handleSessionTypeValidation(sessiontype, &sessionTypeId)
            var customerId = pSession.customerId
            if customerId != nil {
                customerId = pSession.customerId
            }
            else {
                customerId = UserDefaults.standard.value(forKey: "SelectedCustmer") as? NSNumber
            }
            
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
            let avgAGe = (pSession.avgAge ?? "") as String
            let avgWght = (pSession.avgWeight ?? "") as String
            let outTime = (pSession.outTime ?? "") as String
            let fcr = (pSession.fcr ?? "") as String
            let livability = (pSession.livability ?? "") as String
            let mortality = (pSession.dayMortality ?? "") as String
            
            self.postingIdArr.add(sessionId!)
           
            var fullData =  pSession.timeStamp!
            
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
            postingDataDict.setValue(proId, forKey: "productionTypeId")
            postingDataDict.setValue(proName, forKey: "productionTypeName")
            postingDataDict.setValue(fcr, forKey: "FCR")
            postingDataDict.setValue(avgWght, forKey: "AvgWeight")
            postingDataDict.setValue(avgAGe, forKey: "AvgAge")
            postingDataDict.setValue(outTime, forKey: "AvgOutTime")
            postingDataDict.setValue(livability, forKey: "Livability")
            postingDataDict.setValue(mortality, forKey: "Avg7DayMortality")
            
            let id = UserDefaults.standard.integer(forKey: "Id")
            postingDataDict.setValue(id, forKey: "UserId")
            postingDataDict.setValue(udid1, forKey: "udid")
            postingServerArray.add(postingDataDict)
        }
        
        postingDictOnServer.setValue(postingServerArray, forKey: "PostingSessions")
        
        do {
            
            if WebClass.sharedInstance.connected() {
                let Url = "PostingSession/SaveMultiplePostingsSyncData"
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
                let headerDict = [Constants.authorization:accestoken]
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                request.httpBody = try? JSONSerialization.data(withJSONObject: postingDictOnServer, options: [])
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode = response.response?.statusCode
                    
                    self.handleAPIResponseSaveMultiplePosting(statusCode, response, postingId: postingId)
                }
                
            }
        }
    }
    // MARK: - /********************* Save Farms  data On Server ***************************/ /**************************************************************************/
    func saveNecropsyDataOnServer(postingId: NSNumber){
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cNecArr = CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let a = NSMutableArray()
        var complexId = Int()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            a.add(captureNecropsyData)
            for w in 0..<a.count - 1
            {
                let c = a.object(at: w)  as! CaptureNecropsyData
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
            let allArray = NSMutableArray()
            let captureNecropsyData = a.object(at: i)  as! CaptureNecropsyData
            complexId = Int(captureNecropsyData.complexId!)
            let cNec =  CoreDataHandler().FetchNecropsystep1NecId(postingId)
            let formWithcatNameWithBirdAndAllObs1 = NSMutableDictionary()
            for x in 0..<cNec.count
            {
                
                let birdArry = NSMutableArray()
                let cNData = cNec.object(at: x) as! CaptureNecropsyData
                let farmName = cNData.farmName
                let noOfBird = Int(cNData.noOfBirds!)
                let houseNo = cNData.houseNo
                let feedProgram = cNData.feedProgram
             
                
                let age = cNData.age
                let imgId = cNData.imageId
                complexId = cNData.complexId as! Int
                let flock = cNData.flockId
                let sick = cNData.sick
               
                let customerId = cNData.custmerId
                let customerName = cNData.complexName
                let complexdate = cNData.complexDate
                let farmId = cNData.farmId
                let formWithcatNameWithBirdAndAllObs = NSMutableDictionary()
                for j in 0..<noOfBird!
                {
                    let obsNameWithValue =   CoreDataHandler().fetchObsWithBirdandFarmName(farmName!, birdNo: (j + 1) as NSNumber, necId: cNData.necropsyId!)
                    let notesWithFarm = CoreDataHandler().fetchNotesWithBirdNumandFarmName((j + 1) as NSNumber, formName: farmName!, necId: cNData.necropsyId!)
                    if notesWithFarm.count > 0
                    {
                        let n = notesWithFarm.object(at: 0) as! NotesBird
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
                formWithcatNameWithBirdAndAllObs.setValue(feedId, forKey: "DeviceFeedId")
                formWithcatNameWithBirdAndAllObs.setValue(age, forKey: "age")
                formWithcatNameWithBirdAndAllObs.setValue(customerId, forKey: "customerId")
                formWithcatNameWithBirdAndAllObs.setValue(customerName, forKey: "customerName")
                formWithcatNameWithBirdAndAllObs.setValue(sick, forKey: "sick")
                formWithcatNameWithBirdAndAllObs.setValue(flock, forKey: "flockId")
                formWithcatNameWithBirdAndAllObs.setValue(complexdate, forKey: "ComplexDate")
                allArray.add(formWithcatNameWithBirdAndAllObs)
            }
            
           
            var fullData =   captureNecropsyData.timeStamp!
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
        
        sessionWithAllforms.setValue(sessionArr, forKey: "Session")
        
        do {
     
            
            if WebClass.sharedInstance.connected() {
                accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
              //  accestoken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
                let headerDict = [Constants.authorization:accestoken]
                let Url = "PostingSession/SaveMultipleNecropsySyncData"
                let urlString: String = WebClass.sharedInstance.webUrl + Url
                var request = URLRequest(url: URL(string: urlString)! )
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headerDict
                request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
                request.httpBody = try? JSONSerialization.data(withJSONObject: sessionWithAllforms, options: [])
                
                sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                    let statusCode =  response.response?.statusCode
                    
                    if statusCode == 401  {
                        self.loginMethod(postingId:postingId)
                    }
                    else if statusCode == 500 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                        self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                    }
                    
                    switch response.result {
                        
                    case .success(let responseObject):
                        self.saveObservationImageOnServer(postingId: postingId)
                        
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                        } else if response.data != nil {
                            
                            if let s = statusCode {
                                self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: s)
                            }
                            else
                            {
                                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK: -   /********************* Save Image  On Server ***************************/
    /**************************************************************************/
    
    func saveObservationImageOnServer(postingId: NSNumber) {
        let imageArrWithIsyncIsTrue = CoreDataHandler().fecthPhotoWithiSynsTrue(true)
        let sessionDict = NSMutableDictionary()
        let sessionArr = NSMutableArray()
        let cNecArr = CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let totalSession = NSMutableArray()

        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j) as! CaptureNecropsyData
            totalSession.add(captureNecropsyData)
            for w in 0..<totalSession.count - 1 {
                let c = totalSession.object(at: w) as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId {
                    totalSession.remove(c)
                }
            }
        }

        postingArrWithAllData.removeAllObjects()
        postingArrWithAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray

        if imageArrWithIsyncIsTrue.count > 0 {
            for i in 0..<totalSession.count {
                let captureNecropsyData = totalSession.object(at: i) as! CaptureNecropsyData
                let cNec = CoreDataHandler().FetchNecropsystep1NecId(postingId)
                let obsWithImageArr = NSMutableArray()
                for x in 0..<cNec.count {
                    let cNData = cNec.object(at: x) as! CaptureNecropsyData
                    let farmName = cNData.farmName
                    let noOfBird = Int(cNData.noOfBirds!)
                    let necId = Int(cNData.necropsyId!)
                    for j in 0..<noOfBird! {
                        let catArr = ["skeltaMuscular", "Coccidiosis", "GITract", "Resp", "Immune"]
                        for cat in catArr {
                            let obsArr = CoreDataHandler().fecthobsDataWithCatnameAndFarmNameAndBirdNumber((j + 1) as NSNumber, farmname: farmName!, catName: cat, necId: necId as NSNumber)
                            for y in 0..<obsArr.count {
                                let obsWithAllImageDataDict = NSMutableDictionary()
                                let cData = obsArr.object(at: y) as! CaptureNecropsyViewData
                                let photoArr = CoreDataHandler().fecthPhotoWithCatnameWithBirdAndObservationIDandIsync((j + 1) as NSNumber, farmname: farmName!, catName: cat, Obsid: cData.obsID!, isSync: true, necId: necId as NSNumber)
                                obsWithAllImageDataDict.setValue(farmName!, forKey: "farmName")
                                obsWithAllImageDataDict.setValue(j + 1, forKey: "birdNumber")
                                obsWithAllImageDataDict.setValue(cat, forKey: "categoryName")
                                obsWithAllImageDataDict.setValue(cData.obsID!, forKey: "observationId")
                                let photoValArr = NSMutableArray()
                                for z in 0..<photoArr.count {
                                    let objBirdPhotoCapture = photoArr.object(at: z) as! BirdPhotoCapture
                                    var image = UIImage(data: objBirdPhotoCapture.photo! as Data)!
                                    if let imageData = image.jpeg(.lowest) {
                                        image = UIImage(data: imageData)!
                                    }
                                    let resizedImage = self.resizeImage(image, newWidth: image.size.width / 7)!
                                    let imageDict = NSMutableDictionary()
                                    imageDict.setValue(self.imageToNSString(resizedImage), forKey: "Image")
                                    photoValArr.add(imageDict)
                                }
                                obsWithAllImageDataDict.setValue(photoValArr, forKey: "images")
                                obsWithImageArr.add(obsWithAllImageDataDict)
                            }
                        }
                    }
                }
            }

            for i in 0..<postingArrWithAllData.count {
                let sessionDetails = NSMutableDictionary()
                let captureNecropsyData = postingArrWithAllData.object(at: i) as! PostingSession
                let cNec = CoreDataHandler().FetchNecropsystep1NecId(postingId)
                let obsWithImageArr = NSMutableArray()
                for x in 0..<cNec.count {
                    let cNData = cNec.object(at: x) as! CaptureNecropsyData
                    let farmName = cNData.farmName
                    let noOfBird = Int(cNData.noOfBirds!)
                    let necId = Int(cNData.necropsyId!)
                    for j in 0..<noOfBird! {
                        let catArr = ["skeltaMuscular", "Coccidiosis", "GITract", "Resp", "Immune"]
                        for cat in catArr {
                            let obsArr = CoreDataHandler().fecthobsDataWithCatnameAndFarmNameAndBirdNumber((j + 1) as NSNumber, farmname: farmName!, catName: cat, necId: necId as NSNumber)
                            for y in 0..<obsArr.count {
                                let obsWithAllImageDataDict = NSMutableDictionary()
                                let cData = obsArr.object(at: y) as! CaptureNecropsyViewData
                                let photoArr = CoreDataHandler().fecthPhotoWithCatnameWithBirdAndObservationIDandIsync((j + 1) as NSNumber, farmname: farmName!, catName: cat, Obsid: cData.obsID!, isSync: true, necId: necId as NSNumber)
                                obsWithAllImageDataDict.setValue(farmName!, forKey: "farmName")
                                obsWithAllImageDataDict.setValue(j + 1, forKey: "birdNumber")
                                obsWithAllImageDataDict.setValue(cat, forKey: "categoryName")
                                obsWithAllImageDataDict.setValue(cData.obsID!, forKey: "observationId")
                                let photoValArr = NSMutableArray()
                                for z in 0..<photoArr.count {
                                    let objBirdPhotoCapture = photoArr.object(at: z) as! BirdPhotoCapture
                                    var image = UIImage(data: objBirdPhotoCapture.photo! as Data)!
                                    if let imageData = image.jpeg(.lowest) {
                                        image = UIImage(data: imageData)!
                                    }
                                    let resizedImage = self.resizeImage(image, newWidth: image.size.width / 7)!
                                    let imageDict = NSMutableDictionary()
                                    imageDict.setValue(self.imageToNSString(resizedImage), forKey: "Image")
                                    photoValArr.add(imageDict)
                                }
                                obsWithAllImageDataDict.setValue(photoValArr, forKey: "images")
                                obsWithImageArr.add(obsWithAllImageDataDict)
                            }
                        }
                    }
                }
                let fullData = captureNecropsyData.timeStamp!
                sessionDetails.setValue(obsWithImageArr, forKey: "ImageDetails")
                let id = UserDefaults.standard.integer(forKey: "Id")
                sessionDetails.setValue(id, forKey: "UserId")
                sessionDetails.setValue(fullData, forKey: "deviceSessionId")
                sessionArr.add(sessionDetails)
            }
        }
        sessionDict.setValue(sessionArr, forKey: "Sessions")

        if WebClass.sharedInstance.connected() {
            accestoken = AccessTokenHelper().getFromKeychain(keyed: "aceesTokentype")!
            let headerDict = ["Authorization": accestoken]
            let urlString = WebClass.sharedInstance.webUrl + "PostingSession/SaveBirdImageSyncData"
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: sessionDict, options: [])
            request.timeoutInterval = 300
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode = response.response?.statusCode

                if statusCode == 401 {
                    self.loginMethod(postingId: postingId)
                    return
                } else if [400, 403, 404, 408, 500, 501, 502, 503, 504].contains(statusCode) {
                    self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
                    return
                }

                switch response.result {
                case .success:
                    self.updateSyncSequence(postingId: postingId) {
                        self.delegeteSyncApiData.didFinishApiSyncdata()
                    }
                case .failure(let encodingError):
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                    } else if let data = response.data {
                        print(encodingError)
                        if let urlError = encodingError.underlyingError as? URLError, urlError.code == .timedOut {
                            DispatchQueue.main.async {
                                
                                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
                                // self.showAlert(title: "Timeout", message: "The request timed out. Please try again.")
                            }
                        }
                        
                    }
                }
            }
        }
    }

    func updateSyncSequence(postingId: NSNumber, completion: @escaping () -> Void) {
        typealias SyncStep = (@escaping () -> Void) -> Void
        print(postingId)
        let steps: [SyncStep] = [
            { next in CoreDataHandler().updateisSyncOnMyBindersViaPostingId(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnAlternativeFeedPostingid(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnAntiboticViaPostingId(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnAllCocciControlviaPostingid(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnHetcharyVacDataWithPostingId(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnPostingSession(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().CaptureSkeletaDataUpdatedInDatabase(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncNecropsystep1neccId(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnCaptureInDatabase(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnNotesBirdDatabase(postingId, isSync: false) { _ in next() }},
            { next in CoreDataHandler().updateisSyncOnBirdPhotoCaptureDatabase(postingId, isSync: false) { _ in next() }}
        ]

        func runSteps(_ remainingSteps: [SyncStep]) {
            guard let first = remainingSteps.first else {
                completion()
                return
            }
            first {
                runSteps(Array(remainingSteps.dropFirst()))
            }
        }
    
        runSteps(steps)
    }

    // MARK: - /********************* Save User Setting   On Server ***************************/
    fileprivate func handleskeletenArr(_ skeletenArr: NSMutableArray, _ lngId: Int, _ arr1: NSMutableArray) {
        for i in 0..<skeletenArr.count {
            let obsId = (skeletenArr.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (skeletenArr.object(at: i) as AnyObject).value(forKey: "visibilityCheck")
            let quickLink = (skeletenArr.object(at: i) as AnyObject).value(forKey: "quicklinks")
            let quicklinkIndex = (skeletenArr.object(at: i) as AnyObject).value(forKey: "quicklinkIndex")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            Internaldict.setValue(quicklinkIndex, forKey: "SequenceId")
            arr1.add(Internaldict)
        }
    }
    
    fileprivate func handlecocoii(_ cocoii: NSMutableArray, _ lngId: Int, _ arr1: NSMutableArray) {
        for i in 0..<cocoii.count {
            let obsId = (cocoii.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (cocoii.object(at: i) as AnyObject).value(forKey: "visibilityCheck")
            let quickLink = (cocoii.object(at: i) as AnyObject).value(forKey: "quicklinks")
            let quicklinkIndex = (cocoii.object(at: i) as AnyObject).value(forKey: "quicklinkIndex")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            Internaldict.setValue(quicklinkIndex, forKey: "SequenceId")
            arr1.add(Internaldict)
        }
    }
    
    fileprivate func handlegitract(_ gitract: NSMutableArray, _ lngId: Int, _ arr1: NSMutableArray) {
        for i in 0..<gitract.count {
            let obsId = (gitract.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (gitract.object(at: i) as AnyObject).value(forKey: "visibilityCheck")
            let quickLink = (gitract.object(at: i) as AnyObject).value(forKey: "quicklinks")
            let quicklinkIndex = (gitract.object(at: i) as AnyObject).value(forKey: "quicklinkIndex")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            Internaldict.setValue(quickLink, forKey: "visibilityCheck")
            Internaldict.setValue(quicklinkIndex, forKey: "SequenceId")
            arr1.add(Internaldict)
        }
    }
    
    fileprivate func handleresp(_ resp: NSMutableArray, _ lngId: Int, _ arr1: NSMutableArray) {
        for i in 0..<resp.count {
            let obsId = (resp.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (resp.object(at: i) as AnyObject).value(forKey: "visibilityCheck")
            let quickLink = (resp.object(at: i) as AnyObject).value(forKey: "quicklinks")
            let quicklinkIndex = (resp.object(at: i) as AnyObject).value(forKey: "quicklinkIndex")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            Internaldict.setValue(quicklinkIndex, forKey: "SequenceId")
            arr1.add(Internaldict)
        }
    }
    
    fileprivate func handleimmu(_ immu: NSMutableArray, _ lngId: Int, _ arr1: NSMutableArray) {
        for i in 0..<immu.count {
            let obsId = (immu.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (immu.object(at: i) as AnyObject).value(forKey: "visibilityCheck")
            let quickLink = (immu.object(at: i) as AnyObject).value(forKey: "quicklinks")
            let quicklinkIndex = (immu.object(at: i) as AnyObject).value(forKey: "quicklinkIndex")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            Internaldict.setValue(quicklinkIndex, forKey: "SequenceId")
            arr1.add(Internaldict)
        }
    }
    
    fileprivate func handleSaveAllSettings(_ response: AFDataResponse<Any>, _ statusCode: Int?) {
        switch response.result {
            
        case .success(let responseObject):
            print(responseObject)
            
        case .failure(let encodingError):
            
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet
            {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
            else if response.data != nil
            {
                self.delegeteSyncApiData.failWithErrorInternalSyncdata()
            }
        }
    }
    
    fileprivate func handleErrorCodes(_ statusCode: Int?) {
        if statusCode == 401 {
        } else if statusCode == 500 || statusCode == 503 || statusCode == 403 || statusCode == 501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408 {
            self.delegeteSyncApiData.failWithErrorSyncdata(statusCode: statusCode!)
        }
    }
    
    func saveDatOnServerAllSeting() {
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let outerDict = NSMutableDictionary()
        let arr1 = NSMutableArray()
        let Id = UserDefaults.standard.integer(forKey: "Id")
        outerDict.setValue(Id, forKey: "UserId")
        
        let cocoii =  CoreDataHandler().fetchAllCocoiiData().mutableCopy() as! NSMutableArray
        let gitract =  CoreDataHandler().fetchAllGITractData().mutableCopy() as! NSMutableArray
        let resp =  CoreDataHandler().fetchAllRespiratory().mutableCopy() as! NSMutableArray
        let immu =  CoreDataHandler().fetchAllImmune().mutableCopy() as! NSMutableArray
        let skeletenArr =  CoreDataHandler().fetchAllSeettingdata().mutableCopy() as! NSMutableArray
        
        handleskeletenArr(skeletenArr, lngId, arr1)
        handlecocoii(cocoii, lngId, arr1)
        handlegitract(gitract, lngId, arr1)
        handleresp(resp, lngId, arr1)
        handleimmu(immu, lngId, arr1)
        
        outerDict.setValue(arr1, forKey: "ObservationUserDetails")
        
        if WebClass.sharedInstance.connected() {
            
            let Url = "Setting/SaveUserSetting"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
           // accestoken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
            let headerDict = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            var request = URLRequest(url: URL(string: urlString)! )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: outerDict, options: [])
            
            sessionManager.request(request as URLRequestConvertible).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                self.handleErrorCodes(statusCode)
                self.handleSaveAllSettings(response, statusCode)
            }
        }
    }
    
    // MARK: -   /*************** Login Method call Again  ***************************************************/
    
    func loginMethod(postingId:NSNumber) {
        
        if WebClass.sharedInstance.connected() {
            
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
            let userName =  PasswordService.shared.getUsername()
            let pass =  PasswordService.shared.getPassword()
            
            let Url = "Token"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            let headers: HTTPHeaders = [Constants.contentType: "application/x-www-form-urlencoded","Accept": Constants.applicationJson]
            let parameters:[String:String] = ["grant_type": "password","UserName" : CryptoHelper.encrypt(input: userName) as! String, "Password" : CryptoHelper.encrypt(input: pass) as! String,"LoginType": "Web","DeviceId":udid as! String]
            
            sessionManager.request(urlString, method: .post,parameters: parameters, headers: headers).responseJSON { response in
                switch response.result {
                case let .success(value):
                    let statusCode = response.response?.statusCode
                    let dict : NSDictionary = value as! NSDictionary
                    if statusCode == 400 {
                        _ = dict["error_description"]
                    } else if statusCode == 401 {
                        _ = dict["error_description"]
                    } else {
                        let acessToken = (dict.value(forKey: "access_token") as? String)!
                        let tokenType = (dict.value(forKey: "token_type") as? String)!
                        let aceesTokentype: String = tokenType + " " + acessToken
                        _ = dict.value(forKey: "HasAccess")! as AnyObject
                        AccessTokenHelper.saveData(aceesTokentype)
                        
                        let keychainHelper = AccessTokenHelper()
                     
                        keychainHelper.saveToKeychain(valued: aceesTokentype, keyed: Constants.accessToken)
                                                      
                       // UserDefaults.standard.set(aceesTokentype,forKey: Constants.accessToken)
                        UserDefaults.standard.synchronize()
                        self.feedprogram(postingId: postingId)
                    }
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    // MARK: - Update Core Data
    fileprivate func handleUpdateisSyncOnHetchary(_ success: Bool,pId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        if success == true {
            CoreDataHandler().updateisSyncOnPostingSession(pId , isSync: false, { (success) in
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
    }
    
    fileprivate func handleUpdateSyncOnAntibiotic(_ success: Bool,pId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        if success == true {
            CoreDataHandler().updateisSyncOnAllCocciControlviaPostingid(pId , isSync: false, { (success) in
                if success == true {
                    CoreDataHandler().updateisSyncOnHetcharyVacDataWithPostingId(pId , isSync: false, { (success) in
                        handleUpdateisSyncOnHetchary(success,pId: pId) { (status) in
                            completion(status)
                        }
                    })
                }
            })
        }
    }
    
    func updadateDataOnCoreData(pId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        CoreDataHandler().updateisSyncOnMyBindersViaPostingId(pId, isSync: false, { (success) in
            if success == true{
                CoreDataHandler().updateisSyncOnAlternativeFeedPostingid(pId , isSync: false, { (success) in
                    if success == true {
                        CoreDataHandler().updateisSyncOnAntiboticViaPostingId(pId , isSync: false, { (success) in
                            handleUpdateSyncOnAntibiotic(success,pId: pId) { (status) in
                                completion(status)
                            }
                        })
                    }
                })
            }
        })
    }
    
    // MARK: - Update Necropsy Data on Core DB
    fileprivate func handleUpdateSyncOnBirdPhoto(_ success: Bool,nId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        if success == true {
            CoreDataHandler().updateisSyncOnNotesBirdDatabase(nId , isSync: false, { (success) in
                if success == true {
                    completion(success)
                }
            })
        }
    }
    
    fileprivate func handleUpdateisSyncNecropsystep1neccId(_ success: Bool,nId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        if success == true {
            
            CoreDataHandler().updateisSyncOnCaptureInDatabase(nId , isSync: false, { (success) in
                if success == true {
                    CoreDataHandler().updateisSyncOnBirdPhotoCaptureDatabase(nId , isSync: false, { (success) in
                        self.handleUpdateSyncOnBirdPhoto(success, nId: nId) { (status) in
                            completion(status)
                        }
                    })
                }
            })
        }
    }
    
    func updadateNacDataOnCoreData(nId: NSNumber, _ completion: (_ status: Bool) -> Void) {
        
        CoreDataHandler().CaptureSkeletaDataUpdatedInDatabase(nId , isSync: false, { (success) in
            if success == true {
                CoreDataHandler().updateisSyncNecropsystep1neccId(nId , isSync: false, { (success) in
                    self.handleUpdateisSyncNecropsystep1neccId(success, nId: nId) { status in
                        completion(status)
                    }
                })
            }
        })
    }
}


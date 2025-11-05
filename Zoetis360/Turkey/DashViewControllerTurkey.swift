//
//  DashViewControllerTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 12/03/18.
//
import UIKit
//import Charts
import Alamofire
import Reachability

import SystemConfiguration
import CoreData

import Gigya
import GigyaTfa
import GigyaAuth
import SwiftyJSON

class DashViewControllerTurkey: UIViewController,syncApiTurkey,SyncApiDataTurkey {
    
    
    
    
    // MARK: - VARIABLES
    var postingId = Int()
    var feedId = Int()
    var btnTag = Int()
    var lngIdIs = NSInteger()
    let images  = [UIImage(named: "turkey_dashboard@1908x.jpg")!,
                   UIImage(named: "embrex_banner_graphic_1786x432.jpg")!,
                   UIImage(named: "PoulvacEcoli_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "PoulvacIB_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "Rotecc_banner_graphic_1908x802.jpg")!]
    var index = 0
    let animationDuration: TimeInterval = 0.75
    let switchingInterval: TimeInterval = 5
    let buttonbg = UIButton ()
    var customPopView1 :UserListView!
    var postingIdArr = NSMutableArray()
    var dataArray = NSMutableArray()
    var dataArray1 = NSMutableArray()
    var RouteArray = NSArray ()
    var custmorArr = NSArray ()
    var salesRepArr = NSArray ()
    
    var cocoiiProgramArr = NSArray ()
    var sessiontypeArr = NSArray ()
    var birdSizeArr = NSArray ()
    var breedArr = NSArray ()
    var veterianArr = NSArray ()
    var complexArr = NSArray()
    var FeedProgramArray = NSMutableArray()
    var cocciVaccine = NSMutableArray()
    var targetWeight = NSMutableArray()
    var dataSkeletaArray = NSArray ()
    var dataCocoiiArray = NSArray ()
    var dataGiTractArray = NSArray ()
    var dataRespiratoryArray = NSArray ()
    var dataImmuneArray = NSArray ()
    
    var serviceDataHldArr = NSMutableArray()
    var NecropsiesPostingSess =  NSMutableArray()
    var farmsListAray = NSArray ()
    let objApiSync = ApiSyncTurkey()
    let objApiSyncOneSetTurkey = SingleSyncDataTurkey()
    var complexSize = NSMutableArray()
    var arraVetType  = NSMutableArray()
    var getFormArray = NSMutableArray ()
    var arraCustmer = NSMutableArray ()
    var arraSalesRep = NSMutableArray ()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var genType = NSMutableArray()
    var genTypeArray = NSArray()
    var val = NSArray()
    var valnecPos = NSArray()
    var isSync : Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var dataSyncCount: UILabel!
    @IBOutlet weak var dataAvailbleForSync: UILabel!
    @IBOutlet weak var syncBackImageView: UIImageView!
    @IBOutlet weak var sideMenuBtnOutlet: UIButton!
    @IBOutlet weak var syncCount: UILabel!
    @IBOutlet weak var syncBtnOutlet: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var sessionBadgeLbl: UILabel!
    @IBOutlet weak var unlinkdBadgeLbl: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var PostingSessionButton: UIButton!
    @IBOutlet weak var ActiveSessionButton: UIButton!
    @IBOutlet weak var ReportsButton: UIButton!
    @IBOutlet weak var startSessionButton: UIButton!
    let lightFontName = "HelveticaNeue-Light"
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    
    let noDataAvalbl = "No data available from the server."
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    
    @objc func methodOfReceivedNotification(notification: Notification){
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: false)
    }
    
    // MARK: - **************** View Life Cycle ***********************************/
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        lngIdIs = UserDefaults.standard.integer(forKey: "lngId")
        
        if lngIdIs == 3{
            callLoginView()
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashViewControllerTurkey.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
        
        self.printSyncLblCountChicken()
        UserDefaults.standard.set(true, forKey: "turkeySyncStatus")
        UserDefaults.standard.set(2, forKey: "birdTypeId")
        UserDefaults.standard.set(false, forKey: "ChickenBird")
        if UserDefaults.standard.integer(forKey: "Role") == 0 {
            PostingSessionButton.isUserInteractionEnabled = false
            ActiveSessionButton.isUserInteractionEnabled = false
            ReportsButton.isUserInteractionEnabled = false
            startSessionButton.isUserInteractionEnabled = false
            syncBtnOutlet.isUserInteractionEnabled = false
        } else{
            ActiveSessionButton.isUserInteractionEnabled = true
            ReportsButton.isUserInteractionEnabled = true
            PostingSessionButton.isUserInteractionEnabled = true
            startSessionButton.isUserInteractionEnabled = true
            syncBtnOutlet.isUserInteractionEnabled = true
        }
        objApiSync.delegeteSyncApiTurkey = self
        objApiSyncOneSetTurkey.delegeteSyncApiData = self
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.set(false, forKey: "backFromStep1")
        UserDefaults.standard.synchronize()
        appDelegate.sendFeedVariable = ""
        btnTag = 0
        bannerImageView.startAnimating()
        
        let custArr = CoreDataHandlerTurkey().fetchCustomerTurkey()
        if(custArr.count == 0){
            callWebService()
        }
    }
    
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.set(false, forKey: "backFromStep1")
        UserDefaults.standard.synchronize()
        
        self.printSyncLblCount()
        let sync =  UserDefaults.standard.bool(forKey: "promt")
        if sync == true && self.allSessionArr().count > 0
        {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callPrmpApi), userInfo: nil, repeats: false)
        }
        if sync == false || self.allSessionArr().count == 0
        {
            Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(iSfarmSync), userInfo: nil, repeats: false)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lngIdIs = UserDefaults.standard.integer(forKey: "lngId")
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierLeftMenu"), object: nil)
        UserDefaults.standard.set(2, forKey: "LastScreenRef")
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        
        UserDefaults.standard.set(true, forKey: "nec")
        UserDefaults.standard.set(true, forKey: "timeStampTrue")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        UserDefaults.standard.set(1, forKey: "sessionId")
        UserDefaults.standard.set(0, forKey: "isBackWithoutFedd")
        UserDefaults.standard.removeObject(forKey: "count")
        UserDefaults.standard.synchronize()
        
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        
        let totalExustingArr = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        val = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0) as NSArray
        for i in 0..<val.count{
            let posting : PostingSessionTurkey = val.object(at: i) as! PostingSessionTurkey
            let pidSession = posting.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pidSession!)
            if feedProgram.count == 0{
                CoreDataHandlerTurkey().deleteDataWithPostingIdTurkey(pidSession!)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pidSession!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pidSession!)
            }
        }
        
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pid!)
            if feedProgram.count == 0{
                CoreDataHandlerTurkey().updatePostingSessionOndashBoardTurkey(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pid!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pid!)
            }
        }
        
        self.NecropsiesPostingSess =  CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(0).mutableCopy() as! NSMutableArray
        valnecPos  = CoreDataHandlerTurkey().fetchAllPostingSessionWithVetIdTurkey(_VetName: "") as NSArray
        let arr = NSMutableArray()
        
        for i in 0..<totalExustingArr.count {
            let posting : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            arr.add(posting)
        }
        
        sessionBadgeLbl.text = String(arr.count + valnecPos.count + val.count)
        unlinkdBadgeLbl.text =  String(valnecPos.count + val.count )
        self.printSyncLblCount()
    }
    
    // MARK: ☰ - Side Menu Button Action
    @IBAction func sideMenuBttnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    // MARK: 🔓 - Log Out Button Action
    @IBAction func logOutBtnAction(_ sender: UIButton) {
        clickHelpPopUp()
    }
    // MARK: 🔄 - Sync Button Action
    @IBAction func syncBtnAction(_ sender: UIButton) {
        
        if self.allSessionArr().count > 0 {
            if ConnectionManager.shared.hasConnectivity() {
                Helper.showGlobalProgressHUDWithTitle(self.view, title: "Data syncing ...")
                self.callSyncApi()
            } else {
                Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:Constants.offline)
            }
        } else {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    // MARK: 🎓 - Training & Education Action
    @IBAction func trainingEducationAction(_ sender: UIButton) {
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "TrainingNew") as! TrainingViewController
        self.navigationController?.pushViewController(navigateTo, animated: true)
    }
    
    // MARK: 🆕▶️ - Start New Session Action
    @IBAction func startNewSessionAction(_ sender: UIButton) {
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(0, forKey: "necUnLinked")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        Constants.isForUnlinkedTurkey = false
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: true)
    }
    
    // MARK: 📂 - Open Existing Session Action
    @IBAction func openExistingSession(_ sender: UIButton) {
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "ExistingTurkey") as! ExistingPostingSessionTurkey
        self.navigationController?.pushViewController(navigateTo, animated: true)
    }
    
    // MARK: 📊 - Reports Button Action
    @IBAction func reportsBttnAction(_ sender: UIButton) {
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "ReportTurkey") as! ReportDashboardTurkey
        self.navigationController?.pushViewController(navigateTo, animated: true)
    }
    
    // MARK: ▶️ - Start Session Action
    @IBAction func startSessionAction(_ sender: UIButton) {
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "StartNecropsyVcTurky") as? StartNecropsyVcTurky
        self.navigationController?.pushViewController(navigateTo!, animated: true)
    }
    
    // MARK: 🔗❌ - Unlinked Session Action
    @IBAction func unlinkedSessionAction(_ sender: UIButton) {
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "UnlinkedNecrTurkey") as! UnlinkedNecropsyControllerTurkey
        self.navigationController?.pushViewController(navigateTo, animated: true)
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    @objc func callPrmpApi()  {
        self.promtSyncing()
    }
    
    func animateImageView() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = DispatchTime.now() + Double(Int64(self.switchingInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        bannerImageView.layer.add(transition, forKey: kCATransition)
        bannerImageView.image = images[index]
        CATransaction.commit()
        index = index < images.count - 1 ? index + 1 : 0
    }
    func printSyncLblCountChicken() {
        
        dataSyncCount.text = String(self.allSessionArrChicken().count)
        if dataSyncCount.text == String(0)
        {
            dataSyncCount.isHidden = true
            dataAvailbleForSync.isHidden = true
            syncBackImageView.isHidden = true
        }
        else
        {
            dataAvailbleForSync.isHidden = false
            syncBackImageView.isHidden = false
            dataSyncCount.isHidden = false
        }
        
    }
    var accestoken = String()
    
    fileprivate func handleTGetNecroCategoryObservationListAPISuccessResponse(_ value: Any) {
        if let arrayValue = value as? NSArray {
            self.dataArray.removeAllObjects()
            self.appDelegate.globalDataArrTurkey.removeAllObjects()
            
            for i in 0..<arrayValue.count {
                if let tempDict = arrayValue[i] as? NSDictionary {
                    let serviceHolder = ServiceDataHolder()
                    serviceHolder.CategoryDescp = tempDict["CategoryDescription"] as? NSString ?? ""
                    serviceHolder.CataID = tempDict["CategoryId"] as? NSInteger ?? 0
                    serviceHolder.ObservaionDetailsArr = (tempDict["ObservaionDetails"] as? NSArray)?.mutableCopy() as? NSMutableArray ?? []
                    self.dataArray.add(serviceHolder)
                }
            }
            
            self.appDelegate.globalDataArrTurkey = self.dataArray
            self.skelta(0)
            self.cocoii(1)
            self.gitract(2)
            self.res(3)
            self.immu(4)
            
            self.callCustmerWebService()
        } else {
            self.callCustmerWebService()
        }
    }
    
    fileprivate func handleTGetCatObsListAPIResponse(_ statusCode: Int, _ response: AFDataResponse<Any>) {
        if statusCode == 401 {
            self.loginMethod()
        } else if (400...404).contains(statusCode) || (500...504).contains(statusCode) {
            let alertController = UIAlertController(
                title: "",
                message: "Unable to get data from server. \n(\(statusCode))",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Retry", style: .default) { _ in
                Helper.dismissGlobalHUD(self.view)
                self.callWebService()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        } else {
            switch response.result {
            case let .success(value):
                self.handleTGetNecroCategoryObservationListAPISuccessResponse(value)
            case let .failure(error):
                debugPrint("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    ///// Setting get Turkey
    
    func callWebService() {
        if WebClass.sharedInstance.connected() {
            Helper.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
            let keychainHelper = AccessTokenHelper()
            accestoken = keychainHelper.getFromKeychain(keyed: Constants.accessToken) ?? ""
            let headerDict: HTTPHeaders = [
                Constants.authorization: accestoken,
                Constants.cacheControl: Constants.noStoreNoCache
            ]
            let Id = UserDefaults.standard.integer(forKey: "Id")
            let countryId = UserDefaults.standard.integer(forKey: "countryId")
            let Url = WebClass.sharedInstance.webUrl + "Setting/TurkeyGetNecroCategoryObservationList?UserId=\(Id)&CountryId=\(countryId)"
            let urlString = URL(string: Url)
            
            sessionManager.request(urlString!, method: .get, headers: headerDict).responseJSON { response in
                guard let statusCode = response.response?.statusCode else {
                    print("Failed to get status code")
                    Helper.dismissGlobalHUD(self.view)
                    return
                }
                
                self.handleTGetCatObsListAPIResponse(statusCode, response)
            }
        } else {
            self.appDelegate.globalDataArrTurkey = self.dataArray
            self.skelta(0)
            self.cocoii(1)
            self.gitract(2)
            self.res(3)
            self.immu(4)
            self.callCustmerWebService()
        }
    }
    
    
    func loginMethod() {
        guard WebClass.sharedInstance.connected() else {
            debugPrint("No internet connection")
            return
        }
        
        // Retrieve sensitive data securely
        guard let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String else {
            debugPrint("Missing Application Identifier")
            return
        }
        let userName = PasswordService.shared.getUsername()
        let password = PasswordService.shared.getPassword()
        
        // Encrypt sensitive parameters
        let encryptedUsername = CryptoHelper.encrypt(input: userName) as? String ?? ""
        let encryptedPassword = CryptoHelper.encrypt(input: password) as? String ?? ""
        
        let url = WebClass.sharedInstance.webUrl + "Token"
        let headers: HTTPHeaders = [
            Constants.authorization: accestoken,
            Constants.cacheControl: Constants.noStoreNoCache,
            Constants.contentType: "application/x-www-form-urlencoded",
        ]
        let parameters: [String: String] = [
            "grant_type": "password",
            "UserName": encryptedUsername,
            "Password": encryptedPassword,
            "LoginType": "Web",
            "DeviceId": udid
        ]
        
        // Disable HTTP caching
        //        let configuration = URLSessionConfiguration.default
        //        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        //        let sessionManager = Session(configuration: configuration)
        
        // Send the request
        sessionManager.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { response in
            
            Helper.dismissGlobalHUD(self.view)
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else {
                    debugPrint("Invalid response")
                    return
                }
                let dict = value as? [String: Any] ?? [:]
                
                switch statusCode {
                case 400, 401:
                    debugPrint("Error: \(dict["error_description"] as? String ?? Constants.unknownErrorStr)")
                case 200:
                    let acessToken = (dict["access_token"] as? String)!
                    
                    let tokenType = (dict["token_type"] as? String)!
                    let aceesTokentype: String = tokenType + " " + acessToken
                    _ = dict["HasAccess"]! as AnyObject
                    let keychainHelper = AccessTokenHelper()
                    keychainHelper.saveToKeychain(valued: aceesTokentype, keyed: Constants.accessToken)
                    //                    UserDefaults.standard.set(aceesTokentype,forKey: Constants.accessToken)
                    //                    UserDefaults.standard.synchronize()
                    self.callWebService()
                default:
                    debugPrint("Unhandled status code: \(statusCode)")
                }
            case .failure(let error):
                debugPrint("Request failed: \(error.localizedDescription)")
            }
        }
    }
    
    func promtSyncing (){
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleFont = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: lightFontName, size: 19.0)]
        let messageFont = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: lightFontName, size: 12.0)]
        
        var myString = "Data available for sync. Do you want to sync now? \n\n\n *Note - Please don't minimize App while syncing."
        let titleAttrString = NSMutableAttributedString(string: Constants.alertStr, attributes: convertToOptionalNSAttributedStringKeyDictionary(titleFont))
        var messageAttrString = NSMutableAttributedString(string: myString , attributes: convertToOptionalNSAttributedStringKeyDictionary(messageFont))
        messageAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:50,length:52))
        let font = UIFont(name: lightFontName, size: 11.0)
        messageAttrString.addAttribute(NSAttributedString.Key.font, value:font!, range: NSRange.init(location: 50 , length: 52))
        
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            if self.allSessionArr().count > 0
            {
                if ConnectionManager.shared.hasConnectivity() {
                    DispatchQueue.main.async {
                        Helper.showGlobalProgressHUDWithTitle(self.view, title: "Data syncing ...")
                        self.callSyncApi()
                    }
                }
                else
                {
                    Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:Constants.offline)
                }
                
            }
            else{
                Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"Data not available for syncing.")
            }
            Helper.dismissGlobalHUD(self.view)
            
        }
        
        let CancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.iSfarmSync()
            self.printSyncLblCount()
            UserDefaults.standard.set(false, forKey: "promt")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
   // MARK: - 🟢 Sync API: POST Feed Data (Single or Multiple)
    func callSyncApi() {
        self.isSync = false
        let arr = self.allSessionArr()
        for postingAssessmentId in arr {
            if isSync == false{
                isSync = true
                if (UserDefaults.standard.value(forKey: "postingTurkey") != nil){
                    Constants.isFromPsotingTurkey = UserDefaults.standard.value(forKey: "postingTurkey") as? Bool ?? false
                    if Constants.isFromPsotingTurkey
                    {
                        objApiSyncOneSetTurkey.feedprogram(postingId: NSNumber(value: postingAssessmentId as! Int))
                    }
                    else
                    {
                        objApiSync.feedprogram()
                    }
                }else{
                    objApiSync.feedprogram()
                }
            }
        }
    }
    // MARK: - 🐞 API Error Handling ❌ (POST / GET) ⚠️
    func failWithError(statusCode:Int){
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"There are problem in data syncing please try again.(NA))")
        } else {
            
            if lngIdIs == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
                
            } else if lngIdIs == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
                
            } else if lngIdIs == 1000 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Há problemas na sincronização de dados, tente novamente. \n(\(statusCode))")
            }
        }
    }
    
    func failWithErrorInternal() {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"No internet connection. Please try again!")
    }
    
    func failWithInternetSyncdata() {
        Helper.dismissGlobalHUD(self.view)
    }
    
    func didFailDuringPostApi(message: String) {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,
                                titleStr: NSLocalizedString(Constants.alertStr, comment: ""),
                                messageStr: message)
    }
    
    func didFinishApi() {
        self.printSyncLblCount()
        
        if self.allSessionArr().count > 0 {
            self.showToastWithTimer(message: "Assessment synced successfully. Please Wait while we set this up for you.", duration: 2.0)
            self.isSync = false
            self.callSyncApi()
        }
        else {
            let alertView = UIAlertController(title:NSLocalizedString(Constants.alertStr, comment: "") , message:NSLocalizedString("Data Sync has completed.", comment: ""), preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: "") , style: .default, handler: { (alertAction) -> Void in
                Helper.dismissGlobalHUD(self.view)
                self.iSfarmSync()
                
            }))
            present(alertView, animated: true, completion: nil)
        }
    }
    
    func failWithInternetConnection() {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr: Constants.offline)
    }
    
    // MARK: - 🌐⏳ Start API Sync Loader for retry API Call..
    func startLoader()
    {
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
    }
    
    func startLoaderTurkey()
    {
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
    }
    
    // MARK: - ⚙️🛑 Dismiss API Sync Loader
    func didFinishApiLoader() {
        Helper.dismissGlobalHUD(self.view)
    }

    // MARK: - 🌐 ******************************* Master API Call Begins *******************************
    // MARK: - //  Get Farm List From Server  //
    func getListFarms() {
        guard WebClass.sharedInstance.connected() else {
            // Offline mode: Fetch data from Core Data
            self.farmsListAray = CoreDataHandlerTurkey().fetchFarmsDataDatabaseTurkey()
            if self.farmsListAray.count == 0 {
                self.callSaveMethodgetListFarms(self.getFormArray)
            }
            return
        }
        accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
        //  accestoken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
        // Set up headers and parameters
        let headers: HTTPHeaders = [
            Constants.authorization: accestoken,
            Constants.cacheControl: Constants.noStoreNoCache
        ]
        
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let parameters: [String: Any] = ["userId": userId]
        
        // Construct URL
        let urlString = WebClass.sharedInstance.webUrl + "Farm/GetFarmListByUserId"
        guard let url = URL(string: urlString) else {
            debugPrint("Invalid URL")
            return
        }
        
        // Make the request
        sessionManager.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                debugPrint("Failed to get response")
                return
            }
            
            switch statusCode {
            case 401:
                self.loginMethod() // Re-login on unauthorized access
                
            case 400...599 where statusCode != 404:  // <- Notice this line
                // Handle server errors with a user-friendly alert
                let alertController = UIAlertController(
                    title: "Error",
                    message: "Unable to get data from the server. (\(statusCode))",
                    preferredStyle: .alert
                )
                let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                    Helper.dismissGlobalHUD(self.view)
                    self.getListFarms()
                }
                alertController.addAction(retryAction)
                self.present(alertController, animated: true)
                
            default:
                // Handle success response
                switch response.result {
                case .success(let value):
                    self.handleFarmsList(value)
                case .failure(let error):
                    debugPrint("Request failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate func handleFarmsList(_ value: Any) {
        if let farmsArray = value as? [[String: Any]] {
            self.saveFarmNameGetVetList(farmsArray)
        } else {
            // No farms found, proceed to next service call
            self.callVeterianService()
        }
    }
    
    
    
    fileprivate func saveFarmNameGetVetList(_ farmsArray: [[String : Any]]) {
        self.getFormArray = NSMutableArray()
        
        // Process farm data
        for farm in farmsArray {
            let farmDict = NSMutableDictionary()
            farmDict["CountryId"] = farm["CountryId"] as? Int
            farmDict["FarmId"] = farm["FarmId"] as? Int
            farmDict["FarmName"] = farm["FarmName"] as? String
            self.getFormArray.add(farmDict)
        }
        
        // Save to Core Data
        CoreDataHandlerTurkey().deleteAllDataTurkey("FarmsListTurkey")
        self.callSaveMethodgetListFarms(self.getFormArray)
        self.callVeterianService()
    }
    
  
    
    func callSaveMethodgetListFarms(_ farmsArray : NSArray) {
        
        for i in 0..<farmsArray.count {
            
            let FarmId = (farmsArray.object(at: i) as AnyObject).value(forKey: "FarmId") as! NSNumber
            let FarmName = (farmsArray.object(at: i) as AnyObject).value(forKey: "FarmName") as! String
            let CountryId = (farmsArray.object(at: i) as AnyObject).value(forKey: "CountryId") as! NSNumber
            /***************** All details Save in to FarmdataBase ****************************************/
            CoreDataHandlerTurkey().FarmsDataDatabaseTurkey("", stateId: 0, farmName: FarmName, farmId: FarmId, countryName: "", countryId: CountryId, city: "")
        }
    }
    
    // MARK: - 🚀 Get All Session List...
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
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
        
        
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    // MARK: - 🌐 ********* Feed Program molecule ************ 🚀
    func FeedProgramMoleculeService() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getFeedProgramCatagoryAndMoleculeDetailsResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Feed Program molecule list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                self?.handleFeedProgramError(jsonResponse)
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleFeedProgramResponse(json)
                }
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
    // MARK: Handle molecule List API fail
    private func handleFeedProgramError(_ jsonResponse: JSON) {
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
            
            print("Error from get Route list API : \(errorMsg) (Code: \(errorCode))")
            self.callLoginMethod(errorCode)
        }
    }
    
    // MARK: ✅ Handle molecule List API Responce..
    private func handleFeedProgramResponse(_ json: Any) {
        let jsonDict = JSON(json).dictionary
        if let errorMessage = jsonDict?["Message"]?.string {
            print("Error from API Feed Program molecule: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Feed Program molecule list is empty.")
            self.callGetCocciVaccine()
            return
        }
        
        self.FeedProgramArray = NSMutableArray()
        for item in arr {
            if let dict = item.dictionaryObject {
                self.FeedProgramArray.add(dict)
            }
        }
        UserDefaults.standard.set(self.FeedProgramArray, forKey: "Molucule")
        self.callGetCocciVaccine()
    }
    
    
    
    func callFeedProgramMoleculeService( _ breedTypeArr : NSArray) {
        print(appDelegateObj.testFuntion())
    }
    // MARK: - 💾 Save Session's type API Response to Database...
    func callSaveMethodforSessiontype( _ seessionTypeArr : NSArray) {
        
        for i in 0..<seessionTypeArr.count {
            
            let SessionId = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "SessionTypeId") as! Int
            let sessionName = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "SessionTypeName") as! String
            let langId = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            CoreDataHandlerTurkey().SessionTypeDatabaseTurkey(SessionId, sesionType: sessionName, lngId: langId, dbArray: self.sessiontypeArr, index: i)
        }
    }
    
    // MARK: - 💾 Save Veterinarian's List API Response to Database...
    func callSaveMethodforeterian( _ veterianArray : NSArray) {
        var vetId = 0
        var vetName = ""
        for i in 0..<veterianArray.count {
            if let num = (veterianArray.object(at: i) as AnyObject).value(forKey: "VeterinarianId") {
                vetId = num as! Int
            }
            if let str = (veterianArray.object(at: i) as AnyObject).value(forKey: "VeterinarianName") {
                vetName = str as! String
            }
            CoreDataHandlerTurkey().VetDataDatabaseTurkey(vetId, vtName: vetName, complexId: 0, dbArray: self.veterianArr, index: i)
        }
    }
    // MARK: - 💾 Save Bird's Size API Response to Database...
    func callSaveMethodforBirdSize( _ birdSizeTypeArr : NSArray) {
        
        for i in 0..<birdSizeTypeArr.count {
            
            let birdSizeId = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "BirdSizeId") as! Int
            let birdSizeName = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "BirdSize") as! String
            let birdtype = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "ScaleType") as! String
            CoreDataHandlerTurkey().BirdSizeDatabaseTurkey(birdSizeId, birdSize: birdSizeName, scaleType: birdtype, dbArray: self.birdSizeArr, index: i)
        }
    }
    // MARK: - 💾 Save Route's List API Response to Database...
    func callSaveMethod( _ routeArr : NSArray) {
        
        for i in 0..<routeArr.count {
            let routeId = (routeArr.object(at: i) as AnyObject).value(forKey: "RouteId") as! Int
            let languageId = (routeArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            let routeName = (routeArr.object(at: i) as AnyObject).value(forKey: "RouteName") as! String
            
            CoreDataHandlerTurkey().saveRouteDatabaseTurkey(routeId, routeName: routeName,lngId:languageId, dbArray: self.RouteArray, index: i)
        }
    }
    
    // MARK: - 🦃  Setup Skeleton 🩻 data & Save in an Array
    func skelta (_ tag: Int) {
        btnTag = 0
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0 {
            let _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        
        dataSkeletaArray = CoreDataHandlerTurkey().fetchAllSeettingdataTurkey()
        if dataSkeletaArray.count == 0 {
            
            self.callSaveMethod1(serviceDataHldArr)
            dataSkeletaArray = CoreDataHandlerTurkey().fetchAllSeettingdataTurkey()
        }
    }
    
    func skeltaInfoArr(){
        for i in 0..<dataSkeletaArray.count{
            let sketlaVal = dataSkeletaArray[i] as! Skeleta
            let obsName12 = sketlaVal.observationField
            var dict12 = [String: Any]()
            let skeltaArr12 = NSMutableArray()
            skeltaArr12.add(sketlaVal.observationId ?? 0)
            skeltaArr12.add(sketlaVal.observationId ?? 0)
            dict12[obsName12!] = skeltaArr12
        }
    }
    
    // MARK: - 🦃 Set Up Turkey Coccidiosis Data & Save in Array
    func cocoii (_ tag: Int) {
        
        btnTag = 1
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
            var cocciServices = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = cocciServices.ObservaionDetailsArr
        }
        dataCocoiiArray = CoreDataHandlerTurkey().fetchAllCocoiiDataTurkey()
        if dataCocoiiArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataCocoiiArray = CoreDataHandlerTurkey().fetchAllCocoiiDataTurkey()
        }
    }
    // MARK: Call Login Method
    func callLoginView()  {
        UserDefaults.standard.removeObject(forKey: "login")
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    // MARK: - 🦃 Set Up Turkey Gitract 🦠 Data & Save in Array
    func gitract (_ tag: Int) {
        
        btnTag = 2
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
            var _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataGiTractArray = CoreDataHandlerTurkey().fetchAllGITractDataTurkey()
        if dataGiTractArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataGiTractArray = CoreDataHandlerTurkey().fetchAllGITractDataTurkey()
        }
    }
    // MARK: - 🦃 Set Up Turkey Respiratory Data & Save in Array
    func res (_ tag: Int) {
        btnTag = 3
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
            var _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataRespiratoryArray = CoreDataHandlerTurkey().fetchAllRespiratoryTurkey()
        if dataRespiratoryArray.count == 0 {
            
            self.callSaveMethod1(serviceDataHldArr)
            dataRespiratoryArray = CoreDataHandlerTurkey().fetchAllRespiratoryTurkey()
        }
    }
    // MARK: - 🦃🩺 Set Up Turkey Immune Data & Save in Array
    func immu (_ tag: Int) {
        btnTag = 4
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
            var _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataImmuneArray = CoreDataHandlerTurkey().fetchAllImmuneTurkey()
        if dataImmuneArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataImmuneArray = CoreDataHandlerTurkey().fetchAllImmuneTurkey()
        }
    }

    // MARK: - 🩺 Save Observation Settings in Database for Turkey 🦃
    func callSaveMethod1( _ skeletaArr : NSArray) {
        
        for i in 0..<skeletaArr.count {
            
            let strObservationField = (skeletaArr.object(at: i) as AnyObject).value(forKey: "ObservationDescription") as! String
            let visibilityCheck = (skeletaArr.object(at: i) as AnyObject).value(forKey: "DefaultQLink") as! Bool
            let obsId = (skeletaArr.object(at: i) as AnyObject).value(forKey: "ObservationId") as! NSInteger
            let visibilitySwitch = (skeletaArr.object(at: i) as AnyObject).value(forKey: "Visibility") as! Bool
            let measure =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "Measure") as! String
            let lngIdValue =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! NSNumber
            let refId =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "ReferenceId") as! NSNumber
            let quickLinkIndex =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "SequenceId") as? Int
            
            var isVisibilityCheck = Bool()
            var isQuicklinksCheck = Bool()
            if visibilityCheck == true {
                isQuicklinksCheck = true
                
            } else if visibilityCheck == false {
                isQuicklinksCheck = false
            }
            if visibilitySwitch == true {
                isVisibilityCheck = true
            } else {
                
                isVisibilityCheck = false
            }
            
            if  btnTag == 0 {
                
                let settingsSkeletaData = CoreDataHandlerTurkeyModels.turkeySettingsSkeletaData(
                    strObservationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    strInformation: "xyz",
                    index: i,
                    dbArray: dataSkeletaArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0                )
                CoreDataHandlerTurkey().saveSettingsSkeletaInDatabaseTurkey(settingsData: settingsSkeletaData)
                
            } else if btnTag == 1{
                
                let savecoccidiosisSettings = CoreDataHandlerTurkeyModels.turkeyCoccidiosisSettings(
                    strObservationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    strInformation: "xyz",
                    index: i,
                    dbArray: dataCocoiiArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandlerTurkey().saveSettingsCocoiiInDatabaseTurkey(data: savecoccidiosisSettings)
                
            } else if btnTag == 2{
                let gITractDatasettings = CoreDataHandlerTurkeyModels.turkeyGITractSettingsData(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataGiTractArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandlerTurkey().saveSettingsGITractDatabaseTurkey(gITractDatasettings)
                
                
            } else if btnTag == 3 {
                
                let respiratorySettings = CoreDataHandlerTurkeyModels.turkeyRespiratorySettings(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataRespiratoryArray,
                    observationId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandlerTurkey().saveSettingsRespiratoryDatabaseTurkey(respiratorySettings)
                
            } else {
                
                let immuneSettings = CoreDataHandlerTurkeyModels.turkeyImmuneSettings(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataImmuneArray,
                    observationId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandlerTurkey().saveSettingsImmuneDatabaseTurkey(immuneSettings)
            }
            
        }
    }
    // MARK: - Looking for unlinked Farms in Posting session or Unlinked Session's For Turkey. 🦃
    @objc func iSfarmSync(){
        let totalExustingArr = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        var isFarmSync = Bool()
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let farms = CoreDataHandlerTurkey().fetchNecropsystep1neccIdFeedProgramTurkey(pid!)
            if farms.count > 0 {
                CoreDataHandlerTurkey().updatedPostigSessionwithIsFarmSyncPostingIdTurkey(pid!, isFarmSync: true)
                if isFarmSync == false{
                    Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr: "You have unlinked farm(s) to your feed in posting session. Visit '' Open Existing Session '' to link farm(s) to feed program.")
                    isFarmSync = true
                }
            }
        }
    }
    // MARK: - 🦃🔢 Show Turkey Session Count
    func printSyncLblCount() {
        syncCount.text = String(self.allSessionArr().count)
    }
    // MARK: - 💬⏱️ Show Toast Message (API Fail / Data Not Found)
    func showToastWithTimer(message : String, duration: TimeInterval ) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        
        toastLabel.font  = UIFont(name: lightFontName, size: 14.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 3
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: - 💾 Save Cocci Programe API Response to Database...
    func callSaveMethodforCocoiiProgram( _ cocoiArr : NSArray) {
        
        for i in 0..<cocoiArr.count {
            let cocoiiId = (cocoiArr.object(at: i) as AnyObject).value(forKey: "CocciProgramId") as! Int
            let languageId = (cocoiArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            let cocoiiIdName = (cocoiArr.object(at: i) as AnyObject).value(forKey: "CocciProgramName") as! String
            CoreDataHandlerTurkey().CocoiiProgramDatabaseTurkey(cocoiiId, cocoiProgram: cocoiiIdName, lngId: languageId, dbArray: self.cocoiiProgramArr, index: i)
        }
    }
    
    // MARK: - 💾 Save Sales Representative API Response to Database...
    func callSaveMethodforSalesRep( _ SalesRepArr : NSArray) {
        
        for i in 0..<SalesRepArr.count {
            let SalesId = (SalesRepArr.object(at: i) as AnyObject).value(forKey: "SalesRepresentativeId") as! Int
            let SalesNameName = (SalesRepArr.object(at: i) as AnyObject).value(forKey: "SalesRepresentativeName") as! String
            CoreDataHandlerTurkey().SalesRepDataDatabaseTurkey(SalesId, salesRepName: SalesNameName, dbArray: self.salesRepArr, index: i)
        }
    }
    // MARK: - 💾 Save Breed Type API Response to Database...
    func callSaveMethodforBreedType( _ breedTypeArr : NSArray) {
        for i in 0..<breedTypeArr.count {
            
            let breeId = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedId") as! Int
            let breedName = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedName") as! String
            let breedType = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedType") as! String
            CoreDataHandlerTurkey().BreedTypeDatabaseTurkey(breeId, breedType: breedType, breedName: breedName, dbArray: self.breedArr, index: i)
        }
    }
    // MARK: - 💾 Save Customer's lIst from API Response to Database...
    func callSaveMethodforCustomer( _ custmorArr : NSArray) {
        for i in 0..<custmorArr.count {
            let CustId = (custmorArr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! Int
            let CustName = (custmorArr.object(at: i) as AnyObject).value(forKey: "CustomerName") as! String
            CoreDataHandlerTurkey().saveCustmerDatabaseTurkey(CustId, CustName: CustName, dbArray: self.custmorArr, index: i)
        }
    }
    
    // MARK: - 💾 Save Cocci Vaccine Name list to Database...
    fileprivate func cocciVaccinListSaved(_ arr: [JSON]) {
        for item in arr {
            if let cocciDict = item.dictionary {
                // Safely unwrap and parse each key
                let cocciVaccineId = cocciDict["CocciVaccineId"]?.int ?? -1
                let cocciVaccineName = cocciDict["CocciVaccineName"]?.string ?? "Unknown"
                let languageId = cocciDict["LanguageId"]?.int ?? -1
                
                // Save to CoreData
                CoreDataHandlerTurkey().saveCocoiiVacTurkey(
                    cocciVaccineId,
                    decscMolecule: cocciVaccineName,
                    lngId: languageId
                )
            } else {
                print("Invalid data format in CocciVaccine array: \(item)")
            }
        }
        
        // Save serialized data to UserDefaults (if needed)
        UserDefaults.standard.set(
            arr.map { $0.dictionaryObject },
            forKey: "cocci"
        )
    }
    // MARK: - 🦃🦠🌐 Get Coccidiosis Vaccine API Call
    func callGetCocciVaccine() {
        if WebClass.sharedInstance.connected() {
            CoreDataHandlerTurkey().deleteAllDataTurkey("CocoiVaccineTurkey")
            
            ZoetisWebServices.shared.getCocciVaccineTurkeyResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Cocci Vaccine list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    // Check if the JSON response contains an error message
                    if let jsonDict = JSON(json).dictionary, let errorMessage = jsonDict["Message"]?.string {
                        print("Error from API Cocci Vaccine list: \(errorMessage)")
                        self?.showToastWithTimer(message: errorMessage, duration: 3.0)
                        return
                    }
                    // Parse the array from JSON response
                    if let arr = JSON(json).array, !arr.isEmpty {
                        self?.cocciVaccinListSaved(arr)
                    } else {
                        print("Cocci Vaccine list is empty.")
                        
                    }
                    // Proceed with the next API call
                    self?.callTargetWeightProcessing()
                }
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
    
    func callCocciVaccineService( _ CocciVaccine : NSArray) {
        print(appDelegateObj.testFuntion())
    }
  
    // MARK: - 🦃⚖️🌐 Get Target Weight Processing API
    func callTargetWeightProcessing() {
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getTargetWeightResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Target Weight Processing list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                DispatchQueue.main.async {
                    self?.handleTargetWeightResponse(json)
                }
            })
            
        } else {
            self.failWithErrorInternal()
        }
    }
    // MARK: ✅ Handle Target Weight ⚖️ API Responce..
    private func handleTargetWeightResponse(_ json: Any) {
        if let errorMessage = JSON(json)["Message"].string {
            print("Error from API: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        guard let arr = JSON(json).array, !arr.isEmpty else {
            self.getListFarms()
            print(Constants.noDataReceivedStr)
            self.showToastWithTimer(message: Constants.noDataRecieved, duration: 3.0)
            return
        }
        
        var serializedArray: [[String: Any]] = []
        self.targetWeight.removeAllObjects()
        
        for item in arr {
            if let dictionary = item.dictionaryObject {
                serializedArray.append(dictionary)
                self.targetWeight.add(dictionary as AnyObject)
            }
        }
        
        UserDefaults.standard.set(serializedArray, forKey: "target")
        self.getListFarms()
    }
        
    // MARK: - 🦃🌐 Get Zoetis Complex's list API of Turkey ...
    func complexService() {
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getChickenTurkeyComplexByUserIdResponce(controller: self, parameters: ["UserId" :"UserId"], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Complex list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                DispatchQueue.main.async {
                    self?.handleComplexResponse(json)
                }
            })
        }
        else {
            self.complexArr = CoreDataHandlerTurkey().fetchCompexTypeTurkey()
            if(self.complexArr.count == 0){
                self.callcomplexService(self.complexSize)
                
            }
        }
    }
    
    // MARK: ✅ Handle complex's list API Responce..
    private func handleComplexResponse(_ json: Any) {
        if let errorMessage = JSON(json)["Message"].string {
            print("Error from API: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        guard let arr = JSON(json).array, !arr.isEmpty else {
            
            self.dismissGlobalHUD(self.view ?? UIView())
            self.showToastWithTimer(message: "Failed to get complex's list", duration: 3.0)
            return
        }
        
        self.complexSize = NSMutableArray()
        
        for item in arr {
            if let tempDict = item.dictionaryObject {
                let dictData = NSMutableDictionary()
                dictData.setValue(tempDict["CustomerId"] as? Int, forKey: "CustomerId")
                dictData.setValue(tempDict["ComplexName"] as? String, forKey: "ComplexName")
                dictData.setValue(tempDict["ComplexId"] as? Int, forKey: "ComplexId")
                self.complexSize.add(dictData)
            } else {
                print("Invalid data format in array: \(item)")
            }
        }
        
        CoreDataHandlerTurkey().deleteAllDataTurkey("ComplexPostingTurkey")
        self.callcomplexService(self.complexSize)
        self.callSalesRepWebService()
    }
    
    
    // MARK: - 💾 Save Complex's list to Database...
    func callcomplexService( _ complexArrrr : NSArray) {
        for i in 0..<complexArrrr.count {
            let custmerId = (complexArrrr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! NSNumber
            let custmerName = (complexArrrr.object(at: i) as AnyObject).value(forKey: "ComplexName") as! String
            let complexid = (complexArrrr.object(at: i) as AnyObject).value(forKey: "ComplexId") as! NSNumber
            CoreDataHandlerTurkey().ComplexDatabaseTurkey(complexid, cutmerid: custmerId, complexName: custmerName, dbArray: complexArr, index: i)
        }
    }
    
    // MARK: - 💾 Save Veteration list to Database...
    fileprivate func saveVetListArr(_ self: DashViewControllerTurkey, _ arr: [JSON]) {
        self.arraVetType = NSMutableArray()
        CoreDataHandler().deleteAllData("VeterationTurkey")
        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid vet list item structure in array.")
                continue
            }
            
            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["VeterinarianName"] as? String, forKey: "VeterinarianName")
            dictData.setValue(tempDict["VeterinarianId"] as? Int, forKey: "VeterinarianId")
            
            arraVetType.add(dictData)
        }
        
        self.callSaveMethodforeterian(self.arraVetType)
        self.callhatcheryStrain()
    }
   
    // MARK: - 🦃🌐 Get Zoetis Veterinarian List API (Turkey)
    func callVeterianService() {
        
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getVeterinarianResponceTurkey(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get veterian list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processVeterianResponseData(json)
                }
                
            })
        }
        else
        {
            self.failWithInternetConnection()
        }
        
    }
    // MARK: - 💾 Save Veteration list to Database...
    private func processVeterianResponseData(_ json: Any) {
        let jsonDict = JSON(json).dictionary
        
        if let errorMessage = jsonDict?["Message"]?.string {
            print("Error from API Veterinarian list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        if let arr = JSON(json).array, !arr.isEmpty {
            saveVetListArr(self, arr)
        } else {
            print("Veterinarian  list is empty.")
            self.callhatcheryStrain()
        }
    }
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
            }
        }
        return nil
    }
    // MARK: - 💾 Save Breed Type to Database...
    fileprivate func saveBreedTypeInArr(_ arr: [JSON], _ arraBreedType: NSMutableArray) {
        for item in arr {
            if let tempDict = item.dictionaryObject {
                let dictData = NSMutableDictionary()
                dictData.setValue(tempDict["BirdBreedType"] as? String, forKey: "BirdBreedType")
                dictData.setValue(tempDict["BirdBreedName"] as? String, forKey: "BirdBreedName")
                dictData.setValue(tempDict["BirdBreedId"] as? Int, forKey: "BirdBreedId")
                arraBreedType.add(dictData)
            } else {
                print("Invalid data format in array: \(item)")
            }
        }
        
        self.breedArr = CoreDataHandlerTurkey().fetchBreedTypeTurkey()
        if self.breedArr.count == 0 {
            self.callSaveMethodforBreedType(arraBreedType)
        }
    }
    // MARK: - 🦃🌐 Get Zoetis Bird Breed type List API (Turkey)
    func callBreedService() {
        
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getBirdBreedChickenAndTurkeyResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Bird Breed list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let jsonDict = JSON(json).dictionary, let errorMessage = jsonDict["Message"]?.string {
                        print("Error from API: \(errorMessage)")
                        self?.showToastWithTimer(message: errorMessage, duration: 3.0)
                        return
                    }
                    
                    // Check if the response contains an array
                    if let arr = JSON(json).array, !arr.isEmpty {
                        let arraBreedType = NSMutableArray()
                        
                        self?.saveBreedTypeInArr(arr, arraBreedType)
                        
                        self?.FeedProgramMoleculeService()
                    } else {
                        // Handle the case where the array is empty or nil
                        print(Constants.noDataReceivedStr)
                        self?.showToastWithTimer(message: Constants.noDataRecieved, duration: 3.0)
                    }
                }
                
            })
            
        }
        else
        {
            self.failWithInternetConnection()
        }
    }
    
    // MARK: - 💾 Save Bird Size List to Database...
    fileprivate func saveBirdSizeInArr(_ arr: [JSON], _ self: DashViewControllerTurkey) {
        let arraBirdSize = NSMutableArray()
        CoreDataHandler().deleteAllData("BirdSizePostingTurkey")
        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid Bird Size item structure in array.")
                continue
            }
            
            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["BirdSize"] as? String, forKey: "BirdSize")
            dictData.setValue(tempDict["BirdSizeId"] as? Int, forKey: "BirdSizeId")
            dictData.setValue(tempDict["ScaleType"] as? String, forKey: "ScaleType")
            arraBirdSize.add(dictData)
        }
        
        
        self.birdSizeArr = CoreDataHandlerTurkey().fetchBirdSizeTurkey()
        if(self.birdSizeArr.count == 0)
        {
            self.callSaveMethodforBirdSize(arraBirdSize)
        }
        self.callBreedService()
    }
    // MARK: - 📥 Process Bird Size List ......
    private func processBirdTypeData(_ json: Any) {
        let jsonArr = JSON(json).array
        
        if let arr = jsonArr, !arr.isEmpty {
            saveBirdSizeInArr(arr, self)
        } else {
            print("Bird Size list is empty.")
            self.callBreedService()
        }
    }
    // MARK: - 🦃🌐 Get Zoetis Bird Size List API (Turkey)
    func callBirdTypeService() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getBirdSizeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Bird Size list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processBirdTypeData(json)
                    
                }
                
            })
        } else{
            self.failWithInternetConnection()
        }
    }
    // MARK: - 💾 Save Session Type to a Array for Turkey...
    fileprivate func saveSessionTypeInArr(_ arr: [JSON], _ self: DashViewControllerTurkey) {
        let arraSessionType = NSMutableArray ()
        
        CoreDataHandler().deleteAllData("SessiontypeTurkey")
        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid Session type item structure in array.")
                continue
            }
            
            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["SessionTypeName"] as? String, forKey: "SessionTypeName")
            dictData.setValue(tempDict["SessionTypeId"] as? Int, forKey: "SessionTypeId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "LanguageId")
            arraSessionType.add(dictData)
        }
        
        self.sessiontypeArr = CoreDataHandlerTurkey().fetchSessiontypeTurkey()
        
        if(self.cocoiiProgramArr.count == 0)
        {
            self.callSaveMethodforSessiontype(arraSessionType)
        }
    }

    // MARK: - 🦃🌐 Get Zoetis Session's type List API (Turkey)
    func callSessionTypeService() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getSessionTypeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Session's type list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    if errorCode == "401" || errorCode == "404"{
                        self!.loginMethod()
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleSessionTypeResponse(json)
                }
                
            })
            
        } else {
            self.failWithInternetConnection()
        }
    }
    // MARK: ✅ Handle Session's Type API Responce..
    private func handleSessionTypeResponse(_ json: Any) {
        if let arr = JSON(json).array, !arr.isEmpty {
            saveSessionTypeInArr(arr, self)
        }
        self.callBirdTypeService()
    }
    // MARK: - 💾 Save Cocci Program in Data Base for Turkey...
    fileprivate func saveCocciProgramName(_ arr: [JSON], _ self: DashViewControllerTurkey) {
        let cocoiiProgramArray = NSMutableArray()
        CoreDataHandler().deleteAllData("CocciProgramPostingTurkey")
        //
        // Parse each item in the array
        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid cocci program item structure in array.")
                continue
            }
            
            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["CocciProgramName"] as? String, forKey: "CocciProgramName")
            dictData.setValue(tempDict["CocciProgramId"] as? Int, forKey: "CocciProgramId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "LanguageId")
            
            cocoiiProgramArray.add(dictData)
        }
        
        // Fetch existing data from Core Data
        self.cocoiiProgramArr = CoreDataHandlerTurkey().fetchCocoiiProgramTurkey()
        
        // Save data only if there is no existing data
        if self.cocoiiProgramArr.count == 0 {
            self.callSaveMethodforCocoiiProgram(cocoiiProgramArray)
        }
    }

    // MARK: - 🦃🌐 Get Zoetis Cocci Program list API (Turkey)
    func callCocoiiProgramService() {
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getCocciProgramResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Cocci Program list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    if errorCode == "401" || errorCode == "404"{
                        self!.loginMethod()
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleCocciProgramData(json: json)
                }
                
            })
        } else{
            self.failWithInternetConnection()
        }
    }
    
    // MARK: ✅ Handle Cocci Program API Responce..
    private func handleCocciProgramData(json: Any) {
        guard let arr = JSON(json).array else {
            print("Invalid data format.")
            callSessionTypeService()
            return
        }
        
        if !arr.isEmpty {
            saveCocciProgramName(arr, self)
        } else {
            print("Cocci Program list is empty.")
        }
        
        // Always call next API
        callSessionTypeService()
    }
    
    // MARK: - 🦃🌐 Get Zoetis 🧑‍💼 Sales Representatives List  API (Turkey) 🤝
    func callSalesRepWebService() {
        
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getSalesRepresentativeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Sales Representatives list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                DispatchQueue.main.async {
                    self?.parseSalesRepJSON(json: json)
                }
            })
            
            
        } else{
            
            self.salesRepArr = CoreDataHandlerTurkey().fetchSalesrepTurkey()
            if(self.salesRepArr.count == 0){
                self.callSaveMethodforSalesRep(self.arraSalesRep)
            }
        }
    }
    // MARK: ✅ Handle Sales Representatives API Responce..
    private func parseSalesRepJSON(json: Any) {
        if let jsonDict = JSON(json).dictionary, let errorMessage = jsonDict["Message"]?.string {
            print("Error from API: \(errorMessage)")
            showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        guard let arr = JSON(json).array, !arr.isEmpty else {
            showToastWithTimer(message: "No data received for Sales Representatives.", duration: 3.0)
            
            callAddVaccination()
            return
        }
        
        processSalesRepArray(arr)
    }
  
    // MARK: - 💾 Save 🧑‍💼 Sales Representatives List in Data Base for Turkey...
    private func processSalesRepArray(_ arr: [JSON]) {
        arraSalesRep = NSMutableArray()
        
        for item in arr {
            if let tempDict = item.dictionaryObject {
                let dictDat = NSMutableDictionary()
                dictDat.setValue(tempDict["SalesRepresentativeName"] as? String, forKey: "SalesRepresentativeName")
                dictDat.setValue(tempDict["SalesRepresentativeId"] as? Int, forKey: "SalesRepresentativeId")
                arraSalesRep.add(dictDat)
            } else {
                print("Invalid data format in Sales Representative array: \(item)")
            }
        }
        
        CoreDataHandlerTurkey().deleteAllDataTurkey("SalesrepTurkey")
        callSaveMethodforSalesRep(arraSalesRep)
        callAddVaccination()
    }
    // MARK: - 💾 Save 🧑‍💼 Customer Name List in Data Base for Turkey...
    fileprivate func saveCustomerNameArr(_ arr: [JSON]) {
        var customerArray: [NSDictionary] = []
        
        // Parse each item in the array
        for item in arr {
            if let tempDict = item.dictionary {
                let customerName = tempDict["CustomerName"]?.string ?? "Unknown"
                let customerId = tempDict["CustomerId"]?.int ?? -1
                
                // Create a dictionary for the customer
                let dictData: NSDictionary = [
                    "CustomerName": customerName,
                    "CustomerId": customerId
                ]
                
                customerArray.append(dictData)
            } else {
                print("Invalid data format for item: \(item)")
            }
        }
        
        // Save parsed data and proceed with business logic
        self.arraCustmer = NSMutableArray(array: customerArray)
        CoreDataHandlerTurkey().deleteAllDataTurkey("CustmerTurkey")
        self.callSaveMethodforCustomer(self.arraCustmer)
        self.complexService()
    }
    // MARK: - 🦃Login Method call If Access Token Fail. (Turkey) ⚠️
    fileprivate func callLoginMethod(_ errorCode: String) {
        if errorCode == "401" || errorCode == "404"{
            self.loginMethod()
        }
    }
    
    // MARK: - 🦃🌐 Get Zoetis 🧑‍💼 Customers List API (Turkey)
    func callCustmerWebService() {
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getCustomerListResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Customers list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    print("Error from get Route list API : \(errorMsg) (Code: \(errorCode))")
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    
                    // Parse the array from JSON response
                    if let arr = JSON(json).array, !arr.isEmpty {
                        self?.saveCustomerNameArr(arr)
                    } else {
                        // Handle case when the route list is empty
                        print("Customer's list is empty.")
                        self?.complexService()
                    }
                }
            })
        } else{
            
            self.custmorArr = CoreDataHandlerTurkey().fetchCustomerTurkey()
            if(self.custmorArr.count == 0){
                self.callSaveMethodforCustomer(self.arraCustmer)
            }
        }
    }
    
    // MARK: - 💾 Save 🧑‍💼 Route Name List in Data Base for Turkey...
    fileprivate func saveRouteNameInArr(_ arr: [JSON]) {
        var routeArray: [NSDictionary] = []
        
        // Parse each item in the array
        for item in arr {
            if let tempDict = item.dictionaryObject {
                let routeData: NSMutableDictionary = [
                    "RouteName": tempDict["RouteName"] as? String ?? "",
                    "RouteId": tempDict["RouteId"] as? Int ?? -1,
                    "LanguageId": tempDict["LanguageId"] as? Int ?? -1
                ]
                routeArray.append(routeData)
            } else {
                print("Invalid route data format: \(item)")
            }
        }
        
        // Fetch existing routes from CoreData
        self.RouteArray = CoreDataHandlerTurkey().fetchRouteTurkey()
        
        // Save new routes if CoreData is empty
        if self.RouteArray.count == 0 {
            self.callSaveMethod(routeArray as NSArray)
        }
        
        // Proceed to the next service call
        self.callCocoiiProgramService()
    }
  
    // MARK: - 🦃🌐 Get Zoetis 🧑‍💼 Route List API (Turkey)
    func callAddVaccination() {
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getRouteResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Route list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleVaccinationArray(json: json)
                }
            })
            
        } else {
            self.failWithInternetConnection()
        }
    }
    // MARK: ✅ Handle Route List API Responce..
    private func handleVaccinationArray(json: Any) {
        let jsonDict = JSON(json).dictionary
        
        if let errorMessage = jsonDict?["Message"]?.string {
            print("Error from API Route list: \(errorMessage)")
            showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        if let arr = JSON(json).array, !arr.isEmpty {
            saveRouteNameInArr(arr)
        } else {
            print("Route list is empty.")
            callCocoiiProgramService()
        }
    }
    
    // MARK: - 🦃📂 Get All Turkey Session Array
    func allSessionArrChicken() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
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
        
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        return allPostingSessionArr
    }
 
    // MARK: - 💾 Save 🥚 Hatchery Strain list in Data Base for Turkey...
    fileprivate func saveHatcheryStrainInArr(_ arr: [JSON], _ self: DashViewControllerTurkey) {
        // Clear existing data in Core Data
        CoreDataHandler().deleteAllData("HatcheryStrain")
        
        // Process each item in the array
        for item in arr {
            if let strainDict = item.dictionary {
                // Safely unwrap and parse the keys
                let strainId = strainDict["StrainId"]?.int ?? -1
                let strainName = strainDict["StrainName"]?.string ?? "Unknown"
                let langID = strainDict["LanguageId"]?.int ?? -1
                
                // Save the parsed data to Core Data
                CoreDataHandler().SaveStrainDataDatabase(strainName, StrainId: strainId, lngId: langID)
            } else {
                print("Invalid data format for HatcheryStrain: \(item)")
            }
        }
        
        // Call the next service after processing
        self.callGetFieldStrain()
    }
    
    // MARK: - 🦃🌐 Get Zoetis 🥚 Hatchery Strain List API (Turkey)
    func callhatcheryStrain() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getTurkeyHatcheryStrainResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Hatchery Strain list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    print("Error from get Route list API : \(errorMsg) (Code: \(errorCode))")
                    if errorCode == "401" || errorCode == "404"{
                        self!.loginMethod()
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.handleHatcheryStrainArray(json: json)
                }
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
    
    // MARK: ✅ Handle 🥚 Hatchery Strain List API Responce..
    private func handleHatcheryStrainArray(json: Any) {
        if let arr = JSON(json).array, !arr.isEmpty {
            saveHatcheryStrainInArr(arr, self)
        } else {
            print("Hatchery strain list is empty.")
            showToastWithTimer(message: noDataAvalbl, duration: 3.0)
            callGetFieldStrain()
        }
    }

    // MARK: - 💾 Save 🧬 Field Strain Field Strain list in Data Base for Turkey...
    fileprivate func saveFieldStraininArr(_ arr: [JSON]) {
        // Clear existing data in Core Data
        CoreDataHandler().deleteAllData("GetFieldStrain")
        
        // Process each item in the array
        for item in arr {
            if let strainDict = item.dictionary {
                // Safely unwrap and parse the keys
                let strainId = strainDict["StrainId"]?.int ?? -1
                let strainName = strainDict["StrainName"]?.string ?? "Unknown"
                let langID = strainDict["LanguageId"]?.int ?? -1
                
                // Save the parsed data to Core Data
                CoreDataHandler().SaveStrainDataDatabaseField(strainName, StrainId: strainId, lngId: langID)
                
            } else {
                print("Invalid data format for Field Strain: \(item)")
            }
        }
    }
    // MARK: - 🦃🌐 Get Zoetis 🥚 Field Strain List API (Turkey)
    func callGetFieldStrain() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getTurkeyFieldStrainResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Field Strain list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    // Parse the array from JSON response
                    if let arr = JSON(json).array, !arr.isEmpty {
                        self?.saveFieldStraininArr(arr)
                        
                        // Call the next service after processing
                        self?.callGetDosage()
                    } else {
                        // Handle the case where the array is empty
                        self?.showToastWithTimer(message: self?.noDataAvalbl ?? "", duration: 3.0)
                        // Call the next service
                        self?.callGetDosage()
                    }
                }
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
    
    // MARK: - 💾 Save💊 Dossage list in Data Base for Turkey...
    fileprivate func saveDossageListInArr(_ arr: [JSON]) {
        // Clear existing data in Core Data
        CoreDataHandler().deleteAllData("GetDosage")
        
        // Process each item in the array
        for item in arr {
            if let strainDict = item.dictionary {
                // Safely unwrap and parse the keys
                let doseId = strainDict["DoseId"]?.int ?? -1
                let dosename = strainDict["Dose"]?.string ?? "Unknown"
                
                // Save the parsed data to Core Data
                CoreDataHandler().SaveDosageDataDatabaseField(dosename, doseId: doseId)
            } else {
                print("Invalid data format for Get Dosage: \(item)")
            }
        }
        
        // Call the next service after processing
        self.getGenerationType()
    }
    
    // MARK: - 🦃🌐 Get Zoetis 💊 Dossage List API (Turkey)
    func callGetDosage() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getDosageResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Dossage list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    // Parse the array from JSON response
                    if let arr = JSON(json).array, !arr.isEmpty {
                        self?.saveDossageListInArr(arr)
                    } else {
                        // Handle the case where the array is empty
                        print("Get Dosage list is empty.")
                        self?.showToastWithTimer(message: self?.noDataAvalbl ?? "", duration: 3.0)
                        // Call the next service
                        self?.getGenerationType()
                    }
                }
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
   
    // MARK: - 💾 Save 🧬 Generation Type list in Data Base for Turkey...
    fileprivate func saveGenerationTypeArr(_ arr: [JSON], _ self: DashViewControllerTurkey) {
        // Clear existing data in Core Data
        CoreDataHandler().deleteAllData("GenerationType")
        
        // Process each item in the array
        for item in arr {
            if let tempDict = item.dictionary {
                // Safely parse the "Name" and "Id" fields
                let generationName = tempDict["Name"]?.string ?? "Unknown"
                let generationId = tempDict["Id"]?.int ?? -1
                
                // Create a dictionary and add it to the genType array
                let dictData: [String: Any] = [
                    "generationName": generationName,
                    "generationId": generationId
                ]
                
                self.genType.add(dictData)
            } else {
                print("Invalid data format in array item: \(item)")
            }
        }
        
        self.callGenerationType(self.genType)
    }
    // MARK: - Process 🧬 Generation Type list in Data Base for Turkey...
    func callGenerationType( _ generationTypArrrr : NSArray) {
        
        for i in 0..<generationTypArrrr.count {
            let genName = (generationTypArrrr.object(at: i) as AnyObject).value(forKey: "generationName") as! String
            let genid = (generationTypArrrr.object(at: i) as AnyObject).value(forKey: "generationId") as! NSNumber
            CoreDataHandler().generationTypeDatabase(genid, generationName: genName, dbArray: genTypeArray, index: i)
        }
        self.callGetDosageTurkeyWithMoleculeId()
    }
    
    // MARK: ✅ Handle 🧬 Generation Type List API Responce..
    fileprivate func handleJsonAndSaveData(_ json: JSON) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Parse the array from JSON response
            if let arr = JSON(json).array, !arr.isEmpty {
                saveGenerationTypeArr(arr, self)
            } else {
                // Handle the case where the array is empty
                self.genType = CoreDataHandler().fetchGenerationType() as! NSMutableArray
                if(self.genType.count == 0){
                    self.callGenerationType(self.genType)
                }
            }
        }
    }
    // MARK: - 🦃🌐 Get Zoetis 🧬 Generation Type List API (Turkey)
    func getGenerationType() {
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getTurkeyGenerationResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Generation Type list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                self?.handleJsonAndSaveData(json)
            })
        } else {
            self.failWithInternetConnection()
        }
    }
      
    // MARK: - 💾 Save 💊 Dossage By Molecule ID in Data Base for Turkey...
    fileprivate func saveDossageInArr(_ arr: [JSON]) {
        // Clear existing data in Core Data
        CoreDataHandler().deleteAllData("GetDosageTurkeyWithMoleculeID")
        
        // Process each item in the array
        for item in arr {
            if let strainDict = item.dictionary {
                let doseId = strainDict["DoseId"]?.int ?? -1
                let dosename = strainDict["Dose"]?.string ?? "Unknown"
                let moleculeId = strainDict["MoleculeId"]?.int ?? -1
                CoreDataHandler().SaveTurkeyDosageDataWithMoleculeIDDatabaseField(dosename, doseId: doseId, molecukeId: moleculeId)
            } else {
                print("Invalid data format for Get Dosage: \(item)")
            }
        }
        Helper.dismissGlobalHUD(self.view)
    }
    // MARK: - 🦃🌐 Get Zoetis 💊 Dossage By Molecule ID List API (Turkey)
    func callGetDosageTurkeyWithMoleculeId() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getTurkeyDoseByMoleculeIdResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Dossage By Molecule ID list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.handleDosageArray(json: json)
                }
            })
            
        } else{
            Helper.dismissGlobalHUD(self.view)
            self.failWithInternetConnection()
        }
    }
    // MARK: - Process 💊 Dossage By Molecule ID in Data Base for Turkey...
    private func handleDosageArray(json: Any) {
        if let arr = JSON(json).array, !arr.isEmpty {
            self.saveDossageInArr(arr)
        } else {
            Helper.dismissGlobalHUD(self.view)
        }
    }
    
}

// MARK: - 🧩 DashView Controller Turkey EXTENSION 🔧
extension DashViewControllerTurkey :userlistProtocol,userLogOut {
    
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView, indexValue: String) {
        
        if indexValue == "Log Out" || indexValue == "Cerrar sesión" {
            
            self.ssologoutMethod()
            UserDefaults.standard.removeObject(forKey: "login")
            UserDefaults.standard.set(false, forKey: "newlogin")
            UserDefaults.standard.set(true, forKey: "callDraftApi")
            
            for controller in (self.navigationController?.viewControllers ?? []) as Array {
                if controller.isKind(of: ViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            buttonbg.removeFromSuperview()
            customPopView1.removeView(view)
        }
        else{
            
            guard let url = URL(string: "https://mypoultryview360.com") else {
                return
            }
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - 👤🔒 Logout SSO Account
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func cancelMethod(){
        customPopView1.removeView(view)
    }
    @objc func buttonPressed1() {
        customPopView1.removeView(view)
        buttonbg.removeFromSuperview()
    }
    
    func DoneMethod(_ EmailUsers: String!){
        customPopView1.removeView(view)
    }
    
    func clickHelpPopUp() {
        buttonbg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg.addTarget(self, action: #selector(DashViewControllerTurkey.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 210, y: 60, width: 150, height: 130))
    }
    
    /// COPIED FROM THE BELOW EXTENSION METHOD
    func failWithErrorSyncdata(statusCode:Int){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            
            if lngIdIs == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            }
            if lngIdIs == 1000 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again(NA))", comment: ""))
            }
            else if lngIdIs == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
        }
    }
    
    func failWithErrorInternalSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:" Server error please try again .")
    }
    
    func didFinishApiSyncdata(){
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnectionSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
}
// MARK: - 🛠️ Swift 4.2 Migrator Helper Function
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

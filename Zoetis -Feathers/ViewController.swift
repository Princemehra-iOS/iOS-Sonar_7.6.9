// ViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 11/08/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Reachability
import FirebaseCrashlytics
import JNKeychain
import simd
import Gigya
import GigyaTfa
import GigyaAuth
import SwiftyJSON
//import JNKeychain


private struct FeedConstants {
	static let deviceType = "iOS"
	static let feedIdKey = "feedId"
}

class ViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, syncApiTurkey, syncApi {
   
    
    var delegate: SidePenalDelegate?
    let myBlueColor = (UIColor(red: 204.0, green: 227.0, blue: 255.0, alpha: 1.0))
    var loginArray = NSArray()
    var hatcheryVaccDict = NSMutableDictionary()
    var fieldVaccDict = NSMutableDictionary()
    var otherDict = NSMutableDictionary()
    var dashboardVC: PEDashboardViewController = PEDashboardViewController()
    
    
    var objApiSync = ApiSync()
    var objApiSyncTurkey = ApiSyncTurkey()
    @IBOutlet weak var versionNumber: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    var accestoken = String()
    var userName = String()
    var password = String()
    var termsCond = Int()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lastScreenFlag: Int!
    let buttonbg = UIButton()
    var droperTableView  =  UITableView()
    var langArray: [String] = []
    var langDict = NSMutableDictionary()
    var newOpenModules : Bool = true
    var bottomViewController:BottomViewController!
    var isPassHidden = true;
    
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var nextBtn: PESubmitButton!
    
    var btnTag = Int()
    var langNameArray: [String] = []
    var langCultureArray : [String] = []
    var langIdArray : [NSNumber] = []
    var countryArray: [String] = []
    var countryIdIs: [NSNumber] = []
    var apiKeyIdIs: NSNumber?
    var domainsName : String?
    var apiKeyIs: String?
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    let selectCountryStr = "Select country"
    let selectLangStr = "Select language"
    let pleaseSelectLangStr = "Please select Language "
    
    var emailIs: String = ""
    var guidIs: String = ""
    var guidSignatureIs: String = ""
    var signatureTimestampIs: String = ""
    
    
    
    
    private let sessionManager: Session = {
           let configuration = URLSessionConfiguration.default
           configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
           configuration.urlCache = nil
           return Session(configuration: configuration)
       }()
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        lblCountry.text = selectCountryStr
        lblLanguage.text = selectLangStr
        
        lblCountry.textColor = .lightGray
        lblLanguage.textColor = .lightGray
        
        btnLanguage.layer.cornerRadius = 1
        btnLanguage.layer.borderColor = UIColor.black.cgColor
        
        btnCountry.layer.cornerRadius = 1
        btnCountry.layer.borderColor = UIColor.black.cgColor
        
        countryView.layer.borderWidth  = 2
        countryView.layer.borderColor = UIColor.getBorderColorr().cgColor
        countryView.layer.cornerRadius = 18.5
        countryView.backgroundColor = UIColor.white
        
        languageView.layer.borderWidth  = 2
        languageView.layer.borderColor = UIColor.getBorderColorr().cgColor
        languageView.layer.cornerRadius = 18.5
        languageView.backgroundColor = UIColor.white
        
        
        setLeftPenalNotification()
        if ConnectionManager.shared.hasConnectivity() {
            /* To avoid load master data again & again in Chicken & Turkey
             */
//            CoreDataHandler().deleteAllData("Custmer")
//            CoreDataHandlerTurkey().deleteAllDataTurkey("CustmerTurkey")
        }
        
        UserDefaults.standard.synchronize()
        
        setupHeader()
        
        lblAppName.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
        let environmentIs = Constants.Api.versionUrl
        let baseVersionText = "Version " + Bundle.main.versionNumber

        // Define constants for liveAlbums values
        enum LiveAlbumEnvironment: Int {
            case stage = 0, dev = 1, support = 2, production = 3
        }

        var liveAlbums: LiveAlbumEnvironment = .production

        if environmentIs.contains("stageapi") {
            liveAlbums = .stage
        } else if environmentIs.contains("devapi") {
            liveAlbums = .dev
        } else if environmentIs.contains("supportapi") {
            liveAlbums = .support
        }

        let environmentSuffix: String
        switch liveAlbums {
        case .stage:
            environmentSuffix = " (UAT)"
        case .dev:
            environmentSuffix = " (Dev)"
        case .support:
            environmentSuffix = " (Dev Support)"
        case .production:
            environmentSuffix = ""
        }

        lblAppVersion.text = baseVersionText + environmentSuffix

    }
    
    // MARK:  /*********** Fetch Gigya Country List **************/
    private func fetchGigyaCountryList(){
        Constants.baseUrl = Constants.Api.fhBaseUrl
        self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
        if ConnectionManager.shared.hasConnectivity() {
            ZoetisWebServices.shared.getGigyaCountryList(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: Constants.gigyaValidation, duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    self?.countryArray.removeAll()
                    self?.countryIdIs.removeAll()
                    
                    let dataArray = json
                    for countries in dataArray {
                        let countryName = countries.1
                        let country = countryName[Constants.countryNamStr]
                        let countryIds = countryName["CountryId"]
                        self?.countryArray.append(country.rawValue as! String)
                        self?.countryIdIs.append(countryIds.rawValue as! NSNumber)
                    }
                }
            })
        }
        
        else{
            self.showToastWithTimer(message: Constants.gigyaValidation, duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    // MARK:  /*********** Fetch Gigya Country Languages List **************/
    private func fetchGigyaCountryLang(countryId: String){
        Constants.baseUrl = Constants.Api.fhBaseUrl
        if ConnectionManager.shared.hasConnectivity() {
            ZoetisWebServices.shared.getGigyaCountryLanguage(countryID: countryId,controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    var dataArray = json
                    for languages in dataArray {
                        var language = languages.1
                        let langCulture = language["Language_Culture"]
                        
                        self?.langCultureArray.append(langCulture.rawValue as! String)
                        let langName = language["Language_Name"]
                        
                        self?.langNameArray.append(langName.rawValue as! String)
                        let langId = language["Id"]
                        
                        self?.langIdArray.append(langId.rawValue as! NSNumber)
                        
                    }
                }
            })
        }
        
        else{
            self.showToastWithTimer(message: "Failed to get Gigya Country's Language list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK:  /*********** Fetch Gigya API Keys List **************/
    private func fetchGigyaApiKeys(countryId: String){
        Constants.baseUrl = Constants.Api.fhBaseUrl
        if ConnectionManager.shared.hasConnectivity() {
            ZoetisWebServices.shared.getGigyaApiKeys(countryID: countryId,controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    let dataArray = json
                    
                    for apiKeyData in dataArray {
                        let apiKeys = apiKeyData.1   // <- Rename the outer loop variable
                         
                        let countryApiKey = apiKeys["API_Keys"]
                        debugPrint(countryApiKey)
                        
                        self?.apiKeyIs = countryApiKey.rawValue as? String
                        let domainName = apiKeys["Data_Center"]
                        self?.domainsName = domainName.rawValue as? String
                        let apiKeyId = apiKeys["Id"]
                        self?.apiKeyIdIs = apiKeyId.rawValue as? NSNumber
                     
                        
                        let environmentIs = Constants.Api.versionUrl
                        let environmentMap: [String: Int] = [
                            "stageapi": 0,
                            "devapi": 1,
                            "supportapi": 2
                        ]

                        let match = self!.findEnvironmentMatch(environmentMap: environmentMap, environmentIs: environmentIs)
                        let liveAlbums = match?.value ?? 3
                        let apiKey = (liveAlbums == 1 || liveAlbums == 2) ? self!.appDelegate.gigyaApiKeyStageDev : (self?.apiKeyIs ?? "")
                        self?.gigya.initFor(apiKey: apiKey, apiDomain: self?.domainsName)
                        


                    }

                }
            })
        }
        
        else{
            self.showToastWithTimer(message: "Failed to get Gigya API keys", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    private func findEnvironmentMatch(environmentMap: [String: Int], environmentIs: String) -> (key: String, value: Int)? {
        return environmentMap.first { environmentIs.contains($0.key) }
    }
    
    // MARK:  /*********** Fetch Gigya Country Languages List **************/
    private func encryptUserName(emailId: String){
        Constants.baseUrl = Constants.Api.fhBaseUrl
        if ConnectionManager.shared.hasConnectivity() {
            ZoetisWebServices.shared.getEncryptedUserName(emailIs: emailId,controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    let jsonTextValue: String = json["Text"].stringValue
                    
                    self?.loginMethod(Email: jsonTextValue, GUID: self?.guidIs ?? "", GUIDSignature: self?.guidSignatureIs ?? "", SignatureTimestamp: self?.signatureTimestampIs ?? "")

                }
            })
        }
        
        else{
            self.showToastWithTimer(message: "Failed to get Gigya Country's Language list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    
    
    // MARK:  /*********** Country Button Action **************/
    @IBAction func countryBtnAction(_ sender: Any) {
        
        btnTag = 1
        tableViewpop()
    }
    // MARK:  /*********** Language button Action **************/
    @IBAction func languageBtnAction(_ sender: Any) {
        lblLanguage.textColor = .black
        btnTag = 2
        tableViewpop()
    }
    // MARK:  /*********** Next button Action **************/
    @IBAction func nextBtnAction(_ sender: Any) {
        
        if lblCountry.text == ""
        {
            self.showToastWithTimer(message: "Please select Country ", duration: 3.0)
        }
        else if lblCountry.text == selectCountryStr
        {
            self.showToastWithTimer(message: "Please select Country ", duration: 3.0)
        }
        else if lblLanguage.text == ""
        {
            self.showToastWithTimer(message: pleaseSelectLangStr, duration: 3.0)
        }
        else if lblLanguage.text == selectLangStr
        {
            self.showToastWithTimer(message: pleaseSelectLangStr, duration: 3.0)
        }
        
        else
        {
            if ConnectionManager.shared.hasConnectivity() {
                self.ssologoutMethod()
                
                var registerloginIs = "RegistrationLogin_US"
                if lblCountry.text == "United States" {
                    registerloginIs = "RegistrationLogin_US"
                }else{
                    registerloginIs = "RegistrationLogin"
                }
                
                let newParam = ["startScreen": "gigya-login-screen"]
                
                Gigya.sharedInstance().showScreenSet(with: registerloginIs , viewController: self , params: newParam) { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .onLogin(let account):
                        
                      //
                        
                        self.encryptUserName(emailId: account.profile?.email ?? "")
                        
                        emailIs = account.profile?.email ?? ""
                        guidIs = account.UID ?? ""
                        guidSignatureIs = account.UIDSignature ?? ""
                        signatureTimestampIs = account.signatureTimestamp ?? ""
                        
                        
                    case .error(let event):
                        
                        debugPrint(event)
                    default:
                        break
                    }
                }
                
            }
            
            else
            {
                self.alerViewInternet()
            }
        }
        
    }
    
    // MARK:  /*********** Logout SSO Account **************/
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
    
    // MARK:  /*********** Login With SSO Account **************/
    fileprivate func setOffLineLoggedInUserData(_ Email: String) {
        let name = Email as String
        self.loginArray = CoreDataHandler().fetchLoginTypeWithUserEmail(email:name)
        if  loginArray.count == 0{
            Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"You are offline. Please go online for first time login.")
        }
        else {
            
            for i in 0..<loginArray.count {
                userName = (loginArray.object(at: i) as AnyObject).value(forKey: "username") as! String
            }
            
            let name = Email as String
            if userName.lowercased() == name {
                
                UserDefaults.standard.set(true, forKey: "login")
                self.lastScreenFlag = UserDefaults.standard.value(forKey: "LastScreenRef") as? Int
                
                if lastScreenFlag == 1 {
                    UserDefaults.standard.set(1, forKey: "birdTypeId")
                }
                else if lastScreenFlag == 2 {
                    UserDefaults.standard.set(2, forKey: "birdTypeId")
                }
                else if lastScreenFlag == 3 {
                    UserDefaults.standard.set(3, forKey: "birdTypeId")
                }
                
                self.callDashBordView()
            }
            else if userName.lowercased() != name{
                Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"Please enter valid mail .")
            }
        }
    }
    
    fileprivate func handleLoginSuccessMethodPart1(_ lastUsername: String, _ mailTexts: String, _ jsonData: Data?, _ jsonDecoder: JSONDecoder) {
        if lastUsername != "" && mailTexts != "" {
            if lastUsername.removeWhitespace().contains(mailTexts.removeWhitespace()){
                UserDefaults.standard.set(false, forKey: "PENewUserLoginFlag")
            } else {
                UserDefaults.standard.set(true, forKey: "PENewUserLoginFlag")
            }
        }
        
        if let data = jsonData {
            let userResponseObj = try? jsonDecoder.decode(UserResponseDTO.self, from: jsonData!)
            if userResponseObj != nil {
                if let lastFilledUserId =  UserContextDAO.sharedInstance.getUserContextFilledObj()?.userId?.removeWhitespace() {
                    UserContext.sharedInstance.setUserDetails(userResponseObj!)
                    if let newlyFilledUserId =  UserContextDAO.sharedInstance.getUserContextFilledObj()?.userId?.removeWhitespace() {
                        if newlyFilledUserId == lastFilledUserId {
                            UserDefaults.standard.set(false, forKey: "PENewUserLoginFlag")
                        } else {
                            UserDefaults.standard.set(true, forKey: "PENewUserLoginFlag")
                        }
                    }
                }
                UserContext.sharedInstance.setUserDetails(userResponseObj!)
                UserDefaults.standard.set(true, forKey: "hasLoggedIn")
            }
        }
    }
    
    private func hadleLoginInvalidaGrantMethod(dict: NSDictionary) -> Bool? {
        if (dict.value(forKey: "error") as? String) ?? ""  == "invalid_grant"{
            self.ssologoutMethod()
            let errorMSg = dict["error_description"]
            let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                Helper.dismissGlobalHUD(self.view)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return true
        }
        return nil
    }
    
    fileprivate func deleteCacheAndLocalDataBeforeLoginNavigation() {
        // **********Chicken DataBase delete**************//
        self.deleteAllData("AlternativeFeed")
        self.deleteAllData("AntiboticFeed")
        self.deleteAllData("BirdPhotoCapture")
        self.deleteAllData("BirdSizePosting")
        self.deleteAllData("Breed")
        self.deleteAllData("CamraImage")
        self.deleteAllData("CaptureNecropsyData")
        self.deleteAllData("CaptureNecropsyViewData")
        self.deleteAllData("Coccidiosis")
        self.deleteAllData("CoccidiosisControlFeed")
        self.deleteAllData("CocciProgramPosting")
        self.deleteAllData("ComplexPosting")
        self.deleteAllData("Custmer")
        self.deleteAllData("CustomerReprestative")
        self.deleteAllData("FarmsList")
        self.deleteAllData("FeedProgram")
        self.deleteAllData("FieldVaccination")
        self.deleteAllData("GITract")
        self.deleteAllData("HatcheryVac")
        self.deleteAllData("Immune")
        self.deleteAllData("Login")
        self.deleteAllData("MyCotoxinBindersFeed")
        self.deleteAllData("Necropsy")
        self.deleteAllData("NotesBird")
        self.deleteAllData("PostingSession")
        self.deleteAllData("Respiratory")
        self.deleteAllData("Route")
        self.deleteAllData("Salesrep")
        self.deleteAllData("Sessiontype")
        self.deleteAllData("Skeleta")
        self.deleteAllData("Veteration")
        
        
        // **********Turkey DataBase delete**************//
        self.deleteAllData("AlternativeFeedTurkey")
        self.deleteAllData("AntiboticFeedTurkey")
        self.deleteAllData("BirdPhotoCaptureTurkey")
        self.deleteAllData("BirdSizePostingTurkey")
        self.deleteAllData("BreedTurkey")
        self.deleteAllData("CamraImageTurkey")
        self.deleteAllData("CaptureNecropsyDataTurkey")
        self.deleteAllData("CaptureNecropsyViewDataTurkey")
        self.deleteAllData("CoccidiosisTurkey")
        self.deleteAllData("CoccidiosisControlFeedTurkey")
        self.deleteAllData("CocciProgramPostingTurkey")
        self.deleteAllData("ComplexPostingTurkey")
        self.deleteAllData("CustmerTurkey")
        self.deleteAllData("CustomerReprestativeTurkey")
        self.deleteAllData("FarmsListTurkey")
        self.deleteAllData("FeedProgramTurkey")
        self.deleteAllData("FieldVaccinationTurkey")
        self.deleteAllData("GITractTurkey")
        self.deleteAllData("HatcheryVacTurkey")
        self.deleteAllData("ImmuneTurkey")
        self.deleteAllData("LoginTurkey")
        self.deleteAllData("MyCotoxinBindersFeedTurkey")
        self.deleteAllData("NecropsyTurkey")
        self.deleteAllData("NotesBirdTurkey")
        self.deleteAllData("PostingSessionTurkey")
        self.deleteAllData("RespiratoryTurkey")
        self.deleteAllData("RouteTurkey")
        self.deleteAllData("SalesrepTurkey")
        self.deleteAllData("SessiontypeTurkey")
        self.deleteAllData("SkeletaTurkey")
        self.deleteAllData("VeterationTurkey")
    }
    
    fileprivate func handleLoginMethodArrModules(_ arrModuleIds: [String], _ dict: NSDictionary) -> Bool? {
        if !(arrModuleIds.count > 1) {
            if arrModuleIds[0] == "21" {
                let roleID = dict.value(forKey: "RoleIds") as? String ?? ""
                if roleID != "31" && roleID != "33"{
                    Helper.dismissGlobalHUD(self.view)
                    Helper.showAlertMessage(self, titleStr: "", messageStr: "Sorry you dont have access for this.")
                    return true
                }
            }
        }
        return nil
    }
    
    fileprivate func handleSwitchBirdAndTerms(_ switchBird: Int, _ terms: String) {
        if switchBird == 2 {
            UserDefaults.standard.set(true, forKey: "turkeyReport")
        } else {
            UserDefaults.standard.set(false, forKey: "turkeyReport")
        }
        if terms == "true" {
            self.termsCond = 1
        } else {
            self.termsCond = 0
        }
    }
    
    fileprivate func handleBirdManagement(_ birdId: Int) {
        if birdId == 2 {
            UserDefaults.standard.set(false, forKey: "turkey")
        } else if birdId == 1 {
            UserDefaults.standard.set(false, forKey: "Chicken")
        }
    }
    
    fileprivate func handleBirdIdANdPostingDataPostingDataTurkey(_ birdId: Int, _ postingData: NSArray, _ postingDataTurkey: NSArray) {
        if birdId == 1 {
            if postingData.count == 0 {
                self.getPostingDataFromServer()
            }
        } else if birdId == 2 {
            if postingDataTurkey.count == 0 {
                self.getPostingDataFromServerTurkey()
            }
            
        } else {
            if postingData.count == 0 || postingDataTurkey.count == 0 {
                self.getPostingDataFromServer()
            }
        }
    }
    
    func loginMethod(Email: String, GUID: String, GUIDSignature: String, SignatureTimestamp: String) {
        let userDefaults = UserDefaults.standard
        let udidKey = "ApplicationIdentifier"

        var udid = userDefaults.string(forKey: udidKey)
        if udid == nil || udid?.isEmpty == true {
            let newUUID = UUID().uuidString
            userDefaults.set(newUUID, forKey: udidKey)
            userDefaults.synchronize()
            udid = newUUID
           // print("✅ ApplicationIdentifier regenerated after logout: \(newUUID)")
           
        }
    
        guard WebClass.sharedInstance.connected() else
        {
            return
        }
        
        self.deleteAllData("Login")
        _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: Constants.loginLoaderMessage)
        let urlString = WebClass.sharedInstance.webUrl + "Token"
        let headers: HTTPHeaders = [
            Constants.contentType: "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        let parameters: [String: String] = [
            "grant_type": "password",
            "UserName": Email,
            "Password": "",
            "LoginType": "App",
            "DeviceId": udid ?? "",
            "ChkEnvironment": WebClass.sharedInstance.ChkEnvironmentLive,
            "GUID": GUID,
            "GUIDSignature": GUIDSignature,
            "SignatureTimestamp": SignatureTimestamp,
            "AppVersion": "\(Bundle.main.versionNumber)",
            "TokenVersion": "V2"
        ]
        
        sessionManager.request(urlString, method: .post, parameters: parameters, headers: headers).responseJSON { response in
            
            let stass = response.response?.statusCode
            if stass == 500 {
                Helper.dismissGlobalHUD(self.view)
                Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"InvalidWebcredentials")
                self.ssologoutMethod()
                return
            }
            
            if stass == 400 {
                    self.ssologoutMethod()
                    Helper.dismissGlobalHUD(self.view)
                    Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Authorisation failed please contact PV360 support team poultryview360@zoetis.com.")
                    return
            }
            
            switch response.result {
            case let .success(value):
                
                let loginDate = Date()
                UserDefaults.standard.set(loginDate, forKey: "LoginDate")
                TimeManager.shared.startSession()
                
                UserDefaults.standard.set(false, forKey:"PECleanSession")
                UserDefaults.standard.set(nil, forKey: "PE_Selected_Customer_Id")
                UserDefaults.standard.set(nil, forKey: "PE_Selected_Customer_Name")
                UserDefaults.standard.set(nil, forKey: "PE_Selected_Site_Id")
                UserDefaults.standard.set(nil, forKey: "PE_Selected_Site_Name")
                let mailTexts = Email ?? ""
                PasswordService.shared.setUsername(password: Email)
                let dict : NSDictionary = value as! NSDictionary
                let statusCode = response.response?.statusCode
                let lastUsername = PasswordService.shared.getUsername()
                UserDefaults.standard.set(false, forKey: "hasAppMovedToBackground")
                let jsonDecoder = JSONDecoder()
                let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let userId = UserDefaults.standard.integer(forKey: "Id")
                let Id = dict.value(forKey:"Id")!  as AnyObject
                let id = Id.integerValue

                self.handleLoginSuccessMethodPart1(lastUsername, mailTexts, jsonData, jsonDecoder)
                
                if let _ = self.hadleLoginInvalidaGrantMethod(dict: dict) {
                    return
                }
                
                if statusCode == 401 {
                    self.ssologoutMethod()
                    let errorMSg = dict["error_description"]
                    let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                        Helper.dismissGlobalHUD(self.view)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let FirstName = dict.value(forKey: "FirstName") as? String ?? ""
                    let terms = dict.value(forKey: "TermAccepted")! as! String
                    let acessToken = (dict.value(forKey: "access_token") as? String) ?? ""
                    let countryId = dict.value(forKey: "CountryId")
                    let LastName = dict.value(forKey: "LastName") as? String ?? ""
                    let salcountryId = dict.value(forKey: "NonUSCountryId")
                    let birdTypeId = dict.value(forKey: "BirdTypeId")
                    let RoleId = (dict.value(forKey: "RoleId") as? String) ?? ""
                    let RoleIds = (dict.value(forKey: "RoleIds") as? String) ?? ""
                    let Regionid = (dict.value(forKey: "Regionid") as? String) ?? ""
                    UserDefaults.standard.set(birdTypeId, forKey: "switchBird")
                    let switchBird = UserDefaults.standard.integer(forKey: "switchBird")
                    let roleId = dict.value(forKey: "HasAccess")! as AnyObject
                    let tokenType = (dict.value(forKey: "token_type") as? String)!
                    
                    let ModuleId = (dict.value(forKey: "ModuleId") as? String) ?? ""
                    let arrModuleIds = ModuleId.components(separatedBy: "~")
                    if let status = self.handleLoginMethodArrModules(arrModuleIds, dict) {
                        return
                    }
                    let ModuleName = (dict.value(forKey: "ModuleName") as? String) ?? ""
                    let moduleIdIs = ModuleId.replacingOccurrences(of: "~", with: "")
                    UserDefaults.standard.set(ModuleId, forKey: "ModuleIdsArray")
                    UserDefaults.standard.set(moduleIdIs, forKey: "ModuleId")
                    UserDefaults.standard.set(ModuleName, forKey: "ModuleName")
                    UserDefaults.standard.set(RoleId, forKey: "RoleId")
                    UserDefaults.standard.set(RoleIds, forKey: "RoleIds")
                    UserDefaults.standard.set(Regionid, forKey: "Regionid")
                    UserDefaults.standard.set(salcountryId, forKey: "nonUScountryId")
                    UserDefaults.standard.set(LastName, forKey: "LastName")
                    UserDefaults.standard.set(birdTypeId, forKey: "birdTypeId")
                    
                    self.handleSwitchBirdAndTerms(switchBird as! Int, terms)
                    UserDefaults.standard.set(countryId, forKey: "countryId")
                    UserDefaults.standard.synchronize()
                    let aceesTokentype: String = tokenType + " " + acessToken
                    let role = roleId.integerValue
                    AccessTokenHelper().saveToKeychain(valued: aceesTokentype, keyed: "aceesTokentype")
                    UserDefaults.standard.set(role!, forKey: "Role")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(terms, forKey: "Terms")
                    UserDefaults.standard.set(terms, forKey: "TermsChicken")
                    UserDefaults.standard.set(terms, forKey: "TermsTurkey")
                    let userName = "\(FirstName)_\(LastName)".lowercased()
                    UserDefaults.standard.set(userName, forKey: "username")
                    
                    let birdId = UserDefaults.standard.integer(forKey: "birdTypeId")
                    self.handleBirdManagement(birdId)
                    self.deleteCacheAndLocalDataBeforeLoginNavigation()
                    
                    UserDefaults.standard.set(FirstName,forKey: "FirstName")
                    UserDefaults.standard.set(id!, forKey: "Id")
                    UserDefaults.standard.synchronize()
                    let postingData = CoreDataHandler().fetchAllPostingExistingSession()
                    let postingDataTurkey = CoreDataHandlerTurkey().fetchAllPostingExistingSessionTurkey()
                    
                    self.handleBirdIdANdPostingDataPostingDataTurkey(birdId, postingData, postingDataTurkey)
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn_successful")
                    UserDefaults.standard.synchronize()
                    UserModel.shared.setUserData(
                        userId: id!,
                        username: "\(FirstName)_\(LastName)".lowercased(),
                        firstName: FirstName,
                        lastName: LastName,
                        email: Email
                    )

                    self.loginArray = CoreDataHandler().fetchLoginType()
                    if(self.loginArray.count == 0) {
                        CoreDataHandler().loginDatabase(1, userId: id! as NSNumber , userName: Email  , status: 1, loginId: 0, dbArray: self.loginArray, index: 0)
                    }
                }
                break
            case let .failure(error):
                debugPrint(error.localizedDescription)
                break
            }
        }
    }
    
    private func resetUserDefaultsOnLogin(email: String) {
        UserDefaults.standard.set(false, forKey: "PECleanSession")
        UserDefaults.standard.set(nil, forKey: "PE_Selected_Customer_Id")
        UserDefaults.standard.set(nil, forKey: "PE_Selected_Customer_Name")
        UserDefaults.standard.set(nil, forKey: "PE_Selected_Site_Id")
        UserDefaults.standard.set(nil, forKey: "PE_Selected_Site_Name")
        let mailTexts = email
        let lastUsername = PasswordService.shared.getUsername()
        if !lastUsername.isEmpty && !mailTexts.isEmpty {
            let isSameUser = lastUsername.removeWhitespace().contains(mailTexts.removeWhitespace())
            UserDefaults.standard.set(!isSameUser, forKey: "PENewUserLoginFlag")
        }
        PasswordService.shared.setUsername(password: email)
        UserDefaults.standard.set(false, forKey: "hasAppMovedToBackground")
    }

    private func decodeUserResponse(_ value: Any) -> UserResponseDTO? {
        let jsonDecoder = JSONDecoder()
        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted),
           let userResponseObj = try? jsonDecoder.decode(UserResponseDTO.self, from: jsonData) {
            return userResponseObj
        }
        return nil
    }

    private func updateUserContext(_ userResponseObj: UserResponseDTO) {
        if let lastFilledUserId = UserContextDAO.sharedInstance.getUserContextFilledObj()?.userId?.removeWhitespace(),
           let newlyFilledUserId = UserContextDAO.sharedInstance.getUserContextFilledObj()?.userId?.removeWhitespace() {
            UserContext.sharedInstance.setUserDetails(userResponseObj)
            UserDefaults.standard.set(lastFilledUserId != newlyFilledUserId, forKey: "PENewUserLoginFlag")
        }
        UserContext.sharedInstance.setUserDetails(userResponseObj)
        UserDefaults.standard.set(true, forKey: "hasLoggedIn")
    }
    
    private func handleError(with dict: NSDictionary) {
        self.ssologoutMethod()
        let errorMsg = dict["error_description"]
        let alertController = UIAlertController(title: Constants.alertStr, message: errorMsg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            Helper.dismissGlobalHUD(self.view)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // Usage for the original cases
    private func handleInvalidGrant(_ dict: NSDictionary) {
        handleError(with: dict)  // Simply call handleError
    }

    private func handleUnauthorized(_ dict: NSDictionary) {
        handleError(with: dict)  // Simply call handleError
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        //, name: Notification.Name.willResig, object: nil)
    }
    
    // MARK:  Call Sync API for Feed Program Chicken *******/
    func callSyncApi() {
        objApiSync.feedprogram()
    }
    // MARK:  Call Sync API for Feed Program Turkey *******/
    func callSyncApiTurkey() {
        
        objApiSyncTurkey.feedprogram()
    }
    
    
    // MARK: ******* Get All Session for Chicken**********/
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
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
            if let postingId = pSession.postingId {
                allPostingSessionArr.add(postingId)
            }
        }

        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            if let necropsyId = nIdSession.necropsyId {
                allPostingSessionArr.add(necropsyId)
            }
        }

        return allPostingSessionArr
    }
    
    // MARK: ******* Get All Session for Turkey**********/
    func allSessionArrTurkey() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j) as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w) as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            if let postingId = pSession.postingId {
                allPostingSessionArr.add(postingId)
            }
        }

        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            if let necropsyId = nIdSession.necropsyId {
                allPostingSessionArr.add(necropsyId)
            }
        }
        return allPostingSessionArr
    }
    
    // MARK: ******* Method for Fail with Error Message **********/
    
    func failWithError(statusCode:Int) {
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        Helper.dismissGlobalHUD((UIApplication.shared.keyWindow)!)
        if statusCode == 0{
            Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again.(NA)")
        } else {
            
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
                
            } else if lngId == 3 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
        }
    }
    
    func dismisLoader() {
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            Helper.dismissGlobalHUD(keyWindow)
        }
    }
    
    // MARK: ******* Method for Internet Connection Fail with Error Message **********/
    func failWithErrorInternal() {
        self.dismisLoader()
        Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
        
    }
    
    func startLoaderTurkey() {
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(Constants.dataSyncingMessage, comment: ""))
    }
    
    func didFinishApiLoader() {
        Helper.dismissGlobalHUD((UIApplication.shared.keyWindow)!)
    }
    
    func failWithInternetConnection(){
        appDelegateObj.testFuntion()
    }
    // MARK: ******* Navigate to Bird Selection Screen **********/
    func didFinishApi(){
        
        Helper.dismissGlobalHUD((UIApplication.shared.keyWindow)!)
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        
    }
    
    // MARK: ******* Logout Method **********/
    func logoutBtnAction(){
        
        self.ssologoutMethod()
    
        let userType = UserDefaults.standard.string(forKey:"userType")
        
        let errorMSg = Constants.areYouSureToLogoutStr
        let alertController = UIAlertController(title: Constants.alertStr, message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            
            UserDefaults.standard.set(false, forKey: "hasVaccinationDataLoaded")
            if userType == "PVE" {// For PVE
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "syncDataNoti"),object: nil))
            }
            if userType == "PE" {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "peSyncDataNoti"),object: nil))
            }
            else if userType == "Microbial"{
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "microbialSyncDataNoti"),object: nil))
            }
            else if userType == "FlockHealth"{
                self.logoutActionFlockHealth()
            }
            else  if userType == "Vaccination"{
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TraningSyncDataNoti"),object: nil))
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) 
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    // MARK: ******* Flock Health Logout Method **********/
    func logoutActionFlockHealth() {
        
        UserDefaults.standard.set(false, forKey: "newlogin")
        
        UserDefaults.standard.set(true, forKey: "callDraftApi")
        ViewController.savePrevUserLoggedInDetails()
        ViewController.clearDataBeforeLogout()
        self.ssologoutMethod()
        
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: ViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    // MARK: ******* Tranning & Certification Logout Method **********/
    func logoutActionTraningAndCertification() {
        
        UserDefaults.standard.set(false, forKey: "newlogin")
        UserDefaults.standard.set(true, forKey: "callDraftApi")
        ViewController.savePrevUserLoggedInDetails()
        self.ssologoutMethod()
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: ViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    // MARK: ******* Clear Data Before Logout **********/
    class func clearDataBeforeLogout(){
        
        PasswordService.shared.deleteUsername()
        PasswordService.shared.deletePassword()
        UserDefaults.standard.setValue(false, forKey: "isSession")
        UserDefaults.standard.removeObject(forKey: "ModuleId")
        UserDefaults.standard.removeObject(forKey: "ModuleName")
        UserDefaults.standard.removeObject(forKey: "RoleId")
        UserDefaults.standard.removeObject(forKey: "RoleIds")
        UserDefaults.standard.removeObject(forKey: "nonUScountryId")
        UserDefaults.standard.removeObject(forKey: "birdTypeId")
        UserDefaults.standard.removeObject(forKey: "switchBird")
        UserDefaults.standard.removeObject(forKey: "turkeyReport")
        UserDefaults.standard.removeObject(forKey: "countryId")
        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
        UserDefaults.standard.removeObject(forKey: "Role")
        UserDefaults.standard.removeObject(forKey: "login")
        UserDefaults.standard.removeObject(forKey: "FirstName")
        UserDefaults.standard.removeObject(forKey: "LastName")
        UserDefaults.standard.removeObject(forKey: "Id")
        UserDefaults.standard.removeObject(forKey: "isFreshLaunched")
        CoreDataHandler().deleteAllData("PVE_CustomerComplexPopup")
        CoreDataHandler().deleteAllData("Customer_PVE")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: ******* Save Previous Logged in User **********/
    class func savePrevUserLoggedInDetails(){
        let keychainHelper = AccessTokenHelper()
        let ModuleId = UserDefaults.standard.value(forKey:"ModuleId") as? String ?? ""
        let ModuleName = UserDefaults.standard.value(forKey:"ModuleName") as? String ?? ""
        let RoleId =  UserDefaults.standard.value(forKey:"RoleId") as? Int ?? 0
        let nonUScountryId =  UserDefaults.standard.value(forKey:"nonUScountryId") as? Int ?? 0
        let birdTypeId =  UserDefaults.standard.value(forKey:"birdTypeId") as? Int ?? 0
        let switchBird =  UserDefaults.standard.value(forKey:"switchBird") as? Int ?? 0
        let turkeyReport =  UserDefaults.standard.value(forKey:"turkeyReport") as? Bool ?? false
        let countryId =  UserDefaults.standard.value(forKey:"countryId") as? Int ?? 0
        
        let aceesTokentype = keychainHelper.getFromKeychain(keyed: Constants.accessToken)
      
      //  let aceesTokentype = UserDefaults.standard.value(forKey:Constants.accessToken) as? String ?? ""
        
        let Role =  UserDefaults.standard.value(forKey:"Role") as? Int ?? 0
        let login =  UserDefaults.standard.value(forKey:"login") as? Bool ?? false
        let FirstName = UserDefaults.standard.value(forKey:"FirstName") as? String ?? ""
        let LastName = UserDefaults.standard.value(forKey:"LastName") as? String ?? ""
        let Id =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let userName = PasswordService.shared.getUsername()
        let pass = PasswordService.shared.getPassword()
        
        UserDefaults.standard.set(userName, forKey: "userNamePrev")
        UserDefaults.standard.set(pass, forKey: "passPrev")
        
        UserDefaults.standard.set(ModuleId, forKey: "ModuleIdPrev")
        UserDefaults.standard.set(ModuleName, forKey: "ModuleNamePrev")
        UserDefaults.standard.set(RoleId, forKey: "RoleIdPrev")
        UserDefaults.standard.set(nonUScountryId, forKey: "nonUScountryIdPrev")
        UserDefaults.standard.set(birdTypeId, forKey: "birdTypeIdPrev")
        UserDefaults.standard.set(switchBird, forKey: "switchBirdPrev")
        UserDefaults.standard.set(turkeyReport, forKey: "turkeyReportPrev")
        UserDefaults.standard.set(countryId, forKey: "countryIdPrev")
       // UserDefaults.standard.set(aceesTokentype, forKey: "aceesTokentypePrev")
        
        
        keychainHelper.saveToKeychain(valued: "\(String(describing: aceesTokentype))", keyed: "aceesTokentypePrev")
        
        UserDefaults.standard.set(Role, forKey: "RolePrev")
        UserDefaults.standard.set(login, forKey: "loginPrev")
        UserDefaults.standard.set(FirstName, forKey: "FirstNamePrev")
        UserDefaults.standard.set(LastName, forKey: "LastNamePrev")
        UserDefaults.standard.set(Id, forKey: "IdPrev")
        UserDefaults.standard.synchronize()
        
    }
    
    // MARK: ******* Save Previous Logged in User other Detail **********/
    func savePrevUserLoggedInDetailsToCurrentForOfflineLogin(){
        let keychainHelper = AccessTokenHelper()
        let ModuleIdPrev = UserDefaults.standard.value(forKey:"ModuleIdPrev") as? String ?? ""
        let ModuleNamePrev = UserDefaults.standard.value(forKey:"ModuleNamePrev") as? String ?? ""
        let RoleIdPrev =  UserDefaults.standard.value(forKey:"RoleIdPrev") as? Int ?? 0
        let nonUScountryIdPrev =  UserDefaults.standard.value(forKey:"nonUScountryIdPrev") as? Int ?? 0
        let birdTypeIdPrev =  UserDefaults.standard.value(forKey:"birdTypeIdPrev") as? Int ?? 0
        let switchBirdPrev =  UserDefaults.standard.value(forKey:"switchBirdPrev") as? Int ?? 0
        let turkeyReportPrev =  UserDefaults.standard.value(forKey:"turkeyReportPrev") as? Bool ?? false
        let countryIdPrev =  UserDefaults.standard.value(forKey:"countryIdPrev") as? Int ?? 0
       // let aceesTokentypePrev = UserDefaults.standard.value(forKey:"aceesTokentypePrev") as? String ?? ""
        
        
        let aceesTokentypePrev = keychainHelper.getFromKeychain(keyed: "aceesTokentypePrev")

     
        
        let RolePrev =  UserDefaults.standard.value(forKey:"RolePrev") as? Int ?? 0
        let loginPrev =  UserDefaults.standard.value(forKey:"loginPrev") as? Bool ?? false
        let FirstNamePrev = UserDefaults.standard.value(forKey:"FirstNamePrev") as? String ?? ""
        let LastNamePrev = UserDefaults.standard.value(forKey:"LastNamePrev") as? String ?? ""
        let IdPrev =  UserDefaults.standard.value(forKey:"IdPrev") as? Int ?? 0
        let LastName = UserDefaults.standard.value(forKey:"LastName") as? String ?? ""
        let userNamePrev = UserDefaults.standard.value(forKey:"userNamePrev") as? String ?? ""
        let passPrev = UserDefaults.standard.value(forKey:"passPrev") as? String ?? ""
        
        PasswordService.shared.setUsername(password: userNamePrev)
        PasswordService.shared.setPassword(password: passPrev)
        
        UserDefaults.standard.set(ModuleIdPrev, forKey: "ModuleId")
        UserDefaults.standard.set(ModuleNamePrev, forKey: "ModuleName")
        UserDefaults.standard.set(RoleIdPrev, forKey: "RoleId")
        UserDefaults.standard.set(nonUScountryIdPrev, forKey: "nonUScountryId")
        UserDefaults.standard.set(birdTypeIdPrev, forKey: "birdTypeId")
        UserDefaults.standard.set(switchBirdPrev, forKey: "switchBird")
        UserDefaults.standard.set(turkeyReportPrev, forKey: "turkeyReport")
        UserDefaults.standard.set(countryIdPrev, forKey: "countryId")
          
       
        keychainHelper.saveToKeychain(valued: "\(String(describing: aceesTokentypePrev))", keyed: Constants.accessToken)
      //  UserDefaults.standard.set(aceesTokentypePrev, forKey: Constants.accessToken)
    
        UserDefaults.standard.set(RolePrev, forKey: "Role")
        UserDefaults.standard.set(loginPrev, forKey: "login")
        UserDefaults.standard.set(FirstNamePrev, forKey: "FirstName")
        UserDefaults.standard.set(LastNamePrev, forKey: "LastName")
        UserDefaults.standard.set(LastName, forKey: "LastName")
        UserDefaults.standard.set(IdPrev, forKey: "Id")
        
    }
    // MARK: ******* Setup Header **********/
    private func setupHeader() {
        bottomViewController = BottomViewController()
        self.bottomView.addSubview(bottomViewController.view)
        self.topviewConstraint(vwTop: bottomViewController.view)
    }
    
    // MARK: ******* Select Complex **********/
    @IBAction func didSelectOnComplex(_ sender: AnyObject) {
        view.endEditing(true)
        tableViewpop()
    }
    
    // MARK: ************* Dropdown popup  ***************
    func tableViewpop() {
        
        if btnTag == 1
        {
            if countryArray.count == 0 {
                self.showToastWithTimer(message: Constants.gigyaValidation, duration: 3.0)
                return
            }
            
            self.dropDownVIewNew(arrayData: countryArray, kWidth: countryView.frame.width, kAnchor: countryView, yheight: countryView.bounds.height) { [unowned self] selectedVal, index  in
                self.lblCountry.text = selectedVal
                UserDefaults.standard.set(selectedVal, forKey: "Country")
          
                self.lblCountry.textColor = .black
                let countryID = countryIdIs[index]
                let strCountryId = String(describing: countryID)
                UserDefaults.standard.set(strCountryId, forKey: "CountryIdIs")
                self.langNameArray.removeAll()
                self.langIdArray.removeAll()
                self.langCultureArray.removeAll()
                self.fetchGigyaCountryLang(countryId: strCountryId)
                self.fetchGigyaApiKeys(countryId: strCountryId)
                self.lblLanguage.text = ""
                
            }
        }
        else
        {
            
            if countryArray.count == 0 {
                self.showToastWithTimer(message: "Failed to get Gigya Language list", duration: 3.0)
                return
            }
            self.dropDownVIewNew(arrayData: langNameArray, kWidth: languageView.frame.width, kAnchor: languageView, yheight: languageView.bounds.height) { [unowned self] selectedVal, index  in
                self.lblLanguage.text = selectedVal
                UserDefaults.standard.set(selectedVal, forKey: "Language")
                
                self.lblLanguage.textColor = .black
                if selectedVal == "English" {
                    UserDefaults.standard.set(1, forKey: "lngId")
                    LanguageUtility.setAppleLAnguageTo(lang: "en")
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.set(3, forKey: "lngId")
                    LanguageUtility.setAppleLAnguageTo(lang: "fr")
                    UserDefaults.standard.synchronize()
                }
            }
            
        }
        self.dropHiddenAndShow()
        
    }
    
    // MARK: ************* Show Hide Drop down ***************
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    // MARK: ************* TableView delegates Method ***************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnTag == 1
        {
            return countryArray.count
        }else
        {
            return langNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if btnTag == 1
        {
            let country  = countryArray[indexPath.row]
            cell.textLabel!.text = country
        }else
        {
            let lang  = langNameArray[indexPath.row]
            cell.textLabel!.text = lang
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if btnTag == 1
        {
            let str = countryArray[indexPath.row]
           
            lblCountry.text = str
            
            lblCountry.textColor = .black
            lblLanguage.text = ""
            langNameArray.removeAll()
            langIdArray.removeAll()
            langCultureArray.removeAll()
        }else
        {
            let str = langNameArray[indexPath.row] as! String
            lblLanguage.textColor = .black
            lblLanguage.text = str
        }
        
        switch indexPath.row {
            
        case 0:
            UserDefaults.standard.set(1, forKey: "lngId")
            LanguageUtility.setAppleLAnguageTo(lang: "en")
            UserDefaults.standard.synchronize()
            
            break
        case 1:
            UserDefaults.standard.set(3, forKey: "lngId")
            LanguageUtility.setAppleLAnguageTo(lang: "fr")
            UserDefaults.standard.synchronize()
            
            break
            
        default:
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "newlogin") == true {
            if checkUserDataIsInDbOrNotPE(){
                navigateToPEDashboard()
            } else {
                callSelectionModule()
            }
        }else
        {
            
            if let value = UserDefaults.standard.object(forKey: "Country") {
                
                lblCountry.text = value as? String
                lblCountry.textColor = .black
                
            } else {
                lblCountry.text = selectCountryStr
                lblCountry.textColor = .lightGray
                
            }
            
            if let value = UserDefaults.standard.object(forKey: "Language") {
                
                lblLanguage.text = value as? String
                lblLanguage.textColor = .black
            } else {
                lblLanguage.text = selectLangStr
                lblLanguage.textColor = .lightGray
            }
            
            self.fetchGigyaCountryList()
        }
    }
    
    // MARK: ************* Call Selection MOdule ***************
    func callDashBordView() {
        callSelectionModule()
    }
    
    // MARK: ************* Delete all Saved Data from DB ***************
    override func deleteAllData(_ entityName: String) {
        // Ensure this function runs on the main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.sync {
                self.deleteAllData(entityName)
            }
            return
        }
        
        // Get the managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to get AppDelegate")
            return
        }
        let managedContext = appDelegate.managedObjectContext
        
        // Create a fetch request to delete all entities
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                if let object = managedObject as? NSManagedObject {
                    managedContext.delete(object)
                }
            }
            try managedContext.save() // Save changes to persist deletions
            //   debugPrint("Successfully deleted all data for entity: \(entityName)")
        } catch {
            print("Failed to fetch or delete data: \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func btnSignIn(_ sender: AnyObject) {
        
        // loginMethod()
        //ssologinMethod()
    }
    
    // MARK: ************* Call Selection MOdule ***************
    func callDashBoard() {
        UserDefaults.standard.set(true, forKey: "newlogin")
        callSelectionModule()
        
    }
    
    // MARK: ************* Call Global DashBoard MOdule ***************
    func callSelectionModule(){
        UserDefaults.standard.set(true, forKey: "newlogin")
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GlobalDashboardViewController") as? GlobalDashboardViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    
    func animateView (_ movement: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        })
    }
    
    
    // MARK: ZoetisWebServices to Call Get Api For Posting Session **************************************/

    fileprivate func handleJsonArr(json:JSON) {
        if let arr = JSON(json).array, !arr.isEmpty {
            for item in arr {
                CoreDataHandler().getPostingData((item.dictionaryObject as NSDictionary?)!)
            }
            
            let postingData = CoreDataHandler().fetchAllPostingExistingSession()
            
            if postingData.count > 0 {
                self.getPostingDataFromServerforVaccination()
            } else {
                self.getCNecStep1Data()
            }
        } else {
            self.getPostingDataFromServerforVaccination()
        }
    }
    
    func getPostingDataFromServer(){
        self.deleteAllData("PostingSession")
        if WebClass.sharedInstance.connected() {
            Helper.dismissGlobalHUD(self.view)
            _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: Constants.loginLoaderMessage)
            let Id = UserDefaults.standard.value(forKey: "Id") as! Int
            let devType = Constants.deviceType
            let newUrl = ZoetisWebServices.EndPoint.getPostingSessionList.latestUrl + "\(Id)&DeviceType=\(devType)"
            
            ZoetisWebServices.shared.getPostedSessionResponceForChicken(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.handleJsonArr(json: json)
                }
            })
            
        } else {
            self.alerViewInternet()
        }
    }
    
 
    // MARK: ***********ZoetisWebServices to Call Get Api For Feed Session  Implementation ************/
    
    func getPostingDataFromServerforFeed() {
        self.deleteAllData("AlternativeFeed")
        self.deleteAllData("AntiboticFeed")
        self.deleteAllData("CoccidiosisControlFeed")
        self.deleteAllData("MyCotoxinBindersFeed")
        
        if WebClass.sharedInstance.connected() {
            var id = Int()
            id = UserDefaults.standard.value(forKey: "Id") as! Int
            let devType = Constants.deviceType
            let newUrl = ZoetisWebServices.EndPoint.getFlockFeedList.latestUrl + "\(id)&DeviceType=\(devType)"
            ZoetisWebServices.shared.getFlockFeedSessionResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    let arr = json
                    // Iterate over the array of dictionaries
                    for posDict in arr {
                        let jsonData = posDict.1  // This accesses the JSON part of the tuple
                        
                        guard let sessionId = jsonData["sessionId"].int else { continue }
                        guard let feedDictArr = jsonData["Feeds"].array else { continue }
                        
                        // Continue processing as before
                        for feedDict in feedDictArr {
                            guard let feedId = feedDict["feedId"].int else { continue }
                            let nsFeedId = UserDefaults.standard.integer(forKey: "feedId")
                            
                            if feedId > nsFeedId {
                                UserDefaults.standard.set(feedId, forKey: "feedId")
                            }
                            
                            let feedName = feedDict["feedName"].string ?? ""
                            let startDate = feedDict["startDate"].string ?? ""
                            
                            CoreDataHandler().getFeedNameFromGetApi(sessionId as NSNumber, sessionId: sessionId as NSNumber, feedProgrameName: feedName, feedId: feedId as NSNumber, startDate: startDate)
                            
                            if let feedDetailArr = feedDict["feedCategoryDetails"].array {
                                for feedDetail in feedDetailArr {
                                    guard let feedCatName = feedDetail["feedProgramCategory"].string else { continue }
                                    
                                    switch feedCatName {
                                    case "Coccidiosis Control":
                                        self.processFeedDetails(feedDetail.rawValue as! [String : Any], category: "Coccidiosis Control", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
                                    case "Antibiotic":
                                        self.processFeedDetails(feedDetail.rawValue as! [String : Any], category: "Antibiotic", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
                                    case "Alternatives":
                                        self.processFeedDetails(feedDetail.rawValue as! [String : Any], category: "Alternatives", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
                                    case "Mycotoxin Binders":
                                        self.processFeedDetails(feedDetail.rawValue as! [String : Any], category: "Mycotoxin Binders", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                    }
                    self.getCNecStep1Data()
                }
            })
        } else {
            self.alerViewInternet()
        }
    }
    
    private func clearFeedCoreData() {
        self.deleteAllData("AlternativeFeed")
        self.deleteAllData("AntiboticFeed")
        self.deleteAllData("CoccidiosisControlFeed")
        self.deleteAllData("MyCotoxinBindersFeed")
    }

//    private func fetchFeedDataFromServer() {
//        guard let id = UserDefaults.standard.value(forKey: "Id") as? Int else { return }
//        let devType = Constants.deviceType
//        let newUrl = ZoetisWebServices.EndPoint.getFlockFeedList.latestUrl + "\(id)&DeviceType=\(devType)"
//        ZoetisWebServices.shared.getFlockFeedSessionResponce(controller: self, url: newUrl) { [weak self] (json, error) in
//            guard let self = self else { return }
//            if let error = error {
//                print("Error fetching data: \(error.localizedDescription)")
//                return
//            }
//            DispatchQueue.main.async {
//                self.processFeedSessions(json.rawValue as! [(String, JSON)])
//                self.getCNecStep1Data()
//            }
//        }
//    }

//    private func processFeedSessions(_ arr: [(String, JSON)]) {
//        for posDict in arr {
//            let jsonData = posDict.1
//            guard let sessionId = jsonData["sessionId"].int else { continue }
//            guard let feedDictArr = jsonData["Feeds"].array else { continue }
//            processFeeds(feedDictArr, sessionId: sessionId)
//        }
//    }

//    private func processFeeds(_ feedDictArr: [JSON], sessionId: Int) {
//        for feedDict in feedDictArr {
//            guard let feedId = feedDict["feedId"].int else { continue }
//            updateFeedIdIfNeeded(feedId)
//            let feedName = feedDict["feedName"].string ?? ""
//            let startDate = feedDict["startDate"].string ?? ""
//            CoreDataHandler().getFeedNameFromGetApi(sessionId as NSNumber, sessionId: sessionId as NSNumber, feedProgrameName: feedName, feedId: feedId as NSNumber, startDate: startDate)
//            if let feedDetailArr = feedDict["feedCategoryDetails"].array {
//                processFeedCategories(feedDetailArr, feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
//            }
//        }
//    }

    private func updateFeedIdIfNeeded(_ feedId: Int) {
        let nsFeedId = UserDefaults.standard.integer(forKey: "feedId")
        if feedId > nsFeedId {
            UserDefaults.standard.set(feedId, forKey: "feedId")
        }
    }

    private func processFeedCategories(_ feedDetailArr: [JSON], feedId: Int, sessionId: Int, feedName: String, startDate: String) {
        for feedDetail in feedDetailArr {
            guard let feedCatName = feedDetail["feedProgramCategory"].string else { continue }
            let feedDetailDict = feedDetail.rawValue as! [String: Any]
            switch feedCatName {
            case Constants.coccidioStr:
                self.processFeedDetails(feedDetailDict, category: Constants.coccidioStr, feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
            case "Antibiotic":
                self.processFeedDetails(feedDetailDict, category: "Antibiotic", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
            case "Alternatives":
                self.processFeedDetails(feedDetailDict, category: "Alternatives", feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
            case Constants.mytoxinStr:
                self.processFeedDetails(feedDetailDict, category: Constants.mytoxinStr, feedId: feedId, sessionId: sessionId, feedName: feedName, startDate: startDate)
            default:
                break
            }
        }
    }
    
    // Helper function to handle processing of different feed categories
    func processFeedDetails(_ feedDetail: [String: Any], category: String, feedId: Int, sessionId: Int, feedName: String, startDate: String) {
        if let feedDetails = feedDetail["feedDetails"] as? [[String: Any]] {
            for postDict in feedDetails {
                // Handle feed details based on category
                switch category {
                case Constants.coccidioStr:
                    CoreDataHandler().getDataFromCocoiiControll(postDict as NSDictionary, feedId: feedId as NSNumber, postingId: sessionId as NSNumber, feedProgramName: feedName, startDate: startDate)
                case "Antibiotic":
                    CoreDataHandler().getDataFromAntiboitic(postDict as NSDictionary, feedId: feedId as NSNumber, postingId: sessionId as NSNumber, feedProgramName: feedName, startDate: startDate)
                case "Alternatives":
                    CoreDataHandler().getDataFromAlterNative(postDict as NSDictionary, feedId: feedId as NSNumber, postingId: sessionId as NSNumber, feedProgramName: feedName, startDate: startDate)
                case Constants.mytoxinStr:
                    CoreDataHandler().getDataFromMyCocotinBinder(postDict as NSDictionary, feedId: feedId as NSNumber, postingId: sessionId as NSNumber, feedProgramName: feedName, startDate: startDate)
                default:
                    break
                }
            }
        }
    }

 
    // MARK: *********** Get Necropsy data Acessing From Server **************/
    func getPostingDataFromServerforNecorpsy() {
        self.deleteAllData("CaptureNecropsyViewData")
        guard WebClass.sharedInstance.connected() else { return }
        fetchNecropsyDataFromServer()
    }

    private func fetchNecropsyDataFromServer() {
        guard let id = UserDefaults.standard.value(forKey: "Id") as? Int else { return }
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let countryId = UserDefaults.standard.integer(forKey: "countryId")
        let url = "PostingSession/GetNecropsyListByUser?UserId=\(id)&LanguageId=\(lngId)&CountryId=\(countryId)"
        accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
        let headerDict: HTTPHeaders = ["Authorization": accestoken]
        let urlString: String = WebClass.sharedInstance.webUrl + url
        sessionManager.request(urlString, method: .get, headers: headerDict).responseJSON { response in
            self.handleNecropsyResponse(response)
        }
    }

    private func handleNecropsyResponse(_ response: AFDataResponse<Any>) {
        let statusCode = response.response?.statusCode ?? 0
        if [500, 401, 503, 403, 501, 502, 400, 504, 408].contains(statusCode) {
            self.alerView(statusCode: statusCode)
            return
        }
        switch response.result {
        case let .success(value):
            DispatchQueue.main.async {
                self.processNecropsyValue(value)
            }
        case .failure(let encodingError):
            self.handleNecropsyFailure(encodingError, response: response)
        }
    }

    private func processNecropsyValue(_ value: Any) {
        if let arr = value as? NSArray, arr.count > 0 {
            for i in 0..<arr.count {
                let sessionObj = arr.object(at: i) as AnyObject
                let sessionId = sessionObj.value(forKey: "SessionId") as! Int
                let farmArr = sessionObj.value(forKey: "Farms")
                processFarms(farmArr, sessionId: sessionId)
            }
            self.getNotesFromServer()
        } else {
            self.getNotesFromServer()
        }
    }

    private func processFarms(_ farmArr: Any?, sessionId: Int) {
        guard let farmArr = farmArr as? NSArray else { return }
        for j in 0..<farmArr.count {
            let farmObj = farmArr.object(at: j) as AnyObject
            let farmName = farmObj.value(forKey: "FarmName") as! String
            let catArr = farmObj.value(forKey: "Category")
            processCategories(catArr, farmName: farmName, sessionId: sessionId)
        }
    }

    private func processCategories(_ catArr: Any?, farmName: String, sessionId: Int) {
        guard let catArr = catArr as? NSArray else { return }
        for k in 0..<catArr.count {
            let catObj = catArr.object(at: k) as AnyObject
            let catName = catObj.value(forKey: "Category") as! String
            let obArr = catObj.value(forKey: "Observations")
            processObservations(obArr, catName: catName, farmName: farmName, sessionId: sessionId)
        }
    }

    private func processObservations(_ obArr: Any?, catName: String, farmName: String, sessionId: Int) {
        guard let obArr = obArr as? NSArray else { return }
        for l in 0..<obArr.count {
            let obsObj = obArr.object(at: l) as AnyObject
            let obsId = obsObj.value(forKey: "ObservationId") as! Int
            let refId = obsObj.value(forKey: "ReferenceId") as! NSNumber
            let languageId = obsObj.value(forKey: "LanguageId") as! NSNumber
            let obsName = obsObj.value(forKey: "Observations") as! String
            let measure = obsObj.value(forKey: "Measure") as! String
            let quickLink = obsObj.value(forKey: "DefaultQLink")
            let birdArr = (obsObj.value(forKey: "Birds") as AnyObject).object(at: 0)
            
            let birdsData = chickenCoreDataHandlerModels.chickenBirdDataProcessing(
                birdArr: birdArr,
                   catName: catName,
                   obsName: obsName,
                   farmName: farmName,
                   obsId: obsId,
                   measure: measure,
                   dataVar: (quickLink, sessionId, languageId, refId),
                   index: l
            )

            processBirds(context: birdsData)
            
        }
    }
    
    private func processBirds(context: chickenCoreDataHandlerModels.chickenBirdDataProcessing) {
        guard let birdArr = context.birdArr as? NSObject else { return }
        for m in 0..<10 {
            let keyStr = NSString(format: "BirdNumber%d", m+1)
            let chkKey3 = birdArr.value(forKey: keyStr as String) as! String
            if chkKey3 == "NA" {
                break
            }
            let chkKey = (birdArr.value(forKey: keyStr as String) as AnyObject).boolValue
            let chkKey1 = (birdArr.value(forKey: keyStr as String) as AnyObject).integerValue
            let catstr = mapCategoryName(context.catName)

            let observation = SkeletalObservationData(
                catName: catstr,
                obsName: context.obsName,
                formName: context.farmName,
                obsVisibility: chkKey!,
                birdNo: NSNumber(value: m + 1),
                obsPoint: chkKey1!,
                obsId: context.obsId,
                measure: context.measure,
                quickLink: (context.dataVar.0! as AnyObject).integerValue! as NSNumber,
                necId: context.dataVar.1 as NSNumber,
                isSync: false,
                lngId: context.dataVar.2,
                refId: context.dataVar.3,
                actualText: chkKey3
            )
            CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(observation, index: context.index)
        }
    }

    private func mapCategoryName(_ catName: String) -> String {
        switch catName {
        case "Coccidiosis": return "Coccidiosis"
        case "GI Tract": return "GITract"
        case "Immune/Others": return "Immune"
        case "Respiratory": return "Resp"
        case "Skeletal/Muscular/Integumentary": return "skeltaMuscular"
        default: return catName
        }
    }

    private func handleNecropsyFailure(_ encodingError: Error, response: AFDataResponse<Any>) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
            self.alerViewInternet()
            debugPrint(err)
        } else if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
            debugPrint(encodingError)
            debugPrint(responseString)
            self.alerViewInternet()
        }
    }
    
    // MARK: ************* ZoetisWebServices Calling to GetVaccination Data for Posted Session Data From Server  ***************************************/
    fileprivate func handlePosDictKeysValidations(_ posDict: [String : Any]) {
        for key in posDict.keys {
            if key.contains("hatchery") {
                CoreDataHandler().getHatcheryDataFromServer(posDict as NSDictionary)
            } else if key.contains("field") {
                CoreDataHandler().getFieldDataFromServer(posDict as NSDictionary)
            }
        }
    }
    
    fileprivate func saveFieldHatcheryStrainData(_ jsonArray: [JSON], _ self: ViewController) {
        for item in jsonArray {
            if let vaccinations = item["Vaccination"].array {
                for vaccination in vaccinations {
                    let posDict = vaccination.dictionaryObject ?? [:]
                    handlePosDictKeysValidations(posDict)
                }
            }
        }
        DispatchQueue.global(qos: .background).async {
            self.getPostingDataFromServerforFeed()
        }
    }
    
    func getPostingDataFromServerforVaccination(){
        self.deleteAllData("HatcheryVac")
        self.deleteAllData("FieldVaccination")
        if WebClass.sharedInstance.connected() {
            let id =  UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
            let devType = Constants.deviceType
            let newUrl = ZoetisWebServices.EndPoint.getSubmitedPostingVaccinationData.latestUrl + "\(id)&DeviceType=\(devType)"
            
            ZoetisWebServices.shared.getPostedSessionVaccinationResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
          
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                  //  self.alerView(statusCode:"")
                    return
                }
                
                if let jsonArray = JSON(json).array , !jsonArray.isEmpty  {
                    saveFieldHatcheryStrainData(jsonArray, self)
                } else {
                    DispatchQueue.global(qos: .background).async {
                        self.getPostingDataFromServerforFeed()
                    }
                }
            })
        }
        else{
            self.alerViewInternet()
        }
    }
    
    
    // MARK: ****************************** ZoetisWebServices to Get Notes data from Server & Save  ******************************/
    fileprivate func saveNotesInDB(_ item: JSON) {
        if let dict = item.dictionary {
            let noteArr = dict["Note"]?.array ?? []
            
            if !noteArr.isEmpty { // Check if Note array is not empty
                for noteItem in noteArr {
                    let sessionId = noteItem["sessionId"].int ?? 0
                    let farmName = noteItem["farmName"].string ?? ""
                    let birdNo = noteItem["birdNumber"].int ?? 0
                    let birdNotes = noteItem["Notes"].string ?? ""
                    
                    CoreDataHandler().saveNoofBirdWithNotes(
                        "",
                        notes: birdNotes,
                        formName: farmName,
                        birdNo: birdNo as NSNumber,
                        index: 0,
                        necId: sessionId as NSNumber,
                        isSync: false
                    )
                }
            }
        }
    }
    
    fileprivate func handlejsonAndGetPostingDataFromServer(_ json: JSON, _ self: ViewController) {
        DispatchQueue.main.async {
            if let arr = JSON(json).array, !arr.isEmpty {
                for item in arr {
                    self.saveNotesInDB(item)
                }
                self.getPostingDataFromServerforImage()
            } else {
                self.getPostingDataFromServerforImage()
            }
        }
    }
    
    func getNotesFromServer(){
        self.deleteAllData("NotesBird")
        if WebClass.sharedInstance.connected() {
          
            var id =  UserDefaults.standard.integer(forKey: "Id")
            let devType = Constants.deviceType
            let newUrl = ZoetisWebServices.EndPoint.getSubmittedNotesForChicken.latestUrl + "\(id)&DeviceType=\(devType)"
            
            ZoetisWebServices.shared.getNotesPostedSessionResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    //  self.alerView(statusCode:"")
                    return
                }
                
                self.handlejsonAndGetPostingDataFromServer(json, self)
            })
        } else{
            self.alerViewInternet()
        }
    }
    
       // MARK: ZoetisWebServices Used to  Get Necropsy Data from Server
    func getCNecStep1Data() {
        self.deleteAllData("CaptureNecropsyData")
        guard WebClass.sharedInstance.connected() else {
            self.alerViewInternet()
            return
        }
        fetchNecropsyFarmList()
    }

    private func fetchNecropsyFarmList() {
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let devType = Constants.deviceType
        let newUrl = ZoetisWebServices.EndPoint.getNecropsyFarmListForChicken.latestUrl + "\(userId)&DeviceType=\(devType)"
        ZoetisWebServices.shared.getPostedNecropsyFarmListResponce(controller: self, url: newUrl) { [weak self] (json, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.handleNecropsyFarmListResponse(json)
            }
        }
    }

    private func handleNecropsyFarmListResponse(_ json: Any) {
        if let arr = JSON(json).array, !arr.isEmpty {
            for item in arr {
                self.processNecropsyFarmItem(item)
            }
            self.finalizePostingSessions()
            self.checkAndFetchNecropsyData()
        } else {
            self.getPostingDataFromServerforNecorpsy()
        }
    }

    private func processNecropsyFarmItem(_ item: JSON) {
        let sessionId = item["SessionId"].intValue
        let devSessionId = item["deviceSessionId"].stringValue
        let lngId = item["LanguageId"].numberValue
        let custId = item["CustomerId"].intValue
        let complexId = item["ComplexId"].intValue
        let complexName = item["ComplexName"].stringValue
        let sessionDate = item["SessionDate"].stringValue
        let seesDat = self.convertDateFormater(sessionDate)
        let farmArr = item["Farms"].arrayValue

        for farmItem in farmArr {
            
            let farmData = chickenCoreDataHandlerModels.submitdNecrStep1Data(
                farmItem: farmItem,
                sessionId: sessionId,
                devSessionId: devSessionId,
                lngId: lngId,
                custId: custId,
                complexId: complexId,
                complexName: complexName,
                seesDat: seesDat
            )

            self.saveFarmNecropsyStep1(farmData)
            
        }
    }
    
    private func saveFarmNecropsyStep1(_ data: chickenCoreDataHandlerModels.submitdNecrStep1Data) {
        let farmName = data.farmItem["farmName"].stringValue
        let postingArr = CoreDataHandler().fetchAllPostingSession(data.sessionId as NSNumber)
        for postItem in postingArr {
            guard let posttingSes = postItem as? PostingSession else { continue }
            let vetId = posttingSes.veterinarianId
            CoreDataHandler().updateFinalizeDataWithNec(data.sessionId as NSNumber, finalizeNec: vetId == 0 ? 2 : 1)
        }
        
        let age = data.farmItem["age"].stringValue
        let birds = data.farmItem["birds"].stringValue
        let houseNo = data.farmItem["houseNo"].stringValue
        let flockId = data.farmItem["flockId"].stringValue
        let feedProgram = data.farmItem["feedProgram"].stringValue
        let sick = data.farmItem["sick"].boolValue
        let feedId = data.farmItem["FeedId"].intValue
        let farmId = data.farmItem["DeviceFarmId"].intValue
        let ImgId = data.farmItem["ImgId"].intValue
        
        let necropsyData = chickenCoreDataHandlerModels.saveNecropsyStep1Data(
            postingId: data.sessionId as NSNumber,
            age: age,
            farmName: farmName,
            feedProgram: feedProgram,
            flockId: flockId,
            houseNo: houseNo,
            noOfBirds: birds,
            sick: sick as NSNumber,
            necId: data.sessionId as NSNumber,
            compexName: data.complexName,
            complexDate: data.seesDat,
            complexId: data.complexId as NSNumber,
            custmerId: data.custId as NSNumber,
            feedId: feedId as NSNumber,
            isSync: false,
            timeStamp: data.devSessionId,
            actualTimeStamp: data.devSessionId,
            lngId: data.lngId,
            farmId: farmId as NSNumber,
            imageId: ImgId as NSNumber,
            count: 0
        )
        
        CoreDataHandler().SaveNecropsystep1(data: necropsyData)
    }

    private func finalizePostingSessions() {
        let postingData = CoreDataHandler().fetchAllPostingExistingSession()
        for pdOb in postingData {
            guard let pdOB1 = pdOb as? PostingSession else { continue }
            let step1data = CoreDataHandler().FetchNecropsystep1neccId(pdOB1.postingId ?? 0)
            if step1data.count < 1 {
                CoreDataHandler().updateFinalizeDataWithNecGetApi(pdOB1.postingId ?? 0, finalizeNec: 0)
            }
        }
    }

    private func checkAndFetchNecropsyData() {
        let necArr = CoreDataHandler().FetchNecropsystep1AllNecId()
        if necArr.count > 0 {
            self.getPostingDataFromServerforNecorpsy()
        }
    }

    // ... existing code ...
    
    
    // MARK: ******************* ZoetisWebServices Get Posting Data from Server for Images
    fileprivate func termAndConditionViewCheck() {
        if self.termsCond == 0 {
            UserDefaults.standard.set(true, forKey: "login")
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "terms") as? Terms_ConditionViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
        } else {
            UserDefaults.standard.set(true, forKey: "login")
            self.callDashBordView()
        }
    }
    
    fileprivate func getTurkeyPostedSessionFromServer(birdTypeIdIs:Int) {
        Helper.dismissGlobalHUD(self.view)
        
        if birdTypeIdIs == 3{
            self.getPostingDataFromServerTurkey()
        }
        else{
            
            self.termAndConditionViewCheck()
        }
    }
    
    fileprivate func saveImagesFromServer(_ arr: [JSON]) {
        for item in arr {
            
            guard let imagesArray = item["Images"].array, !imagesArray.isEmpty else {
                continue
            }
            
            for image in imagesArray {
                if let imageDict = image.dictionaryObject as NSDictionary? {
                    CoreDataHandler().getSaveImageFromServer(imageDict)
                }
            }
        }
        let birdTypeId = UserDefaults.standard.integer(forKey: "birdTypeId")
        self.getTurkeyPostedSessionFromServer(birdTypeIdIs: birdTypeId)
    }
    
    func getPostingDataFromServerforImage(){
        let birdTypeId = UserDefaults.standard.integer(forKey: "birdTypeId")
        self.deleteAllData("BirdPhotoCapture")
        if WebClass.sharedInstance.connected() {
            
            let Id =   UserDefaults.standard.value(forKey: "Id") as! Int
            let DevType = Constants.deviceType
            let newUrl = ZoetisWebServices.EndPoint.getNecropsySubmittedImagesforChicken.latestUrl + "\(Id)&DeviceType=\(DevType)"
            
            ZoetisWebServices.shared.getNecropsyImagesListResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    //  self.alerView(statusCode:"")
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let arr = JSON(json).array, !arr.isEmpty {
                        self.saveImagesFromServer(arr)
                    }
                    else{
                        
                        self.getTurkeyPostedSessionFromServer(birdTypeIdIs: birdTypeId)
                    }
                }
            })
            
        } else{
            self.alerViewInternet()
        }
        
    }
 
    // MARK: Data Formatter
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
    // MARK: Alert View
    func alerView(statusCode: Int) {
      //  UserDefaults.standard.removeObject(forKey: "Id")
        self.deleteAllData("Login")
        let alertController = UIAlertController(title: "", message: "Unable to get data from server.\n(\(statusCode))", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Retry", style: UIAlertAction.Style.default) {
            (_: UIAlertAction) -> Void in
            Helper.dismissGlobalHUD(self.view)
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: Internet Alert View
    func alerViewInternet() {
     //   UserDefaults.standard.removeObject(forKey: "Id")
        self.deleteAllData("Login")
        let alertController = UIAlertController(title: "", message: "No internet connection. Please try again!", preferredStyle: UIAlertController.Style.alert) //Replace
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (_: UIAlertAction) -> Void in
            Helper.dismissGlobalHUD(self.view)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:  *************************  TURKEY Modules  Methods *************************
    
    // MARK:  Get Posting Data From Server For Turkey
    fileprivate func handlePostedTurkeySession(json:JSON) {
        if let arr = JSON(json).array, !arr.isEmpty {
            // Use a single CoreDataHandler instance
            let coreDataHandler = CoreDataHandlerTurkey()
            
            // Loop through and process each item in the array
            for posDict in arr {
                if let dict = posDict.dictionaryObject {
                    coreDataHandler.getPostingDataTurkey(dict as NSDictionary)
                }
            }
            
            // Fetch posting data only once after processing
            let postingData = coreDataHandler.fetchAllPostingExistingSessionTurkey()
            
            // Check if postingData exists
            if postingData.count>0 {
                self.getPostingDataFromServerforVaccinationTurkey()
            } else {
                // Handle case where postingData is empty if necessary
                // Maybe log a message or show an alert
            }
        } else {
            // Handle case where arr is empty or nil
            self.getPostingDataFromServerforVaccinationTurkey()
        }
    }
    
    fileprivate func handleApiResponseSuccessFromServer(_ json: JSON, _ self: ViewController) {
        DispatchQueue.main.async {
            if let arr = JSON(json).array, !arr.isEmpty {
                // Use a single CoreDataHandler instance
                let coreDataHandler = CoreDataHandlerTurkey()
                
                // Loop through and process each item in the array
                for posDict in arr {
                    if let dict = posDict.dictionaryObject {
                        coreDataHandler.getPostingDataTurkey(dict as NSDictionary)
                    }
                }
                
                // Fetch posting data only once after processing
                let postingData = coreDataHandler.fetchAllPostingExistingSessionTurkey()
                
                // Check if postingData exists
                if postingData.count>0 {
                    self.getPostingDataFromServerforVaccinationTurkey()
                }
            } else {
                // Handle case where arr is empty or nil
                self.getPostingDataFromServerforVaccinationTurkey()
            }
            // self.handlePostedTurkeySession(json: json)
        }
    }
    
    func getPostingDataFromServerTurkey() {
        if WebClass.sharedInstance.connected() {
            Helper.dismissGlobalHUD(self.view)
            _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: Constants.loginLoaderMessage)
            let Id = UserDefaults.standard.value(forKey: "Id") as! Int
            let newUrl = ZoetisWebServices.EndPoint.getTurkeyPostedSession.latestUrl + "\(Id)&DeviceType=\(Constants.deviceType)"
            ZoetisWebServices.shared.getTurkeyPostedSessionsListResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let statusCode = errorResult["errorCode"]?.int ?? 0
                    
                    print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
                    
                    if statusCode == 500  || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408 {
                        self.alerView(statusCode: statusCode)
                    }
                }
                
                self.handleApiResponseSuccessFromServer(json, self)

            })
        } else {
            self.alerViewInternet()
        }
        
    }
    
    // MARK:  Get Necropsy Data From Server For Turkey **************************************************************************************/
    func getCNecStep1DataTurkey() {
        self.deleteAllData("CaptureNecropsyDataTurkey")
        guard WebClass.sharedInstance.connected() else { return }
        fetchTurkeyFarmList()
    }

    private func fetchTurkeyFarmList() {
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let newUrl = ZoetisWebServices.EndPoint.getTukeyPostedFarmList.latestUrl + "\(userId)&DeviceType=\(Constants.deviceType)"
        ZoetisWebServices.shared.getTukeyPostedFarmListResponce(controller: self, url: newUrl) { [weak self] (json, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            self.handleTurkeyFarmListResponse(json)
        }
    }

    private func handleTurkeyFarmListResponse(_ json: Any) {
        let jsonResponse = JSON(json)
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.int ?? 0
            print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
            if [500, 401, 503, 403, 501, 502, 400, 504, 404, 408].contains(statusCode) {
                self.alerView(statusCode: statusCode)
            }
        }
        DispatchQueue.main.async {
            if let arr = JSON(json).array, !arr.isEmpty {
                for item in arr {
                    self.processTurkeyFarmSession(item)
                }
                self.finalizeTurkeyPostingSessions()
                self.checkAndFetchTurkeyNecropsyData()
            } else {
                self.getPostingDataFromServerforNecorpsyTurkey()
            }
        }
    }

    private func processTurkeyFarmSession(_ item: JSON) {
        guard let sessionDict = item.dictionaryObject else { return }
        guard let sessionId = sessionDict["SessionId"] as? Int,
              let devSessionId = sessionDict["deviceSessionId"] as? String,
              let lngId = sessionDict["LanguageId"] as? NSNumber,
              let custId = sessionDict["CustomerId"] as? Int,
              let complexId = sessionDict["ComplexId"] as? Int,
              let complexName = sessionDict["ComplexName"] as? String,
              let sessionDate = sessionDict["SessionDate"] as? String else { return }
        let seesDat = self.convertDateFormater(sessionDate)
        guard let farmArr = sessionDict["Farms"] as? [[String: Any]], !farmArr.isEmpty else { return }
        for farmDict in farmArr {
            
            let input = CoreDataHandlerTurkeyModels.TurkeyFarmNecropsyInput(
                farmDict: farmDict,
                sessionId: sessionId,
                devSessionId: devSessionId,
                lngId: lngId,
                custId: custId,
                complexId: complexId,
                complexName: complexName,
                seesDat: seesDat
            )

            self.saveTurkeyFarmNecropsyStep1(input)
            
        }
    }
    
    private func saveTurkeyFarmNecropsyStep1(_ input: CoreDataHandlerTurkeyModels.TurkeyFarmNecropsyInput) {
        guard let farmName = input.farmDict["farmName"] as? String else { return }
        
        let postingArr = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(input.sessionId as NSNumber)
        for posttingSes in postingArr {
            guard let postSes = posttingSes as? PostingSessionTurkey else { continue }
            let vetId = postSes.veterinarianId
            CoreDataHandlerTurkey().updateFinalizeDataWithNecTurkey(input.sessionId as NSNumber, finalizeNec: vetId == 0 ? 2 : 1)
        }
        
        guard let age = input.farmDict["age"] as? Int,
              let birds = input.farmDict["birds"] as? Int,
              let houseNo = input.farmDict["houseNo"] as? String,
              let flockId = input.farmDict["flockId"] as? String,
              let feedProgram = input.farmDict["feedProgram"] as? String,
              let sick = input.farmDict["sick"] as? Bool,
              let feedId = input.farmDict["FeedId"] as? Int,
              let farmId = input.farmDict["DeviceFarmId"] as? Int,
              let imgId = input.farmDict["ImgId"] as? Int,
              let farmWeight = input.farmDict["Farm_Weight"] as? String,
              let abf = input.farmDict["ABF"] as? String,
              let breed = input.farmDict["Breed"] as? String,
              let sex = input.farmDict["Sex"] as? String,
              let nameGen = input.farmDict["GenerationName"] as? String,
              let idGen = input.farmDict["GenerationId"] as? Int else { return }

        let necropsyData = CoreDataHandlerTurkeyModels.saveTurkeyNecropsyStep1Data(
            postingId: input.sessionId as NSNumber,
            age: String(age),
            farmName: farmName,
            feedProgram: feedProgram,
            flockId: flockId,
            houseNo: houseNo,
            noOfBirds: String(birds),
            sick: sick as NSNumber,
            necId: input.sessionId as NSNumber,
            compexName: input.complexName,
            complexDate: input.seesDat,
            complexId: input.complexId as NSNumber,
            customerId: input.custId as NSNumber,
            feedId: feedId as NSNumber,
            isSync: false,
            timeStamp: input.devSessionId,
            actualTimeStamp: input.devSessionId,
            lngId: input.lngId,
            farmWeight: farmWeight,
            abf: abf,
            breed: breed,
            sex: sex,
            farmId: farmId as NSNumber,
            imageId: imgId as NSNumber,
            count: 0,
            genName: nameGen,
            genId: idGen as NSNumber
        )

        CoreDataHandlerTurkey().SaveNecropsystep1Turkey(necropsyData)
    }

    private func finalizeTurkeyPostingSessions() {
        let postingData = CoreDataHandlerTurkey().fetchAllPostingExistingSessionTurkey()
        for pdOb in postingData {
            if let pdOB1 = pdOb as? PostingSessionTurkey {
                let step1data = CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(pdOB1.postingId!)
                if step1data.count < 1 {
                    CoreDataHandlerTurkey().updateFinalizeDataWithNecGetApiTurkey(pdOB1.postingId!, finalizeNec: 0)
                }
            }
        }
    }

    private func checkAndFetchTurkeyNecropsyData() {
        let necArr = CoreDataHandlerTurkey().FetchNecropsystep1AllNecIdTurkey()
        if necArr.count > 0 {
            self.getPostingDataFromServerforNecorpsyTurkey()
        }
    }
    
    // MARK: *************Get Posting data From Server for Necropsy ***************************************/
    func getPostingDataFromServerforNecorpsyTurkey() {
        self.deleteAllData("CaptureNecropsyViewDataTurkey")
        guard WebClass.sharedInstance.connected() else { return }
        fetchTurkeyNecropsyDataFromServer()
    }

    private func fetchTurkeyNecropsyDataFromServer() {
        guard let id = UserDefaults.standard.value(forKey: "Id") as? Int else { return }
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let countryId = UserDefaults.standard.integer(forKey: "countryId")
        let url = "PostingSession/TurkeyGetNecropsyListByUser?UserId=\(id)&LanguageId=\(lngId)&CountryId=\(countryId)"
        accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
        let headerDict: HTTPHeaders = [Constants.authorization: accestoken]
        let urlString: String = WebClass.sharedInstance.webUrl + url
        sessionManager.request(urlString, method: .get, headers: headerDict).responseJSON { response in
            self.handleTurkeyNecropsyResponse(response)
        }
    }

    private func handleTurkeyNecropsyResponse(_ response: AFDataResponse<Any>) {
        let statusCode = response.response?.statusCode ?? 0
        if [500, 401, 503, 403, 501, 502, 400, 504, 408].contains(statusCode) {
            self.alerView(statusCode: statusCode)
            return
        }
        switch response.result {
        case let .success(value):
            DispatchQueue.main.async {
                self.processTurkeyNecropsyValue(value)
            }
        case .failure(let encodingError):
            self.handleTurkeyNecropsyFailure(encodingError, response: response)
        }
    }

    private func processTurkeyNecropsyValue(_ value: Any) {
        if let arr = value as? NSArray, arr.count > 0 {
            for i in 0..<arr.count {
                let sessionObj = arr.object(at: i) as AnyObject
                let sessionId = sessionObj.value(forKey: "SessionId") as! Int
                let farmArr = sessionObj.value(forKey: "Farms")
                processTurkeyFarms(farmArr, sessionId: sessionId)
            }
            self.getNotesFromServerTurkey()
        } else {
            self.getNotesFromServerTurkey()
        }
    }

    private func processTurkeyFarms(_ farmArr: Any?, sessionId: Int) {
        guard let farmArr = farmArr as? NSArray else { return }
        for j in 0..<farmArr.count {
            let farmObj = farmArr.object(at: j) as AnyObject
            let farmName = farmObj.value(forKey: "FarmName") as! String
            let catArr = farmObj.value(forKey: "Category")
            processTurkeyCategories(catArr, farmName: farmName, sessionId: sessionId)
        }
    }

    private func processTurkeyCategories(_ catArr: Any?, farmName: String, sessionId: Int) {
        guard let catArr = catArr as? NSArray else { return }
        for k in 0..<catArr.count {
            let catObj = catArr.object(at: k) as AnyObject
            let catName = catObj.value(forKey: "Category") as! String
            let obArr = catObj.value(forKey: "Observations")
            processTurkeyObservations(obArr, catName: catName, farmName: farmName, sessionId: sessionId)
        }
    }

    private func processTurkeyObservations(_ obArr: Any?, catName: String, farmName: String, sessionId: Int) {
        guard let obArr = obArr as? NSArray else { return }
        for l in 0..<obArr.count {
            let obsObj = obArr.object(at: l) as AnyObject
            let obsId = obsObj.value(forKey: "ObservationId") as! Int
            let refId = obsObj.value(forKey: "ReferenceId") as! NSNumber
            let languageId = obsObj.value(forKey: "LanguageId") as! NSNumber
            let obsName = obsObj.value(forKey: "Observations") as! String
            let measure = obsObj.value(forKey: "Measure") as! String
            let quickLink = obsObj.value(forKey: "DefaultQLink")
            let birdArr = (obsObj.value(forKey: "Birds") as AnyObject).object(at: 0)
            
            let input = CoreDataHandlerTurkeyModels.TurkeyBirdProcessingInput(
                birdArr: birdArr,
                catName: catName,
                obsName: obsName,
                farmName: farmName,
                obsId: obsId,
                measure: measure,
                quickLink: quickLink,
                sessionId: sessionId,
                languageId: languageId,
                refId: refId
            )

            processTurkeyBirds(input)
            
        }
    }
    
    
    private func processTurkeyBirds(_ input: CoreDataHandlerTurkeyModels.TurkeyBirdProcessingInput) {
        guard let birdArr = input.birdArr as? NSObject else { return }

        for m in 0..<10 {
            let keyStr = NSString(format: "BirdNumber%d", m+1)
            let chkKey3 = (birdArr.value(forKey: keyStr as String) as! String)
            if chkKey3 == "NA" {
                break
            }
            let chkKey = (birdArr.value(forKey: keyStr as String) as AnyObject).boolValue
            let chkKey1 = (birdArr.value(forKey: keyStr as String) as AnyObject).integerValue
            let catstr = mapTurkeyCategoryName(input.catName)

            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: catstr,
                obsName: input.obsName,
                formName: input.farmName,
                obsVisibility: chkKey!,
                birdNo: (m + 1) as NSNumber,
                obsPoint: chkKey1!,
                index: m,
                obsId: input.obsId,
                measure: input.measure,
                quickLink: (input.quickLink! as AnyObject).integerValue! as NSNumber,
                necId: input.sessionId as NSNumber,
                isSync: false,
                lngId: input.languageId,
                refId: input.refId,
                actualText: chkKey3
            )

            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
        }
    }

    private func mapTurkeyCategoryName(_ catName: String) -> String {
        switch catName {
        case "Microscopy": return "Coccidiosis"
        case "GI Tract": return "GITract"
        case "Immune/Others": return "Immune"
        case "Respiratory": return "Resp"
        case "Skeletal/Muscular/Integumentary": return "skeltaMuscular"
        default: return catName
        }
    }

    private func handleTurkeyNecropsyFailure(_ encodingError: Error, response: AFDataResponse<Any>) {
        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
            self.alerViewInternet()
            debugPrint(err)
        } else if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
            debugPrint(encodingError)
            debugPrint(responseString)
            self.alerViewInternet()
        }
    }
    
    // MARK: ************* Get Posting Data from Server for Vaccination ***************************************/
    func getPostingDataFromServerforVaccinationTurkey() {
        self.deleteAllData("HatcheryVacTurkey")
        self.deleteAllData("FieldVaccinationTurkey")
        guard WebClass.sharedInstance.connected() else {
            self.alerViewInternet()
            return
        }
        fetchTurkeyVaccinationData()
    }

    private func fetchTurkeyVaccinationData() {
        let id = UserDefaults.standard.value(forKey: "Id") as! Int
        let newUrl = ZoetisWebServices.EndPoint.getTurkeyPostedSessionsVacccine.latestUrl + "\(id)&DeviceType=\(Constants.deviceType)"
        ZoetisWebServices.shared.getTurkeyPostedSessionsVacccineResponce(controller: self, url: newUrl) { [weak self] (json, error) in
            guard let self = self else { return }
            self.handleTurkeyVaccinationResponse(json)
        }
    }

    private func handleTurkeyVaccinationResponse(_ json: Any) {
        let jsonResponse = JSON(json)
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.int ?? 0
            print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
            if [500, 401, 503, 403, 501, 502, 400, 504, 404, 408].contains(statusCode) {
                self.alerView(statusCode: statusCode)
            }
        }
        DispatchQueue.main.async {
            if let arr = JSON(json).array, !arr.isEmpty {
                for vacData in arr {
                    self.processTurkeyVaccinationData(vacData)
                }
                self.getPostingDataFromServerforFeedTurkey()
            } else {
                self.getPostingDataFromServerforFeedTurkey()
            }
        }
    }

    private func processTurkeyVaccinationData(_ vacData: JSON) {
        if let vac = vacData["Vaccination"].array {
            for posDict in vac {
                if let posDictDict = posDict.dictionaryObject {
                    self.processTurkeyVaccinationDict(posDictDict)
                }
            }
        }
    }

    private func processTurkeyVaccinationDict(_ posDictDict: [String: Any]) {
        let allKeyArr = Array(posDictDict.keys)
        for key in allKeyArr {
            if key.range(of: "hatchery") != nil {
                CoreDataHandlerTurkey().getHatcheryDataFromServerTurkey(posDictDict as NSDictionary)
            } else {
                CoreDataHandlerTurkey().getFieldDataFromServerTurkey(posDictDict as NSDictionary)
            }
        }
    }
    
    // MARK:  ********** Call Get Api For Feed Session  TURKEY **************************************/
	// MARK: - Feed Data Fetching
	func getPostingDataFromServerforFeedTurkey() {
		clearExistingFeedData()
		guard WebClass.sharedInstance.connected() else {
			// Handle no internet case if needed
			return
		}
		fetchFeedDataFromServerTwo()
	}
	
	private func clearExistingFeedData() {
		let tables = ["AlternativeFeedTurkey", "AntiboticFeedTurkey",
					  "CoccidiosisControlFeedTurkey", "MyCotoxinBindersFeedTurkey"]
		tables.forEach { self.deleteAllData($0) }
	}
	
	private func fetchFeedDataFromServerTwo() {
		let userId = UserDefaults.standard.value(forKey: "Id") as! Int
		guard let accessToken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken) else { return }
		
		let headerDict: HTTPHeaders = [Constants.authorization: accessToken]
		let urlString = buildFeedDataURL(userId: userId)
		
		sessionManager.request(urlString, method: .get, headers: headerDict)
			.responseJSON { [weak self] response in
				guard let self = self else { return }
				self.handleFeedDataResponse(response)
			}
	}
	
	private func buildFeedDataURL(userId: Int) -> String {
		let baseUrl = WebClass.sharedInstance.webUrl
		let endpoint = "PostingSession/TurkeyGetFeedListByUser"
		return "\(baseUrl)\(endpoint)?UserId=\(userId)&DeviceType=\(FeedConstants.deviceType)"
	}
	
	private func handleFeedDataResponse(_ response: AFDataResponse<Any>) {
		if let statusCode = response.response?.statusCode {
			guard !handleErrorStatusCode(statusCode) else { return }
		}
		
		switch response.result {
			case .success(let value):
				handleSuccessResponse(value)
			case .failure(let error):
				handleFailureResponse(error, response: response)
		}
	}
	
	private func handleErrorStatusCode(_ statusCode: Int) -> Bool {
		let errorCodes = [400, 401, 403, 408, 500, 501, 502, 503, 504]
		if errorCodes.contains(statusCode) {
			DispatchQueue.main.async { [weak self] in
				self?.alerView(statusCode: statusCode)
			}
			return true
		}
		return false
	}
	
	private func handleSuccessResponse(_ value: Any) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			guard let feedArray = value as? NSArray else {
				self.getCNecStep1DataTurkey()
				return
			}
			
			if feedArray.count > 0 {
				self.processFeedArray(feedArray)
			}
			self.getCNecStep1DataTurkey()
		}
	}
	
	private func processFeedArray(_ feedArray: NSArray) {
		for feedData in feedArray {
			guard let postDict = feedData as? [String: Any],
				  let sessionId = postDict["sessionId"] as? Int,
				  let feedDictArr = postDict["Feeds"] as? [[String: Any]] else { continue }
			
			processFeedDetails(feedDictArr: feedDictArr, sessionId: sessionId)
		}
	}
	
	private func processFeedDetails(feedDictArr: [[String: Any]], sessionId: Int) {
		for feedDict in feedDictArr {
			guard let feedId = feedDict["feedId"] as? Int,
				  let feedName = feedDict["feedName"] as? String else { continue }
			
			updateFeedId(feedId)
			let startDate = feedDict["startDate"] as? String
			
			DispatchQueue.main.async { [weak self] in
				self?.handleGetFeedNameFromTurkey(
					seesionId: NSNumber(value: sessionId),
					feedsName: feedName,
					feedId: NSNumber(value: feedId),
					startDate: startDate
				)
			}
			
			if let feedDetails = feedDict["feedCategoryDetails"] as? [[String: Any]] {
				processFeedCategories(
					feedDetails: feedDetails,
					feedId: feedId,
					sessionId: sessionId,
					feedName: feedName,
					startDate: startDate ?? ""
				)
			}
		}
	}
	
	private func updateFeedId(_ newFeedId: Int) {
		let currentFeedId = UserDefaults.standard.integer(forKey: FeedConstants.feedIdKey)
		if newFeedId > currentFeedId {
			UserDefaults.standard.set(newFeedId, forKey: FeedConstants.feedIdKey)
		}
	}
	
	private func processFeedCategories(feedDetails: [[String: Any]], feedId: Int, sessionId: Int, feedName: String, startDate: String) {
		for category in feedDetails {
			guard let categoryName = category["feedProgramCategory"] as? String,
				  let details = category["feedDetails"] as? [[String: Any]] else { continue }
			
			let feedIdNumber = NSNumber(value: feedId)
			let sessionIdNumber = NSNumber(value: sessionId)
			
			switch categoryName {
				case Constants.coccidioStr:
					details.forEach { detail in
						CoreDataHandlerTurkey().getDataFromCocoiiControllTurkey(
							detail as NSDictionary,
							feedId: feedIdNumber,
							postingId: sessionIdNumber,
							feedProgramName: feedName,
							startDate: startDate
						)
					}
				case "Antibiotic":
					details.forEach { detail in
						CoreDataHandlerTurkey().getDataFromAntiboiticTurkey(
							detail as NSDictionary,
							feedId: feedIdNumber,
							postingId: sessionIdNumber,
							feedProgramName: feedName,
							startDate: startDate
						)
					}
				case "Alternatives":
					details.forEach { detail in
						CoreDataHandlerTurkey().getDataFromAlterNativeTurkey(
							detail as NSDictionary,
							feedId: feedIdNumber,
							postingId: sessionIdNumber,
							feedProgramName: feedName,
							startDate: startDate
						)
					}
				case Constants.mytoxinStr:
					details.forEach { detail in
						CoreDataHandlerTurkey().getDataFromMyCocotinBinderTurkey(
							detail as NSDictionary,
							feedId: feedIdNumber,
							postingId: sessionIdNumber,
							feedProgramName: feedName,
							startDate: startDate
						)
					}
				default:
					break
			}
		}
	}
	
	private func handleFailureResponse(_ error: Error, response: AFDataResponse<Any>) {
		if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
			DispatchQueue.main.async { [weak self] in
				self?.alerViewInternet()
			}
			debugPrint(urlError)
		} else if let data = response.data,
				  let responseString = String(data: data, encoding: .utf8) {
			debugPrint(error)
			debugPrint(responseString)
			DispatchQueue.main.async { [weak self] in
				self?.alerViewInternet()
			}
		}
	}
    
    
    func handleGetFeedNameFromTurkey(seesionId: NSNumber, feedsName: String, feedId: NSNumber, startDate: Any?) {
        self.callGetFeedNameFromTurkey(seesionId: seesionId, feedName: feedsName, feedId: feedId, startDate: startDate)
    }
    
    private func callGetFeedNameFromTurkey(seesionId: NSNumber, feedName: String, feedId: NSNumber, startDate: Any?) {
        CoreDataHandlerTurkey().getFeedNameFromGetApiTurkey(
            (seesionId) as NSNumber,
            sessionId: seesionId as NSNumber,
            feedProgrameName: feedName,
            feedId: feedId as NSNumber,
            startDate: startDate as? String ?? ""
        )
    }
    
    
    // MARK: Get Posting Data from Server for Images Turkey
    func getPostingDataFromServerforImageTurkey() {
        self.deleteAllData("BirdPhotoCaptureTurkey")
        guard WebClass.sharedInstance.connected() else {
            self.alerViewInternet()
            return
        }
        fetchTurkeyImagesFromServer()
    }

    private func fetchTurkeyImagesFromServer() {
        let id = UserDefaults.standard.value(forKey: "Id") as! Int
        let newUrl = ZoetisWebServices.EndPoint.getTurkeyPostedImages.latestUrl + "\(id)&DeviceType=\(Constants.deviceType)"
        ZoetisWebServices.shared.getTurkeyPostedImagesResponce(controller: self, url: newUrl) { [weak self] (json, error) in
            guard let self = self else { return }
            self.handleTurkeyImagesResponse(json)
        }
    }

    private func handleTurkeyImagesResponse(_ json: Any) {
        let jsonResponse = JSON(json)
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.int ?? 0
            print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
            if [500, 401, 503, 403, 501, 502, 400, 504, 404, 408].contains(statusCode) {
                self.alerView(statusCode: statusCode)
            }
        }
        DispatchQueue.main.async {
            self.processTurkeyImagesAndNavigate(json)
        }
    }

    private func processTurkeyImagesAndNavigate(_ json: Any) {
        if let arr = JSON(json).array, !arr.isEmpty {
            for vacData in arr {
                self.saveTurkeyImages(vacData)
            }
        }
        Helper.dismissGlobalHUD(self.view)
        handleTurkeyTermsAndNavigation()
    }

    private func saveTurkeyImages(_ vacData: JSON) {
        if let imagArr = vacData["Images"].array, !imagArr.isEmpty {
            for imageData in imagArr {
                if let imageDict = imageData.dictionaryObject {
                    CoreDataHandlerTurkey().getSaveImageFromServerTurkey(imageDict as NSDictionary)
                }
            }
        }
    }

    private func handleTurkeyTermsAndNavigation() {
        if self.termsCond == 0 {
            UserDefaults.standard.set(true, forKey: "login")
            if let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "terms") as? Terms_ConditionViewController {
                self.navigationController?.pushViewController(mapViewControllerObj, animated: false)
            }
        } else {
            UserDefaults.standard.set(true, forKey: "login")
            self.callDashBordView()
        }
    }
    
    // MARK:  ****************************** Get Notes from Server & Save ******************************/
    fileprivate func saveTurkeyNotes(_ vacData: JSON) {
        if let noteArr = vacData["Note"].array, !noteArr.isEmpty {
            for note in noteArr {
                // Safely unwrap each value
                if let sessionId = note["sessionId"].int,
                   let farmName = note["farmName"].string,
                   let birdNo = note["birdNumber"].int,
                   let birdNotes = note["Notes"].string {
                    
                    // Save data using CoreDataHandlerTurkey
                    CoreDataHandlerTurkey().saveNoofBirdWithNotesTurkey(
                        "",
                        notes: birdNotes,
                        formName: farmName,
                        birdNo: NSNumber(value: birdNo),
                        index: 0,
                        necId: NSNumber(value: sessionId),
                        isSync: false
                    )
                }
            }
        }
    }
    
    fileprivate func getImagesAndSaveNotesOfTurkeySessions(json: JSON) {
        if let arr = JSON(json).array, !arr.isEmpty {
            for vacData in arr {
                self.saveTurkeyNotes(vacData)
            }
            // Fetch posting data after processing
            self.getPostingDataFromServerforImageTurkey()
        } else {
            // Handle the case where array is empty or nil
            self.getPostingDataFromServerforImageTurkey()
        }
    }
    
    func getNotesFromServerTurkey() {
        self.deleteAllData("NotesBirdTurkey")
        if WebClass.sharedInstance.connected() {
       
            let id =  UserDefaults.standard.integer(forKey: "Id")
           
   
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            
            let newUrl = ZoetisWebServices.EndPoint.getTurkeyPostedNotes.latestUrl + "\(id)&DeviceType=\(Constants.deviceType)"
            ZoetisWebServices.shared.getTurkeyPostedNotesResponce(controller: self, url: newUrl, completion: { [weak self] (json, error) in
                guard let self = self else { return }
                
                let jsonResponse = JSON(json)
           
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let statusCode = errorResult["errorCode"]?.int ?? 0
                    
                    print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
                    
                    if statusCode == 500  || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408 {
                        self.alerView(statusCode: statusCode)
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    self.getImagesAndSaveNotesOfTurkeySessions(json: json)
                }

            })

        } else {
            
            self.failWithErrorInternal()
        }
    }
}

// MARK:  Side Pannel Delegates Method
extension ViewController:SidePanelViewControllerDelegate {
    
    func didSelectLeftPenal(_ selectedRow: Int, selectedDetails: [String : String]) {
        
        let userType =   UserDefaults.standard.string(forKey:"userType")
        self.navigationItem.setHidesBackButton(true, animated: true)
        if userType == "PE" {
            if selectedRow == 0 {
                self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
                delegate?.collapseSidePanels?()
                return
            }
            else if selectedRow == 1 {
                Constants.isDashboard = true
                Constants.isDataLoaded = true
                UserDefaults.standard.set(true, forKey: "PEDashboard")
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboard"),object: nil))
                self.navigationController?.popToViewController(ofClass: PEDashboardViewController.self)
                delegate?.collapseSidePanels?()
                return
            }
            
            else if selectedRow == 2 {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MoveToViewAssessment"),object: nil))
                delegate?.collapseSidePanels?()
                return
            }
            else if selectedRow == 3 {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "NavigateToScheduledAssesments"),object: nil))
                delegate?.collapseSidePanels?()
                return
            }
            else if selectedRow == 4 {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MoveToOpenPlacards"),object: nil))
                delegate?.collapseSidePanels?()
                return
            }
            
            else if selectedRow == 1 {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboard"),object: nil))
                self.navigationController?.popToViewController(ofClass: PEDashboardViewController.self)
                delegate?.collapseSidePanels?()
                return
            }
            else if selectedRow == 5 {
                logoutBtnAction()
            }
            
            else if selectedRow == 7 {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MoveToOpenPlacards"),object: nil))
            }
        }
        
        else  if userType == "PVE" {
            if selectedRow == 0 {
                self.navigationController?.popToViewController(ofClass: PulletSelectionViewController.self)
                delegate?.collapseSidePanels?()
                return
            }
            if selectedRow == 3{
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PVESessionViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        delegate?.collapseSidePanels?()
                        return
                    }
                }
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PVESessionViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                    }
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PVESessionViewController") as! PVESessionViewController
                navigationController?.pushViewController(vc, animated: false) //navigationController?.popViewController(animated: true)
            }
            if selectedRow == 1 {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PVEDashboardViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                    }
                }
            }
            if selectedRow == 2 {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: PVEStartNewAssessment.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        delegate?.collapseSidePanels?()
                        return
                    }
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PVEStartNewAssessment") as! PVEStartNewAssessment
                navigationController?.pushViewController(vc, animated: false)
            }
            if selectedRow == 4 {
                logoutBtnAction()
            }
            delegate?.collapseSidePanels?()
        }
        
        
        //************************** Is Microbial *****************************
        
        else  if userType == "Microbial" {//
            
            if selectedRow == 0 {
                self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
                delegate?.collapseSidePanels?()
                return
            }
            
            if selectedRow == 1 {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MicrobialViewController.self) {
                        (controller as? MicrobialViewController)?.isNewRquisitionSelected = false
                        self.navigationController!.popToViewController(controller, animated: true)
                        delegate?.collapseSidePanels?()
                        return
                    }
                }
            }
            
            if selectedRow == 2 {
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: MicrobialViewController.self) {
                        if self.navigationController?.viewControllers.last == controller{
                            NotificationCenter.default.post(name: Notification.Name("openStartRequisition"), object: nil, userInfo: [:])
                        }else{
                            (controller as? MicrobialViewController)?.isNewRquisitionSelected = true
                            self.navigationController!.popToViewController(controller, animated: true)
                        }
                        delegate?.collapseSidePanels?()
                        return
                    }
                }
            }
            
            if selectedRow == 3 {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ViewRequisitionViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        delegate?.collapseSidePanels?()
                        return
                    }
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "ViewRequisition", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewRequisitionViewController") as! ViewRequisitionViewController
                navigationController?.pushViewController(vc, animated: false)
            }
            
            if selectedRow == 4 {
                logoutBtnAction()
            }
        }
        else if userType == "FlockHealth"{
            switch selectedRow {
            case 0:
                self.navigationController?.popToViewController(ofClass: GrownoutSelectionViewController.self)
                delegate?.collapseSidePanels?()
                return
            case 1:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
                navigationController?.pushViewController(vc, animated: false)
                
                
            case 2:
                
                UserDefaults.standard.set(0, forKey: "postingId")
                UserDefaults.standard.set(0, forKey: "necUnLinked")
                UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                UserDefaults.standard.set(false, forKey: "Unlinked")
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.set(false, forKey: "backFromStep1")
                let val = UserDefaults.standard.integer(forKey: "chick")
                if val  ==  4  {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "DashView_Controller") as! DashViewController
                    navigationController?.pushViewController(vc, animated: false)
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as! DashViewControllerTurkey
                    navigationController?.pushViewController(vc, animated: false)
                }
                
            case 3:
                if UserDefaults.standard.integer(forKey: "Role") == 1 {
                    
                    UserDefaults.standard.set(false, forKey: "Unlinked")
                    UserDefaults.standard.set(true, forKey: "nec")
                    UserDefaults.standard.set(false, forKey: "backFromStep1")
                    UserDefaults.standard.set(0, forKey: "postingId")
                    UserDefaults.standard.set(0, forKey: "necUnLinked")
                    UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                    UserDefaults.standard.removeObject(forKey: "count")
                    UserDefaults.standard.set(0, forKey: "postingId")
                    UserDefaults.standard.set(1, forKey: "sessionId")
                    UserDefaults.standard.set(0, forKey: "isBackWithoutFedd")
                    appDelegate.sendFeedVariable = ""
                    let val = UserDefaults.standard.integer(forKey: "chick")
                    if val  ==  4 {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                        
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
                    }
                }
            case 4:
                
                if UserDefaults.standard.integer(forKey: "Role") == 1{
                    UserDefaults.standard.set(0, forKey: "postingId")
                    UserDefaults.standard.set(0, forKey: "necUnLinked")
                    UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                    UserDefaults.standard.set(false, forKey: "Unlinked")
                    UserDefaults.standard.set(true, forKey: "nec")
                    UserDefaults.standard.set(false, forKey: "backFromStep1")
                    let val = UserDefaults.standard.integer(forKey: "chick")
                    if val ==  4  {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Existing") as! ExistingPostingSessionViewController
                        navigationController?.pushViewController(vc, animated: false)
                        
                    } else {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ExistingTurkey") as! ExistingPostingSessionTurkey
                        navigationController?.pushViewController(vc, animated: false)
                    }
                }
            case 5:
                
                UserDefaults.standard.set(0, forKey: "postingId")
                UserDefaults.standard.set(0, forKey: "necUnLinked")
                UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TrainingNew") as! TrainingViewController
                navigationController?.pushViewController(vc, animated: false)
                
                
            case 6:
                
                if UserDefaults.standard.integer(forKey: "Role") == 1 {
                    UserDefaults.standard.set(0, forKey: "postingId")
                    UserDefaults.standard.set(0, forKey: "necUnLinked")
                    UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                    UserDefaults.standard.set(false, forKey: "Unlinked")
                    UserDefaults.standard.set(true, forKey: "nec")
                    UserDefaults.standard.set(false, forKey: "backFromStep1")
                    let val = UserDefaults.standard.integer(forKey: "chick")
                    if val  ==  4 {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Report") as! Report_MainVCViewController
                        navigationController?.pushViewController(vc, animated: false)
                        
                    } else {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ReportTurkey") as! ReportDashboardTurkey
                        navigationController?.pushViewController(vc, animated: false)
                    }
                }
                
            case 7:
                
                UserDefaults.standard.set(0, forKey: "postingId")
                UserDefaults.standard.set(0, forKey: "necUnLinked")
                
                UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                UserDefaults.standard.set(false, forKey: "Unlinked")
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.set(false, forKey: "backFromStep1")
                let val = UserDefaults.standard.integer(forKey: "chick")
                if val  ==  4 {
                    let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "helpView") as? HelpViewController
                    self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                } else {
                    
                    let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HelpScreenVcTurkey") as? HelpScreenVcTurkey
                    self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                }
                
            case 8:
                
                if UserDefaults.standard.integer(forKey: "Role") == 1 {
                    UserDefaults.standard.set(0, forKey: "postingId")
                    UserDefaults.standard.set(0, forKey: "necUnLinked")
                    
                    UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                    UserDefaults.standard.set(false, forKey: "Unlinked")
                    UserDefaults.standard.set(true, forKey: "nec")
                    UserDefaults.standard.set(false, forKey: "backFromStep1")
                    
                    let val = UserDefaults.standard.integer(forKey: "chick")
                    if val  ==  4 {
                        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "setting") as? SettingsViewController
                        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                    }
                    else{
                        
                        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "settingTurkey") as? SettingControllerTurkey
                        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                    }
                }
                
            default:
                let birdTypeId = UserDefaults.standard.integer(forKey: "switchBird")
                let vlue = UserDefaults.standard.bool(forKey: "turkey")
                let vlue1 = UserDefaults.standard.bool(forKey: "Chicken")
                
                if birdTypeId ==  3 {
                    if ConnectionManager.shared.hasConnectivity() {
                        
                        UserDefaults.standard.set(0, forKey: "postingId")
                        UserDefaults.standard.set(0, forKey: "necUnLinked")
                        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
                        UserDefaults.standard.set(false, forKey: "Unlinked")
                        UserDefaults.standard.set(true, forKey: "nec")
                        UserDefaults.standard.set(false, forKey: "backFromStep1")
                        if vlue == true{
                            objApiSyncTurkey.delegeteSyncApiTurkey = self
                            if self.allSessionArrTurkey().count > 0 {
                                if WebClass.sharedInstance.connected() == true{
                                    Helper.showGlobalProgressHUDWithTitle(UIApplication.shared.keyWindow!, title: NSLocalizedString(Constants.dataSyncingMessage, comment: ""))
                                    self.callSyncApiTurkey()
                                } else {
                                    Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please go online and sync data before logging out.", comment: ""))
                                }
                            } else {
                                
                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                                
                            }
                        }
                        else if vlue1 == true{
                            objApiSync.delegeteSyncApi = self
                            if self.allSessionArr().count > 0 {
                                if WebClass.sharedInstance.connected() == true{
                                    Helper.showGlobalProgressHUDWithTitle(UIApplication.shared.keyWindow!, title: NSLocalizedString(Constants.dataSyncingMessage, comment: ""))
                                    self.callSyncApi()
                                } else {
                                    Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please go online and sync data before logging out.", comment: ""))
                                }
                            }
                            else {
                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                            }
                        }
                        else {
                            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                        }
                    } else {
                        
                        if vlue == true{
                            let custArr = CoreDataHandler().fetchCustomer()
                            if(custArr.count == 0){
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please connect to Internet, switching species is only allowed when device is connected to Internet.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                            else{
                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                            }
                        }
                        else if vlue1 == true{
                            let custArr = CoreDataHandlerTurkey().fetchCustomerTurkey()
                            if(custArr.count == 0){
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("Please connect to Internet, switching species is only allowed when device is connected to Internet.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                            }  else {
                                
                                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                            }
                        }
                        else {
                            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
                            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                        }
                    }
                }
            }
            
            
            if selectedRow == 0 {
                self.navigationController?.popToViewController(ofClass: GlobalDashboardViewController.self)
            }
         
        }
        
        //************************** Is Vaccination *****************************
        if userType == "Vaccination" {
            switch selectedRow{
            case 0:
                self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
                delegate?.collapseSidePanels?()
                return
            case 1:
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: VaccinationDashboardVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                    }
                }
            case 2:
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ViewCertificationsVC.self) {
                        let userDefaults = UserDefaults.standard
                        if userDefaults.value(forKey: "ViewCertificationsVC") != nil{
                            let val = userDefaults.value(forKey: "ViewCertificationsVC") as? String
                            if val == VaccinationCertificationStatus.submitted.rawValue{
                                delegate?.collapseSidePanels?()
                                return
                            }
                        }
                    }
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Certification", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewCertificationsVC") as! ViewCertificationsVC //PVESessionViewController
                vc.status = VaccinationCertificationStatus.submitted
                navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ViewCertificationsVC.self) {
                        let userDefaults = UserDefaults.standard
                        if userDefaults.value(forKey: "ViewCertificationsVC") != nil{
                            let val = userDefaults.value(forKey: "ViewCertificationsVC") as? String
                            if val == VaccinationCertificationStatus.draft.rawValue{
                                delegate?.collapseSidePanels?()
                                return
                            }
                        }
                    }
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Certification", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewCertificationsVC") as! ViewCertificationsVC
                vc.status = VaccinationCertificationStatus.draft
                navigationController?.pushViewController(vc, animated: true)
                
            case 4:
                logoutBtnAction()
                delegate?.collapseSidePanels?()
                
            default:
                delegate?.collapseSidePanels?()
                break;
            }
        }
        
        delegate?.collapseSidePanels?()
    }
    
    @IBAction func leftPanelTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    func setLeftPenalNotification() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,selector: #selector(LeftMenuBtnNoti),
                                       name: NSNotification.Name("LeftMenuBtnNoti"),object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(DashBtnNoti),
                                       name: NSNotification.Name("DashBtnNoti"),object: nil)
    }
    
    @objc private func LeftMenuBtnNoti(noti: NSNotification){
        delegate?.toggleLeftPanel!()
    }
    
    @objc private func DashBtnNoti(noti: NSNotification){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            _ = touch.location(in: self.view)
            delegate?.collapseSidePanels!()
        }
    }
}

extension ViewController {
    
    func checkUserDataIsInDbOrNotPE() -> Bool{
        let peNewAssessmentInDB = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        if peNewAssessmentInDB.customerName?.count ?? 0 > 0 {
            return true
        }
        return false
    }
    
    private func navigateToPEDashboard(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GlobalDashboardViewController") as? GlobalDashboardViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
}

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"]  as? String ?? ""
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"]  as? String ?? ""
    }
    
}

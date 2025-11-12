//  Zoetis -Feathers
//
//  Created by "" ""on 08/11/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Constants {
    static var isFromRejected = false
    static var isDataLoaded = false
    static var rejectedCount = 0
    static var isMovementDone = false
    static var isFirstTime = true
    static var isFromSyncAssess = false
    var isApiLoaded: Bool?
    static var isMovedOn = false
    static var isDashboard = false
    static var isExtendedPopup = false
    static var liveComment = ""
    static var inactiveComment = ""
    static var locationValueType : Int = 0
    static var cell = EnviromentalSampleInfoCell()
    static var baseUrl = ""
    static var versionUrl = ""
    static var isLastSession = false
    static var modeType = ""
    static var selectedIndex = 0
    static var isFromPsoting = false
    static var isFromPsotingTurkey = false
    static var informDataSync = "Please sync all your assessment data to the web, then log out and log back into the app."//"You have an assessment that needs to be synced in order to logout of the app. Do you wish to sync the data first?"
    static var askForDataSync = "Data is available to sync. Do you wish to continue?"
    static var forceSyncMessage = "You cannot logout of the app without syncing as you may risk losing your data. Please sync the data in order to proceed with the log out."
    static var syncToWebTapped : Bool = false
    static var isFromDraft : Bool = false
    static var isPPmValueChanged : Bool = false
    static var isDraftAssessment : Bool = false
    static var isfromDraftStartVC: Bool = false
    static var anotherSwitchOFF: Bool = false
    static var switchCount : Int = 0
    static var isEMCalledFromDraft : Bool = false
    static var isAssessmentRejected : Bool = false
    static var appInstalledFirstTime : Bool = false
    static var offline = "You are currently offline. Please go online to sync data."
    static var isForUnlinkedTurkey = false
    static var isForUnlinkedChicken = false
    static var SelectedFarmChicken : Int = 0
    static var SelectedFarmTurkey : Int = 0
    static var deviceType = "iOS"
    static var selectedSiteId = ""
    static var getSiteAdderss : Bool = true
    static var customRepSigIdFirst : Int = 0
    static var secoundcustomRepSigIdFirst : Int = 0
    static var updateSiteAddress : Bool = false
    
    static func startNewRecordSubmission() { // for the image id to be
        self.customRepSigIdFirst = 0
        self.secoundcustomRepSigIdFirst = 0
    }
    
    static var appURLink =   "https://itunes.apple.com/us/app/poultryview-360/id1228196698?mt=8"
    static var mandatoryFields = "Please fill all the mandatory fields."
    static var gigyaValidation = "Failed to get Gigya Country list"
    static var loginLoaderMessage = "Logging in...Please Wait"
    struct ControllerIdentifier {
        static let dashboardController = "DashboardViewController"
        static let searchController = "SearchViewController"
        static let articleController = "ArticleListViewController"
        static let datePickerPopupViewController = "DatePickerPopupViewController"
        
        // PVE-------------
        static let PVEFinalizeSNA = "PVEStartNewAssFinalizeAssement"
        
    }
    
    struct CellIdentifiers {
        static let docCell = "DocCell"
        static let listCell = "cell"
        static let articleCell = "ArticleCell"
        static let plusMinusCell = "MyCell"
        static let addNote_StartNewAssCell = "AddNote_StartNewAssCell"
        static let startNewAssignmentCell = "StartNewAssignmentCell"
        
    }
    
    struct AppData {
        static let dashboardData = [["title": "Spotflock Login", "value": ["Login"]], ["title": "Spotflock Registration", "value": ["Registration"]]]
    }
    
    struct Storyboard {
        static let selection = "Selection"
        static let peStoryboard = "PEStoryboard"
        static let pve360Storyboard = "Main"
        static let pveStoryboard = "PVEStoryboard"
        static let microbialStoryboard = "Microbial"
        static let VACCINATIONCERTIFICATION = "Certification"
    }
    
    struct ClickedFieldMicrobialSurvey {
        static let company = "Company"
        static let reviewer = "Reviewer"
        static let surveyCondustedOn = "SurveyCondustedOn"
        static let siteId = "SiteId"
        static let reasonForVisit = "VisitReason"
        static let SampleCollectedBy = "SampleCollectedBy"
        static let purposeOfSurvey = "PurposeOfSurvey"
        static let transferIn = "TransferIn"
        static let evaluationType = "evaluationType"
        static let locationType = "locationType"
        static let locationValue = "locationValue"
        static let specimenType = "specimenType"
        static let birdType = "birdType"
        static let mediaType = "mediaType"
        static let mediaTypeId = "mediaTypeId"
        static let notes = "notes"
        static let sampling = "sampling"
    }
    
    struct ClickedFieldStartNewAssPVE {
        static let customer = "customer"
        static let housing = "Housing"
        static let ageOfBirds = "ageOfBirds"
        static let breedOfBirds = "breedOfBirds"
        static let breedOfBirdsFemale = "breedOfBirdsFemale"
        static let accountManager = "accountManager"
        static let siteId = "siteId"
        static let evaluationDetails = "evaluationDetails"
        static let evaluationFor = "evaluationFor"
        static let evaluationType = "evaluationType"
    }
    
    struct Api {
        
        // MARK: - 🔴 ************************* Dev Migration URL*************************** 🚀
        // Dev Migration
//        static let versionUrl = "https://devapi.mypoultryview360.com"
//        static let pveBaseUrl = "https://devPVEapi.mypoultryview360.com"
//        static let peBaseUrl = "https://devpeapi.mypoultryview360.com"
//        static let fhBaseUrl = "https://devapi.mypoultryview360.com"
//        static let tcBaseUrl = "https://devpeapi.mypoultryview360.com"
//        static let miBaseUrl = "https://devmicrobialapi.mypoultryview360.com"
//        static let fcmUrl = "https://devapi.mypoultryview360.com/api/GlobalDashboard/SaveNotificationSyncData"
        
        
        // MARK: - 🟠 ************************* Stage Migration URL *************************** 🚀
        // Stage
        static let versionUrl = "https://stageapi.mypoultryview360.com"
        static let pveBaseUrl = "https://stagePVEapi.mypoultryview360.com"
        static let peBaseUrl = "https://stagepeapi.mypoultryview360.com"
        static let fhBaseUrl = "https://stageapi.mypoultryview360.com"
        static let tcBaseUrl = "https://stagepeapi.mypoultryview360.com"
        static let miBaseUrl = "https://stagemicrobialapi.mypoultryview360.com"
        static let fcmUrl = "https://stageapi.mypoultryview360.com/api/GlobalDashboard/SaveNotificationSyncData"
        
        
       // MARK: - 🟢 ************************* Live Migration URL *************************** 🚀
        // Live Migration
//        static let versionUrl = "https://api.mypoultryview360.com"
//        static let pveBaseUrl = "https://pveapi.mypoultryview360.com"
//        static let peBaseUrl = "https://peapi.mypoultryview360.com"
//        static let fhBaseUrl = "https://api.mypoultryview360.com"
//        static let tcBaseUrl = "https://peapi.mypoultryview360.com"
//        static let miBaseUrl = "https://microbialapi.mypoultryview360.com"
//        static let fcmUrl = "https://api.mypoultryview360.com/api/GlobalDashboard/SaveNotificationSyncData"
        
        // MARK: - 🟡 ************************* Dev Support URL*************************** 🚀
        // Dev Support URLs
//		static let versionUrl = "https://supportapi.mypoultryview360.com"
//		static let pveBaseUrl = "https://supportPVEapi.mypoultryview360.com"
//		static let peBaseUrl = "https://supportpeapi.mypoultryview360.com"
//		static let fhBaseUrl = "https://supportapi.mypoultryview360.com"
//		static let tcBaseUrl = "https://supportpeapi.mypoultryview360.com"
//		static let miBaseUrl = "https://supportMicrobialapi.mypoultryview360.com"
//		static let fcmUrl = "https://supportapi.mypoultryview360.com/api/GlobalDashboard/SaveNotificationSyncData"
        
    }
    
    struct GlobalVariables {
        
        // **********Chicken DataBase delete**************//
        
        static var chickenDB = ["AlternativeFeed", "AntiboticFeed", "BirdPhotoCapture", "BirdSizePosting", "Breed", "CamraImage", "CaptureNecropsyData", "CaptureNecropsyViewData", "Coccidiosis", "CoccidiosisControlFeed", "CocciProgramPosting", "ComplexPosting", "Custmer", "CustomerReprestative", "FarmsList", "FeedProgram", "FieldVaccination", "GITract", "HatcheryVac", "Immune", "Login", "MyCotoxinBindersFeed", "Necropsy", "NotesBird", "PostingSession", "Respiratory", "Route", "Salesrep", "Sessiontype", "Skeleta", "Veteration", "differernt user"]
        
        // **********Turkey DataBase delete**************//
        
        static var TurkeyDBArray = ["AlternativeFeedTurkey", "AntiboticFeedTurkey", "BirdPhotoCaptureTurkey", "BirdSizePostingTurkey", "BreedTurkey", "CamraImageTurkey", "CaptureNecropsyDataTurkey", "CaptureNecropsyViewDataTurkey", "CoccidiosisTurkey", "CoccidiosisControlFeedTurkey", "CocciProgramPostingTurkey", "ComplexPostingTurkey", "CustmerTurkey", "CustomerReprestativeTurkey", "FarmsListTurkey", "FeedProgramTurkey", "FieldVaccinationTurkey", "GITractTurkey", "HatcheryVacTurkey", "ImmuneTurkey", "LoginTurkey", "MyCotoxinBindersFeedTurkey", "NecropsyTurkey", "NotesBirdTurkey", "PostingSessionTurkey", "RespiratoryTurkey", "RouteTurkey", "SalesrepTurkey", "SessiontypeTurkey", "SkeletaTurkey", "VeterationTurkey"]
    }
    
    struct Module {
        static let hatchery = "IsHatchery"
        static let hatchery_PV = "IsHatcheryPV"
        static let breeder = "IsBreeder"
        static let growout = "IsGrowout"
        static let breeder_PVE = "IsbreederPVE"
    }
    
    struct Image {
        static let popup_bg_hatchery = "popup_bg_hatchery"
        static let popup_bg_breeder = "popup_bg_breeder"
        static let popup_bg_growout = "popup_bg_growout"
        static let add_icon = "add_icon"
        static let delete_icon = "delete_icon"
    }
    
    static let failedPosting = "Failed to get Posting Assessment list"
    static let yyyyMMddHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
    static let noIdFoundStr = "No id found"
    static let countryNamStr = "CountryName"
    static let countryNamStrSmall = "countryName"
    static let coccidioStr = "Coccidiosis Control"
    static let mytoxinStr = "Mycotoxin Binders"
    static let dataAvailableStr = "Data available"
    static let unknownErrorStr = "Unknown error"
    static let noLesion = "No lesion."
    static let sinLesionStr = "Sin lesión."
    static let growth50 = "<50% growth plate."
    static let growth50GreaterStr = ">50% growth plate."
    static let yesStr = "Yes."
    static let noStr = "No"
    static let alertStr = "Alert"
    static let areYouSureSaveAsmntStr = "Are you sure you want to save assessment in Draft?"
    static let areYouSureToLogoutStr = "Are you sure you want to Logout?"
    static let postincIdPredicate = "postingId == %@"
    static let normalStr = "Normal."
    static let noDataReceivedStr = "No data received from the API."
    static let maleFemaleStr = "Male/Female"
    static let percentageAt = "%@(%@)"
    static let applicationJson = "application/json"
    static let contentType = "Content-Type"
    static let wingWeb = "Wing-Web"
    static let drinkingWater = "Drinking Water"
    static let inOvoStr = "In Ovo"
    static let eveDrop = "Eye Drop"
    static let offlineMessage = "You are currently offline. Please go online to sync data."
    static let dataSyncCompleted = "Data sync has been completed."
    static let mandatoryFieldsMessage = "Fields marked as (*) are mandatory. Please fill all the fields."
    static let unknowCode = "Unknown code"
    static let noStoreNoCache = "no-store, no-cache, must-revalidate, private"
    static let accessToken = "aceesTokentype"
    static let authorization = "Authorization"
    static let noDataRecieved = "No data received from the server."
    static let failedSerilazedJSON = "Failed to serialize JSON data"
    static let predicateRefLang = "refId == %@ AND lngId == %@"
    static let predicateNecFarmName = "necropsyId == %@ AND formName == %@"
    static let predicateBirdsFarmNecID = "noofBirds == %@ AND formName == %@ AND necropsyId == %@"
    
    static let predicateObsIdBirdsFarmNecID = "birdNo == %@ AND formName == %@ AND obsID == %@ AND necropsyId == %@"
    static let predicateCatNameBirdsFarmNecID  = "birdNo == %@ AND catName == %@ AND formName == %@ AND necropsyId == %@"
    
    static let postingIdFeedPredicate = "postingId == %@ AND feedId = %@"
    static let statusPostingIdPredicate = "isSync == %@ AND postingId == %@"
    static let feedIdPredicate = "feedId == %@"
    static let predicateStatus = "isSync == %@"
    static let necFarmNamePredicate  = "necropsyId == %@ AND farmName == %@"
    static let necIdPredicate = "necropsyId == %@"
    static let langIdPredicate = "lngId == %@"
    static let refIdPredicater = "refId == %@"
    static let postIdStatusPredicator  = "postingId == %@ AND isSync == %@"
    static let cacheControl  = "Cache-Control"
    static let complexIdPredicate = "complexId == %@"
    static let inovo = "In Ovo"
    static let eyeDrop = "Eye Drop"
    static let complexTotal = "Complex Total"
    static let displayNone = "#display:none#"
    static let noneDisplay = "display:none"
    static let leftMargin = "margin-left:-40px"
    static let noHistoricalData = "No historical data."
    static let membranaDaAsa = "Membrana Da Asa"
    static let pleaseEnterMandatoryFields = "Please enter details in all the fields marked as mandatory."
    static let predicates =  "%@(%@)"
    static let Subcutânea =  "Subcutânea"
    static let aguaDeBebida =  "Água De Bebida"
    static let spray =  "Spray"
    static let visibilityHidden = "visibility:hidden"
    static let noMinimizeWhileSyncing = "*Note - Please don't minimize App while syncing."
    static let dataSyncInProgress = "Data sync is in progress, please do not close the app."
    static let refrigeratorNitrogenStr = "Refrigerator\n/Freezer\n/Liquid Nitrogen"
    static let extendedMicrobialStr = "Extended Microbial"
    static let pleaseEnterVaccineDetailsStr = "Please enter vaccine details in the Vaccine Preparation & Sterility."
    static let ddMMyyyStr = "dd/MM/yyyy"
    static let pleaseEnterProgramNameStr = "Please enter program name in the Vaccine Preparation & Sterility."
    static let pleaseEnterAntibiotics = "Please enter Antibiotic in the Vaccine Preparation & Sterility."
    static let areYouSureAssessmentStr = "Are you sure you want to finish the assessment? After finishing the information can't be edited."
    static let pleaseEnterAMPM = "Please enter AM/PM Value in Miscellaneous."
    static let pleaseEnterFrequencyDet = "Please enter frequency detail in Customer Quality Control Program."
    static let pleaseEnterPersonName = "Please enter person name in Customer Quality Control Program."
    static let pleaseEnterQCount = "Please enter QC count in Customer Quality Control Program."
    static let pleaseEnterPPM = "Please enter PPM Value in Inovoject System Set Up/Shut Down and Operation."
    static let pleaseEnterVaccineMixObserverStr = "Please enter Vaccine Mixer Observer in  Vaccine Preparation & Sterility."
    static let peCommentImageStr = "PEcomment.png"
    static let peCommentSelectedStr = "PECommentSelected.png"
    static let incompleteDataStr = "Incomplete Data"
    static let oneGallonStr = "1 gallon"
    static let twoGallonStr = "2 gallon"
    static let fiveGallonStr = "5 gallon"
    static let twoLitre = "2 litre"
    static let liter24 = "2.4 litre"
    static let liter28 = "2.8 litre"
    static let mil200 = "200 ml"
    static let mil300 = "300 ml"
    static let mil400 = "400 ml"
    static let mil500 = "500 ml"
    static let mil800 = "800 ml"
    static let syncToWebStr = "Sync to Web"
    static let yyyyMMddStr = "yyyy-MM-dd"
    static let MMddyyyyStr = "MM/dd/yyyy"
    static let MMddYYYYHHmmss = "MM/dd/YYYY HH:mm:ss Z"
    static let pleaseEnterCommentForThawBathTempStr = "Please enter comment for (Thaw bath temp) in Aseptic Technique & Vaccine Application"
    static let pleaseEnterCommentForVaccineThawingTimesStr = "Please enter comment for (Vaccine thawing time) in Aseptic Technique & Vaccine Application"
    static let youHaveAlreadyRequisitionStr = "You have already added requisition with same date and site."
    static let pleaseFillMandatoryFieldsStr = "Please fill all mandatory fields"
    static let dataSyncSuccess = "Data synced successfully."
    static let dontHaveSessionToPostMessage = "To help keep your account safe and master data updated, we need you to log out and sign back in. Click “Later” if you need to upload data to the Web before logging out."
    static let stillHaveActiveSessionMessage = "Please sync all your assessment data to the web, then log out and log back into the app."
    static let dataSyncingMessage = "Data syncing..."
    static let internetErrorMessage = "Connection issue detected. Please check your internet and try again."
    static let selectPlaceholder = "- Select -"
    static let selectComplex = "Please select a complex first."
    static let microscopyLastSession = "Microscopy Summary Last Session"
}
struct CategoryConstants {
    static let extendedMicrobialName = "Extended Microbial"
    static let okPressed = "OK Pressed"
    static let refrigerator = "Refrigerator\n/Freezer\n/Liquid Nitrogen"
    static let  yyyyMMdd =  "yyyy-MM-dd"
    static let MMddyyyy = "MM/dd/yyyy"
    static let ddMMyyyy = "dd/MM/yyyy"
    static let pleaseenterprogramnameintheVaccinePreparationSterility = "Please enter program name in the Vaccine Preparation & Sterility."
    static let pleaseenterpersonnameinCustomerQualityControlProgram = "Please enter person name in Customer Quality Control Program."
    static let pleaseenterQCcountinCustomerQualityControlProgram = "Please enter QC count in Customer Quality Control Program."
}
func predicateForSessionType() -> NSPredicate {
    return NSPredicate(format: "isSessionType == %d", argumentArray: [true])
}

enum ZoetisArt {
    
    struct FontSize {
        
        static let extraLarge: CGFloat = 20.0
        static let large: CGFloat = 18.0
        static let medium: CGFloat = 16.0
        static let regular: CGFloat = 17.0
        static let small: CGFloat = 12.0
        static let extraSmall: CGFloat = 10.0
    }
    
    struct ColorCode {
        static let black = "#000000"
        static let lightGray = "#AAAAAA"
        static let red = "#E86E6E"
        static let blueBackgroundColor = "#3A3D65"
        static let textFieldBackGroundColor = "#F8F8FB"
        static let gradientlightGreen = "#97e8c3"
        static let gradientDarkGreen = "#31c588"
        static let gradientlightOrange = "#f6be81"
        static let gradientDarkOrange = "#c5631c"
        static let gradientCyan = "#21d4fd"
        static let gradientBlue = "#3721ff"
        static let gradientLightRed = "#f07f7f"
        static let gradientDarkRed = "#FF0000"
        static let background = "#D8D8D8"
        static let orangeColor = UIColor(red: 246.0 / 255.0, green: 121.0 / 255.0, blue: 45.0 / 255.0, alpha: CGFloat(1))
        
        static let loginButtonColor = UIColor(red: 40.0 / 255.0, green: 122.0 / 255.0, blue: 1.0, alpha: CGFloat(1))
        
        static let blue1 = UIColor(red: 40.0 / 255.0, green: 237.0 / 255.0, blue: 1.0, alpha: CGFloat(1))
        static let blue2 = UIColor(red: 1.0 / 255.0, green: 167.0 / 255.0, blue: 199.0 / 255.0, alpha: CGFloat(1))
        static let orange = "#F6792D"
        static let green = UIColor(red: 41.0 / 255.0, green: 193.0 / 255.0, blue: 86.0 / 255.0, alpha: CGFloat(1))
    }
    
    struct Font {
        static let light = Font.regular
        static let regular = "SFProText-Regular"
        static let medium = Font.regular
        static let semiBold = Font.regular
        static let bold = Font.regular
    }
    
    struct SfProTextFont {
        
        static let light = "SFProText-Light"
        static let regular = "SFProText-Regular"
        static let medium = "SFProDisplay-Medium"
        static let semiBold = "SFProText-Semibold"
        static let bold = "SFProDisplay-Bold"
    }
    
    struct HelveticaNeueFont {
        static let regular = "Helvetica"
        static let light = "Helvetica-Light"
        static let medium = "HelveticaNeue-Medium"
        static let semiBold = "Helvetica-LightOblique"
        static let bold = "Helvetica-Bold"
    }
    
}

extension ZoetisArt {
    
    struct Color {
        static let white = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        static let appThemeColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        static let appGray = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let textBlack = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        static let backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        static let textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 0.6)
        
    }
}
func delay(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

struct PEQuestionsImagesData {
    static var peImagesData: [[String:Any]]?
}

struct AccessTokenHelper {
    static func saveData(_ encodedToken:String) {
        KeyChainHelper.saveData(key: Constants.accessToken, value: encodedToken)
    }
    
    static func getData() -> String? {
        return KeyChainHelper.getData(key: Constants.accessToken)
    }
    
    
    
    func saveToKeychain(valued: String, keyed: String) {
        KeyChainHelper.saveData(key: keyed, value: valued)
    }
    
    
    func getFromKeychain(keyed: String) -> String? {
        return KeyChainHelper.getData(key: keyed)
    }
    
    
}


struct KeyChainHelper {
    static func saveData(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Remove existing item if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Data saved to Keychain.")
        } else {
            print("Failed to save data: \(status)")
        }
    }
    
    static func getData(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Failed to retrieve data: \(status)")
            return nil
        }
    }
}

extension NSMutableDictionary {
    func toJSONDictionary() -> [String: Any]? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []),let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return jsonDictionary
        }
        return nil
    }
}

let appDelegateObj = UIApplication.shared.delegate as! AppDelegate


 struct CoreDataHandlerMicrodataModels
{
   struct CustomerSessionData {
        let barcode: String
        let company: String
        let companyId: Int
        let emailId: String
        let requestor: String
        let reviewer: String
        let sampleCollectedBy: String
        let sampleCollectionDate: String
        let sessionId: String
        let site: String
        let siteId: Int
    }
    
    struct CaseInfo {
        let requestor: String
        let sampleCollectedBy: String
        let company: String
        let companyId: Int
        let site: String
        let siteId: Int
        let email: String
        let reviewer: String
        let surveyConductedOn: String
        let sampleCollectionDate: String
        let sampleCollectionDateWithTimeStamp: String
        let purposeOfSurvey: String
        let transferIn: String
        let barCode: String
        let barCodeManualEntered: String
        let notes: String
        let reasonForVisit: String
        let currentdate: String
        let customerId: String
        let requisitionType: Int
        let sessionStatus: Int
        let requisitionId: String
        let timeStamp: String
        let isPlateIdGenerated: Bool
        let typeOfBird: String
        let typeOfBirdId: Int
        let reviewerId: Int
        let purposeOfSurveyId: Int
        let surveyConductedOnId: Int
        let reasonForVisitId: Int
    }
    
    struct SampleInfoHeader {
        let currentdate: String
        let customerId: String
        let requisitionType: Int
        let sessionStatus: Int
        let locationType: String
        let locationTypeId: Int
        let noOfPlates: Int
        let section: Int
        let requisitionId: String
        let timeStamp: String
    }
     
 
     struct EnvironmentalSessionInfo {
         let requestor: String
         let sampleCollectedBy: String
         let company: String
         let companyId: Int
         let site: String
         let siteId: Int
         let email: String
         let reviewer: String
         let surveyConductedOn: String
         let sampleCollectionDate: String
         let sampleCollectionDateWithTimeStamp: String
         let purposeOfSurvey: String
         let transferIn: String
         let barCode: String
         let barCodeManualEntered: String
         let notes: String
         let reasonForVisit: String
         let requisitionId: String
         let requisitionType: Int
         let isPlateIdGenerated: Bool
         let typeOfBird: String
         let typeOfBirdId: Int
     }
     
     struct EnviromentalLocationPlateData {
         var isBacterialChecked: Bool
         var isMicoscoreChecked: Bool
         var locationValue: String
         var plateId: String
         var row: Int
         var section: Int
         var sampleDescription: String
         var locationTypeId: Int?
         var requisitionId: String
         var requisitionType: Int
         var mediaTypeValue: String
         var mediaTypeId: Int?
         var notes: String
         var samplingMethodId: Int?
         var samplingMethodTypeValue: String
     }
     
     struct SessionProgressData {
         var barcode: String
         var company: String
         var companyId: Int
         var emailId: String
         var requestor: String
         var reviewer: String
         var sampleCollectedBy: String
         var sampleCollectionDate: String
         var sampleCollectionDateWithTimeStamp: String
         var sessionId: Int
         var site: String
         var siteId: Int
         var manualEnteredBarCode: String
     }

     struct CustomerDetails {
         var barcode: String
         var company: String
         var companyId: Int
         var emailId: String
         var requestor: String
         var reviewer: String
         var sampleCollectedBy: String
         var sampleCollectionDate: String
         var sessionId: Int
         var site: String
         var siteId: Int
         var draftCheck: String
     }

     struct saveLocationTypeValues {
         let locationId: NSNumber
         let id: NSNumber
         let value: String
         let std40: Bool
         let std20: Bool
         let rep20: Int
         let rep40: Int
         let standard: Bool
         let stnRep: Int
         let mediaTypeDefault: String
         let samplingMethodDefault: String
     }
     
     struct submitDataCustomerDetails {
         let barcode: String
         let company: String
         let companyId: Int
         let emailId: String
         let requestor: String
         let reviewer: String
         let sampleCollectedBy: String
         let sampleCollectionDate: String
         let sessionId: Int
         let site: String
         let siteId: Int
     }

     
     struct SessionUpdateData {
         let requestor: String
         let sampleCollectedBy: String
         let company: String
         let companyId: Int
         let site: String
         let siteId: Int
         let email: String
         let reviewer: String
         let surveyConductedOn: String
         let sampleCollectionDate: String
         let sampleCollectionDateWithTimeStamp: String
         let purposeOfSurvey: String
         let transferIn: String
         let barCode: String
         let barCodeManualEntered: String
         let notes: String
         let reasonForVisit: String
         let currentdate: String
         let customerId: String
         let requisitionType: Int
         let sessionStatus: Int
         let requisition_Id: String
         let timeStamp: String
         let isPlateIdGenerated: Bool
         let typeOfBird: String
         let typeOfBirdId: Int
         let reviewerId: Int
         let purposeOfSurveyId: Int
         let surveyConductedOnId: Int
         let reasonForVisitId: Int
     }

     struct EnvSampleHeaderUpdateInfo {
         let currentDate: String
         let customerId: String
         let requisitionType: Int
         let sessionStatus: Int
         let locationType: String
         let locationTypeId: Int
         let noOfPlates: Int
         let section: Int
         let requisitionId: String
         let timeStamp: String
         let prevSection: Int
     }

     struct EnvSamplePlateData {
         let currentDate: String
         let customerId: String
         let requisitionType: Int
         let sessionStatus: Int
         let isBacterialChecked: Bool
         let isMicoscoreChecked: Bool
         let locationTypeId: Int
         let locationValueId: Int
         let plateId: String
         let row: Int
         let sampleDescription: String
         let section: Int
         let requisitionId: String
         let timeStamp: String
         let mediaTypeId: Int
         let notes: String
         let samplingMethodTypeId: Int
     }
     
     struct envPlateSampleInfo {
         let currentDate: String
         let customerId: String
         let requisitionType: Int
         let sessionStatus: Int
         let isBacterialChecked: Bool
         let isMicoscoreChecked: Bool
         let locationTypeId: Int
         let locationValue: String
         let plateId: String
         let row: Int
         let sampleDescription: String
         let section: Int
         let requisitionId: String
         let timeStamp: String
         let locationValueId: Int
         let mediaTypeId: Int
         let notes: String
         let samplingMethodTypeId: Int
     }

     

     struct SampleInfoPlate {
         var currentdate: String
         var customerId: String
         var requisitionType: Int
         var sessionStatus: Int
         var isBacterialChecked: Bool
         var isMicoscoreChecked: Bool
         var locationTypeId: Int
         var locationValue: String
         var plateId: String
         var row: Int
         var sampleDescription: String
         var section: Int
         var requisition_Id: String
         var timeStamp: String
         var locationValueId: Int
         var mediaTypeValue: String
         var mediaTypeId: Int
         var notes: String
         var samplingMethodTypeValue: String
         var samplingMethodTypeId: Int
     }

     struct environmentalSampleInfoPlate {
         var currentdate: String
         var customerId: String
         var requisitionType: Int
         var sessionStatus: Int
         var isBacterialChecked: Bool
         var isMicoscoreChecked: Bool
         var locationTypeId: Int
         var locationValue: String
         var locationValueId: Int
         var plateId: String
         var row: Int
         var sampleDescription: String
         var section: Int
         var requisition_Id: String
         var timeStamp: String
         var prevSection: Int
         var mediaTypeValue: String
         var mediaTypeId: Int
         var notes: String
         var samplingMethodTypeId: Int
         var samplingMethodTypeValue: String
     }
  
     
     struct FeatherPulpSampleInfoDataSave {
         var plateIdGenerated: String
         var plateId: Int
         var flockId: String
         var houseNo: String
         var sampleDescription: String
         var additionalTests: String
         var checkMark: String
         var microsporeCheck: String
         var sessionId: Int
         var timeStamp: String
         var isSessionPlate: Bool
     }

}


struct CoreDataHandlerPEModels
{
    
    struct refrigeratorData {
        let id: NSNumber
        let labelText: String
        let rollOut: String
        let unit: String
        let value: Double
        let catID: NSNumber
        let isCheck: Bool
        let isNA: Bool
        let schAssmentId: Int
    }
    
    struct offlineRefrigatorData {
        let id: NSNumber
        let labelText: String
        let rollOut: String
        let unit: String
        let value: Double
        let catID: NSNumber
        let isCheck: Bool
        let isNA: Bool
        let schAssmentId: Int
    }
    
    struct RefrigatorDraftData {
        var id: NSNumber
        var labelText: String
        var rollOut: String
        var unit: String
        var value: Double
        var catID: NSNumber
        var isCheck: Bool
        var isNA: Bool
        var schAssmentId: Int
    }

    struct rejectedRefrigatorData {
        var id: NSNumber
        var labelText: String
        var rollOut: String
        var unit: String
        var value: Double
        var catID: NSNumber
        var isCheck: Bool
        var isNA: Bool
        var schAssmentId: Int
    }

    struct DraftRefrigerator {
        var id: Int
        var labelText: String
        var rollOut: String
        var unit: String
        var value: Double
        var catID: NSNumber
        var isCheck: Bool
        var isNA: Bool
        var serverAssessmentId: Int
    }
    
    struct updateOfflineRefrigeratorData {
        var id: Int
        var labelText: String
        var rollOut: String
        var unit: String
        var value: Double
        var catID: NSNumber
        var isCheck: Bool
        var isNA: Bool
        var serverAssessmentId: Int
    }

    struct updateRefrigatorData {
        let id: Int
        let labelText: String
        let rollOut: String
        let unit: String
        let value: Double
        let catID: NSNumber
        let isCheck: Bool
        let isNA: Bool
        let serverAssessmentId: Int
    }
    
    struct updateDraftRefrigeratorData {
        let id: Int
        let labelText: String
        let rollOut: String
        let unit: String
        let value: Double
        let catID: NSNumber
        let isCheck: Bool
        let isNA: Bool
        let serverAssessmentId: Int
    }
    
    struct ExtntdMicroFuncParams {
        var statusType: Int
        var dict: PENewAssessment
        var json: [String: Any]
        var serverAssessmentId: Int64
        var userId: Int?
        var evaluationId: Int?
        var saveType: Int
        var isEMRequested: Bool
        var appVersion: String
        var extendedData: [[String: Any]]?
    }
    
    struct ValidationData {
        var refrigratorDataArr: [[String: Any]]
        var inovojectDataArr: [[String: Any]]
        var dayOfAgeDataArr: [[String: Any]]
        var dayOfAgeSDataArr: [[String: Any]]
        var certificateDataArr: [[String: Any]]
        var vaccineResidueMoldsDataArr: [[String: Any]]
        var vaccineMicroSamplesDataArr: [[String: Any]]
    }
    
    
    struct AssessmentInput {
        let frequencyValue: String
        let qcCount: String
        let personName: String
        let amPmText: String
        let ppmValue: String
        let assessmentScore: Int
        let isNA: Bool
        let questionMark: [String: Any]
    }

    struct CertificateInfo {
        let id: Int
        let name: String
        let date: String
        let isCertExpired: Bool
        let isReCert: Bool
        let vacOperatorId: Int
        let signatureImg: String
        let fsrSign: String
        var certCeatedbyName: String?
        var source: String?
        var certCeatedby: Int?
        let isManuallyAdded: Bool
    }
    
    struct doaVaccinationSaveData {
        let userId: String
        let isExtendedPE: Bool
        let assessmentId: String
        let date: Date?
        var override: Bool? = true
        var subcutaneousTxt: String?  // Optional String
        var dayOfAgeTxt: String?      // Optional String
        var hasChlorineStrips: Bool? = false  // Optional Bool
        var isAutomaticFail: Bool? = false    // Optional Bool
    }

    
    struct RefrigatorDetails {
        var id: NSNumber
        var labelText: String
        var rollOut: String
        var unit: String
        var value: Double
        var catID: NSNumber
        var isCheck: Bool
        var isNA: Bool
        var schAssmentId: Int
    }
    
    struct InovojectInfo {
        
           var id: Int?
          var vaccineMan: String?
          var name: String?
          
          var ampuleSize: String?
          var ampulePerBag: String?
          var bagSizeType: String?
          var dosage: String?
          var dilute: String?
          
          var invoHatchAntibiotic: Int?
          var invoHatchAntibioticText: String?
          var invoProgramName: String?
          var doaDilManOther: String?
        
    }

    struct SubmittedAssessmentConfig {
        var assessment2: JSONNull?
        var types: String?
        var locationPhone: String?
        var comments: String?
        var sequenceNo: Int?
        var moduleCatID: Int?
        var recordID: Int?
        var assessment: String?
        var answer: Bool?
        var id: Int?
    }

    
    
    
}


struct CoreDataHandlerTurkeyModels
{
    struct turkeyfieldStrnVaccination {
        var type: String
        var strain: String
        var route: String
        var age: String
        var index: Int
        var dbArray: NSArray
        var postingId: NSNumber
        var vaciProgram: String
        var sessionId: NSNumber
        var isSync: Bool
        var lngId: NSNumber
    }
    
    
    struct turkyVaccinationData {
        let type: String
        let strain: String
        let route: String
        let index: Int
        let dbArray: NSArray
        let postingId: NSNumber
        let vaciProgram: String
        let sessionId: NSNumber
        let isSync: Bool
        let lngId: NSNumber
    }

    
    struct turkeySettingsSkeletaData {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let quicklinkIndex: Int
    }

    struct updateTurkySkeletaSettings {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct turkeyCoccidiosisSettings {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var quicklinkIndex: Int
    }

    struct updateCoccidiosisTurkeySettings {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
    }

    struct turkeyGITractSettingsData {
        let observationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let information: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let quicklinkIndex: Int
    }
    struct updateGITractSettingsData {
        let observationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let information: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
    }

    struct turkeyRespiratorySettings {
        var observationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var information: String
        var index: Int
        var dbArray: NSArray
        var observationId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var quicklinkIndex: Int
    }

    struct turkeyRespiratorySettingsUpdate {
        var observationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var information: String
        var index: Int
        var dbArray: NSArray
        var observationId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct turkeyImmuneSettings {
        var observationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var information: String
        var index: Int
        var dbArray: NSArray
        var observationId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var quicklinkIndex: Int
    }
    
    struct ImmuneSettingsUpdate {
        var observationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var information: String
        var index: Int
        var dbArray: NSArray
        var observationId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct PostingSessionTurkeyDBData {
        var antobotic: String
        var birdBreesId: NSNumber
        var birdbreedName: String
        var birdBreedType: String
        var birdSize: String
        var birdSizeId: NSNumber
        var cocciProgramId: NSNumber
        var cociiProgramName: String
        var complexId: NSNumber
        var complexName: String
        var convential: String
        var customerId: NSNumber
        var customerName: String
        var customerRepId: NSNumber
        var customerRepName: String
        var imperial: String
        var metric: String
        var notes: String
        var salesRepId: NSNumber
        var salesRepName: String
        var sessiondate: String
        var sessionTypeId: NSNumber
        var sessionTypeName: String
        var vetanatrionName: String
        var veterinarianId: NSNumber
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var mail: String
        var female: String
        var finilize: NSNumber
        var isSync: Bool
        var timeStamp: String
        var lngId: NSNumber
        var birdType: String
        var birdTypeId: NSNumber
        var birdbreedId: NSNumber
        var capNec: NSNumber
        var avgAge: String
        var avgWeight: String
        var outTime: String
        var FCR: String
        var Livability: String
        var mortality: String
    }


    struct updatePostingSessionTurkeyDBData {
        var postingId: NSNumber
        var antobotic: String
        var birdBreesId: NSNumber
        var birdBreedName: String
        var birdBreedType: String
        var birdSize: String
        var birdSizeId: NSNumber
        var cocciProgramId: NSNumber
        var cociiProgramName: String
        var complexId: NSNumber
        var complexName: String
        var convential: String
        var customerId: NSNumber
        var customerName: String
        var customerRepId: NSNumber
        var customerRepName: String
        var imperial: String
        var metric: String
        var notes: String
        var salesRepId: NSNumber
        var salesRepName: String
        var sessionDate: String
        var sessionTypeId: NSNumber
        var sessionTypeName: String
        var vetanatrionName: String
        var veterinarianId: NSNumber
        var loginSessionId: NSNumber
        var mail: String
        var female: String
        var finalize: NSNumber
        var isSync: Bool
        var timeStamp: String
        var lngId: NSNumber
        var birdType: String
        var birdTypeId: NSNumber
        var birdBreedId: NSNumber
        var capNec: NSNumber
        var avgAge: String
        var avgWeight: String
        var outTime: String
        var FCR: String
        var livability: String
        var mortality: String
    }

    struct saveCoccoiControlFeedData {
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var molecule: String
        var dosage: String
        var fromDays: String
        var toDays: String
        var coccidiosisVaccine: String
        var targetWeight: String
        var index: Int
        var dbArray: NSArray
        var feedId: NSNumber
        var feedProgram: String
        var formName: String
        var isSync: Bool
        var feedType: String
        var cocoVacId: NSNumber
        var lngId: NSNumber
        var lbldate: String
        var dosemoleculeId: NSNumber
    }

    // Define a struct to group related parameters
    struct AntiboticControlData {
        var loginSessionId: NSNumber
           var postingId: NSNumber
           var molecule: String
           var dosage: String
           var fromDays: String
           var toDays: String
           var feedId: NSNumber
           var feedProgram: String
           var formName: String
           var isSync: Bool
           var feedType: String
           var cocoVacId: NSNumber
           var lngId: NSNumber
           var lbldate: String
    }


    struct AlternativeFeedData {
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var molecule: String
        var dosage: String
        var fromDays: String
        var toDays: String
        var feedId: NSNumber
        var feedProgram: String
        var formName: String
        var isSync: Bool
        var feedType: String
        var cocoVacId: NSNumber
        var lngId: NSNumber
        var lbldate: String
    }

    struct myCoxtinFeedData {
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var molecule: String
        var dosage: String
        var fromDays: String
        var toDays: String
        var feedId: NSNumber
        var feedProgram: String
        var isSync: Bool
        var feedType: String
        var cocoVacId: NSNumber
        var lngId: NSNumber
        var lbldate: String
        var formName: String
    }

    struct turkeyFeedProgramData {
        var postingId: NSNumber
        var sessionId: NSNumber
        var feedProgrameName: String
        var feedId: NSNumber
        var formName: String
        var isSync: Bool
        var lngId: NSNumber
    }

    struct saveTurkeyNecropsyStep1Data {
        let postingId: NSNumber
        let age: String
        let farmName: String
        let feedProgram: String
        let flockId: String
        let houseNo: String
        let noOfBirds: String
        let sick: NSNumber
        let necId: NSNumber
        let compexName: String
        let complexDate: String
        let complexId: NSNumber
        let customerId: NSNumber
        let feedId: NSNumber
        let isSync: Bool
        let timeStamp: String
        let actualTimeStamp: String
        let lngId: NSNumber
        let farmWeight: String
        let abf: String
        let breed: String
        let sex: String
        let farmId: NSNumber
        let imageId: NSNumber
        let count: NSNumber
        let genName: String
        let genId: NSNumber
    }

    struct singleNecropsyDataTurkey {
        var postingId: NSNumber
        var age: String
        var farmName: String
        var feedProgram: String
        var flockId: String
        var houseNo: String
        var noOfBirds: String
        var sick: NSNumber
        var necId: NSNumber
        var compexName: String
        var complexDate: String
        var complexId: NSNumber
        var custmerId: NSNumber
        var feedId: NSNumber
        var isSync: Bool
        var timeStamp: String
        var actualTimeStamp: String
        var necIdSingle: NSNumber
        var farmweight: String
        var abf: String
        var sex: String
        var breed: String
        var farmId: NSNumber
        var imgId: NSNumber
        var generationName: String
        var generationId: NSNumber
    }
    struct switchCaseCaptureSkeletaDataTurkey {
        let catName: String
        let obsName: String
        let formName: String
        let obsVisibility: Bool
        let birdNo: NSNumber
        let obsPoint: NSInteger
        let index: Int
        let obsId: NSInteger
        let measure: String
        let quickLink: NSNumber
        let necId: NSNumber
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let actualText: String
    }

    struct turkeySexNecropsyData {
        let catName: String
        let obsName: String
        let formName: String
        let obsVisibility: Bool
        let birdNo: NSNumber
        let obsPoint: NSInteger
        let index: Int
        let obsId: NSInteger
        let measure: String
        let quickLink: NSNumber
        let necId: NSNumber
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let actualText: String
    }

    struct imumneSwithcCaptureData {
        var catName: String
        var obsName: String
        var formName: String
        var obsVisibility: Bool
        var birdNo: NSNumber
        var obsPoint: Float
        var index: Int
        var obsId: NSInteger
        var measure: String
        var quickLink: NSNumber
        var necId: NSNumber
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var actualText: String
    }

    struct singleNecroSwithCaseData {
        var catName: String
        var obsName: String
        var formName: String
        var obsVisibility: Bool
        var birdNo: NSNumber
        var obsPoint: NSInteger
        var index: Int
        var obsId: NSInteger
        var measure: String
        var quickLink: NSNumber
        var necId: NSNumber
        var isSync: Bool
        var necIdSingle: NSNumber
        var lngId: NSNumber
        var refId: NSNumber
    }
    
    struct updateSkeletaTurkeySexValueObs {
        let catName: String
        let obsName: String
        let formName: String
        let obsVisibility: Bool
        let birdNo: NSNumber
        let obsPoint: NSInteger
        let obsId: NSInteger
        let necId: NSNumber
        let isSync: Bool
        let actualText: String
    }

    struct SkeletalTurkeyImageData {
        let catName: String
        let obsName: String
        let formName: String
        let birdNo: NSNumber
        let camraImage: UIImage
        let obsId: NSInteger
        let necropsyId: NSNumber
        let isSync: Bool
    }

    struct saveTurkeyNoteData {
        let catName: String
        let notes: String
        let formName: String
        let birdNo: NSNumber
        let necId: NSNumber  // Can be used if needed elsewhere
        let isSync: Bool
        let necIdSingle: NSNumber
    }

    
    struct TurkeyCoxinmodel {
        let feedId: NSNumber
        let index: Int
        let loginSessionId: NSNumber
        let postingId: NSNumber
        let molecule: String
        let dosage: String
        let fromDays: String
        let toDays: String
        let feedProgram: String
        let isSync: Bool
        let feedType: String
        let cocoVacId: NSNumber
        let lngId: NSNumber
        let lbldate: String
        let formName: String
    }
    
    struct updateWeightSkeletaData {
        let catName: String
        let obsName: String
        let formName: String
        let birdNo: NSNumber
        let actualName: String
        let index: Int
        let necId: NSNumber
        let isSync: Bool
    }
    struct SkeletaUpdateSwithCaseTurkey {
        let catName: String
        let obsName: String
        let formName: String
        let obsVisibility: Bool
        let birdNo: NSNumber
        let camraImage: UIImage
        let obsPoint: NSInteger
        let obsId: NSInteger
        let necId: NSNumber
        let isSync: Bool
    }
    struct TurkeyFarmNecropsyInput {
        let farmDict: [String: Any]
        let sessionId: Int
        let devSessionId: String
        let lngId: NSNumber
        let custId: Int
        let complexId: Int
        let complexName: String
        let seesDat: String
    }

    struct TurkeyBirdProcessingInput {
        let birdArr: Any?
        let catName: String
        let obsName: String
        let farmName: String
        let obsId: Int
        let measure: String
        let quickLink: Any?
        let sessionId: Int
        let languageId: NSNumber
        let refId: NSNumber
    }
}

struct chickenCoreDataHandlerModels {
    struct saveSkeletaSettingsInDB {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let quicklinkIndex: Int
    }
    
    struct updateSkeletaSettingData {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct saveCoccidiosisSettingDB {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var quicklinkIndex: Int
    }
    
    struct updateCoccidiosisSettingData {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct saveGITractSettingData {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let quicklinkIndex: Int
    }

    struct updateGITractSettingData {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct saveRespiratorySettings {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var index: Int
        var dbArray: NSArray
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
        var quicklinkIndex: Int
    }

    struct updateRespiratorySettings {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
    }

    struct saveImmuneSettings {
        let strObservationField: String
        let visibilityCheck: Bool
        let quicklinks: Bool
        let strInformation: String
        let index: Int
        let dbArray: NSArray
        let obsId: NSInteger
        let measure: String
        let isSync: Bool
        let lngId: NSNumber
        let refId: NSNumber
        let quicklinkIndex: Int
    }
    
    struct ImmuneUpdateData {
        var strObservationField: String
        var visibilityCheck: Bool
        var quicklinks: Bool
        var strInformation: String
        var obsId: NSInteger
        var measure: String
        var isSync: Bool
        var lngId: NSNumber
        var refId: NSNumber
    }

    struct chickenPostingSessionData {
        var antiboitic: String
        var birdBreesId: NSNumber
        var birdbreedName: String
        var birdBreedType: String
        var birdSize: String
        var birdSizeId: NSNumber
        var cocciProgramId: NSNumber
        var cociiProgramName: String
        var complexId: NSNumber
        var complexName: String
        var convential: String
        var customerId: NSNumber
        var customerName: String
        var customerRepId: NSNumber
        var customerRepName: String
        var imperial: String
        var metric: String
        var notes: String
        var salesRepId: NSNumber
        var salesRepName: String
        var sessiondate: String
        var sessionTypeId: NSNumber
        var sessionTypeName: String
        var vetanatrionName: String
        var veterinarianId: NSNumber
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var mail: String
        var female: String
        var finilize: NSNumber
        var isSync: Bool
        var timeStamp: String
        var lngId: NSNumber
        var productionTypName: String
        var productionTypId: NSNumber
        var avgAge: String
        var avgWeight: String
        var outTime: String
        var FCR: String
        var Livability: String
        var mortality: String
    }

    struct updatePostingSessionData {
        var antiboitic: String
        var birdBreesId: NSNumber
        var birdbreedName: String
        var birdBreedType: String
        var birdSize: String
        var birdSizeId: NSNumber
        var cocciProgramId: NSNumber
        var cociiProgramName: String
        var complexId: NSNumber
        var complexName: String
        var convential: String
        var customerId: NSNumber
        var customerName: String
        var customerRepId: NSNumber
        var customerRepName: String
        var imperial: String
        var metric: String
        var notes: String
        var salesRepId: NSNumber
        var salesRepName: String
        var sessiondate: String
        var sessionTypeId: NSNumber
        var sessionTypeName: String
        var vetanatrionName: String
        var veterinarianId: NSNumber
        var loginSessionId: NSNumber
        var postingId: NSNumber
        var mail: String
        var female: String
        var finilize: NSNumber
        var isSync: Bool
        var timeStamp: String
        var lngId: NSNumber
        var productionTypName: String
        var productionTypId: NSNumber
        var avgAge: String
        var avgWeight: String
        var outTime: String
        var FCR: String
        var Livability: String
        var mortality: String
    }

    struct saveChickenFeedProgramData {
        var postingId: NSNumber
        var sessionId: NSNumber
        var feedProgrameName: String
        var feedId: NSNumber
        var dbArray: NSArray
        var index: Int
        var formName: String
        var isSync: Bool
        var lngId: NSNumber
    }
    struct BirdNotesData {
        var catName: String
        var notes: String
        var formName: String
        var birdNo: NSNumber
        var index: Int
        var necId: NSNumber
        var isSync: Bool
        var necIdSingle: NSNumber
    }

    struct saveSkeletalBirdPhotoCaptureData {
        let catName: String
        let obsName: String
        let formName: String
        let birdNo: NSNumber
        let cameraImage: UIImage
        let obsId: NSInteger
        let necropsyId: NSNumber
        let isSync: Bool
        let viewController: CaptureNecropsyDataViewController
    }

    struct actualClickUpdateCaptureSkeletaData {
        let catName: String
        let obsName: String
        let formName: String
        let birdNo: NSNumber
        let actualName: String
        let index: Int
        let necId: NSNumber
        let isSync: Bool
        let refId: NSNumber
    }

    struct updateSkeletaSingleSyncSkeletaData {
        var catName: String
        var obsName: String
        var formName: String
        var obsVisibility: Bool
        var birdNo: NSNumber
        var obsPoint: NSInteger
        var index: Int
        var obsId: NSInteger
        var measure: String
        var quickLink: NSNumber
        var necId: NSNumber
        var isSync: Bool
        var necIdSingle: NSNumber
        var lngId: NSNumber
        var refId: NSNumber
        var actualText: String
    }

    struct SaveNecropsystep1SingleNecropsyData {
        var postingId: NSNumber
        var age: String
        var farmName: String
        var feedProgram: String
        var flockId: String
        var houseNo: String
        var noOfBirds: String
        var sick: NSNumber
        var necId: NSNumber
        var compexName: String
        var complexDate: String
        var complexId: NSNumber
        var custmerId: NSNumber
        var feedId: NSNumber
        var isSync: Bool
        var timeStamp: String
        var actualTimeStamp: String
        var necIdSingle: NSNumber
        var farmId: NSNumber
        var imgId: NSNumber
    }
    struct saveNecropsyStep1Data {
        var postingId: NSNumber
        var age: String
        var farmName: String
        var feedProgram: String
        var flockId: String
        var houseNo: String
        var noOfBirds: String
        var sick: NSNumber
        var necId: NSNumber
        var compexName: String
        var complexDate: String
        var complexId: NSNumber
        var custmerId: NSNumber
        var feedId: NSNumber
        var isSync: Bool
        var timeStamp: String
        var actualTimeStamp: String
        var lngId: NSNumber
        var farmId: NSNumber
        var imageId: NSNumber
        var count: NSNumber
    }

    struct saveChiknHtchryVacintnDetails {
        var type: String
        var strain: String
        var route: String
        var age: String
        var postingId: NSNumber
        var vaciProgram: String
        var sessionId: NSNumber
        var isSync: Bool
        var lngId: NSNumber
        var routeID: Int
    }
    
    struct saveChknFieldVaccinationDetails {
        var type: String
        var strain: String
        var route: String
        var postingId: NSNumber
        var vaciProgram: String
        var sessionId: NSNumber
        var isSync: Bool
        var lngId: NSNumber
        var routeID: Int
    }
    
    struct updateSkeletalSwitchCaseCaptureData {
        let catName: String
        let obsName: String
        let formName: String
        let obsVisibility: Bool
        let birdNo: NSNumber
        let cameraImage: UIImage
        let obsPoint: Int
        let index: Int
        let obsId: Int
        let necId: NSNumber
        let isSync: Bool
    }

    struct saveChknAntibioticFeedData {
        let loginSessionId: NSNumber
        let postingId: NSNumber
        let molecule: String
        let dosage: String
        let fromDays: String
        let toDays: String
        let index: Int
        let dbArray: NSArray
        let feedId: NSNumber
        let feedProgram: String
        let formName: String
        let isSync: Bool
        let feedType: String
        let cocoVacId: NSNumber
        let lngId: NSNumber
        let lblDate: String
    }
    
    struct submitdNecrStep1Data {
        let farmItem: JSON
        let sessionId: Int
        let devSessionId: String
        let lngId: NSNumber
        let custId: Int
        let complexId: Int
        let complexName: String
        let seesDat: String
    }

    struct manBreedValidationData {
        var manufacturerName: String
        var manufacturerNames: NSArray
        var manufacturerIDs: NSArray
        
        var breedName: String
        var breedNames: NSArray
        var breedIDs: NSArray
        
        var eggName: String
        var eggNames: NSArray
        var eggIDs: NSArray

        // Output values
        var manufacturerId: Int = 0
        var breedId: Int = 0
        var eggId: Int = 0
    }

    struct chickenFarmInputData {
        let farmName: String?
        let houseNo: String?
        let noOfBirds: Int
        let farmId: NSNumber?
        let imageId: NSNumber?
        let feedProgram: String?
        let feedId: Int
        let age: String?
        let customerId: NSNumber?
        let customerName: String?
        let sick: String?
        let flockId: NSNumber?
        let complexDate: String?
        let birdDetails: NSMutableArray
    }

    struct chickenBirdDataProcessing {
        let birdArr: Any?
        let catName: String
        let obsName: String
        let farmName: String
        let obsId: Int
        let measure: String
        let dataVar: (Any?, Int, NSNumber, NSNumber)
        let index: Int
    }
    
    
    struct MyCoxtinBinderInput {
        let loginSessionId: NSNumber
        let postingId: NSNumber
        let molecule: String
        let dosage: String
        let fromDays: String
        let toDays: String
        let feedId: NSNumber
        let feedProgram: String
        let formName: String
        let isSync: Bool
        let feedType: String
        let cocoVacId: NSNumber
        let lngId: NSNumber
        let lblDate: String
    }



}

struct ReportComposerDaignosticModels
{
    struct PlaceholderTemplate {
        let htmlContent: String
        let complexName: String
        let customerName: String
        let vetanatrionName: String
        let salesRepName: String
        let customerRepName: String
        let typeDate: String
        let isCocciHistory: Bool
        let logoImageURL: String
    }

}


struct PVEDataModel{
    struct WingInjectionData {
        let injCenter_LeftWing: Int
        let leftRightInjTotal: Int
        let injCenter_RightWing: Int
        let injWingBand_LeftWing: Int
        let injWingBand_RightWing: Int
        let injMuscleHit_LeftWing: Int
        let injMuscleHit_RightWing: Int
        let injMissed_LeftWing: Int
        let injMissed_RightWing: Int
    }
}
struct NecropsyFarmModel {
    let farmName: String
    let age: String
    let birds: String
    let houseNo: String
    let flockId: String
    let feedProgram: String
    let sick: Bool
    let feedId: Int
    let farmWeight: String
    let abf: String
    let sex: String
    let breed: String
    let farmId: Int
    let generationName: String
    let generationId: Int
    let imgId: Int
}

struct NecropsySessionInput {
    var farms: [NecropsyFarmModel]
    var sessionId: Int
    var postingId: Int
    var complexName: String
    var seesDate: String
    var complexId: Int
    var customerId: Int
    var deviceSessionId: String
}

struct CoxinInputModel {
    let feedId: NSNumber
    let index: Int
    let loginSessionId: NSNumber
    let postingId: NSNumber
    let molecule: String
    let dosage: String
    let fromDays: String
    let toDays: String
    let feedProgram: String
    let isSync: Bool
    let feedType: String
    let cocoVacId: NSNumber
    let lngId: NSNumber
    let lbldate: String
    let formName: String
}

struct CoccidiosisControlData {
    let loginSessionId: NSNumber
    let postingId: NSNumber
    let molecule: String
    let dosage: String
    let fromDays: String
    let toDays: String
    let coccidiosisVaccine: String
    let targetWeight: String
    let index: Int
    let dbArray: NSArray
    let feedId: NSNumber
    let feedProgram: String
    let formName: String
    let isSync: Bool
    let feedType: String
    let cocoVacId: NSNumber
    let lngId: NSNumber
    let lbldate: String
    let doseMoleculeId: Int
}

struct AlternativeFeedData {
    var loginSessionId: NSNumber
    var postingId: NSNumber
    var molecule: String
    var dosage: String
    var fromDays: String
    var toDays: String
    var feedId: NSNumber
    var feedProgram: String
    var formName: String?
    var isSync: Bool
    var feedType: String
    var cocoVacId: NSNumber
    var lngId: NSNumber
    var lblDate: String
}
struct SkeletalObservationData {
    let catName: String
    let obsName: String
    let formName: String
    let obsVisibility: Bool
    let birdNo: NSNumber
    let obsPoint: NSInteger
    let obsId: NSInteger
    let measure: String
    let quickLink: NSNumber
    let necId: NSNumber
    let isSync: Bool
    let lngId: NSNumber
    let refId: NSNumber
    let actualText: String
}
struct ReportPlaceholderData {
    let complexName: String
    let customerName: String
    let vetanatrionName: String
    let salesRepName: String
    let customerRepName: String
    let typeDate: String
    let isCocciHistory: Bool
    let logoImageURL: String
}
struct ReportLayoutConfigProcessItems {
    let birdsMarginHistory: String
    let birdsMarginSummary: String
    let ageMarginHistory: String
    let ageMarginSummary: String
}

struct ReportConfigDiagnosticVariable {
    let template: String
    let meanArray: [[AnyObject]]
    let lngId: Int
    let isCocciHistory: Bool
}
struct ReportConfigDiagnosticHandleAgeSplitting {
    let content: String
    let item: [String: AnyObject]
    let index: Int
    let items: [[String: AnyObject]]
}
struct GITractModelDataVars {
    let quickLink: Any
    let sessionId: Int
    let languageId: NSNumber
    let refId: NSNumber
}


struct GITractDataModels {
    
    struct EnvironmentData {
        var dataVar: (String, Int)
        var aArray: NSArray
        var j: Int
        var pericarditis: Float
        var septicemia: Float
        var liverGranuloma: Float
        var activeBursa: Float
        var cellulitis: Float
    }
    
    
    struct HealthDataParams {
        var aArray: NSArray
        var j: Int
        var footPadLesions: Float
        var scratchedBirds: Float
        var cornealUlcers: Float
        var femoralHeadNecrosis: Float
        var tibialDyschondroplasia: Float
        var rickets: Float
        var boneStrength: Float
        var synovitis: Float
        var infectiousProcess: Float
        var breastMyopathy: Float
        var muscularHemorrhages: Float
        var notExistValue: Float  // Assuming NOT_EXIST value, like -1 or something
    }
    
    struct ItemProcessingInput {
        var dataVar: ([String: Any], Int)
        var items: [[String: Any]]
        var meanArray: [[Float]]
    }
    

}

struct TraningCertificationDataModels {
    
    struct ShippingAddressConfig {
        var fssName: String?
        var fssID: Int?
        var trainingID: Int?
        var id: Int?
        var city: String?
        var address2: String?
        var stateID: Int?
        var countryID: Int?
        var address1: String?
        var pincode: String?
        var countryName: String?
        var stateName: String?
        var addressTypeIs : Bool?
        var siteIdIs: Int?
        var siteNameIs: String?
        var stateNameIs: String?
        
    }
  
}


struct MicrobialDataModels {
    struct LocationValueConfig {
        let locatgionTypeId: Int?
        let std40: Bool?
        let std20: Bool?
        let rapNo40: Int?
        let rapNo20: Int?
        let standard: Bool?
        let stnRep: Int?
        let mediaTypeDefault: String?
        let samplingMethodDefault: String?
    }

}



struct PVEAlertShow{
    
    func alertMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Something went wrong with your request. Please try again."
        case 404:
            return "No records found."
        case 500:
            return "A server error occurred. Please try again later."
        case 204:
            return "No content available to display."
        default:
            return "An unexpected error occurred. Please try again."
        }
    }
}

var trainingScheduleArray: [[String:Any]]?
var trainingStateName: String?

func saveCountryAndState(certId:String,
                         countryId:Int?,
                         stateId:Int?,
                         addressLine1:String?,
                         addressLine2:String?,
                         city:String?,
                         zip:String?,
                         siteId:Int?,
                         siteName:String?,
                         countryName:String?,
                         stateName:String?,
                         isOtherAddress:Bool?
                         )
{
    
    if countryId != nil {
        UserDefaults.standard.set(countryId, forKey: "savedCountryID-\(certId)")
    }
    if stateId != nil {
        UserDefaults.standard.set(stateId, forKey: "savedStateID-\(certId)")
    }
    if addressLine1 != nil {
        UserDefaults.standard.set(addressLine1, forKey: "addressLine1-\(certId)")
    }
    if addressLine2 != nil {
        UserDefaults.standard.set(addressLine2, forKey: "addressLine2-\(certId)")
    }
    if city != nil {
        UserDefaults.standard.set(city, forKey: "city-\(certId)")
    }
    if zip != nil {
        UserDefaults.standard.set(zip, forKey: "zip-\(certId)")
    }
    if siteId != nil {
        UserDefaults.standard.set(siteId, forKey: "savedSiteId-\(certId)")
    }
    if siteName != nil {
        UserDefaults.standard.set(siteName, forKey: "savedSiteName-\(certId)")
    }
    if countryName != nil {
        UserDefaults.standard.set(countryName, forKey: "savedCountryName-\(certId)")
    }
    if stateName != nil {
        UserDefaults.standard.set(countryName, forKey: "savedStateName-\(certId)")
    }
    if isOtherAddress != nil {
        UserDefaults.standard.set(isOtherAddress, forKey: "isOtherAddress-\(certId)")
    }
 
    UserDefaults.standard.synchronize()
}

func fetchCountryAndState(certId:String , _ isSite:String = "") -> CountryState? {
    let country = UserDefaults.standard.value(forKey: "savedCountryID-\(certId)") as? Int
    let state = UserDefaults.standard.value(forKey: "savedStateID-\(certId)") as? Int
    
    let addressLine1 = UserDefaults.standard.value(forKey: "addressLine1-\(certId)") as? String
    let addressLine2 = UserDefaults.standard.value(forKey: "addressLine2-\(certId)") as? String
    let city = UserDefaults.standard.value(forKey: "city-\(certId)") as? String
    let zip = UserDefaults.standard.value(forKey: "zip-\(certId)") as? String
    
    let siteName = UserDefaults.standard.value(forKey: "savedSiteName-\(certId)") as? String
    let stateName = UserDefaults.standard.value(forKey: "savedStateName-\(certId)") as? String
    let countryName = UserDefaults.standard.value(forKey: "savedCountryName-\(certId)") as? String
    let siteId = UserDefaults.standard.value(forKey: "savedSiteId-\(certId)") as? Int
    let isOtherAddress = UserDefaults.standard.value(forKey: "isOtherAddress-\(certId)") as? Bool
    
    let countryState = CountryState(countryId: country,stateId: state,addressLine1:addressLine1,addressLine2:addressLine2,city:city,zip:zip , siteId:siteId , siteName: siteName ,stateName:stateName ,isOtherAddress:isOtherAddress,countryName:countryName)
    return countryState
}

struct CountryState {
    var countryId:Int?
    var stateId:Int?
    var addressLine1:String?
    var addressLine2:String?
    var city:String?
    var zip:String?
    var siteId:Int?
    var siteName: String?
    var stateName:String?
    var isOtherAddress:Bool?
    var countryName:String?
    
}


func saveSiteAddress(certId:String,
                         countryId:Int?,
                         stateId:Int?,
                         addressLine1:String?,
                         addressLine2:String?,
                         city:String?,
                         zip:String?,
                         siteId:Int?,
                         siteName:String?,
                         countryName:String?,
                         stateName:String?,
                         isOtherAddress:Bool?
                         )
{
    
    if countryId != nil {
        UserDefaults.standard.set(countryId, forKey: "siteSavedCountryID-\(certId)")
    }
    if stateId != nil {
        UserDefaults.standard.set(stateId, forKey: "siteSavedStateID-\(certId)")
    }
    if addressLine1 != nil {
        UserDefaults.standard.set(addressLine1, forKey: "siteAddressLine1-\(certId)")
    }
    if addressLine2 != nil {
        UserDefaults.standard.set(addressLine2, forKey: "siteAddressLine2-\(certId)")
    }
    if city != nil {
        UserDefaults.standard.set(city, forKey: "siteCity-\(certId)")
    }
    if zip != nil {
        UserDefaults.standard.set(zip, forKey: "siteZip-\(certId)")
    }
    if siteId != nil {
        UserDefaults.standard.set(siteId, forKey: "siteSavedSiteId-\(certId)")
    }
    if siteName != nil {
        UserDefaults.standard.set(siteName, forKey: "siteSavedSiteName-\(certId)")
    }
    if countryName != nil {
        UserDefaults.standard.set(countryName, forKey: "siteSavedCountryName-\(certId)")
    }
    if stateName != nil {
        UserDefaults.standard.set(stateName, forKey: "siteSavedStateName-\(certId)")
    }
    if isOtherAddress != nil {
        UserDefaults.standard.set(isOtherAddress, forKey: "siteOtherAddress-\(certId)")
    }
 
    UserDefaults.standard.synchronize()
}

func fetchSavedSiteAddress(certId:String , _ isSite:String = "") -> CountryState? {
    let country = UserDefaults.standard.value(forKey: "siteSavedCountryID-\(certId)") as? Int
    let state = UserDefaults.standard.value(forKey: "siteSavedStateID-\(certId)") as? Int
    
    let addressLine1 = UserDefaults.standard.value(forKey: "siteAddressLine1-\(certId)") as? String
    let addressLine2 = UserDefaults.standard.value(forKey: "siteAddressLine2-\(certId)") as? String
    let city = UserDefaults.standard.value(forKey: "siteCity-\(certId)") as? String
    let zip = UserDefaults.standard.value(forKey: "siteZip-\(certId)") as? String
    
    let siteName = UserDefaults.standard.value(forKey: "siteSavedSiteName-\(certId)") as? String
    let stateName = UserDefaults.standard.value(forKey: "siteSavedStateName-\(certId)") as? String
    let countryName = UserDefaults.standard.value(forKey: "siteSavedCountryName-\(certId)") as? String
    let siteId = UserDefaults.standard.value(forKey: "siteSavedSiteId-\(certId)") as? Int
    let isOtherAddress = UserDefaults.standard.value(forKey: "siteOtherAddress-\(certId)") as? Bool
    
    let countryState = CountryState(countryId: country,stateId: state,addressLine1:addressLine1,addressLine2:addressLine2,city:city,zip:zip , siteId:siteId , siteName: siteName ,stateName:stateName ,isOtherAddress:isOtherAddress,countryName:countryName)
    return countryState
}

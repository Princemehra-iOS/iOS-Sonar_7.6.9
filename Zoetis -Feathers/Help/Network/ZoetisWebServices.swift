//  Zoetis -Feathers
//
//  Created by "" ""on 08/11/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MBProgressHUD

typealias CompletionBlock = (JSON, NSError?) -> Void

class ZoetisWebServices: BaseViewController {
    
    static let shared = ZoetisWebServices()
    var viewController = UIViewController()
    let languageIdStr = "&LanguageId=1"
    let countryIdStr = "&CountryId="
    let regionIdStr = "&RegionId="
    
    enum DeviceIDRequestType {
           case postedSession
           case vaccineList
           case feedList
        case farmList
        case birdsNotes
        case NecropsyByDeviceID
        case chickenPostedSessions
        case FlockFeedSession
        case PostedSessionVaccination
        case NotesPostedSession
        case PostedNecropsyFarmList
        case necropsyList
        case necropsyImagesList
        case tukeyPostedFarmList
        case targetWeight
        case cocciVaccineTurkey
        case salesRepresentative
        case getRoute
        case getTurkeyHatcheryStrain
        case getTurkeyFieldStrain
        case getDosage
        case getTurkeyGeneration
        case getTurkeyDoseByMoleculeId
        case getCocciProgram
        case getSessionType
        case getBirdBreedChickenAndTurkey
        case getFeedProgramCatagoryAndMolecule
        case getVeterinarian
        case TurkeyPostedSessionsVacccine
        case TurkeyPostedNotes
        case TurkeyPostedImages
        case Tutorial
       }
    
    
    enum EndPoint: String {
        case login = "Token"
        
        case getMasterDataVersion = "/api/UserManagement/GetMasterTableDataVersion"
        
        //********************************PE Migration**************************
                                   
        case getPostingSessionList = "/api/PostingSession/GetPostingSessionListByUser?UserId="
        case getAllCustomerPE = "/api/Assessment/GetAllCustomer_PE"
        case getPEDosages = "/api/Assessment/GetPEDosages"
        case getCustomerPE = "/api/Assessment/GetAssignedCustomerByUser?userId="
        case getSitesPE = "/api/Assessment/GetAssignedSitesByUser?userId="
        case getApproversPE = "/api/Assessment/GetTSRUser?CountryId="
        case getEvaluator = "/api/Assessment/GetEvaluator?CountryId="
        case getVisitTypes = "/api/Assessment/GetReasonForVisitTypes"
        case getEvaluatorTypes = "/api/Assessment/GetEvaluationTypes?userId="
        case getManufacturer = "/api/Assessment/GetManufacturer"
        case getBirdBreed = "/api/Assessment/GetBirdBreeds?userId="
        case getEggs = "/api/Assessment/GetEggsPerFlat"
        case getVaccineManufacturer = "/api/Assessment/GetVaccineManufacturer?userId="
        case getVaccineNames = "/api/Assessment/GetVaccineNames?userId="
        case getSubVaccineNames = "/api/Assessment/GetVaccineNamesSubcutaneous?userId="
        case getDiluentManufacturer = "/api/Assessment/DiluentManufacturer"
        case getbagSizes = "/api/Assessment/GetBagSizeTypes"
        case getAmplePerBag = "/api/Assessment/GetAmpulePerBag"
        case getAmpleSizes = "/api/Assessment/GetAmpuleSizes"
        case getPERoles = "/api/Assessment/GetRoles?"
        case getPEFrequency = "/api/Assessment/GetAssessmentFreuqncies"
        case getPECountry = "/api/Assessment/GetCountry"
        case getPEDOADiluentType = "/api/Assessment/GetDayOfAgeDiluentType"
        case getIncubationStyle = "/api/Assessment/GetIncubationStyles"
        case getPEDOASizes = "/api/Assessment/GetDayOfAgeBagSizeTypes?"
        case getPEClorine = "/api/Assessment/GetChlorineTypes?"
        
        //      New
        case getDuplicacyCheck = "/api/Assessment/DuplicateAssessmentcheck"
        case getPostingAssessmentListByUserPE = "/api/Assessment/GetPostingAssessmentListByUser?UserId="
        case getPostingAssessmentImagesListByUserPE = "/api/AssessmentImage/GetPostingAssessmentImagesListByUser?UserId="
        case getModuleAssessmentCategoriesDetailsPE = "/api/Assessment/GetQuestionAnswerCategories?"
        case getAssessmentQuesInfoPE = "/api/Assessment/GetAssessmentInfosDetails"
        case postAddAttachmentDetails = "/api/Assessment/AddAssessment"
        case postAddScores = "/api/Assessment/AddScores"
        case postAddDayOfAgeAndInvoject = "/api/Assessment/AddInovojectDayOfAgeDetails"
        case postImagesBase64 = "/api/AssessmentImage/SaveAssessmentImagesDetails"
        case getPEScheduledCertifications = "/api/Assessment/GetAssessmentSchedulesListById/"
        case getPERejectedAssessment = "/api/Assessment/GetRejectedAssessmentListByUser?UserId="
        case getPERejectedAssessmentImages = "/api/AssessmentImage/GetAssessmentImageById?AssessmentId="
        case getPlateTypes = "/api/Assessment/GetPlateTypes"
        case deleteDrafts = "/api/Assessment/DeleteDrafts?draftIds="
        case postUpdateStatus = "/api/Assessment/updateStatusType?assessmentId="
        case getAppVersion = "/api/user/GetAppversion?Versionno="
        case getAssessmentStatus = "/api/Assessment/GetAssessmentStatusType?AssessmentId="
        case getVaccineMixerList = "/api/Assessment/GetVaccineMixerOperatorNames?CustomerId="
        case finalAssessmentStatus = "/api/Assessment/FinalAssessmentStatus_V2"
        case postExtendedMicro = "/api/Assessment/AddEMAssessment"
        case getGigyaCountries = "/api/Login/GetCountrys"
        case getGigyaCountryLanguages = "/api/Login/GetLanguage?"
        case getGigyaApiKeys = "/api/Login/GetApiMobkeysList?"
        
        case getEncryptedEmail = "/api/Login/GetEncryptText?"
        //&StatusType=1
        //PVE--------------------
        /* Dev */
        ///*
        
        case getCustomerListPVE = "/api/CustomerDetails/GetAssignedCustomerByUser?userId="
        case getComplexPVEOld = "/api/ComplexDetails?customerId="
        case getComplexPVE = "/api/ComplexDetails?"
        case getEvaluationTypePVE = "/api/EvaluationDetails/GetEvaluationType?moduleId=2"
        case getEvaluationForPVE = "/api/EvaluationDetails/GetEvaluationFor"
        case getSiteIDNameDetailsPVE = "/api/HatcherySitesDetails"
        case getBirdAgeDetailsPVE = "/api/BirdAgeDetails"
        case getBirdBreedsDetailsPVE = "/api/BirdBreedsDetails/GetBirdBreeds"
        case getHousingDetailsPVE = "/api/HousingDetails"
        case getAssignUserDetailPVE = "/api/AssignUserDetails/GetAccountManagerList"
        case getEvaluatorDetailPVE = "/api/UserDetails/GetEvaluator"
        case getModuleAssessmentCategoriesDetailsPVE = "/api/ModuleAssessmentCategoriesDetails/GetModuleAssessmentCategoriesDetails?Module_Id=2"
        case getModuleAssessmentsPVE = "/api/ModuleAssessmentsDetails?Module_Cat_Id="
        case getSerotypeDetailsPVE = "/api/VaccineNamesDetails/GetAntigen"
        case getSurveyTypeDetailsPVE = "/api/SurveyTypeDetails"
        case getSiteInjctsDetailssPVE = "/api/SiteInjctsDetails"
        case getVaccineManDetailsPVE = "/api/VaccineManDetails"
        case getVaccineNamesDetailsPVE = "/api/VaccineNamesDetails/GetVaccineNamesDetails?api_key=GetPostingAssessmentListByUs"
        case getPostingAssessmentListByUser = "/api/AssignUserDetails/GetPostingAssessmentListByUser"
        case getBlankAssessmentFiles = "/api/Assessment/GetBlankAssessmentFiles"
        case getDownloadBlankFile = "/api/Assessment/GetDownloadBlankFile?"
        
      
        case getPostingAssessmentImagesListByUser = "/api/AssignUserDetails/GetPostingAssessmentImagesListByUser?DeviceType=ios&api_key=GetPostingAssessmentListByUser"
        case postSNADetailsPVE = "/api/AssessmentDetails/CreateAssessmentDetails"
        case postScoreDetailsPVE = "/api/AssessmentDetails/SaveAssessmentScoresDetails"
        case postSaveAssessmentImagesDetailsPVE = "/api/AssessmentDetails/SaveAssessmentImagesDetails"
        case postPDFPVE = "/api/VaccineNamesDetails/GetPdfReport?reportType=1"
        case postPDFPVENotBlank = "/api/VaccineNamesDetails/GetPdfReport?reportType=0"
        case getPostingAssessmentCompleteImagesListByUser = "/api/AssignUserDetails/GetPostingAssessmentCompleteImagesListByUser?DeviceType=ios&api_key=GetPostingAssessmentListByUser"
        
 
        
        
        ///Microbial-----------------------------
        case getAllEnvironmentalLocationTypes = "/api/MicrobialLocationTypes/AllMicrobiallEnvironmentalLocationTypes"
        case getAllBacterialLocationTypes = "/api/MicrobialLocationTypes/AllMicrobialBacterialLocationTypes"
        case getAllCustomersMicrobial = "/api/Customer/GetAllCustomersByUser?UserId="
        case getAllLocationValues = "/api/MicrobialLocationValues/AllMicrobialLocationValues"
        case getAllHatcherySiteMicrobial =  "/api/HatcherySites/GetAllHatcherySites"
        case getAllHatcheryReviewerMicrobial = "/api/Users/GetAllTsrUsers"
        case getAllHatcheryConductTypesMicrobial = "/api/MicrobialConductTypes/AllConductTypes"
        case getAllHatcheryPurposeOfSurveyURLPathMicrobial = "/api/MicrobialSurveyPurpose/AllSurveyPurpose"
        case getAllHatcheryAllTransferTypeURLPathMicrobial = "/api/MicrobialTransferTypes/AllMicrobialTransferTypes"
        case getAllHatcheryAllVisitTypeURLPathMicrobial = "/api/MicrobialVisitTypes/GetAllVisitTypes"
        case getAllMicrobialSpecimenTypes = "/api/MicrobialSpecimenType/AllMicrobialSpecimenTypes"
        case getAllMicrobialFeatherPulpTests = "/api/MicrobialFeatherPulpTests/AllMicrobialFeatherPulpTests"
        case getAllMicrobialBirdTypes = "/api/MicrobialBirdType/AllMicrobialBirdTypes"
        case syncEnvironmentalData = "/api/MicrobialEnvironmentalDetails/AddMicrobialEnvironmentalDetails"
        case syncBacterialData = "/api/MicrobialBacterialDetails/AddMicrobialBacterialDetails"
        case syncFeathurePulp = "/api/MicrobialFeatherPulpDetails/AddMicrobialFeatherPulpDetails"
        case getSyncedReqData = "/api/MicrobialDetails/GetDetailsByApiCount"
        case getRequisionDataWithPlates = "/api/MicrobialDetails/GetMicrobialPostingDetailsByUser"

        case getAllCaseStatus = "/api/MicrobialCaseStatus/AllCaseStatus"
        case getAllMediaTypeValues = "/api/MicrobialMediaTypes/AllMicrobialMediaTypes"
        case getAllSamplingMethodList = "/api/MicrobialSamplingMethod/AllMicrobialSamplingMethod"
        
        
        //Microbial API's Finish

        
        //**********************Vaccine Migration API**********************
        
        case getUpcomingCertifications = "/api/VaccinationTraining/GetScheduleTrainingByFSRId/"
        
        case getQuestionsMasterData = "/api/VaccinationTraining/GetCertificateQuestion"
        
        case getVaccinationMasterDropdowndata = "/api/VaccinationTraining/GetlanguagesAndTshirtSizes"
        
        case getEmployessById = "/api/VaccinationTraining/GetEmployeeList"
        
        case getSiteByCustomerIds  = "/api/VaccinationTraining/GetCustomerListByCustomerlst?customerIds="
        
        case getCustomersByUserId = "/api/VaccinationTraining/GetAssingedCustomerListByUser?userId="
        
        case postvaccinationCertification = "/api/VaccinationTraining/SubmitTrainingDataSync"
        case postNewvaccinationCertification = "/api/VaccinationTraining/SubmitTrainingWithoutSchedule"
        case getSubmittedCertifications = "/api/VaccinationTraining/GetPostingCertificateByUserId?userId="
        
        case getFSMList = "/api/VaccinationTraining/GetFSMList?CountryId="
        
        case getStateList = "/api/Assessment/GetStates?CountryId="
        
        case getShippingAddressDetails = "/api/VaccinationTraining/GetTrackingFSSAddress?FSSId="
        
        
        //**********************Flock Health **********************
        
        case getNecropsyListForChicken = "/api/PostingSession/GetNecropsyListByUser?UserId="
        
        case getFlockFeedList = "/api/PostingSession/GetFeedListByUser?UserId="
        
        case getSubmitedPostingVaccinationData = "/api/PostingSession/GetVaccinationListByUser?UserId="
        
        case getSubmittedNotesForChicken = "/api/PostingSession/GetBirdNotesListByUser?UserId="
        
       case getNecropsyFarmListForChicken = "/api/PostingSession/GetFarmListByUser?UserId="
         
        case getNecropsySubmittedImagesforChicken = "/api/PostingSession/GetBirdImagesListByUser?UserId="
        
        case getTargetWeightForTurkey = "/api/PostingSession/GetTargetWeightProcessing"
        
        case getTurkeyCocciVaccine = "/api/PostingSession/GetCocciVaccine?Languageid="
        
        case getChickenAndTurkeyComplexByUserId = "/api/PostingSession/GetComplexByUserId?UserId="
        
        case getTurkeySalesRepresentative = "/api/PostingSession/GetSalesRepresentativeBySubProductList?UserId="
        
        case getRoutes = "/api/PostingSession/GetRoute"
        
        case getTurkeyHatcheryStrain = "/api/PostingSession/GetHatcheryStrain"
        
        case getTurkeyFieldStrain = "/api/PostingSession/GetFieldStrain"
        
        case getTurkeyDosage = "/api/PostingSession/GetDosage"
        
        case getTurkeyGeneratiobnType = "/api/PostingSession/GetGeneration"
        
        case getTurkeyDosageByMoulecule = "/api/PostingSession/GetDosageWithMoleculeId"
        
        case getCustomerOfChickenAndTurkey = "/api/PostingSession/GetCustomerByUser?UserId="
        
        case getCocciProgram = "/api/PostingSession/GetCocciProgram"
        
        case getSessionType = "/api/PostingSession/GetSessionType"
        
        case getBirdSizeTurkey = "/api/PostingSession/GetBirdSize"
        
        case termAndCondtion = "/api/User/PostTermsAccepted"
        
        case getBirdBreedChickenAndTurkey = "/api/PostingSession/GetBirdBreed"
        
        case GetFeedProgramCatagoryAndMoleculeDetails  = "/api/PostingSession/GetFeedProgramCatagoryAndMoleculeDetails"
        
        case GetChickenTurkeyVeterinarian  = "/api/PostingSession/GetVeterinarian?UserId="
        
        case getFarmListTurkey = "/api/Farm/GetFarmListByUserId"
        
        case getProductionType = "/api/PostingSession/GetProductionType"
        
        case getPostedSessionsByDeviceSessionID = "/api/PostingSession/GetPostingSessionListBySessionId?DeviceSessionId="
        
        case getPostedVaccinationListByDeviceSessionID = "/api/PostingSession/GetVaccinationListBySessionId?DeviceSessionId="
        
        case getFeedListByDeviceSessionID = "/api/PostingSession/GetFeedListBySessionId?DeviceSessionId="
        
        case getFarmListDataByDeviceSessionId = "/api/PostingSession/GetFarmListBySessionId?DeviceSessionId="
        
        
        case getBirdsNotesDataByDeviceSessionId = "/api/PostingSession/GetBirdNotesListBySessionId?DeviceSessionId="
        
        
        case getNecropsyDataByDeviceSessionId  = "/api/PostingSession/GetNecropsyListBySessionId?UserId="
        
        // ********************************************* CHICKEN **************************************************
     
        
        // ********************************************* Turkey **************************************************
        case getTurkeyPostedSession  = "/api/PostingSession/TurkeyGetPostingSessionListByUser?UserId="
      //  case getTurkeyPostedSession  = "/api/PostingSession/T_GetPostingSessionListByUser?UserId="
        
      //  case getTurkeyPostedSessionsVacccine = "/api/PostingSession/T_GetVaccinationListByUser?UserId="
        case getTurkeyPostedSessionsVacccine = "/api/PostingSession/TurkeyGetVaccinationListByUser?UserId="
        
//        case getTurkeyPostedNotes = "/api/PostingSession/T_GetBirdNotesListByUser?UserId="
        case getTurkeyPostedNotes = "/api/PostingSession/TurkeyGetBirdNotesListByUser?UserId="
        
       // case getTurkeyPostedImages = "/api/PostingSession/T_GetBirdImagesListByUser?UserId="
        case getTurkeyPostedImages = "/api/PostingSession/TurkeyGetBirdImagesListByUser?UserId="
        
       // case getTukeyPostedFarmList = "/api/PostingSession/T_GetFarmListByUser?UserId="
        case getTukeyPostedFarmList = "/api/PostingSession/TurkeyGetFarmListByUser?UserId="
        
        case getTutorial = "/api/PostingSession/GetTutorial"
        
        case postFeedProgramToServer = "/api/PostingSession/SaveMultipleFeedsSyncData"
        
        //
        //
       
        var latestUrl: String {
            return "\(Constants.baseUrl)\(self.rawValue)"
        }
        var VerUrl: String {
            return "\(Constants.Api.versionUrl)\(self.rawValue)"
        }
    }
}

/* Error Formats */

extension NSError {
    
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

extension ZoetisWebServices {
    
    /* Random number creator */
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    /*-----------------------------------------PE-------------------------------------------------*/
    /* Draft assessment deleted */
    
    func deleteDeletedDrafts( controller: UIViewController, parameters: JSONDictionary, url:String, completion: @escaping CompletionBlock) {
        deleteRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Dosage list PE */
    
    func getPEDosagesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPEDosages.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Customer list PE */
    
    func getAllCustomerListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllCustomerPE.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
        
    /* Get Chlorine strip List */
    func getClorineStripsForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getPEClorine.latestUrl + "RegionId=" + String(Regionid)  + languageIdStr
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* App version check */
    
    func getAppVersionCheck( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAppVersion.VerUrl + Bundle.main.versionNumber
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Master data version check */
    
    func getMasterDataVersionCheck( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getMasterDataVersion.VerUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Customer list by user PE */
    
    func getCustomerListForPE( controller : UIViewController, countryID: String, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let id = UserDefaults.standard.integer(forKey: "Id")
        let countryid = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getCustomerPE.latestUrl + String(id) + "&countryId=" + String(countryid)  + regionIdStr + String(Regionid)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Site list PE */
    
    func getSitesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let id = UserDefaults.standard.integer(forKey: "Id")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        
        let url = EndPoint.getSitesPE.latestUrl + String(id) + countryIdStr + String(countryId)  + regionIdStr + String(Regionid)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    /* Evaluator list PE */
    
    func getEvaluatorListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getEvaluator.latestUrl + String(countryId)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getApproversListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getApproversPE.latestUrl + String(countryId)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVisitTypesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getVisitTypes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEvaluatorTypesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let countryid = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let id = UserDefaults.standard.integer(forKey: "Id")
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        
        let url = EndPoint.getEvaluatorTypes.latestUrl + String(id) + countryIdStr + String(countryid) + regionIdStr + String(Regionid)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getManufacturerListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getManufacturer.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBirdBreedListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let countryid = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let id = UserDefaults.standard.integer(forKey: "Id")
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        
        let url = EndPoint.getBirdBreed.latestUrl  + String(id) + countryIdStr + String(countryid) + languageIdStr + regionIdStr + String(Regionid)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEggsListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getEggs.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVaccineManufacturerListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let id = UserDefaults.standard.integer(forKey: "Id")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getVaccineManufacturer.latestUrl + String(id) +  countryIdStr + String(countryId) + languageIdStr
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVaccineNamesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let id = UserDefaults.standard.integer(forKey: "Id")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getVaccineNames.latestUrl  + String(id)  +  countryIdStr + String(countryId) + languageIdStr
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVaccineSubNamesListForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let id = UserDefaults.standard.integer(forKey: "Id")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
     //   let url = EndPoint.getSubVaccineNames.latestUrl + String(id) + countryIdStr + String(countryId) + languageIdStr + "&Rollout=PEI"
        let url = EndPoint.getSubVaccineNames.latestUrl + String(id) + countryIdStr + String(countryId) + languageIdStr
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
        
    }
    
    
    func getDiluentManufacturerList( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getDiluentManufacturer.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBagSizes( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getbagSizes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAmplePerBag( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAmplePerBag.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAmpleSizes( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAmpleSizes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPERoles( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPERoles.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPEFrequency( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPEFrequency.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPEIncubationStyle( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getIncubationStyle.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPEDOASizes( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getPEDOASizes.latestUrl + "LanguageId=1" + regionIdStr + String(Regionid)
        getRequest( controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getDuplicacyCheck( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getDuplicacyCheck.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: parameters, headers: [:], completion: completion)
    }
    
    func getPEDOADiluentType( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPEDOADiluentType.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAssessmentCategoriesDetailsPE( controller: UIViewController,evalType: String,moduleID: String, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let countryid = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getModuleAssessmentCategoriesDetailsPE.latestUrl + "Module_Id=" + moduleID +  countryIdStr + String(countryid) + languageIdStr + regionIdStr + String(Regionid) + "&EvalType=" + String(evalType)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAssessmentQuesInfoPE( controller: UIViewController,evalType: String,moduleID: String, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getAssessmentQuesInfoPE.latestUrl  + "?RegionId=" + String(Regionid) + languageIdStr
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func checkAssessment( controller: UIViewController,assessmentId: String, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAssessmentStatus.latestUrl + assessmentId + "&StatusType=1"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getMixerList( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let custId = parameters["customerId"] as? String ?? ""
        let siteId = parameters["siteId"] as? String ?? ""
        let countryId = parameters["countryId"] as? String ?? ""
        
        let url = EndPoint.getVaccineMixerList.latestUrl + custId + "&SiteId=" + siteId + countryIdStr + countryId
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPostedAssmntListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
    // old     let url = EndPoint.getPostingAssessmentListByUserPE.latestUrl + String(Id) + "&DeviceType=ios"  + regionIdStr + String(Regionid)
        let url = EndPoint.getPostingAssessmentListByUserPE.latestUrl + String(Id)  + regionIdStr + String(Regionid)
        
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getCountryForPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPECountry.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
   
    
    func getGigyaCountryList( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getGigyaCountries.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getGigyaCountryLanguage(countryID: String, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getGigyaCountryLanguages.latestUrl + "countryid=\(countryID)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEncryptedUserName(emailIs: String, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getEncryptedEmail.latestUrl + "Text=\(emailIs)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    
    func getGigyaApiKeys(countryID: String, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getGigyaApiKeys.latestUrl + "countryid=\(countryID)" + "&TokenVersion=V2" + "&LoginType=App"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getRejectedAssessmentListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getPERejectedAssessment.latestUrl + String(Id)  + regionIdStr + String(Regionid)
        
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getRejectedAssessmentImagesListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let assId = parameters["assessmentId"] as? String ?? ""
        let url = EndPoint.getPERejectedAssessmentImages.latestUrl + assId
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    //getPostingAssessmentImagesListByUserPE
    func getPostingImagesListByUserPE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let url = EndPoint.getPostingAssessmentImagesListByUserPE.latestUrl + String(Id) + "&DeviceType=ios" //+ countryIdStr + String(countryId) + regionIdStr + String(Regionid)
        
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func GetPostingAssessmentImagesListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPostingAssessmentImagesListByUser.latestUrl
        print("GET SERVICE*** : getPostingAssessmentImagesListByUser ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPostingAssessmentListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let Regionid = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getPostingAssessmentListByUserPE.latestUrl + String(Id) + "&DeviceType=ios"  + "&RegionId=" + String(Regionid)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func sendPostDataToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        postRequest((endPoint: EndPoint.postAddAttachmentDetails.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func sendPostDataToServerVaccination(controller: UIViewController, parameters: JSONDictionary,url:String,  completion: @escaping CompletionBlock) {
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
 
    func sendAssessmentStatusTOWeb(controller: UIViewController, parameters: JSONDictionary,  completion: @escaping CompletionBlock) {
        
        let assesId = parameters["AssessmentID"] as? String ?? ""
        let saveType = parameters["SaveType"] as? Int ?? 1
        let userId = parameters["UserID"] as? Int ?? UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let AppVersion = parameters["appVersion"] as? String ?? ""
        
        let url = EndPoint.postUpdateStatus.latestUrl + assesId + "&saveType=" + String(saveType) + "&userId=" + String(userId) + "&appVersion=" + AppVersion
        postRequest((endPoint: url , controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    
    
    func postStatusUpdate(controller: UIViewController, parameters: JSONDictionary,url:String,  completion: @escaping CompletionBlock) {
        let assId = parameters["assessmentId"] as? String ?? ""
        let sType = parameters["saveType"] as? Int ?? 0
        let urls = EndPoint.postUpdateStatus.latestUrl + assId + "&userId=\(UserContext.sharedInstance.userDetailsObj?.userId ?? "")" + "&saveType=\(sType)" + "&appVersion=\(Bundle.main.versionNumber)"
        postRequest((endPoint: urls, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func sendFCMTokenDataToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        
        postRequest((endPoint: Constants.Api.fcmUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    
    func sendScoresDataToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        print("scccccccoooooooo",parameters)
        postRequest((endPoint: EndPoint.postAddScores.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func sendMultipleImagesBase64ToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        postRequest((endPoint: EndPoint.postImagesBase64.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    
    func sendAddDayOfAgeAndInvoject(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        postRequest((endPoint: EndPoint.postAddDayOfAgeAndInvoject.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func sendExtendedMicroToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
   //     print("Extended Micro ",parameters)
        postRequest((endPoint: EndPoint.postExtendedMicro.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func submitFinalStatusOfAssessmentToServer(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
   //     print("Extended Micro ",parameters)
        postRequest((endPoint: EndPoint.finalAssessmentStatus.latestUrl, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    
    
    
    
    
    /*---------------------------------------------------PVE--------------------------------------------*/
    
    func getVaccineNamesDetailsPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getVaccineNamesDetailsPVE.latestUrl
        print("GET SERVICE*** : getVaccineNamesDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVaccineManDetailsPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getVaccineManDetailsPVE.latestUrl
        print("GET SERVICE*** : getVaccineManDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getSiteInjctsDetailssPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getSiteInjctsDetailssPVE.latestUrl
        print("GET SERVICE*** : getSiteInjctsDetailssPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getSurveyTypeDetailsPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getSurveyTypeDetailsPVE.latestUrl
        print("GET SERVICE*** : getSurveyTypeDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getSerotypeDetailsPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getSerotypeDetailsPVE.latestUrl
        print("GET SERVICE*** : getSerotypeDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    func getAssessmentCategoriesDetailsPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getModuleAssessmentCategoriesDetailsPVE.latestUrl
        print("GET SERVICE*** : getAssessmentCategoriesDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getCustomerListForPVE( controller: UIViewController, countryID: String, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int
        let url = EndPoint.getCustomerListPVE.latestUrl + String(Id ?? 0) + "&countryId=\(countryID)"
        print("GET SERVICE*** : getCustomerListForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getComplexListForPVE( controller: UIViewController, countryID: String,  parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getComplexPVE.latestUrl + "countryId=\(countryID)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBreedOfBirldsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getBirdBreedsDetailsPVE.latestUrl
        print("GET SERVICE*** : getBirdBreedsDetailsPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEvaluationTypeForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getEvaluationTypePVE.latestUrl
        print("GET SERVICE*** : getEvaluationTypePVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEvaluationForForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getEvaluationForPVE.latestUrl
        print("GET SERVICE*** : getEvaluationForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getSiteIdNameForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getSiteIDNameDetailsPVE.latestUrl
        print("GET SERVICE*** : getSiteIdNameForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getblankPDFPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.postPDFPVE.latestUrl
        print("get SERVICE*** : postPDFPVE ", url)
        
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBlankAssessmentFiles( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        let url = EndPoint.getBlankAssessmentFiles.latestUrl + "?RegionId=\(regionId)"
     
        print("get Blank Assessments *** : PDF ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getDownloadBlankFile( controller: UIViewController, parameters: JSONDictionary, fileName: String, completion: @escaping CompletionBlock) {
        let url = EndPoint.getDownloadBlankFile.latestUrl + "fileName=\(fileName)" + "&userId=\(UserContext.sharedInstance.userDetailsObj?.userId ?? "")"
        print("get SERVICE*** : PDF DOWNLOAD LINK ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAgeOfBirdsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getBirdAgeDetailsPVE.latestUrl
        print("GET SERVICE*** : getAgeOfBirdsForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBreedOfBirdsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getBirdBreedsDetailsPVE.latestUrl
        print("GET SERVICE*** : getBreedOfBirdsForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getHousingDetailsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getHousingDetailsPVE.latestUrl
        print("GET SERVICE*** : getHousingDetailsForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAssignUserDetailForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getAssignUserDetailPVE.latestUrl + "?countryId=\(countryId)"
        print("GET SERVICE*** : getAssignUserDetailForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getEvaluatorDetailForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
   
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.getEvaluatorDetailPVE.latestUrl + "?countryId=\(countryId)"
        
        print("GET SERVICE*** : getEvaluatorDetailForPVE ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func GetPostingAssessmentListByUser( controller: UIViewController, header: [String: Any] ,parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPostingAssessmentListByUser.latestUrl + "?deviceType=ios"
        print("GET SERVICE*** : getPostingAssessmentListByUser ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: header, completion: completion)
    }
    
    func GetPostingAssessmentCompleteImagesListByUser( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getPostingAssessmentCompleteImagesListByUser.latestUrl
        print("GET SERVICE*** : getPostingAssessmentCompleteImagesListByUser ", url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    // PVE - Sync API ---- Start
    
    func postStartNewAssessmentDetailForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.postSNADetailsPVE.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
        
    }
    
    func postScoreDetailsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.postScoreDetailsPVE.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
        
    }
    
    func postSaveAssessmentImagesDetailsForPVE( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.postSaveAssessmentImagesDetailsPVE.latestUrl
        do{
            let jsonData = try JSONSerialization.data(withJSONObject:parameters, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            print("Images JSON Data" , jsonDataString)
        }
        catch
        {
            
        }
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
        
    }
    
    // PVE - Sync API ---- End
    
    //-----------------Microbial-----------------------
    func getAllLocationTypeValues( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllLocationValues.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllMediaTypeValues( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllMediaTypeValues.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    func getAllSamplingMethodValues( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllSamplingMethodList.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllEnvironmentalLocationTypes( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllEnvironmentalLocationTypes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllBacterialLocationTypes( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllBacterialLocationTypes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllMicrobialSpecimenTypes(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllMicrobialSpecimenTypes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllMicrobialBirdTypes(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllMicrobialBirdTypes.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllMicrobialFeatherPulpTest(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllMicrobialFeatherPulpTests.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllCaseStatus(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllCaseStatus.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllHatcheryAllVisitTypeForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcheryAllVisitTypeURLPathMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllCustomersForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let userId = UserDefaults.standard.value(forKey: "Id") as? Int
        let url = EndPoint.getAllCustomersMicrobial.latestUrl + "\(userId ?? 0)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllSyncedRequisitionData( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getSyncedReqData.latestUrl
        let currentUserId = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: ["UserId" : currentUserId], completion: completion)
    }
    func getAllRequisitionDataWithPlates( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getRequisionDataWithPlates.latestUrl
        let currentUserId = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: ["UserId" : currentUserId], completion: completion)
    }
    func syncEnvironmentalData(reqType: RequisitionType, controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        var url = ""
        if reqType == .enviromental{
            url = EndPoint.syncEnvironmentalData.latestUrl
        }else if reqType == .bacterial{
            url = EndPoint.syncBacterialData.latestUrl
        }else{
            url = EndPoint.syncFeathurePulp.latestUrl
        }
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func getAllHatcherySitesForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcherySiteMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getAllHatcheryReviewerForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcheryReviewerMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getAllHatcheryAllConductTypeForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcheryConductTypesMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getAllHatcheryAllSurveyPurposeForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcheryPurposeOfSurveyURLPathMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getAllHatcheryAllTransferTypeForMicrobial( controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock) {
        let url = EndPoint.getAllHatcheryAllTransferTypeURLPathMicrobial.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVaccinationServicesResponse(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
 
    // Flock Health API ---- Start
//    
    func getFlockHealthAPIResponce(type: DeviceIDRequestType, controller: UIViewController, url: String, parameters: [String: Any], headers: [String: String], completion: @escaping CompletionBlock) {
        print(url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }

    
    func getPostedSessionByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        
        getFlockHealthAPIResponce(type: DeviceIDRequestType.postedSession, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    
    }
    
    func getVaccineListByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.vaccineList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getFeedListByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.feedList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getFarmListByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.farmList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)

//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getNecropsyByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.NecropsyByDeviceID, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBirdsNotesDataByDeviceIDResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.birdsNotes, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPostedSessionResponceForChicken(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.chickenPostedSessions, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getFlockFeedSessionResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.FlockFeedSession, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPostedSessionVaccinationResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.PostedSessionVaccination, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
 
    func getNotesPostedSessionResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.NotesPostedSession, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getPostedNecropsyFarmListResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.PostedNecropsyFarmList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
        
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getNecropsyListResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.necropsyList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getNecropsyImagesListResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.necropsyImagesList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTukeyPostedFarmListResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        getFlockHealthAPIResponce(type: DeviceIDRequestType.tukeyPostedFarmList, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
//        print(url)
//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }

    func getTargetWeightResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTargetWeightForTurkey.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.targetWeight, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)

//        getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getCocciVaccineTurkeyResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyCocciVaccine.latestUrl + "\(0)" // sent 0 forcefully to get data for all language , change made in 7.6.6 release
        getFlockHealthAPIResponce(type: DeviceIDRequestType.cocciVaccineTurkey, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getChickenTurkeyComplexByUserIdResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        
        let Id = UserDefaults.standard.value(forKey: "Id") as! Int
        let url = EndPoint.getChickenAndTurkeyComplexByUserId.latestUrl + "\(Id)"
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func getSalesRepresentativeResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
       
        let Id = UserDefaults.standard.value(forKey: "Id") as! Int
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let FlockType = UserDefaults.standard.value(forKey: "chick") as! Int
        
        if FlockType == 4 {
            let url = EndPoint.getTurkeySalesRepresentative.latestUrl + "\(Id)" + "&SubProductID=1&CountryId=\(countryId)"
           // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
            
            getFlockHealthAPIResponce(type: DeviceIDRequestType.salesRepresentative, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
        } else {
            let url = EndPoint.getTurkeySalesRepresentative.latestUrl + "\(Id)" + "&SubProductID=2&CountryId=\(countryId)"
            
            getFlockHealthAPIResponce(type: DeviceIDRequestType.salesRepresentative, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
           // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
        }
    }
    
    
    func getRouteResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getRoutes.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getRoute, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
       // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTurkeyHatcheryStrainResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyHatcheryStrain.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getTurkeyHatcheryStrain, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
       // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getTurkeyFieldStrainResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyFieldStrain.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getTurkeyFieldStrain, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getDosageResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyDosage.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getDosage, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTurkeyGenerationResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyGeneratiobnType.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getTurkeyGeneration, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
       // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTurkeyDoseByMoleculeIdResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getTurkeyDosageByMoulecule.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getTurkeyDoseByMoleculeId, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getCocciProgramResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getCocciProgram.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getCocciProgram, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
       // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getSessionTypeResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getSessionType.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getSessionType, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getBirdSizeResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getBirdSizeTurkey.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func getTermConditionResponceResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.termAndCondtion.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    func getBirdBreedChickenAndTurkeyResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getBirdBreedChickenAndTurkey.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getBirdBreedChickenAndTurkey, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)

      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getFeedProgramCatagoryAndMoleculeDetailsResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.GetFeedProgramCatagoryAndMoleculeDetails.latestUrl
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getFeedProgramCatagoryAndMolecule, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVeterinarianResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let Id = UserDefaults.standard.value(forKey: "Id") as! Int
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.GetChickenTurkeyVeterinarian.latestUrl + "\(Id)" + "&SubProductID=1&CountryId=\(countryId)"
        getFlockHealthAPIResponce(type: DeviceIDRequestType.getVeterinarian, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getVeterinarianResponceTurkey(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let Id = UserDefaults.standard.value(forKey: "Id") as! Int
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        let url = EndPoint.GetChickenTurkeyVeterinarian.latestUrl + "\(Id)" + "&SubProductID=2&CountryId=\(countryId)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getCustomerListResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let Id =  UserDefaults.standard.value(forKey: "Id") as! Int
        let url = EndPoint.getCustomerOfChickenAndTurkey.latestUrl + "\(Id)"
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getFarmListTurkeyResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getFarmListTurkey.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }
    
    
    func getProductionTypeResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.getProductionType.latestUrl
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getTurkeyPostedSessionsListResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        print(url)
        getRequest(controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getTurkeyPostedSessionsVacccineResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        print(url)
        
        getFlockHealthAPIResponce(type: DeviceIDRequestType.TurkeyPostedSessionsVacccine, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
       // getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    
    func getTurkeyPostedNotesResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        print(url)
       
        getFlockHealthAPIResponce(type: DeviceIDRequestType.TurkeyPostedNotes, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTurkeyPostedImagesResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        print(url)
        getFlockHealthAPIResponce(type: DeviceIDRequestType.TurkeyPostedImages, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    func getTutorialResponce(controller: UIViewController, url: String, completion: @escaping CompletionBlock){
        print(url)
        getFlockHealthAPIResponce(type: DeviceIDRequestType.Tutorial, controller: controller, url: url, parameters: [:], headers: [:], completion: completion)
      //  getRequest(showHud: false, showHudText: "", controller: controller, endPoint: url, parameters: [:], headers: [:], completion: completion)
    }
    
    //    ***************************** Post Data to Server *************************************
  //

    func getFeedProgramResponceResponce(controller: UIViewController, parameters: JSONDictionary, completion: @escaping CompletionBlock){
        let url = EndPoint.postFeedProgramToServer.latestUrl
        postRequest((endPoint: url, controller: controller), parameters: parameters, headers: [:], completion: completion)
    }

    
    
    //Handlers
    
    func handleFailureBlock(error: NSError? = nil, json: JSON? = nil) {
        viewController.dismissGlobalHUD(viewController.view)
        if error?.code == -1009 {
            viewController.noInternetConnection()
        } else if error?.code == 405 {
            print("error in api 405")
        } else if error?.code == 400 ||  error?.code == 401 {
            print("error in api 6090")
            viewController.showAlertViewWithMessageAndActionHandler(message: "server response 400 || 401", actionHandler: nil)
        } else if error?.code == 402 {
            print("error in api 456")
            viewController.showAlertViewWithMessageAndActionHandler(message: "server response 402", actionHandler: nil)
        } else {
            if error?.localizedDescription == "cancelled" {
                print("error in api 22")
                return
            }
            viewController.showAlertViewWithMessageAndActionHandler(message: error?.localizedDescription ?? "Something went wrong.", actionHandler: nil)
        }
        dismissGlobalHUD(viewController.view)
    }
    
    func getRequest(shouldErrorRequired: Bool = false, pageNumber: Int = 1, controller: UIViewController, endPoint: String, parameters: JSONDictionary,  headers: [String: Any], completion: @escaping CompletionBlock) {
        viewController = controller
        ZoetisApiManager.GET(endPoint: endPoint, parameters: parameters, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            print("error in api 1",error, endPoint)
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func deleteRequest(shouldErrorRequired: Bool = false, pageNumber: Int = 1, controller: UIViewController, endPoint: String, parameters: JSONDictionary, headers: JSONDictionary, completion: @escaping CompletionBlock) {
        viewController = controller
        ZoetisApiManager.POST(endPoint: endPoint, parameters: parameters, success: { (json) in
            print("response is ",json, endPoint)
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            print("error in api 1",error)
            shouldErrorRequired ? completion(JSON([:]), error) : self.handleFailureBlock(error: error)
        }
    }
    
    func postRequest(shouldErrorRequired: Bool = false, _ dataVar:(String,UIViewController), parameters: JSONDictionary, imageData: Data = Data(), imageKey: String = "", headers: JSONDictionary, completion: @escaping CompletionBlock) {
        viewController = dataVar.1
        
        ZoetisApiManager.POST(endPoint: dataVar.0, parameters: parameters, imageData: imageData, imageKey: imageKey, success: { (json) in
            self.handlecompletionResponse(json, shouldErrorRequired: shouldErrorRequired, completion: completion)
        }) { (error) in
            print("error in api with End Point -- " , dataVar.0)
            
            // Directly call completion, no need for the ternary operator
            completion(JSON([:]), error)
        }
    }

    
    func handlecompletionResponse(_ json: JSON, shouldErrorRequired: Bool = false, completion: @escaping CompletionBlock) {
        
        let jsonDic = json["error"].stringValue
        
        if jsonDic.count > 0 {
            print("error in api 3")
            handleFailureBlock(json: json)
            
        } else {
            completion(json, nil)
        }
        
    }
    
    
}


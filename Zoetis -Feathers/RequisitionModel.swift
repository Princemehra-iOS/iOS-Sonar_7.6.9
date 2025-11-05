//
//  EnviromentalSessionInProgressModel.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 15/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData

enum SessionStatus: Int {
    case saveAsDraft = 1
    case submitted = 2
}

enum REQUISITION_SAVED_SESSION_TYPE: Int {
    case RESTORE_OLD_SESSION = 0
    case CREATE_NEW_SESSION = 1
    case SHOW_DRAFT_FOR_EDITING = 2
    case SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY = 3
}

enum RequisitionType: Int {
    case bacterial = 1
    case enviromental = 2
  //  case feathurePulp = 3
    
   static func getRequisitionTypeStringValue(type: Int) -> String{
        switch type {
        case 1:
            return "Bacterial"
        case 2:
            return "Environmental"
//        case 3:
//            return "Feather Pulp"
        default:
            return ""
        }
    }
    
    static func getRequisitionTypeIntValue(type: String) -> NSNumber {
        switch type {
        case "Bacterial":
            return 1
        case "Environmental":
            return 2
//        case "Feather Pulp":
//            return 3
        default:
            return 0
        }
    }
}

enum CASE_STATUS: Int {
    case INITIAL = 0
    case IN_PROGRESS = 1
    case SENT_FOR_REVIEW = 2
    case RECEIVED_FOR_REVIEW = 3
    case COMPLETED = 4
    case REOPENED = 5
    case RELEASED = 6
    
    static func getCaseStatusInStringValue(type: Int) -> String{
        switch type {
        case self.INITIAL.rawValue:
            return "INITIAL"
        case self.IN_PROGRESS.rawValue:
            return "IN PROGRESS"
        case self.SENT_FOR_REVIEW.rawValue:
            return "SENT FOR REVIEW"
        case self.RECEIVED_FOR_REVIEW.rawValue:
            return "RECEIVED FOR REVIEW"
        case self.COMPLETED.rawValue:
            return "COMPLETED"
        case self.REOPENED.rawValue:
            return "REOPENED"
        case self.RELEASED.rawValue:
            return "RELEASED"
        default:
            return ""
        }
    }
    
    static func getCaseStatusTypeIntValue(type: String) -> Int {
        switch type {
        case self.getCaseStatusInStringValue(type: self.INITIAL.rawValue):
            return self.INITIAL.rawValue
        case self.getCaseStatusInStringValue(type: self.IN_PROGRESS.rawValue):
            return self.IN_PROGRESS.rawValue
        case self.getCaseStatusInStringValue(type: self.SENT_FOR_REVIEW.rawValue):
            return self.SENT_FOR_REVIEW.rawValue
        case self.getCaseStatusInStringValue(type: self.RECEIVED_FOR_REVIEW.rawValue):
            return self.RECEIVED_FOR_REVIEW.rawValue
        case self.getCaseStatusInStringValue(type: self.COMPLETED.rawValue):
            return self.COMPLETED.rawValue
        case self.getCaseStatusInStringValue(type: self.REOPENED.rawValue):
            return self.REOPENED.rawValue
        case self.getCaseStatusInStringValue(type: self.RELEASED.rawValue):
            return self.RELEASED.rawValue
        default:
            return 0
        }
    }
}
//public enum CaseStatus
//{
//    Initial = 1,
//
//    [Display(Name = "In Progress")]
//    InProgress = 2,
//
//    [Display(Name = "Sent For Review")]
//    SentForReview = 3,
//
//    [Display(Name = "Received For Review")]
//    ReceivedForReview = 4,
//
//    [Display(Name = "Completed")]
//    Completed = 5,
//
//    [Display(Name = "Re Opened")]
//    Reopened = 6,
//
//    [Display(Name = "Released")]
//    Released = 7,
//}

class RequisitionModel {
    
    var requestor = ""
    var reasonForVisit = ""
    var reasonForVisitId = Int()
    var reviewerId = Int()
    var surveyConductedOnId = Int()
    var purposeOfSurveyId = Int()
    var sampleCollectedBy = ""
    var company = ""
    var companyId = Int()
    var site = ""
    var siteIdForBarcode = Int()
    var siteId = Int()
    var email = ""
    var reviewer = ""
    var surveyConductedOn = ""
    var sampleCollectionDate: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.MMddyyyyStr
        let dateString = formatter.string(from: Date())
        return dateString
    }()
    var sampleCollectionDateWithTimeStamp = ""
    var timeStamp = ""
    var purposeOfSurvey = ""
    var transferIn = ""
    var barCode = ""
    var barCodeManualEntered = ""
    var notes = ""
    var typeOfBird = ""
    var typeOfBirdId = Int()
    var environmentalLocationTypeArray = [Microbial_EnvironmentalLocationTypes]()
    var bacterialLocationTypeArray = [Microbial_BacterialLocationTypes]()
    var microbiaLocationTypeValuesArray = [Microbial_LocationValues]()
    
    var possibleHeaders = [LocationTypeHeaderModel]()
    var actualCreatedHeaders = [LocationTypeHeaderModel]()
    
    var requisitionType = RequisitionType.bacterial
    var sessionStatus = SessionStatus.saveAsDraft
    var isPlateIdGenerated = false
    
    var currentdate: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.MMddyyyyStr
        let dateString = formatter.string(from: Date())
        return dateString
    }()
    
    var selectedLocationTypes = [Int]()
    
    init() {
        requestor = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        sampleCollectedBy = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        
        
        if let surveyConductedOnArr = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllConductType") as? [Micro_AllConductType] {
            if surveyConductedOnArr.count > 0, surveyConductedOn == "" {
                surveyConductedOn = surveyConductedOnArr[0].text ?? ""
            }
            surveyConductedOnId = self.getSurveyConductedOnId()
        }
        
        if let purposeOfSurveyArr = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllSurveyPurpose") as? [Micro_AllSurveyPurpose] {
            if purposeOfSurveyArr.count > 0, purposeOfSurvey == "" {
                purposeOfSurvey = purposeOfSurveyArr[0].text ?? ""
            }
            purposeOfSurveyId = self.getPurposeOfSurveyId()
        }
        
        self.setDefaultReasonForVisit()
        let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpBirdType")
        let customerNamesArray  = customerDetailsArray.value(forKey: "birdText") as? [String] ?? []
        if customerNamesArray.count > 0{
            self.typeOfBird = customerNamesArray[0]
        }
        self.typeOfBirdId = self.getBirdTypeId()
    }
    
    
    
    
    func setDefaultReasonForVisit() {
        let reasonForVisitObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes")
        let reasonsForVisits = reasonForVisitObjectArray.value(forKey: "text")  as? [String] ?? []
        
        for item in reasonsForVisits {
            if item == "Routine" {
                self.reasonForVisit = item
                self.reasonForVisitId = self.getReasonForVisitId()
            }
        }
    }
    
    func generateHeader() {
        if self.actualCreatedHeaders.count == 0{
            let locationHeader = LocationTypeHeaderModel()
            locationHeader.section = 1
            self.actualCreatedHeaders.append(locationHeader)
        }
    }
    
    
    //MARK: - Reset Data into model for session in progress
    fileprivate func manageHeaders(_ headers: NSArray) {
        for item in headers {
            if let headerObject = item as? Microbial_LocationTypeHeaders {
                let header = LocationTypeHeaderModel(headerObject: headerObject)
                if header.numberOfPlateIDCreated.count > 0, let locationTypeId = header.selectedLocationTypeId {
                    selectedLocationTypes.append(locationTypeId)
                }
                self.actualCreatedHeaders.append(header)
            }
        }
    }
    
    func configureDataIfSessionInProgress() {
        let enviromentalSessionInProgress = CoreDataHandlerMicro().fetchAllData("Microbial_EnviromentalSessionInProgress")
        if enviromentalSessionInProgress.count > 0,
           let sessionData = enviromentalSessionInProgress.object(at: 0) as? Microbial_EnviromentalSessionInProgress {
            self.setSessionInProgressData(sessionData)
        }

        let headers = CoreDataHandlerMicro().fetchAllData("Microbial_LocationTypeHeaders")
        if headers.count > 0 {
            self.actualCreatedHeaders = []
            self.selectedLocationTypes = []
            manageHeaders(headers)
        }
    }

    
    
    
    //MARK: - Set data saved in draft
    fileprivate func handleHeadersValidations(_ headers: [Microbial_LocationTypeHeadersSubmitted]) {
        for item in headers {
            if let headerObject = item as? Microbial_LocationTypeHeadersSubmitted,
               let locationTypeId = LocationTypeHeaderModel(headerObject: headerObject).selectedLocationTypeId,
               LocationTypeHeaderModel(headerObject: headerObject).numberOfPlateIDCreated.count > 0 {
                
                let header = LocationTypeHeaderModel(headerObject: headerObject)
                selectedLocationTypes.append(locationTypeId)
                self.actualCreatedHeaders.append(header)
            }
        }
    }

    
    func configureDataFromDrafts(draftData: Microbial_EnviromentalSurveyFormSubmitted) {
        self.setDataOfDraftOrSubmittedRequisition(draftData)
        
        let dataSaved = CoreDataHandlerMicro().fetchAllData("Microbial_LocationTypeHeadersSubmitted") as? [Microbial_LocationTypeHeadersSubmitted]
        if let headers = dataSaved?.filter({ $0.timeStamp == draftData.timeStamp })  {
            print(headers)
            if headers.count > 0 {
                self.actualCreatedHeaders = []
                self.selectedLocationTypes = []
                handleHeadersValidations(headers)
            }
        }
    }

    func configureDataIfSessionInProgress_FeatherPulp() {
        let enviromentalSessionInProgress = CoreDataHandlerMicro().fetchAllData("Microbial_EnviromentalSessionInProgress")
        
        if enviromentalSessionInProgress.count > 0,
           let sessionData = enviromentalSessionInProgress.object(at: 0) as? Microbial_EnviromentalSessionInProgress {
            self.setSessionInProgressData(sessionData)
        }
    }

    
    
    //MARK: - Reset Site And BarCode If Selected Company changed
    func resetSiteAndBarCode() {
        self.site = ""
        self.siteId = 0
        self.barCode = ""
        self.barCodeManualEntered = ""
        self.generatebarCode()
    }
    
    func getReviewerId() -> Int {
        guard let reviewer = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer") as? [Micro_Reviewer]  else {
            return 0
        }
        let reviewerData = reviewer.filter {$0.reviewerName == self.reviewer}
        return reviewerData.count > 0 ? (reviewerData[0].reviewerId?.intValue ?? 0) : 0
    }
    
    func  getReviewerFromItsId(reviewerId: Int) -> String {
        guard let reviewer = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer") as? [Micro_Reviewer]  else {
            return ""
        }
        let reviewerData = reviewer.filter {$0.reviewerId?.intValue == reviewerId}
        return reviewerData.count > 0 ? (reviewerData[0].reviewerName ?? "") : ""
    }
    
    func getPurposeOfSurveyFromItsId(purposeOfSurveyId: Int) -> String {
        guard let purposeOfSurvey = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllSurveyPurpose") as? [Micro_AllSurveyPurpose]  else {
            return ""
        }
        let purposeOfSurveyData = purposeOfSurvey.filter {$0.id?.intValue == purposeOfSurveyId}
        return purposeOfSurveyData.count > 0 ? (purposeOfSurveyData[0].text ?? "") : ""
    }
    
    func getPurposeOfSurveyId() -> Int {
        guard let purposeOfSurvey = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllSurveyPurpose") as? [Micro_AllSurveyPurpose]  else {
            return 0
        }
        let purposeOfSurveyData = purposeOfSurvey.filter {$0.text == self.purposeOfSurvey}
        return purposeOfSurveyData.count > 0 ? (purposeOfSurveyData[0].id?.intValue ?? 0) : 0
    }
    
    func getSurveyConductedOnId() -> Int {
        guard let surveyConductedOn = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllConductType") as? [Micro_AllConductType]  else {
            return 0
        }
        let surveyConductedOnData = surveyConductedOn.filter {$0.text == self.surveyConductedOn}
        return surveyConductedOnData.count > 0 ? (surveyConductedOnData[0].id?.intValue ?? 0) : 0
    }
    
    func getSurveyConductedOnFromItsId(surveyConductedOnId: Int) -> String {
        guard let surveyConductedOn = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllConductType") as? [Micro_AllConductType]  else {
            return ""
        }
        let surveyConductedOnData = surveyConductedOn.filter {$0.id?.intValue == surveyConductedOnId}
        return surveyConductedOnData.count > 0 ? (surveyConductedOnData[0].text ?? "") : ""
    }
    
    func getReasonForVisitId() -> Int {
        guard let reasonForVisit = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes") as? [Micro_AllMicrobialVisitTypes]  else {
            return 0
        }
        let reasonForVisitData = reasonForVisit.filter {$0.text == self.reasonForVisit}
        return reasonForVisitData.count > 0 ? (reasonForVisitData[0].id?.intValue ?? 0) : 0
    }
    
    func getReasonForVisitFromItsId(reasonForVisitId: Int) -> String {
        guard let reasonForVisit = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes") as? [Micro_AllMicrobialVisitTypes]  else {
            return ""
        }
        let reasonForVisitData = reasonForVisit.filter {$0.id?.intValue == reasonForVisitId}
        return reasonForVisitData.count > 0 ? (reasonForVisitData[0].text ?? "") : ""
    }

    
    func getCompanyIdforSelectedCompany() -> Int {
        guard let currentSelectedCompany = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer", companyName: self.company) as? [Micro_Customer]  else {
            return 0
        }
        
        return currentSelectedCompany.count > 0 ? (currentSelectedCompany[0].customerId?.intValue ?? 0) : 0
    }
    
    func getCompanyfromId(id: Int) -> String {
        guard let currentSelectedCompany = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer") as? [Micro_Customer]  else {
            return ""
        }
        let currentSelectedCompanyData = currentSelectedCompany.filter {$0.customerId?.intValue == id}
        return currentSelectedCompanyData.count > 0 ? (currentSelectedCompanyData[0].customerName ?? "") : ""
    }
    
    func getSiteIdforSelectedSite(id: Int) -> String {
        guard let sites = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_siteByCustomer") as? [Micro_siteByCustomer]  else {
            return ""
        }
        let newSites = sites.filter {$0.id?.intValue == id}
        return newSites.count > 0 ? newSites[0].siteName ?? "" : ""
    }
    
    func getSiteIdforSelectedSite() -> Int {
        guard let sites = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_siteByCustomer") as? [Micro_siteByCustomer]  else {
            return 0
        }
        let newSites = sites.filter {$0.siteName == self.site}
        self.siteIdForBarcode = newSites.count > 0 ? Int(truncating: newSites[0].siteId ?? 0) : 0
        return newSites.count > 0 ? Int(truncating: newSites[0].id ?? 0) : 0
    }
    
    func getLocationValues(selectedValue: String) -> Int {
        guard let locationValues = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_LocationValues") as? [Microbial_LocationValues]  else {
            return 0
        }
        let newLocationValues = locationValues.filter {$0.text == selectedValue}
        return newLocationValues.count > 0 ? Int(truncating: newLocationValues[0].id ?? 0) : 0
    }
    
    func getMediaTypeValues(selectedValue: String) -> Int {
        guard let locationValues = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_AllMediaTypes") as? [Microbial_AllMediaTypes]  else {
            return 0
        }
        let newLocationValues = locationValues.filter {$0.text == selectedValue}
        return newLocationValues.count > 0 ? Int(truncating: newLocationValues[0].id ?? 0) : 0
    }
    
    
    func getSamplingMethodTypeValues(selectedValue: String) -> Int {
        
        if selectedValue == "Swab" {
            return 1
        }
        else if selectedValue ==  "Fluid"
        {
            return 2
        }
        else if selectedValue ==  "Sampling Plate"
        {
            return 3
        }
        else if selectedValue ==  "Other"
        {
            return 4
        }
        else if selectedValue ==  "Airplate"
        {
            return 5
        }
        else
        {
         return 0
        }
       
        

    }
    
    func getLocationValuesFromIds(id: Int) -> String {
        guard let locationValues = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_LocationValues") as? [Microbial_LocationValues]  else {
            return ""
        }
        let newLocationValues = locationValues.filter {$0.id?.intValue == id}
        return newLocationValues.count > 0 ? newLocationValues[0].text ?? "" : ""
    }
    
    func getBirdTypeId() -> Int {
        guard let birds = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpBirdType") as? [MicrobialFeatherPulpBirdType]  else {
            return 0
        }
        let newBirds = birds.filter {$0.birdText == self.typeOfBird}
        return newBirds.count > 0 ? Int(truncating: newBirds[0].id ?? 0) : 0
    }
    
    func getSpecimenTypeId(specimen: String) -> Int {
        guard let specimenArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpSpecimenType") as? [MicrobialFeatherPulpSpecimenType]  else {
            return 0
        }
        let temp = specimenArray.filter {$0.specimenText == specimen}
        return temp.count > 0 ? Int(truncating: temp[0].id ?? 0) : 0
    }
    
    
    func getLocationType(id: Int, reqType: Int) -> String{
        if reqType == RequisitionType.enviromental.rawValue{
            guard let values = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_EnvironmentalLocationTypes") as? [Microbial_EnvironmentalLocationTypes]  else {
                return ""
            }
            let newValues = values.filter {$0.id?.intValue == id}
            return newValues.count > 0 ? newValues[0].text ?? "" : ""
        }else if reqType == RequisitionType.bacterial.rawValue{
            guard let values = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_BacterialLocationTypes") as? [Microbial_BacterialLocationTypes]  else {
                return ""
            }
            let newValues = values.filter {$0.id?.intValue == id}
            return newValues.count > 0 ? newValues[0].text ?? "" : ""
        }
        return ""
    }
    
    func generateLocationType() {
        self.environmentalLocationTypeArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_EnvironmentalLocationTypes") as? [Microbial_EnvironmentalLocationTypes] ?? []
        self.bacterialLocationTypeArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_BacterialLocationTypes") as? [Microbial_BacterialLocationTypes] ?? []
        self.microbiaLocationTypeValuesArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Microbial_LocationValues") as? [Microbial_LocationValues] ?? []
    }
    
    fileprivate func handleEnvLocationTypeArr(_ locationTypes: inout [String], _ locationTypeIds: inout [Int]) {
        for object in environmentalLocationTypeArray {
            if let text = object.text {
                locationTypes.append(text)
            }
            if let locationTypeId = object.id {
                locationTypeIds.append(Int(truncating: locationTypeId))
            }
        }
    }
    
    fileprivate func handleBacterialLocationTypeArray(_ locationTypes: inout [String], _ locationTypeIds: inout [Int]) {
        for object in bacterialLocationTypeArray {
            if let text = object.text {
                locationTypes.append(text)
            }
            if let locationTypeId = object.id {
                locationTypeIds.append(Int(truncating: locationTypeId))
            }
        }
    }
    
    func getAllLocationTypes() -> (locationTypes: [String], locationTypeIds: [Int]) {
        var locationTypes = [String]()
        var locationTypeIds = [Int]()
        if requisitionType == .enviromental{
            handleEnvLocationTypeArr(&locationTypes, &locationTypeIds)
        } else{
            handleBacterialLocationTypeArray(&locationTypes, &locationTypeIds)
        }
        return (locationTypes, locationTypeIds)
    }
    
    func getAllLocationValuesFor(locationTypeId: Int) -> (locationValues: [String], locationValueIds: [Int]) {
        let locationTypeValuesArray = CoreDataHandlerMicro().fetchLocationValueFor(locationId: locationTypeId) as? [Microbial_LocationValues]  ?? []
        var locationValues = [String]()
        var locationValueIds = [Int]()
     
        for object in locationTypeValuesArray {
            if let text = object.text {
                locationValues.append(text)
            }
            if let locationTypeId = object.id {
                locationValueIds.append(Int(truncating: locationTypeId))
            }
        }
        return (locationValues, locationValueIds)
    }
    
    func getMediaTypes() -> [String] {
        var mediaTypeArray = [String]()

        if  let mediaTypeValues = CoreDataHandlerMicro().fetchAllData1("Microbial_AllMediaTypes") as? [NSManagedObject] {

        if mediaTypeValues.count > 0 {
            for mediaObj in mediaTypeValues {
                var new = mediaObj.value(forKey: "text") as! String
                mediaTypeArray.append(new)
            }
        }
        return mediaTypeArray
        }
        else {
            return mediaTypeArray
        }
    }
    
    func getSamplingTypes() -> [String] {
        var samplingMethodTypeArray = [String]()

        if  let samplingMethodTypeValues = CoreDataHandlerMicro().fetchAllData1("Microbial_SamplingMethodTypes") as? [NSManagedObject] {

        if samplingMethodTypeValues.count > 0 {
            for samplingObj in samplingMethodTypeValues {
                var new = samplingObj.value(forKey: "text") as! String
                samplingMethodTypeArray.append(new)
            }
        }
        //let newLocationValues = locationValues.filter {$0.id?.intValue == id}
        return samplingMethodTypeArray
        }
        else {
            return samplingMethodTypeArray
        }
    }
    
    func getAllLocationValuesWhichAreTrueForStd20(locationTypeId: Int) -> [Microbial_LocationValues] {
        let locationTypeValuesArray = CoreDataHandlerMicro().fetchLocationValueFor(locationId: locationTypeId) as? [Microbial_LocationValues]  ?? []
        return locationTypeValuesArray.filter{ $0.std20 as! Bool }
    }
    
    func getAllLocationValuesWhichAreTrueForStd(locationTypeId: Int) -> [Microbial_LocationValues] {
        let locationTypeValuesArray = CoreDataHandlerMicro().fetchLocationValueFor(locationId: locationTypeId) as? [Microbial_LocationValues]  ?? []
        return locationTypeValuesArray.filter{ $0.standard as! Bool }
    }
    
    func getAllLocationValuesWhichAreTrueForStd40(locationTypeId: Int) -> [Microbial_LocationValues] {
        let locationTypeValuesArray = CoreDataHandlerMicro().fetchLocationValueFor(locationId: locationTypeId) as? [Microbial_LocationValues]  ?? []
        return locationTypeValuesArray.filter{ $0.std40 as! Bool }
    }
    
    
    //MARK:- Generate Barcode Using "B-", Date and Selected Site
    fileprivate func populateNewArray(_ initialsZ: [String], _ newArray: inout [String]) {
        for item in initialsZ {
            if item != "" {
                newArray.append(item)
            }
        }
    }
    
    func generatebarCode() {
        
        if self.site.isEmpty {
            switch self.requisitionType {
            case .bacterial:
                self.barCode = "B-"
            case .enviromental:
                self.barCode = "E-"
            }
            return
        }
        
        let nameString = String(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "") + " " + String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "") + "\(String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "").count > 0 ? " " : "")" + String(UserDefaults.standard.value(forKey: "LastName") as? String ?? "")
        var initials = ""
        let initialsZ = nameString.components(separatedBy: " ")
        if initialsZ.count > 0 {
            
            var newArray : [String] = []
            newArray.removeAll()
            
            populateNewArray(initialsZ, &newArray)
         
            if let seconed = newArray[1] as? String{
                
                let arrayofstring  = seconed.map { String($0) }
                if arrayofstring.count > 0 {
                    var firstChar = arrayofstring[0]
                    initials = firstChar
                }
            }
        }

        switch self.requisitionType {
        case .bacterial:
            self.barCode = initials + "-" + "\(String(describing: sampleCollectionDate.replacingOccurrences(of: "/", with: "")))" + "-" + String(self.siteIdForBarcode) + "-B"
        case .enviromental:
            self.barCode = initials + "-" + "\(String(describing: sampleCollectionDate.replacingOccurrences(of: "/", with: "")))" + "-" + String(self.siteIdForBarcode) + "-E"
        }
    }
    
    //MARK: - Set data into model from Requisitions Session In progress
    func setSessionInProgressData(_ managedObject: Microbial_EnviromentalSessionInProgress) {
        self.requestor =  managedObject.requestor ?? ""
        self.sampleCollectedBy = managedObject.sampleCollectedBy ?? ""
        self.company = managedObject.company ?? ""
        self.companyId = Int(truncating: managedObject.companyId ?? 0)
        self.site = managedObject.site ?? ""
        self.siteId = Int(truncating: managedObject.siteId ?? 0)
        self.typeOfBird = managedObject.typeOfBird ?? ""
        self.typeOfBirdId = Int(managedObject.typeOfBirdId ?? 0)
        self.email = managedObject.email ?? ""
        self.reasonForVisit = managedObject.reasonForVisit ?? ""
        self.notes = managedObject.notes ?? ""
        self.reviewer = managedObject.reviewer ?? ""
        self.surveyConductedOn = managedObject.surveyConductedOn ?? ""
        self.sampleCollectionDate = managedObject.sampleCollectionDate ?? ""
        self.sampleCollectionDateWithTimeStamp = managedObject.sampleCollectionDateWithTimeStamp ?? ""
        self.purposeOfSurvey = managedObject.purposeOfSurvey ?? ""
        self.transferIn = managedObject.transferIn ?? ""
        self.isPlateIdGenerated = (managedObject.isPlateIdGenerated == 1) ? true : false
        self.timeStamp = managedObject.sampleCollectionDateWithTimeStamp ?? ""
        if let barCode = managedObject.barcode {
            self.barCode = barCode
        }
        
        if let barCodeManualEntered = managedObject.barcodeManualEntered {
            self.barCodeManualEntered = barCodeManualEntered
        }
        
        if let requisitionTypeValue = managedObject.requisitionType,
           let requisitionType = RequisitionType(rawValue: Int(truncating: requisitionTypeValue)) {
            self.requisitionType = requisitionType
        }

        
    }
    
    //MARK: - Set data into model from Draft Or Saved Rquisition
    func setDataOfDraftOrSubmittedRequisition(_ managedObject: Microbial_EnviromentalSurveyFormSubmitted) {
        self.requestor =  managedObject.requestor ?? ""
        self.sampleCollectedBy = managedObject.sampleCollectedBy ?? ""
        self.company = managedObject.company ?? ""
        self.companyId = Int(truncating: managedObject.companyId ?? 0)
        self.site = managedObject.site ?? ""
        self.siteId = Int(truncating: managedObject.siteId ?? 0)
        self.typeOfBird = managedObject.typeOfBird ?? ""
        self.typeOfBirdId = Int(truncating: managedObject.typeOfBirdId ?? 0)
        self.email = managedObject.email ?? ""
        self.reasonForVisit = managedObject.reasonForVisit ?? ""
        self.notes = managedObject.notes ?? ""
        self.reviewer = managedObject.reviewer ?? ""
        self.surveyConductedOn = managedObject.surveyConductedOn ?? ""
        self.sampleCollectionDate = managedObject.sampleCollectionDate ?? ""
        self.sampleCollectionDateWithTimeStamp = managedObject.sampleCollectionDateWithTimeStamp ?? ""
        self.purposeOfSurvey = managedObject.purposeOfSurvey ?? ""
        self.transferIn = managedObject.transferIn ?? ""
        self.isPlateIdGenerated = (managedObject.isPlateIdGenerated == 1) ? true : false
        self.surveyConductedOnId = self.getSurveyConductedOnId()
        self.purposeOfSurveyId = self.getPurposeOfSurveyId()
        self.timeStamp = managedObject.timeStamp ?? ""
        if let barCode = managedObject.barcode {
            self.barCode = barCode
        }
        
        if let barCodeManualEntered = managedObject.barcodeManualEntered {
            self.barCodeManualEntered = barCodeManualEntered
        }
        
        if let requisitionTypeValue = managedObject.requisitionType,
           let requisitionType = RequisitionType(rawValue: Int(truncating: requisitionTypeValue)) {
            self.requisitionType = requisitionType
        }

        print(getSiteIdforSelectedSite())
    }
    
    
    //MARK: - Set data into model from Submitted/ Draft requisitions
    func setRequisitionData(_ managedObject: Microbial_EnviromentalSurveyFormSubmitted) {
        self.requestor =  managedObject.requestor ?? ""
        self.sampleCollectedBy = managedObject.sampleCollectedBy ?? ""
        self.company = managedObject.company ?? ""
        self.companyId = Int(truncating: managedObject.companyId ?? 0)
        self.site = managedObject.site ?? ""
        self.siteId = Int(truncating: managedObject.siteId ?? 0)
        self.typeOfBird = managedObject.typeOfBird ?? ""
        self.typeOfBirdId = Int(managedObject.typeOfBirdId ?? 0)
        self.email = managedObject.email ?? ""
        self.reasonForVisit = managedObject.reasonForVisit ?? ""
        self.notes = managedObject.notes ?? ""
        self.reviewer = managedObject.reviewer ?? ""
        self.surveyConductedOn = managedObject.surveyConductedOn ?? ""
        self.sampleCollectionDate = managedObject.sampleCollectionDate ?? ""
        self.sampleCollectionDateWithTimeStamp = managedObject.sampleCollectionDateWithTimeStamp ?? ""
        self.purposeOfSurvey = managedObject.purposeOfSurvey ?? ""
        self.transferIn = managedObject.transferIn ?? ""
        self.isPlateIdGenerated = (managedObject.isPlateIdGenerated == 1) ? true : false
        
        if let barCode = managedObject.barcode {
            self.barCode = barCode
        }
        
        if let barCodeManualEntered = managedObject.barcodeManualEntered {
            self.barCodeManualEntered = barCodeManualEntered
        }
        
        if let requisitionTypeValue = managedObject.requisitionType,
           let requisitionType = RequisitionType(rawValue: Int(truncating: requisitionTypeValue)) {
            self.requisitionType = requisitionType
        }

       
        self.timeStamp = managedObject.timeStamp ?? ""
    }
    
    
    
    //MARK: - Validatation for Is requisition is already created for same date and same site
    func isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: SessionStatus) -> Bool {
        return Microbial_EnviromentalSurveyFormSubmitted.doReqOfSameSiteAndSameDateExists(siteId: self.siteId, sampleCollectionDate: self.sampleCollectionDate, reqType: self.requisitionType.rawValue, sessionStatus: sessionStatus)
    }
    
    
    
    func updateNewBarcodeEditted(){
        Microbial_LocationTypeHeaderPlatesSubmitted.updateBarcode(barCode: self.barCode, timeStamp: self.timeStamp)
        Microbial_LocationTypeHeadersSubmitted.updateBarcode(barCode: self.barCode, timeStamp: self.timeStamp)
    }
    
    
    //MARK:- Save Enviromental data into DB for current Session
    func saveCaseInfoCurrentSessionDataInToDB() {
        CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
        
        let saveEnvSessionInfo = CoreDataHandlerMicrodataModels.EnvironmentalSessionInfo(
            requestor: self.requestor,
            sampleCollectedBy: self.sampleCollectedBy,
            company: self.company,
            companyId: self.companyId,
            site: self.site,
            siteId: self.siteId,
            email:  self.email,
            reviewer: self.reviewer,
            surveyConductedOn: self.surveyConductedOn,
            sampleCollectionDate: self.sampleCollectionDate,
            sampleCollectionDateWithTimeStamp: self.sampleCollectionDateWithTimeStamp,
            purposeOfSurvey: self.purposeOfSurvey,
            transferIn:  self.transferIn,
            barCode: self.barCode,
            barCodeManualEntered:  self.barCodeManualEntered,
            notes: self.notes,
            reasonForVisit: self.reasonForVisit,
            requisitionId: self.barCode,
            requisitionType: self.requisitionType.rawValue,
            isPlateIdGenerated: self.isPlateIdGenerated,
            typeOfBird: "",
            typeOfBirdId: 0
        )
       
        CoreDataHandlerMicro().saveEnviromentalSessionInProgress(info: saveEnvSessionInfo)
    }
    
    func saveLocationTypeHeaderCurrentSessionInfoInDB() {
        CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaders")
        for (index, header) in actualCreatedHeaders.enumerated() {
            if let locationTypeId = header.selectedLocationTypeId {
                
               print("your total no. of plates : \(header.noOfPlates)")
                
                CoreDataHandlerMicro().saveEnviromentalLocationTypeHeaderInfo(locationType: header.selectedLocationType, locationTypeId: locationTypeId, noOfPlates: header.noOfPlates, section: index + 1, requisition_Id: self.barCode, requisitionType: self.requisitionType.rawValue)
            }
        }
    }
    
    func saveLocationTypePlatesCurrentSessionInfoInToDB() {
     //   CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaderPlates")
        self.selectedLocationTypes = []
        var totalHeaderPlates = [LocationTypeCellModel]()
        
        for (index, header) in self.actualCreatedHeaders.enumerated() {
            if header.noOfPlates > 0 {
                if let locationTypeId = header.selectedLocationTypeId {
                    self.selectedLocationTypes.append(locationTypeId)
                }
                for plate in header.numberOfPlateIDCreated {
                    plate.section = index + 1
                    totalHeaderPlates.append(plate)
                }
            }
        }
        var uiop = 0
        for plate in totalHeaderPlates {
            let actualPlateId = "\(plate.plateId)"
            print("your plate id is while saving :\(uiop): :\(actualPlateId)")
            uiop = uiop + 1
            
            let LocationTypePlates = CoreDataHandlerMicrodataModels.EnviromentalLocationPlateData(
                isBacterialChecked: plate.isBacterialChecked,
                isMicoscoreChecked: plate.isMicoscoreChecked,
                locationValue: plate.selectedLocationValues,
                plateId: actualPlateId,
                row: plate.row ?? 0, // Default to 0 if `plate.row` is nil
                section: plate.section ?? 0, // Default to 0 if `plate.section` is nil
                sampleDescription: plate.sampleDescription,
                locationTypeId: plate.selectedLocationTypeId ?? nil, // If nil, pass nil, otherwise pass the value
                requisitionId: self.barCode, // Bar code from current requisition
                requisitionType: self.requisitionType.rawValue, // Convert raw value of enum
                mediaTypeValue: plate.mediaTypeValue,
                mediaTypeId: plate.selectedMediaTypeId,
                notes: plate.notes,
                samplingMethodId: plate.samplingMethodTypeId,
                samplingMethodTypeValue: plate.samplingMethodTypeValue
            )
            
            CoreDataHandlerMicro().saveEnviromentalLocationTypePlatesInfo(data: LocationTypePlates)
            
            
        }
    }
    
    
    //MARK:- Save Enviromental  Sample Info/ Case Info data into DB when Submitted or Save As Draft
    func saveCaseInfoDataInToDB_Enviromental() {
        
        let caseInfo = CoreDataHandlerMicrodataModels.CaseInfo(
            requestor: self.requestor,
            sampleCollectedBy: self.sampleCollectedBy,
            company: self.company,
            companyId: self.companyId,
            site: self.site,
            siteId: self.siteId,
            email: self.email,
            reviewer: self.reviewer,
            surveyConductedOn: self.surveyConductedOn,
            sampleCollectionDate: self.sampleCollectionDate,
            sampleCollectionDateWithTimeStamp: self.sampleCollectionDateWithTimeStamp,
            purposeOfSurvey: self.purposeOfSurvey,
            transferIn: self.transferIn,
            barCode: self.barCode,
            barCodeManualEntered: self.barCodeManualEntered,
            notes: self.notes,
            reasonForVisit: self.reasonForVisit,
            currentdate: self.currentdate,
            customerId: "", // Empty or replace with actual ID if available
            requisitionType: self.requisitionType.rawValue,
            sessionStatus: self.sessionStatus.rawValue,
            requisitionId: self.barCode, // Reusing barCode as requisition_Id
            timeStamp: self.timeStamp,
            isPlateIdGenerated: self.isPlateIdGenerated,
            typeOfBird: "", // Provide a default or actual type
            typeOfBirdId: 0, // Default or lookup ID
            reviewerId: self.reviewerId,
            purposeOfSurveyId: self.purposeOfSurveyId,
            surveyConductedOnId: self.surveyConductedOnId,
            reasonForVisitId: self.reasonForVisitId
        )
        CoreDataHandlerMicro().saveCaseInfoDataInToDB(info: caseInfo)
        
    }
    
    
    //MARK:- Save Enviromental  Sample Info/ Case Info data into DB when Submitted or Save As Draft
    func updateDataForDraft(isFinalSubmit: Bool) {
        let predicate = NSPredicate(format: "timeStamp = %@ AND sessionStatus = %i", argumentArray: [self.timeStamp, "\(self.sessionStatus.rawValue)"])
        
        let updateInfo = CoreDataHandlerMicrodataModels.SessionUpdateData(
            requestor: self.requestor,
            sampleCollectedBy: self.sampleCollectedBy,
            company: self.company,
            companyId: self.companyId,
            site: self.site,
            siteId: self.siteId,
            email: self.email,
            reviewer: self.reviewer,
            surveyConductedOn: self.surveyConductedOn,
            sampleCollectionDate: self.sampleCollectionDate,
            sampleCollectionDateWithTimeStamp: self.sampleCollectionDateWithTimeStamp,
            purposeOfSurvey: self.purposeOfSurvey,
            transferIn: self.transferIn,
            barCode: self.barCode,
            barCodeManualEntered: self.barCodeManualEntered,
            notes: self.notes,
            reasonForVisit: self.reasonForVisit,
            currentdate: self.currentdate,
            customerId: "",
            requisitionType: self.requisitionType.rawValue,
            sessionStatus: isFinalSubmit ? SessionStatus.submitted.rawValue : self.sessionStatus.rawValue,
            requisition_Id: self.barCode,
            timeStamp: self.timeStamp,
            isPlateIdGenerated: self.isPlateIdGenerated,
            typeOfBird: self.typeOfBird,
            typeOfBirdId: self.typeOfBirdId,
            reviewerId: self.reviewerId,
            purposeOfSurveyId: self.purposeOfSurveyId,
            surveyConductedOnId: self.surveyConductedOnId,
            reasonForVisitId: self.reasonForVisitId
            
        )
        
        CoreDataHandlerMicro().updateDataInTheEntityWithPredicates(predicate: predicate, entity: "Microbial_EnviromentalSurveyFormSubmitted", updateData: updateInfo)
   
    }
    
    
    func deletePlateHeader(locationHeader: LocationTypeHeaderModel){
        CoreDataHandlerMicro().deleteHeaderPlates(timeStamp: self.timeStamp, barcode: locationHeader.requisition_Id, locationId: locationHeader.selectedLocationTypeId ?? 0, section: locationHeader.section )
        let prediactes = NSPredicate(format: "timeStamp = %@ AND requisitionType = %i AND section = %i AND locationTypeId = %i", argumentArray: [self.timeStamp, locationHeader.requisitionType ?? 0, locationHeader.section , locationHeader.selectedLocationTypeId ?? 0])
        Microbial_LocationTypeHeaderPlatesSubmitted.deleteAndUpdateCountSampleInfoPlateDataInToDB_Enviromental(predicate: prediactes)
    }
    
    func reArrangeSectionOfHeaders(){
        
        CoreDataHandlerMicro().reArrangeHeaders(timeStamp: self.timeStamp)
    }
    
    
    func deletePlates(data: LocationTypeCellModel, locationId: Int, numberOfPlates: Int){
        let prediactes = NSPredicate(format: "timeStamp = %@ AND section = %i AND locationTypeId = %i AND row = %i", argumentArray: [self.timeStamp, data.section ?? -1, locationId, data.row ?? -1])
        Microbial_LocationTypeHeaderPlatesSubmitted.deleteAndUpdateCountSampleInfoPlateDataInToDB_Enviromental(predicate: prediactes)
        let predicateToUpdateNumberOfPlates = NSPredicate(format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i", argumentArray: [self.timeStamp, data.requisition_Id, data.requisitionType ?? 0, data.section ?? -1])
        CoreDataHandlerMicro().updateNumberOfPlates(predicate: predicateToUpdateNumberOfPlates, noOfPlates: numberOfPlates)
    }
    
    
    func appendNewPlate(data: LocationTypeCellModel , numberOfPlates: Int){
        
        let plateData = CoreDataHandlerMicrodataModels.envPlateSampleInfo(
            
            currentDate: self.currentdate,
             customerId: "", // Assuming it's intentionally empty
             requisitionType: self.requisitionType.rawValue,
             sessionStatus: self.sessionStatus.rawValue,
             isBacterialChecked: data.isBacterialChecked,
             isMicoscoreChecked: data.isMicoscoreChecked,
             locationTypeId: data.selectedLocationTypeId ?? 0,
             locationValue: data.selectedLocationValues,
             plateId: data.plateId,
             row: data.row ?? -1,
             sampleDescription: data.sampleDescription,
             section: data.section ?? -1,
             requisitionId: self.barCode,
             timeStamp: self.timeStamp,
             locationValueId: data.selectedLocationValueId ?? 0,
             mediaTypeId: data.selectedMediaTypeId ?? 0,
             notes: data.notes,
             samplingMethodTypeId: data.samplingMethodTypeId ?? 0
            
        )
        Microbial_LocationTypeHeaderPlatesSubmitted.saveSampleInfoPlateDataInToDB_Enviromental(plateData)
        
        let predicateToUpdateNumberOfPlates = NSPredicate(format: "timeStamp = %@ AND requisition_Id = %@ AND requisitionType = %i AND section = %i", argumentArray: [self.timeStamp, data.requisition_Id, data.requisitionType ?? 0, data.section ?? -1])
        CoreDataHandlerMicro().updateNumberOfPlates(predicate: predicateToUpdateNumberOfPlates, noOfPlates: numberOfPlates)
    }
    
    
    
    
    func updateSampleInfoDataInToDB_Enviromental(isFinalSubmit: Bool) {
        var totalHeaderPlates = [LocationTypeCellModel]()
        
        debugPrint("Check final submit bool value :- ",isFinalSubmit)
        
        for (index, header) in self.actualCreatedHeaders.enumerated() {
            if let locationTypeId = header.selectedLocationTypeId {
                
                let headerInfo = CoreDataHandlerMicrodataModels.EnvSampleHeaderUpdateInfo(
                    currentDate: self.currentdate,
                     customerId: "",
                     requisitionType: self.requisitionType.rawValue,
                     sessionStatus: self.sessionStatus.rawValue,
                     locationType: header.selectedLocationType,
                     locationTypeId: locationTypeId,
                     noOfPlates: header.noOfPlates,
                     section: index + 1,
                     requisitionId: self.barCode,
                     timeStamp: self.timeStamp,
                     prevSection: index + 1
                )
                
                CoreDataHandlerMicro().updateSampleInfoHeaderDataInToDB_Enviromental(headerInfo)
            }
            
            if header.numberOfPlateIDCreated.count > 0 {
                for plate in header.numberOfPlateIDCreated {
                    plate.section = index + 1
                    plate.prevSection = index + 1 //isFinalSubmit ? (index + 1) : header.section
                    totalHeaderPlates.append(plate)
                }
            }
        }
        
        for plate in totalHeaderPlates {
            if let locationTypeId = plate.selectedLocationTypeId {
                let actualPlateId = "\(plate.plateId)"
                
                let sampleInfo = CoreDataHandlerMicrodataModels.environmentalSampleInfoPlate(
                    currentdate: self.currentdate,
                        customerId: "",
                        requisitionType: self.requisitionType.rawValue,
                        sessionStatus: self.sessionStatus.rawValue,
                        isBacterialChecked: plate.isBacterialChecked,
                        isMicoscoreChecked: plate.isMicoscoreChecked,
                        locationTypeId: locationTypeId,
                        locationValue: plate.selectedLocationValues,
                        locationValueId: plate.selectedLocationValueId ?? 0,
                        plateId: actualPlateId,
                        row: plate.row ?? -1,
                        sampleDescription: plate.sampleDescription,
                        section: plate.section ?? -1,
                        requisition_Id: self.barCode,
                        timeStamp: self.timeStamp,
                        prevSection: plate.prevSection ?? -1,
                        mediaTypeValue: plate.mediaTypeValue,
                        mediaTypeId: plate.selectedMediaTypeId ?? 0,
                        notes: plate.notes,
                        samplingMethodTypeId: plate.samplingMethodTypeId ?? 0,
                        samplingMethodTypeValue: plate.samplingMethodTypeValue
                    
                )
                Microbial_LocationTypeHeaderPlatesSubmitted.updateSampleInfoPlateDataInToDB_Enviromental(sampleInfo: sampleInfo)
            }
            
        }
    }

    func saveSampleInfoDataInToDB_Enviromental() {
        var totalHeaderPlates = [LocationTypeCellModel]()
        
        for (index, header) in self.actualCreatedHeaders.enumerated() {
            if let locationTypeId = header.selectedLocationTypeId {
                
                let headerInfo = CoreDataHandlerMicrodataModels.SampleInfoHeader(
                    currentdate: self.currentdate,
                    customerId: "", // Fill in if available
                    requisitionType: self.requisitionType.rawValue,
                    sessionStatus: self.sessionStatus.rawValue,
                    locationType: header.selectedLocationType,
                    locationTypeId: locationTypeId,
                    noOfPlates: header.noOfPlates,
                    section: index + 1,
                    requisitionId: self.barCode,
                    timeStamp: self.timeStamp
                )
                
                CoreDataHandlerMicro().saveSampleInfoHeaderDataInToDB_Enviromental(info: headerInfo)
            }
            
            if header.numberOfPlateIDCreated.count > 0 {
                for plate in header.numberOfPlateIDCreated {
                    plate.section = index + 1
                    totalHeaderPlates.append(plate)
                }
            }
        }
        
        for plate in totalHeaderPlates {
            if let locationTypeId = plate.selectedLocationTypeId {
                let actualPlateId = "\(plate.plateId)"
                
                let saveSampleInfoPlateDataInTo = CoreDataHandlerMicrodataModels.SampleInfoPlate(
                    currentdate: self.currentdate,
                    customerId: "",
                    requisitionType: self.requisitionType.rawValue,
                    sessionStatus: self.sessionStatus.rawValue,
                    isBacterialChecked: plate.isBacterialChecked,
                    isMicoscoreChecked: plate.isMicoscoreChecked,
                    locationTypeId: locationTypeId,
                    locationValue: plate.selectedLocationValues,
                    plateId: actualPlateId,
                    row: plate.row ?? -1,
                    sampleDescription: plate.sampleDescription,
                    section: plate.section ?? -1,
                    requisition_Id: self.barCode,
                    timeStamp: self.timeStamp,
                    locationValueId: plate.selectedLocationValueId ?? 0,
                    mediaTypeValue: plate.mediaTypeValue,
                    mediaTypeId: plate.selectedMediaTypeId ?? 0,
                    notes: plate.notes,
                    samplingMethodTypeValue: plate.samplingMethodTypeValue,
                    samplingMethodTypeId: plate.samplingMethodTypeId ?? 0
                )
                
                Microbial_LocationTypeHeaderPlatesSubmitted.saveSampleInfoPlateDataInToDB(sampleInfo: saveSampleInfoPlateDataInTo)
      
            }
            
        }
    }
    
     //MARK:- Save Enviromental  Requistions Id
    func saveEnviromentalRequisitionalId() {
        var totalPlates = [LocationTypeCellModel]()
        
        for header in self.actualCreatedHeaders {
            if header.noOfPlates > 0 {
                for plate in header.numberOfPlateIDCreated {
                   totalPlates.append(plate)
                }
            }
        }
        CoreDataHandlerMicro().saveRequisitionalIDs_Enviromental(requisition_Id: self.barCode, requisitionType: self.requisitionType.rawValue, sessionStatus: self.sessionStatus.rawValue, totalHeader: self.actualCreatedHeaders.count, totalPlates: totalPlates.count, timeStamp: self.timeStamp)
    }

}

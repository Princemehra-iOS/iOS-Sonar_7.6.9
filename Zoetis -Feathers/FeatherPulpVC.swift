//
//  FeatherPulpVCViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SwiftyJSON

class FeatherPulpVC: BaseViewController {
    var isPlusBtnClicked : Bool = false
    var isCompanyFieldCheck = false
    var isSiteFieldCheck = false
    var isBarcodeFieldCheck = false
    var isSubmitBtnClk = false
    var progressSession = NSArray()
    var plateArr = [MicrobialFeatherPulpSampleInfo]()
    var testOptions = [MicrobialFeatherpulpServiceTestSampleInfo]()
    var rowCount = Int()
    var globalDate: String = "\(Date.getCurrentDate())"
    var isToggle = false
    var barcodeForPlateId : String = ""
    var reviewerDetails : [MicrobialSelectedUnselectedReviewer] = []
    let sessionIdPlate = "sessionId = %d AND isSessionPlate == 1"
    let timeStampSessionPlate = "timeStamp = %@ AND isSessionPlate == 0"
    let timeStampStr = "timeStamp = %@"
    @IBOutlet weak var saveAsDraftBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    var requisitionSavedSessionType = REQUISITION_SAVED_SESSION_TYPE.CREATE_NEW_SESSION
    var featherPulpData = Microbial_EnviromentalSurveyFormSubmitted()
     
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var featherPulpTableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let firstName = UserDefaults.standard.value(forKey: "FirstName") as! String
    
    var currentRequisition = RequisitionModel()
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        print(self.requisitionSavedSessionType)
//        currentRequisition.requisitionType = RequisitionType.feathurePulp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currentRequisition.generatebarCode()
        self.setAttributesOfTableView()
        self.configureRequisitionAsPerSavedSessionType()
        userNameLabel.text = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        self.featherPulpTableView.reloadData()
    }
    
    class func  getSpecimenFromItsId(id: Int) -> String {
        guard let specimens = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpSpecimenType") as? [MicrobialFeatherPulpSpecimenType]  else {
            return ""
        }
        let data = specimens.filter {$0.id?.intValue == id}
        return data.count > 0 ? (data[0].specimenText ?? "") : ""
    }
    
    class func  getTypeOfBirdFromItsId(id: Int) -> String {
        guard let birds = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpBirdType") as? [MicrobialFeatherPulpBirdType]  else {
            return ""
        }
        let data = birds.filter {$0.id?.intValue == id}
        return data.count > 0 ? (data[0].birdText ?? "") : ""
    }
    
    func setAttributesOfTableView(){
        self.featherPulpTableView.layer.cornerRadius = 20
        self.featherPulpTableView.layer.masksToBounds = true
        self.featherPulpTableView.register(UINib(nibName: "FeatherpulpSampleInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FeatherpulpSampleInfoTableViewCell")
        self.featherPulpTableView.register(UINib(nibName: "FeatherPulpSampleInfoHeaderCell", bundle: nil), forCellReuseIdentifier: "FeatherPulpSampleInfoHeaderCell")
    }
    
    func configureRequisitionAsPerSavedSessionType(){
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION:
            let sessionprogresss = UserDefaults.standard.bool(forKey: "sessionprogresss")
            if sessionprogresss == true {
                self.currentRequisition.configureDataIfSessionInProgress_FeatherPulp()
                let id = UserDefaults.standard.integer(forKey: "sessionId")
                let predicate = NSPredicate(format: sessionIdPlate, argumentArray: [id])
                plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
                let predicateForTest = NSPredicate(format: "timeStamp = %@ && isSessionType == 1", argumentArray: [self.currentRequisition.timeStamp])
                self.testOptions = MicrobialFeatherpulpServiceTestSampleInfo.fetchDataOfTestOptions(predicate: predicateForTest)
//                self.currentRequisition.timeStamp = Date().getCurrentTimeStamp()
            }
            
        case .CREATE_NEW_SESSION:
            self.currentRequisition.timeStamp = Date().getCurrentTimeStamp()
            self.addSingleFarmDataForNewSession()
            
        case .SHOW_DRAFT_FOR_EDITING:
        self.currentRequisition.setDataOfDraftOrSubmittedRequisition(self.featherPulpData)
            let predicate = NSPredicate(format: timeStampSessionPlate, argumentArray: [self.currentRequisition.timeStamp])
            self.plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
            let predicateForTest = NSPredicate(format: "timeStamp = %@ && isSessionType == 0", argumentArray: [self.currentRequisition.timeStamp])
            self.testOptions = MicrobialFeatherpulpServiceTestSampleInfo.fetchDataOfTestOptions(predicate: predicateForTest)
            //   print("sample info >>>>>>>>\(self.plateArr)")
            self.featherPulpTableView.reloadData()
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.currentRequisition.setDataOfDraftOrSubmittedRequisition(self.featherPulpData)
            let predicate = NSPredicate(format: timeStampSessionPlate, argumentArray: [self.currentRequisition.timeStamp])
            self.plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
            
            let predicateForTest = NSPredicate(format: "timeStamp = %@ && isSessionType == 0", argumentArray: [self.currentRequisition.timeStamp])
            self.testOptions = MicrobialFeatherpulpServiceTestSampleInfo.fetchDataOfTestOptions(predicate: predicateForTest)
            //   print("sample info >>>>>>>>\(self.plateArr)")
            self.featherPulpTableView.reloadData()
            self.saveAsDraftBtn.isHidden = true
            self.submitBtn.isHidden = true
            self.submitBtn.translatesAutoresizingMaskIntoConstraints = false
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.currentRequisition.setDataOfDraftOrSubmittedRequisition(self.featherPulpData)
        }
    }
    
    
    func addSingleFarmDataForNewSession() {
        CoreDataHandlerMicro().deleteWithPredicatesFeaherPulpSampleInfo("MicrobialFeatherPulpSampleInfo")
        MicrobialFeatherPulpSampleInfo.addSingleFarmDetails(isSessionPlate: true, plateId: 1, timeStamp: self.currentRequisition.timeStamp)
        let id = UserDefaults.standard.integer(forKey: "sessionId")
        let predicate = NSPredicate(format: sessionIdPlate, argumentArray: [id])
        plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
        let tests = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpTestOptions") as! [MicrobialFeatherPulpTestOptions]
        for testOption in tests{
            MicrobialFeatherpulpServiceTestSampleInfo.saveFirstTimeTestOptionValuesInDB(timeStamp:  self.currentRequisition.timeStamp,testId: testOption.id ?? -100 ,testType: testOption.text ?? "" ,isSessionType: true, isCheckBoxSelected: false)
        }
        let predicateForTest = NSPredicate(format: "timeStamp = %@ && isSessionType == 1", argumentArray: [self.currentRequisition.timeStamp])
        self.testOptions = MicrobialFeatherpulpServiceTestSampleInfo.fetchDataOfTestOptions(predicate: predicateForTest)

        
        self.featherPulpTableView.reloadData()
    }
    
    
    @IBAction func actionMenu(_ sender: Any) {
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION, .CREATE_NEW_SESSION:
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
            CoreDataHandlerMicro().deleteAllData("Microbial_FeatherPulpCurrentSession")
            self.saveCurrentSession()
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
            CoreDataHandlerMicro().deleteAllData("Microbial_FeatherPulpCurrentSession")
            
        default: break
            
        }
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    
    private func saveReviewersDataToDatabase(isSessionType: Bool){
        let prediacateForNonSessionType = NSPredicate(format: "timeStamp == %@", argumentArray: [self.currentRequisition.timeStamp])
        let prediacateForSessionType = predicateForSessionType()
        let doesReviewerExists = MicrobialSelectedUnselectedReviewer.doReviewersExisitsFortheTimeStamp(predicate: isSessionType ? prediacateForSessionType : prediacateForNonSessionType)
        if !doesReviewerExists{
            let reviewerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer") as! [Micro_Reviewer]
            for reviewer in reviewerDetailsArray{
                MicrobialSelectedUnselectedReviewer.saveReviewersInDB( self.currentRequisition.timeStamp, reviewerId: reviewer.reviewerId?.intValue ?? 0, reviewerName: reviewer.reviewerName ?? "", isSelected: false, isSessionType: isSessionType)
            }
        }
    }
    
    func saveCurrentSession() {
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION, .CREATE_NEW_SESSION:
            CoreDataHandlerMicro().autoIncrementidtable()
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            
            let saveEnvSessionInfo = CoreDataHandlerMicrodataModels.EnvironmentalSessionInfo(
                requestor: currentRequisition.requestor,
                sampleCollectedBy: currentRequisition.sampleCollectedBy,
                company: currentRequisition.company,
                companyId: currentRequisition.companyId,
                site: currentRequisition.site,
                siteId: currentRequisition.siteId,
                email:  "",
                reviewer: currentRequisition.reviewer,
                surveyConductedOn: "",
                sampleCollectionDate: currentRequisition.sampleCollectionDate,
                sampleCollectionDateWithTimeStamp: currentRequisition.timeStamp,
                purposeOfSurvey: "", // Provide real value
                transferIn:  "",
                barCode: currentRequisition.barCode,
                barCodeManualEntered:  "",
                notes: currentRequisition.notes,
                reasonForVisit: currentRequisition.reasonForVisit,
                requisitionId: currentRequisition.barCode,
                requisitionType: currentRequisition.requisitionType.rawValue,
                isPlateIdGenerated: false,
                typeOfBird: currentRequisition.typeOfBird,
                typeOfBirdId: currentRequisition.typeOfBirdId
            )
           
            CoreDataHandlerMicro().saveEnviromentalSessionInProgress(info: saveEnvSessionInfo)
       
            self.saveReviewersDataToDatabase(isSessionType: true)
            UserDefaults.standard.set(true, forKey: "sessionprogresss")
            
        case .SHOW_DRAFT_FOR_EDITING:
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            self.currentRequisition.sessionStatus = SessionStatus.saveAsDraft//SessionStatus(rawValue: Int(truncating: savedData.sessionStatus ?? 0)) ?? SessionStatus.saveAsDraft
            self.currentRequisition.updateDataForDraft(isFinalSubmit: false)
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
        
    }
    
    @IBAction func siteBtnAction(_ sender: UIButton) {
        
        switch requisitionSavedSessionType {
            
        case .CREATE_NEW_SESSION,.RESTORE_OLD_SESSION, .SHOW_DRAFT_FOR_EDITING :
            guard !self.currentRequisition.company.isEmpty else {
                featherPulpTableView.reloadData()
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please select company first.")
                return
            }
            
            let sitesObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_siteByCustomer", customerId: self.currentRequisition.companyId)
            let sitesArray = sitesObjectArray.value(forKey: "siteName") as? [String] ?? []
            self.currentRequisition.barCodeManualEntered = ""
            
            if sitesArray.count == 0 {
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "There are no sites for selected company")
                return
            }
            self.currentRequisition.barCodeManualEntered = ""
            self.setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId, dropDownArr: sitesArray)
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    @IBAction func dateBtnAction(_ sender: UIButton) {
        switch requisitionSavedSessionType {
            
        case .CREATE_NEW_SESSION,.RESTORE_OLD_SESSION,.SHOW_DRAFT_FOR_EDITING:
            let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.canSelectPreviousDate = true
        present(datePickerPopupViewController, animated: false, completion: nil)
      
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    @IBAction func companyBtnAction(_ sender: UIButton) {
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION, .SHOW_DRAFT_FOR_EDITING:
            let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
            let customerNamesArray  = customerDetailsArray.value(forKey: "customerName") as? [String] ?? []
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.company, dropDownArr: customerNamesArray)
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?){
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField)
            }
            self.dropHiddenAndShow()
        }
    }
    
    func setDropdrownForTextField(_ sender: UITextField, clickedField:String, dropDownArr:[String]?){
        if dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField)
            }
            self.dropHiddenAndShow()
        }
    }
    
    @IBAction func reasonForVisitAction(_ sender: UIButton) {
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION,.SHOW_DRAFT_FOR_EDITING:   let reasonForVisitObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes")
            let reasonsForVisit = reasonForVisitObjectArray.value(forKey: "text")  as? [String] ?? []
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.reasonForVisit, dropDownArr: reasonsForVisit)
            
        case .RESTORE_OLD_SESSION: break
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    @IBAction func sampleCollectedByAction(_ sender: UIButton) {
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION, .SHOW_DRAFT_FOR_EDITING:
            let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpBirdType")
            let customerNamesArray  = customerDetailsArray.value(forKey: "birdText") as? [String] ?? []
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.birdType, dropDownArr: customerNamesArray)
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    @IBAction func reviewerBtnAction(_ sender: UIButton) {
        self.saveCurrentSession()
    }
    
    private func updateBoolValueOfReviewer(reviewerData: MicrobialSelectedUnselectedReviewer){
        switch requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            let predicate = NSPredicate(format: "isSessionType = %d AND reviewerId == %d", argumentArray: [true, reviewerData.reviewerId ?? 0])
            MicrobialSelectedUnselectedReviewer.updateBoolValueOfReviewer(predicate: predicate)

        case .SHOW_DRAFT_FOR_EDITING, .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            let predicate = NSPredicate(format: "timeStamp = %@ AND reviewerId == %d", argumentArray: [self.currentRequisition.timeStamp, reviewerData.reviewerId ?? 0])
            MicrobialSelectedUnselectedReviewer.updateBoolValueOfReviewer(predicate: predicate)
        }
        self.refreshReviewerData()
    }
    
    private func refreshReviewerData() {
        self.reviewerDetails.removeAll()
        switch requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            let prediacateForSessionType = predicateForSessionType()
            self.reviewerDetails = MicrobialSelectedUnselectedReviewer.fetchDetailsForReviewer(predicate: prediacateForSessionType)
        case .SHOW_DRAFT_FOR_EDITING,.SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            let prediacateForNonSessionType = NSPredicate(format: "timeStamp == %@", argumentArray: [self.currentRequisition.timeStamp])
            self.reviewerDetails = MicrobialSelectedUnselectedReviewer.fetchDetailsForReviewer(predicate: prediacateForNonSessionType)
        }
    }
    
    func setValueInTextFields(selectedValue: String, selectedIndex: Int, clickedField:String) {
        switch clickedField {
        case Constants.ClickedFieldMicrobialSurvey.birdType:
            self.currentRequisition.typeOfBird = selectedValue
            self.currentRequisition.typeOfBirdId = self.currentRequisition.getBirdTypeId()
            
        case Constants.ClickedFieldMicrobialSurvey.specimenType:
            self.plateArr[0].specimenType = selectedValue
            self.plateArr[0].specimenTypeId = self.currentRequisition.getSpecimenTypeId(specimen: selectedValue) as NSNumber
            let predicate = NSPredicate(format: timeStampStr, argumentArray: [self.currentRequisition.timeStamp])
            MicrobialFeatherPulpSampleInfo.updateSpecimenTypeId(value: self.plateArr[0].specimenTypeId?.intValue ?? 0, predicate: predicate)
        case Constants.ClickedFieldMicrobialSurvey.company:
            
            if self.currentRequisition.company != selectedValue {
                self.currentRequisition.resetSiteAndBarCode()
            }
            self.currentRequisition.company = selectedValue
            self.currentRequisition.companyId = self.currentRequisition.getCompanyIdforSelectedCompany()
            
        case Constants.ClickedFieldMicrobialSurvey.siteId:
            currentRequisition.site = selectedValue
            self.currentRequisition.siteId = self.currentRequisition.getSiteIdforSelectedSite()
            self.currentRequisition.generatebarCode()
            self.updatePlateId()
            self.refreshDataOfPlateArray()
            
        case Constants.ClickedFieldMicrobialSurvey.SampleCollectedBy:
            currentRequisition.sampleCollectedBy = selectedValue
            
        case Constants.ClickedFieldMicrobialSurvey.reviewer:
            currentRequisition.reviewer = selectedValue
            
        case Constants.ClickedFieldMicrobialSurvey.reasonForVisit:
            currentRequisition.reasonForVisit = selectedValue
            
        default:
            break
        }
        
        self.saveCurrentSession()
        featherPulpTableView.reloadData()
        
        
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    


    @IBAction func DraftBtnAction(_ sender: UIButton){
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            if self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .saveAsDraft){
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: Constants.youHaveAlreadyRequisitionStr)
                return
            }

            let alert = UIAlertController(title: Constants.alertStr, message: "Are you sure you want to Save To draft...?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
//                self.saveCaseInfoData(sessionStatus: .saveAsDraft)
            }))
            self.present(alert, animated: true, completion: nil)
            
        default:
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: MicrobialViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    func checkIfAllFieldsAreFilledInCaseInfo() -> Bool {
        let cellCaseInfo = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MicrobialCaseInfoCell
        
        let company = cellCaseInfo?.selectedCompanyTxt.text ?? ""
        let site = cellCaseInfo?.siteTxt.text ?? ""
        let barcode = cellCaseInfo?.barcodeTxt.text ?? ""
        let typeOfBird = cellCaseInfo?.sampleCollectedByTxt.text ?? ""
        let reviewer = cellCaseInfo?.reviewerTxt.text ?? ""
        if !company.isEmpty && !site.isEmpty && !barcode.isEmpty && !typeOfBird.isEmpty && !reviewer.isEmpty {
            if self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted){
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: Constants.youHaveAlreadyRequisitionStr)
                return false
            }
        }else{
            self.featherPulpTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            if cellCaseInfo?.siteTxt.text == "" {
                cellCaseInfo?.siteSelectionView.layer.borderColor = UIColor.red.cgColor
            }
            
            if cellCaseInfo?.sampleCollectedByTxt.text == ""{
                cellCaseInfo?.typeOfBirdView.layer.borderColor = UIColor.red.cgColor
            }
            
            if cellCaseInfo?.selectedCompanyTxt.text == "" {
                cellCaseInfo?.companySelectionView.layer.borderColor = UIColor.red.cgColor
            }
            
            if cellCaseInfo?.barcodeTxt.text == "" {
                cellCaseInfo?.barcodeSelectionView.layer.borderColor = UIColor.red.cgColor
            }
            
            if cellCaseInfo?.reviewerTxt.text == "" {
                cellCaseInfo?.reviewerTextFieldSuperView.layer.borderColor = UIColor.red.cgColor
            }
            Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please enter mandatory fields.")
            return false
        }
        return true
    }
    
    @IBAction func submitBtnClk(_ sender: UIButton) {
        if !checkIfAllFieldsAreFilledInCaseInfo() {
            return
        }
        let alert = UIAlertController(title: Constants.alertStr, message: "Are you Sure you want to submit the requisition?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
//            self.saveCaseInfoData(sessionStatus: .submitted)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        let cellSampleInfo = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MicrobialSampleInfoCell
        if !checkIfAllFieldsAreFilledInCaseInfo() {
            return
        }
        if plateArr.count > 0 {
            let lastVal = plateArr.count + 1
            cellSampleInfo?.noOfPlates.text = String(lastVal)
            rowCount = lastVal
            UserDefaults.standard.set(lastVal, forKey: "lastVal")
            self.addMorePlates(plateId: lastVal)
            
        } else {
            let txtVale = Int(cellSampleInfo?.noOfPlates.text ?? "0")!
            rowCount = txtVale
            for i in 0..<txtVale {
                self.addMorePlates(plateId: i + 1)
            }
            cellSampleInfo?.noOfPlates.isEnabled = false
        }
        self.featherPulpTableView.reloadData()
    }
    
    
    func addMorePlates(plateId: Int){
        let cellCaseInfo = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MicrobialCaseInfoCell
        let plate =  "\(String(describing:cellCaseInfo?.barcodeTxt.text ?? ""))-" + "\(plateId)"
        let sessionId = UserDefaults.standard.integer(forKey: "sessionId")

        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            
            let data = CoreDataHandlerMicrodataModels.FeatherPulpSampleInfoDataSave(
                plateIdGenerated: plate,
                    plateId: plateId,
                    flockId: "",
                    houseNo: "",
                    sampleDescription: "",
                    additionalTests: "Bacterial",
                    checkMark: "true",
                    microsporeCheck: "false",
                    sessionId: sessionId,
                    timeStamp: self.currentRequisition.timeStamp,
                    isSessionPlate: true
            )

            CoreDataHandlerMicro().saveFeatherPulpSampleInfoDataInDB(data)            
            
            plateArr.removeAll()
            let predicate = NSPredicate(format: sessionIdPlate, argumentArray: [sessionId])
            plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
        
        case .SHOW_DRAFT_FOR_EDITING:
            
            let data = CoreDataHandlerMicrodataModels.FeatherPulpSampleInfoDataSave(
                plateIdGenerated: plate,
                 plateId: plateId,
                 flockId: "",
                 houseNo: "",
                 sampleDescription: "",
                 additionalTests: "Bacterial",
                 checkMark: "true",
                 microsporeCheck: "false",
                 sessionId: sessionId,
                 timeStamp: self.currentRequisition.timeStamp,
                 isSessionPlate: false
            )

            CoreDataHandlerMicro().saveFeatherPulpSampleInfoDataInDB(data)
            
            plateArr.removeAll()
            let predicate = NSPredicate(format: timeStampSessionPlate, argumentArray: [self.currentRequisition.timeStamp])
            self.plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicate) as! [MicrobialFeatherPulpSampleInfo]
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    
    //MARK: - Delete plate button action
    @IBAction func globaldeleteBtnAction(_ sender: UIButton) {
        let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
        let timeStamp = self.currentRequisition.timeStamp
        
        if plateArr.count > 0 && isToggle == false {
            switch self.requisitionSavedSessionType {
            case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
                let predicateToDelete = NSPredicate(format: "sessionId = %d AND isSessionPlate == 1 AND plateId == %d", argumentArray: [sessionId, plateArr.last?.plateId?.intValue])
                CoreDataHandlerMicro().deleteLastRowFeatherPulpData(predicate: predicateToDelete)
                plateArr.removeAll()
                let predicateToFetch = NSPredicate(format: sessionIdPlate, argumentArray: [sessionId])
                plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]

            case .SHOW_DRAFT_FOR_EDITING:
                let predicateToDelete = NSPredicate(format: "timeStamp = %@ AND isSessionPlate == 0 AND plateId == %d", argumentArray: [timeStamp, plateArr.last?.plateId?.intValue])
                CoreDataHandlerMicro().deleteLastRowFeatherPulpData(predicate: predicateToDelete)
                plateArr.removeAll()
                let predicateToFetch = NSPredicate(format: timeStampSessionPlate, argumentArray: [timeStamp])
                plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]
                
            case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
            }
        }
        UIView.performWithoutAnimation {
            featherPulpTableView.reloadSections([IndexPath(row: 0, section: 1).section, IndexPath(row: 0, section: 2).section], with: .none)
        }
    }
  
    //MARK: - UP down arrow
    @IBAction func expandCollapseToggleBtn(_ sender: UIButton) {
        let cell = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MicrobialSampleInfoCell
        if isToggle == false {
            isToggle = true
            cell?.toggleExpandCollapseBtn.setImage(UIImage(named: "expand_view_icon"), for: .normal)
        } else {
            isToggle = false
            cell?.toggleExpandCollapseBtn.setImage(UIImage(named: "collapse_view_icon"), for: .normal)
        }
        featherPulpTableView.reloadData()
    }
    
    //MARK: - Check box Button action  // bacterial
    /// Identicle implementation of function: checkMarkUpdateSerotypeAction()
    @IBAction func checkMarkHVTUpdateAction(_ sender: UIButton) {
        let index = IndexPath(row: sender.tag, section: 2)
        sender.isSelected = !sender.isSelected
        self.updateFeatherPulpPlateDataInfo(indexPath: index as NSIndexPath)
    }
    
    func textFieldShouldStartEditingForCell(indexPath: IndexPath, cell: FeatherpulpSampleInfoTableViewCell, textField: UITextField) {
        if textField == cell.specimenTypeTextField {
            switch self.requisitionSavedSessionType {
            case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION, .SHOW_DRAFT_FOR_EDITING:
                let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialFeatherPulpSpecimenType")
                let customerNamesArray  = customerDetailsArray.value(forKey: "specimenText") as? [String] ?? []
                self.setDropdrownForTextField(textField, clickedField: Constants.ClickedFieldMicrobialSurvey.specimenType, dropDownArr: customerNamesArray)
            case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
            }
        }
    }
    
    func textFieldDidEndEditingForCell(indexPath: IndexPath, cell: FeatherpulpSampleInfoTableViewCell, textField: UITextField) {
        let predicate = NSPredicate(format: timeStampStr, argumentArray: [self.currentRequisition.timeStamp])
        var key = ""
        var value = ""
        switch textField {
        case cell.farmeEnterNameTextField:
            key = "farmName"
            value = textField.text ?? ""
        
        case cell.ageWeeksTextField:
            key = "weeks"
            value = textField.text ?? ""
            
        case cell.ageDaysTextField:
            key = "days"
            value = textField.text ?? ""
        
        case cell.specimenTypeTextField:
            key = "specimenType"
            value = textField.text ?? ""
            if !value.isEmpty{
                let specimenId = self.currentRequisition.getSpecimenTypeId(specimen: value)
                MicrobialFeatherPulpSampleInfo.updateSpecimenTypeId(value: specimenId, predicate: predicate)
            }
            
        case cell.enterNoOfPlatesTextField:
            key = "noOfSamples"
            value = textField.text ?? ""
            
        default: break
        }
        if !value.isEmpty{
            MicrobialFeatherPulpSampleInfo.updateFarmDetails(key: key, value: value, predicate: predicate)
            self.saveCurrentSession()
            self.refreshDataOfPlateArray()
            self.featherPulpTableView.reloadData()
        }
    }
    
}

//MARK: - UITableView Delegates and UITableView DataSource
extension FeatherPulpVC: UITableViewDelegate, UITableViewDataSource, MicrobialSampleInfoCellDelegate {
    
    func noOfPlates(count: Int, clicked: Bool) {
        rowCount = count
        
        if rowCount > 0 {
            isPlusBtnClicked = clicked
        } else {
            isPlusBtnClicked = false
        }
        featherPulpTableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.plateArr.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        switch indexPath.section {
        case 0:
            height = 450
        case 1:
            height = 100
        case 2:
            height = 204
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MicrobialCaseInfoCell", for: indexPath) as! MicrobialCaseInfoCell
            cell.selectedCompanyTxt.text = currentRequisition.company
            cell.siteTxt.text = currentRequisition.site
            
            cell.sampleCollectionDateTxt.text = currentRequisition.sampleCollectionDate
            cell.sampleCollectedByTxt.text = currentRequisition.typeOfBird
            cell.reviewerTxt.text = currentRequisition.reviewer
            cell.reasonForVisitTxt.text  = currentRequisition.reasonForVisit
            cell.requestorTxt.text = currentRequisition.requestor
            
            if !currentRequisition.barCodeManualEntered.isEmpty {
                currentRequisition.barCode = currentRequisition.barCodeManualEntered
            }
            cell.noteTextView.delegate = self
            cell.noteTextView.text = currentRequisition.notes
            cell.barcodeTxt.text = currentRequisition.barCode
            cell.barcodeTxt.delegate = self
            featherPulpTableView.allowsSelection = false
            cell.unableDisableAccordingToSessionType(sessionType: self.requisitionSavedSessionType)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatherPulpSampleInfoHeaderCell", for: indexPath) as! FeatherPulpSampleInfoHeaderCell
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatherpulpSampleInfoTableViewCell", for: indexPath) as! FeatherpulpSampleInfoTableViewCell
            cell.sessionType = self.requisitionSavedSessionType
            cell.setAttributes()
            cell.timeStamp = self.currentRequisition.timeStamp
            cell.arrTestOptions = self.testOptions
            cell.farmeEnterNameTextField.text = self.plateArr[indexPath.row].farmName
            cell.ageWeeksTextField.text = self.plateArr[indexPath.row].weeks
            cell.ageDaysTextField.text = self.plateArr[indexPath.row].days
            cell.specimenTypeTextField.text = self.plateArr[indexPath.row].specimenType
            cell.enterNoOfPlatesTextField.text = self.plateArr[indexPath.row].noOfSamples
            cell.specimentDropDownBtnAction = { (textfield) in
                self.textFieldShouldStartEditingForCell(indexPath: indexPath, cell: cell, textField: textfield)
            }
            cell.textFieldActionShouldStartEditingBlock = { (textfield) in
                self.textFieldShouldStartEditingForCell(indexPath: indexPath, cell: cell, textField: textfield)
            }
            cell.textFieldActionDidEndEditingBlock = { (textfield) in
                self.textFieldDidEndEditingForCell(indexPath: indexPath, cell: cell, textField: textfield)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}

//MARK: - Date picker Delegate
extension FeatherPulpVC: DatePickerPopupViewControllerProtocol {
   
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        self.currentRequisition.sampleCollectionDate = string
        self.currentRequisition.generatebarCode()
        self.featherPulpTableView.reloadData()
        self.saveCurrentSession()
    }
    
    
    func doneButtonTapped(string: String) {
//        self.currentRequisition.sampleCollectionDate = string
//        self.currentRequisition.generatebarCode()
//        self.featherPulpTableView.reloadData()
    }
}

//MARK: - Text field delegates
extension FeatherPulpVC : UITextFieldDelegate, UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentRequisition.notes = textView.text ?? ""
        self.saveCurrentSession()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        let cell = featherPulpTableView.cellForRow(at: IndexPath(row: textField.tag, section: 2)) as? MicrobialTextfieldInfoCell
        let cell1 = featherPulpTableView.cellForRow(at: IndexPath(row: textField.tag, section: 1)) as? MicrobialSampleInfoCell
        
        if cell1?.noOfPlates == textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: newString)) else {
                return false
            }
            return textField.text!.count < 3 || string == ""
        }
        
        if cell?.FlockIdTxt == textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: newString)) else {
                return false
            }
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // textField.becomeFirstResponder()
        let index = IndexPath(row: textField.tag, section: 2)
        let cell = featherPulpTableView.cellForRow(at: index) as? MicrobialTextfieldInfoCell
        let cell1 = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MicrobialSampleInfoCell
        let cell2 = featherPulpTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MicrobialCaseInfoCell
        if textField == cell?.FlockIdTxt {
//            self.plateArr[index.row].flockId = textField.text
            self.updateFeatherPulpPlateDataInfo(indexPath: index as NSIndexPath)
            
        } else if textField == cell?.HouseNoTxt {
//            self.plateArr[index.row].houseNo = textField.text
            self.updateFeatherPulpPlateDataInfo(indexPath: index as NSIndexPath)
            
        } else if textField == cell1?.noOfPlates {
            //   cell1?.noOfPlates.text = textField.text
            
        }  else if textField == cell2?.barcodeTxt {
            currentRequisition.barCode = textField.text ?? ""
            self.saveCurrentSession()
            self.updatePlateId()
            self.refreshDataOfPlateArray()
            featherPulpTableView.reloadSections([2], with: .automatic)
        }
    }
    
    func updatePlateId(){
        let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
        switch  self.requisitionSavedSessionType{
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            let predicate = NSPredicate(format: sessionIdPlate, argumentArray: [sessionId])

            MicrobialFeatherPulpSampleInfo.updatePlateIdGenerates(entity: "MicrobialFeatherPulpSampleInfo", predicate: predicate, barcode: self.currentRequisition.barCode)
            
            
        case .SHOW_DRAFT_FOR_EDITING:
            let predicate = NSPredicate(format: timeStampSessionPlate, argumentArray: [self.currentRequisition.timeStamp])
            MicrobialFeatherPulpSampleInfo.updatePlateIdGenerates(entity: "MicrobialFeatherPulpSampleInfo", predicate: predicate, barcode: self.currentRequisition.barCode)
            
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    func refreshDataOfPlateArray(){
        plateArr.removeAll()
        let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            let predicateToFetch = NSPredicate(format: sessionIdPlate, argumentArray: [sessionId])
            plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]
            
        case .SHOW_DRAFT_FOR_EDITING:
            let predicateToFetch = NSPredicate(format: timeStampSessionPlate, argumentArray: [self.currentRequisition.timeStamp])
            plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
    }
    
    func updateFeatherPulpPlateDataInfo(indexPath: NSIndexPath){
        let timeStamp = self.currentRequisition.timeStamp
        let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
        switch self.requisitionSavedSessionType {
        case .CREATE_NEW_SESSION, .RESTORE_OLD_SESSION:
            let predicate = NSPredicate(format: "sessionId = %d AND isSessionPlate == 1 AND plateId == %d", argumentArray: [sessionId, plateArr[indexPath.row].plateId])
            CoreDataHandlerMicro().updateFeatherPulpSampledesc(plateData: plateArr[indexPath.row], predicate: predicate)
            plateArr.removeAll()
            let predicateToFetch = NSPredicate(format: sessionIdPlate, argumentArray: [sessionId])
            plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]

        case .SHOW_DRAFT_FOR_EDITING:
            let predicate = NSPredicate(format: "timeStamp = %@ AND isSessionPlate == 0 AND plateId == %d", argumentArray: [timeStamp, plateArr[indexPath.row].plateId])
            CoreDataHandlerMicro().updateFeatherPulpSampledesc(plateData: plateArr[indexPath.row], predicate: predicate)
            plateArr.removeAll()
            let predicateToFetch = NSPredicate(format: timeStampSessionPlate, argumentArray: [timeStamp])
            plateArr =  CoreDataHandlerMicro().fetchSampleInfoDataForATimeStamp("MicrobialFeatherPulpSampleInfo", predicate: predicateToFetch) as! [MicrobialFeatherPulpSampleInfo]

        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY: break
        }
        
        UIView.performWithoutAnimation {
            featherPulpTableView.reloadData()
        }
    }
    
}

//
//  EnviromentalSurveyController.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 13/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import CoreData

class EnviromentalSurveyController: BaseViewController , UISearchBarDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var saveButtonAndDraftBurronView: UIView!
    @IBOutlet weak var saveAsDraftButton: GradientButton1!
    @IBOutlet weak var submitButton: customButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesView: UIView!
    var notesIndexPath = IndexPath()
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    let userLogedIn = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
    let userId =  UserDefaults.standard.value(forKey: "Id") as? String ?? ""
    var plateIdIndex = 0
    var selectedRequisionId: String?
    
    var currentRequisition = RequisitionModel()
    
    var isSubmitButtonPressed = false
    var currentRequisitionType = RequisitionType.enviromental
    var requisitionSavedSessionType = REQUISITION_SAVED_SESSION_TYPE.CREATE_NEW_SESSION
    
    var defaultBorderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 255.0/255, alpha: 1.0).cgColor
    
    var savedData = Microbial_EnviromentalSurveyFormSubmitted()
    var reviewerDetails : [MicrobialSelectedUnselectedReviewer] = []
    var dropButton = DropDown()
    var data: [String] = [String]()
    var dataFiltered: [String] = []
    var isSelectionStart = false
    var microbialSelectedPlatesData: [MicrobialSampleDetailsList] = []
    
    var requisitionArray: [RequisitionData] = []
    
    enum STANDARD_TEMPLATE_TYPE: Int {
        case STD20 = 0
        case STD40 = 1
        case STD = 2
        
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            fetchGetAllRequisionDataWithPlates()
        }else {
            self.tableView.reloadData()
            self.configureTableView()
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.saveButtonAndDraftBurronView.isHidden = (requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY)
        self.userNameLabel.text = userLogedIn
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentRequisition.requisitionType = self.currentRequisitionType
        self.currentRequisition.generateLocationType()
        self.currentRequisition.generatebarCode()
        self.currentRequisition.generateHeader()
        
        self.configureRequisitionAsPerSavedSessionType()
        switch self.currentRequisition.requisitionType {
        case .bacterial:
            self.titleLabel.text = "Bacterial Survey Submission Form"
        case .enviromental:
            self.titleLabel.text = "Environmental Survey Submission Form"
        }
        if self.currentRequisition.isPlateIdGenerated{
            self.submitButton.setImage(nil, for: .normal)
            self.submitButton.backgroundColor = UIColor.blue
            self.submitButton.setTitle("DONE", for: .normal)
            self.submitButton.cornerRadius = 24.0
        } else {
            self.submitButton.setImage(UIImage(named: "BacterialSubmitImg"), for: .normal)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        switch requisitionSavedSessionType {
        case .CREATE_NEW_SESSION:
            self.removeIfUserDoesNotSaveAnythingInNewSession()
        default: break
        }
    }
    
    private func fetchGetAllRequisionDataWithPlates() {
        dismissGlobalHUD(self.view)
        showGlobalProgressHUDWithTitle(self.view, title: "")

        ZoetisWebServices.shared.getAllRequisitionDataWithPlates(
            controller: self,
            parameters: [:]
        ) { [weak self] (json, error) in
            
            guard let self = self else { return }
            self.dismissGlobalHUD(self.view)
            guard error == nil else { return }

            let jsonObject = RequisitionGetDataModel(json)
            self.requisitionArray = jsonObject.requisitionArray ?? []

            guard let requisitions = jsonObject.requisitionArray,
                  !requisitions.isEmpty else { return }

            self.extractSelectedPlateData(from: requisitions)
        }
    }

    private func extractSelectedPlateData(from requisitions: [RequisitionData]) {
        for req in requisitions {
            guard let microbialDetails = req.microbialDetailsList else { continue }

            let matched = microbialDetails.filter {
                $0.requisitionNo?.replacingOccurrences(of: "C-", with: "") == selectedRequisionId
            }

            guard let first = matched.first else { continue }

            self.microbialSelectedPlatesData.append(contentsOf: first.microbialSampleDetailsList ?? [])
        }
    }
    
    
    private func removeIfUserDoesNotSaveAnythingInNewSession(){
        let sessionDataArr = CoreDataHandlerMicro().fetchAllData("Microbial_EnviromentalSessionInProgress")
        if sessionDataArr.count == 0 {
            let prediacateForSessionType = predicateForSessionType()
            MicrobialSelectedUnselectedReviewer.deleteReviewer(predicate: prediacateForSessionType)
        }
    }
    
    
    //MARK: - All Buttons action
    @IBAction func actionMenu(_ sender: Any) {
        
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION, .CREATE_NEW_SESSION:
            self.startSavingInSession()
            
        default: break
        }
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    
    
    @IBAction func saveAsDraftPressed(_ sender: UIButton) {
        self.saveAsDraft()
    }
    
    @IBAction func notesDoneBtnClick(_ sender: UIButton) {
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            notesView.removeFromSuperview()
            self.reloadTableView()
            
        } else {
            self.currentRequisition.actualCreatedHeaders[notesIndexPath.section - 1].numberOfPlateIDCreated[notesIndexPath.row].notes = notesTextView.text
            self.currentRequisition.actualCreatedHeaders[notesIndexPath.section - 1].numberOfPlateIDCreated[notesIndexPath.row].isSelectedNote = true
            self.currentRequisition.actualCreatedHeaders[notesIndexPath.section - 1].numberOfPlateIDCreated[notesIndexPath.row].tag = notesIndexPath.row
            notesView.removeFromSuperview()
            self.reloadTableView()
        }
    }
    
    @IBAction func notesCancelBtnClick(_ sender: UIButton) {
        notesView.removeFromSuperview()
    }
    
    
    
    private func navigateToMocrobialViewController() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MicrobialViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        self.isSubmitButtonPressed = true
        guard !self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted) else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
            return
        }
        
        guard self.isAllSampleInfoMandatoryFiledsFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.pleaseFillMandatoryFieldsStr)
            return
        }
        
        guard self.currentRequisition.barCode != "E-" else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Invalid Barcode")
            return
        }
        
        if self.currentRequisition.actualCreatedHeaders.count == 1 {
            guard self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0 else {
                Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please create plates before submit.")
                return
            }
        }
        
        if self.currentRequisition.actualCreatedHeaders.count > 1 {
            for plates in self.currentRequisition.actualCreatedHeaders{
                guard plates.numberOfPlateIDCreated.count > 0 else {
                    Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please create plates for all the locations added.")
                    return
                }
            }
        }
        
        guard self.isAllPlatesHaveLocationValue() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please select location value for all plates generated.")
            return
        }
        
        guard self.isSampleTextFieldFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please enter sample description.")
            return
        }
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to submit?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.currentRequisition.isPlateIdGenerated = true
            self.finalSubmit()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func generatePlateIdFirst() {
        
        self.currentRequisition.isPlateIdGenerated = !self.currentRequisition.isPlateIdGenerated
        for i in 0..<self.currentRequisition.actualCreatedHeaders.count{
            self.currentRequisition.actualCreatedHeaders[i].ischeckBoxSelected = true
        }
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.tableView.reloadData()
    }
    
    func finalSubmit(){
        self.currentRequisition.timeStamp = Date().getCurrentTimeStamp()
        self.currentRequisition.sessionStatus = SessionStatus.submitted
        if requisitionSavedSessionType != .SHOW_DRAFT_FOR_EDITING {
            self.currentRequisition.saveCaseInfoDataInToDB_Enviromental()
            self.currentRequisition.saveSampleInfoDataInToDB_Enviromental()
            self.currentRequisition.saveEnviromentalRequisitionalId()
            let predicate = NSPredicate(format: "isSessionType = %d", argumentArray: [true])
            MicrobialSelectedUnselectedReviewer.updateTimeStampFromSession(predicate: predicate, timeStamp: self.currentRequisition.timeStamp)
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            //            CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaders")
            //            CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaderPlates")
        }
        
        else {
            self.saveCurrentDataInLocalDB(isFinalSubmit: true)
        }
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MicrobialViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
            }
        }
        
    }
    
    func saveCurrentSessionDataInToDB() {
        self.currentRequisition.saveCaseInfoCurrentSessionDataInToDB()
        self.currentRequisition.saveLocationTypeHeaderCurrentSessionInfoInDB()
        self.currentRequisition.saveLocationTypePlatesCurrentSessionInfoInToDB()
        self.saveReviewersDataToDatabase(isSessionType: true)
        UserDefaults.standard.set(true, forKey: "sessionprogresss")
    }
    
    private func saveReviewersDataToDatabase(isSessionType: Bool) {
        let prediacateForNonSessionType = NSPredicate(format: "timeStamp == %@", argumentArray: [self.currentRequisition.timeStamp])
        let prediacateForSessionType = predicateForSessionType()
        let doesReviewerExists = MicrobialSelectedUnselectedReviewer.doReviewersExisitsFortheTimeStamp(predicate: isSessionType ? prediacateForSessionType : prediacateForNonSessionType)
        if !doesReviewerExists{
            let reviewerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer") as! [Micro_Reviewer]
            for reviewer in reviewerDetailsArray  {
                let userIdStr = UserDefaults.standard.value(forKey:"Id") ?? 0
                let isReviewerSelected = ((userIdStr as! Int) == reviewer.reviewerId?.intValue ?? 0)
                MicrobialSelectedUnselectedReviewer.saveReviewersInDB( self.currentRequisition.timeStamp, reviewerId: reviewer.reviewerId?.intValue ?? 0, reviewerName: reviewer.reviewerName ?? "", isSelected: isReviewerSelected, isSessionType: isSessionType)
            }
        }
    }
    
    
    private func refreshReviewerData(){
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
    
    fileprivate func isAllPlatesHaveLocationValue() -> Bool {
        for header in self.currentRequisition.actualCreatedHeaders {
            for plate in header.numberOfPlateIDCreated {
                if plate.selectedLocationValues.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    fileprivate func isSampleTextFieldFilled() -> Bool {
        for header in self.currentRequisition.actualCreatedHeaders {
            for plate in header.numberOfPlateIDCreated {
                if (plate.selectedLocationValues == "Other") && plate.sampleDescription.isEmpty {
                    return false
                }
            }
        }
        return true
    }
    
    fileprivate func isAllSampleInfoMandatoryFiledsFilled() -> Bool {
        if  self.currentRequisition.company.isEmpty ||
                self.currentRequisition.site.isEmpty ||
                self.currentRequisition.barCode.isEmpty {
            return false
        }
        
        return true
    }
}


//MARK: - Table View Delegates and Configuration
extension EnviromentalSurveyController: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight =  610
        self.tableView.separatorStyle = .none
        
        self.tableView.register(EnviromentalFormCell.nib, forCellReuseIdentifier: EnviromentalFormCell.identifier)
        self.tableView.register(BacterialFormCell.nib, forCellReuseIdentifier: BacterialFormCell.identifier)
        self.tableView.register(EnviromentalSampleInfoCell.nib, forCellReuseIdentifier: EnviromentalSampleInfoCell.identifier)
        
        self.tableView.register(UINib(nibName: "EnviromentalLocationHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "EnviromentalLocationHeaderView")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if microbialSelectedPlatesData.count > 0 {
            return microbialSelectedPlatesData.count + 1
        }
        return 1 + self.currentRequisition.actualCreatedHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                if self.microbialSelectedPlatesData[section - 1].isHeaderIsCollapsed {
                    return 0
                } else {
                    if microbialSelectedPlatesData.count > 0 {
                        return microbialSelectedPlatesData[section - 1].microbialSamplePlates?.count ?? 0
                    }
                }
                
            }
            if self.currentRequisition.actualCreatedHeaders[section - 1].isHeaderIsCollapsed {
                return 0
            } else {
                
                return self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count
            }
        }
    }
    
    //MARK: - Configure data for Enviromental
    fileprivate func configureData_Enviromental(_ cell: EnviromentalFormCell) {
        cell.reasonForVisitTextField.text = self.currentRequisition.reasonForVisit
        cell.requestorTextField.text = self.currentRequisition.requestor
        cell.sampleCollectedByText.text = self.currentRequisition.sampleCollectedBy
        cell.companyTextField.text = self.currentRequisition.company
        cell.siteTextField.text = self.currentRequisition.site
        cell.surveyConductedTextField.text = self.currentRequisition.surveyConductedOn
        cell.sampleDateTextField.text = self.currentRequisition.sampleCollectionDate
        cell.purposeOfSurveyTextField.text = self.currentRequisition.purposeOfSurvey
        cell.barcodeTextField.text = self.currentRequisition.barCode
        cell.noteTextView.text = self.currentRequisition.notes
    }
    
    //MARK: - Configure data for Bacterial
    fileprivate func configureData_Bacterial(_ cell: BacterialFormCell) {
        cell.reasonForVisitTextField.text = self.currentRequisition.reasonForVisit
        cell.requestorTextField.text = self.currentRequisition.requestor
        cell.companyTextField.text = self.currentRequisition.company
        cell.siteTextField.text = self.currentRequisition.site
        cell.sampleDateTextField.text = self.currentRequisition.sampleCollectionDate
        cell.barcodeTextField.text = self.currentRequisition.barCode
        cell.noteTextView.text = self.currentRequisition.notes
    }
    
    fileprivate func cellForRowOfBacterialCaseInfo(_ tableView: UITableView, indexPath: IndexPath) -> BacterialFormCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BacterialFormCell", for: indexPath) as! BacterialFormCell
        cell.requisitionSavedSessionType = self.requisitionSavedSessionType
        cell.delegate = self
        cell.barcodeTextField.delegate = cell
        cell.noteTextView.delegate = cell
        self.configureData_Bacterial(cell)
        if self.currentRequisition.actualCreatedHeaders.count > 0  {
            cell.configureMandatoryFiledsValidation(self.currentRequisition.actualCreatedHeaders[0], isSubmitButtonPressed: self.isSubmitButtonPressed, currentSessionInProgressModel: self.currentRequisition)
        }
        cell.disableAllEvents()
        return cell
    }
    
    
    fileprivate func cellForRowOfEnvironmentalCaseInfo(_ tableView: UITableView, indexPath: IndexPath) -> EnviromentalFormCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnviromentalFormCell", for: indexPath) as! EnviromentalFormCell
        cell.requisitionSavedSessionType = self.requisitionSavedSessionType
        cell.enviromentalFormCellDelegates = self
        cell.barcodeTextField.delegate = cell
        cell.noteTextView.delegate = cell
        
        self.configureData_Enviromental(cell)
        if self.currentRequisition.actualCreatedHeaders.count > 0  {
            cell.configureMandatoryFiledsValidation(self.currentRequisition.actualCreatedHeaders[0], isSubmitButtonPressed: self.isSubmitButtonPressed, currentSessionInProgressModel: self.currentRequisition)
        }
        cell.disableAllEvents()
        return cell
    }
    
    
    // MARK: cellForRowAt Started
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return handleCaseInfoSection(tableView, indexPath: indexPath)
        } else {
            return configureEnvironmentalSampleCell(tableView, indexPath: indexPath)
        }
    }
    
    private func handleCaseInfoSection(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch currentRequisition.requisitionType {
        case .bacterial:
            return cellForRowOfBacterialCaseInfo(tableView, indexPath: indexPath)
        case .enviromental:
            return cellForRowOfEnvironmentalCaseInfo(tableView, indexPath: indexPath)
        }
    }
    
    private func configureEnvironmentalSampleCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnviromentalSampleInfoCell") as! EnviromentalSampleInfoCell
        let headerIndex = indexPath.section - 1
        
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            cell.locationValueTextField.text = microbialSelectedPlatesData[indexPath.section - 1].microbialSamplePlates?[indexPath.row].locVal
            cell.samplingTextField.text = microbialSelectedPlatesData[ indexPath.section - 1].microbialSamplePlates?[indexPath.row].samplingText
            cell.mediaTypeTextField.text = microbialSelectedPlatesData[ indexPath.section - 1].microbialSamplePlates?[indexPath.row].mediaText
            configureLineViewForReadOnly(for: cell, at: indexPath)
            if let plateForView = microbialSelectedPlatesData[ indexPath.section - 1].microbialSamplePlates?[indexPath.row] {
                configureReadOnlyUIViewOnly(for: cell, plate: plateForView, indexPath: indexPath)
                configureTextFieldsForViewOnly(for: cell, plate: plateForView)
                configurePlateIDForViewOnly(for: cell, at: indexPath, plate: plateForView)
                configureBasicCellProperties(cell, indexPath: indexPath)
                configureButtonsForViewOnly(for: cell, plateMicro: plateForView, indexPath: indexPath)
                cell.isPlateIdGenerated = currentRequisition.isPlateIdGenerated
                cell.disableAllEventsAccordingToSavedSession()
                cell.disableAllEventsAccordingToPlateIdsGenerated()
                cell.disableAllEvents()
            }
        } else {
            let plate = currentRequisition.actualCreatedHeaders[headerIndex].numberOfPlateIDCreated[indexPath.row]
            configureBasicCellProperties(cell, indexPath: indexPath)
            configureDropDown(for: cell, at: indexPath)
            configurePlateID(for: cell, at: indexPath, plate: plate)
            configureReadOnlyUI(for: cell, plate: plate, indexPath: indexPath)
            configureTextFields(for: cell, plate: plate)
            configureButtons(for: cell, plate: plate, indexPath: indexPath)
            configureValidationBorders(for: cell, plate: plate)
            
            cell.isPlateIdGenerated = currentRequisition.isPlateIdGenerated
            cell.disableAllEventsAccordingToSavedSession()
            cell.disableAllEventsAccordingToPlateIdsGenerated()
        }
        
        return cell
    }
    
    private func configureBasicCellProperties(_ cell: EnviromentalSampleInfoCell, indexPath: IndexPath) {
        cell.requisitionSavedSessionType = requisitionSavedSessionType
        cell.delegate = self
        cell.tag = indexPath.row
        cell.sampleDescriptionTextField.delegate = cell
        cell.notesButton.tag = indexPath.row
        cell.searchBarLocation.delegate = self
        cell.searchBarLocation.tag = 100 + indexPath.row
    }
    
    private func configureDropDown(for cell: EnviromentalSampleInfoCell, at indexPath: IndexPath) {
        dropButton.anchorView = cell.searchBarLocation
        dropButton.bottomOffset = CGPoint(x: 40, y: (dropButton.anchorView?.bounds.height ?? 0) + 10)
        dropButton.backgroundColor = .white
        dropButton.direction = .top
        dropButton.tag = 100 + indexPath.row
        dropButton.dataSource = data as [AnyObject]
        dropButton.selectionAction = { [unowned self] (index, item) in
            self.setValueInTextFields(
                selectedValue: item,
                selectedIndex: index,
                clickedField: Constants.ClickedFieldMicrobialSurvey.locationValue,
                cell: Constants.cell,
                view: view
            )
        }
        cell.searchBarLocation.placeholder = "Location Value"
    }
    
    private func configurePlateID(for cell: EnviromentalSampleInfoCell, at indexPath: IndexPath, plate: LocationTypeCellModel) {
        let header = currentRequisition.actualCreatedHeaders[indexPath.section - 1]
        let key = "\(plate.selectedLocationTypeId ?? 0) - \(indexPath.section) - \(indexPath.row + 1)"
        
        if let index = generatePlateIndex()[key] {
            let barcode = currentRequisition.barCode
            let plateId = "\(barcode)-\(index)"
            header.numberOfPlateIDCreated[indexPath.row].plateId = plateId
            
            if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                cell.plateIdLabel.text = plateId
                cell.plateIdLabel.isHidden = true
                cell.infoDetailButton.isHidden = false
                cell.infoIconImage.isHidden = true
                saveButtonAndDraftBurronView.isHidden = true
                
                cell.addInfoPlate = { sender in
                    let alert = UIAlertController(title: plateId, message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    UIPopoverController(contentViewController: alert).present(
                        from: sender.frame,
                        in: cell,
                        permittedArrowDirections: .down,
                        animated: true
                    )
                }
            } else {
                cell.plateIdLabel.text = "\(index)"
                cell.plateIdLabel.isHidden = false
                cell.plateIdLabel.textAlignment = .center
                cell.infoDetailButton.isHidden = true
                cell.infoIconImage.isHidden = true
            }
        }
    }
    private func configurePlateIDForViewOnly(for cell: EnviromentalSampleInfoCell, at indexPath: IndexPath, plate: MicrobialSamplePlates) {
        cell.plateIdLabel.text = plate.plateId
        cell.plateIdLabel.isHidden = true
        cell.infoDetailButton.isHidden = false
        cell.infoIconImage.isHidden = true
        saveButtonAndDraftBurronView.isHidden = true
        
        cell.addInfoPlate = { sender in
            let alert = UIAlertController(title: plate.plateId, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            UIPopoverController(contentViewController: alert).present(
                from: sender.frame,
                in: cell,
                permittedArrowDirections: .down,
                animated: true
            )
        }
    }
    private func configureReadOnlyUI(for cell: EnviromentalSampleInfoCell, plate: LocationTypeCellModel, indexPath: IndexPath) {
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            cell.searchBarLocation.isHidden = true
            cell.locationValueTextField.isHidden = false
            cell.locationValueTextField.text = plate.selectedLocationValues
            saveButtonAndDraftBurronView.isHidden = true
            cell.samplingTypeButton.isUserInteractionEnabled = false
            cell.noteButtonNew.isUserInteractionEnabled = false
            cell.selectionStyle = .none
        } else {
            cell.searchBarLocation.text = plate.selectedLocationValues
        }
    }
    private func configureReadOnlyUIViewOnly(for cell: EnviromentalSampleInfoCell, plate: MicrobialSamplePlates, indexPath: IndexPath) {
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            cell.searchBarLocation.isHidden = true
            cell.locationValueTextField.isHidden = false
            cell.locationValueTextField.text = plate.locVal
            saveButtonAndDraftBurronView.isHidden = true
            cell.samplingTypeButton.isUserInteractionEnabled = false
            cell.noteButtonNew.isUserInteractionEnabled = false
            cell.selectionStyle = .none
        } else {
            cell.searchBarLocation.text = plate.locVal
        }
    }
    private func configureTextFields(for cell: EnviromentalSampleInfoCell, plate: LocationTypeCellModel) {
        cell.sampleDescriptionTextField.text = plate.sampleDescription
        
        if plate.mediaTypeValue.isEmpty {
            plate.mediaTypeValue = plate.mediaDefault ?? ""
            plate.selectedMediaTypeId = 1
        }
        cell.mediaTypeTextField.text = plate.mediaTypeValue
        
        if plate.samplingMethodTypeValue.isEmpty {
            plate.samplingMethodTypeValue = plate.samplingDefault ?? ""
            plate.samplingMethodTypeId = 1
        }
        cell.samplingTextField.text = plate.samplingMethodTypeValue
    }
    private func configureTextFieldsForViewOnly(for cell: EnviromentalSampleInfoCell, plate: MicrobialSamplePlates) {
        cell.sampleDescriptionTextField.text = plate.sampleDesc
        
        
        cell.mediaTypeTextField.text = plate.mediaText
        
        
        cell.samplingTextField.text = plate.samplingText
    }
    private func configureButtons(for cell: EnviromentalSampleInfoCell, plate: LocationTypeCellModel, indexPath: IndexPath) {
        if plate.selectedLocationValues == "Other" {
            cell.sampleDescriptionButton.backgroundColor = .white
        } else {
            cell.sampleDescriptionButton.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.2)
        }
        
        let imageName = plate.isBacterialChecked ? "checkIcon" : "uncheckIcon"
        cell.bacterialCheckBoxButton.setImage(UIImage(named: imageName), for: .normal)
        
        if plate.notes.count > 0 {
            cell.noteButtonNew.setImage(UIImage(named: "PECommentSelected"), for: .normal)
            if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                cell.noteButtonNew.isUserInteractionEnabled = true
            }
        } else {
            cell.noteButtonNew.setTitle("", for: .normal)
            cell.noteButtonNew.setImage(UIImage(named: "NewImgeComment"), for: .normal)
            cell.noteButtonNew.contentMode = .scaleToFill
        }
    }
    private func configureButtonsForViewOnly(for cell: EnviromentalSampleInfoCell, plateMicro: MicrobialSamplePlates, indexPath: IndexPath) {
        if plateMicro.locVal == "Other" {
            cell.sampleDescriptionButton.backgroundColor = .white
        } else {
            cell.sampleDescriptionButton.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.2)
        }
        
        let imageName = plateMicro.addBact ?? false ? "checkIcon" : "uncheckIcon"
        cell.bacterialCheckBoxButton.setImage(UIImage(named: imageName), for: .normal)
        
        if plateMicro.notes?.count ?? 0 > 0 {
            cell.noteButtonNew.setImage(UIImage(named: "PECommentSelected"), for: .normal)
            if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                cell.noteButtonNew.isUserInteractionEnabled = true
            }
        } else {
            cell.noteButtonNew.setTitle("", for: .normal)
            cell.noteButtonNew.setImage(UIImage(named: "NewImgeComment"), for: .normal)
            cell.noteButtonNew.contentMode = .scaleToFill
        }
    }
    private func configureValidationBorders(for cell: EnviromentalSampleInfoCell, plate: LocationTypeCellModel) {
        let showError = isSubmitButtonPressed
        let locationEmpty = plate.selectedLocationValues.isEmpty
        let sampleDescriptionEmpty = plate.sampleDescription.isEmpty
        let isOther = plate.selectedLocationValues == "Other"
        
        cell.locationValueButton.layer.borderColor = showError && locationEmpty ? UIColor.red.cgColor : defaultBorderColor
        cell.sampleDescriptionButton.layer.borderColor = showError && sampleDescriptionEmpty && isOther ? UIColor.red.cgColor : defaultBorderColor
    }
    
    private func configureLineView(for cell: EnviromentalSampleInfoCell, at indexPath: IndexPath) {
        let isLast = indexPath.row == currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated.count - 1
        cell.lineBetweenCellsView.isHidden = isLast
        cell.lineBetweenCellsViewHeight.constant = isLast ? 0 : 1
    }
    private func configureLineViewForReadOnly(for cell: EnviromentalSampleInfoCell, at indexPath: IndexPath) {
        
        let isLast = indexPath.row == (microbialSelectedPlatesData[indexPath.section - 1].microbialSamplePlates?.count ?? 0) - 1
        cell.lineBetweenCellsView.isHidden = isLast
        cell.lineBetweenCellsViewHeight.constant = isLast ? 0 : 1
    }
    @objc func addInfoPopup(PlateID : String) {
        showtoast(message: PlateID)
    }
    
    //MARK: - Mandatory Fields Validation for Header
    func mandatoryFieldValidationForHeader(_ view: EnviromentalLocationHeaderView, section: Int) {
        if self.currentRequisition.actualCreatedHeaders[view.tag].isPlusButtonPressed &&
            self.currentRequisition.actualCreatedHeaders[view.tag].selectedLocationType == "Select location type" {
            view.locationTypeButton.layer.borderColor = UIColor.red.cgColor
        } else {
            view.locationTypeButton.layer.borderColor = defaultBorderColor
        }
        
        if self.currentRequisition.actualCreatedHeaders[view.tag].isPlusButtonPressed &&
            self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates == 0 {
            view.noOfPlatesButton.layer.borderColor = UIColor.red.cgColor
        } else {
            view.noOfPlatesButton.layer.borderColor = defaultBorderColor
        }
    }
    
    //MARK: - Set Up Header View
    fileprivate func setUpHeaderView(_ headerView: EnviromentalLocationHeaderView, _ section: Int) {
        headerView.addLocationButton.isHidden = section == 1 ? false : true
        headerView.generatePlateIdButton.isHidden = true
        headerView.deleteLocationButton.isHidden = section == 1 ? false : true
        headerView.btnsStackView.isHidden = section == 1 ? false : true
        headerView.btnStd40.isHidden = section == 1 ? false : true
        headerView.btnStd20.isHidden = section == 1 ? false : true
        headerView.sampleInfoTitleContainerView.isHidden = section == 1 ? false : true
        headerView.sampleInfoTitleLabel.isHidden = section == 1 ? false : true
        
        headerView.sampleInfoTitleContainerViewHeight.constant = section == 1 ? 60 : 0
        headerView.sampleInfoTitleContainerViewTop.constant = section == 1 ? 34 : 15
        
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            headerView.locationTypeTextField.text = microbialSelectedPlatesData[section - 1].locType

            headerView.noOfPlatesTextField.text = String(microbialSelectedPlatesData[section - 1].noOfPlates ?? 0)
            if self.microbialSelectedPlatesData[section - 1].isHeaderIsCollapsed {
                headerView.collapsableButton.setImage(UIImage(named: "expand_view_icon"), for: .normal)
                headerView.platesTitleView.isHidden = true
                headerView.backgrounfView.isHidden = true
                headerView.locationTypeContainerViewHeight.constant = 68
                
            } else {
                headerView.collapsableButton.setImage(UIImage(named: "collapse_view_icon"), for: .normal)
                headerView.platesTitleView.isHidden = false
                headerView.backgrounfView.isHidden = false
                headerView.platesTitleView.isHidden = !(self.microbialSelectedPlatesData[section - 1].noOfPlates ?? 0 > 0)
                headerView.locationTypeContainerViewHeight.constant = 68
                
                if self.microbialSelectedPlatesData[section - 1].noOfPlates ?? 0 > 0 {
                    headerView.backgrounfView.isHidden = false
                } else {
                    headerView.backgrounfView.isHidden = true
                }
        }
       
        } else {
            if self.currentRequisition.actualCreatedHeaders[section - 1].noOfPlates > 0 {
                headerView.noOfPlatesTextField.text = "\(self.currentRequisition.actualCreatedHeaders[section - 1].noOfPlates)"
            } else {
                headerView.noOfPlatesTextField.text = ""
            }
            headerView.locationTypeTextField.text = self.currentRequisition.actualCreatedHeaders[section - 1].selectedLocationType
            
            
            headerView.noOfPlatesTextField.isUserInteractionEnabled = !(self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0)
            headerView.locationTypeButton.isUserInteractionEnabled = !(self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0)
            
            
            if self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count == 200 {
                headerView.plusButton.isEnabled = false
            } else {
                headerView.plusButton.isEnabled = true
            }
            
            if self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count == 0 {
                headerView.minusButton.isEnabled = false
            } else {
                headerView.minusButton.isEnabled = true
            }
            
            if self.currentRequisition.actualCreatedHeaders[section - 1].ischeckBoxSelected {
                headerView.checkBoxButton.setImage(UIImage(named: "checkedIcon_new"), for: .normal)
            } else {
                headerView.checkBoxButton.setImage(UIImage(named: "uncheckIcon_new"), for: .normal)
            }
            
            if self.currentRequisition.actualCreatedHeaders[section - 1].isHeaderIsCollapsed {
                headerView.collapsableButton.setImage(UIImage(named: "expand_view_icon"), for: .normal)
                headerView.platesTitleView.isHidden = true
                headerView.backgrounfView.isHidden = true
                headerView.locationTypeContainerViewHeight.constant = 68
                
            } else {
                headerView.collapsableButton.setImage(UIImage(named: "collapse_view_icon"), for: .normal)
                headerView.platesTitleView.isHidden = false
                headerView.backgrounfView.isHidden = false
                headerView.platesTitleView.isHidden = !(self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0)
                headerView.locationTypeContainerViewHeight.constant = 68
                
                if self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0 {
                    headerView.backgrounfView.isHidden = false
                } else {
                    headerView.backgrounfView.isHidden = true
                }
        }
           
        
        
        
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EnviromentalLocationHeaderView" ) as! EnviromentalLocationHeaderView
            headerView.delegate = self
            headerView.noOfPlatesTextField.keyboardType = .numberPad
            headerView.noOfPlatesTextField.delegate = headerView
            headerView.locationTypeButton.tag = section - 1
            headerView.tag = section - 1
            headerView.noOfPlatesTextField.placeholder = "0"
            headerView.btnStd40.isEnabled = !(self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0)
            headerView.btnStd40.alpha = (self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0) ? 0.5 : 1.0
            headerView.btnStd20.isEnabled = !(self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0)
            headerView.btnStd20.alpha = (self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0) ? 0.5 : 1.0
            headerView.btnStd.isEnabled = !(self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0)
            headerView.btnStd.alpha = (self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0) ? 0.5 : 1.0
            
            if self.currentRequisition.actualCreatedHeaders.count == 1 {
                headerView.deleteLocationButton.isEnabled = false
                self.deleteBtn.isEnabled = false
                headerView.checkBoxButton.isEnabled = false
            } else {
                headerView.deleteLocationButton.isEnabled = true
                self.deleteBtn.isEnabled = true
                headerView.checkBoxButton.isEnabled = true
            }
            
            if self.currentRequisitionType == .enviromental {
                headerView.btnStd.isHidden = false
            }else{
                headerView.btnStd.isHidden = true
            }
            
            self.setUpHeaderView(headerView, section)
            
            if requisitionSavedSessionType != .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                self.mandatoryFieldValidationForHeader(headerView, section: section - 1)

            }
            self.enableDisableButtonsOnGeneratingPlateId(headerView: headerView)
            self.disableAllEventsOnHeader(headerView: headerView)
            headerView.btnStd40.isHidden = (self.currentRequisitionType == .enviromental)
            headerView.btnStd20.isHidden = (self.currentRequisitionType == .enviromental)
            
            return headerView
        }
    }
    
    
    func enableDisableButtonsOnGeneratingPlateId(headerView: EnviromentalLocationHeaderView){
        headerView.generatePlateIdButton.isEnabled = (self.currentRequisition.actualCreatedHeaders[0].numberOfPlateIDCreated.count > 0) && !self.currentRequisition.isPlateIdGenerated
        if self.currentRequisition.isPlateIdGenerated{
            headerView.addLocationButton.isEnabled = false
            headerView.deleteLocationButton.isEnabled = true
            self.deleteBtn.isEnabled = true
            headerView.plusButton.isEnabled = false
            headerView.minusButton.isEnabled = false
            headerView.locationTypeButton.isEnabled = false
        }else{
            headerView.addLocationButton.isEnabled = true
            headerView.deleteLocationButton.isEnabled = self.isCheckBoxSelectedInOfPlatesHeaders()
            self.deleteBtn.isEnabled = self.isCheckBoxSelectedInOfPlatesHeaders()
            headerView.plusButton.isEnabled = true
            headerView.minusButton.isEnabled = true
            headerView.locationTypeButton.isEnabled = true
        }
    }
    
    
    func isCheckBoxSelectedInOfPlatesHeaders() -> Bool{
        for plateHeader in self.currentRequisition.actualCreatedHeaders{
            if plateHeader.ischeckBoxSelected{
                return true
            }
        }
        return false
    }
    
    func disableAllEventsOnHeader(headerView: EnviromentalLocationHeaderView){
        switch requisitionSavedSessionType {
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            headerView.noOfPlatesTextField.isUserInteractionEnabled = false
            headerView.locationTypeButton.isEnabled = false
            headerView.locationTypeButton.isEnabled = false
            headerView.noOfPlatesButton.isEnabled = false
            headerView.checkBoxButton.isEnabled = false
            headerView.addLocationButton.isEnabled = false
            headerView.plusButton.isEnabled = false
            headerView.minusButton.isEnabled = false
            headerView.deleteLocationButton.isEnabled = false
            self.deleteBtn.isEnabled = false
            headerView.generatePlateIdButton.isEnabled = false
            headerView.btnStd20.isEnabled = false
            headerView.btnStd40.isEnabled = false
            headerView.btnStd.isEnabled = false
            
        default: break
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch self.currentRequisition.requisitionType {
            case .bacterial:
                return 480
            case .enviromental:
                return 560
            default:
                return 610
            }
        default:
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.001
            
        case 1:
            if requisitionSavedSessionType != .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                
                if self.currentRequisition.actualCreatedHeaders[section - 1].isHeaderIsCollapsed {
                    return 149
                }
                
                if self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0 {
                    return 195
                } else {
                    return 180
                }
            } else {
                if self.microbialSelectedPlatesData[section - 1].isHeaderIsCollapsed {
                    return 149
                }
                
                if self.microbialSelectedPlatesData[section - 1].noOfPlates ?? 0 > 0 {
                    return 195
                } else {
                    return 180
                }
            }
            
        default:
            if requisitionSavedSessionType != .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
                if self.currentRequisition.actualCreatedHeaders[section - 1].isHeaderIsCollapsed {
                    if (self.currentRequisition.actualCreatedHeaders.count - 1) == (section - 1) {
                        return 80
                    }
                    return 70
                }
                
                if self.currentRequisition.actualCreatedHeaders[section - 1].numberOfPlateIDCreated.count > 0 {
                    return 115
                } else {
                    return 70
                }
            }else {
                if self.microbialSelectedPlatesData[section - 1].isHeaderIsCollapsed {
                    if (self.microbialSelectedPlatesData.count - 1) == (section - 1) {
                        return 80
                    }
                    return 70
                }
                if self.microbialSelectedPlatesData[section - 1].noOfPlates ?? 0  > 0 {
                    return 115
                } else {
                    return 70
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}


//MARK: - Enviromental Form Cell Delegates
extension EnviromentalSurveyController: EnviromentalFormCellDelegates {
    
    func emailEntered(cell: EnviromentalFormCell, activeTextField: UITextField) {
        print(activeTextField.text ?? "Not working")
        if activeTextField == cell.emailIdTextField {
            let email = activeTextField.text ?? ""
            let arrayOfEmail = email.components(separatedBy: ",")
            self.currentRequisition.email = email
            for item in arrayOfEmail {
                guard item.isValidEmail() else {
                    if email.isEmpty {
                        cell.emailButton.layer.borderColor = defaultBorderColor
                    } else {
                        cell.emailButton.layer.borderColor = UIColor.red.cgColor
                    }
                    return
                }
            }
            
            cell.emailButton.layer.borderColor = defaultBorderColor
        }
        
        if activeTextField == cell.barcodeTextField {
            self.currentRequisition.barCodeManualEntered = activeTextField.text ?? ""
            self.currentRequisition.barCode = activeTextField.text ?? ""
        }
        if requisitionSavedSessionType != .SHOW_DRAFT_FOR_EDITING{
            self.currentRequisition.saveCaseInfoCurrentSessionDataInToDB()
        }
        self.currentRequisition.updateNewBarcodeEditted()
        self.reloadTableView()
    }
    
    func noteEntered(cell: EnviromentalFormCell, activeTextView: UITextView) {
        if let text = activeTextView.text {
            self.currentRequisition.notes = text
        }
        self.currentRequisition.saveCaseInfoCurrentSessionDataInToDB()
    }
    
    func reasonForVisitButtonPressed(_ cell: EnviromentalFormCell) {
        let reasonForVisitObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes")
        let reasonsForVisit = reasonForVisitObjectArray.value(forKey: "text")  as? [String] ?? []
        setDropdrown(cell.reasonForVisitButton, clickedField: Constants.ClickedFieldMicrobialSurvey.reasonForVisit, dropDownArr: reasonsForVisit, cell: cell)
    }
    
    func sampleCollectedPressed(_ cell: EnviromentalFormCell) {
        self.setDropdrown(cell.sampleCollectedByButton, clickedField: Constants.ClickedFieldMicrobialSurvey.SampleCollectedBy, dropDownArr: [userLogedIn], cell: cell)
    }
    
    func companyButtonPressed(_ cell: EnviromentalFormCell) {
        let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
        let customerNamesArray  = customerDetailsArray.value(forKey: "customerName") as? [String] ?? []
        self.setDropdrown(cell.companyButton, clickedField: Constants.ClickedFieldMicrobialSurvey.company, dropDownArr: customerNamesArray, cell: cell)
    }
    
    func siteButtonPressed(_ cell: EnviromentalFormCell) {
        guard !self.currentRequisition.company.isEmpty else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please select company first.")
            return
        }
        let sitesObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_siteByCustomer", customerId: self.currentRequisition.companyId)
        let sitesArray = sitesObjectArray.value(forKey: "siteName") as? [String] ?? []
        
        if sitesArray.count == 0 {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "There are no sites for selected company")
            return
        }
        
        self.currentRequisition.barCodeManualEntered = ""
        self.setDropdrown(cell.siteButton, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId, dropDownArr: sitesArray, cell: cell)
    }
    
    func reviewerButtonPressed(_ cell: EnviromentalFormCell) {
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.presentReviewerController()
    }
    
    func surveyConductedButtonPressed(_ cell: EnviromentalFormCell) {
        let surveyConductOnDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllConductType")
        let surveyConductOnArray = surveyConductOnDetailsArray.value(forKey: "text") as? [String] ?? []
        self.setDropdrown(cell.surveyConductedButton, clickedField: Constants.ClickedFieldMicrobialSurvey.surveyCondustedOn, dropDownArr: surveyConductOnArray, cell: cell)
    }
    
    func sampleDateButtonPressed(_ cell: EnviromentalFormCell) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.canSelectPreviousDate = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    func purposeOfSurveyButtonPressed(_ cell: EnviromentalFormCell) {
        let allSurveyPurposDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllSurveyPurpose")
        let allSurveyPurposeArray = allSurveyPurposDetailsArray.value(forKey: "text") as? [String] ?? []
        self.setDropdrown(cell.purposeOfSurveyButton, clickedField: Constants.ClickedFieldMicrobialSurvey.purposeOfSurvey, dropDownArr: allSurveyPurposeArray, cell: cell)
    }
    
    func transferInButtonPressed(_ cell: EnviromentalFormCell) {
        let microbialTransferTypesDetailArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialTransferTypes")
        let microbialTransferTypesArray = microbialTransferTypesDetailArray.value(forKey: "text") as? [String] ?? []
        self.setDropdrown(cell.transferInButton, clickedField: Constants.ClickedFieldMicrobialSurvey.transferIn, dropDownArr: microbialTransferTypesArray, cell: cell)
    }
    
    //MARK: - Drop down View load
    
    func getLocationValuesOnType(locationTypeId: Int){
        
        let locationValues =  self.currentRequisition.getAllLocationValuesFor(locationTypeId: locationTypeId).locationValues
        dataFiltered = locationValues
        data = locationValues
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        dropButton.dataSource.removeAll()
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        dropButton.dataSource = dataFiltered as [AnyObject]
        
        let cell = searchBar.superview?.superview?.superview?.superview as! EnviromentalSampleInfoCell
        self.setDropdrown(cell.locationValueButton, clickedField: Constants.ClickedFieldMicrobialSurvey.locationValue, dropDownArr: dataFiltered, cell: cell)
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        var selectedIndex = 0
        var superview = searchBar.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        
        if let cell = superview as? UITableViewCell,let indexPath = tableView.indexPath(for: cell) {
            selectedIndex = indexPath.section-1
        }
        
        if requisitionSavedSessionType == .SHOW_DRAFT_FOR_EDITING {
            let idOfSelectedLocationTypeIs = self.currentRequisition.actualCreatedHeaders[selectedIndex].selectedLocationTypeId ?? 0
            self.getLocationValuesOnType(locationTypeId: idOfSelectedLocationTypeIs)
        } else {
            let idOfSelectedLocationTypeIs = currentRequisition.selectedLocationTypes[selectedIndex]
            self.getLocationValuesOnType(locationTypeId: idOfSelectedLocationTypeIs)
        }
        
        Constants.cell = searchBar.superview?.superview?.superview?.superview as! EnviromentalSampleInfoCell
        
        for ob: UIView in (searchBar.subviews[0]).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // searchBar.text = ""
        dataFiltered = data
        dropButton.hide()
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    
    
    
    
    
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?, cell: UITableViewCell? = nil, view: UIView? = nil){
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal, index  in
                self.dropHiddenAndShow()
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField, cell: cell, view: view)
            }
            self.dropHiddenAndShow()
        }
    }
    
    fileprivate func populateSelectedValueVisitIdEnviromentalFormCell(_ cell: EnviromentalFormCell, _ selectedValue: String) {
        cell.reasonForVisitTextField.text = selectedValue
        self.currentRequisition.reasonForVisit = selectedValue
        self.currentRequisition.reasonForVisitId = self.currentRequisition.getReasonForVisitId()
    }
    
    fileprivate func populateSelectedValueVisitIdBacterialFormCell(_ cell: BacterialFormCell, _ selectedValue: String) {
        cell.reasonForVisitTextField.text = selectedValue
        self.currentRequisition.reasonForVisit = selectedValue
        self.currentRequisition.reasonForVisitId = self.currentRequisition.getReasonForVisitId()
    }
    
    
    func setValueInTextFields(selectedValue: String, selectedIndex: Int, clickedField: String, cell: UITableViewCell?, view: UIView? = nil) {
        switch clickedField {
        case Constants.ClickedFieldMicrobialSurvey.reasonForVisit:
            handleReasonForVisit(selectedValue, cell)
            
        case Constants.ClickedFieldMicrobialSurvey.SampleCollectedBy:
            if let cell = cell as? EnviromentalFormCell {
                cell.sampleCollectedByText.text = selectedValue
                currentRequisition.sampleCollectedBy = selectedValue
            }
            
        case Constants.ClickedFieldMicrobialSurvey.company:
            handleCompanySelection(selectedValue, cell: cell)
            
        case Constants.ClickedFieldMicrobialSurvey.siteId:
            handleSiteSelection(selectedValue, cell)
            
        case Constants.ClickedFieldMicrobialSurvey.reviewer:
            currentRequisition.reviewer = selectedValue
            currentRequisition.reviewerId = currentRequisition.getReviewerId()
            
        case Constants.ClickedFieldMicrobialSurvey.surveyCondustedOn:
            if let cell = cell as? EnviromentalFormCell {
                cell.surveyConductedTextField.text = selectedValue
                currentRequisition.surveyConductedOn = selectedValue
                currentRequisition.surveyConductedOnId = currentRequisition.getSurveyConductedOnId()
            }
            
        case Constants.ClickedFieldMicrobialSurvey.purposeOfSurvey:
            if let cell = cell as? EnviromentalFormCell {
                cell.purposeOfSurveyTextField.text = selectedValue
                currentRequisition.purposeOfSurvey = selectedValue
                currentRequisition.purposeOfSurveyId = currentRequisition.getPurposeOfSurveyId()
            }
            
        case Constants.ClickedFieldMicrobialSurvey.transferIn:
            if let cell = cell as? EnviromentalFormCell {
                cell.transferInTextField.text = selectedValue
                currentRequisition.transferIn = selectedValue
            }
            
        case Constants.ClickedFieldMicrobialSurvey.locationType:
            handleLocationTypeSelection(selectedValue, selectedIndex, view)
            
        case Constants.ClickedFieldMicrobialSurvey.locationValue:
            updateSampleInfoCell(selectedValue, selectedIndex, cell, fieldType: .location)
            
        case Constants.ClickedFieldMicrobialSurvey.mediaType:
            updateSampleInfoCell(selectedValue, selectedIndex, cell, fieldType: .media)
            
        case Constants.ClickedFieldMicrobialSurvey.sampling:
            updateSampleInfoCell(selectedValue, selectedIndex, cell, fieldType: .sampling)
            
        default:
            break
        }
        
        saveCurrentDataInLocalDB(isFinalSubmit: false)
        reloadTableView()
    }
    
    
    private func handleReasonForVisit(_ selectedValue: String, _ cell: UITableViewCell?) {
        if let cell = cell as? EnviromentalFormCell {
            populateSelectedValueVisitIdEnviromentalFormCell(cell, selectedValue)
        } else if let cell = cell as? BacterialFormCell {
            populateSelectedValueVisitIdBacterialFormCell(cell, selectedValue)
        }
    }
    
    private func handleCompanySelection(_ selectedValue: String, cell: UITableViewCell?) {
        
        if let envFormCell = cell as? EnviromentalFormCell {
            envFormCell.companyTextField.text = selectedValue
        } else if let bacFormCell = cell as? BacterialFormCell {
            bacFormCell.companyTextField.text = selectedValue
        }
        
        if currentRequisition.company != selectedValue {
            currentRequisition.resetSiteAndBarCode()
        }
        
        isSubmitButtonPressed = false
        currentRequisition.company = selectedValue
        currentRequisition.companyId = currentRequisition.getCompanyIdforSelectedCompany()
    }
    
    private func handleSiteSelection(_ selectedValue: String, _ cell: UITableViewCell?) {
        if let cell = cell as? EnviromentalFormCell {
            cell.siteTextField.text = selectedValue
        } else if let bcell = cell as? BacterialFormCell {
            bcell.siteTextField.text = selectedValue
        }
        currentRequisition.site = selectedValue
        currentRequisition.siteId = currentRequisition.getSiteIdforSelectedSite()
        currentRequisition.generatebarCode()
    }
    
    private func handleLocationTypeSelection(_ selectedValue: String, _ selectedIndex: Int, _ view: UIView?) {
        guard let headerView = view as? EnviromentalLocationHeaderView else { return }
        headerView.locationTypeTextField.text = selectedValue
        currentRequisition.actualCreatedHeaders[headerView.tag].selectedLocationType = selectedValue
        currentRequisition.actualCreatedHeaders[headerView.tag].selectedLocationTypeId = currentRequisition.getAllLocationTypes().locationTypeIds[selectedIndex]
    }
    
    private enum SampleFieldType {
        case location, media, sampling
    }
    
    private func updateSampleInfoCell(_ selectedValue: String, _ selectedIndex: Int, _ cell: UITableViewCell?, fieldType: SampleFieldType) {
        guard let cell = cell as? EnviromentalSampleInfoCell,
              let indexPath = tableView.indexPath(for: cell)
        else { return }
        
        switch fieldType {
        case .location:
            cell.searchBarLocation.text = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].selectedLocationValues = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].selectedLocationValueId = currentRequisition.getLocationValues(selectedValue: selectedValue)
            
        case .media:
            cell.mediaTypeTextField.text = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].mediaTypeValue = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].selectedMediaTypeId = currentRequisition.getMediaTypeValues(selectedValue: selectedValue)
            
        case .sampling:
            cell.samplingTextField.text = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].samplingMethodTypeValue = selectedValue
            currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].samplingMethodTypeId = currentRequisition.getSamplingMethodTypeValues(selectedValue: selectedValue)
        }
    }
    
}


//MARK: - Enviromental Location HeaderView Delegates
extension EnviromentalSurveyController: EnviromentalLocationHeaderViewDelegates {
    
    fileprivate func updateCurrentRequisitionValidation(_ locationValues: [Microbial_LocationValues], _ templateType: EnviromentalSurveyController.STANDARD_TEMPLATE_TYPE, _ tempValue: Int, _ id: Int, _ fullIndex: inout Int) {
        
        let index = self.currentRequisition.actualCreatedHeaders.count - 1
        
        for lValue in locationValues {
            // let limit = (templateType == (tempValue == 0 ? .STD20 : .STD)) ? (tempValue == 0 ? lValue.rep20!.intValue : lValue.stnRep!.intValue) : lValue.rep40!.intValue
            
            let limit: Int
            if templateType == (tempValue == 0 ? .STD20 : .STD) {
                limit = (tempValue == 0) ? lValue.rep20!.intValue : lValue.stnRep!.intValue
            } else {
                limit = lValue.rep40!.intValue
            }
            
            
            
            for _ in 0..<limit {
                let plateCell = LocationTypeCellModel()
                let i = self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated.count
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated.append(plateCell)
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].isBacterialChecked = false
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].isMicoscoreChecked = true
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].selectedLocationTypeId = id
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].selectedLocationValues = lValue.text ?? ""
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].selectedLocationValueId = lValue.id?.intValue
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].mediaDefault = lValue.media ?? ""
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].mediaTypeValue = lValue.media ?? ""
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].selectedMediaTypeId = 1
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].samplingDefault = lValue.sampling ?? ""
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].samplingMethodTypeValue = lValue.sampling ?? ""
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].samplingMethodTypeId = 1
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].row = self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated.count - 1
                self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated[i].section = self.currentRequisition.actualCreatedHeaders.count
                self.currentRequisition.actualCreatedHeaders[index].noOfPlates = self.currentRequisition.actualCreatedHeaders[index].numberOfPlateIDCreated.count
                self.currentRequisition.actualCreatedHeaders[self.currentRequisition.actualCreatedHeaders.count - 1].numberOfPlateIDCreated[i].plateId = "\(self.currentRequisition.barCode)-\(fullIndex + 1)"
                fullIndex = fullIndex + 1
            }
        }
    }
    
    func setTemplateFor(templateType: STANDARD_TEMPLATE_TYPE) {
        self.currentRequisition.actualCreatedHeaders.removeAll()
        
        let locationTypeIds = self.currentRequisition.getAllLocationTypes().locationTypeIds
        let locationTypeNames = self.currentRequisition.getAllLocationTypes().locationTypes
        var fullIndex = 0
        for (id, name) in zip(locationTypeIds, locationTypeNames) {
            let locationHeader = LocationTypeHeaderModel()
            locationHeader.section = self.currentRequisition.actualCreatedHeaders.count + 1
            locationHeader.requisition_Id = self.currentRequisition.barCode
            locationHeader.selectedLocationTypeId = id
            locationHeader.selectedLocationType = name
            var locationValues = [Microbial_LocationValues]()
            var tempValue = 0
            if self.currentRequisition.requisitionType == .enviromental {
                locationValues = (templateType == .STD) ? self.currentRequisition.getAllLocationValuesWhichAreTrueForStd(locationTypeId: id) : self.currentRequisition.getAllLocationValuesWhichAreTrueForStd40(locationTypeId: id)
                tempValue = 1
            } else {
                locationValues = (templateType == .STD20) ? self.currentRequisition.getAllLocationValuesWhichAreTrueForStd20(locationTypeId: id) : self.currentRequisition.getAllLocationValuesWhichAreTrueForStd40(locationTypeId: id)
                tempValue = 0
            }
            var i = 0
            if locationValues.count > 0 {
                i = i + 1
                self.currentRequisition.actualCreatedHeaders.append(locationHeader)
                updateCurrentRequisitionValidation(locationValues, templateType, tempValue, id, &fullIndex)
            }
        }
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.reloadTableView()
    }
    
    func stdButtonPressed(_ view: EnviromentalLocationHeaderView) {
        guard self.isAllSampleInfoMandatoryFiledsFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.pleaseFillMandatoryFieldsStr)
            return
        }
        
        guard !self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted) else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
            return
        }
        self.setTemplateFor(templateType: .STD)
    }
    
    func std20ButtonPressed(_ view: EnviromentalLocationHeaderView) {
        guard self.isAllSampleInfoMandatoryFiledsFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.pleaseFillMandatoryFieldsStr)
            return
        }
        
        guard !self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted) else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
            return
        }
        self.setTemplateFor(templateType: .STD20)
    }
    
    func std40ButtonPressed(_ view: EnviromentalLocationHeaderView) {
        guard self.isAllSampleInfoMandatoryFiledsFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.pleaseFillMandatoryFieldsStr)
            return
        }
        guard !self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted) else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
            return
        }
        self.setTemplateFor(templateType: .STD40)
    }
    
    func generatePlateIdButtonPressed(_ view: EnviromentalLocationHeaderView) {
        guard self.isAllPlatesHaveLocationValue() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please select location value for all plates generated.")
            return
        }
        self.currentRequisition.isPlateIdGenerated = !self.currentRequisition.isPlateIdGenerated
        for i in 0..<self.currentRequisition.actualCreatedHeaders.count{
            self.currentRequisition.actualCreatedHeaders[i].ischeckBoxSelected = true
        }
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.tableView.reloadData()
    }
    
    func generatePlateIndex() -> [String: Int]{
        let sections = tableView.numberOfSections
        var indexing = 0
        var dict : [String: Int] = [:]
        for sectionIndex in 0..<sections - 1{
            for rowIndex in 0..<self.currentRequisition.actualCreatedHeaders[sectionIndex].numberOfPlateIDCreated.count{
                if let id = self.currentRequisition.actualCreatedHeaders[sectionIndex].selectedLocationTypeId {
                    indexing = indexing + 1
                    dict["\(id) - \(sectionIndex + 1) - \(rowIndex + 1)"] = indexing
                }
            }
        }
        return dict
    }
    
    
    func textFieldDidEndEditingForHeader(_ view: EnviromentalLocationHeaderView, _ textField: UITextField) {
        if let text = textField.text, let intValue = Int(text) {
            self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates = intValue
            //            self.currentRequisition.saveLocationTypeHeaderCurrentSessionInfoInDB()
            self.saveCurrentDataInLocalDB(isFinalSubmit: false)
            self.reloadTableView()
        }
    }
    
    //MARK: - Add new header
    func addLocationButtonPressed(_ view: EnviromentalLocationHeaderView) {
        self.addLocation()
    }
    
    @IBAction func addLocationBtnAction(_ sender: UIButton) {
        self.addLocation()
    }
    
    
    func addLocation(){
        var isAllHeadersHasPlates = true
        for header in self.currentRequisition.actualCreatedHeaders {
            if header.numberOfPlateIDCreated.count == 0 {
                isAllHeadersHasPlates = false
            }
        }
        
        if isAllHeadersHasPlates {
            let locationHeader = LocationTypeHeaderModel()
            locationHeader.section = self.currentRequisition.actualCreatedHeaders.count + 1
            locationHeader.requisition_Id = self.currentRequisition.barCode
            self.currentRequisition.actualCreatedHeaders.append(locationHeader)
        } else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please click to Plus icon to add plates.")
            return
        }
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.reloadTableView()
    }
    
    //MARK: - Delete selected header
    func deleteLocationButtonPressed(_ view: EnviromentalLocationHeaderView) {
        self.deleteLocationButton()
    }
    
    @IBAction func deletebtnAction(_ sender: UIButton) {
        self.deleteLocationButton()
    }
    
    fileprivate func handleRequisitionSavedSessionTypeShowDraftForEditting(_ checkedHeadersIndex: [Int]) {
        if self.requisitionSavedSessionType == .SHOW_DRAFT_FOR_EDITING {
            for index in checkedHeadersIndex {
                self.currentRequisition.deletePlateHeader(locationHeader: self.currentRequisition.actualCreatedHeaders[index])
            }
            self.currentRequisition.actualCreatedHeaders.remove(at: checkedHeadersIndex)
            
            self.currentRequisition.reArrangeSectionOfHeaders()
        } else {
            self.currentRequisition.actualCreatedHeaders.remove(at: checkedHeadersIndex)
            self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        }
    }
    
    func deleteLocationButton() {
        if !currentRequisition.isPlateIdGenerated {
            guard self.currentRequisition.actualCreatedHeaders.count > 1 else {
                Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "You can't delete all the locations.")
                return
            }
        }
        for header in self.currentRequisition.actualCreatedHeaders {
            if header.ischeckBoxSelected == false {
                break
            }
        }
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            var checkedHeadersIndex = [Int]()
            for (index, header) in self.currentRequisition.actualCreatedHeaders.enumerated() {
                if header.ischeckBoxSelected {
                    checkedHeadersIndex.append(index)
                }
            }
            
            self.handleRequisitionSavedSessionTypeShowDraftForEditting(checkedHeadersIndex)
            
            if self.currentRequisition.actualCreatedHeaders.count == 0 {
                self.submitButton.setImage(UIImage(named: "BacterialSubmitImg"), for: .normal)
                self.submitButton.backgroundColor = UIColor.clear
                self.currentRequisition.generateHeader()
                self.currentRequisition.isPlateIdGenerated = false
                self.saveCurrentDataInLocalDB(isFinalSubmit: false)
            }
            self.configureRequisitionAsPerSavedSessionType()
            self.reloadTableView()
        }))
        self.present(alert, animated: true)
    }
    
    //MARK: - Select header
    func checkBoxButtonPressed(_ view: EnviromentalLocationHeaderView) {
        self.currentRequisition.actualCreatedHeaders[view.tag].ischeckBoxSelected = !self.currentRequisition.actualCreatedHeaders[view.tag].ischeckBoxSelected
        if self.currentRequisition.actualCreatedHeaders[view.tag].ischeckBoxSelected {
            view.checkBoxButton.setImage(UIImage(named: "checkedIcon_new"), for: .normal)
        } else {
            view.checkBoxButton.setImage(UIImage(named: "uncheckIcon_new"), for: .normal)
        }
        //self.currentRequisition.saveLocationTypeHeaderCurrentSessionInfoInDB()
        self.reloadTableView()
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
    }
    
    func locationTypeButtonPressed(_ view: EnviromentalLocationHeaderView) {
        let microbialTransferTypesArray = self.currentRequisition.getAllLocationTypes().locationTypes
        self.setDropdrown(view.locationTypeButton, clickedField: Constants.ClickedFieldMicrobialSurvey.locationType, dropDownArr: microbialTransferTypesArray, cell: nil, view: view)
    }
    
    //MARK: - Plus button action
    func plusButtonPressed(_ view: EnviromentalLocationHeaderView) {
        self.view.endEditing(true)
        if ((requisitionSavedSessionType == .CREATE_NEW_SESSION) || (requisitionSavedSessionType == .RESTORE_OLD_SESSION)){
            guard !self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .submitted) else {
                Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
                return
            }
        }
        
        self.currentRequisition.actualCreatedHeaders[view.tag].isPlusButtonPressed = true
        
        guard self.isAllSampleInfoMandatoryFiledsFilled() else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.pleaseFillMandatoryFieldsStr)
            return
        }
        
        guard self.currentRequisition.barCode != "E-" else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Invalid Barcode")
            return
        }
        
        guard let selectedLocationType = view.locationTypeTextField.text,
              selectedLocationType != "Select location type" else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please select location type.")
            self.reloadTableView()
            return
        }
        self.isSubmitButtonPressed = false
        let noOfPlates = self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates
        guard noOfPlates > 0 else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please enter number of plates.")
            self.reloadTableView()
            return
        }
        
        guard noOfPlates <= 200  else {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Number of plates exceeding 200.")
            return
        }
        
        let totalPlatesInHeader = self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.count
        if totalPlatesInHeader > 0 {
            let plateCell = LocationTypeCellModel()
            self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates += 1
            plateCell.row = totalPlatesInHeader //(plateCell.row ?? 0) + 1
            plateCell.section = view.tag
            plateCell.selectedLocationTypeId = self.currentRequisition.actualCreatedHeaders[view.tag].selectedLocationTypeId
            self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.append(plateCell)
        } else {
            for i in 0..<noOfPlates {
                let plateCell = LocationTypeCellModel()
                plateCell.row = i
                plateCell.section = view.tag
                plateCell.selectedLocationTypeId = self.currentRequisition.actualCreatedHeaders[view.tag].selectedLocationTypeId
                self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.append(plateCell)
            }
        }
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.reloadTableView()
    }
    
    //MARK: - Minus button action
    func minusButtonPressed(_ view: EnviromentalLocationHeaderView) {
        if  self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.count > 0 {
            //self.currentRequisition.saveLocationTypePlatesCurrentSessionInfoInToDB()
            self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates -= 1
            if let dataToDelete = self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.last{
                if requisitionSavedSessionType == .SHOW_DRAFT_FOR_EDITING{
                    self.currentRequisition.deletePlates(data: dataToDelete, locationId: self.currentRequisition.actualCreatedHeaders[view.tag].selectedLocationTypeId ?? 0, numberOfPlates: self.currentRequisition.actualCreatedHeaders[view.tag].noOfPlates)
                } else {
                    self.saveCurrentDataInLocalDB(isFinalSubmit: false)
                }
                self.currentRequisition.actualCreatedHeaders[view.tag].numberOfPlateIDCreated.removeLast()
            }
        }
        self.reloadTableView()
    }
    
    func collapsableButtonPressed(_ view: EnviromentalLocationHeaderView) {

        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            self.microbialSelectedPlatesData[view.tag].isHeaderIsCollapsed =  !self.microbialSelectedPlatesData[view.tag].isHeaderIsCollapsed
        } else {
            self.currentRequisition.actualCreatedHeaders[view.tag].isHeaderIsCollapsed = !self.currentRequisition.actualCreatedHeaders[view.tag].isHeaderIsCollapsed
        }
        
        self.reloadTableView()
        self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: view.tag + 1), at: .top, animated: true)        
    }
    
    func reloadTableView() {
        UIView.performWithoutAnimation {
            tableView.reloadData()
        }
    }
}

//MARK: - Enviromental Sample Info Cell Delegate
extension EnviromentalSurveyController: EnviromentalSampleInfoCellDelegate {
    
    func notesButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        notesIndexPath = indexPath
        notesView.frame = self.view.bounds
        
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY{
            notesTextView.text = self.microbialSelectedPlatesData[indexPath.section - 1].microbialSamplePlates?[indexPath.row].notes
            //   self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isSelectedNote = true
            notesTextView.isEditable = false
        }
        else{
            notesTextView.isEditable = true
            if self.currentRequisition.actualCreatedHeaders.count > 1 {
                notesTextView.text = self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].notes
                self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isSelectedNote = true
            }
        }
        view.addSubview(notesView)
    }
    
    func mediaTypeButtonPressed(_ cell: EnviromentalSampleInfoCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        if self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].selectedLocationTypeId != nil {
            let locationValues =  self.currentRequisition.getMediaTypes()
            
            self.setDropdrown(cell.mediaTypeButton, clickedField: Constants.ClickedFieldMicrobialSurvey.mediaType, dropDownArr: locationValues, cell: cell)
        }
    }
    func samplingTypeButtonPressed(_ cell: EnviromentalSampleInfoCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        if self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].selectedLocationTypeId != nil {
            let locationValues =  self.currentRequisition.getSamplingTypes()
            
            self.setDropdrown(cell.samplingTypeButton, clickedField: Constants.ClickedFieldMicrobialSurvey.sampling, dropDownArr: locationValues, cell: cell)
        }
    }
    
    func locationValueButtonPressed(_ cell: EnviromentalSampleInfoCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        if let locationTypeId = self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].selectedLocationTypeId {
            var locationValues =  self.currentRequisition.getAllLocationValuesFor(locationTypeId: locationTypeId).locationValues
            if !locationValues.contains("Other") {
                locationValues.append("Other")
            }
            self.setDropdrown(cell.locationValueButton, clickedField: Constants.ClickedFieldMicrobialSurvey.locationValue, dropDownArr: locationValues, cell: cell)
        }
    }
    
    func textFieldDidEndEditing(_ cell: EnviromentalSampleInfoCell, _ activeTextField: UITextField) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        guard let sampleDescription = activeTextField.text else {
            return
        }
            self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].sampleDescription = sampleDescription
            //self.currentRequisition.saveLocationTypePlatesCurrentSessionInfoInToDB()
            self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        
    }
    
    func bacterialCheckBoxButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        if requisitionSavedSessionType != .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            if self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isBacterialChecked {
                sender.setImage(UIImage(named: "uncheckIcon"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "checkIcon"), for: .normal)
            }
            
            self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isBacterialChecked = !self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isBacterialChecked
            //self.currentRequisition.saveLocationTypePlatesCurrentSessionInfoInToDB()
            self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        }
    }
    
    func micoscoreCheckBoxButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        if self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isMicoscoreChecked {
            sender.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "checkIcon"), for: .normal)
        }
        
        self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isMicoscoreChecked = !self.currentRequisition.actualCreatedHeaders[indexPath.section - 1].numberOfPlateIDCreated[indexPath.row].isMicoscoreChecked
        //self.currentRequisition.saveLocationTypePlatesCurrentSessionInfoInToDB()
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
    }
}

//MARK: - Date picker Delegate
extension EnviromentalSurveyController: DatePickerPopupViewControllerProtocol {
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        self.currentRequisition.sampleCollectionDate = string
        self.currentRequisition.generatebarCode()
        //        self.currentRequisition.updateNewBarcodeEditted()
        //        self.currentRequisition.saveCaseInfoCurrentSessionDataInToDB()
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.reloadTableView()
    }
    
    func doneButtonTapped(string: String) {
        self.currentRequisition.sampleCollectionDate = string
        self.reloadTableView()
    }
}

//MARK: - For bacterial Form cell Delegate
extension EnviromentalSurveyController: BacterialFormCellDelegates {
    
    func reasonForVisitButtonPressed_Bacterial(_ cell: BacterialFormCell) {
        let reasonForVisitObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_AllMicrobialVisitTypes")
        let reasonsForVisit = reasonForVisitObjectArray.value(forKey: "text")  as? [String] ?? []
        setDropdrown(cell.reasonForVisitButton, clickedField: Constants.ClickedFieldMicrobialSurvey.reasonForVisit, dropDownArr: reasonsForVisit, cell: cell)
    }
    
    func companyButtonPressed_Bacterial(_ cell: BacterialFormCell) {
        let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
        let customerNamesArray  = customerDetailsArray.value(forKey: "customerName") as? [String] ?? []
        self.setDropdrown(cell.companyButton, clickedField: Constants.ClickedFieldMicrobialSurvey.company, dropDownArr: customerNamesArray, cell: cell)
    }
    
    func siteButtonPressed_Bacterial(_ cell: BacterialFormCell) {
        guard !self.currentRequisition.company.isEmpty else {
            self.reloadTableView()
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "Please select company first.")
            return
        }
        let sitesObjectArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_siteByCustomer", customerId: self.currentRequisition.companyId)
        let sitesArray = sitesObjectArray.value(forKey: "siteName") as? [String] ?? []
        
        if sitesArray.count == 0 {
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "There are no sites for selected company")
            return
        }
        
        self.currentRequisition.barCodeManualEntered = ""
        self.setDropdrown(cell.siteButton, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId, dropDownArr: sitesArray, cell: cell)
    }
    
    func reviewerButtonPressed_Bacterial(_ cell: BacterialFormCell) {
        self.saveCurrentDataInLocalDB(isFinalSubmit: false)
        self.presentReviewerController()
    }
    
    private func presentReviewerController() {
        let obj = ReviewerViewController(nibName: "ReviewerViewController", bundle: nil)
        obj.definesPresentationContext = true
        obj.providesPresentationContextTransitionStyle = true
        obj.view.backgroundColor = UIColor.clear
        obj.modalPresentationStyle = .overCurrentContext
        obj.cancelAction = { sender in
            let selectedReviewer = self.reviewerDetails.filter{ $0.isSelected?.boolValue == true }
            self.currentRequisition.reviewer =  ""
            if selectedReviewer.count > 0 {
                self.currentRequisition.reviewer = selectedReviewer[0].reviewerName ?? ""
            }
            
            if selectedReviewer.count > 1 {
                for i in 1..<selectedReviewer.count{
                    self.currentRequisition.reviewer = "\(self.currentRequisition.reviewer), \(selectedReviewer[i].reviewerName ?? "")"
                }
            }
            self.dismiss(animated: false, completion: {
                self.saveCurrentDataInLocalDB(isFinalSubmit: false)
                self.reloadTableView()
                
            })
        }
        
        obj.doneAction = { sender in
            let selectedReviewer = self.reviewerDetails.filter{ $0.isSelected?.boolValue == true }
            self.currentRequisition.reviewer =  ""
            if selectedReviewer.count > 0 {
                self.currentRequisition.reviewer = selectedReviewer[0].reviewerName ?? ""
            }
            
            if selectedReviewer.count > 1 {
                for i in 1..<selectedReviewer.count {
                    self.currentRequisition.reviewer = "\(self.currentRequisition.reviewer), \(selectedReviewer[i].reviewerName ?? "")"
                }
            }
            self.dismiss(animated: false, completion: {
                self.saveCurrentDataInLocalDB(isFinalSubmit: false)
                self.reloadTableView()
                
            })
        }
        
        obj.reviewerIdSelected = { reviewer in
            //update bool value
            self.updateBoolValueOfReviewer(reviewerData: reviewer)
            self.refreshReviewerData()
            obj.reviewerDetails = self.reviewerDetails
        }
        self.refreshReviewerData()
        obj.reviewerDetails = self.reviewerDetails
        self.present(obj, animated: false) {
            print("presented")
        }
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
    
    func sampleDateButtonPressed_Bacterial(_ cell: BacterialFormCell) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.canSelectPreviousDate = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    func barcode_bacterial(cell: BacterialFormCell, activeTextField: UITextField) {
        if activeTextField == cell.barcodeTextField {
            self.currentRequisition.barCodeManualEntered = activeTextField.text ?? ""
            self.currentRequisition.barCode = activeTextField.text ?? ""
        }
        if requisitionSavedSessionType != .SHOW_DRAFT_FOR_EDITING{
            self.currentRequisition.saveCaseInfoCurrentSessionDataInToDB()
        }
        self.currentRequisition.updateNewBarcodeEditted()
        self.reloadTableView()
    }
    
    func noteEntered_Bacterial(cell: BacterialFormCell, activeTextView: UITextView) {
        if let text = activeTextView.text {
            self.currentRequisition.notes = text
        }
    }
}


//MARK:- Update AND SAVE
extension EnviromentalSurveyController{
    
    // MARK: Start saving data - incase of only session
    func startSavingInSession(){
        switch self.currentRequisition.requisitionType {
        case .bacterial:
            if  !self.currentRequisition.company.isEmpty ||
                    !self.currentRequisition.site.isEmpty ||
                    self.currentRequisition.barCode != "B-" {
                self.saveCurrentSessionDataInToDB()
            }
            
        case .enviromental:
            if  !self.currentRequisition.company.isEmpty ||
                    !self.currentRequisition.site.isEmpty ||
                    self.currentRequisition.barCode != "E-" {
                self.saveCurrentSessionDataInToDB()
            }
            
        default:
            break
        }
    }
    
    //MARK: Configure data from view did load
    func configureRequisitionAsPerSavedSessionType(){
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION:
            let sessionprogresss = UserDefaults.standard.bool(forKey: "sessionprogresss")
            if sessionprogresss == true {
                self.currentRequisition.configureDataIfSessionInProgress()
                print(self.currentRequisition.isPlateIdGenerated)
            }
        case .CREATE_NEW_SESSION:
            self.currentRequisition.isPlateIdGenerated = false
            self.setReviewerByDefaultSelected()
            
        case .SHOW_DRAFT_FOR_EDITING, .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.currentRequisition.timeStamp = savedData.timeStamp ?? ""
            self.currentRequisition.configureDataFromDrafts(draftData: savedData)
            print(self.currentRequisition.isPlateIdGenerated)
        }
        self.checkMarkAllIfPlateIdIsGenerated()
    }
    
    
    private func setReviewerByDefaultSelected(){
        self.reviewerDetails.removeAll()
        self.saveReviewersDataToDatabase(isSessionType: true)
        self.refreshReviewerData()
        if self.reviewerDetails.count > 0{
            let selectedReviewer = self.reviewerDetails.filter{ ($0.isSelected?.boolValue ?? true) }
            self.currentRequisition.reviewer = (selectedReviewer.count > 0) ? UserContext.sharedInstance.userDetailsObj?.userId ?? "" : ""
        }
    }
    
    
    //MARK: Check and chech mark all if plat ids are generated
    func checkMarkAllIfPlateIdIsGenerated(){
        if self.currentRequisition.isPlateIdGenerated{
            for header in self.currentRequisition.actualCreatedHeaders{
                header.ischeckBoxSelected = true
            }
        }
    }
    
    //MARK: Save on clicking save as draft
    func saveAsDraft(){
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION, .CREATE_NEW_SESSION:
            if self.currentRequisition.isrequisitionIsAlreadyCreatedForSameDateWithSameSite(sessionStatus: .saveAsDraft){
                Helper.showAlertMessage(self, titleStr: "Alert", messageStr: Constants.youHaveAlreadyRequisitionStr)
                return
            }
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Save To draft?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
                self.currentRequisition.timeStamp = Date().getCurrentTimeStamp()
                self.currentRequisition.sessionStatus = SessionStatus.saveAsDraft
                self.currentRequisition.saveCaseInfoDataInToDB_Enviromental()
                self.currentRequisition.saveSampleInfoDataInToDB_Enviromental()
                self.currentRequisition.saveEnviromentalRequisitionalId()
                
                let predicate = NSPredicate(format: "isSessionType = %d", argumentArray: [true])
                MicrobialSelectedUnselectedReviewer.updateTimeStampFromSession(predicate: predicate, timeStamp: self.currentRequisition.timeStamp)
                //                NSPredicate(format: "isSessionType = %d", argumentArray: [true])
                self.currentRequisition = RequisitionModel()
                CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
                CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaders")
                CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaderPlates")
                UserDefaults.standard.removeObject(forKey: "sessionprogresss")
                self.navigateToMocrobialViewController()
            }))
            self.present(alert, animated: true, completion: nil)
            
        case .SHOW_DRAFT_FOR_EDITING: // this case will never execute as the draft button is hidden
            self.currentRequisition.timeStamp = savedData.timeStamp ?? ""
            self.currentRequisition.sessionStatus = SessionStatus(rawValue: Int(truncating: savedData.sessionStatus ?? 0)) ?? SessionStatus.saveAsDraft
            self.currentRequisition.updateNewBarcodeEditted()
            self.currentRequisition.updateDataForDraft(isFinalSubmit: false)
            
            //update plates
            self.currentRequisition.updateSampleInfoDataInToDB_Enviromental(isFinalSubmit: false)
            self.navigateToMocrobialViewController()
            
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            break
        }
    }
    
    
    // MARK: Save at every action
    func saveCurrentDataInLocalDB(isFinalSubmit: Bool){
        switch requisitionSavedSessionType {
        case .RESTORE_OLD_SESSION, .CREATE_NEW_SESSION:
            self.saveCurrentSessionDataInToDB()
            
        case .SHOW_DRAFT_FOR_EDITING:
            self.currentRequisition.timeStamp = self.savedData.timeStamp ?? ""
            self.currentRequisition.sessionStatus = SessionStatus(rawValue: Int(truncating: savedData.sessionStatus ?? 0)) ?? SessionStatus.saveAsDraft
            self.currentRequisition.updateNewBarcodeEditted()
            self.currentRequisition.updateDataForDraft(isFinalSubmit: isFinalSubmit)
            self.currentRequisition.updateSampleInfoDataInToDB_Enviromental(isFinalSubmit: isFinalSubmit)
            
            
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            break
        }
    }
    
}


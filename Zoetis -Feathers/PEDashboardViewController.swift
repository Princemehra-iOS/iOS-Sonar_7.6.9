

//
//  PEDashboardViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 05/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SwiftyJSON
import Charts
import Reachability
import CoreData
import Gigya
import GigyaTfa
import GigyaAuth

class PEDashboardViewController: BaseViewController , ChartViewDelegate{
    // MARK: - OUTLETS
    let gigya = Gigya.sharedInstance(GigyaAccount.self)
    @IBOutlet weak var btn_Training: UIButton!
    @IBOutlet weak var dashboardTblVw: UITableView!
    @IBOutlet weak var draftCountImg: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var extendedLbl: UILabel!
    @IBOutlet weak var extendedLblDash: UILabel!
    @IBOutlet weak var graphHeaderImage: UIImageView!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var barChartViewFirst: BarChartView!
    @IBOutlet weak var barChartViewSecond: BarChartView!
    @IBOutlet weak var startassessmentButton: UIButton!
    @IBOutlet weak var draftView: UIView!
    @IBOutlet weak var barChart2: BarChartView!
    @IBOutlet weak var barChart1: BarChartView!
    @IBOutlet weak var selectedSiteLabel: PEFormLabel!
    @IBOutlet weak var selectedCustomerLabel: PEFormLabel!
    @IBOutlet weak var barGraph1: UIView!
    @IBOutlet weak var barGraph2: UIView!
    @IBOutlet weak var labelDraftCount: UILabel!
    @IBOutlet weak var gradientViewBelowGraph: GradientButton!
    @IBOutlet weak var operatorCertVw: UIView!
    @IBOutlet weak var viewAssessmentBtn: UIButton!
    @IBOutlet weak var popupVw: UIView!
    @IBOutlet weak var titleVw: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var popupHeaderVw: UIView!
    @IBOutlet weak var rejectedBGView: UIImageView!
    @IBOutlet weak var popupTblVw: UITableView!
    @IBOutlet weak var sectionHeaderVw: UIView!
    @IBOutlet weak var popupSectionHeaderVw: UIView!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rejectedListBtn: UIButton!
    @IBOutlet weak var popupBackgroundVw: UIView!
    @IBOutlet weak var tableHeaderVw: UIView!
    @IBOutlet weak var rejectedListCount: UILabel!
    
    // MARK: - VARIABLES
    var sanitationQuesArr = [PE_ExtendedPEQuestion]()
    var upcomingCertificationsArr:[PENewAssessment] = [PENewAssessment]()
    var rejectedVM: RejectedAssessmentViewModel?
    var scheduleAssessmentIdArray : [String] = []
    var lastTwoAssessmentsDate : [String] = []
    var lastTwoAssessmentsSubmitId : [String] = []
    var resultCatfirstAssessment : [PE_AssessmentInProgress] = []
    var resultCatSecondAssessment : [PE_AssessmentInProgress] = []
    var peHeaderViewController:PEHeaderViewController!
    var deviceIDFORSERVER = ""
    var inovojectData : [InovojectData] = []
    var dayOfAgeData : [InovojectData] = []
    var dayOfAgeSData : [InovojectData] = []
    var certificateData : [PECertificateData] = []
    var saveTypeString : [Int] = []
    var peAssessmentSyncArray : [PENewAssessment] = []
    var objAssessment : PENewAssessment = PENewAssessment()
    var peNewAssessment:PENewAssessment?
    var callRequest4Int = 0
    var totalImageToSync : [Int] = []
    var syncAndLogout : Bool = false
    var isGotResponse : Bool = false
    var isfromSync : Bool = false
    var jsonRe : JSON = JSON()
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var infoImageDataResponse = InfoImageDataResponse(nil)
    var deletedAssessmentIdArray = [String]()
    var i = 0, j = 0, k = 0
    var isSync : Bool = false
    var syncResponse : Bool = false
    var assessID : Int?
    let group = DispatchGroup()
    var  regionID = Int()
    var tempArr : [JSONDictionary]  = []
    
    var HaveToCallExtendedMicro : Bool = false
    @IBOutlet weak var alertLbl: UILabel!
	var globalAssessmentId:String?

    var fileDetailArray = NSArray()
    // MARK: - VIEW LIFE CYCLE
    // MARK: - Session Timer Variables.
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var timerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossBtn: UIButton!
    var requestTrackingTimer:Timer?
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        getBlankAssessmentFiles()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if( regionID != 3){
            btn_Training.alpha = 0.3
            btn_Training.alpha = 0.3
            btn_Training.isUserInteractionEnabled = false
        }
        else{
            btn_Training.alpha = 1
            btn_Training.alpha = 1
            btn_Training.isUserInteractionEnabled = true
        }
        DispatchQueue.main.async {
            self.gradientViewBelowGraph.setGradient(topGradientColor: UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        self.selectedCustomerLabel.text   = ""
        self.selectedSiteLabel.text =  ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.navToGlobalDashboard(notification:)), name: Notification.Name("NavToGlobalDashboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dashboardRefresh(notification:)), name: Notification.Name("UpdateComplexOnDashboardPE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToStartAssessment(notification:)), name: Notification.Name("MoveToStartAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToViewAssessment(notification:)), name: Notification.Name("MoveToViewAssessment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToScheduledAssessments(notification:)), name: Notification.Name("NavigateToScheduledAssesments"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToPlacards(notification:)), name: Notification.Name("MoveToOpenPlacards"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncBtnTappedNoti(notification:)), name: Notification.Name("peSyncDataNoti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navToGlobalDashboardAfterSync(notification:)), name: Notification.Name("MoveToDashBoard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishSessionClicked(notification:)), name: Notification.Name("FinishSessionPEClicked"), object: nil)
        
        registerTblVwCells()
        setUI()
        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if regionID == 3{
            extendedLbl.text = "Extended Microbial"
            extendedLblDash.text = "Extended Microbial"
        }else{
            extendedLbl.text = "Country"
            extendedLblDash.text = "Country"
        }
        let PE_Selected_Customer_Name = UserDefaults.standard.string(forKey: "PE_Selected_Customer_Name") ?? ""
        let PE_Selected_Site_Name = UserDefaults.standard.string(forKey: "PE_Selected_Site_Name") ?? ""
        
        self.selectedCustomerLabel.text   = PE_Selected_Customer_Name + " - " + PE_Selected_Site_Name
        date1Label.isHidden = true
        date2Label.isHidden = true
        getPlateTypes()
        loadPopupUI()
        hidePopup()
        operatorCertVw.setGradient(topGradientColor: UIColor.getUpcomingCertUpperGradColor(), bottomGradientColor: UIColor.getUpcomingCertLowerGradColor())
        operatorCertVw.roundVsCorners(corners: [.topLeft, .topRight], radius: 18.5)
        tableHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        
        
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(handleAppEnteredForeground),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil
//        )
//        
        
        timerView.layer.cornerRadius = 18
        timerView.layer.masksToBounds = true
        timerView.layer.borderColor = UIColor.lightGray.cgColor
        timerView.layer.borderWidth = 1.0
        
        timerView.clipsToBounds = true
        self.sessionTimer()
        
    }
    
    //MARK: Session Timer  Code
    override func viewWillDisappear(_ animated: Bool) {
        self.viewAssessmentBtn.isUserInteractionEnabled = true
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func okBtnActn(_ sender: Any) {
        self.timerView.isHidden = true
        self.crossBtn.isHidden = true
    }
    
    @IBAction func logOutBtnActn(_ sender: Any) {
        if WebClass.sharedInstance.connected() {
            TimeManager.shared.performAutoLogout()
        }
        else
        {
            self.failWithInternetConnection()
        }
    }
    
    
    func failWithInternetConnection()
    {
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }

    //MARK:  Timer  cleared from memory
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    //MARK:  Timer Statrt
    func sessionTimer() {
        TimeManager.shared.startSession()
        
        TimeManager.shared.onTick = { timeString in
            self.sessionLabel.text = timeString
        }
        
        TimeManager.shared.onSessionExpired = {
            self.timerView.isHidden = true
            self.crossBtn.isHidden = true
            if self.peAssessmentSyncArray.count != 0{
                self.showSessionExpiredAlert(showLogoutButton: true)
            }
            else{
                self.showSessionExpiredAlert(showLogoutButton: true)
            }
        }
      
    }
    
    //MARK: Session Expired Alert
    func showSessionExpiredAlert(showLogoutButton: Bool) {
        let messageText: String
        
   
        messageText = Constants.dontHaveSessionToPostMessage

        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        // MARK: - Attributed Title
        let titleFont: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.black
        ]
        let titleAttrString = NSMutableAttributedString(string: "⚠️ Session Notification\n", attributes: titleFont)
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        
        // MARK: - Attributed Message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        
        let messageFont: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.darkGray,
            .paragraphStyle: paragraphStyle
        ]
        
        let messageAttrString = NSMutableAttributedString(string: messageText, attributes: messageFont)
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        // MARK: - Actions
        if showLogoutButton {
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                if WebClass.sharedInstance.connected() {
                    print("Internet is connected. Calling sessionLogout()")
                    self.sessionLogout()
                }
                else
                {
                    self.failWithInternetConnection()
                }
            }
            alert.addAction(logoutAction)
        }
        
        let okAction = UIAlertAction(title: "Later", style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func sessionLogout() {
     //   let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        
        if self.peAssessmentSyncArray.count != 0{
            self.showOKAlert(title:  "⚠️\nAlert!", message: Constants.stillHaveActiveSessionMessage)
            return
        }
        else
        {
            ViewController.clearDataBeforeLogout()
            TimeManager.shared.performAutoLogout()
        }
    }
    
    func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.isSync = false
        hideDraftCount()
        hideRejectedCount()
        peAssessmentSyncArray.removeAll()
        peAssessmentSyncArray = getAllDateArrayStored()
        if peAssessmentSyncArray.count < 1 {
            addOperations()
        }
        setupHeader()
        hidePopup()
        let userDefault = UserDefaults.standard
        let customerId = userDefault.integer(forKey: "PE_Selected_Customer_Id")
        let siteId = userDefault.integer(forKey: "PE_Selected_Site_Id")
        self.checkDataForSyncViewDidAppear()
        self.upcomingCertificationsArr =  PEAssessmentsDAO.sharedInstance.getVMObj(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        
        if upcomingCertificationsArr.count > 0
        {
            alertLbl.isHidden = true
        }
        else
        {
            alertLbl.isHidden = false
        }
        
        self.popupTblVw.reloadData()
        self.dashboardTblVw.reloadData()
        
        userDefault.set(nil, forKey: "PE_Selected_Customer_Id")
        userDefault.set(nil, forKey: "PE_Selected_Customer_Name")
        userDefault.set(nil, forKey: "PE_Selected_Site_Id")
        userDefault.set(nil, forKey: "PE_Selected_Site_Name")
        let allAssesmentDraftArr = getAllDateArrayStoredDraft()
        if allAssesmentDraftArr.count  > 0 {
            let count = allAssesmentDraftArr.count//getDraftCountFromDb()
            labelDraftCount.text = String(count)
            showDraftCount()
            if count == 0 {
                hideDraftCount()
            }
        } else {
            labelDraftCount.text  = "0"
            hideDraftCount()
            
        }
        
        let rejectedCountIS =  UserDefaults.standard.value(forKey: "rejectedCountIS") as? Int ?? 0
        if rejectedCountIS  > 0 {
            rejectedListCount.text = String(rejectedCountIS)
            showRejectedCount()
            if rejectedCountIS == 0 {
                hideRejectedCount()
            }
        } else {
            rejectedListCount.text  = "0"
            hideRejectedCount()
        }
        requestTrackingTimer?.invalidate()
        requestTrackingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("ActiveRequests Count: ",APIActivityTracker.shared.activeRequestCount)
            if APIActivityTracker.shared.activeRequestCount == 0 {
                appDelegateObj.hideAllHUDs()
                self.requestTrackingTimer?.invalidate()
            }
        }
    }
    
    // MARK: - INITIAL UI METHODS
    
    
    func registerTblVwCells(){
        popupTblVw.delegate = self
        popupTblVw.dataSource = self
        dashboardTblVw.delegate = self
        dashboardTblVw.dataSource = self
        
        popupTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
        dashboardTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
    }
    
    private func getPlateTypes(){
        PEDataService.sharedInstance.getPlateTypes(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
            }
        })
    }
    // MARK: - Load Popup
    private func loadPopupUI(){
        setGradientToTblVw(tableView:popupTblVw)
        popupHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        popupSectionHeaderVw.backgroundColor = UIColor.getPopupSectionHeaderColor()
    }
    // MARK: - Hide Popup
    private func hidePopup(){
        popupBackgroundVw.isHidden = true
        
        popupSectionHeaderVw.isHidden = true
        popupHeightConstraint.constant = 0
        titleVw.isHidden = true
        sectionHeaderVw.isHidden = true
    }
    // MARK: - Hide Draft Count
    func hideDraftCount(){
        labelDraftCount.isHidden = true
        draftCountImg.isHidden = true
    }
    // MARK: - Hide Reject Count
    func hideRejectedCount(){
        rejectedListCount.isHidden = true
        rejectedBGView.isHidden = true
    }
    // MARK: - Setup Header
    private func setupHeader() {
        _ =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        let PE_Selected_Customer_Name = UserDefaults.standard.string(forKey: "PE_Selected_Customer_Name") ?? ""
        let PE_Selected_Site_Name = UserDefaults.standard.string(forKey: "PE_Selected_Site_Name") ?? ""
        
        self.selectedCustomerLabel.text   = PE_Selected_Customer_Name + " - " + PE_Selected_Site_Name
        
        if peNewAssessment?.customerName != nil {
            _ = ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0].peNewAssessment
            _ = Date().string(format: "yyyy-MM-dd")
            
        } else {
            peNewAssessment = PENewAssessment()
            var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
            var jsonRe : JSON = JSON()
            jsonRe = ((getJSON("QuestionAns") ?? nil) ?? JSON())
            pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
            ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession.append(pECategoriesAssesmentsResponse)
        }
        
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "finalizeArray") ?? Data()
//        let finalizeArrayFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [PECategoriesAssesmentsResponse]
//        _ = finalizeArrayFromDefaults?.count ?? 0
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Process Evaluation"
        peHeaderViewController.showSession = checkCurrentAssessmentData()
        peHeaderViewController.delegatePE = self
        let assessmentInOfflineFromDb = getAssessmentInOfflineFromDb()
        if  assessmentInOfflineFromDb  > 0 {
            peHeaderViewController.titleofSync = String(assessmentInOfflineFromDb)
        } else {
            peHeaderViewController.titleofSync = "0"
        }
        
        let allAssesmentDraftArr = getAllDateArrayStoredDraft()//CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInDraft")
        
        if allAssesmentDraftArr.count  > 0 {
            let count = allAssesmentDraftArr.count//getDraftCountFromDb()
            labelDraftCount.text = String(count)
            showDraftCount()
            if count == 0 {
                hideDraftCount()
            }
        } else {
            labelDraftCount.text  = "0"
            hideDraftCount()
        }
        
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    // MARK: - Check Data for Sync
    private func checkDataForSyncViewDidAppear(){
        
        let syncArr = getAssessmentInOfflineFromDb()
        if ConnectionManager.shared.hasConnectivity(){
            if syncArr > 0{
                let errorMSg = "Data available for sync, Do you want to sync now?"
                let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    _ in
                    self.getVaccinationServiceResponse(showHud: true)
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    _ in
                   
                    self.popupTblVw.reloadData()
                    self.dashboardTblVw.reloadData()
                    self.sessionTimer()
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
               
            }
        }
    }
    // MARK: - Show Draft Count
    func showDraftCount(){
        labelDraftCount.isHidden = false
        draftCountImg.isHidden = false
    }
    
    // MARK: - Set Gradient Colour to Table View.
    private func setGradientToTblVw(tableView:UITableView){
        let gradientColors = [UIColor.white, UIColor.getPopupTblGradientColor()]
        let gradientLocations = [0.0, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        gradientLayer.frame = popupTblVw.bounds
        let backgroundVw = UIView.init(frame: popupTblVw.bounds)
        backgroundVw.layer.insertSublayer(gradientLayer, at: 0)
        popupTblVw.backgroundView = backgroundVw
    }
    // MARK: - Load popup
    private func loadPopupVw(){
        popupBackgroundVw.isHidden = false
        popupSectionHeaderVw.isHidden = false
        popupHeightConstraint.constant = 360
        titleVw.isHidden = false
        sectionHeaderVw.isHidden = false
        Constants.startNewRecordSubmission()
        DispatchQueue.main.async {
            self.popupTblVw.reloadData()
        }
    }
    // MARK: - Set UI
    func setUI(){
        DispatchQueue.main.async {
            self.draftView.setCornerRadiusFloat(radius: 32)
        }
    }
    // MARK: - Set Charts
    func setChart(values: [Double],dataPoints:[String],barChart:BarChartView) {
        
        barChart.noDataText = "You need to provide data for the chart."
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        chartData.label = "Assessments Result"
        let myBlueColor =   NSUIColor(red: 64/255.0, green: 126/255.0, blue: 201/255.0, alpha: 1.0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        chartData.valueFormatter = DefaultValueFormatter(formatter: formatter)
        chartData.setColor(myBlueColor)
        barChart.delegate = self
        barChart.xAxis.valueFormatter = self
        barChart.xAxis.labelPosition = .bottom
        barChart.leftAxis.axisMinimum = 0
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChart.data = BarChartData(dataSet: chartData)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChart.xAxis.labelFont = UIFont.systemFont(ofSize: 6)
        barChart.chartDescription?.text = ""
        barChart.legend.enabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.gridColor = .clear
        barChart.leftAxis.gridColor = .clear
        barChart.rightAxis.gridColor = .clear
        barChart.extraBottomOffset = 20
        barChart.fitScreen()
    }
    
    // MARK: - Convert JSON to String
    func jsonToString(json: JSON)->String{
        do {
            let data1 =  self.getDataFrom(JSON: json)
            let convertedString = String(data: data1 ?? Data(), encoding: String.Encoding.utf8)
            return convertedString!
            
        } catch let myJSONError {
        }
        
        return ""
    }
    
    func getDataFrom(JSON json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
    
    // MARK: - Convert Date Formatter
    func convertDateFormatter(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            return ""
        }
        
        if regionID == 3
        {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        else{
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        let timeStamp = dateFormatter.string(from: convertedDate ?? Date())
        
        return timeStamp
        
    }
    // MARK: - Save Image In PE Module
    private func saveImageInPEModule(imageData:Data)->Int{
        _ = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let imageCount = getImageCountInPEModule()
        CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount+1, imageData: imageData)
        return imageCount+1
    }
    // MARK: - Get Image Count In PE Module
    func getImageCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "imageId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    // MARK: -  Navigate to Start Assessment
    @objc private func moveToStartAssessment(notification: NSNotification){
        self.startNewSessionClicked(self.startassessmentButton!)
    }
    // MARK: - Navigate to View Assessment
    @objc private func moveToViewAssessment(notification: NSNotification){
        navigateToViewAssessment()
    }
    // MARK: - Navigate to Schedule Assessment
    @objc private func navigateToScheduledAssessments(notification: NSNotification){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEScheduleVC") as? PEScheduleVC
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Navigate to Placards
    @objc private func moveToPlacards(notification: NSNotification){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEPlacardsViewController") as? PEPlacardsViewController
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Navigate to Global Dashboard
    @objc private func navToGlobalDashboard(notification: NSNotification){
        self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
    }
    
    @objc private func navToGlobalDashboardAfterSync(notification: NSNotification){
        self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
    }
    
    @objc private func finishSessionClicked(notification: NSNotification){
        addComplexPopupWithoutDataCheck(isFromSyncDel: true)
        setupHeader()
    }
    
    // MARK: - Refresh DashBoard
    @objc private func dashboardRefresh(notification: NSNotification){
        date1Label.isHidden = true
        date2Label.isHidden = true
        let userDefault = UserDefaults.standard
        let customerId = userDefault.integer(forKey: "PE_Selected_Customer_Id")
        let siteId = userDefault.integer(forKey: "PE_Selected_Site_Id")
        
        self.upcomingCertificationsArr =  PEAssessmentsDAO.sharedInstance.getVMObj(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        if anyCategoryContainCustomerOrNot(){
            let peNewAssessmentSurrentIs = ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0].peNewAssessment
            if let complexNameIs = peNewAssessmentSurrentIs?.customerName {
            } else {
                peNewAssessment = PENewAssessment()
            }
        } else {
            addComplexPopup(isFromSyncDel: true)
        }
        setupHeader()
    }
    // MARK: - Check Current Assessment Data
    private func checkCurrentAssessmentData() -> Bool{
        let peNewAssessmentSurrentIs = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        let customerName = peNewAssessmentSurrentIs.customerName ?? ""
        let evaluationName = peNewAssessmentSurrentIs.siteName  ?? ""
        let camera = peNewAssessmentSurrentIs.camera  ?? 0
        let hatcheryAntibiotics = peNewAssessmentSurrentIs.hatcheryAntibiotics  ?? 0
        let visitName = peNewAssessmentSurrentIs.visitName  ?? ""
        let notes = peNewAssessmentSurrentIs.notes  ?? ""
        if customerName.count > 0 || evaluationName.count > 0 || camera > 0 || hatcheryAntibiotics > 0  || visitName.count > 0 || notes.count > 0  {
            return true
        }
        return false
    }
    // MARK: - Set Chart for Assessment Submitted Offline
    private func setChartForAssesmentSubmittedOffline(count:Int){
        if count  > 0 {
            if count > 2 || count == 2 {
                let date = resultCatSecondAssessment[0].evaluationDate ?? ""
                var text2 = date + ""  + "(" + (resultCatSecondAssessment[0].customerName ?? "") + ", "
                text2 = text2  + (resultCatSecondAssessment[0].siteName ?? "") + ")"
                date2Label.text = date
                date2Label.isHidden = false
                var resultInAssessment1 : [Double] = []
                var dataPoints1 : [String] = []
                if resultCatSecondAssessment.count > 0 {
                    for obj in resultCatSecondAssessment {
                        resultInAssessment1.append(Double(truncating: obj.catResultMark ?? 0))
                        let name = obj.catName ?? ""
                        var data = changeStringToArrayLevel3(name:name)
                        data = data + "(" + (obj.catMaxMark?.stringValue ?? "") + ")"
                        dataPoints1.append(data )
                    }
                }
                let unitsSold1 = resultInAssessment1
                setChart(values: unitsSold1,dataPoints:dataPoints1,barChart: barChart2 )
            }
            if count == 1 {
                let date = resultCatfirstAssessment[0].evaluationDate ?? ""
                var text2 = date + ""  + "(" + (resultCatfirstAssessment[0].customerName ?? "") + ", "
                text2 = text2  + (resultCatfirstAssessment[0].siteName ?? "") + ")"
                var resultInAssessment : [Double] = []
                date1Label.text = date
                date1Label.isHidden = false
                var dataPoints : [String] = []
                if resultCatfirstAssessment.count > 0 {
                    for obj in resultCatfirstAssessment {
                        resultInAssessment.append(Double(truncating: obj.catResultMark ?? 0))
                        let name = obj.catName ?? ""
                        var data = changeStringToArrayLevel3(name:name)
                        data = data + "(" + (obj.catMaxMark?.stringValue ?? "") + ")"
                        dataPoints.append(data )
                    }
                }
                let unitsSold = resultInAssessment
                setChart(values: unitsSold,dataPoints:dataPoints,barChart: barChart1 )
            }
        }
    }
    
    func changeStringToArrayLevel3(name:String) -> String{
        var tempName = ""
        tempName = name.replacingOccurrences(of: "&", with: "")
        var fullNameArr : [String]? = []
        fullNameArr = tempName.split{$0 == " "}.map(String.init)
        var fullName1 = ""
        var fullName3 = ""
        var fullName2 = ""
        if 0 >= 0 && 0 < fullNameArr?.count ?? 0 {
            fullName1 = fullNameArr?[0] ?? ""
        }
        if 1 >= 0 && 1 < fullNameArr?.count ?? 0{
            fullName2 = fullNameArr?[1] ?? ""
        }
        if 2 >= 0 && 2 < fullNameArr?.count ?? 0{
            fullName3 = fullNameArr?[2] ?? ""
        }
        let data =  fullName1 + "\n" + fullName2 + "\n" + fullName3
        return data
        
    }
    
    // MARK: - Show Rejected Count
    func showRejectedCount(){
        rejectedListCount.isHidden = false
        rejectedBGView.isHidden = false
    }
    
    private func addComplexPopup(isFromSyncDel:Bool = false) {
        
    }
    
    private func addComplexPopupWithoutDataCheck(isFromSyncDel:Bool = false) {
        
    }
    // MARK: - Navigate to View Assessment.
    func navigateToViewAssessment(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PESessionViewController") as? PESessionViewController
        Constants.isFromRejected = false
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Navigate to Rejected Assessment
    func navigateToRejectedAssessment(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PESessionViewController") as? PESessionViewController
        Constants.isFromRejected = true
        if vc != nil{
            vc!.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Filter Categoty Count
    func filterCategoryCount(peNewAssessmentOf:PENewAssessment) -> Int {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessmentOf.evaluationID == object.evaluationID{
                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
        return pECategoriesAssesmentsResponse.peCategoryArray.count ?? 0
    }
    // MARK: - Save Inovoject Data In PE Module
    private func saveInovojectInPEModule(inovojectData:InovojectData,assessment: PE_AssessmentInProgress) -> Int{
        let imageCount = getDOACountInPEModule()
        CoreDataHandlerPE().saveInovojectPEModule(assessment: assessment ?? PE_AssessmentInProgress(), doaId: imageCount+1,inovojectData: inovojectData)
        return imageCount+1
        
    }
    // MARK: - Save DOA Data In PE Module
    private func saveDOAInPEModule(inovojectData:InovojectData,assessment: PE_AssessmentInProgress,fromDoaS:Bool?=false) -> Int{
        let imageCount = getDOACountInPEModule()
        CoreDataHandlerPE().saveDOAPEModule(assessment: assessment, doaId: imageCount+1,inovojectData: inovojectData,fromDoaS: fromDoaS)
        return imageCount+1
    }
    // MARK: - Dismiss Loader
    func dismissHUD(){
        let mainQueue = OperationQueue.main
        mainQueue.addOperation{
            self.dismissGlobalHUD(self.view)
        }
    }
    // MARK: - Get All Data of Drafted Assessment.
    private func getAllDateArrayStoredDraft() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject(ofCurrentAssessment:true)
        var carColIdArray : [String] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.draftID ?? ""){
                carColIdArray.append(obj.draftID ?? "")
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    // MARK: - Get Last two Assessment from Data Base
    func getAssessmentOfflineLastTwoFromDb() {
        var peAssessmentDraftArray = getAllDateArrayStoredOffline()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if(regionID == 3){
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        else{
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        let sortedArray = peAssessmentDraftArray.sorted {
            let evalDate1 = $0.evaluationDate ?? ""
            let evalDate2 = $1.evaluationDate ?? ""
            let evalDateObj1 = dateFormatter.date(from: evalDate1)
            let evalDateObj2 = dateFormatter.date(from: evalDate2)
            
            if evalDateObj1 != nil && evalDateObj2 != nil{
                return  evalDateObj1! > evalDateObj2!
            }
            return false
        }
        peAssessmentDraftArray = sortedArray
        lastTwoAssessmentsDate.removeAll()
        lastTwoAssessmentsSubmitId.removeAll()
        
        for assessment in peAssessmentDraftArray {
            if !lastTwoAssessmentsSubmitId.contains(assessment.dataToSubmitID ?? "" ){
                lastTwoAssessmentsDate.append(assessment.evaluationDate ?? "")
                lastTwoAssessmentsSubmitId.append(assessment.dataToSubmitID ?? "")
                
            }
        }
        
        if lastTwoAssessmentsDate.count > 0 {
            var tempArr = NSArray()
            let peNewAssessmentSurrentIs =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.managedObjectContext
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
            fetchRequest.returnsObjectsAsFaults = false
            let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            let evaluationDateLatestSubmitId = lastTwoAssessmentsSubmitId[0] as? String ?? ""
            let evaluationDateLatestAssessment = lastTwoAssessmentsDate[0] as? String ?? ""
            
            let customerId = UserDefaults.standard.integer(forKey: "PE_Selected_Customer_Id") ?? 0
            let siteId = UserDefaults.standard.integer(forKey: "PE_Selected_Site_Id") ?? 0
            
            
            fetchRequest.predicate = NSPredicate(format: "customerId == %@ AND siteId == %d AND userID == %d AND evaluationDate == %@ AND dataToSubmitID == %@", argumentArray: [customerId, siteId,userID,evaluationDateLatestAssessment,evaluationDateLatestSubmitId])
            
            
            var carColIdArrayDraftNumbers : NSArray = NSArray()
            var catColIdArrayDraftNumbers : NSArray = NSArray()
            var submitIDArray : NSArray = NSArray()
            var allAssesmentDraftArr : [PE_AssessmentInOffline] = []
            var dataToSubmitNumberIdArray : [Int] = []
            
            do {
                let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 {
                    tempArr = results as NSArray? ?? []
                    allAssesmentDraftArr = results as? [PE_AssessmentInOffline] ?? []
                    carColIdArrayDraftNumbers  = tempArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
                    
                    for obj in carColIdArrayDraftNumbers {
                        if (!dataToSubmitNumberIdArray.contains((obj as? Int) ?? 0) && dataToSubmitNumberIdArray.count < 2){
                            dataToSubmitNumberIdArray.append((obj as? Int) ?? 0)
                        }
                    }
                    catColIdArrayDraftNumbers  = tempArr.value(forKey: "catID") as? NSArray ?? []
                    submitIDArray  = tempArr.value(forKey: "dataToSubmitID") as? NSArray ?? []
                }
            } catch {
            }
            if  resultCatfirstAssessment.count > 0 {
                resultCatfirstAssessment.removeAll()
            }
            if  resultCatSecondAssessment.count > 0 {
                resultCatSecondAssessment.removeAll()
            }
            var dataSubmitIdArray : [String] = []
            for obj in submitIDArray {
                if !dataSubmitIdArray.contains((obj as? String) ?? ""){
                    dataSubmitIdArray.append((obj as? String) ?? "")
                }
            }
            if dataToSubmitNumberIdArray.count > 0 {
                var dataCatIDToSubmitNumberIdArray : [Int] = []
                for obj in catColIdArrayDraftNumbers {
                    if !dataCatIDToSubmitNumberIdArray.contains((obj as? Int) ?? 0) {
                        dataCatIDToSubmitNumberIdArray.append((obj as? Int) ?? 0)
                    }
                }
                let fetchRequestNew  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
                fetchRequestNew.returnsObjectsAsFaults = false
                if  resultCatSecondAssessment.count > 0 {
                    resultCatSecondAssessment.removeAll()
                }
                if  resultCatfirstAssessment.count > 0 {
                    resultCatfirstAssessment.removeAll()
                }
                let evaluationDateLatestSubmitId = lastTwoAssessmentsSubmitId[0] as? String ?? ""
                for i in 0...dataCatIDToSubmitNumberIdArray.count-1 {
                    fetchRequestNew.predicate = NSPredicate(format: "evaluationDate == %@ AND catID == %d AND dataToSubmitID == %@", argumentArray: [ evaluationDateLatestAssessment,dataCatIDToSubmitNumberIdArray[i],evaluationDateLatestSubmitId])
                    fetchRequestNew.returnsObjectsAsFaults = false
                    
                    do {
                        let results = try managedContext.fetch(fetchRequestNew) as? [NSManagedObject]
                        if results?.count != 0 {
                            if results?.count ?? 0 > 1 {
                                resultCatfirstAssessment.append(results?[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                            }
                            
                        }
                    } catch {
                    }
                }
                
                if resultCatfirstAssessment.count > 0 {
                    setChartForAssesmentSubmittedOffline(count: 1)
                }
            }
        }else {
            barChart1.clearValues()
            barChart2.clearValues()
            barChart1.clear()
            barChart2.clear()
        }
        if lastTwoAssessmentsDate.count > 1 {
            getAssessmentSecondFromDb()
        }
        
    }
    
    func getAssessmentSecondFromDb() {
        
        if lastTwoAssessmentsDate.count > 1 {
            var tempArr = NSArray()
            let peNewAssessmentSurrentIs =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate!.managedObjectContext
            let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
            fetchRequest.returnsObjectsAsFaults = false
            let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            let evaluationDateLatestSubmitId = lastTwoAssessmentsSubmitId[1] as? String ?? ""
            let evaluationDateLatestAssessment = lastTwoAssessmentsDate[1] as? String ?? ""
            
            let customerId = UserDefaults.standard.integer(forKey: "PE_Selected_Customer_Id")
            let siteId = UserDefaults.standard.integer(forKey: "PE_Selected_Site_Id")
            
            fetchRequest.predicate = NSPredicate(format: "customerId == %@ AND siteId == %d AND userID == %d AND evaluationDate == %@ AND dataToSubmitID == %@", argumentArray: [customerId,siteId,userID,evaluationDateLatestAssessment,evaluationDateLatestSubmitId])
            
            var carColIdArrayDraftNumbers : NSArray = NSArray()
            var catColIdArrayDraftNumbers : NSArray = NSArray()
            var submitIDArray : NSArray = NSArray()
            var allAssesmentDraftArr : [PE_AssessmentInOffline] = []
            
            var dataToSubmitNumberIdArray : [Int] = []
            
            do {
                let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
                if results?.count != 0 {
                    tempArr = results as NSArray? ?? []
                    allAssesmentDraftArr = results as? [PE_AssessmentInOffline] ?? []
                    carColIdArrayDraftNumbers  = tempArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
                    
                    for obj in carColIdArrayDraftNumbers {
                        if (!dataToSubmitNumberIdArray.contains((obj as? Int) ?? 0) && dataToSubmitNumberIdArray.count < 2){
                            dataToSubmitNumberIdArray.append((obj as? Int) ?? 0)
                        }
                    }
                    catColIdArrayDraftNumbers  = tempArr.value(forKey: "catID") as? NSArray ?? []
                    submitIDArray  = tempArr.value(forKey: "dataToSubmitID") as? NSArray ?? []
                }
            } catch {
            }
            var dataSubmitIdArray : [String] = []
            for obj in submitIDArray {
                if !dataSubmitIdArray.contains((obj as? String) ?? ""){
                    dataSubmitIdArray.append((obj as? String) ?? "")
                }
            }
            if dataToSubmitNumberIdArray.count > 0 {
                var dataCatIDToSubmitNumberIdArray : [Int] = []
                for obj in catColIdArrayDraftNumbers {
                    if !dataCatIDToSubmitNumberIdArray.contains((obj as? Int) ?? 0) {
                        dataCatIDToSubmitNumberIdArray.append((obj as? Int) ?? 0)
                    }
                }
                let fetchRequestNew  = NSFetchRequest<NSFetchRequestResult>(entityName: "PE_AssessmentInOffline")
                fetchRequestNew.returnsObjectsAsFaults = false
                if  resultCatSecondAssessment.count > 0 {
                    resultCatSecondAssessment.removeAll()
                }
                let evaluationDateLatestSubmitId = lastTwoAssessmentsSubmitId[1] as? String ?? ""
                for i in 0...dataCatIDToSubmitNumberIdArray.count-1 {
                    fetchRequestNew.predicate = NSPredicate(format: "evaluationDate == %@ AND catID == %d AND dataToSubmitID == %@", argumentArray: [ evaluationDateLatestAssessment,dataCatIDToSubmitNumberIdArray[i],evaluationDateLatestSubmitId])
                    fetchRequestNew.returnsObjectsAsFaults = false
                    
                    do {
                        let results = try managedContext.fetch(fetchRequestNew) as? [NSManagedObject]
                        if results?.count != 0 {
                            if results?.count ?? 0 > 1 {
                                resultCatSecondAssessment.append(results?[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                            }
                        }
                    } catch {
                    }
                }
                
                if resultCatSecondAssessment.count > 0 {
                    setChartForAssesmentSubmittedOffline(count: 2)
                }
            }
        }else {
            barChart2.clearValues()
            barChart2.clear()
        }
        
    }
    // MARK: - Get Offine Assessment from Database
    func getAssessmentInOfflineFromDb() -> Int {
        getAssessmentOfflineLastTwoFromDb()
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDFor(entityName: "PE_AssessmentInOffline")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
        
        var carColIdArrayDraft : [Int] = []
        
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArrayDraft.contains(obj as? Int ?? 0){
                carColIdArrayDraft.append(obj as? Int ?? 0)
            }
        }
        let allAssesmentOffArr = CoreDataHandlerPE().fetchDetailsWithUserIDFor(entityName: "PE_AssessmentInDraft")
        let carColIdArrayOffNumbers  = allAssesmentOffArr.value(forKey: "draftNumber") as? NSArray ?? []
        var carColIdArrayOff : [Int] = []
        for obj in carColIdArrayOffNumbers {
            if !carColIdArrayOff.contains(obj as? Int ?? 0){
                carColIdArrayOff.append(obj as? Int ?? 0)
            }
        }
        let syncCount = carColIdArrayOff.count
        let syncCount2 = carColIdArrayDraft.count
        return syncCount + syncCount2
    }
    
    func getDraftCountFromDb() -> Int {
        
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftID") as? NSArray ?? []
        var carColIdArray : [String] = []
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? String ?? ""){
                carColIdArray.append(obj as? String ?? "")
            }
        }
        return carColIdArray.count
    }
    // MARK: - Get Latest Marks of Assessment
    private func GetLatestMarkOfAss(assID:Int) -> Int{
        let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
        for ass in allAssesmentArr{
            let objMark = ass as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
            if Int(objMark.assID ?? 0) == assID{
                return  objMark.catResultMark as? Int ?? 0
            }
        }
        return 0
    }
    // MARK: - Get total Marks of Assessment
    private func GetLatestTotalMarkOfAss(assID:Int) -> Int{
        let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
        for ass in allAssesmentArr{
            let objMark = ass as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
            if Int(objMark.assID ?? 0) == assID{
                return  objMark.catMaxMark as? Int ?? 0
            }
        }
        return 0
    }
    // MARK: - Get DOA Count In PE Module
    func getDOACountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DayOfAge")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "doaId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK: - Get Vaccine Mixture Count In PE Module
    func getVMixerCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VMixer")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "vmid") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    // MARK: - IBACTIONS
    // MARK: - Rejection Button Action
    @IBAction func btnRejectionListOpen(_ sender: Any) {
        navigateToRejectedAssessment()
    }
    // MARK: - Close Button Action
    @IBAction func closeBtnAction(_ sender: UIButton) {
        hidePopup()
    }
    // MARK: - Start New Session Button Action
    @IBAction func startNewSessionClicked(_ sender: Any) {
        loadPopupVw()
    }
    // MARK: - Open Existing Button Action
    @IBAction func openExistingSessionClicked(_ sender: Any) {
        self.viewAssessmentBtn.isUserInteractionEnabled = false
        navigateToViewAssessment()
    }
    // MARK: - Tranning & Education Button Action
    @IBAction func trainingEducationClicked(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEPlacardsViewController") as? PEPlacardsViewController
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    // MARK: - Assessment Finalize Button Action
    @IBAction func btnDraftClicked(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        delay(1.0) {
            sender.isEnabled = true
        }
        
        if peNewAssessment?.peCategoriesAssesmentsResponseDraft?.peCategoryArray.count ?? 0 > 0 {
            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as? PEAssesmentFinalize
            vc?.peNewAssessment = self.peNewAssessment
            if vc != nil{
                vc!.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    // MARK: - Draft Button Action
    @IBAction func draftTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftViewController") as? PEDraftViewController
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    // MARK: - Blank PDF Button Action
    @IBAction func blankPDFBtnAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "pdfOptionsViewController") as! pdfOptionsViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.view.backgroundColor = .clear
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension PEDashboardViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let sharedPEQueueArray = ZoetisDropdownShared.sharedInstance.sharedPEQueue
        let count = sharedPEQueueArray?.count ?? 0
        
        if count  > 0 {
            if count > 2 {
                
            }
            if count == 1 {
                barChart1.delegate = self
                barChart1.xAxis.valueFormatter = self
                let peCategoriesAssesmentsResponse = sharedPEQueueArray?[0]
                let categoriesArray = peCategoriesAssesmentsResponse?.peCategoryArray as? [PECategory]
                var resultInAssessment : [Double] = []
                var dataPoints : [String] = []
                if categoriesArray?.count ?? 0 > 0 {
                    for obj in categoriesArray ?? [] {
                        resultInAssessment.append(Double(obj.resultMark ?? 0))
                        let name = obj.categoryName ?? ""
                        var data = changeStringToArrayLevel3(name:name)
                        data = data + "(" + String(obj.maxMark ?? 0) + ")"
                        dataPoints.append(data ?? "")
                        
                    }
                }
                let unitsSold = resultInAssessment
                let maxMrk = categoriesArray?[ Int(value) % (categoriesArray?.count ?? 0)].maxMark ?? 0
                return String(maxMrk)
            }
        }
        return ""
    }
}

// MARK: - CHECK SESSION DATA

extension PEDashboardViewController{
    
    func anyCategoryContainValueOrNot(serverAssessmentId:String) -> Bool{
        let peNewAssessmentInDB = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: serverAssessmentId ?? "")
        if peNewAssessmentInDB.count > 1 {
            return true
        }
        return false
    }
    
    func anyCategoryContainCustomerOrNot() -> Bool{
        
        let PE_Selected_Customer_Id = UserDefaults.standard.integer(forKey: "PE_Selected_Customer_Id") as? Int ?? 0
        
        if  PE_Selected_Customer_Id != 0 {
            return true
        }
        return false
    }
    
}

// MARK: - EXTENSION FOR MANAGING THE SYNC

extension PEDashboardViewController:  SyncBtnDelegatePE,UnsyncedDelegate {
    func longPress() {
        peAssessmentSyncArray.removeAll()
        peAssessmentSyncArray = getAllDateArrayStored()
        let popupVC = ExportLogsViewController()//UnsyncedDataVC()
        popupVC.peAssessmentSyncArray = peAssessmentSyncArray
        popupVC.delegateUnsynced = self
        popupVC.modalPresentationStyle = .formSheet
        present(popupVC, animated: true, completion: nil)
    }
    
    func exportTapped(index: Int) {
        print(index)
        createJsonToExport(indexTapped: index)
    }
    
    @objc private func moveToDashBoard(notification: NSNotification){
        
    }
    // MARK: - Sync Button Notification
    @objc private func syncBtnTappedNoti(notification: NSNotification){
        
        let syncArr = getAssessmentInOfflineFromDb()
        if ConnectionManager.shared.hasConnectivity() {
            if syncArr > 0{
                let errorMSg = Constants.informDataSync
                let alertController = UIAlertController(title: "⚠️\nAlert!", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    _ in
                    self.askForDataSync()
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    _ in
                    self.forceSyncMessage()
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                self.logoutAction()
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
        }
        
    }
    // MARK: - get offine Data Array Data
    private func getAllDateArrayStoredOffline() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        
        let drafts  = CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
        var carColIdArray : [Int] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.dataToSubmitNumber ?? 0){
                carColIdArray.append(obj.dataToSubmitNumber ?? 0)
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    // MARK: - Ask for data Sync
    func askForDataSync(){
        let errorMSg = Constants.askForDataSync
        let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.getVaccinationServiceResponse(showHud: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            _ in
            self.forceSyncMessage()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Force Sync Message
    func forceSyncMessage(){
        let errorMSg = Constants.forceSyncMessage
        let alertController = UIAlertController(title: "Alert!", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            _ in
            self.popupTblVw.reloadData()
            self.dashboardTblVw.reloadData()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Get All Assessment Array.
    private func getAllDateArrayStored() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        
        var drafts  = CoreDataHandlerPE().getSessionAssessmentArrayPEObject(ofCurrentAssessment:true)
        
        let draftsNew  = CoreDataHandlerPE().getSessionAssessmentArrayPEObjectDraft(ofCurrentAssessment:true)
        
        
        var carColIdArray : [Int] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.dataToSubmitNumber ?? 0){
                carColIdArray.append(obj.dataToSubmitNumber ?? 0)
                peAssessmentArray.append(obj)
            }
        }
        
        var carColIdArrayraft : [Int] = []
        for obj in draftsNew {
            if !carColIdArrayraft.contains(obj.draftNumber ?? 0){
                carColIdArrayraft.append(obj.draftNumber ?? 0)
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    
    private func getAllDateArrayStoredNew() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        
        var drafts  = CoreDataHandlerPE().getSessionAssessmentArrayPEObject(ofCurrentAssessment:true)
        
        var carColIdArray : [Int] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.dataToSubmitNumber ?? 0){
                carColIdArray.append(obj.dataToSubmitNumber ?? 0)
                peAssessmentArray.append(obj)
            }
        }
        
        return peAssessmentArray
    }
    
    func getDataFrom(json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
    
    // MARK: - Sync Extended Microbial
    
    func exportExtendedmicrobialData (saveType: Int , statusType: Int,index:Int) ->JSONDictionary? {
        var extendedMicroArr : [JSONDictionary]  = []
        if peAssessmentSyncArray.count > 0 {
            let obj = peAssessmentSyncArray[index]
            self.assessID = Int(obj.serverAssessmentId ?? "")
            self.objAssessment = obj
            self.checkDataDuplicacy(obj: obj)
            var arrIDs = [NSNumber]()
            
            self.certificateData.removeAll()
            if obj.vMixer.count > 0 {
                var idArr : [Int] = []
                for objn in  obj.vMixer {
                    let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
                    if idArr.contains(data!.id ?? 0){
                        
                    }else{
                        idArr.append(data!.id ?? 0)
                        if data != nil{
                            self.certificateData.append(data!)
                        }
                    }
                }
            }
            
            let jsonExtendedMicro = self.createSyncRequestForExtendedMicro(dict: obj , certificationData : self.certificateData, saveType: saveType )
            extendedMicroArr.removeAll()
            extendedMicroArr.append(jsonExtendedMicro)
            
            return ["ExtendedMicrobialData":extendedMicroArr] as JSONDictionary
        }
        return nil
    }
    
    func syncExtendedMicrobial (saveType: Int , statusType: Int) {
        var extendedMicroArr : [JSONDictionary]  = []
        
        if peAssessmentSyncArray.count > 0 {
            for obj in self.peAssessmentSyncArray{
                self.assessID = Int(obj.serverAssessmentId ?? "")
				if globalAssessmentId == "\(self.assessID ?? 0)" {
					self.objAssessment = obj
					self.checkDataDuplicacy(obj: obj)
					var arrIDs = [NSNumber]()
					
					self.certificateData.removeAll()
					if obj.vMixer.count > 0 {
						var idArr : [Int] = []
						for objn in  obj.vMixer {
							let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
							if idArr.contains(data!.id ?? 0){
								
							}else{
								idArr.append(data!.id ?? 0)
								if data != nil{
									self.certificateData.append(data!)
								}
							}
						}
					}
					
					let jsonExtendedMicro = self.createSyncRequestForExtendedMicro(dict: obj , certificationData : self.certificateData, saveType: saveType )
                    extendedMicroArr.removeAll()  // Pankush
					extendedMicroArr.append(jsonExtendedMicro)
					
					let ExtendedMicroparam = ["ExtendedMicrobialData":extendedMicroArr] as JSONDictionary
					self.convertDictToJson(dict: ExtendedMicroparam,apiName: "Extended")
					
					self.callExtendedMicro(param: ExtendedMicroparam)
				}
            }
        }
    }
    
    // MARK: - Sync button Tabbed
    func syncBtnTapped(showHud:Bool) {
        peAssessmentSyncArray.removeAll()
        peAssessmentSyncArray = getAllDateArrayStored()
        if peAssessmentSyncArray.count > 0 {
            if ConnectionManager.shared.hasConnectivity() {
                self.accessPEArrayObjects()
                
            } else {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
            }
        }else{
            if self.deletedAssessmentIdArray.count > 0{
                let alertController = UIAlertController(title: "Alert", message: String(format: "%d assessment(s) has been removed from the web. App data will be updated.", self.deletedAssessmentIdArray.count), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    _ in
                    let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
                    for id in self.deletedAssessmentIdArray{
                        CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentInOffline", predicate: NSPredicate(format: " userID == %d AND serverAssessmentId == %@", userID, id))
                    }
                    self.peHeaderViewController.titleofSync = "0"
                    self.peHeaderViewController.viewDidLoad()
                    self.getScheduledAssessments()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.dismissGlobalHUD(self.view ?? UIView())
                let errorMSg = "Data not available for sync"
                let alertController = UIAlertController(title: "No data available", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    _ in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Check Data Duplicacy
    func checkDataDuplicacy(obj: PENewAssessment) {
        self.dataDuplicacyCheck(assId: obj.serverAssessmentId!, customerId: obj.customerId!, siteId: obj.siteId!, evalDate: obj.evaluationDate!, evaulaterId: obj.evaluatorID!) { status in
            if status{
            }else{
                
                let alertController = UIAlertController(title: "Duplicate Data", message: "Assessment already captured with same customer and site Id on same evaluation date for same evaluator", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    self.showGlobalProgressHUDWithTitle(self.view, title: "Loading.")
                    self.getScheduledAssessments()
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                if let index = self.peAssessmentSyncArray.firstIndex(of: obj) {
                    self.peAssessmentSyncArray.remove(at: index)
                    if self.peAssessmentSyncArray.count == 0  {
                        self.dismissGlobalHUD(self.view)
                    }
                }
                
            }
        }
    }
    
    
    private func dataDuplicacyCheck(assId: String, customerId: Int, siteId: Int, evalDate: String, evaulaterId: Int, _ completion: @escaping (_ status: Bool) -> Void){
        let parameter = [
            "AssessmentId":assId,
            "SiteId": siteId,
            "CustomerId": customerId,
            "EvaulaterId": evaulaterId,
            "EvaluationDate": evalDate
        ] as JSONDictionary
        APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getDuplicacyCheck(controller: self, parameters: parameter, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
            guard let `self` = self, error == nil else { return }
            if json["Data"].boolValue == true{
                completion(false)
            }else{
                completion(true)
            }
        })
    }
    // MARK: - Post DOA Data to Server
    func callRequest2(paramForDoaInnovoject:JSONDictionary,json:JSON){
        let mjson = json
        self.convertDictToJson(dict: paramForDoaInnovoject,apiName: "add inovoject and day of age")
        APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.sendAddDayOfAgeAndInvoject(controller: self, parameters: paramForDoaInnovoject, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let `self` = self, error == nil else { return }
            
            if json["StatusCode"]  == 200{
                self.group.enter()
                if self.isSync {
                    self.handleSyncResponse(mjson)
                    
                }
                self.group.leave()
                
            } else {
                self.dismissGlobalHUD(self.view)
                self.showAlert(title: "Error", message: "Something went wrong in Vaccination sync, Please try again.", owner: self)
            }
        })
    }
    
    // MARK: - Post Data to Server
    func callRequest3(param:JSONDictionary){
        self.convertDictToJson(dict: param,apiName: "add score")
        APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.sendScoresDataToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let `self` = self, error == nil else { return }
            if json["StatusCode"]  == 200{
                self.group.enter()
                self.CalculateImageCount()
                self.group.leave()
                
            } else {
                self.dismissGlobalHUD(self.view)
                self.showAlert(title: "Error", message: "Something went wrong in Score sync, Please try again.", owner: self)
            }
        })
    }
    
    // MARK: - Post Images to Server
    func callRequest4(paramForImages:JSONDictionary){
        self.convertDictToJson(dict: paramForImages, apiName: "Test")
        callRequest4Int = callRequest4Int + 1
        Helper.showGlobalProgressHUDWithTitle(self.view, title: "Data sync is in progress, please do not close the app." + "\n" + "*Note - Please don't minimize App while syncing.")
        APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.sendMultipleImagesBase64ToServer(controller: self, parameters: paramForImages, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
            self?.callRequest4Int = self!   .callRequest4Int - 1
            
            if error != nil {
                
                let syncArr = self?.getAssessmentInOfflineFromDb()
                if syncArr ?? 0 > 0{
                    self?.syncBtnTapped(showHud: false)
                } else {
                    self?.showtoast(message: "Data synced successfully.")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                }
                
            }
            guard let `self` = self, error == nil else { return }
            self.dismissGlobalHUD(self.view)
            if json["StatusCode"]  == 200{
                if self.saveTypeString.contains(11)
                {
                    if self.saveTypeString.contains(00) {
                        CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                    }
                    CoreDataHandlerPE().updateOfflineStatus(assessment: self.objAssessment)
                } else {
                    CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                }
                
                if ConnectionManager.shared.hasConnectivity() {
                    if self.callRequest4Int == 0 {
                        
                        if self.regionID == 3
                        {
                            if HaveToCallExtendedMicro == true
                            {
                                
                                 let isEmRequested = CoreDataHandlerPE().fetchDraftEMRequestedData(assessmentId: self.objAssessment.serverAssessmentId ?? "") 
                                    
                                    self.syncExtendedMicrobial(saveType: isEmRequested ? 1: 0, statusType: 0)

                           
//                                var saveType = Int()
//                                let isExtendedAvailable = UserDefaults.standard.value(forKey: "extendedAvailable") as! Bool
//                                if Constants.isDraftAssessment == true && !isExtendedAvailable {
//                                    saveType = 0
//                                }
//                                else {
//                                    saveType = 1
//                                }
                                
                            }
                            
                        }
                        
                        let syncArr = self.getAssessmentInOfflineFromDb()
                        if syncArr > 0{
                            self.isSync = false
                            self.dismissGlobalHUD(self.view)
                            self.syncBtnTapped(showHud: false)
                            Helper.showGlobalProgressHUDWithTitle(self.view, title: "Data sync is in progress, please do not close the app." + "\n" + "*Note - Please don't minimize App while syncing.")
                        } else {
                            self.dismissGlobalHUD(self.view)
                            Helper.showGlobalProgressHUDWithTitle(self.view, title: "Data sync is in progress, please do not close the app." + "\n" + "*Note - Please don't minimize App while syncing.")
                            for i in self.totalImageToSync{
                                CoreDataHandlerPE().setImageStatusTrue(idArray: i)
                            }
                            self.showToastWithTimer(message: "Data Sync has been completed.", duration: 4.0)
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                            self.dismissGlobalHUD(self.view)
                        }
                    }
                }
            } else {
                self.dismissGlobalHUD(self.view)
            }
            
        })
    }
    
    // MARK: - Call Extended Micro
    func callExtendedMicro(param:JSONDictionary){
        
        APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.sendExtendedMicroToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let `self` = self, error == nil else { return }
            if json["StatusCode"]  == 200{
                if self.saveTypeString.contains(11)
                {
                    if self.saveTypeString.contains(00) {
                        CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                    }
                    CoreDataHandlerPE().updateOfflineStatus(assessment: self.objAssessment)
                } else {
                    CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                }
                self.dismissGlobalHUD(self.view)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                
            } else {
                // Condition added if APi failed because of any reason , so that user can finish this from the view session
                if self.objAssessment.IsEMRequested == true {
                    CoreDataHandlerPE().updateIsEMRequestedInAssessmentSwitch(isEMRequested: false, AssessmentId: objAssessment.serverAssessmentId ?? "")
                    CoreDataHandlerPE().updateIsEMRequestedInAssessmentSwitchOffline(isEMRequested: false, AssessmentId: objAssessment.serverAssessmentId ?? "")
                } else {
                    if self.saveTypeString.contains(11)
                    {
                        if self.saveTypeString.contains(00) {
                            CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                        }
                        CoreDataHandlerPE().updateOfflineStatus(assessment: self.objAssessment)
                    } else {
                        CoreDataHandlerPE().updateDraftStatus(assessment: self.objAssessment)
                    }
                }
                
                self.dismissGlobalHUD(self.view)
            }
        })
    }
    
    // MARK: - Handle Sync Responce
    private func handleSyncResponse(_ json: JSON) {
        if self.isSync {
            self.syncResponse = true
        }
        
        for obj in peAssessmentSyncArray{
            let sNumber = obj.dataToSubmitNumber ?? 0
            let dNumber = obj.draftNumber ?? 0
            var  getOfflineArray : [PENewAssessment] = []
            var  getDraftArray : [PENewAssessment] = []
            if syncResponse {
                if sNumber != 0 {
                    getOfflineArray = CoreDataHandlerPE().getOfflineAssessmentArray(id:obj.dataToSubmitID ?? "" )
                }
                if dNumber != 0 {
                    getDraftArray = CoreDataHandlerPE().getDraftAssessmentArray(id:obj.draftNumber ?? 0)
                }
                callRequest4Int = 0
                
                totalImageToSync = []
                
                if getOfflineArray.count > 0 {
                    var carColIdArray : [Int] = []
                    var catArray : [PENewAssessment] = []
                    var catAllRowArray : [PENewAssessment] = []
                    for cat in getOfflineArray {
                        if !carColIdArray.contains(cat.sequenceNo ?? 0){
                            carColIdArray.append(cat.sequenceNo ?? 0)
                            catArray.append(cat)
                        }
                    }
                    for objCt in catArray{
                        let catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatID(objCt.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber:obj.dataToSubmitNumber as NSNumber? ?? 0) as? [PENewAssessment] ?? []
                        
                        catAllRowArray.append(contentsOf: catArrayForTableIs)
                    }
                    var tempArr : [JSONDictionary]  = []
                    var comntArray : [JSONDictionary]  = []
                    var imgArray : [JSONDictionary]  = []
                    imgArray.removeAll()
                    for objCtIs in catAllRowArray {
                        let json = createSyncRequestForScore(dictArray: objCtIs)
                        let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                        tempArr.append(json)
                        comntArray.append(jsonComment)
                    }
                    let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":tempArr] as JSONDictionary
                    if self.isSync {
                        self.callRequest3(param:param)
                        self.syncResponse = false
                        
                    }
                    
                }
                
                if getDraftArray.count > 0 {
                    var carColIdArray : [Int] = []
                    var catArray : [PENewAssessment] = []
                    var catAllRowArray : [PENewAssessment] = []
                    for cat in getDraftArray {
                        if !carColIdArray.contains(cat.sequenceNo ?? 0){
                            carColIdArray.append(cat.sequenceNo ?? 0)
                            catArray.append(cat)
                        }
                    }
                    for objCt in catArray{
                        var catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatIDDraft(objCt.sequenceNo as NSNumber? ?? 0,draftNumber:obj.draftNumber as? NSNumber ?? 0) as? [PENewAssessment] ?? []
                        
                        catAllRowArray.append(contentsOf: catArrayForTableIs)
                    }
                    var tempArr : [JSONDictionary]  = []
                    var comntArray : [JSONDictionary]  = []
                    for objCtIs in catAllRowArray {
                        let json = createSyncRequestForScore(dictArray: objCtIs)
                        let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                        tempArr.append(json)
                        comntArray.append(jsonComment)
                    }
                    let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":tempArr] as JSONDictionary
                    if self.isSync {
                        self.callRequest3(param:param)
                        self.syncResponse = false
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Calculate Image Count
    func CalculateImageCount(){
        if self.isSync {
            self.syncResponse = true
        }
        for obj in peAssessmentSyncArray{
            let sNumber = obj.dataToSubmitNumber ?? 0
            let dNumber = obj.draftNumber ?? 0
            var  getOfflineArray : [PENewAssessment] = []
            var  getDraftArray : [PENewAssessment] = []
            if self.syncResponse {
                if sNumber != 0 {
                    getOfflineArray = CoreDataHandlerPE().getOfflineAssessmentArray(id:obj.dataToSubmitID ?? "" )
                    CoreDataHandlerPE().updateOfflineStatus(assessment: obj)
                }
                if dNumber != 0 {
                    getDraftArray = CoreDataHandlerPE().getDraftAssessmentArray(id:obj.draftNumber ?? 0)
                }
                callRequest4Int = 0
                
                totalImageToSync = []
                
                if getOfflineArray.count > 0 {
                    var carColIdArray : [Int] = []
                    var catArray : [PENewAssessment] = []
                    var catAllRowArray : [PENewAssessment] = []
                    for cat in getOfflineArray {
                        if !carColIdArray.contains(cat.sequenceNo ?? 0){
                            carColIdArray.append(cat.sequenceNo ?? 0)
                            catArray.append(cat)
                        }
                    }
                    for objCt in catArray{
                        let catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatID(objCt.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber:obj.dataToSubmitNumber as NSNumber? ?? 0) as? [PENewAssessment] ?? []
                        
                        catAllRowArray.append(contentsOf: catArrayForTableIs)
                    }
                    var tempArr : [JSONDictionary]  = []
                    var comntArray : [JSONDictionary]  = []
                    var imgArray : [JSONDictionary]  = []
                    
                    for objCtIs in catAllRowArray {
                        let json = createSyncRequestForScore(dictArray: objCtIs)
                        let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                        for i in objCtIs.images{
                            let status = CoreDataHandlerPE().imageAlreadySyncStatus(imageId: i) as? Bool ?? false
                            if status {
                                
                            } else {
                                let jsonIMages = createSyncRequestForImage(dictArray: objCtIs,img:i)
                                imgArray.append(jsonIMages)
                            }
                        }
                        tempArr.append(json)
                        comntArray.append(jsonComment)
                    }
                    let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":tempArr] as JSONDictionary
                    var arrayCount  = 0
                    var imgDic :  [JSONDictionary] = []
                    
                    if imgArray.count > 3 {
                        for objimgr in imgArray{
                            arrayCount  = arrayCount + 1
                            imgDic.append(objimgr)
                            if arrayCount == 3  {
                                let ss  = imgDic as?  [JSONDictionary]  ?? []
                                var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                                arrayCount  = 0
                                imgDic.removeAll()
                                self.group.enter()
                                self.callRequest4(paramForImages:paramForImages)
                                self.syncResponse = false
                                self.group.leave()
                                
                            }
                        }
                        if  arrayCount > 0 {
                            let ss  = imgDic as?  [JSONDictionary]  ?? []
                            var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                            arrayCount  = 0
                            imgDic.removeAll()
                            self.group.enter()
                            self.callRequest4(paramForImages:paramForImages)
                            self.syncResponse = false
                            self.group.leave()
                        }
                    } else {
                        var  paramForImages  = ["AssessmentImages":imgArray] as JSONDictionary
                        self.group.enter()
                        self.callRequest4(paramForImages:paramForImages)
                        self.syncResponse = false
                        self.group.leave()
                    }
                }
                
                if getDraftArray.count > 0 {
                    var carColIdArray : [Int] = []
                    var catArray : [PENewAssessment] = []
                    var catAllRowArray : [PENewAssessment] = []
                    for cat in getDraftArray {
                        if !carColIdArray.contains(cat.sequenceNo ?? 0){
                            carColIdArray.append(cat.sequenceNo ?? 0)
                            catArray.append(cat)
                        }
                    }
                    for objCt in catArray{
                        var catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatIDDraft(objCt.sequenceNo as NSNumber? ?? 0,draftNumber:obj.draftNumber as? NSNumber ?? 0) as? [PENewAssessment] ?? []
                        
                        catAllRowArray.append(contentsOf: catArrayForTableIs)
                    }
                    var tempArr : [JSONDictionary]  = []
                    var comntArray : [JSONDictionary]  = []
                    var imgArray : [JSONDictionary]  = []
                    
                    for objCtIs in catAllRowArray {
                        let json = createSyncRequestForScore(dictArray: objCtIs)
                        let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                        for i in objCtIs.images{
                            let status = CoreDataHandlerPE().imageAlreadySyncStatus(imageId: i) as? Bool ?? false
                            if status {
                                
                            } else {
                                let jsonIMages = createSyncRequestForImage(dictArray: objCtIs,img:i)
                                imgArray.append(jsonIMages)
                            }
                        }
                        tempArr.append(json)
                        comntArray.append(jsonComment)
                        
                    }
                    let param = ["AssessmentScoreData":tempArr,"AssessmentCommentsData":comntArray] as JSONDictionary
                    var arrayCount  = 0
                    var imgDic :  [JSONDictionary] = []
                    
                    if imgArray.count > 3 {
                        for objimgr in imgArray{
                            arrayCount  = arrayCount + 1
                            imgDic.append(objimgr)
                            if arrayCount == 3  {
                                let ss  = imgDic as?  [JSONDictionary]  ?? []
                                var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                                arrayCount  = 0
                                imgDic.removeAll()
                                self.group.enter()
                                self.callRequest4(paramForImages:paramForImages)
                                self.syncResponse = false
                                self.group.leave()
                            }
                        }
                        if  arrayCount > 0 {
                            let ss  = imgDic as?  [JSONDictionary]  ?? []
                            var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                            arrayCount  = 0
                            imgDic.removeAll()
                            self.group.enter()
                            self.callRequest4(paramForImages:paramForImages)
                            self.syncResponse = false
                            self.group.leave()
                        }
                    } else {
                        var  paramForImages  = ["AssessmentImages":imgArray] as JSONDictionary
                        self.group.enter()
                        self.callRequest4(paramForImages:paramForImages)
                        self.syncResponse = false
                        self.group.leave()
                    }
                }
            }
        }
    }
    // MARK: - Create Sync Request for Score Data
    func createSyncRequestForScore(dictArray: PENewAssessment) -> JSONDictionary{
        
        var UniID = dictArray.dataToSubmitID ?? ""
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var score = 0
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var TextAmPm = ""
        var PersonName = ""
        var FrequencyValue = 32
        var QCCount = ""
        var PPMValue = ""
        let assID =  dictArray.assID ?? 0
        
        if dictArray.rollOut == "Y" && dictArray.sequenceNoo == 3 && dictArray.qSeqNo == 12
        {
            QCCount =  dictArray.qcCount ?? ""
        } else if dictArray.rollOut == "Y" && dictArray.catName == "Miscellaneous"
        {
            TextAmPm =  dictArray.ampmValue ?? ""
        }
        else if  dictArray.rollOut == "Y" && dictArray.sequenceNoo == 5  && dictArray.qSeqNo == 5
        {
            PPMValue =  dictArray.ppmValue ?? ""
        }
        
        else if dictArray.rollOut == "Y" && dictArray.sequenceNoo == 3 && dictArray.qSeqNo == 1
        {
            PersonName =  dictArray.personName ?? ""
            let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
            let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
            let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
            if dictArray.frequency?.count ?? 0 > 0 {
                if visitNameArray.contains(dictArray.frequency ?? ""){
                    let indexOfe =  visitNameArray.index(of: dictArray.frequency ?? "")
                    FrequencyValue = visitIDArray[indexOfe] as? Int ?? 0
                }
            }
        }
        
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        if regionId == 3 {
            let json = [
                "DisplayId":DisplayId?.prefix(22) ?? "",
                "AppAssessmentId": String(AssessmentId),
                "ModuleAssessmentId": dictArray.assID ??  0,
                "AssessmentScore": score,
                "UserId": dictArray.userID ?? 0,
                "Device_Id": deviceIDFORSERVER,
                "QCCount":QCCount,
                "PersonName":PersonName,
                "FrequencyValue": FrequencyValue == 32 ? "" : FrequencyValue,
                "TextAmPm":TextAmPm,
                "AssessmentId": serverAssessmentId,
                "SequenceNo":dictArray.sequenceNoo ?? 0,
                "MaxScore":dictArray.assMaxScore ?? 0,
                "Chlorine_Value": PPMValue,
                "isNA":dictArray.isNA ?? false
            ] as JSONDictionary
            return json
        }
        
        else
        {
            let json = [
                "DisplayId":DisplayId?.prefix(22) ?? "",
                "AppAssessmentId": String(AssessmentId),
                "ModuleAssessmentId": dictArray.assID ??  0,
                "AssessmentScore": score,
                "UserId": dictArray.userID ?? 0,
                "Device_Id": deviceIDFORSERVER,
                "QCCount":QCCount,
                "PersonName":PersonName,
                "FrequencyValue": FrequencyValue == 32 ? "" : FrequencyValue,
                "TextAmPm":TextAmPm,
                "AssessmentId": serverAssessmentId,
                "SequenceNo":dictArray.sequenceNoo ?? 0,
                "MaxScore":dictArray.assMaxScore ?? 0,
                "isNA":dictArray.isNA ?? false
            ] as JSONDictionary
            return json
        }
        
    }
    // MARK: - Create Sync Request for Comment's
    func createSyncRequestForComment(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 2701
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let json = [
            "DisplayId":DisplayId?.prefix(22) ?? "",
            "AppAssessmentId":  String(AssessmentId),
            "ModuleAssessmentId": dictArray.assID ?? 0,
            "Comment": dictArray.note ?? "",
            "UserId": dictArray.userID ?? 0,
            "ModuleId": 1,
            "DeviceId":deviceIDFORSERVER,
            "AssessmentId":serverAssessmentId
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: - Create Sync Request for Image's
    func createSyncRequestForImage(dictArray: PENewAssessment,img:Int) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 2701
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        let base64Str = CoreDataHandlerPE().getImageBase64ByImageID(idArray:img)
        totalImageToSync.append(img)
        let imageName = "ImgName-" + siteId + String(img ?? 0)
        let unique = "\(deviceIDFORSERVER)_\(String(img ?? 0))_iOS_"
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        let json = [
            "DisplayId":DisplayId?.prefix(22),
            "Id": AssessmentId,
            "AssessmentDetailId": AssessmentId,
            "ModuleAssessmentId": dictArray.assID ?? 0,
            "Comment": dictArray.note,
            "UserId": dictArray.userID ?? 0,
            "CreatedAt": "2020-05-08T13:51:26.02701Z",
            "ModuleId": 1,
            "CommentTypeId": 1,
            "DeviceId":deviceIDFORSERVER,
            "ImageBase64String":base64Str,
            "FolderPath": "",
            "ImageName": imageName,
            "StrUniqueId":unique,
            "AssessmentId":deviceIdForServer
        ] as JSONDictionary
        return json
        
    }
    // MARK: - Create Sync Request for Inovoject's Data
    func createSyncRequestForInvoject(dictArray: PENewAssessment,inovojectData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 270101
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = inovojectData.invoHatchAntibiotic
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1 {
            HatcheryAntibiotics = true
        }
        
        var x = 0
        var vvv = inovojectData.ampuleSize
        var ampleSizeesNameArray = NSArray()
        var ampleSizeIDArray = NSArray()
        var ampleSizeDetailArray = NSArray()
        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if inovojectData.ampuleSize != "" {
            let xx = inovojectData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        
        var otherVaccine = ""
        var ManufacturerId = 0
        var vNameArray = NSArray()
        var vNameIDArray = NSArray()
        var vNameDetailsArray = NSArray()
        var VaccineId = 0
        vNameDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        vNameArray = vNameDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if vNameArray.contains(inovojectData.vaccineMan){
            let indexOfe = vNameArray.index(of: inovojectData.vaccineMan)
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
        } else {
            VaccineId = 0
        }
        
        var vNameDetailsArrayIS = NSArray()
        var vNameArrayIS = NSArray()
        var vNameIDArrayIS = NSArray()
        var vNameMfgIdArrayIS = NSArray()
        vNameDetailsArrayIS = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
        vNameArrayIS = vNameDetailsArrayIS.value(forKey: "name") as? NSArray ?? NSArray()
        vNameIDArrayIS = vNameDetailsArrayIS.value(forKey: "id") as? NSArray ?? NSArray()
        vNameMfgIdArrayIS = vNameDetailsArrayIS.value(forKey: "mfgId") as? NSArray ?? NSArray()
        
        if vNameArrayIS.contains(inovojectData.name){
            let indexOfe = vNameArrayIS.index(of: inovojectData.name)
            VaccineId = vNameIDArrayIS[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArrayIS[indexOfe] as? Int ?? 0
        } else if (inovojectData.name != ""){
            otherVaccine = inovojectData.name ?? ""
        }
        var y = 2
        
        let DManufacturerId = 0
        var DNameArray = NSArray()
        var DNameIDArray = NSArray()
        var DNameDetailsArray = NSArray()
        DNameDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DManufacturer")
        
        let indexOfg = DNameArray.index(of: inovojectData.vaccineMan)
        var dManufacture = 0
        let timestamp = Date().currentTimeMillis()
        let uni = ManufacturerId + Int(timestamp) + x
        let unique = "\(deviceIDFORSERVER)_\(inovojectData.id)_iOS_"
        let ampulePerBag = Int(inovojectData.ampulePerBag ?? "0")
        var AntibioticInformation  =  ""
        if HatcheryAntibiotics {
            AntibioticInformation =  inovojectData.invoHatchAntibioticText ?? ""
        }
        var json = [
            "VaccineId":  VaccineId == 0 ? "" : VaccineId,
            "AmpulePerbag":ampulePerBag == 0 ? "" : ampulePerBag,
            "AmpuleSize":  x == 0 ? "" : x,
            "AppAssessmentId": String(AssessmentId),
            "BagSizeType":inovojectData.bagSizeType,
            "Device_Id": deviceIDFORSERVER,
            "DiluentMfg": inovojectData.vaccineMan,
            "DisplayId": DisplayId?.prefix(22),
            "HatcheryAntibiotics": HatcheryAntibiotics,
            "ManufacturerId":  ManufacturerId == 0 ? "" : ManufacturerId,
            "ModuleAssessmentCatId": dictArray.catID,
            "Dosage": inovojectData.dosage,
            "StrUniqueId":unique,
            "OtherText":otherVaccine,
            "SecquenceId":0,
            "AntibioticInformation": AntibioticInformation,
            "DiluentsMfgOtherName":inovojectData.doaDilManOther ?? "",
            "ProgramName": inovojectData.invoProgramName,
            "AssessmentId":serverAssessmentId
            
        ] as JSONDictionary
        let doaDilManOther =  inovojectData.doaDilManOther ?? ""
        
        if doaDilManOther == "" {
            json.removeValue(forKey: "DiluentsMfgOtherName")
        }
        if ManufacturerId == 0  {
            json["ManufacturerId"] =  ManufacturerId == 0 ? "" : ManufacturerId
            json.removeValue(forKey: "ManufacturerId")
        }
        return json
        
    }
    
    // MARK: - Create Sync Request for DOA's Data
    func createSyncRequestForDOA(dictArray: PENewAssessment,dayOfAgeData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = dictArray.hatcheryAntibioticsDoa
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1  {
            HatcheryAntibiotics = true
        }
        
        var x = 0
        var vvv = dayOfAgeData.ampuleSize
        var ampleSizeesNameArray = NSArray()
        var ampleSizeIDArray = NSArray()
        var ampleSizeDetailArray = NSArray()
        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if dayOfAgeData.ampuleSize != "" {
            let xx = dayOfAgeData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        
        var VaccineId = 0
        var otherVaccine = ""
        var ManufacturerId = 0
        var vNameArray = NSArray()
        var vNameIDArray = NSArray()
        var vNameDetailsArray = NSArray()
        vNameDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
        vNameArray = vNameDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
        vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        var vNameMfgIdArray = vNameDetailsArray.value(forKey: "mfgId") as? NSArray ?? NSArray()
        
        if vNameArray.contains(dayOfAgeData.name){
            let indexOfe =  vNameArray.index(of: dayOfAgeData.name)
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArray[indexOfe] as? Int ?? 0
        } else if (dayOfAgeData.name != ""){
            otherVaccine = dayOfAgeData.name ?? ""
        }
        
        var vManufacutrerNameArray = NSArray()
        var vManufacutrerIDArray = NSArray()
        var vManufacutrerDetailsArray = NSArray()
        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if vManufacutrerNameArray.contains(dayOfAgeData.vaccineMan){
            let indexOfe =  vManufacutrerNameArray.index(of: dayOfAgeData.vaccineMan) //
            ManufacturerId = vManufacutrerIDArray[indexOfe] as? Int ?? 0
        }
        
        let timestamp = Date().currentTimeMillis()
        let uni = ManufacturerId + Int(timestamp) + x
        let unique = "\(deviceIDFORSERVER)_\(dayOfAgeData.id)_iOS_"
        let ampulePerBag = Int(dayOfAgeData.ampulePerBag ?? "0")
        var AntibioticInformation  =  ""
        
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: dictArray.serverAssessmentId ?? "")
        if HatcheryAntibiotics {
            AntibioticInformation =  dictArray.hatcheryAntibioticsDoaText ?? ""
        }
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let json = [
            "AppAssessmentId": String(AssessmentId),
            "DayOfAgeAmpulePerbag": ampulePerBag == 0 ? "" : ampulePerBag,
            "DayOfAgeAmpuleSize":  x == 0 ? "" : x,
            "DayOfAgeBagSizeType": dictArray.dDT,
            "DayOfAgeMfgId":  ManufacturerId == 0 ? "" : ManufacturerId,
            "DayOfAgeMfgNameId":  VaccineId == 0 ? "" : VaccineId,
            "DayOfBagHatcheryAntibiotics": HatcheryAntibiotics,
            "Device_Id": deviceIDFORSERVER,
            "DiluentMfg": dictArray.dCS,
            "DisplayId": DisplayId?.prefix(22),
            "ModuleAssessmentCatId": dictArray.catID,
            "DayOfAgeDosage": dayOfAgeData.dosage,
            "StrUniqueId":unique,
            "OtherText":otherVaccine,
            "SecquenceId":0,
            "AntibioticInformation":AntibioticInformation,
            "AssessmentId":serverAssessmentId
        ] as JSONDictionary
        return json
    }
    
    func createSyncRequestForDOAS(dictArray: PENewAssessment,dayOfAgeData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = dictArray.hatcheryAntibioticsDoaS
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1  {
            HatcheryAntibiotics = true
        }
        var x = 0
        
        var vvv = dayOfAgeData.ampuleSize
        var ampleSizeesNameArray = NSArray()
        var ampleSizeIDArray = NSArray()
        var ampleSizeDetailArray = NSArray()
        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if dayOfAgeData.ampuleSize != "" {
            let xx = dayOfAgeData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        var VaccineId = 0
        var otherVaccine = ""
        var ManufacturerId = 0
        var vNameArray = NSArray()
        var vNameIDArray = NSArray()
        var vNameDetailsArray = NSArray()
        vNameDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
        vNameArray = vNameDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
        vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        var vNameMfgIdArray = vNameDetailsArray.value(forKey: "mfgId") as? NSArray ?? NSArray()
        if vNameArray.contains(dayOfAgeData.name){
            let indexOfe =  vNameArray.index(of: dayOfAgeData.name) //
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArray[indexOfe] as? Int ?? 0
        } else if (dayOfAgeData.name != ""){
            otherVaccine = dayOfAgeData.name ?? ""
        }
        
        var vManufacutrerNameArray = NSArray()
        var vManufacutrerIDArray = NSArray()
        var vManufacutrerDetailsArray = NSArray()
        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if vManufacutrerNameArray.contains(dayOfAgeData.vaccineMan){
            let indexOfe =  vManufacutrerNameArray.index(of: dayOfAgeData.vaccineMan) //
            ManufacturerId = vManufacutrerIDArray[indexOfe] as? Int ?? 0
        }
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(dayOfAgeData.id)_iOS_"
        var AntibioticInformation  =  ""
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: dictArray.serverAssessmentId ?? "")
        
        if HatcheryAntibiotics {
            AntibioticInformation =  dictArray.hatcheryAntibioticsDoaSText ?? ""
        }
        let ampulePerBag = Int(dayOfAgeData.ampulePerBag ?? "0")
        var json = [
            
            "DayAgeSubcutaneousBagSizeType": dictArray.dDDT,
            "Device_Id": deviceIDFORSERVER,
            "DisplayId": DisplayId?.prefix(22) ?? "",
            "ModuleAssessmentCatId":  dictArray.catID ?? "",
            "StrUniqueId":unique,
            "SecquenceId": 0,
            "AppAssessmentId":  String(AssessmentId)] as JSONDictionary
        
        json["DayAgeSubcutaneousHatcheryAntibiotics"] = HatcheryAntibiotics
        json["DayAgeSubcutaneousMfgId"] =  ManufacturerId == 0 ? "" : ManufacturerId
        json["DayAgeSubcutaneousDosage"] = dayOfAgeData.dosage ?? ""
        json["DayAgeSubcutaneousMfgNameId"] =  VaccineId == 0 ? "" : VaccineId;
        json["OtherText"] =  otherVaccine
        json["DayAgeSubcutaneousDiluentMfg"] =   dictArray.dDCS
        json["DayAgeSubcutaneousAmpuleSize"] =   x == 0 ? "" : x
        json["DayAgeSubcutaneousAmpulePerbag"] =  ampulePerBag == 0 ? "" : (ampulePerBag ?? 0)
        json["AntibioticInformation"] =  AntibioticInformation
        json["AssessmentId"] = serverAssessmentId
        return json
        
    }
    // MARK: - Create Sync Request for Certificate's
    func createSyncRequestForCertificateData(dictArray: PENewAssessment,peCertificateData :PECertificateData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 2701
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let uni = dictArray.userID ?? 433 + Int(timestamp)
        let unique = "\(deviceIDFORSERVER)_\(peCertificateData.id)_iOS_"
        
        var resultString = String()
        if(regionID != 3){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: peCertificateData.certificateDate ?? "")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if date != nil {
                resultString = dateFormatter.string(from: date ?? Date())
                
            } else {
                resultString =  ""
            }
        }
        else{
            resultString = peCertificateData.certificateDate ?? ""
        }
        
        if regionID == 3
        {
            
            let json = [
                "Id": AssessmentId,
                "AssessmentId": serverAssessmentId,//AssessmentId,
                "AssessmentDetailId": AssessmentId,
                "ModuleAssessmentId": 0,
                "Name": peCertificateData.name,
                "CertificationDate": resultString,
                "AlternateName": "string",
                "CertificationDate2": "2020-05-23T06:36:50.915Z",
                "ModuleAssessmentCatId":  dictArray.catID,
                "userId": dictArray.userID,
                "DeviceId": deviceIDFORSERVER,
                "ResidueName": dictArray.residue,
                "MicroSamplesName": dictArray.micro,
                "EvaluationTypeId": 1,
                "AppAssessmentId": String(AssessmentId),
                "DisplayId": DisplayId?.prefix(22),
                "StrUniqueId":unique,
                "IsCertiExpired": peCertificateData.isCertExpired,
                "VacOperatorId": peCertificateData.vacOperatorId ?? 0,
                "IsRecert": peCertificateData.isReCert,
                "SignatureImg": peCertificateData.signatureImg ?? "",
                "CertCeatedby": peCertificateData.certCeatedby ?? 0
            ] as JSONDictionary
            return json
        }
        
        else
        {
            
            let json = [
                "Id": AssessmentId,
                "AssessmentId": serverAssessmentId,//AssessmentId,
                "AssessmentDetailId": AssessmentId,
                "ModuleAssessmentId": 0,
                "Name": peCertificateData.name,
                "CertificationDate": resultString,
                "AlternateName": "string",
                "CertificationDate2": "2020-05-23T06:36:50.915Z",
                "ModuleAssessmentCatId":  dictArray.catID,
                "userId": dictArray.userID,
                "DeviceId": deviceIDFORSERVER,
                "ResidueName": dictArray.residue,
                "MicroSamplesName": dictArray.micro,
                "EvaluationTypeId": 1,
                "AppAssessmentId": String(AssessmentId),
                "DisplayId": DisplayId?.prefix(22),
                "StrUniqueId":unique,
                "SignatureImg": peCertificateData.signatureImg ?? "",
                "CertCeatedby": peCertificateData.certCeatedby ?? 0
            ] as JSONDictionary
            return json
        }
        
    }
    // MARK: - Create Sync Request for Residue's
    func createSyncRequestForResidueData(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var serverAssessmentId: Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 2701
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let uni = dictArray.userID ?? 32 + Int(timestamp)
        let unique = "\(deviceIDFORSERVER)_\(dictArray.residue)_iOS_"
        
        let json = [
            "AssessmentId": serverAssessmentId,
            "AssessmentDetailId": dictArray.assID ?? 0,
            "StrUniqueId": unique,
            "ModuleAssessmentId": dictArray.catID,
            "ResidueName":dictArray.residue,
            "MicroSamplesName": dictArray.micro,
            "EvaluationTypeId": 1,
            "AppAssessmentId": String(AssessmentId),
            "DisplayId": DisplayId?.prefix(22),
            "UserId": dictArray.userID,
            "CreatedAt": "2020-06-11T12:53:38.930Z",
            "DeviceId": deviceIDFORSERVER,
            "ModuleAssessmentCatId": dictArray.catID
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: - Create Sync Request for Microbial's Data
    func createSyncRequestForMicroData(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var score = 0
        
        if dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        var sID = dictArray.siteId ?? 0
        sID = sID + 2701
        var dID = AssessmentId ?? 0
        dID = dID + 2903
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let uni = dictArray.userID ?? 32 + Int(timestamp)
        let unique = "\(deviceIDFORSERVER)_\(dictArray.micro)_iOS_"
        
        let json = [
            "Id": AssessmentId,
            "AssessmentId": serverAssessmentId,
            "AssessmentDetailId": dictArray.assID ?? 0,
            "ModuleAssessmentId": 0,
            "Name": "",
            "CertificationDate": "",
            "AlternateName": "string",
            "CertificationDate2": "2020-05-23T06:36:50.915Z",
            "ModuleAssessmentCatId":  dictArray.catID,
            "userId": dictArray.userID,
            "DeviceId": deviceIDFORSERVER,
            "ResidueName": dictArray.residue,
            "MicroSamplesName": dictArray.micro,
            "EvaluationTypeId": 1,
            "AppAssessmentId": String(AssessmentId),
            "DisplayId": DisplayId?.prefix(22),
            "StrUniqueId":unique
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: - Create Sync Request for Assessment's
    func createSyncRequest(dict: PENewAssessment ,certificationData : [PECertificateData]) -> JSONDictionary{
        debugPrint("dict---\(dict)")
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dict.dataToSubmitID ?? ""
        
        let evaluationDate = dict.evaluationDate
        if UniID == "" {
            UniID = dict.draftID ?? ""
        }
        var Complete = 1
        var Draft = 0
        var SaveType = 1
        saveTypeString.append(11)
        var AssessmentId = dict.dataToSubmitNumber ?? 0
        let deviceIdForServer = "\(UniID)_1_iOS_\(udid)"
        deviceIDFORSERVER = deviceIdForServer
        
        if AssessmentId == 0 {
            if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
                deviceIDFORSERVER = dict.assDetail2 ?? ""
            }
            AssessmentId = dict.draftNumber ?? 0
            Draft = 1
            Complete = 0
            SaveType = 0
            saveTypeString.append(00)
        }
        if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
            deviceIDFORSERVER = dict.assDetail2 ?? ""
        }
        var serverAssessmentId:Int64 = 0
        if dict.serverAssessmentId != nil{
            serverAssessmentId = Int64( dict.serverAssessmentId ?? "") ?? 0
        }
        let DocId = ""
        let VisitId = dict.visitID
        let CustomerId = dict.customerId
        let SiteId = dict.siteId
        let IncubationStyle = dict.incubation
        let EvaluationId = dict.evaluationID
        let BreedBirds = dict.breedOfBird
        var EvaluationDate = ""
        let EvaulaterId = dict.evaluatorID
        var hacheryAntibiotics:Bool = false
        if dict.hatcheryAntibiotics == 1{
            hacheryAntibiotics = true
        }
        
        var TSRIdUser = dict.selectedTSR
        var  TSRId  = dict.selectedTSRID
        
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
        let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray ()
        let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray ()
        if dict.selectedTSR?.count ?? 0 > 0 {
            if visitNameArray.contains(dict.selectedTSR ?? ""){
                let indexOfe =  visitNameArray.index(of: dict.selectedTSR ?? "") //
                TSRId = visitIDArray[indexOfe] as? Int ?? 0
            }
        }
        
        let countryID = UserDefaults.standard.integer(forKey: "nonUScountryId")
        var fluid : Bool = false
        var basicTransfr:Bool = false
        
        fluid = dict.fluid!
        basicTransfr = dict.basicTransfer!
        
        let HatchAnti = false
        var Camera = false
        if  dict.camera == 1 {
            Camera = true
        }
        
        var man = dict.manufacturer  ?? ""
        var manOther =  ""
        if  man != "" {
            if let character = dict.manufacturer?.character(at:0) {
                if character == "S"{
                    let str =  man.replacingOccurrences(of: "S", with: "")
                    manOther = str
                    man = "Other"
                }
            }
        }
        var eggg = ""
        var egggOther =  ""
        let xx = String(dict.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                let str =  xx.replacingOccurrences(of: "000", with: "")
                egggOther = str
                eggg = "Other"
            } else {
                eggg = xx
            }
        }
        
        var breeedd = dict.breedOfBird  ?? ""
        var breeeddOther =  ""
        if breeedd != "" {
            if let character = breeedd.character(at:0) {
                if character == "S".character(at: 0){
                    let str =  breeedd.replacingOccurrences(of: "S", with: "")
                    breeeddOther = str
                    breeedd = "Other"
                    
                }
            }
        }
        breeeddOther = dict.breedOfBirdOther ?? ""
        
        var ManufacturerId = 0
        var EggID = 0
        var breeddId = 0
        var manufacutrerNameArray = NSArray()
        var manufacutrerIDArray = NSArray()
        var manufacutrerDetailsArray = NSArray()
        manufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Manufacturer")
        manufacutrerNameArray = manufacutrerDetailsArray.value(forKey: "mFG_Name") as? NSArray ?? NSArray()
        manufacutrerIDArray = manufacutrerDetailsArray.value(forKey: "mFG_Id") as? NSArray ?? NSArray()
        if man != "" {
            let indexOfd = manufacutrerNameArray.index(of: man) // 3
            ManufacturerId = manufacutrerIDArray[indexOfd] as? Int ?? 0
        }
        
        var BirdBreedIDArray = NSArray()
        var BirdBreedNameArray = NSArray()
        var BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_BirdBreed")
        BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "birdBreedName") as? NSArray ?? NSArray()
        BirdBreedIDArray = BirdBreedDetailsArray.value(forKey: "birdId") as? NSArray ?? NSArray()
        if breeedd != "" {
            let indexOfe = BirdBreedNameArray.index(of: breeedd) // 3
            breeddId = BirdBreedIDArray[indexOfe] as? Int ?? 0
        }
        var EggsIDArray = NSArray()
        var EggsNameArray = NSArray()
        let EggsDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Eggs")
        EggsNameArray = EggsDetailsArray.value(forKey: "eggCount") as? NSArray ?? NSArray()
        EggsIDArray = EggsDetailsArray.value(forKey: "eggId") as? NSArray ?? NSArray()
        if eggg != "" {
            let indexOfp = EggsNameArray.index(of: eggg) // 3
            EggID = EggsIDArray[indexOfp] as? Int ?? 0
        }
        
        let FlockAgeId = dict.isFlopSelected
        let Status_Type = ""
        let UserId = dict
            .userID
        let RepresentativeName = ""
        let Notes = dict.notes
        let dateFormatter = DateFormatter()
        
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        if regionId != 3 {
            dateFormatter.dateFormat = "dd/MM/YYYY HH:mm:ss Z"
            let date = dict.evaluationDate?.toDate(withFormat: "dd/MM/YYYY")
            let datastr = date?.toString(withFormat: "dd/MM/YYYY HH:mm:ss Z")
        }
        else{
            dateFormatter.dateFormat="MM/dd/YYYY"
            
            let date = dict.evaluationDate?.toDate(withFormat: "MM/dd/YYYY")
            let datastr = date?.toString(withFormat: "MM/dd/YYYY HH:mm:ss Z")
        }
        
        let  sig_Datetext = dict.sig_Date
        var dateSig = ""
        let ddd = dict.sig_Date ?? ""
        if ddd != "" {
            dateSig = self.convertDateFormat(inputDate: ddd)
        }
        
        let sig_Nametext2 = dict.sig_Name2
        let sig_Nametext = dict.sig_Name
        let sig_Phonetext = dict.sig_Phone
        let sig_EmployeeIDtext = dict.sig_EmpID
        let sig_EmployeeIDtext2 = dict.sig_EmpID2
        let sigNumber = dict.sig ?? 0
        let sigNumber2 = dict.sig2 ?? 0
        let statusType = dict.statusType ?? 0
        var base64Str = ""
        var base64Str2 = ""
        if sigNumber == 0 {
        } else {
            base64Str = CoreDataHandlerPE().getImageBase64ByImageID(idArray:(dict.sig) ?? 0)
        }
        if sigNumber2 == 0 {
        } else {
            base64Str2 = CoreDataHandlerPE().getImageBase64ByImageID(idArray:(dict.sig2) ?? 0)
        }
        
        var DisplayId = dict.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        var iStle = 0
        var iStleIDArray = NSArray()
        var iStleNameArray = NSArray()
        let iStleDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_IncubationStyle")
        iStleNameArray = iStleDetailsArray.value(forKey: "incubationStylesName") as? NSArray ?? NSArray()
        iStleIDArray = iStleDetailsArray.value(forKey: "incubationId") as? NSArray ?? NSArray()
        if IncubationStyle?.count ?? 0 > 1 {
            let indexOfe = iStleNameArray.index(of: IncubationStyle ?? "") // 3
            iStle = iStleIDArray[indexOfe] as? Int ?? 0
        }
        var rollID = 0
        var rollIDArray = NSArray()
        var rollNameArray = NSArray()
        let rollDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Roles")
        rollNameArray = rollDetailsArray.value(forKey: "roleName") as? NSArray ?? NSArray()
        rollIDArray = rollDetailsArray.value(forKey: "roleId") as? NSArray ?? NSArray()
        if sig_EmployeeIDtext?.count ?? 0 > 1 {
            let indexOfe = rollNameArray.index(of: sig_EmployeeIDtext ?? "") // 3
            rollID = rollIDArray[indexOfe] as? Int ?? 0
        }
        
        var rollID2 = 0
        if sig_EmployeeIDtext2?.count ?? 0 > 1 {
            let indexOfe = rollNameArray.index(of: sig_EmployeeIDtext2 ?? "") // 3
            rollID2 = rollIDArray[indexOfe] as? Int ?? 0
        }
        
        dict.evaluationDate = dateSig
        
        var json : JSONDictionary = JSONDictionary()
        if dateSig != ""{
            dict.evaluationDate = dateSig
        }else{
            let convertDateFormatter = DateFormatter()
            convertDateFormatter.dateFormat = "yyyy-MM-dd"
            convertDateFormatter.timeZone = Calendar.current.timeZone
            convertDateFormatter.locale = Calendar.current.locale
        }
        let userInfo = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: dict.serverAssessmentId ?? "")
        
        let dateFormatterObj = CodeHelper.sharedInstance.getDateFormatterObj("")
        if regionId == 3 {
            dateFormatterObj.dateFormat = "MM/dd/yyyy"
        }
        else
        {
            dateFormatterObj.dateFormat = "dd/MM/yyyy"
        }
        
        let evalDateObj = dateFormatterObj.date(from: evaluationDate ?? "")
        dateFormatterObj.dateFormat = "yyyy-MM-dd"
        let evalDateStr = dateFormatterObj.string(from: evalDateObj ?? Date())
        dict.evaluationDate = evalDateStr
        var FSRsign = ""
        if certificationData.count > 0 {
            FSRsign = certificateData[0].fsrSign
        }
        let inovoFluid : Bool
        let basicTransfer : Bool
        let countryName = dict.countryName
        let countryIDSelc = dict.countryID
        inovoFluid = dict.fluid!
        basicTransfer = dict.basicTransfer!
        let isEMRequested = dict.IsEMRequested ?? false
        let RegionalId = UserDefaults.standard.integer(forKey: "Regionid")
        let extndMicro = dict.extndMicro ?? false
        let isHandMix = dict.isHandMix ?? false
        let ppmValue = dict.ppmValue ?? ""
        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if regionID == 3
        {
            if SaveType == 0 {
                if statusType == 2 {
                    
                    json = [
                        "AppAssessmentId":String(AssessmentId),
                        "Camera": Camera,
                        "CustomerId": CustomerId ?? 0,
                        "AppCreationTime": UniID.prefix(22),
                        "DeviceId": deviceIDFORSERVER,
                        "DisplayId":DisplayId?.prefix(22),
                        "EvaluationDate": evalDateStr,
                        "EvaluationId": EvaluationId ?? 0,
                        "EvaluationTypeText": dict.evaluationName ?? "",
                        "EvaulaterId": EvaulaterId ?? 0,
                        "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                        "IncubationStyle": iStle,
                        "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                        "SaveType":SaveType,
                        "Status_Type":statusType,
                        "RepresentativeName":sig_Nametext,
                        "RepresentativeName2":sig_Nametext2,
                        "RepresentativeNotes":sig_Phonetext,
                        "SignatureImage": base64Str,
                        "SignatureImage2": base64Str2,
                        "SignatureDate":dateSig,
                        "RoleId":rollID,
                        "RoleId2":rollID2 == 0 ? "" : rollID2,
                        "SiteId": SiteId,
                        "TSRId": TSRId,
                        "UserId": UserId,
                        "VisitId": VisitId,
                        "AssessmentId":serverAssessmentId,
                        "BreedBirds": breeddId == 0 ? "" : breeddId,
                        "EggsPerFlat": EggID == 0 ? "" : EggID,
                        "ManufacturerOther": manOther,
                        "BreedOfBirdsOther": breeeddOther,
                        "EggsPerFlatOther": egggOther,
                        "Notes": Notes,
                        "DoubleSanitation":hacheryAntibiotics,
                        "SanitationEmbrex":  dict.sanitationValue, //userInfo?.isExtendedPE ?? false,
                        "HasChlorineStrips" :  dict.isChlorineStrip ?? false,
                        "IsAutomaticFail" :  dict.isAutomaticFail ?? false,
                        "FSTSignatureImage": FSRsign,
                        "IsEMRequested" : isEMRequested,
                        "RefrigeratorNote": dict.refrigeratorNote ?? "",
                        "RegionId" : RegionalId,
                        "IsInterMicrobial": extndMicro,
                        "CountryId":countryID,
                        "IsInovoFluids": false,
                        "IsBasicTrfAssessment" :  false,
                        "ChlorineId" :  "",
                        "Handmix" : isHandMix ?? false
                    ] as JSONDictionary
                }else{
                    json = [
                        "AppAssessmentId":String(AssessmentId),
                        "Camera": Camera,
                        "CustomerId": CustomerId ?? 0,
                        "AppCreationTime": UniID.prefix(22),
                        "DeviceId": deviceIDFORSERVER,
                        "DisplayId":DisplayId?.prefix(22),
                        "EvaluationDate": evalDateStr,
                        "EvaluationId": EvaluationId ?? 0,
                        "EvaluationTypeText": dict.evaluationName ?? "",
                        "EvaulaterId": EvaulaterId ?? 0,
                        "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                        "IncubationStyle": iStle,
                        "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                        "SaveType":SaveType,
                        "Status_Type":statusType,
                        "SiteId": SiteId,
                        "TSRId": TSRId,
                        "UserId": UserId,
                        "VisitId": VisitId,
                        "AssessmentId":serverAssessmentId,
                        "BreedBirds": breeddId == 0 ? "" : breeddId,
                        "EggsPerFlat": EggID == 0 ? "" : EggID,
                        "ManufacturerOther": manOther,
                        "BreedOfBirdsOther": breeeddOther,
                        "EggsPerFlatOther": egggOther,
                        "Notes": Notes,
                        "DoubleSanitation":hacheryAntibiotics,
                        "SanitationEmbrex": dict.sanitationValue, //userInfo?.isExtendedPE ?? false,
                        "HasChlorineStrips" :  dict.isChlorineStrip ?? false,
                        "IsAutomaticFail" :  dict.isAutomaticFail ?? false,
                        "FSTSignatureImage": FSRsign,
                        "IsEMRequested" : isEMRequested,
                        "RefrigeratorNote": dict.refrigeratorNote ?? "",
                        "RegionId" : RegionalId,
                        "IsInterMicrobial": extndMicro,
                        "CountryId":countryID,
                        "IsInovoFluids": false,
                        "IsBasicTrfAssessment" :  false,
                        "ChlorineId" :  "",
                        "Handmix" :isHandMix ?? false
                        
                    ] as JSONDictionary
                }
            } else {
                json = [
                    "AppAssessmentId":String(AssessmentId),
                    "DisplayId":DisplayId?.prefix(22),
                    "VisitId": VisitId,
                    "CustomerId": CustomerId,
                    "SiteId": SiteId,
                    "IncubationStyle": iStle,
                    "EvaluationId": EvaluationId,
                    "BreedBirds": breeddId == 0 ? "" : breeddId,
                    "EvaluationDate": evalDateStr,
                    "EvaulaterId": EvaulaterId ?? 0,
                    "TSRId": TSRId,
                    "Camera": Camera,
                    "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                    "EggsPerFlat": EggID == 0 ? "" : EggID,
                    "Notes": Notes,
                    "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                    "SaveType":SaveType,
                    "UserId": UserId,
                    "DeviceId": deviceIDFORSERVER,
                    "RepresentativeName":sig_Nametext,
                    "RepresentativeName2":sig_Nametext2,
                    "RepresentativeNotes":sig_Phonetext,
                    "SignatureImage": base64Str,
                    "SignatureImage2": base64Str2,
                    "ManufacturerOther": manOther,
                    "BreedOfBirdsOther": breeeddOther,
                    "EggsPerFlatOther": egggOther,
                    "RoleId":rollID,
                    "RoleId2":rollID2 == 0 ? "" : rollID2,
                    "EvaluationTypeText": dict.evaluationName,
                    "AppCreationTime": UniID.prefix(22),
                    "SignatureDate":dateSig,
                    "AssessmentId":serverAssessmentId,
                    "DoubleSanitation":hacheryAntibiotics,
                    "SanitationEmbrex":  dict.sanitationValue,
                    "HasChlorineStrips" :  dict.isChlorineStrip ?? false,
                    "IsAutomaticFail" :  dict.isAutomaticFail ?? false,
                    "FSTSignatureImage": FSRsign,
                    "IsEMRequested" : isEMRequested,
                    "RefrigeratorNote": dict.refrigeratorNote ?? "",
                    "RegionId" : RegionalId,
                    "IsInterMicrobial": extndMicro,
                    "CountryId":countryID,
                    "IsInovoFluids": false,
                    "IsBasicTrfAssessment" :  false,
                    "ChlorineId" :  "",
                    "Handmix" : isHandMix ?? false
                    
                    
                ] as JSONDictionary
            }
            return json
        }
        
        else
        {
            let re_note =    UserDefaults.standard.value(forKey: "re_note")
            if SaveType == 0 {
                if statusType == 2 {
                    
                    json = [
                        "AppAssessmentId":String(AssessmentId),
                        "Camera": Camera,
                        "CustomerId": CustomerId ?? 0,
                        "AppCreationTime": UniID.prefix(22),
                        "DeviceId": deviceIDFORSERVER,
                        "DisplayId":DisplayId?.prefix(22),
                        "EvaluationDate": evalDateStr,
                        "EvaluationId": EvaluationId ?? 0,
                        "EvaluationTypeText": dict.evaluationName ?? "",
                        "EvaulaterId": EvaulaterId ?? 0,
                        "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                        "IncubationStyle": iStle,
                        "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                        "SaveType":SaveType,
                        "Status_Type":statusType,
                        "RepresentativeName":sig_Nametext,
                        "RepresentativeName2":sig_Nametext2,
                        "RepresentativeNotes":sig_Phonetext,
                        "SignatureImage": base64Str,
                        "SignatureImage2": base64Str2,
                        "SignatureDate":dateSig,
                        "RoleId":rollID,
                        "RoleId2":rollID2 == 0 ? "" : rollID2,
                        "SiteId": SiteId,
                        "TSRId": TSRId,
                        "UserId": UserId,
                        "VisitId": VisitId,
                        "AssessmentId":serverAssessmentId,
                        "BreedBirds": breeddId == 0 ? "" : breeddId,
                        "EggsPerFlat": EggID == 0 ? "" : EggID,
                        "ManufacturerOther": manOther,
                        "BreedOfBirdsOther": breeeddOther,
                        "EggsPerFlatOther": egggOther,
                        "Notes": Notes,
                        "DoubleSanitation":hacheryAntibiotics,
                        "SanitationEmbrex": false,//userInfo?.isExtendedPE ?? false, for PE International this required to be false
                        "IsAutomaticFail" :  dict.isAutomaticFail ?? 0, //userInfo?.isAutomaticFail ?? false,
                        "FSTSignatureImage": FSRsign,
                        "IsInterMicrobial" : extndMicro,
                        "RefrigeratorNote": re_note,
                        "RegionId" : RegionalId,
                        "CountryId":countryIDSelc,
                        "IsInovoFluids": inovoFluid,
                        "IsBasicTrfAssessment" :  basicTransfer,
                        "ChlorineId" : dict.clorineId
                        
                    ] as JSONDictionary
                }else{
                    json = [
                        "AppAssessmentId":String(AssessmentId),
                        "Camera": Camera,
                        "CustomerId": CustomerId ?? 0,
                        "AppCreationTime": UniID.prefix(22),
                        "DeviceId": deviceIDFORSERVER,
                        "DisplayId":DisplayId?.prefix(22),
                        "EvaluationDate": evalDateStr,
                        "EvaluationId": EvaluationId ?? 0,
                        "EvaluationTypeText": dict.evaluationName ?? "",
                        "EvaulaterId": EvaulaterId ?? 0,
                        "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                        "IncubationStyle": iStle,
                        "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                        "SaveType":SaveType,
                        "Status_Type":statusType,
                        "SiteId": SiteId,
                        "TSRId": TSRId,
                        "UserId": UserId,
                        "VisitId": VisitId,
                        "AssessmentId":serverAssessmentId,
                        "BreedBirds": breeddId == 0 ? "" : breeddId,
                        "EggsPerFlat": EggID == 0 ? "" : EggID,
                        "ManufacturerOther": manOther,
                        "BreedOfBirdsOther": breeeddOther,
                        "EggsPerFlatOther": egggOther,
                        "Notes": Notes,
                        "DoubleSanitation":hacheryAntibiotics,
                        "SanitationEmbrex": false,
                        "IsAutomaticFail" :  dict.isAutomaticFail ?? 0 ,
                        "FSTSignatureImage": FSRsign,
                        "IsInterMicrobial" : extndMicro,
                        "RefrigeratorNote": re_note,
                        "RegionId" : RegionalId,
                        "CountryId":countryIDSelc,
                        "IsInovoFluids": inovoFluid,
                        "IsBasicTrfAssessment" :  basicTransfer,
                        "ChlorineId" : dict.clorineId
                        
                    ] as JSONDictionary
                }
            } else {
                json = [
                    
                    "AppAssessmentId":String(AssessmentId),
                    "DisplayId":DisplayId?.prefix(22),
                    "VisitId": VisitId,
                    "CustomerId": CustomerId,
                    "SiteId": SiteId,
                    "IncubationStyle": iStle,
                    "EvaluationId": EvaluationId,
                    "BreedBirds": breeddId == 0 ? "" : breeddId,
                    "EvaluationDate": evalDateStr,
                    "EvaulaterId": EvaulaterId ?? 0,
                    "TSRId": TSRId,
                    "Camera": Camera,
                    "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                    "EggsPerFlat": EggID == 0 ? "" : EggID,
                    "Notes": Notes,
                    "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                    "SaveType":SaveType,
                    "UserId": UserId,
                    "DeviceId": deviceIDFORSERVER,
                    "RepresentativeName":sig_Nametext,
                    "RepresentativeName2":sig_Nametext2,
                    "RepresentativeNotes":sig_Phonetext,
                    "SignatureImage": base64Str,
                    "SignatureImage2": base64Str2,
                    "ManufacturerOther": manOther,
                    "BreedOfBirdsOther": breeeddOther,
                    "EggsPerFlatOther": egggOther,
                    "RoleId":rollID,
                    "RoleId2":rollID2 == 0 ? "" : rollID2,
                    "EvaluationTypeText": dict.evaluationName,
                    "AppCreationTime": UniID.prefix(22),
                    "SignatureDate":dateSig,
                    "AssessmentId":serverAssessmentId,
                    "DoubleSanitation":hacheryAntibiotics,
                    "SanitationEmbrex": false,
                    "IsAutomaticFail" : dict.isAutomaticFail ?? 0,
                    "FSTSignatureImage": FSRsign,
                    "IsInterMicrobial" : extndMicro,
                    "RefrigeratorNote": re_note ,
                    "RegionId" : RegionalId,
                    "CountryId":countryIDSelc,
                    "IsInovoFluids": inovoFluid,
                    "IsBasicTrfAssessment" :  basicTransfer,
                    "ChlorineId" : dict.clorineId
                ] as JSONDictionary
            }
            return json
        }
        
    }
    // MARK: - Post Request for Extended Microbial's
    func createSyncRequestForExtendedMicro(dict: PENewAssessment ,certificationData : [PECertificateData], saveType: Int) -> JSONDictionary{
        debugPrint("dict---\(dict)")
        var idArr = [String]()
        for val in tempArr{
            let id = val["AssessmentId"] as? Int64 ?? 0
            if id != 0{
                idArr.append("\(id)")
            }
        }
        var arr = [PESanitationDTO]()
        for id in idArr {
            let tempPEArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.sendExtendedPEFilledDTO(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: id)
            arr.append(contentsOf: tempPEArr)
        }
        var extendedData : [[String: Any]]?
        let jsonEncoder = JSONEncoder()
        let jsonDataArr = try? jsonEncoder.encode(arr)
        if jsonDataArr != nil{
            extendedData = try! JSONSerialization.jsonObject(with: jsonDataArr!, options: []) as? [[String: Any]]
        }
        var Complete = 1
        var Draft = 0
        if saveType == 1 {
            saveTypeString.append(11)
            
        }
        var AssessmentId = dict.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
                deviceIDFORSERVER = dict.assDetail2 ?? ""
            }
            AssessmentId = dict.draftNumber ?? 0
            Draft = 1
            Complete = 0
            saveTypeString.append(00)
        }
        var serverAssessmentId:Int64 = 0
        if dict.serverAssessmentId != nil{
            serverAssessmentId = Int64( dict.serverAssessmentId ?? "") ?? 0
        }
        let EvaluationId = dict.evaluationID
        let Status_Type = ""
        let UserId = dict.userID
        var statusType = dict.statusType ?? 0
        var json : JSONDictionary = JSONDictionary()
        let userInfo = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: dict.serverAssessmentId ?? "")
        
        let isEMRequested = dict.IsEMRequested ?? false
        let appVersion = "\(Bundle.main.versionNumber)"
        tempArr.removeAll()
        
        if saveType == 0 {
            if statusType == 2 {
                
                if dict.isEMRejected == true  || dict.isPERejected == true {
                    statusType = 0
                }
                json = [
                    "AssessmentId":serverAssessmentId,
                    "DeviceId": deviceIDFORSERVER,
                    "UserId": UserId,
                    "EvaluationId": EvaluationId ?? 0,
                    "SaveType":saveType,
                    "Status_Type":statusType,
                    "IsEMRequested" : isEMRequested,
                    "IsSendEmail": false,
                    "appVersion": appVersion,
                    "SanitationEmbrexScoresDataModel":extendedData
                ] as JSONDictionary
            }else{
                json = [
                    "AssessmentId":serverAssessmentId,
                    "DeviceId": deviceIDFORSERVER,
                    "UserId": UserId,
                    "EvaluationId": EvaluationId ?? 0,
                    "SaveType":saveType,
                    "Status_Type":statusType,
                    "IsEMRequested" : isEMRequested,
                    "IsSendEmail": false,
                    "appVersion": appVersion,
                    "SanitationEmbrexScoresDataModel":extendedData
                ] as JSONDictionary
            }
        } else {
            
            if dict.isPERejected == true && dict.isEMRejected == true
            {
                if Constants.isAssessmentRejected == true
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":0,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
                else
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":1,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
            }
            else  if dict.isPERejected == false && dict.isEMRejected == true
            {
                if Constants.isAssessmentRejected == true
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":0,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
                else
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":1,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
            }
            
            else  if dict.isPERejected == true && dict.isEMRejected == false
            {
                if Constants.isAssessmentRejected == true
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":1,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
                else
                {
                    json = [
                        "AssessmentId":serverAssessmentId,
                        "DeviceId": deviceIDFORSERVER,
                        "UserId": UserId,
                        "EvaluationId": EvaluationId ?? 0,
                        "SaveType":1,
                        "Status_Type":0,
                        "IsEMRequested" : isEMRequested,
                        "IsSendEmail": true,
                        "appVersion": appVersion,
                        "SanitationEmbrexScoresDataModel":extendedData
                    ] as JSONDictionary
                }
            }
            else
            {
                json = [
                    "AssessmentId":serverAssessmentId,
                    "DeviceId": deviceIDFORSERVER,
                    "UserId": UserId,
                    "EvaluationId": EvaluationId ?? 0,
                    "SaveType":saveType,
                    "Status_Type":statusType,
                    "IsEMRequested" : isEMRequested,
                    "IsSendEmail": true,
                    "appVersion": appVersion,
                    "SanitationEmbrexScoresDataModel":extendedData
                ] as JSONDictionary
            }
            Constants.isAssessmentRejected = false
        }
  
        return json
        
    }
    // MARK: - Logout Action
    func logoutAction() {
        self.ssologoutMethod()
        TimeManager.shared.clearCoreDataAndUserdefaults()
        UserDefaults.standard.set(false, forKey: "newlogin")
        UserDefaults.standard.set(false, forKey: "hasPEDataLoaded")
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: ViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod() {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //    // MARK: - Date Formatter
    
    
    
    // MARK: - Date Formatter
    func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "MMM d, yyyy"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if regionID == 3
        {convertDateFormatter.dateFormat = "yyyy-MM-dd"
        }
        else{
            convertDateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }
        return ""
    }
    
    //    func convertDateFormat(inputDate: String) -> String {
    //
    //        let olDateFormatter = DateFormatter()
    //        olDateFormatter.dateFormat = "MMM d, yyyy"
    //        let oldDate = olDateFormatter.date(from: inputDate)
    //        let convertDateFormatter = DateFormatter()
    //        convertDateFormatter.dateFormat = "yyyy-MM-dd"
    //
    //        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
    //        if regionID == 3
    //        {convertDateFormatter.dateFormat = "yyyy-MM-dd"
    //        }
    //        else{
    //            convertDateFormatter.dateFormat = "yyyy-MM-dd"
    //        }
    //
    //        if oldDate != nil{
    //            return convertDateFormatter.string(from: oldDate!)
    //        }
    //        return ""
    //
    ////
    ////        let olDateFormatter = DateFormatter()
    //////        olDateFormatter.calendar = Calendar(identifier: .gregorian)
    //////        olDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    ////
    ////        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    ////        let oldDate = olDateFormatter.date(from: inputDate)
    ////        let convertDateFormatter = DateFormatter()
    //////        convertDateFormatter.calendar = Calendar(identifier: .gregorian)
    //////        convertDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    ////        convertDateFormatter.dateFormat = "yyyy-MM-dd"
    ////
    ////        if regionID == 3
    ////        {
    ////            let inputFormatter = DateFormatter()
    ////            inputFormatter.dateFormat = "MMM d, yyyy" // for date like Sept 6, 2024
    ////
    ////            if let date = inputFormatter.date(from: inputDate) {
    ////                convertDateFormatter.dateFormat = "MM/dd/YYYY"
    ////                return convertDateFormatter.string(from: date)
    ////            } else {
    ////                print("Invalid date format")
    ////            }
    ////            convertDateFormatter.dateFormat = "yyyy-MM-dd"
    ////
    ////        }
    ////        else{
    ////            convertDateFormatter.dateFormat = "MM-dd-yyyy"
    ////        }
    ////
    ////        if oldDate != nil{
    ////            return convertDateFormatter.string(from: oldDate!)
    ////        }
    ////        return ""
    //    }
    
    // MARK: - Date Formatter
    func convertSign_DateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "MMM d, yyyy"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        if regionId != 3 {
            convertDateFormatter.calendar = Calendar(identifier: .gregorian)
            convertDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            convertDateFormatter.dateFormat = "yyyy-MM-dd"
        }
        else{
            convertDateFormatter.dateFormat = "MM/dd/yyyy"
        }
        
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }
        return ""
    }
    
    
}

// MARK: - EXTENSION FOR STRING TO DATE

extension String {
    
    func toDate(withFormat format: String = "MM/dd/YYYY HH:mm:ss Z")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        //  dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func toDateWithFormat(withFormat format: String = "MM/dd/YYYY HH:mm:ss Z")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        //  dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
}

// MARK: - EXTENSION FOR DATE TO STRING

extension Date {
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toString(withFormat format: String = "MM/dd/YYYY HH:mm:ss Z") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

// MARK: - EXTENSION FOR TABLE VIEW DATA SOURCE AND DELEGATES

extension PEDashboardViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingCertificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VaccinationCertificationsTableViewCell.identifier, for: indexPath) as? VaccinationCertificationsTableViewCell{
            cell.removeBtnVw()
            if upcomingCertificationsArr.count > 0 && indexPath.row < upcomingCertificationsArr.count{
                
                cell.setPEValues(vaccinationCertificatonObj:upcomingCertificationsArr[indexPath.row] )
                if upcomingCertificationsArr.count - 1 == indexPath.row{
                    cell.layer.masksToBounds = true
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                } else{
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                }
            }else{
                
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Constants.isPPmValueChanged = false
        Constants.switchCount = 0
        if upcomingCertificationsArr.count > 0 && upcomingCertificationsArr.count > indexPath.row {
            if let assessmentId = upcomingCertificationsArr[indexPath.row].serverAssessmentId{
                
                UserDefaults.standard.set(assessmentId, forKey: "currentServerAssessmentId")
                let userDefault = UserDefaults.standard
                userDefault.set(upcomingCertificationsArr[indexPath.row].customerId, forKey: "PE_Selected_Customer_Id")
                userDefault.set(upcomingCertificationsArr[indexPath.row].customerName, forKey: "PE_Selected_Customer_Name")
                userDefault.set(upcomingCertificationsArr[indexPath.row].siteId, forKey: "PE_Selected_Site_Id")
                userDefault.set(upcomingCertificationsArr[indexPath.row].siteName, forKey: "PE_Selected_Site_Name")
                
                if let assessment = PEAssessmentsDAO.sharedInstance.getDraftAssessment(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: assessmentId) {
                    let delete = CoreDataHandlerPE().deleteDraftAndMoveToSessionInProgress(assessment.draftNumber!)
                    if delete {
                        if self.anyCategoryContainValueOrNot(serverAssessmentId:assessmentId) {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as! PEDraftAssesmentFinalize
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            if regionID == 3 {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftStartNewAssessment") as! PEDraftStartNewAssessment
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftStartNewAssesmentINT") as! PEDraftStartNewAssesmentINT
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                } else {
                    
                    if anyCategoryContainValueOrNot(serverAssessmentId: assessmentId) {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as! PEAssesmentFinalize
                        vc.scheduledAssessment = upcomingCertificationsArr[indexPath.row]
                        vc.scheduledAssessment?.scheduledDate = Date()
                        let pervioudAssesID = UserDefaults.standard.value(forKey: "assIID") as? String ?? ""
                        if(pervioudAssesID  != upcomingCertificationsArr[indexPath.row].serverAssessmentId){
                            UserDefaults.standard.set(upcomingCertificationsArr[indexPath.row].refrigeratorNote ?? "", forKey:"re_note")
                            UserDefaults.standard.set(upcomingCertificationsArr[indexPath.row].assID ,forKey:"assIID")
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        
                        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
                        if regionID == 3 {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEStartNewAssessment") as! PEStartNewAssessment
                            vc.navigationController?.navigationBar.isHidden = true
                            vc.scheduledAssessment = upcomingCertificationsArr[indexPath.row]
                            vc.scheduledAssessment?.scheduledDate = Date()
                            navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEStartNewAssessmentINT") as! PEStartNewAssessmentINT
                            vc.scheduledAssessment = upcomingCertificationsArr[indexPath.row]
                            vc.scheduledAssessment?.scheduledDate = Date()
                            let pervioudAssesID = UserDefaults.standard.value(forKey: "assIID") as? String ?? ""
                            if(pervioudAssesID  != upcomingCertificationsArr[indexPath.row].serverAssessmentId){
                                UserDefaults.standard.set(upcomingCertificationsArr[indexPath.row].refrigeratorNote ?? "", forKey:"re_note")
                                UserDefaults.standard.set(upcomingCertificationsArr[indexPath.row].assID ,forKey:"assIID")
                            }
                            navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - EXTENSION FOR CALLING API'S

extension PEDashboardViewController {
    // MARK: - Add operations
    func addOperations() {
        
        let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn_successful") as? Bool
        let isFromGlobalDashboard = UserDefaults.standard.value(forKey: "OnGlobalFromPE") as? Bool ?? false
        
        if isLoggedIn ?? false{
            UserDefaults.standard.setValue(false, forKey: "dontGetRejectedAssessment")
            UserDefaults.standard.set(false, forKey: "isLoggedIn_successful")
            UserDefaults.standard.setValue(false, forKey: "OnGlobalFromPE")
            UserDefaults.standard.synchronize()
            if ConnectionManager.shared.hasConnectivity() {
                self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
                self.fetchAllCustomer()
            } else {
                self.dismissGlobalHUD(self.view ?? UIView())
            }
        } else {
            if isFromGlobalDashboard {
                
                UserDefaults.standard.setValue(true, forKey: "haveToCallGetPosting")
                UserDefaults.standard.setValue(false, forKey: "OnGlobalFromPE")
                self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
                self.getRejectedAssessmentListByUser()
            }
        }
    }
    // MARK: - Get Blank PDF Files
    private func getBlankAssessmentFiles(){
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            let jsonDict = ["ReportType" : "1"]
            if let theJSONData = try? JSONSerialization.data( withJSONObject: jsonDict, options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                debugPrint("SNA Json = \n\(theJSONText)")
            }
            
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getBlankAssessmentFiles(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let `self` = self, error == nil else { return }
                self.handleBlankAssessmentResponse(json)
            })
            
        } else {
            // From  You are currently offline. Please go online to download PDF. -- To  No Internet connection, please check your internet connection. ----> As per QA Concern and released in 7.6.8 build release.
           
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("No Internet connection, please check your internet connection.", comment: ""))
        }
    }
    
    // MARK: - Get All Customer's List
    func fetchAllCustomer(){
        if ConnectionManager.shared.hasConnectivity() {
            let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getCustomerListForPE(controller: self, countryID: String(countryId), parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handlefetchAllCustomerResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Customer's list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Dosages's List
    private func fetchAllDoses(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPEDosagesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handlefetchAllDosesResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Dosages list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Countries List
    private func fetchAllCountries(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getCountryForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handlefetchAllCountriesResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Countries list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Evaluator's Type List
    private func fetchEvaluator(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getEvaluatorListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleFetchEvaluatorResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Evaluator's list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Approver's List
    private func fetchApprovers(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getApproversListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleFetchApproversResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Approver's list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Visit type List
    private func fetchVisitTypes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getVisitTypesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleFetchVisitTypesResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Visit type list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Evaluation's types List
    private func fetchEvaluationTypes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getEvaluatorTypesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleFetchEvaluationTypesResponse(json)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Evaluation type list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Site's List
    private func fetchSites(_ isEverytime:Bool = false){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getSitesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleFetchSitesResponse(json, isEverytime)
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Sites list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Assessment's Category Responce
    internal func fetchtAssessmentCategoriesResponse(){
        if ConnectionManager.shared.hasConnectivity() {
            var evalTypeId = ""
            let regionId = UserDefaults.standard.integer(forKey: "Regionid")
            if regionId == 3 {
                evalTypeId = String(peNewAssessment?.evalType?.id ?? 0)
            }
            else {
                evalTypeId = String(peNewAssessment?.evalType?.id ?? 1)
            }
            
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAssessmentCategoriesDetailsPE(controller: self, evalType:evalTypeId, moduleID: "1"  , parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    if let responseJSONDict = json.dictionary{
                        if let response = responseJSONDict["Data"]{
                            
                            let jsonDecoder = JSONDecoder()
                            let responseStr = response.description
                            if responseStr != ""{
                                let jsonData = try? Data(responseStr.utf8)
                                if let data = jsonData{
                                    let vaccinationCertificationObj = try? jsonDecoder.decode([ExtendedPECategoryDTO].self, from: data)
                                    
                                    if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                        let index = vaccinationCertificationObj?.firstIndex(where: {
                                            $0.id == 36
                                        })
                                        if index != nil{
                                            let embrex =  vaccinationCertificationObj![index!]
                                            SanitationEmbrexQuestionMasterDAO.sharedInstance.saveExtendedPEQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", plateTypeDTO: [embrex])
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self?.handleAssessmentCategoriesResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Question's List", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Question's Info
    internal func fetchtQuestionInfo(){
        if ConnectionManager.shared.hasConnectivity(){
            let evalTypeId = String(peNewAssessment?.evalType?.id ?? 1)
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAssessmentQuesInfoPE(controller: self, evalType:evalTypeId, moduleID: "1"  , parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchtQuestionInfo(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Questions's info", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Manufacturer's List
    private func fetchManufacturer(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getManufacturerListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchManufacturerResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Manufacturer list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Bird's List
    private func fetchBirdBreed(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getBirdBreedListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchBirdBreedResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Bird Breed list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get Eggs List
    private func fetchEggs(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getEggsListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchEggsResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Eggs count list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Vaccine Manufacturer's List
    private func fetchVManufacturer(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getVaccineManufacturerListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchVManufacturerResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Vaccine manufacture list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Vaccine Name's List
    private func fetchVaccineNames(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getVaccineNamesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchVaccineNamesResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Vaccines list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Diluent Manufacturer's List
    private func fetchDiluentManufacturer(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getDiluentManufacturerList(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchDiluentManufacturer(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Diluent Manufacture list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    private func getDiluentManufacturer(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getDiluentManufacturerList(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handleGetDiluentManufacturer(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Diluent Manufacture list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Bag' Sizes List
    private func fetchBagSizes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getBagSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchBagSizes(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Bag size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    private func getBagSizes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getBagSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handleGetBagSizes(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Bag size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    // MARK: - Get All Ample Size Bag's List
    private func fetchAmplePerBag(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAmplePerBag(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchAmplePerBag(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Ample per bag Size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    
    private func getAmplePerBag(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAmplePerBag(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handleGetAmplePerBag(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Ample per bag Size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get Ample Size's List
    private func fetchAmpleSizes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAmpleSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchAmpleSizes(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Ample Size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    private func getAmpleSizes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getAmpleSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlegettingfetchAmpleSizes(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Ample Size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    // MARK: - Get All Role's List
    private func fetchRoles() {
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPERoles(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchRoles(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Role list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All DOA Diluent's Type List
    private func fetchDOADiluentType(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPEDOADiluentType(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchDOADiluentType(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Diluent type list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Sub Vaccine's List
    private func fetchSubVaccineNames(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getVaccineSubNamesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchSubVaccineNamesResponse(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Sub vaccines list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All PE Frequencie's List
    private func fetchPEFrequency(){
        if ConnectionManager.shared.hasConnectivity(){
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPEFrequency(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchPEFrequency(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get PE Frequency list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All Incubation Style's List
    private func fetchIncubationStyle(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPEIncubationStyle(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchIncubationStyle(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Incubation list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get All DOA Size's List
    private func fetchDOASizes(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPEDOASizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlefetchDOASizes(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get DOA Size list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get Posted assessment List
    private func getPostingAssessmentListByUser(){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getPostedAssmntListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.handlGetPostingAssessmentListByUser(json)
                }
            })
        }else{
            self.showToastWithTimer(message: "Failed to get Posting Assessment list", duration: 3.0)
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - Get Images of Posted assessment
	private func getPostingAssessmentImagesListByUser(){
		if ConnectionManager.shared.hasConnectivity() {
			APIActivityTracker.shared.startRequest()
			ZoetisWebServices.shared.getPostingImagesListByUserPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
				APIActivityTracker.shared.endRequest()
				guard let _ = self, error == nil else {
					self?.dismissGlobalHUD(self?.view ?? UIView())
					return
				}
				self?.dismissGlobalHUD(self?.view ?? UIView())
				let mainQueue = OperationQueue.main
				mainQueue.addOperation {
					self?.showGlobalProgressHUDWithTitle(self?.view ?? UIView(), title: "Saving Assessment Data..")
					self?.handlGetPostingAssessmentImagesListByUser(json)
					UserDefaults.standard.set(true, forKey: "hasPEDataLoaded")
					UserDefaults.standard.set(true, forKey: "hasPELoadedPrevData")
				}
			})
		}else{
			self.showToastWithTimer(message: "Failed to get Posted assessment images list", duration: 3.0)
			self.dismissGlobalHUD(self.view ?? UIView())
		}
	}
    
    // MARK: - Get Rejected assessment List
    private func getRejectedAssessmentListByUser(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getRejectedAssessmentListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handlGetRejectedAssessmentListByUser(json)
            })
        }else{
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    // MARK: - Get Scheduled assessment List
    //    private func getScheduledAssessments(){
    //        if ConnectionManager.shared.hasConnectivity() {
    //            PEDataService.sharedInstance.getScheduledAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
    //                guard let _ = self, error == nil else {
    //                    self?.dismissGlobalHUD(self?.view ?? UIView());
    //                    return
    //                }
    //                self?.extractedFunc15(status)
    //                self?.peHeaderViewController.titleofSync = "0"
    //                self?.peHeaderViewController.viewDidLoad()
    //                self?.dismissGlobalHUD(self?.view ?? UIView())
    //
    //
    //                if self?.regionID == 3 {
    //                    let callGetPosting = UserDefaults.standard.value(forKey: "haveToCallGetPosting") as? Bool
    //                    if callGetPosting ?? false {
    //
    //                        UserDefaults.standard.setValue(false, forKey: "haveToCallGetPosting")
    //                        UserDefaults.standard.setValue(true, forKey: "dontGetRejectedAssessment")
    //                        self?.getPostingAssessmentListByUser()
    //                    }
    //                }
    //            })
    //        }else{
    //            self.dismissGlobalHUD(self.view ?? UIView())
    //        }
    //    }
    
    private func getScheduledAssessments() {
        if ConnectionManager.shared.hasConnectivity() {
            PEDataService.sharedInstance.getScheduledAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView());
                    return
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                        let userDefault = UserDefaults.standard
                        let customerId = userDefault.integer(forKey: "PE_Selected_Customer_Id") ?? 0
                        let siteId = userDefault.integer(forKey: "PE_Selected_Site_Id") ?? 0
                        
                        self?.upcomingCertificationsArr =  PEAssessmentsDAO.sharedInstance.getVMObj(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "")
                        if self?.upcomingCertificationsArr.count ?? 0 > 0 {
                            self?.alertLbl.isHidden = true
                        } else {
                            self?.alertLbl.isHidden = false
                        }
                        self?.popupTblVw.reloadData()
                        self?.dashboardTblVw.reloadData()
                    }
                }
                
                self?.peHeaderViewController.titleofSync = "0"
                self?.peHeaderViewController.viewDidLoad()
                self?.dismissGlobalHUD(self?.view ?? UIView())
                
                
                if self?.regionID == 3 {
                    let callGetPosting = UserDefaults.standard.value(forKey: "haveToCallGetPosting") as? Bool
                    if callGetPosting ?? false {
                        
                        UserDefaults.standard.setValue(false, forKey: "haveToCallGetPosting")
                        UserDefaults.standard.setValue(true, forKey: "dontGetRejectedAssessment")
                        self?.getPostingAssessmentListByUser()
                    }
                }
            })
        } else {
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    
    func accessPEArrayObjects(){
        
        var extendedMicroArr : [JSONDictionary]  = []
        var inovojectDataArr : [JSONDictionary]  = []
        var dayOfAgeDataArr : [JSONDictionary]  = []
        var dayOfAgeSDataArr : [JSONDictionary]  = []
        var certificateDataArr : [JSONDictionary]  = []
        var vaccineMicroSamplesDataArr : [JSONDictionary]  = []
        var vaccineResidueMoldsDataArr : [JSONDictionary]  = []
        var refrigratorDataArr : [JSONDictionary]  = []
        if peAssessmentSyncArray.count > 0 {
            for obj in self.peAssessmentSyncArray{
                // For loop for each assessment to be synced (Multiple Assessment)
                if obj.isEMRejected == true && obj.isPERejected == false
                {
                    globalAssessmentId = obj.serverAssessmentId

                    self.syncExtendedMicrobial(saveType: 1, statusType: 0)
                    return
                }
                
                if self.isSync == false{
                    self.isSync = true
                    self.assessID = Int(obj.serverAssessmentId ?? "")
                    self.objAssessment = obj
                    self.checkDataDuplicacy(obj: obj)
                    var arrIDs = [NSNumber]()
                    // region 3 means US & Canada
                    if  self.regionID  != 3 {
                        refrigratorDataArr.removeAll()
                        let refriArray = CoreDataHandlerPE().getREfriData(id: self.assessID ?? 0)
                        if refriArray.count > 1 {
                            arrIDs.removeAll()
                            for objn in  refriArray {
                                if !arrIDs.contains(objn.id!) {
                                    arrIDs.append(objn.id!)
                                    let data = self.createSyncRequestRefrigator(dictArray: objn)
                                    refrigratorDataArr.append(data)
                                }
                            }
                        }
                    }
                    
                    self.dayOfAgeSData.removeAll()
                    if obj.doaS.count > 0 {
                        var idArr : [Int] = []
                        for objn in  obj.doaS {
                            let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                            if data != nil {
                                if idArr.contains(data!.id ?? 0){
                                }else{
                                    idArr.append(data!.id ?? 0)
                                    if data != nil{
                                        self.dayOfAgeSData.append(data!)
                                    }
                                }
                            }
                        }
                    }
                    
                    self.dayOfAgeData.removeAll()
                    if obj.doa.count > 0 {
                        var idArr : [Int] = []
                        for objn in  obj.doa {
                            let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                            if data != nil {
                                if idArr.contains(data!.id ?? 0){
                                    
                                }else{
                                    idArr.append(data!.id ?? 0)
                                    if data != nil{
                                        self.dayOfAgeData.append(data!)
                                    }
                                }
                            }
                        }
                    }
                    
                    self.inovojectData.removeAll()
                    if obj.inovoject.count > 0 {
                        var idArr : [Int] = []
                        for objn in  obj.inovoject {
                            let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                            if data != nil {
                                if idArr.contains(data!.id ?? 0){
                                }else{
                                    idArr.append(data!.id ?? 0)
                                    if data != nil{
                                        self.inovojectData.append(data!)
                                    }
                                }
                            }
                        }
                    }
                    
                    self.certificateData.removeAll()
                    if obj.vMixer.count > 0 {
                        var idArr : [Int] = []
                        for objn in  obj.vMixer {
                            let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
                            if idArr.contains(data!.id ?? 0){
                                
                            }else{
                                idArr.append(data!.id ?? 0)
                                if data != nil{
                                    self.certificateData.append(data!)
                                }
                            }
                        }
                    }
                    self.tempArr.removeAll()
                    
                    if obj.extndMicro == false
                    {
                        HaveToCallExtendedMicro = false
                    }
                    else{
                        HaveToCallExtendedMicro = true
                    }
                    
                    let json = self.createSyncRequest(dict: obj , certificationData : self.certificateData )
                    tempArr.append(json)
                    
                    if self.inovojectData.count > 0 {
                        for item in self.inovojectData {
                            let json = self.createSyncRequestForInvoject(dictArray: obj, inovojectData: item)
                            inovojectDataArr.append(json)
                            
                        }
                    }
                    if self.dayOfAgeData.count > 0 {
                        for item in self.dayOfAgeData {
                            let json = self.createSyncRequestForDOA(dictArray: obj, dayOfAgeData: item)
                            dayOfAgeDataArr.append(json)
                            
                        }
                    }
                    if self.dayOfAgeSData.count > 0 {
                        for item in self.dayOfAgeSData {
                            let json = self.createSyncRequestForDOAS(dictArray: obj, dayOfAgeData: item)
                            dayOfAgeSDataArr.append(json)
                            
                        }
                    }
                    if self.certificateData.count > 0 {
                        for item in self.certificateData {
                            let json = self.createSyncRequestForCertificateData(dictArray: obj, peCertificateData: item)
                            certificateDataArr.append(json)
                        }
                    }
                    if obj.evaluationID == 2 {
                        let json = self.createSyncRequestForResidueData(dictArray: obj)
                        vaccineResidueMoldsDataArr.append(json)
                    }
                    if obj.evaluationID == 2 {
                        let json = self.createSyncRequestForMicroData(dictArray: obj)
                        vaccineMicroSamplesDataArr.append(json)
                    }
                    
                    var AssessmentId = self.objAssessment.dataToSubmitNumber ?? 0
                    if AssessmentId == 0 {
                        AssessmentId = self.objAssessment.draftNumber ?? 0
                    }
                    if tempArr.count > 0 {
                        AssessmentId = (tempArr[0]["AssessmentId"] as? NSNumber)?.intValue ?? 0
                    }
                    
					print("AssessmentId: <<< ",AssessmentId)
					print("AssessmentId: <<< obj.assID: <<< ",(obj.serverAssessmentId) ?? 0)
					globalAssessmentId = obj.serverAssessmentId
                    var paramForDoaInnovoject = JSONDictionary()
//                    let certCreatedById = self.certificateData.
                    ///Add cert crated by id
                    if( self.regionID  != 3 ){
                        paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr,"RefrigeratorData":refrigratorDataArr,"DeviceId": self.deviceIDFORSERVER, "AssessmentDetailsId" :AssessmentId] as JSONDictionary
                    }
                    else{
                        paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr, "DeviceId": self.deviceIDFORSERVER, "AssessmentDetailsId" :AssessmentId] as JSONDictionary
                    }
                    
                    var idArr = [String]()
                    for val in tempArr{
                        let id = val["AssessmentId"] as? Int64 ?? 0
                        if id != 0{
                            idArr.append("\(id)")
                        }
                    }
                    
                    var isSendEmail = "true"
                    if let saveType = tempArr[0]["SaveType"] as? Int,
                       saveType == 0 {
                        isSendEmail = "false"
                    }
                    let param = ["AssessmentData":tempArr,"appVersion":Bundle.main.versionNumber,"IsSendEmail":isSendEmail] as JSONDictionary
                    
                    //self.convertDictToJson(dict: param,apiName: "add assessment")
                    APIActivityTracker.shared.startRequest()
                    ZoetisWebServices.shared.sendPostDataToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
                        APIActivityTracker.shared.endRequest()
                        if error != nil {
                            self?.dismissGlobalHUD(self?.view ?? UIView())
                        }
                        guard let `self` = self, error == nil else { return }
                        
                        if json["StatusCode"]  == 200{
                            if self.isSync {
                                self.convertDictToJson(dict: paramForDoaInnovoject,apiName: "add paramData")
                                self.callRequest2(paramForDoaInnovoject: paramForDoaInnovoject, json: json)
                            }
                        } else {
                            self.dismissGlobalHUD(self.view)
                            self.showAlert(title: "Error", message: "Something went wrong in Assessment sync. Please try again.", owner: self)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Create Sync request for Refrigrator Data
    func createSyncRequestRefrigator(dictArray: PE_Refrigators) -> JSONDictionary{
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let f = dictArray.value
        let s = NSString(format: "%.2f", f ?? "")
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let s2 = nf.string(from: f as? NSNumber ?? 0)
        let value = Double((s ) as Substring) as? NSNumber
        let json = [
            "Id": 0,
            "AssessmentId": dictArray.schAssmentId ?? 0 ,
            "AssessmentDetailId": dictArray.id ?? 0 ,
            "RefValue": value ?? 0.0,
            "RefUnit": dictArray.unit ?? "",
            "IsNa": dictArray.isNA ?? false,
            "IsCheck": dictArray.isCheck ?? false,
            "UserId": userId ?? 0,
            "CreatedAt": "2023-01-31T14:57:39.582Z"
        ] as JSONDictionary
        return json
    }
    
    // MARK: - Get Vaccine Service Responce
    func getVaccinationServiceResponse(showHud:Bool){
        if ConnectionManager.shared.hasConnectivity() {
            
            self.showGlobalProgressHUDWithTitle(self.view, title: "Data sync is in progress, please do not close the app." + "\n" + "*Note - Please don't minimize App while syncing.")
            let id = UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found"
            let url = ZoetisWebServices.EndPoint.getPEScheduledCertifications.latestUrl + "\(id)?customerId=null&siteId=null"
            
            
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getVaccinationServicesResponse(controller: self, url: url, completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else{return;}
                var dataDic : [String:Any] = [:]
                var dataArray : [Any] = []
                if let string = json.rawString() {
                    dataDic = string.convertToDictionary() ?? [:]
                }
                dataArray = dataDic["Data"] as? [Any] ?? []
                let myTask = DispatchGroup()
                self?.scheduleAssessmentIdArray = []
                while dataArray.count != 0{
                    myTask.enter()
                    var objDic : [String:Any] = [:]
                    objDic =  dataArray[0] as? [String:Any] ?? [:]
                    dataArray.remove(at: 0)
                    let _ = objDic["StatusName"] as? String
                    
                    if !(self?.scheduleAssessmentIdArray.contains(String(objDic["Id"]! as! Int)) ?? true){
                        self?.scheduleAssessmentIdArray.append(String(objDic["Id"]! as! Int))
                        myTask.leave()
                    }
                }
                var peAssessmentArray : [PENewAssessment] = []
                self?.deletedAssessmentIdArray = []
                peAssessmentArray = self?.getAllDateArrayStoredNew() ?? []
                let peAssessmentNewArray = self?.getAllDateArrayStored() ?? []
                for obj in peAssessmentArray{
                    if obj.statusType ?? 0 == 3{
                        if self?.scheduleAssessmentIdArray.count ?? 0 > 0{
                            if !(self?.scheduleAssessmentIdArray.contains(obj.serverAssessmentId ?? "") ?? true){
                                self?.deletedAssessmentIdArray.append(obj.serverAssessmentId!)
                                let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
                                let index = peAssessmentArray.index(of: obj) ?? 0
                                peAssessmentArray.remove(at: index)
                                CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentInOffline", predicate: NSPredicate(format: " userID == %d AND serverAssessmentId == %@", userID, obj.serverAssessmentId ?? ""))
                            }
                        }else{
                            self?.deletedAssessmentIdArray.append(obj.serverAssessmentId!)
                            let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
                            let index = peAssessmentArray.index(of: obj) ?? 0
                            peAssessmentArray.remove(at: index)
                            CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentInOffline", predicate: NSPredicate(format: " userID == %d AND serverAssessmentId == %@", userID, obj.serverAssessmentId ?? ""))
                        }
                    }
                }
                
                if peAssessmentNewArray.count > 0{
                    if self?.deletedAssessmentIdArray.count ?? 0 > 0{
                        let alertController = UIAlertController(title: "Alert", message: String(format: "%d assessment(s) has been removed from the web. App data will be updated.", self?.deletedAssessmentIdArray.count ?? 0), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            _ in
                            if peAssessmentArray.count > 0{
                                self?.syncBtnTapped(showHud: showHud)
                            }else{
                                let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
                                for id in self?.deletedAssessmentIdArray ?? []{
                                    CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentInOffline", predicate: NSPredicate(format: " userID == %d AND serverAssessmentId == %@", userID, id))
                                }
                                self?.peHeaderViewController.titleofSync = "0"
                                self?.peHeaderViewController.viewDidLoad()
                                self?.getScheduledAssessments()
                            }
                        }
                        alertController.addAction(okAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }else{
                        self?.syncBtnTapped(showHud: showHud)
                    }
                }else{
                    self?.syncBtnTapped(showHud: showHud)
                }
            })
            
        }
        else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
        }
        
        
    }
}

// MARK: - HANDLE ALL ABOVE API RESPONSES
extension PEDashboardViewController{
    
    private func handlefetchAllCustomerResponse(_ json: JSON, isEverytime:Bool = false) {
        self.deleteAllData("PE_Customer")
        let _ = CustomerResponse(json)
        if isEverytime{
            fetchSites(isEverytime)
            dismissGlobalHUD(self.view)
        }else{
            fetchAllDoses()
        }
    }
    // MARK: - HANDLE ALL Doses API RESPONSES
    private func handlefetchAllDosesResponse(_ json: JSON) {
        self.deleteAllData("PE_Dose")
        let _ = PEDoseResponse(json)
        fetchAllCountries()
    }
    // MARK: - HANDLE ALL Countries API RESPONSES
    private func handlefetchAllCountriesResponse(_ json: JSON) {
        
        self.deleteAllData("AllCountriesPE")
        let _ = PECountryResponse(json)
        fetchChlorinStripsList()
    }
    // MARK: - HANDLE ALL Blank Assessment API RESPONSES
    private func handleBlankAssessmentResponse(_ json: JSON) {
        self.deleteAllData("BlankAssessmentFiles")
        let _ = PEBlankAssessmentResponse(json)
    }
    // MARK: - Get Chlorine Strips List API
    private func fetchChlorinStripsList(){
        if ConnectionManager.shared.hasConnectivity() {
            APIActivityTracker.shared.startRequest()
           ZoetisWebServices.shared.getClorineStripsForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
APIActivityTracker.shared.endRequest()
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                self?.handleAllClorineResponse(json)
            })
        }else{
            self.dismissGlobalHUD(self.view ?? UIView())
        }
    }
    // MARK: - HANDLE Chlorine Strips List API RESPONSES
    private func handleAllClorineResponse(_ json: JSON) {
        self.deleteAllData("AllClorinePE")
        let _ = PEClorineResponse(json)
        fetchEvaluator()
    }
    // MARK: - HANDLE Evaluator's List API RESPONSES
    private func handleFetchEvaluatorResponse(_ json: JSON) {
        self.deleteAllData("PE_Evaluator")
        let _ = EvaluatorResponse(json)
        fetchApprovers()
    }
    // MARK: - HANDLE Approvers List API RESPONSES
    private func handleFetchApproversResponse(_ json: JSON) {
        self.deleteAllData("PE_Approvers")
        let _ = ApproverResponse(json)
        fetchVisitTypes()
    }
    // MARK: - HANDLE Visit List API RESPONSES
    private func handleFetchVisitTypesResponse(_ json: JSON) {
        self.deleteAllData("PE_VisitTypes")
        let _ = VisitTypesResponse(json)
        fetchEvaluationTypes()
    }
    // MARK: - HANDLE Evaluation type's  API RESPONSES
    private func handleFetchEvaluationTypesResponse(_ json: JSON) {
        self.deleteAllData("PE_EvaluationType")
        let _ = EvaluationTypeResponse(json)
        fetchSites()
    }
    // MARK: - HANDLE Site List API RESPONSES
    private func handleFetchSitesResponse(_ json: JSON,_ isEverytime:Bool = false) {
        self.deleteAllData("PE_Sites")
        let _ = SiteResponse(json)
        if isEverytime{
            dismissGlobalHUD(self.view)
        } else{
            fetchtAssessmentCategoriesResponse()
        }
    }
    // MARK: - HANDLE Assessment Categories Question Answers API RESPONSES
    private func handleAssessmentCategoriesResponse(_ json: JSON) {
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(nil, forKey:"QuestionAns")
            let _ = PECategoriesAssesmentsResponse(json)
            self.saveJSON(json: json, key: "QuestionAns")
            self.fetchtQuestionInfo()
        }
    }
    // MARK: - HANDLE Assessment Categories Question Info API RESPONSES
    private func handlefetchtQuestionInfo(_ json: JSON) {
        let _ = InfoImageDataResponse(json)
        saveJSON(json: json, key: "QuestionAnsInfo")
        fetchManufacturer()
    }
    
    // MARK: - HANDLE PE Manufacturer Lisi API RESPONSES
    private func handlefetchManufacturerResponse(_ json: JSON) {
        self.deleteAllData("PE_Manufacturer")
        let _ = ManufacturerResponse(json)
        fetchBirdBreed()
    }
    
    // MARK: - HANDLE PE Bird Breed List API RESPONSES
    private func handlefetchBirdBreedResponse(_ json: JSON) {
        self.deleteAllData("PE_BirdBreed")
        let _ = BreedBirdResponse(json)
        self.fetchEggs()
    }
    
    // MARK: - HANDLE Eggs List API RESPONSES
    private func handlefetchEggsResponse(_ json: JSON) {
        self.deleteAllData("PE_Eggs")
        let _ = EggsResponse(json)
        fetchVManufacturer()
    }
    
    // MARK: - HANDLE PE Vaccine Manufacture List API RESPONSES
    private func handlefetchVManufacturerResponse(_ json: JSON) {
        self.deleteAllData("PE_VManufacturer")
        let _ = VManufacturerResponse(json)
        fetchVaccineNames()
    }
    
    // MARK: - HANDLE Vaccine Name List API RESPONSES
    private func handlefetchVaccineNamesResponse(_ json: JSON) {
        self.deleteAllData("PE_VNames")
        let _ = VNamesResponse(json)
        self.fetchDiluentManufacturer()
    }
    
    // MARK: -  Get PE Diluent Manufacturer  List API RESPONSES
    private func handlefetchDiluentManufacturer(_ json: JSON) {
        self.deleteAllData("PE_DManufacturer")
        let _ = DManufacturerResponse(json)
        fetchBagSizes()
    }
    
    // MARK: -   HANDLE Diluent Manufacturer  List API RESPONSES
    private func handleGetDiluentManufacturer(_ json: JSON) {
        self.deleteAllData("PE_DManufacturer")
        let _ = DManufacturerResponse(json)
    }
    
    // MARK: - Get PE BAg Size List API RESPONSES
    private func handlefetchBagSizes(_ json: JSON) {
        self.deleteAllData("PE_BagSizes")
        let _ = BagSizeResponse(json)
        fetchAmplePerBag()
    }
    
    // MARK: - HANDLE PE BAg Size List API RESPONSES
    private func handleGetBagSizes(_ json: JSON) {
        self.deleteAllData("PE_BagSizes")
        let _ = BagSizeResponse(json)
    }
    
    // MARK: - Get PE Ample Per Bag Size List API RESPONSES
    private func handlefetchAmplePerBag(_ json: JSON) {
        self.deleteAllData("PE_AmplePerBag")
        let _ = AmplePerBagResponse(json)
        fetchAmpleSizes()
    }
    
    // MARK: - Handle PE Ample Per Bag Size List API RESPONSES
    private func handleGetAmplePerBag(_ json: JSON) {
        self.deleteAllData("PE_AmplePerBag")
        let _ = AmplePerBagResponse(json)
        self.getPostingAssessmentListByUser()
    }
    
    // MARK: - Get PE Roles List API
    private func handlefetchAmpleSizes(_ json: JSON) {
        self.deleteAllData("PE_AmpleSizes")
        let _ = AmpleSizeResponse(json)
        fetchRoles()
    }
    
    // MARK: - Handle PE Ample Size List API RESPONSES
    private func handlegettingfetchAmpleSizes(_ json: JSON) {
        self.deleteAllData("PE_AmpleSizes")
        let _ = AmpleSizeResponse(json)
    }
    
    // MARK: - Handle PE Roles List API
    private func handlefetchRoles(_ json: JSON) {
        self.deleteAllData("PE_Roles")
        PERolesResponse(json)
        fetchDOADiluentType()
    }
    
    // MARK: - Handle PE DOA Diluent Type List API
    private func handlefetchDOADiluentType(_ json: JSON) {
        self.deleteAllData("PE_DOADiluentType")
        PEDOADiluentTypeResponce(json)
        fetchSubVaccineNames()
    }
    
    // MARK: - Handle PE Sub Vaccine List API Responce
    private func handlefetchSubVaccineNamesResponse(_ json: JSON) {
        self.deleteAllData("PE_VSubNames")
        let jsonObject = VSubNamesResponse(json)
        fetchPEFrequency()
    }
    
    // MARK: - Handle PE Frequency List API Responce
    private func handlefetchPEFrequency(_ json: JSON) {
        self.deleteAllData("PE_Frequency")
        PEFrequencyResponse(json)
        fetchIncubationStyle()
    }
    
    // MARK: - Handle PE Incubation Style List API Responce
    private func handlefetchIncubationStyle(_ json: JSON) {
        self.deleteAllData("PE_IncubationStyle")
        PEIncubationStyleResponse(json)
        fetchDOASizes()
    }
    
    // MARK: - Handle PE Dose Size List API Responce
    private func handlefetchDOASizes(_ json: JSON) {
        self.deleteAllData("PE_DOASizes")
        PEDOASizesResponse(json)
        UserDefaults.standard.set(true, forKey: "hasPEDataLoaded")
        getPostingAssessmentListByUser()
    }
    
    // MARK: - Handle Countries List API Responce
    private func handlefetchedCountries(_ json: JSON) {
        self.deleteAllData("PE_IncubationStyle")
        PEIncubationStyleResponse(json)
        getPostingAssessmentListByUser()
    }
    
    // MARK: - Handle PE Posting Assessment List API Responce
    private func handlGetPostingAssessmentListByUser(_ json: JSON) {
        var dataDic : [String:Any] = [:]
        var dataArray : [Any] = []
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        dataArray = dataDic["Data"] as? [Any] ?? []
        if  dataArray.count  > 0 {
            self.deleteAllDataWithUserID("PE_AssessmentInOffline")
            self.deleteAllDataWithUserID("PE_AssessmentInDraft")
        }
        for obj in dataArray {
            var objDic : [String:Any] = [:]
            objDic =  obj as? [String:Any] ?? [:]
            let SaveType = objDic["SaveType"] as? Int ?? 0
            let status_Type = objDic["Status_Type"] as? Int ?? 0
            UserDefaults.standard.set(true, forKey: "hasPELoadedPrevData")
            
            if SaveType != 0 {
                let peNewAssessmentWas = PENewAssessment()
                let assessmentCommentsPostingData = objDic["AssessmentCommentsPostingData"] as? [[String:Any]] ?? []
                let assessmentScoresPostingData = objDic["AssessmentScoresPostingData"] as? [[String:Any]] ?? []
                let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                let serverAssessmentId = objDic["AssessmentId"] as? Int ?? 0
                if objDic["HasChlorineStrips"] as? Int == 1{
                    let hasChlorineStrips = true
                }else{
                    let hasChlorineStrips = false
                }
                if objDic["IsAutomaticFail"] as? Int == 1{
                    let isAutomaticFail = true
                }else{
                    let isAutomaticFail = false
                }
                
                let sanitationEmbrexValue = objDic["SanitationEmbrex"] as? Bool ?? false
                if sanitationEmbrexValue{
                    //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                    
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                }
                
                let sanitationEmbrex = objDic["SanitationEmbrexScoresPostinData"] as? [[String:Any]] ?? []
                let jsonData = try? JSONSerialization.data(withJSONObject: sanitationEmbrex, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                if jsonData != nil{
                    let dtoArr = try? jsonDecoder.decode([PESanitationDTO].self, from: jsonData!)
                    if dtoArr != nil{
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.saveServiceResponse(assessmentId: "\(serverAssessmentId)", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", dtoArr: dtoArr!)
                    }
                }
                
                let currentServerAssessmentId = UserDefaults.standard.set(String(serverAssessmentId), forKey: "currentServerAssessmentId")
                peNewAssessmentWas.serverAssessmentId = String(serverAssessmentId)
                let AppCreationTime = objDic["AppCreationTime"] as? String ?? ""
                peNewAssessmentWas.siteId = objDic["SiteId"] as? Int ?? 0
                peNewAssessmentWas.siteName = objDic["SiteName"] as? String ?? ""
                peNewAssessmentWas.customerId = objDic["CustomerId"] as? Int ?? 0
                peNewAssessmentWas.customerName = objDic["CustomerName"] as? String ?? ""
                peNewAssessmentWas.hatcheryAntibiotics = 0
                peNewAssessmentWas.evaluationID  = EvaluationId
                peNewAssessmentWas.extndMicro = objDic["IsInterMicrobial"] as? Bool ?? false
                peNewAssessmentWas.IsEMRequested = objDic["IsEMRequested"] as? Bool ?? false
                peNewAssessmentWas.sanitationValue = objDic["SanitationEmbrex"] as? Bool ?? false
                if let doubleSanitation =  objDic["DoubleSanitation"] as? Bool{
                    if doubleSanitation {
                        peNewAssessmentWas.hatcheryAntibiotics = 1
                    }
                }
                peNewAssessmentWas.isHandMix = objDic["Handmix"] as? Bool ?? false
                peNewAssessmentWas.isEMRejected = objDic["IsEMRejected"] as? Bool ?? false
                peNewAssessmentWas.isPERejected = objDic["IsPERejected"] as? Bool ?? false
                peNewAssessmentWas.emRejectedComment = objDic["EMRejectedComment"] as? String ?? ""
                peNewAssessmentWas.userID = objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationDate = convertDateFormatter(date: objDic["EvaluationDate"] as? String ?? "")
                peNewAssessmentWas.visitID = objDic["VisitId"] as? Int ?? 0
                peNewAssessmentWas.visitName =  objDic["VisitName"] as? String ?? ""
                peNewAssessmentWas.selectedTSRID = objDic["TSRId"] as? Int ?? 0
                let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
                let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
                let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                if  peNewAssessmentWas.selectedTSRID != 0 {
                    if visitIDArray.contains( peNewAssessmentWas.selectedTSRID){
                        let indexOfe =  visitIDArray.index(of: peNewAssessmentWas.selectedTSRID)
                        let TSRName = visitNameArray[indexOfe] as? String ?? ""
                        peNewAssessmentWas.selectedTSR =  TSRName
                    }
                }
                peNewAssessmentWas.evaluatorName = objDic["UserName"] as? String ?? ""
                peNewAssessmentWas.evaluatorID =  objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationName = objDic["EvaluationName"] as? String ?? ""
                peNewAssessmentWas.evaluationID = objDic["EvaluationId"] as? Int ?? 0
                peNewAssessmentWas.incubation = objDic["IncubationStyleName"] as? String ?? ""
                peNewAssessmentWas.breedOfBird = objDic["BreedBirdsName"] as? String ?? ""
                peNewAssessmentWas.breedOfBirdOther = objDic["BreedOfBirdsOther"] as? String ?? ""
                peNewAssessmentWas.dataToSubmitID = objDic["AppCreationTime"] as? String ?? ""
                peNewAssessmentWas.manufacturer = objDic["ManufacturerName"] as? String ?? ""
                peNewAssessmentWas.countryName = objDic["CountryName"] as? String ?? ""
                peNewAssessmentWas.countryID = objDic["CountryId"] as? Int ?? 0
                peNewAssessmentWas.refrigeratorNote = objDic["RefrigeratorNote"] as? String ?? ""
                peNewAssessmentWas.fluid = objDic["IsInovoFluids"] as? Bool ?? false
                peNewAssessmentWas.basicTransfer = objDic["IsBasicTrfAssessment"] as? Bool ?? false
                peNewAssessmentWas.extndMicro = objDic["IsInterMicrobial"] as? Bool ?? false
                peNewAssessmentWas.clorineName = objDic["ChlorineText"] as? String ?? ""
                peNewAssessmentWas.clorineId = objDic["ChlorineId"] as? Int ?? 0
                
                let manuOthers = objDic["ManufacturerOther"] as? String ?? ""
                if manuOthers != "" {
                    peNewAssessmentWas.manufacturer = "S" + manuOthers
                }
                let eggStr = objDic["EggsPerFlatName"] as? String ?? "0"
                peNewAssessmentWas.noOfEggs = Int64(eggStr)
                let eggsOthers = objDic["EggsPerFlatOther"]  as? String ?? ""
                if eggsOthers != "" {
                    let txt = eggsOthers
                    let str =   txt  + "000"
                    let iii = Int64(str)
                    if  iii != nil{
                        peNewAssessmentWas.noOfEggs = iii!
                    }
                }
                let fsrSignatureImage = objDic["FSTSignatureImage"]  as? String ?? ""
                peNewAssessmentWas.FSTSignatureImage = fsrSignatureImage
                let f = objDic["FlockAgeId"] as? Int ?? 0
                peNewAssessmentWas.isFlopSelected =  f
                let Camera =  objDic["Camera"]  as? Bool ?? false
                if  Camera == true {
                    peNewAssessmentWas.camera = 1
                } else {
                    peNewAssessmentWas.camera = 0
                }
                peNewAssessmentWas.notes = objDic["Notes"] as? String ?? ""
                let strBase64Signatture =  objDic["SignatureImage"] as? String ?? ""
                let representaiveName =  objDic["RepresentativeName"] as? String ?? ""
                let RoleName =  objDic["RoleName"] as? String ?? ""
                let imageData : Data? = Data(base64Encoded: strBase64Signatture, options: .ignoreUnknownCharacters)
                
                let strBase64Signatture2 =  objDic["SignatureImage2"] as? String ?? ""
                let representaiveName2 =  objDic["RepresentativeName2"] as? String ?? ""
                let RoleName2 =  objDic["RoleName2"] as? String ?? ""
                let fsrSignature = objDic["RepresentativeName2"] as? String ?? ""
                let imageData2 : Data = Data(base64Encoded: strBase64Signatture2, options: .ignoreUnknownCharacters) ?? Data()
                let representaiveNotes =  objDic["RepresentativeNotes"] as? String ?? ""
                let SignatureDate =  objDic["SignatureDate"] as? String ?? ""
                let id = self.saveImageInPEModule(imageData: imageData ?? Data())
                let id2 = self.saveImageInPEModule(imageData: imageData2)
                
                var sigDate = ""
                
                if SignatureDate != "" {
                    sigDate = self.convertDateFormat(inputDate: SignatureDate)
                } else {
                    sigDate = Date().stringFormat(format: "yyyy-MM-dd")
                }
                let param : [String:String] = ["sig":String(id),"sig2":String(id2),"sig_Date":sigDate ,"sig_EmpID":RoleName,"sig_Name":representaiveName ?? "","sig_EmpID2":RoleName2,"sig_Name2":representaiveName2 ?? "","sig_Phone":representaiveNotes ?? ""]
                jsonRe = (getJSON("QuestionAns") ?? JSON())
                pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
                let questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
                let infoImageDataResponse = InfoImageDataResponse(questionInfo)
                let categoryCount = filterCategoryCount(peNewAssessmentOf: peNewAssessmentWas)
                if categoryCount > 0 {
                    for  cat in  pECategoriesAssesmentsResponse.peCategoryArray {
                        for (index, ass) in cat.assessmentQuestions.enumerated(){
                            var peNewAssessmentNew = PENewAssessment()
                            peNewAssessmentNew = peNewAssessmentWas
                            peNewAssessmentNew.serverAssessmentId = peNewAssessmentWas.serverAssessmentId
                            peNewAssessmentNew.cID = index
                            peNewAssessmentNew.catID = cat.id
                            peNewAssessmentNew.catName = cat.categoryName
                            peNewAssessmentNew.catMaxMark = cat.maxMark
                            peNewAssessmentNew.sequenceNo = cat.id
                            peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                            peNewAssessmentNew.catResultMark = cat.maxMark
                            peNewAssessmentNew.catEvaluationID = cat.evaluationID
                            peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                            peNewAssessmentNew.assID = ass.id
                            peNewAssessmentNew.assDetail1 = ass.assessment
                            peNewAssessmentNew.evaluationID = cat.evaluationID
                            peNewAssessmentNew.assDetail2 = ass.assessment2
                            peNewAssessmentNew.assMinScore = ass.minScore
                            peNewAssessmentNew.assMaxScore = ass.maxScore
                            peNewAssessmentNew.assCatType = ass.cateType
                            peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                            peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                            peNewAssessmentNew.assStatus = 1
                            peNewAssessmentNew.informationImage = ass.informationImage
                            peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                            peNewAssessmentNew.isChlorineStrip = objDic["HasChlorineStrips"] as? Int ?? 0
                            peNewAssessmentNew.isAutomaticFail = objDic["IsAutomaticFail"] as? Int ?? 0
                            peNewAssessmentNew.isAllowNA = ass.isAllowNA
                            peNewAssessmentNew.rollOut = ass.rollOut
                            peNewAssessmentNew.isNA = ass.isNA
                            peNewAssessmentNew.qSeqNo = ass.qSeqNo
                            CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                        }
                    }
                    let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                    var filterScoreData : [[String:Any]] = [[:]]
                    var isNaSelectedArray : [[String:Any]] = [[:]]
                    for questionMark in assessmentScoresPostingData {
                        let AssessmentScore = questionMark["AssessmentScore"] as? Int ?? 0
                        let QCCount = questionMark["QCCount"] as? String ?? ""
                        let FrequencyValue = questionMark["FrequencyValue"] as? Int ?? 32
                        var FrequencyValueStr = ""
                        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
                        let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
                        let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
                        if FrequencyValue != 32 {
                            if visitIDArray.contains(FrequencyValue){
                                let indexOfe =  visitIDArray.index(of: FrequencyValue) //
                                FrequencyValueStr = visitNameArray[indexOfe] as? String ?? ""
                            }
                        }
                        let TextAmPm = questionMark["TextAmPm"] as? String ?? ""
                        let PersonName = questionMark["PersonName"] as? String ?? ""
                        
                        let PPMValue = questionMark["Chlorine_Value"] as? String ?? ""
                        let isNAValue = questionMark["IsNA"] as? Bool ?? false
                        
                        if FrequencyValueStr.count > 0 {
                            CoreDataHandlerPE().updateFrequencyInAssessmentInProgress(frequency:FrequencyValueStr)
                        }
                        if QCCount.count > 0 {
                            CoreDataHandlerPE().updateQCCountInAssessmentInProgress(qcCount:QCCount)
                        }
                        if PersonName.count > 0 {
                            CoreDataHandlerPE().updatePersonNameInAssessmentInProgress(personName: PersonName)
                        }
                        if TextAmPm.count > 0 {
                            CoreDataHandlerPE().updateAMPMInAssessmentInProgress(ampmValue: TextAmPm)
                        }
                        if PPMValue.count > 0 {
                            CoreDataHandlerPE().updatePPMValueInAssessmentInProgress(PpmValue: PPMValue)
                        }
                        if AssessmentScore  ==  0 || (isNAValue)  {
                            filterScoreData.append(questionMark)
                        }
                        if isNAValue{
                            isNaSelectedArray.append(questionMark)
                        }
                    }
                    
                    var assArray : [Int] = []
                    for cat in filterScoreData {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        assArray.append(assID)
                    }
                    
                    var naArray : [Int] = []
                    for cat in isNaSelectedArray
                    {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        naArray.append(assID)
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in naArray {
                            
                            if (Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestTotalMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInTotalAnsInProgressTable(catISSelected:catISSelected,catMaxMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                            }
                        }
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assArray {
                            
                            if ( Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInAnsInProgressTable(catISSelected:catISSelected,catResultMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                            }
                        }
                    }
                    
                    var assNAArray : [[String:Any]] = [[:]]
                    for cat in assessmentScoresPostingData {
                        let isNA = cat["IsNA"] as? Bool ?? false
                        if(isNA){
                            assNAArray.append(cat)
                        }
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assNAArray {
                            let assIsNA = assID["IsNA"] as? Bool ?? false
                            let AssessmentId = assID["ModuleAssessmentId"] as? Int ?? 0
                            
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().update_isNAInAssessmentInProgress(isNA: true, assID: Int(objMark.assID ?? 0))
                            }
                        }
                    }
                    
                    //score ends
                    //comment start
                    var filterCommentData : [[String:Any]] = [[:]]
                    for questionMark in assessmentCommentsPostingData {
                        let AssessmentComment = questionMark["AssessmentComment"] as? String ?? ""
                        if AssessmentComment.count > 0  {
                            filterCommentData.append(questionMark)
                        }
                    }
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in filterCommentData {
                            let AssessmentComment = assID["AssessmentComment"] as? String ?? ""
                            let AssessmentId = assID["AssessmentId"] as? Int ?? 0
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().updateNoteInProgressTable(assID:Int(truncating: objMark.assID ?? 0),text:AssessmentComment)
                            }
                        }
                    }
                    //comment ends
                    let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                    let InovojectPostingData = objDic["InovojectPostingData"] as? [Any] ?? []
                    let VaccineMixerObservedPostingData = objDic["VaccineMixerObservedPostingData"] as? [Any] ?? []
                    
                    // INOVOJECT
                    for inoDic in InovojectPostingData {
                        
                        let inoDicIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = inoDicIS["Dosage"] as? String ?? ""
                        let otherString = inoDicIS["OtherText"] as? String ?? ""
                        let VaccineId = inoDicIS["VaccineId"] as? Int ?? 0
                        let AmpuleSize = inoDicIS["AmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        let AntibioticInformation =  inoDicIS["AntibioticInformation"] as? String ?? ""
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe = ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = inoDicIS["AmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  inoDicIS["HatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = inoDicIS["ManufacturerId"] as? Int ?? 0
                        let BagSizeType = inoDicIS["BagSizeType"] as? String ?? ""
                        let DiluentMfg = inoDicIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        let ProgramName = inoDicIS["ProgramName"] as? String ?? ""
                        let DiluentsMfgOtherName = inoDicIS["DiluentsMfgOtherName"] as? String ?? ""
                        
                        var vManufacutrerNameArray = NSArray()
                        var vManufacutrerIDArray = NSArray()
                        var vManufacutrerDetailsArray = NSArray()
                        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }  else {
                            VName = otherString
                        }
                        
                        if otherString != "" {
                            VName = otherString
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        var HatcheryAntibioticsIntVal = 0
                        
                        if HatcheryAntibiotics == true{
                            HatcheryAntibioticsIntVal = 1
                        } else {
                            HatcheryAntibioticsIntVal = 0
                        }
                        
                        peNewAssessmentInProgress.iCS  = inoDicIS["BagSizeType"] as? String ?? ""
                        let diluentMfg  = inoDicIS["DiluentMfg"] as? String ?? ""
                        peNewAssessmentInProgress.iDT = diluentMfg
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromInvo: true)
                        
                        //let inVoDataNew = InovojectData(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                        
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                        let inVoDataNew = InovojectData(info: info)
                        
                        let id = self.saveInovojectInPEModule(inovojectData: inVoDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        inVoDataNew.id = id
                    }
                    let DayPostingData = objDic["DayOfAgePostingData"] as? [Any] ?? []
                    //Day OF AGE
                    for inoDic in DayPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayOfAgeDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayOfAgeMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayOfAgeAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = DayOfAgeIS["DayOfAgeAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayOfBagHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayOfAgeMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayOfAgeBagSizeType"] as? String ?? ""
                        
                        let DiluentMfg = DayOfAgeIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        var vManufacutrerNameArray = NSArray()
                        var vManufacutrerIDArray = NSArray()
                        var vManufacutrerDetailsArray = NSArray()
                        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                                VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }
                        
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                                
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        
                        let DayOfAgeDataNew = InovojectData(info: info)
                        peNewAssessmentInProgress.dCS  = DiluentMfg
                        peNewAssessmentInProgress.dDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoa : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        DayOfAgeDataNew.id = id
                    }
                    
                    // save Refrigator
                    
                    let refriPostingData = objDic["RefrigeratorPostingData"] as? [Any] ?? []
                    for refriDic in refriPostingData {
                        let RefriData = refriDic as? [String:Any] ?? [:]
                        let id = RefriData["Id"] as? Int ?? 0
                        let assessmentId = RefriData["AssessmentId"] as? Int ?? 0
                        let assessmentDetailId = RefriData["AssessmentDetailId"] as? Int ?? 0
                        let refValue = RefriData["RefValue"] as? Double ?? 0.0
                        let isNa = RefriData["IsNa"] as? Bool ?? false
                        let isCheck = RefriData["IsCheck"] as? Bool ?? false
                        let userId = RefriData["UserId"] as? Int ?? 0
                        let refUnit = RefriData["RefUnit"] as? String ?? ""
                        let fridgeData = CoreDataHandlerPEModels.offlineRefrigatorData(id: (assessmentId ?? 0) as NSNumber,  labelText: "", rollOut: "Y", unit:  refUnit ?? "", value: refValue ?? 0.0,catID: 11 ,isCheck: isCheck ?? false,isNA: isNa ?? false,schAssmentId: assessmentDetailId ?? 0)
                        CoreDataHandlerPE().saveOfflineRefrigatorInDB(fridgeData)
                    }
                    
                    let DayAgeSubcutaneousDetailsPostingData = objDic["DayAgeSubcutaneousDetailsPostingData"] as? [Any] ?? []
                    for inoDic in DayAgeSubcutaneousDetailsPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayAgeSubcutaneousDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayAgeSubcutaneousMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayAgeSubcutaneousAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        let AmpulePerbag = DayOfAgeIS["DayAgeSubcutaneousAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayAgeSubcutaneousHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayAgeSubcutaneousMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayAgeSubcutaneousBagSizeType"] as? String ?? ""
                        let DiluentMfg = DayOfAgeIS["DayAgeSubcutaneousDiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        var vManufacutrerNameArray = NSArray()
                        var vManufacutrerIDArray = NSArray()
                        var vManufacutrerDetailsArray = NSArray()
                        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                                VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        } else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        //let DayOfAgeDataNew = InovojectData(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: info)
                        
                        peNewAssessmentInProgress.dDCS  = DiluentMfg
                        peNewAssessmentInProgress.dDDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaSText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoaS : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(),fromDoaS: true)
                        DayOfAgeDataNew.id = id
                    }
                    //VMIXER
                    for  vmixer in  VaccineMixerObservedPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var CertificationDate = vmixerIS["CertificationDate"] as? String ?? ""
                        var CertificationDateIS = ""
                        if CertificationDate != "" {
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "T", with: "")
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "00", with: "")
                            CertificationDate = CertificationDate.replacingOccurrences(of: ":", with: "")
                            let array = CertificationDate.components(separatedBy: "-")
                            let date = array[2]
                            let month = array[1]
                            let year = array[0]
                            if regionID == 3
                            {
                                CertificationDateIS = month + "-" +  date + "-" +  year
                            }
                            else
                            {
                                CertificationDateIS = date + "/" +  month + "/" +  year
                            }
                            
                        }
                        let isCertExpired = vmixerIS["IsCertExpired"] as? Bool ?? false
                        let isReCert = vmixerIS["IsReCert"] as? Bool ?? false
                        let vacOperatorId = vmixerIS["vacOperatorId"] as? Int ?? 0
                        let signatureImg = vmixerIS["SignatureImg"] as? String ?? ""
                        let isManuallyAdded = vmixerIS["isManuallyAdded"] as? Bool ?? false
                        let catId = vmixerIS["ModuleAssessmentCatId"] as? Int ?? 0
                        let imageCount = getVMixerCountInPEModule()
                        let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:imageCount + 1,name:Name,date:CertificationDateIS,isCertExpired: isCertExpired,isReCert: isReCert,vacOperatorId: vacOperatorId, signatureImg: signatureImg, fsrSign: fsrSignatureImage, isManuallyAdded: isManuallyAdded)
                        let certificateData = PECertificateData(info: certificModel)
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        CoreDataHandlerPE().saveVMixerPEModuleGet(peCertificateData: certificateData,evalutionID:peNewAssessmentInProgress.evaluationID , CategoryID: catId)
                    }
                    let VaccineMicroSamplesPostingData = objDic["VaccineMicroSamplesPostingData"] as? [Any] ?? []
                    //Micro
                    for  vmixer in  VaccineMicroSamplesPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.micro  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    let VaccineResiduePostinData = objDic["VaccineResiduePostinData"] as? [Any] ?? []
                    //Residue
                    for  vmixer in  VaccineResiduePostinData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.residue  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    let dataToSubmitNumber = self.getAssessmentInOfflineFromDb()
                    for obj in allAssesmentArr {
                        CoreDataHandlerPE().saveDataToSyncPEInDBFromGet(newAssessment: obj as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(), dataToSubmitNumber: dataToSubmitNumber + 1,param:param,formateFromServer: AppCreationTime)
                    }
                    CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
                    CoreDataHandler().deleteAllData("PE_Refrigator")
                }
            }
            else {
                
                let peNewAssessmentWas = PENewAssessment()
                let assessmentCommentsPostingData = objDic["AssessmentCommentsPostingData"] as? [[String:Any]] ?? []
                let assessmentScoresPostingData = objDic["AssessmentScoresPostingData"] as? [[String:Any]] ?? []
                let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                let serverAssessmentId = objDic["AssessmentId"] as? Int ?? 0
                var hasChlorineStrips = false
                var isAutomaticFail = false
                if objDic["HasChlorineStrips"] as? Int == 1{
                    hasChlorineStrips = true
                }
                if objDic["IsAutomaticFail"] as? Int == 1{
                    isAutomaticFail = true
                }
                
                if hasChlorineStrips{
                    //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: false, assessmentId: "\(serverAssessmentId)", date: nil, override: false, hasChlorineStrips: hasChlorineStrips, isAutomaticFail: isAutomaticFail)
                    
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: false, assessmentId: "\(serverAssessmentId)", date: nil, override: false, hasChlorineStrips: hasChlorineStrips, isAutomaticFail: isAutomaticFail)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                }
                
                let sanitationEmbrexValue = objDic["SanitationEmbrex"] as? Bool ?? false
                if sanitationEmbrexValue{
                    ///PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false, hasChlorineStrips: hasChlorineStrips, isAutomaticFail: isAutomaticFail)
                    
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false, hasChlorineStrips: hasChlorineStrips, isAutomaticFail: isAutomaticFail)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                }
                
                let sanitationEmbrex = objDic["SanitationEmbrexScoresPostinData"] as? [[String:Any]] ?? []
                let jsonData = try? JSONSerialization.data(withJSONObject: sanitationEmbrex, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                if jsonData != nil{
                    let dtoArr = try? jsonDecoder.decode([PESanitationDTO].self, from: jsonData!)
                    if dtoArr != nil{
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.saveServiceResponse(assessmentId: "\(serverAssessmentId)", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", dtoArr: dtoArr!)
                    }
                    
                }
                UserDefaults.standard.set(String(serverAssessmentId), forKey: "currentServerAssessmentId")
                peNewAssessmentWas.serverAssessmentId = String(serverAssessmentId)
                let AppCreationTime = objDic["AppCreationTime"] as? String ?? ""
                let DeviceId = objDic["DeviceId"] as? String ?? ""
                peNewAssessmentWas.siteId = objDic["SiteId"] as? Int ?? 0
                peNewAssessmentWas.siteName = objDic["SiteName"] as? String ?? ""
                peNewAssessmentWas.customerId = objDic["CustomerId"] as? Int ?? 0
                peNewAssessmentWas.customerName = objDic["CustomerName"] as? String ?? ""
                peNewAssessmentWas.statusType = objDic["Status_Type"] as? Int ?? 0
                peNewAssessmentWas.userID = objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationDate = convertDateFormatter(date: objDic["EvaluationDate"] as? String ?? "")
                peNewAssessmentWas.visitID = objDic["VisitId"] as? Int ?? 0
                peNewAssessmentWas.visitName =  objDic["VisitName"] as? String ?? ""
                peNewAssessmentWas.selectedTSRID = objDic["TSRId"] as? Int ?? 0
                peNewAssessmentWas.hatcheryAntibiotics = 0
                peNewAssessmentWas.evaluationID  = EvaluationId
                peNewAssessmentWas.isHandMix = objDic["Handmix"] as? Bool ?? false
                peNewAssessmentWas.isEMRejected = objDic["IsEMRejected"] as? Bool ?? false
                peNewAssessmentWas.isPERejected = objDic["IsPERejected"] as? Bool ?? false
                peNewAssessmentWas.emRejectedComment = objDic["EMRejectedComment"] as? String ?? ""
                
                if let doubleSanitation =  objDic["DoubleSanitation"] as? Bool{
                    if doubleSanitation {
                        peNewAssessmentWas.hatcheryAntibiotics = 1
                    }
                }
                let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
                let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
                let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                if  peNewAssessmentWas.selectedTSRID != 0 {
                    if visitIDArray.contains( peNewAssessmentWas.selectedTSRID){
                        let indexOfe =  visitIDArray.index(of: peNewAssessmentWas.selectedTSRID)
                        let TSRName = visitNameArray[indexOfe] as? String ?? ""
                        peNewAssessmentWas.selectedTSR =  TSRName
                    }
                }
                
                peNewAssessmentWas.evaluatorName = objDic["UserName"] as? String ?? ""
                peNewAssessmentWas.evaluatorID =  objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationName = objDic["EvaluationName"] as? String ?? ""
                peNewAssessmentWas.evaluationID = objDic["EvaluationId"] as? Int ?? 0
                peNewAssessmentWas.incubation = objDic["IncubationStyleName"] as? String ?? ""
                peNewAssessmentWas.breedOfBird = objDic["BreedBirdsName"] as? String ?? ""
                peNewAssessmentWas.breedOfBirdOther = objDic["BreedOfBirdsOther"] as? String ?? ""
                peNewAssessmentWas.dataToSubmitID = objDic["DeviceId"] as? String ?? ""
                peNewAssessmentWas.rejectionComment = objDic["RejectionComments"] as? String ?? ""
                peNewAssessmentWas.manufacturer = objDic["ManufacturerName"] as? String ?? ""
                peNewAssessmentWas.countryName = objDic["CountryName"] as? String ?? ""
                peNewAssessmentWas.countryID = objDic["CountryId"] as? Int ?? 0
                peNewAssessmentWas.clorineName = objDic["ChlorineText"] as? String ?? ""
                peNewAssessmentWas.clorineId = objDic["ChlorineId"] as? Int ?? 0
                peNewAssessmentWas.fluid = objDic["IsInovoFluids"] as? Bool ?? false
                peNewAssessmentWas.basicTransfer = objDic["IsBasicTrfAssessment"] as? Bool ?? false
                peNewAssessmentWas.extndMicro = objDic["IsInterMicrobial"] as? Bool ?? false
                peNewAssessmentWas.refrigeratorNote = objDic["RefrigeratorNote"] as? String ?? ""
                peNewAssessmentWas.IsEMRequested = objDic["IsEMRequested"] as? Bool ?? false
                peNewAssessmentWas.sanitationValue = objDic["SanitationEmbrex"] as? Bool ?? false
                
                let manuOthers = objDic["ManufacturerOther"] as? String ?? ""
                if manuOthers != "" {
                    peNewAssessmentWas.manufacturer = "S" + manuOthers
                }
                let eggStr = objDic["EggsPerFlatName"] as? String ?? "0"
                peNewAssessmentWas.noOfEggs = Int64(eggStr)
                
                let eggsOthers = objDic["EggsPerFlatOther"]  as? String ?? ""
                if eggsOthers != "" {
                    let txt = eggsOthers
                    let str =   txt  + "000"
                    let iii = Int64(str)
                    if iii != nil{
                        peNewAssessmentWas.noOfEggs = iii!
                    }
                }
                
                let fsrSignatureImage = objDic["FSTSignatureImage"]  as? String ?? ""
                peNewAssessmentWas.FSTSignatureImage = fsrSignatureImage
                let f = objDic["FlockAgeId"] as? Int ?? 0
                peNewAssessmentWas.isFlopSelected =  f
                let Camera =  objDic["Camera"]  as? Bool ?? false
                if  Camera == true {
                    peNewAssessmentWas.camera = 1
                } else {
                    peNewAssessmentWas.camera = 0
                }
                
                peNewAssessmentWas.notes = objDic["Notes"] as? String ?? ""
                let strBase64Signatture =  objDic["SignatureImage"] as? String ?? ""
                let representaiveName =  objDic["RepresentativeName"] as? String ?? ""
                let RoleName =  objDic["RoleName"] as? String ?? ""
                let imageData : Data? = Data(base64Encoded: strBase64Signatture, options: .ignoreUnknownCharacters)
                
                let strBase64Signatture2 =  objDic["SignatureImage2"] as? String ?? ""
                let representaiveName2 =  objDic["RepresentativeName2"] as? String ?? ""
                let RoleName2 =  objDic["RoleName2"] as? String ?? ""
                let imageData2 : Data = Data(base64Encoded: strBase64Signatture2, options: .ignoreUnknownCharacters) ?? Data()
                let representaiveNotes =  objDic["RepresentativeNotes"] as? String ?? ""
                let SignatureDate =  objDic["SignatureDate"] as? String ?? ""
                let id = self.saveImageInPEModule(imageData: imageData ?? Data())
                let id2 = self.saveImageInPEModule(imageData: imageData2)
                var sigDate = ""
                if SignatureDate != "" {
                    sigDate = self.convertDateFormat(inputDate: SignatureDate)
                } else {
                    sigDate = Date().stringFormat(format: "MMM d, yyyy")
                }
                let param : [String:String] = ["sig":String(id),"sig2":String(id2),"sig_Date":sigDate ,"sig_EmpID":RoleName,"sig_Name":representaiveName ?? "","sig_EmpID2":RoleName2,"sig_Name2":representaiveName2 ?? "","sig_Phone":representaiveNotes ?? ""]
                jsonRe = (getJSON("QuestionAns") ?? JSON())
                pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
                let questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
                let infoImageDataResponse = InfoImageDataResponse(questionInfo)
                
                let categoryCount = filterCategoryCount(peNewAssessmentOf: peNewAssessmentWas)
                if categoryCount > 0 {
                    for  cat in  pECategoriesAssesmentsResponse.peCategoryArray {
                        for (index, ass) in cat.assessmentQuestions.enumerated(){
                            var peNewAssessmentNew = PENewAssessment()
                            peNewAssessmentNew = peNewAssessmentWas
                            peNewAssessmentNew.cID = index
                            peNewAssessmentNew.catID = cat.id
                            peNewAssessmentNew.catName = cat.categoryName
                            peNewAssessmentNew.catMaxMark = cat.maxMark
                            peNewAssessmentNew.sequenceNo = cat.id
                            peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                            peNewAssessmentNew.catResultMark = cat.maxMark
                            peNewAssessmentNew.catEvaluationID = cat.evaluationID
                            peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                            peNewAssessmentNew.assID = ass.id
                            peNewAssessmentNew.assDetail1 = ass.assessment
                            peNewAssessmentNew.evaluationID = cat.evaluationID
                            peNewAssessmentNew.assDetail2 = ass.assessment2
                            peNewAssessmentNew.assMinScore = ass.minScore
                            peNewAssessmentNew.assMaxScore = ass.maxScore
                            peNewAssessmentNew.assCatType = ass.cateType
                            peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                            peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                            peNewAssessmentNew.assStatus = 1
                            peNewAssessmentNew.informationImage = ass.informationImage
                            peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                            peNewAssessmentNew.isChlorineStrip = objDic["HasChlorineStrips"] as? Int ?? 0
                            peNewAssessmentNew.isAutomaticFail = objDic["IsAutomaticFail"] as? Int ?? 0
                            peNewAssessmentNew.isAllowNA = ass.isAllowNA
                            peNewAssessmentNew.isNA = ass.isNA
                            peNewAssessmentNew.rollOut = ass.rollOut
                            peNewAssessmentNew.qSeqNo = ass.qSeqNo
                            
                            CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                        }
                    }
                    var allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                    var filterScoreData : [[String:Any]] = [[:]]
                    var isNaSelectedArray : [[String:Any]] = [[:]]
                    for questionMark in assessmentScoresPostingData {
                        let AssessmentScore = questionMark["AssessmentScore"] as? Int ?? 0
                        let QCCount = questionMark["QCCount"] as? String ?? ""
                        
                        let FrequencyValue = questionMark["FrequencyValue"] as? Int ?? 32
                        var FrequencyValueStr = ""
                        
                        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
                        let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
                        let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
                        if FrequencyValue != 32 {
                            if visitIDArray.contains(FrequencyValue){
                                let indexOfe =  visitIDArray.index(of: FrequencyValue) //
                                FrequencyValueStr = visitNameArray[indexOfe] as? String ?? ""
                            }
                        }
                        
                        let isNAValue = questionMark["IsNA"] as? Bool ?? false
                        let TextAmPm = questionMark["TextAmPm"] as? String ?? ""
                        let PersonName = questionMark["PersonName"] as? String ?? ""
                        let PPMValue = questionMark["Chlorine_Value"] as? String ?? ""
                        
                        if QCCount.count > 0 {
                            CoreDataHandlerPE().updateQCCountInAssessmentInProgress(qcCount:QCCount)
                        }
                        
                        if FrequencyValueStr.count > 0 {
                            CoreDataHandlerPE().updateFrequencyInAssessmentInProgress(frequency:FrequencyValueStr)
                        }
                        if PersonName.count > 0 {
                            CoreDataHandlerPE().updatePersonNameInAssessmentInProgress(personName: PersonName)
                        }
                        if TextAmPm.count > 0 {
                            CoreDataHandlerPE().updateAMPMInAssessmentInProgress(ampmValue: TextAmPm)
                        }
                        if PPMValue.count > 0 {
                            CoreDataHandlerPE().updatePPMInAssessmentInProgress(ppmValue: PPMValue)
                        }
                        //
                        if (AssessmentScore  ==  0) || (isNAValue) {
                            filterScoreData.append(questionMark)
                        }
                        if isNAValue{
                            isNaSelectedArray.append(questionMark)
                        }
                    }
                    var assArray : [Int] = []
                    for cat in filterScoreData {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        assArray.append(assID)
                    }
                    
                    var naArray : [Int] = []
                    for cat in isNaSelectedArray {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        naArray.append(assID)
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in naArray {
                            
                            if (Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestTotalMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInTotalAnsInProgressTable(catISSelected:catISSelected,catMaxMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                            }
                        }
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assArray {
                            
                            if ( Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInAnsInProgressTable(catISSelected:catISSelected,catResultMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                            }
                        }
                    }
                    //
                    var assNAArray : [[String:Any]] = [[:]]
                    for cat in assessmentScoresPostingData {
                        let isNA = cat["IsNA"] as? Bool ?? false
                        if(isNA){
                            assNAArray.append(cat)
                        }
                        
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assNAArray {
                            let assIsNA = assID["IsNA"] as? Bool ?? false
                            let AssessmentId = assID["ModuleAssessmentId"] as? Int ?? 0
                            
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().update_isNAInAssessmentInProgress(isNA: true, assID: Int(objMark.assID ?? 0))
                            }
                            
                        }
                    }
                    
                    //score ends
                    //comment start
                    var filterCommentData : [[String:Any]] = [[:]]
                    for questionMark in assessmentCommentsPostingData {
                        let AssessmentComment = questionMark["AssessmentComment"] as? String ?? ""
                        if AssessmentComment.count > 0  {
                            filterCommentData.append(questionMark)
                        }
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in filterCommentData {
                            let AssessmentComment = assID["AssessmentComment"] as? String ?? ""
                            let AssessmentId = assID["AssessmentId"] as? Int ?? 0
                            
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().updateNoteInProgressTable(assID:Int(objMark.assID ?? 0),text:AssessmentComment)
                            }
                        }
                    }
                    //comment ends
                    let InovojectPostingData = objDic["InovojectPostingData"] as? [Any] ?? []
                    let VaccineMixerObservedPostingData = objDic["VaccineMixerObservedPostingData"] as? [Any] ?? []
                    
                    for inoDic in InovojectPostingData {
                        
                        let inoDicIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = inoDicIS["Dosage"] as? String ?? ""
                        let otherString = inoDicIS["OtherText"] as? String ?? ""
                        let VaccineId = inoDicIS["VaccineId"] as? Int ?? 0
                        let AmpuleSize = inoDicIS["AmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        let AntibioticInformation =  inoDicIS["AntibioticInformation"] as? String ?? ""
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = inoDicIS["AmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  inoDicIS["HatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = inoDicIS["ManufacturerId"] as? Int ?? 0
                        let BagSizeType = inoDicIS["BagSizeType"] as? String ?? ""
                        let DiluentMfg = inoDicIS["DiluentMfg"] as? String ?? ""
                        var VName = ""
                        let ProgramName = inoDicIS["ProgramName"] as? String ?? ""
                        let DiluentsMfgOtherName = inoDicIS["DiluentsMfgOtherName"] as? String ?? ""
                        
                        
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }  else {
                            VName = otherString
                        }
                        
                        if otherString != "" {
                            VName = otherString
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        var HatcheryAntibioticsIntVal = 0
                        if HatcheryAntibiotics == true{
                            HatcheryAntibioticsIntVal = 1
                        } else {
                            HatcheryAntibioticsIntVal = 0
                        }
                        
                        peNewAssessmentInProgress.iCS  = inoDicIS["BagSizeType"] as? String ?? ""
                        let diluentMfg  = inoDicIS["DiluentMfg"] as? String ?? ""
                        peNewAssessmentInProgress.iDT = diluentMfg
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromInvo: true)
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                        
                        let inVoDataNew = InovojectData(info: info)
                        let id = self.saveInovojectInPEModule(inovojectData: inVoDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        inVoDataNew.id = id
                    }
                    
                    let DayPostingData = objDic["DayOfAgePostingData"] as? [Any] ?? []
                    for inoDic in DayPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayOfAgeDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayOfAgeMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayOfAgeAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = DayOfAgeIS["DayOfAgeAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayOfBagHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayOfAgeMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayOfAgeBagSizeType"] as? String ?? ""
                        let DiluentMfg = DayOfAgeIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        var vManufacutrerNameArray = NSArray()
                        var vManufacutrerIDArray = NSArray()
                        var vManufacutrerDetailsArray = NSArray()
                        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                                VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx) {
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        } else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                                
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: info)
                        
                        peNewAssessmentInProgress.dCS  = DiluentMfg
                        peNewAssessmentInProgress.dDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        
                        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoa : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        DayOfAgeDataNew.id = id
                    }
                    
                    // save Draft Refrigator
                    let refriPostingData = objDic["RefrigeratorPostingData"] as? [Any] ?? []
                    for refriDic in refriPostingData {
                        
                        let RefriData = refriDic as? [String:Any] ?? [:]
                        let id = RefriData["Id"] as? Int ?? 0
                        let assessmentId = RefriData["AssessmentId"] as? Int ?? 0
                        let assessmentDetailId = RefriData["AssessmentDetailId"] as? Int ?? 0
                        let refValue = RefriData["RefValue"] as? Double ?? 0.0
                        let isNa = RefriData["IsNa"] as? Bool ?? false
                        let isCheck = RefriData["IsCheck"] as? Bool ?? false
                        let userId = RefriData["UserId"] as? Int ?? 0
                        let refUnit = RefriData["RefUnit"] as? String ?? ""
                        let fridgeData = CoreDataHandlerPEModels.offlineRefrigatorData(id: (assessmentId ?? 0) as NSNumber,  labelText: "", rollOut: "Y", unit:  refUnit ?? "", value: refValue ?? 0.0,catID: 11 ,isCheck: isCheck ?? false,isNA: isNa ?? false,schAssmentId: assessmentDetailId ?? 0)
                        CoreDataHandlerPE().saveOfflineRefrigatorInDB(fridgeData)
                    }
                    
                    let DayAgeSubcutaneousDetailsPostingData = objDic["DayAgeSubcutaneousDetailsPostingData"] as? [Any] ?? []
                    
                    for inoDic in DayAgeSubcutaneousDetailsPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayAgeSubcutaneousDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayAgeSubcutaneousMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayAgeSubcutaneousAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        var ampleSizeesNameArray = NSArray()
                        var ampleSizeIDArray = NSArray()
                        var ampleSizeDetailArray = NSArray()
                        ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        let AmpulePerbag = DayOfAgeIS["DayAgeSubcutaneousAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayAgeSubcutaneousHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayAgeSubcutaneousMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayAgeSubcutaneousBagSizeType"] as? String ?? ""
                        let DiluentMfg = DayOfAgeIS["DayAgeSubcutaneousDiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        var vManufacutrerNameArray = NSArray()
                        var vManufacutrerIDArray = NSArray()
                        var vManufacutrerDetailsArray = NSArray()
                        vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                                VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }
                        var vNameArray = NSArray()
                        var vIDArray = NSArray()
                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
                        vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx)
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        } else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: info)
                        
                        peNewAssessmentInProgress.dDCS  = DiluentMfg
                        peNewAssessmentInProgress.dDDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaSText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoaS : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(),fromDoaS: true)
                        DayOfAgeDataNew.id = id
                    }
                    
                    for  vmixer in  VaccineMixerObservedPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var CertificationDate = vmixerIS["CertificationDate"] as? String ?? ""
                        var CertificationDateIS = ""
                        if CertificationDate != "" {
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "T", with: "")
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "00", with: "")
                            CertificationDate = CertificationDate.replacingOccurrences(of: ":", with: "")
                            let array = CertificationDate.components(separatedBy: "-")
                            let date = array[2]
                            let month = array[1]
                            let year = array[0]
                            CertificationDateIS = month + "-" +  date + "-" +  year
                        }
                        let isCertExpired = vmixerIS["IsCertExpired"] as? Bool ?? false
                        let isReCert = vmixerIS["IsReCert"] as? Bool ?? false
                        let vacOperatorId = vmixerIS["vacOperatorId"] as? Int ?? 0
                        let signatureImg = vmixerIS["SignatureImg"] as? String ?? ""
                        let catId = vmixerIS["ModuleAssessmentCatId"] as? Int ?? 0
                        let isManuallyAdded = vmixerIS["isManuallyAdded"] as? Bool ?? false
                        let imageCount = getVMixerCountInPEModule()
                        let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:imageCount + 1,name:Name,date:CertificationDateIS,isCertExpired: isCertExpired,isReCert: isReCert,vacOperatorId: vacOperatorId, signatureImg: signatureImg, fsrSign: fsrSignatureImage, isManuallyAdded: isManuallyAdded)
                        let certificateData = PECertificateData(info: certificModel)
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        CoreDataHandlerPE().saveVMixerPEModuleGet(peCertificateData: certificateData,evalutionID:peNewAssessmentInProgress.evaluationID , CategoryID: catId)
                    }
                    
                    var VaccineMicroSamplesPostingData = objDic["VaccineMicroSamplesPostingData"] as? [Any] ?? []
                    //Micro
                    for  vmixer in  VaccineMicroSamplesPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.micro  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                        
                    }
                    let VaccineResiduePostinData = objDic["VaccineResiduePostinData"] as? [Any] ?? []
                    
                    //Residue
                    for  vmixer in  VaccineResiduePostinData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.residue  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    
                    //Saving in Progress Data to Draft
                    allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                    CoreDataHandlerPE().deleteDraftByDrafyNumber(AppCreationTime ?? "")
                    let draftNumber = getDraftCountFromDb()
                    for obj in allAssesmentArr {
                        CoreDataHandlerPE().saveGetDraftDataToSyncPEInDBFromGet(newAssessment: obj as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(), dataToSubmitNumber: draftNumber + 1,param:param,formateFromServer: AppCreationTime,deviceID:DeviceId)
                    }
                    CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
                    CoreDataHandler().deleteAllData("PE_Refrigator")
                }
            }
        }
        
        self.getPostingAssessmentImagesListByUser()
    }
    // MARK: - Handle PE Posting Assessment images List API Responce
    private func handlGetPostingAssessmentImagesListByUser(_ json: JSON) {
        var dataDic : [String:Any] = [:]
        var dataArray : [Any] = []
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        dataArray = dataDic["Data"] as? [Any] ?? []
		PEQuestionsImagesData.peImagesData = dataDic["Data"] as? [[String : Any]]
        for obj in dataArray {
            DispatchQueue.main.async {
                var objDic : [String:Any] = [:]
                objDic =  obj as? [String:Any] ?? [:]
                let base64Encoded = objDic["ImageBase64"] as? String ?? ""
                let DisplayId = objDic["DisplayId"] as? String ?? ""
                let DeviceId = objDic["Device_Id"] as? String ?? ""
                let UserId = objDic["UserId"] as? Int ?? 0
                let Assessment_Id = objDic["Assessment_Id"] as? Int ?? 0
                let Module_Assessment_Categories_Id = objDic["Module_Assessment_Categories_Id"] as? Int ?? 0
                let decodedData = Data(base64Encoded: base64Encoded) ?? Data()
                let AppCreationTime = DisplayId.replacingOccurrences(of: "C-", with: "")
                let imageCount = self.getImageCountInPEModule()
                CoreDataHandlerPE().saveImageInGetApi(imageId:imageCount+1,imageData:decodedData)
                CoreDataHandlerPE().saveImageIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:AppCreationTime)
                
                CoreDataHandlerPE().saveImageDraftIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:DeviceId)
            }
        }
        let allAssesmentDraftArr = self.getAllDateArrayStoredDraft()
        if allAssesmentDraftArr.count  > 0 {
            let count = allAssesmentDraftArr.count//getDraftCountFromDb()
            self.labelDraftCount.text = String(count)
            self.showDraftCount()
            if count == 0 {
                self.hideDraftCount()
            }
        } else {
            self.labelDraftCount.text  = "0"
            self.hideDraftCount()
        }
        self.dismissGlobalHUD(self.view)
        let dontGetRejected = UserDefaults.standard.value(forKey: "dontGetRejectedAssessment") as? Bool
        if dontGetRejected ?? false{
        }
        else
        {
            getRejectedAssessmentListByUser()
        }
        
    }
    // MARK: - Handle PE Rejected Assessment List API Responce
    private func handlGetRejectedAssessmentListByUser(_ json: JSON) {
        var dataDic : [String:Any] = [:]
        var dataArray : [Any] = []
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        var count = 0
        dataArray = dataDic["Data"] as? [Any] ?? []
        if  dataArray.count  > 0 {
            self.deleteAllDataWithUserID("PE_AssessmentRejected")
        }
        for obj in dataArray {
            
            var objDic : [String:Any] = [:]
            objDic =  obj as? [String:Any] ?? [:]
            
            let SaveType = objDic["SaveType"] as? Int ?? 0
            
            count += 1
            UserDefaults.standard.setValue(count, forKey: "rejectedCountIS")
            
            let peNewAssessmentWas = PENewAssessment()
            let assessmentCommentsPostingData = objDic["AssessmentCommentsPostingData"] as? [[String:Any]] ?? []
            let assessmentScoresPostingData = objDic["AssessmentScoresPostingData"] as? [[String:Any]] ?? []
            let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
            let serverAssessmentId = objDic["AssessmentId"] as? Int ?? 0
            
            if objDic["HasChlorineStrips"] as? Int == 1{
                UserDefaults.standard.set(1, forKey: "isChlorineStrip")
                let hasChlorineStrips = true
            }else{
                UserDefaults.standard.set(0, forKey: "isChlorineStrip")
                let hasChlorineStrips = false
            }
            if objDic["IsAutomaticFail"] as? Int == 1{
                UserDefaults.standard.set(1, forKey: "isAutomaticFail")
                let isAutomaticFail = true
            }else{
                UserDefaults.standard.set(0, forKey: "isAutomaticFail")
                let isAutomaticFail = false
            }
            let sanitationEmbrexValue = objDic["SanitationEmbrex"] as? Bool ?? false
            if sanitationEmbrexValue{
                //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                
                let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                PEInfoDAO.sharedInstance.saveData(vaccineData: data)
            }
            
            let sanitationEmbrex = objDic["SanitationEmbrexScoresPostinData"] as? [[String:Any]] ?? []
            let jsonData = try? JSONSerialization.data(withJSONObject: sanitationEmbrex, options: .prettyPrinted)
            let jsonDecoder = JSONDecoder()
            if jsonData != nil{
                let dtoArr = try? jsonDecoder.decode([PESanitationDTO].self, from: jsonData!)
                if dtoArr != nil{
                    SanitationEmbrexQuestionMasterDAO.sharedInstance.saveServiceResponse(assessmentId: "\(serverAssessmentId)", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", dtoArr: dtoArr!)
                }
                
            }
            
            self.sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId:  "\(serverAssessmentId)" )
            
            UserDefaults.standard.set(String(serverAssessmentId), forKey: "currentServerAssessmentId")
            
            peNewAssessmentWas.serverAssessmentId = String(serverAssessmentId)
            let AppCreationTime = objDic["AppCreationTime"] as? String ?? ""
            peNewAssessmentWas.siteId = objDic["SiteId"] as? Int ?? 0
            peNewAssessmentWas.siteName = objDic["SiteName"] as? String ?? ""
            peNewAssessmentWas.customerId = objDic["CustomerId"] as? Int ?? 0
            peNewAssessmentWas.customerName = objDic["CustomerName"] as? String ?? ""
            peNewAssessmentWas.hatcheryAntibiotics = 0
            peNewAssessmentWas.evaluationID  = EvaluationId
            peNewAssessmentWas.isHandMix = objDic["Handmix"] as? Bool ?? false
            
            if let doubleSanitation =  objDic["DoubleSanitation"] as? Bool{
                if doubleSanitation {
                    peNewAssessmentWas.hatcheryAntibiotics = 1
                }
            }
            
            peNewAssessmentWas.userID = objDic["UserId"] as? Int ?? 0
            peNewAssessmentWas.evaluationDate = convertDateFormatter(date: objDic["EvaluationDate"] as? String ?? "")
            peNewAssessmentWas.evaluatorName = objDic["UserName"] as? String ?? ""
            peNewAssessmentWas.evaluatorID =  objDic["UserId"] as? Int ?? 0
            peNewAssessmentWas.evaluationName = objDic["EvaluationName"] as? String ?? ""
            peNewAssessmentWas.evaluationID = objDic["EvaluationId"] as? Int ?? 0
            peNewAssessmentWas.incubation = objDic["IncubationStyleName"] as? String ?? ""
            peNewAssessmentWas.breedOfBird = objDic["BreedBirdsName"] as? String ?? ""
            peNewAssessmentWas.statusType = objDic["Status_Type"] as? Int ?? 0
            peNewAssessmentWas.breedOfBirdOther = objDic["BreedOfBirdsOther"] as? String ?? ""
            peNewAssessmentWas.dataToSubmitID = objDic["AppCreationTime"] as? String ?? ""
            peNewAssessmentWas.manufacturer = objDic["ManufacturerName"] as? String ?? ""
            peNewAssessmentWas.rejectionComment = objDic["RejectionComments"] as? String ?? ""
            peNewAssessmentWas.visitID = objDic["VisitId"] as? Int ?? 0
            peNewAssessmentWas.visitName =  objDic["VisitName"] as? String ?? ""
            peNewAssessmentWas.selectedTSRID = objDic["TSRId"] as? Int ?? 0
            peNewAssessmentWas.countryName = objDic["CountryName"] as? String ?? ""
            peNewAssessmentWas.countryID = objDic["CountryId"] as? Int ?? 0
            peNewAssessmentWas.clorineName = objDic["ChlorineText"] as? String ?? ""
            peNewAssessmentWas.clorineId = objDic["ChlorineId"] as? Int ?? 0
            peNewAssessmentWas.fluid = objDic["IsInovoFluids"] as? Bool ?? false
            peNewAssessmentWas.basicTransfer = objDic["IsBasicTrfAssessment"] as? Bool ?? false
            peNewAssessmentWas.extndMicro = objDic["IsInterMicrobial"] as? Bool ?? false
            peNewAssessmentWas.refrigeratorNote = objDic["RefrigeratorNote"] as? String ?? ""
            peNewAssessmentWas.IsEMRequested = objDic["IsEMRequested"] as? Bool ?? false
            peNewAssessmentWas.emRejectedComment = objDic["EMRejectedComment"] as? String ?? ""
            peNewAssessmentWas.isPERejected = objDic["IsPERejected"] as? Bool ?? false
            peNewAssessmentWas.isEMRejected = objDic["IsEMRejected"] as? Bool ?? false
            peNewAssessmentWas.sanitationValue = objDic["SanitationEmbrex"] as? Bool ?? false
            
            let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
            let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
            let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
            if  peNewAssessmentWas.selectedTSRID != 0 {
                if visitIDArray.contains( peNewAssessmentWas.selectedTSRID as Any){
                    let indexOfe =  visitIDArray.index(of: peNewAssessmentWas.selectedTSRID as Any)
                    let TSRName = visitNameArray[indexOfe] as? String ?? ""
                    peNewAssessmentWas.selectedTSR =  TSRName
                }
            }
            
            let manuOthers = objDic["ManufacturerOther"] as? String ?? ""
            if manuOthers != "" {
                peNewAssessmentWas.manufacturer = "S" + manuOthers
            }
            let eggStr = objDic["EggsPerFlatName"] as? String ?? "0"
            peNewAssessmentWas.noOfEggs = Int64(eggStr)
            let eggsOthers = objDic["EggsPerFlatOther"]  as? String ?? ""
            if eggsOthers != "" {
                let txt = eggsOthers
                let str =   txt  + "000"
                let iii = Int64(str)
                if  iii != nil{
                    peNewAssessmentWas.noOfEggs = iii!
                }
            }
            let f = objDic["FlockAgeId"] as? Int ?? 0
            peNewAssessmentWas.isFlopSelected =  f
            let Camera =  objDic["Camera"]  as? Bool ?? false
            if  Camera == true {
                peNewAssessmentWas.camera = 1
            } else {
                peNewAssessmentWas.camera = 0
            }
            peNewAssessmentWas.notes = objDic["Notes"] as? String ?? ""
            let strBase64Signatture =  objDic["SignatureImage"] as? String ?? ""
            let representaiveName =  objDic["RepresentativeName"] as? String ?? ""
            let RoleName =  objDic["RoleName"] as? String ?? ""
            let imageData : Data? = Data(base64Encoded: strBase64Signatture, options: .ignoreUnknownCharacters)
            
            let strBase64Signatture2 =  objDic["SignatureImage2"] as? String ?? ""
            let representaiveName2 =  objDic["RepresentativeName2"] as? String ?? ""
            let RoleName2 =  objDic["RoleName2"] as? String ?? ""
            let fsrSignatureImage = objDic["FSTSignatureImage"] as? String ?? ""
            peNewAssessmentWas.FSTSignatureImage = fsrSignatureImage
            
            let imageData2 : Data = Data(base64Encoded: strBase64Signatture2, options: .ignoreUnknownCharacters) ?? Data()
            let representaiveNotes =  objDic["RepresentativeNotes"] as? String ?? ""
            let SignatureDate =  objDic["SignatureDate"] as? String ?? ""
            let id = self.saveImageInPEModule(imageData: imageData ?? Data())
            let id2 = self.saveImageInPEModule(imageData: imageData2)
            var sigDate = ""
            if SignatureDate != "" {
                sigDate = self.convertDateFormat(inputDate: SignatureDate)
            } else {
                sigDate = Date().stringFormat(format: "MMM d, yyyy")
            }
            let param : [String:String] = ["sig":String(id),"sig2":String(id2),"sig_Date":sigDate ,"sig_EmpID":RoleName,"sig_Name":representaiveName ,"sig_EmpID2":RoleName2,"sig_Name2":representaiveName2 ,"sig_Phone":representaiveNotes ]
            jsonRe = (getJSON("QuestionAns") ?? JSON())
            pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
            
            var peCategoryFilteredArray: [PECategory] =  []
            for object in pECategoriesAssesmentsResponse.peCategoryArray{
                if peNewAssessmentWas.evaluationID == object.evaluationID{
                    if object.id != 36{
                        peCategoryFilteredArray.append(object)
                    }
                }
            }
            
            let questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
            let infoImageDataResponse = InfoImageDataResponse(questionInfo)
            let categoryCount = filterCategoryCount(peNewAssessmentOf: peNewAssessmentWas)
            var peNewAssessmentNew = PENewAssessment()
            if peCategoryFilteredArray.count > 0 {
                for  cat in  peCategoryFilteredArray {
                    for (index, ass) in cat.assessmentQuestions.enumerated(){
                        
                        peNewAssessmentNew = peNewAssessmentWas
                        peNewAssessmentNew.serverAssessmentId = peNewAssessmentWas.serverAssessmentId
                        peNewAssessmentNew.cID = index
                        peNewAssessmentNew.catID = cat.id
                        peNewAssessmentNew.catName = cat.categoryName
                        peNewAssessmentNew.catMaxMark = cat.maxMark
                        peNewAssessmentNew.sequenceNo = cat.id
                        peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                        peNewAssessmentNew.catResultMark = cat.maxMark
                        peNewAssessmentNew.catEvaluationID = cat.evaluationID
                        peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                        peNewAssessmentNew.assID = ass.id
                        peNewAssessmentNew.assDetail1 = ass.assessment
                        peNewAssessmentNew.evaluationID = cat.evaluationID
                        peNewAssessmentNew.assDetail2 = ass.assessment2
                        peNewAssessmentNew.assMinScore = ass.minScore
                        peNewAssessmentNew.assMaxScore = ass.maxScore
                        peNewAssessmentNew.assCatType = ass.cateType
                        peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                        peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                        peNewAssessmentNew.assStatus = 1
                        peNewAssessmentNew.isChlorineStrip = objDic["HasChlorineStrips"] as? Int ?? 0
                        peNewAssessmentNew.isAutomaticFail = objDic["IsAutomaticFail"] as? Int ?? 0
                        peNewAssessmentNew.manufacturer = peNewAssessmentWas.manufacturer
                        peNewAssessmentNew.noOfEggs = peNewAssessmentWas.noOfEggs
                        peNewAssessmentNew.informationImage = ass.informationImage
                        peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                        peNewAssessmentNew.isAllowNA = ass.isAllowNA
                        peNewAssessmentNew.isNA = ass.isNA
                        peNewAssessmentNew.rollOut = ass.rollOut
                        peNewAssessmentNew.qSeqNo = ass.qSeqNo
                        CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                    }
                }
                
                var allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                
                var filterScoreData : [[String:Any]] = [[:]]
                var isNaSelectedArray : [[String:Any]] = [[:]]
                for questionMark in assessmentScoresPostingData {
                    let AssessmentScore = questionMark["AssessmentScore"] as? Int ?? 0
                    let QCCount = questionMark["QCCount"] as? String ?? ""
                    let FrequencyValue = questionMark["FrequencyValue"] as? Int ?? 32
                    var FrequencyValueStr = ""
                    let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
                    let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
                    let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
                    if FrequencyValue != 32 {
                        if visitIDArray.contains(FrequencyValue){
                            let indexOfe =  visitIDArray.index(of: FrequencyValue) //
                            FrequencyValueStr = visitNameArray[indexOfe] as? String ?? ""
                        }
                    }
                    let isNAValue = questionMark["IsNA"] as? Bool ?? false
                    let TextAmPm = questionMark["TextAmPm"] as? String ?? ""
                    let PersonName = questionMark["PersonName"] as? String ?? ""
                    let PPMValue = questionMark["Chlorine_Value"] as? String ?? ""
                    
                    if FrequencyValueStr.count > 0 {
                        CoreDataHandlerPE().updateFrequencyInAssessmentInProgress(frequency:FrequencyValueStr)
                    }
                    if QCCount.count > 0 {
                        CoreDataHandlerPE().updateQCCountInAssessmentInProgress(qcCount:QCCount)
                    }
                    if PersonName.count > 0 {
                        CoreDataHandlerPE().updatePersonNameInAssessmentInProgress(personName: PersonName)
                    }
                    if TextAmPm.count > 0 {
                        CoreDataHandlerPE().updateAMPMInAssessmentInProgress(ampmValue: TextAmPm)
                    }
                    if PPMValue.count > 0 {
                        CoreDataHandlerPE().updatePPMValueInAssessmentInProgress(PpmValue: PPMValue)
                    }
                    if (AssessmentScore  ==  0) || (isNAValue) {
                        filterScoreData.append(questionMark)
                    }
                    if isNAValue{
                        isNaSelectedArray.append(questionMark)
                    }
                }
                var assArray : [Int] = []
                for cat in filterScoreData {
                    let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                    assArray.append(assID)
                }
                
                var naArray : [Int] = []
                for cat in isNaSelectedArray {
                    let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                    naArray.append(assID)
                }
                
                for qMark in allAssesmentArr {
                    let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                    for assID in naArray {
                        
                        if (Int(truncating: objMark.assID ?? 0) == assID ) {
                            var totalMark = GetLatestTotalMarkOfAss(assID: objMark.assID as? Int ?? 0)
                            let catISSelected = 0
                            let maxMarks =  objMark.assMaxScore ?? 0
                            let reMark = Int(totalMark) - Int(truncating: maxMarks)
                            totalMark = Int(truncating: NSNumber(value: reMark))
                            CoreDataHandlerPE().updateChangeInTotalAnsInProgressTable(catISSelected:catISSelected,catMaxMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                        }
                    }
                }
                
                for qMark in allAssesmentArr {
                    let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                    for assID in assArray {
                        
                        if ( Int(truncating: objMark.assID ?? 0) == assID ) {
                            var totalMark = GetLatestMarkOfAss(assID: objMark.assID as? Int ?? 0)
                            let catISSelected = 0
                            let maxMarks =  objMark.assMaxScore ?? 0
                            let reMark = Int(totalMark) - Int(truncating: maxMarks)
                            totalMark = Int(truncating: NSNumber(value: reMark))
                            CoreDataHandlerPE().updateChangeInAnsInProgressTable(catISSelected:catISSelected,catResultMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                        }
                    }
                }
                
                var assNAArray : [[String:Any]] = [[:]]
                for cat in assessmentScoresPostingData {
                    let isNA = cat["IsNA"] as? Bool ?? false
                    if(isNA){
                        assNAArray.append(cat)
                    }
                }
                
                for qMark in allAssesmentArr {
                    let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                    for assID in assNAArray {
                        let assIsNA = assID["IsNA"] as? Bool ?? false
                        let AssessmentId = assID["ModuleAssessmentId"] as? Int ?? 0
                        
                        if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                            CoreDataHandlerPE().update_isNAInAssessmentInProgress(isNA: true, assID: Int(objMark.assID ?? 0))
                        }
                    }
                }
                
                //score ends
                //comment start
                var filterCommentData : [[String:Any]] = [[:]]
                for questionMark in assessmentCommentsPostingData {
                    let AssessmentComment = questionMark["AssessmentComment"] as? String ?? ""
                    if AssessmentComment.count > 0  {
                        filterCommentData.append(questionMark)
                    }
                }
                for qMark in allAssesmentArr {
                    let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                    for assID in filterCommentData {
                        let AssessmentComment = assID["AssessmentComment"] as? String ?? ""
                        let AssessmentId = assID["AssessmentId"] as? Int ?? 0
                        if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                            CoreDataHandlerPE().updateNoteInProgressTable(assID:Int(truncating: objMark.assID ?? 0),text:AssessmentComment)
                        }
                    }
                }
                //comment ends
                let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                let InovojectPostingData = objDic["InovojectPostingData"] as? [Any] ?? []
                let VaccineMixerObservedPostingData = objDic["VaccineMixerObservedPostingData"] as? [Any] ?? []
                
                // INOVOJECT
                for inoDic in InovojectPostingData {
                    
                    let inoDicIS = inoDic as? [String:Any] ?? [:]
                    let Dosage = inoDicIS["Dosage"] as? String ?? ""
                    let otherString = inoDicIS["OtherText"] as? String ?? ""
                    let VaccineId = inoDicIS["VaccineId"] as? Int ?? 0
                    let AmpuleSize = inoDicIS["AmpuleSize"] as? Int ?? 0
                    var AmpuleSizeStr = ""
                    let AntibioticInformation =  inoDicIS["AntibioticInformation"] as? String ?? ""
                    var ampleSizeesNameArray = NSArray()
                    var ampleSizeIDArray = NSArray()
                    var ampleSizeDetailArray = NSArray()
                    ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                    ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                    ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                    if AmpuleSize != 0 {
                        let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                        AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                    }
                    let AmpulePerbag = inoDicIS["AmpulePerbag"] as? Int ?? 0
                    let HatcheryAntibiotics =  inoDicIS["HatcheryAntibiotics"] as? Bool ?? false
                    let ManufacturerId = inoDicIS["ManufacturerId"] as? Int ?? 0
                    let BagSizeType = inoDicIS["BagSizeType"] as? String ?? ""
                    let DiluentMfg = inoDicIS["DiluentMfg"] as? String ?? ""
                    var VManufacturerName = ""
                    var VName = ""
                    let ProgramName = inoDicIS["ProgramName"] as? String ?? ""
                    let DiluentsMfgOtherName = inoDicIS["DiluentsMfgOtherName"] as? String ?? ""
                    
                 
                    var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                    var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                    var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    
                    var vNameArray = NSArray()
                    var vIDArray = NSArray()
                    var vDetailsArray = NSArray()
                    vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                    vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                    vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    let xxxx =    VaccineId
                    if xxxx != 0 {
                        if vIDArray.contains(xxxx){
                            let indexOfd = vIDArray.index(of: xxxx)
                            VName = vNameArray[indexOfd] as? String ?? ""
                        }
                    }  else {
                        VName = otherString
                    }
                    
                    if otherString != "" {
                        VName = otherString
                    }
                    
                    let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    
                    var HatcheryAntibioticsIntVal = 0
                    if HatcheryAntibiotics == true{
                        HatcheryAntibioticsIntVal = 1
                    } else {
                        HatcheryAntibioticsIntVal = 0
                    }
                    
                    peNewAssessmentInProgress.iCS  = inoDicIS["BagSizeType"] as? String ?? ""
                    let diluentMfg  = inoDicIS["DiluentMfg"] as? String ?? ""
                    peNewAssessmentInProgress.iDT = diluentMfg
                    peNewAssessmentInProgress.micro  = ""
                    peNewAssessmentInProgress.residue = ""
                    CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromInvo: true)
                    
                    let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                    let inovojectData = InovojectData(info: info)
                    
                    let id = self.saveInovojectInPEModule(inovojectData: inovojectData, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                    inovojectData.id = id
                }
                
                let DayPostingData = objDic["DayOfAgePostingData"] as? [Any] ?? []
                //Day OF AGE
                for inoDic in DayPostingData {
                    
                    let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                    let Dosage = DayOfAgeIS["DayOfAgeDosage"] as? String ?? ""
                    let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                    let VaccineId = DayOfAgeIS["DayOfAgeMfgNameId"] as? Int ?? 0
                    let AmpuleSize = DayOfAgeIS["DayOfAgeAmpuleSize"] as? Int ?? 0
                    var AmpuleSizeStr = ""
                    var ampleSizeesNameArray = NSArray()
                    var ampleSizeIDArray = NSArray()
                    var ampleSizeDetailArray = NSArray()
                    ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                    ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                    ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                    if AmpuleSize != 0 {
                        let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                        AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                    }
                    
                    let AmpulePerbag = DayOfAgeIS["DayOfAgeAmpulePerbag"] as? Int ?? 0
                    let HatcheryAntibiotics =  DayOfAgeIS["DayOfBagHatcheryAntibiotics"] as? Bool ?? false
                    let ManufacturerId = DayOfAgeIS["DayOfAgeMfgId"] as? Int ?? 0
                    let BagSizeType = DayOfAgeIS["DayOfAgeBagSizeType"] as? String ?? ""
                    let DiluentMfg = DayOfAgeIS["DiluentMfg"] as? String ?? ""
                    var VManufacturerName = ""
                    var VName = ""
                    var vManufacutrerNameArray = NSArray()
                    var vManufacutrerIDArray = NSArray()
                    var vManufacutrerDetailsArray = NSArray()
                    vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                    vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                    vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    let xxx =    ManufacturerId
                    if xxx != 0 {
                        
                        let indexOfd = vManufacutrerIDArray.index(of: xxx)
                        if vManufacutrerNameArray.count > indexOfd{
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                        }
                    }
                    var vNameArray = NSArray()
                    var vIDArray = NSArray()
                    var vDetailsArray = NSArray()
                    vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                    vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
                    vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                    vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    let xxxx =    VaccineId
                    if xxxx != 0 {
                        if vIDArray.contains(xxxx){
                            let indexOfd = vIDArray.index(of: xxxx)
                            VName = vNameArray[indexOfd] as? String ?? ""
                        }
                    }else {
                        if VManufacturerName.lowercased().contains("other"){
                            VName  = otherText
                            
                        }
                    }
                    if otherText != "" {
                        VName = otherText
                    }
                    
                    let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                    let DayOfAgeDataNew = InovojectData(info: info)
                    
                    peNewAssessmentInProgress.dCS  = DiluentMfg
                    peNewAssessmentInProgress.dDT = BagSizeType
                    peNewAssessmentInProgress.micro  = ""
                    peNewAssessmentInProgress.residue = ""
                    if HatcheryAntibiotics == true{
                        peNewAssessmentInProgress.hatcheryAntibioticsDoa = 1
                    } else{
                        peNewAssessmentInProgress.hatcheryAntibioticsDoa = 0
                    }
                    let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                    peNewAssessmentInProgress.hatcheryAntibioticsDoaText = AntibioticInformation
                    let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                    
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                    CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoa : true)
                    let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                    DayOfAgeDataNew.id = id
                }
                
                let DayAgeSubcutaneousDetailsPostingData = objDic["DayAgeSubcutaneousDetailsPostingData"] as? [Any] ?? []
                
                for inoDic in DayAgeSubcutaneousDetailsPostingData {
                    
                    let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                    let Dosage = DayOfAgeIS["DayAgeSubcutaneousDosage"] as? String ?? ""
                    let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                    let VaccineId = DayOfAgeIS["DayAgeSubcutaneousMfgNameId"] as? Int ?? 0
                    let AmpuleSize = DayOfAgeIS["DayAgeSubcutaneousAmpuleSize"] as? Int ?? 0
                    var AmpuleSizeStr = ""
                    var ampleSizeesNameArray = NSArray()
                    var ampleSizeIDArray = NSArray()
                    var ampleSizeDetailArray = NSArray()
                    ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                    ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                    ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                    if AmpuleSize != 0 {
                        let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                        AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                    }
                    let AmpulePerbag = DayOfAgeIS["DayAgeSubcutaneousAmpulePerbag"] as? Int ?? 0
                    let HatcheryAntibiotics =  DayOfAgeIS["DayAgeSubcutaneousHatcheryAntibiotics"] as? Bool ?? false
                    let ManufacturerId = DayOfAgeIS["DayAgeSubcutaneousMfgId"] as? Int ?? 0
                    let BagSizeType = DayOfAgeIS["DayAgeSubcutaneousBagSizeType"] as? String ?? ""
                    let DiluentMfg = DayOfAgeIS["DayAgeSubcutaneousDiluentMfg"] as? String ?? ""
                    var VManufacturerName = ""
                    var VName = ""
                    var vManufacutrerNameArray = NSArray()
                    var vManufacutrerIDArray = NSArray()
                    var vManufacutrerDetailsArray = NSArray()
                    vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                    vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                    vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    let xxx =    ManufacturerId
                    if xxx != 0 {
                        let indexOfd = vManufacutrerIDArray.index(of: xxx)
                        if vManufacutrerNameArray.count > indexOfd{
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                        }
                    }
                    var vNameArray = NSArray()
                    var vIDArray = NSArray()
                    var vDetailsArray = NSArray()
                    vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
                    vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                    vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                    let xxxx =    VaccineId
                    if xxxx != 0 {
                        if vIDArray.contains(xxxx){
                            let indexOfd = vIDArray.index(of: xxxx)
                            VName = vNameArray[indexOfd] as? String ?? ""
                        }
                    } else {
                        if VManufacturerName.lowercased().contains("other"){
                            VName  = otherText
                        }
                    }
                    if otherText != "" {
                        VName = otherText
                    }
                    
                    let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                    
                    let DayOfAgeDataNew = InovojectData(info: info)
                    peNewAssessmentInProgress.dDCS  = DiluentMfg
                    peNewAssessmentInProgress.dDDT = BagSizeType
                    peNewAssessmentInProgress.micro  = ""
                    peNewAssessmentInProgress.residue = ""
                    if HatcheryAntibiotics == true{
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 1
                    } else {
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 0
                    }
                    let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                    peNewAssessmentInProgress.hatcheryAntibioticsDoaSText = AntibioticInformation
                    let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                    
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                    CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoaS : true)
                    let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(),fromDoaS: true)
                    DayOfAgeDataNew.id = id
                }
                
                //VMIXER
                for  vmixer in  VaccineMixerObservedPostingData{
                    let vmixerIS = vmixer as? [String:Any] ?? [:]
                    let Name = vmixerIS["Name"] as? String ?? ""
                    var CertificationDate = vmixerIS["CertificationDate"] as? String ?? ""
                    var CertificationDateIS = ""
                    if CertificationDate != "" {
                        CertificationDate =  CertificationDate.replacingOccurrences(of: "T", with: "")
                        CertificationDate =  CertificationDate.replacingOccurrences(of: "00", with: "")
                        CertificationDate = CertificationDate.replacingOccurrences(of: ":", with: "")
                        let array = CertificationDate.components(separatedBy: "-")
                        let date = array[2]
                        let month = array[1]
                        let year = array[0]
                        
                        if regionID == 3
                        {
                            CertificationDateIS = month + "-" +  date + "-" +  year
                        }
                        else
                        {
                            CertificationDateIS = date + "-" +  month + "-" +  year
                        }
                        
                    }
                    let isCertExpired = vmixerIS["IsCertiExpired"] as? Bool ?? false
                    let isReCert = vmixerIS["IsReCert"] as? Bool ?? false
                    let vacOperatorId = vmixerIS["vacOperatorId"] as? Int ?? 0
                    let signatureImg = vmixerIS["SignatureImg"] as? String ?? ""
                    let catId = vmixerIS["ModuleAssessmentCatId"] as? Int ?? 0
                    let isManuallyAdded = vmixerIS["isManuallyAdded"] as? Bool ?? false

                    let imageCount = getVMixerCountInPEModule()
                    let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:imageCount + 1,name:Name,date:CertificationDateIS,isCertExpired: isCertExpired,isReCert: isReCert,vacOperatorId: vacOperatorId, signatureImg: signatureImg, fsrSign: fsrSignatureImage, isManuallyAdded: isManuallyAdded)
                    let certificateData = PECertificateData(info: certificModel)
                    
                    let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    CoreDataHandlerPE().saveVMixerPEModuleGet(peCertificateData: certificateData,evalutionID:peNewAssessmentInProgress.evaluationID , CategoryID: catId)
                }
                let VaccineMicroSamplesPostingData = objDic["VaccineMicroSamplesPostingData"] as? [Any] ?? []
                //Micro
                for  vmixer in  VaccineMicroSamplesPostingData{
                    let vmixerIS = vmixer as? [String:Any] ?? [:]
                    let Name = vmixerIS["Name"] as? String ?? ""
                    let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    peNewAssessmentInProgress.micro  = Name
                    CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                }
                let VaccineResiduePostinData = objDic["VaccineResiduePostinData"] as? [Any] ?? []
                //Residue
                for  vmixer in  VaccineResiduePostinData{
                    let vmixerIS = vmixer as? [String:Any] ?? [:]
                    let Name = vmixerIS["Name"] as? String ?? ""
                    let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                    peNewAssessmentInProgress.residue  = Name
                    CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                }
                let dataToSubmitNumber = self.getAssessmentInOfflineFromDb()
                for obj in allAssesmentArr {
                    CoreDataHandlerPE().saveDataToRejectedSyncPEInDBFromGet(newAssessment: obj as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(), dataToSubmitNumber: dataToSubmitNumber + 1,param:param,formateFromServer: AppCreationTime, rejectionComment: peNewAssessmentWas.rejectionComment ?? "")
                }
                
                // save Reject Refrigator
                let refriPostingData = objDic["RefrigeratorPostingData"] as? [Any] ?? []
                for refriDic in refriPostingData {
                    let RefriData = refriDic as? [String:Any] ?? [:]
                    let assessmentId = RefriData["AssessmentId"] as? Int ?? 0
                    let assessmentDetailId = RefriData["AssessmentDetailId"] as? Int ?? 0
                    let refValue = RefriData["RefValue"] as? Double ?? 0.0
                    let isNa = RefriData["IsNa"] as? Bool ?? false
                    let isCheck = RefriData["IsCheck"] as? Bool ?? false
                    let refUnit = RefriData["RefUnit"] as? String ?? ""
                    let fridgeData = CoreDataHandlerPEModels.offlineRefrigatorData(id: (assessmentId ?? 0) as NSNumber,  labelText: "", rollOut: "Y", unit:  refUnit, value: refValue ?? 0.0,catID: 11 ,isCheck: isCheck ?? false,isNA: isNa ?? false,schAssmentId: assessmentDetailId ?? 0)
                    CoreDataHandlerPE().saveOfflineRefrigatorInDB(fridgeData)
                }
                
                CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
                CoreDataHandler().deleteAllData("PE_Refrigator")
            }
        }
        
        UserDefaults.standard.setValue(count, forKey: "rejectedCountIS")
        UserDefaults.standard.synchronize()
        if count  > 0 {
            rejectedListCount.text = String(count)
            showRejectedCount()
            if count == 0 {
                hideRejectedCount()
            }
        } else {
            rejectedListCount.text  = "0"
            hideRejectedCount()
        }
        getScheduledAssessments()
    }
}

extension PEDashboardViewController {
    func createJsonToExport(indexTapped:Int) {
        
        var extendedMicroArr : [JSONDictionary]  = []
        var inovojectDataArr : [JSONDictionary]  = []
        var dayOfAgeDataArr : [JSONDictionary]  = []
        var dayOfAgeSDataArr : [JSONDictionary]  = []
        var certificateDataArr : [JSONDictionary]  = []
        var vaccineMicroSamplesDataArr : [JSONDictionary]  = []
        var vaccineResidueMoldsDataArr : [JSONDictionary]  = []
        var refrigratorDataArr : [JSONDictionary]  = []
        if peAssessmentSyncArray.count > 0 {
            let obj = self.peAssessmentSyncArray[indexTapped]
            
            //            if self.isSync == false{
            //                self.isSync = true
            self.assessID = Int(obj.serverAssessmentId ?? "")
            self.objAssessment = obj
            //                self.checkDataDuplicacy(obj: obj)
            var arrIDs = [NSNumber]()
            // region 3 means US & Canada
            if  self.regionID  != 3 {
                refrigratorDataArr.removeAll()
                let refriArray = CoreDataHandlerPE().getREfriData(id: self.assessID ?? 0)
                if refriArray.count > 1 {
                    arrIDs.removeAll()
                    for objn in  refriArray {
                        if !arrIDs.contains(objn.id!) {
                            arrIDs.append(objn.id!)
                            let data = self.createSyncRequestRefrigator(dictArray: objn)
                            refrigratorDataArr.append(data)
                        }
                    }
                }
            }
            
            self.dayOfAgeSData.removeAll()
            if obj.doaS.count > 0 {
                var idArr : [Int] = []
                for objn in  obj.doaS {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                self.dayOfAgeSData.append(data!)
                            }
                        }
                    }
                }
            }
            
            self.dayOfAgeData.removeAll()
            if obj.doa.count > 0 {
                var idArr : [Int] = []
                for objn in  obj.doa {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                            
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                self.dayOfAgeData.append(data!)
                            }
                        }
                    }
                }
            }
            
            self.inovojectData.removeAll()
            if obj.inovoject.count > 0 {
                var idArr : [Int] = []
                for objn in  obj.inovoject {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                self.inovojectData.append(data!)
                            }
                        }
                    }
                }
            }
            
            self.certificateData.removeAll()
            if obj.vMixer.count > 0 {
                var idArr : [Int] = []
                for objn in  obj.vMixer {
                    let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
                    if idArr.contains(data!.id ?? 0){
                        
                    }else{
                        idArr.append(data!.id ?? 0)
                        if data != nil{
                            self.certificateData.append(data!)
                        }
                    }
                }
            }
            self.tempArr.removeAll()
            
            if obj.extndMicro == false
            {
                HaveToCallExtendedMicro = false
            }
            else{
                HaveToCallExtendedMicro = true
            }
            
            let json = self.createSyncRequest(dict: obj , certificationData : self.certificateData )
            tempArr.append(json)
            
            if self.inovojectData.count > 0 {
                for item in self.inovojectData {
                    let json = self.createSyncRequestForInvoject(dictArray: obj, inovojectData: item)
                    inovojectDataArr.append(json)
                    
                }
            }
            if self.dayOfAgeData.count > 0 {
                for item in self.dayOfAgeData {
                    let json = self.createSyncRequestForDOA(dictArray: obj, dayOfAgeData: item)
                    dayOfAgeDataArr.append(json)
                    
                }
            }
            if self.dayOfAgeSData.count > 0 {
                for item in self.dayOfAgeSData {
                    let json = self.createSyncRequestForDOAS(dictArray: obj, dayOfAgeData: item)
                    dayOfAgeSDataArr.append(json)
                    
                }
            }
            if self.certificateData.count > 0 {
                for item in self.certificateData {
                    let json = self.createSyncRequestForCertificateData(dictArray: obj, peCertificateData: item)
                    certificateDataArr.append(json)
                }
            }
            if obj.evaluationID == 2 {
                let json = self.createSyncRequestForResidueData(dictArray: obj)
                vaccineResidueMoldsDataArr.append(json)
            }
            if obj.evaluationID == 2 {
                let json = self.createSyncRequestForMicroData(dictArray: obj)
                vaccineMicroSamplesDataArr.append(json)
            }
            
            var AssessmentId = self.objAssessment.dataToSubmitNumber ?? 0
            if AssessmentId == 0 {
                AssessmentId = self.objAssessment.draftNumber ?? 0
            }
            
            var paramForDoaInnovoject = JSONDictionary()
            
            if( self.regionID  != 3 ){
                paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr,"RefrigeratorData":refrigratorDataArr,"DeviceId": self.deviceIDFORSERVER, "AssessmentDetailsId" :AssessmentId] as JSONDictionary
            } else {
                paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr, "DeviceId": self.deviceIDFORSERVER, "AssessmentDetailsId" :AssessmentId] as JSONDictionary
            }
            
            var idArr = [String]()
            for val in tempArr{
                let id = val["AssessmentId"] as? Int64 ?? 0
                if id != 0{
                    idArr.append("\(id)")
                }
            }
            
            let param = ["AssessmentData":tempArr,"appVersion":Bundle.main.versionNumber,"IsSendEmail":"true"] as JSONDictionary
            var mergedDict = param
            for (key, value) in paramForDoaInnovoject {
                mergedDict[key] = value
            }
            
            if obj.isEMRejected == true && obj.isPERejected == false {
                let emData = exportExtendedmicrobialData(saveType: 1, statusType: 0, index: indexTapped)
                
                if let extendedMicData = emData {
                    for (key, value) in extendedMicData {
                        mergedDict[key] = value
                    }
                }
            }
            var assessmentIdStr: String?
            if tempArr.count > 0,
               let assId = tempArr[0]["AssessmentId"] {
                assessmentIdStr = "\(Int(assId as? Int64 ?? 0))"
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: mergedDict, options: [])
                if let status = EmailReportManager.shared.sendEmailReport(dataToAttach: jsonData, from: self,assessmentId: assessmentIdStr,date: nil,isPE: true), !status.0 {
                    if let filePath = status.1 {
                        print(filePath)
                    }
                }
            } catch {
                showAlert(title: "Error", message: "Failed to convert data to JSON.", owner: self)
            }
        }
    }
}

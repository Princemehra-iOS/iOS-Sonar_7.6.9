//
//  VaccinationDashboardVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 31/03/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit
import Reachability
import Gigya
import GigyaTfa
import GigyaAuth
import SwiftyJSON
import CoreData

class VaccinationDashboardVC: BaseViewController{
    // MARK: - Outlets
    
    @IBOutlet weak var notificationCountBackgroundImg: UIImageView!
    @IBOutlet weak var dratCountBackgroundImg: UIImageView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    @IBOutlet weak var draftCountLbl: UILabel!
    @IBOutlet weak var operatorCertVw: UIView!
    @IBOutlet weak var operatorCertImgVw: UIImageView!
    @IBOutlet weak var operatorCertLbl: UILabel!
    @IBOutlet weak var operatorCertBtn: UIButton!
    @IBOutlet weak var safeyCertVw: UIView!
    @IBOutlet weak var safetyCertImgVw: UIImageView!
    @IBOutlet weak var safetyCertLbl: UILabel!
    @IBOutlet weak var safetyCertBtn: UIButton!
    @IBOutlet weak var viewTrainingVw: UIView!
    @IBOutlet weak var viewTrainingImgVw: UIImageView!
    @IBOutlet weak var viewTrainingLbl: UILabel!
    @IBOutlet weak var viewTrainingBtn: UIButton!
    @IBOutlet weak var draftVw: UIView!
    @IBOutlet weak var draftBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var tableHeaderVw: UIView!
    @IBOutlet weak var upcomingCertificationsVw: UIView!
    @IBOutlet weak var headerContainerVw: UIView!
    @IBOutlet weak var certificationsTblVw: UITableView!
    @IBOutlet weak var popupBackgroundVw: UIView!
    @IBOutlet weak var popupVw: UIView!
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupHeaderVw: UIView!
    @IBOutlet weak var popupSectionHeaderVw: UIView!
    @IBOutlet weak var popupTblVw: UITableView!
    @IBOutlet weak var titleVw: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var sectonHeaderVw: UIView!
    
    // MARK: - VARIABLES
    
    var vaccinationHeaderView: VaccinationHeaderContainerVC!
    let operationQueue = OperationQueue()
    var upcomingCertificationsArr = [VaccinationCertificationVM]()
    var hasDataLoaded = false
    var navigate = true
    var hasViewLoaded = false
    let submitOperationQueue = OperationQueue()
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    // MARK: - VIEW LIFE CYCLE
    var apiRequestTimer:Timer?
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        setupHeaderView()
        setupUI()
        addOperations()
        registerTblVwCells()
        loadPopupUI()
        hidePopup()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCertifications), name: NSNotification.Name.init(rawValue: "RefreshCertifications") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(submitCertifications), name: NSNotification.Name.init(rawValue: "SubmitVaccinationCertifications") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ClearSafetyCertifications), name: NSNotification.Name.init(rawValue: "ClearSafetyCertifications") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutClicked), name: NSNotification.Name.init(rawValue: "TraningSyncDataNoti") , object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("VaccinationDashboardVC", forKey: "ViewCertificationsVC")
        if ConnectionManager.shared.hasConnectivity() {
            if hasViewLoaded{
                self.showGlobalProgressHUDWithTitle(self.view, title: "Fetching Scheduled Certifications")
                self.getScheduledCertifications()
            } else {
                self.showPopup()
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
        }
        hasViewLoaded = true
        hidePopup()
        showCount()
//            self.showPopup()

        self.apiRequestTimer?.invalidate()
        self.apiRequestTimer = nil
        apiRequestTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            print("Training Cert - ActiveRequests Count: ",APIActivityTracker.shared.activeRequestCount)
            if APIActivityTracker.shared.activeRequestCount == 0 {
                appDelegateObj.hideAllHUDs()
                self.apiRequestTimer?.invalidate()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for operation in operationQueue.operations.reversed(){
            operation.cancel()
        }
        operationQueue.cancelAllOperations()
    }
    
    // MARK: - OBJC SELECTORS
    @objc func ClearSafetyCertifications(){
        VaccinationDashboardDAO.sharedInstance.deleteStartedCertObjByCategory(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationCategoryId: VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID)
        setupHeaderView()
    }
    
    @objc func submitCertifications() {
        if ConnectionManager.shared.hasConnectivity() {
            submitOperationQueue.maxConcurrentOperationCount = 1
            let certifications = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(
                userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                status: .submitted,
                syncStatus: .synced
            )
            
            if certifications.count > 0 {
                self.showGlobalProgressHUDWithTitle(self.view, title: "Data syncing..")
            } else {
                let errorMSg = "Data not available for sync"
                let alertController = UIAlertController(title: "No data available", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            // Processing each certification sequentially
            for (index, certification) in certifications.enumerated() {
				var tempCert = certification
				var approverId: Int?
                var cstmrId: Int?
                var cstmName: String?
                var siteId: String?
                var SiteName: String?
                var selectedFSM: Int?
				if certification.certificationId!.count >= 15 {
					tempCert.certificationCategoryId = "0"
                    if let certId = certification.certificationId {
                        
                        if let approver = ApproverStore.shared.getApprover(for: certId) {
                            print("Approver ID: \(approver.approverId), Name: \(approver.approverName)")
                            approverId = Int(approver.approverId)
                        }
                        
                        if let otherDetails = ApproverStore.shared.getOtherCertificateDetail(for: certId) {
                            selectedFSM = Int(otherDetails.selectedFsmId)
                            siteId = otherDetails.siteId
                        }

                    }
				} else {
                    if let certId = certification.certificationId {
                        if let approver = ApproverStore.shared.getApprover(for: certId) {
                            print("Approver ID: \(approver.approverId), Name: \(approver.approverName)")
                            approverId = Int(approver.approverId)//UserDefaults.standard.value(forKey: certId) as? Int
                        }
                        
                        if let otherDetails = ApproverStore.shared.getOtherCertificateDetail(for: certId) {
                            selectedFSM = Int(otherDetails.selectedFsmId)
                            siteId = otherDetails.siteId
                        }
                    }

				}

                let resolvedCustomerId = certification.customerId?.isEmpty == false
                    ? certification.customerId!
                    : (cstmrId != nil ? "\(cstmrId!)" : "")
                
                let resolvedFSMId = certification.selectedFsmId?.isEmpty == false
                    ? certification.selectedFsmId!
                    : (selectedFSM != nil ? "\(selectedFSM!)" : "")
                
				
                let param = DataService.sharedInstance.getFilledCertObj(
                    certificationId: certification.certificationId ?? "",
                    userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                    siteId: siteId ?? "",
                    customerId: resolvedCustomerId,
                    fssId: Int(resolvedFSMId) ?? 0,
                    FsrId: certification.fsrId ?? "",
                    trainingId: Int(certification.systemCertificationId ?? "0") ?? 0,
                    approverId: approverId
                )
                
                if tempCert.certificationCategoryId == "0" {
                    APIActivityTracker.shared.startRequest()
                    DataService.sharedInstance.postNewCertifications(
                        loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                        viewController: self,
                        param: param ?? [:],
                        completion: { [weak self] (status, error) in
                            APIActivityTracker.shared.endRequest()
                            guard let self = self, error == nil else { return }
                            if let ss = status {
                                if ss.contains("SUCCESS") {
                                    let certId = String(status?.split(separator: "-")[1] ?? "")
                                    var approverId = ""
                                    var approverName = ""
                                   
                                    var siteId = ""
                                    var siteName = ""
                                    var customerId = ""
                                    var custShipping = ""
                                    var selectedFsmId = ""
                                    var customerName = ""
                                    var certDateIs = ""
                                    var manager = ""
                                    
                                    if let prevCertId = certification.certificationId {
                                        if let approver = ApproverStore.shared.getApprover(for: prevCertId) {
                                            approverId = approver.approverId
                                            approverName = approver.approverName
                                        }
                                        
                                        if let details = ApproverStore.shared.getOtherCertificateDetail(for: prevCertId) {
                                            siteId = details.siteId
                                            siteName = details.siteName
                                            customerId = details.customerId
                                            customerName = details.customerName
                                            custShipping = details.custShipping
                                            selectedFsmId = details.selectedFsmId
                                            certDateIs = details.dateSchedule
                                            certDateIs = details.htchMngr
                                        }
                                        
                                    }
                                    
                                    if let prevCertId = certification.certificationId {
                                        if let prevSavedAddress = fetchCountryAndState(certId: prevCertId) {
                                            saveCountryAndState(certId: certId,
                                                                countryId: prevSavedAddress.countryId,
                                                                stateId: prevSavedAddress.stateId,
                                                                addressLine1: prevSavedAddress.addressLine1,
                                                                addressLine2: prevSavedAddress.addressLine2,
                                                                city: prevSavedAddress.city,
                                                                zip: prevSavedAddress.zip,
                                                                siteId: prevSavedAddress.siteId,
                                                                siteName: prevSavedAddress.siteName,
                                                                countryName: prevSavedAddress.countryName,
                                                                stateName: prevSavedAddress.stateName,
                                                                isOtherAddress: prevSavedAddress.isOtherAddress)
                                        }
                                    }
                                    
                                    ApproverStore.shared.setApprover(for: certId, approverId: approverId, approverName: approverName)
                                    ApproverStore.shared.setOtherCertificateDetail(for: certId, customerId: customerId, customerName: customerName, siteId: siteId, siteName: siteName, custShipping: custShipping, selectedFsmId: selectedFsmId, dateSchedule: certDateIs, htchMngr: manager)
                                    
                                    var certObj = certification
                                    certObj.syncStatus = VaccinationCertificationSyncStatus.synced.rawValue
                                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(
                                        userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                        lastModuleName: .VaccinationDashboardVC,
                                        certificationId: certObj.certificationId ?? UUID().uuidString,
                                        subModule: "",
                                        certificationCategoryId: certObj.certificationCategoryId ?? "",
                                        certObj: certObj
                                    )
                                    let certificationCount = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(
                                        userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                        status: .submitted,
                                        syncStatus: .synced
                                    ).count
                                    
                                    if certificationCount > 0 {
                                        self.setupHeaderView(true)
                                    } else {
                                        self.dismissGlobalHUD(self.view ?? UIView())
                                        self.showtoast(message: "Data Synced.")
                                        UserDefaults.standard.set(false, forKey: "hasVaccinationDataLoaded")
                                        self.getSubmittedCertifications()
                                        self.setupHeaderView()
                                    }
                                } else {
                                    self.dismissGlobalHUD(self.view ?? UIView())
                                    //  self.showtoast(message: "Data Sync Unsuccessful. Please try again.")
                                }
                            }
                            
                            // Add delay before processing the next certification
                            if index < certifications.count - 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 1-second delay
                                    self.submitCertifications()  // Recursively call the method for the next certification
                                }
                            }
                        })
                } else {
                    APIActivityTracker.shared.startRequest()
                    DataService.sharedInstance.postCertifications(
                        loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                        viewController: self,
                        param: param ?? [:],
                        completion: { [weak self] (status, error) in
                            APIActivityTracker.shared.endRequest()
                            guard let self = self, error == nil else { return }
                            if status == "SUCCESS" {
                                var certObj = certification
                                certObj.syncStatus = VaccinationCertificationSyncStatus.synced.rawValue
                                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(
                                    userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                    lastModuleName: .VaccinationDashboardVC,
                                    certificationId: certObj.certificationId ?? UUID().uuidString,
                                    subModule: "",
                                    certificationCategoryId: certObj.certificationCategoryId ?? "",
                                    certObj: certObj
                                )
                                let certificationCount = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(
                                    userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                    status: .submitted,
                                    syncStatus: .synced
                                ).count
                                
                                if certificationCount > 0 {
                                    self.setupHeaderView(true)
                                } else {
                                    self.dismissGlobalHUD(self.view ?? UIView())
                                    self.showtoast(message: "Data Synced.")
                                    UserDefaults.standard.set(false, forKey: "hasVaccinationDataLoaded")
                                    self.getSubmittedCertifications()
                                    self.setupHeaderView()
                                }
                            } else {
                                self.dismissGlobalHUD(self.view ?? UIView())
                                //  self.showtoast(message: "Data Sync Unsuccessful. Please try again.")
                            }
                            
                            // Add delay before processing the next certification
                            if index < certifications.count - 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1-second delay
                                    self.submitCertifications()  // Recursively call the method for the next certification
                                }
                            }
                        })
                }
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
        }
    }

    @objc func refreshCertifications(_ notification: NSNotification){
        self.upcomingCertificationsArr =  VaccinationDashboardDAO.sharedInstance.getScheduledCertifications(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        certificationsTblVw.reloadData()
        if popupTblVw != nil{
            popupTblVw.reloadData()
        }
    }
    // MARK: - INITIAL UI SETUP
    
    private func setupUI(){
        operatorCertVw.setGradient(topGradientColor: UIColor.getOperatorCertUpperGradColor(), bottomGradientColor: UIColor.getOperatorCertLowerGradColor())
        
        safeyCertVw.setGradient(topGradientColor: UIColor.getSafetyCertUpperGradColor(), bottomGradientColor: UIColor.getSafetyCertLowerGradColor())
        
        viewTrainingVw.setGradient(topGradientColor: UIColor.getViewCertUpperGradColor() , bottomGradientColor: UIColor.getViewCertLowerGradColor())
        
        draftVw.setGradient(topGradientColor: UIColor.getDraftUpperGradColor(), bottomGradientColor: UIColor.getDraftLowerGradColor())
        
        upcomingCertificationsVw.setGradient(topGradientColor: UIColor.getUpcomingCertUpperGradColor(), bottomGradientColor: UIColor.getUpcomingCertLowerGradColor())
        
        tableHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        
        upcomingCertificationsVw.roundVsCorners(corners: [.topLeft, .topRight], radius: 18.5)
        
    }
    
    @objc func logoutClicked()  {
        let certifications = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", status: .submitted, syncStatus: .synced)
        if certifications.count > 0{
            if hasDataLoaded{
                DispatchQueue.main.async {
                    
                    let errorMSg = Constants.informDataSync
                    let alertController = UIAlertController(title: "Alert!", message: errorMSg, preferredStyle: .alert)
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
                    
                    
                }
            }
        }
        else
        {
            self.logoutActionTraningAndCertification()
        }
    }
    
    func askForDataSync(){
        let errorMSg = Constants.askForDataSync
        let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            
            self.submitCertifications()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            _ in
            self.forceSyncMessage()
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func forceSyncMessage(){
        let errorMSg = Constants.forceSyncMessage
        let alertController = UIAlertController(title: "Alert!", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            _ in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func syncDataPopup(){
        if ConnectionManager.shared.hasConnectivity() {
            let errorMSg = "Data available for sync, Do you want to sync now?"
            let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                _ in
                
                self.submitCertifications()
                
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
        }
    }
    
    
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
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func showPopup(){
        let certifications = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", status: .submitted, syncStatus: .synced)
        if certifications.count > 0{
            if hasDataLoaded{
                DispatchQueue.main.async {
                    self.syncDataPopup()
                }
            }
        }
    }
    
    func showCount(){
        setupHeaderView()
        let count = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", status: .draft, syncStatus: nil).count
        if count > 0{
            dratCountBackgroundImg.isHidden = false
            draftCountLbl.isHidden = false
            draftCountLbl.text = "\( count)"
        }else{
            dratCountBackgroundImg.isHidden = true
            draftCountLbl.isHidden = true
        }
        let  notificationCount = 0
        if notificationCount > 0{
            notificationCountBackgroundImg.isHidden = false
            notificationCountLbl.isHidden = false
            notificationCountLbl.text = "\(notificationCount)"
        }else{
            notificationCountBackgroundImg.isHidden = true
            notificationCountLbl.isHidden = true
        }
    }
    
    private func hidePopup(){
        popupBackgroundVw.isHidden = true
        popupSectionHeaderVw.isHidden = true
        popupHeightConstraint.constant = 0
        titleVw.isHidden = true
        sectonHeaderVw.isHidden = true
    }
    
    private func loadPopupUI(){
        setGradientToTblVw(tableView:popupTblVw)
        popupHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        popupSectionHeaderVw.backgroundColor = UIColor.getPopupSectionHeaderColor()
    }
    
    func setupHeaderView(_ hasSyncCompleted:Bool = true){
        vaccinationHeaderView = VaccinationHeaderContainerVC()
        vaccinationHeaderView.titleOfHeader = "Training & Certification"
        
        vaccinationHeaderView.isVaccinationModule = true
        vaccinationHeaderView.hasVaccinationSynced = hasSyncCompleted
        
        let curentCertification = VaccinationDashboardDAO.sharedInstance.getStartedCertObjByCategory(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationCategoryId: VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID)
        if curentCertification != nil{
            vaccinationHeaderView.showSession = true
        }
        
        
        let count = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", status: .submitted, syncStatus: .synced).count
        vaccinationHeaderView.titleofSync = "\(count)"
        // New changes added in 7.6.6 release as per QA Arshad asking.
        if count > 0
        {
            self.showPopup()
        }
        
        self.headerContainerVw.addSubview(vaccinationHeaderView.view)
        self.topviewConstraint(vwTop: vaccinationHeaderView.view)
        
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
    
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
    
    func addOperations(){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Data...")
        operationQueue.maxConcurrentOperationCount = 4
        let hasLoadedVaccinations = UserDefaults.standard.bool(forKey: "hasVaccinationDataLoaded")
        
        let getCertOperation = BlockOperation{
            self.getScheduledCertifications()
        }
        let getQuestionsOperation = BlockOperation{
            self.getQuestionsMasterData()
        }
        let getDropdownOperation = BlockOperation{
            self.getDropdownMasterData()
        }
        let getMasterEmployeesOperation = BlockOperation{
            self.getEmployeesMasterData()
        }
        let getCustomerOperation = BlockOperation{
            self.getVaccinationCustomers()
        }
        let getCustomerSitesOperation = BlockOperation{
            self.getVaccinationCustomersSites()
        }
        let getFSMListOperation = BlockOperation{
            self.getVaccinationFSMList()
        }
        
        let getCountryListOperation = BlockOperation{
            self.getVaccinationCountryList()
        }
        
        
        let getSubmittedCertifications = BlockOperation{
            self.getSubmittedCertifications()
        }
        operationQueue.addOperation(getCertOperation)
        if !hasLoadedVaccinations{
            
            operationQueue.addOperation(getQuestionsOperation)
            operationQueue.addOperation(getDropdownOperation)
            operationQueue.addOperation(getMasterEmployeesOperation)
            operationQueue.addOperation(getCustomerOperation)
            getCustomerSitesOperation.addDependency(getCustomerOperation)
            operationQueue.addOperation(getCustomerSitesOperation)
            operationQueue.addOperation(getSubmittedCertifications)
            operationQueue.addOperation(getFSMListOperation)
            operationQueue.addOperation(getCountryListOperation)
        }
        
        
        
    }
    
    func registerTblVwCells(){
        certificationsTblVw.delegate = self
        certificationsTblVw.dataSource = self
        certificationsTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
        
        popupTblVw.delegate = self
        popupTblVw.dataSource = self
        popupTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    func addOperationinQueue(){
        let getCustomerSitesOperation = BlockOperation{
            self.getVaccinationCustomersSites()
        }
        operationQueue.waitUntilAllOperationsAreFinished()
        operationQueue.addOperation(getCustomerSitesOperation)
        operationQueue.waitUntilAllOperationsAreFinished()
        
    }
    
    private func loadPopupVw(){
        popupBackgroundVw.isHidden = false
        popupSectionHeaderVw.isHidden = false
        popupHeightConstraint.constant = 360
        titleVw.isHidden = false
        sectonHeaderVw.isHidden = false
    }
    
	private func getScheduledCertifications(){
		APIActivityTracker.shared.startRequest()
		DataService.sharedInstance.getScheduledCertifications(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self,completion: { [weak self] (status, error) in
			APIActivityTracker.shared.endRequest()
			
			self?.showPopup()
			guard let _ = self, error == nil else {
				self?.hasDataLoaded = true
				//                self?.showPopup()
				let hasLoadedVaccinations = UserDefaults.standard.bool(forKey: "hasVaccinationDataLoaded")
				if !hasLoadedVaccinations{
					
				}else{
					self?.dismissGlobalHUD(self?.view ?? UIView());
				}
				return;
			}
			
			let mainQueue = OperationQueue.main
			mainQueue.addOperation{
				if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
					self?.upcomingCertificationsArr =  VaccinationDashboardDAO.sharedInstance.getScheduledCertifications(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
					UserContext.sharedInstance.markSynced(apiCallName: .getScheduledCertifications)
					self?.certificationsTblVw.reloadData()
					if self?.popupTblVw != nil{
						self?.popupTblVw.reloadData()
					}
					self?.hasDataLoaded = true
					//                    self?.showPopup()
				} else if status == "No Data Found"{
					self?.hasDataLoaded = true
					//                    self?.showPopup()
					self?.dismissGlobalHUD(self?.view ?? UIView())
				}
				let hasLoadedVaccinations = UserDefaults.standard.bool(forKey: "hasVaccinationDataLoaded")
				if !hasLoadedVaccinations{
					
				}else{
					self?.dismissGlobalHUD(self?.view ?? UIView());
				}
			}
		})
	}
    
    private func getQuestionsMasterData(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getCertificationMasterQuestions(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self,completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getQuestionsMasterData)
                }
            }
        })
    }
    
    private func getDropdownMasterData(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getDropdownMasterData(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self,completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getDropdownMasterData)
                }
            }
        })
    }
    
    private func getEmployeesMasterData(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getEmployeesById(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, customerId: "11", siteId: "221",completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getEmployeesMasterData)       }
            }
        })
    }
    
    private func getVaccinationCustomers(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getVaccinationCustomers(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationCustomers)
                    self?.addOperationinQueue()
                    
                }
            }
        })
    }
    
    private func getVaccinationCustomersSites(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getVaccinationCustomerSites(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationCustomersSites)
                    
                }
            }
        })
    }
    
    //Get FSM List
    private func getVaccinationFSMList(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getVaccinationFSMList(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationFSMList)
                    
                }
            }
        })
    }
    
    private func getVaccinationCountryList(){
        APIActivityTracker.shared.startRequest()
       DataService.sharedInstance.getVaccinationCountryList(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationCountryList)
                    
                }
            }
        })
    }
    
    
    private func getSubmittedCertifications(){
        
        DispatchQueue.main.async {
            self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Data...")
        }
        
        APIActivityTracker.shared.startRequest()
        DataService.sharedInstance.getSubmittedCertifications(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
            APIActivityTracker.shared.endRequest()
            guard let _ = self, error == nil else { self?.dismissGlobalHUD(self?.view ?? UIView()); return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.showCount()
                    UserDefaults.standard.set(true, forKey: "hasVaccinationDataLoaded")
                    self?.dismissGlobalHUD(self?.view ?? UIView());
                    
                    UserContext.sharedInstance.markSynced(apiCallName: .getSubmittedCertifications)
                    //
                }
            }
            UserDefaults.standard.set(true, forKey: "hasVaccinationDataLoaded")
            self?.dismissGlobalHUD(self?.view ?? UIView());
            
            
        })
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func draftBtnsAction(_ sender: UIButton) {
        if navigate{
            navigate = false
            navigateToViewCertifications(status: .draft)
            navigate = true
        }
    }
    
    @IBAction func notificationBtnsAction(_ sender: UIButton) {
        
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        hidePopup()
    }
    
    @IBAction func operatorCertBtnAction(_ sender: UIButton) {
        if navigate{
            navigate = false
            Constants.modeType = "new_operator"
            navigateToAddEmloyees(index: 0)
            navigate = true
        }
    }
    
    @IBAction func safetyCertBtnAction(_ sender: UIButton) {
        if navigate{
            navigate = false
            Constants.modeType = "Safety"
            navigateToAddEmloyees(index: nil, safetyCertification: true)
            navigate = true
        }
    }
    
    @IBAction func viewTrainingBtnAction(_ sender: UIButton){
        if navigate{
            navigate = false
            navigateToViewCertifications(status: .submitted)
            navigate = true
        }
    }
    
    @IBAction func draftBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func notificationBtnaCTION(_ sender: UIButton) {
    }
    
}

// MARK: - EXTENSION

extension VaccinationDashboardVC: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingCertificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: VaccinationCertificationsTableViewCell.identifier, for: indexPath) as? VaccinationCertificationsTableViewCell{
            cell.removeBtnVw()
            if upcomingCertificationsArr.count > 0 && indexPath.row < upcomingCertificationsArr.count{
                cell.setValues(vaccinationCertificatonObj:upcomingCertificationsArr[indexPath.row] )
                if upcomingCertificationsArr.count - 1 == indexPath.row{
                    cell.layer.masksToBounds = true
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                } else{
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                }
            }else{
                
            }
            
            if tableView == popupTblVw{
                cell.removeCertVw()
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == certificationsTblVw{
            return 44
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == certificationsTblVw{
            if upcomingCertificationsArr.count > 0 && indexPath.row < upcomingCertificationsArr.count{
                let certificationId = upcomingCertificationsArr[indexPath.row].certificationId
                Constants.modeType = "operator"
                var certificationStatusObj = VaccinationDashboardDAO.sharedInstance.getScheduledCertificationStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: certificationId ?? "", certCategoryId: "2", certObj: upcomingCertificationsArr[indexPath.row])
                if certificationStatusObj.lastModuleName ==  VaccinationModuleNames.QuestionnaireVC.rawValue{
                    navigatetToQuestionnaireScreen(index: indexPath.row, subModule:certificationStatusObj.lastSubmoduleName ?? "" )
                } else{
                    navigateToAddEmloyees(index: indexPath.row)
                }
                
            }
            
        } else if tableView == popupTblVw{
            if upcomingCertificationsArr.count > 0 && indexPath.row < upcomingCertificationsArr.count{
                let certificationId = upcomingCertificationsArr[indexPath.row].certificationId
                var certObj = upcomingCertificationsArr[indexPath.row]
                certObj.certificationCategoryName = "Operator"
                certObj.certificationCategoryId = "2"
                var certificationStatusObj = VaccinationDashboardDAO.sharedInstance.getScheduledCertificationStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: certificationId ?? "", certCategoryId: "2", certObj: upcomingCertificationsArr[indexPath.row])
                if certificationStatusObj.lastModuleName ==  VaccinationModuleNames.QuestionnaireVC.rawValue{
                    navigatetToQuestionnaireScreen(index: indexPath.row, subModule:certificationStatusObj.lastSubmoduleName ?? "" )
                } else{
                    navigateToAddEmloyees(index: indexPath.row, safetyCertification:  false)
                }
            }
        }
    }
    
    // MARK: - SYNC METHODS
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Can't Proceed", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - NAVIGATION METHODS
    
    func navigatetToQuestionnaireScreen(index:Int?, subModule:String = "") {
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "QuestionnaireVC") as? QuestionnaireVC
        vc?.subModule = subModule
        if index != nil && index! > -1{
            vc?.curentCertification =  upcomingCertificationsArr[index!]
            let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: vc?.curentCertification?.certificationId ?? "")
            if startedObj != nil{
                vc?.curentCertification = startedObj
            }
            let safetyCertification  = false
            if !safetyCertification{
                let cert = upcomingCertificationsArr[index!]
                vc?.curentCertification = cert
                let certificationId = cert.certificationId ?? ""
                if startedObj != nil {
                    vc?.curentCertification = startedObj
                }
                vc?.curentCertification?.certificationCategoryId =  "2"
                vc?.curentCertification?.certificationCategoryName =  "Operator"
                
                if let dd = trainingScheduleArray,
                   dd.count > index! {
                    for trainingCert in dd {
                        let certIddd = trainingCert["Id"] as? Int ?? 0
                        if certificationId == "\(certIddd)" {
                            let approverId = trainingCert["ApproverId"] as? Int ?? 0
                            let approverName = trainingCert["ApproverName"] as? String ?? ""
                            ApproverStore.shared.setApprover(for: certificationId, approverId: "\(approverId)", approverName: approverName)
                        }
                    }
                }
            } else {
                vc?.curentCertification?.certificationCategoryId =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                vc?.curentCertification?.certificationCategoryName =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
            }
        }
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func navigateToViewCertifications(status: VaccinationCertificationStatus){
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewCertificationsVC") as? ViewCertificationsVC
        vc?.status = status
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    func navigateToAddEmloyees(index:Int?, safetyCertification:Bool = false) {
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeesVC") as? AddEmployeesVC
        vc?.isSafetyCertification = safetyCertification
        if index != nil && index! > -1 {
            if !safetyCertification {
                if Constants.modeType == "new_operator" {
                    vc?.curentCertification?.certificationCategoryId =  "0"
                    vc?.curentCertification?.certificationCategoryName =  "Operator"
                } else {
                    var certificationId = ""
                    if let indx = index,
                        upcomingCertificationsArr.count > indx {
                        certificationId = upcomingCertificationsArr[indx].certificationId ?? ""
                    }
                    if let indx = index, upcomingCertificationsArr.count > indx {
                        vc?.curentCertification = upcomingCertificationsArr[indx]
                    }
                    let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: vc?.curentCertification?.certificationId ?? "")
                    if startedObj != nil {
                        vc?.curentCertification = startedObj
                    }
                    vc?.curentCertification?.certificationCategoryId =  "2"
                    vc?.curentCertification?.certificationCategoryName =  "Operator"
                    
                    
					if let dd = trainingScheduleArray,
                       dd.count > index! {
                        for trainingCert in dd {
                            let certIddd = trainingCert["Id"] as? Int ?? 0
                            if certificationId == "\(certIddd)" {
                                let approverId = trainingCert["ApproverId"] as? Int ?? 0
                                let approverName = trainingCert["ApproverName"] as? String ?? ""
                                ApproverStore.shared.setApprover(for: certificationId, approverId: "\(approverId)", approverName: approverName)
                            }
                        }
					}
                }
            } else {
                vc?.curentCertification?.certificationCategoryId =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                vc?.curentCertification?.certificationCategoryName =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
            }
        }
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}

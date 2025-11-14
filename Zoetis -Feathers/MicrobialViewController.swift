//
//  MicrobialViewController.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 10/12/19.
//  Copyright © 2019 . All rights reserved.
//


import SwiftyJSON
import Charts
import Reachability
import CoreMedia
import Gigya
import GigyaTfa
import GigyaAuth

class MicrobialViewController: BaseViewController {
    
    
    @IBOutlet weak var createReqBtn: UIButton!
    @IBOutlet weak var syncBadgeBackgroundView: UIImageView!
    @IBOutlet weak var draftImageView: UIImageView!
    @IBOutlet weak var requisitionBtnView: customButton!
    @IBOutlet weak var loggedInUser: UILabel!
    @IBOutlet weak var syncCountLbl: UILabel!
    @IBOutlet weak var draftCountLbl: UILabel!
    @IBOutlet weak var NotificationCountLbl: UILabel!
    @IBOutlet weak var sessionBtn: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var microbialPopUpView: GradientView!
    @IBOutlet weak var microbialPopUpBackgroundView: GradientView!
    @IBOutlet weak var draftContainerView: GradientView!
    @IBOutlet weak var draftContainer: GradientView!
    @IBOutlet weak var backViewBtn: UIButton!
    
    @IBOutlet weak var piechartViewBacterial: PieChartView!
    @IBOutlet weak var piechartViewEnviromental: PieChartView!
    @IBOutlet weak var piechartViewFeathurePulp: PieChartView!
    
    @IBOutlet weak var widthOfSessionButton: NSLayoutConstraint!
    @IBOutlet weak var horizontalDistanceBetweenSyncAndSessionButton: NSLayoutConstraint!

    var selectedSurvey = ""
    var gradientLayer: CAGradientLayer!
    var isNewRquisitionSelected = false
    var wantToStartViewRequisition = false
    var arrSyncReqLimit = 0
    var arrSyncIndex = 0
    let releaseReqId = 8
    let reqAndRevRoleId = 33
    @IBOutlet weak var btnSyn: UIButton!

    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let FirstName = UserDefaults.standard.value(forKey: "FirstName") as! String
        if let isLaunched = UserDefaults.standard.value(forKey: "isFreshLaunched"){
            debugPrint(isLaunched)
        }else{
            UserDefaults.standard.set(true, forKey: "isFreshLaunched")
            UserDefaults.standard.synchronize()
        }
        self.loggedInUser.text = FirstName
        self.sessionBtn.isHidden = true
        self.backViewBtn.isHidden = true
        self.microbialPopUpView.isHidden = true
        self.microbialPopUpBackgroundView.isHidden = true
        self.callApiOfMasterData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncBtnLogoutTappedNoti(notification:)), name: Notification.Name("microbialSyncDataNoti"), object: nil)
    }
    
    private func callApiOfMasterData(){
        if CodeHelper.sharedInstance.reachability!.connection == .unavailable {
                return
        }
        if (UserDefaults.standard.value(forKey: "isFreshLaunched") as? Bool) ?? true {
            fetchCustomerList()
        }else{
        //            fetchGetAllSyncedDataForRequisition()
        }
    }
        
    
    @IBAction func menuBtnActionNew(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @objc private func syncBtnLogoutTappedNoti(notification: NSNotification){
        self.startLogoutProcess()
    }
    
    private func startLogoutProcess(){
        let syncCount = Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.bacterial.rawValue).count + Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.enviromental.rawValue).count
        if ConnectionManager.shared.hasConnectivity() {

            if syncCount > 0{
                
                let errorMSg = "Data available for sync. Do you want to sync now? \n\n\n *Note - Please don't minimize App while syncing."
                let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    _ in
                    
                    self.suncDataBackToServer(reqType: .bacterial, sessionStatus: .submitted)
                    
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    _ in
                    
                    self.logoutAction()
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                self.logoutAction()
            }
            
        } else {
            self.logoutAction()
        }
    }
    
    @IBAction func logoutNavBarBtn(_ sender: UIButton) {
        let errorMSg = "Are you sure you want to logout?"
        let alertController = UIAlertController(title: "Alert", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { _ in
            self.startLogoutProcess()
            
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logoutAction() {
        
        UserDefaults.standard.set(false, forKey: "newlogin")
        self.ssologoutMethod()
        guard let arrNavigationController = self.navigationController else{
            return
        }
        ViewController.savePrevUserLoggedInDetails()
        ViewController.clearDataBeforeLogout()
        for controller in arrNavigationController.viewControllers as Array {
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
 
   
    
    @IBAction func viewRequisitionBtnClicked(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "ViewRequisition", bundle: nil).instantiateViewController(withIdentifier: "ViewRequisitionViewController") as? ViewRequisitionViewController {
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
    @IBAction func bacterialBtnClicked(_ sender: UIButton) {
        self.navigateToBacterialViewController(requisitionSavedSessionType: .CREATE_NEW_SESSION)
    }
    
    func navigateToBacterialViewController(requisitionSavedSessionType: REQUISITION_SAVED_SESSION_TYPE){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Microbial", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EnviromentalSurveyController") as! EnviromentalSurveyController
        vc.currentRequisitionType = RequisitionType.bacterial
      
        vc.requisitionSavedSessionType = requisitionSavedSessionType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func environmentalServeyBtnClicked(_ sender: UIButton) {
        self.navigateToEnvironmentalViewController(requisitionSavedSessionType: .CREATE_NEW_SESSION)
    }
    
    func navigateToEnvironmentalViewController(requisitionSavedSessionType: REQUISITION_SAVED_SESSION_TYPE){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Microbial", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EnviromentalSurveyController") as! EnviromentalSurveyController
        vc.currentRequisitionType = RequisitionType.enviromental
        vc.requisitionSavedSessionType = requisitionSavedSessionType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func completedRequisitionSyncBtnAction(_ sender: UIButton) {
        print("btn click")
        let syncCount = Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.bacterial.rawValue).count + Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.enviromental.rawValue).count
//            Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.feathurePulp.rawValue).count

        if syncCount == 0{
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "No data available to sync.")
            return
        }
        if !ConnectionManager.shared.hasConnectivity(){
            Helper.showAlertMessage(self, titleStr: "Alert", messageStr: "No Internet connection available.")
            return
        }
        let alert = UIAlertController(title: "Alert", message: "Data Available for Sync.\nAre you sure you want to Sync ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            self.suncDataBackToServer(reqType: .bacterial, sessionStatus: .submitted)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func featherPulpBtnClicked(_ sender: UIButton) {
        self.navigateToFeatherPulpController(requisitionSavedSessionType: .CREATE_NEW_SESSION)
    }

    func navigateToFeatherPulpController(requisitionSavedSessionType: REQUISITION_SAVED_SESSION_TYPE){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Microbial", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FeatherPulpVC") as! FeatherPulpVC
        vc.requisitionSavedSessionType = requisitionSavedSessionType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.newRequisitionBtnClk(_:)), name: Notification.Name("openStartRequisition"), object: nil)
        if isNewRquisitionSelected{
            self.newRequisitionBtnClk(UIButton())
            
        }else{
            // check and sync
            if let isFreshLaunched = UserDefaults.standard.value(forKey: "isFreshLaunched") as? Bool{
                if !isFreshLaunched{
                    let n: Int! = self.navigationController?.viewControllers.count
                    if let objHatcherySelectionViewController = self.navigationController?.viewControllers[n-2] as? HatcherySelectionViewController{
                        self.checkAndSync()
                        if ConnectionManager.shared.hasConnectivity(){
                            return
                        }
                        fetchGetAllSyncedDataForRequisition()
                    }else{
                        self.checkAndSync()
                    }
                }
            }
        }
        draftContainerView.firstColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        draftContainerView.secondColor = UIColor(red: 223/255, green: 240/255, blue: 1, alpha: 1)
        
        draftContainer.firstColor = UIColor(red: 238/255, green: 247/255, blue: 255/255, alpha: 1)
        draftContainer.secondColor = UIColor(red: 207/255, green: 1, blue: 242/255, alpha: 1)
    }
   
    func checkAndSync(){
        let syncCount = Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.bacterial.rawValue).count + Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.enviromental.rawValue).count
        if ConnectionManager.shared.hasConnectivity() {

            if syncCount > 0{
                
                let errorMSg = "Data available for sync. Do you want to sync now? \n\n\n *Note - Please don't minimize App while syncing."
                let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    _ in
                    self.suncDataBackToServer(reqType: .bacterial, sessionStatus: .submitted)
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel)
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                // no data available for sync..
            }
            
        } else {
            // No internet connection
        }
    }
    
    
    @IBAction func newRequisitionBtnClk(_ sender: UIButton) {
        let enviromentalSessionInProgress = CoreDataHandlerMicro().fetchAllData("Microbial_EnviromentalSessionInProgress")
        var requisitionType = RequisitionType.bacterial
        
        if enviromentalSessionInProgress.count > 0 {
            if let sessionData = enviromentalSessionInProgress.object(at: 0) as? Microbial_EnviromentalSessionInProgress {
                if let requisition = RequisitionType(rawValue: Int(truncating: sessionData.requisitionType ?? 0)) {
                    requisitionType = requisition
                }
            }
        }
                
        if enviromentalSessionInProgress.count > 0  && requisitionType ==  RequisitionType.bacterial {
            
            self.navigateToBacterialViewController(requisitionSavedSessionType: .RESTORE_OLD_SESSION)
            
        } else if enviromentalSessionInProgress.count > 0 && requisitionType ==  RequisitionType.enviromental {
            
            self.navigateToEnvironmentalViewController(requisitionSavedSessionType: .RESTORE_OLD_SESSION)
            
        }

        else {
            self.backViewBtn.isHidden = false
            self.microbialPopUpView.isHidden = false
            self.microbialPopUpBackgroundView.isHidden = false
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDataForGraphDraftAndSubmittedReq()
        buttonMenu.bringSubviewToFront(self.view)
        btnSyn.bringSubviewToFront(self.view)
    }
    
    func loadDataForGraphDraftAndSubmittedReq(){
        createGradientLayer()
        self.backViewBtn.isHidden = true
        self.microbialPopUpView.isHidden = true
        self.microbialPopUpBackgroundView.isHidden = true
        
        let enviromentalSessionInProgress = CoreDataHandlerMicro().fetchAllData("Microbial_EnviromentalSessionInProgress")
        let bacterialSessionInProgress = CoreDataHandlerMicro().fetchAllData("ProgressSessionMicrobial")
        let featherPulpSessionInProgress = CoreDataHandlerMicro().fetchAllData("Microbial_FeatherPulpCurrentSession")
        
        if enviromentalSessionInProgress.count > 0{
            self.sessionBtn.isHidden = false
            self.widthOfSessionButton.constant = 40
            self.horizontalDistanceBetweenSyncAndSessionButton.constant = 35
        } else if bacterialSessionInProgress.count > 0{
            self.sessionBtn.isHidden = false
            self.widthOfSessionButton.constant = 40
            self.horizontalDistanceBetweenSyncAndSessionButton.constant = 35
        } else if featherPulpSessionInProgress.count > 0{
            self.sessionBtn.isHidden = false

            self.widthOfSessionButton.constant = 40
            self.horizontalDistanceBetweenSyncAndSessionButton.constant = 35
        } else {
            self.sessionBtn.isHidden = true

            self.widthOfSessionButton.constant = 0
            self.horizontalDistanceBetweenSyncAndSessionButton.constant = 0
        }
        
        if wantToStartViewRequisition{
            self.newRequisitionBtnClk(UIButton())
        }
        
        self.configureGraphViews()
    }
    
    @IBAction func backViewBtnClk(_ sender: UIButton) {
        self.backViewBtn.isHidden = true
        self.microbialPopUpView.isHidden = true
        self.microbialPopUpBackgroundView.isHidden = true
    }
    
    @IBAction func viewDraftAction(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "ViewRequisition", bundle: nil).instantiateViewController(withIdentifier: "DraftViewController") as? DraftViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func sessionBtnAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to clear current session?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            self.sessionBtn.isHidden = true
            self.widthOfSessionButton.constant = 0
            self.horizontalDistanceBetweenSyncAndSessionButton.constant = 0
            CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
            CoreDataHandlerMicro().deleteAllData("MicrobialSampleInfo")
            
            //Delete data for Enviromental Session InProgress
            CoreDataHandlerMicro().deleteAllData("Microbial_EnviromentalSessionInProgress")
            CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaders")
            CoreDataHandlerMicro().deleteAllData("Microbial_LocationTypeHeaderPlates")
            
            //Delete data for Feathure pulp Session InProgress
            CoreDataHandlerMicro().deleteAllData("Microbial_FeatherPulpCurrentSession")
            MicrobialFeatherpulpServiceTestSampleInfo.deleteWithPredicatesFeaherPulpSampleInfo()
            MicrobialSelectedUnselectedReviewer.deleteSessionType()
            CoreDataHandlerMicro().deleteWithPredicatesFeaherPulpSampleInfo("MicrobialFeatherPulpSampleInfo")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MicrobialViewController {
    
    private func suncDataBackToServer(reqType: RequisitionType, sessionStatus: SessionStatus){
        let requisitionsBacterial = CoreDataHandlerMicro().fetchSubmittedOrSaveAsDraftRequisitions(sessionStatus: sessionStatus.rawValue, requisitionType: RequisitionType.bacterial.rawValue)
        let requisitionsEnvironmental = CoreDataHandlerMicro().fetchSubmittedOrSaveAsDraftRequisitions(sessionStatus: sessionStatus.rawValue, requisitionType: RequisitionType.enviromental.rawValue)
        
        switch reqType {
        case .bacterial:
            if requisitionsBacterial.count > 0{
                self.arrSyncReqLimit = requisitionsBacterial.count
                self.arrSyncIndex = 0
                self.syncData(data: requisitionsBacterial[self.arrSyncIndex] as! Microbial_EnviromentalSurveyFormSubmitted, reqType: .bacterial, sessionType: sessionStatus)
            }else{
                if sessionStatus == .submitted{
                    self.suncDataBackToServer(reqType: .bacterial, sessionStatus: .saveAsDraft)
                }else{
                    // after save as draft syncing is complete
                    self.suncDataBackToServer(reqType: .enviromental, sessionStatus: .submitted)
                }
            }

            
        case .enviromental:
            if requisitionsEnvironmental.count > 0{
                self.arrSyncReqLimit = requisitionsEnvironmental.count
                self.arrSyncIndex = 0
                self.syncData(data:  requisitionsEnvironmental[self.arrSyncIndex] as! Microbial_EnviromentalSurveyFormSubmitted, reqType: .enviromental, sessionType: sessionStatus)
            }else{
                if sessionStatus == .submitted{
                    self.suncDataBackToServer(reqType: .enviromental, sessionStatus: .saveAsDraft)
                }else{
                    // after save as draft syncing is complete
                }
            }

        }
    }
    
    private func createStructureJsonForEnvAndBacterial(data: Microbial_EnviromentalSurveyFormSubmitted, reqType: RequisitionType, sessionType: SessionStatus) -> [String: Any]{
        let objMicrobial_LocationTypeHeaderPlatesSubmitted = Microbial_LocationTypeHeaderPlatesSubmitted.fetchEnviromentalPlatesWith(timeStamp: data.timeStamp ?? "")
        var objPlates = [Dictionary<String, Any>]()
        var temIndex = 1
        for plates in objMicrobial_LocationTypeHeaderPlatesSubmitted {
            if plates.mediaTypeValue == "TSA" {
                plates.mediaTypeId = 1
            }
            else if plates.mediaTypeValue == "SabDex" {
                plates.mediaTypeId = 2
            }
            else if plates.mediaTypeValue == "MacConkey" {
                plates.mediaTypeId = 3

            }
            else if plates.mediaTypeValue == "Other"  {
                plates.mediaTypeId = 4
            }
            let section = plates.section?.intValue ?? -1
            let plateId = (data.isPlateIdGenerated?.boolValue ?? false) ? (plates.plateId ?? "") : ""
            
            objPlates.append(MicrobialBacterialSampleDetailsList(Plate_Id: plateId, Location_Type: plates.locationTypeId?.intValue ?? 0, Location_Value: plates.locationValueId?.intValue ?? 0, Sample_Desc: plates.sampleDescription ?? "", Add_Test: plates.isMicoscoreChecked?.boolValue ?? true, Add_Bact: plates.isBacterialChecked?.boolValue ?? false, ParentId: section - 1, ChildId: plates.row?.intValue ?? -1, MediaType: plates.mediaTypeId as? Int, Notes: plates.notes, SamplingMethod: plates.samplingMethodTypeId?.intValue).dictionary ?? [:])
            temIndex = temIndex + 1
        }//data.email
        let requestor_Id = UserDefaults.standard.value(forKey: "Id") as? Int ?? 0
        let prediacate = NSPredicate(format: "timeStamp == %@ AND isSelected == %d", argumentArray: [data.timeStamp ?? "", true])
        let reviewerIds = MicrobialSelectedUnselectedReviewer.fetchDetailsForReviewer(predicate: prediacate).map{ $0.reviewerId?.intValue }
        let objBacterial = EnvironmentalRequestModel(Requestor_Id: requestor_Id, Customer_Id: data.companyId?.intValue ?? 0, Site_Id: data.siteId?.intValue ?? 0, ReviewerIds: reviewerIds as? [Int], Barcode: data.barcode ?? "", Conducted_Type: data.surveyConductedOnId?.intValue ?? 0, Purpose_Type: data.purposeOfSurveyId?.intValue ?? 0, Transfer_Type: 0, Sample_Date: data.sampleCollectionDate ?? "", Ack: true, Device_Id: data.syncDeviceId ?? "", RequisitionId: data.timeStamp ?? "", RequisitionType: data.sessionStatus?.intValue ?? 1, Notes: data.notes ?? "", VisitReason: (data.reasonForVisitId?.intValue == 0) ? 3 : data.reasonForVisitId?.intValue, RequisitionNo: data.reqNo ?? "")
        var dict = objBacterial.dictionary ?? [:]
        if reqType == .bacterial{
            dict["MicrobialBacterialSampleDetailsList"] = objPlates
        }else if reqType == .enviromental{
            dict["MicrobialEnvironmentalSampleDetailsList"] = objPlates
        }
        return dict
    }
 
    private func syncData(data: Microbial_EnviromentalSurveyFormSubmitted, reqType: RequisitionType, sessionType: SessionStatus){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Syncing")
        var dict = self.createStructureJsonForEnvAndBacterial(data: data, reqType: reqType, sessionType: sessionType)
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        print(dict)
        ZoetisWebServices.shared.syncEnvironmentalData(reqType: reqType, controller: self, parameters: dict, completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.dismissGlobalHUD(self.view)
         
            
            let submittedRequisitionsBacterial = CoreDataHandlerMicro().fetchSubmittedOrSaveAsDraftRequisitions(sessionStatus: sessionType.rawValue, requisitionType: RequisitionType.bacterial.rawValue)
            let submittedRequisitionsEnvironmental = CoreDataHandlerMicro().fetchSubmittedOrSaveAsDraftRequisitions(sessionStatus: sessionType.rawValue, requisitionType: RequisitionType.enviromental.rawValue)
            self.showtoast(message: "Data sync successfully")
            
            switch reqType {
            case .bacterial:
                self.arrSyncIndex = self.arrSyncIndex + 1
                if self.arrSyncIndex < self.arrSyncReqLimit{
                    self.syncData(data: submittedRequisitionsBacterial[self.arrSyncIndex] as! Microbial_EnviromentalSurveyFormSubmitted, reqType: .bacterial, sessionType: sessionType)
                }else{
                    Microbial_EnviromentalSurveyFormSubmitted.updateSyncCheckForAll(reqType: RequisitionType.bacterial.rawValue, sessionStatus: sessionType.rawValue)
                    if sessionType == .submitted{
                        self.suncDataBackToServer(reqType: .bacterial, sessionStatus: .saveAsDraft)
                    }else{
                        self.suncDataBackToServer(reqType: .enviromental, sessionStatus: .submitted)
                    }
                }
                
                
            case .enviromental:
                self.arrSyncIndex = self.arrSyncIndex + 1
                if self.arrSyncIndex < self.arrSyncReqLimit {
                    self.syncData(data:  submittedRequisitionsEnvironmental[self.arrSyncIndex] as! Microbial_EnviromentalSurveyFormSubmitted, reqType: .enviromental, sessionType: sessionType)
                } else {
                    Microbial_EnviromentalSurveyFormSubmitted.updateSyncCheckForAll(reqType: RequisitionType.enviromental.rawValue, sessionStatus: sessionType.rawValue)
                    if sessionType == .submitted {
                        self.suncDataBackToServer(reqType: .enviromental, sessionStatus: .saveAsDraft)
                    }
                }
            }
            let syncCount = Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.bacterial.rawValue).count + Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.enviromental.rawValue).count
            self.syncBadgeBackgroundView.isHidden = (syncCount == 0)
            self.syncCountLbl.text = "\(syncCount)"
        })
    }
    
    private func fetchGetAllSyncedDataForRequisition(){
        dismissGlobalHUD(self.view)
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllSyncedRequisitionData(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            self!.dismissGlobalHUD(self!.view)
            guard let self = self, error == nil else { return }
            UserDefaults.standard.set(false, forKey: "isFreshLaunched")
            UserDefaults.standard.synchronize()
            let jsonObject = RequisitionGetDataModel(json)
            let arrRequisition = jsonObject.requisitionArray
            if arrRequisition?.count ?? 0 > 0{
                for objReq in arrRequisition ?? []{
                    if let microbialDetailsList = objReq.microbialDetailsList{
                        
                        for arrMicrobialDetailsList in microbialDetailsList{
                            if !Microbial_EnviromentalSurveyFormSubmitted.isSameTimeStampAndUserIdAlreadyExisits(reqData: arrMicrobialDetailsList){
                                let isPlateIdGenerated = false
                                
                                let arrReviewers = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer") as! [Micro_Reviewer]
                                let reviewerIds = arrMicrobialDetailsList.reviewerIds ?? []
                                for reviewer in arrReviewers{
                                    let isSelected = reviewerIds.contains(reviewer.reviewerId?.intValue ?? 0)
                                    MicrobialSelectedUnselectedReviewer.saveReviewersInDB(arrMicrobialDetailsList.timeStamp ?? "", reviewerId: reviewer.reviewerId?.intValue ?? 0, reviewerName: reviewer.reviewerName ?? "", isSelected: isSelected, isSessionType: false)
                                }
                                
                                var reviewersText = ""
                                for selectsId in reviewerIds{
                                    let selectedReviewer = arrReviewers.filter{ $0.reviewerId?.intValue ?? 0 == selectsId }
                                    if selectedReviewer.count > 0{
                                        if reviewersText == ""{
                                            reviewersText = selectedReviewer.first?.reviewerName ?? ""
                                        }else{
                                            reviewersText = "\(reviewersText), \(selectedReviewer.first?.reviewerName ?? "")"
                                        }
                                    }
                                }
                                
                                Microbial_EnviromentalSurveyFormSubmitted.saveDataWhichIsAlreadySynced(reqData: arrMicrobialDetailsList, reqText: objReq.SurveyType?.Text ?? "", reqId: objReq.SurveyType?.Id ?? 0, isPlateIdGenerated: isPlateIdGenerated, reviewerText: reviewersText)


                            }else{
                                //update case status
                                
                                Microbial_EnviromentalSurveyFormSubmitted.updateCaseStatusOfReq(timeStamp: arrMicrobialDetailsList.timeStamp ?? "", caseStatus: arrMicrobialDetailsList.status ?? 0)
                            }
                        }
                    }
                }
            }
            self.checkAndSync()
            self.loadDataForGraphDraftAndSubmittedReq()
            print(json)
        })
    }
    
    
    private func headersAndPlatesForBacterialAndEnv(microbialSampleDetailsList: [MicrobialSampleDetailsList], arrMicrobialDetailsList: MicrobialDetailsList, objReq: RequisitionData){
        for sampleDetails in microbialSampleDetailsList{
            //check for timestamp in header
            if Microbial_LocationTypeHeadersSubmitted.isSameTimeStampAlreadyExistsInHeader(reqData: arrMicrobialDetailsList, section: sampleDetails.section ?? 0){
                // update count of number of plates
                Microbial_LocationTypeHeadersSubmitted.incrementNumOfPlates(reqDetails: arrMicrobialDetailsList, section: sampleDetails.section ?? 0)
            }else{
                //insert with number of plates as 1
                Microbial_LocationTypeHeadersSubmitted.saveSampleInfoHeaderDataInToDB_Enviromental(reqDetails: arrMicrobialDetailsList, headerDetails: sampleDetails, reqId: objReq.SurveyType?.Id ?? 0, reqName: objReq.SurveyType?.Text ?? "", numOfPlates: 1)
            }
            
            let plateData = CoreDataHandlerMicrodataModels.envPlateSampleInfo(currentDate: arrMicrobialDetailsList.sampleDate ?? "", customerId: "", requisitionType: objReq.SurveyType?.Id ?? 0, sessionStatus: arrMicrobialDetailsList.sessionStatus ?? 0, isBacterialChecked: sampleDetails.addBact ?? false, isMicoscoreChecked: sampleDetails.addMicro ?? false, locationTypeId: sampleDetails.locationType ?? 0, locationValue: sampleDetails.locVal ?? "", plateId: sampleDetails.plateId ?? "", row: sampleDetails.row ?? 0, sampleDescription: sampleDetails.sampleDesc ?? "", section: sampleDetails.section ?? 0, requisitionId: arrMicrobialDetailsList.barcode ?? "", timeStamp: arrMicrobialDetailsList.timeStamp ?? "", locationValueId: sampleDetails.locationValue ?? -100, mediaTypeId: sampleDetails.mediaTypeId ?? 0, notes: sampleDetails.notes ?? "", samplingMethodTypeId: sampleDetails.samplingMethodId ?? 0)
            
            Microbial_LocationTypeHeaderPlatesSubmitted.saveSampleInfoPlateDataInToDB_Enviromental(plateData)

        }
    }

    
    private func fetchCustomerList(){
        CoreDataHandlerMicro().deleteAllData("Micro_Customer")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllCustomersForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchCustomerResponse(json)
        })
    }
    
    private func handlefetchCustomerResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicroabialAllCustomerResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedCustomerNameArrMicrobial = jsonObject.getAllCustomerNames(customerArray: jsonObject.customerArray ?? [])
        dropdownManager.sharedComplexMicroabial =  jsonObject.customerArray ?? []
        fetchHatcherySiteList()
    }
    
    private func fetchHatcherySiteList(){
        CoreDataHandlerMicro().deleteAllData("Micro_siteByCustomer")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcherySitesForMicrobial(controller: self, parameters:  [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchHatcherySiteResponse(json)
        })
    }
    
    private func handlefetchHatcherySiteResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicrobialAllHatchSiteResponse(json)
        print(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedHatcherySiteArrMicroabial = jsonObject.getAllHatchSiteNames(customerArray: jsonObject.responseArray ?? [])
        dropdownManager.sharedHatcherySiteMicroabial =  jsonObject.responseArray ?? []
        fetchHatcheryReviewerList()
    }
    
    private func fetchHatcheryReviewerList() {
        CoreDataHandlerMicro().deleteAllData("Micro_Reviewer")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcheryReviewerForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchHatcheryReviewerResponse(json)
        })
    }
    
    private func handlefetchHatcheryReviewerResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicrobialReviewGroupResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedHatcheryReviewerArrMicroabial =  jsonObject.getAllHatcheryReviewerNames(customerArray: jsonObject.reviewerResponseArray ?? [])
        dropdownManager.sharedHatcheryReviewerMicroabial =  jsonObject.reviewerResponseArray  ?? []
        fetchConductTypesList()
    }
    
    private func  fetchConductTypesList() {
        CoreDataHandlerMicro().deleteAllData("Micro_AllConductType")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcheryAllConductTypeForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handleConductTypeResponse(json)
        })
    }
    
    private func handleConductTypeResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicroabialAllConnductTypesResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedConductTypeArrMicrobial =  jsonObject.getAllConductType(customerArray: jsonObject.customerArray ?? [])
        dropdownManager.sharedHatcheryAllConductTypeMicroabial =  jsonObject.customerArray  ?? []
        fetchAllSurveyPurposeList()
    }
    
    private func  fetchAllSurveyPurposeList() {
        CoreDataHandlerMicro().deleteAllData("Micro_AllSurveyPurpose")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcheryAllSurveyPurposeForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchAllSurveyPurposeListResponse(json)
        })
    }
    
    private func handlefetchAllSurveyPurposeListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicobialAllsurveyPurposeResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllSurveyPurposeArrMicrobial =  jsonObject.getAllSurveyPurpose(customerArray: jsonObject.customerArray ?? [])
        dropdownManager.sharedHatcheryAllSurveyPurposeMicroabial =  jsonObject.customerArray  ?? []
        fetchAllMicrobialTransferTypeList()
    }
    
    
    private func fetchAllMicrobialTransferTypeList() {
        CoreDataHandlerMicro().deleteAllData("Micro_AllMicrobialTransferTypes")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcheryAllTransferTypeForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchAllMicrobialTransferTypeListResponse(json)
        })
    }
    
    private func handlefetchAllMicrobialTransferTypeListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicrobialAllMicrobialTransferTypesResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllMicrobialTransferTypeArrMicrobial =  jsonObject.getAllTransferTypeMicrobial(customerArray: jsonObject.customerArray ?? [])
        dropdownManager.sharedHatcheryAllMicrobialTransferTypeMicroabial =  jsonObject.customerArray  ?? []
        
        self.fetchAllLocationTypeList()
    }
    
    private func fetchAllLocationTypeList() {
        CoreDataHandlerMicro().deleteAllData("Microbial_EnvironmentalLocationTypes")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllEnvironmentalLocationTypes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            let jsonObject = EnvironmentalLocationTypeModel(json)
            let dropdownManager = ZoetisDropdownShared.sharedInstance
            dropdownManager.sharedAllEnvironmentalLocationTypeArray =  jsonObject.getAllLocationTypes(customerArray: jsonObject.locationTypeArray ?? [])
            
            // bacterial location types
            CoreDataHandlerMicro().deleteAllData("Microbial_BacterialLocationTypes")
            ZoetisWebServices.shared.getAllBacterialLocationTypes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let self = self, error == nil else { return }
                self.handleFetchedBacterialLocationTypeListResponse(json)
            })
        })
    }
    
    private func handleFetchedBacterialLocationTypeListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = BacterialLocationTypeModel(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllBacterialLocationTypeArray =  jsonObject.getAllLocationTypes(customerArray: jsonObject.locationTypeArray ?? [])
        
        self.fetchAllLocationTypeValuesList()
    }
    
    private func fetchAllLocationTypeValuesList() {
        CoreDataHandlerMicro().deleteAllData("Microbial_LocationValues")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllLocationTypeValues(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            print("your json  is : \(json)")
            self.handlefetchedAllLocationTypeValuesListResponse(json)
        })
    }
    
    
    private func handlefetchedAllLocationTypeValuesListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = LocationTypeValues(json)
        print("your json Object is : \(jsonObject)")
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllLocationTypeValuesArray =  jsonObject.getAllLocationTypes(array: jsonObject.locationValueArray ?? [])
        self.fetchAllMediaTypeList()
    }
    
    private func fetchAllMediaTypeList() {
        CoreDataHandlerMicro().deleteAllData("Microbial_AllMediaTypes")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllMediaTypeValues(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchedAllMediaTypeListResponse(json)
        })
    }
    
    private func handlefetchedAllMediaTypeListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MediaTypeResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllMediaTypeValuesArray =  jsonObject.getAllMediaTypes(mediaArray: jsonObject.mediaTypeValueArray ?? [])

        fetchAllSamplingMethodList()
    }
    private func fetchAllSamplingMethodList() {
        CoreDataHandlerMicro().deleteAllData("Microbial_SamplingMethodTypes")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllSamplingMethodValues(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchedAllSamplingMethodListResponse(json)
        })
    }
    
    private func handlefetchedAllSamplingMethodListResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = SamplingMethodTypeResponse(json)
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllSamplingMethodTypeValuesArray =  jsonObject.getAllSamplingMethodTypes(samplingArray: jsonObject.samplingMethodTypeValueArray ?? [])
        fetchAllMicrobialVisitType()
    }
    private func fetchAllMicrobialVisitType() {
        CoreDataHandlerMicro().deleteAllData("Micro_AllMicrobialVisitTypes")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllHatcheryAllVisitTypeForMicrobial(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlefetchAllMicrobialVisitTypeResponse(json)
        })
    }
    
    private func handlefetchAllMicrobialVisitTypeResponse(_ json: JSON) {
        dismissGlobalHUD(self.view)
        let jsonObject = MicrobialAllVisitTypeResponse(json)
        
        let dropdownManager = ZoetisDropdownShared.sharedInstance
        dropdownManager.sharedAllMicrobialVisitTypeArrMicrobial =  jsonObject.getAllVisitType(customerArray: jsonObject.customerArray ?? [])
        dropdownManager.sharedHatcheryAllMicrobialVisitTypeMicroabial =  jsonObject.customerArray  ?? []
        self.fetchAllMicrobialSpecimenTypes()
    }
    
    private func fetchAllMicrobialSpecimenTypes() {
        dismissGlobalHUD(self.view)
        CoreDataHandlerMicro().deleteAllData("MicrobialFeatherPulpSpecimenType")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllMicrobialSpecimenTypes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            print(json)
            let jsonObject = SpecimenTypeFeatherpulpModel(json)//LocationTypeValues(json)
            let dropdownManager = ZoetisDropdownShared.sharedInstance
            dropdownManager.sharedAllSpecimenTypeValuesArray =  jsonObject.getAllSpecimenTypes(array: jsonObject.specimenTypeArrayIs ?? [])
            self.fetchAllMicrobialBirdTypes()
        })
    }
    
    private func fetchAllMicrobialBirdTypes() {
        dismissGlobalHUD(self.view)
        CoreDataHandlerMicro().deleteAllData("MicrobialFeatherPulpBirdType")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllMicrobialBirdTypes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            print(json)
            let jsonObject = BirdTypeFeatherpulpModel(json)
            let dropdownManager = ZoetisDropdownShared.sharedInstance
            dropdownManager.sharedAllBirdTypeValuesArray =  jsonObject.getAllBirdTypes(array: jsonObject.birdTypeArray ?? [])
            self.fetchAllMicrobialFeatherPulpTest()
        })
    }
    
    private func fetchAllMicrobialFeatherPulpTest() {
        dismissGlobalHUD(self.view)
        CoreDataHandlerMicro().deleteAllData("MicrobialFeatherPulpTestOptions")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllMicrobialFeatherPulpTest(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            print(json)
            let jsonObject = MicrobialFeatherpulpTestModel(json)
            print(jsonObject)

            self.fetchAllCaseStatus()
        })
    }
    
    
    private func fetchAllCaseStatus() {
        dismissGlobalHUD(self.view)
        CoreDataHandlerMicro().deleteAllData("MicrobialCaseStatus")
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        ZoetisWebServices.shared.getAllCaseStatus(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            print(json)
            let jsonObject = MicrobialCaseStatusModel(json)
            print(jsonObject)

            self.fetchGetAllSyncedDataForRequisition()
        })
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.requisitionBtnView.bounds
        gradientLayer.colors = [UIColor(red: 15/255.0, green: 117/255.0, blue: 187/255.0, alpha: 1.0), UIColor(red: 57/255.0, green: 196/255.0, blue: 245/255.0, alpha: 1.0)]
        self.requisitionBtnView.layer.addSublayer(gradientLayer)
    }
    
}


//MARK: - SetUp Pie Charts
extension MicrobialViewController {
    
    fileprivate func checkForSubmittedOrSaveAsDraftDataCount_Bacterial() -> (draftRequisitionCount: Int, submittedRequisitionCount: Double, releasedCount: Double) {
        
            let bacterialsaveAsDraftRequisitions = Microbial_EnviromentalSurveyFormSubmitted.fetchSubmittedOrSaveAsDraftRequisitionsForGraphs(sessionStatus: SessionStatus.saveAsDraft.rawValue, requisitionType: RequisitionType.bacterial.rawValue)
            let bacterialsubmittedRequisitions = Microbial_EnviromentalSurveyFormSubmitted.fetchSubmittedOrSaveAsDraftRequisitionsForGraphs(sessionStatus: SessionStatus.submitted.rawValue, requisitionType: RequisitionType.bacterial.rawValue) as? [Microbial_EnviromentalSurveyFormSubmitted]
        var submittedReleasedReqCount = 0
        if let totalData = bacterialsubmittedRequisitions{
            submittedReleasedReqCount = totalData.filter{ ($0.reqStatus?.intValue ?? 0) == releaseReqId }.count
        }
        return (bacterialsaveAsDraftRequisitions.count, Double(bacterialsubmittedRequisitions?.count ?? 0), releasedCount: Double(submittedReleasedReqCount))
        }
    
    fileprivate func checkForSubmittedOrSaveAsDraftDataCount_Enviromental() -> (draftRequisitionCount: Int, submittedRequisitionCount: Double, releasedCount: Double) {

        let saveAsDraftRequisitions = Microbial_EnviromentalSurveyFormSubmitted.fetchSubmittedOrSaveAsDraftRequisitionsForGraphs(sessionStatus: SessionStatus.saveAsDraft.rawValue, requisitionType: RequisitionType.enviromental.rawValue)
        let submittedRequisitions = Microbial_EnviromentalSurveyFormSubmitted.fetchSubmittedOrSaveAsDraftRequisitionsForGraphs(sessionStatus: SessionStatus.submitted.rawValue, requisitionType: RequisitionType.enviromental.rawValue) as? [Microbial_EnviromentalSurveyFormSubmitted]
        
        var submittedReleasedReqCount = 0
        if let totalData = submittedRequisitions{
            submittedReleasedReqCount = totalData.filter{ ($0.reqStatus?.intValue ?? 0) == releaseReqId }.count
        }

        return (saveAsDraftRequisitions.count, Double(submittedRequisitions?.count ?? 0), releasedCount: Double(submittedReleasedReqCount))
    }

    
    fileprivate func configureGraphViews() {
        
        let (bacterialsaveAsDraftRequisitions, bacterialsubmittedRequisitions, releasedBacterialCount) = self.checkForSubmittedOrSaveAsDraftDataCount_Bacterial()
        let (enviromentalDraftRequisitionCount, enviromentalSubmittedRequisitionCount, releasedEnvCount) =  self.checkForSubmittedOrSaveAsDraftDataCount_Enviromental()
       /// let (featherPulpSaveAsDraftRequisitions, featherPulpSubmittedRequisitions, releasedFeatherpulpCount) = self.checkForSubmittedOrSaveAsDraftDataCount_feathure()
        
        let totalSubmittedRequisition = Int(enviromentalSubmittedRequisitionCount) + Int(bacterialsubmittedRequisitions)
        //+ Int(featherPulpSubmittedRequisitions)
        let totalDraftRequisition = Int(enviromentalDraftRequisitionCount) + bacterialsaveAsDraftRequisitions
        //+ featherPulpSaveAsDraftRequisitions
        
        let syncCount = Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.bacterial.rawValue).count + Microbial_EnviromentalSurveyFormSubmitted.dataToBeSynced(requisitionType: RequisitionType.enviromental.rawValue).count

        self.syncBadgeBackgroundView.isHidden = (syncCount == 0)
        self.syncCountLbl.text = "\(syncCount)"
        self.draftCountLbl.text = "\(totalDraftRequisition)"
        
        if totalSubmittedRequisition > 0 && Int(bacterialsubmittedRequisitions) > 0 {
            self.setUpPieChart(pieChartView: piechartViewBacterial, data: [releasedBacterialCount, (bacterialsubmittedRequisitions - releasedBacterialCount)], count: Int(bacterialsubmittedRequisitions), requisitionType: "Bacterial")
        } else {
            self.setUpPieChart(pieChartView: piechartViewBacterial, data: [], count: Int(bacterialsubmittedRequisitions), requisitionType: "Bacterial")
        }
        
        if totalSubmittedRequisition > 0 && Int(enviromentalSubmittedRequisitionCount) > 0 {
            self.setUpPieChart(pieChartView: piechartViewEnviromental, data: [releasedEnvCount, (enviromentalSubmittedRequisitionCount - releasedEnvCount)], count: Int(enviromentalSubmittedRequisitionCount), requisitionType: "Environmental")
        } else {
            self.setUpPieChart(pieChartView: piechartViewEnviromental, data: [], count: Int(enviromentalSubmittedRequisitionCount), requisitionType: "Environmental")
        }
        
    }
    
    func setUpPieChart(pieChartView: PieChartView, data: [Double], count: Int, requisitionType: String) {
        
        var entries = [PieChartDataEntry]()
        for (_, value) in data.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = (value == 0.0) ? "" : "\(value)"
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "Pie Chart")
        set.drawValuesEnabled = false
        
        let orangeColor = UIColor(red: 242/255, green: 99/255, blue: 35/255, alpha: 1)
        let blueColor = UIColor(red: 16/255, green: 121/255, blue: 202/255, alpha: 1)
        set.colors = [orangeColor, blueColor]
        
        let pieChartData = PieChartData(dataSet: set)
        
        pieChartView.data = pieChartData
        pieChartView.noDataText = "No chart data available"
        pieChartView.isUserInteractionEnabled = false
        
        let d = Description()
        d.text = ""
        pieChartView.chartDescription = d
        pieChartView.centerText = ""
        pieChartView.holeRadiusPercent = 0.80
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChartView.backgroundColor = .clear
        pieChartView.holeColor = UIColor.clear
        pieChartView.legend.enabled = false
        
        if data.count > 0 {
            pieChartView.centerAttributedText = self.getChartCenterTextAttributed(count: "\(count)\n", requisitionType: requisitionType)
        } else {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.firstLineHeadIndent = 0
            
            let tolatCountAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            let noData = NSMutableAttributedString(string: "No chart data available", attributes: tolatCountAttributes)
            pieChartView.centerAttributedText = noData
        }
        
    }
    
    
    func getChartCenterTextAttributed(count: String, requisitionType: String) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.firstLineHeadIndent = 0
        
        let tolatCountAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 35),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        let tolatCountAttrString = NSMutableAttributedString(string: "\(count)\n", attributes: tolatCountAttributes)
        
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.alignment = .center
        paragraphStyle2.firstLineHeadIndent = 0
        let requisitionTypeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle2
        ]
        
        let requisitionTypeAttrString = NSAttributedString(string: "\(requisitionType)\n", attributes: requisitionTypeAttributes)
        
        var lastString = ""
        if requisitionType == "Bacterial" || requisitionType == "Environmental" {
            lastString = "Survey"
        } else {
            lastString = "Pulp"
        }
        
        
        let paragraphStyle3 = NSMutableParagraphStyle()
        paragraphStyle3.alignment = .center
        paragraphStyle3.firstLineHeadIndent = 0
        let lastStringAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle3
        ]
        
        let lastStringAttrString = NSAttributedString(string: lastString, attributes: lastStringAttributes)
        
        tolatCountAttrString.append(requisitionTypeAttrString)
        tolatCountAttrString.append(lastStringAttrString)
        return tolatCountAttrString
    }
}



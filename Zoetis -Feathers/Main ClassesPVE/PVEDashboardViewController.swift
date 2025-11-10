//
//  PVEDashboardViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 09/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import Charts
import SwiftyJSON
import Reachability
import Gigya
import GigyaTfa
import GigyaAuth

class PVEDashboardViewController: BaseViewController, URLSessionDelegate {
    
    let sharedManager = PVEShared.sharedInstance
    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var gradientViewBelowGraph: GradientButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var draftView: UIView!
    @IBOutlet weak var draftLable : UILabel!
    @IBOutlet weak var draftCountImg : UIImageView!
    @IBOutlet weak var recentDateLbl : UILabel!
    @IBOutlet weak var recentDetailsLbl : UILabel!
    @IBOutlet weak var previousDateLbl : UILabel!
    @IBOutlet weak var previousDetailsLbl : UILabel!
    @IBOutlet weak var noBarChartLeftDataLbl : UILabel!
    @IBOutlet weak var noBarChartDataRightLbl : UILabel!
    @IBOutlet weak var chartHeader: UIImageView!
    @IBOutlet weak var dateLeftLbl : UILabel!
    @IBOutlet weak var dateRightLbl : UILabel!
    
    @IBOutlet weak var buttonMenu: UIButton!
    var currentSelectedModule = String()
    @IBOutlet weak var barChartLeft: BarChartView!
    @IBOutlet weak var barChartRight: BarChartView!
    
    var recivedDataArray = NSMutableArray()
    let customLegends = UIImageView()
    var headerTitle: NSString?
    var subjectString = NSString()
    let chartNameLable = UILabel()
    var pdfURL: URL?
    var isSync : Bool = false
    var isToastShown : Bool = false
    var isResponseCalled : Bool = false
    var isLogoutTapped : Bool = false
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    
    @IBOutlet weak var timerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var msgLblHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupHeader()
        setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dashboardRefresh(notification:)), name: Notification.Name("UpdateComplexOnDashboardForPVE"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dashboardOnGoingBegin(notification:)), name: Notification.Name("dashboardOnGoingBeginNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.syncBtnTappedNoti(notification:)), name: Notification.Name("syncDataNoti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(forceSyncSingleData), name: Notification.Name("forceSync"), object: nil)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap1.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap1)
        
        let getApiCalled = UserDefaults.standard.bool(forKey:"getApiCalled")
        
        if getApiCalled == false{
            UserDefaults.standard.set(true, forKey: "callDraftApi")
        }
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleAppEnteredForeground),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
      
        timerView.layer.cornerRadius = 18
        timerView.layer.masksToBounds = true
        timerView.layer.borderColor = UIColor.lightGray.cgColor
        timerView.layer.borderWidth = 1.0
        timerView.clipsToBounds = true
        
        self.sessionTimer()
        
    }
    
    func sessionTimer() {
        TimeManager.shared.startSession()
        
        TimeManager.shared.onTick = { timeString in
            self.sessionLabel.text = timeString
        }
        
        // Handle session expiration
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        TimeManager.shared.onSessionExpired = {
            self.timerView.isHidden = true
            self.crossBtn.isHidden = true
            self.showSessionExpiredAlert(showLogoutButton: true) // change of plan in the functionality we want to show data sync available popup when user clik on logout button.
            
            
        }
        /*
        // Optional: handle 2-day warning alert
        TimeManager.shared.onTwoDayWarning = {
            self.timerView.isHidden = false
            self.crossBtn.isHidden = false
            if syncArr.count != 0
            {
                self.okBtn.isUserInteractionEnabled = true
                self.okBtn.isHidden = false
                self.logoutBtn.isUserInteractionEnabled = false
                self.logoutBtn.isHidden = true
                self.timerHeightConstraint.constant = 232
                self.msgLblHeightConstraint.constant = 100
                self.msgLabel.text =  "You currently have an active session.\nPlease ensure all data is synced to avoid any potential data loss.\nYour session will expire in."
            }
            else
            {
              
                self.timerHeightConstraint.constant = 220
                self.msgLblHeightConstraint.constant = 80
                self.okBtn.isUserInteractionEnabled = false
                self.okBtn.isHidden = true
                self.logoutBtn.isUserInteractionEnabled = true
                self.logoutBtn.isHidden = false
                self.msgLabel.text =  "No active session is available for posting.\nPlease log out.\nYour session will expire in."
            }
        }
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleAppEnteredForeground() {
        sessionTimer()
    }
    deinit {
          NotificationCenter.default.removeObserver(
              self,
              name: UIApplication.willEnterForegroundNotification,
              object: nil
          )
      }
    
    func showSessionExpiredAlert(showLogoutButton: Bool) {
        let messageText: String
        messageText = Constants.dontHaveSessionToPostMessage


        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

        // MARK: - Attributed Title
        let titleFont: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
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
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        
        if syncArr.count > 0
        {
            self.showOKAlert(title:  "⚠️\nAlert!", message: Constants.stillHaveActiveSessionMessage)
            
          //  self.showOKAlert(title: "⚠️ Alert!", message: Constants.stillHaveActiveSessionMessage)

            return
        }
        else
        {
            ViewController.clearDataBeforeLogout()
            TimeManager.shared.performAutoLogout()
        }
        
//
        
    }
    

    
    func showOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func btnOntimerAction(_ sender: Any) {
        self.crossBtn.isHidden = true
        self.timerView.isHidden = true
    }
    func failWithInternetConnection()
    {
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
    @IBAction func timmerBtnLogoutAction(_ sender: Any) {
        if WebClass.sharedInstance.connected() {
            TimeManager.shared.performAutoLogout()
        }
        else
        {
            self.failWithInternetConnection()
        }
    }

    @objc func forceSyncSingleData(notification:NSNotification) {
     
        if let userInfo = notification.userInfo as? [String: String], let assId = userInfo["id"] {
            self.singleDataSync(id: assId)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func dashboardRefresh(notification: NSNotification){
        CoreDataHandler().deleteAllData("PVE_CustomerComplexPopup")
        
        let getPVE_CustomerComplexPopupDetails = (CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup"))
        
        if getPVE_CustomerComplexPopupDetails.count == 0{
            addComplexPopup()
        }
        
        peHeaderViewController.onGoingSessionView.isHidden = true
        
        barChartLeft.isHidden = true
        barChartRight.isHidden = true
        noBarChartLeftDataLbl.isHidden = false
        noBarChartDataRightLbl.isHidden = false
        dateLeftLbl.isHidden = true
        dateRightLbl.isHidden = true
        
        
    }
    
    @objc private func dashboardOnGoingBegin(notification: NSNotification){
        
        peHeaderViewController.killSessionBtn.isHidden = false
        peHeaderViewController.onGoingSessionView.isHidden = false
        viewWillAppear(false)
        
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.delegate = self
        
        peHeaderViewController.titleOfHeader = "Pullet Vaccine Evaluation"
        
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
        
    }
    
    func setUI(){
        DispatchQueue.main.async
        {
            self.gradientViewBelowGraph.setGradient(topGradientColor: UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isSync = false
        self.isLogoutTapped = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        if (UserDefaults.standard.value(forKey: "isSession") as? Bool) == true{
            peHeaderViewController.killSessionBtn.isHidden = false
        }
        let getPVE_CustomerComplexPopupDetails = (CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_CustomerComplexPopup"))
        let currentLoggedInUserForPopup = CoreDataHandlerPVE().fetchAllUserSavedDataInComplexPopup()
        if getPVE_CustomerComplexPopupDetails.count == 0 || currentLoggedInUserForPopup.count == 0{
            addComplexPopup()
        } else {
            peHeaderViewController.onGoingSessionView.isHidden = false
            let isAppTerminated = UserDefaults.standard.value(forKey: "isAppTerminated") as? Bool
            if isAppTerminated == true {
                Constants.syncToWebTapped = false
                UserDefaults.standard.set(false, forKey: "isAppTerminated")
            }
            if !Constants.syncToWebTapped && isLogoutTapped == true {
                checkDataForSync(isNotification: false)
                
            } else {
                if Constants.syncToWebTapped == false {
                    self.checkDataForSyncViewDidAppear()
                }
            }
        }
        
        let IdPrev = UserDefaults.standard.value(forKey:"IdPrev") as? Int ?? 0
        let currentUserId = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
       
        if (currentUserId != IdPrev) && IdPrev != 0 {
            
            UserDefaults.standard.set(0, forKey: "IdPrev")
            CoreDataHandler().deleteAllData("PVE_CustomerComplexPopup")
            CoreDataHandler().deleteAllData("Customer_PVE")
        }

        setSyncDraftCountLabel()
        drawPVEBarChart()
    }
    
    private func checkDataForSyncViewDidAppear() {
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        if ConnectionManager.shared.hasConnectivity() && syncArr.count > 0 {
            let errorMSg = "Data available for sync, Do you want to sync now?"
            let alertController = UIAlertController(title: Constants.dataAvailableStr, message: errorMSg, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.syncBtnTapped()
            }
            alertController.addAction(okAction)

            let cancelAction = UIAlertAction(title: Constants.noStr.isEmpty ? "No" : Constants.noStr, style: .cancel) { _ in
                print("Cancel tapped")
                self.sessionTimer() // Alert dismisses automatically
            }
            alertController.addAction(cancelAction) // ✅ This was missing

            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    
    func setSyncDraftCountLabel() {
        let PVE_Draft = CoreDataHandlerPVE().fetchDetailsForTypeOfData(type: "draft")
        draftLable.text = "\(PVE_Draft.count)"
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        peHeaderViewController.labelSyncCount.text = "\(syncArr.count)"
        peHeaderViewController.syncView.isHidden = false
        
        refreshCountHideUnhide()
    }
    
    func setSyncDraftCountLabelFinalAssessed() {
        let PVE_Draft = CoreDataHandlerPVE().fetchDetailsForTypeOfData(type: "draft")
        draftLable.text = "\(PVE_Draft.count)"
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        peHeaderViewController.labelSyncCount.text = "\(syncArr.count)"
        peHeaderViewController.syncView.isHidden = false
        
        if !Constants.syncToWebTapped {
            if syncArr.count > 0 {
                self.isSync = false
                self.syncBtnTapped()
                
            } else {
                if !isToastShown {
                    self.isToastShown = true
                    showToastWithTimer(message: Constants.dataSyncCompleted, duration: 4.0)
                }
                DispatchQueue.main.async {
                    self.dismissGlobalHUD(self.view)
                    self.stopHud()
                }
                self.refreshCountHideUnhide()
            }
        } else {
            Constants.syncToWebTapped = false
            self.dismissGlobalHUD(self.view)
            self.stopHud()
            self.refreshCountHideUnhide()
            showToastWithTimer(message: Constants.dataSyncCompleted, duration: 4.0)
        }
    }
    
    func refreshCountHideUnhide(){
        
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        
        if  syncArr.count  > 0 {
            peHeaderViewController.labelSyncCount.isHidden = false
            peHeaderViewController.syncCountImg.isHidden = false
        } else {
            peHeaderViewController.labelSyncCount.isHidden = true
            peHeaderViewController.syncCountImg.isHidden = true
        }
        
        let PVE_Draft = CoreDataHandlerPVE().fetchDetailsForTypeOfData(type: "draft")
        if  PVE_Draft.count  > 0 {
            draftCountImg.isHidden = false
            draftLable.isHidden = false
        }else {
            draftCountImg.isHidden = true
            draftLable.isHidden = true
        }
        
        
        
    }
    
    func drawPVEBarChart() {
        
        let arrPVE_Sync = CoreDataHandlerPVE().fetchDetailsForTypeOfData(type: "sync")
        if arrPVE_Sync.count > 0{
            let getDataToSyncInDBArr = CoreDataHandlerPVE().getDataToSyncInDB(type: "sync")
            //   print("getDataToSyncInDB--\(getDataToSyncInDBArr)")
            
            // chartHeader.isHidden = true
            barChartLeft.isHidden = true
            barChartRight.isHidden = true
            noBarChartLeftDataLbl.isHidden = false
            noBarChartDataRightLbl.isHidden = false
            
            recentDateLbl.text = ""
            recentDetailsLbl.text = ""
            
            previousDateLbl.text = ""
            previousDetailsLbl.text = ""
            
            dateLeftLbl.isHidden = true
            dateRightLbl.isHidden = true
            
            
            
            if getDataToSyncInDBArr.count > 0 {
                barChartLeft.isHidden = false
                noBarChartLeftDataLbl.isHidden = true
                //barChartRight.isHidden = false
                createChart(chartDatsArr: getDataToSyncInDBArr)
                
            }
            if getDataToSyncInDBArr.count > 1{
                barChartLeft.isHidden = false
                barChartRight.isHidden = false
                noBarChartLeftDataLbl.isHidden = true
                noBarChartDataRightLbl.isHidden = true
                createChart(chartDatsArr: getDataToSyncInDBArr)
                createChart2(chartDatsArr: getDataToSyncInDBArr)
            }
        }
        
        
        if barChartLeft.isHidden && barChartRight.isHidden{
            dateLeftLbl.isHidden = false
            
            let PVE_UserInfo = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_UserInfo")
            if PVE_UserInfo.count > 0{
                let customerStr = (PVE_UserInfo[0] as AnyObject).value(forKey: "customer")  as? String
                let siteNameStr = (PVE_UserInfo[0] as AnyObject).value(forKey: "complexName")  as? String
                recentDateLbl.text = "\(customerStr ?? "") - \(siteNameStr ?? "")"
                
                dateLeftLbl.isHidden = true
                dateRightLbl.isHidden = true
                
            }
        }
        
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
        
    }
    
    @IBAction func startNewAssessmentBtnAction(_ sender: Any) {
        Constants.syncToWebTapped = false
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEStartNewAssessment") as! PVEStartNewAssessment
        navigationController?.pushViewController(vc, animated: true)
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func viewAssessmentBtnAction(_ sender: Any) {
        Constants.syncToWebTapped = false
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVESessionViewController") as! PVESessionViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.view.endEditing(true)
        
        
    }
    
    @IBAction func draftBtnAction(_ sender: Any) {
        Constants.syncToWebTapped = false
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEDraftViewController") as! PVEDraftViewController
        navigationController?.pushViewController(vc, animated: true)
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func logOutBtnAction(_ sender: Any) {
        addComplexPopup()
    }
    
    // MARK: Download Blank PDF File in iPad Device .
    @IBAction func downloadPdfBtnAction(_ sender: Any) {
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable {
            
            let baseURL = Constants.Api.pveBaseUrl
            let userInput = "/PDF/SummaryReport.pdf"

            // Safely construct the URL
            if let sanitizedURL = URL(string: baseURL)?.appendingPathComponent(userInput) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "BlankPDFViewController") as! BlankPDFViewController
                vc.pdfURL = sanitizedURL
                vc.modalPresentationStyle = .currentContext
                self.present(vc, animated: false, completion: nil)
            } else {
                debugPrint("Invalid URL")
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to view PDF.", comment: ""))
        }
    }
    
    func loadingUrl(url: URL,  to localURl: URL) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request){(tempLocalUrl , responce , error) in
            if let tempLocalUrl = tempLocalUrl , error == nil {
                if (responce as? HTTPURLResponse)?.statusCode != nil {
                    DispatchQueue.main.async {
                        print("PDF successfully saved!")
                        self.showtoast(message: "PDF Downloaded Successfully..")
                    }
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localURl)
                }
                catch(let writeError){
                    print("error Writting Files\(localURl) : \(writeError)")
                }
            }
        }
        task.resume()
    }
    
    func addComplexPopup() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ComplexPoupVC") as? ComplexPoupViewController
        vc?.currentSelectedModule = Constants.Module.breeder_PVE
        vc?.delegate = self
        navigationController?.present(vc!, animated: false, completion: nil)
    }
}

extension PVEDashboardViewController: ChartViewDelegate, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "formateStr"
    }
    
    func createChart(chartDatsArr:NSArray) {
        let scoreArray = (chartDatsArr[0] as AnyObject).value(forKey: "scoreArray")  as? [Double] ?? []
        let catArray = (chartDatsArr[0] as AnyObject).value(forKey: "categoryArray")  as? [String] ?? []
        let maxScoreArray = (chartDatsArr[0] as AnyObject).value(forKey: "maxScoreArray")  as? [Double] ?? []
        let customerStr = (chartDatsArr[0] as AnyObject).value(forKey: "customer")  as? String ?? ""
        let complexStr = (chartDatsArr[0] as AnyObject).value(forKey: "complexName")  as? String ?? ""
        let dateCreated = (chartDatsArr[0] as AnyObject).value(forKey: "evaluationDate")  as? String ?? ""
        
        recentDateLbl.text = "\(customerStr) - \(complexStr)"
        dateLeftLbl.text = "\(dateCreated)"
        dateLeftLbl.isHidden = false
        
        barChartLeft.delegate = self
        barChartLeft.xAxis.valueFormatter = self
        barChartLeft.xAxis.labelPosition = .bottom
        barChartLeft.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        let categoriesArray = catArray
        var dataPoints : [String] = []
        
        if categoriesArray.count > 0 {
            for (ind, obj) in categoriesArray.enumerated() {
                let name = obj
                var data = changeStringToArrayLevel3(name:name)
                data = data + "(" + "\(maxScoreArray[ind])" + ")"
                dataPoints.append(data)
            }
        }
        
        setChart(values: scoreArray, dataPoints:dataPoints, barChart: barChartLeft)
    }
    
    func createChart2(chartDatsArr:NSArray) {
        
        let scoreArray = (chartDatsArr[1] as AnyObject).value(forKey: "scoreArray")  as? [Double] ?? []
        let catArray = (chartDatsArr[1] as AnyObject).value(forKey: "categoryArray")  as? [String] ?? []
        let maxScoreArray = (chartDatsArr[1] as AnyObject).value(forKey: "maxScoreArray")  as? [Double] ?? []
        let customerStr = (chartDatsArr[1] as AnyObject).value(forKey: "customer")  as? String ?? ""
        let complexStr = (chartDatsArr[1] as AnyObject).value(forKey: "complexName")  as? String ?? ""
        let dateCreated = (chartDatsArr[1] as AnyObject).value(forKey: "evaluationDate")  as? String ?? ""
        
        previousDateLbl.text = "\(customerStr) - \(complexStr)"
        dateRightLbl.isHidden = false
        dateRightLbl.text = "\(dateCreated)"
        
        barChartRight.delegate = self
        barChartRight.xAxis.valueFormatter = self
        barChartRight.xAxis.labelPosition = .bottom
        barChartRight.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        var categoriesArray = catArray
        var dataPoints : [String] = []
        if categoriesArray.count > 0 {
            for (ind, obj) in categoriesArray.enumerated() {
                let name = obj
                var data = changeStringToArrayLevel3(name: name)
                
                if ind < maxScoreArray.count {
                    data += "(\(maxScoreArray[ind]))"
                } else {
                    data += "0" 
                }
                
                dataPoints.append(data)
            }
        }

 /*
        if categoriesArray.count > 0 {
            for (ind, obj) in categoriesArray.enumerated() {
                let name = obj
                var data = changeStringToArrayLevel3(name:name)
                data = data + "(" + "\(maxScoreArray[ind])" + ")"
                dataPoints.append(data)
            }
        }
   */
        setChart(values: scoreArray, dataPoints:dataPoints, barChart: barChartRight)
        
    }
    func setChart(values: [Double],dataPoints:[String],barChart:BarChartView) {
        barChart.noDataText = "You need to provide data for the chart."
        
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        chartData.label = "Assessments Result"
        let myBlueColor =   NSUIColor(red: 64/255.0, green: 126/255.0, blue: 201/255.0, alpha: 1.0)
        
        chartData.setColor(myBlueColor)
        barChart.delegate = self
        barChart.xAxis.valueFormatter = self
        barChart.xAxis.labelPosition = .bottom
        barChart.leftAxis.axisMinimum = 0
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChart.data = BarChartData(dataSet: chartData)
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        barChart.xAxis.wordWrapEnabled = true
        barChart.xAxis.labelRotationAngle = 0
        barChart.xAxis.granularity = 1
        barChart.xAxis.granularityEnabled = true
        
        
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
    
    private func changeStringToArrayLevel3(name:String) -> String {
        
        let tempName = name.replacingOccurrences(of: "&", with: "")
        var fullNameArr = tempName.split{$0 == " "}.map(String.init)
        var fullName1 = ""
        var fullName3 = ""
        var fullName2 = ""
        if 0 < fullNameArr.count {
            fullName1 = fullNameArr[0]
        }
        if 1 < fullNameArr.count {
            fullName2 = fullNameArr[1]
        }
        if 2 < fullNameArr.count {
            fullName3 = fullNameArr[2]
        }
        let data = fullName1 + "\n" + fullName2 + "\n" + fullName3
        return data
    }
    
    func sortFunc(_ num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
}

extension PVEDashboardViewController: SyncBtnDelegate,UnsyncedDelegate {
    func longPress() {
        print("long press")
        let syncArr = CoreDataHandlerPVE().fetchDataForSync()
        let popupVC = ExportLogsViewController()
        popupVC.delegateUnsynced = self
        popupVC.pveAssessmentSynArray = syncArr
        popupVC.isPE = false
        popupVC.modalPresentationStyle = .formSheet
        present(popupVC, animated: true, completion: nil)
    }
    
    func exportTapped(index: Int) {
        print(index)
        createJsonForExportPVE(index: index)
    }
    
    private func createJsonForExportPVE(index:Int) {
        let syncArr = CoreDataHandlerPVE().fetchDataForSync()
        if syncArr.count > 0 {
            guard index >= 0, index < syncArr.count else {
                print("Index out of bounds")
                return
            }
            
            let val = syncArr[index] as AnyObject
            let dict = val as AnyObject
            let json = createSyncRequest(dict: dict)
            let currentAssessmentQuestJson = getQuestionsDetails(dict: val as AnyObject)
            let forImgArrJson = getImageDetails(dict: val as AnyObject)
            
            let syncId = json["syncId"] as! String
            
            let tempArr = [json]
            let jsonDict = ["AssessmentDataDetails" : tempArr,"AssessmentScoresDataDetails":currentAssessmentQuestJson]
            let createdAt = (dict).value(forKey: "createdAt") as? String
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                if let status = EmailReportManager.shared.sendEmailReport(dataToAttach: jsonData,from: self, assessmentId:syncId,date: createdAt, isPE: false), !status.0 {
                    if let filePath = status.1 {
                        print(filePath)
                    }
                }
            } catch {
                print("Error converting merged dictionary to JSON: \(error)")
                showAlert(title: "Error", message: "Failed to convert data to JSON.", owner: self)
            }
        }
    }
    
    private func addWebKitView(_ fileUrl:URL) {
        let webVC = WebViewController()
        webVC.fileUrl = fileUrl
        present(webVC, animated: true, completion: nil)
    }
    
    
    func checkDataForSync(isNotification:Bool) {
        
        let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable {
            
            if syncArr.count > 0 {
                let errorMSg = Constants.informDataSync
                let alertController = UIAlertController(title: "⚠️ Alert!", message: errorMSg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                    _ in
                    self.askForDataSync()
                }
                let cancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.cancel) {
                    _ in
                    self.forceSyncMessage()
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                if isNotification == true {
                    self.logoutAction()
                }
            }
        } else {
            if isNotification == true {
                self.logoutAction()
            }
        }
    }
    
    func askForDataSync() {
        let errorMSg = Constants.askForDataSync
        let alertController = UIAlertController(title: Constants.dataAvailableStr, message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.syncBtnTapped()
        }
        let cancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.cancel) {
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
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc private func syncBtnTappedNoti(notification: NSNotification) {
        self.isLogoutTapped = true
        checkDataForSync(isNotification: true)
    }
    
    fileprivate func extractedFunc(_ syncData: NSArray) {
        for (_, val) in syncData.enumerated() {
            
            let json = createSyncRequest(dict: val as AnyObject)
            let currentAssessmentQuestJson = getQuestionsDetails(dict: val as AnyObject)
            let forImgArrJson = getImageDetails(dict: val as AnyObject)
            
            let syncId = json["syncId"] as! String
            let tempArr = [json]
            let jsonDict = ["AssessmentDataDetails" : tempArr]
            
            ZoetisWebServices.shared.postStartNewAssessmentDetailForPVE(controller: self, parameters: jsonDict, completion: { [weak self] (json, error) in
                guard let selfObject = self, error == nil else { return }
              //  selfObject.stopHud()
                selfObject.isResponseCalled = false
                selfObject.handleSyncResponse(json, syncId: syncId, assessmentScoreDict: currentAssessmentQuestJson, forImgArrJson: forImgArrJson)
            })
        }
    }
    
    func singleDataSync(id: String) {
        Constants.liveComment = ""
        Constants.inactiveComment = ""
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            let syncData = CoreDataHandlerPVE().fetchSingleDataForSync(id: id)
            if syncData.count > 0 {
           
                self.showGlobalProgressHUDWithTitle(self.view, title: "Data sync is in progress, please do not close the app.")
                extractedFunc(syncData)
                showtoast(message: "Data syncing")
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
        }
    }
    
    fileprivate func extractedFunc1(_ syncArr: NSArray) {
        for (_, val) in syncArr.enumerated() {
            if !isSync {
                self.isSync = true
                let json = createSyncRequest(dict: val as AnyObject)
                let currentAssessmentQuestJson = getQuestionsDetails(dict: val as AnyObject)
                let forImgArrJson = getImageDetails(dict: val as AnyObject)

                let syncId = json["syncId"] as! String

                let tempArr = [json]
                let jsonDict = ["AssessmentDataDetails" : tempArr]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Assessment's Details JSON - " , jsonString)
                }
                
                ZoetisWebServices.shared.postStartNewAssessmentDetailForPVE(controller: self, parameters: jsonDict, completion: { [weak self] (json, error) in
                    guard let selfObject = self, error == nil else { return }
                    selfObject.isResponseCalled = false
                    selfObject.handleSyncResponse(json, syncId: syncId, assessmentScoreDict: currentAssessmentQuestJson, forImgArrJson: forImgArrJson)
                })
            }
        }
    }
    
    func syncBtnTapped() {
        Constants.syncToWebTapped = false
        self.isLogoutTapped = false
        Constants.liveComment = ""
        Constants.inactiveComment = ""
      
        
        if ConnectionManager.shared.hasConnectivity() {
            let syncArr = CoreDataHandlerPVE().fetchDataForSync()
            if syncArr.count > 0{
                dismissGlobalHUD(self.view)
                self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.dataSyncInProgressStr + "\n" + Constants.noMinimizeWhileSyncing)
                extractedFunc1(syncArr)
            }
        }
        
        else {
           Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
       }
        
    }
    
    private func handleSyncResponse(_ json: JSON,  syncId:String, assessmentScoreDict: [[String: Any]], forImgArrJson:[[String: Any]]) {
        if json["StatusCode"] == 200 {
            var jsonDict = ["AssessmentScoresDataDetails" : assessmentScoreDict]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Score JSON - " , jsonString)
            }
            
            ZoetisWebServices.shared.postScoreDetailsForPVE(controller: self, parameters: jsonDict, completion: { [weak self] (json, error) in
                guard let selfObject = self, error == nil else { return }
                selfObject.stopHud()
                selfObject.handleSyncScoreResponse(json, syncId: syncId, forImgArrJson: forImgArrJson)
            })
        } else {

            self.stopHud()
//            self.showAlert(title: "Error", message: "\(json["DisplayMessage"])", owner: self)
            
            self.isSync = false
                       self.stopHud()
                       self.stopLoader()
                       self.dismissGlobalHUD(self.view)
                      let statusCode = json["StatusCode"].int ?? 405
                      let alertHandler = PVEAlertShow()
                      let apiAlertMessage = alertHandler.alertMessage(for: statusCode)
                      
                      self.showAlert(title: "Error", message: apiAlertMessage, owner: self)
            
        }
    }
    
    fileprivate func extractedFunc2(_ tempImgArrDict: [[String : Any]], _ syncId: String) {
        for (_, obj) in tempImgArrDict.enumerated() {
            
            self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.dataSyncInProgressStr + "\n" + Constants.noMinimizeWhileSyncing)
            ZoetisWebServices.shared.postSaveAssessmentImagesDetailsForPVE(controller: self, parameters: obj, completion: { [weak self] (json, error) in
                guard let selfObject = self, error == nil else { return }
                if selfObject.isResponseCalled == false {
                    selfObject.isResponseCalled = true
                    selfObject.handleImageSyncResponse(json, syncId: syncId)
                }
            })
        }
    }
    
    fileprivate func extractedFunc3(_ chunkArr: [[Int]], _ ModuleAssessmentIdArrrrr: inout [Int], _ forImgArrJson: [[String : Any]], _ tempImgArrDict: inout [[String : Any]]) {
        for (_, indArr) in chunkArr.enumerated() {
            var chunkImgArrToSend = [[String : Any]]()
            for (_, obj) in indArr.enumerated() {
                ModuleAssessmentIdArrrrr.append(forImgArrJson[obj-1]["ModuleAssessmentId"] as! Int)
                chunkImgArrToSend.append(forImgArrJson[obj-1])
                CoreDataHandlerPVE().updateStatusSyncImageDataInAssementDetails(forImgArrJson[obj-1]["imgSyncId"] as! String)
            }
            let jsonDict = ["AssessmentQuestionImages" : chunkImgArrToSend]
            tempImgArrDict.append(jsonDict)
        }
    }
    
    fileprivate func extractedFunc4(_ syncArr: NSArray) {
        if !Constants.syncToWebTapped {
            if syncArr.count > 0 {
                self.isSync = false
                self.syncBtnTapped()
            } else {
                showToastWithTimer(message: Constants.dataSyncCompleted, duration: 2.0)
                DispatchQueue.main.async {
                    self.dismissGlobalHUD(self.view)
                    self.stopHud()
                }
                self.refreshCountHideUnhide()
            }
        } else {
            Constants.syncToWebTapped = false
            self.dismissGlobalHUD(self.view)
            self.refreshCountHideUnhide()
        }
    }
    
    private func handleSyncScoreResponse(_ json: JSON,  syncId:String, forImgArrJson:[[String: Any]]) {
        
        if json["StatusCode"] == 200 {
            
            if forImgArrJson.count > 0 {
                let imgArrCount : Int = forImgArrJson.count
                let numbers = Array(1...imgArrCount)
                let chunkArr = numbers.chunked(into: 5)
                
                var ModuleAssessmentIdArrrrr = [Int]()
                var tempImgArrDict = [[String: Any]]()
                
                extractedFunc3(chunkArr, &ModuleAssessmentIdArrrrr, forImgArrJson, &tempImgArrDict)
                extractedFunc2(tempImgArrDict, syncId)
                dismissGlobalHUD(self.view)
                
               
            } else {
                CoreDataHandlerPVE().updateStatusForSync(syncId, text: true, forAttribute: "syncedStatus")
                let syncArr = CoreDataHandlerPVE().fetchSyncDataDetailsForTypeOfData(type: "sync")
                peHeaderViewController.labelSyncCount.text = "\(syncArr.count)"
                extractedFunc4(syncArr)
            }
        }
        else
        {
            self.isSync = false
             self.stopHud()
             self.stopLoader()
             self.dismissGlobalHUD(self.view)
            let statusCode = json["StatusCode"].int ?? 405
            let alertHandler = PVEAlertShow()
            let apiAlertMessage = alertHandler.alertMessage(for: statusCode)
            
            self.showAlert(title: "Error", message: apiAlertMessage, owner: self)

        }
    }
    
    private func handleImageSyncResponse(_ json: JSON,  syncId:String) {
        if json["StatusCode"] == 200 {
            CoreDataHandlerPVE().updateStatusForSync(syncId, text: true, forAttribute: "syncedStatus")
        }
        else
        {
            if json["StatusCode"] == 500 {
                self.isSync = false
                self.stopHud()
                self.stopLoader()
                self.dismissGlobalHUD(self.view)
                self.showAlert(title: "Error", message: "\(json["App_Assessment_Details_Id"])", owner: self)
                return
            }
            else
            {
                self.isSync = false
                self.stopHud()
                self.stopLoader()
                self.dismissGlobalHUD(self.view)
                let statusCode = json["StatusCode"].int ?? 405
                let alertHandler = PVEAlertShow()
                let apiAlertMessage = alertHandler.alertMessage(for: statusCode)
                self.showAlert(title: "Error", message: apiAlertMessage, owner: self)
            }
           
        }
        
        dismissGlobalHUD(self.view)
        setSyncDraftCountLabelFinalAssessed()
    }
    
    func createCustomImgView(imgArr:[Data]) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 400, width: self.view.frame.size.width, height: 100))
        customView.backgroundColor = .green
        
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: 10, y: 0, width: 100, height: 100))
        imageView.image = UIImage(data: imgArr[0])
        customView.addSubview(imageView)
        
        var imageView2 : UIImageView
        imageView2  = UIImageView(frame:CGRect(x: 200, y: 0, width: 100, height: 100))
        imageView2.image = UIImage(data: imgArr[1])
        customView.addSubview(imageView2)
        
        var imageView3 : UIImageView
        imageView3  = UIImageView(frame:CGRect(x: 390, y: 0, width: 100, height: 100))
        imageView3.image = UIImage(data: imgArr[2])
        customView.addSubview(imageView3)
        
        self.view.addSubview(customView)
        
    }
    
    func getImageDetails(dict: AnyObject) -> [[String: Any]] {
        
        var tempImgArr = [Data]()
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 19
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId", syncId: syncId!) as? Int
        
        let assessmentArr = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: syncId!)
        let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        let module_Cat_IdArr = assessmentArr.value(forKey: "id")  as? NSArray ?? NSArray()
        
        var imgArr = [[String : Any]]()
        for (indx, seq_Number) in seq_NumberArr.enumerated() {
            let currentModule_Cat_IdArr = module_Cat_IdArr[indx] as! Int
            let savedImgArr = CoreDataHandlerPVE().fetchImgDetailsFromDB(seq_Number as! NSNumber, syncId: syncId!) as NSArray
            
            for (_, currentQObj) in savedImgArr.enumerated() {
                var scoreDict = [String : Any]()
                
                scoreDict.merge(dict: ["Id" : id])
                scoreDict.merge(dict: ["AssessmentDetailId" : Assessment_Detail_Id])
                
                let ModuleAssessmentId = (currentQObj as AnyObject).value(forKey: "id") as! Int
                scoreDict.merge(dict: ["ModuleAssessmentId" : ModuleAssessmentId])
                scoreDict.merge(dict: ["UserId" : userId!])
                scoreDict.merge(dict: ["ModuleId" : Module_cat_id])
                scoreDict.merge(dict: ["DeviceId" : deviceId!])
                
                let imdDataa = (currentQObj as AnyObject).value(forKey: "imageData") as! Data
                let imgBase64Data = convertImageToBase64String(imgData: imdDataa)
                scoreDict.merge(dict: ["ImageBase64" : imgBase64Data])
                scoreDict.merge(dict: ["ImageName" : "test"])
                scoreDict.merge(dict: ["Folder_Path" : "test"])
                scoreDict.merge(dict: ["type" :  ""])
                
                let imgSyncId = (currentQObj as AnyObject).value(forKey: "imgSyncId") as! String
                scoreDict.merge(dict: ["imgSyncId" :  imgSyncId])
                tempImgArr.append(imdDataa)
                scoreDict.merge(dict: ["Module_Assessment_Categories_Id" : currentModule_Cat_IdArr])
                
                imgArr.append(scoreDict)
            }
        }
        
        return imgArr
        
    }
    
    
    
    func convertImageToBase64String (imgData: Data) -> String {
        return imgData.base64EncodedString(options: .lineLength64Characters)
        
    }
    
    func getQuestionsDetails(dict: AnyObject) -> [[String: Any]] {
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 0
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId", syncId: syncId!) as? Int
        
        let assessmentArr = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: syncId!)
        let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        
        var scoreArr = [[String : Any]]()
        for (_, seq_Number) in seq_NumberArr.enumerated() {
            
            var scoreDict = [String : Any]()
            
            let questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(seq_Number as! NSNumber, type: "sync", syncId: syncId!) as NSArray
            
            for (_, currentQObj) in questionsArr.enumerated() {
                scoreDict.merge(dict: ["syncId" : syncId!])
                scoreDict.merge(dict: ["Id" : id])
                scoreDict.merge(dict: ["UserId" : userId!])
                scoreDict.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
                scoreDict.merge(dict: ["Device_Id" : deviceId!])
                if (currentQObj as AnyObject).value(forKey: "isSelected") as! Bool == true {
                    scoreDict.merge(dict: ["Score" : (currentQObj as AnyObject).value(forKey: "max_Score") as! Int])
                } else {
                    scoreDict.merge(dict: ["Score" : (currentQObj as AnyObject).value(forKey: "min_Score") as! Int])
                }
                
                scoreDict.merge(dict: ["Assessment_Id" : (currentQObj as AnyObject).value(forKey: "id") as! Int])
                scoreDict.merge(dict: ["Assessment_Type" : (currentQObj as AnyObject).value(forKey: "types") as! String])
                scoreDict.merge(dict: ["TextFieldValue" : (currentQObj as AnyObject).value(forKey: "enteredText") as! String])
                
                scoreDict.merge(dict: ["LiveVaccineType" : (currentQObj as AnyObject).value(forKey: "liveVaccineSwitch") as! Bool])
                scoreDict.merge(dict: ["LiveVaccineTypeComment" : (currentQObj as AnyObject).value(forKey: "liveComment") as! String])
                scoreDict.merge(dict: ["InactivatedVaccineType" : (currentQObj as AnyObject).value(forKey: "inactiveVaccineSwitch") as! Bool])
                scoreDict.merge(dict: ["InactivatedVaccineTypeComment" : (currentQObj as AnyObject).value(forKey: "inactiveComment") as! String])
                
                
                var commentDict = [String : Any]()
                commentDict.merge(dict: ["Id" : id])
                commentDict.merge(dict: ["UserId" : userId!])
                commentDict.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
                commentDict.merge(dict: ["Device_Id" : deviceId!])
                commentDict.merge(dict: ["Assessment_Id" : (currentQObj as AnyObject).value(forKey: "id") as! Int])
                commentDict.merge(dict: ["Comment" : (currentQObj as AnyObject).value(forKey: "comment") as! String])
                commentDict.merge(dict: ["ModuleId" : Module_cat_id])
                
                let commntStr = (currentQObj as AnyObject).value(forKey: "comment") ?? ""
                if commntStr as! String == "" {
                    scoreDict.merge(dict: ["assessmentCommentsViewModel" : NSDictionary()])
                } else {
                    scoreDict.merge(dict: ["assessmentCommentsViewModel" : commentDict])
                }
                scoreArr.append(scoreDict)
            }
        }
        return scoreArr
    }
    
    
    
    func createSyncRequest(dict: AnyObject) -> [String: AnyObject]{
        
        let houseNumber = (dict).value(forKey: "houseNumber")  as? String
        let accountManagerId = (dict).value(forKey: "accountManagerId")  as? Int
        let farm = (dict).value(forKey: "farm")  as? String
        let evaluationForId = (dict).value(forKey: "evaluationForId")  as? Int
        let breedOfBirdsId = (dict).value(forKey: "breedOfBirdsId")  as? Int
        let objEvaluationDate = (dict).value(forKey: "objEvaluationDate") as! Date
        let ageOfBirds = (dict).value(forKey: "ageOfBirds")  as? Int
        let noOfBirds = (dict).value(forKey: "noOfBirds")  as? Int
        let housingId = (dict).value(forKey: "housingId")  as? Int
        let notes = (dict).value(forKey: "notes")  as? String
        let breedOfBirdsFemaleId = (dict).value(forKey: "breedOfBirdsFemaleId")  as? Int
        let breedOfBirdsOther = (dict).value(forKey: "breedOfBirdsOther")  as? String
        let breedOfBirdsFemaleOther = (dict).value(forKey: "breedOfBirdsFemaleOther")  as? String
        
        var selectedBirdTypeId = (dict).value(forKey: "selectedBirdTypeId")  as? Int
        let createdAt = (dict).value(forKey: "createdAt")  as? String
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let evaluatorId = (dict).value(forKey: "evaluatorId")  as? Int
        
        let customerId = (dict).value(forKey: "customerId")  as? Int
        let complexId = (dict).value(forKey: "complexId")  as? Int
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        let type = (dict).value(forKey: "type")  as? String
        
        
        let cameraState = (dict).value(forKey: "cameraEnabled")  as? String
        
        var cameraEnabled = Bool()
        
        if cameraState == "true"{
            cameraEnabled = true
            
        }else{
            cameraEnabled = false
        }
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 0
        
       // let cat_NoOfCatchersDetailsArr = (dict).value(forKey: "cat_NoOfCatchersDetailsArr")  as? [[String : String]] ?? []
        let cat_NoOfCatchersDetailsArr = (dict).value(forKey: "cat_NoOfCatchersDetailsArr")  as? String

        var catchersViewModelArr = [[String : Any]]()
        
       // if cat_NoOfCatchersDetailsArr.count > 0 {
         if cat_NoOfCatchersDetailsArr != "" {

           // for (index, val) in cat_NoOfCatchersDetailsArr.enumerated(){
              //  let name = val["name"] ?? ""
                catchersViewModelArr.append(["MemberName" : "",//name,
                                             "Id" : id,
                                             "Module_cat_id" : Module_cat_id,
                                             "Device_Id" : deviceId!,
                                             "Assessment_Detail_Id" : Assessment_Detail_Id,
                                             "UserId" : userId!,
                                             "Sequence_no" : 0])
                
        //    }
        }
        
        
      //  let cat_NoOfVaccinatorsDetailsArr = (dict).value(forKey: "cat_NoOfVaccinatorsDetailsArr")  as? [[String : String]] ?? []
        let cat_NoOfVaccinatorsDetailsArr = (dict).value(forKey: "cat_NoOfVaccinatorsDetailsArr")  as? String
        var vaccinatorsViewModelArr = [[String : Any]]()
        
        if cat_NoOfVaccinatorsDetailsArr != "" {
            // Pankush
         //   for (index, val) in cat_NoOfVaccinatorsDetailsArr.enumerated(){
             //   let serology = val["serology"] ?? ""
//                var IsSerology = Bool()
//                if serology == "selected" {
//                    IsSerology = true
//                }else{
//                    IsSerology = false
//                }
                vaccinatorsViewModelArr.append(["MemberName" : "",//val["name"] ?? "",
                                                "Id" : id,
                                                "Module_cat_id" : Module_cat_id,
                                                "Device_Id" : deviceId!,
                                                "Assessment_Detail_Id" : Assessment_Detail_Id,
                                                "UserId" : userId!,
                                            //    "IsSerology" : IsSerology,
                                                "Sequence_no" : 0])
                // }
        }
        
        
        let cat_vaccinInfoDetailArr = (dict).value(forKey: "cat_vaccinInfoDetailArr")  as? [[String : Any]] ?? []
        var vaccineInfoDetailsViewModelArr = [[String : Any]]()
        if cat_vaccinInfoDetailArr.count > 0 {
            
            print("cat_vaccinInfoDetailArr.count-\(cat_vaccinInfoDetailArr.count)")
            for (index, val) in cat_vaccinInfoDetailArr.enumerated(){
                
                var expDate = ""
                if val["expDate"] as! String == "" {
                    expDate = "12/12/1900"
                }else{
                    expDate = val["expDate"] as! String
                }
                
                var Vaccine_Other = String()
                var Vaccine_Id = Int()
                
                if val["man_id"] as! Int == 17 {
                    Vaccine_Other = val["name"] as! String
                    Vaccine_Id = 0
                }else{
                    Vaccine_Other = ""
                    Vaccine_Id = val["name_id"] as! Int
                }
                
                let noteeeee = val["note"] ?? ""
                let serotype = val["serotype"] as? [String] ?? [""]
                let serotype_id = val["serotype_id"] as? [String] ?? [""]
                let antigenOther = val["otherAntigen"] ?? ""
                let serotype_idStr = (serotype_id.map{String($0)}).joined(separator: ",")
                
                var antigenViewModelArr = [[String : Any]]()
                
                for (index , val) in serotype_id.enumerated() {
                    
                    antigenViewModelArr.append(["Vaccine_Id" :Vaccine_Id , "Antigen_Id" : val , "Vaccine_Other": ""  , "Antigen_Other" : antigenOther , "Assessment_Detail_Id" : Assessment_Detail_Id , "Device_Id": deviceId!, "Sequence_no" : index , "UserId" :userId! , "Antigen_Name" : serotype[index]])
                }
                
                
                vaccineInfoDetailsViewModelArr.append(["Id" : id,
                                                       "Vaccine_Mfg_Id" : val["man_id"] ?? 0,
                                                       "Vaccine_Id" : Vaccine_Id,
                                                       "Serotype_Id" :  serotype_idStr ,
                                                       "Serial" : val["serial"] ?? "",
                                                       "Exp_Date" : expDate,
                                                       "Site_Injct_Id" : val["siteOfInj_id"] ?? "",
                                                       "UserId" : userId!,
                                                       "Assessment_Detail_Id" : Assessment_Detail_Id,
                                                       "Device_Id" : deviceId!,
                                                       "Vaccine_Mfg_Other": "",
                                                       "Vaccine_Other": Vaccine_Other,
                                                       "Serotype_Other": val["otherAntigen"] ?? "",
                                                       "Site_Injct_Other": "",
                                                       "showMore": val["showMore"] ?? "",
                                                       "Note": val["note"] ?? "",
                                                       "antigenDetailsViewModel" : antigenViewModelArr,
                                                       "Sequence_no" : index])
                
            }
        }
        
        let HousingId = (dict).value(forKey: "housingId")  as? Int
        let VaccineInfoType = (dict).value(forKey: "cat_selectedVaccineInfoType")  as? String
        let CrewLeaderName = (dict).value(forKey: "cat_crewLeaderName")  as? String
        let CrewEmailId = (dict).value(forKey: "cat_crewLeaderEmail")  as? String
        let CrewTelephoneNo = (dict).value(forKey: "cat_crewLeaderMobile")  as? String
        let CompFieldRepName = (dict).value(forKey: "cat_companyRepName")  as? String
        let CompFieldRepEmailId = (dict).value(forKey: "cat_companyRepEmail")  as? String
        let CompFieldRepPhone = (dict).value(forKey: "cat_companyRepMobile")  as? String
        
        var tempCrewDetailsViewModel = [String : Any]()
        tempCrewDetailsViewModel.merge(dict: ["Id" : id])
        tempCrewDetailsViewModel.merge(dict: ["UserId" : userId!])
        tempCrewDetailsViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
        tempCrewDetailsViewModel.merge(dict: ["Device_Id" : deviceId!])
        tempCrewDetailsViewModel.merge(dict: ["Module_cat_id" : Module_cat_id])
        tempCrewDetailsViewModel.merge(dict: ["HousingId" : HousingId!])
        tempCrewDetailsViewModel.merge(dict: ["No_of_Catchers" : cat_NoOfCatchersDetailsArr ?? ""])
        tempCrewDetailsViewModel.merge(dict: ["No_of_Vaccinator" : cat_NoOfVaccinatorsDetailsArr ?? ""])
        tempCrewDetailsViewModel.merge(dict: ["VaccineInfoType" : VaccineInfoType!])
        tempCrewDetailsViewModel.merge(dict: ["CrewLeaderName" : CrewLeaderName!])
        tempCrewDetailsViewModel.merge(dict: ["CrewEmailId" : CrewEmailId!])
        tempCrewDetailsViewModel.merge(dict: ["CrewTelephoneNo" : CrewTelephoneNo!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepName" : CompFieldRepName!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepEmailId" : CompFieldRepEmailId!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepPhone" : CompFieldRepPhone!])
        let isFreeSerology = (dict).value(forKey: "isFreeSerology")  as? Bool
//        if isFreeSerology == true{
//            tempCrewDetailsViewModel.merge(dict: ["IsSerology" : isFreeSerology ?? 0])
//        }else{
//            tempCrewDetailsViewModel.merge(dict: ["IsSerology" : isFreeSerology ?? 0])
//        }
        
        let WasDyeAdded = (dict).value(forKey: "vacEval_DyeAdded")  as? Bool
        let Comments_observations = (dict).value(forKey: "vacEval_Comment")  as? String
        var evaluationNoteViewModel = [String : Any]()
        evaluationNoteViewModel.merge(dict: ["Id" : id])
        evaluationNoteViewModel.merge(dict: ["UserId" : userId!])
        evaluationNoteViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
        evaluationNoteViewModel.merge(dict: ["Device_Id" : deviceId!])
        evaluationNoteViewModel.merge(dict: ["WasDyeAdded" : WasDyeAdded!])
        evaluationNoteViewModel.merge(dict: ["Note" : Comments_observations!])
        evaluationNoteViewModel.merge(dict: ["ModuleCategoryId" : Module_cat_id])
        
        var choleraArr = [[String : Any]]()
        
        for n in 1...5 {
            var choleraVaccinesViewModel = [String : Any]()
            choleraVaccinesViewModel.merge(dict: ["Id" : id])
            choleraVaccinesViewModel.merge(dict: ["UserId" : userId!])
            choleraVaccinesViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
            choleraVaccinesViewModel.merge(dict: ["Device_Id" : deviceId!])
            choleraVaccinesViewModel.merge(dict: ["Assessment_Id" : 134])
            choleraVaccinesViewModel.merge(dict: ["Module_Assessment_Cat_Id" : Module_cat_id])
            
            var LeftWingInj = Double()
            var RightWingInj = Double()
            if n == 1{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Center (good)"])
                LeftWingInj = (dict).value(forKey: "injCenter_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injCenter_RightWing_Field") as! Double
                
                
                let LeftPerInj = (dict).value(forKey: "injCenter_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injCenter_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injCenter_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 2{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Wing Band"])
                LeftWingInj = (dict).value(forKey: "injWingBand_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injWingBand_RightWing_Field") as! Double
                
                let LeftPerInj = (dict).value(forKey: "injWingBand_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injWingBand_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injWingBand_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 3{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Muscle Hit"])
                LeftWingInj = (dict).value(forKey: "injMuscleHit_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injMuscleHit_RightWing_Field")  as! Double
                
                let LeftPerInj = (dict).value(forKey: "injMuscleHit_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injMuscleHit_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injMuscleHit_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 4{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Missed"])
                LeftWingInj = (dict).value(forKey: "injMissed_LeftWing_Field")  as! Double
                RightWingInj = (dict).value(forKey: "injMissed_RightWing_Field")  as! Double
                
                let LeftPerInj = (dict).value(forKey: "injMissed_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injMissed_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injMissed_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 5{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Total"])
                
                LeftWingInj = (dict).value(forKey: "subQLeftTotal") as! Double
                RightWingInj = (dict).value(forKey: "subQRightTotal") as! Double
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : 100])
                if LeftWingInj == 0 {
                    choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : 0])
                }
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : 100])
                if RightWingInj == 0 {
                    choleraVaccinesViewModel.merge(dict: ["RightPerInj" : 0])
                }
                
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : 100])
                if totalling == 0 {
                    choleraVaccinesViewModel.merge(dict: ["PerTotal" : 0])
                }
            }
            
            choleraVaccinesViewModel.merge(dict: ["LeftWingInj" : LeftWingInj])
            choleraVaccinesViewModel.merge(dict: ["RightWingInj" : RightWingInj])
            
            let score = (dict).value(forKey: "scoreCholeraVaccine") as! Double
            choleraVaccinesViewModel.merge(dict: ["Score" : score])
            
            choleraArr.append(choleraVaccinesViewModel)
            
        }
        
        var inactivatedVacArr = [[String : Any]]()
        
        for n in 1...3 {
            var inactivatedVaccinesViewModel = [String : Any]()
            inactivatedVaccinesViewModel.merge(dict: ["Id" : id])
            inactivatedVaccinesViewModel.merge(dict: ["UserId" : userId!])
            inactivatedVaccinesViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
            inactivatedVaccinesViewModel.merge(dict: ["Device_Id" : deviceId!])
            inactivatedVaccinesViewModel.merge(dict: ["Assessment_Id" : 135])
            inactivatedVaccinesViewModel.merge(dict: ["Module_Assessment_Cat_Id" : Module_cat_id])
            
            var IntraInj = Double()
            var SubInj = Double()
            
            if n == 1{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Hits"])
                IntraInj = (dict).value(forKey: "injMuscleHit_IntramusculerInj_Field")  as! Double
                SubInj = (dict).value(forKey: "injMuscleHit_SubcutaneousInj_Field")  as! Double
                
                let PerIntra = (dict).value(forKey: "injMuscleHit_IntramusculerInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : PerIntra!])
                
                let PerSub = (dict).value(forKey: "injMuscleHit_SubcutaneousInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : PerSub!])
                
                let TotalInj = (dict).value(forKey: "injMuscleHit_Total")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = (dict).value(forKey: "injMuscleHit_Percent") as! Double
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
            }
            if n == 2{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Missed"])
                IntraInj = (dict).value(forKey: "injMissed_IntramusculerInj_Field")  as! Double
                SubInj = (dict).value(forKey: "injMissed_SubcutaneousInj_Field")  as! Double
                
                let PerIntra = (dict).value(forKey: "injMissed_IntramusculerInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : PerIntra!])
                
                let PerSub = (dict).value(forKey: "injMissed_SubcutaneousInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : PerSub!])
                
                let TotalInj = (dict).value(forKey: "injMissed_Total")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = (dict).value(forKey: "injMissed_Percent") as! Double
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 3{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Total"])
                
                IntraInj = (dict).value(forKey: "intraInjLeftTotal")  as! Double
                SubInj = (dict).value(forKey: "subInjRightTotal")  as! Double
                
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : 100])
                if IntraInj == 0 {
                    inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : 0])
                }
                
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : 100])
                if SubInj == 0 {
                    inactivatedVaccinesViewModel.merge(dict: ["PerSub" : 0])
                }
                
                let TotalInj = (dict).value(forKey: "injTotal_For_Inactivated")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = 100
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                if (IntraInj + SubInj) == 0{
                    inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : 0])
                }
            }
            
            inactivatedVaccinesViewModel.merge(dict: ["IntraInj" : IntraInj])
            inactivatedVaccinesViewModel.merge(dict: ["SubInj" : SubInj])
            
            let score = (dict).value(forKey: "scoreInactivatedVaccine") as! Double
            inactivatedVaccinesViewModel.merge(dict: ["Score" : score])
            
            inactivatedVacArr.append(inactivatedVaccinesViewModel)
        }
        
        if selectedBirdTypeId == 13{
            selectedBirdTypeId = 2
        }else{
            selectedBirdTypeId = 1
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM/dd/YYYY HH:mm:ss Z"
        let date = dateFormatter.string(from: objEvaluationDate) as String
        
        let evaluationDate = (dict).value(forKey: "evaluationDate")  as? String
        
        var tempBreedOfBirdsId = ""
        if breedOfBirdsId == 0 {
            tempBreedOfBirdsId = ""
        }else{
            tempBreedOfBirdsId = "\(breedOfBirdsId ?? 0)"
        }
        
        let json = [
            "Id" : 0,
            "App_Assessment_Detail_Id": syncId!,
            "Evaluation_Date" : evaluationDate!,
            "Evaluation_For_Id" : evaluationForId!,
            "Customer_Id" : customerId ?? 0,
            "Complex_Id" : complexId ?? 0,
            "Zoetis_Account_Manager_Id" : accountManagerId!,
            "Evaluator_Id" : evaluatorId!, // need to set in db
            "Breed_Id" : tempBreedOfBirdsId,
            "Breed_of_Birds_Other": breedOfBirdsOther!,
            "Breed_Female_Id" : breedOfBirdsFemaleId!,
            "Breed_Female_Other": breedOfBirdsFemaleOther!,
            "Housing_Id" : housingId!,
            "Farm_Name" : farm!,
            "House_No" : houseNumber!,
            "Age_of_Birds" : ageOfBirds!,
            "Camera" : cameraEnabled,
            "No_of_Birds" : noOfBirds!,
            "Type_of_Bird" : selectedBirdTypeId!,
            "Notes" : notes!,
            "Device_Id" : deviceId!,
            "UserId" : userId!,
            "Save_type": type!,
            
            "CreatedBy" : userId ?? 0,
            "CreatedAt" : createdAt!,
            "syncId" : syncId!,
            
            "vaccineInformationCrewDetailsViewModel" : tempCrewDetailsViewModel,
            "catchersViewModel" : catchersViewModelArr,
            "vaccinatorsViewModel" : vaccinatorsViewModelArr,
            "vaccineInfoDetailsViewModel" : vaccineInfoDetailsViewModelArr,
            "evaluationNoteViewModel" : evaluationNoteViewModel,
            "choleraVaccinesViewModel" : choleraArr,
            "inactivatedVaccinesViewModel" : inactivatedVacArr
        ] as Dictionary<String, AnyObject>
        
        
        return json as [String : AnyObject]
        
    }
    
    func getDraftValueForKey(key:String, syncId:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: syncId)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
 
    
    func logoutAction() {
        
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
    
    
    internal func sendImageRequest(address: String, method: String, body: Dictionary<String, AnyObject>){
        
        let url = NSURL(string: address)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: Constants.contentType)
        request.setValue("\(String(describing: UserDefaults.standard.value(forKey: "Id") ?? 0))", forHTTPHeaderField: "UserId") //**
        request.setValue("\(String(describing: UserDefaults.standard.value(forKey: Constants.accessToken) ?? ""))", forHTTPHeaderField: Constants.authorization) //**
        
        request.httpMethod = method
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.init(rawValue: 2))
        } catch {
            // Error handling
            print("There was an error while Serializing the body object")
            return
        }
        
        let session = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                if error != nil {
                    print("Error -> \(error)")
                    return
                }
            } catch {
                print("Send request error while Serializing the data object")
                return
            }
        })
        
        session.resume()
    }
}

extension PVEDashboardViewController:  ComplexDelegate {
    func stopLoader() {
        dismissGlobalHUD(self.view)
        
    }
    
    func fetchGetAPIResponse() {
        
        let callDraftApi = UserDefaults.standard.bool(forKey:"callDraftApi")
        
        if callDraftApi == true {
            
            UserDefaults.standard.set(false, forKey: "callDraftApi")
            let currentUserId = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            ZoetisWebServices.shared.GetPostingAssessmentListByUser(controller: self, header: ["UserId" : currentUserId], parameters: [:], completion: { [weak self] (json, error) in
                guard let selfObject = self, error == nil else { return }
                
               
                if json["data"].count > 0 {
                    let responseDataArr = json["data"].array
                    CoreDataHandler().deleteAllData("PVE_Sync")
                    CoreDataHandler().deleteAllData("PVE_ImageEntitySync")
                    
                    for (_, currntSyncObj) in responseDataArr!.enumerated() {
                        CoreDataHandlerPVE().saveSyncDetailsInDBFromResponse(json: currntSyncObj)
                    }
                    
                    selfObject.refreshCountHideUnhide()
                    selfObject.getSyncedImageResponse()
                    
                } else {
                    selfObject.stopHud()
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "stopComplexPopupLosder"),object: nil))
                }
            })
            UserDefaults.standard.set(true, forKey: "getApiCalled")
        }
    }
    
    func getSyncedImageResponse() {
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...Please wait, This may take a while.")
        
        ZoetisWebServices.shared.GetPostingAssessmentImagesListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let selfObject = self, error == nil else { return }
            if json["data"].count > 0 {
                CoreDataHandler().deleteAllData("PVE_ImageEntitySync")
                
                let responseDataArr = json["data"].array
                for (_, currntSyncObj) in responseDataArr!.enumerated() {
                    CoreDataHandlerPVE().saveSyncedImageDetailsInDBFromResponse(json: currntSyncObj)
                }
                selfObject.getSyncedCompleteImageResponse()
            } else {
                selfObject.stopHud()
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "stopComplexPopupLosder"),object: nil))
            }
        })
    }
    
    func getSyncedCompleteImageResponse() {
        ZoetisWebServices.shared.GetPostingAssessmentCompleteImagesListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let selfObj = self, error == nil else { return }
            if json["data"].count > 0 {
                
                let responseDataArr = json["data"].array
                for (_, currntSyncObj) in responseDataArr!.enumerated() {
                    CoreDataHandlerPVE().saveSyncedImageDetailsInDBFromResponse(json: currntSyncObj)
                    selfObj.stopHud()
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "stopComplexPopupLosder"),object: nil))
                }
            } else {
                selfObj.stopHud()
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "stopComplexPopupLosder"),object: nil))
            }
        })
    }
    
    func stopHud() {
        dismissGlobalHUD(self.view)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension PVEDashboardViewController:URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded Location- ",  location)
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationPath)
        do{
            
            try FileManager.default.copyItem(at: location, to: destinationPath)
            print("File Downloaded Location- ",  destinationPath)
            DispatchQueue.main.async {
                self.showtoast(message: "PDF Downloaded Sucessfully..")
               
            }
        }catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
}


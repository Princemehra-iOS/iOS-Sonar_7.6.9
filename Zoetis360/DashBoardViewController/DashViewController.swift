
//  DashViewController.swift
//  Zoetis -Feathers
//  Created by "" on 11/08/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit
import Charts
import Alamofire
import Reachability
import SystemConfiguration
import CoreData
import SwiftyJSON
import Gigya
import GigyaTfa
import GigyaAuth


class DashViewController: UIViewController,MDRotatingPieChartDataSource,userlistProtocol,userLogOut ,syncApi,SyncApiData {
    
    // MARK: - VARIABLES
    var  postingIdArr = NSMutableArray()
    var lngId = NSInteger()
    
    let dropDown = DropDown()
    typealias CompletionHandler = (_ selectedVal:String) -> Void
    typealias CompletionHandlerWithIndex = (_ selectedVal:String, _ index:Int) -> Void
    
    var customPopView1 :UserListView!
    var dataArray = NSMutableArray()
    var dataArray1 = NSMutableArray()
    var RouteArray = NSArray ()
    var custmorArr = NSArray ()
    var salesRepArr = NSArray ()
    var cocoiiProgramArr = NSArray ()
    var sessiontypeArr = NSArray ()
    var birdSizeArr = NSArray ()
    var breedArr = NSArray ()
    var veterianArr = NSArray ()
    var complexArr = NSArray()
    let buttonbg = UIButton ()
    var FeedProgramArray = NSMutableArray()
    var cocciVaccine = NSMutableArray()
    var targetWeight = NSMutableArray()
    var dataSkeletaArray = NSArray ()
    var dataCocoiiArray = NSArray ()
    var dataGiTractArray = NSArray ()
    var dataRespiratoryArray = NSArray ()
    var dataImmuneArray = NSArray ()
    var serviceDataHldArr = NSMutableArray()
    var NecropsiesPostingSess =  NSMutableArray()
    var farmsListAray = NSArray ()
    let objApiSync = ApiSync()
    let objApiSyncOneSet = SingleSyncData()
    var complexSize = NSMutableArray()
    var arraVetType  = NSMutableArray()
    var getFormArray = NSMutableArray ()
    var arraCustmer = NSMutableArray ()
    var arraSalesRep = NSMutableArray ()
    var prodType = NSMutableArray()
    var prodTypeArray = NSArray()
    /****************** Api Sync ************/
    var strdateTimeStamp = String()
    var datePicker = UIDatePicker()
    var accestoken = String()
    var isSync : Bool = false
    var postingId = Int()
    var feedId = Int()
    var btnTag = Int ()
    var val = NSArray()
    var valnecPos = NSArray()
    var slicesData:Array<DataSet> = Array<DataSet>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var postingArrWithAllData = NSMutableArray()
    let images  = [UIImage(named: "Poultry_App_1908x802.jpg")!,
                   UIImage(named: "embrex_banner_graphic_1786x432.jpg")!,
                   UIImage(named: "PoulvacEcoli_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "PoulvacIB_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "Rotecc_banner_graphic_1908x802.jpg")!]
    var index = 0
    let animationDuration: TimeInterval = 0.75
    let switchingInterval: TimeInterval = 5
    var langArray: [String] = []
    let helveticaLight = "HelveticaNeue-Light"
    let cacheControl = Constants.cacheControl
    let authorization = Constants.authorization
    let unknownCodeStr = Constants.unknowCode
    let invalidItemStructureStr = "Invalid item structure in array."
    // MARK: - OUTLETS
    
    @IBOutlet weak var syncBackImageView: UIImageView!
    @IBOutlet weak var syncCountLbl: UILabel!
    @IBOutlet weak var openExixtingLbl: UILabel!
    @IBOutlet weak var dataAvailbleForSync: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var uinLinkedBadgeLabel: UILabel!
    @IBOutlet weak var sessionBadgeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var PostingSessionButton: UIButton!
    @IBOutlet weak var ActiveSessionButton: UIButton!
    @IBOutlet weak var PostingSessionHistroyButton: UIButton!
    @IBOutlet weak var ReportsButton: UIButton!
    @IBOutlet weak var trainingEductionLbl: UILabel!
    @IBOutlet weak var btnSelectLanguage: UIButton!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var unlinkedSessionButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var piChartView: BarChartView!
    @IBOutlet weak var barChartViewView: BarChartView!
    @IBOutlet weak var syncCount: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    
    
    
    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    let offLineMsg = Constants.offline
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()

    // MARK: - CLASS DECLERATION
    class DataSet {
        var value:CGFloat
        var color:UIColor = UIColor.gray
        var label:String = ""
        
        init(myValue:CGFloat, myColor:UIColor, myLabel:String) {
            value = myValue
            color = myColor
            label = myLabel
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    // MARK: 🟠 - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 1 {
            self.trainingEductionLbl.frame = CGRect(x: 303, y: 128, width: 130, height: 60)
            openExixtingLbl.text =  "Open Existing Session"
            
        }else if lngId == 3 {
            self.trainingEductionLbl.frame = CGRect(x: 303, y: 120, width: 130, height: 60)
            openExixtingLbl.text = "Abrir Sessão Existente"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(DashViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        UserDefaults.standard.set(true, forKey: "chickenSyncStatus")
        UserDefaults.standard.set(1, forKey: "birdTypeId")
        self.printSyncLblCountTurkey()
        UserDefaults.standard.set(false, forKey: "TurkeyBird")
        
        if UserDefaults.standard.integer(forKey: "Role") == 0 {
            PostingSessionButton.isUserInteractionEnabled = false
            ActiveSessionButton.isUserInteractionEnabled = false
            ReportsButton.isUserInteractionEnabled = false
            startSessionButton.isUserInteractionEnabled = false
            unlinkedSessionButton.isUserInteractionEnabled = false
            syncButton.isUserInteractionEnabled = false
        } else {
            ActiveSessionButton.isUserInteractionEnabled = true
            ReportsButton.isUserInteractionEnabled = true
            PostingSessionButton.isUserInteractionEnabled = true
            startSessionButton.isUserInteractionEnabled = true
            unlinkedSessionButton.isUserInteractionEnabled = true
            syncButton.isUserInteractionEnabled = true
        }
        objApiSync.delegeteSyncApi = self
        objApiSyncOneSet.delegeteSyncApiData = self
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.set(false, forKey: "backFromStep1")
        UserDefaults.standard.synchronize()
        appDelegate.sendFeedVariable = ""
        btnTag = 0
        bannerImageView.startAnimating()
        animateImageView()
        
        let custArr = CoreDataHandler().fetchCustomer()
        if(custArr.count == 0){
            callWebService()
        }

    }

    @objc func showTwoDayWarningAlert() {
        let alert = UIAlertController(title: "Session Expiring Soon",
                                      message: "Your session will expire in less than 2 days. Please consider saving your work or re-logging in.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func showSessionExpiredAlert(showLogoutButton: Bool) {
        let messageText: String

        if showLogoutButton {
            messageText = Constants.dontHaveSessionToPostMessage
        } else {
            messageText = Constants.stillHaveActiveSessionMessage
        }

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
                    TimeManager.shared.performAutoLogout()
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

    func failWithInternetConnection()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    func getRemainingTimeForAutoLogout() -> TimeInterval? {
        guard let loginDate = UserDefaults.standard.object(forKey: "LoginDate") as? Date else { return nil }
        let expiryDate = Calendar.current.date(byAdding: .day, value: 7, to: loginDate)!
        let remainingTime = expiryDate.timeIntervalSinceNow
        return remainingTime > 0 ? remainingTime : nil
    }
    
    @IBAction func btnOntimerAction(_ sender: Any) {
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.set(false, forKey: "backFromStep1")
        UserDefaults.standard.synchronize()
        let sync =  UserDefaults.standard.bool(forKey: "promt")
        
        uinLinkedBadgeLabel.text =  String(valnecPos.count  ) // + val.count
        self.printSyncLblCount()
        if sync == true && self.allSessionArr().count > 0{
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callPrmpApi), userInfo: nil, repeats: false)
        }
        if sync == false || self.allSessionArr().count == 0 {
            Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(iSfarmSync), userInfo: nil, repeats: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierLeftMenu"), object: nil)
        let totalExustingArr = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSession = totalExustingArr.object(at: i) as! PostingSession
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandler().FetchFeedProgram(pid!)
            if feedProgram.count == 0{
                CoreDataHandler().updatePostingSessionOndashBoard(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandler().deletefieldVACDataWithPostingId(pid!)
                CoreDataHandler().deleteDataWithPostingIdHatchery(pid!)
            }
        }
        UserDefaults.standard.set(1, forKey: "LastScreenRef")
        UserDefaults.standard.set(true, forKey: "nec")
        UserDefaults.standard.set(true, forKey: "timeStampTrue")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        UserDefaults.standard.set(1, forKey: "sessionId")
        UserDefaults.standard.set(0, forKey: "isBackWithoutFedd")
        UserDefaults.standard.removeObject(forKey: "count")
        UserDefaults.standard.synchronize()
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        val = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0) as NSArray
        for i in 0..<val.count{
            let posting : PostingSession = val.object(at: i) as! PostingSession
            let pidSession = posting.postingId
            let feedProgram =  CoreDataHandler().FetchFeedProgram(pidSession!)
            if feedProgram.count == 0{
                CoreDataHandler().deleteDataWithPostingId(pidSession!)
                CoreDataHandler().deletefieldVACDataWithPostingId(pidSession!)
                CoreDataHandler().deleteDataWithPostingIdHatchery(pidSession!)
            }
        }
        
        self.NecropsiesPostingSess =  CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(0).mutableCopy() as! NSMutableArray
        valnecPos  = CoreDataHandler().fetchAllPostingSessionWithVetId(_VetName: "") as NSArray
        let arr = NSMutableArray()
        
        for i in 0..<totalExustingArr.count {
            
            let posting : PostingSession = totalExustingArr.object(at: i) as! PostingSession
            let finializeB = posting.finalizeExit as! Int
            
            if finializeB == 0 {
                arr.add(posting)
            }
        }
        
        sessionBadgeLabel.text = String(arr.count + valnecPos.count ) // + val.count
        uinLinkedBadgeLabel.text =  String(valnecPos.count  ) // + val.count
        self.printSyncLblCount()
    }
    
    
    // MARK: 🟠 - New POsting Session  Button Action
    @IBAction func PostingSessionButtonPress(_ sender: AnyObject) {
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
        Constants.isForUnlinkedChicken = false
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    // MARK: 🟠 - Existing Posting Session Button Action
    @IBAction func ActiveSessionButtonPress(_ sender: AnyObject) {
        Constants.isForUnlinkedChicken = false
        UserDefaults.standard.set(true, forKey: "postingSession")
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "Existing") as? ExistingPostingSessionViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    // MARK: 🟠 - Tranning & Certification Button Action
    @IBAction func PostingSessionHistoryButtonPress(_ sender: AnyObject) {
        Constants.isForUnlinkedChicken = false
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TrainingNew") as? TrainingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    // MARK: 🟠 - Reports Button Action
    @IBAction func ReportsButtonPress(_ sender: AnyObject) {
        Constants.isForUnlinkedChicken = false
        AllValidSessions.sharedInstance.complexName = "" // New Change
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "Report") as? Report_MainVCViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    /**************************************************************************************************************/
    
    @IBAction func didSelectOnUnlinkedNecrp(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
    
    @IBAction func NacropsyButtonPress(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
    
    // MARK: 🟠 - Logout Button Action
    @IBAction func logOutButtonAction(_ sender: AnyObject) {
        clickHelpPopUp()
    }
    
    // MARK: 🟠 - METHODS AND FUNCTIONS
    func printSyncLblCountTurkey() {
        syncCountLbl.text = String(self.allSessionArrTurkey().count)
        
        if syncCountLbl.text == String(0) {
            syncCountLbl.isHidden = true
            dataAvailbleForSync.isHidden = true
            syncBackImageView.isHidden = true
        }
        else {
            
            dataAvailbleForSync.isHidden = false
            syncBackImageView.isHidden = false
            syncCountLbl.isHidden = false
        }
    }
    // MARK: 🟠 - Get all Session array for Turkey.
    func allSessionArrTurkey() ->NSMutableArray{
        
        let postedSessionArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postedSessionArrWithAllData.count {
            let pSession = postedSessionArrWithAllData.object(at: i) as! PostingSessionTurkey
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    // MARK: 🟠 - function for Sync Prompt
    @objc func callPrmpApi()  {
        self.promtSyncing()
    }
    
    // MARK: 🟠 - Unlinked Sessions
    @IBAction func didSelectOnSeesion(_ sender: AnyObject) {
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "unlinkSessionSecond") as? UnlinkNecrpoSecondViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    
    // MARK: 🟠 - Language Button Action
    @IBAction func ActionSelectLanguage(_ sender: UIButton) {
        self.dropDownVIewNew(arrayData: langArray, kWidth: btnSelectLanguage.frame.width, kAnchor: btnSelectLanguage, yheight: btnSelectLanguage.bounds.height) { [unowned self] selectedVal, index  in
            btnSelectLanguage.setTitle(selectedVal, for: .normal)
            
            if selectedVal == "English(Default)" {
                UserDefaults.standard.set(1, forKey: "lngId")
                LanguageUtility.setAppleLAnguageTo(lang: "en")
            } else {
                UserDefaults.standard.set(3, forKey: "lngId")
                LanguageUtility.setAppleLAnguageTo(lang: "fr")
            }
            UserDefaults.standard.synchronize()
           
            self.loadView()
            self.viewWillAppear(true)
            self.viewDidLoad()
            self.viewDidAppear(true)
        }
        self.dropHiddenAndShow()
        
    }
    
    // MARK: 🟠 - Load Drop down
    func dropDownVIewNew(arrayData:[String], kWidth:CGFloat,kAnchor:UIView,yheight:CGFloat,completionHandler:@escaping CompletionHandlerWithIndex){
        dropDown.dataSource = arrayData as [AnyObject];
        dropDown.width = kWidth
        dropDown.anchorView = kAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y:yheight+1)
        self.dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDown.deselectRowAtIndexPath(index)
            completionHandler(item, index);
        }
    }
    
    // MARK: 🟠 DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    func animateImageView() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = DispatchTime.now() + Double(Int64(self.switchingInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        bannerImageView.layer.add(transition, forKey: kCATransition)
        bannerImageView.image = images[index]
        CATransaction.commit()
        index = index < images.count - 1 ? index + 1 : 0
    }
    
    // MARK: 🟠 Check for unlinked farm to feed program
    @objc func iSfarmSync(){
        let totalExustingArr = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        var isFarmSync = Bool()
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSession = totalExustingArr.object(at: i) as! PostingSession
            let pid = postingSession.postingId
            let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(pid!)
            if farms.count > 0 {
                CoreDataHandler().updatedPostigSessionwithIsFarmSyncPostingId(pid!, isFarmSync: true)
                if isFarmSync == false{
                    
                    if lngId == 1 {
                        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("You have unlinked farm(s) to your feed in posting session. Visit '' Open Existing Session '' to link farm(s) to feed program.", comment: ""))
                        isFarmSync = true
                        
                    } else if lngId == 3 {
                        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("Vous avez dissocié la/les ferme(s) de votre aliment en affichant. La visite '' Ouvrir la séance existante '' pour associer la ferme(s) au programme alimentaire.", comment: ""))
                        isFarmSync = true
                    }
                }
            }
        }
    }
    // MARK: 🟠 - Sync Count
    func printSyncLblCount()
    {
        syncCount.text = String(self.allSessionArr().count)
    }
    
    // MARK: 🟠 - Toast view with timmer.
    func showToastWithTimer(message : String, duration: TimeInterval ) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: helveticaLight, size: 11.0) //UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 3
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: 🟠Datasource & Delegate of Pie Chart ************************//
    
    func colorForSliceAtIndex(_ index:Int) -> UIColor {
        return slicesData[index].color
    }
    
    func valueForSliceAtIndex(_ index:Int) -> CGFloat {
        return slicesData[index].value
    }
    
    func labelForSliceAtIndex(_ index:Int) -> String {
        return slicesData[index].label
    }
    
    func numberOfSlices() -> Int {
        return slicesData.count
    }
    /**************************************************************************/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: 🟠 Side Menu Button action
    @IBAction func sideMenuButtonPress(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    // MARK: 🟢  Call Web Services to get Observation's List
    fileprivate func handleSuccessResponseGetNecropsy(_ JSON: Any) {
        if (JSON is NSArray) {
            self.dataArray.removeAllObjects()
            self.appDelegate.globalDataArr.removeAllObjects()
            let arr : NSArray = JSON as! NSArray
            for  i in 0..<arr.count {
                let tempDict = arr.object(at: i) as AnyObject
                let ObJServiceHolder = ServiceDataHolder()
                ObJServiceHolder.CategoryDescp = (tempDict as! NSDictionary).value(forKey:"CategoryDescription") as!  NSString
                ObJServiceHolder.CataID = (tempDict as! NSDictionary).value(forKey:"CategoryId") as! NSInteger
                ObJServiceHolder.ObservaionDetailsArr = ((tempDict as! NSDictionary).value(forKey: "ObservaionDetails") as! NSArray).mutableCopy() as! NSMutableArray
                self.dataArray.add(ObJServiceHolder)
            }
            
            self.appDelegate.globalDataArr = self.dataArray
            self.skelta(0)
            self.cocoii(1)
            self.gitract(2)
            self.res(3)
            self.immu(4)
            
            self.callCustmerWebService()
        } else {
            self.callCustmerWebService()
        }
    }
    
    fileprivate func handleGetNecropsyAPIResponse(_ statusCode: Int, _ response: AFDataResponse<Any>) {
        if statusCode == 401 {
            self.loginMethod()
        } else if (400...403).contains(statusCode) || (500...504).contains(statusCode) {
            let alertController = UIAlertController(title: "", message:NSLocalizedString("Unable to get data from server. \n(\(String(describing: statusCode)))", comment: ""), preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                Helper.dismissGlobalHUD(self.view)
                self.callWebService()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            switch response.result {
            case let .success(JSON):
                self.handleSuccessResponseGetNecropsy(JSON)
                break
            case let .failure(error):
                debugPrint(error.localizedDescription)
                //completion(nil, error as NSError)
                break
            }
        }
    }
    
    func callWebService() {
        if WebClass.sharedInstance.connected() {
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
            let keychainHelper = AccessTokenHelper()
            accestoken = keychainHelper.getFromKeychain(keyed: Constants.accessToken) ?? ""
           // accestoken = UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
            let headers: HTTPHeaders = [
                authorization: accestoken,
                cacheControl: Constants.noStoreNoCache
            ]
            let Id = UserDefaults.standard.integer(forKey: "Id")
            let countryId = UserDefaults.standard.integer(forKey: "countryId")
            let Url = WebClass.sharedInstance.webUrl + "Setting/GetNecroCategoryObservationList?UserId=\(Id)&CountryId=\(countryId)"
            
            let urlString = URL(string: Url)
            sessionManager.request(urlString!, method: .get, headers: headers).responseJSON { response in
                
                guard let statusCode = response.response?.statusCode else {
                    print("Failed to get status code")
                    Helper.dismissGlobalHUD(self.view)
                    return
                }
                self.handleGetNecropsyAPIResponse(statusCode, response)
            }
        }
        
        else{
            self.appDelegate.globalDataArr = self.dataArray
            self.skelta(0)
            self.cocoii(1)
            self.gitract(2)
            self.res(3)
            self.immu(4)
            self.callCustmerWebService()
        }
    }
    
    // MARK: 🟠 Skeletan Info
    func skeltaInfoArr(){
        
        for i in 0..<dataSkeletaArray.count{
            let sketlaVal = dataSkeletaArray[i] as! Skeleta
            let obsName12 = sketlaVal.observationField
            var dict12 = [String: Any]()
            let skeltaArr12 = NSMutableArray()
            skeltaArr12.add(sketlaVal.observationId ?? 0)
            skeltaArr12.add(sketlaVal.observationId ?? 0)
            dict12[obsName12!] = skeltaArr12
        }
    }
    
    // MARK: 🟠 Coccidiosis
    func cocoii (_ tag: Int) {
        
        btnTag = 1
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
           
            var _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        dataCocoiiArray = CoreDataHandler().fetchAllCocoiiData()
        if dataCocoiiArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataCocoiiArray = CoreDataHandler().fetchAllCocoiiData()
        }
    }
    
    // MARK: 🟠 Skeletan
    func skelta (_ tag: Int) {
        btnTag = 0
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
            
            var  _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataSkeletaArray = CoreDataHandler().fetchAllSeettingdata()
        if dataSkeletaArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataSkeletaArray = CoreDataHandler().fetchAllSeettingdata()
        }
    }
    
    // MARK: 🟠 GiTract
    func gitract (_ tag: Int) {
        
        btnTag = 2
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
           
            var  _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataGiTractArray = CoreDataHandler().fetchAllGITractData()
        if dataGiTractArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataGiTractArray = CoreDataHandler().fetchAllGITractData()
        }
    }
    
    // MARK: 🟠 Respiratory
    func res (_ tag: Int) {
        btnTag = 3
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
          
            var  _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataRespiratoryArray = CoreDataHandler().fetchAllRespiratory()
        if dataRespiratoryArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataRespiratoryArray = CoreDataHandler().fetchAllRespiratory()
        }
    }
    
    
    // MARK: 🟠 Immune
    func immu (_ tag: Int) {
        btnTag = 4
        
        if WebClass.sharedInstance.connected() || dataArray.count > 0{
          
            var _temp = self.dataArray.object(at: btnTag) as! ServiceDataHolder
            serviceDataHldArr = _temp.ObservaionDetailsArr
        }
        
        dataImmuneArray = CoreDataHandler().fetchAllImmune()
        if dataImmuneArray.count == 0 {
            self.callSaveMethod1(serviceDataHldArr)
            dataImmuneArray = CoreDataHandler().fetchAllImmune()
        }
    }
    
    
    // MARK: 🟠 Save Session details in Local Database
    func callSaveMethod1( _ skeletaArr : NSArray) {
        
        for i in 0..<skeletaArr.count {
            
            let strObservationField = (skeletaArr.object(at: i) as AnyObject).value(forKey: "ObservationDescription") as! String
            let visibilityCheck = (skeletaArr.object(at: i) as AnyObject).value(forKey: "DefaultQLink") as! Bool
            let obsId = (skeletaArr.object(at: i) as AnyObject).value(forKey: "ObservationId") as! NSInteger
            let visibilitySwitch = (skeletaArr.object(at: i) as AnyObject).value(forKey: "Visibility") as! Bool
            let measure =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "Measure") as! String
            let lngIdValue =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! NSNumber
            let refId =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "ReferenceId") as! NSNumber
            let quickLinkIndex =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "SequenceId") as? Int
            
            var isVisibilityCheck = Bool()
            var isQuicklinksCheck = Bool()
            if visibilityCheck == true {
                isQuicklinksCheck = true
            }
            else if visibilityCheck == false {
                isQuicklinksCheck = false
            }
            if visibilitySwitch == true {
                isVisibilityCheck = true
            }
            else{
                isVisibilityCheck = false
            }
            
            if  btnTag == 0 {
                let settings = chickenCoreDataHandlerModels.saveSkeletaSettingsInDB(
                    strObservationField: strObservationField,
                        visibilityCheck: isVisibilityCheck,
                        quicklinks: isQuicklinksCheck,
                        strInformation: "xyz",
                        index: i,
                        dbArray: dataSkeletaArray,
                        obsId: obsId,
                        measure: measure,
                        isSync: false,
                        lngId: lngIdValue,
                        refId: refId,
                        quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandler().saveSettingsSkeletaInDatabase(settings)
            }
            else if btnTag == 1{
                
                let settingData = chickenCoreDataHandlerModels.saveCoccidiosisSettingDB(
                    strObservationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    strInformation: "xyz",
                    index: i,
                    dbArray: dataCocoiiArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )

                CoreDataHandler().saveSettingsCocoiiInDatabase(settingData)
                
                
            }
            else if btnTag == 2{
                let settingData = chickenCoreDataHandlerModels.saveGITractSettingData(
                    strObservationField: strObservationField,
                        visibilityCheck: isVisibilityCheck,
                        quicklinks: isQuicklinksCheck,
                        strInformation: "xyz",
                        index: i,
                        dbArray: dataGiTractArray,
                        obsId: obsId,
                        measure: measure,
                        isSync: false,
                        lngId: lngIdValue,
                        refId: refId,
                        quicklinkIndex: quickLinkIndex ?? 0
                )

                CoreDataHandler().saveSettingsGITractDatabase(settingData: settingData)
            }
            else if btnTag == 3{
                
                let settings = chickenCoreDataHandlerModels.saveRespiratorySettings(
                    strObservationField: strObservationField,
                       visibilityCheck: isVisibilityCheck,
                       quicklinks: isQuicklinksCheck,
                       strInformation: "xyz",
                       index: i,
                       dbArray: dataRespiratoryArray,
                       obsId: obsId,
                       measure: measure,
                       isSync: false,
                       lngId: lngIdValue,
                       refId: refId,
                       quicklinkIndex: quickLinkIndex ?? 0
                )

                CoreDataHandler().saveSettingsRespiratoryDatabase(settings: settings)
            }
            else{
                
                let settings = chickenCoreDataHandlerModels.saveImmuneSettings(
                       strObservationField: strObservationField,
                          visibilityCheck: isVisibilityCheck,
                          quicklinks: isQuicklinksCheck,
                          strInformation: "xyz",
                          index: i,
                          dbArray: dataImmuneArray,
                          obsId: obsId,
                          measure: measure,
                          isSync: false,
                          lngId: lngIdValue,
                          refId: refId,
                          quicklinkIndex: quickLinkIndex ?? 0
                )

                CoreDataHandler().saveSettingsImmuneDatabase(settings)
            }
        }
    }
    // MARK: 🟢 Get Route's Name & ID
    func callAddVaccination() {
        if WebClass.sharedInstance.connected() {

            ZoetisWebServices.shared.getRouteResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Route list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processRouteArray(jsonResponse)
                }
       })
 
        } else{
            self.failWithInternetConnection()
        }
    }
    
    
    private func processRouteArray(_ json: JSON) {
        guard let arr = json.array, !arr.isEmpty else {
            print("Route list is empty.")
            self.callCocoiiProgramService()
            return
        }

        let arraRoute = NSMutableArray()

        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid route data format: \(item)")
                continue
            }

            let routeData = NSMutableDictionary()
            routeData.setValue(tempDict["RouteName"] as? String ?? "", forKey: "RouteName")
            routeData.setValue(tempDict["RouteId"] as? Int ?? -1, forKey: "RouteId")
            routeData.setValue(tempDict["LanguageId"] as? Int ?? -1, forKey: "LanguageId")

            arraRoute.add(routeData)
        }

        self.RouteArray = CoreDataHandler().fetchRoute()

        if self.RouteArray.count == 0 {
            self.callSaveMethod(arraRoute)
        }

        self.callCocoiiProgramService()
    }

    
    
    // MARK: 🟠 Save Route Name & ID
    func callSaveMethod( _ routeArr : NSArray) {
        
        for i in 0..<routeArr.count {
            let routeId = (routeArr.object(at: i) as AnyObject).value(forKey: "RouteId") as! Int
            let languageId = (routeArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            let routeName = (routeArr.object(at: i) as AnyObject).value(forKey: "RouteName") as! String
            CoreDataHandler().saveRouteDatabase(routeId, routeName: routeName,lngId:languageId, dbArray: self.RouteArray, index: i)
        }
    }
    // MARK: 🟢 Get Customer's List
    
    func callCustmerWebService() {
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getCustomerListResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
               
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Customers list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    debugPrint(errorResult)
                    self?.showToastWithTimer(message: "Failed to get Customers list", duration: 3.0)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processCustomerArray(jsonResponse)
                }
            })
        } else{
            
            self.custmorArr = CoreDataHandler().fetchCustomer()
            if(self.custmorArr.count == 0){
                self.callSaveMethodforCustomer(self.arraCustmer)
            }
        }
    }
    
    private func processCustomerArray(_ json: JSON) {
        guard let arr = json.array, !arr.isEmpty else {
            self.showToastWithTimer(message: "Customer's list Data not found", duration: 3.0)
            print("Customer's list is empty.")
            self.complexService()
            return
        }

        var customerArray: [NSDictionary] = []

        for item in arr {
            guard let tempDict = item.dictionary else {
                print("Invalid data format for item: \(item)")
                continue
            }

            let customerName = tempDict["CustomerName"]?.string ?? "Unknown"
            let customerId = tempDict["CustomerId"]?.int ?? -1

            let dictData: NSDictionary = [
                "CustomerName": customerName,
                "CustomerId": customerId
            ]

            customerArray.append(dictData)
        }

        CoreDataHandler().deleteAllData("Custmer")
        self.callSaveMethodforCustomer(customerArray as NSArray)
        self.complexService()
    }

    
    
    // MARK: 🟠 Save Customer's name
    func callSaveMethodforCustomer( _ custmorArr : NSArray) {
        
        for i in 0..<custmorArr.count {
            let CustId = (custmorArr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! Int
            let CustName = (custmorArr.object(at: i) as AnyObject).value(forKey: "CustomerName") as! String
            CoreDataHandler().saveCustmerDatabase(CustId, CustName: CustName, dbArray: self.custmorArr, index: i)
        }
    }
    
    // MARK: 🟢 SalesRep data call Web Service *******************************************************/
    
    func callSalesRepWebService() {
        
        if WebClass.sharedInstance.connected() {

                ZoetisWebServices.shared.getSalesRepresentativeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                    guard let _ = self, error == nil else {
                        self?.showToastWithTimer(message: "Failed to get Sales Representatives list", duration: 3.0)
                        self?.dismissGlobalHUD(self?.view ?? UIView())
                        return
                    }
                    
                    let jsonResponse = JSON(json)
                    // Check for the "errorResult" key and handle errors
                    if let errorResult = jsonResponse["errorResult"].dictionary {
                        debugPrint(errorResult)
                        self?.showToastWithTimer(message: "Sales representatives Data not found", duration: 3.0)
                    }
                    
                    DispatchQueue.main.async {
                        self?.handleSalesRepresentative(json)
                    }
                    
                })

        } else{
            
            self.salesRepArr = CoreDataHandler().fetchSalesrep()
            if(self.salesRepArr.count == 0){
                self.callSaveMethodforSalesRep(self.arraSalesRep)
            }
            self.failWithInternetConnection()
        }
    }
    
    func handleSalesRepresentative(_ json: JSON)
    {
        
        if let arr = JSON(json).array, !arr.isEmpty {
            // Initialize the array to store sales representative data
            self.arraSalesRep = NSMutableArray()
            
            for item in arr {
                if let tempDict = item.dictionaryObject {
                    let dictDat = NSMutableDictionary()
                    dictDat.setValue(tempDict["SalesRepresentativeName"] as? String, forKey: "SalesRepresentativeName")
                    dictDat.setValue(tempDict["SalesRepresentativeId"] as? Int, forKey: "SalesRepresentativeId")
                    self.arraSalesRep.add(dictDat)
                } else {
                    print("Invalid data format in Sales Representative array: \(item)")
                }
            }
            
            CoreDataHandler().deleteAllData("Salesrep")
            self.callSaveMethodforSalesRep(self.arraSalesRep)
            self.callAddVaccination()
        } else {
            // Handle the case where the array is empty or nil
            print("No data received for Sales Representatives.")
            self.showToastWithTimer(message: "No data found for sales representative.", duration: 3.0)
            self.callAddVaccination()
        }
    }
    
    // MARK: 🟠 Save Sale's representative
    func callSaveMethodforSalesRep( _ SalesRepArr : NSArray) {
        
        for i in 0..<SalesRepArr.count {
            let SalesId = (SalesRepArr.object(at: i) as AnyObject).value(forKey: "SalesRepresentativeId") as? Int
            let SalesNameName = (SalesRepArr.object(at: i) as AnyObject).value(forKey: "SalesRepresentativeName") as? String
            CoreDataHandler().SalesRepDataDatabase(SalesId, salesRepName: SalesNameName, dbArray: self.salesRepArr, index: i)
        }
    }
    
    // MARK: 🟢********* CocoiiProgram data call Web Service *******************************************************/
    
    func callCocoiiProgramService() {
        if WebClass.sharedInstance.connected() {
 
            ZoetisWebServices.shared.getCocciProgramResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Cocci Program list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processCocoiiProgram(json)
                }
                
                
            })
            
        } else{
            self.failWithInternetConnection()
        }
        
    }
    
    private func processCocoiiProgram(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Cocci Program list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Cocci Program list is empty.")
            self.callSessionTypeService()
            return
        }

        let cocoiiProgramArray = NSMutableArray()
        CoreDataHandler().deleteAllData("CocciProgramPosting")

        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print(self.invalidItemStructureStr)
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["CocciProgramName"] as? String, forKey: "CocciProgramName")
            dictData.setValue(tempDict["CocciProgramId"] as? Int, forKey: "CocciProgramId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "LanguageId")
            cocoiiProgramArray.add(dictData)
        }

        self.cocoiiProgramArr = CoreDataHandler().fetchCocoiiProgram()
        if self.cocoiiProgramArr.count == 0 {
            self.callSaveMethodforCocoiiProgram(cocoiiProgramArray)
        }

        self.callSessionTypeService()
    }

    
    // MARK: 🟠 Save Coccidiosis Program
    func callSaveMethodforCocoiiProgram( _ cocoiArr : NSArray) {
        
        for i in 0..<cocoiArr.count {
            let cocoiiId = (cocoiArr.object(at: i) as AnyObject).value(forKey: "CocciProgramId") as! Int
            let selectdLngId = (cocoiArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            let cocoiiIdName = (cocoiArr.object(at: i) as AnyObject).value(forKey: "CocciProgramName") as! String
            CoreDataHandler().CocoiiProgramDatabase(cocoiiId, cocoiProgram: cocoiiIdName,lngId:selectdLngId,dbArray: self.cocoiiProgramArr, index: i)
        }
    }
    // MARK: 🟢 Get Session's Type
    
    func callSessionTypeService() {
        
        if WebClass.sharedInstance.connected() {

            ZoetisWebServices.shared.getSessionTypeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Session's type list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processSessionTypeResponse(json)
                    
                }
                
            })

        } else{
            self.failWithInternetConnection()
        }
    }
    
    private func processSessionTypeResponse(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Session Type list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Session Type list is empty.")
            self.callBirdTypeService()
            return
        }

        let sessionTypeArray = NSMutableArray()
        CoreDataHandler().deleteAllData("Sessiontype")

        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print(self.invalidItemStructureStr)
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["SessionTypeName"] as? String, forKey: "SessionTypeName")
            dictData.setValue(tempDict["SessionTypeId"] as? Int, forKey: "SessionTypeId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "LanguageId")
            sessionTypeArray.add(dictData)
        }

        self.sessiontypeArr = CoreDataHandler().fetchSessiontype()
        if self.sessiontypeArr.count == 0 {
            self.callSaveMethodforSessiontype(sessionTypeArray)
        }

        self.callBirdTypeService()
    }

    
    // MARK: 🟠 Save Session type
    func callSaveMethodforSessiontype( _ seessionTypeArr : NSArray) {
        
        for i in 0..<seessionTypeArr.count {
            let SessionId = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "SessionTypeId") as! Int
            let sessionName = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "SessionTypeName") as! String
            let lngIdIs = (seessionTypeArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            CoreDataHandler().SessionTypeDatabase(SessionId, sesionType: sessionName, lngId: lngIdIs as NSNumber, dbArray: self.sessiontypeArr, index: i)
        }
    }
    
    // MARK: 🟢******** BirdSize data call Web Service *******************************************************/
    
    func callBirdTypeService() {
        
        if WebClass.sharedInstance.connected() {
 
            ZoetisWebServices.shared.getBirdSizeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Bird Size list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processBirdSizeResponse(json)
                }
                
            })
  
        } else{
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    private func processBirdSizeResponse(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Bird Size list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Bird Size list is empty.")
            self.callBreedService()
            return
        }

        let birdSizeArray = buildBirdSizeArray(from: arr)

        self.birdSizeArr = CoreDataHandler().fetchBirdSize()
        if self.birdSizeArr.count == 0 {
            self.callSaveMethodforBirdSize(birdSizeArray)
        }

        self.callBreedService()
    }

    private func buildBirdSizeArray(from array: [JSON]) -> NSMutableArray {
        let result = NSMutableArray()
        CoreDataHandler().deleteAllData("BirdSizePosting")

        for item in array {
            guard let tempDict = item.dictionaryObject else {
                print(self.invalidItemStructureStr)
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["BirdSize"] as? String, forKey: "BirdSize")
            dictData.setValue(tempDict["BirdSizeId"] as? Int, forKey: "BirdSizeId")
            dictData.setValue(tempDict["ScaleType"] as? String, forKey: "ScaleType")
            result.add(dictData)
        }

        return result
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: 🟠 Save Bird Size
    func callSaveMethodforBirdSize( _ birdSizeTypeArr : NSArray) {
        
        for i in 0..<birdSizeTypeArr.count {
            let birdSizeId = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "BirdSizeId") as! Int
            let birdSizeName = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "BirdSize") as! String
            let birdtype = (birdSizeTypeArr.object(at: i) as AnyObject).value(forKey: "ScaleType") as! String
            CoreDataHandler().BirdSizeDatabase(birdSizeId, birdSize: birdSizeName, scaleType: birdtype, dbArray: self.birdSizeArr, index: i)
        }
    }
    // MARK: 🟢******** Breed type data call Web Service *******************************************************/
    
    func callBreedService() {
        
        if WebClass.sharedInstance.connected() {
 
            ZoetisWebServices.shared.getBirdBreedChickenAndTurkeyResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Bird Size list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                DispatchQueue.main.async {
                    self?.processBreedResponse(json)
                }
                
            })
            
        } else{
            print(appDelegateObj.testFuntion())
        }
    }
    
    private func processBreedResponse(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print(Constants.noDataReceivedStr)
            self.showToastWithTimer(message: Constants.noDataRecieved, duration: 3.0)
            return
        }

        let breedArray = buildBreedArray(from: arr)

        self.breedArr = CoreDataHandler().fetchBreedType()
        if self.breedArr.count == 0 {
            self.callSaveMethodforBreedType(breedArray)
        }

        self.FeedProgramMoleculeService()
    }

    private func buildBreedArray(from array: [JSON]) -> NSMutableArray {
        let result = NSMutableArray()

        for item in array {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid data format in array: \(item)")
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["BirdBreedType"] as? String, forKey: "BirdBreedType")
            dictData.setValue(tempDict["BirdBreedName"] as? String, forKey: "BirdBreedName")
            dictData.setValue(tempDict["BirdBreedId"] as? Int, forKey: "BirdBreedId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "LanguageId")
            result.add(dictData)
        }

        return result
    }

    // MARK: 🟠 Save Breed type
    func callSaveMethodforBreedType( _ breedTypeArr : NSArray) {
        
        for i in 0..<breedTypeArr.count {
            let breeId = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedId") as! Int
            let breedName = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedName") as! String
            let breedType = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "BirdBreedType") as! String
            let languageId = (breedTypeArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! Int
            CoreDataHandler().BreedTypeDatabase(breeId, breedType: breedType, breedName: breedName, lngId: languageId, dbArray: self.breedArr, index: i)
        }
    }
    // MARK: 🟠 Load Custome Popup
    func clickHelpPopUp() {
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonbg.addTarget(self, action: #selector(DashViewController.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 210, y: 60, width: 150, height: 130))
    }
    // MARK: 🟠 Dismiss Popup
    func cancelMethod(){
        customPopView1.removeView(view)
    }
    @objc func buttonPressed1() {
        customPopView1.removeView(view)
        buttonbg.removeFromSuperview()
    }
    
    func DoneMethod(_ EmailUsers: String!){
        customPopView1.removeView(view)
    }
    // MARK: 🟠 Side Menu Button Action
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out" || indexValue == "Cerrar sesión" || indexValue == "Déconnexion" || indexValue == "Sair"
        {
            self.ssologoutMethod()
            UserDefaults.standard.removeObject(forKey: "login")
            UserDefaults.standard.set(false, forKey: "newlogin")
            UserDefaults.standard.set(true, forKey: "callDraftApi")
            
            for controller in (self.navigationController?.viewControllers ?? []) as Array {
                if controller.isKind(of: ViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            buttonbg.removeFromSuperview()
            customPopView1.removeView(view)
        }
        else{
            guard let url = URL(string: "https://mypoultryview360.com") else {
                return
            }
            UIApplication.shared.open(url)
            // https://mypoultryview360.com/
        }
    }
    
    // MARK: 🟠  /*********** Logout SSO Account **************/
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
    
    
    // MARK: 🟢 Get feed Program & Molecule Service
    
    fileprivate func handleAPIReponseFeedProgramCategory(_ json: JSON) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Check if the JSON response contains an error message
            if let jsonDict = JSON(json).dictionary,
               let errorMessage = jsonDict["Message"]?.string {
                print("Error from API Feed Program molecule: \(errorMessage)")
                self.showToastWithTimer(message: errorMessage, duration: 3.0)
                return
            }
            
            if let arr = JSON(json).array, !arr.isEmpty {
                self.FeedProgramArray = NSMutableArray() // Ensure it is mutable
                
                for i in 0..<arr.count {
                    let tempDict  = arr[i].dictionaryObject as NSDictionary? // Convert JSON to NSDictionary
                    tempDict!.value(forKey: "FeedProgramCategoryDescription") as! String
                    tempDict!.value(forKey: "FeedProgramCategoryId") as! Int
                    self.FeedProgramArray.add(tempDict as Any)
                    
                }
                
                // Store in UserDefaults
                UserDefaults.standard.set(self.FeedProgramArray, forKey: "Molucule")
                
                // Proceed with the next function call
                self.callGetCocciVaccine()
            } else {
                // Handle empty array case
                print("Feed Program molecule list is empty.")
                self.callGetCocciVaccine()
            }
            
        }
    }
    
    func FeedProgramMoleculeService() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getFeedProgramCatagoryAndMoleculeDetailsResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Feed Program molecule list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                self?.handleAPIReponseFeedProgramCategory(json)
                
            })
            
        } else{
            self.failWithInternetConnection()
        }
    }
 
    // MARK: 🟢 Get Cocci Vaccine List
    func callGetCocciVaccine() {
        if WebClass.sharedInstance.connected() {
            ZoetisWebServices.shared.getCocciVaccineTurkeyResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                         guard let _ = self, error == nil else {
                             self?.showToastWithTimer(message: "Failed to get Cocci Vaccine's list", duration: 3.0)
                             self?.dismissGlobalHUD(self?.view ?? UIView())
                             
                             return
                         }
                         
                         let jsonResponse = JSON(json)
                         // Check for the "errorResult" key and handle errors
                         if let errorResult = jsonResponse["errorResult"].dictionary {
                             let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                             
                             self?.callLoginMethod(errorCode)
                         }
                self?.processCocciVaccineResponse(json)
             

         })
        
        } else{
            self.failWithInternetConnection()
        }
    }
    
    private func processCocciVaccineResponse(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Cocci Vaccine list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            self.callTargetWeightProcessing()
            return
        }

        CoreDataHandler().deleteAllData("CocoiVaccine")

        for item in arr {
            guard let dict = item.dictionary else {
                print("Invalid data format in array: \(item)")
                continue
            }

            if let id = dict["CocciVaccineId"]?.int,
               let name = dict["CocciVaccineName"]?.string,
               let langId = dict["LanguageId"]?.int {
                CoreDataHandler().saveCocoiiVac(id, decscMolecule: name, lngId: langId)
            } else {
                print("Missing required fields in JSON item: \(dict)")
            }
        }

        UserDefaults.standard.set(self.cocciVaccine, forKey: "cocci")
        self.callTargetWeightProcessing()
    }

    
    
    // MARK: 🟢 Get Target Weight Processing List
    func callTargetWeightProcessing() {
        if WebClass.sharedInstance.connected() {
  
            ZoetisWebServices.shared.getTargetWeightResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Target Weight Processing List", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async {
                    self?.processTargetWeightResponse(json)
                }

                
            })

        } else{
            self.failWithInternetConnection()
        }
    }
    
    private func processTargetWeightResponse(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let dataArray = JSON(json).array, !dataArray.isEmpty else {
            print(Constants.noDataReceivedStr)
            self.showToastWithTimer(message: Constants.noDataRecieved, duration: 3.0)
            self.getListFarms()
            return
        }

        let targetWeightArray = NSMutableArray()

        for item in dataArray {
            guard let dictionary = item.dictionaryObject else {
                print("Invalid data format in array: \(item)")
                continue
            }
            targetWeightArray.add(dictionary)
        }

        // Store in UserDefaults
        UserDefaults.standard.set(targetWeightArray, forKey: "target")

        // Assign to instance variable
        self.targetWeight = targetWeightArray

        // Proceed to next API call
        self.getListFarms()
    }

    
    
    // MARK: 🟢 Get Complex's List  ✅  Zoetis Call
    func complexService() {
        if WebClass.sharedInstance.connected() {
        
                ZoetisWebServices.shared.getChickenTurkeyComplexByUserIdResponce(controller: self, parameters: ["UserId" :"UserId"], completion: { [weak self] (json, error) in
                    guard let _ = self, error == nil else {
                        self?.showToastWithTimer(message: "Failed to get Complex list", duration: 3.0)
                        self?.dismissGlobalHUD(self?.view ?? UIView())
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.processComplexArray(json)                    }
                })
        } else {
            self.complexArr = CoreDataHandler().fetchCompexType()
            if(self.complexArr.count == 0) {
                self.callcomplexService(self.complexSize)
            }
            self.failWithInternetConnection()
        }
    }
    
    
    private func processComplexArray(_ json: Any) {
        guard let arr = JSON(json).array, !arr.isEmpty else {
            print(Constants.noDataReceivedStr)
            self.showToastWithTimer(message: Constants.noDataRecieved, duration: 3.0)
            self.callSalesRepWebService()
            return
        }

        CoreDataHandler().deleteAllData("ComplexPosting")
        self.complexSize = NSMutableArray()

        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print("Invalid data format in array: \(item)")
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["CustomerId"] as? Int, forKey: "CustomerId")
            dictData.setValue(tempDict["ComplexName"] as? String, forKey: "ComplexName")
            dictData.setValue(tempDict["ComplexId"] as? Int, forKey: "ComplexId")

            self.complexSize.add(dictData)
        }

        self.callcomplexService(self.complexSize)
        self.callSalesRepWebService()
    }

    
    
    // MARK: 🟠 Save Complex Name
    func callcomplexService( _ complexArrrr : NSArray) {
        
        for i in 0..<complexArrrr.count {
            let custmerId = (complexArrrr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! NSNumber
            let custmerName = (complexArrrr.object(at: i) as AnyObject).value(forKey: "ComplexName") as! String
            let complexid = (complexArrrr.object(at: i) as AnyObject).value(forKey: "ComplexId") as! NSNumber
            CoreDataHandler().ComplexDatabase(complexid, cutmerid: custmerId, complexName: custmerName, dbArray: complexArr, index: i)
        }
    }
    // MARK: 🟢 Get Veterinarian List from server
    func callVeterianService() {
        
        if WebClass.sharedInstance.connected() {
       
            ZoetisWebServices.shared.getVeterinarianResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: Constants.failedtogetVeterinarianListlist, duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    debugPrint(errorResult)
                    self?.showToastWithTimer(message: Constants.failedtogetVeterinarianListlist, duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processVeterinarianArray(json)
                }
                
            })
            
        } else{
            
            self.veterianArr = CoreDataHandler().fetchVetData()
            if(self.veterianArr.count == 0){
                self.callSaveMethodforeterian(self.arraVetType)
            }
            self.failWithInternetConnection()
            
        }
    }
    
    private func processVeterinarianArray(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Veterinarian List: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Veterinarian List is empty.")
            self.showToastWithTimer(message: Constants.failedtogetVeterinarianListlist, duration: 3.0)
            self.callhatcheryStrain()
            return
        }

        self.arraVetType = NSMutableArray()
        CoreDataHandler().deleteAllData("Veteration")

        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print(self.invalidItemStructureStr)
                continue
            }

            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["VeterinarianName"] as? String, forKey: "VeterinarianName")
            dictData.setValue(tempDict["VeterinarianId"] as? Int, forKey: "VeterinarianId")

            arraVetType.add(dictData)
        }

        self.callSaveMethodforeterian(self.arraVetType)
        self.callhatcheryStrain()
    }

    
    // MARK: 🟢 Get Hatchery Strain List from server
    func callhatcheryStrain() {
        
        if WebClass.sharedInstance.connected() {
       
            ZoetisWebServices.shared.getTurkeyHatcheryStrainResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Hatchery Strain list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    debugPrint(errorResult)
                    self?.showToastWithTimer(message: "Failed to get Hatchery Strain list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processHatcheryStrainArray(json)
                }
            })

        } else{
            self.failWithInternetConnection()
        }
    }
    
    
    private func processHatcheryStrainArray(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Hatchery Strain list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Hatchery strain list is empty.")
            self.showToastWithTimer(message: "No hatchery strain data found on the server.", duration: 3.0)
            self.callGetFieldStrain()
            return
        }

        CoreDataHandler().deleteAllData("HatcheryStrain")

        for item in arr {
            if let strainDict = item.dictionary {
                let strainId = strainDict["StrainId"]?.int ?? -1
                let strainName = strainDict["StrainName"]?.string ?? "Unknown"
                let langID = strainDict["LanguageId"]?.int ?? -1

                CoreDataHandler().SaveStrainDataDatabase(strainName, StrainId: strainId, lngId: langID)
            } else {
                print("Invalid data format for HatcheryStrain: \(item)")
            }
        }

        self.callGetFieldStrain()
    }

    
    
    // MARK: 🟢 Get Field Strain List from server
    func callGetFieldStrain() {
        
        if WebClass.sharedInstance.connected() {
      
            ZoetisWebServices.shared.getTurkeyFieldStrainResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Field Strain list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processFieldStrainArray(json)
                }
                
            })
         
        } else{
            
        }
    }
    
    private func processFieldStrainArray(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Field Strain list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Field Strain list is empty.")
            self.showToastWithTimer(message: "No field strain data found on the server.", duration: 3.0)
            self.callGetDosage()
            return
        }

        CoreDataHandler().deleteAllData("GetFieldStrain")

        for item in arr {
            if let strainDict = item.dictionary {
                let strainId = strainDict["StrainId"]?.int ?? -1
                let strainName = strainDict["StrainName"]?.string ?? "Unknown"
                let langID = strainDict["LanguageId"]?.int ?? -1
                CoreDataHandler().SaveStrainDataDatabaseField(strainName, StrainId: strainId, lngId: langID)
            } else {
                print("Invalid data format for Field Strain: \(item)")
            }
        }

        self.callGetDosage()
    }

    
    // MARK: 🟢 Get Dossage List from server
    func callGetDosage() {
        
        if WebClass.sharedInstance.connected() {
      
            ZoetisWebServices.shared.getDosageResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Dossage list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                   
                    self?.DosageArrayProcessed(json)
                }
            })

        } else{
            print(appDelegateObj.testFuntion())
        }
    }
    
    private func DosageArrayProcessed(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Route list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            print("Get Dosage list is empty.")
            self.showToastWithTimer(message: "No data available from the server.", duration: 3.0)
            self.getProductionType()
            return
        }

        CoreDataHandler().deleteAllData("GetDosage")

        for item in arr {
            if let strainDict = item.dictionary {
                let doseId = strainDict["DoseId"]?.int ?? -1
                let doseName = strainDict["Dose"]?.string ?? "Unknown"
                CoreDataHandler().SaveDosageDataDatabaseField(doseName, doseId: doseId)
            } else {
                print("Invalid data format for Get Dosage: \(item)")
            }
        }

        self.getProductionType()
    }

    
    
    // MARK: 🟢 Get Dossage List with Molecule ID from server
    func callGetDosageWithMoleculeId() {
        
        if WebClass.sharedInstance.connected() {
            
            ZoetisWebServices.shared.getTurkeyDoseByMoleculeIdResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Dossage By Molecule ID list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                if let apiMessage = jsonResponse["Message"].string {
                    
                    self?.showAlert(title: "Alert", message: apiMessage, owner: self!)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                       return
                   }
                
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                    
                    self?.callLoginMethod(errorCode)
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.processDosageArray(json)
                }
            })
           
        } else{
            print(appDelegateObj.testFuntion())
        }
    }
    
    private func processDosageArray(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Dosage List with Molecule ID: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            Helper.dismissGlobalHUD(self.view)
            return
        }

        CoreDataHandler().deleteAllData("GetDosageWithMoleculeID")

        for item in arr {
            if let strainDict = item.dictionary {
                let doseId = strainDict["DoseId"]?.int ?? -1
                let doseName = strainDict["Dose"]?.string ?? "Unknown"
                let moleculeId = strainDict["MoleculeId"]?.int ?? -1
                CoreDataHandler().SaveDosageDataWithMoleculeIDDatabaseField(doseName, doseId: doseId, molecukeId: moleculeId)
            } else {
                print("Invalid data format for Dosage List with Molecule ID: \(item)")
            }
        }

        Helper.dismissGlobalHUD(self.view)
    }
    
    // MARK: 🟢  ZoetisWebServices Get production type List from server
    fileprivate func callLoginMethod(_ errorCode: String?) {
        if errorCode == "401" || errorCode == "404"{
            self.loginMethod()
        }
    }
    
    func getProductionType() {
        if WebClass.sharedInstance.connected() {
      
            ZoetisWebServices.shared.getProductionTypeResponce(controller: self, parameters: [:], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.showToastWithTimer(message: "Failed to get Production type list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorCode = errorResult["errorCode"]?.string ?? self?.unknownCodeStr
                     
                   
                    self?.callLoginMethod(errorCode)
                }
                
                self?.handleProductionTypeResponse(json)
            })
     
        } else{
            
            self.prodType = CoreDataHandler().fetchProductionType(lngID: lngId) as! NSMutableArray
            if(self.prodType.count == 0){
                self.callProductionType(self.prodType)
            }
            self.failWithInternetConnection()
        }
    }
    
    private func processProductionTypeData(_ json: Any) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error from API Production Type list: \(errorMessage)")
            self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }

        guard let arr = JSON(json).array, !arr.isEmpty else {
            Helper.dismissGlobalHUD(self.view)
            return
        }
        
        CoreDataHandler().deleteAllData("ProductionType")
        self.prodType = NSMutableArray()
        
        for item in arr {
            guard let tempDict = item.dictionaryObject else {
                print(self.invalidItemStructureStr)
                continue
            }
            let dictData = NSMutableDictionary()
            dictData.setValue(tempDict["Name"] as? String, forKey: "productionName")
            dictData.setValue(tempDict["Id"] as? Int, forKey: "productionId")
            dictData.setValue(tempDict["LanguageId"] as? Int, forKey: "langID")
            self.prodType.add(dictData)
        }
        
        self.callProductionType(self.prodType)
        self.callGetDosageWithMoleculeId()
       
    }

    
    private func handleProductionTypeResponse(_ json: Any) {
        let jsonResponse = JSON(json)
        
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let errorCode = errorResult["errorCode"]?.string ?? self.unknownCodeStr
            print("Error from ProductionType API: \(errorMsg) (Code: \(errorCode))")
            self.callLoginMethod(errorCode)
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.processProductionTypeData(json)
        }
    }

    
    
    
    
    
    // MARK: 🟠 Save Production type data
    func callProductionType( _ productionTypArrrr : NSArray) {
        
        for i in 0..<productionTypArrrr.count {
            let productionTypeName = (productionTypArrrr.object(at: i) as AnyObject).value(forKey: "productionName") as! String
            let productionTypeid = (productionTypArrrr.object(at: i) as AnyObject).value(forKey: "productionId") as! NSNumber
            let lngTypeid = (productionTypArrrr.object(at: i) as AnyObject).value(forKey: "langID") as! NSNumber
            CoreDataHandler().productionTypeDatabase(productionTypeid, productionName: productionTypeName, dbArray: prodTypeArray, index: i,lngID: lngTypeid)
        }
        
    }
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                
            }
        }
        return nil
    }
    // MARK: 🟠 Save Veterinarian data
    func callSaveMethodforeterian( _ veterianArray : NSArray) {
        var vetId = 0
        var vetName = ""
        for i in 0..<veterianArray.count {
            if let num = (veterianArray.object(at: i) as AnyObject).value(forKey: "VeterinarianId")
            {
                vetId = num as! Int
            }
            if let str = (veterianArray.object(at: i) as AnyObject).value(forKey: "VeterinarianName")
            {
                vetName = str as! String
            }
            
            CoreDataHandler().VetDataDatabase(vetId, vtName: vetName, complexId: 0, dbArray: self.veterianArr, index: i)
        }
    }
    // MARK: 🟠 Captured Necropsy Button Action
    @IBAction func captureNecropsyaAction(_ sender: AnyObject) {
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "CaptureNecropsy") as? CaptureNecropsyDataViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        
        
    }
    @IBOutlet weak var captureNecropsy2: UIButton!
    // MARK: 🟠 Unlinked NEcropsy button action
    @IBAction func unlinkedNecropsyBtnAction(_ sender: AnyObject) {
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "UnlinkedNecr") as? UnlinkedNecropsiesViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    // MARK: 🟢 ******************************* Get FarmList From Server ************************************* //
    
    fileprivate func handleFarmListName(_ value: Any) {
        if let arr = value as? [[String: Any]] {
            let formArray = arr.map { tempDict in
                [
                    "CountryId": tempDict["CountryId"] as? Int ?? 0,
                    "FarmId": tempDict["FarmId"] as? Int ?? 0,
                    "FarmName": tempDict["FarmName"] as? String ?? ""
                ]
            }
            
            CoreDataHandler().deleteAllData("FarmsList")
            self.callSaveMethodgetListFarms(formArray as NSArray)
        }
    }
    
    func getListFarms() {
        
        if WebClass.sharedInstance.connected() {
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let Id = UserDefaults.standard.integer(forKey: "Id")
            let parameters = ["userId" :Id]
            let Url = WebClass.sharedInstance.webUrl + "Farm/GetFarmListByUserId"
            let urlString = URL(string: Url)
            
            let headers: HTTPHeaders = [
                authorization: accestoken,
                cacheControl: Constants.noStoreNoCache
            ]
            sessionManager.request(urlString!, method: .post, parameters:parameters, headers: headers).responseJSON { response in
                
                let statusCode =  response.response?.statusCode
                if statusCode == 401{
                    self.loginMethod()
                }
                if statusCode == 204  || statusCode == 400 ||  statusCode == 404 ||  statusCode==500 {
                    self.callVeterianService()
                }
             
                else{
                    switch response.result {
                    case let .success(value):
                        
                        self.handleFarmListName(value)

                        self.callVeterianService()

                        break
                    case let .failure(error):
                        debugPrint(error.localizedDescription)
                        break
                    }
                }
            }
            
        } else{
            self.farmsListAray = CoreDataHandler().fetchFarmsDataDatabase()
            if(self.farmsListAray.count == 0){
                self.callSaveMethodgetListFarms( self.getFormArray)
            }
        }
    }
    // MARK: 🟠 Save Farm's in Local Database
    func callSaveMethodgetListFarms(_ farmsArray : NSArray) {
        
        for i in 0..<farmsArray.count {
            let FarmId = (farmsArray.object(at: i) as AnyObject).value(forKey: "FarmId") as! NSNumber
            let FarmName = (farmsArray.object(at: i) as AnyObject).value(forKey: "FarmName") as! String
            let CountryId = (farmsArray.object(at: i) as AnyObject).value(forKey: "CountryId") as! NSNumber
            /***************** All details Save in to FarmdataBase ****************************************/
            CoreDataHandler().FarmsDataDatabase("", stateId: 0, farmName: FarmName, farmId: FarmId, countryName: "", countryId: CountryId, city: "")
        }
    }
    // MARK: 🟠 Get All Session's List
    func allSessionArr() ->NSMutableArray{
        
        let allPostingArrWithData = CoreDataHandler().fetchPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        if let pSession = allPostingArrWithData.firstObject as? PostingSession {
            Constants.isFromPsoting = (pSession.isfarmSync != nil) // for warnig Refactor this loop to do more than one iteration.
        }

        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId{
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        for i in 0..<allPostingArrWithData.count
        {
            let pSession = allPostingArrWithData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        return allPostingSessionArr
    }
    // MARK: 🟠 Sync Button Action
    @IBAction func SyncButtonAction(_ sender: AnyObject) {
        if self.allSessionArr().count > 0
        {
            if ConnectionManager.shared.hasConnectivity() {
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data sync is in progress, please do not close the app. \n*Note - Please don't minimize App while syncing.", comment: ""))
                UserDefaults.standard.removeObject(forKey: "postingSession")
                self.callSyncApi()
            }
            else{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offLineMsg, comment: ""))
            }
        }
        else{
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            var strMsg = String()
            if lngId == 5 {
                strMsg = "Datos no disponibles para la sincronización."
            } else if lngId == 3 {
                strMsg = "Aucune données disponible pour la synchronisation."
            }else if lngId == 1{
                strMsg = "Data not available for syncing."
            }
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:strMsg)
        }
    }
    // MARK: 🟢 Sync API method call for Feed Program
    func callSyncApi()
    {
        self.isSync = false
        let arr = self.allSessionArr() 
        for postingIdIs in arr {
            if isSync == false {
                isSync = true
                if (UserDefaults.standard.value(forKey: "postingSession") != nil){
                    Constants.isFromPsoting = UserDefaults.standard.value(forKey: "postingSession") as? Bool ?? false
                    if Constants.isFromPsoting
                    {
                        UserDefaults.standard.removeObject(forKey: "postingSession")
                        objApiSyncOneSet.feedprogram(postingId: NSNumber(value: postingIdIs as! Int))
                    }
                    else{
                        objApiSync.feedprogram()
                    }
                }else{
                    objApiSync.feedprogram()
                }
            }
            AllValidSessions.sharedInstance.complexName = "" // New Change
        }
    }
    // MARK: 🟠 No Internet Alert Message
    func failWithError(statusCode:Int)
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            } else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
        }
    }
    
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
 
    // MARK: 🟠 Alert Message
    func promtSyncing (){
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleFont = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: helveticaLight, size: 19.0)]
        let messageFont = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: helveticaLight, size: 12.0)]
        let myMsgString = NSLocalizedString("Data available for sync. Do you want to sync now? \n\n\n *Note - Please don't minimize App while syncing.", comment: "")
        let titleAttrString = NSMutableAttributedString(string: NSLocalizedString(Constants.alertStr, comment: ""), attributes: convertToOptionalNSAttributedStringKeyDictionary(titleFont))
        var messageAttrString = NSMutableAttributedString(string: myMsgString , attributes: convertToOptionalNSAttributedStringKeyDictionary(messageFont))
        messageAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:50,length:52))
        let font = UIFont(name: helveticaLight, size: 11.0)
        messageAttrString.addAttribute(NSAttributedString.Key.font, value:font!, range: NSRange.init(location: 50 , length: 52))
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            if self.allSessionArr().count > 0
            {
                if ConnectionManager.shared.hasConnectivity() {
                    DispatchQueue.main.async {
                        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data sync is in progress, please do not close the app. \n*Note - Please don't minimize App while syncing.", comment: ""))
                        self.callSyncApi()
                    }
                }
                else{
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(self.offLineMsg, comment: ""))
                }
            }
            else{
                self.lngId = UserDefaults.standard.integer(forKey: "lngId")
                var strMsg = String()
                if self.lngId == 5 {
                    strMsg = "Datos no disponibles para la sincronización."
                } else if self.lngId == 3 {
                    strMsg = "Aucune données disponible pour la synchronisation."
                }
                else if self.lngId == 1{
                    strMsg = "Data not available for syncing."
                }
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:strMsg)
            }
            Helper.dismissGlobalHUD(self.view)
        }
        let CancelAction = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.iSfarmSync()
            self.printSyncLblCount()
            UserDefaults.standard.set(false, forKey: "promt")
            AllValidSessions.sharedInstance.complexName = "" // New Change
        }
        alertController.addAction(okAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: 🟠 APi Sync finished Sucessfully
    func didFinishApi()
    {
        self.printSyncLblCount()
        if self.allSessionArr().count > 0 {
            self.showToastWithTimer(message: "Assessment synced successfully. Please Wait while we set this up for you.", duration: 2.0)
            self.isSync = false
            self.callSyncApi()
        }
        else {
            Helper.dismissGlobalHUD(self.view)
            let alertView = UIAlertController(title:NSLocalizedString(Constants.alertStr, comment: "") , message:NSLocalizedString(Constants.dataSyncCompleted, comment: ""), preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title:NSLocalizedString("OK", comment: "") , style: .default, handler: { (alertAction) -> Void in
                self.iSfarmSync()
                
            }))
            present(alertView, animated: true, completion: nil)
        }
    }
    // MARK: 🟠 Hit login API
    func loginMethod(){
        if WebClass.sharedInstance.connected() {
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
            let userName = PasswordService.shared.getUsername()
            let pass =  PasswordService.shared.getPassword()
            let Url = "Token"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            let headers: HTTPHeaders = [Constants.contentType: "application/x-www-form-urlencoded",
                                        "Accept": "application/json",
                                        cacheControl: Constants.noStoreNoCache]
            
            let parameters:[String:String] = ["grant_type": "password","UserName" : CryptoHelper.encrypt(input: userName) as! String, "Password" : CryptoHelper.encrypt(input: pass) as! String,"LoginType": "Web","DeviceId":udid as! String]
            
            sessionManager.request(urlString, method: .post, parameters: parameters, headers: headers).responseJSON { response in
                switch response.result {
                case let .success(value):
                    let statusCode = response.response?.statusCode
                    let dict : NSDictionary = value as! NSDictionary
                    if statusCode == 400 || statusCode == 401{
                        _ = dict["error_description"]
                        self.callLoginView()
                    }
                    else{
                        let acessToken = (dict.value(forKey: "access_token") as? String)!
                        let tokenType = (dict.value(forKey: "token_type") as? String)!
                        let aceesTokentype: String = tokenType + " " + acessToken
                        _ = dict.value(forKey: "HasAccess")! as AnyObject
                        
                        
                        let keychainHelper = AccessTokenHelper()
                        keychainHelper.saveToKeychain(valued: aceesTokentype, keyed: Constants.accessToken)
                      //  UserDefaults.standard.set(aceesTokentype,forKey: Constants.accessToken)
                        UserDefaults.standard.synchronize()
                        Helper.dismissGlobalHUD(self.view)
                        self.callWebService()
                    }
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    break
                }
            }
        }
    }
    // MARK: 🟠 Move to Login view
    func callLoginView()  {
        UserDefaults.standard.removeObject(forKey: "login")
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
// MARK: 🟠 - EXTENSION
extension DashViewController{
    // MARK: 🟠 API Fail Sync Delegates
    func failWithErrorSyncdata(statusCode:Int){
        Helper.dismissGlobalHUD(self.view)
        
        self.printSyncLblCount()
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            }
            else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
            else if lngId == 4 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Há problemas na sincronização de dados, tente novamente. \n(\(statusCode))")
            }
        }
    }
    
    func failWithErrorInternalSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Server error please try again .", comment: "") )
    }
    func didFinishApiSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
        self.printSyncLblCount()
    }
    func failWithInternetConnectionSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offLineMsg, comment: ""))
    }
}

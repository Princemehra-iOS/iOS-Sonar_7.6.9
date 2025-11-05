//
//  ExistingPostingSessionViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 04/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import Reachability
import SystemConfiguration
import Gigya
import GigyaTfa
import GigyaAuth

class ExistingPostingSessionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,userLogOut,UITextFieldDelegate,startNecropsyP,syncApi {
    
    // MARK: - Variables
    let editFinalizeValue = 2
    var lngId = NSInteger()
    var fromDate = Date()
    var toDate   = Date()
    var fromString = String()
    var toString = String()
    var dateFormatterIs = DateFormatter()
    let objApiSync = ApiSync()
    
    var customPopView1 :UserListView!
    let buttonbg1 = UIButton ()
    let buttonbg2 = UIButton ()
    var buttonback = UIButton()
    var customPopV :startNecropsyXib!
    var finializeB = NSNumber()
    
    let buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    let textCellIdentifier = "cell"
    var buttonBg = UIButton()
    var datePicker : UIDatePicker!
    var fetchcustRep = NSArray ()
    
    var complexTypeFetchArray = NSMutableArray()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    let cellReuseIdentifier = "cell"
    var imageChange = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Outlets
    @IBOutlet weak var syncNotiCount: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromLblDate: UILabel!
    @IBOutlet weak var toLblDate: UILabel!
    @IBOutlet weak var fromLblDateFrench: UILabel!
    @IBOutlet weak var toLblDateFrench: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    @IBOutlet weak var searchWidComplexName: UITextField!
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    
    // MARK: 🟠 - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ExistingPostingSessionViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        searchWidComplexName.layer.borderWidth = 1
        searchWidComplexName.layer.cornerRadius = 3.5
        searchWidComplexName.layer.borderColor = UIColor.black.cgColor
        objApiSync.delegeteSyncApi = self
        
        let lngid = UserDefaults.standard.integer(forKey: "lngId")
        if lngid == 3{
            fromLblDate.alpha = 0
            toLblDate.alpha = 0
            dateFormatterIs = DateFormatter()
            dateFormatterIs = DateFormatter()
            dateFormatterIs.dateFormat = Constants.ddMMyyyStr
            dateFormatterIs = DateFormatter()
            dateFormatterIs.dateFormat = Constants.ddMMyyyStr
            fromLblDateFrench.text = dateFormatterIs.string(from: Date())
            toLblDateFrench.text = dateFormatterIs.string(from: Date())
        }
        else{
            fromLblDateFrench.alpha = 0
            toLblDateFrench.alpha = 0
            fromLblDate.alpha = 1
            toLblDate.alpha = 1
        }     
        var dateFormatterOther = DateFormatter()
        dateFormatterOther.dateFormat = Constants.MMddyyyyStr
        dateFormatterOther = DateFormatter()
        dateFormatterOther.dateFormat = Constants.MMddyyyyStr

        fromString = dateFormatterOther.string(from: Date())
        toString = dateFormatterOther.string(from: Date())
        fromLblDate.text = fromString
        toLblDate.text = toString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        self.printSyncLblCount()
        searchWidComplexName.delegate = self
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        tableView.tableFooterView = UIView()
        existingArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionWithCapId(1).mutableCopy() as! NSMutableArray
        
        for i in 0..<existingArray.count{
            let postingSession : PostingSession = existingArray.object(at: i) as! PostingSession
            let pid = postingSession.postingId
            let farms = CoreDataHandler().fetchNecropsystep1neccIdFeedProgram(pid!)
            if farms.count > 0 {
                CoreDataHandler().updatedPostigSessionwithIsFarmSyncPostingId(pid!, isFarmSync: true)
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        complexTypeFetchArray = CoreDataHandler().fetchCompexType().mutableCopy() as! NSMutableArray
        if  let data = CoreDataHandler().fetchCompexType() as? NSArray {
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonDroper.addTarget(self, action: #selector(ExistingPostingSessionViewController.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.delegate = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.lightGray.cgColor
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
    }
    
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 🟠- IBACTIONS
    
    @IBAction func sliderButtonAction(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    // MARK: 🟠 From date Button Action
    @IBAction func fromDateAction(_ sender: AnyObject) {
        view.endEditing(true)
        
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(ExistingPostingSessionViewController.buttonPressed), for: .touchUpInside)
        
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(ExistingPostingSessionViewController.doneClick)
        
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(ExistingPostingSessionViewController.cancelClick)
        
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
    }
    // MARK: Tab on Screen Action
    @objc func buttonPressed() {
        buttonBg.removeFromSuperview()
    }
    
    // MARK: 🟠 From date DONE Button Action
    @objc func doneClick() {
        
        let donelngId = UserDefaults.standard.integer(forKey: "lngId")
        if donelngId == 3{
            fromLblDate.alpha = 0
            fromLblDateFrench.alpha = 1
            dateFormatterIs = DateFormatter()
            dateFormatterIs.dateFormat = Constants.ddMMyyyStr
            let strdate = dateFormatterIs.string(from: datePicker.date) as String
            fromLblDateFrench.text = strdate
        }
        else{
            fromLblDate.alpha = 1
            fromLblDateFrench.alpha = 0
        }
        
        dateFormatterIs = DateFormatter()
        dateFormatterIs.dateFormat = Constants.MMddyyyyStr
        dateFormatterIs = DateFormatter()
        dateFormatterIs.dateFormat = Constants.MMddyyyyStr
        fromString = dateFormatterIs.string(from: datePicker.date)
        fromDate = datePicker.date
        
        if fromString == toString || fromDate.isLessThanDate(toDate) {
            // Handle language-specific UI changes
            if lngId == 3 {
                fromLblDate.alpha = 0
                fromLblDateFrench.alpha = 1
                dateFormatterIs = DateFormatter()
                dateFormatterIs.dateFormat = Constants.ddMMyyyStr
                let strdate = dateFormatterIs.string(from: datePicker.date)
                fromLblDateFrench.text = strdate
            } else {
                fromLblDate.alpha = 1
                fromLblDateFrench.alpha = 0
            }
            
            // Update both labels with the formatted date
            let strdate = dateFormatterIs.string(from: datePicker.date)
            fromLblDate.text = strdate
            
            // Save the date to UserDefaults
            UserDefaults.standard.set(fromLblDate.text, forKey: "date")
            
            // Final UI updates
            buttonBg.removeFromSuperview()
            tableView.reloadData()
        }
        else {
            self.cancelClick()
            
            fromString = fromLblDate.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            fromDate = dateFormatter.date(from: fromString)!
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                let title = NSLocalizedString(Constants.alertStr, comment: "")
                let message = NSLocalizedString("From date must be smaller than to date.", comment: "")
                
                Helper.showAlertMessage(rootViewController, titleStr: title, messageStr: message)
            }
        }
    }
    // MARK: 🟠Cancel Button Action
    @objc func cancelClick() {
        buttonBg.removeFromSuperview()
    }
    // MARK: 🟠 To date Button Action
    @IBAction func toDateAction(_ sender: AnyObject) {
        
        view.endEditing(true)
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(ExistingPostingSessionViewController.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(ExistingPostingSessionViewController.todoneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(ExistingPostingSessionViewController.cancelClick)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
        
    }
    // MARK: 🟠 To date DONE Button Action
    @objc func todoneClick() {
        
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3{
            toLblDate.alpha = 0
            toLblDateFrench.alpha = 1
            dateFormatterIs = DateFormatter()
            dateFormatterIs.dateFormat = Constants.ddMMyyyStr
            let strdate = dateFormatterIs.string(from: datePicker.date) as String
            toLblDateFrench.text = strdate
        }
        else{
            toLblDate.alpha = 1
            toLblDateFrench.alpha = 0
        }
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = Constants.MMddyyyyStr
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = Constants.MMddyyyyStr
        toString = dateFormatter1.string(from: datePicker.date)
        toDate = datePicker.date
        
        if fromString == toString || toDate.isGreaterThanDate(fromDate) {
            
            if lngId == 3{
                toLblDate.alpha = 0
                dateFormatterIs = DateFormatter()
                dateFormatterIs.dateFormat = Constants.ddMMyyyStr
                let strdate = dateFormatterIs.string(from: datePicker.date) as String
                toLblDateFrench.text = strdate
            }
            else{
                toLblDate.alpha = 1
                toLblDateFrench.alpha = 0
            }
            
            let strdate = dateFormatter2.string(from: datePicker.date) as String
            toLblDate.text = strdate
            UserDefaults.standard.set( toLblDate.text, forKey: "date")
            buttonBg.removeFromSuperview()
            tableView.reloadData()
            
        }
        
        else {
            self.cancelClick()
            fromString = toLblDate.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            toDate = dateFormatter.date(from: fromString)!
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                let title = NSLocalizedString(Constants.alertStr, comment: "")
                let message = NSLocalizedString("To date must be greater than from date.", comment: "")
                Helper.showAlertMessage(rootViewController, titleStr: title, messageStr: message)
            }
         
        }
    }
    // MARK: 🟠 Logout button Action
    @IBAction func logOutBtnAction(_ sender: AnyObject) {
        clickHelpPopUp()
    }
    // MARK: 🟠 Search Button Action
    @IBAction func serchButtonAction(_ sender: AnyObject) {
        let newString = searchWidComplexName.text
        
        if newString!.isEmpty == true{
            fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionSessionDate(1, birdTypeId: 1,todate:fromLblDate.text!,lasatdate:toLblDate.text!) as NSArray
            existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
            if existingArray.count == 0 {
                self.Alert()
            }
            tableView.reloadData()
        }
        else{
            let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) AND complexName contains[c] %@", fromLblDate.text!, toLblDate.text! ,newString!)
            fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionWithCapId(1).filtered(using: bPredicate) as NSArray
            existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
            if existingArray.count == 0 {
                self.Alert()
            }
            tableView.reloadData()
        }
    }
    
    // MARK: 🟠 - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            searchWidComplexName.text = cuatomerep.complexName
            UserDefaults.standard.set(  searchWidComplexName.text, forKey: "complex")
            autoSerchTable.alpha = 0
            searchWidComplexName.endEditing(true)
            buttonDroper.alpha = 0
        }else{
            
            let posting : PostingSession = existingArray.object(at: indexPath.row) as! PostingSession
            let appLngId = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
            if appLngId == posting.lngId{
                
                let postingSessionDetails = self.storyboard?.instantiateViewController(withIdentifier: "PostingSession") as? PostingSessionDetailController
                postingSessionDetails?.postingId = posting.postingId!
                postingSessionDetails?.editFinalizeValue = editFinalizeValue as NSNumber
                postingSessionDetails?.finilizeValue = posting.finalizeExit!
                self.navigationController?.pushViewController(postingSessionDetails!, animated: true)
            }
            else{
                 lngId = UserDefaults.standard.integer(forKey: "lngId")
                
                alertMessageLanguageBasis(lngId: posting.lngId ?? 1)
                
            }
        }
    }
    
    fileprivate func alertMessageLanguageBasis(lngId :NSNumber) {
        if lngId == 4{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in portuguese language. Please select portuguese as a language to edit / view this session.", comment: ""))
            
        }
        if lngId == 3{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in french language. Please select french as a language to edit / view this session.", comment: ""))
            
        }
        
        if lngId == 1{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in English language. Please select french as a language to edit / view this session.", comment: ""))
            
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == autoSerchTable {
            return autocompleteUrls.count
        } else  {
            return existingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            cell.textLabel?.text = cuatomerep.complexName
            cell.textLabel?.font = searchWidComplexName.font
            return cell
            
        }else {
            
            let cell:ExistingPostingTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ExistingPostingTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            let posting : PostingSession = existingArray.object(at: indexPath.row) as! PostingSession
            
            let isfarmSync = posting.isfarmSync
            cell.infoButton.alpha = isfarmSync == 1 ? 1 : 0
            let lngIdFr = UserDefaults.standard.integer(forKey: "lngId")
            if lngIdFr == 3
            {
                let dateString = posting.sessiondate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let dateObj = dateFormatter.date(from: dateString!)
                dateFormatter.dateFormat = Constants.ddMMyyyStr
                cell.datelabel.text = dateFormatter.string(from: dateObj!)
            }
            else
            {
                cell.datelabel.text  = posting.sessiondate
            }
            
            cell.sessionTypeLabel.text  = posting.sessionTypeName
            cell.complexLabel.text  = posting.complexName
            cell.veterinartionLabel.text  = posting.vetanatrionName
            let selectedLanguageIs =  posting.lngId
            if selectedLanguageIs == 1{
                cell.lblLng.text = "(En)"
            }else if selectedLanguageIs == 3{
                cell.lblLng.text = "(Fr)"
            }
            else if selectedLanguageIs == 4{
                cell.lblLng.text = "(pt-BR)"
            }
            else{
                cell.lblLng.text = "(Es)"
            }
            cell.infoButton.addTarget(self, action: #selector(ExistingPostingSessionViewController.infoButton), for: .touchUpInside)
            finializeB = posting.finalizeExit!
            if finializeB == 1{
                cell.eyeIamgeView.image = UIImage(named:"eye_blue")!
            }
            else if finializeB == 0{
                cell.eyeIamgeView.image =  UIImage(named:"eye_orange")!
            }
            return cell
        }
    }
    
    // MARK: 🟠 - TEXTFIELD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (textField.tag == 101){
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            fetchcomplexArray = CoreDataHandler().fetchCompexType().filtered(using: bPredicate) as NSArray
            autocompleteUrls = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autoSerchTable.frame = CGRect(x: 675, y: 120, width: 250, height: 200)
            
            buttonDroper.alpha = 1
            autoSerchTable.alpha = 1
            
            if autocompleteUrls.count == 0 {
                buttonDroper.alpha = 0
                autoSerchTable.alpha = 0
            }
            else{
                autoSerchTable.reloadData()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        buttonDroper.alpha = 0
        autoSerchTable.alpha = 0
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        existingArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionWithCapId(1).mutableCopy() as! NSMutableArray
        tableView.reloadData()
    }
    
    // MARK: 🟠 -Info Button Action
    @objc func infoButton() {
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please connect farm(s) with feed program.", comment: ""))
    }
    // MARK: 🟠 Posting View Controller
    @objc func methodOfReceivedNotification(notification: Notification){
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    func Alert(){
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No sessions found.", comment: ""))
    }
    // MARK: 🟠 Load Custome popup
    func CallPopoupStartNec()  {
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcn), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        customPopV = startNecropsyXib.loadFromNibNamed("startNecropsyXib") as! startNecropsyXib
        customPopV.necropsyDelegate = self
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
    }
    // MARK: 🟠 Dismiss custome Popup
    @objc func buttonAcn(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    // MARK: 🟠 Start Necropsy Button Action
    func startNecropsyBtnFunc (){
        let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
        self.navigationController?.pushViewController(navigateToAnother!, animated: false)
        
    }
    // MARK: 🟠 Cross Button Action
    func crossBtnFunc (){
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    // MARK: 🟠 Side Menu Button
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected()  == true{
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            buttonbg2.removeFromSuperview()
            customPopView1.removeView(view)
        }
    }
    
    
    // MARK: 🟠  /*********** Logout SSO Account **************/
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
    // MARK: 🟠 Create Custome Popup
    func clickHelpPopUp() {
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg1.addTarget(self, action: #selector(PostingViewController.buttonPressed11), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg1)
        
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg1 .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200, y: 60, width: 150, height: 60))
    }
    
    func buttonPressed11() {
        customPopView1.removeView(view)
        buttonbg1.removeFromSuperview()
    }
    
    // MARK: 🟠 All Session Array
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        let allPostingSessionArr = NSMutableArray()
       
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
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
    // MARK: 🟠Sync Button Action
    @IBAction func synvBtnAction(_ sender: AnyObject) {
        
        if self.allSessionArr().count > 0
        {
            if WebClass.sharedInstance.connected()  == true{
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                self.callSyncApi()
            }
            else
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
            }
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
        
    }
    // MARK: 🟢 Call Sync API Feed Program
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    // MARK: 🟠 Failed with Internal error with Status Code
    func failWithError(statusCode:Int)
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            } else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
            
            else if lngId == 4 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Há problemas na sincronização de dados, tente novamente. \n(\(statusCode))")
            }
            
        }
    }
    // MARK: 🟠 Failed with Internal error
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    
    func didFinishApi()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    // MARK: 🟠 Failed With Internet Connection offline
    func failWithInternetConnection()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
    func printSyncLblCount()
    {
        syncNotiCount.text = String(self.allSessionArr().count)
    }
}


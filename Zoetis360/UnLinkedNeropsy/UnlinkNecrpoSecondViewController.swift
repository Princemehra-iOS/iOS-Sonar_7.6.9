//  UnlinkNecrpoSecondViewController.swift
//  Zoetis -Feathers
//  Created by "" on 05/11/16.
//  Copyright © 2016 "". All rights reserved.


import UIKit
import Reachability
import SystemConfiguration
import CoreData
import Gigya
import GigyaTfa
import GigyaAuth

class UnlinkNecrpoSecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,userLogOut,startNecropsyP,syncApi, UITextFieldDelegate {
    
    
    // MARK: - VARIABLES
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    @IBOutlet weak var syncNotifLbl: UILabel!
    var buttonBg1 = UIButton ()
    let bckroundBtnn = UIButton ()
    var datePicker : UIDatePicker!
    var lngId = NSInteger()
    var strDateEn = String()
    let objApiSync = ApiSync()
    var buttonback = UIButton()
    var customPopV :startNecropsyXib!
    var strdate1 = String()
    var complexTypeFetchArray = NSMutableArray()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    let buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    let cellReuseIdentifier = "cell"
    let buttonbg = UIButton ()
    var customPopView1 :UserListView!
    
    // MARK: - OUTLET
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tblSession: UITableView!
    @IBOutlet weak var searchWidComplexName: UITextField!
    let sessionExistedMsg = "Session for this date & complex already exist. Please select another date or complex."
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        tblSession.estimatedRowHeight = 50
        tblSession.rowHeight = UITableView.automaticDimension
        searchWidComplexName.layer.borderWidth = 1
        searchWidComplexName.layer.cornerRadius = 3.5
        searchWidComplexName.layer.borderColor = UIColor.black.cgColor
        searchWidComplexName.delegate = self
        objApiSync.delegeteSyncApi = self
        
        self.tblSession.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let selecdLngId = UserDefaults.standard.integer(forKey: "lngId")
        if selecdLngId == 3 {
            let todaysDate:NSDate = NSDate()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            
            let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
            lblDate.text = DateInFormat
            UserDefaults.standard.set( DateInFormat, forKey: "dateFrench")
            let todaysDate1:NSDate = NSDate()
            let dateFormatter1:DateFormatter = DateFormatter()
            dateFormatter1.dateFormat = Constants.MMddyyyyStr
            strDateEn = dateFormatter1.string(from: todaysDate1 as Date)
        }
        else{
            let todaysDate:NSDate = NSDate()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            strDateEn = dateFormatter.string(from: todaysDate as Date)
            lblDate.text = strDateEn
        }
        
        let todaysDate1:NSDate = NSDate()
        let dateFormatter1:DateFormatter = DateFormatter()
        dateFormatter1.dateFormat="MM/dd/yyyy/HH:mm:ss"
        
        let DateInFormat1:String = dateFormatter1.string(from: todaysDate1 as Date)
        UserDefaults.standard.set( strDateEn, forKey: "date")
        UserDefaults.standard.set(DateInFormat1, forKey: "timeStamp")
        UserDefaults.standard.synchronize()
        existingArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        
        if existingArray.count == 0 {
            print(appDelegateObj.testFuntion())
        }
        
        if UserDefaults.standard.bool(forKey: "backFromStep1") == true
        {
            existingArray.removeAllObjects()
            self.tblSession.reloadData()
            searchWidComplexName.text = ""
            
            if (customPopV != nil)
            {
                customPopV.removeFromSuperview()
                buttonback.removeFromSuperview()
            }
            UserDefaults.standard.set(false, forKey: "backFromStep1")
            UserDefaults.standard.synchronize()
        }
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        complexTypeFetchArray = CoreDataHandler().fetchCompexType().mutableCopy() as! NSMutableArray
        
        if  let data = CoreDataHandler().fetchCompexType() as? NSArray{
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonDroper.addTarget(self, action: #selector(UnlinkNecrpoSecondViewController.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.black.cgColor
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
        
        let  postingArrWithAllData1 = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        syncNotifLbl.text = String(postingArrWithAllData1.count)
        self.printSyncLblCount()
        
    }
    
    // MARK: 🟠 - Logout Button Action
    @IBAction func logoutBttn(sender: AnyObject) {
        clickHelpPopUp()
    }
    // MARK: 🟠 Back Button Action
    @IBAction func backButtonAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: 🟠 Sync Button Action
    @IBAction func syncBtnAction(sender: AnyObject) {
        if self.allSessionArr().count > 0
        {
            if WebClass.sharedInstance.connected() == true{
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
    
    // MARK: 🟠- TABLE VIEW DATA SOURCE AND DELEGATES
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == autoSerchTable {
            return autocompleteUrls.count
        }  else  {
            return existingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            guard indexPath.row < autocompleteUrls.count else {
                print("Index \(indexPath.row) is out of bounds for autocompleteUrls (count: \(autocompleteUrls.count))")
                return UITableViewCell() // Return an empty cell to prevent crash
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                print("Failed to dequeue cell")
                return UITableViewCell()
            }
            
            if let customerRep = autocompleteUrls.object(at: indexPath.row) as? ComplexPosting {
                cell.textLabel?.text = customerRep.complexName
                cell.textLabel?.font = searchWidComplexName.font
            } else {
                print("Invalid object type at index \(indexPath.row)")
            }
            
            return cell
        }
        else {
            
            let cell:ExistingPostingTableViewCell = self.tblSession.dequeueReusableCell(withIdentifier: "cell") as! ExistingPostingTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let posting : PostingSession = existingArray.object(at: indexPath.row) as! PostingSession
            
            cell.datelabel.text  = posting.sessiondate
            cell.sessionTypeLabel.text  = posting.sessionTypeName
            cell.complexLabel.text  = posting.complexName
            cell.veterinartionLabel.text  = posting.vetanatrionName
            
            let selectdlngId = posting.lngId!
            if selectdlngId == 1{
                cell.languageLbl.text = "(En)"
            }else if selectdlngId == 3{
                cell.languageLbl.text = "(Fr)"
            }else if selectdlngId == 4{
                cell.languageLbl.text = "(pt-BR)"
            }
            return cell
        }
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            
            searchWidComplexName.text = cuatomerep.complexName
            
            let complexId  = cuatomerep.complexId as! Int
            UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
            UserDefaults.standard.synchronize()
            let cutstId = cuatomerep.customerId as! Int
            
            if checkComplexNameandDate(date: strDateEn, complexName: searchWidComplexName.text!) == true {
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message:NSLocalizedString(sessionExistedMsg, comment: "") , preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    self.searchWidComplexName.text = ""
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                autoSerchTable.alpha = 0
                buttonDroper.alpha = 0
            }
            else {
                
                UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
                UserDefaults.standard.set(cutstId, forKey: "unCustId")
                UserDefaults.standard.set(searchWidComplexName.text, forKey: "complex")
                UserDefaults.standard.synchronize()
                autoSerchTable.alpha = 0
                searchWidComplexName.endEditing(true)
                buttonDroper.alpha = 0
            }
        } else {
            let posting : PostingSession = existingArray.object(at: indexPath.row) as! PostingSession
            
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            
            if Int(posting.lngId!) == lngId {
                
                let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
                let postingId = posting.postingId as! Int
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.set(postingId, forKey: "postingId")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(navigateToAnother!, animated: false)
            }
            else{
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in English language Please logout and select English as a language to edit /proceed this session.", comment: ""))
            }
        }
    }
    
    // MARK: - TEXT FEILD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101){
            
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            
            fetchcomplexArray = CoreDataHandler().fetchCompexType().filtered(using: bPredicate) as NSArray
            autocompleteUrls = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autoSerchTable.frame = CGRect(x: 732,y:  126,width: 198,height: 200)
            buttonDroper.alpha = 1
            autoSerchTable.alpha = 1
            
            if autocompleteUrls.count == 0 {
                buttonDroper.alpha = 0
                autoSerchTable.alpha = 0
            } else {
                autoSerchTable.reloadData()
            }
        }
        return true
    }
    
    
    func checkComplexNameandDate(date : String, complexName: String) -> Bool {
        var isComplexandDateExist : Bool = false
        
        let postingSessionArray =  CoreDataHandler().FetchNecropsystep1AllNecId() as NSArray
        
        for i in 0..<postingSessionArray.count {
            let pSession = postingSessionArray.object(at: i) as! CaptureNecropsyData
            let sessionDate = pSession.complexDate! as String
            let sessioncomplexName = pSession.complexName! as String
            if (sessionDate == date) && (sessioncomplexName == complexName) {
                isComplexandDateExist = true
                break
            }
        }
        
        let necArray =  CoreDataHandler().FetchNecropsystep1neccIdAll() as NSArray
        
        for i in 0..<necArray.count {
            
            let necSession = necArray.object(at: i) as! CaptureNecropsyData
            let sessionDate = necSession.complexDate! as String
            let sessioncomplexName = necSession.complexName! as String
            if (sessionDate == date) && (sessioncomplexName == complexName) {
                isComplexandDateExist = true
                break
            }
        }
        
        return isComplexandDateExist
    }
    // MARK: 🟠 Search Button Action
    fileprivate func checkExistedComplex(_ newString: String?) {
        if checkComplexName(complexName: searchWidComplexName.text!) == true {
            
            let necData = CoreDataHandler().FetchNecropsystep1neccIdAllwithId(sessiondate: strDateEn, newstring: newString!)
            if necData.count>1{
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message:NSLocalizedString(sessionExistedMsg, comment: "") , preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.searchWidComplexName.text = ""
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.CallPopoupStartNec()
            }
        }
        else {
            
            Helper.showAlertMessage(self,titleStr: NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("Complex doesn't exist.", comment: ""))
        }
    }
    
    fileprivate func existedComplexForDate(_ newString: String?) {
        if checkComplexName(complexName: searchWidComplexName.text!) == true {
            
            let necData = CoreDataHandler().FetchNecropsystep1neccIdAllwithId(sessiondate: strDateEn, newstring: newString!)
            if necData.count>1{
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message:NSLocalizedString(sessionExistedMsg, comment: "") , preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.searchWidComplexName.text = ""
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.CallPopoupStartNec()
            }
            
        }  else  {
            
            Helper.showAlertMessage(self,titleStr: NSLocalizedString(Constants.alertStr, comment: "") , messageStr:  NSLocalizedString( "Complex doesn't exist.", comment: "") )
        }
    }
    
    @IBAction func serchButtonAction(sender: AnyObject) {
        
        if(searchWidComplexName.text == "") || (lblDate.text == "" ){
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter complex.", comment: ""))
        }
        else {
            
            let newString = searchWidComplexName.text
            UserDefaults.standard.set(searchWidComplexName.text, forKey: "complex")
            if newString!.isEmpty == true{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) OR complexName contains[cd] %@", strDateEn ,newString!)
                
                fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if existingArray.count == 0 {
                    
                    checkExistedComplex(newString)
                }
                else {
                    self.tblSession.alpha = 1
                }
                self.tblSession.reloadData()
            }
            else {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND complexName contains[cd] %@", strDateEn ,newString!)
                fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                
                existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
                if existingArray.count != 0 {
                    let posting : PostingSession = existingArray.object(at: 0) as! PostingSession
                    let exlngId = UserDefaults.standard.integer(forKey: "lngId")
                    existingArray.removeAllObjects()
                    posting.lngId = exlngId as NSNumber
                    existingArray.add(posting)
                }
                
                if existingArray.count == 0 {
                    
                    existedComplexForDate(newString)
                }
                else{
                    self.tblSession.alpha = 1
                    let necData = CoreDataHandler().FetchNecropsystep1neccIdAllwithId(sessiondate: strDateEn, newstring: newString!)
                    if necData.count>1{
                        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message:NSLocalizedString(sessionExistedMsg, comment: "") , preferredStyle: .alert)
                        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.searchWidComplexName.text = ""
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        let data =    CoreDataHandler().fetchAllPostingExistingSessionWithId(sessionDate: strDateEn, newString: newString!)
                        if data.count < 1{
                            self.CallPopoupStartNec()
                        }
                    }
                }
                self.tblSession.reloadData()
            }
        }
    }
    
    // MARK: - METHOD & FUNCTION
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    func CallPopoupStartNec()  {
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: .normal)
        buttonback.addTarget(self, action: #selector(buttonAcn), for: .touchUpInside)
        self.view.addSubview(buttonback)
        customPopV = startNecropsyXib.loadFromNibNamed("startNecropsyXib") as! startNecropsyXib
        customPopV.necropsyDelegate = self
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
        
    }
    
    @objc func buttonAcn(sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    func checkComplexName(complexName: String) -> Bool {
        
        var isComplexandDateExist : Bool = false
        
        let colpexArr  = CoreDataHandler().fetchCompexType()
        
        for i in 0..<colpexArr.count{
            let complexNameData = colpexArr.object(at: i) as! ComplexPosting
            if complexNameData.complexName == searchWidComplexName.text {
                UserDefaults.standard.set(complexNameData.complexId, forKey: "UnlinkComplex")
                UserDefaults.standard.set(complexNameData.customerId, forKey: "unCustId")
                isComplexandDateExist = true
                break
            }
        }
        return isComplexandDateExist
    }
    // MARK: 🟠 Custome Popup
    func clickHelpPopUp() {
        
        buttonbg.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonbg.addTarget(self, action: #selector(UnlinkNecrpoSecondViewController.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        
        self.buttonbg .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200,y: 60,width: 150,height: 60))
        
    }
    // MARK: 🟠 Dismiss Custome Popup
    @objc func buttonPressed1() {
        customPopView1.removeView(view)
        buttonbg.removeFromSuperview()
    }
    // MARK: 🟠 Cross Button Action
    func crossBtnFunc (){
        self.searchWidComplexName.text = ""
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
        
    }
    // MARK: 🟠 Date Picker Button Action
    @IBAction func didSelectOnDatePicker(sender: AnyObject) {
        view.endEditing(true)
        
        let buttons  = CommonClass.sharedInstance.pickUpDate()
        buttonBg1  = buttons.0
        buttonBg1.frame = CGRect(x: 0,y: 0,width: 1024,height: 768) // X, Y, width, height
        buttonBg1.addTarget(self, action: #selector
                            (UnlinkNecrpoSecondViewController.buttonPressed), for: .touchUpInside)
        
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(UnlinkNecrpoSecondViewController.doneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(UnlinkNecrpoSecondViewController.cancelClick)
        
        datePicker = buttons.4
        self.view.addSubview(buttonBg1)
        
    }
    // MARK: 🟠 Date Picker Done Button Action
    @objc func doneClick() {
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3 {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat=Constants.ddMMyyyStr
            let strfrench  = dateFormatter1.string(from: datePicker.date)
            lblDate.text = strfrench
            UserDefaults.standard.set( strfrench, forKey: "dateFrench")
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat=Constants.MMddyyyyStr
            strDateEn = dateFormatter2.string(from: datePicker.date)
            
        }
        else{
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat=Constants.MMddyyyyStr
            strDateEn = dateFormatter1.string(from: datePicker.date)
            lblDate.text = strDateEn
        }
        
        UserDefaults.standard.set( strDateEn, forKey: "date")
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat="MM/dd/yyyy/HH:mm:ss"
        strdate1 = dateFormatter3.string(from: datePicker.date) as String
        UserDefaults.standard.set( strdate1, forKey: "timeStamp")
        UserDefaults.standard.synchronize()
        
        buttonBg1.removeFromSuperview()
    }
    // MARK: 🟠 Cancel Button Action
    @objc func cancelClick() {
        buttonBg1.removeFromSuperview()
    }
    
    @objc func buttonPressed() {
        buttonBg1.removeFromSuperview()
    }
    // MARK: 🟠 Side Menu Action
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out" {
            
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected() == true{
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            buttonbg.removeFromSuperview()
            customPopView1.removeView(view)
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
    // MARK: 🟠Start Necropsy Btn Action
    func startNecropsyBtnFunc (){
        UserDefaults.standard.removeObject(forKey: "count")
        if(searchWidComplexName.text == "") || (lblDate.text == "" ){
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please select coplex & date.", comment: ""))
        }
        else{
            
            let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
            navigateToAnother!.navigatefronInlinked = "Unlinked"
            UserDefaults.standard.set(true, forKey: "nec")
            UserDefaults.standard.set(true, forKey: "Unlinked")
            self.navigationController?.pushViewController(navigateToAnother!, animated: false)
        }
    }
    // MARK: 🟠  All Session Array
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
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    // MARK: 🟠 Call Sync API
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    
    // MARK: 🟠-- Delegate SyNC Api
    
    func failWithError(statusCode:Int)
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.", comment: "") + "(NA)")
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.", comment: "")  + "\n(\(statusCode))")
        }
    }
    
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection Please try again!", comment: ""))
    }
    
    // MARK: 🟠 Did Finish API
    func didFinishApi()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnection()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
    // MARK: 🟠 Print Sync Count.
    func printSyncLblCount()
    {
        syncNotifLbl.text = String(self.allSessionArr().count)
    }
    
}


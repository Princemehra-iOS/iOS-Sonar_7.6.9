//
//  ExistingPostingSessionTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import Reachability
import SystemConfiguration

class ExistingPostingSessionTurkey: UIViewController,UITextFieldDelegate,necropsyPop {
    
    // MARK: - VARIABLES
    let buttonDroper = UIButton ()
    
    
    var buttonback = UIButton()
    var customPopV: startNecrPopUpTurkey!
    var finializeB = NSNumber()
    let editFinalizeValue = 2
    var fromDate = Date()
    var toDate   = Date()
    var fromString = String()
    var toString = String()
    var dateFormatter = DateFormatter()
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
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var selectDateToLbl: UILabel!
    @IBOutlet weak var selectDateFromLbl: UILabel!
    @IBOutlet weak var complexNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ExistingPostingSessionTurkey.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        fromString = dateFormatter.string(from: Date())
        toString = dateFormatter.string(from: Date())
        selectDateFromLbl.text = fromString
        selectDateToLbl.text = toString
        
        complexNameTextField.layer.borderWidth = 1
        complexNameTextField.layer.cornerRadius = 3.5
        complexNameTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        complexNameTextField.delegate = self
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        tableView.tableFooterView = UIView()
        existingArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkeyCapNic(1).mutableCopy() as! NSMutableArray
        
        for i in 0..<existingArray.count{
            let postingSession : PostingSessionTurkey = existingArray.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let farms = CoreDataHandlerTurkey().fetchNecropsystep1neccIdFeedProgramTurkey(pid!)
            if farms.count > 0 {
                CoreDataHandlerTurkey().updatedPostigSessionwithIsFarmSyncPostingIdTurkey(pid!, isFarmSync: true)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        complexTypeFetchArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().mutableCopy() as! NSMutableArray
        if  let data: NSArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey() as? NSArray {
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonDroper.addTarget(self, action: #selector(ExistingPostingSessionTurkey.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.delegate = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.black.cgColor
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
    }
    
    // MARK: - METHOD & FUNCTION
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    @objc func todoneClick() {
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = Constants.MMddyyyyStr
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = Constants.MMddyyyyStr
        toString = dateFormatter1.string(from: datePicker.date)
        toDate = datePicker.date
        
        if fromString == toString || toDate.isGreaterThanDate(fromDate){
            
            let strdate = dateFormatter2.string(from: datePicker.date) as String
            selectDateToLbl.text = strdate
            UserDefaults.standard.set( selectDateToLbl.text, forKey: "date")
            buttonBg.removeFromSuperview()
            tableView.reloadData()
            
        }  else {
            self.cancelClick()
            
            fromString = selectDateToLbl.text!
            let dateFormatterIs = DateFormatter()
            dateFormatterIs.dateFormat = Constants.MMddyyyyStr
            toDate = dateFormatterIs.date(from: fromString)!
            Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"To date must be greater than from date.")
            
        }
    }
    
    @objc func buttonPressed() {
        
        buttonBg.removeFromSuperview()
    }
    
    @objc func doneClick() {
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        fromString = dateFormatter.string(from: datePicker.date)
        fromDate = datePicker.date
        
        if fromString == toString || fromDate.isLessThanDate(toDate){
            
            let strdate = dateFormatter.string(from: datePicker.date) as String
            selectDateFromLbl.text = strdate
            UserDefaults.standard.set( selectDateFromLbl.text, forKey: "date")
            buttonBg.removeFromSuperview()
            tableView.reloadData()
        }  else {
            self.cancelClick()
            
            fromString = selectDateFromLbl.text!
            let fromDateFormatter = DateFormatter()
            fromDateFormatter.dateFormat = Constants.MMddyyyyStr
            fromDate = fromDateFormatter.date(from: fromString)!
            Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"From date must be smaller than to date.")
        }
    }
    
    @objc func cancelClick() {
        buttonBg.removeFromSuperview()
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
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
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        return allPostingSessionArr
    }
    // MARK: - Info Button Action
    @objc func infoButton() {
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please connect farm(s) with feed program.", comment: ""))
    }
    
    func Alert(){
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"No sessions found.")
    }
    // MARK: - Load PopUp
    func CallPopoupStartNec()  {
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcn), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        customPopV = startNecrPopUpTurkey.loadFromNibNamed("startNecrPopUpTurkey") as! startNecrPopUpTurkey
        customPopV.delegateStartNec = self
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
        
    }
    
    @objc func buttonAcn(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    // MARK: - Start Necropsy Button ACTION
    func startNecropsyBtnFunc (){
        let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
        self.navigationController?.pushViewController(navigateToAnother!, animated: false)
        
    }
    // MARK: - Cross Button ACTION
    func crossBtnFunc (){
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: false)
    }
    
    
    // MARK: - Search Button ACTION
    @IBAction func searchBtnAction(_ sender: UIButton) {
        let newString = complexNameTextField.text
        if newString!.isEmpty == true {
            fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionSessionDateTurkey(1, birdTypeId: 1,todate:selectDateFromLbl.text!,lasatdate:selectDateToLbl.text!) as NSArray
            existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
            
            if existingArray.count == 0 {
                self.Alert()
            }
            tableView.reloadData()
        } else {
            
            let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) OR complexName contains[c] %@", selectDateFromLbl.text!, selectDateToLbl.text! ,newString!)
            
            fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkeyCapNic(1).filtered(using: bPredicate) as NSArray
            existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
            
            if existingArray.count == 0 {
                self.Alert()
            }
            tableView.reloadData()
        }
    }
    // MARK: - Date Selection "TO" Button Action
    @IBAction func selectDateToAction(_ sender: UIButton) {
        
        view.endEditing(true)
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg.addTarget(self, action: #selector(ExistingPostingSessionTurkey.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(ExistingPostingSessionTurkey.todoneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(ExistingPostingSessionTurkey.cancelClick)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
    }
    
    // MARK: - Date Selection "FROM" Button Action
    @IBAction func selectDateFromAction(_ sender: UIButton) {
        view.endEditing(true)
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg.addTarget(self, action: #selector(ExistingPostingSessionTurkey.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(ExistingPostingSessionTurkey.doneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(ExistingPostingSessionTurkey.cancelClick)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
    }
    // MARK: - Side Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    // MARK: 📝 - TEXTFIELD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == 101 {
            
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            let fetchedArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().filtered(using: bPredicate)
            fetchcomplexArray = fetchedArray as NSArray
            autocompleteUrls = NSMutableArray(array: fetchedArray)
            
            autoSerchTable.frame = CGRect(x: 680, y: 120, width: 250, height: 250)
            
            if autocompleteUrls.count == 0 {
                autocompleteUrls.removeAllObjects()
                autoSerchTable.reloadData()
                buttonDroper.alpha = 0
                autoSerchTable.alpha = 0
            } else {
                buttonDroper.alpha = 1
                autoSerchTable.alpha = 1
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
        
        existingArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkeyCapNic(1).mutableCopy() as! NSMutableArray
        tableView.reloadData()
    }
    
}

// MARK: 📋 - TABLEVIEW DELEGATES

extension ExistingPostingSessionTurkey : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        else{
            return existingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let cuatomerep : ComplexPostingTurkey = autocompleteUrls.object(at: indexPath.row) as! ComplexPostingTurkey
            cell.textLabel?.text = cuatomerep.complexName
            cell.textLabel?.font = complexNameTextField.font
            return cell
        }
        else {
            let cell:ExistingPostingTurkeyCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ExistingPostingTurkeyCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let posting : PostingSessionTurkey = existingArray.object(at: indexPath.row) as! PostingSessionTurkey
            let isfarmSync = posting.isfarmSync
            
            if isfarmSync == 1{
                cell.infoButton.alpha = 1
            }
            else{
                cell.infoButton.alpha = 0
            }
            
            cell.dateLbl.text  = posting.sessiondate
            cell.sessionTypeLbl.text  = posting.sessionTypeName
            cell.complexLbl.text  = posting.complexName
            cell.veterinarianLbl.text  = posting.vetanatrionName
            
            cell.lblLng.text = "(En)"
            cell.infoButton.addTarget(self, action: #selector(ExistingPostingSessionTurkey.infoButton), for: .touchUpInside)
            
            finializeB = posting.finalizeExit!
            
            if finializeB == 1{
                cell.eyeBlueImage.image = UIImage(named:"eye_blue")!
            }
            else if finializeB == 0{
                cell.eyeBlueImage.image =  UIImage(named:"eye_orange")!
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPostingTurkey = autocompleteUrls.object(at: indexPath.row) as! ComplexPostingTurkey
            complexNameTextField.text = cuatomerep.complexName
            UserDefaults.standard.set(complexNameTextField.text, forKey: "complex")
            autoSerchTable.alpha = 0
            complexNameTextField.endEditing(true)
            buttonDroper.alpha = 0
        }
        else{
            let posting : PostingSessionTurkey = existingArray.object(at: indexPath.row) as! PostingSessionTurkey
            let postingSessionDetails = self.storyboard?.instantiateViewController(withIdentifier: "PostingSessionTurkey") as? PostingSessionDetailTurkey
            postingSessionDetails?.postingId = posting.postingId!
            postingSessionDetails?.editFinalizeValue = editFinalizeValue as NSNumber
            postingSessionDetails?.finilizeValue = posting.finalizeExit!
            self.navigationController?.pushViewController(postingSessionDetails!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
}

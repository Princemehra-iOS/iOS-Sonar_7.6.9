//
//  UnlinkedNecropsyControllerTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 19/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreData
import Reachability

import SystemConfiguration

class UnlinkedNecropsyControllerTurkey: UIViewController {
    
    // MARK: - VARIABLES
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var unlinkedNecropsies =  NSMutableArray()
    var NecropsiesPostingSess =  NSMutableArray()
    var existingArray = NSMutableArray()
    var  postingId = Int()
    var buttonBg = UIButton ()
    var datePicker: UIDatePicker!
    var dateFormatter = DateFormatter()
    var fromDate = Date()
    var toDate = Date()
    var fromString = String()
    
    var toString = String()
    let buttonDroper = UIButton ()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    let cellReuseIdentifier = "cell"
    var complexTypeFetchArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    var buttnTag = Int()
    var dictdata = NSMutableDictionary()
    let bckroundBtnn = UIButton ()
    
    
    // MARK: - Outlets
    @IBOutlet weak var complexTextField: UITextField!
    @IBOutlet weak var userNamelbl: UILabel!
    @IBOutlet weak var sessionFromDate: UILabel!
    @IBOutlet weak var sessionToDate: UILabel!
    @IBOutlet weak var necroWithOutPostingView: UIView!
    @IBOutlet weak var postingSessionWithoutView: UIView!
    @IBOutlet weak var necroWithOutPostingSessionOutlet: UIButton!
    @IBOutlet weak var postingSessionWithoutNecroOutlet: UIButton!
    @IBOutlet weak var necroWithoutTable: UITableView!
    @IBOutlet weak var postingWithoutNecroTable: UITableView!
    
    
    func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: false)
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        //UserDefaults.standard.set(false, forKey: "Unlinkeddd")
        NotificationCenter.default.addObserver(self, selector: #selector(PostingViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
        
        
        postingWithoutNecroTable.estimatedRowHeight = 50
        postingWithoutNecroTable.rowHeight = UITableView.automaticDimension
        
        necroWithoutTable.estimatedRowHeight = 50
        necroWithoutTable.rowHeight = UITableView.automaticDimension
        
        complexTextField.layer.borderWidth = 1
        complexTextField.layer.cornerRadius = 3.5
        complexTextField.layer.borderColor = UIColor.black.cgColor
        necroWithoutTable.isHidden = false
        postingWithoutNecroTable.isHidden = true
        necroWithOutPostingSessionOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        buttnTag = 1
     
     
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        //        dateFormatter.calendar = Calendar(identifier: .gregorian)
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        //        dateFormatter.calendar = Calendar(identifier: .gregorian)
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        fromString = dateFormatter.string(from: Date())
        toString = dateFormatter.string(from: Date())
        sessionFromDate.text = fromString
        sessionToDate.text = toString
        
        UserDefaults.standard.set( sessionToDate.text, forKey: "date")
        UserDefaults.standard.synchronize()
        let arr =  CoreDataHandlerTurkey().fetchAllPostingSessionWithVetIdTurkey(_VetName: "")
        
        for i in 0..<arr.count{
            let pId = arr.object(at: i)
          
            var arr = CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(pId as! NSNumber).mutableCopy() as! NSMutableArray
            if arr.count > 0
            {
                self.NecropsiesPostingSess.add(arr)
            }
        }
        existingArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        postingWithoutNecroTable.delegate = self
        postingWithoutNecroTable.dataSource = self
        necroWithoutTable.delegate = self
        necroWithoutTable.dataSource = self
        necroWithOutPostingView.isHidden = false
        postingSessionWithoutView.isHidden = true
        necroWithoutTable.isHidden = false
        postingWithoutNecroTable.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let totalExustingArr = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pid!)
            if feedProgram.count == 0{
                CoreDataHandlerTurkey().updatePostingSessionOndashBoardTurkey(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pid!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pid!)
            }
        }
        
        if  buttnTag == 2 {
            self.unlinkedNecropsies =  CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
            
            necroWithoutTable.isHidden = true
            postingWithoutNecroTable.isHidden = false
            necroWithOutPostingView.isHidden = true
            postingSessionWithoutView.isHidden = false
            postingWithoutNecroTable.reloadData()
        } else {
            let arr =  CoreDataHandlerTurkey().fetchAllPostingSessionWithVetIdTurkey(_VetName: "")
            self.NecropsiesPostingSess.removeAllObjects()
            for i in 0..<arr.count{
                
                let pId = arr.object(at: i)
                var arr = CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(pId as! NSNumber).mutableCopy() as! NSMutableArray
                if arr.count > 0
                {
                    self.NecropsiesPostingSess.add(arr)
                }
            }
            necroWithoutTable.isHidden = false
            postingWithoutNecroTable.isHidden = true
            necroWithOutPostingView.isHidden = false
            postingSessionWithoutView.isHidden = true
            necroWithoutTable.reloadData()
        }
        
        userNamelbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        complexTypeFetchArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().mutableCopy() as! NSMutableArray
        
        if  let data = CoreDataHandlerTurkey().fetchCompexTypeTurkey() as? NSArray{
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonDroper.addTarget(self, action: #selector(UnlinkedNecropsyControllerTurkey.buttonPressedDroper), for: .touchUpInside)
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
    @objc func buttonPressedDroper() {
        
        buttonDroper.alpha = 0
    }
    
    // MARK: - IBACTIONS
    @IBAction func menuBtnAction(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
        
    }
    // MARK: - 🔍 Search Button Action
    @IBAction func searchBtnAction(_ sender: UIButton) {
        if  buttnTag == 1{
            
            let newString = complexTextField.text
            if newString?.isEmpty == true{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(complexDate >= %@) AND (complexDate <= %@) OR complexName contains[c] %@", sessionFromDate.text!, sessionToDate.text! ,newString ?? "")
                
                fetchcustRep = CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(0).filtered(using: bPredicate) as NSArray
                NecropsiesPostingSess = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if NecropsiesPostingSess.count == 0 {
                    self.Alert()
                }
                necroWithoutTable.reloadData()
                
            } else {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(complexDate >= %@) AND (complexDate <= %@) AND complexName contains[c] %@", sessionFromDate.text!, sessionToDate.text! ,newString ?? "")
                
                fetchcustRep = CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(0).filtered(using: bPredicate) as NSArray
                NecropsiesPostingSess = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if NecropsiesPostingSess.count == 0 {
                    self.Alert()
                }
                necroWithoutTable.reloadData()
            }
            
        }  else if buttnTag == 2 {
            
            let newString = complexTextField.text
            if newString?.isEmpty == true {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) OR complexName contains[c] %@", sessionFromDate.text!, sessionToDate.text! ,newString ?? "")
                
                fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                
                self.unlinkedNecropsies = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if self.unlinkedNecropsies.count == 0 {
                    self.Alert()
                }
                postingWithoutNecroTable.reloadData()
                
            }  else {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) AND complexName contains[c] %@", sessionFromDate.text!, sessionToDate.text! ,newString ?? "")
                
                fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                
                self.unlinkedNecropsies = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if self.unlinkedNecropsies.count == 0 {
                    self.Alert()
                    
                }
                postingWithoutNecroTable.reloadData()
            }
        }
    }
    // MARK: - 📅 Select From Date Button Action
    @IBAction func selectFromDateAction(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(UnlinkedNecropsyControllerTurkey.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(UnlinkedNecropsyControllerTurkey.doneClick1)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(UnlinkedNecropsyControllerTurkey.cancelClick1)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
        
    }
    // MARK: - 📅 Select TO Date Button Action
    @IBAction func selectToDateAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(UnlinkedNecropsyControllerTurkey.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(UnlinkedNecropsyControllerTurkey.doneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(UnlinkedNecropsyControllerTurkey.cancelClick1)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
    }
    // MARK: - ⚡ Necropsy Without Posting Session Button Action
    @IBAction func necroWithOutPostingSession(_ sender: UIButton) {
        buttnTag = 1
        
        let arr =  CoreDataHandlerTurkey().fetchAllPostingSessionWithVetIdTurkey(_VetName: "")
        self.NecropsiesPostingSess.removeAllObjects()
        
        for i in 0..<arr.count{
            let pId = arr.object(at: i)
          
            var arr = CoreDataHandlerTurkey().FetchNecropsystep1UpdateFromUnlinkedTurkey(pId as! NSNumber).mutableCopy() as! NSMutableArray
            if arr.count > 0
            {
                self.NecropsiesPostingSess.add(arr)
            }
        }
        necroWithOutPostingView.isHidden = false
        postingSessionWithoutView.isHidden = true
        necroWithoutTable.isHidden = false
        postingWithoutNecroTable.isHidden = true
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            necroWithOutPostingSessionOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            postingSessionWithoutNecroOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        
        necroWithoutTable.reloadData()
    }
    // MARK: - ⚡ Posting Session Without Necropsy Button Action
    @IBAction func postingSessionWithoutNecro(_ sender: UIButton) {
        
        buttnTag = 2
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.synchronize()
        
        self.unlinkedNecropsies =  CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        
        if unlinkedNecropsies.count == 0{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"No sessions found.")
        }
        
        necroWithOutPostingView.isHidden = true
        postingSessionWithoutView.isHidden = false
        necroWithoutTable.isHidden = true
        postingWithoutNecroTable.isHidden = false
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            necroWithOutPostingSessionOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            postingSessionWithoutNecroOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        }
        
        postingWithoutNecroTable.reloadData()
    }
    // MARK: - METHODS AND FUNCTIONS
    func Alert(){
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"No sessions found.")
    }
    // MARK: - 📅 Date Picker Done Button Action
    @objc func doneClick1() {
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        //        dateFormatter.calendar = Calendar(identifier: .gregorian)
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        fromString = dateFormatter.string(from: datePicker.date)
        fromDate = datePicker.date
        
        if fromString == toString {
            
            let strdate = dateFormatter.string(from: datePicker.date) as String
            sessionFromDate.text = strdate
            UserDefaults.standard.set( sessionFromDate.text, forKey: "date")
            buttonBg.removeFromSuperview()
            necroWithoutTable.reloadData()
            postingWithoutNecroTable.reloadData()
            
        } else if fromDate.isLessThanDate(toDate) {
            let strdate = dateFormatter.string(from: datePicker.date) as String
            sessionFromDate.text = strdate
            UserDefaults.standard.set(sessionFromDate.text, forKey: "date")
            UserDefaults.standard.synchronize()
            buttonBg.removeFromSuperview()
            necroWithoutTable.reloadData()
            postingWithoutNecroTable.reloadData()
            
        } else {
            self.cancelClick1()
            fromString = sessionFromDate.text!
             dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            //            dateFormatter.calendar = Calendar(identifier: .gregorian)
            //            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            fromDate = dateFormatter.date(from: fromString)!
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"From date must be smaller than to date.")
        }
    }
    
    @objc func buttonPressed() {
        
        buttonBg.removeFromSuperview()
    }
    // MARK: - 📅 Date Picker Cancle Button Action
    @objc func cancelClick1() {
        
        buttonBg.removeFromSuperview()
    }
    // MARK: - 📅 Date Picker Done Button Action
    @objc func doneClick() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        toString = dateFormatter.string(from: datePicker.date)
        toDate = datePicker.date
        
        if fromString == toString || toDate.isGreaterThanDate(fromDate) {
            
            let strdate = dateFormatter.string(from: datePicker.date) as String
            sessionToDate.text = strdate
            UserDefaults.standard.set( sessionToDate.text, forKey: "date")
            buttonBg.removeFromSuperview()
            necroWithoutTable.reloadData()
            postingWithoutNecroTable.reloadData()
            
        }  else {
            self.cancelClick1()
            
            fromString = sessionToDate.text!
             dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            toDate = dateFormatter.date(from: fromString)!
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"To date must be greater than from date.")
        }
    }
    
    // MARK: - ✏️ TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101){
            
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            
            fetchcomplexArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().filtered(using: bPredicate) as NSArray
            autocompleteUrls = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autoSerchTable.frame = CGRect(x: 750, y: 125, width: 220, height: 250)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        buttonDroper.alpha = 0
        autoSerchTable.alpha = 0
        view.endEditing(true)
        return true
    }
}

// MARK: 🧩 ************************* EXTENSION ************************* ✅ //
extension UnlinkedNecropsyControllerTurkey : UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - 📋 TableView DataSource & Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView ==  necroWithoutTable{
            return NecropsiesPostingSess.count
        }
        else if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        else if tableView == postingWithoutNecroTable{
            return unlinkedNecropsies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == necroWithoutTable {
            let cell:UnlinkedNecropsyControllerCell = (self.necroWithoutTable.dequeueReusableCell(withIdentifier: "necropsyCell") as! UnlinkedNecropsyControllerCell?)!
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let arr = (NecropsiesPostingSess.object(at: indexPath.row)) as! NSMutableArray
            if arr.count>0 {
                let arr1 = arr[0]
                let complexName = (arr1 as AnyObject).value(forKey: "complexName") as! String
                let comlexDate = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                cell.necroWithoutDateLabel.text = comlexDate
                cell.necroWithoutComplexLbl.text = complexName
                cell.necroLblLng.text = "(En)"
                
            }
            return cell
            
        } else if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            cell.textLabel?.text = cuatomerep.complexName
            cell.textLabel?.font = complexTextField.font
            return cell
            
        } else {
            
            let cell:UnlinkedNecropsyControllerCell = (self.postingWithoutNecroTable.dequeueReusableCell(withIdentifier: "unlinked") as? UnlinkedNecropsyControllerCell)!
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let posting : PostingSessionTurkey = unlinkedNecropsies.object(at: indexPath.row) as! PostingSessionTurkey
            cell.postingComplexLbl.text = posting.value(forKey: "complexName") as? String
            cell.postingDateLbl?.text = posting.value(forKey: "sessiondate") as? String
            cell.postingSessionTypeLbl?.text = posting.value(forKey: "sessionTypeName") as? String
            cell.postingVeteranarianLbl?.text = posting.value(forKey: "vetanatrionName") as? String
            cell.lblLng.text = "(En)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPostingTurkey = autocompleteUrls.object(at: indexPath.row) as! ComplexPostingTurkey
            
            complexTextField.text = cuatomerep.complexName
            let complexId  = cuatomerep.complexId as! Int
            let cutstId = cuatomerep.customerId as! Int
            UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
            UserDefaults.standard.set(cutstId, forKey: "unCustId")
            UserDefaults.standard.set(complexTextField.text, forKey: "complex")
            UserDefaults.standard.synchronize()
            
            autoSerchTable.alpha = 0
            complexTextField.endEditing(true)
            buttonDroper.alpha = 0
            
        } else if tableView == necroWithoutTable{
            let arr = (NecropsiesPostingSess.object(at: indexPath.row)) as! NSMutableArray
            let arr1 = arr[0]
            UserDefaults.standard.set(1, forKey: "isBackWithoutFedd")
            UserDefaults.standard.synchronize()
            let lngIdNec = (arr1 as AnyObject).value(forKey: "lngId") as! NSNumber
            let lngId = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
            if lngId == lngIdNec {
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as? PostingVCTurkey
                mapViewControllerObj!.navigateFromUnlinked = "Unlinked"
                UserDefaults.standard.set(true, forKey: "Unlinked")
                UserDefaults.standard.set(0, forKey: "postingId")
                let complexname =  (arr1 as AnyObject).value(forKey: "complexName") as! String
                UserDefaults.standard.set(complexname, forKey: "complexUnlinked")
                let sessiondate = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                UserDefaults.standard.set(sessiondate, forKey: "complexDateUnlinked")
                UserDefaults.standard.synchronize()
                let complexId =   (arr1 as AnyObject).value(forKey: "complexId") as! Int
                let custId =  (arr1 as AnyObject).value(forKey: "custmerId") as! Int
                mapViewControllerObj!.strComplexFromUnlinked = (arr1 as AnyObject).value(forKey: "complexName") as! String
                mapViewControllerObj!.strdateFromUnlinked = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                mapViewControllerObj!.unComplexId = complexId
                mapViewControllerObj!.unCustId = custId
                mapViewControllerObj?.actualTimeStamp =   (arr1 as AnyObject).value(forKey: "actualTimeStamp") as! String
                mapViewControllerObj?.lblTimestampUnlinked = (arr1 as AnyObject).value(forKey: "timeStamp") as! String
                appDelegate.sendFeedVariable = ""
                
                let necId = (arr1 as AnyObject).value(forKey: "necropsyId") as! Int
                let postingId = (arr1 as AnyObject).value(forKey: "postingId") as! Int
                mapViewControllerObj!.necId = necId
                mapViewControllerObj!.postingIdnavigate =  postingId
                
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
                UserDefaults.standard.set(necId, forKey: "necUnLinked")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
                
            } else {
                var lanStr  = String()
                let lngId =  lngIdNec
                if lngId == 1{
                    lanStr = "English"
                }
                else{
                    lanStr = "Spanish"
                }
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in \(lanStr) language. Please logout and select \(lanStr) as a language to edit /proceed this session.", comment: ""))
            }
        } else {
            let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1Turkey") as? CaptureNecropsyStep1Turkey
            
            let posting : PostingSessionTurkey = unlinkedNecropsies.object(at: indexPath.row) as! PostingSessionTurkey
            let lngId = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
            if lngId == posting.lngId{
            
                var postingId = posting.postingId as! Int
                navigateToAnother!.isComesFromUnlikedWithPostind = true
                if posting.actualTimeStamp == nil || posting.actualTimeStamp == ""{
                    posting.actualTimeStamp = ""
                }  else {
                    
                    navigateToAnother?.actualTimestamp = posting.actualTimeStamp!
                }
                
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.setValue(posting.sessiondate, forKey: "date")
                UserDefaults.standard.setValue(posting.complexName, forKey: "complex")
                UserDefaults.standard.setValue(posting.customerName, forKey: "custmer")
                UserDefaults.standard.set(postingId, forKey: "postingId")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(navigateToAnother!, animated: false)
                
            } else {
                var lanStr  = String()
                let lngId =  posting.lngId
                if lngId == 1{
                    lanStr = "English"
                }
                else {
                    lanStr = "Spanish"
                }
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in \(lanStr) language. Please logout and select \(lanStr) as a language to edit /proceed this session.", comment: ""))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
}



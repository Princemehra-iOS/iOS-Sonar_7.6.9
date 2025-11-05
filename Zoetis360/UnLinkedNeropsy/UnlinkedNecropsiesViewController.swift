//
//  UnlinkedNecropsiesViewController.swift

//  Zoetis -Feathers
//
//  Created by "" on 8/22/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import CoreData

import Reachability
import SystemConfiguration

class UnlinkedNecropsiesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,startNecropsyP {
    // MARK: - VARIABLES
    let objApiSync = ApiSync()
    var lngId = NSInteger()
    let buttonbg1 = UIButton ()
    let buttonbg2 = UIButton ()
    var buttonback = UIButton()
    var customPopV :startNecropsyXib!
    let buttonDroper = UIButton ()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    let cellReuseIdentifier = "cell"
    var complexTypeFetchArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    var buttnTag = Int()
    var dictdata = NSMutableDictionary()
    var buttonBg = UIButton ()
    var comlexDateFrench = String()
    let bckroundBtnn = UIButton ()
    var datePicker : UIDatePicker!
    var fromDate = Date()
    var toDate   = Date()
    var fromString = String()
    var toString = String()
    var dateFormatter = DateFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var customPopView1 :UserListView!
    var fetchcomplex = NSArray ()
    var Necropsycomplex = NSArray ()
    var unlinkedNecropsies =  NSMutableArray()
    var NecropsiesPostingSess =  NSMutableArray()
    var existingArray = NSMutableArray()
    var  postingId = Int()
    
    // MARK: - OUTLET
    
    @IBOutlet weak var syncNotiCountLbl: UILabel!
    @IBOutlet weak var postingTableView: UITableView!
    @IBOutlet weak var necropsyTableView: UITableView!
    @IBOutlet weak var unlinkedSearchTextField: UITextField!
    @IBOutlet weak var necropsyWithoutPostingOutlet: UIButton!
    @IBOutlet weak var postingSessionWithout: UIButton!
    @IBOutlet weak var necropsyWithoutPostingHeader: UIView!
    @IBOutlet weak var postingSesionWithoutHeader: UIView!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var selectDateLabelFrench: UILabel!
    @IBOutlet weak var toDateLabelFrench: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @objc func methodOfReceivedNotification(notification: Notification){
        UserDefaults.standard.set(0, forKey: "postingId")
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
        self.navigationController?.navigationBar.isHidden = true
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        NotificationCenter.default.addObserver(self, selector: #selector(UnlinkedNecropsiesViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        postingTableView.estimatedRowHeight = 50
        postingTableView.rowHeight = UITableView.automaticDimension
        unlinkedSearchTextField.layer.borderColor = UIColor.black.cgColor
                
        buttnTag = 1
        if lngId == 3{
            selectDateLabel.alpha = 0
            toDateLabel.alpha = 0
             dateFormatter = DateFormatter()
          
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            selectDateLabelFrench.text = dateFormatter.string(from: Date())
            toDateLabelFrench.text = dateFormatter.string(from: Date())
        }
        if lngId == 4{
            selectDateLabel.alpha = 0
            toDateLabel.alpha = 0
             dateFormatter = DateFormatter()
          
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            selectDateLabelFrench.text = dateFormatter.string(from: Date())
            toDateLabelFrench.text = dateFormatter.string(from: Date())
        }
        else{
            selectDateLabelFrench.alpha = 0
            toDateLabelFrench.alpha = 0
            selectDateLabel.alpha = 1
            toDateLabel.alpha = 1
        }
       
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        fromString = dateFormatter.string(from: Date())
        toString = dateFormatter.string(from: Date())
        selectDateLabel.text = fromString
        toDateLabel.text = toString
        
        UserDefaults.standard.set( toDateLabel.text, forKey: "date")
        UserDefaults.standard.synchronize()
        let arr =  CoreDataHandler().fetchAllPostingSessionWithVetId(_VetName: "")
        
        for i in 0..<arr.count{
            let pId = arr.object(at: i)
           
            var unlinkarr = CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(pId as! NSNumber).mutableCopy() as! NSMutableArray
            
            if unlinkarr.count > 0
            {
                self.NecropsiesPostingSess.add(unlinkarr)
            }
        }
        
       
        var reversedArray =  NSMutableArray(array:NecropsiesPostingSess.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        
        NecropsiesPostingSess.removeAllObjects()
        NecropsiesPostingSess = reversedArray.mutableCopy() as! NSMutableArray
        
        existingArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        postingTableView.delegate = self
        postingTableView.dataSource = self
        necropsyTableView.delegate = self
        necropsyTableView.dataSource = self
        necropsyWithoutPostingHeader.isHidden = false
        postingSesionWithoutHeader.isHidden = true
        necropsyTableView.isHidden = false
        postingTableView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
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
        
        if  buttnTag == 2
        {
            self.unlinkedNecropsies =  CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
            necropsyTableView.isHidden = true
            postingTableView.isHidden = false
            necropsyWithoutPostingHeader.isHidden = true
            postingSesionWithoutHeader.isHidden = false
            postingTableView.reloadData()
        }
        else
        {
            let arr =  CoreDataHandler().fetchAllPostingSessionWithVetId(_VetName: "")
            self.NecropsiesPostingSess.removeAllObjects()
            for i in 0..<arr.count{
                
                let pId = arr.object(at: i)
              
                var unlinkarr = CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(pId as! NSNumber).mutableCopy() as! NSMutableArray
                
                if unlinkarr.count > 0
                {
                    self.NecropsiesPostingSess.add(unlinkarr)
                }
            }
            
          
            var reversedArray =  NSMutableArray(array:NecropsiesPostingSess.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
            NecropsiesPostingSess.removeAllObjects()
            NecropsiesPostingSess = reversedArray.mutableCopy() as! NSMutableArray
            necropsyTableView.isHidden = false
            postingTableView.isHidden = true
            necropsyWithoutPostingHeader.isHidden = false
            postingSesionWithoutHeader.isHidden = true
            necropsyTableView.reloadData()
        }
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        complexTypeFetchArray = CoreDataHandler().fetchCompexType().mutableCopy() as! NSMutableArray
        let data: NSArray = CoreDataHandler().fetchCompexType()
        fetchcustRep = data
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonDroper.addTarget(self, action: #selector(UnlinkedNecropsiesViewController.buttonPressedDroper), for: .touchUpInside)
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
    
    // MARK: 🟠 - TABLE VIEW DATA SOURCE AND DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView ==  necropsyTableView{
            return NecropsiesPostingSess.count
        }
        else if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        else if tableView == postingTableView{
            return unlinkedNecropsies.count
        }
        return 0
    }
    
    fileprivate func handleLngIdCellDateObj(_ lngIdFr: Int, _ cell: NecropsyTableViewCell, _ dateObj: Date?, _ dateString: String, _ dateFormatter: DateFormatter, _ comlexDate: String) {
        if lngIdFr == 3 || lngIdFr == 4 {
            cell.sessionDateLbl.text = dateObj == nil ? dateString : dateFormatter.string(from: dateObj!)
        } else {
            let dateString = comlexDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            
            if dateObj == nil {
                cell.sessionDateLbl.text = dateString
                
            } else {
                cell.sessionDateLbl.text = dateFormatter.string(from: dateObj!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == necropsyTableView {
            
            let cell:NecropsyTableViewCell = self.necropsyTableView.dequeueReusableCell(withIdentifier: "necropsyCell") as! NecropsyTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let arr = (NecropsiesPostingSess.object(at: indexPath.row)) as! NSMutableArray
            if arr.count > 0 {
                let arr1 = arr[0]
                let complexName = (arr1 as AnyObject).value(forKey: "complexName") as! String
                let comlexDate = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                let lngIdFr = UserDefaults.standard.integer(forKey: "lngId")
                
                let dateString = comlexDate
              
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = Constants.ddMMyyyStr
                
                handleLngIdCellDateObj(lngIdFr, cell, dateObj, dateString, dateFormatter, comlexDate)
                
                cell.complexLbl.text = complexName
                
                let sessionLngId = (arr1 as AnyObject).value(forKey: "lngId") as! NSNumber

                let languageMap: [NSNumber: String] = [
                    1: "(En)",
                    3: "(Fr)",
                    4: "(pt-BR)"
                ]

                cell.lblLng.text = languageMap[sessionLngId] ?? "(En)"
            }
            return cell
        }
        
        else if tableView == autoSerchTable {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            cell.textLabel?.text = cuatomerep.complexName
            cell.textLabel?.font = unlinkedSearchTextField.font
            return cell
        }
        else {
            let cell:UnlinkedNecropsiesTableViewCell = self.postingTableView.dequeueReusableCell(withIdentifier: "unlinked") as!  UnlinkedNecropsiesTableViewCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            let posting : PostingSession = unlinkedNecropsies.object(at: indexPath.row) as! PostingSession
            cell.complexLblPostingSession.text = posting.value(forKey: "complexName") as? String
            let lngIdFr = UserDefaults.standard.integer(forKey: "lngId")
            if lngIdFr == 3{
                let dateString = posting.value(forKey: "sessiondate") as! String
              
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = Constants.ddMMyyyStr
                cell.dateLblPostingSession.text = dateFormatter.string(from: dateObj!)
            }
            if lngIdFr == 4{
                let dateString = posting.value(forKey: "sessiondate") as! String
               
                dateFormatter.dateFormat = Constants.MMddyyyyStr
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = Constants.ddMMyyyStr
                cell.dateLblPostingSession.text = dateFormatter.string(from: dateObj!)
            }
            else{
                cell.dateLblPostingSession.text = posting.value(forKey: "sessiondate") as? String
            }
            
            cell.sessionLblPostingSesson.text = posting.value(forKey: "sessionTypeName") as? String
            cell.veterinarianLblPostingSession.text = posting.value(forKey: "vetanatrionName") as? String
            let selectdLngId =  posting.lngId
            if selectdLngId == 1{
                cell.lblLng.text = "(En)"
            }else if selectdLngId == 3{
                cell.lblLng.text = "(Fr)"
            }
            return cell
        }
    }
    
    fileprivate func alertMessageLanguageBasis(lngId :NSNumber) {
        if lngId == 4{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in portuguese language. Please logout and select portuguese as a language to edit / view this session.", comment: ""))
            
        }
        if lngId == 3{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in french language. Please logout and select french as a language to edit / view this session.", comment: ""))
            
        }
        
        if lngId == 1{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(NSLocalizedString(Constants.alertStr, comment: ""), comment: "") , messageStr:NSLocalizedString("This session has been created in English language. Please logout and select french as a language to edit / view this session.", comment: ""))
            
        }
        
      
    }
    
    fileprivate func dateFormatterFrench(_ sessiondate: String) {
        let dateString = sessiondate
        
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let dateObj = dateFormatter.date(from: dateString)
        if dateObj == nil{
            comlexDateFrench = dateString
        }
        else{
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            comlexDateFrench = dateFormatter.string(from: dateObj!)
        }
        UserDefaults.standard.setValue(comlexDateFrench, forKey: "dateFrench")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPosting = autocompleteUrls.object(at: indexPath.row) as! ComplexPosting
            
            unlinkedSearchTextField.text = cuatomerep.complexName
            let complexId  = cuatomerep.complexId as! Int
            let cutstId = cuatomerep.customerId as! Int
            
            UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
            UserDefaults.standard.set(cutstId, forKey: "unCustId")
            UserDefaults.standard.set(unlinkedSearchTextField.text, forKey: "complex")
            UserDefaults.standard.synchronize()
            
            autoSerchTable.alpha = 0
            unlinkedSearchTextField.endEditing(true)
            buttonDroper.alpha = 0
        }
        else if tableView == necropsyTableView{
            let arr = (NecropsiesPostingSess.object(at: indexPath.row)) as! NSMutableArray
            let arr1 = arr[0]
            UserDefaults.standard.set(1, forKey: "isBackWithoutFedd")
            UserDefaults.standard.synchronize()
            let lngIdNec = (arr1 as AnyObject).value(forKey: "lngId") as! NSNumber
            let lngIdNew = UserDefaults.standard.integer(forKey: "lngId") as NSNumber
            if lngIdNew == lngIdNec || lngIdNec.intValue == 0 {
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
                mapViewControllerObj!.navigateFromUnlinked = "Unlinked"
                UserDefaults.standard.set(true, forKey: "Unlinked")
                UserDefaults.standard.set(0, forKey: "postingId")
                let complexname =  (arr1 as AnyObject).value(forKey: "complexName") as! String
                UserDefaults.standard.set(complexname, forKey: "complexUnlinked")
                let sessiondate = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                
                let selectedLngId = UserDefaults.standard.integer(forKey: "lngId")
                if selectedLngId == 3{
                    dateFormatterFrench(sessiondate)
                }
                
                UserDefaults.standard.set(sessiondate, forKey: "complexDateUnlinked")
                UserDefaults.standard.synchronize()
                let complexId =   (arr1 as AnyObject).value(forKey: "complexId") as! Int
                let custId =  (arr1 as AnyObject).value(forKey: "custmerId") as? Int
                mapViewControllerObj!.strComplexFromUnlinked = (arr1 as AnyObject).value(forKey: "complexName") as! String
                mapViewControllerObj!.strdateFromUnlinked = (arr1 as AnyObject).value(forKey: "complexDate") as! String
                mapViewControllerObj!.unComplexId = complexId
                mapViewControllerObj!.unCustId = custId ?? 0
                mapViewControllerObj?.actualTimeStamp =   (arr1 as AnyObject).value(forKey: "actualTimeStamp") as! String
                mapViewControllerObj?.lblTimestampUnlinked = (arr1 as AnyObject).value(forKey: "timeStamp") as! String
                appDelegate.sendFeedVariable = ""
                
                let necId = (arr1 as AnyObject).value(forKey: "necropsyId") as! Int
                let postingIdIs = (arr1 as AnyObject).value(forKey: "postingId") as! Int
                mapViewControllerObj!.necId = necId
                mapViewControllerObj!.postingIdnavigate =  postingIdIs
                UserDefaults.standard.set(true, forKey: "nec")
                UserDefaults.standard.set(false, forKey: "isUpadteFeedFromUnlinked")
                UserDefaults.standard.set(necId, forKey: "necUnLinked")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
            }
            else{
                
                alertMessageLanguageBasis(lngId: lngIdNec)
            }
        }
        else{
            let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1") as? captureNecropsyStep1Data
            let posting : PostingSession = unlinkedNecropsies.object(at: indexPath.row) as! PostingSession
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            if lngId == posting.lngId as! Int{
               
                let newPostingId = posting.postingId as! Int
                navigateToAnother!.isComesFromUnlikedWithPostind = true
                posting.actualTimeStamp = posting.actualTimeStamp ?? ""
                navigateToAnother?.actualTimestamp = posting.actualTimeStamp ?? ""
                
                UserDefaults.standard.set(true, forKey: "nec")
                let newLngId = UserDefaults.standard.integer(forKey: "lngId")
                if newLngId == 3{
                    let dateString = posting.sessiondate
                    dateFormatter.dateFormat = Constants.MMddyyyyStr
                    let dateObj = dateFormatter.date(from: dateString!)
                    dateFormatter.dateFormat = Constants.ddMMyyyStr
                    comlexDateFrench = dateFormatter.string(from: dateObj!)
                    UserDefaults.standard.setValue(comlexDateFrench, forKey: "dateFrench")
                }
                
                UserDefaults.standard.setValue(posting.sessiondate, forKey: "date")
                UserDefaults.standard.setValue(posting.complexName, forKey: "complex")
                UserDefaults.standard.setValue(posting.customerName, forKey: "custmer")
                UserDefaults.standard.set(newPostingId, forKey: "postingId")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(navigateToAnother!, animated: false)
            } else {
                alertMessageLanguageBasis(lngId: lngId as NSNumber)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    // MARK: 🟠 - TEXTFIELD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (textField.tag == 101){
            
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            fetchcomplexArray = CoreDataHandler().fetchCompexType().filtered(using: bPredicate) as NSArray
            autocompleteUrls = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autoSerchTable.frame = CGRect(x: 725, y: 123, width: 220, height: 250)
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
    
    // MARK: 🟠 Search Button Action
    @IBAction func searchButtonAction(_ sender: AnyObject) {
        
        if  buttnTag == 1{
            
            let newString = unlinkedSearchTextField.text
            if newString!.isEmpty == true{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(complexDate >= %@) AND (complexDate <= %@) OR complexName contains[c] %@", selectDateLabel.text!, toDateLabel.text! ,newString!)
                
                fetchcustRep = CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(0).filtered(using: bPredicate) as NSArray
                
                NecropsiesPostingSess = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if NecropsiesPostingSess.count == 0 {
                    self.Alert()
                }
                necropsyTableView.reloadData()
            }
            else{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(complexDate >= %@) AND (complexDate <= %@) AND complexName contains[c] %@", selectDateLabel.text!, toDateLabel.text! ,newString!)
                fetchcustRep = CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(0).filtered(using: bPredicate) as NSArray
                NecropsiesPostingSess = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if NecropsiesPostingSess.count == 0 {
                    self.Alert()
                }
                necropsyTableView.reloadData()
            }
        }
        else if buttnTag == 2{
            
            let newString = unlinkedSearchTextField.text
            if newString!.isEmpty == true{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) OR complexName contains[c] %@", selectDateLabel.text!, toDateLabel.text! ,newString!)
                fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                self.unlinkedNecropsies = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if self.unlinkedNecropsies.count == 0 {
                    self.Alert()
                }
                postingTableView.reloadData()
                
            }
            else {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND (sessiondate <= %@) AND complexName contains[c] %@", selectDateLabel.text!, toDateLabel.text! ,newString!)
                
                fetchcustRep = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                self.unlinkedNecropsies = fetchcustRep.mutableCopy() as! NSMutableArray
                if self.unlinkedNecropsies.count == 0 {
                    self.Alert()
                }
                postingTableView.reloadData()
            }
        }
    }
    
    // MARK: 🟠 "From Date" Button Action
    @IBAction func fromDateBtn(_ sender: AnyObject) {
        view.endEditing(true)
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(UnlinkedNecropsiesViewController.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(UnlinkedNecropsiesViewController.doneClick1)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(UnlinkedNecropsiesViewController.cancelClick1)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
    }
    
    @IBAction func sliderBttn(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    // MARK: 🟠 Necropsy Without Button Action
    @IBAction func necropsyWithoutPostingRadio(_ sender: AnyObject) {
        
        buttnTag = 1
        let arr =  CoreDataHandler().fetchAllPostingSessionWithVetId(_VetName: "")
        
        self.NecropsiesPostingSess.removeAllObjects()
        for i in 0..<arr.count{
            let pId = arr.object(at: i)
           
            var unlinkarr = CoreDataHandler().FetchNecropsystep1UpdateFromUnlinked(pId as! NSNumber).mutableCopy() as! NSMutableArray
            if unlinkarr.count > 0
            {
                self.NecropsiesPostingSess.add(unlinkarr)
            }
        }
        
      
        var reversedArray =  NSMutableArray(array:NecropsiesPostingSess.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        NecropsiesPostingSess.removeAllObjects()
        NecropsiesPostingSess = reversedArray.mutableCopy() as! NSMutableArray
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            necropsyWithoutPostingOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            postingSessionWithout.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        
        necropsyTableView.isHidden = false
        postingTableView.isHidden = true
        necropsyWithoutPostingHeader.isHidden = false
        postingSesionWithoutHeader.isHidden = true
        necropsyTableView.reloadData()
    }
    // MARK: 🟠 Posting Session without Button Action
    @IBAction func postingSessionWithoutRadio(_ sender: AnyObject) {
        buttnTag = 2
        UserDefaults.standard.set(false, forKey: "Unlinked")
        UserDefaults.standard.synchronize()
        
        self.unlinkedNecropsies =  CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        
        if unlinkedNecropsies.count == 0{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No sessions found.", comment: ""))
        }
        
        necropsyTableView.isHidden = true
        postingTableView.isHidden = false
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            postingSessionWithout.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            necropsyWithoutPostingOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        necropsyWithoutPostingHeader.isHidden = true
        postingSesionWithoutHeader.isHidden = false
        postingTableView.reloadData()
    }
    
    // MARK: 🟠 "TO Date" Button Action
    @IBAction func toDateBttn(_ sender: AnyObject) {
        view.endEditing(true)
        
        let buttons  = DatepickerClass.sharedInstance.pickUpDate()
        buttonBg  = buttons.0
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonBg.addTarget(self, action: #selector(UnlinkedNecropsiesViewController.buttonPressed), for: .touchUpInside)
        let donebutton : UIBarButtonItem = buttons.1
        donebutton.action =  #selector(UnlinkedNecropsiesViewController.doneClick)
        let cancelbutton : UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(UnlinkedNecropsiesViewController.cancelClick1)
        datePicker = buttons.4
        self.view.addSubview(buttonBg)
        
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func Alert(){
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No sessions found.", comment: ""))
    }
    // MARK: 🟠 Call Necropsy PopUp Button Action
    func CallPopoupStartNec()  {
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcn), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        customPopV = (startNecropsyXib.loadFromNibNamed("startNecropsyXib") as! startNecropsyXib)
        customPopV.necropsyDelegate = self
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
        
    }
    
    @objc func buttonAcn(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
        
    }
    // MARK: 🟠 Date formatter "From Date" Done Button Action
    @objc func doneClick1() {
        
        datePicker.locale = Locale(identifier: "en_US")
        dateFormatter = DateFormatter()

        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3{
            selectDateLabel.alpha = 0
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            let strdate = dateFormatter.string(from: datePicker.date) as String
            selectDateLabelFrench.text = strdate
        }
        else{
            selectDateLabel.alpha = 1
            selectDateLabelFrench.alpha = 0
            dateFormatter.dateFormat = Constants.MMddyyyyStr
        }
        
        fromString = dateFormatter.string(from: datePicker.date)
        fromDate = datePicker.date
        
        if fromString == toString{
            
            let strdate = dateFormatter.string(from: datePicker.date) as String
            selectDateLabel.text = strdate
            UserDefaults.standard.set( selectDateLabel.text, forKey: "date")
            buttonBg.removeFromSuperview()
            postingTableView.reloadData()
            necropsyTableView.reloadData()
        }
        else if fromDate.isLessThanDate(toDate)
        {
            let strdate = dateFormatter.string(from: datePicker.date) as String
            selectDateLabel.text = strdate
            UserDefaults.standard.set(selectDateLabel.text, forKey: "date")
            UserDefaults.standard.synchronize()
            buttonBg.removeFromSuperview()
            postingTableView.reloadData()
            necropsyTableView.reloadData()
        }
        else 
        {
            self.cancelClick1()
            fromString = selectDateLabel.text!
           
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            fromDate = dateFormatter.date(from: fromString)!
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("From date must be smaller than to date.", comment: ""))
        }
    }
    // MARK: 🟠 Calander Cancel Button Action
    @objc func cancelClick1() {
        buttonBg.removeFromSuperview()
    }
    
    @objc func buttonPressed() {
        buttonBg.removeFromSuperview()
    }
    
    // MARK: 🟠 Date formatter "TO Date" Done Button Action
    @objc func doneClick() {
        dateFormatter = DateFormatter()

        datePicker.locale = Locale(identifier: "en_US")
        if lngId == 3 {
            toDateLabel.alpha = 0
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            let strdate = dateFormatter.string(from: datePicker.date) as String
            toDateLabelFrench.text = strdate
        }
        else {
            toDateLabel.alpha = 1
            toDateLabelFrench.alpha = 0
        }
        
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        toString = dateFormatter.string(from: datePicker.date)
        toDate = datePicker.date
        
        if fromString == toString || toDate.isGreaterThanDate(fromDate){
            let strdate = dateFormatter.string(from: datePicker.date) as String
            toDateLabel.text = strdate
            UserDefaults.standard.set( toDateLabel.text, forKey: "date")
            buttonBg.removeFromSuperview()
            postingTableView.reloadData()
            necropsyTableView.reloadData()
            
        } else {
            self.cancelClick1()
            fromString = toDateLabel.text!
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            toDate = dateFormatter.date(from: fromString)!
            Helper.showAlertMessage(self,titleStr: NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("To date must be greater than from date.", comment: "") )
        }
    }
    
    func startNecropsyBtnFunc (){
        appDelegateObj.testFuntion()
    }
    
    // MARK: 🟠 Cross Button Action
    func crossBtnFunc(){
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
}

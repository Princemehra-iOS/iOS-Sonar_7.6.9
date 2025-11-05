//
//  StartNecropsyVcTurky.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 23/03/18.
//  Copyright © 2018 . All rights reserved.

import UIKit

class StartNecropsyVcTurky: UIViewController,necropsyPop, UITextFieldDelegate {
    
    // MARK: - VARIABLES
    var necbckBtn = UIButton()
    var bckPopUp :startNecrPopUpTurkey!
    var buttonback = UIButton()
    var buttonBg = UIButton()
    var buttonBg1 = UIButton()
    var datePicker : UIDatePicker!
    var complexTypeFetchArray = NSMutableArray()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    let buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    let cellReuseIdentifier = "cell"
    
    // MARK: - OUTLET
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var selectFromLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var complexNameLbl: UITextField!
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.alpha = 0
        complexNameLbl.layer.borderWidth = 1
        complexNameLbl.layer.cornerRadius = 3.5
        complexNameLbl.layer.borderColor = UIColor.black.cgColor
        complexNameLbl.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        
        let todaysDate1:NSDate = NSDate()
        let dateFormatter1:DateFormatter = DateFormatter()
        dateFormatter1.dateFormat="MM/dd/yyyy/HH:mm:ss"
        let DateInFormat1:String = dateFormatter1.string(from: todaysDate1 as Date)
        selectFromLbl.text = DateInFormat
        UserDefaults.standard.set( selectFromLbl.text, forKey: "date")
        UserDefaults.standard.set( DateInFormat1, forKey: "timeStamp")
        
        UserDefaults.standard.synchronize()
        existingArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).mutableCopy() as! NSMutableArray
        buttonback.removeFromSuperview()
        self.necbckBtn.removeFromSuperview();
        if existingArray.count == 0 {
            print(appDelegateObj.testFuntion())
        }
        
        if UserDefaults.standard.bool(forKey: "backFromStep1") == true {
            existingArray.removeAllObjects()
            self.tableView.reloadData()
            
            complexNameLbl.text = ""
            if (bckPopUp != nil) {
                bckPopUp.removeFromSuperview()
                buttonback.removeFromSuperview()
            }
            
            UserDefaults.standard.set(false, forKey: "backFromStep1")
            UserDefaults.standard.synchronize()
        }
        
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        complexTypeFetchArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().mutableCopy() as! NSMutableArray
        
        if let data = CoreDataHandlerTurkey().fetchCompexTypeTurkey() as? NSArray {
            fetchcustRep = data
        }
        
        buttonDroper.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonDroper.addTarget(self, action: #selector(StartNecropsyVcTurky.buttonPressedDroper), for: .touchUpInside)
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
    
    
    // MARK: - IBACTION
    @IBAction func bckBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func checkComplex() {
        if checkComplexName(complexName: complexNameLbl.text!) == true {
            self.strtNecrPop()
        } else  {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:"Complex doesn't exist.")
        }
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        
        if(complexNameLbl.text == "") || (selectFromLbl.text == "" ){
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter complex.", comment: ""))
        } else {
            let newString = complexNameLbl.text
            if newString!.isEmpty == true{
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) OR complexName contains[cd] %@", selectFromLbl.text! ,newString!)
                
                fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                
                existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if existingArray.count == 0 {
                    
                    checkComplex()
                } else {
                    self.tableView.alpha = 1
                }
                self.tableView.reloadData()
                
            } else {
                
                let bPredicate: NSPredicate = NSPredicate(format: "(sessiondate >= %@) AND complexName contains[cd] %@", selectFromLbl.text! ,newString!)
                fetchcustRep = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(0, birdTypeId: 0).filtered(using: bPredicate) as NSArray
                
                existingArray = fetchcustRep.mutableCopy() as! NSMutableArray
                
                if existingArray.count == 0 {
                    
                    checkComplex()
                } else {
                    self.tableView.alpha = 1
                    let necData = CoreDataHandlerTurkey().FetchNecropsystep1AllNecIdTurkeyWithId(sessiondate: selectFromLbl.text!, newString: newString!)
                    if necData.count>1{
                        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: "Session for this date & complex already exist. Please select another date or complex.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.complexNameLbl.text = ""
                            //self.searchWidComplexName.text = ""
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        
                        let data =    CoreDataHandlerTurkey().fetchAllPostingExistingSessionWithId(sessionDate: selectFromLbl.text!, newString: newString!)
                        if data.count < 1{
                            self.strtNecrPop()
                        }
                    }
                    // self.strtNecrPop()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func selectFromDateAction(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let buttons  = CommonClass.sharedInstance.pickUpDate()
        buttonBg1  = buttons.0
        buttonBg1.frame = CGRect(x: 0,y: 0,width: 1024,height: 768) // X, Y, width, height
        buttonBg1.addTarget(self, action: #selector
                            (StartNecropsyVcTurky.buttonPressed1), for: .touchUpInside)
        
        let donebutton :UIBarButtonItem = buttons.1
        donebutton.action =  #selector(StartNecropsyVcTurky.doneClick1)
        
        let cancelbutton: UIBarButtonItem = buttons.3
        cancelbutton.action =  #selector(StartNecropsyVcTurky.cancelClick1)
        datePicker = buttons.4
        self.view.addSubview(buttonBg1)
    }
    
    
    // MARK: - METHOD & FUNCTION
    func startNecropsyBtnFunc (){
        UserDefaults.standard.removeObject(forKey: "count")
        if(complexNameLbl.text == "") || (selectFromLbl.text == "" ){
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please select coplex & date.", comment: ""))
        } else {
            
            let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1Turkey") as? CaptureNecropsyStep1Turkey
            navigateToAnother!.navigatefronInlinked = "Unlinked"
            UserDefaults.standard.set(true, forKey: "nec")
            UserDefaults.standard.set(true, forKey: "Unlinked")
            self.navigationController?.pushViewController(navigateToAnother!, animated: false)
        }
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j) as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w) as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
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
    
    
    func checkComplexName(complexName: String) -> Bool {
        
        var isComplexandDateExist :Bool = false
        let colpexArr = CoreDataHandlerTurkey().fetchCompexTypeTurkey()
        for i in 0..<colpexArr.count{
            let complexNameData = colpexArr.object(at: i) as! ComplexPostingTurkey
            if complexNameData.complexName == complexNameLbl.text {
                CoreDataHandlerTurkey().fetchCustomerTurkey()
                isComplexandDateExist = true
                break
            }
        }
        return isComplexandDateExist
    }
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    func strtNecrPop(){
        necbckBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        necbckBtn.backgroundColor = UIColor.black
        necbckBtn.alpha = 0.5
        necbckBtn.setTitle("", for: UIControl.State())
        necbckBtn.addTarget(self, action: #selector(notesButtonAcn), for: .touchUpInside)
        self.view.addSubview(necbckBtn)
        bckPopUp = startNecrPopUpTurkey.loadFromNibNamed("startNecrPopUpTurkey") as! startNecrPopUpTurkey
        bckPopUp.delegateStartNec = self
        bckPopUp.center = self.view.center
        self.view.addSubview(bckPopUp)
        
    }
    @objc func notesButtonAcn(_ sender: UIButton!) {
        self.bckPopUp.removeFromSuperview()
        self.necbckBtn.removeFromSuperview()
    }
    func crossBtn(){
        
        self.bckPopUp.removeFromSuperview()
        self.necbckBtn.removeFromSuperview()
    }
    func crossBtnFunc (){
        self.complexNameLbl.text = ""
        bckPopUp.removeFromSuperview()
        buttonback.removeFromSuperview()
        self.necbckBtn.removeFromSuperview()
    }
    func startNecroBtn(){
        self.bckPopUp.removeFromSuperview()
        self.necbckBtn.removeFromSuperview()
        
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "Step1Turkey") as? CaptureNecropsyStep1Turkey
        mapViewControllerObj?.complexLbl.text = complexNameLbl.text
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    
    @objc func doneClick1() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat=Constants.MMddyyyyStr
        //        dateFormatter1.calendar = Calendar(identifier: .gregorian)
        //        dateFormatter1.timeZone = TimeZone(secondsFromGMT: 0)
        selectFromLbl.text = dateFormatter1.string(from: datePicker.date)
        UserDefaults.standard.set( selectFromLbl.text, forKey: "date")
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat="MM/dd/yyyy/HH:mm:ss"
        //        dateFormatter3.calendar = Calendar(identifier: .gregorian)
        //        dateFormatter3.timeZone = TimeZone(secondsFromGMT: 0)
        let strdate1 = dateFormatter3.string(from: datePicker.date) as String
        UserDefaults.standard.set( strdate1, forKey: "timeStamp")
        UserDefaults.standard.synchronize()
        
        buttonBg1.removeFromSuperview()
    }
    
    @objc func cancelClick1() {
        
        buttonBg1.removeFromSuperview()
    }
    
    @objc func buttonPressed1() {
        
        buttonBg1.removeFromSuperview()
    }
    
    // MARK: - TEXTFIELD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101){
            
            let bPredicate: NSPredicate = NSPredicate(format: "complexName contains[cd] %@", newString)
            fetchcomplexArray = CoreDataHandlerTurkey().fetchCompexTypeTurkey().filtered(using: bPredicate) as NSArray
            autocompleteUrls = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autoSerchTable.frame = CGRect(x: 744,y:  125,width: 196,height: 200)
            
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
        
        let postingSessionArray =  CoreDataHandlerTurkey().FetchNecropsystep1AllNecIdTurkey() as NSArray
        
        for i in 0..<postingSessionArray.count {
            let pSession = postingSessionArray.object(at: i) as! CaptureNecropsyDataTurkey
            let sessionDate = pSession.complexDate! as String
            let sessioncomplexName = pSession.complexName! as String
            if (sessionDate == date) && (sessioncomplexName == complexName) {
                isComplexandDateExist = true
                break
            }
        }
        let necArray =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdAllTurkey() as NSArray
        
        for i in 0..<necArray.count {
            
            let necSession = necArray.object(at: i) as! CaptureNecropsyDataTurkey
            let sessionDate = necSession.complexDate! as String
            let sessioncomplexName = necSession.complexName! as String
            if (sessionDate == date) && (sessioncomplexName == complexName) {
                
                isComplexandDateExist = true
                break
            }
        }
        return isComplexandDateExist
    }
}

// MARK: - EXTENSION
extension StartNecropsyVcTurky: UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == autoSerchTable {
            return autocompleteUrls.count
        } else {
            return existingArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let cuatomerep : ComplexPostingTurkey = autocompleteUrls.object(at: indexPath.row) as! ComplexPostingTurkey
            
            cell.textLabel?.text = cuatomerep.complexName
            cell.textLabel?.font = complexNameLbl.font
            return cell
            
        } else {
            
            let cell:startNecropsyViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! startNecropsyViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            let posting : PostingSessionTurkey = existingArray.object(at: indexPath.row) as! PostingSessionTurkey
            cell.langLbl.text = "(En)"
            
            cell.sessionDateLbl.text  = posting.sessiondate
            cell.sessionType.text  = posting.sessionTypeName
            cell.complexDateLbl.text  = posting.complexName
            cell.veterinarianLbl.text  = posting.vetanatrionName
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
        
    }
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoSerchTable {
            let cuatomerep : ComplexPostingTurkey = autocompleteUrls.object(at: indexPath.row) as! ComplexPostingTurkey
            
            complexNameLbl.text = cuatomerep.complexName
            
            let complexId  = cuatomerep.complexId as! Int
            UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
            UserDefaults.standard.synchronize()
            let cutstId = cuatomerep.customerId as! Int
            
            if checkComplexNameandDate(date: selectFromLbl.text!, complexName: complexNameLbl.text!) == true {
                let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: "Session for this date & complex already exists. Please select another date or complex.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    self.complexNameLbl.text = ""
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                autoSerchTable.alpha = 0
                buttonDroper.alpha = 0
            }  else {
                
                UserDefaults.standard.set(complexId, forKey: "UnlinkComplex")
                UserDefaults.standard.set(cutstId, forKey: "unCustId")
                UserDefaults.standard.set(complexNameLbl.text, forKey: "complex")
                UserDefaults.standard.synchronize()
                autoSerchTable.alpha = 0
                complexNameLbl.endEditing(true)
                buttonDroper.alpha = 0
            }
        } else {
            
            let navigateToAnother = self.storyboard?.instantiateViewController(withIdentifier: "Step1Turkey") as? CaptureNecropsyStep1Turkey
            
            let posting : PostingSessionTurkey = existingArray.object(at: indexPath.row) as! PostingSessionTurkey
            var postingId = posting.postingId as! Int
            
            UserDefaults.standard.set(true, forKey: "nec")
            UserDefaults.standard.set(postingId, forKey: "postingId")
            UserDefaults.standard.synchronize()
            self.navigationController?.pushViewController(navigateToAnother!, animated: false)
            
        }
    }
}

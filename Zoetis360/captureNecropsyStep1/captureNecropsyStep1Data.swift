//  captureNecropsyStep1Data.swift
//  Zoetis -Feathers
//  Created by "" on 21/10/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit
import CoreData
import Reachability

class captureNecropsyStep1Data: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    // MARK: - VARIABLE
    
    var trimmedString = String()
    var timeStampString = String()
    var strDateEn = String ()
    var strDateFr = String ()
    var metricArray: [BirdSizePosting]  = []
    var birdArray: [BirdSizePosting]  = []
    var ell = Int()
    var countFarmId = Int()
    var isComesFromUnlikedWithPostind = Bool()
    var strMsgforDelete =  String()
    var myPickerView = UIPickerView()
    let buttonbg = UIButton ()
    let buttonbg1 = UIButton ()
    var feedProgramArray = NSArray ()
    var count = Int()
    var ncropsyId = Int()
    var feeId = Int()
    var lngId = NSInteger()
    var hideDropDwnB = true
    var navigatefronInlinked = String()
    var actualTimestamp = String()
    
    var complexTypeFetchArray = NSMutableArray()
    var complexTypeFetchArray1 = NSMutableArray()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var autocompleteUrls2 = NSMutableArray ()
    var autocompleteUrls1 = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    var fetchcomplexArray1 = NSArray ()
    var buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    let cellReuseIdentifier = "cell"
    
    var HouseNo = NSArray ()
    var AgeOp = NSArray ()
    var NoOFbirds = NSArray ()
    var btnTag = Int()
    var postingId = Int()
    var droperTableView  = UITableView ()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var asb = Bool()
    var targetWeigh = UserDefaults.standard.integer(forKey: "targetWeightSelection")
    var captureNecropsy = [NSManagedObject]()
    var pickerIndexIs = Int()
    var custmerIdFarm = NSNumber() //Raman's Code
    var editfeed = String()
    
    // MARK: - OUTLET
    
    @IBOutlet weak var syncNotiCountLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var btnAddLablel: UILabel!
    @IBOutlet weak var targetWeightOutlet: UIButton!
    @IBOutlet weak var targetWeightLbl: UILabel!
    @IBOutlet weak var feedProgramDropDwnIcon: UIImageView!
    @IBOutlet weak var feedProgramOutlet: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var feedProgramTextLebl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lblCustmer: UILabel!
    @IBOutlet weak var lblHouse: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblNoBirds: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var houseIMAGEvIEW: UIImageView!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var myAgepickerView: UIPickerView!
    @IBOutlet weak var noOfBirdsPickerView: UIView!
    @IBOutlet weak var farmNameTextField: UITextField!
    
    @IBOutlet weak var flockIdTextField: UITextField!
    @IBOutlet weak var ageUperBtnOutlet1: UIButton!
    @IBOutlet weak var ageDownBtnOutlet: UIButton!
    @IBOutlet weak var feedProgramDisplayLabel: UILabel!
    @IBOutlet weak var huseNoDwnOutlet: UIButton!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
//    @IBOutlet weak var noOfDownoutlet: UIButton!
    @IBOutlet weak var noOfBirdsTextField: UITextField!
    @IBOutlet weak var noOfDownOutlet: UIButton!
    @IBOutlet weak var houseNotextField: UITextField!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var uprView: UIView!
    @IBOutlet weak var huseNoUperBttnOutlet: UIButton!
    @IBOutlet weak var noOFiMAGEVIEW: UIImageView!
    @IBOutlet weak var houseNoTextFld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var farmNameTextLebl: UILabel!
    @IBOutlet weak var houseNoTextLebl: UILabel!
    @IBOutlet weak var ageDaysTextLebl: UILabel!
    @IBOutlet weak var noOfBirdsTextLebl: UILabel!
    @IBOutlet weak var sickTextLebl: UILabel!
    @IBOutlet weak var flockIDTextLebl: UILabel!
    @IBOutlet weak var enterFlockInfoLbl: UILabel!
    @IBOutlet weak var sessionDateLbl: UILabel!
    @IBOutlet weak var complexLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var addFartmAndBirdDetails: UILabel!
    @IBOutlet weak var headerFarmName: UILabel!
    @IBOutlet weak var headerFeedProLbl: UILabel!
    @IBOutlet weak var headerBirdsLbl: UILabel!
    @IBOutlet weak var headerFlockLbl: UILabel!
    @IBOutlet weak var headerSickLbl: UILabel!
    @IBOutlet weak var headerHouseLbl: UILabel!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    let editView = UIView(frame:CGRect(x: 250, y: 220, width: 500, height: 330))
    let titleView = UIView(frame:CGRect(x: 0, y: 0, width: 500, height: 50))
    let nameLabel = UILabel(frame:CGRect(x: 42, y: 53, width: 300, height: 50))
    let titleLabel = UILabel(frame:CGRect(x: 150, y: 0, width: 400, height: 50))
    let ageLabel = UILabel(frame:CGRect(x: 42, y: 142, width: 100, height: 50))
    let feedLabel = UILabel(frame:CGRect(x: 190, y: 142, width: 300, height: 50))
    let nameText = UITextField(frame:CGRect(x: 40, y: 98, width: 220, height: 50))
    let ageButton = UIButton(frame:CGRect(x: 43, y: 184, width: 120, height: 50))
    let feedButton = UIButton(frame:CGRect(x: 190, y: 184, width: 268, height: 50))
    let submitButton = UIButton(frame:CGRect(x: 30, y: 270, width: 175, height: 40))
    let cancelButton = UIButton(frame:CGRect(x: 290, y: 270, width: 175, height: 40))
    let paddingView = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let paddingView1 = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let targetWeight = UITextField(frame:CGRect(x: 40, y: 270, width: 420, height: 50))
    let paddingViewHouse = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let houseLabel = UILabel(frame:CGRect(x: 280, y: 53, width: 100, height: 50))
    let houseNoTxtFld = UITextField(frame:CGRect(x: 280, y: 98, width: 100, height: 50))
    var feedProArrWithId = NSMutableArray()
    
    
    let buttonEdit: UIButton = UIButton()
    var strfarmName = String()
    var strFeddUpdate = String()
    var farmArray = NSMutableArray ()
    var strFeedId = Int()
    var strFarmNameFeedId = String()
    var strfarmNameArray = NSArray()
    var oldFarmName = NSString()
    var strFeddCheck  = String()
    var buttonbgNew2 = UIButton()
    let feedProgramText = "Feed Program *"
    let mendatoryFieldsMessage = Constants.mandatoryFieldsMessage
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        NoOFbirds = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10"]
        AgeOp = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80"]
        HouseNo = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50"]
        
        sessionDateLbl.text = NSLocalizedString("Session Date |", comment: "")
        companyLbl.text = NSLocalizedString("Company |", comment: "")
        complexLbl.text = NSLocalizedString("Complex |", comment: "")
        
        enterFlockInfoLbl.text = NSLocalizedString("Enter Flock Information", comment:"")
        addFartmAndBirdDetails.text = NSLocalizedString("Add Farm & Bird Details", comment:"")
        houseNoTextLebl.text = NSLocalizedString("House no.", comment: "")
        ageDaysTextLebl.text = NSLocalizedString("Age(days) *", comment: "")
        noOfBirdsTextLebl.text = NSLocalizedString("No. of birds", comment: "")
        farmNameTextLebl.text = NSLocalizedString("Farm Name *", comment: "")
        sickTextLebl.text = NSLocalizedString("Sick", comment: "")
        flockIDTextLebl.text = NSLocalizedString("Flock id", comment: "")
        
        headerFarmName.text = NSLocalizedString("Farm Name", comment: "")
        headerFeedProLbl.text = NSLocalizedString("Feed Program", comment: "")
        headerBirdsLbl.text = NSLocalizedString("No. of birds", comment: "")
        headerFlockLbl.text = NSLocalizedString("Flock id", comment: "")
        headerHouseLbl.text = NSLocalizedString("House No.", comment: "")
        headerSickLbl.text = NSLocalizedString("Sick", comment: "")
        
        nextBtn.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            
            postingId = 0
            feedProgramOutlet.isUserInteractionEnabled = false
            feedProgramOutlet.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.1)
            feedProgramDropDwnIcon.isHidden = true
            customerLbl.isHidden
            = true
            lblCustmer.isHidden = true
            feedProgramDisplayLabel.text = ""
        }
        else
        {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
            feedProgramOutlet.isUserInteractionEnabled = true
            lblCustmer.isHidden = false
            feedProgramTextLebl.text = NSLocalizedString(feedProgramText, comment: "")
            feedProgramDropDwnIcon.isHidden = false
            customerLbl.isHidden = false
            feedProgramDisplayLabel.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        }
        
        flockIdTextField.tag = 11
        houseNoTextFld.tag = 18
        lblAge.text = ""
        farmNameTextField.text = ""
        flockIdTextField.text = ""
        lblNoBirds.text = "5"
        houseNoTextFld.text = "1"
        flockIdTextField.keyboardType = .numberPad
        
        if lngId == 3 {
            lblDate.text = UserDefaults.standard.value(forKey: "dateFrench") as? String
        }
        else{
            lblDate.text = UserDefaults.standard.value(forKey: "date") as? String
        }
        
        strDateEn  = UserDefaults.standard.value(forKey: "date") as! String
        lblComplex.text = UserDefaults.standard.value(forKey: "complex") as? String
        lblCustmer.text = UserDefaults.standard.value(forKey: "custmer") as? String
        tableView.delegate = self
        tableView.dataSource = self
        feedProgramOutlet.layer.borderWidth = 1
        feedProgramOutlet.layer.cornerRadius = 3.5
        feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
        
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        farmNameTextField.layer.borderColor = UIColor.black.cgColor
        farmNameTextField.delegate = self
        flockIdTextField.delegate = self
        flockIdTextField.layer.borderWidth = 1
        flockIdTextField.layer.borderColor = UIColor.black.cgColor
        
        houseNoTextFld.layer.borderWidth = 1
        houseNoTextFld.layer.cornerRadius = 1
        houseNoTextFld.layer.borderColor = UIColor.black.cgColor
        houseNoTextFld.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        myPickerView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissPicker() {
        buttonbg.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkBoxOutlet.layer.borderWidth = 1
        checkBoxOutlet.layer.borderColor = UIColor.black.cgColor
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            feedProgramDisplayLabel.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        }
        
        feedProgramTextLebl.text = NSLocalizedString(feedProgramText, comment: "")
        
        if lngId == 1{
            feedProgramTextLebl.text = feedProgramText
        } else if lngId == 3 {
            feedProgramTextLebl.text = "Programme alimentaire *"
        } else if lngId == 5 {
            feedProgramTextLebl.text = "Programa de alimentación *"
        }
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        spacingTextField()
        let nec =  UserDefaults.standard.bool(forKey: "nec")
        if nec == false
        {
            let neciIdStep = UserDefaults.standard.integer(forKey: "necId")
            self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1neccId(neciIdStep  as NSNumber) as! [NSManagedObject]
        }
        buttonDroper.frame = CGRect(x:0,y: 0,width: 1024,height: 768)
        buttonDroper.addTarget(self, action: #selector(captureNecropsyStep1Data.buttonPressedDroper), for: .touchUpInside)
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
        
        if self.captureNecropsy.isEmpty {
            count = 0
        }

        tableView.reloadData()
        
        let allBireType = CoreDataHandler().fetchBirdSize()
        if(birdArray.count == 0){
            for dict in allBireType {
                if (dict as AnyObject).value(forKey: "scaleType") as! String == "Imperial"{
                    birdArray.append(dict as! BirdSizePosting)
                }
                else{
                    metricArray.append(dict as! BirdSizePosting)
                }
            }
        }
    }
    func removeDuplicates(array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if let stringValue = value as? String, !encountered.contains(stringValue) {
                encountered.insert(stringValue)
                result.add(stringValue)
            }
        }
        

        return result
    }
    
    func removeDuplicatesOnArr(array: NSArray) -> NSArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("check duplicacy")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
       
        let arra = result.mutableCopy()  as! NSArray
        return arra
    }
    
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    // MARK: - IBACTION
    @IBAction func backButton(sender: AnyObject)
    {
        UserDefaults.standard.set(true, forKey: "backFromStep1")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func huseNoUpperBtnAction(sender: AnyObject) {
        self.view.endEditing(true)
        btnTag = 0
        myPickerView.frame = CGRect(x:628,y: 151,width: 100,height: 120)
        pickerView()
        
        if(lblHouse.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else{
            
            for i in 0..<HouseNo.count{
                if (lblHouse.text! == HouseNo[i] as! String){
                    pickerIndexIs = i
                    break
                }
            }
            myPickerView.selectRow(pickerIndexIs, inComponent: 0, animated: true)
        }
        myPickerView.reloadInputViews()
    }
    
    
    @IBAction func ageUperBtnaction(sender: AnyObject) {
        self.view.endEditing(true)
        btnTag = 1
        myPickerView.frame = CGRect(x:628,y: 240,width: 100,height: 120)
        pickerView()
        
        if(lblAge.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else{
            var setPickerIndex = Int()
            for i in 0..<AgeOp.count{
                if (lblAge.text! == AgeOp[i] as! String){
                    setPickerIndex = i
                    break
                }
            }
            myPickerView.selectRow(setPickerIndex, inComponent: 0, animated: true)
        }
        myPickerView.reloadInputViews()
        ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: .normal)
        
    }
    @IBAction func noOfUperBtnAction(sender: AnyObject) {
        
        self.view.endEditing(true)
        btnTag = 2
        myPickerView.frame = CGRect(x: 881,y: 237,width: 100,height: 120)
        pickerView()
        var birdsPickerIndex = Int()
        for i in 0..<NoOFbirds.count{
            
            if (lblNoBirds.text! == NoOFbirds[i] as! String){
                birdsPickerIndex = i
                break
            }
        }
        myPickerView.selectRow(birdsPickerIndex, inComponent: 0, animated: true)
        myPickerView.reloadInputViews()
    }
    
    @IBAction func feedProrgramAction(sender: AnyObject) {
        btnTag = 5
        do {
            
            farmNameTextField.resignFirstResponder()
            flockIdTextField.resignFirstResponder()
            feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
            
            if !UserDefaults.standard.bool(forKey: "Unlinked") {
                self.ncropsyId = UserDefaults.standard.integer(forKey: "postingId")
            }
           
            feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
            
            self.tableViewpop()
            droperTableView.frame = CGRect(x: 175,y: 320,width: 200,height: 100)
            droperTableView.reloadData()
            
            buttonDroper.alpha = 0
            autoSerchTable.alpha = 0
            
        } catch {
            
        }
    }
    
    fileprivate func unlinkedSessionValidations() {
        if (trimmedString == "" ||  lblAge.text == ""){
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMessage, comment: ""))
            
            if trimmedString == ""{
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
                
            } else {
                farmNameTextField.layer.borderColor = UIColor.black.cgColor
            }
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: .normal)
            
            if lblAge.text != ""  {
                ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: .normal)
            }
        } else {
            
            feedProgramDisplayLabel.text = ""
            self.insertdata()
        }
    }
    
    @IBAction func addMoreAction(sender: AnyObject) {
        
        trimmedString = farmNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            
            unlinkedSessionValidations()
        }
        else  if ( trimmedString == "" || feedProgramDisplayLabel.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||  lblAge.text == "" ){
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMessage, comment: ""))
            
            if trimmedString == ""{
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
                
            } else {
                farmNameTextField.layer.borderColor = UIColor.black.cgColor
            }
            feedProgramOutlet.layer.borderColor = UIColor.red.cgColor
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: .normal)
            if feedProgramDisplayLabel.text != NSLocalizedString(appDelegateObj.selectStr, comment: "")  {
                feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
            }
            if lblAge.text != ""  {
                ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: .normal)
            }
        } else {
            self.insertdata()
        }
        
        for i in 0..<NoOFbirds.count{
            if (lblNoBirds.text! == NoOFbirds[i] as! String){
                pickerIndexIs = i
                break
            }
        }
        myPickerView.selectRow(pickerIndexIs, inComponent: 0, animated: true)
        myPickerView.reloadInputViews()
    }
    
    @IBAction func checkBtnAction(sender: AnyObject) {
        
        if (sender.tag == 200)
        {
            checkBoxOutlet.isSelected = !checkBoxOutlet.isSelected
            if  checkBoxOutlet.isSelected {
                checkBoxOutlet.isSelected = true
                sender.setImage(UIImage(named: "Check_")!, for: .normal)
                asb = true
                
            } else {
                checkBoxOutlet.setImage(nil, for: .normal)
                checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
                asb = false
            }
        }else{
            
        }
    }
    
    @IBAction func uperViewTab(sender: AnyObject) {
        uprView.endEditing(true)
    }
    
    @IBAction func innerTabView(sender: AnyObject) {
        innerView.endEditing(true)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        droperTableView.removeFromSuperview()
    }
    
    @IBAction func nextBttnAction(sender: AnyObject) {
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            feedProgramDisplayLabel.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        }
        if farmNameTextField.text != "" || feedProgramDisplayLabel.text != NSLocalizedString(appDelegateObj.selectStr, comment: "") || lblAge.text != "" {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please add farm & bird details.", comment:""))
        }
        else if captureNecropsy.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please add farm & bird details.", comment:""))
        }
        else{
            
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "capture") as? CaptureNecropsyDataViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func tableViewpop()
    {
        buttonbg1.frame = CGRect(x:0,y: 0,width: 1024,height: 768)
        buttonbg1.addTarget(self, action:#selector(captureNecropsyStep1Data.buttonPreddDroper), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg1)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttonbg1.addSubview(droperTableView)
        
    }
    
    func pickerView (){
        
        buttonbg.frame = CGRect(x:0,y: 0,width: 1024,height: 768) // X, Y, width, height
        buttonbg.addTarget(self, action: #selector(captureNecropsyStep1Data.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        
        myPickerView.layer.borderWidth = 1
        myPickerView.layer.cornerRadius = 5
        myPickerView.layer.borderColor = UIColor.clear.cgColor
        myPickerView.dataSource = self
        myPickerView.delegate = self
        myPickerView.backgroundColor = UIColor.white
        buttonbg.addSubview(myPickerView)
    }
    
    @objc func buttonPressed1() {
        buttonbg.removeFromSuperview()
    }
    
    @objc func buttonPreddDroper() {
        buttonbg1.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var managedObjectContext = (UIApplication.shared.delegate
                                as! AppDelegate).managedObjectContext
    
    fileprivate func saveUnlinkedStep1Data() {
        CoreDataHandler().updateFinalizeDataWithNec( self.ncropsyId as NSNumber, finalizeNec: 1)
        self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1neccId(self.ncropsyId as NSNumber) as! [NSManagedObject]
        if self.captureNecropsy.count == 0 && UserDefaults.standard.bool(forKey: "Unlinked") {
            self.saveDataforposting()
        }
        saveStep1Data()
    }
    
    func insertdata()  {
        farmNameTextField.layer.borderColor = UIColor.black.cgColor
        
        countFarmId = UserDefaults.standard.integer(forKey: "farmId")
        countFarmId = countFarmId+1
        UserDefaults.standard.set(countFarmId, forKey: "farmId") // done this because in both if else case doing the same thing.

        CoreDataHandler().FarmsDataDatabase("", stateId: 0, farmName: trimmedString, farmId: 0, countryName: "", countryId: 0, city: "")
        
        let postingArr = CoreDataHandler().fetchAllPostingSessionWithNumber()
        let nec = UserDefaults.standard.bool(forKey:"nec")
        if nec == true {
            
            if postingArr.count == 0
            {
                CoreDataHandler().autoIncrementidtable()
                let autoD  = CoreDataHandler().fetchFromAutoIncrement()
                self.ncropsyId = autoD
                if nec == true {
                    self.saveDataforposting()
                }
                saveStep1Data()
            }
            else
            {
                if UserDefaults.standard.bool(forKey:"Unlinked") == true
                {
                    CoreDataHandler().autoIncrementidtable()
                    let autoD  = CoreDataHandler().fetchFromAutoIncrement()
                    self.ncropsyId = autoD
                    
                    if nec == true {
                        self.saveDataforposting()
                    }
                    saveStep1Data()
                }
                else{
                    self.ncropsyId = UserDefaults.standard.integer(forKey:"postingId")
                    saveStep1Data()
                    CoreDataHandler().updateFinalizeDataWithNec( self.ncropsyId as NSNumber, finalizeNec: 1)
                    CoreDataHandler().updateisSyncTrueOnPostingSession(self.ncropsyId as NSNumber)
                }
            }
        }
        else{
            saveUnlinkedStep1Data()
        }
    }
    
    func saveDataforposting(){
        let complexId = UserDefaults.standard.integer(forKey:"UnlinkComplex")
        let custMid = UserDefaults.standard.integer(forKey:"unCustId")
        self.timeStampString  = self.timeStamp()
        
        let postingData = chickenCoreDataHandlerModels.chickenPostingSessionData(
            antiboitic: "",
             birdBreesId: 0,
             birdbreedName: "",
             birdBreedType: "",
             birdSize: "",
             birdSizeId: 0,
             cocciProgramId: 0,
             cociiProgramName: "",
             complexId: complexId as NSNumber,
             complexName: lblComplex.text!,
             convential: "",
             customerId: custMid as NSNumber,
             customerName: "",
             customerRepId: 0,
             customerRepName: "",
             imperial: "",
             metric: "",
             notes: "",
             salesRepId: 0,
             salesRepName: "",
             sessiondate: strDateEn,
             sessionTypeId: 0,
             sessionTypeName: "",
             vetanatrionName: "",
             veterinarianId: 0,
             loginSessionId: 1,
             postingId: self.ncropsyId as NSNumber,
             mail: "",
             female: "",
             finilize: 0,
             isSync: true,
             timeStamp: timeStampString,
             lngId: lngId as NSNumber,
             productionTypName: "",
             productionTypId: 0,
             avgAge: "",
             avgWeight: "",
             outTime: "",
             FCR: "",
             Livability: "",
             mortality: ""
        )

        CoreDataHandler().PostingSessionDb(postingData)
        
        
        
        let _ = CoreDataHandler().fetchAllPostingSession(self.ncropsyId as NSNumber)
        
        CoreDataHandler().updateFinalizeDataWithNec(self.ncropsyId as NSNumber, finalizeNec: 2)
    }
    
    func saveStep1Data(){
        UserDefaults.standard.set(self.ncropsyId, forKey: "necId")
        UserDefaults.standard.set(self.ncropsyId, forKey: "postingId")
        UserDefaults.standard.synchronize()
        let neciIdStep = UserDefaults.standard.integer(forKey:"necId")
        let complexId = UserDefaults.standard.integer(forKey:"UnlinkComplex")
        let custMid = UserDefaults.standard.integer(forKey:"unCustId")
        let _ = CoreDataHandler().FetchNecropsystep1NecId(neciIdStep as NSNumber)
        count =  UserDefaults.standard.integer(forKey: "count")
        count = count+1
        
        var  imageAutoIncrementId = UserDefaults.standard.integer(forKey: "imageAutoIncrementId")
        imageAutoIncrementId = imageAutoIncrementId + 1
      
        
        UserDefaults.standard.set(imageAutoIncrementId, forKey: "imageAutoIncrementId")
        UserDefaults.standard.set(count, forKey: "count")
        UserDefaults.standard.synchronize()
        
        let appendfeedProgramwithCount = String(format:"%d. %@",count,trimmedString )
        let _ = self.timeStamp()
        
        //Raman's code
        if UserDefaults.standard.bool(forKey:"Unlinked") == true
        {
            
            let necropsyData = chickenCoreDataHandlerModels.saveNecropsyStep1Data(
                postingId: neciIdStep as NSNumber,
                   age: self.lblAge.text!,
                   farmName: appendfeedProgramwithCount,
                   feedProgram: feedProgramDisplayLabel.text!,
                   flockId: flockIdTextField.text!,
                   houseNo: houseNoTextFld.text!,
                   noOfBirds: lblNoBirds.text!,
                   sick: asb as NSNumber,
                   necId: neciIdStep as NSNumber,
                   compexName: lblComplex.text!,
                   complexDate: strDateEn,
                   complexId: complexId as NSNumber,
                   custmerId: custMid as NSNumber,
                   feedId: feedId as NSNumber,
                   isSync: true,
                   timeStamp: timeStampString,
                   actualTimeStamp: timeStampString,
                   lngId: lngId as NSNumber,
                   farmId: countFarmId as NSNumber,
                   imageId: NSNumber(value: imageAutoIncrementId),
                   count: count as NSNumber
            )

            CoreDataHandler().SaveNecropsystep1(data: necropsyData)
            
        }
        else {
            let necropsyData = chickenCoreDataHandlerModels.saveNecropsyStep1Data(
                postingId: neciIdStep as NSNumber,
                    age: self.lblAge.text!,
                    farmName: appendfeedProgramwithCount,
                    feedProgram: feedProgramDisplayLabel.text!,
                    flockId: flockIdTextField.text!,
                    houseNo: houseNoTextFld.text!,
                    noOfBirds: lblNoBirds.text!,
                    sick: asb as NSNumber,
                    necId: neciIdStep as NSNumber,
                    compexName: lblComplex.text!,
                    complexDate: strDateEn,
                    complexId: complexId as NSNumber,
                    custmerId: custmerIdFarm as NSNumber,
                    feedId: feedId as NSNumber,
                    isSync: true,
                    timeStamp: timeStampString,
                    actualTimeStamp: timeStampString,
                    lngId: lngId as NSNumber,
                    farmId: countFarmId as NSNumber,
                    imageId: NSNumber(value: imageAutoIncrementId),
                    count: count as NSNumber
            )

            CoreDataHandler().SaveNecropsystep1(data: necropsyData)
            
        }
        
        UserDefaults.standard.set(false, forKey: "nec")
        UserDefaults.standard.synchronize()
        
        if !UserDefaults.standard.bool(forKey: "Unlinked") {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
        
        UserDefaults.standard.set(timeStampString, forKey: "timestamp")
        UserDefaults.standard.synchronize()
        CoreDataHandler().updateFinalizeDataActualNec(ncropsyId as NSNumber, deviceToken: actualTimestamp)
        lblAge.text = ""
        farmNameTextField.text = ""
        if UserDefaults.standard.bool(forKey:"Unlinked") == true{
            feedProgramDisplayLabel.text = ""
        }
        else{
            self.feedProgramDisplayLabel.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        }
        
        flockIdTextField.text = ""
        houseNoTextFld.text = "1"
        lblNoBirds.text = "5"
        checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        asb = false
        
        self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1neccId(neciIdStep as NSNumber) as! [NSManagedObject]
        tableView.reloadData()
        
    }
    
    /******** Genrate Time Stamp *********************/
    
    func timeStamp() -> String{
        if UserDefaults.standard.bool(forKey:"Unlinked") == true
        {
            
            let nectimeStamp = UserDefaults.standard.bool(forKey:"timeStampTrue")
            if nectimeStamp == true{
                if (UserDefaults.standard.value(forKey: "timeStamp") as? String) != nil{
                    timeStampString = UserDefaults.standard.value(forKey: "timeStamp") as! String
                }
                else{
                    let postingArr = CoreDataHandler().fetchAllPostingSession(postingId as NSNumber)
                    timeStampString = (postingArr.object(at:0) as AnyObject).value( forKey:  "timeStamp") as! String
                }
                
                UserDefaults.standard.set(false, forKey: "timeStampTrue")
                UserDefaults.standard.synchronize()
            }
            else{
                timeStampString = UserDefaults.standard.value(forKey: "timeStamp") as! String
            }
            
            timeStampString = timeStampString.replacingOccurrences(of: "/", with: "", options: .regularExpression)
            timeStampString = timeStampString.replacingOccurrences(of: ":", with: "", options: .regularExpression)
            
            let string = timeStampString
            let character: Character = "i"
            
            if (string.contains(character)) {
                debugPrint("no time stamp updated or added")
            } else {
                let  udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")! as! String
                let sessionGUID1 =   timeStampString + "_" + String(describing: self.ncropsyId as NSNumber)
                timeStampString = sessionGUID1 + "_" + "iOS" + "_" + String(udid)
            }
        }
        else{
            let postinSeesion =  CoreDataHandler().fetchAllPostingSession(self.postingId  as NSNumber) as NSArray
            self.timeStampString = (postinSeesion.object(at: 0) as AnyObject).value(forKey: "timeStamp") as! String
        }
        return timeStampString
    }
    
    fileprivate func deleteNotesImageNecropsyData(necropsyId: NSNumber, farmWithoutAge: String) {
        deleteStep2DataCapture(necropsyId: necropsyId, farmWithoutAge: farmWithoutAge) { success in
            guard success else { return }
            self.deleteNotes(necropsyId: necropsyId, farmWithoutAge: farmWithoutAge)
        }
    }

    private func deleteNotes(necropsyId: NSNumber, farmWithoutAge: String) {
        deleteStep2NotesBird(necropsyId: necropsyId, farmWithoutAge: farmWithoutAge) { success in
            guard success else { return }
            self.deleteImages(necropsyId: necropsyId, farmWithoutAge: farmWithoutAge)
        }
    }

    private func deleteImages(necropsyId: NSNumber, farmWithoutAge: String) {
        deleteStep2CameraImage(necropsyId: necropsyId, farmWithoutAge: farmWithoutAge) { success in
            guard success else { return }
            self.handleSessionDeletion(for: necropsyId)
        }
    }

    

    private func deleteStep2DataCapture(necropsyId: NSNumber, farmWithoutAge: String, completion: @escaping (Bool) -> Void) {
        CoreDataHandler().deleteDataWithPostingIdStep2dataCaptureNecViewWithfarmName(necropsyId, farmName: farmWithoutAge) { success in
            completion(success)
        }
    }

    private func deleteStep2NotesBird(necropsyId: NSNumber, farmWithoutAge: String, completion: @escaping (Bool) -> Void) {
        CoreDataHandler().deleteDataWithPostingIdStep2NotesBirdWithFarmName(necropsyId, farmName: farmWithoutAge) { success in
            completion(success)
        }
    }

    private func deleteStep2CameraImage(necropsyId: NSNumber, farmWithoutAge: String, completion: @escaping (Bool) -> Void) {
        CoreDataHandler().deleteDataWithPostingIdStep2CameraIamgeWithFarmName(necropsyId, farmName: farmWithoutAge) { success in
            completion(success)
        }
    }
    
    func handleSessionDeletion(for necropsyId: NSNumber) {
        self.deleteSessionWithPostingId(necropsyId: necropsyId)
    }
    
    
    @objc func ClickDeleteBtton(_ sender: UIButton){
        let person = captureNecropsy[sender.tag]
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as? captureTableViewCell
        cell?.backgroundColor = UIColor.gray
        let farmArrayWithoutAge = (person.value(forKey: "farmName") as? String)!
        let necId = (person.value(forKey: "necropsyId") as? Int)!
        
        let dataArr =  CoreDataHandler().fecthFrmWithCatnameWithBirdAndObservationWithDelete(farmname: farmArrayWithoutAge, necId: necId as NSNumber)
        if dataArr.count > 0{
            for i in 0..<dataArr.count{
                
                let obspoint = (dataArr.object(at: i) as AnyObject).value(forKey: "obsPoint") as! Int
                let obsVal = (dataArr.object(at: i) as AnyObject).value(forKey: "objsVisibilty") as! Int
                
                if obspoint > 0 || obsVal > 0{
                    strMsgforDelete = NSLocalizedString("Are you sure you want to delete this farm? You have observation recorded for this farm.", comment: "")
                    
                    break
                }
                else {
                    strMsgforDelete = NSLocalizedString("Are you sure you want to delete this farm?", comment: "")
                }
            }
        }
        else{
            strMsgforDelete = NSLocalizedString("Are you sure you want to delete this farm?", comment: "")
        }
        
        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString(strMsgforDelete, comment: ""), preferredStyle: .alert)
        let action1 = UIAlertAction(title:NSLocalizedString("Yes", comment: ""), style: .default) { (action) in
            CoreDataHandler().deleteDataWithPostingIdStep1dataWithfarmName(necId as NSNumber, farmName: farmArrayWithoutAge, { (success) in
                if success == true{
                    self.deleteNotesImageNecropsyData(necropsyId: necId as NSNumber, farmWithoutAge: farmArrayWithoutAge)
                }
            })
        }
        let action2 = UIAlertAction(title:NSLocalizedString(Constants.noStr, comment: "") , style: .cancel) { (action) in
            cell?.backgroundColor = UIColor.clear
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    fileprivate func deleteSessionWithPostingId(necropsyId:NSNumber) {
        
        self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1neccId(necropsyId as NSNumber) as! [NSManagedObject]
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            if  self.captureNecropsy.count == 0{
                CoreDataHandler().deleteDataWithPostingId(necropsyId as NSNumber)
            }
        }
        else if self.captureNecropsy.count == 0{
            CoreDataHandler().updateFinalizeDataWithNec(necropsyId as NSNumber, finalizeNec: 0)
        }
        
        self.appDelegate.saveContext()
        self.tableView.reloadData()
    }
    
    
    
    @objc func ClickEditBtton(_ sender: UIButton){
        
        print("edit button clicked")
        let person = captureNecropsy[sender.tag]
        
        buttonEdit.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonEdit.frame = CGRect(x: 0, y:1500, width: 1024, height: 768)
        buttonEdit.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        buttonEdit.addTarget(self, action: #selector( PostingSessionDetailController.buttonPressed), for: .touchUpInside)
        editView.backgroundColor = UIColor.white
        editView.layer.cornerRadius = 25
        editView.layer.masksToBounds = true
        titleView.backgroundColor = UIColor(red: 11/255, green:88/255, blue:160/255, alpha:1.0)
        
        titleLabel.text = NSLocalizedString("Update Farm", comment: "")
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = UIColor.white
        nameLabel.text = NSLocalizedString("Farm Name * : ", comment: "")
        ageLabel.text = NSLocalizedString("Age * :", comment: "")
        feedLabel.text = NSLocalizedString("Feed Program * :", comment: "")
        houseLabel.text = NSLocalizedString("House No. : ", comment: "")
        nameText.layer.borderColor =  UIColor.gray.cgColor
        nameText.delegate = self
        nameText.layer.borderWidth = 1
        nameText.leftView = paddingView
        nameText.leftViewMode = UITextField.ViewMode.always
        
        targetWeight.layer.borderColor =  UIColor.red.cgColor
        targetWeight.delegate = self
        targetWeight.layer.borderWidth = 1
        targetWeight.leftView = paddingView1
        targetWeight.leftViewMode = UITextField.ViewMode.always
        
        strFarmNameFeedId = (person.value(forKey: "feedProgram") as? String)!
        strfarmName = (person.value(forKey: "farmName") as? String)!
        strFeedId = (person.value(forKey: "necropsyId") as? Int)!
        strFeddUpdate = (person.value(forKey: "feedProgram") as? String)!
        houseNoTxtFld.text = (person.value(forKey: "houseNo") as? String)!
        
        feeId = (person.value(forKey: "feedId") as? Int)!
        postingId = (person.value(forKey: "postingId") as? Int)!
        
        strfarmNameArray = strfarmName.components(separatedBy: ". ") as NSArray
        let farmName = strfarmNameArray[1]
        
        nameText.text = farmName as? String
        nameText.layer.cornerRadius = 5.0
        nameText.layer.borderWidth = 1
        nameText.returnKeyType = UIReturnKeyType.done
        
        houseNoTxtFld.layer.cornerRadius = 5.0
        houseNoTxtFld.layer.borderWidth = 1
        houseNoTxtFld.returnKeyType = UIReturnKeyType.done
        
        houseNoTxtFld.layer.borderColor =  UIColor.gray.cgColor
        houseNoTxtFld.delegate = self
        houseNoTxtFld.leftView = paddingViewHouse
        houseNoTxtFld.leftViewMode = UITextField.ViewMode.always
        
        houseNoTxtFld.tag = 40
        
        targetWeight.text = UserDefaults.standard.value(forKey: "targetWeight") as? String
        targetWeight.layer.cornerRadius = 5.0
        targetWeight.layer.borderWidth = 1
        targetWeight.returnKeyType = UIReturnKeyType.done
        
        oldFarmName = strfarmName as NSString
        ageButton.layer.borderColor =  UIColor.gray.cgColor
        ageButton.layer.cornerRadius = 5.0
        ageButton.layer.borderWidth = 1
        ageButton.setTitleColor(UIColor.black, for: .normal)
        ageButton.contentVerticalAlignment = .center
        ageButton.titleEdgeInsets = UIEdgeInsets.init(top: 5.0, left: 10.0, bottom: 0.0, right: 0.0)
        ageButton.setTitle("\((person.value(forKey: "age") as? String)!)", for: .normal)
        ageButton.addTarget(self, action: #selector( captureNecropsyStep1Data.updateAge), for: .touchUpInside)
        ageButton.setBackgroundImage(UIImage(named:"dialer01"), for: .normal)
        ageButton.contentHorizontalAlignment = .left
        feedButton.layer.cornerRadius = 5.0
        feedButton.layer.borderWidth = 1
        feedButton.contentHorizontalAlignment = .left
        feedButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0);
        feedButton.setTitle(strFarmNameFeedId, for: .normal)
        if let value = feedButton.titleLabel?.text{
            strFeddCheck = value
        }
        feedButton.setTitleColor(UIColor.black, for: .normal)
        feedButton.layer.borderColor =  UIColor.gray.cgColor
        feedButton.addTarget(self, action: #selector( captureNecropsyStep1Data.feedPressed), for: .touchUpInside)
        let  btnView = UIView()
        let  btnView1 = UIView()
        
        btnView.frame =   CGRect(x: 20, y:260, width: 460, height: 0.5)
        btnView.backgroundColor = UIColor.gray
        btnView1.frame =  CGRect(x: 250, y:268, width: 1, height:50)
        btnView1.backgroundColor = UIColor.gray
        editView.addSubview(btnView)
        editView.addSubview(btnView1)
        submitButton.backgroundColor = UIColor.clear
        submitButton.tintColor = UIColor.white
        submitButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        submitButton.titleLabel!.font =  UIFont(name: "Arial", size: 20)
        submitButton.setTitleColor(UIColor(red: 0/255, green:122/255, blue:228/255, alpha:1.0), for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector( captureNecropsyStep1Data.updatePressed), for: .touchUpInside)
        
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.tintColor = UIColor.white
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel!.font =  UIFont(name: "Arial", size: 20)
        cancelButton.setTitleColor(UIColor(red: 0/255, green:122/255, blue:228/255, alpha:1.0), for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector( captureNecropsyStep1Data.buttonPressed), for: .touchUpInside)
        editView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        editView.addSubview(nameLabel)
        editView.addSubview(ageLabel)
        editView.addSubview(feedLabel)
        editView.addSubview(nameText)
        editView.addSubview(ageButton)
        editView.addSubview(submitButton)
        editView.addSubview(cancelButton)
        editView.addSubview(feedButton)
        editView.addSubview(houseLabel)
        editView.addSubview(houseNoTxtFld)
        buttonEdit.addSubview(editView)
        self.view.addSubview(buttonEdit)
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonEdit.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        })
    }
    
    @objc func updateAge(){
        showAgesList()
        
    }
    
    func showAgesList(){
        btnTag = 1
        self.myPickerView.frame = CGRect(x:420,y: 363,width: 100,height: 120)
        pickerView()
        editfeed = "yes"
        if(ageButton.titleLabel?.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else {
            
            var agePickerIndex = Int()
            for i in 0..<AgeOp.count{
                if (ageButton.titleLabel?.text! == AgeOp[i] as? String){
                    agePickerIndex = i
                    break
                }
            }
            myPickerView.selectRow(agePickerIndex, inComponent: 0, animated: true)
            
        }
        myPickerView.reloadInputViews()
    }
    
    @objc func  buttonPressedPopAction() {
        buttonbg1.removeFromSuperview()
    }
    
    @objc func feedPressed(){
        
        btnTag = 5
        do {
            feeId = 0
            strFeddUpdate = ""
            farmNameTextField.resignFirstResponder()
            flockIdTextField.resignFirstResponder()
            feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
            if !UserDefaults.standard.bool(forKey: "Unlinked")
            {
                        self.ncropsyId = UserDefaults.standard.integer(forKey: "postingId")
            }

            feedProgramArray = CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
            editfeed = "yes"
            self.tableViewpop()
            droperTableView.frame = CGRect( x: 441, y: 455, width: 250, height: 90)
            droperTableView.reloadData()
            
            
        } catch {
            
        }
        
    }
    
    @objc func buttonPressed() {
        feedButton.titleLabel?.text = ""
        strFeddUpdate = ""
        strFarmNameFeedId = ""
        strFeddCheck = ""
        
        UIView.animate(withDuration:0.5, animations: {
            self.buttonEdit.frame = CGRect(x: 0, y: 768, width: 1024, height: 768)
        })
        DispatchQueue.main.async {
            sleep(1)
            self.buttonbgNew2.removeFromSuperview()
            self.buttonEdit.removeFromSuperview()
        }
    }
    
    // MARK: - METHODS AND FUNCTIONS
    @objc func updatePressed(){
        
        Constants.isFromPsoting = true
        UserDefaults.standard.set(false, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        var trimmedFarmString = nameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedFarmString = trimmedFarmString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        
        if houseNoTxtFld.text == ""
        {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMessage, comment: ""))
            houseNoTxtFld.layer.borderColor = UIColor.red.cgColor
            return
            
        }
        
        if strFeddCheck == "" && strFeddUpdate == "" && trimmedFarmString == "" {
            
            feedButton.layer.borderColor = UIColor.red.cgColor
            nameText.layer.borderColor = UIColor.red.cgColor
        }
        if strFarmNameFeedId == "" && strFeddUpdate == "" {
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(mendatoryFieldsMessage, comment: ""))
        }
        if strFeddCheck == "" && strFeddUpdate == "" && strFarmNameFeedId == ""{
            
            if trimmedFarmString == "" {
                nameText.layer.borderColor = UIColor.red.cgColor
            }
            else {
                nameText.layer.borderColor = UIColor.black.cgColor
            }
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMessage, comment: ""))
        }
        
        else {
            
            if trimmedFarmString == "" {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldsMessage, comment: ""))
                nameText.layer.borderColor = UIColor.red.cgColor
                feedButton.layer.borderColor = UIColor.black.cgColor
            }
            else{
                
                let str = strfarmNameArray[0] as! String
                let strNewFarm = str+". "+trimmedFarmString
                if strFeddUpdate == ""{
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId as NSNumber, feedname: strFeddCheck, feedId: feeId as NSNumber , formName: strfarmName)
                }
                else if strFarmNameFeedId == ""{
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId as NSNumber, feedname: strFeddUpdate, feedId: feeId as NSNumber , formName: strfarmName)
                }
                else {
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId as NSNumber, feedname: strFeddUpdate, feedId: feeId as NSNumber , formName: strfarmName)
                }
                
                CoreDataHandler().updateNecropsystep1WithNecIdAndFarmName(postingId as NSNumber, farmName: oldFarmName as NSString, newFarmName: strNewFarm as NSString  , age: (ageButton.titleLabel?.text!)!, newHouseNo: houseNoTxtFld.text! as NSString , isSync: true)
                
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewData(postingId as NSNumber, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdNotes(postingId as NSNumber, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdPhoto(postingId as NSNumber, oldFarmName: oldFarmName as String, newFarmName: strNewFarm)
                CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
                self.tableView.reloadData()
                self.buttonbgNew2.removeFromSuperview()
                self.buttonEdit.removeFromSuperview()
            }
            
        }
        
    }
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == droperTableView {
            
            if btnTag == 5 {
                return feedProgramArray.count
            } else if btnTag == 6 {
                
                if targetWeigh == 0 {
                    return metricArray.count
                }
                else if targetWeigh == 1{
                    return birdArray.count
                }
            }
        }
        else if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        else{
            return captureNecropsy.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == droperTableView {
            return getDropperTableViewCell(indexPath: indexPath)
        }
        else if tableView == autoSerchTable {
            
            do {
                let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                if indexPath.row < autocompleteUrls.count, let value = autocompleteUrls.object(at: indexPath.row) as? String {
                    cell.textLabel?.text = value
                }
                return cell
            }
        }
        
        else{
            
            let Cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! captureTableViewCell
            let person = captureNecropsy[indexPath.row]
            var farmName = person.value(forKey: "farmName") as? String
            let age = person.value(forKey: "age") as! String
            farmName = farmName! + " " + "[" + age + "]"
            
            var farmName2 = String()
            let range = farmName?.range(of: ".")
            if range != nil{
                let abc = String(farmName![range!.upperBound...]) as NSString
                farmName2 = String(indexPath.row+1) + "." + " " + String(describing:abc)
            }
            
            Cell.farmLabel.text = farmName2
            Cell.backgroundColor = UIColor.clear
            Cell.feedProgramLabel.text = person.value(forKey: "feedProgram") as? String
            Cell.flockIdLabel.text = person.value(forKey: "flockId") as? String
            Cell.houseNo.text = person.value(forKey: "houseNo") as? String
            let noofBirds = Int((person.value(forKey: "noOfBirds") as? String)!)
            Cell.deleteButton.tag = indexPath.row
            Cell.deleteButton.addTarget(self, action: #selector(captureNecropsyStep1Data.ClickDeleteBtton(_:)), for: .touchUpInside)
            Cell.editBtn.tag = indexPath.row
            Cell.editBtn.addTarget(self, action: #selector(captureNecropsyStep1Data.ClickEditBtton(_:)), for: .touchUpInside)
            
            
            if (noofBirds == 11){
                let val = 10
                Cell.noOfBirdsLabel.text = String(val)
            } else {
                Cell.noOfBirdsLabel.text = person.value(forKey: "noOfBirds") as? String
            }
            let checkVal  = person.value(forKey: "sick") as! Int
            if checkVal == 0 {
                Cell.sickLabel.text = NSLocalizedString(Constants.noStr, comment: "")
            } else {
                Cell.sickLabel.text = NSLocalizedString("Yes", comment: "")
            }
            return Cell
        }
    }
    
    
    // MARK: - Helper Functions

    private func getDropperTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch btnTag {
        case 5:
            if let vet = feedProgramArray.object(at: indexPath.row) as? FeedProgram {
                cell.textLabel?.text = vet.feddProgramNam
            }
        case 6:
            let birdSize = targetWeigh == 0 ? metricArray[indexPath.row].birdSize : birdArray[indexPath.row].birdSize
            if let value = birdSize {
                cell.textLabel?.text = value
            }
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == droperTableView {
            
            if btnTag == 5 {
                
                let str = feedProgramArray[indexPath.row] as! FeedProgram
                feedProgramDisplayLabel.text = str.feddProgramNam
                feedId =  str.feedId as! Int
                buttonPreddDroper()
                
                if editfeed == "yes"
                {
                    CoreDataHandler().updatedPostigSessionwithIsFarmSyncPostingId(self.postingId as NSNumber, isFarmSync: false)
                    feedButton.setTitle(str.feddProgramNam!, for: .normal)
                    feedProgramDisplayLabel.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
                    feeId = Int(truncating: str.feedId!)
                    strFeddUpdate = str.feddProgramNam ?? ""
                }
            }
            else if btnTag == 6{
                
                if targetWeigh == 0 {
                    let objMedtricarray = metricArray[indexPath.row]
                    targetWeightLbl.text = objMedtricarray.birdSize
                    
                } else {
                    let objstr = birdArray[indexPath.row]
                    targetWeightLbl.text = objstr.birdSize
                }
                buttonPreddDroper()
            }
        }
        else if tableView == autoSerchTable {
            
            farmNameTextField.text = autocompleteUrls.object(at:indexPath.row) as? String
            autoSerchTable.alpha = 0
            farmNameTextField.endEditing(true)
            buttonDroper.alpha = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            debugPrint("too much backspace entered.")
        }
        else if ((textField.text?.count)! > 49  ){
            return false
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101){
            
         
            let bPredicate: NSPredicate = NSPredicate(format: "farmName contains[cd] %@", newString)
            let complexId = UserDefaults.standard.integer(forKey:"UnlinkComplex")
            
            fetchcomplexArray = CoreDataHandler().fetchFarmsDataDatabaseUsingCompexId(complexId: complexId as NSNumber).filtered(using: bPredicate) as NSArray
            
            autocompleteUrls1 = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autocompleteUrls.removeAllObjects()
            autocompleteUrls2.removeAllObjects()
            
            for i in 0..<autocompleteUrls1.count
            {
                let f = autocompleteUrls1.object(at:i) as! FarmsList
                let  farmName = f.farmName
                autocompleteUrls2.add(farmName!)
            }
            
            autocompleteUrls =   self.removeDuplicates(array: autocompleteUrls2)
            autoSerchTable.frame = CGRect(x:175,y: 240,width: 200,height: 200)
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
        
        else{
            let aSet = NSCharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£").inverted
            switch textField.tag { 
                
            case 18 , 11 , 40 :
              
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                
                let maxLength = 6
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
                return string == numberFiltered && newString.length <= maxLength
                
                
            case 1 : break
                
            default : break
            }
        }
        return true
    }
    
    // MARK: - Picker View Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if btnTag == 0{
            return HouseNo.count
        } else if btnTag == 1{
            return AgeOp.count
        }else {
            return NoOFbirds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      
        
        if btnTag == 0{
            if let value = HouseNo[row] as? String {
                return value
            } else {
                return nil
            }
        }
        else if btnTag == 1{
            myPickerView.showsSelectionIndicator = false
            if let value = AgeOp[row] as? String{
                return value
            } else {
                return nil
            }
        }
        else {
            myPickerView.showsSelectionIndicator = false
            if let value = NoOFbirds[row] as? String{
                return value
            } else {
                return nil
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if btnTag == 0{
           
            if let value = HouseNo[row] as? String {
                return lblHouse.text = value
            } else {
                return lblHouse.text = ""
            }
            
        }
        else if btnTag == 1 {
        
            if editfeed == "yes"
            {
                if let value = AgeOp[row] as? String {
                    editfeed = Constants.noStr
                    return ageButton.setTitle("\(value)", for: .normal)
                    
                    
                } else {
                    return lblAge.text = ""
                }
                
            }
            else
            {
                if let value = AgeOp[row] as? String {
                    return lblAge.text = value
                } else {
                    return lblAge.text = ""
                }
            }
            
        }
        else{
            if let value = NoOFbirds[row] as? String {
                return lblNoBirds.text = value
            } else {
                return lblNoBirds.text = ""
            }
        }
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Dropper.sharedInstance.hideWithAnimation(0.1)
        
        if (textField == farmNameTextField ) {
            farmNameTextField.returnKeyType = UIReturnKeyType.done
        } else {
            flockIdTextField.returnKeyType = UIReturnKeyType.done
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == farmNameTextField ) {
            
            if farmNameTextField.text?.isEmpty == true{
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                farmNameTextField.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        
        if trimmedString == ""{
            farmNameTextField.layer.borderColor = UIColor.red.cgColor
            
        } else {
            farmNameTextField.layer.borderColor = UIColor.black.cgColor
        }
        if farmNameTextField.text?.isEmpty == true{
            farmNameTextField.layer.borderColor = UIColor.red.cgColor
        }
        else {
            farmNameTextField.layer.borderColor = UIColor.black.cgColor
        }
        
        return true
    }
    
    var index = 10
    
    // MARK: - Add Padding sapce to textfield
    func spacingTextField() {
          // Create an array of all the text fields
          let textFields: [UITextField] = [
            farmNameTextField, flockIdTextField, houseNoTextFld
          ]
          
          // Loop through each text field and apply the padding
          for textField in textFields {
              let paddedView = UIView(frame: CGRect(x: 15, y: 0, width: 10, height: 20))
              textField.leftView = paddedView
              textField.leftViewMode = .always
          }
      }
    
    
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at:j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at:w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        let allPostingSessionArr = NSMutableArray()
      
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at:i) as! PostingSession
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at:i) as! CaptureNecropsyData
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    @IBAction func targetWeightBtnAction(_ sender: UIButton) {
        view.endEditing(true)
        btnTag = 6
        if targetWeigh == 0 || targetWeigh == 1 {
            
            tableViewpop()
            droperTableView.frame = CGRect( x: 162, y: 385, width: 200, height: 200)
            droperTableView.reloadData()
            
        }
    }
}


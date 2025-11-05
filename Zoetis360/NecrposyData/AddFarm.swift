//  AddFarm.swift
//  Zoetis -Feathers
//  Created by "" on 09/11/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit
import MBProgressHUD
protocol AddFarmPop: class {
    func anv ()
}
protocol refreshPageafterAddFeed{
    func refreshPageafterAddFeed(_ formName: String)
}

class AddFarm:UIView,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    // MARK: - VARIABLES
    var hud : MBProgressHUD = MBProgressHUD()
    var AddFarmDelegate :AddFarmPop!
    var asb = Bool()
    var delegeterefreshPage : refreshPageafterAddFeed!
    var postingIdFromExistingNavigate = String()
    var postingIdFromExisting = Int()
    var trimmedString = String()
    var countFarmId = Int()
    var timeStamp1 = String()
    var HouseNo = NSArray ()
    var AgeOp = NSArray ()
    var NoOFbirds = NSArray ()
    var btnTag = Int()
    let buttonbg = UIButton ()
    var myPickerView = UIPickerView()
    var pickerIndex = Int()
    var backroundPop = UIButton()
    var postingId = Int()
    var feedId = Int()
    var feedProgramArray = NSArray ()
    var count = Int()
    var necIdExist = Int()
    var necIdExIsting = String()
    let buttonbg1 = UIButton ()
    var lngId = NSInteger()
    var droperTableView  =  UITableView ()
    
    var complexTypeFetchArray = NSMutableArray()
    var complexTypeFetchArray1 = NSMutableArray()
    var autoSerchTable = UITableView ()
    var autocompleteUrls = NSMutableArray ()
    var autocompleteUrls1 = NSMutableArray ()
    var autocompleteUrls2 = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    var fetchcomplexArray1 = NSArray ()
    var buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    let cellReuseIdentifier = "cell"
    let complexDate =  UserDefaults.standard.value(forKey: "date") as? String
    let complexName = UserDefaults.standard.value(forKey: "complex") as? String
    
    // MARK: - OUTLET
    @IBOutlet weak var farmNameTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var feedProgramLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var houseNoLbl: UILabel!
    @IBOutlet weak var flockIdTextField: UITextField!
    @IBOutlet weak var noOfBirdsLbl: UILabel!
    @IBOutlet weak var sickBtnOutlet: UIButton!
    @IBOutlet weak var feedProgramDisplayLabel: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var feedProgramOutlet: UIButton!
    @IBOutlet weak var ageUperBtnOutlet1: UIButton!
    
    @IBOutlet weak var newAddFarm: UILabel!
    @IBOutlet weak var newFarm: UILabel!
    @IBOutlet weak var newHouse: UILabel!
    @IBOutlet weak var newFlock: UILabel!
    @IBOutlet weak var newAge: UILabel!
    @IBOutlet weak var newNoOfBirds: UILabel!
    @IBOutlet weak var newDne: UIButton!
    @IBOutlet weak var newSick: UILabel!
    @IBOutlet weak var feedDisplyLbl: UILabel!
    @IBOutlet weak var feedProgramdropDwnIcon: UIImageView!
    
    @IBOutlet weak var houseNoTextFld: UITextField!
    
    
    /********************************/
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AddFarm", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    // MARK: 🟠 Sick Button ACTION
    @IBAction func sickBtnAction(_ sender: AnyObject) {
        self.endEditing(true)
        
        if (sender.tag == 200)
        {
            sickBtnOutlet.isSelected = !sickBtnOutlet.isSelected
            if  sickBtnOutlet.isSelected {
                sickBtnOutlet.isSelected = true
                sender.setImage(UIImage(named: "Check_")!, for: UIControl.State())
                asb = true
                
            } else {
                sickBtnOutlet.setImage(nil, for: UIControl.State())
                sickBtnOutlet.setImage(UIImage(named: "Uncheck_")!, for: UIControl.State())
                asb = false
            }
        }else{
            print(appDelegateObj.testFuntion())
        }
    }
    // MARK: 🟠 Show Custome Alert
    func showAlertIfNeeded(message: String) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            let title = NSLocalizedString(Constants.alertStr, comment: "")
            
            Helper.showAlertMessage(rootViewController, titleStr: title, messageStr: message)
        }
    }
    
    
    // MARK: 🟠 Done Button ACTION
    fileprivate func unlinkedSessionRequiredFieldvalidation() {
        if (trimmedString == "" ||  lblAge.text == "" ){
            
            showAlertIfNeeded(message: NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
            
            if trimmedString == ""{
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
                farmNameTextField.text = ""
            }
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: UIControl.State())
            if lblAge.text != ""  {
                ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
            }
        }
        else {
            feedProgramDisplayLabel.text = ""
            self.hudAnimated1()
            self.insertData({ (status) in
                if status == true
                {
                    self.hud.hide(animated: true)
                }
            })
        }
    }
    
    @IBAction func doneBtnAction(_ sender: AnyObject) {
        Constants.isFromPsoting = true
        UserDefaults.standard.set(true, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        trimmedString = farmNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            Constants.isForUnlinkedChicken = true
            
            unlinkedSessionRequiredFieldvalidation()
        }
        else if (trimmedString == "" || feedProgramDisplayLabel.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||  lblAge.text == "" ||  houseNoTextFld.text == "" )  {
            
            showAlertIfNeeded(message: NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
            feedProgramOutlet.layer.borderColor = UIColor.red.cgColor
            
            if trimmedString == ""{
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
                farmNameTextField.text = ""
            }
            if houseNoTextFld.text == "" {
                houseNoTextFld.layer.borderColor = UIColor.red.cgColor
                houseNoTextFld.text = ""
            } else {
                houseNoTextFld.layer.borderColor = UIColor.black.cgColor
            }
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: UIControl.State())
            
            if feedProgramDisplayLabel.text != NSLocalizedString(appDelegateObj.selectStr, comment: "")  {
                feedProgramOutlet.layer.borderColor = UIColor.gray.cgColor
            }
            if lblAge.text != ""  {
                ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
            }
        } else {
            self.hudAnimated1()
            self.insertData({ (status) in
               self.hud.hide(animated: status)
            })
        }
    }
    // MARK: 🟠 - Cross Button ACTION
    @IBAction func crossBtnAction(_ sender: AnyObject) {
        AddFarmDelegate.anv()
        self.removeFromSuperview()
        
    }
    // MARK: 🟠 - House Number Button ACTION
    @IBAction func houseNoBtnAction(_ sender: AnyObject) {
        
        self.endEditing(true)
        btnTag = 0
        myPickerView.frame = CGRect(x: 572, y: 45, width: 100, height: 120)
        buttonbg.removeFromSuperview()
        pickerView()
        if(houseNoLbl.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else{
            for i in 0..<HouseNo.count{
                
                if (houseNoLbl.text! == HouseNo[i] as! String){
                    pickerIndex = i
                    break
                }
            }
            myPickerView.selectRow(pickerIndex, inComponent: 0, animated: true)
        }
        myPickerView.reloadInputViews()
    }
    
    // MARK: 🟠 - Age Button ACTION
    @IBAction func ageBtnAction(_ sender: AnyObject) {
        self.endEditing(true)
        ageDaata()
    }
    
    // MARK: 🟠 - Number of Birds Button ACTION
    @IBAction func noOfbirdsAction(_ sender: AnyObject) {
        self.endEditing(true)
        
        btnTag = 2
        myPickerView.frame = CGRect(x: 785 , y: 122, width: 100, height: 120)
        buttonbg.removeFromSuperview()
        pickerView()
        var birdsPickerIndex = Int()
        for i in 0..<NoOFbirds.count{
            
            if (noOfBirdsLbl.text! == NoOFbirds[i] as! String){
                birdsPickerIndex = i
                break
            }
        }
        myPickerView.selectRow(birdsPickerIndex, inComponent: 0, animated: true)
        myPickerView.reloadInputViews()
        
    }
    // MARK: 🟠 - Feed Program Button ACTION
    @IBAction func feedProgramBttn(_ sender: AnyObject) {
        
        farmNameTextField.resignFirstResponder()
        flockIdTextField.resignFirstResponder()
        feedProgramOutlet.layer.borderColor = UIColor.black.cgColor
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            postingId = 0
        }
        
        else if necIdExIsting == "Exting"{
            postingId = necIdExist
        }
        else
        {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
        
        feedProgramArray =  CoreDataHandler().FetchFeedProgram(postingId as NSNumber)
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 147, y: 205, width: 200, height: 100)
        droperTableView.reloadData()
        
    }
    
    
    // MARK: 🟠 - METHODS AND FUNCTIONS
    func hudAnimated1(){
        if MBProgressHUD.forView(self) == nil {
            hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.color = UIColor.black
            hud.label.text = "Adding Farm..."
        }
    }
    // MARK: 🟠- Insert Data.
    func insertData( _ completion: (_ status: Bool) -> Void) {
        CoreDataHandler().FarmsDataDatabase("", stateId: 0, farmName: trimmedString, farmId: 0, countryName: "", countryId: 0, city: "")
        
        var  necId = Int()
        
        if  necIdExIsting == "Exting"{
            
            necId = necIdExist
            CoreDataHandler().updateisSyncTrueOnPostingSessionISSync(necId as NSNumber)
            let captdata = CoreDataHandler().FetchNecropsystep1NecId(necId as NSNumber)
            let countData = captdata.lastObject as! CaptureNecropsyData
            count = countData.farmcount as! Int
            if count == 0{
                count = captdata.count
            }
            count = count+1
        }
        else{
            
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
            count =  UserDefaults.standard.integer(forKey: "count")
            count = count+1
        }
        UserDefaults.standard.set(self.count, forKey: "count")
        
        let appendfeedProgramwithCount = String(format:"%d. %@",self.count,trimmedString )
        let complexId = UserDefaults.standard.integer(forKey: "UnlinkComplex")
        let custMid = UserDefaults.standard.integer(forKey: "unCustId")
        
        UserDefaults.standard.set(appendfeedProgramwithCount, forKey: "farm")
        UserDefaults.standard.synchronize()
        let captdata = CoreDataHandler().FetchNecropsystep1NecId(necId as NSNumber)
        if captdata.count>0 {
            timeStamp1 = (captdata.object(at: 0) as AnyObject).value(forKey: "timeStamp") as! String
        }
        else{
            timeStamp1 =  UserDefaults.standard.value(forKey: "timestamp") as! String
        }
        if  necIdExIsting == "Exting"{
            let captdata = CoreDataHandler().FetchNecropsystep1NecId(necId as NSNumber)
            for i in 0..<captdata.count{
                let farmId = captdata.object(at: i) as! CaptureNecropsyData
                countFarmId = farmId.farmId as! Int
            }
            countFarmId = countFarmId+1
        }
        else{
            countFarmId = UserDefaults.standard.integer(forKey: "farmId")
            countFarmId = countFarmId+1
            UserDefaults.standard.set(countFarmId, forKey: "farmId")
        }
        
        
        var  imageAutoIncrementId = UserDefaults.standard.integer(forKey: "imageAutoIncrementId")
        imageAutoIncrementId = imageAutoIncrementId + 1
       
        
        UserDefaults.standard.set(imageAutoIncrementId, forKey: "imageAutoIncrementId")

        let necropsyData = chickenCoreDataHandlerModels.saveNecropsyStep1Data(
            postingId: necId as NSNumber,
               age: self.lblAge.text!,
               farmName: appendfeedProgramwithCount,
               feedProgram: feedProgramDisplayLabel.text!,
               flockId: flockIdTextField.text!,
               houseNo: houseNoTextFld.text!,
               noOfBirds: noOfBirdsLbl.text!,
               sick: asb as NSNumber,
               necId: necId as NSNumber,
               compexName: complexName!,
               complexDate: complexDate!,
               complexId: complexId as NSNumber,
               custmerId: custMid as NSNumber,
               feedId: feedId as NSNumber,
               isSync: true,
               timeStamp: timeStamp1,
               actualTimeStamp: timeStamp1,
               lngId: 1,
               farmId: countFarmId as NSNumber,
               imageId: NSNumber(value: imageAutoIncrementId),
               count: count as NSNumber
        )

        CoreDataHandler().SaveNecropsystep1(data: necropsyData)
        
        let numberofbirds = Int(noOfBirdsLbl.text!)
        
        self.saveSkeletonCat(appendfeedProgramwithCount, numberofBirds: numberofbirds!)
        self.saveCocoiCat(appendfeedProgramwithCount, numberofBirds: numberofbirds!)
        self.saveGiTractCat(appendfeedProgramwithCount, numberofBirds: numberofbirds!)
        self.saveResCat(appendfeedProgramwithCount, numberofBirds: numberofbirds!)
        self.saveImmuneCat(appendfeedProgramwithCount, numberofBirds: numberofbirds!)
        self.AddFarmDelegate.anv()
        self.delegeterefreshPage.refreshPageafterAddFeed(appendfeedProgramwithCount)
        
        completion (true)
    }
    // MARK: 🟢 - Save Skeleton Category
    func saveSkeletonCat(_ formName: String , numberofBirds:Int) {
        
        var necId = Int()
        if necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let skeletenArr = CoreDataHandler().fetchAllSeettingdataWithLngId(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<skeletenArr.count
        {
            for j in 0..<numberofBirds
            {
                if ((skeletenArr.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    
                    let skleta : Skeleta = skeletenArr.object(at: i) as! Skeleta
                    
                    if skleta.measure! == "Y,N" || skleta.measure == "Actual"{
                        let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let skeltaData = SkeletalObservationData(
                            catName: "skeltaMuscular",
                            obsName: skleta.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            obsId: Int(truncating: skleta.observationId ?? 0),
                            measure: trimmed,
                            quickLink: skleta.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: skleta.refId ?? 0,
                            actualText: skleta.measure ?? ""
                        )
                        
                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(skeltaData, index: j)
                    } else {
                        let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        let skeletalData = SkeletalObservationData(
                            catName: "skeltaMuscular",
                            obsName: skleta.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: Int(array[0]) ?? 0,
                            obsId: Int(truncating: skleta.observationId ?? 0),
                            measure: trimmed,
                            quickLink: skleta.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: skleta.refId ?? 0,
                            actualText: skleta.measure ?? ""
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(skeletalData, index: j)
                    }
                }
            }
        }
    }
    // MARK: 🟢 - Save Coci Category
    func saveCocoiCat(_ formName: String , numberofBirds:Int)
    {
        var  necId = Int()
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cocoii = CoreDataHandler().fetchAllCocoiiDataUsinglngId(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<cocoii.count
        {
            for j in 0..<numberofBirds
            {
                if ((cocoii.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let cocoiDis : Coccidiosis = cocoii.object(at: i) as! Coccidiosis
                    
                    if cocoiDis.measure! == "Y,N" || cocoiDis.measure == "Actual" {
                        
                        let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let cocciData = SkeletalObservationData(
                            catName: "Coccidiosis",
                            obsName: cocoiDis.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            obsId: Int(truncating: cocoiDis.observationId ?? 0),
                            measure: trimmed,
                            quickLink: cocoiDis.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: cocoiDis.refId ?? 0,
                            actualText: cocoiDis.measure ?? ""
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(cocciData, index: j)
                    }
                    
                    else
                    {
                        let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        let cocciData = SkeletalObservationData(
                            catName: "Coccidiosis",
                             obsName: cocoiDis.observationField ?? "",
                             formName: formName,
                             obsVisibility: false,
                             birdNo: NSNumber(value: j + 1),
                             obsPoint: Int(array[0]) ?? 0,
                             obsId: Int(truncating: cocoiDis.observationId ?? 0),
                             measure: trimmed,
                             quickLink: cocoiDis.quicklinks ?? 0,
                             necId: NSNumber(value: necId),
                             isSync: true,
                             lngId: NSNumber(value: lngId),
                             refId: cocoiDis.refId ?? 0,
                             actualText: cocoiDis.measure ?? ""
                            
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(cocciData, index: j)
                        
                        
                        
                    }
                }
            }
        }
    }
    // MARK: 🟢 - Save GiTract Category
    func saveGiTractCat(_ formName: String , numberofBirds:Int)
    {
        var  necId = Int()
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else{
            
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        let gitract = CoreDataHandler().fetchAllGITractDataUsingLngId(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        for i in 0..<gitract.count {
            for j in 0..<numberofBirds {
                if ((gitract.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let gitract : GITract = gitract.object(at: i) as! GITract
                    
                    if gitract.measure! == "Y,N" || gitract.measure == "Actual"{
                        let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let giTractData = SkeletalObservationData(
                            catName: "GITract",
                            obsName: gitract.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            obsId: Int(truncating: gitract.observationId ?? 0),
                            measure: trimmed,
                            quickLink: gitract.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: gitract.refId ?? 0,
                            actualText: gitract.measure ?? ""
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(giTractData, index: j)
                    } else {
                        let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        let giTractData = SkeletalObservationData(
                            catName: "GITract",
                            obsName: gitract.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: Int(array[0]) ?? 0,
                            obsId: Int(truncating: gitract.observationId ?? 0),
                            measure: trimmed,
                            quickLink: gitract.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: gitract.refId ?? 0,
                            actualText: gitract.measure ?? ""
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(giTractData, index: j)
                    }
                }
                
            }
        }
    }
    // MARK: 🟢 - Save Resp Category
    func saveResCat(_ formName: String , numberofBirds:Int)
    {
        var  necId = Int()
        
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let resp = CoreDataHandler().fetchAllRespiratoryusingLngId(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        
        for i in 0..<resp.count
        {
            for j in 0..<numberofBirds
            {
                if ((resp.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let resp : Respiratory = resp.object(at: i) as! Respiratory
                    
                    if resp.measure! == "Y,N" || resp.measure! == "Actual" {
                        
                        let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let respData = SkeletalObservationData(
                            catName: "Resp",
                            obsName: resp.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            obsId: Int(truncating: resp.observationId ?? 0),
                            measure: trimmed,
                            quickLink: resp.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: resp.refId ?? 0,
                            actualText: resp.measure ?? ""
                        )

                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(respData, index: j)
                    } else {
                        
                        let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        let respData = SkeletalObservationData(
                            catName: "Resp",
                            obsName: resp.observationField ?? "",
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: Int(array[0])!,
                            obsId: Int(truncating: resp.observationId ?? 0),
                            measure: trimmed,
                            quickLink: resp.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: resp.refId ?? 0,
                            actualText: resp.measure ?? ""
                        )
                        
                        CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(respData, index: j)
                    }
                }
            }
        }
    }
    // MARK: 🟢 - Save Imune Category
    fileprivate func handleIfCondition(_ immune: Immune, _ formName: String, _ j: Int, _ necId: Int) {
        let trimmed = immune.measure!.trimmingCharacters(in: .whitespacesAndNewlines)
        let obsId = Int(truncating: immune.observationId ?? 0)
        let birdNo = NSNumber(value: j + 1)
        let quickLink = immune.quicklinks ?? 0
        let lngIdInternal = lngId as NSNumber
        let refId = immune.refId ?? 0
        let observationField = immune.observationField ?? ""
        
        // Helper function to call saveCaptureSkeletaInDatabaseOnSwithCase
        func saveImmuneData(actualText: String) {
            let immuneData = SkeletalObservationData(
                catName: "Immune",
                obsName: observationField,
                formName: formName,
                obsVisibility: false,
                birdNo: birdNo,
                obsPoint: 0,
                obsId: obsId,
                measure: trimmed,
                quickLink: quickLink,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngIdInternal,
                refId: refId,
                actualText: actualText
            )
            CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCase(immuneData, index: j)
        }

        // Conditionally save based on the immune measure
        if immune.measure == "Y,N" {
            saveImmuneData(actualText: trimmed)
        } else if immune.measure == "Actual" {
            saveImmuneData(actualText: "0.0")
            if immune.observationField == Constants.maleFemaleStr {
                saveImmuneData(actualText: "N/A")
            }
        } else if immune.measure == "F,M" {
            if immune.observationField == Constants.maleFemaleStr {
                saveImmuneData(actualText: "0")
            }
        } else {
            saveImmuneData(actualText: immune.measure ?? "")
        }
    }
    
    func saveImmuneCat(_ formName: String , numberofBirds:Int) {
        var  necId = Int()
        
        if necIdExIsting == "Exting" {
            necId = necIdExist
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let immu =   CoreDataHandler().fetchAllImmuneUsingLngId(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        
        for i in 0..<immu.count {
            for j in 0..<numberofBirds {
                if ((immu.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let immune : Immune = immu.object(at: i) as! Immune
                    handleIfCondition(immune, formName, j, necId)
                }
            }
        }
    }
    
    // MARK: 🟠- Age Data
    func ageDaata(){
        
        btnTag = 1
        myPickerView.frame = CGRect(x: 572 , y: 122, width: 100, height: 120)
        buttonbg.removeFromSuperview()
        pickerView()
        if(lblAge.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else{
            var ageOPickerIndex = Int()
            for i in 0..<AgeOp.count{
                if (lblAge.text! == AgeOp[i] as! String){
                    ageOPickerIndex = i
                    break
                }
            }
            
            myPickerView.selectRow(ageOPickerIndex, inComponent: 0, animated: true)
        }
        myPickerView.reloadInputViews()
        ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
        
    }
    // MARK: 🟠 - Button Pressed to remove Background view
    @objc func buttonPressed1() {
        buttonbg.removeFromSuperview()
    }
    
    // MARK: 🟠 - load popup View
    func tableViewpop(){
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 945, height: 340)
        buttonbg1.addTarget(self, action:#selector(AddFarm.buttonPreddDroper), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.2)
        self.addSubview(buttonbg1)
        
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.white.cgColor
        buttonbg1.addSubview(droperTableView)
        
    }
    // MARK: 🟠 - Picekr View
    func pickerView (){
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 945, height: 340)
        buttonbg.addTarget(self, action: #selector(AddFarm.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.addSubview(buttonbg)
        
        myPickerView.layer.borderWidth = 1
        myPickerView.layer.cornerRadius = 5
        myPickerView.layer.borderColor = UIColor.clear.cgColor
        myPickerView.dataSource = self
        myPickerView.delegate = self
        myPickerView.backgroundColor = UIColor.white
        buttonbg.addSubview(myPickerView)
    }
    
    @objc func buttonPreddDroper() {
        buttonbg1.removeFromSuperview()
    }
    // MARK: - 🔴 Remove Duplicate Data.
    func removeDuplicates(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("no task.")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
        
        return result
    }
    // MARK: - 🔴 Remove Duplicate Data on array
    func removeDuplicatesOnArr(_ array: NSArray) -> NSArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("no task to preform.")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
        
        
        var arra = result.mutableCopy()  as! NSArray
        return arra
    }
    // MARK: 🟠 -Draw custome View .
    override func draw(_ rect: CGRect) {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            
            postingId = 0
            feedProgramOutlet.isUserInteractionEnabled = false
            feedProgramOutlet.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.1)
            
            if lngId == 3 {
                feedDisplyLbl.text = "Programme alimentaire"
            }else if lngId == 5 {
                feedDisplyLbl.text = "Programa de alimentación"
            }
            else if lngId == 4 {
                feedDisplyLbl.text = "Programa de Alimentação"
                newFarm.text = "Nome do Farm *"
                newAge.text = "Idade (dias)*"
                newSick.text = "Doente"
                newHouse.text = "Casa não."
                newFlock.text = "ID do rebanho"
                newDne.setTitle("Feito", for: .normal)
                newNoOfBirds.text = "N.o de aves"
                newAddFarm.text = "Adicionar Farm"
            }
            
            else if lngId == 1{
                feedDisplyLbl.text = "Feed Program"
            }
            
            feedProgramdropDwnIcon.isHidden = true
        }
        else
        {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
            feedProgramOutlet.isUserInteractionEnabled = true
            if lngId == 3 {
                feedDisplyLbl.text = "Programme alimentaire *"
            }else if lngId == 5 {
                feedDisplyLbl.text = "Programa de alimentación *"
            }
            else if lngId == 4 {
                feedDisplyLbl.text = "Programa In feed"
                newFarm.text = "Nome da Unidade *"
                newAge.text = "Idade (dias)*"
                newSick.text = "Doente"
                newHouse.text = "Galpão nº"
                newFlock.text = "ID do lote"
                newDne.setTitle("Feito", for: .normal)
                newNoOfBirds.text = "N.o de aves"
                newAddFarm.text = "Adicionar Unidade"
            }
            else if lngId == 1{
                feedDisplyLbl.text = "Feed Program *"
            }
            
            feedProgramdropDwnIcon.isHidden = false
            
        }
        
        flockIdTextField.tag = 11
        flockIdTextField.keyboardType = .numberPad
        flockIdTextField.delegate = self
        
        houseNoTextFld.tag = 18
        houseNoTextFld.keyboardType = .numberPad
        
        NoOFbirds = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10"]
        AgeOp = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80"]
        
        HouseNo = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50"]
        feedProgramDisplayLabel?.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        count = 0
        
        self.spacingTextField()
        
        self.bgView.layer.cornerRadius = 7
        self.bgView.layer.borderWidth = 3
        self.bgView.layer.borderColor = UIColor.white.cgColor
        
        
        flockIdTextField.delegate = self
        feedProgramOutlet.layer.borderWidth = 1
        feedProgramOutlet.layer.borderColor = UIColor.gray.cgColor
        farmNameTextField.delegate = self
        feedProgramOutlet.layer.cornerRadius = 4
        feedProgramOutlet.layer.borderWidth = 1
        feedProgramOutlet.layer.borderColor = UIColor.gray.cgColor
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        farmNameTextField.layer.borderColor = UIColor.black.cgColor
        
        houseNoTextFld.delegate = self
        houseNoTextFld.layer.borderWidth = 1
        houseNoTextFld.layer.cornerRadius = 1
        houseNoTextFld.layer.borderColor = UIColor.black.cgColor
        
        complexTypeFetchArray = CoreDataHandler().fetchFarmsDataDatabase().mutableCopy() as! NSMutableArray
        
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 994, height: 339)
        buttonDroper.addTarget(self, action: #selector(AddFarm.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.delegate = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.black.cgColor
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
        flockIdTextField.layer.borderWidth = 1
        flockIdTextField.layer.borderColor = UIColor.black.cgColor
        houseNoTextFld.text = "1"
    }
    
    @objc func buttonPressedDroper() {
        
        buttonDroper.alpha = 0
    }
    
    // MARK: 🟠  Add Padding sapce to textfield
    
    func spacingTextField() {
        // Create an array of all the text fields
        let textFields: [UITextField] = [
            farmNameTextField, flockIdTextField, houseNoTextFld
        ]
        
        // Loop through each text field and apply the padding
        for textField in textFields {
            let paddingView = UIView(frame: CGRect(x: 15, y: 0, width: 10, height: 20))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
    
    
    // MARK: 🟠 - PICKER VIEW DELEGATES
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        let counts = [HouseNo.count, AgeOp.count, NoOFbirds.count]
        
        if btnTag >= 0 && btnTag < counts.count {
            return counts[btnTag]
        }
        return 1
        
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
            if let value = AgeOp[row] as? String{
                return value
            } else {
                return nil
            }
        }
        else {
            
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
                return houseNoLbl.text = value
            } else {
                return houseNoLbl.text = ""
            }
        }
        else if btnTag == 1 {
            
            if let ageCheck = AgeOp[row] as? String {
                return lblAge.text = ageCheck
            }else {
                return lblAge.text = ""
            }
        }
        else{
            if let noOfBirdCheck = NoOFbirds[row] as? String {
                return noOfBirdsLbl.text = noOfBirdCheck
            }
            else {
                return noOfBirdsLbl.text = ""
            }
        }
        myPickerView.endEditing(true)
        buttonbg.removeFromSuperview()
    }
    
    // MARK: 🟠 TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == droperTableView {
            return feedProgramArray.count
        }
        else if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            
            if indexPath.row  < autocompleteUrls.count
            {
                cell.textLabel?.text = autocompleteUrls.object(at: indexPath.row) as? String
            }
            return cell
        }
        else{
            let cell = UITableViewCell ()
            let vet : FeedProgram = feedProgramArray.object(at: indexPath.row) as! FeedProgram
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textLabel!.text = vet.feddProgramNam
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == droperTableView {
            let str = feedProgramArray[indexPath.row] as! FeedProgram
            feedProgramDisplayLabel.text = str.feddProgramNam
            feedId = str.feedId as! Int
            buttonPreddDroper()
        }
        
        else if tableView == autoSerchTable {
            farmNameTextField.text = autocompleteUrls.object(at: indexPath.row) as? String
            autoSerchTable.alpha = 0
            farmNameTextField.endEditing(true)
            buttonDroper.alpha = 0
        }
    }
    
    // MARK: 🟠 TEXTFIELD DELEGATES
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == farmNameTextField ) {
            
            if farmNameTextField.text?.isEmpty == true
            {
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
            }
            else
            {
                farmNameTextField.layer.borderColor = UIColor.black.cgColor
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            debugPrint("backspace pressed.")
        }
        
        else if ((textField.text?.count)! > 50  ){
            return false
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101){
            
            let bPredicate: NSPredicate = NSPredicate(format: "farmName contains[cd] %@", newString)
            let complexId = UserDefaults.standard.integer(forKey: "UnlinkComplex")
            fetchcomplexArray = CoreDataHandler().fetchFarmsDataDatabaseUsingCompexId(complexId: complexId as NSNumber).filtered(using: bPredicate) as NSArray
            autocompleteUrls1 = fetchcomplexArray.mutableCopy() as! NSMutableArray
            autocompleteUrls.removeAllObjects()
            autocompleteUrls2.removeAllObjects()
            
            for i in 0..<autocompleteUrls1.count
            {
                let f = autocompleteUrls1.object(at: i) as! FarmsList
                let  farmName = f.farmName
                autocompleteUrls2.add(farmName!)
            }
            
            autocompleteUrls =   self.removeDuplicates(autocompleteUrls2)
            autoSerchTable.frame = CGRect(x: 150, y: 0, width: 200, height: 100)
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
            switch textField.tag {
            case 18 , 11 :
                let aSet = NSCharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£").inverted
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
}

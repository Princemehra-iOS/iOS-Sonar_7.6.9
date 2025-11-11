//
//  AddFarmTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 20/03/18.
//  Copyright © 2018 . All rights reserved.
//
import UIKit
import MBProgressHUD
protocol AddFarmPopTurkey: class {
    func addPopBack ()
    func noFarmUpdate ()
}
protocol refreshPageafterAddFeedTurkey{
    func refreshPageafterAddFeedTurkey(_ formName: String)
}
class AddFarmTurkey: UIView,UITextFieldDelegate{
    
    // MARK: - VARIABLES
    var farmWeightArray = NSArray ()
    var butttnTag1 = 0
    var asb = Bool()
    var hud : MBProgressHUD = MBProgressHUD()
    var valueStore = Bool()
    var abc = String()
    var delegeterefreshPage : refreshPageafterAddFeedTurkey!
    var myPickerView = UIPickerView()
    var countFarmId = Int()
    var feedProgramArray = NSArray()
    var abfArray = NSArray()
    var autoSerchTable = UITableView ()
    var btnTag = Int()
    let buttonbg = UIButton ()
    var necIdExIsting = String()
    var necIdExist = Int()
    var arrayTag = 0
    var AddFarmDelegate :AddFarmPopTurkey!
    let buttonbg1 = UIButton ()
    let buttonbg2 = UIButton ()
    var lngId = NSInteger()
    var postingIdFromExistingNavigate = String()
    var postingIdFromExisting = Int()
    var trimmedString = String()
    
    var timeStamp1 = String()
    var HouseNo = NSArray ()
    var AgeOp = NSArray ()
    var NoOFbirds = NSArray ()
    var backroundPop = UIButton()
    var  postingId = Int()
    var  feedId = Int()
    var count = Int()
    var  genId = Int()
    var complexTypeFetchArray = NSMutableArray()
    var complexTypeFetchArray1 = NSMutableArray()
    var autocompleteUrls = NSMutableArray ()
    var autocompleteUrls1 = NSMutableArray ()
    var autocompleteUrls2 = NSMutableArray ()
    var fetchcomplexArray = NSArray ()
    var fetchcomplexArray1 = NSArray ()
    var buttonDroper = UIButton ()
    var existingArray = NSMutableArray()
    var fetchcustRep = NSArray ()
    var sexString = String()
    var breedString = String()
    var indexOfSelectedPerson = Int()
    var birdArray: [BirdSizePostingTurkey]  = []
    var metricArray: [BirdSizePostingTurkey]  = []
    var geneId = Int()
    var GenerationTypeArr  = NSArray()
    var droperTableView  =  UITableView ()
    let complexDate =  UserDefaults.standard.value(forKey: "date") as? String
    let complexName = UserDefaults.standard.value(forKey: "complex") as? String
    var birdIndex = Int()
    let digitBeforeDecimal = 3
    let digitAfterDecimal = 3
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var farmNameTextField: UITextField!
    @IBOutlet weak var flockIdTextField: UITextField!
    @IBOutlet weak var feedProgramLbl: UILabel!
    @IBOutlet weak var noOfBirdsLbl: UILabel!
    @IBOutlet weak var abfLbl: UILabel!
    @IBOutlet weak var houseNoLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var ageUperBtnOutlet1: UIButton!
    @IBOutlet weak var mixedBtnOutlet: UIButton!
    @IBOutlet weak var nicholasBtnOutlet: UIButton!
    @IBOutlet weak var hybridBtnOutlet: UIButton!
    @IBOutlet weak var lightHensOutlet: UIButton!
    
    @IBOutlet weak var heavyHensOutlet: UIButton!
    @IBOutlet weak var sickBtnOutlet: UIButton!
    @IBOutlet weak var tomsOutlet: UIButton!
    @IBOutlet weak var genBtn: UIButton!
    @IBOutlet weak var genLbl: UILabel!
    @IBOutlet weak var feedProgramdropDwnIcon: UIImageView!
    @IBOutlet weak var feedProgramBtnOtlet: UIButton!
    @IBOutlet weak var abfBttnOutlet: UIButton!
    @IBOutlet weak var farmWeightTextField: UITextField!
    @IBOutlet weak var farmWeightLbl: UILabel!
    @IBOutlet weak var feedDisplyLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var feedProgramDisplayLabel: UILabel!
    
    @IBOutlet weak var houseNoTxtFld: UITextField!
    
    // MARK: - METHODS AND FUNCTIONS
    fileprivate func setUnlinkedUI() {
        postingId = 0
        feedProgramBtnOtlet.isUserInteractionEnabled = false
        feedProgramBtnOtlet.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.1)
        
        if lngId == 5 {
            feedDisplyLbl.text = "Programa de alimentación"
        }
        if lngId == 1000{
            feedDisplyLbl.text = NSLocalizedString("Feed Program", comment: "")
        }else{
            feedDisplyLbl.text = "Feed Program"
        }
        
        feedProgramdropDwnIcon.isHidden = true
    }
    // MARK: ✏️ Custom PopUp Drawing
    override func draw(_ rect: CGRect) {
        let allBireType = CoreDataHandlerTurkey().fetchBirdSizeTurkey()
        if(birdArray.count == 0){
            
            for dict in allBireType {
                if (dict as AnyObject).value(forKey: "scaleType") as! String == "Imperial"{
                    birdArray.append(dict as! BirdSizePostingTurkey)
                    
                }
                else{
                    metricArray.append(dict as! BirdSizePostingTurkey)
                    
                }
            }
        }
        valueStore = false
        
        sexString = "LH"
        breedString = "N"
        
        
        self.autoSerchTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        flockIdTextField.keyboardType = .numberPad
        flockIdTextField.delegate = self
        
        abfBttnOutlet.layer.borderWidth = 1
        abfBttnOutlet.layer.cornerRadius = 3.5
        abfBttnOutlet.layer.borderColor = UIColor.black.cgColor
        
        genBtn.layer.borderWidth = 1
        genBtn.layer.cornerRadius = 3.5
        genBtn.layer.borderColor = UIColor.black.cgColor
        
        genLbl.text = "Commercial"
        geneId =  1
        
        houseNoTxtFld.text = "1"
        
        feedProgramBtnOtlet.layer.borderWidth = 1
        feedProgramBtnOtlet.layer.cornerRadius = 3.5
        feedProgramBtnOtlet.layer.borderColor = UIColor.black.cgColor
        self.droperTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.bgView.layer.cornerRadius = 7
        self.bgView.layer.borderWidth = 3
        self.bgView.layer.borderColor = UIColor.white.cgColor
        spacingTextField()
        lightHensOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        nicholasBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            
            setUnlinkedUI()
        }  else  {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
            feedProgramBtnOtlet.isUserInteractionEnabled = true
           
            feedDisplyLbl.text = "Feed Program *"
            
            feedProgramdropDwnIcon.isHidden = false
        }
        
        flockIdTextField.tag = 11
        farmWeightTextField.tag = 12
        houseNoTxtFld.tag = 18
        flockIdTextField.keyboardType = .numberPad
        flockIdTextField.delegate = self
        farmWeightTextField.keyboardType = .numberPad
        farmWeightTextField.delegate = self
        NoOFbirds = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10"]
        AgeOp = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80"]
        
        HouseNo = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50"]
        feedProgramDisplayLabel?.text = NSLocalizedString(appDelegateObj.selectStr, comment: "")
        count = 0
        
        self.spacingTextField()
        
        self.bgView.layer.cornerRadius = 7
        self.bgView.layer.borderWidth = 3
        self.bgView.layer.borderColor = UIColor.white.cgColor
        
        sickBtnOutlet.layer.borderWidth = 1
        sickBtnOutlet.layer.borderColor = UIColor.black.cgColor
        
        flockIdTextField.delegate = self
        feedProgramBtnOtlet.layer.borderWidth = 1
        feedProgramBtnOtlet.layer.borderColor = UIColor.black.cgColor
        farmNameTextField.delegate = self
        farmWeightTextField.delegate = self
        
        houseNoTxtFld.keyboardType = .numberPad
        houseNoTxtFld.delegate = self
        houseNoTxtFld.layer.borderWidth = 1
        houseNoTxtFld.layer.cornerRadius = 1
        houseNoTxtFld.layer.borderColor = UIColor.black.cgColor
        
        feedProgramBtnOtlet.layer.cornerRadius = 4
        feedProgramBtnOtlet.layer.borderWidth = 1
        feedProgramBtnOtlet.layer.borderColor = UIColor.black.cgColor
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        farmNameTextField.layer.borderColor = UIColor.black.cgColor
        farmWeightTextField.layer.borderWidth = 1
        farmWeightTextField.layer.cornerRadius = 1
        farmWeightTextField.layer.borderColor = UIColor.black.cgColor
        complexTypeFetchArray = CoreDataHandlerTurkey().fetchFarmsDataDatabaseTurkey().mutableCopy() as! NSMutableArray
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 942, height: 428)
        buttonDroper.addTarget(self, action: #selector(AddFarmTurkey.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.addSubview(buttonDroper)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.delegate = self
        autoSerchTable.layer.cornerRadius = 7
        autoSerchTable.layer.borderWidth = 1
        autoSerchTable.layer.borderColor = UIColor.black.cgColor
        
        buttonDroper .addSubview(autoSerchTable)
        buttonDroper.alpha = 0
        
        let cusPaddingView = UIView(frame: CGRect(x: 15, y: 0, width: 10, height: 20))
        farmWeightTextField.leftView = cusPaddingView
        farmWeightTextField.leftViewMode = .always
        flockIdTextField.layer.borderWidth = 1
        flockIdTextField.layer.borderColor = UIColor.black.cgColor
        
        birdIndex = UserDefaults.standard.integer(forKey: "birdIndex")
        
        if birdIndex == 0 {
            
            farmWeightLbl.text = "(lbs)"
            
        } else if birdIndex == 1 {
            
            farmWeightLbl.text = "(Kgs)"
        }
    }
    
    
    @objc func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    // MARK: 🗑️ Remove Duplicates Item's
    func removeDuplicates(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("value not found.")
            } else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
        return result
    }
    
    func removeDuplicatesOnArr(_ array: NSArray) -> NSArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                debugPrint("No duplicate data found.")
            }
            else {
                encountered.insert(value as! String)
                result.add(value as! String)
            }
        }
    
        var arra = result.mutableCopy()  as! NSArray
        
        return arra
    }
  
    // MARK: ✖️ Dismiss Pop-up Action
    @IBAction func closePopUpAction(_ sender: UIButton) {
        AddFarmDelegate.noFarmUpdate()
        self.removeFromSuperview()
    }
    
    // MARK: 🫁 Save Respiratory Data
    func saveResCat(_ formName: String , numberofBirds:Int) {
        var  necId = Int()
        
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let resp = CoreDataHandlerTurkey().fetchAllRespiratoryusingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<resp.count
        {
            for j in 0..<numberofBirds
            {
                if ((resp.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let resp : RespiratoryTurkey = resp.object(at: i) as! RespiratoryTurkey
                    
                    if resp.measure! == "Y,N" || resp.measure! == "Actual" {
                        
                        let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Resp",
                            obsName: resp.observationField!,
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            index: j,
                            obsId: Int(resp.observationId!),
                            measure: trimmed,
                            quickLink: resp.quicklinks ?? 0,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: resp.refId ?? 0,
                            actualText: resp.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                    else {
                        let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Resp",
                               obsName: resp.observationField ?? "",
                               formName: formName,
                               obsVisibility: false,
                               birdNo: NSNumber(value: j + 1),
                               obsPoint: Int(array[0]) ?? 0,
                               index: j,
                               obsId: Int(resp.observationId!),
                               measure: trimmed,
                               quickLink: resp.quicklinks ?? 0,
                               necId: necId as NSNumber,
                               isSync: true,
                               lngId: lngId as NSNumber,
                               refId: resp.refId ?? 0,
                               actualText: resp.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                }
            }
        }
    }
    // MARK: 🦃⚖️ Set Turkey Body Weight
    fileprivate func setBirdsBodyWeight(_ immune: ImmuneTurkey, _ formName: String, _ necId: Int, _ j: Int) {
        let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let farmWeight =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkeyWithFarmName(formName ,necropsyId:necId as NSNumber)
        let arrdata = farmWeight.object(at: 0) as! CaptureNecropsyDataTurkey
        var result: Float
        if arrdata.farmWeight! != ""{
            result = Float(arrdata.farmWeight!)! / Float(arrdata.noOfBirds!)!
        }
        else{
            result = 0.0
        }
        
        let newResult = Float(result).rounded(toPlaces: 3)
        let immuneData = CoreDataHandlerTurkeyModels.imumneSwithcCaptureData(
            catName: "Immune",
              obsName: immune.observationField!,
              formName: formName,
              obsVisibility: false,
              birdNo: j + 1 as NSNumber,
              obsPoint: newResult,
              index: j,
              obsId: Int(immune.observationId!),
              measure: trimmed,
              quickLink: immune.quicklinks!,
              necId: necId as NSNumber,
              isSync: true,
              lngId: lngId as NSNumber,
              refId: immune.refId!,
              actualText: immune.measure ?? ""
        )
        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkeyImmuneCase(data: immuneData)
    }
    // MARK: 🦃 Set Turkey Bird Sex
    fileprivate func setBirdSex(_ immune: ImmuneTurkey, _ formName: String, _ j: Int, _ necId: Int) {
        let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if immune.observationField == Constants.maleFemaleStr
        {
            
            let data = CoreDataHandlerTurkeyModels.turkeySexNecropsyData(
                catName: "Immune",
                  obsName: immune.observationField!,
                  formName: formName,
                  obsVisibility: false,
                  birdNo: NSNumber(value: j + 1),
                  obsPoint: 1,
                  index: j,
                  obsId: Int(immune.observationId!),
                  measure: trimmed,
                  quickLink: immune.quicklinks!,
                  necId: necId as NSNumber,
                  isSync: true,
                  lngId: lngId as NSNumber,
                  refId: immune.refId!,
                  actualText: "0"
            )

            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkeySex(data: data)
        }
    }
    // MARK: 🦃📝 Set Other Observations
    fileprivate func setOtherObservations(_ immune: ImmuneTurkey, _ formName: String, _ j: Int, _ necId: Int) {
        let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let array = (trimmed.components(separatedBy: ",") as [String])
        if immune.refId == 58 {
            
            
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                    catName: "Immune",
                   obsName: immune.observationField!,
                   formName: formName,
                   obsVisibility: false,
                   birdNo: NSNumber(value: j + 1),
                   obsPoint: Int(array[3])!,
                   index: j,
                   obsId: Int(immune.observationId!),
                   measure: trimmed,
                   quickLink: immune.quicklinks!,
                   necId: necId as NSNumber,
                   isSync: true,
                   lngId: lngId as NSNumber,
                   refId: immune.refId!,
                   actualText: immune.measure ?? ""
            )

            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
            
        } else {
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                  catName: "Immune",
                  obsName: immune.observationField!,
                  formName: formName,
                  obsVisibility: false,
                  birdNo: j + 1 as NSNumber,
                  obsPoint: Int(array[0])!,
                  index: j,
                  obsId: Int(immune.observationId!),
                  measure: trimmed,
                  quickLink: immune.quicklinks!,
                  necId: necId as NSNumber,
                  isSync: true,
                  lngId: lngId as NSNumber,
                  refId: immune.refId!,
                  actualText: immune.measure ?? ""
            )

            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
            
        }
    }
    // MARK: 🦃🛡️💉 Save Immune Category Data
    func saveImmuneCat(_ formName: String , numberofBirds:Int) {
        var  necId = Int()
        
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let immu =   CoreDataHandlerTurkey().fetchAllImmuneUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        
        for i in 0..<immu.count {
            for j in 0..<numberofBirds
            {
                if ((immu.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let immune : ImmuneTurkey = immu.object(at: i) as! ImmuneTurkey
                    
                    if immune.measure! == "Y,N" {
                        let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Immune",
                              obsName: immune.observationField!,
                              formName: formName,
                              obsVisibility: false,
                              birdNo: NSNumber(value: j + 1),
                              obsPoint: 0,
                              index: j,
                              obsId: Int(immune.observationId!),
                              measure: trimmed,
                              quickLink: immune.quicklinks!,
                              necId: necId as NSNumber,
                              isSync: true,
                              lngId: lngId as NSNumber,
                              refId: immune.refId!,
                              actualText: immune.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                    else if ( immune.measure! == "Actual"){
                        setBirdsBodyWeight(immune, formName, necId, j)
                    }
                    else if ( immune.measure! == "F,M"){
                        setBirdSex(immune, formName, j, necId)
                    }
                    else {
                        setOtherObservations(immune, formName, j, necId)
                    }
                }
            }
        }
    }
    
    // MARK: 🦃🦴 Save Skeletal Category Data
    func saveSkeletonCat(_ formName: String , numberofBirds:Int) {
        var  necId = Int()
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        } else {
            
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let skeletenArr = CoreDataHandlerTurkey().fetchAllSeettingdataWithLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<skeletenArr.count
        {
            for j in 0..<numberofBirds
            {
                if ((skeletenArr.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    
                    let skleta : SkeletaTurkey = skeletenArr.object(at: i) as! SkeletaTurkey
                    
                    if skleta.measure! == "Y,N" ||  skleta.measure! == "Actual" {
                        let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "skeltaMuscular",
                            obsName: skleta.observationField!,
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            index: j,
                            obsId: Int(skleta.observationId!),
                            measure: trimmed,
                            quickLink: skleta.quicklinks!,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: skleta.refId!,
                            actualText: skleta.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                    
                    else {
                        let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                                catName: "skeltaMuscular",
                                obsName: skleta.observationField!,
                                formName: formName,
                                obsVisibility: false,
                                birdNo: NSNumber(value: j + 1),
                                obsPoint: Int(array[0])!,
                                index: j,
                                obsId: Int(skleta.observationId!),
                                measure: trimmed,
                                quickLink: skleta.quicklinks!,
                                necId: necId as NSNumber,
                                isSync: true,
                                lngId: lngId as NSNumber,
                                refId: skleta.refId!,
                                actualText: skleta.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                }
            }
        }
    }
    // MARK: 🦃🦠 Save Coccidiosis Category Data
    func saveCocoiCat(_ formName: String , numberofBirds:Int) {
        
        var  necId = Int()
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let cocoii = CoreDataHandlerTurkey().fetchAllCocoiiDataUsinglngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<cocoii.count
        {
            for j in 0..<numberofBirds
            {
                if ((cocoii.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let cocoiDis : CoccidiosisTurkey = cocoii.object(at: i) as! CoccidiosisTurkey
                    
                    if cocoiDis.measure! == "Y,N" || cocoiDis.measure! == "Actual"  {
                        
                        let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                                catName: "Coccidiosis",
                                obsName: cocoiDis.observationField!,
                                formName: formName,
                                obsVisibility: false,
                                birdNo: NSNumber(value: j + 1),
                                obsPoint: 0,
                                index: j,
                                obsId: Int(cocoiDis.observationId!),
                                measure: trimmed,
                                quickLink: cocoiDis.quicklinks!,
                                necId: necId as NSNumber,
                                isSync: true,
                                lngId: lngId as NSNumber,
                                refId: cocoiDis.refId!,
                                actualText: cocoiDis.measure ?? ""
                        )
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                     else {
                        let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                         
                         let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Coccidiosis",
                                obsName: cocoiDis.observationField!,
                                formName: formName,
                                obsVisibility: false,
                                birdNo: NSNumber(value: j + 1),
                                obsPoint: Int(array[0])!,
                                index: j,
                                obsId: Int(cocoiDis.observationId!),
                                measure: trimmed,
                                quickLink: cocoiDis.quicklinks!,
                                necId: necId as NSNumber,
                                isSync: true,
                                lngId: lngId as NSNumber,
                                refId: cocoiDis.refId!,
                                actualText: cocoiDis.measure ?? ""
                         )
                         CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                }
            }
        }
    }
    // MARK: 🦃🫁 Set GI Tract Observations
    fileprivate func setGiTrectObservation(_ gitract: GITractTurkey, _ formName: String, _ j: Int, _ necId: Int) {
        let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if gitract.observationField == "Feed in Crop"{
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "GITract",
                obsName: gitract.observationField!,
                formName: formName,
                obsVisibility: true,
                birdNo: NSNumber(value: j + 1),
                obsPoint: 0,
                index: j,
                obsId: Int(gitract.observationId!),
                measure: trimmed,
                quickLink: gitract.quicklinks!,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngId as NSNumber,
                refId: gitract.refId!,
                actualText: gitract.measure ?? ""
            )
            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
        }
        else {
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "GITract",
                obsName: gitract.observationField!,
                formName: formName,
                obsVisibility: false,
                birdNo: NSNumber(value: j + 1),
                obsPoint: 0,
                index: j,
                obsId: Int(gitract.observationId!),
                measure: trimmed,
                quickLink: gitract.quicklinks!,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngId as NSNumber,
                refId: gitract.refId!,
                actualText: gitract.measure ?? ""
            )
            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
        }
    }
    
    func saveGiTractCat(_ formName: String , numberofBirds:Int) {
        
        var necId = Int()
        if  necIdExIsting == "Exting"{
            necId = necIdExist
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let gitract = CoreDataHandlerTurkey().fetchAllGITractDataUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for i in 0..<gitract.count {
            for j in 0..<numberofBirds {
                if ((gitract.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                    let gitract : GITractTurkey = gitract.object(at: i) as! GITractTurkey
                    
                    if gitract.measure! == "Y,N" {
                        setGiTrectObservation(gitract, formName, j, necId)
                    }
                    else if ( gitract.measure! == "Actual"){
                        
                        let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "GITract",
                            obsName: gitract.observationField!,
                            formName: formName,
                            obsVisibility: false,
                            birdNo: NSNumber(value: j + 1),
                            obsPoint: 0,
                            index: j,
                            obsId: Int(gitract.observationId!),
                            measure: trimmed,
                            quickLink: gitract.quicklinks!,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: gitract.refId!,
                            actualText: gitract.measure ?? ""
                        )

                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    }
                    else {
                        let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "GITract",
                               obsName: gitract.observationField!,
                               formName: formName,
                               obsVisibility: false,
                               birdNo: NSNumber(value: j + 1),
                               obsPoint: Int(array[0])!,
                               index: j,
                               obsId: Int(gitract.observationId!),
                               measure: trimmed,
                               quickLink: gitract.quicklinks!,
                               necId: necId as NSNumber,
                               isSync: true,
                               lngId: lngId as NSNumber,
                               refId: gitract.refId!,
                               actualText: gitract.measure ?? ""
                        )

                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                        
                    }
                }
            }
        }
    }
    // MARK: 🦃⬇️  Create Dropdown Pop-up Table
    func tableViewpop() {
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 945, height: 484)
        buttonbg1.addTarget(self, action:#selector(AddFarmTurkey.buttonPreddDroper), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.2)
        self.addSubview(buttonbg1)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttonbg1.addSubview(droperTableView)
    }
    
    func autoSearch () {
        
        buttonbg2.frame = CGRect(x: 0, y: 0, width: 945, height: 340)
        buttonbg2.addTarget(self, action:#selector(AddFarmTurkey.buttonPreddDroper), for: .touchUpInside)
        buttonbg2.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.2)
        self.addSubview(buttonbg2)
        autoSerchTable.delegate = self
        autoSerchTable.dataSource = self
        autoSerchTable.layer.cornerRadius = 8.0
        autoSerchTable.layer.borderWidth = 1.0
        autoSerchTable.layer.borderColor =  UIColor.white.cgColor
        buttonbg2.addSubview(autoSerchTable)
    }
    
    // MARK: - Dismiss Dropdown on view Click
    @objc func buttonPreddDroper() {
        buttonbg1.removeFromSuperview()
        buttonbg2.removeFromSuperview()
    }
    
    // MARK: ✏️↔️ Add Padding Space to TextField
    func spacingTextField() {
          let textFields: [UITextField] = [
            farmNameTextField, flockIdTextField, houseNoTxtFld
          ]
          
          for textField in textFields {
              let paddingView = UIView(frame: CGRect(x: 15, y: 0, width: 10, height: 20))
              textField.leftView = paddingView
              textField.leftViewMode = .always
          }
      }
    
    // MARK: 👆🔘 Generation IBACTIONS
    @IBAction func genBtnAction(_ sender: Any) {
        arrayTag = 9
        GenerationTypeArr = CoreDataHandler().fetchGenerationType()
        tableViewpop()
        droperTableView.frame = CGRect(x: 175,y: 307,width: 200,height: 100)
        droperTableView.reloadData()
    }
    
    // MARK: - ABF IBACTIONS
    @IBAction func abfBtnAction(_ sender: UIButton) {
        arrayTag = 1
        abfArray = ["Antibiotic free","Conventional"]
        droperTableView.isHidden = false
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 150, y: 253, width: 202, height: 100)
        droperTableView.reloadData()
    }
    
    //MARK: 🦃🤒 Mark Sick Button --- (Not Usefull)
    @IBAction func sickBtnAction(_ sender: UIButton) {
        
        self.endEditing(true)
        
        if (sender.tag == 103) {
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
        } else {
            
        }
        
    }
    // MARK: 🦃🌾 Feed Program Button Action
    @IBAction func feedProgramBtnAction(_ sender: UIButton) {
        
        arrayTag = 2
        farmNameTextField.resignFirstResponder()
        flockIdTextField.resignFirstResponder()
        feedProgramBtnOtlet.layer.borderColor = UIColor.black.cgColor
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true   {
            postingId = 0
        } else if necIdExIsting == "Exting"{
            postingId = necIdExist
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId")
        }
        
        feedProgramArray =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(postingId as NSNumber)
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 150, y: 192, width: 202, height: 100)
        droperTableView.reloadData()
    }
    // MARK: - Done Button IBACTIONS
    fileprivate func setFarmNameWeightAge() {
        Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
        if  trimmedString == ""{
            farmNameTextField.layer.borderColor = UIColor.red.cgColor
        }
        else if farmWeightTextField.text == ""{
            farmWeightTextField.layer.borderColor = UIColor.red.cgColor
        }
        else if ageLbl.text == ""{
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: UIControl.State())
        }
        if ageLbl.text != ""  {
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
        }
    }
    // MARK: 🦃✅ Validate Farm Name, Weight & Age
    fileprivate func validationCheckFarmNameWeigthAge() {
        Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
        
        feedProgramBtnOtlet.layer.borderColor = UIColor.red.cgColor
        ageUperBtnOutlet1.setImage(UIImage(named: "dialer01-1"), for: UIControl.State())
        if feedProgramDisplayLabel.text != NSLocalizedString(appDelegateObj.selectStr, comment: "")  {
            feedProgramBtnOtlet.layer.borderColor = UIColor.black.cgColor
        }
        if farmNameTextField.text == "" {
            farmNameTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            farmNameTextField.layer.borderColor = UIColor.black.cgColor
        }
        if farmWeightTextField.text == "" {
            farmWeightTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            farmWeightTextField.layer.borderColor = UIColor.black.cgColor
        }
        if houseNoTxtFld.text == "" {
            houseNoTxtFld.layer.borderColor = UIColor.red.cgColor
        } else {
            houseNoTxtFld.layer.borderColor = UIColor.black.cgColor
        }
        if ageLbl.text != ""  {
            ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
        }
    }
    // MARK: 🦃✅ Done Button Action
    @IBAction func donebtnAction(_ sender: UIButton) {
        Constants.isFromPsotingTurkey = true
        UserDefaults.standard.setValue(true, forKey: "postingTurkey")
        UserDefaults.standard.synchronize()
        trimmedString = farmNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            Constants.isForUnlinkedTurkey = true
            if (trimmedString == "" ||  ageLbl.text == "" )
            {
                setFarmNameWeightAge()
            } else{
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
        else if (trimmedString == "" || feedProgramDisplayLabel.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") ||  ageLbl.text == "" ||  houseNoTxtFld.text == "")
        {
            validationCheckFarmNameWeigthAge()
        }
        else{
            
            self.hudAnimated1()
            self.insertData({ (status) in
                if status == true
                {
                    self.hud.hide(animated: true)
                }
            })
        }
    }
    // MARK: Show Loader
    func hudAnimated1(){
        if MBProgressHUD.forView(self) == nil {
            hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.color = UIColor.black
            hud.label.text = "Adding Farm..."
        }
    }
    // MARK: 🦃💾 Insert Data
    func insertData( _ completion: (_ status: Bool) -> Void){
        
        CoreDataHandlerTurkey().FarmsDataDatabaseTurkey("", stateId: 0, farmName: trimmedString, farmId: 0, countryName: "", countryId: 0, city: "")
        var necId = Int()
        
        if necIdExIsting == "Exting"{
            necId = necIdExist
            CoreDataHandlerTurkey().updatedPostigSessionwithIsFarmSyncPostingIdTurkey(necId as NSNumber, isFarmSync: false)
            let captdata = CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(necId as NSNumber)
            let countData = captdata.lastObject as! CaptureNecropsyDataTurkey
            count = countData.farmcount as! Int
            if count == 0{
                count = captdata.count
            }
            count = count+1
            
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
            count =  UserDefaults.standard.integer(forKey: "count")
            count = count+1
        }
        
        UserDefaults.standard.set(self.count, forKey: "count")
        if necIdExIsting == "Exting"{
            let captdata = CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(necId as NSNumber)
            for i in 0..<captdata.count{
                let farmId = captdata.object(at: i) as! CaptureNecropsyDataTurkey
                countFarmId = farmId.farmId as? Int ?? 0
            }
            countFarmId = countFarmId+1
        }
        else{
            countFarmId = UserDefaults.standard.integer(forKey: "farmIdTurkey")
            countFarmId = countFarmId+1
            UserDefaults.standard.set(countFarmId, forKey: "farmIdTurkey")
        }
        
        let appendfeedProgramwithCount = String(format:"%d. %@",count,trimmedString )
        let complexId = UserDefaults.standard.integer(forKey: "UnlinkComplex")
        let custMid = UserDefaults.standard.integer(forKey: "unCustId")
        
        UserDefaults.standard.set(appendfeedProgramwithCount, forKey: "farm")
        UserDefaults.standard.synchronize()
        let captdata = CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(necId as NSNumber)
        if captdata.count>0 {
            timeStamp1 = (captdata.object(at: 0) as AnyObject).value(forKey: "timeStamp") as? String ?? ""
        }
        else{
            timeStamp1 =  UserDefaults.standard.value(forKey: "timestamp") as? String ?? ""
        }
        
        if farmWeightTextField.text == "."{
            farmWeightTextField.text = ""
        }
      
        var imageAutoIncrementId = UserDefaults.standard.integer(forKey: "imageAutoIncrementIdTurkey")
        imageAutoIncrementId = imageAutoIncrementId + 1
        UserDefaults.standard.set(imageAutoIncrementId, forKey: "imageAutoIncrementIdTurkey")
        
        let necropsyData = CoreDataHandlerTurkeyModels.saveTurkeyNecropsyStep1Data(
              postingId: necId as NSNumber,
              age: self.ageLbl.text ?? "",
              farmName: appendfeedProgramwithCount,
              feedProgram: feedProgramDisplayLabel.text ?? "",
              flockId: flockIdTextField.text ?? "",
              houseNo: houseNoTxtFld.text ?? "",
              noOfBirds: noOfBirdsLbl.text ?? "",
              sick: asb as NSNumber,
              necId: necId as NSNumber,
              compexName: complexName ?? "",
              complexDate: complexDate ?? "",
              complexId: complexId as NSNumber,
              customerId: custMid as NSNumber,
              feedId: feedId as NSNumber,
              isSync: true,
              timeStamp: timeStamp1,
              actualTimeStamp: timeStamp1,
              lngId: 1,
              farmWeight: farmWeightTextField.text ?? "",
              abf: abfLbl.text ?? "",
              breed: breedString,
              sex: sexString,
              farmId: countFarmId as NSNumber,
              imageId: NSNumber(value: imageAutoIncrementId),
              count: count as NSNumber,
              genName: genLbl.text ?? "",
              genId: geneId as NSNumber
        )

        CoreDataHandlerTurkey().SaveNecropsystep1Turkey(necropsyData)
        
        let numberofbirds = Int(noOfBirdsLbl.text!)
        self.saveSkeletonCat(appendfeedProgramwithCount, numberofBirds: numberofbirds ?? 0)
        self.saveCocoiCat(appendfeedProgramwithCount, numberofBirds: numberofbirds ?? 0)
        self.saveGiTractCat(appendfeedProgramwithCount, numberofBirds: numberofbirds ?? 0)
        self.saveResCat(appendfeedProgramwithCount, numberofBirds: numberofbirds ?? 0)
        self.saveImmuneCat(appendfeedProgramwithCount, numberofBirds: numberofbirds ?? 0)
        self.AddFarmDelegate.addPopBack()
        self.delegeterefreshPage.refreshPageafterAddFeedTurkey(appendfeedProgramwithCount)
        completion (true)
    }
    // MARK: 🦃 Turkey Bird Sex Type Selection Buttons
    
    // MARK: 🦃🐓 Light Hens Button Action
    @IBAction func lightHensBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            lightHensOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            heavyHensOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            tomsOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        sexString = "LH"
    }
    // MARK: 🦃🐓 Heavy Hens Button Action
    @IBAction func heavyHensBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            lightHensOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            heavyHensOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            tomsOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        sexString = "HH"
    }
    // MARK: 🦃🐓 Tom Hens Button Action
    @IBAction func tomsBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            lightHensOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            heavyHensOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            tomsOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        }
        sexString = "T"
    }
    // MARK: 🦃 Turkey Bird Breed Type Selection Buttons
    // MARK: 🦃 Handle Nicholas breed selection
    @IBAction func nicholasBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            nicholasBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            hybridBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            mixedBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        breedString = "N"
    }
    // MARK: 🦃 Handle Hybrid breed selection
    @IBAction func hybridBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            nicholasBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            hybridBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            mixedBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
        }
        breedString = "H"
    }
    // MARK: 🦃 Handle Mixed breed selection
    @IBAction func mixedBtnAction(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
            nicholasBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            hybridBtnOutlet.setImage(UIImage(named: "Radio_Btn01")!, for: UIControl.State())
            mixedBtnOutlet.setImage(UIImage(named: "Radio_Btn")!, for: UIControl.State())
        }
        breedString = "M"
    }
    // MARK: 🦃 House Number button selection
    @IBAction func houseNoBtnAction(_ sender: UIButton) {
        
        self.endEditing(true)
        
        btnTag = 10
        myPickerView.frame = CGRect(x: 570 , y: 51, width: 100, height: 120)
        pickerView()
        var pickerIndex = Int()
        if(houseNoLbl.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }else {
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
    // MARK: 🦃 Create Custome Picker View
    func pickerView (){
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 945, height: 484)
        buttonbg.addTarget(self, action: #selector(AddFarmTurkey.buttonPressed1), for: .touchUpInside)
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
    // MARK: 🦃 Dismiss Picker View
    @objc func buttonPressed1() {
        
        buttonbg.removeFromSuperview()
    }
    // MARK: 🦃 Age Selection button selection
    @IBAction func ageBtnAction(_ sender: UIButton) {
        self.endEditing(true)
        
        btnTag = 11
        myPickerView.frame = CGRect(x: 570 , y: 110, width: 100, height: 120)
        pickerView()
        if(ageLbl.text == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }  else {
            var pickerIndex = Int()
            for i in 0..<AgeOp.count{
                if (ageLbl.text! == AgeOp[i] as! String){
                    pickerIndex = i
                    break
                }
            }
            myPickerView.selectRow(pickerIndex, inComponent: 0, animated: true)
        }
        myPickerView.reloadInputViews()
        ageUperBtnOutlet1.setImage(UIImage(named: "dialer01"), for: UIControl.State())
    }
    // MARK: 🦃  Number of Birds button selection
    @IBAction func noOfBirdsAction(_ sender: UIButton) {
        self.endEditing(true)
        
        btnTag = 12
        myPickerView.frame = CGRect(x: 570, y: 173, width: 100, height: 120)
        pickerView()
        var pickerIndex = Int()
        for i in 0..<NoOFbirds.count{
            
            if (noOfBirdsLbl.text! == NoOFbirds[i] as! String){
                pickerIndex = i
                break
            }
        }
        myPickerView.selectRow(pickerIndex, inComponent: 0, animated: true)
        myPickerView.reloadInputViews()
        
    }
    
    // MARK: 🦃✏️⌨️ TextField Delegates & Validations
    // MARK: ---------------------------------------------
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == farmNameTextField ) {
            
            if farmNameTextField.text?.isEmpty == true {
                farmNameTextField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                farmNameTextField.layer.borderColor = UIColor.black.cgColor
            }
        }
        
        if (textField == farmWeightTextField ) {
            
            if farmWeightTextField.text?.isEmpty == true {
                farmWeightTextField.layer.borderColor = UIColor.red.cgColor
            }
            else {
                farmWeightTextField.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        farmWeightTextField.returnKeyType = UIReturnKeyType.done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        farmNameTextField.layer.borderWidth = 1
        farmNameTextField.layer.cornerRadius = 1
        return true
    }
    
    fileprivate func handleTxtField101Validation(_ newString: String) {
        let bPredicate: NSPredicate = NSPredicate(format: "farmName contains[cd] %@", newString)
        let complexId = UserDefaults.standard.integer(forKey: "UnlinkComplex")
        fetchcomplexArray = CoreDataHandlerTurkey().fetchFarmsDataDatabaseUsingCompexIdTurkey(complexId: complexId as NSNumber).filtered(using: bPredicate) as NSArray
        autocompleteUrls1 = fetchcomplexArray.mutableCopy() as! NSMutableArray
        autocompleteUrls.removeAllObjects()
        autocompleteUrls2.removeAllObjects()
        
        for i in 0..<autocompleteUrls1.count {
            
            let f = autocompleteUrls1.object(at: i) as! FarmsListTurkey
            let  farmName = f.farmName
            autocompleteUrls2.add(farmName!)
            
        }
        autocompleteUrls =   self.removeDuplicates(autocompleteUrls2)
        autoSerchTable.frame = CGRect(x: 150, y: -12, width: 200, height: 100)
        buttonDroper.alpha = 1
        autoSerchTable.alpha = 1
        
        if autocompleteUrls.count == 0 {
            buttonDroper.alpha = 0
            autoSerchTable.alpha = 0
        } else {
            autoSerchTable.reloadData()
        }
    }
    
    fileprivate func handleTag18(_ string: String, _ aSet: CharacterSet, _ textField: UITextField, _ range: NSRange) -> Bool {
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        
        return string == numberFiltered && newString.length <= maxLength
    }
    
  
    
    fileprivate func handleValidations(_ string: String, _ textField: UITextField, _ newString: inout NSString) -> Bool {
        if string == "." {
            let countdots = textField.text!.components(separatedBy:".").count - 1
            if countdots == 0 {
                
                if (newString.length) > 6 {
                    newString = newString.substring(to: newString.length - 1) as NSString
                    return false
                } else {
                    return true
                }
                
            } else {
                if countdots > 0 && string == "." {
                    return false
                } else {
                    return true
                }
            }
        } else {
            return false
        }
    }
    
    fileprivate func handleValidation12(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        var newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        var result = true
        if textField == farmWeightTextField {
            
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            if filtered == string {
                return newString.length <= maxLength
            } else {
                return handleValidations(string, textField, &newString)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            debugPrint("back space is long pressed.")
        }  else if ((textField.text?.count)! > 50  ){
            return false
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (textField.tag == 101) {
            
            handleTxtField101Validation(newString)
        } else {
            let aSet = NSCharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£").inverted
            switch textField.tag {
            case 18 , 11 :
               
                return handleTag18(string, aSet, textField, range)
                
            case 12 :
                return handleValidation12(textField, range, string)
                
            default : break
            }
        }
        return true
    }
    
    
    func checkCharacter( _ inputChar : String , textfield11 : UITextField ) -> Bool {
        
        let newCharacters = CharacterSet(charactersIn: inputChar)
        let boolIsNumber = CharacterSet.decimalDigits.isSuperset(of: newCharacters)
        if boolIsNumber == true {
            return true
        }
        else {
            
            if inputChar == "." {
                let countdots = textfield11.text!.components(separatedBy: ".").count - 1
                if countdots == 0 {
                    return true
                    
                } else {
                    if countdots > 0 && inputChar == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }}
}
// MARK: 🦃🧩 EXTENSIONS
extension AddFarmTurkey : UIPickerViewDelegate,UIPickerViewDataSource {
    
    // MARK: 🦃🎛️ Picker View Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (btnTag == 10) {
            if let value = HouseNo.count as? Int {
                return value
            } else {
                return 0
            }
        }else if ( btnTag == 11) {
            if let value = AgeOp.count as? Int {
                return value
            } else {
                return 0
            }
        }else if (btnTag == 12){
            if let value = NoOFbirds.count as? Int {
                return value
            } else {
                return 0
            }
            
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if btnTag == 10{
            if let value = HouseNo[row] as? String {
                return value
            } else {
                return nil
            }
        }
        else if btnTag == 11{
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
        
        if btnTag == 10{
            if let value = HouseNo[row] as? String {
                return houseNoLbl.text = value
            } else {
                return houseNoLbl.text = ""
            }
            
            
        } else if btnTag == 11 {
            if let ageCheck = AgeOp[row] as? String {
                return ageLbl.text = ageCheck
            }else {
                return ageLbl.text = ""
            }
        }
        else  {
            
            if let noOfBirdCheck = NoOFbirds[row] as? String {
                return noOfBirdsLbl.text = noOfBirdCheck
            }else {
                return noOfBirdsLbl.text = ""
            }
        }
        myPickerView.endEditing(true)
        buttonbg.removeFromSuperview()
    }
}
// MARK: - EXTENSION

extension AddFarmTurkey :UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == droperTableView {
            
            if arrayTag == 1 {
                
                return abfArray.count
                
            } else  if arrayTag == 2 {
                
                return feedProgramArray.count
            }
            else  if arrayTag == 9 {
                
                return GenerationTypeArr.count
            }
            else if arrayTag == 4 {
                
                if butttnTag1 == 0 {
                    return metricArray.count
                } else {
                    return birdArray.count
                }
            }
        } else if tableView == autoSerchTable {
            return autocompleteUrls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell ()
        
        if tableView == droperTableView {
            
            if arrayTag == 1 {
                let vet  = abfArray.object(at: indexPath.row) as! String
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = vet
                return cell
                
            }  else if arrayTag == 2 {
                
                let vet : FeedProgramTurkey = feedProgramArray.object(at: indexPath.row) as! FeedProgramTurkey
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = vet.feddProgramNam
                return cell
                
            } else if arrayTag == 4 {
                
                if butttnTag1 == 0 {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.textLabel!.text = metricArray[indexPath.row].birdSize
                    
                } else {
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.textLabel!.text = birdArray[indexPath.row].birdSize
                }
            }
            
            else if arrayTag == 9 {
                
                let vet : GenerationType = GenerationTypeArr.object(at: indexPath.row) as! GenerationType
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.textLabel!.text = vet.generationName
                return cell
                
            }
        } else if tableView == autoSerchTable {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
            
            if indexPath.row  < autocompleteUrls.count {
                cell.textLabel?.text = autocompleteUrls.object(at: indexPath.row) as? String
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == droperTableView {
            
            if arrayTag == 1 {
                
                let str = abfArray[indexPath.row] as! String
                abfLbl.text = str
                buttonPreddDroper()
                
            } else if arrayTag == 2 {
                let str = feedProgramArray[indexPath.row] as! FeedProgramTurkey
                feedProgramDisplayLabel.text = str.feddProgramNam
                feedId = str.feedId as! Int
                buttonPreddDroper()
                
            }
            else if arrayTag == 9 {
                
                let str = GenerationTypeArr[indexPath.row] as! GenerationType
                genLbl.text = str.generationName
                geneId = str.generationId as! Int
                buttonPreddDroper()
                
            }
            
            else if arrayTag == 4 {
                
                indexOfSelectedPerson = indexPath.row
                valueStore = true
            }
            buttonPreddDroper()
            
        } else if tableView == autoSerchTable {
            farmNameTextField.text = autocompleteUrls.object(at: indexPath.row) as? String
            autoSerchTable.alpha = 0
            farmNameTextField.endEditing(true)
            buttonDroper.alpha = 0
        }
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


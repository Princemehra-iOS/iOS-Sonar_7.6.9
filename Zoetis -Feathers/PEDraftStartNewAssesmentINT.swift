//
//  PEDraftStartNewAssesmentINT.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 09/01/23.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

class PEDraftStartNewAssesmentINT: BaseViewController {
    
    
    
    @IBOutlet weak var clorineBtn: customButton!
    
    @IBOutlet weak var clorineTxtFld: PEFormTextfield!
    @IBOutlet weak var clorineViewHeightConstranit: NSLayoutConstraint!
    
    var selectedClorineId : Int = 0
    @IBOutlet weak var isAutomaticLocal: PEFormLabel!
    @IBOutlet weak var extendedPELbl: PEFormLabel!
    
    @IBOutlet weak var extendedPEBtn: UIButton!
    var extendedPESwitch = Bool()
    @IBOutlet weak var flockAgeLbl: PEFormLabel!
    var isFromTextEditing = false
    
    @IBOutlet weak var chlorineStripsSwitch: UISwitch!
    @IBOutlet weak var isAutomaticFailView: UIView!
    @IBOutlet weak var isAutomaticSwitch: UISwitch!
    @IBOutlet weak var isAutomaticHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var otherManuHeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightFlockAge: NSLayoutConstraint!
    @IBOutlet weak var heightIncubation: NSLayoutConstraint!
    @IBOutlet weak var topBreed: NSLayoutConstraint!
    @IBOutlet weak var heightBreed: NSLayoutConstraint!
    @IBOutlet weak var selectedEvaluationDateText: UITextField!
    @IBOutlet weak var selectedCustomerText: UITextField!
    @IBOutlet weak var selectedSiteText: UITextField!
    @IBOutlet weak var selectedEvaluatorText: UITextField!
    @IBOutlet weak var selectedTSR: UITextField!
    @IBOutlet weak var selectedEvaluationType: UITextField!
    @IBOutlet weak var selectedVisitText: UITextField!
    @IBOutlet weak var customerButton: customButton!
    @IBOutlet weak var siteButton: customButton!
    @IBOutlet weak var evaluatorButton: customButton!
    @IBOutlet weak var visitButton: customButton!
    @IBOutlet weak var evaluationTypeButton: customButton!
    @IBOutlet weak var tsrButton: customButton!
    @IBOutlet weak var hatcherySwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cameraSwitch: UISwitch!
    @IBOutlet weak var evaluationDateButton: customButton!
    @IBOutlet weak var labelEvaluationDate: PEFormLabel!
    @IBOutlet weak var labelCustomer: PEFormLabel!
    @IBOutlet weak var labelSite: PEFormLabel!
    @IBOutlet weak var labelEvaluationType: PEFormLabel!
    @IBOutlet weak var labelReasonForVisit: PEFormLabel!
    @IBOutlet weak var labelApprover: PEFormLabel!
    @IBOutlet weak var labelEvaluator: PEFormLabel!
    @IBOutlet weak var btnNext: PESubmitButton!
    @IBOutlet weak var viewForGradient: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var inovoBtn: UIButton!
    
    @IBOutlet weak var basicBtn: UIButton!
    
    @IBOutlet weak var breedOtherView: UIView!
    @IBOutlet weak var manufactureOtherView: UIView!
    
    @IBOutlet weak var manufacturerButton: customButton!
    @IBOutlet weak var txtManufacturer: PEFormTextfield!
    
    @IBOutlet weak var txtNumberOfEggs: PEFormTextfield!
    @IBOutlet weak var numberOfEggsButton: customButton!
    var switchA = 0
    var switchB = 0
    var isFirstTime: Bool?
    var peHeaderViewController:PEHeaderViewController!
    var peNewAssessment:PENewAssessment!
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    var jsonRe : JSON = JSON()
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var isFlockAgeGreaterTheAllProd : Bool = false
    var isFlockAgeGreaterThen50Weeks : Bool = false
    var constantToSave : String = "S"
    @IBOutlet weak var btnFlockAgeGreater: UIButton!
    @IBOutlet weak var btnFlockImageLower: UIButton!
    @IBOutlet weak var flockView: UIView!
    @IBOutlet weak var flockAgeLower: UILabel!
    var isFromBack : Bool = false
    @IBOutlet weak var btnBreed: customButton!
    @IBOutlet weak var btnBreedOthers: customButton!
    @IBOutlet weak var btnIncubation: customButton!
    @IBOutlet weak var btnIncubationOthers: customButton!
    @IBOutlet weak var txtBreedOfBird: PEFormTextfield!
    @IBOutlet weak var txtBreedOfBirdsOthers: PEFormTextfield!
    @IBOutlet weak var txtIncubation: PEFormTextfield!
    @IBOutlet weak var txtIncubationOthers: PEFormTextfield!
    @IBOutlet weak var manfacturerOtherBtn: customButton!
    
    @IBOutlet weak var manfacturerOtherTxt: PEFormTextfield!
    
    @IBOutlet weak var eggsOtherBtn: customButton!
    
    @IBOutlet weak var eggsOtherTxt: PEFormTextfield!
    
    @IBOutlet weak var notesTop: NSLayoutConstraint!
    @IBOutlet weak var heightManufacturerView: NSLayoutConstraint!
    @IBOutlet weak var heightNumberOfEggsView: NSLayoutConstraint!
    
    @IBOutlet weak var manuBreedHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otherEggsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelCountry: PEFormLabel!
    @IBOutlet weak var countryBtn: customButton!
    
    @IBOutlet weak var countryTxt: PEFormTextfield!
    
    @IBOutlet weak var otherManuLbl: PEFormLabel!
    
    @IBOutlet weak var otherBreedLbl: PEFormLabel!
    
    @IBOutlet weak var otherBreedHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otherBreedWidthConst: NSLayoutConstraint!
    
    @IBOutlet weak var manefacOtherHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var manufactOtherWidthConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var manuFacMainOtherStack: UIStackView!
    
    
    @IBOutlet weak var flockAgeLblConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var allProductionLbl: PEFormLabel!
    @IBOutlet weak var allProductionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var isAutomaticWidth: NSLayoutConstraint!
    var regionID = Int()
    var inovoPESwitch = Bool()
    var basicPESwitch = Bool()
    var selectedCountryId : Int = 0
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        self.hideManufacturerOthers()
        
        self.hideBreedOthers()
        self.hideEggsOthers()
        self.visitButton.isUserInteractionEnabled = false
        setupUI()
        self.manfacturerOtherTxt.delegate = self
        self.eggsOtherTxt.delegate = self
        self.eggsOtherTxt.keyboardType = .numberPad
        
        let dateFormatter = DateFormatter()
     
        if regionID != 3 {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        else{
            dateFormatter.dateFormat="MM/dd/yyyy"
        }
        let currentDate: NSDate = NSDate()
        let strdate1 = dateFormatter.string(from: currentDate as Date) as String
        self.cameraSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.hatcherySwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        
        notesTextView.delegate = self
        notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notesTextView.textContainer.lineFragmentPadding = 12
        notesTextView.text = ""
        
        peNewAssessment = CoreDataHandlerPE().getSavedDraftOnGoingAssessmentPEObject()
        
        notesTextView.text =  peNewAssessment.notes
        selectedCustomerText.text = peNewAssessment.customerName
        selectedSiteText.text =  peNewAssessment.siteName
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Draft Assessment"
        peHeaderViewController.assId = "C-\(peNewAssessment.draftID!)"
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
     
        if peNewAssessment.evaluationDate == "" {
            selectedEvaluationDateText.text = strdate1
            self.peNewAssessment.evaluationDate = strdate1
        } else {
            selectedEvaluationDateText.text = peNewAssessment.evaluationDate ?? strdate1
        }
        self.peNewAssessment.evaluationID = peNewAssessment.evaluationID
        var FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        var LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        selectedEvaluatorText.text =  peNewAssessment.evaluatorName ?? FirstName
        selectedEvaluationType.text = peNewAssessment.evaluationName ?? ""

        
        if peNewAssessment.breedOfBird == "Other"{
            showBreedOthers()
        } else {
            hideBreedOthers()
        }
        
        txtBreedOfBird.text = self.peNewAssessment.breedOfBird
        
        if let character = peNewAssessment.breedOfBird?.character(at: 1),
           character == constantToSave.character(at: 0) {
            showBreedOthers()
            let str = peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
            txtBreedOfBirdsOthers.text = str
            txtBreedOfBird.text = "Other"
        }
        
        txtBreedOfBirdsOthers.text =    self.peNewAssessment.breedOfBirdOther
        txtIncubation.text =  self.peNewAssessment.incubation
        
        
        if selectedEvaluationType.text == "" {
            debugPrint("No Evaluation type Selected")
        } else {
            if selectedEvaluationType.text?.contains("Non") ?? false  {
                self.flockAgeLower.isHidden = true
                self.btnFlockImageLower.isHidden = true
                self.heightFlockAge.constant = 78
                self.flockAgeLbl.text = "Breeder Flock Age of Eggs Injected"
            } else {
                debugPrint("Evaluation type Selected")
            }
            showFlockView()
            
        }
        
        selectedVisitText.text =  peNewAssessment.visitName ?? ""
        
        countryTxt.text = peNewAssessment.countryName ?? ""
        clorineTxtFld.text = peNewAssessment.clorineName ?? ""
        selectedClorineId = peNewAssessment.clorineId ?? 0
        selectedCountryId = peNewAssessment.countryID ?? 0
        
        if peNewAssessment.camera == 1{
            cameraSwitch.setOn(true, animated: false)
        } else {
            cameraSwitch.setOn(false, animated: false)
        }
        if peNewAssessment.hatcheryAntibiotics == 1{
            hatcherySwitch.setOn(true, animated: false)
        } else {
            hatcherySwitch.setOn(false, animated: false)
        }
        
        labelEvaluationDate.addLabelWithAstric(placeHolder: "Evaluation Date")
        labelCustomer.addLabelWithAstric(placeHolder: "Customer")
        labelSite.addLabelWithAstric(placeHolder: "Site")
        labelEvaluationType.addLabelWithAstric(placeHolder: "Evaluation Type")
        labelReasonForVisit.addLabelWithAstric(placeHolder: "Reason for visit")
        labelEvaluator.addLabelWithAstric(placeHolder: "Evaluator")
        FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        peNewAssessment.evaluatorName =  FirstName
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        peNewAssessment.evaluatorID = userID
        if peNewAssessment.selectedTSR?.count ?? 0 > 1 {
            selectedTSR.text = peNewAssessment.selectedTSR
        } else {
            
            
        }
        
      
        if  peNewAssessment.selectedTSR?.count ?? 0 < 1 {
            let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
            let visitNameArray = visitDetailsArray.value(forKey: "username") as! NSArray
            let visitIDArray = visitDetailsArray.value(forKey: "id") as! NSArray
            if peNewAssessment.selectedTSR?.count ?? 0 > 1 {
                selectedTSR.text = peNewAssessment.selectedTSR
            } else {
                for (index,obj) in visitIDArray.enumerated() {
                    if let id = obj as? Int {
                        if id == userID {
                            
                            selectedTSR.text = visitNameArray[index] as? String ?? ""
                            peNewAssessment.selectedTSR = visitNameArray[index] as? String ?? ""
                            peNewAssessment.selectedTSRID = id
                        }
                    }
                }
            }
        } else {
            debugPrint("No selected TSR..")
        }
        
        hideManufacturerOthers()
        hideEggsOthers()
        
        txtManufacturer.text = self.peNewAssessment.manufacturer ?? ""
        if  txtManufacturer.text != "" {
            if let character = peNewAssessment.manufacturer?.character(at:0) {
                if txtManufacturer.text == "Other"{
                    showManufacturerOthers()
                }
                
                if character == constantToSave.character(at: 0){
                    showManufacturerOthers()
                    let str =  peNewAssessment.manufacturer?.replacingOccurrences(of: constantToSave, with: "")
                    manfacturerOtherTxt.text = str
                    txtManufacturer.text = "Other"
                    showManufacturerOthers()
                }
            }
        }
        
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                showEggsOthers()
                let str =  xx.replacingOccurrences(of: "000", with: "")
                eggsOtherTxt.text = str
                txtNumberOfEggs.text = "Other"
            }
        }
        
        if peNewAssessment.isFlopSelected == 1 ||  peNewAssessment.isFlopSelected == 3 ||  peNewAssessment.isFlopSelected == 4 {
            DispatchQueue.main.async {
                self.isFlockAgeGreaterTheAllProd = true
                self.btnFlockAgeGreater.setImage(UIImage(named: "checkIconPE"), for: .normal)
                self.isFlockAgeGreaterThen50Weeks = false
                self.btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            }
            
        } else  if peNewAssessment.isFlopSelected == 2 ||  peNewAssessment.isFlopSelected == 5  {
            DispatchQueue.main.async {
                self.isFlockAgeGreaterTheAllProd = false
                self.btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
                self.isFlockAgeGreaterThen50Weeks = true
                self.btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
            }
        }
        
        if peNewAssessment.fluid == true {
            inovoPESwitch = true
            inovoBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else  {
            inovoPESwitch = false
            inovoBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        if peNewAssessment.basicTransfer == true {
            basicPESwitch = true
            basicBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else  {
            basicPESwitch = false
            basicBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        
        if peNewAssessment.extndMicro == true {
            extendedPESwitch = true
            extendedPEBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else  {
            extendedPESwitch = false
            extendedPEBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        var  peNewAssessmentArray = CoreDataHandlerPE().getOnGoingDraftAssessmentArrayPEObject()
        for obj in peNewAssessmentArray {
            var assessment = obj as? PENewAssessment
            let imageCount = assessment?.images as? [Int]
            if imageCount?.count ?? 0 > 0 {
                cameraSwitch.isUserInteractionEnabled = false
                cameraSwitch.alpha = 0.6
            }
        }
        
        if peNewAssessment.clorineName == "" || peNewAssessment.clorineName == nil{
            
            isAutomaticFailView.isHidden = true
            clorineViewHeightConstranit.constant = 60
            isAutomaticSwitch.isHidden = true
        }else{
            if peNewAssessment.isAutomaticFail == 1{
                self.isAutomaticSwitch.setOn(true, animated: false)
                isAutomaticFailView.isHidden = false
                clorineViewHeightConstranit.constant = 120
                peNewAssessment.isAutomaticFail = 1
            }else{
                
                self.isAutomaticSwitch.setOn(false, animated: false)
                clorineViewHeightConstranit.constant = 120
                isAutomaticSwitch.isHidden = false
                peNewAssessment.isAutomaticFail =  0
            }
        }
        
        checkBackAndSave()
        if peNewAssessment.selectedTSRID == nil || peNewAssessment.selectedTSRID == 0{
            tsrButton.isUserInteractionEnabled = true
            selectedTSR.alpha = 1
        }else {
            selectedTSR.text = peNewAssessment.selectedTSR
            tsrButton.isUserInteractionEnabled = false
            selectedTSR.isUserInteractionEnabled = false
            selectedTSR.alpha = 0.6
        }
        
    }
    
    
    func assignConstraint(otherEgg:Int = 0){
        let leftConst = leftConstraint()
        var rightConst = rightConstraint()
        if rightConst == 3 {
            rightConst = 2
        }
        
        switch leftConst {
        case 0:
            switch rightConst {
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(leftConst * 55 + 30)
                }else{
                    notesTop.constant = CGFloat(leftConst * 55  + 40 )
                }
            case 2:
                notesTop.constant = CGFloat(leftConst * 55  + 20)
            default:
                notesTop.constant = CGFloat(leftConst * 55  + 100)
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(leftConst * 55  + 40)
                }
            }
        case 1:
            switch rightConst {
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    if heightManufacturerView.constant == 94{
                        notesTop.constant = CGFloat(leftConst * 55  - 20)
                    }else{
                        notesTop.constant = CGFloat(leftConst * 55 + 20)
                    }
                }else{
                    notesTop.constant = CGFloat(leftConst * 55 + 20)
                }
            case 2:
                notesTop.constant = CGFloat(leftConst * 55  - 20)
            default:
                
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(leftConst * 55  + 20)
                }else{
                    notesTop.constant = CGFloat(leftConst * 55  + 75)
                }
            }
        case 2:
            switch rightConst {
                
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    if heightManufacturerView.constant == 94{
                        notesTop.constant = CGFloat(leftConst * 55 - 75)
                    }else{
                        notesTop.constant = CGFloat(leftConst * 55  - 35)
                    }
                }else{
                    notesTop.constant = CGFloat(leftConst * 55 - 30)
                }
            case 2:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(leftConst * 55 - 85)
                }
            default:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(leftConst * 55 - 30)
                }else{
                    notesTop.constant = CGFloat(leftConst * 55  + 20)
                }
            }
        default:
            break;
        }
        
    }
    
    func leftConstraint() -> Int{
        var otherCount = 0
        if peNewAssessment.breedOfBird == "Other"{
            otherCount += 1
        }
        if peNewAssessment.evaluationID != nil && peNewAssessment.evaluationID == 1{
            otherCount += 1
        }
        return otherCount
    }
    
    func rightConstraint()-> Int{
        var otherCount = 0
        
        if ((self.txtManufacturer.text?.lowercased().contains("other")) ?? false) {
            otherCount += 1
        } else if self.txtManufacturer.text?.contains("S") ?? false {
            otherCount += 1
        }
        
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                otherCount += 1
            }
        }
        return otherCount
    }
    
    
    
    func showExtendedPE(flag:Bool = false){
        
    }
    
    func enableExtendedPE(flag:Bool = true){
    }
    
    
    func hideFlockView(){
        flockView.isHidden = true
        heightFlockAge.constant = 0
    }
    func showFlockView(){
    }
    
    
    func setupUI(){
        btnNext.setNextButtonUI()
        viewForGradient.setGradientThreeColors(topGradientColor: UIColor.getGradientUpperColorStartAssessment(),midGradientColor:UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientUpperColorStartAssessmentLast())
        
        let btns = [customerButton,siteButton,evaluatorButton,visitButton,evaluationTypeButton,tsrButton,evaluationDateButton,btnBreed,btnBreedOthers,btnIncubation,manufacturerButton,numberOfEggsButton,countryBtn ,manfacturerOtherBtn,eggsOtherBtn , clorineBtn]
        
        self.customerButton.isUserInteractionEnabled = false
        self.siteButton.isUserInteractionEnabled = false
        self.evaluatorButton.isUserInteractionEnabled = false
        self.countryBtn.isUserInteractionEnabled = false
        self.customerButton.isEnabled = false
        self.siteButton.isEnabled = false
        self.evaluatorButton.isEnabled = false
        self.visitButton.isUserInteractionEnabled = false
        self.evaluationTypeButton.isUserInteractionEnabled = false
        self.selectedEvaluationType.alpha = 0.6
        
        self.selectedCustomerText.alpha = 0.6
        self.selectedSiteText.alpha = 0.6
        self.selectedEvaluatorText.alpha = 0.6
        self.countryTxt.alpha = 0.6
        self.selectedVisitText.alpha = 0.6
        if self.isFromBack {
            self.evaluationTypeButton.isUserInteractionEnabled = false
            self.evaluationTypeButton.isEnabled = false
            self.selectedEvaluationType.alpha = 0.6
            self.evaluationDateButton.isUserInteractionEnabled = false
            self.evaluationDateButton.isEnabled = false
            self.selectedEvaluationDateText.alpha = 0.6
        }
        for btn in btns{
            btn?.setTitle("", for: .normal)
            let superviewCurrent =  btn?.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        if view == evaluationDateButton{
                            view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
                        } else{
                            view.setDropdownStartAsessmentView(imageName:"dd")
                        }
                    }
                }
            }
        }
        notesTextView.layer.cornerRadius = 12
        notesTextView.layer.masksToBounds = true
        notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notesTextView.layer.borderWidth = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        if self.peNewAssessment.hatcheryAntibiotics == 1{
            self.hatcherySwitch.isOn = true
        } else{
            self.hatcherySwitch.isOn = false
        }
        if peNewAssessment.selectedTSRID == nil || peNewAssessment.selectedTSRID == 0{
            tsrButton.isUserInteractionEnabled = true
            selectedTSR.alpha = 1
        } else {
            selectedTSR.text = peNewAssessment.selectedTSR
            tsrButton.isUserInteractionEnabled = false
            selectedTSR.isUserInteractionEnabled = false
            selectedTSR.alpha = 0.6
        }
        
        if let character = peNewAssessment.breedOfBird?.character(at: 1) {
            if character == constantToSave.character(at: 0){
                showBreedOthers()
                let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
                txtBreedOfBirdsOthers.text = str
                txtBreedOfBird.text = "Other"
            }
        }
        if peNewAssessment.breedOfBird == "Other"{
            showBreedOthers()
        } else {
            hideBreedOthers()
        }
        
        txtBreedOfBird.text = self.peNewAssessment.breedOfBird
        if let character = peNewAssessment.breedOfBird?.character(at: 1) {
            if character == constantToSave.character(at: 0){
                showBreedOthers()
                let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
                txtBreedOfBirdsOthers.text = str
                txtBreedOfBird.text = "Other"
            }
        }
        txtBreedOfBirdsOthers.text =    self.peNewAssessment.breedOfBirdOther
        
        hideManufacturerOthers()
        hideEggsOthers()
        txtManufacturer.text = self.peNewAssessment.manufacturer ?? ""
        if  txtManufacturer.text != "" {
            if let character = peNewAssessment.manufacturer?.character(at:0) {
                if txtManufacturer.text == "Other"{
                    showManufacturerOthers()
                }
                
                if character == constantToSave.character(at: 0){
                    showManufacturerOthers()
                    let str =  peNewAssessment.manufacturer?.replacingOccurrences(of: constantToSave, with: "")
                    manfacturerOtherTxt.text = str
                    txtManufacturer.text = "Other"
                    showManufacturerOthers()
                }
            }
        }
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                showEggsOthers()
                let str =  xx.replacingOccurrences(of: "000", with: "")
                eggsOtherTxt.text = str
                txtNumberOfEggs.text = "Other"
            }else{
                txtNumberOfEggs.text = last3
            }
        }
        
        
        if self.peNewAssessment.fluid == true{
            self.inovoPESwitch = true//hatcherySwitch.isOn
            inovoBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else{
            self.inovoPESwitch = false
            inovoBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        if self.peNewAssessment.basicTransfer == true{
            self.basicPESwitch = true//hatcherySwitch.isOn
            basicBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else{
            self.basicPESwitch = false
            basicBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        if peNewAssessment.extndMicro == true {
            extendedPESwitch = true
            extendedPEBtn.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else  {
            extendedPESwitch = false
            extendedPEBtn.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0].peNewAssessment = peNewAssessment
    }
    
    private func getAllDateArrayStored() -> [String]{
        
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject()
        var dates : [String] = []
        var coustomers : [String] = []
        var sites : [String] = []
        for obj in drafts {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        let syncData =  CoreDataHandlerPE().getOfflineAssessmentArrayPEObject()
        for obj in syncData {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        return dates
    }
    
    private func getAllCustomerArrayStored() -> [String]{
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject()
        var dates : [String] = []
        var coustomers : [String] = []
        var sites : [String] = []
        for obj in drafts {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        let syncData =  CoreDataHandlerPE().getOfflineAssessmentArrayPEObject()
        for obj in syncData {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        return coustomers
    }
    
    private func getAllSitesArrayStored() -> [String]{
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject()
        var dates : [String] = []
        var coustomers : [String] = []
        var sites : [String] = []
        for obj in drafts {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        let syncData =  CoreDataHandlerPE().getOfflineAssessmentArrayPEObject()
        for obj in syncData {
            dates.append(obj.evaluationDate ?? "")
            coustomers.append(obj.customerName ?? "")
            sites.append(obj.siteName ?? "")
        }
        return sites
    }
    
    @IBAction func manufacutrerClicked(_ sender: Any) {
        
        let superviewCurrent =  manufacturerButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }

        var manufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Manufacturer")
        var manufacutrerNameArray = manufacutrerDetailsArray.value(forKey: "mFG_Name") as? NSArray ?? NSArray()
        var manufacutrerIDArray = manufacutrerDetailsArray.value(forKey: "mFG_Id") as? NSArray ?? NSArray()
        if  manufacutrerNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: manufacutrerNameArray as? [String] ?? [String](), kWidth: btnIncubation.frame.width, kAnchor: btnIncubation, yheight: btnIncubation.bounds.height) { [unowned self] selectedVal, index  in
                self.txtManufacturer.text = selectedVal
                self.peNewAssessment.manufacturer = self.txtManufacturer.text ?? ""
                self.checkBackAndSave()
                if self.peNewAssessment.manufacturer == "Other"{
                    self.showManufacturerOthers()
                } else {
                    self.hideManufacturerOthers()
                }
                if selectedVal == "Other"{
                    
                    self.txtManufacturer.text = selectedVal
                    self.manfacturerOtherTxt.text = ""
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func numberOfEggsClicked(_ sender: Any) {
        let superviewCurrent =  numberOfEggsButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
  
        var EggsDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Eggs")
        var EggsNameArray = EggsDetailsArray.value(forKey: "eggCount") as? NSArray ?? NSArray()
        
        if  EggsNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: EggsNameArray as? [String] ??  [String](), kWidth: txtNumberOfEggs.frame.width, kAnchor: txtNumberOfEggs, yheight: txtNumberOfEggs.bounds.height) { [unowned self] selectedVal, index  in
                self.txtNumberOfEggs.text = selectedVal
                if selectedVal == "Other"{
                    self.peNewAssessment.noOfEggs = 0//Int64(0)
                    self.eggsOtherTxt.text = ""
                    self.showEggsOthers()
                    
                } else {
                    self.hideEggsOthers()
                    self.peNewAssessment.noOfEggs = Int64(self.txtNumberOfEggs.text ?? "")
                    
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
    }
    
    func hideBreedOthers(){
        
        
        if manfacturerOtherBtn.isHidden{
            manufactureOtherView.isHidden = true
            breedOtherView.isHidden = true
            otherManuHeightConst.constant = 0
        }
        btnBreedOthers.isHidden = true
        txtBreedOfBirdsOthers.isHidden = true
        
    }
    func showBreedOthers(){
        
        otherManuHeightConst.constant = 60
        breedOtherView.isHidden = false
        manufactureOtherView.isHidden = false
        btnBreedOthers.isHidden = false
        txtBreedOfBirdsOthers.isHidden = false
    }
    func hideIncubationOthers(){
        btnIncubationOthers.isHidden = true
        txtIncubationOthers.isHidden = true
    }
    func showIncubationOthers(){
        btnIncubationOthers.isHidden = false
        txtIncubationOthers.isHidden = false
    }
    
    
    func hideManufacturerOthers(){
        if btnBreedOthers.isHidden{
            manufactureOtherView.isHidden = true
            breedOtherView.isHidden = true
            otherManuHeightConst.constant = 0
        }
        
        manfacturerOtherBtn.isHidden = true
        manfacturerOtherTxt.isHidden = true
        self.view.layoutIfNeeded()
        
    }
    
    func showManufacturerOthers(){
        
        otherManuHeightConst.constant = 60
        manufactureOtherView.isHidden = false
        manfacturerOtherBtn.isHidden = false
        manfacturerOtherTxt.isHidden = false
        breedOtherView.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func hideEggsOthers(){
        eggsOtherBtn.isHidden = true
        eggsOtherTxt.isHidden = true
        otherEggsHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func showEggsOthers(){
        
        eggsOtherBtn.isHidden = false
        eggsOtherTxt.isHidden = false
        otherEggsHeightConstraint.constant = 60
        btnIncubationOthers.isHidden = true
        txtIncubationOthers.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    
    func fromBackNextBtnAction  () {
        self.checkBackAndSave()
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
        UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        UserDefaults.standard.synchronize()
        if extendedPESwitch{
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
            
            if sanitationQuesArr.count == 0{
                SanitationEmbrexQuestionMasterDAO.sharedInstance.saveAssessmentQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
            }
            
        }
        
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        return
        
    }
    
    func showOnlyExtendedMicrobial(){
        
        self.fromBackNextBtnAction()
        
    }
    
    private func getVaccineMixerList(customerId: Int, siteId: Int, countryId: Int, _ completion: @escaping (_ status: Bool) -> Void){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Mixer...")
        let parameter = [
            "siteId": "\(siteId)",
            "customerId": "\(customerId)",
            "countryId": "\(countryId)"
        ] as JSONDictionary
        ZoetisWebServices.shared.getMixerList(controller: self, parameters: parameter) { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleVaccineMixer(json)
        }
    }
    private func handleVaccineMixer(_ json: JSON) {
        self.deleteAllData("PE_VaccineMixerDetail")
        VaccineMixerResponse(json)
        self.dismissGlobalHUD(self.view ?? UIView())
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        self.getVaccineMixerList(customerId: self.peNewAssessment.customerId ?? 0, siteId: self.peNewAssessment.siteId ?? 0, countryId: 40) { [self] status in
        }
        
        guard let date = self.peNewAssessment.evaluationDate, date.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        guard let site = self.peNewAssessment.siteName, site.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        guard let evaluationName = self.peNewAssessment.evaluationName, evaluationName.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        guard let evaluator = self.peNewAssessment.evaluatorName, evaluator.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        guard let reasonForVisit = self.peNewAssessment.visitName, reasonForVisit.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        
        if peNewAssessment.breedOfBird != nil && peNewAssessment.breedOfBird != ""{
            if ((peNewAssessment.breedOfBird?.lowercased().contains("other")) ?? false) {
                if peNewAssessment.breedOfBirdOther != nil && peNewAssessment.breedOfBirdOther != "" {
                    
                }else{
                    changeMandatorySuperviewToRed()
                    return
                }
            }
        }else{
            changeMandatorySuperviewToRed()
            return
        }
        
        if self.txtManufacturer.text != nil && self.txtManufacturer.text != ""{
            if ((self.txtManufacturer.text?.lowercased().contains("other")) ?? false) {
                if manfacturerOtherTxt.text != nil && manfacturerOtherTxt.text != "" {
                    
                }else{
                    changeMandatorySuperviewToRed()
                    return
                }
            }
        }else{
            changeMandatorySuperviewToRed()
            return
        }
        
        if peNewAssessment.incubation != nil && peNewAssessment.incubation != ""{
            
        }else{
            changeMandatorySuperviewToRed()
            return
        }
        
        if txtNumberOfEggs.text != nil && txtNumberOfEggs.text != ""{
            if ((txtNumberOfEggs.text?.lowercased().contains("other")) ?? false) {
                if eggsOtherTxt.text != nil && eggsOtherTxt.text != "" {
                    
                }else{
                    changeMandatorySuperviewToRed()
                    return
                }
            }
        }else{
            changeMandatorySuperviewToRed()
            return
        }
        
        if isFromBack {
            
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
            if sanitationQuesArr.count == 0 && extendedPESwitch{
                self.showOnlyExtendedMicrobial()
                
            } else{
                self.fromBackNextBtnAction()
            }
            
        } else {
            self.okButtonTapped()
        }
    }
    
    func saveAssessmentInProgressDataInDB()  {
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1
        } else {
            peNewAssessment.hatcheryAntibiotics = 0
        }
        if cameraSwitch.isOn{
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        if let notesTxt = notesTextView.text , notesTxt.count > 0 {
            peNewAssessment.notes =   notesTxt
        }
        var FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        self.peNewAssessment.incubation = txtIncubation.text
        self.peNewAssessment.incubationOthers = txtIncubationOthers.text
        
        self.peNewAssessment.countryName = countryTxt.text
        self.peNewAssessment.fluid = inovoPESwitch
        self.peNewAssessment.basicTransfer = basicPESwitch
        self.peNewAssessment.countryID = selectedCountryId
        self.peNewAssessment.extndMicro = extendedPESwitch
        self.peNewAssessment.clorineId = selectedClorineId
        self.peNewAssessment.clorineName = clorineTxtFld.text
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        self.peNewAssessment.userID = userID
        CoreDataHandlerPE().updateDraftAssessmentInProgressInDB(newAssessment: self.peNewAssessment)
    }
    
    func saveBackAssessmentInProgressDataInDB()  {
        
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1
        } else {
            peNewAssessment.hatcheryAntibiotics = 0
        }
        if cameraSwitch.isOn{
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        
        if let notesTxt = notesTextView.text , notesTxt.count > 0 {
            peNewAssessment.notes =   notesTxt
        }
        let firstNameIs =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        var FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        var LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        self.peNewAssessment.incubation = txtIncubation.text
        self.peNewAssessment.incubationOthers = txtIncubationOthers.text
        
        self.peNewAssessment.countryName = countryTxt.text
        self.peNewAssessment.fluid = inovoPESwitch
        self.peNewAssessment.basicTransfer = basicPESwitch
        self.peNewAssessment.countryID = selectedCountryId
        self.peNewAssessment.extndMicro = extendedPESwitch
        self.peNewAssessment.clorineId = selectedClorineId
        self.peNewAssessment.clorineName = clorineTxtFld.text
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        self.peNewAssessment.userID = userID
        CoreDataHandlerPE().updateDraftAlreadyInProgressInDB(newAssessment: self.peNewAssessment)
        
    }
    
    private func saveDraftData(){
        var allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentIDraftInProgress") as? [PE_AssessmentIDraftInProgress]
        var count = 0
        finishSession()
    }
    
    func finishSession()  {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
    }
    
    
    func changeMandatorySuperviewToRed(){
        let date = self.peNewAssessment.evaluationDate ?? ""
        let customer = self.peNewAssessment.customerName ?? ""
        let site = self.peNewAssessment.siteName ?? ""
        let evaluationName = self.peNewAssessment.evaluationName ?? ""
        let evaluator = self.peNewAssessment.evaluatorName ?? ""
        let reasonForVisit = self.peNewAssessment.visitName ?? ""
        
        if peNewAssessment.breedOfBird != nil && peNewAssessment.breedOfBird != ""{
            if ((peNewAssessment.breedOfBird?.lowercased().contains("other")) ?? false) {
                if peNewAssessment.breedOfBirdOther != nil && peNewAssessment.breedOfBirdOther != "" {
                    
                    let superviewCurrent =  btnBreedOthers.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                    
                }else{
                    let superviewCurrent =  btnBreedOthers.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.red.cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                }
            }
        }else{
            let superviewCurrent =  btnBreed.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        if  self.txtManufacturer.text != nil && self.txtManufacturer.text != ""{
            if ((self.txtManufacturer.text?.lowercased().contains("other")) ?? false) {
                if manfacturerOtherTxt.text != nil && manfacturerOtherTxt.text != "" {
                    let superviewCurrent =  manfacturerOtherBtn.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                }else{
                    let superviewCurrent =  manfacturerOtherBtn.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.red.cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                }
            }
        }else{
            let superviewCurrent =  manufacturerButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        if peNewAssessment.incubation != nil && peNewAssessment.incubation != ""{
            let superviewCurrent =  btnIncubation.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
                
            }
        }else{
            let superviewCurrent =  btnIncubation.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        if txtNumberOfEggs.text != nil && txtNumberOfEggs.text != ""{
            if ((txtNumberOfEggs.text?.lowercased().contains("other")) ?? false) {
                if eggsOtherTxt.text != nil && eggsOtherTxt.text != "" {
                    
                    let superviewCurrent =  eggsOtherBtn.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                    
                }else{
                    let superviewCurrent =  eggsOtherBtn.superview
                    if superviewCurrent != nil {
                        for view in superviewCurrent!.subviews {
                            if view.isKind(of:UIButton.self) {
                                view.layer.borderColor = UIColor.red.cgColor
                                view.layer.borderWidth = 2.0
                            }
                        }
                    }
                }
            }
        }else{
            let superviewCurrent =  numberOfEggsButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        if (date.count > 0 ?? 0){} else  {
            let superviewCurrent =  evaluationDateButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (customer.count > 0 ?? 0 ){} else  {
            let superviewCurrent =  customerButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                        
                    }}
            }
        }
        if (site.count > 0 ?? 0){} else  {
            let superviewCurrent =  siteButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (evaluationName.count ?? 0 > 0){} else  {
            let superviewCurrent =  evaluationTypeButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (evaluator.count ?? 0  > 0){} else  {
            let superviewCurrent =  evaluatorButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (reasonForVisit.count ?? 0 > 0){} else  {
            let superviewCurrent =  visitButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        showAlert(title: "Alert", message: "Please enter details in all the fields marked as mandatory.", owner: self)
        
    }
    
    @IBAction func evaluationDateClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        let superviewCurrent =  evaluationDateButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Selection", bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier: "DatePickerPopupViewController") as? DatePickerPopupViewController
        datePickerPopupViewController?.delegate = self
        datePickerPopupViewController?.canSelectPreviousDate = true
        if datePickerPopupViewController != nil{
            navigationController?.present(datePickerPopupViewController!, animated: false, completion: nil)
        }
        
        
    }
    
    //Customer Company is same
    @IBAction func customerClicked(_ sender: Any) {
        let superviewCurrent =  customerButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        var customerNamesArray = NSArray()
        var customerIDArray = NSArray()
        var customerDetailsArray = NSArray()
        customerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Customer")
        customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray()
        customerIDArray = customerDetailsArray.value(forKey: "customerID") as? NSArray ?? NSArray()
        if  customerNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: customerNamesArray as? [String] ?? [String](), kWidth: customerButton.frame.width, kAnchor: customerButton, yheight: customerButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedCustomerText.text = selectedVal
                self.selectedSiteText.text = ""
                let indexOfItem = customerNamesArray.index(of: selectedVal)
                self.peNewAssessment.customerName = selectedVal
                self.peNewAssessment.siteName = ""
                self.peNewAssessment.customerId = customerIDArray[indexOfItem] as? Int
                let cusId = self.peNewAssessment.customerId ?? 0
                
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK:   ********* Country Button Clicked    *********
    @IBAction func countryBtnClicked(_ sender: Any) {
        let superviewCurrent =  countryBtn.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.lightGray.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            //   showtoast(message: "Select Customer")
            return
        }
        var countryIDArray = NSArray()
        var countryNameArray = NSArray()
        let countryDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "AllCountriesPE")
        countryNameArray = countryDetailsArray.value(forKey: "countryName") as? NSArray ?? NSArray()
        countryIDArray = countryDetailsArray.value(forKey: "countryId") as? NSArray ?? NSArray()
        
        if  countryNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: countryNameArray as? [String] ?? [String](), kWidth: countryBtn.frame.width, kAnchor: countryBtn, yheight: countryBtn.bounds.height) { [unowned self] selectedVal, index in
                self.countryTxt.text = selectedVal
                self.peNewAssessment.countryName = selectedVal
                let indexOfItem = countryNameArray.index(of: selectedVal)
                self.peNewAssessment.countryID = countryIDArray[indexOfItem] as? Int
                selectedCountryId = countryIDArray[indexOfItem] as? Int ?? 0
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        } else{
            //   showtoast(message: "No Sites Found")
        }
    }
    
    // MARK:   ********* Inovo Button Clicked    *********
    @IBAction func inovoBtn(_ sender: UIButton) {
        
        
        if inovoPESwitch == false {
            inovoPESwitch = true
            sender.setImage(UIImage(named: "checkIconPE"), for: .normal)
        }
        
        else{
            inovoPESwitch = false
            sender.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        
        peNewAssessment.fluid = inovoPESwitch
        self.checkBackAndSave()
        //
    }
    // MARK:   ********* Basic Button Clicked    *********
    @IBAction func basicTransferBtn(_ sender: UIButton) {
        if basicPESwitch == false {
            basicPESwitch = true
            sender.setImage(UIImage(named: "checkIconPE"), for: .normal)
        }
        
        else{
            basicPESwitch = false
            sender.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        peNewAssessment.basicTransfer = basicPESwitch
        self.checkBackAndSave()
        
    }
    
    // MARK:   ********* Site Button Clicked    *********
    @IBAction func siteClicked(_ sender: Any) {
        
        let superviewCurrent =  siteButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.lightGray.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            return
        }
        var complexNamesArray = NSArray()
        var complexDetailsArray = NSArray()
        var complexIDArray = NSArray()
        complexDetailsArray = CoreDataHandlerPE().fetchSitesWithCustId( self.peNewAssessment.customerId as NSNumber? ?? 0)
        complexNamesArray = complexDetailsArray.value(forKey: "siteName") as? NSArray ?? NSArray()
        complexIDArray = complexDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if  complexNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: complexNamesArray as? [String] ?? [String](), kWidth: siteButton.frame.width, kAnchor: siteButton, yheight: siteButton.bounds.height) { [unowned self] selectedVal, index in
                self.selectedSiteText.text = selectedVal
                self.peNewAssessment.siteName = selectedVal
                let indexOfItem = complexNamesArray.index(of: selectedVal)
                self.peNewAssessment.siteId = complexIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        } else{
        }
    }
    // MARK:   ********* Evaluator Button Clicked    *********
    @IBAction func evaluatorClicked(_ sender: Any) {
        let superviewCurrent =  evaluatorButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        var customerNamesArray = NSArray()
        var evaluatorIDArray = NSArray()
        var evaluatorNameArray = NSArray()
        var evaluatorDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Evaluator")
        evaluatorNameArray = evaluatorDetailsArray.value(forKey: "evaluatorName") as?  NSArray ?? NSArray()
        evaluatorIDArray = evaluatorDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if  evaluatorNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: evaluatorNameArray as? [String] ?? [String](), kWidth: evaluatorButton.frame.width, kAnchor: evaluatorButton, yheight: evaluatorButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedEvaluatorText.text = selectedVal
                self.peNewAssessment.evaluatorName = selectedVal
                let indexOfItem = evaluatorNameArray.index(of: selectedVal)
                self.peNewAssessment.evaluatorID = evaluatorIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK:   ********* Visit Type Button Clicked    *********
    @IBAction func visitClicked(_ sender: Any) {
        let superviewCurrent =  visitButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        var visitIDArray = NSArray()
        var visitNameArray = NSArray()
        var visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VisitTypes")
        visitNameArray = visitDetailsArray.value(forKey: "visitName") as? NSArray ?? NSArray()
        visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if  visitNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: visitNameArray as? [String] ?? [String](), kWidth: visitButton.frame.width, kAnchor: visitButton, yheight: visitButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedVisitText.text = selectedVal
                self.peNewAssessment.visitName = selectedVal
                let indexOfItem = visitNameArray.index(of: selectedVal)
                self.peNewAssessment.visitID = visitIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
                PEAssessmentsDAO.sharedInstance.updateAssessmentStatus( userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: self.peNewAssessment.serverAssessmentId ?? "", assessmentobj: self.peNewAssessment)
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK:   ********* Evaluation Button Clicked    *********
    @IBAction func evaluationClicked(_ sender: Any) {
        let superviewCurrent =  evaluationTypeButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        var evaluationIDArray = NSArray()
        var evaluationNameArray = NSArray()
        var evaluationDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_EvaluationType")
        evaluationNameArray = evaluationDetailsArray.value(forKey: "evaluationName") as? NSArray ?? NSArray()
        evaluationIDArray = evaluationDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if  evaluationNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: evaluationNameArray as? [String] ?? [String](), kWidth: evaluationTypeButton.frame.width, kAnchor: evaluationTypeButton, yheight: evaluationTypeButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedEvaluationType.text = selectedVal
                self.isFlockAgeGreaterTheAllProd = false
                self.isFlockAgeGreaterThen50Weeks  = false
                self.btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
                self.btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
                self.showFlockView()
                
                if selectedVal.contains("Non")  {
                    self.heightFlockAge.constant = 78
                    self.flockAgeLower.isHidden = true
                    self.btnFlockImageLower.isHidden = true
                } else {
                    self.heightFlockAge.constant = 78
                    self.flockAgeLower.isHidden = false
                    self.btnFlockImageLower.isHidden = false
                }
                self.peNewAssessment.evaluationName = selectedVal
                let indexOfItem = evaluationNameArray.index(of: selectedVal)
                self.peNewAssessment.evaluationID = evaluationIDArray[indexOfItem] as? Int
                
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK:   ********* Flock Greater Image Button Clicked    *********
    @IBAction func flockImageGreaterSlected(_ sender: Any) {
        
        
        if isFlockAgeGreaterTheAllProd {
            isFlockAgeGreaterTheAllProd = false
            btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = true
            btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
        } else {
            isFlockAgeGreaterTheAllProd = true
            btnFlockAgeGreater.setImage(UIImage(named: "checkIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = false
            btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        if  self.peNewAssessment.evaluationID == 1 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 1
            } else {
                self.peNewAssessment.isFlopSelected = 2
            }
        }
        if  self.peNewAssessment.evaluationID == 2 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 3
            } else {
                self.peNewAssessment.isFlopSelected = 0
            }
        }
        if  self.peNewAssessment.evaluationID == 3 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 4
            } else {
                self.peNewAssessment.isFlopSelected = 5
            }
        }
        self.checkBackAndSave()
    }
    
    func checkBackAndSave(){
        
        
        if isFromBack{
            self.saveBackAssessmentInProgressDataInDB()
        }else {
            self.saveAssessmentInProgressDataInDB()
        }
        if !isFromTextEditing{
        }
    }
    
    // MARK:   ********* Flock Image Lower Button Clicked    *********
    @IBAction func flockImageLowerSelected(_ sender: Any) {
        
        if isFlockAgeGreaterThen50Weeks {
            isFlockAgeGreaterTheAllProd = true
            btnFlockAgeGreater.setImage(UIImage(named: "checkIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = false
            btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        } else {
            isFlockAgeGreaterTheAllProd = false
            btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = true
            btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
        }
        if  self.peNewAssessment.evaluationID == 1 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 2
            } else {
                self.peNewAssessment.isFlopSelected = 1
            }
        }
        if  self.peNewAssessment.evaluationID == 2 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 3
            } else {
                self.peNewAssessment.isFlopSelected = 0
            }
        }
        
        if  self.peNewAssessment.evaluationID == 3 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 5
            } else {
                self.peNewAssessment.isFlopSelected = 4
            }
        }
        self.checkBackAndSave()
    }
    
    // MARK:   ********* Extended PE Button Clicked    *********
    @IBAction func extendedPESelected(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "uncheckIconPE"){
            extendedPESwitch = true
            sender.setImage(UIImage(named: "checkIconPE"), for: .normal)
            self.peNewAssessment.sanitationEmbrex = 1
            
        }else if sender.image(for: .normal) == UIImage(named: "checkIconPE"){
            extendedPESwitch = false
            self.peNewAssessment.sanitationEmbrex = 0
            sender.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        }
        peNewAssessment.extndMicro = extendedPESwitch
        self.checkBackAndSave()
    }
    // MARK:   ********* TSR Button Clicked    *********
    @IBAction func tsrClicked(_ sender: Any) {
        let superviewCurrent =  tsrButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        var visitIDArray = NSArray()
        var visitNameArray = NSArray()
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
        visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
        visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if  visitNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: visitNameArray as? [String] ?? [String](), kWidth: tsrButton.frame.width, kAnchor: tsrButton, yheight: tsrButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedTSR.text = selectedVal
                self.peNewAssessment.selectedTSR = selectedVal
                let indexOfItem = visitNameArray.index(of: selectedVal)
                self.peNewAssessment.selectedTSRID = visitIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
                
                
                PEAssessmentsDAO.sharedInstance.updateAssessmentStatus( userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId:  self.peNewAssessment.serverAssessmentId ?? "", assessmentobj: self.peNewAssessment ?? self.peNewAssessment)
                
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK:   ********* Switch Button Clicked    *********
    @IBAction func switchClicked(_ sender: Any) {
        if cameraSwitch.isOn {
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        
        if hatcherySwitch.isOn {
            peNewAssessment.hatcheryAntibiotics = 1
        } else {
            peNewAssessment.hatcheryAntibiotics = 0
        }
        
        if isAutomaticSwitch.isOn{
            peNewAssessment.isAutomaticFail = 1//hatcherySwitch.isOn
            CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment:peNewAssessment)
        } else{
            peNewAssessment.isAutomaticFail = 0
            CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment:peNewAssessment)
        }
        
        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: false, isAutomaticFail: self.isAutomaticSwitch.isOn)
        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: false, isAutomaticFail: self.isAutomaticSwitch.isOn)
        
        self.checkBackAndSave()
    }
    // MARK:   ********* Breed Button Clicked    *********
    @IBAction func btnBreedClicked(_ sender: Any) {
        
        let superviewCurrent =  btnBreed.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        var BirdBreedIDArray = NSArray()
        var BirdBreedNameArray = NSArray()
        var BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_BirdBreed") as? NSArray ?? NSArray()
        BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "birdBreedName") as? NSArray ?? NSArray()
        BirdBreedIDArray = BirdBreedDetailsArray.value(forKey: "birdId") as? NSArray ?? NSArray()
        if  BirdBreedNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: BirdBreedNameArray as? [String] ?? [String](), kWidth: btnBreed.frame.width, kAnchor: btnBreed, yheight: btnBreed.bounds.height) { [unowned self] selectedVal, index  in
                self.txtBreedOfBird.text = selectedVal
                if selectedVal == "Other"{
                    
                    self.showBreedOthers()
                } else {
                    self.hideBreedOthers()
                }
                if selectedVal == "Other"{
                    self.txtBreedOfBird.text = selectedVal
                    self.txtBreedOfBirdsOthers.text = ""
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func btnIncubationClicked(_ sender: Any) {
        let superviewCurrent =  btnIncubation.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        var BirdBreedNameArray = NSArray()
        let BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_IncubationStyle")
        BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "incubationStylesName") as? NSArray ?? NSArray()
        
        if  BirdBreedNameArray.count > 0 {
            
            self.dropDownVIewNew(arrayData: BirdBreedNameArray as? [String] ?? [String](), kWidth: btnIncubation.frame.width, kAnchor: btnIncubation, yheight: btnIncubation.bounds.height) { [unowned self] selectedVal, index  in
                
                self.txtIncubation.text = selectedVal
                if selectedVal == "Other"{
                    self.peNewAssessment.breedOfBird = "Other"
                    self.showIncubationOthers()
                } else {
                    self.peNewAssessment.breedOfBird = selectedVal
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    
    
    
    // MARK:   ********* Clorine Button Clicked    *********
    @IBAction func clorineBtnAction(_ sender: Any) {
        
        let superviewCurrent =  countryBtn.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        var countryIDArray = NSArray()
        var countryNameArray = NSArray()
        let countryDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "AllClorinePE")
        countryNameArray = countryDetailsArray.value(forKey: "clorineName") as? NSArray ?? NSArray()
        countryIDArray = countryDetailsArray.value(forKey: "clorineId") as? NSArray ?? NSArray()
        if  countryNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: countryNameArray as? [String] ?? [String](), kWidth: clorineBtn.frame.width, kAnchor: clorineBtn, yheight: clorineBtn.bounds.height) { [unowned self] selectedVal, index  in
                self.clorineTxtFld.text = selectedVal
                self.peNewAssessment.clorineName = selectedVal
                let indexOfItem = countryNameArray.index(of: selectedVal)
                selectedClorineId = countryIDArray[indexOfItem] as? Int ?? 0
                self.peNewAssessment.clorineId = countryIDArray[indexOfItem] as? Int
                isAutomaticFailView.isHidden = false
                isAutomaticSwitch.isHidden = false
                clorineViewHeightConstranit.constant = 120 // 80
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
        
        
    }
    
    
    // MARK: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}

// MARK: - Other Delegates
extension PEDraftStartNewAssesmentINT: DatePickerPopupViewControllerProtocol{
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        let datesStored =  getAllDateArrayStored()
        let customerStored = getAllCustomerArrayStored()
        let sitesStored = getAllSitesArrayStored()
        if datesStored.contains(string) && customerStored.contains(self.peNewAssessment.customerName ?? "") && sitesStored.contains(self.peNewAssessment.siteName ?? "") {
            let superviewCurrent =  evaluationDateButton.superview
            if superviewCurrent != nil{
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
            showAlert(title: "Alert", message: "Assessment Data already Exists for this Customer, Site & Date combination", owner: self)
            return
        }  else {
            selectedEvaluationDateText.text = string
            self.peNewAssessment.evaluationDate = string
            checkBackAndSave()
        }
    }
    
    func doneButtonTapped(string:String){
        
    }
}

// MARK: - Other Delegates
extension PEDraftStartNewAssesmentINT{
    
    func getEvaluationFromBackend(){
        
    }
    
    func microbialValidations(){
        getEvaluationFromBackend()
        checkBackAndSave()
        jsonRe = (getJSON("QuestionAns") ?? JSON())
        pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
        var questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
        var infoImageDataResponse = InfoImageDataResponse(questionInfo)
        let categoryCount = filterCategoryCount()
        
        if extendedPESwitch{
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
            
            if sanitationQuesArr.count == 0{
                SanitationEmbrexQuestionMasterDAO.sharedInstance.saveAssessmentQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
            }
            
        }
        
        if categoryCount > 0 {
            var peNewAssessmentWas = PENewAssessment()
            peNewAssessmentWas = self.peNewAssessment
            
            CoreDataHandler().deleteAllData("PE_AssessmentInProgress",predicate: NSPredicate(format: "userID == %d AND serverAssessmentId = %@", peNewAssessmentWas.userID ?? 0, peNewAssessmentWas.serverAssessmentId ?? ""))
            
            
            
            for  cat in  pECategoriesAssesmentsResponse.peCategoryArray {
                for (index, ass) in cat.assessmentQuestions.enumerated(){
                    var peNewAssessmentNew = PENewAssessment()
                    peNewAssessmentNew = peNewAssessmentWas
                    peNewAssessmentNew.cID = index
                    peNewAssessmentNew.catID = cat.id
                    peNewAssessmentNew.catName = cat.categoryName
                    peNewAssessmentNew.catMaxMark = cat.maxMark
                    peNewAssessmentNew.sequenceNo = cat.id
                    peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                    peNewAssessmentNew.catResultMark = cat.maxMark
                    peNewAssessmentNew.catEvaluationID = cat.evaluationID
                    peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                    peNewAssessmentNew.assID = ass.id
                    peNewAssessmentNew.assDetail1 = ass.assessment
                    peNewAssessmentNew.evaluationID = cat.evaluationID
                    peNewAssessmentNew.assDetail2 = ass.assessment2
                    peNewAssessmentNew.assMinScore = ass.minScore
                    peNewAssessmentNew.assMaxScore = ass.maxScore
                    peNewAssessmentNew.assCatType = ass.cateType
                    peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                    peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                    peNewAssessmentNew.assStatus = 1
                    peNewAssessmentNew.informationImage = ass.informationImage
                    peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                    peNewAssessmentNew.isAllowNA = ass.isAllowNA
                    peNewAssessmentNew.rollOut = ass.rollOut
                    peNewAssessmentNew.isNA = ass.isNA
                    peNewAssessmentNew.qSeqNo = ass.qSeqNo
                    CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                }
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
            vc?.peNewAssessment = self.peNewAssessment
            UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
            UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
            UserDefaults.standard.synchronize()
            if vc != nil{
                self.navigationController?.pushViewController(vc!, animated: true)
                return
            }
        } else {
        }
        
    }
    
    func okButtonTapped() {
        let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
        if sanitationQuesArr.count == 0 && extendedPESwitch{
            showOnlyExtendedMicrobial()
        } else{
            self.fromBackNextBtnAction()
        }
        
    }
    
    func filterCategoryCount() -> Int {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessment.evaluationID == object.evaluationID{
                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
        return pECategoriesAssesmentsResponse.peCategoryArray.count ?? 0
    }
    
    private func dataDuplicacyCheck(assId: String, customerId: Int, siteId: Int, evalDate: String, evaulaterId: Int, _ completion: @escaping (_ status: Bool) -> Void){
        let parameter = [
            "AssessmentId":assId,
            "SiteId": siteId,
            "CustomerId": customerId,
            "EvaulaterId": evaulaterId,
            "EvaluationDate": evalDate
        ] as JSONDictionary
        ZoetisWebServices.shared.getDuplicacyCheck(controller: self, parameters: parameter, completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            if json["Data"].boolValue == true{
                completion(false)
            }else{
                completion(true)
            }
        })
    }
    
    private func cleanSession(){
        
        let peNewAssessmentSurrentIs =   PENewAssessment()
        let peNewAssessmentNew = PENewAssessment()
        peNewAssessmentNew.siteId = peNewAssessmentSurrentIs.siteId
        peNewAssessmentNew.customerId = peNewAssessmentSurrentIs.customerId
        peNewAssessmentNew.complexId = peNewAssessmentSurrentIs.complexId
        peNewAssessmentNew.siteName = peNewAssessmentSurrentIs.siteName
        peNewAssessmentNew.userID = peNewAssessmentSurrentIs.userID
        peNewAssessmentNew.customerName = peNewAssessmentSurrentIs.customerName
        peNewAssessmentNew.firstname = peNewAssessmentSurrentIs.firstname
        peNewAssessmentNew.username = peNewAssessmentSurrentIs.username
        peNewAssessmentNew.evaluatorName = peNewAssessmentSurrentIs.evaluatorName
        peNewAssessmentNew.countryName = peNewAssessmentSurrentIs.countryName
        peNewAssessmentNew.countryID = peNewAssessmentSurrentIs.countryID
        peNewAssessmentNew.basicTransfer = peNewAssessmentSurrentIs.basicTransfer
        peNewAssessmentNew.fluid = peNewAssessmentSurrentIs.fluid
        peNewAssessmentNew.extndMicro = peNewAssessmentSurrentIs.extndMicro
        peNewAssessmentNew.refrigeratorNote = peNewAssessmentSurrentIs.refrigeratorNote
        
    }
    
}


extension PEDraftStartNewAssesmentINT:UITextViewDelegate{
    //MARK...
    
    func textViewShouldBeginEditing(_ _textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == notesTextView ) {
            checkBackAndSave()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
}

// MARK: - WebServices
extension PEDraftStartNewAssesmentINT {
    
    internal func fetchtAssessmentCategoriesResponse(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
        
        vc?.peNewAssessment = self.peNewAssessment
        UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        UserDefaults.standard.synchronize()
        if vc != nil{
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    private func handleAssessmentCategoriesResponse(_ json: JSON) {
        
    }
    
    
}

extension PEDraftStartNewAssesmentINT : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtBreedOfBirdsOthers {
            self.peNewAssessment.breedOfBird = constantToSave + (textField.text ?? "")
            self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
            self.txtBreedOfBirdsOthers.text = textField.text ?? ""
            checkBackAndSave()
        }
        if textField == self.manfacturerOtherTxt {
            self.peNewAssessment.manufacturer = constantToSave + (textField.text ?? "")
            self.manfacturerOtherTxt.text = textField.text ?? ""
            checkBackAndSave()
        }
        if textField == self.eggsOtherTxt {
            self.eggsOtherTxt.text = textField.text ?? ""
            let txt =  textField.text  ?? "0"
            let str =   txt  + "000"
            let iii = Int64(str)
            if iii != nil{
                self.peNewAssessment.noOfEggs = iii!
            }
            checkBackAndSave()
        }
        
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.eggsOtherTxt {
            if string == "" {
                return true
            }
            let isValid = string.stringWithoutWhitespaces.isNumber
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return string == numberFiltered && newString.length <= maxLength
            
            return isValid
        }
        
        
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

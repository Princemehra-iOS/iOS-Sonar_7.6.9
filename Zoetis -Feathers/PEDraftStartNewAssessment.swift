//
//  PEStartNewAssessment.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 13/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreData

class PEDraftStartNewAssessment: BaseViewController {
    
    var isFromTextEditing = false
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
    var isFromBack : Bool = false
    var regionID = Int()
    
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var extendedPELbl: PEFormLabel!
    @IBOutlet weak var extendedPESwitch: UISwitch!
    @IBOutlet weak var flockAgeLbl: PEFormLabel!
    @IBOutlet weak var chlorineStripsSwitch: UISwitch!
    @IBOutlet weak var isAutomaticFailView: UIView!
    @IBOutlet weak var isAutomaticSwitch: UISwitch!
    @IBOutlet weak var isAutomaticHeightConstraints: NSLayoutConstraint!
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
    @IBOutlet weak var manufacturerButton: customButton!
    @IBOutlet weak var txtManufacturer: PEFormTextfield!
    @IBOutlet weak var txtNumberOfEggs: PEFormTextfield!
    @IBOutlet weak var numberOfEggsButton: customButton!
    @IBOutlet weak var btnFlockAgeGreater: UIButton!
    @IBOutlet weak var btnFlockImageLower: UIButton!
    @IBOutlet weak var flockView: UIView!
    @IBOutlet weak var flockAgeLower: UILabel!
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
    //@IBOutlet weak var notesTop: NSLayoutConstraint!
    @IBOutlet weak var heightManufacturerView: NSLayoutConstraint!
    @IBOutlet weak var heightNumberOfEggsView: NSLayoutConstraint!
    @IBOutlet weak var handmixSwitch: UISwitch!
    
    
    fileprivate func handleViewDidLoadMethod() {
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if txtManufacturer.text != "",let character = peNewAssessment.manufacturer?.character(at:0) {
            if txtManufacturer.text == "Other"{
                showManufacturerOthers()
            }
            if character == constantToSave.character(at: 0) {
                showManufacturerOthers()
                let str =  peNewAssessment.manufacturer?.replacingOccurrences(of: constantToSave, with: "")
                manfacturerOtherTxt.text = str
                txtManufacturer.text = "Other"
                showManufacturerOthers()
            }
        }
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                showEggsOthers()
                let str =  xx.replacingOccurrences(of: "000", with: "")
                eggsOtherTxt.text = str
                txtNumberOfEggs.text = "Other"
            }
        }
        
        if peNewAssessment.isFlopSelected == 1 || peNewAssessment.isFlopSelected == 3 || peNewAssessment.isFlopSelected == 4 {
            isFlockAgeGreaterTheAllProd = true
            btnFlockAgeGreater.setImage(UIImage(named: "checkIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = false
            btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        } else if peNewAssessment.isFlopSelected == 2 ||  peNewAssessment.isFlopSelected == 5 {
            isFlockAgeGreaterTheAllProd = false
            btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = true
            btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
        }
        
        let peNewAssessmentArray = CoreDataHandlerPE().getOnGoingDraftAssessmentArrayPEObject()
        for obj in peNewAssessmentArray {
            let assessment = obj
            let imageCount = assessment.images
            if imageCount.count > 0 {
                cameraSwitch.isUserInteractionEnabled = false
                cameraSwitch.alpha = 0.6
            }
        }
    }
    
    fileprivate func handleViewDidLoadMethod2() {
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
        if peNewAssessment.isChlorineStrip == 1 {
            chlorineStripsSwitch.setOn(true, animated: false)
            self.isAutomaticSwitch.setOn(false, animated: false)
            isAutomaticFailView.isHidden = true
            isAutomaticHeightConstraints.constant = 0
        } else {
            chlorineStripsSwitch.setOn(false, animated: false)
            if peNewAssessment.isAutomaticFail == 1{
                self.isAutomaticSwitch.setOn(true, animated: false)
                isAutomaticFailView.isHidden = false
                isAutomaticHeightConstraints.constant = 40
            } else {
                self.isAutomaticSwitch.setOn(false, animated: false)
                isAutomaticFailView.isHidden = false
                isAutomaticHeightConstraints.constant = 40
            }
        }
        if infoObj != nil {
            showExtendedPE(flag: false)
            if !extendedPESwitch.isOn{
                Constants.isExtendedPopup = true
                enableExtendedPE(flag:true)
            } else {
                Constants.isExtendedPopup = false
                enableExtendedPE(flag:false)
            }
        }
        
        if peNewAssessment.sanitationValue == true {
            extendedPESwitch.isOn = true
        } else {
            extendedPESwitch.isOn = false
        }
    }
    
    fileprivate func handleViewDidLoadMethod3() {
        if peNewAssessment.evaluationID != nil {
            
            if peNewAssessment.evaluationID == 1{
                self.inventoryView.isHidden = false
            } else {
                self.peNewAssessment.isHandMix = false
                self.inventoryView.isHidden = true
            }
        } else {
            self.peNewAssessment.isHandMix = false
            self.inventoryView.isHidden = true
        }
        checkBackAndSave()
        if peNewAssessment.selectedTSRID == nil || peNewAssessment.selectedTSRID == 0 {
            tsrButton.isUserInteractionEnabled = true
            selectedTSR.alpha = 1
        } else {
            selectedTSR.text = peNewAssessment.selectedTSR
            tsrButton.isUserInteractionEnabled = false
            selectedTSR.isUserInteractionEnabled = false
            selectedTSR.alpha = 0.6
        }
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        setupUI()
        self.manfacturerOtherTxt.delegate = self
        self.eggsOtherTxt.delegate = self
        self.eggsOtherTxt.keyboardType = .numberPad
        self.visitButton.isUserInteractionEnabled = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat=Constants.MMddyyyyStr
        let currentDate: NSDate = NSDate()
        let strdate1 = dateFormatter.string(from: currentDate as Date) as String
        self.cameraSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.extendedPESwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.hatcherySwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.chlorineStripsSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.isAutomaticSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        
        notesTextView.delegate = self
        notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notesTextView.textContainer.lineFragmentPadding = 12
        notesTextView.text = ""
        peNewAssessment = CoreDataHandlerPE().getSavedDraftOnGoingAssessmentPEObject()
        notesTextView.text = peNewAssessment.notes
        selectedCustomerText.text = peNewAssessment.customerName
        selectedSiteText.text = peNewAssessment.siteName
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
        var FirstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        var LastName = UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        selectedEvaluatorText.text = peNewAssessment.evaluatorName ?? FirstName
        selectedEvaluationType.text = peNewAssessment.evaluationName ?? ""
        
        if let character = peNewAssessment.breedOfBird?.character(at: 1),character == constantToSave.character(at: 0) {
            showBreedOthers()
            let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
            txtBreedOfBirdsOthers.text = str
            txtBreedOfBird.text = "Other"
        }
        if peNewAssessment.breedOfBird == "Other" {
            showBreedOthers()
        } else {
            hideBreedOthers()
        }
        
        handmixSwitch.setOn(peNewAssessment.isHandMix ?? false, animated: false)
        
        txtBreedOfBird.text = self.peNewAssessment.breedOfBird
        if let character = peNewAssessment.breedOfBird?.character(at: 1),character == constantToSave.character(at: 0) {
            showBreedOthers()
            let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
            txtBreedOfBirdsOthers.text = str
            txtBreedOfBird.text = "Other"
        }
        txtBreedOfBirdsOthers.text = self.peNewAssessment.breedOfBirdOther
        txtIncubation.text =  self.peNewAssessment.incubation
        txtIncubationOthers.text =   self.peNewAssessment.incubationOthers
        
        if selectedEvaluationType.text == "" {
            hideFlockView()
        } else {
            if selectedEvaluationType.text?.contains("Non") ?? false  {
                self.flockAgeLower.isHidden = true
                self.btnFlockImageLower.isHidden = true
                self.heightFlockAge.constant = 78
                self.flockAgeLbl.text = "Breeder Flock Age of Eggs Injected"
            } else {
                self.flockAgeLower.isHidden = false
                self.btnFlockImageLower.isHidden = false
                self.heightFlockAge.constant = 78
                self.flockAgeLbl.text = "Breeder Flock Age of Eggs Injected*"
            }
            showFlockView()
        }
        
        selectedVisitText.text =  peNewAssessment.visitName ?? ""
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
        }
        
        hideManufacturerOthers()
        hideEggsOthers()
        txtManufacturer.text = self.peNewAssessment.manufacturer ?? ""
        
        handleViewDidLoadMethod()
        handleViewDidLoadMethod2()
        handleViewDidLoadMethod3()
    }
    
    
    fileprivate func handleCase0(_ rightConst: Int, _ leftConst: Int) {
//        switch rightConst {
//        case 1:
//            if heightNumberOfEggsView.constant == 94 {
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 30)
//            } else {
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 40 )
//            }
//        case 2:
//            //notesTop.constant = CGFloat((leftConst * 55 ) + 20)
//        default:
//            //notesTop.constant = CGFloat((leftConst * 55 ) + 100)
//            if heightNumberOfEggsView.constant == 94{
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 40)
//            }
//        }
    }
    
    fileprivate func handleCase1(_ rightConst: Int, _ leftConst: Int) {
//        switch rightConst {
//        case 1:
//            if heightNumberOfEggsView.constant == 94{
//                if heightManufacturerView.constant == 94{
//                    //notesTop.constant = CGFloat((leftConst * 55 ) - 20)
//                }else{
//                    //notesTop.constant = CGFloat((leftConst * 55 ) + 20)
//                }
//            }else{
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 20)
//            }
//        case 2:
//            //notesTop.constant = CGFloat((leftConst * 55 ) - 20)
//        default:
//            
//            if heightNumberOfEggsView.constant == 94 {
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 20)
//            }else{
//                //notesTop.constant = CGFloat((leftConst * 55 ) + 75)
//            }
//        }
    }
    
    fileprivate func handleCase2(_ rightConst: Int, _ leftConst: Int) {
        switch rightConst {
            
        case 1:
            if heightNumberOfEggsView.constant == 94 {
                if heightManufacturerView.constant == 94 {
                    //notesTop.constant = CGFloat((leftConst * 55 ) - 75)
                }else{
                    //notesTop.constant = CGFloat((leftConst * 55 ) - 35)
                }
            }else{
                //notesTop.constant = CGFloat((leftConst * 55 ) - 30)
            }
        case 2:
            if heightNumberOfEggsView.constant == 94 {
                //notesTop.constant = CGFloat((leftConst * 55 ) - 85)
            }
        default:
            if heightNumberOfEggsView.constant == 94 {
                //notesTop.constant = CGFloat((leftConst * 55 ) - 30)
            }else{
                //notesTop.constant = CGFloat((leftConst * 55 ) + 20)
            }
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
            handleCase0(rightConst, leftConst)
        case 1:
            handleCase1(rightConst, leftConst)
        case 2:
            handleCase2(rightConst, leftConst)
        default:
            break;
        }
    }
    // MARK: Left Constraint
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
    // MARK: Right Constraint
    func rightConstraint()-> Int{
        var otherCount = 0
        
        if ((self.txtManufacturer.text?.lowercased().contains("other")) ?? false),self.txtManufacturer.text?.contains("S") ?? false {
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
    
    // MARK: Handmix Switch Action
    @IBAction func handMixSwitchAction(_ sender: Any) {
        if peNewAssessment.ppmValue != ""
        {
            Constants.isfromDraftStartVC = true
        }
        else
        {
            Constants.isfromDraftStartVC = false
        }
        peNewAssessment.ppmValue = ""
        
        if handmixSwitch.isOn
        {
            peNewAssessment.isHandMix = true
        }
        else
        {
            peNewAssessment.isHandMix = false
        }
        
    }
    
    // MARK: Show Extended PE
    func showExtendedPE(flag:Bool = false){
        extendedPELbl.isHidden = flag
        extendedPESwitch.isHidden = flag
    }
    // MARK: Enable Extended PE
    func enableExtendedPE(flag:Bool = true){
        extendedPELbl.isUserInteractionEnabled = flag
        extendedPESwitch.isUserInteractionEnabled = flag
    }
    
    // MARK: Hide Flock View
    func hideFlockView(){
        flockView.isHidden = true
        heightFlockAge.constant = 0
    }
    
    // MARK: Show Flock View
    func showFlockView(){
        flockView.isHidden = false
        // notesTopViewConstraint.constant = 122
    }
    
    // MARK: Setup UI
    fileprivate func setBtnBackground(_ btn: customButton?) {
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
    
    func setupUI(){
        btnNext.setNextButtonUI()
        viewForGradient.setGradientThreeColors(topGradientColor: UIColor.getGradientUpperColorStartAssessment(),midGradientColor:UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientUpperColorStartAssessmentLast())
        containerView.setCornerRadiusFloat(radius: 23)
        viewForGradient.setCornerRadiusFloat(radius: 23)
        let btns = [customerButton,siteButton,evaluatorButton,visitButton,evaluationTypeButton,tsrButton,evaluationDateButton,btnBreed,btnBreedOthers,btnIncubation,btnIncubationOthers,manufacturerButton,numberOfEggsButton]
        
        self.customerButton.isUserInteractionEnabled = false
        self.siteButton.isUserInteractionEnabled = false
        self.evaluatorButton.isUserInteractionEnabled = false
        
        self.customerButton.isEnabled = false
        self.siteButton.isEnabled = false
        self.evaluatorButton.isEnabled = false
        
        self.selectedCustomerText.alpha = 0.6
        self.selectedSiteText.alpha = 0.6
        self.selectedEvaluatorText.alpha = 0.6
        self.selectedVisitText.alpha = 0.6
        if self.isFromBack {
            self.evaluationTypeButton.isUserInteractionEnabled = false
            self.evaluationTypeButton.isEnabled = false
            self.selectedEvaluationType.alpha = 0.6
            self.evaluationDateButton.isUserInteractionEnabled = false
            self.evaluationDateButton.isEnabled = false
            self.selectedEvaluationDateText.alpha = 0.6
        }
        
        for btn in btns {
            setBtnBackground(btn)
        }
        notesTextView.layer.cornerRadius = 12
        notesTextView.layer.masksToBounds = true
        notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notesTextView.layer.borderWidth = 2.0
        
        if self.regionID == 3,
           (peNewAssessment.isPERejected == false && peNewAssessment.isEMRejected == true) {
            
            self.evaluationTypeButton.isUserInteractionEnabled = false
            self.evaluationDateButton.isUserInteractionEnabled = false
            self.notesTextView.isUserInteractionEnabled = false
            self.handmixSwitch.isUserInteractionEnabled = false
            self.hatcherySwitch.isUserInteractionEnabled = false
            self.cameraSwitch.isUserInteractionEnabled = false
            self.eggsOtherBtn.isUserInteractionEnabled = false
            self.txtNumberOfEggs.isUserInteractionEnabled = false
            self.eggsOtherTxt.isUserInteractionEnabled = false
            self.txtManufacturer.isUserInteractionEnabled = false
            self.manufacturerButton.isUserInteractionEnabled = false
            self.btnIncubation.isUserInteractionEnabled = false
            self.btnIncubationOthers.isUserInteractionEnabled = false
            self.txtIncubationOthers.isUserInteractionEnabled = false
            self.manfacturerOtherBtn.isUserInteractionEnabled = false
            self.manfacturerOtherTxt.isUserInteractionEnabled = false
            self.chlorineStripsSwitch.isUserInteractionEnabled = false
            self.extendedPESwitch.isUserInteractionEnabled = false
            self.isAutomaticSwitch.isUserInteractionEnabled = false
            self.btnBreed.isUserInteractionEnabled = false
            self.txtBreedOfBird.isUserInteractionEnabled = false
            self.txtBreedOfBirdsOthers.isUserInteractionEnabled = false
            self.btnBreedOthers.isUserInteractionEnabled = false
            self.numberOfEggsButton.isUserInteractionEnabled = false
            self.btnFlockImageLower.isUserInteractionEnabled = false
            self.btnFlockAgeGreater.isUserInteractionEnabled = false
        }
    }
    
    fileprivate func loadManufacturerOtherUI() {
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
    
    fileprivate func loadEggOtherUI(_ xx: String) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        if self.peNewAssessment.hatcheryAntibiotics == 1{
            self.hatcherySwitch.isOn = true//hatcherySwitch.isOn
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
        
        if let character = peNewAssessment.breedOfBird?.character(at: 1),character == constantToSave.character(at: 0) {
            showBreedOthers()
            let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
            txtBreedOfBirdsOthers.text = str
            txtBreedOfBird.text = "Other"
        }
        if peNewAssessment.breedOfBird == "Other"{
            showBreedOthers()
        } else {
            hideBreedOthers()
        }
        
        txtBreedOfBird.text = self.peNewAssessment.breedOfBird
        if let character = peNewAssessment.breedOfBird?.character(at: 1),character == constantToSave.character(at: 0) {
            showBreedOthers()
            let str =  peNewAssessment.breedOfBird?.replacingOccurrences(of: constantToSave, with: "")
            txtBreedOfBirdsOthers.text = str
            txtBreedOfBird.text = "Other"
        }
        txtBreedOfBirdsOthers.text =    self.peNewAssessment.breedOfBirdOther
        
        hideManufacturerOthers()
        hideEggsOthers()
        
        txtManufacturer.text = self.peNewAssessment.manufacturer ?? ""
        if txtManufacturer.text != "" {
            loadManufacturerOtherUI()
        }
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if xx != "0" {
            loadEggOtherUI(xx)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0].peNewAssessment = peNewAssessment
    }
    
    // MARK: Get All Drafted Assessments Array Stored in DB
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
    
    // MARK: Get All Customer's List
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
    // MARK: Get All Sites Array list
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
    
    // MARK: Manufacturer Button Action
    @IBAction func manufacutrerClicked(_ sender: Any) {
        
        let superviewCurrent = manufacturerButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        let manufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Manufacturer")
        let manufacutrerNameArray = manufacutrerDetailsArray.value(forKey: "mFG_Name") as? NSArray ?? NSArray()
        if manufacutrerNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: manufacutrerNameArray as? [String] ?? [String](), kWidth: btnIncubation.frame.width, kAnchor: btnIncubation, yheight: btnIncubation.bounds.height) { [unowned self] selectedVal, index  in
                self.txtManufacturer.text = selectedVal
                self.peNewAssessment.manufacturer = self.txtManufacturer.text ?? ""
                self.checkBackAndSave()
                if self.peNewAssessment.manufacturer == "Other" {
                    self.showManufacturerOthers()
                } else {
                    self.hideManufacturerOthers()
                }
                if selectedVal == "Other" {
                    
                    self.txtManufacturer.text = selectedVal
                    self.manfacturerOtherTxt.text = ""
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    // MARK: Number of Eggs Button Action
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
        
        let EggsDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Eggs")
        let EggsNameArray = EggsDetailsArray.value(forKey: "eggCount") as? NSArray ?? NSArray()
        if EggsNameArray.count > 0 {
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
        appDelegateObj.testFuntion()
    }
    // MARK: Hide Breeds View
    func hideBreedOthers(){
        heightBreed.constant = 45
        btnBreedOthers.isHidden = true
        txtBreedOfBirdsOthers.isHidden = true
    }
    
    // MARK: Show Breed Views
    func showBreedOthers(){
        heightBreed.constant = 94
        btnBreedOthers.isHidden = false
        txtBreedOfBirdsOthers.isHidden = false
    }
    
    // MARK: Hide Incubation Others View
    func hideIncubationOthers(){
        heightIncubation.constant = 45
        btnIncubationOthers.isHidden = true
        txtIncubationOthers.isHidden = true
    }
    
    // MARK: Show Incubation Others View
    func showIncubationOthers(){
        heightIncubation.constant = 94
        btnIncubationOthers.isHidden = false
        txtIncubationOthers.isHidden = false
    }
    
    // MARK: Hide Manufacturer Other View
    func hideManufacturerOthers(){
        assignConstraint()
        heightManufacturerView.constant = 45
        manfacturerOtherBtn.isHidden = true
        manfacturerOtherTxt.isHidden = true
        self.view.layoutIfNeeded()
    }
    // MARK: Show Manufacturer Other View
    func showManufacturerOthers(){
        assignConstraint()
        heightManufacturerView.constant = 90
        manfacturerOtherBtn.isHidden = false
        manfacturerOtherTxt.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    // MARK: Hide Eggs Other View
    func hideEggsOthers(){
        assignConstraint()
        heightNumberOfEggsView.constant = 45
        eggsOtherBtn.isHidden = true
        eggsOtherTxt.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    // MARK: Show Eggs Other View
    func showEggsOthers(){
        heightNumberOfEggsView.constant = 94
        eggsOtherBtn.isHidden = false
        eggsOtherTxt.isHidden = false
        assignConstraint(otherEgg: 1)
        self.view.layoutIfNeeded()
    }
    
    // MARK: Function to Save Data when Comes for Back button
    func fromBackNextBtnAction  () {
        self.checkBackAndSave()
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
        UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        UserDefaults.standard.synchronize()
        
        if extendedPESwitch.isOn{
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
    
    // MARK: Show Only Extended Microbial
    func showOnlyExtendedMicrobial(){
        
        let errorMSg = VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_EXTENDED_MICROBIAL
        let alertController = UIAlertController(title: Constants.alertStr, message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.fromBackNextBtnAction()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    // MARK: Get Vaccine Mixture List
    private func getVaccineMixerList(customerId: Int, siteId: Int, countryId: Int, _ completion: @escaping (_ status: Bool) -> Void){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Mixer...")
        let parameter = [
            "siteId": "\(siteId)",
            "customerId": "\(customerId)",
            "countryId": "\(countryId)"
        ] as JSONDictionary
        ZoetisWebServices.shared.getMixerList(controller: self, parameters: parameter) { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handleVaccineMixer(json)
        }
    }
    // MARK:  Handle Vaccine Mixture List
    private func handleVaccineMixer(_ json: JSON) {
        self.deleteAllData("PE_VaccineMixerDetail")
        VaccineMixerResponse(json)
        self.dismissGlobalHUD(self.view ?? UIView())
    }
    
    // MARK: Next Button Action
    fileprivate func extractedFunc() {
        if isFromBack {
            
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
            if sanitationQuesArr.count == 0 && extendedPESwitch.isOn {
                self.showOnlyExtendedMicrobial()
            } else {
                self.fromBackNextBtnAction()
            }
            
        } else {
            self.okButtonTapped()
        }
    }
    
    fileprivate func breedOtherValidation() {
        if (peNewAssessment.breedOfBird?.lowercased().contains("other") ?? false) {
            guard let otherText = peNewAssessment.breedOfBirdOther, !otherText.isEmpty else {
                changeMandatorySuperviewToRed()
                return
            }
        }
    }
    
    fileprivate func manufacturerOtherValidation() {
        if (self.txtManufacturer.text?.lowercased().contains("other") ?? false) {
            guard let otherText = manfacturerOtherTxt.text, !otherText.isEmpty else {
                changeMandatorySuperviewToRed()
                return
            }
        }
    }
    
    fileprivate func eggsOtherValidation() {
        if (txtNumberOfEggs.text?.lowercased().contains("other") ?? false) {
            guard let otherText = eggsOtherTxt.text, !otherText.isEmpty else {
                changeMandatorySuperviewToRed()
                return
            }
        }
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        self.getVaccineMixerList(customerId: self.peNewAssessment.customerId ?? 0, siteId: self.peNewAssessment.siteId ?? 0, countryId: 40) { [self] status in
            print(status)
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
        
        if peNewAssessment.breedOfBird != nil && peNewAssessment.breedOfBird != "" {
            breedOtherValidation()
        } else {
            changeMandatorySuperviewToRed()
            return
        }
        
        self.checkManufactrIncubationNumberOfEggsValidation()        
        
    }
    
    func checkManufactrIncubationNumberOfEggsValidation() {
        if self.txtManufacturer.text != nil && self.txtManufacturer.text != ""{
            manufacturerOtherValidation()
        } else {
            changeMandatorySuperviewToRed()
            return
        }
        
        if (peNewAssessment.incubation != nil && peNewAssessment.incubation != "") == false{
            changeMandatorySuperviewToRed()
            return
        }
        
        if txtNumberOfEggs.text != nil && txtNumberOfEggs.text != "" {
            eggsOtherValidation()
        } else {
            changeMandatorySuperviewToRed()
            return
        }
        extractedFunc()
    }
    
    
    // MARK: Save Assessment In Draft
    func saveAssessmentInProgressDataInDB()  {
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1
        } else {
            peNewAssessment.hatcheryAntibiotics = 0
        }
        
        if handmixSwitch.isOn
        {
            peNewAssessment.isHandMix = true
        }
        else
        {
            peNewAssessment.isHandMix = false
        }
        
        if cameraSwitch.isOn{
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        if let notesTxt = notesTextView.text , notesTxt.count > 0 {
            peNewAssessment.notes =   notesTxt
        }
        var FirstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName = UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        self.peNewAssessment.incubation = txtIncubation.text
        self.peNewAssessment.incubationOthers = txtIncubationOthers.text
        
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
        
        if handmixSwitch.isOn
        {
            peNewAssessment.isHandMix = true
        }
        else
        {
            peNewAssessment.isHandMix = false
        }
        
        if cameraSwitch.isOn{
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        if let notesTxt = notesTextView.text , notesTxt.count > 0 {
            peNewAssessment.notes =   notesTxt
        }
        var FirstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName = UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName + LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        self.peNewAssessment.incubation = txtIncubation.text
        self.peNewAssessment.incubationOthers = txtIncubationOthers.text
        let userID = UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        self.peNewAssessment.userID = userID
        CoreDataHandlerPE().updateDraftAlreadyInProgressInDB(newAssessment: self.peNewAssessment)
        
    }
    
    func finishSession()  {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
    }
    
    // MARK: Check Mendatory Fields
    fileprivate func setBorderBreedOtherField() {
        let superviewCurrent = btnBreedOthers.superview
        if ((peNewAssessment.breedOfBird?.lowercased().contains("other")) ?? false),
           (peNewAssessment.breedOfBirdOther != nil && peNewAssessment.breedOfBirdOther != "") == false,
           superviewCurrent != nil {
            
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
    }
    
    fileprivate func setBorderManufctrerOtherField() {
        let superviewCurrent = manfacturerOtherBtn.superview
        if ((self.txtManufacturer.text?.lowercased().contains("other")) ?? false),
           (manfacturerOtherTxt.text != nil && manfacturerOtherTxt.text != "") == false,
           superviewCurrent != nil {
            
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
    }
    
    fileprivate func setBorderForNmbrOfEggsField() {
        let superviewCurrent = eggsOtherBtn.superview
        if ((txtNumberOfEggs.text?.lowercased().contains("other")) ?? false),
           (eggsOtherTxt.text != nil && eggsOtherTxt.text != "") == false,
           superviewCurrent != nil {
            
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
    }
    
    fileprivate func setBorderEvaluationDateField() {
        let superviewCurrent = evaluationDateButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
    }
    
    fileprivate func setBorderForCustomerBtn() {
        let superviewCurrent = customerButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                    
                }
            }
        }
    }
    
    fileprivate func setBorderForSiteBtn() {
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
    
    fileprivate func setBorderForEvaluationName() {
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
    
    fileprivate func setEvaluatorBorderField() {
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
    
    fileprivate func setBorderForVisitType() {
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
    
    fileprivate func handleNumberOfEggsButton() {
        let superviewCurrent = numberOfEggsButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.red.cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
    }
    
    fileprivate func handleBtnIncubation() {
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
    
    fileprivate func handleBtnBreed() {
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
    
    fileprivate func handleParams(_ date: String, _ customer: String, _ site: String, _ evaluationName: String, _ evaluator: String) {
        if date.isEmpty {
            setBorderEvaluationDateField()
        }
        if customer.isEmpty {
            setBorderForCustomerBtn()
        }
        if site.isEmpty {
            setBorderForSiteBtn()
        }
        if evaluationName.isEmpty {
            setBorderForEvaluationName()
        }
        if evaluator.isEmpty {
            setEvaluatorBorderField()
        }
    }
    
    fileprivate func handleManufacturerButton() {
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
    
    func changeMandatorySuperviewToRed(){
        let date = self.peNewAssessment.evaluationDate ?? ""
        let customer = self.peNewAssessment.customerName ?? ""
        let site = self.peNewAssessment.siteName ?? ""
        let evaluationName = self.peNewAssessment.evaluationName ?? ""
        let evaluator = self.peNewAssessment.evaluatorName ?? ""
        let reasonForVisit = self.peNewAssessment.visitName ?? ""
        
        if peNewAssessment.breedOfBird != nil && peNewAssessment.breedOfBird != ""{
            setBorderBreedOtherField()
        } else {
            handleBtnBreed()
        }
        
        if self.txtManufacturer.text != nil && self.txtManufacturer.text != ""{
            setBorderManufctrerOtherField()
        } else {
            handleManufacturerButton()
        }
        
        if (peNewAssessment.incubation != nil && peNewAssessment.incubation != "") == false {
            handleBtnIncubation()
        }
        
        if txtNumberOfEggs.text != nil && txtNumberOfEggs.text != ""{
            setBorderForNmbrOfEggsField()
        } else {
            handleNumberOfEggsButton()
        }
        
        handleParams(date, customer, site, evaluationName, evaluator)
        
        if (reasonForVisit.count <= 0) {
            setBorderForVisitType()
        }
        
        showAlert(title: Constants.alertStr, message: Constants.pleaseEnterMandatoryFields, owner: self)
        
    }
    
    // MARK: Evaluation Date Button Actiion
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
    
    // MARK: Customer Button Action
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
        
        let customerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Customer")
        let customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray()
        let customerIDArray = customerDetailsArray.value(forKey: "customerID") as? NSArray ?? NSArray()
        if customerNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: customerNamesArray as? [String] ?? [String](), kWidth: customerButton.frame.width, kAnchor: customerButton, yheight: customerButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedCustomerText.text = selectedVal
                self.selectedSiteText.text = ""
                let indexOfItem = customerNamesArray.index(of: selectedVal)
                self.peNewAssessment.customerName = selectedVal
                self.peNewAssessment.siteName = ""
                self.peNewAssessment.customerId = customerIDArray[indexOfItem] as? Int                
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK: Site Button Action
    @IBAction func siteClicked(_ sender: Any) {
        
        let superviewCurrent = siteButton.superview
        if superviewCurrent != nil {
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
        let complexDetailsArray = CoreDataHandlerPE().fetchSitesWithCustId( self.peNewAssessment.customerId as NSNumber? ?? 0)
        let complexNamesArray = complexDetailsArray.value(forKey: "siteName") as? NSArray ?? NSArray()
        let complexIDArray = complexDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if complexNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: complexNamesArray as? [String] ?? [String](), kWidth: siteButton.frame.width, kAnchor: siteButton, yheight: siteButton.bounds.height) { [unowned self] selectedVal, index in
                self.selectedSiteText.text = selectedVal
                self.peNewAssessment.siteName = selectedVal
                let indexOfItem = complexNamesArray.index(of: selectedVal)
                self.peNewAssessment.siteId = complexIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK: Evaluator Button Action
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
        
        let evaluatorDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Evaluator")
        let evaluatorNameArray = evaluatorDetailsArray.value(forKey: "evaluatorName") as?  NSArray ?? NSArray()
        let evaluatorIDArray = evaluatorDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if evaluatorNameArray.count > 0 {
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
    
    // MARK: Visit type Button Action
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
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VisitTypes")
        let visitNameArray = visitDetailsArray.value(forKey: "visitName") as? NSArray ?? NSArray()
        let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if visitNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: visitNameArray as? [String] ?? [String](), kWidth: visitButton.frame.width, kAnchor: visitButton, yheight: visitButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedVisitText.text = selectedVal
                self.peNewAssessment.visitName = selectedVal
                let indexOfItem = visitNameArray.index(of: selectedVal)
                self.peNewAssessment.visitID = visitIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
                PEAssessmentsDAO.sharedInstance.updateAssessmentStatus(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                                                       serverAssessmentId: self.peNewAssessment.serverAssessmentId ?? "",
                                                                       assessmentobj: self.peNewAssessment)
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK: Evaluation Button action
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
        let evaluationDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_EvaluationType")
        let evaluationNameArray = evaluationDetailsArray.value(forKey: "evaluationName") as? NSArray ?? NSArray()
        let evaluationIDArray = evaluationDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if evaluationNameArray.count > 0 {
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
    
    // MARK: Flock Image Greater Button Action
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
        if self.peNewAssessment.evaluationID == 1 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 1
            } else {
                self.peNewAssessment.isFlopSelected = 2
            }
        }
        if self.peNewAssessment.evaluationID == 2 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 3
            } else {
                self.peNewAssessment.isFlopSelected = 0
            }
        }
        if self.peNewAssessment.evaluationID == 3 {
            if isFlockAgeGreaterTheAllProd {
                self.peNewAssessment.isFlopSelected = 4
            } else {
                self.peNewAssessment.isFlopSelected = 5
            }
        }
        self.checkBackAndSave()
    }
    
    // MARK: Save Data in Draft
    func checkBackAndSave(){
        if isFromBack{
            self.saveBackAssessmentInProgressDataInDB()
        }else {
            self.saveAssessmentInProgressDataInDB()
        }
        if !isFromTextEditing{
            assignConstraint()
        }
    }
    
    // MARK: Flock Image Lower button Action
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
        if self.peNewAssessment.evaluationID == 1 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 2
            } else {
                self.peNewAssessment.isFlopSelected = 1
            }
        }
        if self.peNewAssessment.evaluationID == 2 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 3
            } else {
                self.peNewAssessment.isFlopSelected = 0
            }
        }
        
        if self.peNewAssessment.evaluationID == 3 {
            if isFlockAgeGreaterThen50Weeks {
                self.peNewAssessment.isFlopSelected = 5
            } else {
                self.peNewAssessment.isFlopSelected = 4
            }
        }
        self.checkBackAndSave()
    }
    
    // MARK: TSR Button Action
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
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
        let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
        let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if visitNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: visitNameArray as? [String] ?? [String](), kWidth: tsrButton.frame.width, kAnchor: tsrButton, yheight: tsrButton.bounds.height) { [unowned self] selectedVal, index  in
                self.selectedTSR.text = selectedVal
                self.peNewAssessment.selectedTSR = selectedVal
                let indexOfItem = visitNameArray.index(of: selectedVal)
                self.peNewAssessment.selectedTSRID = visitIDArray[indexOfItem] as? Int
                self.checkBackAndSave()
                
                PEAssessmentsDAO.sharedInstance.updateAssessmentStatus(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
                                                                       serverAssessmentId: self.peNewAssessment.serverAssessmentId ?? "",
                                                                       assessmentobj: self.peNewAssessment)
                
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK: Switch Action
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
        
        if chlorineStripsSwitch.isOn{
            peNewAssessment.isChlorineStrip = 1//hatcherySwitch.isOn
            peNewAssessment.isAutomaticFail = 0
            self.isAutomaticSwitch.setOn(false, animated: false)
            isAutomaticFailView.isHidden = true
            isAutomaticHeightConstraints.constant = 0
            CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment:peNewAssessment)
        } else{
            peNewAssessment.isChlorineStrip = 0
            isAutomaticFailView.isHidden = false
            isAutomaticHeightConstraints.constant = 40
            CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment:peNewAssessment)
        }
        
        if Constants.isExtendedPopup{
            if extendedPESwitch.isOn{
                peNewAssessment.sanitationEmbrex = 1
                peNewAssessment.extndMicro = true
                peNewAssessment.sanitationValue = true
            }else {
                peNewAssessment.sanitationEmbrex = 0
                peNewAssessment.extndMicro = false
                peNewAssessment.sanitationValue = false
                
            }
        }
        
        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
        self.checkBackAndSave()
    }
    
    // MARK: Breed Button Action
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
        let BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_BirdBreed")
        let BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "birdBreedName") as? NSArray ?? NSArray()
        if BirdBreedNameArray.count > 0 {
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
    
    // MARK: Incubation Button Action
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
        
        let BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_IncubationStyle")
        let BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "incubationStylesName") as? NSArray ?? NSArray()
        
        if BirdBreedNameArray.count > 0 {
            
            self.dropDownVIewNew(arrayData: BirdBreedNameArray as? [String] ?? [String](), kWidth: btnIncubation.frame.width, kAnchor: btnIncubation, yheight: btnIncubation.bounds.height) { [unowned self] selectedVal, index  in
                
                self.txtIncubation.text = selectedVal
                if selectedVal == "Other"{
                    self.peNewAssessment.breedOfBird = "Other"
                    self.showIncubationOthers()
                } else {
                    self.peNewAssessment.breedOfBird = selectedVal
                    self.hideIncubationOthers()
                }
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
extension PEDraftStartNewAssessment: DatePickerPopupViewControllerProtocol{
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
            showAlert(title: Constants.alertStr, message: "Assessment Data already Exists for this Customer, Site & Date combination", owner: self)
            return
        }  else {
            selectedEvaluationDateText.text = string
            self.peNewAssessment.evaluationDate = string
            checkBackAndSave()
        }
    }
    
    func doneButtonTapped(string:String){
        print(appDelegateObj.testFuntion())
    }
}

// MARK: - Other Delegates
extension PEDraftStartNewAssessment{
    
    func getEvaluationFromBackend(){
        print(appDelegateObj.testFuntion())
    }
    
    // MARK: Microbial Validation
    func microbialValidations(){
        getEvaluationFromBackend()
        checkBackAndSave()
        jsonRe = (getJSON("QuestionAns") ?? JSON())
        pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
        var questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
        var infoImageDataResponse = InfoImageDataResponse(questionInfo)
        let categoryCount = filterCategoryCount()
        
        if extendedPESwitch.isOn{
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
            
            if sanitationQuesArr.count == 0{
                SanitationEmbrexQuestionMasterDAO.sharedInstance.saveAssessmentQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
            }
            
        }
        
        if categoryCount > 0 {
            CoreDataHandler().deleteAllData("PE_AssessmentInProgress",predicate: NSPredicate(format: "userID == %d AND serverAssessmentId = %@", self.peNewAssessment.userID ?? 0, self.peNewAssessment.serverAssessmentId ?? ""))
            CoreDataHandler().deleteAllData("PE_Refrigator")
            
            for cat in pECategoriesAssesmentsResponse.peCategoryArray {
                for (index, ass) in cat.assessmentQuestions.enumerated() {
                    if let peNewAssessmentNew = self.peNewAssessment {
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
        }
        
    }
    
    // MARK: Ok Button Tapped
    func okButtonTapped() {
        let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
        if sanitationQuesArr.count == 0 && extendedPESwitch.isOn{
            showOnlyExtendedMicrobial()
        } else{
            self.fromBackNextBtnAction()
        }
        
    }
    
    // MARK: Filter Category Count
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
}

// MARK: Extension & Textview Delegates
extension PEDraftStartNewAssessment:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ _textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == notesTextView ) {
            checkBackAndSave()
        }
    }
}

// MARK: - WebServices
extension PEDraftStartNewAssessment {
    
    internal func fetchtAssessmentCategoriesResponse() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
        
        vc?.peNewAssessment = self.peNewAssessment
        UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        UserDefaults.standard.synchronize()
        if vc != nil {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
// MARK: Extension & Textfield Delegates
extension PEDraftStartNewAssessment : UITextFieldDelegate{
    
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
            
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return string == numberFiltered && newString.length <= maxLength
        }
        
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}



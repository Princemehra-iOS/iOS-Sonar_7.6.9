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

class PEStartNewAssessment: BaseViewController {
    
    @IBOutlet weak var extendedPELbl: PEFormLabel!
    @IBOutlet weak var chlorineStripsSwitch: UISwitch!
    @IBOutlet weak var isAutomaticSwitch: UISwitch!
    @IBOutlet weak var extendedPESwitch: UISwitch!
    @IBOutlet weak var notesTop: NSLayoutConstraint!
    @IBOutlet weak var flockAgeLbl: PEFormLabel!
    @IBOutlet weak var heightFlockAge: NSLayoutConstraint!
    @IBOutlet weak var topIncubation: NSLayoutConstraint!
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
    @IBOutlet weak var manufacturerButton: customButton!
    @IBOutlet weak var txtManufacturer: PEFormTextfield!
    @IBOutlet weak var txtNumberOfEggs: PEFormTextfield!
    @IBOutlet weak var numberOfEggsButton: customButton!
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
    @IBOutlet weak var btnFlockAgeGreater: UIButton!
    @IBOutlet weak var btnFlockImageLower: UIButton!
    @IBOutlet weak var flockView: UIView!
    @IBOutlet weak var flockAgeLower: UILabel!
    @IBOutlet weak var btnBreed: customButton!
    @IBOutlet weak var btnBreedOthers: customButton!
    @IBOutlet weak var btnIncubation: customButton!
    @IBOutlet weak var txtBreedOfBird: PEFormTextfield!
    @IBOutlet weak var txtBreedOfBirdsOthers: PEFormTextfield!
    @IBOutlet weak var txtIncubation: PEFormTextfield!
    @IBOutlet weak var manfacturerOtherBtn: customButton!
    @IBOutlet weak var manfacturerOtherTxt: PEFormTextfield!
    @IBOutlet weak var eggsOtherBtn: customButton!
    @IBOutlet weak var eggsOtherTxt: PEFormTextfield!
    @IBOutlet weak var heightManufacturerView: NSLayoutConstraint!
    @IBOutlet weak var heightNumberOfEggsView: NSLayoutConstraint!
    @IBOutlet weak var isAutomaticFailView: UIView!
    @IBOutlet weak var isAutomaticHeightConstraint: NSLayoutConstraint!
    var isFromTextEditing = false
    
    var peHeaderViewController:PEHeaderViewController!
    var peNewAssessment:PENewAssessment!
    var scheduledAssessment:PENewAssessment?
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    var jsonRe : JSON = JSON()
    var questionInfo : JSON = JSON()
    var isMovedForward = false
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var infoImageDataResponse = InfoImageDataResponse(nil)
    var isFlockAgeGreaterTheAllProd : Bool = false
    var isFlockAgeGreaterThen50Weeks : Bool = false
    var constantToSave : String = "S"
    var isFromBack : Bool = false
    
    var firstLogin = false
    
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var handmixSwitch: UISwitch!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        setupUI()
        setUpDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if self.peNewAssessment.hatcheryAntibiotics == 1{
            self.hatcherySwitch.isOn = true//hatcherySwitch.isOn
        } else{
            self.hatcherySwitch.isOn = false
        }
        let peDetails = PEInfoDAO.sharedInstance.fetchInfoMoObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment.serverAssessmentId ?? "")
        if scheduledAssessment?.sanitationEmbrex == nil{
            self.peNewAssessment.sanitationEmbrex = peDetails[0].isExtendedPE as? Int
        }
        
        if peNewAssessment.sanitationEmbrex == 1{
            showExtendedPE(flag: false)
            extendedPESwitch.isOn = true
            peNewAssessment.sanitationValue = true
            UserDefaults.standard.set(true, forKey:"ExtendedMicro")
            UserDefaults.standard.setValue(true, forKey: "extendedAvailable")
            enableExtendedPE(flag: false)
            Constants.isExtendedPopup = false
            let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: true, assessmentId: peNewAssessment?.serverAssessmentId ?? "", date: nil)
            PEInfoDAO.sharedInstance.saveData(vaccineData: data)
        } else {
            showExtendedPE(flag: false)
            extendedPESwitch.isOn = false
            peNewAssessment.sanitationValue = false
            UserDefaults.standard.set(false, forKey:"ExtendedMicro")
            UserDefaults.standard.setValue(false, forKey: "extendedAvailable")
            enableExtendedPE(flag: true)
            Constants.isExtendedPopup = true
            let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: false, assessmentId: peNewAssessment?.serverAssessmentId ?? "", date: nil)
            PEInfoDAO.sharedInstance.saveData(vaccineData: data)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isMovedForward{
            isMovedForward = false
            ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0].peNewAssessment = peNewAssessment
        }else{
            let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
            let pradicate = NSPredicate(format: "userID == %d AND serverAssessmentId == %@", userID, peNewAssessment.serverAssessmentId ?? "")
            CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentInProgress", predicate: pradicate)
        }
    }
    
    // MARK: - Hand Mix Switch Action
    @IBAction func handMixSwitchAction(_ sender: Any) {
        
        if handmixSwitch.isOn
        {
            peNewAssessment.ppmValue = ""
            peNewAssessment.isHandMix = true
        }
        else
        {
            peNewAssessment.ppmValue = ""
            peNewAssessment.isHandMix = false
        }
    }
    
    
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        let btns = [customerButton,siteButton,evaluatorButton,visitButton,evaluationTypeButton,tsrButton,evaluationDateButton,btnBreed,btnBreedOthers,btnIncubation,manufacturerButton,numberOfEggsButton]
        
        DispatchQueue.main.async {
            self.btnNext.setNextButtonUI()
            self.viewForGradient.setGradientThreeColors(topGradientColor: UIColor.getGradientUpperColorStartAssessment(),midGradientColor:UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientUpperColorStartAssessmentLast())
            self.containerView.setCornerRadiusFloat(radius: 23)
            self.viewForGradient.setCornerRadiusFloat(radius: 23)
            
            self.customerButton.isUserInteractionEnabled = false
            self.siteButton.isUserInteractionEnabled = false
            self.evaluatorButton.isUserInteractionEnabled = false
            self.visitButton.isUserInteractionEnabled = false
            
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
            
            for btn in btns{
                let superviewCurrent =  btn?.superview
                if superviewCurrent != nil {
                    for view in superviewCurrent!.subviews {
                        if  view.isKind(of:UIButton.self) {
                            if view == self.evaluationDateButton{
                                view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
                            } else{
                                view.setDropdownStartAsessmentView(imageName:"dd")
                            }
                        }
                    }
                }
            }
            self.notesTextView.layer.cornerRadius = 12
            self.notesTextView.layer.masksToBounds = true
            self.notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.notesTextView.layer.borderWidth = 2.0
            
        }
        
    }
    
    /* Manually assign constraints */
    
    func assignConstraint(otherEgg:Int = 0){
        let leftConst = leftConstraint()
        var rightConst = rightConstraint() //+ otherEgg
        if rightConst == 3 {
            rightConst = 2
        }
        
        switch leftConst {
        case 0:
            
            switch rightConst {
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 40))
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 40 ))
                }
            default:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 40))
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 100))
                }
            }
        case 1:
            switch rightConst {
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(((leftConst * 55 ) - 10))
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 40 ))
                }
            case 2:
                notesTop.constant = CGFloat(((leftConst * 55 ) - 50))
            default:
                if heightNumberOfEggsView.constant == 94{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 30))
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 85))
                }
            }
        case 2:
            switch rightConst {
            case 1:
                if heightNumberOfEggsView.constant == 94{
                    if heightManufacturerView.constant == 94{
                        notesTop.constant = CGFloat(((leftConst * 55 ) - 55))
                    }else{
                        notesTop.constant = CGFloat(((leftConst * 55 ) - 25))
                    }
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) - 10))
                }
            case 2:
                notesTop.constant = CGFloat(((leftConst * 55 ) - 35))
            default:
                if heightNumberOfEggsView.constant == 94{
                    
                    notesTop.constant = CGFloat(((leftConst * 55 ) - 10))
                }else{
                    notesTop.constant = CGFloat(((leftConst * 55 ) + 40))
                }
            }
        default:
            break;
        }
    }
    
    /* Manually left assign constraints */
    
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
    
    /* Manually right assign constraints */
    
    func rightConstraint() -> Int{
        var otherCount = 0
        
        if (( self.txtManufacturer.text?.lowercased().contains("other")) ?? false) {
            otherCount += 1
        }
        let xx = String(self.peNewAssessment.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                //   showEggsOthers()
                let str =  xx.replacingOccurrences(of: "000", with: "")
                eggsOtherTxt.text = str
                txtNumberOfEggs.text = "Other"
            }
        }
        return otherCount
    }
    // MARK: - Setup UI
    private func setUpDidLoad(){
        self.manfacturerOtherTxt.delegate = self
        self.eggsOtherTxt.delegate = self
        self.eggsOtherTxt.keyboardType = .numberPad
        self.txtBreedOfBirdsOthers.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM/dd/yyyy"
        let currentDate: NSDate = NSDate()
        let strdate1 = dateFormatter.string(from: scheduledAssessment?.scheduledDate ?? Date()) as String
        self.cameraSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.hatcherySwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.extendedPESwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.chlorineStripsSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        self.isAutomaticSwitch.tintColor = UIColor.getTextViewBorderColorStartAssessment()
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Assessment"
        self.isAutomaticFailView.isHidden = true
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
        notesTextView.delegate = self
        notesTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notesTextView.textContainer.lineFragmentPadding = 12
        notesTextView.text = ""
        peNewAssessment = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject(serverAssessmentId:scheduledAssessment?.serverAssessmentId ?? "",createNewObject:true)
        peNewAssessment.evaluatorID = scheduledAssessment?.evaluatorID
        peNewAssessment.evaluatorName = scheduledAssessment?.evaluatorName
        if peNewAssessment.serverAssessmentId == nil{
            peNewAssessment.visitName = scheduledAssessment?.visitName
            peNewAssessment.visitID = scheduledAssessment?.visitID
            peNewAssessment.notes = scheduledAssessment?.notes
            peNewAssessment.customerName = scheduledAssessment?.customerName
            peNewAssessment.customerId = scheduledAssessment?.customerId
            peNewAssessment.siteId = scheduledAssessment?.siteId
            peNewAssessment.sanitationEmbrex = scheduledAssessment?.sanitationEmbrex
            peNewAssessment.statusType = 3
            peNewAssessment.siteName = scheduledAssessment?.siteName
            peNewAssessment.serverAssessmentId = scheduledAssessment?.serverAssessmentId
            peNewAssessment.evaluationDate = strdate1
        }
        
        if let selectedTSRID = scheduledAssessment?.selectedTSRID{
            peNewAssessment.selectedTSRID = selectedTSRID
        }
        if let selectedTSR = scheduledAssessment?.selectedTSR{
            if selectedTSR != ""{
                peNewAssessment.selectedTSR = selectedTSR
            }
        }
        
        peNewAssessment.serverAssessmentId = scheduledAssessment?.serverAssessmentId
        notesTextView.text =  peNewAssessment.notes
        selectedCustomerText.text = peNewAssessment.customerName
        selectedSiteText.text =  peNewAssessment.siteName
        var defautUsername =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        defautUsername = defautUsername + LastName
        if peNewAssessment.evaluationDate == "" {
            selectedEvaluationDateText.text = strdate1
            self.peNewAssessment.evaluationDate = strdate1
        } else {
            selectedEvaluationDateText.text = peNewAssessment.evaluationDate ?? strdate1
        }
        self.peNewAssessment.evaluationID = peNewAssessment.evaluationID
        selectedEvaluatorText.text =  peNewAssessment.evaluatorName ?? defautUsername
        selectedEvaluationType.text = peNewAssessment.evaluationName ?? ""
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
        txtIncubation.text =  self.peNewAssessment.incubation
        if self.peNewAssessment.manufacturer?.count ?? "".count > 0 {
            txtManufacturer.text = self.peNewAssessment.manufacturer
        }
        if self.peNewAssessment.noOfEggs ?? 0 > 0 {
            txtNumberOfEggs.text = String(self.peNewAssessment.noOfEggs ?? 0)
        }
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
        
        if peNewAssessment.isHandMix ==  true{
            handmixSwitch.isOn = true
        }
        else{
            handmixSwitch.isOn = false
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
        var FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        
        FirstName = FirstName + " " + LastName
        
        peNewAssessment.evaluatorName =  FirstName
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        peNewAssessment.evaluatorID = userID
        if peNewAssessment.selectedTSR?.count ?? 0 > 1 {
            selectedTSR.text = peNewAssessment.selectedTSR
        }
        
        hideManufacturerOthers()
        hideEggsOthers()
        if peNewAssessment.manufacturer == "Other"{
            showManufacturerOthers()
        } else {
            hideManufacturerOthers()
        }
        
        txtManufacturer.text = self.peNewAssessment.manufacturer ?? ""
        if  txtManufacturer.text != "" {
            if let character = peNewAssessment.manufacturer?.character(at:0) {
                if txtManufacturer.text?.contains("Other") ?? false{
                    showManufacturerOthers()
                }
                if character == constantToSave.character(at: 0){
                    showManufacturerOthers()
                    let str =  peNewAssessment.manufacturer?.replacingOccurrences(of: constantToSave, with: "")
                    manfacturerOtherTxt.text = str
                    txtManufacturer.text = "Other"
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
        getSubmittedAssessmentorEggsAndIncubation()
        
        if peNewAssessment.isFlopSelected == 1 ||  peNewAssessment.isFlopSelected == 3 ||  peNewAssessment.isFlopSelected == 4 {
            isFlockAgeGreaterTheAllProd = true
            btnFlockAgeGreater.setImage(UIImage(named: "checkIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = false
            btnFlockImageLower.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
        } else  if peNewAssessment.isFlopSelected == 2 ||  peNewAssessment.isFlopSelected == 5  {
            isFlockAgeGreaterTheAllProd = false
            btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = true
            btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
        }
        
        let  peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        for obj in peNewAssessmentArray {
            let assessment = obj
            let imageCount = assessment.images
            if imageCount.count > 0 {
                cameraSwitch.isUserInteractionEnabled = false
                cameraSwitch.alpha = 0.6
            }
        }
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        
        if !Constants.isFirstTime{
            if peNewAssessment.isChlorineStrip == 1{
                chlorineStripsSwitch.setOn(true, animated: false)
                self.isAutomaticSwitch.setOn(false, animated: false)
                isAutomaticFailView.isHidden = true
                isAutomaticHeightConstraint.constant = 0
            }else{
                chlorineStripsSwitch.setOn(false, animated: false)
                if peNewAssessment.isAutomaticFail == 1{
                    self.isAutomaticSwitch.setOn(true, animated: false)
                    isAutomaticFailView.isHidden = false
                    isAutomaticHeightConstraint.constant = 40
                }else{
                    self.isAutomaticSwitch.setOn(false, animated: false)
                    isAutomaticFailView.isHidden = false
                    isAutomaticHeightConstraint.constant = 40
                }
            }
        }else{
            self.chlorineStripsSwitch.isOn = true
            isAutomaticSwitch.isOn = false
            peNewAssessment.isChlorineStrip = 1
            peNewAssessment.isAutomaticFail = 0
            isAutomaticFailView.isHidden = true
        }
        
        if peNewAssessment.evaluationID != nil{
            if peNewAssessment.evaluationID == 1{
                if infoObj != nil{
                    extendedPESwitch.isOn =  infoObj?.isExtendedPE ?? false
                }else{
                    
                }
                if extendedPESwitch.isOn{
                } else{
                }
                
            }else{
                self.peNewAssessment.isHandMix = false
                self.inventoryView.isHidden = true
            }
        }else{
            self.peNewAssessment.isHandMix = false
            self.inventoryView.isHidden = true
            
        }
        checkBackAndSave()
        
        if peNewAssessment.selectedTSRID == nil || peNewAssessment.selectedTSRID == 0{
            tsrButton.isUserInteractionEnabled = true
            selectedTSR.alpha = 1
        } else {
            selectedTSR.text = peNewAssessment.selectedTSR
            tsrButton.isUserInteractionEnabled = false
            selectedTSR.isUserInteractionEnabled = false
            selectedTSR.alpha = 0.6
        }
        
    }
    
    /* Extended PE scope */
    
    func showExtendedPE(flag:Bool = false){
        extendedPELbl.isHidden = flag
        extendedPESwitch.isHidden = flag
    }
    
    func enableExtendedPE(flag:Bool = true){
        extendedPELbl.isUserInteractionEnabled = flag
        extendedPESwitch.isUserInteractionEnabled = flag
    }
    
    /* Get offline stored session(Eggs and Incubation) */
    // MARK: - Get offline stored session(Eggs and Incubation)
    private func getSubmittedAssessmentorEggsAndIncubation() {
        var submitedAssess : PENewAssessment = PENewAssessment()
        let offlineSubmitedArray  = CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
        if offlineSubmitedArray.count > 0 {
            for obj in offlineSubmitedArray {
                submitedAssess = obj
            }
            if  txtManufacturer.text  == "" {
                txtManufacturer.text = submitedAssess.manufacturer ?? ""
                if  txtManufacturer.text != "" {
                    if let character = submitedAssess.manufacturer?.character(at:0) {
                        if character == constantToSave.character(at: 0){
                            showManufacturerOthers()
                            let str =  submitedAssess.manufacturer?.replacingOccurrences(of: constantToSave, with: "")
                            manfacturerOtherTxt.text = str
                            txtManufacturer.text = "Other"
                        }
                    }
                }
            }
            if txtManufacturer.text  == "Other"{
                showManufacturerOthers()
            }else{
                hideManufacturerOthers()
            }
            if  txtNumberOfEggs.text == "" {
                if submitedAssess.noOfEggs ?? 0 > 0 {
                    txtNumberOfEggs.text = String(submitedAssess.noOfEggs ?? 0)
                }
                let xx = String(submitedAssess.noOfEggs ?? 000)
                if xx != "0" {
                    let last3 = String(xx.suffix(3))
                    if last3 ==  "000" {
                        showEggsOthers()
                        let str =  xx.replacingOccurrences(of: "000", with: "")
                        eggsOtherTxt.text = str
                        txtNumberOfEggs.text = "Other"
                    }
                }
            }
            if txtNumberOfEggs.text  == "Other"{
                showEggsOthers()
            }else{
                hideEggsOthers()
            }
            if  txtIncubation.text == "" {
                txtIncubation.text =  submitedAssess.incubation
            }
            self.peNewAssessment.incubation = txtIncubation.text
            if txtNumberOfEggs.text  == "Other"{
                self.peNewAssessment.noOfEggs = Int64((eggsOtherTxt.text ?? "") + "000")
            }else{
                self.peNewAssessment.noOfEggs = Int64(txtNumberOfEggs.text ?? "")
            }
            if txtManufacturer.text  == "Other"{
                self.peNewAssessment.manufacturer = "S" + (manfacturerOtherTxt.text ?? "")
            }else{
                self.peNewAssessment.manufacturer = txtManufacturer.text
            }
        }
    }
    
    /* Get offline stored session */
    // MARK: - Get offline stored session
    private func getAllOfflineSubmitedArrayStored() -> PENewAssessment{
        var peAssessmentAlreadySubmitted : PENewAssessment = PENewAssessment()
        let offlineSubmitedArray  = CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
        if offlineSubmitedArray.count > 0 {
            for obj in offlineSubmitedArray {
                peAssessmentAlreadySubmitted = obj
            }
        }
        return peAssessmentAlreadySubmitted
    }
    
    // MARK: - Hide Flock View
    func hideFlockView(){
        flockView.isHidden = true
        heightFlockAge.constant = 0
    }
    // MARK: - Show Flock View
    func showFlockView(){
        flockView.isHidden = false
    }
    
    /* Get offline and draft stored session */
    // MARK: - Get offline and draft stored session
    private func getAllDateArrayStored() -> [String]{
        //let draft =  ZoetisDropdownShared.sharedInstance.sharedPEDraft ?? []
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
    
    // MARK: - Get saved Customers list
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
    // MARK: - Get saved Site's list
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
    // MARK: - Get Evaluation Type list
    private func getAllevaluationIDStored() -> [String]{
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject(ofCurrentDate:true)
        var evaluationIDs : [String] = []
        for obj in drafts {
            evaluationIDs.append(obj.evaluationName ?? "")
        }
        let syncData =  CoreDataHandlerPE().getOfflineAssessmentArrayPEObject(ofCurrentDate:true)
        for obj in syncData {
            evaluationIDs.append(obj.evaluationName ?? "")
        }
        return evaluationIDs
    }
    
    @IBAction func btnAction(_ sender: Any) {
    }
    // MARK: - Hide Breed Other View
    func hideBreedOthers(){
        heightBreed.constant = 45
        btnBreedOthers.isHidden = true
        txtBreedOfBirdsOthers.isHidden = true
        self.view.layoutIfNeeded()
    }
    // MARK: - Show Breed Other View
    func showBreedOthers(){
        heightBreed.constant = 104
        btnBreedOthers.isHidden = false
        txtBreedOfBirdsOthers.isHidden = false
        self.view.layoutIfNeeded()
    }
    // MARK: - Hide Incubation Other View
    func hideIncubationOthers(){
        heightIncubation.constant = 45
        
    }
    // MARK: - Show Incubation Other View
    func showIncubationOthers(){
        
    }
    
    // MARK: - Hide Manufacturer Other  View
    func hideManufacturerOthers(){
        assignConstraint()
        //notesTop.constant = 50
        heightManufacturerView.constant = 45
        manfacturerOtherBtn.isHidden = true
        manfacturerOtherTxt.isHidden = true
        self.view.layoutIfNeeded()
    }
    // MARK: - Show Manufacturer Other View
    func showManufacturerOthers(){
        assignConstraint()
        heightManufacturerView.constant = 94
        manfacturerOtherBtn.isHidden = false
        manfacturerOtherTxt.isHidden = false
        self.view.layoutIfNeeded()
    }
    // MARK: - Hide Eggs Other View
    func hideEggsOthers(){
        assignConstraint()
        heightNumberOfEggsView.constant = 45
        eggsOtherBtn.isHidden = true
        eggsOtherTxt.isHidden = true
        self.view.layoutIfNeeded()
    }
    // MARK: - Show Eggs Other View
    func showEggsOthers(){
        heightNumberOfEggsView.constant = 94
        assignConstraint()
        eggsOtherBtn.isHidden = false
        eggsOtherTxt.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func fromBackNextBtnAction(){
        self.checkBackAndSave()
        isMovedForward = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as? PEAssesmentFinalize
        vc?.peNewAssessment = self.peNewAssessment
        vc?.peNewAssessmentBack = self.peNewAssessment
        vc?.scheduledAssessment = scheduledAssessment
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
            Constants.isMovementDone = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        return
    }
    // MARK: - Show Extended Microbial Button
    func showOnlyExtendedMicrobial(){
        let errorMSg = VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_EXTENDED_MICROBIAL
        
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
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
    // MARK: -API to check Duplicate Data
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
    // MARK: - Get Vaccine Mixer List
    private func getVaccineMixerList(customerId: Int, siteId: Int, countryId: Int, _ completion: @escaping (_ status: Bool) -> Void) {
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Mixer's List...")
        let parameter = [
            "siteId": "\(siteId)",
            "customerId": "\(customerId)",
            "countryId": "\(countryId)"
        ] as JSONDictionary
        ZoetisWebServices.shared.getMixerList(controller: self, parameters: parameter) { [weak self] (json, error) in
			self?.btnNext.isUserInteractionEnabled = true
            guard let `self` = self, error == nil else { return }
            
            DispatchQueue.main.async {
                VaccineMixerResponse(json)
                
            }
            self.dismissGlobalHUD(self.view ?? UIView())
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.checkValidations()
                
            }
            
        }
    }
    // MARK: - Handle Vaccine Mixer Api responce
    private func handleVaccineMixer(_ json: JSON) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            VaccineMixerResponse(json)
            
        }
        self.dismissGlobalHUD(self.view ?? UIView())
    }
    // MARK: - Next button Action
    @IBAction func nextBtnAction(_ sender: Any) {
        self.view.endEditing(true)
		btnNext.isUserInteractionEnabled = false
		
		delay(1.0) {
			self.btnNext.isUserInteractionEnabled = true
		}
        Constants.isFirstTime = false
        DispatchQueue.main.async {
            self.deleteAllData("PE_VaccineMixerDetail")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getVaccineMixerList(customerId: self.peNewAssessment.customerId ?? 0, siteId: self.peNewAssessment.siteId ?? 0, countryId: 40) { [self] status in
            }
        }
    }
    // MARK: -Method to Validate the Data.
    func checkValidations(){
        guard let date = self.peNewAssessment.evaluationDate, date.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            changeMandatorySuperviewToRed()
            return
        }
        
        guard let selectedTSR = self.selectedTSR.text, selectedTSR.count > 0 else {
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
        
        
        
        let datesStored =  getAllDateArrayStored()
        let customerStored = getAllCustomerArrayStored()
        let sitesStored = getAllSitesArrayStored()
        let evaluationIDs = getAllevaluationIDStored()
        var dateContain = false
        
        for  obj  in datesStored {
            if obj.lowercased() == self.peNewAssessment.evaluationDate?.lowercased(){
                dateContain = true
            }
        }
        
        var customerContain = false
        
        for  obj  in customerStored {
            if obj.lowercased() == self.peNewAssessment.customerName?.lowercased(){
                customerContain = true
            }
        }
        
        var siteContain = false
        
        for  obj  in sitesStored {
            if obj.lowercased() == self.peNewAssessment.siteName?.lowercased(){
                siteContain = true
            }
        }
        
        var evaluationContain = false
        
        for  obj  in evaluationIDs {
            if obj.lowercased() == self.peNewAssessment.evaluationName?.lowercased(){
                evaluationContain = true
            }
        }

        
        if self.heightFlockAge.constant == 78 {
            if isFlockAgeGreaterTheAllProd || isFlockAgeGreaterThen50Weeks {
                
                if isFromBack {
                    let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
                    if sanitationQuesArr.count == 0 && Constants.isExtendedPopup{
                        showOnlyExtendedMicrobial()
                    } else{
                        if !Constants.isMovementDone{
                            self.fromBackNextBtnAction()
                            if extendedPESwitch.isOn {
                                CoreDataHandlerPE().updateIsEMRequestedInAssessmentInProgress(isEMRequested: true)
                            } else {
                                CoreDataHandlerPE().updateIsEMRequestedInAssessmentInProgress(isEMRequested: false)
                                
                            }
                        }
                    }
                    
                } else {

                    self.okButtonTapped()
                }
            } else {
                showAlert(title: "Alert", message: "Please enter the flock details.", owner: self)
            }
        }else {
            if isFromBack {
                let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
                if sanitationQuesArr.count == 0 && Constants.isExtendedPopup{
                    showOnlyExtendedMicrobial()
                }else{
                    if !Constants.isMovementDone{
                        self.fromBackNextBtnAction()
                    }
                }
            } else {
                self.okButtonTapped()
            }
        }
    }
    // MARK: - Save assessment in Draft
    func saveAssessmentInProgressDataInDB()  {
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
        FirstName = FirstName +  LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1//hatcherySwitch.isOn
        } else{
            peNewAssessment.hatcheryAntibiotics = 0
        }
        
        if extendedPESwitch.isOn
        {
            peNewAssessment.sanitationValue = true
        }else
        {
            peNewAssessment.sanitationValue = false
        }
        
        if handmixSwitch.isOn{
            peNewAssessment.isHandMix = true
        } else{
            peNewAssessment.isHandMix = false
        }
        
        self.peNewAssessment.incubation = txtIncubation.text
        //   self.peNewAssessment.incubationOthers = txtIncubationOthers.text
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        self.peNewAssessment.userID = userID
        //self.peNewAssessment.hatcheryAntibiotics = 2
        CoreDataHandlerPE().updateAssessmentInProgressInDB(newAssessment: self.peNewAssessment, serverAssessmentId: peNewAssessment.serverAssessmentId ?? "")
    }
    
    func saveBackAssessmentInProgressDataInDB()  {
        if cameraSwitch.isOn{
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        if let notesTxt = notesTextView.text , notesTxt.count > 0 {
            peNewAssessment.notes =   notesTxt
        }
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1//hatcherySwitch.isOn
        } else{
            peNewAssessment.hatcheryAntibiotics = 0
        }
        
        if handmixSwitch.isOn{
            peNewAssessment.isHandMix = true
        } else{
            peNewAssessment.isHandMix = false
        }
        
        if extendedPESwitch.isOn{
            peNewAssessment.sanitationValue = true
        }
        else{
            peNewAssessment.sanitationValue = false
        }
        
        var FirstName =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
        FirstName = FirstName +  LastName
        self.peNewAssessment.username = FirstName
        self.peNewAssessment.firstname = FirstName
        self.peNewAssessment.breedOfBird = txtBreedOfBird.text
        self.peNewAssessment.breedOfBirdOther = txtBreedOfBirdsOthers.text
        self.peNewAssessment.incubation = txtIncubation.text
        
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        self.peNewAssessment.userID = userID
        CoreDataHandlerPE().updateAlreadyInProgressInDB(newAssessment: self.peNewAssessment)
    }
    
    // MARK: - Add red Boredr to blank fields
    func changeMandatorySuperviewToRed(){
        let date = self.peNewAssessment.evaluationDate ?? ""
        let customer = self.peNewAssessment.customerName ?? ""
        let site = self.peNewAssessment.siteName ?? ""
        let evaluationName = self.peNewAssessment.evaluationName ?? ""
        let evaluator = self.peNewAssessment.evaluatorName ?? ""
        let reasonForVisit = self.peNewAssessment.visitName ?? ""
        let selectedTSR = self.selectedTSR.text ?? ""
        //        let incubation = self.peNewAssessment.incubation ?? ""
        //        let breedOfBirds = self.peNewAssessment.breedOfBird ?? ""
        //        let breedOfBirdsOthers = self.peNewAssessment.breedOfBirdOther ?? ""
        //        let manufecturer = self.peNewAssessment.manufacturer ?? ""
        //        let manufecturerOther = self.manfacturerOtherTxt.text ?? ""
        //        let eggsFlat = self.txtNumberOfEggs.text ?? ""
        //        let eggsFlatOther = self.eggsOtherTxt.text ?? ""
        
        //
        if peNewAssessment.breedOfBird != nil && peNewAssessment.breedOfBird != ""{
            if peNewAssessment.breedOfBird?.lowercased().contains("other") ?? false {
                if peNewAssessment.breedOfBirdOther != nil && peNewAssessment.breedOfBirdOther != "" {
                    
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
        
        if  self.txtManufacturer.text != nil &&  self.txtManufacturer.text != ""{
            if (( self.txtManufacturer.text?.lowercased().contains("other")) ?? false) {
                if manfacturerOtherTxt.text != nil && manfacturerOtherTxt.text != "" {
                    
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
        //
        
        if (date.count > 0 ){} else  {
            let superviewCurrent =  evaluationDateButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (customer.count > 0 ){} else  {
            let superviewCurrent =  customerButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (selectedTSR.count > 0 ){} else  {
            let superviewCurrent = tsrButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        
        if (site.count > 0 ){} else  {
            let superviewCurrent =  siteButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if (evaluationName.count > 0){} else  {
            let superviewCurrent =  evaluationTypeButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
                
            }
            
        }
        if (evaluator.count  > 0){} else  {
            let superviewCurrent =  evaluatorButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                        
                    }
                }
            }
        }
        if (reasonForVisit.count > 0){} else  {
            let superviewCurrent =  visitButton.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.red.cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
        
        if let controller = UIApplication.getTopMostViewController(),
           (controller is UIAlertController) == false {
            showAlert(title: "Alert", message: "Please enter details in all the fields marked as mandatory.", owner: self)
        }
    }
    
    /* evaluation date selected */
    // MARK: - Evaluation date Button Clicked
    @IBAction func evaluationDateClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        let superviewCurrent =  evaluationDateButton.superview
        if superviewCurrent != nil {
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
        datePickerPopupViewController?.evaluationDate = peNewAssessment.evaluationDate
        if datePickerPopupViewController != nil
        {
            navigationController?.present(datePickerPopupViewController!, animated: false, completion: nil)
        }
        
    }
    
    //Customer Company is same
    /* Customer selected */
    // MARK: - Customer Button Clicked
    @IBAction func customerClicked(_ sender: Any) {
        let superviewCurrent =  customerButton.superview
        if superviewCurrent != nil {
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
                
            }
            self.dropHiddenAndShow()
        }
    }
    
    /* Manufacturer selected */
    // MARK: - Manufacturer Button Action
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
        
        var manufacutrerNameArray = NSArray()
        var manufacutrerDetailsArray = NSArray()
        manufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Manufacturer")
        manufacutrerNameArray = manufacutrerDetailsArray.value(forKey: "mFG_Name") as? NSArray ?? NSArray()
        if  manufacutrerNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: manufacutrerNameArray as? [String] ?? [String](), kWidth: btnIncubation.frame.width, kAnchor: btnIncubation, yheight: btnIncubation.bounds.height){ [unowned self] selectedVal, index  in
                self.txtManufacturer.text = selectedVal
                self.peNewAssessment.manufacturer = self.txtManufacturer.text ?? ""
                //                self.checkBackAndSave()
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
    
    /* Number of eggs selected */
    // MARK: - Number Of Eggs Button Action
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
        var EggsNameArray = NSArray()
        let EggsDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Eggs")
        EggsNameArray = EggsDetailsArray.value(forKey: "eggCount") as? NSArray ?? NSArray()
        if  EggsNameArray.count > 0 {
            self.dropDownVIewNew(arrayData: EggsNameArray as? [String] ?? [String](), kWidth: txtNumberOfEggs.frame.width, kAnchor: txtNumberOfEggs, yheight: txtNumberOfEggs.bounds.height) { [unowned self] selectedVal, index  in
                if selectedVal == "Other"{
                    self.txtNumberOfEggs.text = selectedVal
                    self.peNewAssessment.noOfEggs = 0//Double(0)
                    self.eggsOtherTxt.text = ""
                    self.showEggsOthers()
                } else {
                    self.hideEggsOthers()
                    self.txtNumberOfEggs.text = selectedVal
                    self.peNewAssessment.noOfEggs = Int64(self.txtNumberOfEggs.text ?? "")
                }
                
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    
    //Complex Site is same
    /* Site selected */
    // MARK: - Site Button Action
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
            //   showtoast(message: "No Sites Found")
        }
    }
    
    /* Evaluator selected */
    // MARK: - Evaluator Button Action
    @IBAction func evaluatorClicked(_ sender: Any) {
        let superviewCurrent =  evaluatorButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        
        var evaluatorIDArray = NSArray()
        var evaluatorNameArray = NSArray()
        let evaluatorDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Evaluator")
        evaluatorNameArray = evaluatorDetailsArray.value(forKey: "evaluatorName") as? NSArray ?? NSArray()
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
    
    /* Type of visit selected */
    // MARK: - Vist Type Button Action
    @IBAction func visitClicked(_ sender: Any) {
        let superviewCurrent =  visitButton.superview
        if superviewCurrent != nil{
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }}
        }
        var visitIDArray = NSArray()
        var visitNameArray = NSArray()
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VisitTypes")
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
    
    /* Types of evaluation selected */
    // MARK: - Evaluation type Button Action
    @IBAction func evaluationClicked(_ sender: Any) {
        //fetchEvaluatorTypes
        let superviewCurrent =  evaluationTypeButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }
            }
        }
        
        
        var evaluationIDArray = NSArray()
        var evaluationNameArray = NSArray()
        let evaluationDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_EvaluationType")
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
                    let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "")
                    if infoObj != nil {
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: false, assessmentId: self.peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: self.chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                    }
                    
                    self.heightFlockAge.constant = 78
                    self.flockAgeLower.isHidden = true
                    self.btnFlockImageLower.isHidden = true
                    self.flockAgeLbl.text = "Breeder Flock Age of Eggs Injected"
                    
                    self.inventoryView.isHidden = true
                    
                } else {
                    self.heightFlockAge.constant = 78
                    self.flockAgeLower.isHidden = false
                    self.btnFlockImageLower.isHidden = false
                    self.flockAgeLbl.text = "Breeder Flock Age of Eggs Injected*"
                    self.inventoryView.isHidden = false
                    
                }
                
                
                self.peNewAssessment.evaluationName = selectedVal
                let indexOfItem = evaluationNameArray.index(of: selectedVal)
                self.peNewAssessment.evaluationID = evaluationIDArray[indexOfItem] as? Int
                
                if self.peNewAssessment.evaluationID != nil && self.peNewAssessment.evaluationID == 1{
                    //                    self.showExtendedPE()
                    //                    self.enableExtendedPE()
                }else{
                    let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "")
                    
                    let hasSelectedExtendedPE = infoObj?.isExtendedPE ?? false
                    if hasSelectedExtendedPE{
                        
                    }
                    //                    self.showExtendedPE(flag: true)
                    
                }
                
                self.checkBackAndSave()
                
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK: - Check & Save Method
    func checkBackAndSave() {
        if isFromBack {
            self.saveBackAssessmentInProgressDataInDB()
        } else {
            self.saveAssessmentInProgressDataInDB()
        }
        assignConstraint()
    }
    
    /* TSR selected */
    // MARK: - TSR Button Action
    @IBAction func tsrClicked(_ sender: Any) {
        let superviewCurrent =  tsrButton.superview
        if superviewCurrent != nil {
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                    view.layer.borderWidth = 2.0
                }}
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
                self.scheduledAssessment?.selectedTSR = selectedVal
                self.scheduledAssessment?.selectedTSRID = visitIDArray[indexOfItem] as? Int
                
                PEAssessmentsDAO.sharedInstance.updateAssessmentStatus( userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId:  self.scheduledAssessment?.serverAssessmentId ?? "", assessmentobj: self.scheduledAssessment ?? self.peNewAssessment)
            }
            self.dropHiddenAndShow()
        }
    }
    
    /* Switch action */
    
    @IBAction func switchClicked(_ sender: Any) {
        if cameraSwitch.isOn {
            peNewAssessment.camera = 1
        } else {
            peNewAssessment.camera = 0
        }
        if hatcherySwitch.isOn{
            peNewAssessment.hatcheryAntibiotics = 1//hatcherySwitch.isOn
        } else{
            peNewAssessment.hatcheryAntibiotics = 0
        }
        
        if isAutomaticSwitch.isOn{
            peNewAssessment.isAutomaticFail = 1//hatcherySwitch.isOn
        } else{
            peNewAssessment.isAutomaticFail = 0
        }
        
        if chlorineStripsSwitch.isOn{
            peNewAssessment.isChlorineStrip = 1//hatcherySwitch.isOn
            peNewAssessment.isAutomaticFail = 0
            self.isAutomaticSwitch.setOn(false, animated: false)
            isAutomaticFailView.isHidden = true
            isAutomaticHeightConstraint.constant = 0
        } else{
            peNewAssessment.isChlorineStrip = 0
            isAutomaticFailView.isHidden = false
            isAutomaticHeightConstraint.constant = 40
        }
        if Constants.isExtendedPopup{
            if extendedPESwitch.isOn{
                UserDefaults.standard.set(true, forKey:"ExtendedMicro")
                UserDefaults.standard.setValue(true, forKey: "extendedAvailable")
                
                peNewAssessment.sanitationEmbrex = 1
                peNewAssessment.sanitationValue = true
                //                PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: true, assessmentId: scheduledAssessment?.serverAssessmentId ?? "", date: nil)
            }else{
                UserDefaults.standard.set(false, forKey:"ExtendedMicro")
                UserDefaults.standard.setValue(false, forKey: "extendedAvailable")
                
                peNewAssessment.sanitationEmbrex = 0
                peNewAssessment.sanitationValue = false
            }
        }
        
        //            if scheduledAssessment?.sanitationEmbrex != nil{
        //                if scheduledAssessment?.sanitationEmbrex == 0 {
        //                    scheduledAssessment?.sanitationEmbrex = 1
        //                    extendedPESwitch.isOn = true
        //                    PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: true, assessmentId: scheduledAssessment?.serverAssessmentId ?? "", date: nil)
        //                }else{
        //                    scheduledAssessment?.sanitationEmbrex = 0
        //                    extendedPESwitch.isOn = false
        //                    PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: false, assessmentId: scheduledAssessment?.serverAssessmentId ?? "", date: nil)
        //                }
        //            }
        //        var extendedPESwitchVal = false
        //        if extendedPESwitch != nil{
        //            extendedPESwitchVal = extendedPESwitch.isOn
        //            if peNewAssessment.evaluationID != nil && peNewAssessment.evaluationID == 1{
        //                PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil, hasChlorineStrips: chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
        //            }
        //        }else{
        //
        //        }
        //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
        
        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
                                
        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
        
        self.checkBackAndSave()
    }
    
    /* Breed selected */
    // MARK: - Breed Button Action
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
        
        var BirdBreedNameArray = NSArray()
        let BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_BirdBreed")
        BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "birdBreedName") as? NSArray ?? NSArray()
        
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
    
    /* Incubation style selected */
    // MARK: - Incubation Button Action
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
                    self.hideIncubationOthers()
                }
                self.checkBackAndSave()
            }
            self.dropHiddenAndShow()
        }
    }
    
    
    // MARK: -DROP DOWN HIDDEN AND SHOW Method
    //MARKS: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}

// MARK: - DatePicker Delegates

extension PEStartNewAssessment : DatePickerPopupViewControllerProtocol{
    
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        let datesStored =  getAllDateArrayStored()
        let customerStored = getAllCustomerArrayStored()
        let sitesStored = getAllSitesArrayStored()
        let evaluationIDs = getAllevaluationIDStored()
        
        var dateContain = false
        
        for  obj  in datesStored {
            if obj.lowercased() == string.lowercased(){
                dateContain = true
            }
        }
        
        var customerContain = false
        
        for  obj  in customerStored {
            if obj.lowercased() == self.peNewAssessment.customerName?.lowercased(){
                customerContain = true
            }
        }
        
        var siteContain = false
        
        for  obj  in sitesStored {
            if obj.lowercased() == self.peNewAssessment.siteName?.lowercased(){
                siteContain = true
            }
        }
        
        var evaluationContain = false
        
        for  obj  in evaluationIDs {
            if obj.lowercased() == self.peNewAssessment.evaluationName?.lowercased(){
                evaluationContain = true
            }
        }
 
        selectedEvaluationDateText.text = string
        self.peNewAssessment.evaluationDate = string
        
        scheduledAssessment?.scheduledDate = objDate
        PEAssessmentsDAO.sharedInstance.updateAssessmentStatus( userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: scheduledAssessment?.serverAssessmentId ?? "", assessmentobj: scheduledAssessment ?? peNewAssessment)
        checkBackAndSave()
    }
    
    func doneButtonTapped(string:String){
        
    }
}

// MARK: - Action Methods
extension PEStartNewAssessment{
    
    
    
    func okButtonTapped() {
        let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: scheduledAssessment?.serverAssessmentId ?? "")
        if Constants.isExtendedPopup && extendedPESwitch.isOn{
            if sanitationQuesArr.count == 0{
                if self.peNewAssessment.evaluationID != nil && self.peNewAssessment.evaluationID == 1{
                    showScheduledAndMicrobialPopup(VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_BOTH_DATE_MICROBIAL)
                }else{
                    showScheduledAndMicrobialPopup(VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_SCHEDULED_DATE)
                }
                
            }else{
                showScheduledAndMicrobialPopup(VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_SCHEDULED_DATE)
                //Only Scheduled Date
            }
        }else if Constants.isExtendedPopup{
            showScheduledAndMicrobialPopup(VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_SCHEDULED_DATE)
            //Only Scheduled Date
            
        }else if !Constants.isExtendedPopup{
            okAction()
        }
    }
    
    func showScheduledAndMicrobialPopup(_ msg:String){
        let errorMSg = msg
        //VaccinationConstants.PEConstants.WARNING_MSG_NEXTBTN_CLICK_EXTENDED_MICROBIAL
        
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.okAction()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func okAction(){
        checkBackAndSave()
        jsonRe = (getJSON("QuestionAns") ?? JSON())
        questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
        infoImageDataResponse = InfoImageDataResponse(questionInfo)
        pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
        if extendedPESwitch.isOn{
            let sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: scheduledAssessment?.serverAssessmentId ?? "")
            
            if sanitationQuesArr.count == 0{
                SanitationEmbrexQuestionMasterDAO.sharedInstance.saveAssessmentQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
            }
            
        }
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessment.evaluationID == object.evaluationID{
                
                if object.sequenceNo != 12{
                    peCategoryFilteredArray.append(object)
                }
            }
        }
        
        // let categoryCount = filterCategoryCount()
        if peCategoryFilteredArray.count > 0 {
            var peNewAssessmentWas = PENewAssessment()
            
            peNewAssessmentWas = self.peNewAssessment
            
            if handmixSwitch.isOn
            {
                peNewAssessmentWas.isHandMix = true
            }
            else
            {
                peNewAssessmentWas.isHandMix = false
            }
            
            if extendedPESwitch.isOn {
                
                peNewAssessmentWas.IsEMRequested = true
                peNewAssessmentWas.sanitationValue = true
                peNewAssessmentWas.extndMicro = true
            }
            else {
                peNewAssessmentWas.IsEMRequested = false
                peNewAssessmentWas.sanitationValue = false
                //Raman's code for extended microbial switch
                peNewAssessmentWas.extndMicro = false
                
            }
            CoreDataHandler().deleteAllData("PE_AssessmentInProgress",predicate: NSPredicate(format: "userID == %d AND serverAssessmentId = %@", peNewAssessmentWas.userID ?? 0, peNewAssessmentWas.serverAssessmentId ?? ""))
            CoreDataHandler().deleteAllData("PE_Refrigator")
            for  cat in  peCategoryFilteredArray {
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
                    peNewAssessmentNew.isChlorineStrip = self.peNewAssessment.isChlorineStrip
                    peNewAssessmentNew.isAutomaticFail = self.peNewAssessment.isAutomaticFail
                    peNewAssessmentNew.informationImage = ass.informationImage
                    peNewAssessmentNew.serverAssessmentId = peNewAssessmentWas.serverAssessmentId
                    peNewAssessmentNew.sanitationEmbrex = peNewAssessmentWas.sanitationEmbrex
                    peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                    peNewAssessmentNew.isAllowNA = ass.isAllowNA
                    peNewAssessmentNew.rollOut = ass.rollOut
                    peNewAssessmentNew.isNA = ass.isNA
                    peNewAssessmentNew.qSeqNo = ass.qSeqNo
                    peNewAssessmentNew.IsEMRequested = peNewAssessmentWas.IsEMRequested
                    peNewAssessmentNew.sanitationValue = peNewAssessmentWas.sanitationValue
                    peNewAssessmentNew.extndMicro = peNewAssessmentWas.extndMicro
                    peNewAssessmentNew.isHandMix = peNewAssessmentWas.isHandMix
                    peNewAssessmentNew.ppmValue = peNewAssessmentWas.ppmValue
                    CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:self.peNewAssessment)
                    
                    //PEInfoDAO.sharedInstance.saveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: self.peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: self.chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: extendedPESwitch.isOn, assessmentId: self.peNewAssessment.serverAssessmentId ?? "", date: nil,hasChlorineStrips: self.chlorineStripsSwitch.isOn, isAutomaticFail: self.isAutomaticSwitch.isOn)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                    //"" PANDEY
                }
            }
            if peNewAssessment.evaluationID != nil && peNewAssessment.evaluationID == 1{
                if extendedPESwitch.isOn{
                    
                }
            }
            isMovedForward = true
            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as? PEAssesmentFinalize
            vc?.peNewAssessment = self.peNewAssessment
            vc?.peNewAssessmentBack = self.peNewAssessment
            vc?.scheduledAssessment = scheduledAssessment
            
            UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
            UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
            UserDefaults.standard.synchronize()
            if vc != nil {
                self.navigationController?.pushViewController(vc!, animated: true)
                return
            }
        } else {
        }
        
        
        
    }
    
    
    func filterCategoryCount() -> Int {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessment.evaluationID == object.evaluationID{
                if object.id != 36{
                    peCategoryFilteredArray.append(object)
                }
                //                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
        return pECategoriesAssesmentsResponse.peCategoryArray.count
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
        
        
    }
    
    @IBAction func flockImageGreaterSlected(_ sender: Any) {
        
        if isFlockAgeGreaterTheAllProd {
            isFlockAgeGreaterTheAllProd = false
            btnFlockAgeGreater.setImage(UIImage(named: "uncheckIconPE"), for: .normal)
            isFlockAgeGreaterThen50Weeks = true
            btnFlockImageLower.setImage(UIImage(named: "checkIconPE"), for: .normal)
            self.peNewAssessment.isFlopSelected = 0
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
    
}

// MARK: - UITextViewDelegate

extension PEStartNewAssessment:UITextViewDelegate{
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
extension PEStartNewAssessment {
    
    internal func fetchtAssessmentCategoriesResponse(){
        isMovedForward = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as? PEAssesmentFinalize
        vc?.peNewAssessment = self.peNewAssessment
        vc?.peNewAssessmentBack = self.peNewAssessment
        vc?.scheduledAssessment = scheduledAssessment
        UserDefaults.standard.setValue(self.peNewAssessment.isChlorineStrip, forKey: "isChlorineStrip")
        UserDefaults.standard.setValue(self.peNewAssessment.isAutomaticFail, forKey: "isAutomaticFail")
        UserDefaults.standard.synchronize()
        
        if vc != nil {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    private func handleAssessmentCategoriesResponse(_ json: JSON) {
        
    }
    
    
}

// MARK: - UITextFieldDelegate

extension PEStartNewAssessment : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtBreedOfBirdsOthers{
            let superviewCurrent = btnBreedOthers.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if textField == manfacturerOtherTxt{
            let superviewCurrent =  manfacturerOtherBtn.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        if textField == eggsOtherTxt{
            let superviewCurrent =  eggsOtherBtn.superview
            if superviewCurrent != nil {
                for view in superviewCurrent!.subviews {
                    if view.isKind(of:UIButton.self) {
                        view.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                        view.layer.borderWidth = 2.0
                    }
                }
            }
        }
        
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
                self.peNewAssessment.noOfEggs =  iii//Int(iii)
            }
            
            checkBackAndSave()
        }
        
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.eggsOtherTxt {
            // return true if the string only contains numeric characters
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

extension String  {
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.stringWithoutWhitespaces.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    var stringWithoutWhitespaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    func containsCaseInsensitive(string : String) -> Bool {
        return self.localizedCaseInsensitiveContains(string)
    }
    
}

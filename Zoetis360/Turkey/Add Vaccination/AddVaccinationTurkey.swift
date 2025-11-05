//
//  AddVaccinationTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Reachability
import SystemConfiguration

class AddVaccinationTurkey: UIViewController,DropperDelegateTurkey,UITextFieldDelegate,feedPop {
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        hatchMarekStrainLbl.text = contents
    }
    
    
    // MARK: - VARIABLES
    var exitPopUP :feedPopUpTurkey!
    let buttonbg = UIButton ()
    var hatcStrain = NSArray()
    var fieldStrain = NSArray()
    var buttonTag = NSInteger()
    var btnTag = NSInteger()
    var fieldVaccinatioDataAray = NSArray()
    var postingIdFromExisting = NSNumber()
    var postingIdFromExistingNavigate = String()
    var postingId = NSNumber()
    var hatecheryArray = NSArray()
    var finalizeValue = NSNumber()
    var hatchStrainDrop = DropDown()
    var fieldStrainDrop = DropDown()
    var routeDrop = DropDown()
    var isClickOnAnyField = Bool()
    var lngId = NSInteger()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataArray = NSArray ()
    var index = 10
    
    // MARK: - Outlet
    @IBOutlet weak var vaccinationPrgrmTextField: UITextField!
    @IBOutlet weak var hatcheryBtnOutlet: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var fieldVaccinationOutlet: UIButton!
    
    
    
    @IBOutlet weak var hatcherView: UIView!
    
    @IBOutlet weak var ibdvStrainBtnOutlet: UIButton!
    @IBOutlet weak var ibdv1StrainBtnOutlet: UIButton!
    @IBOutlet weak var ibdStrainBtnOutlet: UIButton!
    @IBOutlet weak var ibv1StrainBtnOutlet: UIButton!
    @IBOutlet weak var trtStrainBtnOutlet: UIButton!
    @IBOutlet weak var trt1StrainBtnOutlet: UIButton!
    @IBOutlet weak var ndvStrainBtnOutlet: UIButton!
    @IBOutlet weak var ndv1StrainBtnOutlet: UIButton!
    @IBOutlet weak var stStrainBtnOutlet: UIButton!
    @IBOutlet weak var ecoliStrainBtnOutlet: UIButton!
    @IBOutlet weak var otherStrainBtnOutlet: UIButton!
    
    // MARK: - Field Vaccination Outlet Label
    @IBOutlet weak var vacciIbdv1StrainLbl: UILabel!
    @IBOutlet weak var vacciIbdv2StrainLbl: UILabel!
    @IBOutlet weak var vacciIbv1StrainLbl: UILabel!
    @IBOutlet weak var vacciIbv2StrainLbl: UILabel!
    @IBOutlet weak var vacciTrtStrainLbl: UILabel!
    @IBOutlet weak var vacciTrt2StrainLbl: UILabel!
    @IBOutlet weak var vacciNdv1StrainLbl: UILabel!
    @IBOutlet weak var vacciNdv2StrainLbl: UILabel!
    @IBOutlet weak var vacciStStrainLbl: UILabel!
    @IBOutlet weak var vacciEcoliStrainLbl: UILabel!
    @IBOutlet weak var vacciOthersStrainLbl: UILabel!
    
    @IBOutlet weak var marekStrainOutlet: UIButton!
    @IBOutlet weak var ibdvStrainOutlet: UIButton!
    @IBOutlet weak var ibvStrainOutlet: UIButton!
    @IBOutlet weak var trtStrainOutlet: UIButton!
    @IBOutlet weak var ndvStrainOutlet: UIButton!
    @IBOutlet weak var poxStrainOutlet: UIButton!
    @IBOutlet weak var reoStrainOutlet: UIButton!
    @IBOutlet weak var stStrainOutlet: UIButton!
    @IBOutlet weak var ecoliStrainOutlet: UIButton!
    @IBOutlet weak var othersStrainOutlet: UIButton!
    
    @IBOutlet weak var hatchMarekStrainField: UILabel!
    @IBOutlet weak var ibdvMarekStrainField: UILabel!
    @IBOutlet weak var ibvMarekStrainField: UILabel!
    @IBOutlet weak var trtMarekStrainField: UILabel!
    @IBOutlet weak var ndvMarekStrainField: UILabel!
    @IBOutlet weak var poxMarekStrainField: UILabel!
    @IBOutlet weak var reoMarekStrainField: UILabel!
    @IBOutlet weak var stMarekStrainField: UILabel!
    @IBOutlet weak var ecoliMarekStrainField: UILabel!
    @IBOutlet weak var othersMarekStrainField: UILabel!
    
    @IBOutlet weak var vacciIbdv1StrainField: UILabel!
    @IBOutlet weak var vacciIbdv2StrainField: UILabel!
    @IBOutlet weak var vacciIbv1StrainField: UILabel!
    @IBOutlet weak var vacciIbv2StrainField: UILabel!
    @IBOutlet weak var vacciTrtStrainField: UILabel!
    @IBOutlet weak var vacciTrt2StrainField: UILabel!
    @IBOutlet weak var vacciNdv1StrainField: UILabel!
    @IBOutlet weak var vacciNdv2StrainField: UILabel!
    @IBOutlet weak var vacciStStrainField: UILabel!
    @IBOutlet weak var vacciEcoliStrainField: UILabel!
    @IBOutlet weak var vacciOthersStrainField: UILabel!
    
    // MARK: - Hatchery Outlet Label
    @IBOutlet weak var hatchMarekStrainLbl: UILabel!
    @IBOutlet weak var ibdvMarekStrainLbl: UILabel!
    @IBOutlet weak var ibvMarekStrainLbl: UILabel!
    @IBOutlet weak var trtMarekStrainLbl: UILabel!
    @IBOutlet weak var ndvMarekStrainLbl: UILabel!
    @IBOutlet weak var poxMarekStrainLbl: UILabel!
    @IBOutlet weak var reoMarekStrainLbl: UILabel!
    @IBOutlet weak var stMarekStrainLbl: UILabel!
    @IBOutlet weak var ecoliMarekStrainLbl: UILabel!
    @IBOutlet weak var othersMarekStrainLbl: UILabel!
    
    // MARK: - Hatchery Button Outlet
    @IBOutlet weak var hatchMarekRouteOutlet: UIButton!
    @IBOutlet weak var hatchIbdvRouteOutlet: UIButton!
    @IBOutlet weak var hatchibvRouteOutlet: UIButton!
    @IBOutlet weak var hatchTrtRouteOutlet: UIButton!
    @IBOutlet weak var hatchNdvRouteOutlet: UIButton!
    @IBOutlet weak var hatchPoxRouteOutlet: UIButton!
    @IBOutlet weak var hatchReoRouteOutlet: UIButton!
    @IBOutlet weak var hatchStRouteOutlet: UIButton!
    @IBOutlet weak var hatchEcoliRouteOutlet: UIButton!
    @IBOutlet weak var hatchOthersRouteOutlet: UIButton!
    
    // MARK: - Field Vaccination Outlet
    @IBOutlet weak var fieldVaccinationView: UIView!
    @IBOutlet weak var vacciIbdv1AgeField: UITextField!
    @IBOutlet weak var vacciIbdv2AgeField: UITextField!
    @IBOutlet weak var vacciIbv1AgeField: UITextField!
    @IBOutlet weak var vacciIbv2AgeField: UITextField!
    @IBOutlet weak var vacciTrtAgeField: UITextField!
    @IBOutlet weak var vacciTrt2AgeField: UITextField!
    @IBOutlet weak var vacciNdv1AgeField: UITextField!
    @IBOutlet weak var vacciNdv2AgeField: UITextField!
    @IBOutlet weak var vacciStAgeField: UITextField!
    @IBOutlet weak var vacciEcoliAgeField: UITextField!
    @IBOutlet weak var vacciOthersAgeField: UITextField!
    
    // MARK: - Field Vaccination Button Outlet
    @IBOutlet weak var vacciIbdv1Outlet: UIButton!
    @IBOutlet weak var vacciIbdv2Outlet: UIButton!
    @IBOutlet weak var vacciIbv1Outlet: UIButton!
    @IBOutlet weak var vacciIbv2Outlet: UIButton!
    @IBOutlet weak var vacciTrtOutlet: UIButton!
    @IBOutlet weak var vacciTrt2Outlet: UIButton!
    @IBOutlet weak var vacciNdv1Outlet: UIButton!
    @IBOutlet weak var vacciNdv2Outlet: UIButton!
    @IBOutlet weak var vacciStOutlet: UIButton!
    @IBOutlet weak var vacciEcoliOutlet: UIButton!
    @IBOutlet weak var vacciOthersOutlet: UIButton!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var doneBTNoutlet: UIButton!
    
    
    @IBOutlet weak var typeMarek: UILabel!
    @IBOutlet weak var typeIbdv: UILabel!
    @IBOutlet weak var typeIbv: UILabel!
    @IBOutlet weak var typeTrt: UILabel!
    @IBOutlet weak var typeNdv: UILabel!
    @IBOutlet weak var typePox: UILabel!
    @IBOutlet weak var typeReo: UILabel!
    @IBOutlet weak var typeSt: UILabel!
    @IBOutlet weak var typeEColi: UILabel!
    @IBOutlet weak var typeOthers: UILabel!
    
    @IBOutlet weak var type0: UILabel!
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var type3: UILabel!
    @IBOutlet weak var type4: UILabel!
    @IBOutlet weak var type5: UILabel!
    @IBOutlet weak var type6: UILabel!
    @IBOutlet weak var type7: UILabel!
    @IBOutlet weak var type8: UILabel!
    @IBOutlet weak var type9: UILabel!
    @IBOutlet weak var type10: UILabel!
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        hatcStrain = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "HatcheryStrain")
        fieldStrain = CoreDataHandler().fetchDataDatabaseWithEntity(entityName: "GetFieldStrain")
        
        hatecheryArray =  CoreDataHandlerTurkey().fetchRouteTurkeyLngId(lngId: 1)
        self.buttonLayoutSet()
        fieldVaccinationView.isHidden = true
        hatcherView.isHidden = false
        isClickOnAnyField = false
        
        defaultBoundryColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        doneBTNoutlet.isHidden = false
        hatcherView.isUserInteractionEnabled = true
        fieldVaccinationView.isUserInteractionEnabled = true
        vaccinationPrgrmTextField.isUserInteractionEnabled = true
        
        buttonLayoutSet()
    }
    override func viewDidLayoutSubviews() {
        buttonLayoutSet()
    }
    
    // MARK: - IBACTION
    @IBAction func tapOnHatcheryViewAction(_ sender: Any) {
        
        hatcherView.endEditing(true)
        fieldVaccinationView.endEditing(true)
        mainView.endEditing(true)
        hideDropDownTurkey()
    }
    
    @IBAction func tapVaccinationViewAction(_ sender: Any) {
        hideDropDownTurkey()
        mainView.endEditing(true)
        fieldVaccinationView.endEditing(true)
    }
    
    @IBAction func fieldVaccinationAction(_ sender: UIButton) {
        btnTag = 1
        hatcheryBtnOutlet.setImage(UIImage(named: "hatchery_unselected_btn"), for: UIControl.State())
        fieldVaccinationOutlet.setImage(UIImage(named: "field_vaccination_select_btn"), for: UIControl.State())
        hatcherView.isHidden = true
        fieldVaccinationView.isHidden = false
        self.view.endEditing(true)
    }
    
    
    @IBAction func hatcheryBtnAction(_ sender: UIButton) {
        btnTag = 0
        hatcheryBtnOutlet.setImage(UIImage(named: "hatchery_selected_btn"), for: UIControl.State())
        fieldVaccinationOutlet.setImage(UIImage(named: "field_vaccination_unselect_btn"), for: UIControl.State())
        fieldVaccinationView.isHidden = true
        hatcherView.isHidden = false
        
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        btnTag = 2
        Constants.isFromPsoting = true
        UserDefaults.standard.set(true, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        allSaveData(btnTag)
    }
    
    @IBAction func bckBtnAction(_ sender: UIButton) {
        btnTag = 1
        allSaveData(btnTag)
    }
    
    @IBAction func hatchMarekRouteAction(_ sender: UIButton) {
        sender.tag = 50
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchIbdvRouteAction(_ sender: UIButton) {
        sender.tag = 51
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    @IBAction func hatchIbvRouteAction(_ sender: UIButton) {
        sender.tag = 52
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchTrtRouteAction(_ sender: UIButton) {
        sender.tag = 53
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchNdvRouteAction(_ sender: UIButton) {
        sender.tag = 54
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchPoxRouteAction(_ sender: UIButton) {
        sender.tag = 55
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchReoRouteAction(_ sender: UIButton) {
        sender.tag = 56
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchStRouteAction(_ sender: UIButton) {
        sender.tag = 57
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func hatchEcoliRouteAction(_ sender: UIButton) {
        sender.tag = 58
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        
    }
    
    @IBAction func hatchOtherRouteAction(_ sender: UIButton) {
        sender.tag = 59
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbdv1Strain(_ sender: UIButton) {
        sender.tag = 61
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbdv2Strain(_ sender: UIButton) {
        sender.tag = 62
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbvStrain(_ sender: UIButton) {
        sender.tag = 63
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbv2Strain(_ sender: UIButton) {
        sender.tag = 64
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    @IBAction func vacciTrtStrain(_ sender: UIButton) {
        sender.tag = 65
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    @IBAction func vacciTrt2Strain(_ sender: UIButton) {
        sender.tag = 66
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    @IBAction func vacciNdvStrain(_ sender: UIButton) {
        sender.tag = 67
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciNdv2Strain(_ sender: UIButton) {
        sender.tag = 68
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        
    }
    
    @IBAction func vacciSTStrain(_ sender: UIButton) {
        sender.tag = 69
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciEcoliStrain(_ sender: UIButton) {
        sender.tag = 70
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
        
    }
    
    
    @IBAction func vacciOthersStrain(_ sender: UIButton) {
        sender.tag = 71
        self.showHatcheryRouteDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    // MARK: - TEXTFIELD DELEGATES
    func textFieldDidEndEditing(_ textField: UITextField) {
        isClickOnAnyField = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DropperTurkey.sharedInstance.hideWithAnimation(0.1)
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DropperTurkey.sharedInstance.hideWithAnimation(0.1)
        
        if (textField ==  hatchMarekStrainField ) {
            print(appDelegateObj.testFuntion())
        }
        else {
            vaccinationPrgrmTextField.returnKeyType = UIReturnKeyType.done
            vacciIbdv1AgeField.returnKeyType = UIReturnKeyType.done
            vacciIbdv2AgeField.returnKeyType = UIReturnKeyType.done
            vacciIbv1AgeField.returnKeyType =  UIReturnKeyType.done
            vacciIbv2AgeField.returnKeyType =  UIReturnKeyType.done
            vacciTrtAgeField.returnKeyType =  UIReturnKeyType.done
            vacciTrt2AgeField.returnKeyType =  UIReturnKeyType.done
            vacciNdv1AgeField.returnKeyType =  UIReturnKeyType.done
            vacciNdv2AgeField.returnKeyType =  UIReturnKeyType.done
            vacciStAgeField.returnKeyType =  UIReturnKeyType.done
            vacciEcoliAgeField.returnKeyType =  UIReturnKeyType.done
            vacciOthersAgeField.returnKeyType = UIReturnKeyType.done
        }
        
        if vacciIbdv1StrainField.text == "" {
            vacciIbdv1AgeField.isUserInteractionEnabled = false
            
        }
        if vacciIbdv2StrainField.text == "" {
            vacciIbdv2AgeField.isUserInteractionEnabled = false
            
        }
        if vacciIbv1StrainField.text == "" {
            vacciIbv1AgeField.isUserInteractionEnabled = false
            
        }
        if vacciIbv2StrainField.text == "" {
            vacciIbv2AgeField.isUserInteractionEnabled = false
            
        }
        if vacciTrtStrainField.text == "" {
            vacciTrtAgeField.isUserInteractionEnabled = false
            
        }
        if vacciTrt2StrainField.text == "" {
            vacciTrt2AgeField.isUserInteractionEnabled = false
            
        }
        if vacciNdv1StrainField.text == "" {
            vacciNdv1AgeField.isUserInteractionEnabled = false
            
        }
        if vacciNdv2StrainField.text == "" {
            vacciNdv2AgeField.isUserInteractionEnabled = false
            
        }
        if vacciStStrainField.text == "" {
            vacciStAgeField.isUserInteractionEnabled = false
            
        }
        if vacciEcoliStrainField.text == "" {
            vacciEcoliAgeField.isUserInteractionEnabled = false
            
        }
        if vacciOthersStrainField.text == "" {
            vacciOthersAgeField.isUserInteractionEnabled = false
            self.vacciOthersAgeField.tintColor = .clear
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 11,12,13,14,15,16,17,18,19,30,31,40,50,21,22,23,24,25,26,27,28,29,20 :
            
            let aSet = CharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return string == numberFiltered && newString.length <= maxLength
            
        case 1 : break
            
        default : break
            
        }
        isClickOnAnyField = true
        if textField == vaccinationPrgrmTextField{
            let ACCEPTED_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£"
            let set = CharacterSet(charactersIn: ACCEPTED_CHARACTERS)
            let inverted = set.inverted
            let filtered = string.components(separatedBy: inverted).joined(separator: "")
            return filtered == string
        }
        
        return true
    }
    
    // MARK: - METHODS AND FUNCTIONS
    fileprivate func saveHatcheryStrainData(_ i: Int) {
        if i == 0 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeMarek.text!,
                strain: hatchMarekStrainField.text!,
                route: hatchMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
        } else if i == 1 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeIbdv.text!,
                strain: ibdvMarekStrainField.text!,
                route: ibdvMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
        } else if i == 2 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeIbv.text!,
                strain: ibvMarekStrainField.text!,
                route: ibvMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
        } else if i == 3 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeTrt.text!,
                strain: trtMarekStrainField.text!,
                route: trtMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
            
        } else if i == 4 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeNdv.text!,
                strain: ndvMarekStrainField.text!,
                route: ndvMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
            
        } else if i == 5 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typePox.text!,
                strain: poxMarekStrainField.text!,
                route: poxMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
        }
        else if i == 6 {
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeReo.text!,
                strain: reoMarekStrainField.text!,
                route: reoMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
        }
        else if i == 7{
            
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeSt.text!,
                strain: stMarekStrainField.text!,
                route: stMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
        }
        else if i == 8{
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeEColi.text!,
                strain: ecoliMarekStrainField.text!,
                route: ecoliMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
            
            
        }else if i == 9{
            
            let hatcheryStrnData = CoreDataHandlerTurkeyModels.turkyVaccinationData(
                type: typeOthers.text!,
                strain: othersMarekStrainField.text!,
                route: othersMarekStrainLbl.text!,
                index: i,
                dbArray: fieldVaccinatioDataAray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveFieldVacinationInDatabaseTurkey(vaccinationData: hatcheryStrnData)
        }
    }
    
    fileprivate func saveFieldStrainData(_ i: Int) {
        if i == 0 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type0.text!,
                strain: vacciIbdv1StrainField.text!,
                route: vacciIbdv1StrainLbl.text!,
                age: vacciIbdv1AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
            
        }
        
        else if i == 1 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type1.text!,
                strain: vacciIbdv2StrainField.text!,
                route: vacciIbdv2StrainLbl.text!,
                age: vacciIbdv2AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
            
        }
        
        else if i == 2 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type2.text!,
                strain: vacciIbv1StrainField.text!,
                route: vacciIbv1StrainLbl.text!,
                age: vacciIbv1AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 3 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type3.text!,
                strain: vacciIbv2StrainField.text!,
                route: vacciIbv2StrainLbl.text!,
                age: vacciIbv2AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 4 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type4.text!,
                strain: vacciTrtStrainField.text!,
                route: vacciTrtStrainLbl.text!,
                age: vacciTrtAgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
            
        }
        
        else if i == 5 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type5.text!,
                strain: vacciTrt2StrainField.text!,
                route: vacciTrt2StrainLbl.text!,
                age: vacciTrt2AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 6 {
            
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type6.text!,
                strain: vacciNdv1StrainField.text!,
                route: vacciNdv1StrainLbl.text!,
                age: vacciNdv1AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 7 {
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type7.text!,
                strain: vacciNdv2StrainField.text!,
                route: vacciNdv2StrainLbl.text!,
                age: vacciNdv2AgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 8 {
            
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type8.text!,
                strain: vacciStStrainField.text!,
                route: vacciStStrainLbl.text!,
                age: vacciStAgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 9 {
            
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type9.text!,
                strain: vacciEcoliStrainField.text!,
                route: vacciEcoliStrainLbl.text!,
                age: vacciEcoliAgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
        
        else if i == 10{
            let fieldStrainData = CoreDataHandlerTurkeyModels.turkeyfieldStrnVaccination(
                type: type10.text!,
                strain: vacciOthersStrainField.text!,
                route: vacciOthersStrainLbl.text!,
                age: vacciOthersAgeField.text!,
                index: i,
                dbArray: dataArray,
                postingId: postingId,
                vaciProgram: vaccinationPrgrmTextField.text!,
                sessionId: 1,
                isSync: true,
                lngId: lngId as NSNumber
            )
            CoreDataHandlerTurkey().saveHatcheryVacinationInDatabaseTurkey(vaccination: fieldStrainData)
        }
    }
    
    ///////////////////////////////////////////
    func allSaveData( _ btnTag : Int)  {
        var trimmedString = vaccinationPrgrmTextField.text!.trimmingCharacters(in: .whitespaces)
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        vaccinationPrgrmTextField.text = trimmedString
        if trimmedString == ""{
            if btnTag == 1 {
                appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.isDoneClick = true
                self.navigationController?.popViewController(animated: true)
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter the vaccination program.", comment: ""))
            }
        }  else {
            if isClickOnAnyField == true
            {
                isClickOnAnyField = false
                
                for i in 0..<10 {
                    
                    saveHatcheryStrainData(i)
                }
                
                /////////Hatchery////////
                
                for i in 0..<11 {
                    
                    saveFieldStrainData(i)
                }
                
                CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingId)
                UserDefaults.standard.set(vaccinationPrgrmTextField.text!, forKey: "vaci")
                UserDefaults.standard.synchronize()
            }
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isDoneClick = true
            self.navigationController?.popViewController(animated: true)
        }
        appDelegate.sendFeedVariable = "vaccination"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        hatcherView.endEditing(true)
        fieldVaccinationView.endEditing(true)
        view.endEditing(true)
    }
    
    func animateView (_ movement : CGFloat){
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement);
        })
    }
    
    
    func showExitAlertWith(msg: String,tag: Int) {
        
        exitPopUP = feedPopUpTurkey.loadFromNibNamed("feedPopUpTurkey") as! feedPopUpTurkey
        exitPopUP.lblFedPrgram.text = msg
        exitPopUP.tag = tag
        exitPopUP.lblFedPrgram.textAlignment = .center
        exitPopUP.delegatefeedPop = self
        exitPopUP.center = self.view.center
        self.view.addSubview(exitPopUP)
        
    }
    func yesBtnPop() {
        print(appDelegateObj.testFuntion())
    }
    //////
    func noBtnPop() {
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            // Update posting session
            CoreDataHandlerTurkey().updatePostingSessionOndashBoardTurkey(self.postingId as NSNumber, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
            CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(self.postingId as NSNumber)
            CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(self.postingId as NSNumber)
        }
        else{
            CoreDataHandlerTurkey().deleteDataWithPostingIdTurkey(self.postingId as NSNumber)
            CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(self.postingId as NSNumber)
            CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(self.postingId as NSNumber)
        }
        for dashboard in (self.navigationController?.viewControllers)! {
            if dashboard.isKind(of: DashViewControllerTurkey.self){
                self.navigationController?.popToViewController(dashboard, animated: true)
            }
        }
    }
    
    
    
    func alertShow()  {
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter strain.", comment: ""))
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
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
    // MARK: - 🎛 Set Button Layout
    
    func buttonLayoutSet(){
        
        // Create an array of all the buttons
        let buttons: [UIButton] = [
            vacciIbdv1Outlet, vacciIbdv2Outlet, vacciIbv1Outlet, vacciIbv2Outlet, vacciTrtOutlet,
            vacciTrt2Outlet, vacciNdv1Outlet, vacciNdv2Outlet, vacciStOutlet, vacciEcoliOutlet,
            vacciOthersOutlet, hatchOthersRouteOutlet, hatchStRouteOutlet, hatchEcoliRouteOutlet,
            hatchPoxRouteOutlet, hatchReoRouteOutlet, hatchMarekRouteOutlet, hatchIbdvRouteOutlet,
            hatchibvRouteOutlet, hatchTrtRouteOutlet, hatchNdvRouteOutlet
        ]
        
        // Loop through each button and apply the layer properties
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 3.5
            button.layer.borderColor = UIColor.black.cgColor
        }
        
        // Create an array of all the Text fields
        let ageFields: [UITextField] = [
            vacciIbdv1AgeField, vacciIbdv2AgeField, vacciIbv1AgeField, vacciIbv2AgeField, vacciTrtAgeField,
            vacciTrt2AgeField, vacciNdv1AgeField, vacciNdv2AgeField, vacciStAgeField, vacciEcoliAgeField,
            vacciOthersAgeField
        ]
        
        // Loop through each text field and set the left padding view
        for textField in ageFields {
            let paddingView = UIView(frame: CGRect(x: 8, y: 0, width: 10, height: 20))
            textField.leftView = paddingView
            textField.resignFirstResponder()
            textField.leftViewMode = .always
            textField.delegate = self
            
        }
        
        vacciIbdv1StrainField.resignFirstResponder()
        vacciIbdv2StrainField.resignFirstResponder()
        vacciIbv1StrainField.resignFirstResponder()
        vacciIbv2StrainField.resignFirstResponder()
        vacciTrtStrainField.resignFirstResponder()
        vacciTrt2StrainField.resignFirstResponder()
        vacciNdv1StrainField.resignFirstResponder()
        vacciNdv2StrainField.resignFirstResponder()
        vacciStStrainField.resignFirstResponder()
        vacciEcoliStrainField.resignFirstResponder()
        vacciOthersStrainField.resignFirstResponder()
        
        hatchMarekStrainField.resignFirstResponder()
        ibdvMarekStrainField.resignFirstResponder()
        ibvMarekStrainField.resignFirstResponder()
        trtMarekStrainField.resignFirstResponder()
        ndvMarekStrainField.resignFirstResponder()
        poxMarekStrainField.resignFirstResponder()
        reoMarekStrainField.resignFirstResponder()
        stMarekStrainField.resignFirstResponder()
        ecoliMarekStrainField.resignFirstResponder()
        othersMarekStrainField.resignFirstResponder()
        
        let cusPaddingView = UIView(frame: CGRect(x: 8, y: 0, width: 10, height: 20))
        vaccinationPrgrmTextField.leftView = cusPaddingView
        vaccinationPrgrmTextField.leftViewMode = .always
        
        if postingIdFromExistingNavigate == "Exting"{
            postingId = postingIdFromExisting
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId") as NSNumber
        }
        
        
        dataArray = CoreDataHandlerTurkey().fetchAddvacinationDataTurkey(postingId)
        
        if dataArray.count > 0 {
            
            for i in 0..<dataArray.count{
                
                vacciIbdv1StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 0) as? String
                vacciIbdv2StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 1) as? String
                vacciIbv1StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 2) as? String
                vacciIbv2StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 3) as? String
                vacciTrtStrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 4) as? String
                vacciTrt2StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 5) as? String
                vacciNdv1StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 6) as? String
                vacciNdv2StrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 7) as? String
                vacciStStrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 8) as? String
                vacciEcoliStrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 9) as? String
                vacciOthersStrainField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 10) as? String
                ///// age
                vacciIbdv1StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 0) as? String
                vacciIbdv2StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 1) as? String
                vacciIbv1StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 2) as? String
                vacciIbv2StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 3) as? String
                vacciTrtStrainLbl.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 4) as? String
                vacciTrt2StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 5) as? String
                vacciNdv1StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 6) as? String
                vacciNdv2StrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 7) as? String
                vacciStStrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 8) as? String
                vacciEcoliStrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 9) as? String
                vacciOthersStrainLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 10) as? String
                
                vacciIbdv1AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 0) as? String
                vacciIbdv2AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 1) as? String
                vacciIbv1AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 2) as? String
                vacciIbv2AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 3) as? String
                vacciTrtAgeField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 4) as? String
                vacciTrt2AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 5) as? String
                vacciNdv1AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 6) as? String
                vacciNdv2AgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 7) as? String
                vacciStAgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 8) as? String
                vacciEcoliAgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 9) as? String
                vacciOthersAgeField.text = (dataArray.value(forKey: "age") as AnyObject).object(at: 10) as? String
                vaccinationPrgrmTextField.text = (dataArray.value(forKey: "vaciNationProgram") as AnyObject).object(at: 0) as? String
            }
        }
        /************ Fetching all data  From Database **************************/
        
        if postingIdFromExistingNavigate == "Exting"{
            postingId = postingIdFromExisting
        }  else {
            postingId = UserDefaults.standard.integer(forKey: "postingId")  as NSNumber
        }
        
        fieldVaccinatioDataAray = CoreDataHandlerTurkey().fetchFieldAddvacinationDataTurkey(postingId)
        
        if fieldVaccinatioDataAray.count > 0 {
            
            for i in 0..<fieldVaccinatioDataAray.count{
                
                hatchMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 0) as? String
                ibdvMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 1) as? String
                ibvMarekStrainField.text = (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 2) as? String
                trtMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 3) as? String
                ndvMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 4) as? String
                poxMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 5) as? String
                reoMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 6) as? String
                stMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 7) as? String
                ecoliMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 8) as? String
                othersMarekStrainField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 9) as? String
                
                hatchMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 0) as? String
                ibdvMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 1) as? String
                ibvMarekStrainLbl.text = (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 2) as? String
                trtMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 3) as? String
                ndvMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 4) as? String
                poxMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 5) as? String
                reoMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 6) as? String
                stMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 7) as? String
                ecoliMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 8) as? String
                othersMarekStrainLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 9) as? String
            }
        }
    }
    
    // MARK: - 🎨 Set Default Boundary Colors , Border & Width
    func defaultBoundryColor(){
        // Create an array of all strain buttons and outlets
        let strainButtons: [UIButton] = [
            ibdvStrainBtnOutlet, ibdv1StrainBtnOutlet, ibdStrainBtnOutlet, ibv1StrainBtnOutlet,
            trtStrainBtnOutlet, trt1StrainBtnOutlet, ndvStrainBtnOutlet, ndv1StrainBtnOutlet,
            stStrainBtnOutlet, ecoliStrainBtnOutlet, otherStrainBtnOutlet, marekStrainOutlet,
            ibdvStrainOutlet, ibvStrainOutlet, trtStrainOutlet, ndvStrainOutlet, poxStrainOutlet,
            reoStrainOutlet, stStrainOutlet, ecoliStrainOutlet, othersStrainOutlet
        ]
        // Loop through each button and apply border styling
        for button in strainButtons {
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 3.5
            button.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // MARK: - 💉 ***************************** Field Strain's Buttons *****************************
    // MARK: - 💉 IBDV Field Vaccination Button Action
    @IBAction func ibdvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 11
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 IBDV1 Field Vaccination Button Action
    @IBAction func ibdv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 12
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 IBV Field Vaccination Button Action
    @IBAction func ibvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 13
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 IBV1 Field Vaccination Button Action
    @IBAction func ibv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 14
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 TRT Field Vaccination Button Action
    @IBAction func trtStrainBtnClick(_ sender: UIButton) {
        sender.tag = 15
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 TRT1 Field Vaccination Button Action
    @IBAction func trt1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 16
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 NDV Field Vaccination Button Action
    @IBAction func ndvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 17
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 NDV1 Field Vaccination Button Action
    @IBAction func ndv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 18
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 💉 ST Field Vaccination Button Action
    @IBAction func stStrainBtnClick(_ sender: UIButton) {
        sender.tag = 19
        self.showFieldStrainDropdown(sender: sender)
        
    }
    // MARK: - 💉 E. coli Field Vaccination Button Action
    @IBAction func ecoliStrainBtnClick(_ sender: UIButton) {
        sender.tag = 20
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
        
    }
    
    @IBAction func othersStrainBtnClick(_ sender: UIButton) {
        sender.tag = 21
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 ***************************** Hatchery Strain's Buttons *****************************
    // MARK: - 🦠 Marek Hatchery Strain Button Action
    @IBAction func marekStrainAction(_ sender: UIButton) {
        sender.tag = 31
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
        
    }
    // MARK: - 🦠 IBDV Hatchery Strain Button Action
    @IBAction func ibdvStrainAction(_ sender: UIButton) {
        sender.tag = 32
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
        
    }
    // MARK: - 🦠 IBV Hatchery Strain Button Action
    @IBAction func ibvStrainAction(_ sender: UIButton) {
        sender.tag = 33
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 TRT Hatchery Strain Button Action
    @IBAction func trtStrainAction(_ sender: UIButton) {
        sender.tag = 34
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 NDV Hatchery Strain Button Action
    @IBAction func ndvStrainAction(_ sender: UIButton) {
        sender.tag = 35
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 Pox Hatchery Strain Button Action
    @IBAction func poxStrainBtn(_ sender: UIButton) {
        sender.tag = 36
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 Reo Hatchery Strain Button Action
    @IBAction func reoBtnAction(_ sender: UIButton) {
        sender.tag = 37
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 ST Hatchery Strain Button Action
    @IBAction func stStrainOutlet(_ sender: UIButton) {
        sender.tag = 38
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    // MARK: - 🦠 E. coli Hatchery Strain Button Action
    @IBAction func ecoliStrainAction(_ sender: UIButton) {
        sender.tag = 39
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
    
    @IBAction func othersStrainAction(_ sender: UIButton) {
        sender.tag = 40
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
        self.view.endEditing(true)
    }
}

// MARK: - // 🧩 ************************* EXTENSION ************************* //
extension AddVaccinationTurkey{
    // MARK: - 🦃 Show Hatchery Strain Dropdown & Set value
    func showHatchStrainDropdown(sender: UIButton){
        let hatchStrainInfoDict = CoreDataHandler().fetchStrainWithlanguage(entityName: "HatcheryStrain", lngID: lngId)
        let strainNameArray = hatchStrainInfoDict.value(forKeyPath: "strainName")
        hatchStrainDrop.dataSource = strainNameArray as! [AnyObject]
        hatchStrainDrop.anchorView = sender //5
        hatchStrainDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        hatchStrainDrop.show()
        hatchStrainDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if sender.tag == 31 {
                self?.hatchMarekStrainField.text = item
            }
            else if sender.tag == 32 {
                self?.ibdvMarekStrainField.text = item
            }
            else if sender.tag == 33 {
                self?.ibvMarekStrainField.text = item
            }
            else if sender.tag == 34 {
                self?.trtMarekStrainField.text = item
            }
            else if sender.tag == 35 {
                self?.ndvMarekStrainField.text = item
            }
            else if sender.tag == 36 {
                self?.poxMarekStrainField.text = item
            }
            else if sender.tag == 37 {
                self?.reoMarekStrainField.text = item
            }
            else if sender.tag == 38 {
                self?.stMarekStrainField.text = item
            }
            else if sender.tag == 39 {
                self?.ecoliMarekStrainField.text = item
            }
            else if sender.tag == 40 {
                self?.othersMarekStrainField.text = item
            }
        }
    }
    // MARK: - 🦃 Show Field Strain Dropdown
    func showFieldStrainDropdown(sender: UIButton){
        let fieldStrainInfoDict = CoreDataHandler().fetchStrainWithlanguage(entityName: "GetFieldStrain", lngID: lngId)
        let strainNameArray = fieldStrainInfoDict.value(forKeyPath: "strainName")
        fieldStrainDrop.dataSource = strainNameArray as! [AnyObject]
        fieldStrainDrop.anchorView = sender //5
        fieldStrainDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        fieldStrainDrop.show()
        fieldStrainDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if sender.tag == 11 {
                self?.vacciIbdv1StrainField.text = item
            }else if sender.tag == 12 {
                self?.vacciIbdv2StrainField.text = item
            }else if sender.tag == 13 {
                self?.vacciIbv1StrainField.text = item
            }else if sender.tag == 14 {
                self?.vacciIbv2StrainField.text = item
            }else  if sender.tag == 15 {
                self?.vacciTrtStrainField.text = item
            }else if sender.tag == 16 {
                self?.vacciTrt2StrainField.text = item
            }else if sender.tag == 17 {
                self?.vacciNdv1StrainField.text = item
            }else if sender.tag == 18 {
                self?.vacciNdv2StrainField.text = item
            }else if sender.tag == 19 {
                self?.vacciStStrainField.text = item
            }else if sender.tag == 20 {
                self?.vacciEcoliStrainField.text = item
            } else if sender.tag == 21 {
                self?.vacciOthersStrainField.text = item
            }
        }
    }
    // MARK: - 🦃 Show Hatchery Route Dropdown
    func showHatcheryRouteDropdown(sender: UIButton) {
        let vaccInfoDict = CoreDataHandlerTurkey().fetchRouteTurkeyLngId(lngId: lngId as NSNumber)
        let routeNameArray = vaccInfoDict.value(forKeyPath: "routeName")
        routeDrop.dataSource = routeNameArray as! [AnyObject]
        routeDrop.anchorView = sender
        routeDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        routeDrop.show()
        
        routeDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.assignLabelBasedOnTag(sender: sender, item: item)
        }
    }
    // MARK: - 🦃 Assign Hatchery Route Label Text Based on Button Tag
    private func assignLabelBasedOnTag(sender: UIButton, item: String) {
        switch sender.tag {
        case 50: hatchMarekStrainLbl.text = item
        case 51: ibdvMarekStrainLbl.text = item
        case 52: ibvMarekStrainLbl.text = item
        case 53: trtMarekStrainLbl.text = item
        case 54: ndvMarekStrainLbl.text = item
        case 55: poxMarekStrainLbl.text = item
        case 56: reoMarekStrainLbl.text = item
        case 57: stMarekStrainLbl.text = item
        case 58: ecoliMarekStrainLbl.text = item
        case 59: othersMarekStrainLbl.text = item
        case 61: vacciIbdv1StrainLbl.text = item
        case 62: vacciIbdv2StrainLbl.text = item
        case 63: vacciIbv1StrainLbl.text = item
        case 64: vacciIbv2StrainLbl.text = item
        case 65: vacciTrtStrainLbl.text = item
        case 66: vacciTrt2StrainLbl.text = item
        case 67: vacciNdv1StrainLbl.text = item
        case 68: vacciNdv2StrainLbl.text = item
        case 69: vacciStStrainLbl.text = item
        case 70: vacciEcoliStrainLbl.text = item
        case 71: vacciOthersStrainLbl.text = item
        default: break
        }
    }
    
}

//  AddVaccinationViewController.swift
//  Zoetis -Feathers
//  Created by "" on 9/7/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit
import CoreData
import Alamofire
import Reachability
import SystemConfiguration

class AddVaccinationViewController: UIViewController,DropperDelegate,UITextFieldDelegate,popUPnavigation {
    
    // MARK: - VARIABLES
    var isClickOnAnyField = Bool()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let objApiSync = ApiSync()
    let buttonbg = UIButton ()
    var exitPopUP :popUP!
    var addVaciArray = NSArray()
    var hatcStrain = NSArray()
    var fieldStrain = NSArray()
    
    var btnTag1 = NSInteger()
    var postingId = NSNumber()
    var postingIdFromExisting = NSNumber()
    var postingIdFromExistingNavigate = String()
    var finalizeValue = NSNumber()
    var btntag = Int ()
    var lngId = NSInteger()
    var colorr :String!
    var buttonTag = NSInteger()
    
    var asb :Bool!
    var arrayMutable = Array<ModelVacation>()
    var hatchStrainDrop = DropDown()
    var fieldStrainDrop = DropDown()
    var routeDrop = DropDown()
    var id :Int!
    var dataArray = NSArray ()
    var fieldVaccinatioDataAray = NSArray()
    var hatcheryVaccinationObject = [NSManagedObject]()
    var index = 10
    
    // MARK: - Outlets
    @IBOutlet weak var syncCountLbl: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var doneBTNoutlet: UIButton!
    @IBOutlet weak var lblIbvTitle: UILabel!
    @IBOutlet weak var lblNdvnew2Title: UILabel!
    @IBOutlet weak var lblOthersTitle: UILabel!
    @IBOutlet weak var ndvNew2: UILabel!
    @IBOutlet weak var otherStrain: UILabel!
    @IBOutlet weak var ndv2DisplayLabel: UILabel!
    @IBOutlet weak var otherDisplayLabel: UILabel!
    @IBOutlet weak var ndv2AgeTextField: UITextField!
    @IBOutlet weak var otherAgeTextField: UITextField!
    @IBOutlet weak var otherRouteOutlet: UIButton!
    @IBOutlet weak var ibvRouteTextFieldOutlet: UIButton!
    @IBOutlet weak var ibvRouteTextField: UILabel!
    
    @IBOutlet weak var type0: UILabel!
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var type3: UILabel!
    @IBOutlet weak var type4: UILabel!
    @IBOutlet weak var type5: UILabel!
    @IBOutlet weak var type6: UILabel!
    @IBOutlet weak var typeMarek: UILabel!
    @IBOutlet weak var typeIbdv: UILabel!
    @IBOutlet weak var typeTrt: UILabel!
    @IBOutlet weak var typeNdv: UILabel!
    @IBOutlet weak var typePox: UILabel!
    @IBOutlet weak var typeReo: UILabel!
    @IBOutlet weak var typeOthers: UILabel!
    @IBOutlet weak var HatcheryEcoliRouteLbl: UILabel!
    @IBOutlet weak var hatcheryStRouteOutlet: UIButton!
    @IBOutlet weak var hatcheryEcoliRouteOutlet: UIButton!
    @IBOutlet weak var stLabel: UILabel!
    @IBOutlet weak var ecoliLbl: UILabel!
    @IBOutlet weak var lblHatchery: UILabel!
    @IBOutlet weak var lblFieldVacii: UILabel!
    @IBOutlet weak var stRouteFieldDisplayLbl: UILabel!
    @IBOutlet weak var eColiRouteFieldDisplayLbl: UILabel!
    @IBOutlet weak var ecoliFieldLbl: UILabel!
    @IBOutlet weak var stFieldVaccinationLbl: UILabel!
    
    @IBOutlet weak var fieldVaccinationView: UIView!
    @IBOutlet weak var ibdvStrainFieldTextField: UITextField!
    @IBOutlet weak var ibdv2StrainFieldTextField: UILabel!
    @IBOutlet weak var ibvStrainFieldTextField: UILabel!
    @IBOutlet weak var ibv2StrainFieldTextField: UILabel!
    
    @IBOutlet weak var trt2StrainFieldTextField: UILabel!
    @IBOutlet weak var ndvStrainFieldTextField: UITextField!
    
    //fIELD aGE tEXTfIELD
    @IBOutlet weak var ibdvAgeTextField: UITextField!
    @IBOutlet weak var ibdv2AgeTextField: UITextField!
    @IBOutlet weak var ibvAgeTextField: UITextField!
    @IBOutlet weak var ibv2AgeTextField: UITextField!
    @IBOutlet weak var trtAgeTextField: UITextField!
    @IBOutlet weak var trt2AgeTextField: UITextField!
    @IBOutlet weak var ndvAgeTextField: UITextField!
    
    //checkbox
    @IBOutlet weak var coccidiosisControl: UITextField!
    @IBOutlet weak var hatcheryBtnOutlet: UIButton!
    @IBOutlet weak var fieldVaccinationBtnOutlet: UIButton!
    
    //checkBoxbttn
    @IBOutlet weak var marekCheckBoxOutlet: UIButton!
    @IBOutlet weak var ibdvCheckBoxOutlet: UIButton!
    @IBOutlet weak var ibdCheckBoxOutlet: UIButton!
    @IBOutlet weak var trtCheckBoxOutlet: UIButton!
    @IBOutlet weak var ndvCheckBoxOutlet: UIButton!
    @IBOutlet weak var poxCheckBoxOutlet: UIButton!
    @IBOutlet weak var reoCheckBoxOutlet: UIButton!
    @IBOutlet weak var othersCheckBoxOutlet: UIButton!
    @IBOutlet weak var innerView: UIView!
    
    //TextField
    @IBOutlet weak var marekStrainTextField: UILabel!
    @IBOutlet weak var ibdvStrainTextField: UILabel!
    @IBOutlet weak var ibvStrainTextField: UILabel!
    @IBOutlet weak var trtStrainTextField: UILabel!
    @IBOutlet weak var ndvStrainTextField: UILabel!
    @IBOutlet weak var poxStrainTextField: UILabel!
    @IBOutlet weak var reoStrainTextField: UILabel!
    @IBOutlet weak var stHatcheryaStrainTextField: UILabel!
    @IBOutlet weak var eColiHatcheryStrainText: UILabel!
    @IBOutlet weak var othersStrainTextField: UILabel!
    
    @IBOutlet weak var ibdStrainTextField: UITextField!
    @IBOutlet weak var ecoliAgeTEXTfield: UITextField!
    @IBOutlet weak var eColiStrainTextField: UILabel!
    @IBOutlet weak var stAgeTextField: UITextField!
    @IBOutlet weak var stStrainTextField: UILabel!
    
    @IBOutlet weak var hatcheryStRouteLbl: UILabel!
    @IBOutlet weak var ibdvTextFieldNew: UILabel!
    @IBOutlet weak var TrtFieldNew: UILabel!
    @IBOutlet weak var ndvNew: UILabel!
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var ibdvLabel: UILabel!
    @IBOutlet weak var ibdLabel: UILabel!
    @IBOutlet weak var trtLabel: UILabel!
    @IBOutlet weak var ndvLabel: UILabel!
    @IBOutlet weak var poxLbL: UILabel!
    @IBOutlet weak var reoLabel: UILabel!
    @IBOutlet weak var othesLabel: UILabel!
    
    @IBOutlet weak var routeLabel1: UILabel!
    @IBOutlet weak var routeLabel2: UILabel!
    @IBOutlet weak var routeLabel3: UILabel!
    @IBOutlet weak var routeLabel4: UILabel!
    @IBOutlet weak var routeLabel5: UILabel!
    @IBOutlet weak var routeLabel6: UILabel!
    @IBOutlet weak var routeLabel7: UILabel!
    
    @IBOutlet weak var marekDrinkingWaterBtnOutlet: UIButton!
    @IBOutlet weak var ibdvDrinkingWaterBtnnOutlet: UIButton!
    @IBOutlet weak var trtDrinkingWaterBtn: UIButton!
    @IBOutlet weak var ndvDrinkingWaterBtn: UIButton!
    @IBOutlet weak var poxDrinkingWaterbTN: UIButton!
    @IBOutlet weak var reoDrinkingWaterOutlet: UIButton!
    @IBOutlet weak var othersDrinkingWaterBtn: UIButton!
    
    @IBOutlet weak var ibdvRouteOutlet: UIButton!
    @IBOutlet weak var ibdv2RouteOutlet: UIButton!
    @IBOutlet weak var ibvRouteFieldOutlet: UIButton!
    @IBOutlet weak var ibv2RouteOutlet: UIButton!
    @IBOutlet weak var trtRouteOutlet: UIButton!
    @IBOutlet weak var trt2RouteFieldOutlet: UIButton!
    @IBOutlet weak var ndvRouteOutlet: UIButton!
    
    @IBOutlet weak var marekStrainBtnOutlet: UIButton!
    @IBOutlet weak var ibdvStainBtnOutlet: UIButton!
    @IBOutlet weak var ibvStrainBtnOutlet: UIButton!
    @IBOutlet weak var trtStainBtnOutlet: UIButton!
    @IBOutlet weak var ndvStrainBtnOutlet: UIButton!
    @IBOutlet weak var poxStainBtnOutlet: UIButton!
    @IBOutlet weak var reoStrainBtnOutlet: UIButton!
    @IBOutlet weak var stStainBtnOutlet: UIButton!
    @IBOutlet weak var ecoliStrainBtnOutlet: UIButton!
    @IBOutlet weak var othersStainBtnOutlet: UIButton!
    
    @IBOutlet weak var stRouteOutlet: UIButton!
    @IBOutlet weak var ecolibtnOutlet: UIButton!
    @IBOutlet weak var ndv2RouteBtnOutlet: UIButton!
    @IBOutlet weak var vacciIbdvStrainOutlet: UIButton!
    @IBOutlet weak var vacciIbdv1StrainOutlet: UIButton!
    @IBOutlet weak var vacciIbvStrainOutlet: UIButton!
    @IBOutlet weak var vacciIbv1StrainOutlet: UIButton!
    @IBOutlet weak var vacciTrtStrainOutlet: UIButton!
    @IBOutlet weak var vacciTrt1StrainOutlet: UIButton!
    @IBOutlet weak var vacciNdvStrainOutlet: UIButton!
    @IBOutlet weak var vacciNdv1StrainOutlet: UIButton!
    @IBOutlet weak var vacciSTStrainOutlet: UIButton!
    @IBOutlet weak var vacciEcoliStrainOutlet: UIButton!
    @IBOutlet weak var vacciOthrsStrainOutlet: UIButton!
    
    // MARK: - **************** View Life Cycle ***********************************/
    fileprivate func refactorViewDidLoad1(_ lngId: Int) {
        if lngId == 5{
            lblHatchery.text = "Criadero"
            lblFieldVacii.text = "Vacunación de campo"
        }
        if lngId == 3 {
            let textFields = [
                marekStrainTextField,ibdvStrainTextField,ibvStrainTextField,trtStrainTextField,ndvStrainTextField,poxStrainTextField,reoStrainTextField,othersStrainTextField,eColiHatcheryStrainText,stHatcheryaStrainTextField,ibdvTextFieldNew,ibdv2StrainFieldTextField,ibvStrainFieldTextField,ibv2StrainFieldTextField,TrtFieldNew,trt2StrainFieldTextField,ndvNew,ndvNew2,stStrainTextField,eColiStrainTextField,otherStrain
            ]
            
            for textField in textFields {
                if textField?.text == " - Select -" {
                    textField?.text = "- Sélectionner -"
                }
            }
        }
    }
    
    fileprivate func refactorViewdidLoad2() {
        /************ Fetching all data  From Database **************************/
        
        if postingIdFromExistingNavigate == "Exting" {
            postingId = postingIdFromExisting
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId") as NSNumber
        }
        dataArray = CoreDataHandler().fetchAddvacinationData(postingId)
        
        if dataArray.count > 0 {
            for _ in 0..<dataArray.count {
                ibdvTextFieldNew.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 0) as? String
                ibdv2StrainFieldTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 1) as? String
                ibvStrainFieldTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 2) as? String
                ibv2StrainFieldTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 3) as? String
                TrtFieldNew.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 4) as? String
                trt2StrainFieldTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 5) as? String
                ndvNew.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 6) as? String
                ndvNew2.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 7) as? String
                stStrainTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 8) as? String
                eColiStrainTextField.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 9) as? String
                otherStrain.text =  (dataArray.value(forKey: "strain") as AnyObject).object(at: 10) as? String
                
                ibdvAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 0) as? String
                ibdv2AgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 1) as? String
                ibvAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 2) as? String
                ibv2AgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 3) as? String
                trtAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 4) as? String
                trt2AgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 5) as? String
                ndvAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 6) as? String
                ndv2AgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 7) as? String
                stAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 8) as? String
                ecoliAgeTEXTfield.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 9) as? String
                otherAgeTextField.text =  (dataArray.value(forKey: "age") as AnyObject).object(at: 10) as? String
                
                routeLabel1.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 0) as? String
                routeLabel2.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 1) as? String
                routeLabel3.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 2) as? String
                routeLabel4.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 3) as? String
                routeLabel5.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 4) as? String
                routeLabel6.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 5) as? String
                routeLabel7.text =  (dataArray.value(forKey: "route") as AnyObject).object(at: 6) as? String
                ndv2DisplayLabel.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 7) as? String
                stRouteFieldDisplayLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 8) as? String
                eColiRouteFieldDisplayLbl.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 9) as? String
                otherDisplayLabel.text = (dataArray.value(forKey: "route") as AnyObject).object(at: 10) as? String
                coccidiosisControl.text = (dataArray.value(forKey: "vaciNationProgram") as AnyObject).object(at: 0) as? String
                
            }
        }
    }
    
    fileprivate func refactorViewDidLoad3() {
        /************ Fetching all data  From Database **************************/
        
        if postingIdFromExistingNavigate == "Exting" {
            postingId = postingIdFromExisting
        } else {
            postingId = UserDefaults.standard.integer(forKey: "postingId")  as NSNumber
        }
        
        fieldVaccinatioDataAray = CoreDataHandler().fetchFieldAddvacinationData(postingId)
        
        /**********************************************************************/
        if fieldVaccinatioDataAray.count > 0 {
            
            for _ in 0..<fieldVaccinatioDataAray.count {
                
                marekStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 0) as? String
                ibdvStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 1) as? String
                ibvStrainTextField.text = (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 2) as? String
                trtStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 3) as? String
                ndvStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 4) as? String
                poxStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 5) as? String
                reoStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 6) as? String
                stHatcheryaStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 7) as? String
                eColiHatcheryStrainText.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 8) as? String
                othersStrainTextField.text =  (fieldVaccinatioDataAray.value(forKey: "strain") as AnyObject).object(at: 9) as? String
                
                markLabel.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 0) as? String
                ibdvLabel.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 1) as? String
                ibvRouteTextField.text = (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 2) as? String
                trtLabel.text = (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 3) as? String
                ndvLabel.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 4) as? String
                poxLbL.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 5) as? String
                reoLabel.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 6) as? String
                hatcheryStRouteLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 7) as? String
                HatcheryEcoliRouteLbl.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 8) as? String
                othesLabel.text =  (fieldVaccinatioDataAray.value(forKey: "route") as AnyObject).object(at: 9) as? String
            }
        }
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        hatcStrain = CoreDataHandler().fetchStrainWithlanguage(entityName: "HatcheryStrain", lngID: lngId)
        fieldStrain = CoreDataHandler().fetchStrainWithlanguage(entityName: "GetFieldStrain", lngID: lngId)
        
         lngId = UserDefaults.standard.integer(forKey: "lngId")
        refactorViewDidLoad1(lngId)
        
        isClickOnAnyField = false
        
        let cusPaddingView = UIView(frame: CGRect(x: 20, y: 0, width: 10, height: 20))
        coccidiosisControl.leftView = cusPaddingView
        coccidiosisControl.leftViewMode = .always
        hatcheryBtnOutlet.layer.borderColor = UIColor.clear.cgColor
        
        ndv2AgeTextField.tag = 11
        otherAgeTextField.tag = 12
        ibdvAgeTextField.tag = 13
        ibdv2AgeTextField.tag = 14
        ibvAgeTextField.tag = 15
        ibv2AgeTextField.tag = 16
        trtAgeTextField.tag = 17
        trt2AgeTextField.tag = 18
        ecoliAgeTEXTfield.tag = 30
        stAgeTextField.tag = 31
        ndvAgeTextField.tag = 19
        
        let outlets: [UIButton] = [
            vacciIbdvStrainOutlet, vacciIbdv1StrainOutlet, vacciIbvStrainOutlet, vacciIbv1StrainOutlet,
            vacciTrtStrainOutlet, vacciTrt1StrainOutlet, vacciNdvStrainOutlet, vacciNdv1StrainOutlet,
            vacciSTStrainOutlet, vacciEcoliStrainOutlet, vacciOthrsStrainOutlet, ibvRouteTextFieldOutlet,
            stRouteOutlet, ecolibtnOutlet, ndv2RouteBtnOutlet, otherRouteOutlet, ibdvRouteOutlet,
            ibdv2RouteOutlet, ibvRouteFieldOutlet, ibv2RouteOutlet, trtRouteOutlet, trt2RouteFieldOutlet,
            ndvRouteOutlet, marekDrinkingWaterBtnOutlet, ibdvDrinkingWaterBtnnOutlet, hatcheryEcoliRouteOutlet,
            hatcheryStRouteOutlet, trtDrinkingWaterBtn, ndvDrinkingWaterBtn, poxDrinkingWaterbTN,
            reoDrinkingWaterOutlet, othersDrinkingWaterBtn, reoStrainBtnOutlet,
            stStainBtnOutlet, ecoliStrainBtnOutlet, othersStainBtnOutlet, marekStrainBtnOutlet,
            ibdvStainBtnOutlet, ibvStrainBtnOutlet, trtStainBtnOutlet, ndvStrainBtnOutlet, poxStainBtnOutlet
        ]
        
        for button in outlets {
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 3.5
            button.layer.borderColor = UIColor.black.cgColor
        }
        fieldVaccinationBtnOutlet.layer.borderColor = UIColor.gray.cgColor

        addVaciArray =  CoreDataHandler().fetchRouteLngId(lngId:lngId as NSNumber)
        
        otherAgeTextField.delegate = self
        ndv2AgeTextField.delegate = self
        ibdvAgeTextField.delegate = self
        ibdv2AgeTextField.delegate = self
        ibvAgeTextField.delegate = self
        ibv2AgeTextField.delegate = self
        trtAgeTextField.delegate = self
        trt2AgeTextField.delegate = self
        ndvAgeTextField.delegate = self
        coccidiosisControl.delegate = self
        
        otherStrain.resignFirstResponder()
        
        self.ibdv2StrainFieldTextField.resignFirstResponder()
        self.ibvStrainFieldTextField.resignFirstResponder()
        self.ibv2StrainFieldTextField.resignFirstResponder()
        self.trt2StrainFieldTextField.resignFirstResponder()
        
        ibdvAgeTextField.resignFirstResponder()
        ibdv2AgeTextField.resignFirstResponder()
        ibvAgeTextField.resignFirstResponder()
        ibv2AgeTextField.resignFirstResponder()
        
        trtAgeTextField.resignFirstResponder()
        trt2AgeTextField.resignFirstResponder()
        marekStrainTextField.resignFirstResponder()
        ibdvStrainTextField.resignFirstResponder()
        
        ndvAgeTextField.resignFirstResponder()
        poxStrainTextField.resignFirstResponder()
        reoStrainTextField.resignFirstResponder()
        othersStrainTextField.resignFirstResponder()
        
        ibvStrainTextField.resignFirstResponder()
        ndvStrainTextField.resignFirstResponder()
        trtStrainTextField.resignFirstResponder()
        otherAgeTextField.resignFirstResponder()
        
        ndv2AgeTextField.resignFirstResponder()
        coccidiosisControl.resignFirstResponder()
        ndvNew2.resignFirstResponder()
        ecoliAgeTEXTfield.resignFirstResponder()
        
        eColiStrainTextField.resignFirstResponder()
        stHatcheryaStrainTextField.resignFirstResponder()
        eColiHatcheryStrainText.resignFirstResponder()
        stAgeTextField.resignFirstResponder()
        stStrainTextField.resignFirstResponder()
        
        fieldVaccinationView.isHidden = true
        refactorViewdidLoad2()
        refactorViewDidLoad3()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        doneBTNoutlet.isHidden = false
        innerView.isUserInteractionEnabled = true
        fieldVaccinationView.isUserInteractionEnabled = true
        coccidiosisControl.isUserInteractionEnabled = true
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        spacingTextField()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 🟠 - **************** Textfield Delegate Methods ***********************************/
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        Dropper.sharedInstance.hideWithAnimation(0.1)
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Dropper.sharedInstance.hideWithAnimation(0.1)
        
        if (textField == ndvNew ) {
            print(appDelegateObj.testFuntion())
        } else {
            ibdvAgeTextField.returnKeyType = UIReturnKeyType.done
            ibdv2AgeTextField.returnKeyType = UIReturnKeyType.done
            ibvAgeTextField.returnKeyType = UIReturnKeyType.done
            ibv2AgeTextField.returnKeyType = UIReturnKeyType.done
            trtAgeTextField.returnKeyType = UIReturnKeyType.done
            trt2AgeTextField.returnKeyType = UIReturnKeyType.done
            ndvAgeTextField.returnKeyType = UIReturnKeyType.done
            coccidiosisControl.returnKeyType = UIReturnKeyType.done
            ndv2AgeTextField.returnKeyType = UIReturnKeyType.done
            otherAgeTextField.returnKeyType = UIReturnKeyType.done
            ndvAgeTextField.returnKeyType = UIReturnKeyType.done
            ibdvAgeTextField.returnKeyType = UIReturnKeyType.done
            ibdv2AgeTextField.returnKeyType = UIReturnKeyType.done
            ibvAgeTextField.returnKeyType = UIReturnKeyType.done
            ecoliAgeTEXTfield.returnKeyType = UIReturnKeyType.done
            stAgeTextField.returnKeyType = UIReturnKeyType.done
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
            
        case 11,12,13,14,15,16,17,18,19,30,31 :
            
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
        
        if textField == coccidiosisControl{
            let ACCEPTED_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£"
            let set = CharacterSet(charactersIn: ACCEPTED_CHARACTERS)
            let inverted = set.inverted
            let filtered = string.components(separatedBy: inverted).joined(separator: "")
            return filtered == string
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        isClickOnAnyField = true
    }
    
    // MARK: 🟠 - Show Custome Popup
    func showExitAlertWith(msg: String,tag: Int) {
        exitPopUP = popUP.loadFromNibNamed("popUP") as? popUP
        exitPopUP.lblFedPrgram.text = msg
        exitPopUP.tag = tag
        exitPopUP.lblFedPrgram.textAlignment = .center
        exitPopUP.delegatenEW = self
        exitPopUP.center = self.view.center
        self.view.addSubview(exitPopUP)
        
    }
    func noPopUpPosting() {
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            CoreDataHandler().updatePostingSessionOndashBoard(self.postingId as NSNumber, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
            CoreDataHandler().deletefieldVACDataWithPostingId(self.postingId as NSNumber)
            CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId as NSNumber)
        }
        else{
            CoreDataHandler().deleteDataWithPostingId(self.postingId as NSNumber)
            CoreDataHandler().deletefieldVACDataWithPostingId(self.postingId as NSNumber)
            CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId as NSNumber)
        }
        for dashboard in (self.navigationController?.viewControllers)! {
            if dashboard.isKind(of: DashViewController.self){
                self.navigationController?.popToViewController(dashboard, animated: true)
            }
        }
    }
    
    func YesPopUpPosting() {
        print(appDelegateObj.testFuntion())
    }
    func alertShow()  {
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter strain.", comment: ""))
    }
    // MARK: 🟠 - Enable disable all text field
    fileprivate func handleIbdvTextFieldNew() {
        if (ibdvTextFieldNew.text == " " || ibdvTextFieldNew.text == ""){
            ibdvAgeTextField.isUserInteractionEnabled = false
            ibdvRouteOutlet.isUserInteractionEnabled = false
        } else {
            ibdvAgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleIdv2StrainFieldTxtField() {
        if (ibdv2StrainFieldTextField.text == " " || ibdv2StrainFieldTextField.text == "") {
            ibdv2AgeTextField.isUserInteractionEnabled = false
            ibdv2RouteOutlet.isUserInteractionEnabled = false
        } else {
            ibdv2AgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleIbvStrainFieldTextField() {
        if (ibvStrainFieldTextField.text == " " || ibvStrainFieldTextField.text == "") {
            ibvRouteFieldOutlet.isUserInteractionEnabled = false
            ibvAgeTextField.isUserInteractionEnabled = false
        } else {
            ibvAgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleIbv2StrainFieldTextField() {
        if (ibv2StrainFieldTextField.text == " " || ibv2StrainFieldTextField.text == "") {
            ibv2RouteOutlet.isUserInteractionEnabled = false
            ibv2AgeTextField.isUserInteractionEnabled = false
        } else {
            ibv2AgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleTrtFieldNew() {
        if (TrtFieldNew.text == " " || TrtFieldNew.text == "") {
            trtRouteOutlet.isUserInteractionEnabled = false
            trtAgeTextField.isUserInteractionEnabled = false
        } else {
            trtAgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleTrt2StrainFieldTextField() {
        if (trt2StrainFieldTextField.text == " " || trt2StrainFieldTextField.text == "") {
            trt2AgeTextField.isUserInteractionEnabled = false
            trt2RouteFieldOutlet.isUserInteractionEnabled = false
        } else {
            trt2AgeTextField.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func handleNdvNew() {
        if (ndvNew.text == " " || ndvNew.text == "") {
            ndvRouteOutlet.isUserInteractionEnabled = false
            ndvAgeTextField.isUserInteractionEnabled = false
        } else {
            ndvAgeTextField.isUserInteractionEnabled = true
        }
    }
    
    func textFieldEnable(){
    
        handleIbdvTextFieldNew()
        handleIdv2StrainFieldTxtField()
        handleIbvStrainFieldTextField()
        handleIbv2StrainFieldTextField()
        handleTrtFieldNew()
        handleTrt2StrainFieldTextField()
        handleNdvNew()
        if (ndvNew2.text == " " || ndvNew2.text == "") {
            ndv2RouteBtnOutlet.isUserInteractionEnabled = false
            ndv2AgeTextField.isUserInteractionEnabled = false
        } else {
            ndv2AgeTextField.isUserInteractionEnabled = true
        }
        if (otherStrain.text == " " || otherStrain.text == "") {
            otherRouteOutlet.isUserInteractionEnabled = false
            otherAgeTextField.isUserInteractionEnabled = false
        } else {
            otherAgeTextField.isUserInteractionEnabled = true
        }
       
    }
    
    // MARK: 🟠 - Add Padding space to all text field funcetion
    func spacingTextField() {
        
        let textFields: [UITextField] = [
            ibvAgeTextField, ndvAgeTextField, trt2AgeTextField, trtAgeTextField, ibv2AgeTextField,
            ibdvAgeTextField, ibdv2AgeTextField, coccidiosisControl, otherAgeTextField,
            ndv2AgeTextField, stAgeTextField, ecoliAgeTEXTfield
        ]
        
        // Loop through each text field and apply the padding
        for textField in textFields {
            let paddingView = UIView(frame: CGRect(x: 15, y: 0, width: 10, height: 20))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
    }
  
    // MARK: 🟠 - ****************IBACTIONS***********************************/
    
    @IBAction func tapOnFieldVaccination(_ sender: AnyObject) {
        mainView.endEditing(true)
        fieldVaccinationView.endEditing(true)
    }
    
    @IBAction func tapOnView(_ sender: AnyObject) {
        innerView.endEditing(true)
        mainView.endEditing(true)
        hideDropDown()
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        markLabel.text = contents
    }
    /****************************** All Button Action ****************************************/
    
    // MARK: 🟠 -Back Button
    @IBAction func bckBtn(_ sender: AnyObject) {
        btntag = 1
        allSaveData(btntag)
    }
    
    // MARK: 🟠 - hatchery Button Action
    @IBAction func hatcheryButton(_ sender: AnyObject) {
        btnTag1 = 0
        hatcheryBtnOutlet.setImage(UIImage(named: "hatchery_selected_btn"), for: UIControl.State())
        fieldVaccinationBtnOutlet.setImage(UIImage(named: "field_vaccination_unselect_btn"), for: UIControl.State())
        fieldVaccinationView.isHidden = true
        innerView.isHidden = false
    }
    
    // MARK: 🟠 - Field Vaccination Button Action
    @IBAction func fieldVaccination(_ sender: AnyObject) {
        btnTag1 = 1
        hatcheryBtnOutlet.setImage(UIImage(named: "hatchery_unselected_btn"), for: UIControl.State())
        fieldVaccinationBtnOutlet.setImage(UIImage(named: "field_vaccination_select_btn"), for: UIControl.State())
        innerView.isHidden = true
        fieldVaccinationView.isHidden = false
    }
    // MARK: 🟠 - Done Button Action
    @IBAction func doneBttn(_ sender: AnyObject) {
        btntag = 2
        Constants.isFromPsoting = true
        UserDefaults.standard.set(true, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        allSaveData(btntag)
        
    }
    // MARK: 🟠 - Save All data in local Database
    fileprivate func handleCoreDataHelper() {
        for i in 0..<10 {
            
            if i == 0 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                    type: typeMarek.text!,
                        strain: marekStrainTextField.text!,
                        route: markLabel.text!,
                        postingId: postingId,
                        vaciProgram: coccidiosisControl.text!,
                        sessionId: 1,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        routeID: markLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            } else if i == 1 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                       type: typeIbdv.text!,
                       strain: ibdvStrainTextField.text!,
                       route: ibdvLabel.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: ibdvLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            } else if i == 2 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                      type: lblIbvTitle.text!,
                       strain: ibvStrainTextField.text!,
                      route: ibvRouteTextField.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: ibvRouteTextField.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
            } else if i == 3 {
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                      type: typeTrt.text!,
                      strain: trtStrainTextField.text!,
                      route: trtLabel.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: trtLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            } else if i == 4 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                    type: typeNdv.text!,
                       strain: ndvStrainTextField.text!,
                       route: ndvLabel.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: ndvLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
            } else if i == 5 {
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                        type: typePox.text!,
                        strain: poxStrainTextField.text!,
                        route: poxLbL.text!,
                        postingId: postingId,
                        vaciProgram: coccidiosisControl.text!,
                        sessionId: 1,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        routeID: poxLbL.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            } else if i == 6 {
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                      type: typeReo.text!,
                      strain: reoStrainTextField.text!,
                      route: reoLabel.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: reoLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
            } else if i == 7 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                    type: stLabel.text!,
                      strain: stHatcheryaStrainTextField.text!,
                      route: hatcheryStRouteLbl.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: hatcheryStRouteLbl.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            } else if i == 8 {
                
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                       type: ecoliLbl.text!,
                       strain: eColiHatcheryStrainText.text!,
                       route: HatcheryEcoliRouteLbl.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: HatcheryEcoliRouteLbl.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
            } else if i == 9 {
                let fieldDetails = chickenCoreDataHandlerModels.saveChknFieldVaccinationDetails(
                    type: typeOthers.text!,
                      strain: othersStrainTextField.text!,
                      route: othesLabel.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: othesLabel.tag
                )

                CoreDataHandler().saveFieldVacinationInDatabase(details: fieldDetails, index: i, dbArray: fieldVaccinatioDataAray)
                
            }
        }
    }
    
    fileprivate func handleCoreDataHelperForLoop() {
        for i in 0..<11 {
            
            if i == 0 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                        type: type0.text!,
                        strain: ibdvTextFieldNew.text!,
                        route: routeLabel1.text!,
                        age: ibdvAgeTextField.text!,
                        postingId: postingId,
                        vaciProgram: coccidiosisControl.text!,
                        sessionId: 1,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        routeID: routeLabel1.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            else if i == 1 {
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                       type: type1.text!,
                       strain: ibdv2StrainFieldTextField.text!,
                       route: routeLabel2.text!,
                       age: ibdv2AgeTextField.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: routeLabel2.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
            }
            else if i == 2 {
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                        type: type2.text!,
                        strain: ibvStrainFieldTextField.text!,
                        route: routeLabel3.text!,
                        age: ibvAgeTextField.text!,
                        postingId: postingId,
                        vaciProgram: coccidiosisControl.text!,
                        sessionId: 1,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        routeID: routeLabel3.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
            }
            else if i == 3 {
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                    type: type3.text!,
                       strain: ibv2StrainFieldTextField.text!,
                       route: routeLabel4.text!,
                       age: ibv2AgeTextField.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: routeLabel4.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            else if i == 4 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                       type: type4.text!,
                       strain: TrtFieldNew.text!,
                       route: routeLabel5.text!,
                       age: trtAgeTextField.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: routeLabel5.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            else if i == 5 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                       type: type5.text!,
                       strain: trt2StrainFieldTextField.text!,
                       route: routeLabel6.text!,
                       age: trt2AgeTextField.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: routeLabel6.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
            }
            else if i == 6 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                    type: type6.text!,
                     strain: ndvNew.text!,
                     route: routeLabel7.text!,
                     age: ndvAgeTextField.text!,
                     postingId: postingId,
                     vaciProgram: coccidiosisControl.text!,
                     sessionId: 1,
                     isSync: true,
                     lngId: lngId as NSNumber,
                     routeID: routeLabel7.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            else if i == 7 {
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                    type: lblNdvnew2Title.text!,
                      strain: ndvNew2.text!,
                      route: ndv2DisplayLabel.text!,
                      age: ndv2AgeTextField.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: ndv2DisplayLabel.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
            }
            else if i == 8 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                      type: stFieldVaccinationLbl.text!,
                      strain: stStrainTextField.text!,
                      route: stRouteFieldDisplayLbl.text!,
                      age: stAgeTextField.text!,
                      postingId: postingId,
                      vaciProgram: coccidiosisControl.text!,
                      sessionId: 1,
                      isSync: true,
                      lngId: lngId as NSNumber,
                      routeID: stRouteFieldDisplayLbl.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            else if i == 9 {
                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                      type: ecoliFieldLbl.text!,
                       strain: eColiStrainTextField.text!,
                       route: eColiRouteFieldDisplayLbl.text!,
                       age: ecoliAgeTEXTfield.text!,
                       postingId: postingId,
                       vaciProgram: coccidiosisControl.text!,
                       sessionId: 1,
                       isSync: true,
                       lngId: lngId as NSNumber,
                       routeID: eColiRouteFieldDisplayLbl.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
                
            }
            
            else if i == 10 {                
                let details = chickenCoreDataHandlerModels.saveChiknHtchryVacintnDetails(
                     type: lblOthersTitle.text!,
                     strain: otherStrain.text!,
                     route: otherDisplayLabel.text!,
                     age: otherAgeTextField.text!,
                     postingId: postingId,
                     vaciProgram: coccidiosisControl.text!,
                     sessionId: 1,
                     isSync: true,
                     lngId: lngId as NSNumber,
                     routeID: otherDisplayLabel.tag
                )

                CoreDataHandler().saveHatcheryVacinationInDatabase(details: details, index: i, dbArray: dataArray)
            }
        }
    }
    
    func allSaveData( _ btnTag : Int)  {
        var trimmedString = coccidiosisControl.text!.trimmingCharacters(in: .whitespaces)
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        coccidiosisControl.text = trimmedString
        if trimmedString == ""{
            if btnTag == 1 {
               
                appDelegate.isDoneClick = true
                self.navigationController?.popViewController(animated: true)
            } else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter the vaccination program.", comment: ""))
            }
        } else {
            if isClickOnAnyField == true {
                isClickOnAnyField = false
                handleCoreDataHelper()
                handleCoreDataHelperForLoop()
                
                CoreDataHandler().updateisSyncTrueOnPostingSession(postingId)
                UserDefaults.standard.set(coccidiosisControl.text!, forKey: "vaci")
                UserDefaults.standard.synchronize()
            }
            
          
            appDelegate.isDoneClick = true
            self.navigationController?.popViewController(animated: true)
        }
        appDelegate.sendFeedVariable = "vaccination"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func animateView (_ movement : CGFloat){
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement);
        })
    }
    // MARK: 🟠 - hatchery Route Button Actions
    @IBAction func marekDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 40
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
        
    }
    @IBAction func ibdvDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 41
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
        
    }
    @IBAction func ibvRouteTextFieldAction(_ sender: UIButton) {
        sender.tag = 42
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func trtDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 43
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ndvDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 44
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func poxDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 45
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func reoDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 46
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func hatcheryStRouteBtn(_ sender: UIButton) {
        sender.tag = 47
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func hatcheryEcoliRouteBtn(_ sender: UIButton) {
        sender.tag = 48
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func othersDrinkingWaterBttn(_ sender: UIButton) {
        sender.tag = 49
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibdvRouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 51
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibdv2RouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 52
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibvRouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 53
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibv2RouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 54
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func trtRouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 55
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func trt2RouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 56
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ndvRouteFieldBtnAction(_ sender: UIButton) {
        sender.tag = 57
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ndv2routeBtnAction(_ sender: UIButton) {
        sender.tag = 58
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func stRouteBtn(_ sender: UIButton) {
        sender.tag = 59
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func eColiBtn(_ sender: UIButton) {
        sender.tag = 60
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    @IBAction func otherRouteBtnAction(_ sender: UIButton) {
        sender.tag = 61
        self.showHatcheryRouteDropdown(sender:sender)
        isClickOnAnyField = true
    }
    
    
    // MARK: 🟠 - All Starin Button's Action
    @IBAction func marekStrainBtnClick(_ sender: UIButton) {
        sender.tag = 11
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibdvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 12
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ibvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 13
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func trtStrainBtnClick(_ sender: UIButton) {
        sender.tag = 14
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ndvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 15
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func poxStrainBtnClick(_ sender: UIButton) {
        sender.tag = 16
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func reoStrainBtnClick(_ sender: UIButton) {
        sender.tag = 17
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func stStrainBtnClick(_ sender: UIButton) {
        sender.tag = 18
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func ecoliStrainBtnClick(_ sender: UIButton) {
        sender.tag = 19
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func othersStrainBtnClick(_ sender: UIButton) {
        sender.tag = 20
        self.showHatchStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbdvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 22
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbdv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 23
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 24
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciIbv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 25
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciTrtStrainBtnClick(_ sender: UIButton) {
        sender.tag = 26
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciTrt1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 27
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciNdvStrainBtnClick(_ sender: UIButton) {
        sender.tag = 28
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciNdv1StrainBtnClick(_ sender: UIButton) {
        sender.tag = 29
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
        
    }
    
    @IBAction func vacciStStrainBtnClick(_ sender: UIButton) {
        sender.tag = 30
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciEcoliStrainBtnClick(_ sender: UIButton) {
        sender.tag = 31
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
    @IBAction func vacciOtherStrainBtnClick(_ sender: UIButton) {
        sender.tag = 32
        self.showFieldStrainDropdown(sender: sender)
        isClickOnAnyField = true
    }
    
}

// MARK: - Extension
extension AddVaccinationViewController{
    // MARK: 🟠 - hatchery Strain Drop Down
    func showHatchStrainDropdown(sender: UIButton){
        
        let hatchStrainInfoDict = CoreDataHandler().fetchStrainWithlanguage(entityName: "HatcheryStrain", lngID: lngId)
        let strainNameArray = hatchStrainInfoDict.value(forKeyPath: "strainName")
        hatchStrainDrop.dataSource = strainNameArray as! [AnyObject]
        hatchStrainDrop.anchorView = sender
        hatchStrainDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        hatchStrainDrop.show()
        hatchStrainDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if sender.tag == 11 {
                self?.marekStrainTextField.text = item
            } else if sender.tag == 12 {
                self?.ibdvStrainTextField.text = item
            } else if sender.tag == 13 {
                self?.ibvStrainTextField.text = item
            }
            else if sender.tag == 14 {
                self?.trtStrainTextField.text = item
            }
            else if sender.tag == 15 {
                self?.ndvStrainTextField.text = item
            }
            else if sender.tag == 16 {
                self?.poxStrainTextField.text = item
            }
            else if sender.tag == 17 {
                self?.reoStrainTextField.text = item
            }
            else if sender.tag == 18 {
                self?.stHatcheryaStrainTextField.text = item
            }
            else if sender.tag == 19 {
                self?.eColiHatcheryStrainText.text = item
            }
            else if sender.tag == 20 {
                self?.othersStrainTextField.text = item
            }
        }
    }
    // MARK: 🟠 - Field Strain DropDown
    func showFieldStrainDropdown(sender: UIButton){
        let fieldStrainInfoDict = CoreDataHandler().fetchStrainWithlanguage(entityName: "GetFieldStrain", lngID: lngId)
        let strainNameArray = fieldStrainInfoDict.value(forKeyPath: "strainName")
        fieldStrainDrop.dataSource = strainNameArray as! [AnyObject]
        fieldStrainDrop.anchorView = sender
        fieldStrainDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        fieldStrainDrop.show()
        fieldStrainDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            if sender.tag == 22 {
                self?.ibdvTextFieldNew.text = item
            }else if sender.tag == 23 {
                self?.ibdv2StrainFieldTextField.text = item
            }else if sender.tag == 24 {
                self?.ibvStrainFieldTextField.text = item
            }else if sender.tag == 25 {
                self?.ibv2StrainFieldTextField.text = item
            }else if sender.tag == 26 {
                self?.TrtFieldNew.text = item
            }else if sender.tag == 27{
                self?.trt2StrainFieldTextField.text = item
            }else if sender.tag == 28 {
                self?.ndvNew.text = item
            }else if sender.tag == 29 {
                self?.ndvNew2.text = item
            }else if sender.tag == 30 {
                self?.stStrainTextField.text = item
            }else if sender.tag == 31 {
                self?.eColiStrainTextField.text = item
            }else if sender.tag == 32 {
                self?.otherStrain.text = item
            }
        }
    }
    // MARK: 🟠 - hatchery Route Drop Down
    
    func showHatcheryRouteDropdown(sender: UIButton) {
        let vaccInfoDict = CoreDataHandler().fetchRouteLngId(lngId: lngId as NSNumber)
        let routeNameArray = vaccInfoDict.value(forKeyPath: "routeName")
        let routeIDArray = vaccInfoDict.value(forKeyPath: "routeId") as! [Int]
        routeDrop.dataSource = routeNameArray as! [AnyObject]

        routeDrop.anchorView = sender
        routeDrop.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        routeDrop.show()
        
        routeDrop.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            let routeId = routeIDArray[index]

            // Dictionary mapping tags to corresponding UILabels / UITextFields
            let tagToLabel: [Int: AnyObject] = [
                40: self.markLabel,
                41: self.ibdvLabel,
                42: self.ibvRouteTextField,
                43: self.trtLabel,
                44: self.ndvLabel,
                45: self.poxLbL,
                46: self.reoLabel,
                47: self.hatcheryStRouteLbl,
                48: self.HatcheryEcoliRouteLbl,
                49: self.othesLabel,
                51: self.routeLabel1,
                52: self.routeLabel2,
                53: self.routeLabel3,
                54: self.routeLabel4,
                55: self.routeLabel5,
                56: self.routeLabel6,
                57: self.routeLabel7,
                58: self.ndv2DisplayLabel,
                59: self.stRouteFieldDisplayLbl,
                60: self.eColiRouteFieldDisplayLbl,
                61: self.otherDisplayLabel
            ]

            if let label = tagToLabel[sender.tag] as? UILabel {
                label.text = item
                label.tag = routeId
            } else if let textField = tagToLabel[sender.tag] as? UITextField {
                textField.text = item
                textField.tag = routeId
            }
        }
    }

}

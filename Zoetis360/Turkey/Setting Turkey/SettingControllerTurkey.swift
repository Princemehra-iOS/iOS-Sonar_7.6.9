//
//  SettingControllerTurkey.swift
//  Zoetis -Feathers
//  Created by Manish Behl on 16/03/18.
//  Copyright © 2018 . All rights reserved.

import UIKit
import CoreData
import Alamofire
import Reachability
import SystemConfiguration

class SettingControllerTurkey: UIViewController,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - VARIABLES
    var quicklinksValue =  Bool()
    var dataSkeletaArray = NSArray ()
    var dataCocoiiArray = NSArray ()
    var dataGiTractArray = NSArray ()
    var dataRespiratoryArray = NSArray ()
    var dataImmuneArray = NSArray ()
    var lngId = NSInteger()
    var dataArray = NSMutableArray()
    var strButtonNmae = String()
    var btnTag = NSInteger()
    var serviceDataHldArr = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - OUTLETS
    @IBOutlet weak var skeltaLabel: UILabel!
    @IBOutlet weak var cocodissLabel: UILabel!
    @IBOutlet weak var gitractLabel: UILabel!
    @IBOutlet weak var respLabel: UILabel!
    @IBOutlet weak var immuLabel: UILabel!
    @IBOutlet weak var skeletalMusclarBtnOutlet: UIButton!
    @IBOutlet weak var microscopyBtnOutlet: UIButton!
    @IBOutlet weak var gitractBtnOutlet: UIButton!
    @IBOutlet weak var immuneOtherBtnOutlet: UIButton!
    @IBOutlet weak var respiratoryBtnOutlet: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    let bodyWeightObs = "Body Weight"
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingControllerTurkey.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
        
        btnTag = 0
        skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_select"), for: .normal)
        microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
        gitractBtnOutlet.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
        immuneOtherBtnOutlet.setImage(UIImage(named: "immune_unselect"), for: .normal)
        respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
        
        if WebClass.sharedInstance.connected(), appDelegate.globalDataArrTurkey.count > 0 {
            dataArray = appDelegate.globalDataArrTurkey
        }
        self.skeletalMusclarAction(sender: "0" as AnyObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 5{
            skeltaLabel.text = "Esquelético/Muscular/Integumental"
            cocodissLabel.text = "Coccidiosis"
            gitractLabel.text = "Tracto gastrointestinal"
            respLabel.text = "Respiratorio"
            immuLabel.text = "Inmune/Otros"
        }
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
    }
    
    // MARK: - 🦴 Skeletal Muscular Assessment Button Action
    @IBAction func skeletalMusclarAction(sender: AnyObject) {
        btnTag = 0
        if(skeletalMusclarBtnOutlet.isSelected == false){
            skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_select"), for: .normal)
            microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            gitractBtnOutlet.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            immuneOtherBtnOutlet.setImage(UIImage(named: "immune_unselect"), for: .normal)
            respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            gitractBtnOutlet.setBackgroundImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            respiratoryBtnOutlet.setBackgroundImage(UIImage(named: "respiratory_unselect"), for: .normal)
            
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataSkeletaArray = CoreDataHandlerTurkey().fetchAllSeettingdataWithLngIdTurkey(lngId:lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
    }
    // MARK: - 🔬 Microscopy Button Action
    @IBAction func microscopyBtnAction(sender: AnyObject) {
        btnTag = 1
        if(microscopyBtnOutlet.isSelected == false){
            
            skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_select"), for: .normal)
            gitractBtnOutlet.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            immuneOtherBtnOutlet.setImage(UIImage(named: "immune_unselect"), for: .normal)
            respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            gitractBtnOutlet.setBackgroundImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            respiratoryBtnOutlet.setBackgroundImage(UIImage(named: "respiratory_unselect"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataCocoiiArray = CoreDataHandlerTurkey().fetchAllCocoiiDataUsinglngIdTurkey(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
    }
    // MARK: - 🫀 GI Tract Assessment Button Action
    @IBAction func gitractBtnAction(sender: AnyObject) {
        strButtonNmae = "gitract"
        btnTag = 2
        if(gitractBtnOutlet.isSelected == false){
            skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            gitractBtnOutlet.setBackgroundImage(UIImage(named: "gi_tract_select"), for: .normal)
            gitractBtnOutlet.setImage(UIImage(named: "gi_tract_select"), for: .normal)
            respiratoryBtnOutlet.setBackgroundImage(UIImage(named: "respiratory_unselect"), for: .normal)
            immuneOtherBtnOutlet.setImage(UIImage(named: "immune_unselect"), for: .normal)
            respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataGiTractArray = CoreDataHandlerTurkey().fetchAllGITractDataUsingLngIdTurkey(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
        
    }
    // MARK: - 🫁 Respiratory Assessment Button Action
    @IBAction func respiratoryBtnAction(sender: AnyObject) {
        btnTag = 3
        if (respiratoryBtnOutlet.isSelected == false) {
            skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            gitractBtnOutlet.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            immuneOtherBtnOutlet.setImage(UIImage(named: "immune_unselect"), for: .normal)
            respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_select"), for: .normal)
            respiratoryBtnOutlet.setBackgroundImage(UIImage(named: "respiratory_select"), for: .normal)
            
            gitractBtnOutlet.setBackgroundImage(UIImage(named: "gi_tract_unselect"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataRespiratoryArray = CoreDataHandlerTurkey().fetchAllRespiratoryusingLngIdTurkey(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
    }
    
    // MARK: - 🧬 Immune Assessment (Others) Button Action
    @IBAction func immuneOthersBtnAction(sender: AnyObject) {
        
        btnTag = 4
        if (immuneOtherBtnOutlet.isSelected == false) {
            skeletalMusclarBtnOutlet.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            microscopyBtnOutlet.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            gitractBtnOutlet.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            immuneOtherBtnOutlet.setImage(UIImage(named: "immune_select"), for: .normal)
            respiratoryBtnOutlet.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            gitractBtnOutlet.setBackgroundImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            respiratoryBtnOutlet.setBackgroundImage(UIImage(named: "respiratory_unselect"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataImmuneArray = CoreDataHandlerTurkey().fetchAllImmuneUsingLngIdTurkey(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
    }
    // MARK: - 💾 Save Observations to Database
    func callSaveMethod( skeletaArr : NSArray) {
        for i in 0..<skeletaArr.count {
            let strObservationField =
            (skeletaArr.object(at: i) as AnyObject).value(forKey:"ObservationDescription") as! String
            let visibilityCheck = (skeletaArr.object(at: i) as AnyObject)
                .value(forKey:"DefaultQLink") as! Bool
            let obsId = (skeletaArr.object(at: i) as AnyObject).value(forKey:"ObservationId") as! NSInteger
            let visibilitySwitch = (skeletaArr.object(at: i) as AnyObject).value(forKey:"Visibility") as! Bool
            let measure =  (skeletaArr.object(at: i) as AnyObject).value(forKey:"Measure") as! String
            let lngIdValue =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "LanguageId") as! NSNumber
            let refId =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "ReferenceId") as! NSNumber
            let quickLinkIndex =  (skeletaArr.object(at: i) as AnyObject).value(forKey: "quicklinkIndex") as! Int
            var isVisibilityCheck = Bool()
            var isQuicklinksCheck = Bool()
            if visibilityCheck == true {
                isQuicklinksCheck = true
            } else if visibilityCheck == false {
                isQuicklinksCheck = false
            }
            if visibilitySwitch == true {
                isVisibilityCheck = true
            } else {
                isVisibilityCheck = false
            }
            
            if  btnTag == 0 {
                
                let settingsSkeletaData = CoreDataHandlerTurkeyModels.turkeySettingsSkeletaData(
                    strObservationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    strInformation: "xyz",
                    index: i,
                    dbArray: dataSkeletaArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex            )
                CoreDataHandlerTurkey().saveSettingsSkeletaInDatabaseTurkey(settingsData: settingsSkeletaData)
                
                
            } else if btnTag == 1{
                
                let savecoccidiosisSettings = CoreDataHandlerTurkeyModels.turkeyCoccidiosisSettings(
                    strObservationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isVisibilityCheck,
                    strInformation: "xyz",
                    index: i,
                    dbArray: dataCocoiiArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex
                )
                CoreDataHandlerTurkey().saveSettingsCocoiiInDatabaseTurkey(data: savecoccidiosisSettings)
                
            } else if btnTag == 2{
                
                let gITractDatasettings = CoreDataHandlerTurkeyModels.turkeyGITractSettingsData(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataGiTractArray,
                    obsId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex
                )
                CoreDataHandlerTurkey().saveSettingsGITractDatabaseTurkey(gITractDatasettings)
                
            } else if btnTag == 3{
                
                let respiratorySettings = CoreDataHandlerTurkeyModels.turkeyRespiratorySettings(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataRespiratoryArray,
                    observationId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex ?? 0
                )
                CoreDataHandlerTurkey().saveSettingsRespiratoryDatabaseTurkey(respiratorySettings)
                
            } else {
                let immuneSettings = CoreDataHandlerTurkeyModels.turkeyImmuneSettings(
                    observationField: strObservationField,
                    visibilityCheck: isVisibilityCheck,
                    quicklinks: isQuicklinksCheck,
                    information: "xyz",
                    index: i,
                    dbArray: dataImmuneArray,
                    observationId: obsId,
                    measure: measure,
                    isSync: false,
                    lngId: lngIdValue,
                    refId: refId,
                    quicklinkIndex: quickLinkIndex
                )
                CoreDataHandlerTurkey().saveSettingsImmuneDatabaseTurkey(immuneSettings)
            }
        }
    }
    /**************** tableView DataSource & Delegate Methods ***********************************/
    
    fileprivate func setCheckBtnImage(_ sender: UIButton) {
        let cocoii : ImmuneTurkey = dataImmuneArray.object(at: sender.tag) as! ImmuneTurkey
        let obs = cocoii.observationField
        if obs == bodyWeightObs{
            sender.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "Check_")!, for: .normal)
        }
    }
    
    /**************** Action Of CheckBox Button *******************************************/
    @objc func checkBoxClick(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if  sender.isSelected {
            sender.isSelected = true
            if  btnTag == 4{
                setCheckBtnImage(sender)
            }
            else{
                sender.setImage(UIImage(named: "Check_")!, for: .normal)
            }
        } else {
            
            sender.setImage(nil, for: .normal)
            sender.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        var  vsibilityValue = Bool()
        
        if btnTag == 0 {
            let skeletaObject : SkeletaTurkey = dataSkeletaArray.object(at: sender.tag) as! SkeletaTurkey
            vsibilityValue = skeletaObject.visibilityCheck as! Bool
            var  observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let updatedSkeSetting = CoreDataHandlerTurkeyModels.updateTurkySkeletaSettings(
                strObservationField: skeletaObject.observationField!,
                visibilityCheck: vsibilityValue,
                quicklinks: sender.isSelected,
                strInformation: "xyz",
                index: sender.tag,
                dbArray: dataSkeletaArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            
            CoreDataHandlerTurkey().updateSettingDataSkeltaTurkey(updatedSkeSetting)
            
            
        } else if  btnTag == 1{
            
            let cocoii : CoccidiosisTurkey = dataCocoiiArray.object(at: sender.tag) as! CoccidiosisTurkey
            vsibilityValue = cocoii.visibilityCheck as! Bool
            var observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            
            let cocciData = CoreDataHandlerTurkeyModels.updateCoccidiosisTurkeySettings(
                strObservationField: cocoii.observationField!,
                visibilityCheck: vsibilityValue,
                quicklinks: sender.isSelected,
                strInformation: "xyz",
                index: sender.tag,
                dbArray: dataCocoiiArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataCocoiiTurkey(data: cocciData)
            
        } else if  btnTag == 2 {
            let skeletaObject : GITractTurkey = dataGiTractArray.object(at: sender.tag) as! GITractTurkey
            vsibilityValue = skeletaObject.visibilityCheck as! Bool
            var  observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let updateGitrectSeetingsData = CoreDataHandlerTurkeyModels.updateGITractSettingsData(
                observationField: skeletaObject.observationField!,
                visibilityCheck: vsibilityValue,
                quicklinks: sender.isSelected,
                information: "xyz",
                index: sender.tag,
                dbArray: dataGiTractArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataGitractTurkey(updateGitrectSeetingsData)
            
        } else if  btnTag == 3{
            
            let cocoii : RespiratoryTurkey = dataRespiratoryArray.object(at: sender.tag) as! RespiratoryTurkey
            vsibilityValue =
            cocoii.visibilityCheck as! Bool
            var observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            
            let settingsUpdate = CoreDataHandlerTurkeyModels.turkeyRespiratorySettingsUpdate(
                observationField: cocoii.observationField!,
                visibilityCheck: vsibilityValue,
                quicklinks: sender.isSelected,
                information: "xyz",
                index: sender.tag,
                dbArray: dataRespiratoryArray,
                observationId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataRespTurkey(settingsUpdate)
            
        } else if  btnTag == 4{
            
            let cocoii : ImmuneTurkey = dataImmuneArray.object(at: sender.tag) as! ImmuneTurkey
            vsibilityValue = cocoii.visibilityCheck as! Bool
            var observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            let obsName = cocoii.observationField
            
            if obsName == bodyWeightObs{
                
                let immuneSettingsUpdate = CoreDataHandlerTurkeyModels.ImmuneSettingsUpdate(
                    observationField: cocoii.observationField!,
                    visibilityCheck: vsibilityValue,
                    quicklinks: false,
                    information: "xyz",
                    index: sender.tag,
                    dbArray: dataImmuneArray,
                    observationId: observationId,
                    measure: measure!,
                    isSync: true,
                    lngId: lngIdValue!,
                    refId: refId!
                )
                CoreDataHandlerTurkey().updateSettingDataImmuneTurkey(immuneSettingsUpdate)
            }
            else{
                let immuneSettingsUpdate = CoreDataHandlerTurkeyModels.ImmuneSettingsUpdate(
                    observationField: cocoii.observationField!,
                    visibilityCheck: vsibilityValue,
                    quicklinks: sender.isSelected,
                    information: "xyz",
                    index: sender.tag,
                    dbArray: dataImmuneArray,
                    observationId: observationId,
                    measure: measure!,
                    isSync: true,
                    lngId: lngIdValue!,
                    refId: refId!
                )
                CoreDataHandlerTurkey().updateSettingDataImmuneTurkey(immuneSettingsUpdate)
            }
        }
    }
    
    // MARK: - 🔀 Switch Button Actions (🦠, 💉, 🧬, 💾)
    @objc func switchClick(_ sender:UISwitch){
        
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        guard let cell :SettingTblCell = tblView.cellForRow(at: indexpath as IndexPath) as? SettingTblCell else{
            return
        }
        
        if sender.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
            quicklinksValue = false
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        } else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
            quicklinksValue = false
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        
        if btnTag == 0 {
            
            let skeletaObject : SkeletaTurkey = dataSkeletaArray.object(at: sender.tag) as! SkeletaTurkey
            var observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let  lngIdValue = skeletaObject.lngId
            let  refId = skeletaObject.refId
            
            let updatedSkeSetting = CoreDataHandlerTurkeyModels.updateTurkySkeletaSettings(
                strObservationField: skeletaObject.observationField!,
                visibilityCheck: sender.isOn,
                quicklinks: quicklinksValue,
                strInformation: "xyz",
                index: sender.tag,
                dbArray: dataSkeletaArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataSkeltaTurkey(updatedSkeSetting)
        }
        else if btnTag == 1{
            
            let cocoii : CoccidiosisTurkey = dataCocoiiArray.object(at: sender.tag) as! CoccidiosisTurkey
            var  observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            
            let cocciData = CoreDataHandlerTurkeyModels.updateCoccidiosisTurkeySettings(
                strObservationField: cocoii.observationField!,
                visibilityCheck: sender.isOn,
                quicklinks: quicklinksValue,
                strInformation: "xyz",
                index: sender.tag,
                dbArray: dataCocoiiArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataCocoiiTurkey(data: cocciData)
        }
        else if btnTag == 2{
            let skeletaObject : GITractTurkey = dataGiTractArray.object(at: sender.tag) as! GITractTurkey
            var  observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let  lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let updateGitrectSeetingsData = CoreDataHandlerTurkeyModels.updateGITractSettingsData(
                observationField: skeletaObject.observationField!,
                visibilityCheck: sender.isOn,
                quicklinks: quicklinksValue,
                information: "xyz",
                index: sender.tag,
                dbArray: dataGiTractArray,
                obsId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataGitractTurkey(updateGitrectSeetingsData)
        }
        else if btnTag == 3{
            
            let cocoii : RespiratoryTurkey = dataRespiratoryArray.object(at: sender.tag) as! RespiratoryTurkey
            var observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            
            let settingsUpdate = CoreDataHandlerTurkeyModels.turkeyRespiratorySettingsUpdate(
                observationField: cocoii.observationField!,
                visibilityCheck: sender.isOn,
                quicklinks: quicklinksValue,
                information: "xyz",
                index: sender.tag,
                dbArray: dataRespiratoryArray,
                observationId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataRespTurkey(settingsUpdate)
        }
        else if btnTag == 4{
            
            let cocoii : ImmuneTurkey = dataImmuneArray.object(at: sender.tag) as! ImmuneTurkey
            var observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            
            let immuneSettingsUpdate = CoreDataHandlerTurkeyModels.ImmuneSettingsUpdate(
                observationField: cocoii.observationField!,
                visibilityCheck: sender.isOn,
                quicklinks: quicklinksValue,
                information: "xyz",
                index: sender.tag,
                dbArray: dataImmuneArray,
                observationId: observationId,
                measure: measure!,
                isSync: true,
                lngId: lngIdValue!,
                refId: refId!
            )
            CoreDataHandlerTurkey().updateSettingDataImmuneTurkey(immuneSettingsUpdate)
        }
    }
    
    // MARK: - ☰ Menu / Sidebar Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    // MARK: - 🦴 Setup Skeletal Cell Data
    fileprivate func setupSkeleta(_ indexPath: IndexPath, _ cell: SettingTblCell) {
        let skeletaObject : SkeletaTurkey = dataSkeletaArray.object(at: indexPath.row) as! SkeletaTurkey
        cell.lblName.text = skeletaObject.observationField
        cell.switchView.isOn = skeletaObject.visibilityCheck as! Bool
        
        if cell.switchView.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
        }
        else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
        }
        cell.checkBoxOutlet.isSelected = skeletaObject.quicklinks as! Bool
        
        if cell.checkBoxOutlet.isSelected == true {
            cell.checkBoxOutlet.setImage(UIImage(named: "Check_")!, for: .normal)
        } else {
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
    }
    // MARK: - 🔬 Setup Coccidiosis Cell Data
    fileprivate func setupCoccidiosis(_ indexPath: IndexPath, _ cell: SettingTblCell) {
        let cocoii : CoccidiosisTurkey = dataCocoiiArray.object(at: indexPath.row) as! CoccidiosisTurkey
        cell.lblName.text = cocoii.observationField
        cell.switchView.isOn = cocoii.visibilityCheck as! Bool
        
        if cell.switchView.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
        } else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
        }
        
        cell.checkBoxOutlet.isSelected = cocoii.quicklinks as! Bool
        if cell.checkBoxOutlet.isSelected == true {
            cell.checkBoxOutlet.setImage(UIImage(named: "Check_")!, for: .normal)
        } else {
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
    }
    // MARK: - 🫀 Setup GI Tract Cell Data
    fileprivate func setupGiTract(_ indexPath: IndexPath, _ cell: SettingTblCell) {
        let skeletaObject : GITractTurkey = dataGiTractArray.object(at: indexPath.row) as! GITractTurkey
        cell.lblName.text = skeletaObject.observationField
        cell.switchView.isOn = skeletaObject.visibilityCheck as! Bool
        
        if cell.switchView.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
        } else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
        }
        cell.checkBoxOutlet.isSelected = skeletaObject.quicklinks as! Bool
        
        if cell.checkBoxOutlet.isSelected == true {
            cell.checkBoxOutlet.setImage(UIImage(named: "Check_")!, for: .normal)
        } else {
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
    }
    // MARK: - 🫁 Setup Respiratory Cell Data
    fileprivate func setupRespiratory(_ indexPath: IndexPath, _ cell: SettingTblCell) {
        let cocoii : RespiratoryTurkey = dataRespiratoryArray.object(at: indexPath.row) as! RespiratoryTurkey
        cell.lblName.text = cocoii.observationField
        cell.switchView.isOn = cocoii.visibilityCheck as! Bool
        
        if cell.switchView.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
        }  else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
        }
        
        cell.checkBoxOutlet.isSelected = cocoii.quicklinks as! Bool
        
        if cell.checkBoxOutlet.isSelected == true {
            cell.checkBoxOutlet.setImage(UIImage(named: "Check_")!, for: .normal)
        } else {
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
    }
    
    fileprivate func setupImmune(_ indexPath: IndexPath, _ cell: SettingTblCell) {
        let cocoii : ImmuneTurkey = dataImmuneArray.object(at: indexPath.row) as! ImmuneTurkey
        cell.lblName.text = cocoii.observationField
        cell.switchView.isOn = cocoii.visibilityCheck as! Bool
        
        
        if cell.switchView.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
        }
        else {
            cell.checkBoxOutlet.isUserInteractionEnabled = false
        }
        
        cell.checkBoxOutlet.isSelected = cocoii.quicklinks as! Bool
        
        
        
        if cell.checkBoxOutlet.isSelected == true {
            cell.checkBoxOutlet.setImage(UIImage(named: "Check_")!, for: .normal)
        } else {
            
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
    }
    
    /**********************************************************************************************/
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingTblCell
        // or fatalError() or whatever
        
        if indexPath.row % 2 == 0 {
            cell.bgView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            
            cell.bgView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        }
        
        if btnTag == 0 {
            setupSkeleta(indexPath, cell)
        }
        else if btnTag == 1{
            setupCoccidiosis(indexPath, cell)
        }
        else if btnTag == 2 {
            setupGiTract(indexPath, cell)
        }
        else if btnTag == 3 {
            setupRespiratory(indexPath, cell)
        }
        else if btnTag ==  4{
            setupImmune(indexPath, cell)
            if  cell.lblName.text == bodyWeightObs{
                cell.checkBoxOutlet.isUserInteractionEnabled = false
                cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
            }
        }
        
        cell.checkBoxOutlet.addTarget(self, action: #selector(SettingControllerTurkey.checkBoxClick(_:)) , for: .touchUpInside )
        cell.switchView.addTarget(self, action: #selector(SettingControllerTurkey.switchClick(_:)) , for: .valueChanged)
        cell.switchView.tag = indexPath.row
        cell.checkBoxOutlet.tag = indexPath.row
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch btnTag {
        case 0:
            return dataSkeletaArray.count
        case 1:
            return dataCocoiiArray.count
        case 2:
            return dataGiTractArray.count
        case 3:
            return dataRespiratoryArray.count
        default:
            return dataImmuneArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
    
    // MARK: - METHODS AND FUNCTIONS
    @objc func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: false)
    }
    
}


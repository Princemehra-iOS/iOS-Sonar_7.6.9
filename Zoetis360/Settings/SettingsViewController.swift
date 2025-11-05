//
//  SettingsViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 9/6/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Reachability
import SystemConfiguration
import Gigya
import GigyaTfa
import GigyaAuth

class SettingsViewController: UIViewController,UINavigationControllerDelegate,closeButton,userLogOut,syncApi, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Outlets
    @IBOutlet weak var syncNotifcCount: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var skeltaLabel: UILabel!
    @IBOutlet weak var cocodissLabel: UILabel!
    @IBOutlet weak var gitractLabel: UILabel!
    @IBOutlet weak var respLabel: UILabel!
    @IBOutlet weak var immuLabel: UILabel!
    
    @IBOutlet weak var btnSkleton: UIButton!
    @IBOutlet weak var btnCocii: UIButton!
    @IBOutlet weak var btnGit: UIButton!
    @IBOutlet weak var btnResp: UIButton!
    @IBOutlet weak var btnImmu: UIButton!
    @IBOutlet weak var tblView: UITableView!
    /******** Intilizing Array **************************/
    
    // MARK: - VARIABLES
    var customPopV :infoLink!
    var quicklinksValue =  Bool()
    var dataSource:CommonTableView!
    var acessToken = String()
    let buttonbg = UIButton ()
    let objApiSync = ApiSync()
    var customPopView1 :UserListView!
    let buttonDroper = UIButton ()
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
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    let offlineMsgAlert = Constants.offline
    // MARK: - **************** View Life Cycle ***********************************/
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        objApiSync.delegeteSyncApi = self
        btnTag = 0
        btnSkleton.setImage(UIImage(named: "skeletal_select"), for: .normal)
        btnCocii.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
        btnGit.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
        btnImmu.setImage(UIImage(named: "immune_unselect"), for: .normal)
        btnResp.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
        
        if WebClass.sharedInstance.connected(), appDelegate.globalDataArr.count > 0 {
            
                dataArray = appDelegate.globalDataArr
            
        }
        
        self.skeletalMusclarAction(sender: "0" as AnyObject)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        skeltaLabel.text = NSLocalizedString("Skeletal/Muscular/Integumentary", comment: "")
        cocodissLabel.text = NSLocalizedString("Coccidiosis", comment: "")
        gitractLabel.text = NSLocalizedString("GI Tract", comment: "")
        respLabel.text = NSLocalizedString("Respiratory", comment: "")
        immuLabel.text = NSLocalizedString("Immune/Others", comment: "")
        self.printSyncLblCount()
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        
    }
    
    // MARK: 🟠 ****************IBACTIONS***********************************/
    @IBAction func skeletalMusclarAction(sender: AnyObject) {
        btnTag = 0
        if(btnSkleton.isSelected == false){
            
            btnSkleton.setImage(UIImage(named: "skeletal_select"), for: .normal)
            btnCocii.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            btnGit.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            btnImmu.setImage(UIImage(named: "immune_unselect"), for: .normal)
            btnResp.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataSkeletaArray = CoreDataHandler().fetchAllSeettingdataWithLngId(lngId:lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
        
    }
    
    @IBAction func coccidiosisAction(sender: AnyObject) {
        
        btnTag = 1
        if(btnCocii.isSelected == false){
            
            btnSkleton.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            btnCocii.setImage(UIImage(named: "Coccidiosis_select"), for: .normal)
            btnGit.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            btnImmu.setImage(UIImage(named: "immune_unselect"), for: .normal)
            btnResp.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataCocoiiArray = CoreDataHandler().fetchAllCocoiiDataUsinglngId(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
        
    }
    
    
    @IBAction func giTractAction(sender: AnyObject) {
        strButtonNmae = "gitract"
        
        btnTag = 2
        if(btnGit.isSelected == false){
            btnSkleton.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            btnCocii.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            btnGit.setImage(UIImage(named: "skeletal_select"), for: .normal)
            btnImmu.setImage(UIImage(named: "immune_unselect"), for: .normal)
            btnResp.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
            
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataGiTractArray = CoreDataHandler().fetchAllGITractDataUsingLngId(lngId: lngId as NSNumber)
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
        
    }
    
    @IBAction func respiratoryAction(sender: AnyObject) {
        strButtonNmae = "respiro"
        
        btnTag = 3
        if (btnResp.isSelected == false) {
            btnSkleton.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            btnCocii.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            btnGit.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            btnImmu.setImage(UIImage(named: "immune_unselect"), for: .normal)
            btnResp.setImage(UIImage(named: "skeletal_select"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataRespiratoryArray = CoreDataHandler().fetchAllRespiratoryusingLngId(lngId: lngId as NSNumber)
        
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
    }
    
    @IBAction func immuneOthers(sender:AnyObject) {
        strButtonNmae = "immu"
        
        btnTag = 4
        if (btnImmu.isSelected == false) {
            
            btnSkleton.setImage(UIImage(named: "skeletal_unselect"), for: .normal)
            btnCocii.setImage(UIImage(named: "Coccidiosis_unselect"), for: .normal)
            btnGit.setImage(UIImage(named: "gi_tract_unselect"), for: .normal)
            btnImmu.setImage(UIImage(named: "immune_select"), for: .normal)
            btnResp.setImage(UIImage(named: "respiratory_unselect"), for: .normal)
        }
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        dataImmuneArray = CoreDataHandler().fetchAllImmuneUsingLngId(lngId: lngId as NSNumber)
        
        Helper.dismissGlobalHUD(self.view)
        self.tblView.reloadData()
        
    }
    
    @IBAction func sideMenu(sender: AnyObject) {
        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func syncBtnAction(sender: AnyObject) {
        // self.saveDatOnServerAllSeting()
        
        if self.allSessionArr().count > 0 {
            if ConnectionManager.shared.hasConnectivity(){
                
                Helper.showGlobalProgressHUDWithTitle(self.view,title : NSLocalizedString("Data syncing...", comment: ""))
                
                self.callSyncApi()
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineMsgAlert, comment: ""))
            }
        } else {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    
    @IBAction func logOutBttn(sender: AnyObject) {
        clickHelpPopUp()
        
    }
    
    @objc func checkBoxClick(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if  sender.isSelected {
            sender.isSelected = true
            sender.setImage(UIImage(named: "Check_")!, for: .normal)
            
        } else {
            
            sender.setImage(nil, for: .normal)
            sender.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        var observationId: Int
        var vsibilityValue: Bool
        
        if btnTag == 0 {
            let skeletaObject : Skeleta = dataSkeletaArray.object(at: sender.tag) as! Skeleta
            vsibilityValue = skeletaObject.visibilityCheck as! Bool
            observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let settingData = chickenCoreDataHandlerModels.updateSkeletaSettingData(
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
            CoreDataHandler().updateSettingDataSkelta(settingData)
            
        }
        else if  btnTag == 1{
            
            let cocoii : Coccidiosis = dataCocoiiArray.object(at: sender.tag) as! Coccidiosis
            vsibilityValue = cocoii.visibilityCheck as! Bool
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            
            let settingData = chickenCoreDataHandlerModels.updateCoccidiosisSettingData(
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

            CoreDataHandler().updateSettingDataCocoii(settingData)
            
            
        }
        else if  btnTag == 2 {
            let skeletaObject : GITract = dataGiTractArray.object(at: sender.tag) as! GITract
            vsibilityValue = skeletaObject.visibilityCheck as! Bool
            observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let settingData = chickenCoreDataHandlerModels.updateGITractSettingData(
                strObservationField: skeletaObject.observationField!,
                  visibilityCheck: vsibilityValue,
                  quicklinks: sender.isSelected,
                  strInformation: "xyz",
                  index: sender.tag,
                  dbArray: dataGiTractArray,
                  obsId: observationId,
                  measure: measure!,
                  isSync: true,
                  lngId: lngIdValue!,
                  refId: refId!
            )

            CoreDataHandler().updateSettingDataGitract(settingData: settingData)
            
        }
        else if  btnTag == 3{
            
            let cocoii : Respiratory = dataRespiratoryArray.object(at: sender.tag) as! Respiratory
            vsibilityValue =
            cocoii.visibilityCheck as! Bool
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            
            let updateSettings = chickenCoreDataHandlerModels.updateRespiratorySettings(
                strObservationField: cocoii.observationField!,
                    visibilityCheck: vsibilityValue,
                    quicklinks: sender.isSelected,
                    strInformation: "xyz",
                    index: sender.tag,
                    dbArray: dataRespiratoryArray,
                    obsId: observationId,
                    measure: measure!,
                    isSync: true,
                    lngId: lngIdValue!,
                    refId: refId!
            )

            CoreDataHandler().updateSettingDataResp(updateSettings)
            
        }
        else if  btnTag == 4{
            
            let cocoii : Immune = dataImmuneArray.object(at: sender.tag) as! Immune
            vsibilityValue = cocoii.visibilityCheck as! Bool
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let lngIdValue = cocoii.lngId
            let refId = cocoii.refId
            
            let immuneData = chickenCoreDataHandlerModels.ImmuneUpdateData(
                strObservationField: cocoii.observationField!,
                    visibilityCheck: vsibilityValue,
                    quicklinks: sender.isSelected,
                    strInformation: "xyz",
                    obsId: observationId,
                    measure: measure!,
                    isSync: true,
                    lngId: lngIdValue!,
                    refId: refId!
            )

            CoreDataHandler().updateSettingDataImmune(immuneData, index: sender.tag, dbArray: dataImmuneArray)
            
        }
    }
    
    // MARK: 🟠 **************** tableView DataSource & Delegate Methods ***********************************/
    
    fileprivate func handleBtnTag4CellForRow(_ indexPath: IndexPath, _ cell: CustomeTableViewCell) {
        let cocoii : Immune = dataImmuneArray.object(at: indexPath.row) as! Immune
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
    
    fileprivate func handleBtnTag3CellforRow(_ indexPath: IndexPath, _ cell: CustomeTableViewCell) {
        let cocoii : Respiratory = dataRespiratoryArray.object(at: indexPath.row) as! Respiratory
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
    
    fileprivate func handleBtnTag2(_ indexPath: IndexPath, _ cell: CustomeTableViewCell) {
        let skeletaObject : GITract = dataGiTractArray.object(at: indexPath.row) as! GITract
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
    
    fileprivate func handleBtnTag1(_ indexPath: IndexPath, _ cell: CustomeTableViewCell) {
        let cocoii : Coccidiosis = dataCocoiiArray.object(at: indexPath.row) as! Coccidiosis
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
    
    fileprivate func handleBtnTag0ellForRow(_ indexPath: IndexPath, _ cell: CustomeTableViewCell) {
        let skeletaObject : Skeleta = dataSkeletaArray.object(at: indexPath.row) as! Skeleta
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomeTableViewCell
        if indexPath.row % 2 == 0 {
            cell.bgView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            cell.bgView.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        }
        
        if btnTag == 0 {
            handleBtnTag0ellForRow(indexPath, cell)
        } else if btnTag == 1 {
            handleBtnTag1(indexPath, cell)
        } else if btnTag == 2 {
            handleBtnTag2(indexPath, cell)
        } else if btnTag == 3 {
            handleBtnTag3CellforRow(indexPath, cell)
        } else if btnTag == 4 {
            handleBtnTag4CellForRow(indexPath, cell)
        }
        cell.checkBoxOutlet.addTarget(self, action: #selector(SettingsViewController.checkBoxClick(_:)) , for: .touchUpInside )
        cell.switchView.addTarget(self, action: #selector(SettingsViewController.switchClick(_:)) , for: .valueChanged)
        cell.switchView.tag = indexPath.row
        cell.checkBoxOutlet.tag = indexPath.row
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    /**********************************************************************************************/
    
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
    
    // MARK: 🟠 - Function & Methods
    
    @objc func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
 
    // MARK: 🟠 Function to save all the Settings details
  
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
            }
            else if visibilityCheck == false {
                isQuicklinksCheck = false
            }
            
            if visibilitySwitch == true {
                isVisibilityCheck = true
            }
            else{
                isVisibilityCheck = false
            }
            
            if  btnTag == 0 {
                
                let settings = chickenCoreDataHandlerModels.saveSkeletaSettingsInDB(
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
                      quicklinkIndex: quickLinkIndex
                )
                CoreDataHandler().saveSettingsSkeletaInDatabase(settings)
                
            }
            else if btnTag == 1{
                

                let settingData = chickenCoreDataHandlerModels.saveCoccidiosisSettingDB(
                    strObservationField: strObservationField,
                        visibilityCheck: isVisibilityCheck,
                        quicklinks: isQuicklinksCheck,
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

                CoreDataHandler().saveSettingsCocoiiInDatabase(settingData)
                
            }
            else if btnTag == 2{
                
                
                let settingData = chickenCoreDataHandlerModels.saveGITractSettingData(
                    strObservationField: strObservationField,
                        visibilityCheck: isVisibilityCheck,
                        quicklinks: isQuicklinksCheck,
                        strInformation: "xyz",
                        index: i,
                        dbArray: dataGiTractArray,
                        obsId: obsId,
                        measure: measure,
                        isSync: false,
                        lngId: lngIdValue,
                        refId: refId,
                        quicklinkIndex: quickLinkIndex
                )

                CoreDataHandler().saveSettingsGITractDatabase(settingData: settingData)
            }
            else if btnTag == 3{
                
                
                let settings = chickenCoreDataHandlerModels.saveRespiratorySettings(
                    strObservationField: strObservationField,
                      visibilityCheck: isVisibilityCheck,
                      quicklinks: isQuicklinksCheck,
                      strInformation: "xyz",
                      index: i,
                      dbArray: dataRespiratoryArray,
                      obsId: obsId,
                      measure: measure,
                      isSync: false,
                      lngId: lngIdValue,
                      refId: refId,
                      quicklinkIndex: quickLinkIndex
                )

                CoreDataHandler().saveSettingsRespiratoryDatabase(settings: settings)
                
            }
            else{
                
                let settings = chickenCoreDataHandlerModels.saveImmuneSettings(
                       strObservationField: strObservationField,
                       visibilityCheck: isVisibilityCheck,
                       quicklinks: isQuicklinksCheck,
                       strInformation: "xyz",
                       index: i,
                       dbArray: dataImmuneArray,
                       obsId: obsId,
                       measure: measure,
                       isSync: false,
                       lngId: lngIdValue,
                       refId: refId,
                       quicklinkIndex: quickLinkIndex
                )

                CoreDataHandler().saveSettingsImmuneDatabase(settings)
                
            }
        }
    }
    // MARK: 🟢 Save Data on server for Quick Link & Visibility
    func SaveDatOnServer(obsId :NSInteger,quickLink : Bool,visibility: Bool) {
        
        let Internaldict = NSMutableDictionary()
        let outerDict = NSMutableDictionary()
        let arr1 = NSMutableArray()
        let Id = UserDefaults.standard.integer(forKey: "Id")
        outerDict.setValue(Id, forKey: "UserId")
        
        Internaldict.setValue(obsId, forKey: "ObservationId")
        Internaldict.setValue(quickLink, forKey: "QuickLink")
        Internaldict.setValue(visibility, forKey: "Visibility")
        Internaldict.setValue(lngId, forKey: "LanguageId")
        arr1.add(Internaldict)
        outerDict.setValue(arr1, forKey: "ObservationUserDetails")

        if WebClass.sharedInstance.connected() {
            
            let Url = "Setting/SaveUserSetting"
            acessToken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
          //  acessToken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
            let headerDict = [Constants.authorization:acessToken]
            
            let urlString: String = WebClass.sharedInstance.webUrl.appending(Url)
            var request = URLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: outerDict, options: [])
            
            sessionManager.request(request as URLRequestConvertible)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        
                        if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            print (error)
                            print (responseString)
                        }
                        
                    case .success(let responseObject):
                        
                        debugPrint(responseObject)
                    }
                }
        }
    }
    
    
    // MARK: 🟠 Action Of Switch Button Action ***********************************************/
    @objc func switchClick(_ sender:UISwitch){
        
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        guard let cell = tblView.cellForRow(at: indexpath as IndexPath) as? CustomeTableViewCell else{
            
            return
        }
        
        if sender.isOn == true {
            cell.checkBoxOutlet.isUserInteractionEnabled = true
            quicklinksValue = false
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        
        else{
            cell.checkBoxOutlet.isUserInteractionEnabled = false
            quicklinksValue = false
            cell.checkBoxOutlet.setImage(UIImage(named: "Uncheck_")!, for: .normal)
        }
        
        var observationId: Int
        
        if btnTag == 0 {
            
            let skeletaObject : Skeleta = dataSkeletaArray.object(at: sender.tag) as! Skeleta
            observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let  lngIdValue = skeletaObject.lngId
            let  refId = skeletaObject.refId
            let settingData = chickenCoreDataHandlerModels.updateSkeletaSettingData(
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
            CoreDataHandler().updateSettingDataSkelta(settingData)
        }
        else if btnTag == 1{
            
            let cocoii : Coccidiosis = dataCocoiiArray.object(at: sender.tag) as! Coccidiosis
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            let settingData = chickenCoreDataHandlerModels.updateCoccidiosisSettingData(
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

            CoreDataHandler().updateSettingDataCocoii(settingData)
        }
        
        else if btnTag == 2{
            let skeletaObject : GITract = dataGiTractArray.object(at: sender.tag) as! GITract
            observationId = skeletaObject.observationId as! NSInteger
            let measure = skeletaObject.measure
            let  lngIdValue = skeletaObject.lngId
            let refId = skeletaObject.refId
            
            let settingData = chickenCoreDataHandlerModels.updateGITractSettingData(
                strObservationField: skeletaObject.observationField!,
                   visibilityCheck: sender.isOn,
                   quicklinks: quicklinksValue,
                   strInformation: "xyz",
                   index: sender.tag,
                   dbArray: dataGiTractArray,
                   obsId: observationId,
                   measure: measure!,
                   isSync: true,
                   lngId: lngIdValue!,
                   refId: refId!
            )

            CoreDataHandler().updateSettingDataGitract(settingData: settingData)
            
        }
        else if btnTag == 3{
            let cocoii : Respiratory = dataRespiratoryArray.object(at: sender.tag) as! Respiratory
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            
            let updateSettings = chickenCoreDataHandlerModels.updateRespiratorySettings(
                strObservationField: cocoii.observationField!,
                    visibilityCheck: sender.isOn,
                    quicklinks: quicklinksValue,
                    strInformation: "xyz",
                    index: sender.tag,
                    dbArray: dataRespiratoryArray,
                    obsId: observationId,
                    measure: measure!,
                    isSync: true,
                    lngId: lngIdValue!,
                    refId: refId!
            )

            CoreDataHandler().updateSettingDataResp(updateSettings)
            
        }
        else if btnTag == 4{
            let cocoii : Immune = dataImmuneArray.object(at: sender.tag) as! Immune
            observationId = cocoii.observationId as! NSInteger
            let measure = cocoii.measure
            let  lngIdValue = cocoii.lngId
            let  refId = cocoii.refId
            
            let immuneData = chickenCoreDataHandlerModels.ImmuneUpdateData(
                strObservationField: cocoii.observationField!,
                   visibilityCheck: sender.isOn,
                   quicklinks: quicklinksValue,
                   strInformation: "xyz",
                   obsId: observationId,
                   measure: measure!,
                   isSync: true,
                   lngId: lngIdValue!,
                   refId: refId!
            )

            CoreDataHandler().updateSettingDataImmune(immuneData, index: sender.tag, dbArray: dataImmuneArray)
            
        }
    }

    // MARK: 🟠 Custome PopUp

    func clickHelpPopUpqw() {
        
        buttonDroper.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonDroper.addTarget(self, action: #selector(SettingsViewController.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonDroper)
        
        customPopV = (infoLink.loadFromNibNamed("infoLink") as! infoLink)
        customPopV.delegateInfo = self
        customPopV.center = self.view.center
        buttonDroper.addSubview(customPopV)
    }
  
    // MARK: 🟠 Dismiss Dropdown

    @objc func buttonPressedDroper(sender: UIButton!) {
        buttonDroper.removeFromSuperview()
    }

    // MARK: 🟠 Dismiss Custome Popup
   
    func noPopUpPosting(){
        buttonDroper.removeFromSuperview()
        customPopV.removeView(view)
    }
    
    func doneButton(){
        customPopV.removeView(view)
    }

    // MARK: 🟠 Side Menu Button action

    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out" {
            UserDefaults.standard.removeObject(forKey: "login")
            if ConnectionManager.shared.hasConnectivity() {
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            } else {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(offlineMsgAlert, comment: ""))
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            buttonbg.removeFromSuperview()
            customPopView1.removeView(view)
        }
    }
    
    // MARK: 🟠  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                debugPrint(data)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
   
    // MARK: 🟠 Load Custome Popup

    func clickHelpPopUp() {
        buttonbg.frame = CGRect(x: 0,y: 0,width: 1024,height: 768)
        buttonbg.addTarget(self, action: #selector(SettingsViewController.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as? UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x :self.view.frame.size.width - 200,y: 60,width: 150,height: 60))
    }
    
    @objc func buttonPressed1() {
        customPopView1.removeView(view)
        buttonbg.removeFromSuperview()
    }
    // MARK: 🟠 Get all Session's List
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0 ..< necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        var sessionId: NSNumber
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            
            sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    func callSyncApi() {
        objApiSync.feedprogram()
    }
    
    // MARK: 🟠 -- Delegate SyNC Api
    
    func failWithError(statusCode:Int) {
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again(NA))", comment: ""))
        }
        else {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.", comment: "") + "\n(\(statusCode))")
        }
    }
    
    func failWithErrorInternal(){
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection Please try again!", comment: ""))
    }
    
    func didFinishApi() {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnection() {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineMsgAlert, comment: ""))
    }
    
    func printSyncLblCount(){
        print(appDelegateObj.testFuntion())
    }
    
    /*******************************************************************************/
    // MARK: 🟠 Save All settings Data on server
    func saveDatOnServerAllSeting() {
        
        let outerDict = NSMutableDictionary()
        let arr1 = NSMutableArray()
        let Id = UserDefaults.standard.integer(forKey: "Id")
        outerDict.setValue(Id, forKey: "UserId")
        
        let cocoii =  CoreDataHandler().fetchAllCocoiiData().mutableCopy() as! NSMutableArray
        let gitract =  CoreDataHandler().fetchAllGITractData().mutableCopy() as! NSMutableArray
        let resp =  CoreDataHandler().fetchAllRespiratory().mutableCopy() as! NSMutableArray
        let immu =  CoreDataHandler().fetchAllImmune().mutableCopy() as! NSMutableArray
        let skeletenArr =  CoreDataHandler().fetchAllSeettingdata().mutableCopy() as! NSMutableArray
        
        for i in 0..<skeletenArr.count{
            let obsId = (skeletenArr.object(at: i) as AnyObject).value(forKey: "observationId")
            let visbility = (skeletenArr.object(at: i) as AnyObject).value(forKey:"visibilityCheck")
            let quickLink = (skeletenArr.object(at: i) as AnyObject).value(forKey:"quicklinks")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            Internaldict.setValue(lngId, forKey: "LanguageId")
            arr1.add(Internaldict)
        }
        for i in 0..<cocoii.count{
            let obsId = (cocoii.object(at: i) as AnyObject).value(forKey:"observationId")
            let visbility = (cocoii.object(at: i) as AnyObject).value(forKey:"visibilityCheck")
            let quickLink = (cocoii.object(at: i) as AnyObject).value(forKey:"quicklinks")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            arr1.add(Internaldict)
            
        }
        for i in 0..<gitract.count{
            let obsId = (gitract.object(at: i) as AnyObject).value(forKey:"observationId")
            let visbility = (gitract.object(at: i) as AnyObject).value(forKey:"visibilityCheck")
            let quickLink = (gitract.object(at: i) as AnyObject).value(forKey:"quicklinks")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            arr1.add(Internaldict)
        }
        for i in 0..<resp.count{
            let obsId = (resp.object(at: i) as AnyObject).value(forKey:"observationId")
            let visbility = (resp.object(at: i) as AnyObject).value(forKey:"visibilityCheck")
            let quickLink = (resp.object(at: i) as AnyObject).value(forKey:"quicklinks")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            arr1.add(Internaldict)
        }
        for i in 0..<immu.count{
            let obsId = (immu.object(at: i) as AnyObject).value(forKey:"observationId")
            let visbility = (immu.object(at: i) as AnyObject).value(forKey:"visibilityCheck")
            let quickLink = (immu.object(at: i) as AnyObject).value(forKey:"quicklinks")
            let Internaldict = NSMutableDictionary()
            Internaldict.setValue(obsId, forKey: "ObservationId")
            Internaldict.setValue(quickLink, forKey: "QuickLink")
            Internaldict.setValue(visbility, forKey: "Visibility")
            arr1.add(Internaldict)
        }
        
        outerDict.setValue(arr1, forKey: "ObservationUserDetails")
        
        if WebClass.sharedInstance.connected() {
            
            let Url = "Setting/SaveUserSetting"
            acessToken = (UserDefaults.standard.value(forKey:Constants.accessToken) as? String)!
            let headerDict = [Constants.authorization:acessToken]
            let urlString: String = WebClass.sharedInstance.webUrl.appending(Url)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL )
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerDict
            request.setValue(Constants.applicationJson, forHTTPHeaderField: Constants.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: outerDict, options: [])
            
            sessionManager.request(request as! URLRequestConvertible).responseJSON { response in
                    
                    switch response.result {
                        
                    case .failure(let error):
                        
                        if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            print (error)
                            print (responseString)
                            
                        }
                        
                    case .success(let responseObject):
                        
                        debugPrint(responseObject)
                        
                    }
                }
        }
    }
}







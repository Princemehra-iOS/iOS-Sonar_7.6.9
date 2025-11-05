//
//  PostingSessionDetailController.swift
//  Zoetis -Feathers
//
//  Created by "" on 8/22/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Alamofire
import Reachability
import SystemConfiguration
import Alamofire

import Gigya
import GigyaTfa
import GigyaAuth
import SwiftyJSON


class PostingSessionDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,userLogOut,syncApi,SyncApiData,
                                      openNotes,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate , otherFuncDetails {
    
    
    
    // MARK: - VARIABLES
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    var lngId = NSInteger()
    let buttonbg1 = UIButton ()
    var droperTableView  =  UITableView ()
    var postingArrWithId = NSMutableArray()
    var feedProArrWithId = NSMutableArray()
    var captureNecropsy = [NSManagedObject]()
    var postingId = NSNumber()
    var necId = NSNumber()
    var farmArray = NSMutableArray ()
    var vacArray = NSMutableArray ()
    let cellReuseIdentifier = "cell"
    var editFinalizeValue = NSNumber()
    var datePicker = UIDatePicker()
    var timeStamp = String()
    var actualTimestamp = String()
    let editView = UIView(frame:CGRect(x: 250, y: 220, width: 500, height: 330))
    let titleView = UIView(frame:CGRect(x: 0, y: 0, width: 500, height: 50))
    let nameLabel = UILabel(frame:CGRect(x: 42, y: 53, width: 300, height: 50))
    let titleLabel = UILabel(frame:CGRect(x: 150, y: 0, width: 400, height: 50))
    let ageLabel = UILabel(frame:CGRect(x: 42, y: 142, width: 100, height: 50))
    let feedLabel = UILabel(frame:CGRect(x: 190, y: 142, width: 300, height: 50))
    let nameText = UITextField(frame:CGRect(x: 40, y: 98, width: 300, height: 50))
    let ageButton = UIButton(frame:CGRect(x: 43, y: 184, width: 120, height: 50))
    let feedButton = UIButton(frame:CGRect(x: 190, y: 184, width: 268, height: 50))
    let submitButton = UIButton(frame:CGRect(x: 30, y: 270, width: 175, height: 40))
    let cancelButton = UIButton(frame:CGRect(x: 290, y: 270, width: 175, height: 40))
    let paddingView = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let paddingView1 = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let targetWeight = UITextField(frame:CGRect(x: 40, y: 270, width: 420, height: 50))
    var notesBGbtn = UIButton()
    var notesView :notes!
    var customPopView1 :UserListView!
    var age:String?
    let bttnbckround = UIButton ()
    var myPickerView = UIPickerView()
    var buttonbgNew = UIButton()
    var accestoken = String()
    var deviceTokenId = String()
    var  fullData  = String()
    var  strFeddCheck  = String()
    var timer  = Timer()
    var feedTableView  =  UITableView ()
    var btnTag = Int()
    var strfarmName = String()
    var strFeddUpdate = String()
    var feedIdUpdate = NSNumber()
    var buttonbgNew2 = UIButton()
    let buttonEdit: UIButton = UIButton()
    var camraImgeArr  = NSArray()
    var strdateTimeStamp = String()
    var strfarmNameArray = NSArray()
    var strFarmNameFeedId = String()
    var  strMsgforDelete = String()
    var strFeedId = Int()
    let objApiSync = ApiSync()
    let objApiSyncOneSet = SingleSyncData()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let AgeOp = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80"]
    var finilizeValue = NSNumber()
    var oldFarmName = NSString()
    
    
    // MARK: - OUTLET
    @IBOutlet weak var synCount: UILabel!
    @IBOutlet weak var addFeedBtnOutlet: UIButton!
    @IBOutlet weak var updateDateButton: UIButton!
    @IBOutlet weak var finializeBttnOutlet: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lblFeedProgram: UILabel!
    @IBOutlet weak var sessionDate: UILabel!
    @IBOutlet weak var complexNamelbl: UILabel!
    @IBOutlet weak var salesRepLbl: UILabel!
    @IBOutlet weak var btnAddVaci: UIButton!
    @IBOutlet weak var sessionTypeLbl: UILabel!
    @IBOutlet weak var customerRepLbl: UILabel!
    
    @IBOutlet weak var cocciProgramLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var veterinarianLbl: UILabel!
    @IBOutlet weak var notesTextField: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var vaccinationTextField: UILabel!
    @IBOutlet weak var feedProtableView: UITableView!
    @IBOutlet weak var productionTypeLbl: UILabel!
    @IBOutlet weak var notesBtnnOutlet: UIButton!
    @IBOutlet weak var feedProgramBtnOutlet: UIButton!
    
    var buttonback = UIButton()
    var customPopV :OtherDetails!
    let paddingViewHouse = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let houseLabel = UILabel(frame:CGRect(x: 355, y: 53, width: 120, height: 50))
    let houseNoTxtFld = UITextField(frame:CGRect(x: 355, y: 98, width: 100, height: 50))
    var strHouseNumber = String()
    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        objApiSync.delegeteSyncApi = self
        objApiSyncOneSet.delegeteSyncApiData = self
        feedProtableView.estimatedRowHeight = 50
        feedProtableView.rowHeight = UITableView.automaticDimension
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM-dd-yyyy HH:mm:ss"
        strdateTimeStamp = dateFormatter.string(from: datePicker.date) as String
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        notesBtnnOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        btnAddVaci.layer.borderWidth = 1.0
        btnAddVaci.layer.borderColor = UIColor.black.cgColor
        notesBtnnOutlet.layer.borderWidth = 1.0
        notesBtnnOutlet.layer.borderColor = UIColor.black.cgColor
        postingArrWithId = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        let posting : PostingSession = postingArrWithId.object(at: 0) as! PostingSession
        
        let lngIdFr = UserDefaults.standard.integer(forKey: "lngId")
        if lngIdFr == 3{
            let dateString = posting.sessiondate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            let dateObj = dateFormatter.date(from: dateString!)
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            sessionDate.text = dateFormatter.string(from: dateObj!)
            UserDefaults.standard.set(dateFormatter.string(from: dateObj!), forKey: "dateFrench")    // value(forKey: "dateFrench") as? String
            addFeedBtnOutlet.setTitle("Ajouter un flux",for: .normal)
        }
        else{
            sessionDate.text = posting.sessiondate
        }
        complexNamelbl.text = posting.complexName
        deviceTokenId = posting.timeStamp!
        let optionalName: String? = posting.actualTimeStamp
        
        if optionalName == nil{
            actualTimestamp = ""
        }
        UserDefaults.standard.set(sessionDate.text, forKey: "date")
        UserDefaults.standard.set(complexNamelbl.text, forKey: "complex")
        UserDefaults.standard.synchronize()
        if posting.salesRepName == NSLocalizedString(appDelegateObj.selectStr, comment: "") || posting.salesRepName == appDelegateObj.selectStr{
            salesRepLbl.text = "NA"
        }
        else{
            salesRepLbl.text = posting.salesRepName
        }
        
        sessionTypeLbl.text = posting.sessionTypeName
        if  posting.customerRepName == ""{
            customerRepLbl.text = "NA"
        }
        else{
            customerRepLbl.text = posting.customerRepName
        }
        if  posting.productionTypeName == ""{
            productionTypeLbl.text = "NA"
        }
        else{
            productionTypeLbl.text = posting.productionTypeName
        }
        
        cocciProgramLbl.text = posting.cociiProgramName
        if cocciProgramLbl.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            cocciProgramLbl.text = ""
        }
        
        customerLbl.text = posting.customerName
        UserDefaults.standard.set( customerLbl.text, forKey: "custmer")
        veterinarianLbl.text = posting.vetanatrionName
        notesBtnnOutlet.setTitle(posting.notes, for: UIControl.State())
        UserDefaults.standard.set( posting.notes, forKey: "postingSessionNotes")
        feedProtableView.reloadData()
        feedProgramBtnOutlet.layer.borderWidth = 1
        feedProgramBtnOutlet.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.printSyncLblCount()
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1NecId(postingId) as! [NSManagedObject]
        notesBtnnOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        self.fetcFarmData()
        vacArray  =  CoreDataHandler().fetchAddvacinationData(postingId).mutableCopy() as! NSMutableArray
        if vacArray.count>0 {
            let vac : HatcheryVac = vacArray.object(at: 0) as! HatcheryVac
            vaccinationTextField.text = vac.vaciNationProgram
        }
        feedProArrWithId = []
        feedProArrWithId = CoreDataHandler().FetchFeedProgram(postingId).mutableCopy() as! NSMutableArray
        
        if  feedProArrWithId.count == 1 {
            lblFeedProgram.text = (feedProArrWithId.object(at: 0) as AnyObject).value(forKey: "feddProgramNam") as? String
            (feedProArrWithId.object(at: 0) as AnyObject).value(forKey: "feddProgramNam") as? String
        }
        
        if feedProArrWithId.count > 1 {
            let ftitle = NSMutableString()
            for i in 0..<feedProArrWithId.count{
                
                var label = UILabel()
                let feepRGMR = (feedProArrWithId.object(at: i) as AnyObject).value(forKey: "feddProgramNam") as! String
                
                if i == 0 {
                    
                    label  = UILabel(frame: CGRect(x: 50, y: 519, width: 111, height: 21))
                    ftitle.append( feepRGMR + " " )
                    
                } else {
                    
                    label  = UILabel(frame: CGRect(x: 50, y: 519, width: 111*(CGFloat(i)+1)+10, height: 21))
                    ftitle.append(", " + feepRGMR + " " )
                }
                
                label.textAlignment = NSTextAlignment.center
                label.backgroundColor = UIColor.red
                lblFeedProgram.text = ftitle as String
            }
        }
        
        if finilizeValue == 1{
            finializeBttnOutlet.isHidden = true
            notesBtnnOutlet.isUserInteractionEnabled = true
            btnAddVaci.isUserInteractionEnabled = true
            feedProgramBtnOutlet.isUserInteractionEnabled = true
            eyeImageView.image = UIImage(named:"eye_blue")!
            
        } else if finilizeValue == 0 {
            eyeImageView.image =  UIImage(named:"eye_orange")!
        }
        finializeBttnOutlet.layer.cornerRadius = 7
        self.feedProtableView.reloadData()
        
    }
    // MARK: 🟠 - Add Vaccination Button Action
    @IBAction func addVacButtonAction(_ sender: AnyObject) {
        let navigateToController = self.storyboard?.instantiateViewController(withIdentifier: "add") as? AddVaccinationViewController
        navigateToController?.postingIdFromExisting = postingId as NSNumber
        navigateToController?.finalizeValue = 0
        navigateToController?.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(navigateToController!, animated: false)
        
    }
    // MARK: 🟠 - Add Feed Button Action
    @IBAction func addFeedButtonAction(_ sender: AnyObject) {
        let navigateToController = self.storyboard?.instantiateViewController(withIdentifier: "feed") as? FeedProgramViewController
        navigateToController!.postingIdFromExisting = postingId as! Int
        navigateToController!.finializeCount = finilizeValue
        navigateToController!.addfeed = "addfeed"
        navigateToController?.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(navigateToController!, animated: false)
    }
    
    // MARK: 🟠 - Done Button Action
    func DoneFunc(){
        self.buttonback.removeFromSuperview()
        self.customPopV.removeFromSuperview()
    }
    
    // MARK: 🟠 - Other Details Button Action
    @IBAction func otherDetailsBtnAction(_ sender: UIButton) {
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcntion), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        let posting : PostingSession = postingArrWithId.object(at: 0) as! PostingSession
        customPopV = OtherDetails.loadFromNibNamed("OtherDetails") as! OtherDetails
        customPopV.liveText = posting.livability ?? ""
        customPopV.mortalityText = posting.dayMortality  ?? ""
        customPopV.otherFuncDetailsDelegate = self
        customPopV.avgAgeText = posting.avgAge  ?? ""
        customPopV.avgWeightText = posting.avgWeight  ?? ""
        customPopV.outTimeText = posting.outTime  ?? ""
        customPopV.fcrText = posting.fcr  ?? ""
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
    }
    
    // MARK: 🟠 Remove Custome popup
    @objc func buttonAcntion(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    // MARK: 🟠 - Fetch Farm Data Function
    func fetcFarmData() {
        
        self.captureNecropsy.removeAll()
        self.captureNecropsy =  CoreDataHandler().FetchNecropsystep1NecId(postingId) as! [NSManagedObject]
        farmArray.removeAllObjects()
        for object in captureNecropsy {
            
            let dictDat = NSMutableDictionary ()
            dictDat.setObject(object.value(forKey: "farmName") ?? "", forKey: "farmName" as NSString)
            dictDat.setObject(object.value(forKey: "noOfBirds") ?? 0, forKey: "noOfBirds" as NSString)
            dictDat.setObject(object.value(forKey: "houseNo") ?? 0, forKey: "houseNo" as NSString)
            dictDat.setObject(object.value(forKey: "age") ?? 0, forKey: "age" as NSString)
            dictDat.setObject(object.value(forKey: "necropsyId") ?? 0, forKey: "necropsyId" as NSString)
            dictDat.setObject(object.value(forKey: "timeStamp") ?? 0, forKey: "timeStamp" as NSString)
            dictDat.setObject(object.value(forKey: "feedProgram") ?? "", forKey: "feedProgram" as NSString)
            dictDat.setObject(object.value(forKey: "feedId") ?? -2332, forKey: "feedId" as NSString)
            farmArray.add(dictDat)
        }
    }
    
    // MARK: 🟠 - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == droperTableView {
            return feedProArrWithId.count
        }
        return farmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == droperTableView {
            
            let cell = UITableViewCell ()
            let feedProgram : FeedProgram = feedProArrWithId.object(at: indexPath.row) as! FeedProgram
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.textLabel!.text = feedProgram.feddProgramNam
            cell.tag = feedProgram.feedId as! Int
            return cell
            
        } else {
            
            let cell:PostingSessionDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostingSessionDetailTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let farmArrayWithoutAge = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "farmName") as? String
            let birdage = ((farmArray as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey:"age") as! String
            let farmNamevalue =  farmArrayWithoutAge!  + " " + "[" + birdage + "]"
            
            var farmName2 = String()
            let range = farmNamevalue.range(of: ".")
            if range != nil{
                let abc = String(farmNamevalue[range!.upperBound...]) as NSString
                farmName2 = String(indexPath.row+1) + "." + " " + String(describing:abc)
            }
            
            cell.farmsLabel.text = farmName2
            cell.updateButton.layer.borderWidth = 8.0
            cell.updateButton.layer.cornerRadius = 17.5
            cell.updateButton.layer.borderColor = UIColor.clear.cgColor
            cell.updateButton.tag = indexPath.row
            cell.houseNoLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "houseNo") as? String
            cell.noofBirdsLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "noOfBirds") as? String
            
            camraImgeArr = CoreDataHandler().fecthPhotoWithFormName(farmArrayWithoutAge!,necId: (((farmArray.object(at: indexPath.row)) as AnyObject).value(forKey: "necropsyId") as? NSNumber)!)
            cell.backgroundColor = UIColor.clear
            cell.badgeBttn.alpha = 1
            cell.badgeBttn.badgeString = String(camraImgeArr.count) as String
            cell.badgeBttn.badgeTextColor = UIColor.white
            cell.badgeBttn.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
            cell.badgeBttn.addTarget(self, action: #selector(PostingSessionDetailController.clickImage(_:)), for: .touchUpInside)
            cell.badgeBttn.tag = indexPath.row
            cell.feedPrgrmLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "feedProgram") as? String
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(PostingSessionDetailController.ClickDeleteBtton(_:)), for: .touchUpInside)
            
            if finilizeValue == 1 {
                cell.badgeBttn.setImage(UIImage(named: "galaryBlue"), for: UIControl.State())
                cell.deleteButton.isUserInteractionEnabled = false
                cell.deleteButton.isHidden = true
                
            } else {
                cell.badgeBttn.setImage(UIImage(named: "galary"), for: UIControl.State())
                cell.deleteButton.isUserInteractionEnabled = true
                cell.deleteButton.isHidden = false
            }
            if camraImgeArr.count<1{
                cell.badgeBttn.isEnabled = false
            }
            else {
                cell.badgeBttn.isEnabled = true
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == droperTableView {
            
            let feedProgram : FeedProgram = feedProArrWithId.object(at: indexPath.row) as! FeedProgram
            strFeddUpdate = feedProgram.feddProgramNam!
            feedIdUpdate = feedProgram.feedId!
            if btnTag == 1 {
                CoreDataHandler().updatedPostigSessionwithIsFarmSyncPostingId(self.postingId, isFarmSync: false)
                feedButton.setTitle(feedProgram.feddProgramNam!, for: .normal)
            }
            else{
                let navigateToController = self.storyboard?.instantiateViewController(withIdentifier: "feed") as? FeedProgramViewController
                navigateToController!.postingIdFromExisting = postingId as! Int
                navigateToController!.FeedIdFromExisting = feedProgram.feedId as! Int
                navigateToController!.finializeCount = finilizeValue
                navigateToController?.postingIdFromExistingNavigate = "Exting"
                self.navigationController?.pushViewController(navigateToController!, animated: false)
                lblFeedProgram.text = feedProgram.feddProgramNam
            }
            self.buttonPreddDroper()
        }
        else {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "capture") as? CaptureNecropsyDataViewController
            mapViewControllerObj?.editFinalizeValue = editFinalizeValue as! Int
            let necIdFromExist =  (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "necropsyId") as? Int
            mapViewControllerObj?.postingIdFromExisting = necIdFromExist!
            mapViewControllerObj?.nsIndexPathFromExist = indexPath.row
            mapViewControllerObj?.postingIdFromExistingNavigate = "Exting"
            mapViewControllerObj!.finalizeValue = finilizeValue as! Int
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
    }
    
    // MARK: 🟠 - Feed Program Button Action
    
    @IBAction func feedProgramBtnAction(_ sender: AnyObject) {
        btnTag = 0
        feedProArrWithId = CoreDataHandler().FetchFeedProgram(postingId).mutableCopy() as! NSMutableArray
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 190, y: 280, width: 300, height: 130)
        droperTableView.reloadData()
    }
    
    // MARK: 🟠 - Finalize Button Action
    @IBAction func finalizeBtnAction(_ sender: AnyObject) {
        Constants.isFromPsoting = true
        UserDefaults.standard.set(true, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        CoreDataHandler().updateFinalizeData(self.postingId, finalize: 1,isSync:true)
        let navigateController = self.storyboard?.instantiateViewController(withIdentifier: "Existing") as? ExistingPostingSessionViewController
        self.navigationController?.pushViewController(navigateController!, animated: false)
        
    }
    
    // MARK: 🟠 - Logout Button Action
    @IBAction func logOutBtnAction(_ sender: AnyObject) {
        clickHelpPopUp()
    }
    
    // MARK: 🟠 - Notes Button Action
    @IBAction func notesBttnAction(_ sender: AnyObject) {
        
        let notesDict = NSMutableArray()
        notesBGbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        notesBGbtn.backgroundColor = UIColor.black
        notesBGbtn.alpha = 0.6
        notesBGbtn.setTitle("", for: UIControl.State())
        notesBGbtn.addTarget(self, action: #selector(notesButtonAcn), for: .touchUpInside)
        self.view.addSubview(notesBGbtn)
        
        notesView = notes.loadFromNibNamed("Notes") as! notes
        notesView.strExist = "Exting"
        notesView.noteDelegate = self
        notesView.noOfBird = sender.tag + 1
        notesView.notesDict = notesDict
        notesView.finalizeValue = finilizeValue as! Int
        notesView.center = self.view.center
        self.view.addSubview(notesView)
        
    }
    
    // MARK: 🟠 - Sync Button Action
    @IBAction func datOneSetSync(_ sender: Any) {
        
        if self.allSessionArrWithPostingId(PId: postingId).count > 0 {
            if WebClass.sharedInstance.connected()  == true{
                
                lngId = UserDefaults.standard.integer(forKey: "lngId")
                var strMsg = String()
                if lngId == 5 {
                    strMsg = "Sincronización de datos ..."
                }
                else if lngId == 1{
                    strMsg = "Data syncing..."
                } else if lngId == 3{
                    strMsg = "Synchronisation des données ..."
                }
                else if lngId == 4{
                    strMsg = "Sincronização de dados ..."
                }
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(strMsg, comment: ""))
                //  Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(strMsg, comment: ""))
                
                self.callSyncApiPostingId(Pid: postingId)
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
            }
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    // MARK: 🟠 - Sync to device Button Action
    @IBAction func reciveButton(_ sender: Any) {
        
        let postingSess = CoreDataHandler().checkPostingSessionHasiSyncTrue(self.postingId, isSync: true)
        let necropcySess = CoreDataHandler().checkNecropcySessionHasiSyncTrue(self.postingId, isSync: true)
        
        if (postingSess == true || necropcySess == true) {
            let alertController = UIAlertController(title: NSLocalizedString("Sync to device", comment: ""), message:NSLocalizedString("By clicking this button, your session data on the web will be downloaded to your device and override any session data captured on your device. Are you sure you want to perform this action?", comment: "") , preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.pullFromWeb()
                return
            }
            let CancelAction = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: UIAlertAction.Style.default)
            alertController.addAction(CancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            
            let alertController = UIAlertController(title: NSLocalizedString("Sync to device", comment: ""), message:NSLocalizedString("The most updated information related to this posting session will be downloaded from web to your device. Are you sure you want to perform this action?", comment: "") , preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.pullFromWeb()
                return
            }
            let CancelAction = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: UIAlertAction.Style.default)
            alertController.addAction(CancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    // MARK: 🟠 - Back Button Action
    @IBAction func bckBttnAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 🟠 - Click Image
    
    @objc func clickImage(_ sender: UIButton) {
        
        let formname = (farmArray.object(at: sender.tag) as AnyObject).value(forKey: "farmName") as? String
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "image") as? ImageViewController
        mapViewControllerObj!.farmname = formname!
        mapViewControllerObj!.necId = ((farmArray.object(at: sender.tag) as AnyObject).value(forKey: "necropsyId") as? Int)!
        mapViewControllerObj!.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
    
    // MARK: 🟠 Notes Button Actipn
    @objc func notesButtonAcn(_ sender: UIButton!) {
        
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    // MARK: 🟠 Remove Custome Notes View
    func openNoteFunc(){
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    
    func doneBtnFunc(_ notes : NSMutableArray , notesText : String , noOfBird : Int) {
        appDelegateObj.testFuntion()
    }
    
    // MARK: 🟠 - Save Necropsy Notes Function on Database
    func  postingNotesdoneBtnFunc(_ notesText : String) {
        
        CoreDataHandler().updateFinalizeDataWithNecNotes(postingId, notes: notesText)
        postingArrWithId = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        let posting : PostingSession = postingArrWithId.object(at: 0) as! PostingSession
        notesBtnnOutlet.setTitle(posting.notes, for: UIControl.State())
        UserDefaults.standard.set( posting.notes, forKey: "postingSessionNotes")
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
        self.printSyncLblCount()
        
    }
    // MARK: 🟠 - Get All Session Array
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    // MARK: 🟠 - Get Session with Posting ID Function
    func allSessionArrWithPostingId(PId:NSNumber) ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSession(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandler().FetchNecropsystep1NecId(postingId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    // MARK: 🟠 - Sync Button Action
    @IBAction func syncAction(_ sender: AnyObject) {
        
        if self.allSessionArr().count > 0
        {
            if WebClass.sharedInstance.connected()  == true{
                
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                self.callSyncApi()
            }
            else
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
            }
        }
        
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
        
    }
    
    // MARK: 🟠 Fatal Error With Status Code
    func failWithError(statusCode:Int)
    {
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
                
            } else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
                
            } else if lngId == 4 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Há problemas na sincronização de dados, tente novamente. \n(\(statusCode))")
            }
        }
    }
    // MARK: 🟠 - Fatal Internal Error
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr: NSLocalizedString("Server error please try again .", comment: ""))
    }
    // MARK: 🟠 - Did Finish API
    func didFinishApi()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
        self.printSyncLblCount()
    }
    // MARK: 🟠 - Fail With Internet Connection
    func failWithInternetConnection()
    {
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    // MARK: 🟠 - get Sync Count
    func printSyncLblCount()
    {
        synCount.text = String(self.allSessionArr().count)
    }
    
    @IBAction func updateDateButtonClicked(_ sender: UIButton) {
        print(appDelegateObj.testFuntion())
    }
    
    // MARK: 🟠 - Session Date Done Button Action
    func doneClick() {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat=Constants.MMddyyyyStr
        let strdate = dateFormatter2.string(from: datePicker.date) as String
        sessionDate.text = strdate
        self.buttonbgNew.removeFromSuperview()
    }
    // MARK: 🟠 - Cancel Button action
    func cancelClick() {
        self.buttonbgNew.removeFromSuperview()
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
    
    @objc func buttonPressedAgeList() {
        self.buttonbgNew2.removeFromSuperview()
    }
    
    // MARK: 🟠 - Farm Table Update Action
    @IBAction func editFarmNameTable(_ sender: UIButton) {
        showUpdateView(sender: sender.tag)
    }
    
    // MARK: 🟠 - Update Age
    @objc func updateAge(){
        showAgesList()
        
    }
    // MARK: 🟠 -Show Custome Update View
    func showUpdateView(sender: Int){
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
        houseLabel.text = NSLocalizedString("House No. * : ", comment: "")
        
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
        
        strfarmName = ((farmArray.object(at: sender) as AnyObject).value(forKey: "farmName") as? String)!
        strHouseNumber = ((farmArray.object(at: sender) as AnyObject).value(forKey: "houseNo") as? String)!
        strFeedId = ((farmArray.object(at: sender) as AnyObject).value(forKey: "feedId") as? Int)!
        houseNoTxtFld.text = strHouseNumber
        
        strFarmNameFeedId = ((farmArray.object(at: sender) as AnyObject).value(forKey: "feedProgram") as? String)!
        strFeddUpdate = ((farmArray.object(at: sender) as AnyObject).value(forKey: "feedProgram") as? String)!
        feedButton.setTitle((farmArray.object(at: sender) as AnyObject).value(forKey: "feedProgram") as? String, for: .normal)
        strfarmNameArray = strfarmName.components(separatedBy: ". ") as NSArray
        let farmName = strfarmNameArray[1]
        
        nameText.text = farmName as? String
        nameText.layer.cornerRadius = 5.0
        nameText.layer.borderWidth = 1
        nameText.returnKeyType = UIReturnKeyType.done
        
        targetWeight.text = UserDefaults.standard.value(forKey: "targetWeight") as? String
        targetWeight.layer.cornerRadius = 5.0
        targetWeight.layer.borderWidth = 1
        targetWeight.returnKeyType = UIReturnKeyType.done
        
        houseNoTxtFld.layer.cornerRadius = 5.0
        houseNoTxtFld.layer.borderWidth = 1
        houseNoTxtFld.returnKeyType = UIReturnKeyType.done
        
        houseNoTxtFld.layer.borderColor =  UIColor.gray.cgColor
        houseNoTxtFld.delegate = self
        houseNoTxtFld.leftView = paddingViewHouse
        houseNoTxtFld.leftViewMode = UITextField.ViewMode.always
        houseNoTxtFld.tag = 40
        
        oldFarmName = strfarmName as NSString
        ageButton.layer.borderColor =  UIColor.gray.cgColor
        ageButton.layer.cornerRadius = 5.0
        ageButton.layer.borderWidth = 1
        ageButton.setTitleColor(UIColor.black, for: .normal)
        ageButton.contentVerticalAlignment = .center
        ageButton.titleEdgeInsets = UIEdgeInsets.init(top: 5.0, left: 10.0, bottom: 0.0, right: 0.0)
        ageButton.setTitle("\(((farmArray.object(at: sender) as AnyObject).value(forKey: "age") as? String)!)", for: .normal)
        ageButton.addTarget(self, action: #selector( PostingSessionDetailController.updateAge), for: .touchUpInside)
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
        feedButton.addTarget(self, action: #selector( PostingSessionDetailController.feedPressed), for: .touchUpInside)
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
        submitButton.addTarget(self, action: #selector( PostingSessionDetailController.updatePressed), for: .touchUpInside)
        
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.tintColor = UIColor.white
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel!.font =  UIFont(name: "Arial", size: 20)
        cancelButton.setTitleColor(UIColor(red: 0/255, green:122/255, blue:228/255, alpha:1.0), for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector( PostingSessionDetailController.buttonPressed), for: .touchUpInside)
        
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
    // MARK: 🟠 - Show Age List
    func showAgesList(){
        
        self.myPickerView.frame = CGRect(x:420,y: 363,width: 100,height: 120)
        pickerView()
        let lblAge = ageButton.titleLabel?.text
        if(lblAge == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else {
            let lblAge = ageButton.titleLabel?.text
            var pickerIndex = Int()
            for i in 0..<AgeOp.count{
                if (lblAge == AgeOp[i] ){
                    pickerIndex = i
                    break
                }
            }
            myPickerView.selectRow(pickerIndex, inComponent: 0, animated: true)
            
        }
        myPickerView.reloadInputViews()
    }
    // MARK: 🟠 - Feed Pressed
    @objc func feedPressed(){
        btnTag = 1
        feedProArrWithId = CoreDataHandler().FetchFeedProgram(postingId).mutableCopy() as! NSMutableArray
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 441, y: 455, width: 250, height: 90)
        droperTableView.reloadData()
    }
    // MARK: 🟠 Side Menu Button Action
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out" {
            
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected() == true {
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
            buttonbgNew2.removeFromSuperview()
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
    // MARK: 🟠 Custome Popup
    func clickHelpPopUp() {
        
        bttnbckround.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        bttnbckround.addTarget(self, action: #selector(PostingViewController.buttonPressed11), for: .touchUpInside)
        bttnbckround.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(bttnbckround)
        
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as? UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.bttnbckround .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200, y: 60, width: 150, height: 60))
    }
    // MARK: 🟠 Dismiss Custome Popup
    func buttonPressed11() {
        customPopView1.removeView(view)
        bttnbckround.removeFromSuperview()
    }
    // MARK: 🟠  Create Dropdown popUp
    func tableViewpop(){
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg1.addTarget(self, action:#selector(PostingSessionDetailController.buttonPreddDroper), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view.addSubview(buttonbg1)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.lightGray.cgColor
        buttonbg1.addSubview(droperTableView)
        
    }
    
    @objc func buttonPreddDroper() {
        
        buttonbg1.removeFromSuperview()
    }
    
    // MARK: 🟠 Delete Farm Button Action
    fileprivate func deleteNotesImagesNecropsyWithFarmName(necId: NSNumber , farmsName: String) {
        CoreDataHandler().deleteDataWithPostingIdStep2dataCaptureNecViewWithfarmName(necId as NSNumber, farmName: farmsName, { (success) in
            if success == true {
                
                CoreDataHandler().deleteDataWithPostingIdStep2NotesBirdWithFarmName(necId as NSNumber, farmName: farmsName, { (success) in
                    if success == true {
                        
                        deleteDataAndHandleSuccess(necId: necId, farmsName: farmsName)
                    }
                })
            }})
    }
    
    private func deleteDataAndHandleSuccess(necId: NSNumber, farmsName: String) {
        CoreDataHandler().deleteDataWithPostingIdStep2CameraIamgeWithFarmName(necId, farmName: farmsName) { success in
            handleDeleteSuccess(success: success)
        }
    }
    
    
    func handleDeleteSuccess(success: Bool) {
        if success == true {
            self.fetcFarmData()
            self.appDelegate.saveContext()
            self.feedProtableView.reloadData()
        }
    }
    
    @objc func ClickDeleteBtton(_ sender: UIButton){
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        let cell =  self.feedProtableView.cellForRow(at: indexpath as IndexPath) as? PostingSessionDetailTableViewCell
        cell?.backgroundColor = UIColor.gray
        if farmArray.count == 1{
            
            let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString("You can not delete all farms. One farm is mandatory for this session.", comment: ""), preferredStyle: .alert)
            let action1 = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
                cell?.backgroundColor = UIColor.clear
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let farmArrayWithoutAge = (farmArray.object(at: sender.tag) as AnyObject).value(forKey: "farmName") as? String
            let necroId = ((farmArray.object(at: sender.tag) as AnyObject).value(forKey: "necropsyId") as? Int)!
            
            let dataArr = CoreDataHandler().fecthFrmWithCatnameWithBirdAndObservationWithDelete(farmname: farmArrayWithoutAge!, necId: necroId as NSNumber)
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
            else {
                strMsgforDelete = NSLocalizedString("Are you sure you want to delete this farm?", comment: "")
            }
            
            let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString(strMsgforDelete, comment: ""), preferredStyle: .alert)
            let action1 = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (action) in
                
                CoreDataHandler().deleteDataWithPostingIdStep1dataWithfarmName(necroId as NSNumber, farmName: farmArrayWithoutAge!, { (success) in
                    if success == true{
                        self.deleteNotesImagesNecropsyWithFarmName(necId: necroId as NSNumber, farmsName: farmArrayWithoutAge!)
                    }
                })
            }
            
            let action2 = UIAlertAction(title: NSLocalizedString(Constants.noStr, comment: ""), style: .cancel) { (action) in
                
                cell?.backgroundColor = UIColor.clear
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: 🟠 - PICKER VIEW METHOD & DELEGATES
    func pickerView (){
        buttonbgNew2.frame = CGRect(x:0,y: 0,width: 1024,height: 768) // X, Y, width, height
        buttonbgNew2.addTarget(self, action: #selector(PostingSessionDetailController.buttonPressedAgeList), for: .touchUpInside)
        buttonbgNew2.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view.addSubview(buttonbgNew2)
        myPickerView.layer.borderWidth = 1
        myPickerView.layer.cornerRadius = 5
        myPickerView.layer.borderColor = UIColor.clear.cgColor
        myPickerView.dataSource = self
        myPickerView.delegate = self
        myPickerView.backgroundColor = UIColor.white
        buttonbgNew2.addSubview(myPickerView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let value = AgeOp.count as? Int {
            return value
        } else {
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let value = AgeOp[row] as? String {
            return value
        } else {
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if let value = AgeOp[row] as? String {
            return ageButton.setTitle("\(value)", for: .normal)
        } else {
            return  ageButton.setTitle("\0)", for: .normal)
        }
        
        myPickerView.endEditing(true)
        buttonbgNew2.removeFromSuperview()
    }
    
    // MARK: 🟠 Update Farm Details
    @objc func updatePressed(){
        
        Constants.isFromPsoting = true
        UserDefaults.standard.set(true, forKey: "postingSession")
        UserDefaults.standard.synchronize()
        var trimmedString = nameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        
        if houseNoTxtFld.text == ""
        {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
            houseNoTxtFld.layer.borderColor = UIColor.red.cgColor
            return
        }
        if strFeddCheck == "" && strFeddUpdate == "" && trimmedString == ""
        {
            feedButton.layer.borderColor = UIColor.red.cgColor
            nameText.layer.borderColor = UIColor.red.cgColor
        }
        if strFarmNameFeedId == "" && strFeddUpdate == "" {
            
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
            
        }
        if strFeddCheck == "" && strFeddUpdate == "" && strFarmNameFeedId == ""
        {
            if trimmedString == "" {
                nameText.layer.borderColor = UIColor.red.cgColor
            }else {
                nameText.layer.borderColor = UIColor.black.cgColor
            }
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
        }
        else
        {
            if trimmedString == "" {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.mandatoryFieldsMessage, comment: ""))
                nameText.layer.borderColor = UIColor.red.cgColor
                feedButton.layer.borderColor = UIColor.black.cgColor
            }
            else{
                let str = strfarmNameArray[0] as! String
                let strNewFarm = str+". "+trimmedString
                if strFeddUpdate == ""{
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId, feedname: strFeddCheck, feedId: feedIdUpdate , formName: strfarmName)
                }
                else if strFarmNameFeedId == ""{
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId, feedname: strFeddUpdate, feedId: feedIdUpdate , formName: strfarmName)
                }
                else {
                    CoreDataHandler().updateFeddProgramInStep1UsingFarmName(self.postingId, feedname: strFeddUpdate, feedId: feedIdUpdate , formName: strfarmName)
                }
                
                CoreDataHandler().updateNecropsystep1WithNecIdAndFarmName(postingId, farmName: oldFarmName as NSString, newFarmName: strNewFarm as NSString  , age: (ageButton.titleLabel?.text!)!, newHouseNo: houseNoTxtFld.text! as NSString , isSync: true)
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewData(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdNotes(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
                CoreDataHandler().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdPhoto(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm)
                CoreDataHandler().updateisSyncTrueOnPostingSession(postingId as NSNumber)
                self.feedProtableView.reloadData()
                self.fetcFarmData()
                self.printSyncLblCount()
                self.buttonbgNew2.removeFromSuperview()
                self.buttonEdit.removeFromSuperview()
            }
        }
    }
    // MARK: 🟠 Api Sync fails Delegates
    func failWithErrorSyncdata(statusCode:Int){
        
        Helper.dismissGlobalHUD(self.view)
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            }
            else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
            else if lngId == 4 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Há problemas na sincronização de dados, tente novamente. \n(\(statusCode))")
            }
        }
    }
    func failWithErrorInternalSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Server error please try again .", comment: "") )
    }
    func didFinishApiSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
        self.printSyncLblCount()
    }
    func failWithInternetConnectionSyncdata(){
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
        
    }
    // MARK: 🟠 Date Formatter
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let convertedtimeStamp = dateFormatter.string(from: date)
        return convertedtimeStamp
    }
    
    // MARK: 🟢 Sync to device Button action
    fileprivate func savingPostedSessionForSpecificID(_ self: PostingSessionDetailController , json:JSON) {
        if let jsonDict = JSON(json).dictionary,
           let errorMessage = jsonDict["Message"]?.string {
            print("Error responce from  PostingSessionListBySessionId?DeviceSessionId API is \(errorMessage)")
            //  self.showToastWithTimer(message: errorMessage, duration: 3.0)
            return
        }
        
        if let arr = JSON(json).array, !arr.isEmpty {
            for item in arr {
                if let posDict = item.dictionaryObject as NSDictionary? {
                    CoreDataHandler().getPostingDatWithSpecificId(posDict, postinngId: self.postingId)
                } else {
                    print("Invalid dictionary format in array: \(item)")
                }
            }
            
            UserDefaults.standard.set("Yes", forKey: "Success")
            
            let postingData = CoreDataHandler().fetchAllPostingSession(self.postingId)
            
            // Call next function if data exists
            if postingData.count>0 {
                self.getPostingDataFromServerforVaccination()
            }
        }
        else
        {
            Helper.dismissGlobalHUD(self.view)
            self.showAlert(title: Constants.alertStr, message: "Unable to get updated data from server.", owner: self)
            
        }
    }
    
    fileprivate func handleGetPostedSessionByDeviceIDResponse(_ error: NSError?, _ json: JSON) {
        if let error = error {
            print("Error fetching data: \(error.localizedDescription)")
            return
        }
        let jsonResponse = JSON(json)
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
            
            print("Error responce from  PostingSessionListBySessionId?DeviceSessionId API is ------ : \(errorMsg) (Code: \(errorCode))")
            if errorCode == "404"{
                UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                self.getPostingDataFromServerforVaccination()
            }
        }
    }
    
    func pullFromWeb() {
        fullData =  deviceTokenId
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        
        if WebClass.sharedInstance.connected() {
            Helper.dismissGlobalHUD(self.view)
            
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            if  lngId == 1 {
                _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: "Fetching data from server...")
            } else if lngId == 4 {
                _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: "Buscar dados do servidor ...")
            } else {
                _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: "Récupération des données du serveur ...")
            }
            
            let apiUrl = ZoetisWebServices.EndPoint.getPostedSessionsByDeviceSessionID.latestUrl + "\(fullData)"
            guard let sessionDetailsUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            
            ZoetisWebServices.shared.getPostedSessionByDeviceIDResponce(controller: self, url: sessionDetailsUrl, completion: { [weak self] (json, error) in
                self?.handleGetPostedSessionByDeviceIDResponse(error, json)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    savingPostedSessionForSpecificID(self , json: json)
                }
            })
        } else {
            self.failWithInternetConnection()
        }
    }
    // MARK: 🟢 Fetch Posted Session details from Server for vaccination
    fileprivate func handleVaccinationPostingResponse(_ arr: [JSON], _ self: PostingSessionDetailController) {
        for item in arr {
            if let vac = item.dictionaryObject?["Vaccination"] as? NSArray, vac.count > 0,
               let posDict = vac.firstObject as? NSDictionary {
                
                CoreDataHandler().getHatcheryDataFromServerSingleFromDeviceId(posDict, postingId: self.postingId)
                CoreDataHandler().getFieldDataFromServerSingledata(posDict, postingId: self.postingId)
            }
        }
    }
    
    fileprivate func handleVaccinationListAPIResponse(_ json:JSON) {
        if let arr = JSON(json).array, !arr.isEmpty {
            
            UserDefaults.standard.set("Yes", forKey: "Success")
            
            CoreDataHandler().deleteDataWithPostingIdHatchery(self.postingId)
            CoreDataHandler().deleteDataWithPostingIdFieldVacinationWithSingle(self.postingId)
            
            self.handleVaccinationPostingResponse(arr, self)
            
            self.getPostingDataFromServerforFeed()
        } else {
            self.getPostingDataFromServerforFeed()
        }
    }
    
    fileprivate func handleGetVaccineDeviceID(_ jsonResponse: JSON) {
        // Check for the "errorResult" key and handle errors
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
            
            print("Error from PostingSession/GetVaccinationListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
            
            if statusCode == "500 " || statusCode == "401" || statusCode == "503" ||  statusCode == "403" ||  statusCode=="501" || statusCode == "502" || statusCode == "400" || statusCode == "504" || statusCode == "404" || statusCode == "408"{
                UserDefaults.standard.set(Constants.noStr, forKey: "Success")
            }
        }
    }
    
    func getPostingDataFromServerforVaccination(){
        
        if WebClass.sharedInstance.connected() {
            
            let apiUrl = ZoetisWebServices.EndPoint.getPostedVaccinationListByDeviceSessionID.latestUrl + "\(fullData)"
            guard let vaccinationDetailsUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            ZoetisWebServices.shared.getVaccineListByDeviceIDResponce(controller: self, url: vaccinationDetailsUrl, completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                self?.handleGetVaccineDeviceID(jsonResponse)
                
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    if let jsonDict = JSON(json).dictionary,
                       let errorMessage = jsonDict["Message"]?.string {
                        print("Error responce from  PostingSession/GetVaccinationListBySessionId?DeviceSessionId API is \(errorMessage)")
                        //  self.showToastWithTimer(message: errorMessage, duration: 3.0)
                        return
                    }
                    
                    handleVaccinationListAPIResponse(json)
                }
            })
            
        } else {
            self.failWithInternetConnection()
        }
    }
    // MARK: 🟢 Get Posted Session Details for Feed Program
    
    func getPostingDataFromServerforFeed() {
        guard WebClass.sharedInstance.connected() else {
            failWithInternetConnection()
            return
        }
        
        let apiUrl = ZoetisWebServices.EndPoint.getFeedListByDeviceSessionID.latestUrl + "\(fullData)"
        
        guard let feedDetailsUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            return
        }
        
        ZoetisWebServices.shared.getFeedListByDeviceIDResponce(controller: self, url: feedDetailsUrl) { [weak self] json, error in
            guard let self = self else { return }
            
            if let apiError = error {
                print("Error occurred: \(apiError)")
                self.dismissGlobalHUD(self.view)
                return
            }
            
            let jsonResponse = JSON(json)
            if self.handleAPIErrorIfPresent(jsonResponse) {
                return
            }
            
            DispatchQueue.main.async {
                self.processFeedData(jsonResponse)
            }
        }
    }
    private func handleAPIErrorIfPresent(_ jsonResponse: JSON) -> Bool {
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
            print("Error from API: \(errorMsg) (Code: \(statusCode))")
            
            if ["500", "401", "503", "403", "501", "502", "400", "504", "404", "408"].contains(statusCode.trimmingCharacters(in: .whitespaces)) {
                UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                getCNecStep1Data()
                return true
            }
        }
        
        if let jsonDict = jsonResponse.dictionary, let errorMessage = jsonDict["Message"]?.string {
            print("Error response message: \(errorMessage)")
            return true
        }
        
        return false
    }
    private func processFeedData(_ jsonResponse: JSON) {
        guard let arr = jsonResponse.array, !arr.isEmpty else {
            getCNecStep1Data()
            return
        }
        
        UserDefaults.standard.set("Yes", forKey: "Success")
        let coreDataHandler = CoreDataHandler()
        clearPreviousFeedData(coreDataHandler)
        
        for session in arr {
            guard let sessionId = session["sessionId"].int,
                  let feedArr = session["Feeds"].array else {
                continue
            }
            
            for feed in feedArr {
                guard let feedId = feed["feedId"].int,
                      let feedName = feed["feedName"].string,
                      let feedDate = feed["startDate"].string,
                      let feedDetailsArr = feed["feedCategoryDetails"].array else {
                    continue
                }
                
                if feedId > UserDefaults.standard.integer(forKey: "feedId") {
                    UserDefaults.standard.set(feedId, forKey: "feedId")
                }
                
                coreDataHandler.getFeedNameFromGetApiSingleDeviceToken(
                    sessionId as NSNumber, sessionId: sessionId as NSNumber,
                    feedProgrameName: feedName, feedId: feedId as NSNumber,
                    postingIdFeed: postingId
                )
                
                processFeedCategories(feedDetailsArr, sessionId: sessionId, feedId: feedId, feedName: feedName, feedDate: feedDate, handler: coreDataHandler)
            }
        }
        
        getCNecStep1Data()
    }
    private func processFeedCategories(
        _ categories: [JSON],
        sessionId: Int,
        feedId: Int,
        feedName: String,
        feedDate: String,
        handler: CoreDataHandler
    ) {
        for category in categories {
            guard let categoryName = category["feedProgramCategory"].string,
                  let details = category["feedDetails"].array else {
                continue
            }
            
            for detail in details {
                guard let dict = detail.dictionaryObject as NSDictionary? else { continue }
                
                switch categoryName {
                case Constants.coccidioStr:
                    handler.getDataFromCocoiiControllForSingleData(
                        dict, feedId: feedId as NSNumber, postingId: sessionId as NSNumber,
                        feedProgramName: feedName, postingIdCocoii: postingId, feedDate: feedDate
                    )
                case "Alternatives":
                    handler.getDataFromAlterNativeForSingleDevToken(
                        dict, feedId: feedId as NSNumber, postingId: sessionId as NSNumber,
                        feedProgramName: feedName, postingAlterNative: postingId, feedDate: feedDate
                    )
                case "Antibiotic":
                    handler.getDataFromAntiboiticWithSigleData(
                        dict, feedId: feedId as NSNumber, postingId: sessionId as NSNumber,
                        feedProgramName: feedName, postingIdAlterNative: postingId, feedDate: feedDate
                    )
                case Constants.mytoxinStr:
                    handler.getDataFromMyCocotinBinderWithSingleData(
                        dict, feedId: feedId as NSNumber, postingId: sessionId as NSNumber,
                        feedProgramName: feedName, postingidMycotxin: postingId, feedDate: feedDate
                    )
                default:
                    print("Unknown category: \(categoryName)")
                }
            }
        }
    }
    private func clearPreviousFeedData(_ handler: CoreDataHandler) {
        handler.deleteDataWithPostingIdFeddProgram(postingId)
        handler.deleteDataWithPostingIdFeddProgramCocoiiSinle(postingId)
        handler.deleteDataWithPostingIdFeddProgramAlternativeSinle(postingId)
        handler.deleteDataWithPostingIdFeddProgramAntiboiticSingle(postingId)
        handler.deleteDataWithPostingIdFeddProgramMyCotoxinSingle(postingId)
    }
    
    
    
    fileprivate func handleAPIErrorResponseGetFarmList(_ jsonResponse: JSON) {
        // Check for the "errorResult" key and handle errors
        if let errorResult = jsonResponse["errorResult"].dictionary {
            let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
            let statusCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
            
            print("Error from PostingSession/getFarmListDataByDeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
            
            switch statusCode {
            case "500 ", "401", "503", "403", "501", "502", "400", "504", "404", "408":
                UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                self.getCNecStep1Data()
            default:
                break
            }
        }
    }
    
    
    // MARK: 🟢 Get Farm list for  posted Session Detail
    func getCNecStep1Data(){
        if WebClass.sharedInstance.connected() {
            
            let keychainHelper = AccessTokenHelper()
            accestoken = keychainHelper.getFromKeychain(keyed: "aceesTokentype") ?? ""
            let headerDict: HTTPHeaders = ["Authorization":accestoken]
            let url = "PostingSession/GetFarmListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            
            guard let necropsyDetailsUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            
            sessionManager.request(necropsyDetailsUrl, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    UserDefaults.standard.set("No", forKey: "Success")
                    self.getPostingDataFromServerforNecorpsy()
                }
                
                switch response.result{
                case let .success(value):
                    
                    if value is NSArray{
                        let arr : NSArray = value as! NSArray
                        
                        UserDefaults.standard.set("Yes", forKey: "Success")
                        if arr.count>0{
                            CoreDataHandler().deleteDataWithPostingIdCaptureStepData(self.postingId)
                            for  i in 0..<arr.count {
                                var posttingId =  Int ()
                                let sessionId = (arr.object(at: i) as AnyObject).value(forKey: "SessionId") as! Int
                                let devSessionId = (arr.object(at: i) as AnyObject).value(forKey: "deviceSessionId") as! String
                                let custId = (arr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! Int
                                let complexId = (arr.object(at: i) as AnyObject).value(forKey: "ComplexId") as! Int
                                let complexName = (arr.object(at: i) as AnyObject).value(forKey: "ComplexName") as! String
                                let sessionDate = (arr.object(at: i) as AnyObject).value(forKey: "SessionDate") as! String
                                let seesDat = self.convertDateFormater(sessionDate)
                                let farmArr = (arr.object(at:i) as AnyObject).value(forKey:  "Farms")
                                if (farmArr as AnyObject).count>0{
                                    for  j in 0..<(farmArr! as AnyObject).count {
                                        let farmName =  ((farmArr as AnyObject).object(at:j) as AnyObject).value(forKey:"farmName") as! String
                                        let  postingArr  =  CoreDataHandler().fetchAllPostingSession(sessionId as NSNumber)
                                        if postingArr.count>0{
                                            posttingId = (postingArr.object(at: 0) as AnyObject).value(forKey:"postingId") as! Int
                                            if posttingId == sessionId{
                                                CoreDataHandler().updateFinalizeDataWithNec(self.postingId, finalizeNec: 1)
                                                posttingId = sessionId
                                            }
                                        }
                                        else{
                                            posttingId = 0
                                        }
                                        let age =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"age")
                                        let birds = "\(((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey: "birds") ?? "")"
                                        let houseNo =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"houseNo")
                                        let flockId =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"flockId")
                                        let feedProgram =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"feedProgram") as! String
                                        let sick =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"sick") as! Bool
                                        let feedId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "FeedId") as! Int
                                        let farmId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "DeviceFarmId") as! Int
                                        let imgId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "ImgId") as! Int
                                        
                                        
                                        let data = chickenCoreDataHandlerModels.SaveNecropsystep1SingleNecropsyData(
                                            postingId: posttingId as NSNumber,
                                            age: ((age as AnyObject).stringValue)!,
                                            farmName: farmName,
                                            feedProgram: feedProgram,
                                            flockId: flockId as! String,
                                            houseNo: houseNo as! String,
                                            noOfBirds: birds ,
                                            sick: 0,
                                            necId: sessionId as NSNumber,
                                            compexName: complexName,
                                            complexDate: seesDat,
                                            complexId: complexId as NSNumber,
                                            custmerId: custId as NSNumber,
                                            feedId: feedId as NSNumber,
                                            isSync: false,
                                            timeStamp: devSessionId,
                                            actualTimeStamp: devSessionId,
                                            necIdSingle: self.postingId,
                                            farmId: farmId as NSNumber,
                                            imgId: imgId as NSNumber
                                        )
                                        
                                        CoreDataHandler().SaveNecropsystep1SingleData(data: data)
                                        
                                        UserDefaults.standard.set(farmId as NSNumber, forKey: "farmId")
                                    }
                                }
                            }
                            let necArr = CoreDataHandler().FetchNecropsystep1AllNecId()
                            if necArr.count>0{
                                self.getPostingDataFromServerforNecorpsy()
                            }
                        }
                        else {
                            self.getPostingDataFromServerforNecorpsy()
                        }
                    }
                    else {
                    }
                    break
                case .failure(let encodingError):
                    
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        debugPrint(err)
                    } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        debugPrint (encodingError)
                        debugPrint (responseString)
                        
                    }
                }
            }
        }
        else {
        }
    }
    
    
    // MARK: 🟢 Get Necropsy Details for posted Session details.
    fileprivate func handleForLoopPostingDataServerNecropsyValidations(_ observations: [NSDictionary], _ catStr: String, _ farmName: String, _ sessionId: Int) {
        for observation in observations {
            guard let obsId = observation["ObservationId"] as? Int,
                  let refId = observation["ReferenceId"] as? NSNumber,
                  let languageId = observation["LanguageId"] as? NSNumber,
                  let obsName = observation["Observations"] as? String,
                  let measure = observation["Measure"] as? String,
                  let quickLink = observation["DefaultQLink"],
                  let birdsArray = observation["Birds"] as? [NSDictionary],
                  let birdData = birdsArray.first else { continue }
            
            processBirds(
                birdData: birdData,
                catStr: catStr,
                obsName: obsName,
                farmName: farmName,
                obsId: obsId,
                measure: measure,
                dataVar: GITractModelDataVars(quickLink: quickLink, sessionId: sessionId, languageId: languageId, refId: refId)
            )
        }
    }
    
    fileprivate func handleForLoopGetPostingDataFromServerNecropsy(_ arr: NSArray) {
        for i in 0..<arr.count {
            guard let sessionData = arr[i] as? NSDictionary,
                  let sessionId = sessionData["SessionId"] as? Int,
                  let farms = sessionData["Farms"] as? [NSDictionary] else { continue }
            
            for farm in farms {
                guard let farmName = farm["FarmName"] as? String,
                      let categories = farm["Category"] as? [NSDictionary] else { continue }
                
                for category in categories {
                    guard let catNameRaw = category["Category"] as? String,
                          let observations = category["Observations"] as? [NSDictionary] else { continue }
                    
                    let catStr = categoryMapping(for: catNameRaw)
                    handleForLoopPostingDataServerNecropsyValidations(observations, catStr, farmName, sessionId)
                }
            }
        }
    }
    
    private func processBirds(
        birdData: NSDictionary,
        catStr: String,
        obsName: String,
        farmName: String,
        obsId: Int,
        measure: String,
        dataVar: GITractModelDataVars
    ) {
        for m in 0..<10 {
            let key = "BirdNumber\(m + 1)"
            guard let birdText = birdData[key] as? String, birdText != "NA" else { break }
            
            let visibility = ((birdData[key] as AnyObject).boolValue)!
            let obsPoint = ((birdData[key] as AnyObject).integerValue)!
            
            let data = chickenCoreDataHandlerModels.updateSkeletaSingleSyncSkeletaData(
                catName: catStr,
                obsName: obsName,
                formName: farmName,
                obsVisibility: visibility,
                birdNo: NSNumber(value: m + 1),
                obsPoint: obsPoint,
                index: m,
                obsId: obsId,
                measure: measure,
                quickLink: ((dataVar.quickLink as AnyObject).integerValue ?? 0) as NSNumber,
                necId: NSNumber(value: dataVar.sessionId),
                isSync: false,
                necIdSingle: self.postingId,
                lngId: dataVar.languageId,
                refId: dataVar.refId,
                actualText: birdText
            )
            
            CoreDataHandler().saveCaptureSkeletaInDatabaseOnSwithCaseSingleData(data: data)
        }
    }
    
    private func categoryMapping(for raw: String) -> String {
        switch raw {
        case "Coccidiosis": return "Coccidiosis"
        case "GI Tract": return "GITract"
        case "Immune/Others": return "Immune"
        case "Respiratory": return "Resp"
        case "Skeletal/Muscular/Integumentary": return "skeltaMuscular"
        default: return raw
        }
    }
    
    
    fileprivate func handleGetNecropsyAPIResponseMain(_ response: AFDataResponse<Any>) {
        switch response.result {
        case let .success(value):
            
            UserDefaults.standard.set("Yes", forKey: "Success")
            if value is NSArray {
                let arr : NSArray = value as! NSArray
                if arr.count>0 {
                    CoreDataHandler().deleteDataWithStep2data(self.postingId)
                    self.handleForLoopGetPostingDataFromServerNecropsy(arr)
                    self.getNotesFromServer()
                }
            }
            break
        case .failure(let encodingError):
            
            if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                debugPrint(err)
            } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                debugPrint (encodingError)
                debugPrint (responseString)
            }
        }
    }
    
    func getPostingDataFromServerforNecorpsy() {
        
        if WebClass.sharedInstance.connected() {
            
            var id =  UserDefaults.standard.value(forKey: "Id") as! Int
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            let countryId = UserDefaults.standard.integer(forKey: "countryId")
            let url = "PostingSession/GetNecropsyListBySessionId?UserId=\(id)&DeviceSessionId=\(fullData)&LanguageId=\(lngId)&CountryId=\(countryId)"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict: HTTPHeaders = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + url
            
            guard let obsDetailsUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(obsDetailsUrl, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                switch statusCode {
                case 500, 401, 503, 403, 501, 502, 400, 504, 404, 408:
                    UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                    self.getNotesFromServer()
                default:
                    break
                }
                self.handleGetNecropsyAPIResponseMain(response)
            }
        }
    }
    
    // MARK: 🟢  Get Notes details from the server
    fileprivate func saveNotesOfPostedSessionInDB(_ arr: [JSON], _ self: PostingSessionDetailController) {
        for item in arr {
            if let noteArr = item["Note"].array, !noteArr.isEmpty {  // ✅ Convert JSON to an array
                for note in noteArr {
                    if let sessionId = note["sessionId"].int,
                       let farmName = note["farmName"].string,
                       let birdNo = note["birdNumber"].int,
                       let birdNotes = note["Notes"].string {
                        
                        let birdData = chickenCoreDataHandlerModels.BirdNotesData(
                            catName: "",
                            notes: birdNotes,
                            formName: farmName,
                            birdNo: NSNumber(value: birdNo),
                            index: 0,
                            necId: NSNumber(value: sessionId),
                            isSync: false,
                            necIdSingle: self.postingId                        )
                        
                        CoreDataHandler().saveNoofBirdWithNotesSingledata(birdData)
                        
                    }
                }
            }
        }
    }
    
    fileprivate func getBirdsNotesAPIResponseHandler(_ json: JSON) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let jsonDict = JSON(json).dictionary,
               let errorMessage = jsonDict["Message"]?.string {
                print("Error responce from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId API is \(errorMessage)")
                //  self.showToastWithTimer(message: errorMessage, duration: 3.0)
                return
            }
            
            let jsonResponse = JSON(json)
            // Check for the "errorResult" key and handle errors
            if let errorResult = jsonResponse["errorResult"].dictionary {
                let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                let statusCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                
                print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
                
                if statusCode == "500 " || statusCode == "401" || statusCode == "503" ||  statusCode == "403" ||  statusCode=="501" || statusCode == "502" || statusCode == "400" || statusCode == "504" || statusCode == "404" || statusCode == "408"{
                    UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                    self.getPostingDataFromServerforImage()
                }
            }
            
            if let arr = JSON(json).array, !arr.isEmpty {
                CoreDataHandler().deleteDataBirdNotesWithId(self.postingId)
                UserDefaults.standard.set("Yes", forKey: "Success")
                
                saveNotesOfPostedSessionInDB(arr, self)
                
                self.getPostingDataFromServerforImage()
            } else {
                self.getPostingDataFromServerforImage()
            }
            
        }
    }
    
    func getNotesFromServer() {
        if WebClass.sharedInstance.connected() {
            
            let apiUrl = ZoetisWebServices.EndPoint.getBirdsNotesDataByDeviceSessionId.latestUrl + "\(fullData)"
            guard let notesDetailsUrl = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            ZoetisWebServices.shared.getBirdsNotesDataByDeviceIDResponce(controller: self, url: notesDetailsUrl, completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let statusCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    print("Error from PostingSession/GetBirdNotesListBySessionId?DeviceSessionId  API : \(errorMsg) (Code: \(statusCode))")
                    
                    if statusCode == "500 " || statusCode == "401" || statusCode == "503" ||  statusCode == "403" ||  statusCode=="501" || statusCode == "502" || statusCode == "400" || statusCode == "504" || statusCode == "404" || statusCode == "408"{
                        UserDefaults.standard.set(Constants.noStr, forKey: "Success")
                        self!.getCNecStep1Data()
                    }
                }
                self?.getBirdsNotesAPIResponseHandler(json)
            })
        } else {
            self.failWithInternetConnection()
        }
    }
    // MARK: 🟢 Get images list from the Server
    fileprivate func saveBirdsImagesReceivedFromAPIToLocalDatabase(_ imagArr: Any?) {
        if (imagArr as AnyObject).count>0 {
            for  i in 0..<(imagArr! as AnyObject).count {
                let posDict = (imagArr! as AnyObject).object(at: i)
                CoreDataHandler().getSaveImageFromServerSingledata(posDict as! NSDictionary,necIdSingle: self.postingId)
            }
        }
    }
    
    fileprivate func getBirdsImageListAPISuccessResponseHandler(_ value: Any, _ statusCode: Int?) {
        let arr : NSArray = value as! NSArray
        if arr.count>0 {
            CoreDataHandler().deleteImageForSingle(self.postingId)
            
            for i in 0..<arr.count {
                let imagArr = (arr.object(at: i) as AnyObject).value(forKey: "Images")
                saveBirdsImagesReceivedFromAPIToLocalDatabase(imagArr)
            }
            
            self.fetcFarmData()
            self.appDelegate.saveContext()
            self.feedProtableView.reloadData()
            if UserDefaults.standard.string(forKey: "Success") == "YesUpdated" {
                self.alerViewSucees()
            }
            if UserDefaults.standard.string(forKey: "Success") == "Yes" {
                self.alerViewSucees()
            } else {
                self.alerView(statusCode:statusCode!)
            }
            Helper.dismissGlobalHUD(self.view)
        } else {
            if  UserDefaults.standard.string(forKey: "Success") == "Yes" {
                print(appDelegateObj.testFuntion())
            } else {
                self.alerViewServer()
            }
        }
    }
    
    fileprivate func getBirdImagesListStatusCodeHandler(_ statusCode: Int?) {
        if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408 {
            
            if UserDefaults.standard.string(forKey: "Success") == "Yes" {
                self.alerViewSucees()
            } else {
                self.alerView(statusCode:statusCode!)
            }
            Helper.dismissGlobalHUD(self.view)
        }
    }
    
    func getPostingDataFromServerforImage() {
        
        if WebClass.sharedInstance.connected() {
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            //  accestoken = (UserDefaults.standard.value(forKey: Constants.accessToken) as? String)!
            let headerDict: HTTPHeaders = [Constants.authorization:accestoken]
            let url = "PostingSession/GetBirdImagesListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            guard let imagesDetailsUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(imagesDetailsUrl, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                self.getBirdImagesListStatusCodeHandler(statusCode)
                switch response.result {
                case let .success(value):
                    if value is NSArray {
                        self.getBirdsImageListAPISuccessResponseHandler(value, statusCode)
                    } else {
                        self.feedProtableView.reloadData()
                        Helper.dismissGlobalHUD(self.view)
                    }
                    break
                case .failure(let encodingError):
                    
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        debugPrint(err)
                    } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        debugPrint (encodingError)
                        debugPrint (responseString)
                    }
                }
            }
        }
    }
    // MARK: 🟢 - Call Sync API for Feed Program
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    // MARK: 🟢 - Call Sync API for Feed Program with Posting ID
    func callSyncApiPostingId(Pid:NSNumber)
    {
        objApiSyncOneSet.feedprogram(postingId: Pid)
    }
    
    // MARK: 🟠 - All Error Messages Popup's
    func alerViewServer() {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("There is no update available on the server.", comment: ""), preferredStyle: UIAlertController.Style.alert) //Replace
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            Helper.dismissGlobalHUD(self.view)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alerView(statusCode:Int) {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("Unable to get data from server.\n(\(statusCode))", comment: ""), preferredStyle: UIAlertController.Style.alert) //Replace
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            Helper.dismissGlobalHUD(self.view)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alerViewInternet() {
        let alertController = UIAlertController(title: "", message: NSLocalizedString("No internet connection. Please try again!", comment: ""), preferredStyle: UIAlertController.Style.alert) //Replace
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            Helper.dismissGlobalHUD(self.view)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alerViewSucees() {
        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString(Constants.dataSyncCompleted, comment: ""), preferredStyle: UIAlertController.Style.alert) //Replace
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Update Function optional not required
    @objc func update() {
        if WebClass.sharedInstance.connected(){
            print(appDelegateObj.testFuntion())
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
        }
    }
    
    // MARK: 🟠 - TEXTFIELD DELEGATES
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            debugPrint("back added....")
        }
        else if ((textField.text?.count)! > 50  ){
            return false
        }
        
        switch textField.tag {
            
        case 40 :
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
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

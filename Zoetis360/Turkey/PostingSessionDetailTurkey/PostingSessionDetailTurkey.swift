//
//  PostingSessionDetailTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Alamofire
import Reachability
import SystemConfiguration

class PostingSessionDetailTurkey: UIViewController,turkeyNotes,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate ,SyncApiDataTurkey, otherFuncDetailsTurkey {
    
    
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()
    
    var height = false
    var strMsgforDelete = String()
    var strFarmNameFeedId = String()
    let objApiSyncOneSet = SingleSyncDataTurkey()
    var strFeedCheck = String()
    var age:String?
    let bttnbckround = UIButton ()
    var myPickerView = UIPickerView()
    var buttonbgNew  = UIButton()
    var accestoken   = String()
    var deviceTokenId = String()
    var fullData     = String()
    var timer        = Timer()
    var feedTableView  = UITableView ()
    var btnTag       = Int()
    var strfarmName  = String()
    var strFeddUpdate = String()
    var feedIdUpdate = NSNumber()
    var buttonbgNew2 = UIButton()
    let buttonEdit: UIButton = UIButton()
    var camraImgeArr = NSArray()
    var strdateTimeStamp = String()
    var strfarmNameArray = NSArray()
    var notesView :NotesTurkey!
    var notesBGbtn = UIButton()
    let buttonbg1 = UIButton ()
    var droperTableView  =  UITableView ()
    var feedProgramArray = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var birdSexArray = NSArray ()
    let AgeOp = ["1", "2", "3", "4", "5", "6", "7","8",  "9", "10","11", "12", "13", "14", "15", "16", "17","18",  "19", "20","21", "22", "23", "24", "25", "26", "27","28",  "29", "30","31", "32", "33", "34", "35", "36", "37","38",  "39", "40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80"]
    var finilizeValue = NSNumber()
    var oldFarmName = NSString()
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
    let editView = UIView(frame:CGRect(x: 250, y: 130, width: 500, height: 500))
    let titleView = UIView(frame:CGRect(x: 0, y: 0, width: 500, height: 50))
    let nameLabel = UILabel(frame:CGRect(x: 42, y: 43, width: 300, height: 50))
    let titleLabel = UILabel(frame:CGRect(x: 182, y: 0, width: 400, height: 50))
    let ageLabel = UILabel(frame:CGRect(x: 42, y: 132, width: 100, height: 50))
    let nameText = UITextField(frame:CGRect(x: 40, y: 88, width: 280, height: 50))
    let ageButton = UIButton(frame:CGRect(x: 43, y: 174, width: 100, height: 50))
    let submitButton = UIButton(frame:CGRect(x: 30, y: 440, width: 175, height: 40))
    let cancelButton = UIButton(frame:CGRect(x: 290, y: 440, width: 175, height: 40))
    let paddingView = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let paddingView1 = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let feedLabel = UILabel(frame:CGRect(x: 200, y: 132, width: 370, height: 50))
    let farmWeightText = UITextField(frame:CGRect(x: 200, y: 174, width: 260, height: 50))
    let feedButton = UIButton(frame:CGRect(x: 40, y:262, width: 420, height: 50))
    let targetWeightLbl = UILabel(frame:CGRect(x: 42, y: 219, width: 200, height: 50))
    
    let birdSexTextLbl = UILabel(frame:CGRect(x: 42, y: 305, width: 200, height: 50))
    let sexLbl = UILabel(frame:CGRect(x: 42, y: 310, width: 100, height: 50))
    let sexButton = UIButton(frame:CGRect(x: 43, y: 350, width: 420, height: 50))
    
    var lngId = NSInteger()
    var str = String()
    
    // MARK: - Label Outlet
    @IBOutlet weak var sessionDateOutlet: UILabel!
    @IBOutlet weak var sessionTypeOutlet: UILabel!
    @IBOutlet weak var cocciProgramLbl: UILabel!
    @IBOutlet weak var accountContactLbl: UILabel!
    @IBOutlet weak var complexLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var zoetisAccountManagerLbl: UILabel!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var veterinarianLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var vaccinationLbl: UILabel!
    @IBOutlet weak var feedProgramLbl: UILabel!
    
    // MARK: - UIButton Outlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var notesBtnOutlet: UIButton!
    @IBOutlet weak var vaccinationBtnOutlet: UIButton!
    @IBOutlet weak var feedProgramBtnOutlet: UIButton!
    @IBOutlet weak var finializeBttnOutlet: UIButton!
    
    // New Addition House No
    let paddingViewHouseTurkey = UIView(frame: CGRect(x:0 ,y: 0,width: 15,height:50))
    let houseLabelTurkey = UILabel(frame:CGRect(x: 345, y: 43, width: 120, height: 50))
    let houseNoTxtFldTurkey = UITextField(frame:CGRect(x: 345, y: 88, width: 115, height: 50))
    var strHouseNumberTurkey = String()
    
    var buttonback = UIButton()
    var customPopV :OtherDetailsTurkey!
    let mendatoryFieldmsg = Constants.mandatoryFieldsMessage
    let offlineDataMsg = Constants.offline
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        birdSexArray = ["Light hens" , "Heavy hens" , "Toms"]
        tblView.estimatedRowHeight = 50
        tblView.rowHeight = UITableView.automaticDimension
        objApiSyncOneSet.delegeteSyncApiData = self
        farmWeightText.keyboardType = .numberPad
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM-dd-yyyy HH:mm:ss"
        strdateTimeStamp = dateFormatter.string(from: datePicker.date) as String
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        notesBtnOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        vaccinationBtnOutlet.layer.borderWidth = 1.0
        vaccinationBtnOutlet.layer.borderColor = UIColor.black.cgColor
        notesBtnOutlet.layer.borderWidth = 1.0
        notesBtnOutlet.layer.borderColor = UIColor.black.cgColor
        postingArrWithId = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        let posting : PostingSessionTurkey = postingArrWithId.object(at: 0) as! PostingSessionTurkey
        sessionDateOutlet.text = posting.sessiondate
        complexLbl.text = posting.complexName
        deviceTokenId = posting.timeStamp!
        let optionalName: String? = posting.actualTimeStamp
        
        if optionalName == nil{
            actualTimestamp = ""
        }
        UserDefaults.standard.set(sessionDateOutlet.text, forKey: "date")
        UserDefaults.standard.set(complexLbl.text, forKey: "complex")
        UserDefaults.standard.synchronize()
        if posting.salesRepName == NSLocalizedString(appDelegateObj.selectStr, comment: "") || posting.salesRepName == appDelegateObj.selectStr{
            zoetisAccountManagerLbl.text = "NA"
        } else {
            
            if posting.salesRepName == nil || posting.salesRepName?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                // If nil or empty → fetch from Core Data
                zoetisAccountManagerLbl.text = CoreDataHandlerTurkey().fetchSalesrepName(byId: posting.salesRepId as! Int)
            } else {
                // Use the existing name
                zoetisAccountManagerLbl.text = posting.salesRepName
            }
        }
        
        sessionTypeOutlet.text = posting.sessionTypeName
        if  posting.customerRepName == ""{
            accountContactLbl.text = "NA"
        } else {
            accountContactLbl.text = posting.customerRepName
        }
        
        cocciProgramLbl.text = posting.cociiProgramName
        if cocciProgramLbl.text == NSLocalizedString(appDelegateObj.selectStr, comment: "") {
            cocciProgramLbl.text = ""
        }
        customerLbl.text = posting.customerName
        UserDefaults.standard.set( customerLbl.text, forKey: "custmer")
        
        veterinarianLbl.text = posting.vetanatrionName
        notesBtnOutlet.setTitle(posting.notes, for: UIControl.State())
        
        UserDefaults.standard.set( posting.notes, forKey: "postingSessionNotes")
        tblView.reloadData()
        feedProgramBtnOutlet.layer.borderWidth = 1
        feedProgramBtnOutlet.layer.borderColor = UIColor.black.cgColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId) as! [NSManagedObject]
        notesBtnOutlet.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        self.fetcFarmData()
        vacArray  =  CoreDataHandlerTurkey().fetchAddvacinationDataTurkey(postingId).mutableCopy() as! NSMutableArray
        if vacArray.count>0 {
            let vac : HatcheryVacTurkey = vacArray.object(at: 0) as! HatcheryVacTurkey
            vaccinationLbl.text = vac.vaciNationProgram
        }
        
        feedProArrWithId = CoreDataHandlerTurkey().FetchFeedProgramTurkey(postingId).mutableCopy() as! NSMutableArray
        
        if  feedProArrWithId.count == 1 {
            feedProgramLbl.text = (feedProArrWithId.object(at: 0) as AnyObject).value(forKey: "feddProgramNam") as? String
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
                feedProgramLbl.text = ftitle as String
            }
        }
        
        if finilizeValue == 1{
            finializeBttnOutlet.isHidden = true
            notesBtnOutlet.isUserInteractionEnabled = true
            vaccinationBtnOutlet.isUserInteractionEnabled = true
            feedProgramBtnOutlet.isUserInteractionEnabled = true
            eyeImageView.image = UIImage(named:"eye_blue")!
            
        } else if finilizeValue == 0 {
            eyeImageView.image =  UIImage(named:"eye_orange")!
            nameText.isUserInteractionEnabled = true
            feedButton.isUserInteractionEnabled = true
            ageButton.isUserInteractionEnabled = true
        }
        
        finializeBttnOutlet.layer.cornerRadius = 7
        self.tblView.reloadData()
    }
    
    // MARK: - ⬅️ Back Button Action
    @IBAction func bckBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - ──────────────────────────────
    // MARK: - 📝 Load Notes Popup Action
    @IBAction func notesBtnAction(_ sender: UIButton) {
        let notesDict = NSMutableArray()
        
        notesBGbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        notesBGbtn.backgroundColor = UIColor.black
        notesBGbtn.alpha = 0.6
        notesBGbtn.setTitle("", for: UIControl.State())
        notesBGbtn.addTarget(self, action: #selector(notesButtonAcn), for: .touchUpInside)
        self.view.addSubview(notesBGbtn)
        
        notesView = NotesTurkey.loadFromNibNamed("NotesTurkey") as! NotesTurkey
        notesView.strExist = "Exting"
        notesView.notesDelegate = self
        notesView.noOfBird = sender.tag + 1
        notesView.notesDict = notesDict
        notesView.finalizeValue = finilizeValue as! Int
        notesView.center = self.view.center
        self.view.addSubview(notesView)
    }
    
    // MARK: - 📝 Dimiss Notes Popup
    @objc func notesButtonAcn(_ sender: UIButton!) {
        
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    
    // MARK: - ──────────────────────────────
    // MARK: - ℹ️ IBAction: Other Details
    @IBAction func otherDetailsBtnAction(_ sender: UIButton) {
        
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcntion), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        let posting : PostingSessionTurkey = postingArrWithId.object(at: 0) as! PostingSessionTurkey
        customPopV = OtherDetails.loadFromNibNamed("OtherDetailsTurkey") as! OtherDetailsTurkey
        
        customPopV.liveText = posting.livability ?? ""
        customPopV.mortalityText = posting.dayMortality  ?? ""
        customPopV.otherFuncDetailsTurkeyDelegate = self
        customPopV.avgAgeText = posting.avgAge  ?? ""
        customPopV.avgWeightText = posting.avgWeight  ?? ""
        
        customPopV.outTimeText = posting.outTime  ?? ""
        customPopV.fcrText = posting.fcr  ?? ""
        
        
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
    }
    
    func DoneFuncTurkey() {
        self.buttonback.removeFromSuperview()
        self.customPopV.removeFromSuperview()
    }
    
    @objc func buttonAcntion(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func doneBtnTurky(){
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    func crossBtnTurky(){
        debugPrint("delegate method.")
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    
    func openNoteFunc(){
        debugPrint("open notes method.")
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
    }
    
    
    
    func doneBtnFunc(_ notes : NSMutableArray , notesText : String , noOfBird : Int) {
        // deafult
    }
    
    func  postingNotesdoneBtnFunc(_ notesText : String) {
        CoreDataHandlerTurkey().updateFinalizeDataWithNecNotesTurkey(postingId, notes: notesText)
        postingArrWithId = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        let posting : PostingSessionTurkey = postingArrWithId.object(at: 0) as! PostingSessionTurkey
        notesBtnOutlet.setTitle(posting.notes, for: UIControl.State())
        UserDefaults.standard.set( posting.notes, forKey: "postingSessionNotes")
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
        
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
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
    
    func allSessionArrWithPostingId(PId:NSNumber) ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(postingId).mutableCopy() as! NSMutableArray
        let cNecArr =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            var  sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    func doneClick() {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat=Constants.MMddyyyyStr
        let strdate = dateFormatter2.string(from: datePicker.date) as String
        sessionDateOutlet.text = strdate
        
        self.buttonbgNew.removeFromSuperview()
    }
    func cancelClick() {
        
        self.buttonbgNew.removeFromSuperview()
    }
    
    @objc func buttonPressed() {
        strFeddUpdate = ""
        strFarmNameFeedId = ""
        strFeedCheck = ""
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
    func showUpdateView(sender: Int){
        tblView.reloadData()
        
        buttonEdit.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonEdit.frame = CGRect(x: 0, y:1500, width: 1024, height: 768)
        buttonEdit.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        buttonEdit.addTarget(self, action: #selector( PostingSessionDetailTurkey.buttonPressed), for: .touchUpInside)
        editView.backgroundColor = UIColor.white
        editView.layer.cornerRadius = 25
        editView.layer.masksToBounds = true
        titleView.backgroundColor = UIColor(red: 11/255, green:88/255, blue:160/255, alpha:1.0)
        
        titleLabel.text = NSLocalizedString("Update Farm", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = UIColor.white
        nameLabel.text = NSLocalizedString("Farm Name * : ", comment: "")
        ageLabel.text = NSLocalizedString("Age * :", comment: "")
        feedLabel.text = NSLocalizedString("Farm Weight :", comment: "")
        targetWeightLbl.text = NSLocalizedString("Feed Program * :", comment: "")
        houseLabelTurkey.text = NSLocalizedString("House No. * : ", comment: "")
        birdSexTextLbl.text = "Sex * :"
        nameText.layer.borderColor = UIColor.black.cgColor
        nameText.delegate = self
        nameText.layer.borderWidth = 1
        nameText.leftView = paddingView
        nameText.leftViewMode = UITextField.ViewMode.always
        
        houseNoTxtFldTurkey.layer.borderColor = UIColor.black.cgColor
        houseNoTxtFldTurkey.delegate = self
        houseNoTxtFldTurkey.layer.cornerRadius = 5.0
        houseNoTxtFldTurkey.layer.borderWidth = 1
        houseNoTxtFldTurkey.leftView = paddingViewHouseTurkey
        houseNoTxtFldTurkey.leftViewMode = UITextField.ViewMode.always
        houseNoTxtFldTurkey.tag = 40
        
        farmWeightText.layer.borderColor = UIColor.black.cgColor
        farmWeightText.delegate = self
        farmWeightText.layer.borderWidth = 1
        farmWeightText.leftView = paddingView1
        farmWeightText.leftViewMode = UITextField.ViewMode.always
        farmWeightText.isUserInteractionEnabled = false
        
        strfarmName = ((farmArray.object(at: sender) as AnyObject).value(forKey: "farmName") as? String)!
        strFarmNameFeedId = ((farmArray.object(at: sender) as AnyObject).value(forKey: "feedProgram") as? String)!
        feedButton.setTitle(strFarmNameFeedId, for: .normal)
        strfarmNameArray = strfarmName.components(separatedBy: ". ") as NSArray
        strHouseNumberTurkey = ((farmArray.object(at: sender) as AnyObject).value(forKey: "houseNo") as? String)!
        houseNoTxtFldTurkey.text = strHouseNumberTurkey
        let farmName = strfarmNameArray[1]
        nameText.text = farmName as? String
        nameText.layer.cornerRadius = 5.0
        nameText.layer.borderWidth = 1
        nameText.returnKeyType = UIReturnKeyType.done
        
        var strFarmWeight = (farmArray.object(at: sender) as AnyObject).value(forKey: "farmWeight") as? String
        
        var truncated = String()
        if strFarmWeight != "" {
            
            // strFarmWeight = String(1)
            let lastVarble = strFarmWeight?.last!
            let count = strFarmWeight?.count
            if count == 1 && strFarmWeight?.first == "."{
                truncated = ""
                
            } else if lastVarble == "." {
                
                truncated = (strFarmWeight?.substring(to: (strFarmWeight?.index(before: (strFarmWeight?.endIndex)!))!))!
                
            }
            else {
                truncated = strFarmWeight!
                
            }
            
        }
        
        // Button styling
        sexButton.layer.borderColor = UIColor.black.cgColor
        sexButton.layer.cornerRadius = 5.0
        sexButton.layer.borderWidth = 1
        sexButton.setTitleColor(.black, for: .normal)
        sexButton.contentVerticalAlignment = .center
        sexButton.contentHorizontalAlignment = .left // title on the left
        
        // Set the title based on sex
        if let sexValue = ((farmArray.object(at: sender) as AnyObject).value(forKey: "sex") as? String) {
            let title: String
            switch sexValue {
            case "HH": title = "Heavy hens"
            case "LH": title = "Light hens"
            case "T":  title = "Toms"
            default:   title = "Unknown"
            }
            sexLbl.text = sexValue
            sexButton.setTitle(title, for: .normal)
        }
        
        // Set the dropdown icon
        sexButton.setImage(UIImage(named: "Drop_Icon"), for: .normal)
        sexButton.imageView?.contentMode = .scaleAspectFit
        
        // Adjust insets
        let padding: CGFloat = 5
        let imagePadding: CGFloat = 10
        sexButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        sexButton.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: sexButton.frame.width - (sexButton.imageView?.frame.width ?? 0) - imagePadding,
            bottom: 0,
            right: imagePadding
        )
        sexButton.addTarget(self, action: #selector( PostingSessionDetailTurkey.updateBirdSex), for: .touchUpInside)
        
        farmWeightText.text = truncated
        farmWeightText.layer.cornerRadius = 5.0
        farmWeightText.layer.borderWidth = 1
        farmWeightText.returnKeyType = UIReturnKeyType.done
        
        oldFarmName = strfarmName as NSString
        ageButton.layer.borderColor =  UIColor.black.cgColor
        ageButton.layer.cornerRadius = 5.0
        ageButton.layer.borderWidth = 1
        ageButton.setTitleColor(UIColor.black, for: .normal)
        ageButton.contentVerticalAlignment = .center
        ageButton.titleEdgeInsets = UIEdgeInsets.init(top: 5.0, left: 10.0, bottom: 0.0, right: 0.0)
        ageButton.setTitle("\(((farmArray.object(at: sender) as AnyObject).value(forKey: "age") as? String)!)", for: .normal)
        ageButton.addTarget(self, action: #selector( PostingSessionDetailTurkey.updateAge), for: .touchUpInside)
        ageButton.setBackgroundImage(UIImage(named:"dialer01"), for: .normal)
        ageButton.contentHorizontalAlignment = .left
        feedButton.layer.cornerRadius = 5.0
        feedButton.layer.borderWidth = 1
        feedButton.contentHorizontalAlignment = .left
        feedButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0);
        
        feedButton.setTitle(strFarmNameFeedId, for: .normal)
        if let value = feedButton.titleLabel?.text{
            strFeedCheck = value
        }
        feedButton.setTitleColor(UIColor.black, for: .normal)
        feedButton.layer.borderColor =  UIColor.black.cgColor
        feedButton.addTarget(self, action: #selector( PostingSessionDetailTurkey.feedPressed), for: .touchUpInside)
        let btnView = UIView()
        let btnView1 = UIView()
        
        btnView.frame = CGRect(x: 20, y:430, width: 470, height: 0.5)
        btnView.backgroundColor = UIColor.black
        btnView1.frame = CGRect(x: 250, y:440, width: 1, height:40)
        btnView1.backgroundColor = UIColor.black
        editView.addSubview(btnView)
        editView.addSubview(btnView1)
        submitButton.backgroundColor = UIColor.clear
        submitButton.tintColor = UIColor.white
        submitButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        submitButton.titleLabel!.font =  UIFont(name: "Arial", size: 20)
        submitButton.setTitleColor(UIColor(red: 0/255, green:122/255, blue:228/255, alpha:1.0), for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector( PostingSessionDetailTurkey.updatePressed), for: .touchUpInside)
        
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.tintColor = UIColor.white
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel!.font =  UIFont(name: "Arial", size: 20)
        cancelButton.setTitleColor(UIColor(red: 0/255, green:122/255, blue:228/255, alpha:1.0), for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector( PostingSessionDetailTurkey.buttonPressed), for: .touchUpInside)
        editView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        editView.addSubview(nameLabel)
        editView.addSubview(ageLabel)
        editView.addSubview(feedLabel)
        editView.addSubview(nameText)
        editView.addSubview(farmWeightText)
        editView.addSubview(houseLabelTurkey)
        editView.addSubview(houseNoTxtFldTurkey)
        
        editView.addSubview(ageButton)
        editView.addSubview(submitButton)
        editView.addSubview(cancelButton)
        editView.addSubview(feedButton)
        editView.addSubview(targetWeightLbl)
        editView.addSubview(birdSexTextLbl)
        editView.addSubview(sexButton)
        buttonEdit.addSubview(editView)
        
        self.view.addSubview(buttonEdit)
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonEdit.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        })
    }
    
    func showAgesList(){
        
        self.myPickerView.frame = CGRect(x:401,y: 272,width: 100,height: 120)
        pickerView()
        let lblAge = ageButton.titleLabel?.text
        if(lblAge == ""){
            myPickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else{
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
    
    func showBirdSexList(){
        
        btnTag = 1001
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 295, y: 530, width: 420, height: 150)
        droperTableView.reloadData()
 
    }
    
    
    @objc func feedPressed(){
        btnTag = 1
        feedProArrWithId = CoreDataHandlerTurkey().FetchFeedProgramTurkey(postingId).mutableCopy() as! NSMutableArray
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 290, y: 455, width: 350, height: 150)
        droperTableView.reloadData()
    }
    
    func pickerView (){
        buttonbgNew2.frame = CGRect(x:0,y: 0,width: 1024,height: 768)
        buttonbgNew2.addTarget(self, action: #selector(PostingSessionDetailTurkey.buttonPressedAgeList), for: .touchUpInside)
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
    
    
    fileprivate func setFeedBtnBorder() {
        nameText.layer.borderColor = UIColor.red.cgColor
        let abc = feedButton.currentTitle!
        if abc == ""{
            feedButton.layer.borderColor = UIColor.red.cgColor
        }else {
            feedButton.layer.borderColor = UIColor.black.cgColor
        }
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:mendatoryFieldmsg)
    }
    
    fileprivate func setFarmBtnBorder(_ trimmedString: String) {
        if strFeddUpdate == "" {
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please select a feed program.", comment: ""))
        }
        if trimmedString == "" {
            nameText.layer.borderColor = UIColor.red.cgColor
            
        } else {
            nameText.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    
    @objc func updatePressed(){
        Constants.isFromPsotingTurkey = true
        UserDefaults.standard.setValue(true, forKey: "postingTurkey")
        UserDefaults.standard.synchronize()
        var trimmedString = nameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        
        trimmedString = trimmedString.replacingOccurrences(of: ".", with: "", options:
                                                            NSString.CompareOptions.literal, range: nil)
        
        if trimmedString == "" && strFeddUpdate == "" {
            
            setFeedBtnBorder()
            
        }else if trimmedString == ""  {
            
            setFeedBtnBorder()
            
        } else if trimmedString == "" && strFeedCheck == ""{
            setFeedBtnBorder()
            farmWeightText.layer.borderColor = UIColor.black.cgColor
            
        }
        
        if houseNoTxtFldTurkey.text == ""
        {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(mendatoryFieldmsg, comment: ""))
            houseNoTxtFldTurkey.layer.borderColor = UIColor.red.cgColor
            return
            
        }
        
        else if trimmedString == "" {
            nameText.layer.borderColor = UIColor.red.cgColor
            feedButton.layer.borderColor = UIColor.black.cgColor
            farmWeightText.layer.borderColor = UIColor.black.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Please enter farm name.")
            
        }else if strFarmNameFeedId == "" && strFeddUpdate == ""{
            setFarmBtnBorder(trimmedString)
        }
        else if strFeedCheck == "" &&  strFeddUpdate == ""{
            farmWeightText.layer.borderColor = UIColor.black.cgColor
            nameText.layer.borderColor = UIColor.black.cgColor
            feedButton.layer.borderColor = UIColor.red.cgColor
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Please select a feed program.")
        }
        
        else {
            str = strfarmNameArray[0] as! String
            let strNewFarm = str+". "+trimmedString
            if strFeddUpdate == ""{
                CoreDataHandlerTurkey().updateFeddProgramInStep1UsingFarmNameTurkey(self.postingId, feedname: strFeedCheck, feedId: feedIdUpdate , formName: strfarmName)
            }
            else if strFarmNameFeedId == ""{
                CoreDataHandlerTurkey().updateFeddProgramInStep1UsingFarmNameTurkey(self.postingId, feedname: strFeddUpdate, feedId: feedIdUpdate , formName: strfarmName)
            }
            else {
                CoreDataHandlerTurkey().updateFeddProgramInStep1UsingFarmNameTurkey(self.postingId, feedname: strFeddUpdate, feedId: feedIdUpdate , formName: strfarmName)
            }
            if farmWeightText.text == "."{
                farmWeightText.text = ""
            }
            
            CoreDataHandlerTurkey().updateNecropsystep1WithNecIdAndFarmNameTurkey(postingId, farmName: oldFarmName as NSString, newFarmName: strNewFarm as NSString  , age: (ageButton.titleLabel?.text!)!, isSync: true, farmWeight: farmWeightText.text!, newHouseNoTurkey: houseNoTxtFldTurkey.text! as NSString, sexLbl.text! as NSString)
            
            CoreDataHandlerTurkey().updateNewFarmAndAgeOnCaptureNecropsyViewDataTurkey(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
            CoreDataHandlerTurkey().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdNotesTurkey(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: true)
            CoreDataHandlerTurkey().updateNewFarmAndAgeOnCaptureNecropsyViewDataBirdPhotoTurkey(postingId, oldFarmName: oldFarmName as String, newFarmName: strNewFarm,isSync: false)
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingId as NSNumber)
            self.tblView.reloadData()
            self.fetcFarmData()
            self.buttonbgNew2.removeFromSuperview()
            self.buttonEdit.removeFromSuperview()
        }
    }
    
    @objc func updateAge(){
        view.endEditing(true)
        showAgesList()
    }
    
    @objc func updateBirdSex(){
        view.endEditing(true)
        showBirdSexList()
    }
    func postSesionSyncTodev(sessionId: String) {
        
        if WebClass.sharedInstance.connected() {
            
            let Id = UserDefaults.standard.integer(forKey: "Id")
            let Url = "PostingSession/SyncToDevice"
            let parameters  = ["UserId" :Id,"SessionId": sessionId] as [String : Any]
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            
            let headerDict: HTTPHeaders = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            
            
            sessionManager.request(urlString, method: .post,parameters:parameters, headers: headerDict).responseJSON { response in
                switch response.result {
                case let .success(value):
                    debugPrint(value)
                    Helper.dismissGlobalHUD(self.view)
                    self.alerViewSucees()
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    //completion(nil, error as NSError)
                    break
                }
            }
        }
    }
    
    
    // MARK: - PICKER VIEW DELEGATES
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
    
    // MARK: - TEXTFIELD DELEGATES
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        farmWeightText.layer.borderColor = UIColor.black.cgColor
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92){
            debugPrint("Back space action.")
        } else if ((textField.text?.count)! > 50  ){
            return false
        }
        
        switch textField.tag {
            
        case 40 :
            let aSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789:;,/-_!@#$%*()-_=+[]\'<>.?/\\~`€£").inverted
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - METHODS AND FUNCTIONS
    fileprivate func savePostingDatatoDataBase(_ value: Any) {
        let arr : NSArray = value as! NSArray
        
        if arr.count>0{
            for  i in 0..<arr.count {
                let posDict = arr.object(at: i)
                
                CoreDataHandlerTurkey().getPostingDatWithSpecificIdTurkey(posDict as! NSDictionary,postinngId: self.postingId)
            }
            
            let postingData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(self.postingId)
            if postingData.count>0{
                self.getPostingDataFromServerforVaccination()
            }
        }
    }
    
    fileprivate func postedDataSavedInDBFromWeb(_ value: Any) {
        if value != nil {
            UserDefaults.standard.set("Yes", forKey: "Success")
            if value is NSArray{
                self.savePostingDatatoDataBase(value)
            }
            
        }
    }
    
    
    
    // MARK: - METHODS AND FUNCTIONS
    func pullFromWeb() {
        fullData =  deviceTokenId
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        
        if WebClass.sharedInstance.connected() {
            Helper.dismissGlobalHUD(self.view)
            Helper.showGlobalProgressHUDWithTitle(self.view, title: "Fetching data from server...")
            let keychainHelper = AccessTokenHelper()
            accestoken = keychainHelper.getFromKeychain(keyed: "aceesTokentype") ?? ""
            let headerDict: HTTPHeaders = ["Authorization":accestoken]
            let Url = "PostingSession/GetPostingSessionListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + Url
            guard let urlStringNew = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            sessionManager.request(urlStringNew, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                if statusCode == 404 {
                    self.getPostingDataFromServerforVaccination()
                    Helper.dismissGlobalHUD(self.view)
                    
                }
                
                else if statusCode == 500  || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504  || statusCode == 408{
                    self.alerView(statusCode:statusCode!)
                }
                else {
                    switch response.result {
                    case let .success(value):
                        
                        if value != nil {
                            UserDefaults.standard.set("Yes", forKey: "Success")
                            if value is NSArray{
                                let arr : NSArray = value as! NSArray
                                if arr.count>0{
                                    for  i in 0..<arr.count {
                                        let posDict = arr.object(at: i)
                                        CoreDataHandlerTurkey().getPostingDatWithSpecificIdTurkey(posDict as! NSDictionary,postinngId: self.postingId)
                                    }
                                    
                                    let postingData = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(self.postingId)
                                    if postingData.count>0{
                                        self.getPostingDataFromServerforVaccination()
                                    }
                                    else{
                                        debugPrint("posted Data count is not 0")
                                    }
                                }
                                else{
                                    debugPrint(" Data count is zero")
                                }
                            }
                            else{
                                debugPrint("No Data in array")
                            }
                        }
                    case .failure(let encodingError):
                        
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            debugPrint(err)
                            
                        } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            // other failures
                            print (encodingError)
                            print (responseString)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getPostingDataFromServerforVaccination(){
        
        if WebClass.sharedInstance.connected() {
       
            let url = "PostingSession/GetVaccinationListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict: HTTPHeaders = ["Authorization":accestoken]
            guard let vaccinationUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(vaccinationUrlString, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.getPostingDataFromServerforFeed()
                    
                }
                else{
                    switch response.result {
                    case let .success(value):
                        
                        if value != nil {
                            if value is NSArray{
                                let arr : NSArray = value as! NSArray
                                
                                UserDefaults.standard.set("Yes", forKey: "Success")
                                if arr.count>0 {
                                    CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(self.postingId)
                                    CoreDataHandlerTurkey().deleteDataWithPostingIdFieldVacinationWithSingleTurkey(self.postingId)
                                    
                                    for  i in 0..<arr.count {
                                        
                                        let vac = (arr.object(at: i) as AnyObject).value(forKey: "Vaccination") as! NSArray
                                        if vac.count > 0{
                                            let posDict = (vac as AnyObject).object(at: 0)
                                            CoreDataHandlerTurkey().getHatcheryDataFromServerSingleFromDeviceIdTurkey(posDict as! NSDictionary,postingId: self.postingId)
                                            CoreDataHandlerTurkey().getFieldDataFromServerSingledataTurkey(posDict as! NSDictionary,postingId: self.postingId)
                                        }
                                    }
                                    self.getPostingDataFromServerforFeed()
                                }
                                else{
                                    self.getPostingDataFromServerforFeed()
                                }
                            }
                            else{
                            }
                        }
                    case .failure(let encodingError):
                        if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                            print(err)
                        } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                            // other failures
                            print (encodingError)
                            print (responseString)
                        }
                    }
                }
            }
        } else{
        }
        
    }
    // MARK: - 🦃🌿 Save Alternative Feed Data
    fileprivate func saveAlternativeFeedData(_ feedDetailArr: Any?, _ j: Int, _ feedId: Int, _ seesionId: Int, _ feedName: Any?, _ feedDate: Any?) {
        let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
        for  p in 0..<(feedDetail! as AnyObject).count{
            let postDict = (feedDetail as AnyObject).object(at: p)
            CoreDataHandlerTurkey().getDataFromAlterNativeForSingleDevTokenTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String, postingAlterNative: self.postingId, feedDate: feedDate as! String)
        }
    }
    // MARK: - 🦃💊 Save Antibiotic Feed Data  💾
    fileprivate func saveAntibioticFeedData(_ feedDetailArr: Any?, _ j: Int, _ feedId: Int, _ seesionId: Int, _ feedName: Any?, _ feedDate: Any?) {
        let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey:"feedDetails")
        for  a in 0..<(feedDetail! as AnyObject).count{
            let postDict = (feedDetail as AnyObject).object(at: a)
            CoreDataHandlerTurkey().getDataFromAntiboiticWithSigleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String,postingIdAlterNative:self.postingId, feedDate: feedDate as! String)
        }
    }
    // MARK: - 🍄🌾 Save Mycotoxin Feed Data 💾
    fileprivate func saveMicoToxinFeedData(_ feedDetailArr: Any?, _ j: Int, _ feedId: Int, _ seesionId: Int, _ feedName: Any?, _ feedDate: Any?) {
        let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
        for  y in 0..<(feedDetail! as AnyObject).count{
            let postDict = (feedDetail as AnyObject).object(at: y)
            CoreDataHandlerTurkey().getDataFromMyCocotinBinderWithSingleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String,postingidMycotxin:self.postingId, feedDate: feedDate as! String)
        }
    }
    // MARK: - 🦃🌾 Save Coccidiosis Feed Data 💾
    fileprivate func saveCoccidiosisFeedData(_ feedDetailArr: Any?, _ j: Int, _ feedId: Int, _ seesionId: Int, _ feedName: Any?, _ feedDate: Any?) {
        let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
        for  m in 0..<(feedDetail! as AnyObject).count{
            
            let postDict = (feedDetail as AnyObject).object(at: m)
            CoreDataHandlerTurkey().getDataFromCocoiiControllForSingleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName: feedName as! String,postingIdCocoii:self.postingId, feedDate: feedDate as! String)
        }
    }
    // MARK: - 🌾 Handle Feed Detail / Feed ID Validations
    fileprivate func handleFeedDetailArrFeedIdValidations(_ feedDetailArr: Any?, _ feedId: Int, _ seesionId: Int, _ feedName: Any?, _ feedDate: Any?) {
        for j in 0..<(feedDetailArr! as AnyObject).count{
            let feedCatName = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedProgramCategory") as! String
            
            if feedCatName == Constants.coccidioStr{
                self.saveCoccidiosisFeedData(feedDetailArr, j, feedId, seesionId, feedName, feedDate)
            }
            else if feedCatName  == "Alternatives"{
                self.saveAlternativeFeedData(feedDetailArr, j, feedId, seesionId, feedName, feedDate)
            }
            else if  feedCatName == "Antibiotic"{
                self.saveAntibioticFeedData(feedDetailArr, j, feedId, seesionId, feedName, feedDate)
            }
            else if  feedCatName  == Constants.mytoxinStr{
                self.saveMicoToxinFeedData(feedDetailArr, j, feedId, seesionId, feedName, feedDate)
                
            }
        }
    }
    
    fileprivate func handleGetPostingDataFromServerFeedForLoopValidations(_ arr: NSArray) {
        for t in 0..<arr.count {
            
            let posDict = arr.object(at: t)
            let seesionId = (posDict as AnyObject).value(forKey: "sessionId") as! Int
            let feedDictArr = (posDict as AnyObject).value(forKey: "Feeds")
            
            for i in 0..<(feedDictArr! as AnyObject).count {
                let feedId = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey: "feedId") as! Int
                let nsFeedid = UserDefaults.standard.integer(forKey: "feedId")
                if feedId > nsFeedid{
                    UserDefaults.standard.set(feedId, forKey: "feedId")
                }
                let feedName = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey:"feedName")
                let feedDate = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey:"startDate")
                
                CoreDataHandlerTurkey().getFeedNameFromGetApiSingleDeviceTokenTurkey((seesionId) as NSNumber, sessionId: seesionId as NSNumber, feedProgrameName: feedName as! String, feedId: feedId as NSNumber,postingIdFeed: self.postingId)
                
                let feedDetailArr = ((feedDictArr! as AnyObject).object(at: i) as AnyObject).value(forKey: "feedCategoryDetails")
                self.handleFeedDetailArrFeedIdValidations(feedDetailArr, feedId, seesionId, feedName, feedDate)
            }
        }
    }
    
    fileprivate func handleGetFeedListBySessionIdSuccessAPIResponse(_ response: AFDataResponse<Any>) {
        switch response.result {
        case let .success(value):
            
            if value is NSArray {
                let arr : NSArray = value as! NSArray
                
                UserDefaults.standard.set("Yes", forKey: "Success")
                if arr.count>0 {
                    CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramTurkey(self.postingId)
                    CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramCocoiiSinleTurkey(self.postingId)
                    CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramAlternativeSinleTurkey(self.postingId)
                    CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramAntiboiticSingleTurkey(self.postingId)
                    CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramMyCotoxinSingleTurkey(self.postingId)
                    self.handleGetPostingDataFromServerFeedForLoopValidations(arr)
                    
                    self.getCNecStep1Data()
                } else {
                    self.getCNecStep1Data()
                }
            }
            
        case .failure(let encodingError):
            
            print (encodingError)
        }
    }
    
    // MARK: - ☁️🌾 Fetch Feed Posting Data from Server
    func getPostingDataFromServerforFeed (){
        
        if WebClass.sharedInstance.connected() {
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict: HTTPHeaders = ["Authorization":accestoken]
            let url = "PostingSession/GetFeedListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            guard let feedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(feedUrlString, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    // UserDefaults.standard.set("No", forKey: "Success")
                    self.getCNecStep1Data()
                }
                switch response.result{
                case let .success(value):
                    if value != nil {
                        if value is NSArray{
                            let arr : NSArray = value as! NSArray
                            print(arr)
                            UserDefaults.standard.set("Yes", forKey: "Success")
                            if arr.count>0{
                                CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramTurkey(self.postingId)
                                CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramCocoiiSinleTurkey(self.postingId)
                                CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramAlternativeSinleTurkey(self.postingId)
                                CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramAntiboiticSingleTurkey(self.postingId)
                                CoreDataHandlerTurkey().deleteDataWithPostingIdFeddProgramMyCotoxinSingleTurkey(self.postingId)
                                
                                for  t in 0..<arr.count {
                                    
                                    let posDict = arr.object(at: t)
                                    let seesionId = (posDict as AnyObject).value(forKey: "sessionId") as! Int
                                    let feedDictArr = (posDict as AnyObject).value(forKey: "Feeds")
                                    
                                    for  i in 0..<(feedDictArr! as AnyObject).count {
                                        var feedId = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey: "feedId") as! Int
                                        let nsFeedid = UserDefaults.standard.integer(forKey: "feedId")
                                        if feedId > nsFeedid{
                                            UserDefaults.standard.set(feedId, forKey: "feedId")
                                        }
                                        let feedName = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey:"feedName")
                                        let feedDate = ((feedDictArr as AnyObject).object(at: i) as AnyObject).value(forKey:"startDate")
                                        CoreDataHandlerTurkey().getFeedNameFromGetApiSingleDeviceTokenTurkey((seesionId) as NSNumber, sessionId: seesionId as NSNumber, feedProgrameName: feedName as! String, feedId: feedId as NSNumber,postingIdFeed: self.postingId)
                                        
                                        let feedDetailArr = ((feedDictArr! as AnyObject).object(at: i) as AnyObject).value(forKey: "feedCategoryDetails")
                                        
                                        for  j in 0..<(feedDetailArr! as AnyObject).count{
                                            let feedCatName = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedProgramCategory") as! String
                                            
                                            if feedCatName == "Coccidiosis Control"{
                                                let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
                                                for  m in 0..<(feedDetail! as AnyObject).count{
                                                    let postDict = (feedDetail as AnyObject).object(at: m)
                                                    CoreDataHandlerTurkey().getDataFromCocoiiControllForSingleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName: feedName as! String,postingIdCocoii:self.postingId, feedDate: feedDate as! String)
                                                }
                                            }
                                            else if feedCatName  == "Alternatives"{
                                                let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
                                                for  p in 0..<(feedDetail! as AnyObject).count{
                                                    let postDict = (feedDetail as AnyObject).object(at: p)
                                                    CoreDataHandlerTurkey().getDataFromAlterNativeForSingleDevTokenTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String, postingAlterNative: self.postingId, feedDate: feedDate as! String)
                                                }
                                            }
                                            else if  feedCatName == "Antibiotic"{
                                                let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey:"feedDetails")
                                                for  a in 0..<(feedDetail! as AnyObject).count{
                                                    let postDict = (feedDetail as AnyObject).object(at: a)
                                                    CoreDataHandlerTurkey().getDataFromAntiboiticWithSigleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String,postingIdAlterNative:self.postingId, feedDate: feedDate as! String)
                                                }
                                            }
                                            else if  feedCatName  == "Mycotoxin Binders"{
                                                let feedDetail = ((feedDetailArr as AnyObject).object(at: j) as AnyObject).value(forKey: "feedDetails")
                                                for  y in 0..<(feedDetail! as AnyObject).count{
                                                    let postDict = (feedDetail as AnyObject).object(at: y)
                                                    CoreDataHandlerTurkey().getDataFromMyCocotinBinderWithSingleDataTurkey(postDict as! NSDictionary, feedId: feedId as NSNumber, postingId: seesionId as NSNumber, feedProgramName:feedName as! String,postingidMycotxin:self.postingId, feedDate: feedDate as! String)
                                                }
                                            }
                                        }
                                    }
                                }
                                self.getCNecStep1Data()
                            }
                            else{
                                self.getCNecStep1Data()
                            }
                        }
                        else{
                        }
                    }
                case .failure(let encodingError):
                    
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        print(err)
                    } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        print (encodingError)
                        print (responseString)
                    }
                }
            }
        } else{
            
        }
    }
    // MARK: - 💾 ⚕️ Save Necropsy Data in Database
    fileprivate func saveNecropsyDataInDataBase(_ input: NecropsySessionInput, _ postingId: inout Int) {
        for farm in input.farms {
            let postingArr = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(input.sessionId as NSNumber)
            
            if let firstPosting = postingArr.first as? NSObject,
               let fetchedPostingId = firstPosting.value(forKey: "postingId") as? Int {
                postingId = fetchedPostingId
                if postingId == input.sessionId {
                    CoreDataHandlerTurkey().updateFinalizeDataWithNecTurkey(postingId as NSNumber, finalizeNec: 1)
                    postingId = input.sessionId
                }
            } else {
                postingId = 0
            }
            
            let necropsyData = CoreDataHandlerTurkeyModels.singleNecropsyDataTurkey(
                postingId: postingId as NSNumber,
                age: farm.age,
                farmName: farm.farmName,
                feedProgram: farm.feedProgram,
                flockId: farm.flockId,
                houseNo: farm.houseNo,
                noOfBirds: farm.birds,
                sick: farm.sick as NSNumber,
                necId: input.sessionId as NSNumber,
                compexName: input.complexName,
                complexDate: input.seesDate,
                complexId: input.complexId as NSNumber,
                custmerId: input.customerId as NSNumber,
                feedId: farm.feedId as NSNumber,
                isSync: false,
                timeStamp: input.deviceSessionId,
                actualTimeStamp: input.deviceSessionId,
                necIdSingle: postingId as NSNumber,
                farmweight: farm.farmWeight,
                abf: farm.abf,
                sex: farm.sex,
                breed: farm.breed,
                farmId: farm.farmId as NSNumber,
                imgId: farm.imgId as NSNumber,
                generationName: farm.generationName,
                generationId: farm.generationId as NSNumber
            )
            
            CoreDataHandlerTurkey().SaveNecropsystep1SingleDataTurkey(data: necropsyData)
            UserDefaults.standard.set(farm.farmId as NSNumber, forKey: "farmIdTurkey")
        }
    }
    // MARK: - ⚕️✅ Handle & Validate Necropsy Data Array Before Saving
    fileprivate func handleArrAndSaveNecropsyDataValidations(_ arr: NSArray) {
        if arr.count>0 {
            CoreDataHandlerTurkey().deleteDataWithPostingIdCaptureStepDataTurkey(self.postingId)
            for i in 0..<arr.count {
                var postingIdInternal = 0
                let obj = arr.object(at: i) as AnyObject
                let sessionId = obj.value(forKey: "SessionId") as! Int
                let devSessionId = obj.value(forKey: "deviceSessionId") as! String
                let custId = obj.value(forKey: "CustomerId") as! Int
                let complexId = obj.value(forKey: "ComplexId") as! Int
                let complexName = obj.value(forKey: "ComplexName") as! String
                let savedSessionDateOutlet = obj.value(forKey: "SessionDate") as! String
                let seesDate = self.convertDateFormater(savedSessionDateOutlet)
                
                guard let farmRawArr = obj.value(forKey: "Farms") as? [AnyObject], !farmRawArr.isEmpty else {
                    continue
                }
                
                let farms: [NecropsyFarmModel] = farmRawArr.map { farmObj in
                    NecropsyFarmModel(
                        farmName: farmObj.value(forKey: "farmName") as? String ?? "",
                        age: (farmObj.value(forKey: "age") as AnyObject).stringValue ?? "",
                        birds: (farmObj.value(forKey: "birds") as AnyObject).stringValue ?? "",
                        houseNo: (farmObj.value(forKey: "houseNo") as AnyObject).stringValue ?? "",
                        flockId: (farmObj.value(forKey: "flockId") as AnyObject).stringValue ?? "",
                        feedProgram: farmObj.value(forKey: "feedProgram") as? String ?? "",
                        sick: farmObj.value(forKey: "sick") as? Bool ?? false,
                        feedId: farmObj.value(forKey: "FeedId") as? Int ?? 0,
                        farmWeight: farmObj.value(forKey: "Farm_Weight") as? String ?? "",
                        abf: farmObj.value(forKey: "ABF") as? String ?? "",
                        sex: farmObj.value(forKey: "Sex") as? String ?? "",
                        breed: farmObj.value(forKey: "Breed") as? String ?? "",
                        farmId: farmObj.value(forKey: "DeviceFarmId") as? Int ?? 0,
                        generationName: farmObj.value(forKey: "GenerationName") as? String ?? "",
                        generationId: farmObj.value(forKey: "GenerationId") as? Int ?? 0,
                        imgId: farmObj.value(forKey: "ImgId") as? Int ?? 0
                    )
                }
                
                let sessionInput = NecropsySessionInput(
                    farms: farms,
                    sessionId: sessionId,
                    postingId: postingIdInternal,
                    complexName: complexName,
                    seesDate: seesDate,
                    complexId: complexId,
                    customerId: custId,
                    deviceSessionId: devSessionId
                )
                self.saveNecropsyDataInDataBase(sessionInput, &postingIdInternal)
            }
            
            let necArr = CoreDataHandlerTurkey().FetchNecropsystep1AllNecIdTurkey()
            if necArr.count>0 {
                self.getPostingDataFromServerforNecorpsy()
            }
        } else {
            self.getPostingDataFromServerforNecorpsy()
        }
    }
    // MARK: - 🏡☁️✅ Handle  Farm List By Session ID API Success Response
    fileprivate func handleGetFarmListBySessionIdAPISucessResponse(_ value: Any) {
        if value != nil {
            
            UserDefaults.standard.set("Yes", forKey: "Success")
            if value is NSArray{
                let arr : NSArray = value as! NSArray
                
                self.handleArrAndSaveNecropsyDataValidations(arr)
            } else {
                self.getPostingDataFromServerforNecorpsy()
                
            }
        }
    }
    // MARK: - 🏡☁️ Get Farm List by Session ID
    func getCNecStep1Data(){
        if WebClass.sharedInstance.connected() {
            let keychainHelper = AccessTokenHelper()
            accestoken = keychainHelper.getFromKeychain(keyed: "aceesTokentype") ?? ""
            let headerDict: HTTPHeaders = ["Authorization":accestoken]
            
            let url = "PostingSession/GetFarmListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            guard let NecropsyUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(NecropsyUrlString, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.getPostingDataFromServerforNecorpsy()
                    
                }
                
                switch response.result{
                case let .success(value):
                    if value != nil {
                        
                        UserDefaults.standard.set("Yes", forKey: "Success")
                        if value is NSArray{
                            let arr : NSArray = value as! NSArray
                            
                            if arr.count>0{
                                CoreDataHandlerTurkey().deleteDataWithPostingIdCaptureStepDataTurkey(self.postingId)
                                for  i in 0..<arr.count {
                                    var posttingId =  Int ()
                                    let sessionId = (arr.object(at: i) as AnyObject).value(forKey: "SessionId") as! Int
                                    let devSessionId = (arr.object(at: i) as AnyObject).value(forKey: "deviceSessionId") as! String
                                    let custId = (arr.object(at: i) as AnyObject).value(forKey: "CustomerId") as! Int
                                    let complexId = (arr.object(at: i) as AnyObject).value(forKey: "ComplexId") as! Int
                                    let complexName = (arr.object(at: i) as AnyObject).value(forKey: "ComplexName") as! String
                                    let sessionsDate = (arr.object(at: i) as AnyObject).value(forKey: "SessionDate") as! String
                                    
                                    let seesDat = self.convertDateFormater(sessionsDate)
                                    let farmArr = (arr.object(at:i) as AnyObject).value(forKey:  "Farms")
                                    if (farmArr as AnyObject).count>0{
                                        for  j in 0..<(farmArr! as AnyObject).count {
                                            let farmName =  ((farmArr as AnyObject).object(at:j) as AnyObject).value(forKey:"farmName") as! String
                                            let  postingArr  =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(sessionId as NSNumber)
                                            if postingArr.count>0{
                                                posttingId = (postingArr.object(at: 0) as AnyObject).value(forKey:"postingId") as! Int
                                                if posttingId == sessionId{
                                                    CoreDataHandlerTurkey().updateFinalizeDataWithNecTurkey(self.postingId, finalizeNec: 1)
                                                    posttingId = sessionId
                                                }
                                            }
                                            else{
                                                posttingId = 0
                                            }
                                            let birdAge =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"age")
                                            let birds =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"birds")
                                            let houseNo =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"houseNo")
                                            let flockId =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"flockId")
                                            let feedProgram =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"feedProgram") as! String
                                            let sick =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"sick") as! Bool
                                            let feedId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "FeedId") as! Int
                                            let farmweight =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"Farm_Weight") as! String
                                            let abf =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"ABF") as! String
                                            let sex =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"Sex") as! String
                                            let breed =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"Breed") as! String
                                            let farmId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "DeviceFarmId") as! Int
                                            let genName =  ((farmArr as AnyObject).object(at: j) as AnyObject).value(forKey:"GenerationName") as! String
                                            let genId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "GenerationId") as! Int
                                            let imgId = ((farmArr! as AnyObject).object(at: j) as AnyObject).value(forKey: "ImgId") as! Int
                                            
                                            let necropsyData = CoreDataHandlerTurkeyModels.singleNecropsyDataTurkey(postingId:posttingId as NSNumber, age: ((birdAge as AnyObject).stringValue)!, farmName: farmName, feedProgram:feedProgram, flockId: ((flockId as AnyObject).stringValue) ?? "", houseNo: ((houseNo as AnyObject).stringValue) ?? "", noOfBirds: ((birds as AnyObject).stringValue)!, sick: sick as NSNumber,necId:sessionId as NSNumber,compexName:complexName,complexDate:seesDat,complexId:complexId as NSNumber,custmerId:custId as NSNumber,feedId: feedId as NSNumber,isSync:false,timeStamp:devSessionId,actualTimeStamp:devSessionId, necIdSingle: self.postingId, farmweight: farmweight, abf: abf,sex: sex,breed: breed,farmId:farmId as NSNumber,imgId:imgId as NSNumber , generationName: genName , generationId: genId as NSNumber)
                                            
                                            CoreDataHandlerTurkey().SaveNecropsystep1SingleDataTurkey(data: necropsyData)
                                            UserDefaults.standard.set(farmId as NSNumber, forKey: "farmIdTurkey")
                                        }
                                    }
                                }
                                let necArr = CoreDataHandlerTurkey().FetchNecropsystep1AllNecIdTurkey()
                                if necArr.count>0{
                                    self.getPostingDataFromServerforNecorpsy()
                                }
                            }
                            else{
                                self.getPostingDataFromServerforNecorpsy()
                            }
                        }
                        else{
                            self.getPostingDataFromServerforNecorpsy()
                            
                        }
                    }
                case .failure(let encodingError):
                    
                    if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
                        print(err)
                    } else if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
                        print (encodingError)
                        print (responseString)
                    }
                }
            }
        } else{
            
        }
        /************************************************************************************/
        
    }
    // MARK: - 📅⏰ Convert Date Formatter
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss
        // New addition for below 2 line
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let convertedTimeStamp = dateFormatter.string(from: date)
        
        return convertedTimeStamp
    }
    // MARK: - ☁️⚕️ Fetch Necropsy Posting Data from Server
    func getPostingDataFromServerforNecorpsy() {
        guard WebClass.sharedInstance.connected() else {
            self.noInternetConnection()
            return
        }
        
        let id = UserDefaults.standard.integer(forKey: "Id")
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let countryId = UserDefaults.standard.integer(forKey: "countryId")
        let url = "PostingSession/TurkeyGetNecropsyListBySessionId?UserId=\(id)&DeviceSessionId=\(fullData)&LanguageId=\(lngId)&CountryId=\(countryId)"
        guard let accessToken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken) else { return }
        
        let headers: HTTPHeaders = [Constants.authorization: accessToken]
        let fullUrl = WebClass.sharedInstance.webUrl + url
        
        guard let urlStringNew = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            return
        }
        
        sessionManager.request(urlStringNew, method: .get, headers: headers).responseJSON { response in
            if self.shouldAbortDueToError(response.response?.statusCode) {
                self.getNotesFromServer()
                return
            }
            
            switch response.result {
            case .success(let value):
                self.handleSuccessResponse(value)
            case .failure(let error):
                print("Error decoding necropsy list: \(error)")
            }
        }
    }
    
    private func shouldAbortDueToError(_ code: Int?) -> Bool {
        let errorCodes = [400, 401, 403, 404, 408, 500, 501, 502, 503, 504]
        return errorCodes.contains(code ?? 0)
    }
    
    private func handleSuccessResponse(_ value: Any) {
        guard let array = value as? NSArray, array.count > 0 else {
            self.getNotesFromServer()
            return
        }
        
        UserDefaults.standard.set("Yes", forKey: "Success")
        CoreDataHandlerTurkey().deleteDataWithStep2dataTurkey(postingId)
        
        for sessionData in array {
            guard let sessionDict = sessionData as? NSDictionary,
                  let sessionId = sessionDict["SessionId"] as? Int,
                  let farms = sessionDict["Farms"] as? NSArray else { continue }
            
            processFarms(farms, sessionId: sessionId)
        }
        
        self.getNotesFromServer()
    }
    
    private func processFarms(_ farms: NSArray, sessionId: Int) {
        for farm in farms {
            guard let farmDict = farm as? NSDictionary,
                  let farmName = farmDict["FarmName"] as? String,
                  let categories = farmDict["Category"] as? NSArray else { continue }
            
            processCategories(categories, farmName: farmName, sessionId: sessionId)
        }
    }
    
    private func processCategories(_ categories: NSArray, farmName: String, sessionId: Int) {
        for category in categories {
            guard let catDict = category as? NSDictionary,
                  let catName = catDict["Category"] as? String,
                  let observations = catDict["Observations"] as? NSArray else { continue }
            
            processObservations(observations, categoryName: catName, farmName: farmName, sessionId: sessionId)
        }
    }
    
    private func processObservations(_ observations: NSArray, categoryName: String, farmName: String, sessionId: Int) {
        for obs in observations {
            guard let obsDict = obs as? NSDictionary,
                  let obsId = obsDict["ObservationId"] as? Int,
                  let refId = obsDict["ReferenceId"] as? NSNumber,
                  let languageId = obsDict["LanguageId"] as? NSNumber,
                  let obsName = obsDict["Observations"] as? String,
                  let measure = obsDict["Measure"] as? String,
                  let quickLink = obsDict["DefaultQLink"],
                  let birdsArray = (obsDict["Birds"] as? NSArray)?.firstObject as? NSDictionary else { continue }
            
            for i in 0..<10 {
                let key = "BirdNumber\(i + 1)"
                guard let birdValue = birdsArray[key] as? String, birdValue != "NA" else { break }
                
                let visible = ((birdsArray[key] as AnyObject).boolValue)!
                let score = ((birdsArray[key] as AnyObject).integerValue)!
                let mappedCategory = mapCategory(catName: categoryName)
                
                let data = CoreDataHandlerTurkeyModels.singleNecroSwithCaseData(
                    catName: mappedCategory,
                    obsName: obsName,
                    formName: farmName,
                    obsVisibility: visible,
                    birdNo: NSNumber(value: i + 1),
                    obsPoint: score,
                    index: i,
                    obsId: obsId,
                    measure: measure,
                    quickLink: (quickLink as AnyObject).integerValue as NSNumber,
                    necId: NSNumber(value: sessionId),
                    isSync: false,
                    necIdSingle: self.postingId,
                    lngId: languageId,
                    refId: refId
                )
                
                CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseSingleDataTurkey(data: data)
            }
        }
    }
    
    private func mapCategory(catName: String) -> String {
        switch catName {
        case "Microscopy": return "Coccidiosis"
        case "GI Tract": return "GITract"
        case "Immune/Others": return "Immune"
        case "Respiratory": return "Resp"
        case "Skeletal/Muscular/Integumentary": return "skeltaMuscular"
        default: return catName
        }
    }
    
    // MARK: - 💾 🖼️ Set Notes Data into Database
    fileprivate func saveNotesData(_ value: Any) {
        let arr : NSArray = value as! NSArray
        if arr.count>0 {
            CoreDataHandlerTurkey().deleteDataBirdNotesWithIdTurkey(self.postingId)
            
            UserDefaults.standard.set("Yes", forKey: "Success")
            for i in 0..<arr.count {
                
                let noteArr = (arr.object(at: i) as AnyObject).value(forKey:"Note")
                
                if (noteArr as AnyObject).count>0 {
                    for  j in 0..<(noteArr! as AnyObject).count {
                        let sessionId =  ((noteArr as AnyObject).object(at: j) as AnyObject).value(forKey: "sessionId") as! Int
                        let farmName =  ((noteArr as AnyObject).object(at: j) as AnyObject).value(forKey:"farmName") as! String
                        let birdNo =  ((noteArr as AnyObject).object(at: j) as AnyObject).value(forKey: "birdNumber") as! Int
                        let birdNotes = ((noteArr as AnyObject).object(at: j) as AnyObject).value(forKey: "Notes")
                        as! String
                        
                        let turkeyNote = CoreDataHandlerTurkeyModels.saveTurkeyNoteData (
                            catName: "",
                            notes: birdNotes,
                            formName: farmName,
                            birdNo: birdNo as NSNumber,
                            necId: sessionId as NSNumber,
                            isSync: false,
                            necIdSingle: self.postingId
                        )
                        
                        CoreDataHandlerTurkey().saveNoofBirdWithNotesSingledataTurkey(turkeyNote)
                    }
                }
            }
            self.getPostingDataFromServerforImage()
            
        } else {
            self.getPostingDataFromServerforImage()
        }
    }
    
    fileprivate func saveTurkeyNotesAndGetImages(_ value: Any) {
        if value != nil {
            if value is NSArray{
                self.saveNotesData(value)
            }
            else{
                self.getPostingDataFromServerforImage()
            }
        }
    }
    // MARK: - ☁️📝 Fetch Notes from Server
    func getNotesFromServer(){
        if WebClass.sharedInstance.connected() {
            let url = "PostingSession/GetBirdNotesListBySessionId?DeviceSessionId=\(fullData)"
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict: HTTPHeaders = [Constants.authorization:accestoken]
            let urlString: String = WebClass.sharedInstance.webUrl + url
            
            guard let notesUrlStringNew = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(notesUrlStringNew, method: .get, headers: headerDict).responseJSON { response in
                
                let statusCode =  response.response?.statusCode
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    self.getPostingDataFromServerforImage()
                }
                switch response.result {
                case let .success(value):
                    
                    self.saveTurkeyNotesAndGetImages(value)
                case .failure(let encodingError):
                    Helper.dismissGlobalHUD(self.view)
                    print (encodingError)
                }
            }
        } else{
            self.noInternetConnection()
            Helper.dismissGlobalHUD(self.view)
        }
    }
    // MARK: - 💾 🖼️ Set Images Data in Database
    fileprivate func saveImagesDatainDataBase(_ value: Any, _ statusCode: Int?) {
        UserDefaults.standard.set("Yes", forKey: "Success")
        let arr : NSArray = value as! NSArray
        if arr.count>0{
            CoreDataHandlerTurkey().deleteImageForSingleTurkey(self.postingId)
            
            for  i in 0..<arr.count {
                let imagArr = (arr.object(at: i) as AnyObject).value(forKey: "Images")
                if  (imagArr as AnyObject).count>0{
                    for  i in 0..<(imagArr! as AnyObject).count {
                        let posDict = (imagArr! as AnyObject).object(at: i)
                        CoreDataHandlerTurkey().getSaveImageFromServerSingledataTurkey(posDict as! NSDictionary,necIdSingle: self.postingId)
                    }
                    
                }
            }
            
            self.appDelegate.saveContext()
            self.fetcFarmData()
            self.tblView.reloadData()
            if  UserDefaults.standard.string(forKey: "Success") == "Yes"
            {
                self.alerViewSucees()
            }
            else
            {
                self.alerView(statusCode:statusCode!)
            }
            Helper.dismissGlobalHUD(self.view)
        }
    }
  
    fileprivate func setImagesDataInDB(_ value: Any, _ statusCode: Int?) {
        if value != nil {
            if value is NSArray{
                self.saveImagesDatainDataBase(value, statusCode)
            }
            else{
                Helper.dismissGlobalHUD(self.view)
            }
        }
    }
    // MARK: - ☁️🖼️ Fetch Posted Data of Images from Server.
    func getPostingDataFromServerforImage(){
        if WebClass.sharedInstance.connected() {
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            let headerDict: HTTPHeaders = [Constants.authorization:accestoken]
            let url = "PostingSession/GetBirdImagesListBySessionId?DeviceSessionId=\(fullData)"
            let urlString: String = WebClass.sharedInstance.webUrl + url
            guard let imagesUrlStringNew = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return
            }
            
            sessionManager.request(imagesUrlStringNew, method: .get, headers: headerDict).responseJSON { response in
                let statusCode =  response.response?.statusCode
                if statusCode == 500 || statusCode == 401 || statusCode == 503 ||  statusCode == 403 ||  statusCode==501 || statusCode == 502 || statusCode == 400 || statusCode == 504 || statusCode == 404 || statusCode == 408{
                    
                    if  UserDefaults.standard.string(forKey: "Success") == "Yes"
                    {
                        self.alerViewSucees()
                    }
                    else
                    {
                        self.alerView(statusCode:statusCode!)
                    }
                    Helper.dismissGlobalHUD(self.view)
                }
                switch response.result{
                case let .success(value):
                    self.setImagesDataInDB(value, statusCode)
                case .failure(let encodingError):
                    Helper.dismissGlobalHUD(self.view)
                    print (encodingError)
                }
            }
            
        } else{
            self.noInternetConnection()
            Helper.dismissGlobalHUD(self.view)
        }
    }
    
    // MARK: ──────────────────────────────────
    // MARK: ❌🌐 API Failure – Delegate Methods
    func alerView(statusCode:Int) {
        let alertController = UIAlertController(title: "", message: "Unable to get data from server.\n(\(statusCode))", preferredStyle: UIAlertController.Style.alert) //Replace
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
    func failWithErrorSyncdata(statusCode:Int){
        Helper.dismissGlobalHUD(self.view)
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
        }
    }
    
    func failWithErrorInternalSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:" Server error please try again .")
    }
    
    func failWithInternetSyncdata(){
        Helper.dismissGlobalHUD(self.view)
    }
    
    func startLoader()
    {
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
    }
    
    func didFinishApiSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    func failWithInternetConnectionSyncdata(){
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
        
    }
    
    func didFailDuringPostApi(message: String) {
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,
                                titleStr: NSLocalizedString(Constants.alertStr, comment: ""),
                                messageStr: message)
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
    
    // MARK: - ──────────────────────────────
    // MARK: Update message alert──────────────────────────────────
    @objc func update() {
        if WebClass.sharedInstance.connected(){
            print(appDelegateObj.testFuntion())
        }
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
        }
    }
    
    // MARK: - ──────────────────────────────
    // MARK: Sync APi call function
    func callSyncApiPostingId(Pid:NSNumber) {
        objApiSyncOneSet.feedprogram(postingId: Pid)
    }
    
    // MARK: - ──────────────────────────────
    // MARK: - 📡 Sync to Device 📲
    @IBAction func reciveButton(_ sender: Any) {
        
        let postingSess = CoreDataHandlerTurkey().checkPostingSessionHasiSyncTrueTurkey(self.postingId, isSync: true)
        let necropcySess = CoreDataHandlerTurkey().checkNecropcySessionHasiSyncTrueTurkey(self.postingId,isSync: true)
        
        if (postingSess == true || necropcySess == true) {
            let alertController = UIAlertController(title: NSLocalizedString("Sync to device", comment: ""), message:"By clicking this button, your session data on the web will be downloaded to your device and override any session data captured on your device. Are you sure you want to perform this action?", preferredStyle: .alert)
            
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
    // MARK: - 🐄──────────────────────────────
    // MARK: - 🚜 Update Farm (IBAction)
    @IBAction func editFarmNameTable(_ sender: UIButton) {
        showUpdateView(sender: sender.tag)
    }
    
    // MARK: - 🦃──────────────────────────────
    // MARK: IBAction → 💉 Vaccination Button Action.
    @IBAction func vaccinationBtnAction(_ sender: UIButton) {
        let navigateController = self.storyboard?.instantiateViewController(withIdentifier: "AddVaccinationTurkey") as? AddVaccinationTurkey
        navigateController?.postingIdFromExisting = postingId as NSNumber
        navigateController?.finalizeValue = finilizeValue
        navigateController?.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(navigateController!, animated: false)
    }
    
    // MARK: - 🌐 ──────────────────────────────
    // MARK: IBAction → Sync to Web Button Action.
    @IBAction func syncToWebAction(_ sender: UIButton) {
        
        if self.allSessionArrWithPostingId(PId: postingId).count > 0 {
            if WebClass.sharedInstance.connected()  == true{
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                self.callSyncApiPostingId(Pid: postingId)
            } else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(offlineDataMsg, comment: ""))
            }
        } else {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    
  
    // MARK: - ✅ ──────────────────────────────
    // MARK: IBAction → Finalize 🦃 Session
    
    @IBAction func finalizeBtnAction(_ sender: UIButton) {
        Constants.isFromPsotingTurkey = true
        UserDefaults.standard.setValue(true, forKey: "postingTurkey")
        UserDefaults.standard.synchronize()
        CoreDataHandlerTurkey().updateFinalizeDataTurkey(self.postingId, finalize: 1,isSync:true)
        let navigateController = self.storyboard?.instantiateViewController(withIdentifier: "ExistingTurkey") as? ExistingPostingSessionTurkey
        self.navigationController?.pushViewController(navigateController!, animated: false)
    }
    
    // MARK: - 🦃──────────────────────────────
    // MARK: IBAction → 🦃🌾  Feed Program Button Action
    @IBAction func feedProgramAction(_ sender: UIButton) {
        btnTag = 0
        feedProArrWithId = CoreDataHandlerTurkey().FetchFeedProgramTurkey(postingId).mutableCopy() as! NSMutableArray
        self.tableViewpop()
        droperTableView.frame = CGRect( x: 223, y: 243, width: 300, height: 130)
        droperTableView.reloadData()
    }
    // MARK: - 🦃──────────────────────────────
    // MARK: MARK: - 📋 Popup TableView Setup
    func tableViewpop() {
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg1.addTarget(self, action:#selector(PostingSessionDetailTurkey.buttonPreddDroper), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view.addSubview(buttonbg1)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        buttonbg1.addSubview(droperTableView)
    }
    
    @objc func buttonPreddDroper() {
        buttonbg1.removeFromSuperview()
    }
    
    // MARK: - 🌾──────────────────────────────
    // MARK: Fetch Farm Data
    func fetcFarmData()  {
        self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId) as! [NSManagedObject]
        farmArray.removeAllObjects()
        for object in captureNecropsy {
            
            let dictDat = NSMutableDictionary ()
            dictDat.setObject(object.value(forKey: "farmName")!, forKey: "farmName" as NSCopying)
            dictDat.setObject(object.value(forKey: "noOfBirds")!, forKey: "noOfBirds" as NSCopying)
            dictDat.setObject(object.value(forKey: "houseNo")!, forKey: "houseNo" as NSCopying)
            dictDat.setObject(object.value(forKey: "age")!, forKey: "age" as NSCopying)
            dictDat.setObject(object.value(forKey: "necropsyId")!, forKey: "necropsyId" as NSCopying)
            dictDat.setObject(object.value(forKey: "timeStamp")!, forKey: "timeStamp" as NSCopying)
            dictDat.setObject(object.value(forKey: "feedProgram")!, forKey: "feedProgram" as NSCopying)
            dictDat.setObject(object.value(forKey: "abf")!, forKey: "abf" as NSCopying)
            dictDat.setObject(object.value(forKey: "flockId")!, forKey: "flockId" as NSCopying)
            dictDat.setObject(object.value(forKey: "breed")!, forKey: "breed" as NSCopying)
            dictDat.setObject(object.value(forKey: "sex")!, forKey: "sex" as NSCopying)
            dictDat.setObject(object.value(forKey: "sick")!, forKey: "sick" as NSCopying)
            dictDat.setObject(object.value(forKey: "farmWeight")!, forKey: "farmWeight" as NSCopying)
            dictDat.setObject(object.value(forKey: "generName")!, forKey: "generName" as NSCopying)
            dictDat.setObject(object.value(forKey: "generID")!, forKey: "generID" as NSCopying)
            farmArray.add(dictDat)
        }
    }
    
    // MARK: ──────────────────────────────────
    // MARK:  🖼️ IBAction: Image Click
    @objc func clickImage(_ sender: UIButton) {
        let formname = (farmArray.object(at: sender.tag) as AnyObject).value(forKey: "farmName") as? String
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "imageTurkey") as? ImageViewTurkeyController
        mapViewControllerObj!.farmname = formname!
        mapViewControllerObj!.necId = ((farmArray.object(at: sender.tag) as AnyObject).value(forKey: "necropsyId") as? Int)!
        mapViewControllerObj!.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
    }
}
// MARK: - EXTENSION
// MARK: - 🛠️ Extension: Utility Methods
extension PostingSessionDetailTurkey: UITableViewDataSource,UITableViewDelegate {
    // MARK: - 📋──────────────────────────────
    // MARK: 📋🌾 Farm Names TableView (DataSource & Delegate)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == droperTableView {
            if btnTag == 1001
            {
                return birdSexArray.count
            }
            else
            {
                return feedProArrWithId.count
            }
        }
        return farmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == droperTableView {
            let cell = UITableViewCell ()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if btnTag == 1001
            {
                cell.textLabel?.text = birdSexArray[indexPath.row] as? String
            }
            else
            {
                let feedProgram : FeedProgramTurkey = feedProArrWithId.object(at: indexPath.row) as! FeedProgramTurkey
                cell.textLabel!.text = feedProgram.feddProgramNam
                cell.tag = feedProgram.feedId as! Int
            }
            return cell
            
        } else {
            
            let cell:PostingSessionDetailCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostingSessionDetailCell
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
            }
            
            let farmArrayWithoutAge = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "farmName") as? String
            let age = ((farmArray as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey:"age") as! String
            let farmNamevalue =  farmArrayWithoutAge!  + " " + "[" + age + "]"
            var farmName2 = String()
            let range = farmNamevalue.range(of: ".")
            if range != nil{
                let abc = String(farmNamevalue[range!.upperBound...]) as NSString
                farmName2 = String(indexPath.row+1) + "." + " " + String(describing:abc)
            }
            
            cell.farmNameLbl.text = farmName2
            cell.updateButton.layer.borderWidth = 8.0
            cell.updateButton.layer.cornerRadius = 17.5
            cell.updateButton.layer.borderColor = UIColor.clear.cgColor
            cell.updateButton.tag = indexPath.row
            cell.houseNoLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "houseNo") as? String
            cell.noOfBirdsLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "noOfBirds") as? String
            let abfLbl = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "abf") as? String
            
            if abfLbl == "Conventional" {
                cell.abfLbl.text = "C"
            } else if abfLbl == "Antibiotic free" {
                cell.abfLbl.text = "A"
            } else if abfLbl == appDelegateObj.selectStr {
                cell.abfLbl.text = ""
            }
            cell.feedProgramLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "feedProgram") as? String
            let flockId = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "flockId") as? String
            var truncated1 = String()
            let count1 = flockId?.count
            
            if count1 == 1 && flockId?.first == "0"{
                truncated1 = ""
            } else {
                truncated1 = flockId!
            }
            
            cell.flockIdLbl.text = truncated1
            cell.breedLbl.text = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "breed") as? String
            if let dict = farmArray.object(at: indexPath.row) as? [String: Any],
               let sexValue = dict["sex"] as? String {
                
                let mapping: [String: String] = [
                    "H": "HH",
                    "HH": "HH",
                    "L": "LH",
                    "LH": "LH",
                    "T": "T"
                ]
                
                cell.sexLbl.text = mapping[sexValue] ?? sexValue
            } else {
                cell.sexLbl.text = ""
            }
            
            let nameOfGeneration =  (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "generName") as? String
            if nameOfGeneration == ""
            {
                cell.genLbl.text = "N/A"
            }
            else{
                cell.genLbl.text = nameOfGeneration
            }
            let sick = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "sick") as! Int
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(PostingSessionDetailTurkey.ClickDeleteBtton(_:)), for: .touchUpInside)
            if sick == 0 {
                cell.sickLbl.text = NSLocalizedString(Constants.noStr, comment: "")
            } else if sick == 1 {
                cell.sickLbl.text = NSLocalizedString("Yes", comment: "")
            }
            let farmWeight = (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "farmWeight") as? String
            var truncated = String()
            let lastVarble = farmWeight?.last
            let count = farmWeight?.count
            if count == 1 && farmWeight?.first == "."{
                truncated = ""
            }
            else if lastVarble == "." {
                truncated = (farmWeight?.substring(to: (farmWeight?.index(before: (farmWeight?.endIndex)!))!))!
                
            } else {
                truncated = farmWeight!
            }
            cell.farmWeightLbl.text = truncated
            camraImgeArr = CoreDataHandlerTurkey().fecthPhotoWithFormNameTurkey(farmArrayWithoutAge!,necId: (((farmArray.object(at: indexPath.row)) as AnyObject).value(forKey: "necropsyId") as? NSNumber)!
            )
            
            if camraImgeArr.count<1{
                cell.badgeButton.isEnabled = false
            }
            else {
                cell.badgeButton.isEnabled = true
            }
            cell.backgroundColor = UIColor.clear
            cell.badgeButton.alpha = 1
            cell.badgeButton.badgeString = String(camraImgeArr.count) as String
            cell.badgeButton.badgeTextColor = UIColor.white
            cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
            cell.badgeButton.addTarget(self, action: #selector(PostingSessionDetailTurkey.clickImage(_:)), for: .touchUpInside)
            cell.badgeButton.tag = indexPath.row
            
            if finilizeValue == 1{
                cell.badgeButton.setImage(UIImage(named: "galaryBlue"), for: UIControl.State())
                cell.deleteButton.isUserInteractionEnabled = false
                cell.deleteButton.isHidden = true
            } else {
                cell.badgeButton.setImage(UIImage(named: "galary"), for: UIControl.State())
                cell.deleteButton.isUserInteractionEnabled = true
                cell.deleteButton.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == droperTableView {
            
            if btnTag == 1 {
                let feedProgram = feedProArrWithId.object(at: indexPath.row) as! FeedProgramTurkey
                strFeddUpdate = feedProgram.feddProgramNam!
                feedIdUpdate = feedProgram.feedId!
                feedButton.setTitle(feedProgram.feddProgramNam!, for: .normal)
                CoreDataHandlerTurkey().updatedPostigSessionwithIsFarmSyncPostingIdTurkey(self.postingId, isFarmSync: false)
                
            } else if btnTag == 1001 {
                CoreDataHandlerTurkey().updatedPostigSessionwithIsFarmSyncPostingIdTurkey(self.postingId, isFarmSync: false)
                let selectedSex = birdSexArray[indexPath.row] as! String
                
                let sexCode: String
                switch selectedSex {
                case "Light hens": sexCode = "LH"
                case "Heavy hens": sexCode = "HH"
                case "Toms":       sexCode = "T"
                default:           sexCode = "LH"
                }
                sexLbl.text = sexCode
                sexButton.setTitle(selectedSex, for: .normal)
                
            } else {
                let feedProgram = feedProArrWithId.object(at: indexPath.row) as! FeedProgramTurkey
                let navigateToController = self.storyboard?.instantiateViewController(withIdentifier: "FeedProgramVcTurkey") as? FeedProgramVcTurkey
                navigateToController!.postingIdFromExisting = postingId as! Int
                navigateToController!.FeedIdFromExisting = feedProgram.feedId as! Int
                navigateToController!.finializeCount = finilizeValue
                navigateToController?.postingIdFromExistingNavigate = "Exting"
                self.navigationController?.pushViewController(navigateToController!, animated: false)
                feedProgramLbl.text = feedProgram.feddProgramNam
            }
            self.buttonPreddDroper()
        }
        else {
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "CaptureNecroStep2Turkey") as? CaptureNecroStep2Turkey
            mapViewControllerObj?.editFinalizeValue = editFinalizeValue as! Int
            let necIdFromExist =  (farmArray.object(at: indexPath.row) as AnyObject).value(forKey: "necropsyId") as? Int
            mapViewControllerObj?.postingIdFromExisting = necIdFromExist!
            mapViewControllerObj?.nsIndexPathFromExist = indexPath.row
            mapViewControllerObj?.postingIdFromExistingNavigate = "Exting"
            mapViewControllerObj!.finalizeValue = finilizeValue as! Int
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
    }
    // MARK: ──────────────────────────────────
    // MARK: 🗑️❌ Delete Button – Action
    @objc func ClickDeleteBtton(_ sender: UIButton){
        
        let indexpath = NSIndexPath(row:sender.tag, section: 0)
        let cell = self.tblView.cellForRow(at: indexpath as IndexPath) as? PostingSessionDetailCell
        cell?.backgroundColor = UIColor.gray
        if farmArray.count == 1{
            let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: NSLocalizedString("You can not delete all farms. One farm is mandatory for this session.", comment: ""), preferredStyle: .alert)
            let action1 = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
                print("Default is pressed.....")
                cell?.backgroundColor = UIColor.clear
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let farmArrayWithoutAge = (farmArray.object(at: sender.tag) as AnyObject).value(forKey: "farmName") as? String
            let necId =  ((farmArray.object(at: sender.tag) as AnyObject).value(forKey: "necropsyId") as? Int)!
            let dataArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationWithDeleteTurkey(farmname: farmArrayWithoutAge!, necId: necId as NSNumber)
            if dataArr.count > 0{
                for i in 0..<dataArr.count{
                    
                    let obspoint = (dataArr.object(at: i) as AnyObject).value(forKey: "obsPoint") as! Int
                    let obsVal = (dataArr.object(at: i) as AnyObject).value(forKey: "objsVisibilty") as! Int
                    
                    if obspoint > 0 || obsVal > 0{
                        strMsgforDelete = "Are you sure you want to delete this farm? You have observation recorded for this farm."
                        break
                    }
                    else{
                        strMsgforDelete = "Are you sure you want to delete this farm?"
                    }
                }
            }
            else{
                strMsgforDelete = "Are you sure you want to delete this farm?"
            }
            
            let alertController = UIAlertController(title: Constants.alertStr, message: strMsgforDelete, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                CoreDataHandlerTurkey().deleteDataWithPostingIdStep1dataWithfarmNameTurkey(necId as NSNumber, farmName: farmArrayWithoutAge!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdStep2dataCaptureNecViewWithfarmNameTurkey(necId as NSNumber, farmName: farmArrayWithoutAge!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdStep2NotesBirdWithFarmNameTurkey(necId as NSNumber, farmName: farmArrayWithoutAge!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdStep2CameraIamgeWithFarmNameTurkey(necId as NSNumber, farmName: farmArrayWithoutAge!)
                self.appDelegate.saveContext()
                self.fetcFarmData()
                self.tblView.reloadData()
                
            }
            let action2 = UIAlertAction(title: Constants.noStr, style: .cancel) { (action) in
                
                cell?.backgroundColor = UIColor.clear
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: 🌾➕ Add Feed – IBAction
    @IBAction func addFeedButtonAction(_ sender: AnyObject) {
        let navigateToController = self.storyboard?.instantiateViewController(withIdentifier: "FeedProgramVcTurkey") as? FeedProgramVcTurkey
        navigateToController!.postingIdFromExisting = postingId as! Int
        navigateToController!.finializeCount = 0 // finilizeValue
        navigateToController!.addfeed = "addfeed"
        navigateToController?.postingIdFromExistingNavigate = "Exting"
        self.navigationController?.pushViewController(navigateToController!, animated: false)
    }
}



//  CaptureNecroStep2Turkey.swift
//  Zoetis -Feathers
//  Created by Manish Behl on 20/03/18.
//  Copyright © 2018 . All rights reserved.

import UIKit
import CoreData
import Gigya
import GigyaTfa
import GigyaAuth




class CaptureNecroStep2Turkey: BaseViewController,AddFarmPopTurkey,summmaryReportTUR, UICollectionViewDelegate,UICollectionViewDataSource,  UIImagePickerControllerDelegate,turkeyNotes, UINavigationControllerDelegate ,UIScrollViewDelegate,UITextFieldDelegate,refreshPageafterAddFeedTurkey,infoLinkkTurkey, UITableViewDelegate, UITableViewDataSource {
    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    // MARK: - VARIABLES
    var notesView : NotesTurkey!
    var backBttnn = UIButton()
    var arrayAddBirds  = NSMutableArray()
    var incremnet :Int = 5
    var button = UIButton()
    var ButtonList = NSMutableArray()
    var summaryRepo :summaryReportTurkey!
    var mesureValue: String = ""
    var incrementValue  = 0
    let buttonbg = UIButton ()
    var customPopVi :UserListView!
    var photoDict = NSMutableDictionary()
    var bitdImageIndexPath  = IndexPath ()
    var nsIndexPathFromExist = Int()
    var necIdFromExist  = Int()
    var notesBGbtn = UIButton()
    var lngId = NSInteger()
    var weight : String = ""
    var lastSelectedIndex: IndexPath?
    var bursaSelectedIndex :IndexPath?
    var arrSwichUpdate  = NSArray()
    var captureNecropsy = [NSManagedObject]()
    var buttonPopup = UIButton ()
    let buttonDroper = UIButton ()
    var btnTag = Int()
    var finalizeValue = Int()
    var isFirstTimeLaunch = Bool()
    
    var customPopView1 :SimpleCustomViewTurkey!
    var isFarmClick = Bool()
    var isNewFarm = Bool()
    var isBirdClick = Bool()
    var farmRow = Int()
    var tableViewSelectedRow = Int()
    var buttonback = UIButton()
    fileprivate var currentTextField: UITextField?
    var totalProfileArray:[CaptureNecropsyCollectionViewCellModel]!
    var editFinalizeValue = Int()
    var postingIdFromExisting = Int()
    var postingIdFromExistingNavigate = String()
    /********************* Creating SeprateArray For Showing Different Data ****************************************/
    var itemsData: NSMutableArray = NSMutableArray()
    var dataSkeltaArray: NSMutableArray = NSMutableArray()
    var dataArrayCocoi: NSMutableArray = NSMutableArray()
    var dataArrayGiTract: NSMutableArray = NSMutableArray()
    var dataArrayRes: NSMutableArray = NSMutableArray()
    var dataArrayImmu: NSMutableArray = NSMutableArray()
    var noOfBirdsArr = NSMutableArray()
    var captureNecdataSkeletaArray = NSArray ()
    var items = NSMutableArray ()
    var farmArray = NSMutableArray ()
    var categoryArray = NSMutableArray ()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var activityView = UIActivityIndicatorView ()
    var activityIndicator = UIActivityIndicatorView()
    var boxView = UIView()
    var noOfBirdsArr1  = NSMutableArray()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var ageArray = NSMutableArray()
    var houseArray = NSMutableArray()
    var customPopV :AddFarmTurkey!
    
    // MARK: - OUTLETS
    @IBOutlet weak var syncNotiCount: UILabel!
    @IBOutlet weak var lblCustmer: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var customerDisplayLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var increaseBirdBtn: UIButton!
    @objc var traingleImageView: UIImageView!
    @IBOutlet weak var decBirdNumberBtn: UIButton!
    @IBOutlet weak var addFormBtn: UIButton!
    @IBOutlet weak var helpPopView: UIView!
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var btnPopUp:    UIButton!
    @IBOutlet weak var btnForm: UIButton!
    @IBOutlet var longPressGestureOutlet: UILongPressGestureRecognizer!
    @IBOutlet weak var formCollectionView: UICollectionView!
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    @IBOutlet weak var MypickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var neccollectionView: UICollectionView!
    @IBOutlet weak var addBirdsScrollView: UIScrollView!
    var observationImageFrameTemp:CGRect?
    
    var turkeyBirdSex = NSArray ()
    var selectedSexValue: String = "N/A"
    var noGrossLesionStr = "No gross lesions."
    var oneBirdRequiredStr = "At least one bird is required under a Farm."
    var selectedFarmIndexTurkey = Int()
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        turkeyBirdSex = ["Male", "Female" , "N/A"]
        
        isFirstTimeLaunch = true
        
        if postingIdFromExistingNavigate == "Exting"{
            increaseBirdBtn.alpha = 1
            decBirdNumberBtn.alpha = 1
            addFormBtn.alpha = 1
        }
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            customerDisplayLbl.isHidden = true
            lblCustmer.isHidden = true
            
        } else {
            customerDisplayLbl.isHidden = false
            lblCustmer.isHidden = false
        }
        
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
        loaderView.alpha = 1
        self.callFirstMethodToLoadView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.printSyncLblCount()
        UserDefaults.standard.set(finalizeValue, forKey: "finalizeValue")
        UserDefaults.standard.synchronize()
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        isNewFarm = false
        isBirdClick = false
        let isQuickLink : Bool = UserDefaults.standard.bool(forKey: "isQuickLink")
        if isQuickLink == true {
            
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
            self.perform(#selector(CaptureNecroStep2Turkey.loadformdata), with: nil, afterDelay:0)
            self.traingleImageView.frame = CGRect(x: 276, y: 229, width: 24, height: 24)
            
            let isQuickLink : Bool = false
            UserDefaults.standard.set(isQuickLink, forKey: "isQuickLink")
            UserDefaults.standard.synchronize()
        }
    }
    // MARK: - METHODS AND FUNCTIONS
    fileprivate func reloadAllCollectionViews() {
        if self.dataSkeltaArray.count > 0
        {
            self.neccollectionView.dataSource = self
            self.neccollectionView.delegate = self
            self.neccollectionView.reloadData()
        }
        if self.farmArray.count > 0
        {
            self.formCollectionView.dataSource = self
            self.formCollectionView.delegate = self
            self.formCollectionView.reloadData()
            
            if self.postingIdFromExistingNavigate == "Exting"{
                self.formCollectionView.selectItem(at: IndexPath(item: self.nsIndexPathFromExist, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            }
            else{
                self.formCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            }
        }
        
        if self.items.count > 0
        {
            self.birdsCollectionView.dataSource = self
            self.birdsCollectionView.delegate = self
            self.birdsCollectionView.reloadData()
            self.birdsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        }
        
        self.tableView.reloadData()
        let rowToSelect:IndexPath = IndexPath(row: 0, section: 0)
        
        self.tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        self.loaderView.alpha = 0
        Helper.dismissGlobalHUD(self.view)
    }
    // MARK: 💾 - Save Immune Category Data
    fileprivate func saveGITrectImmuneData() {
        self.saveGiTractCat({ (status) in
            
            if status == true
            {
                self.saveImmuneCat({ (status) in
                    
                    if status == true
                    {
                        reloadAllCollectionViews()
                        
                    }
                })
            }
        })
    }
    // MARK: ⚕️💾 Save GI-Tract Category Data
    fileprivate func saveImmuneGiTrectData() {
        self.saveResCat({ (status) in
            if status == true
            {
                saveGITrectImmuneData()
            }
        })
    }
    
    // MARK: 🚀 - Initial View Loading
    @objc func callFirstMethodToLoadView() {
        self.callLoad { (status) in
            
            if status == true
            {
                self.saveSkeletonCat{ (status) in
                    if status == true
                    {
                        self.saveCocoiCat(handleSaveCocoiCatCompletion)
                    }
                }
            }
        }
    }
    
    func handleSaveCocoiCatCompletion(status: Bool) {
        if status {
            saveImmuneGiTrectData()
        }
    }
    
    
    func callLoad(_ completion: (_ status: Bool) -> Void){
        tableViewSelectedRow = 0
        UserDefaults.standard.set(0, forKey: "clickindex")
        UserDefaults.standard.synchronize()
        lblDate.text = UserDefaults.standard.value(forKey: "date") as? String
        lblComplex.text = UserDefaults.standard.value(forKey: "complex") as? String
        lblCustmer.text = UserDefaults.standard.value(forKey: "custmer") as? String
        
        isFarmClick = false
        btnTag = 0
        
        if postingIdFromExistingNavigate == "Exting"{
            self.farmRow = nsIndexPathFromExist
            var postingId = postingIdFromExisting
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId as NSNumber) as! [NSManagedObject]
        }
        else{
            self.farmRow = 0
            var postingId = UserDefaults.standard.integer(forKey: "necId") as Int
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(postingId as NSNumber) as! [NSManagedObject]
        }
        
        for object in captureNecropsy {
            let noOfBirds : Int = Int(object.value(forKey: "noOfBirds") as! String)!
            let noOfBirdArr  = NSMutableArray()
            
            var numOfLoop = 0
            
            for i in 0..<noOfBirds
            {
                numOfLoop = i + 1
                
                if numOfLoop > 10
                {
                    debugPrint("birds are more then the expected limit.")
                }
                else
                {
                    noOfBirdArr.add(i+1)
                }
            }
            items.add(noOfBirdArr)
            farmArray.add(object.value(forKey: "farmName")!)
            ageArray.add(object.value(forKey: "age")!)
            houseArray.add(object.value(forKey: "houseNo")!)
            
        }
        categoryArray = [NSLocalizedString("Skeletal/Muscular/Integumentary", comment: ""), NSLocalizedString("Microscopy", comment: ""), NSLocalizedString("GI Tract", comment: ""),NSLocalizedString("Respiratory", comment: ""), NSLocalizedString("Immune/Others", comment: "")]
        
        self.addBirdInNotes()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        imagePicker.delegate = self
        incrementValue = 0
        completion (true)
        
    }
    // MARK: - 📝 Save/Update Turkey Birds Notes
    fileprivate func saveUpdateTurkeyBirdsNotes(_ isNotes: NSArray, _ necId: Int, _ catArr: NSArray, _ i: Int, _ j: Int, _ x: Int) {
        if isNotes.count > 0 {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            
            CoreDataHandlerTurkey().updateNoofBirdWithNotesTurkey(note.catName!,  formName: note.formName!, birdNo: note.noofBirds!,notes:note.notes! ,necId: necId as NSNumber,isSync :true)
        } else {
            
            CoreDataHandlerTurkey().saveNoofBirdWithNotesTurkey(catArr[i] as! String, notes: "", formName: farmArray[j] as! String, birdNo: (items.object(at: j) as AnyObject).object(at: x) as! NSNumber, index: x , necId: necId as NSNumber, isSync :true)
        }
    }
    // MARK: - 🦃📝 Add Bird in Notes
    func addBirdInNotes() {
        if isFirstTimeLaunch == false {
            isFirstTimeLaunch = false
        }
        let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
        for i in 0..<catArr.count {
            for j in 0..<farmArray.count {
                for x in 0..<(items[j] as AnyObject).count
                {
                    let numOfBird = Int((items.object(at: j) as AnyObject).object(at: x) as! NSNumber) as Int
                    var  necId = Int()
                    if postingIdFromExistingNavigate == "Exting"{
                        
                        necId = postingIdFromExisting
                    }  else {
                        necId = UserDefaults.standard.integer(forKey: "necId") as Int
                    }
                    
                    let isNotes =  CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catArr[i] as! String, formName: farmArray[j] as! String, birdNo: numOfBird as NSNumber , necId: necId as NSNumber)
                    
                    saveUpdateTurkeyBirdsNotes(isNotes, necId, catArr, i, j, x)
                }
            }
        }
    }
    // MARK: - 🦴 Handle Skeleton Case
    fileprivate func handleSkeletonArrElse(_ skleta: SkeletaTurkey, _ i: Int, _ birdnumber: Any, _ j: Int, _ necId: Int) {
        
        if skleta.measure == "Y,N" || skleta.measure == "Actual" {
            let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "skeltaMuscular",
                obsName: skleta.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
        else
        {
            let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let array = (trimmed.components(separatedBy: ",") as [String])
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "skeltaMuscular",
                obsName: skleta.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
    
    fileprivate func handleSkeletonArr(_ skeletenArr: NSMutableArray, _ birdnumber: Any, _ i: Int, _ necId: Int) {
        for j in 0..<skeletenArr.count {
            
            if ((skeletenArr.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                
                let skleta : SkeletaTurkey = skeletenArr.object(at: j) as! SkeletaTurkey
                
                let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(birdnumber as! NSNumber, farmname: farmArray[i] as! String, catName: "skeltaMuscular",Obsid: skleta.observationId!,necId : necId as NSNumber)
                if FetchObsArr.count > 0 {
                    debugPrint("No obs for Skeleton")
                } else {
                    
                    handleSkeletonArrElse(skleta, i, birdnumber, j, necId)
                }
            }
            else {
                let skleta : SkeletaTurkey = skeletenArr.object(at: j) as! SkeletaTurkey
                CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithObsIDTurkey(skleta.observationId!,necId: necId as NSNumber)
                
            }
        }
    }
    // MARK: - 🦴💾 Save Skeleton Category Data
    func saveSkeletonCat(_ completion: (_ status: Bool) -> Void) {
        let farm = farmArray.object(at: nsIndexPathFromExist)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        
        let bird = (items.object(at: 0) as AnyObject).object(at: 0)
        UserDefaults.standard.set(bird, forKey: "bird")
        UserDefaults.standard.synchronize()
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let skeletenArr =   CoreDataHandlerTurkey().fetchAllSeettingdataWithLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        var  necId = Int()
        
        if postingIdFromExistingNavigate == "Exting" {
            necId = postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        for i in 0..<farmArray.count {
            for x in 0..<(items[i] as AnyObject).count {
                let birdnumber = (items.object(at: i) as AnyObject).object(at: x)
                
                handleSkeletonArr(skeletenArr, birdnumber, i, necId)
            }
        }
        dataSkeltaArray = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird as! NSNumber, farmname: farm as! String, catName: "skeltaMuscular",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
    }
    // MARK: - 🦠📊 Handle Fetch Observation Array Count Validation for Coccidiosis
    fileprivate func handleFetchObsArrCountValidationCocooi(_ cocoiDis: CoccidiosisTurkey, _ i: Int, _ birdnumber: Any, _ j: Int, _ necId: Int) {
        if cocoiDis.measure! == "Y,N"  || cocoiDis.measure == "Actual" {
            let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "Coccidiosis",
                obsName: cocoiDis.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
        } else {
            let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let array = (trimmed.components(separatedBy: ",") as [String])
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "Coccidiosis",
                obsName: cocoiDis.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
    // MARK: - 🦠📊 Handle Coccidiosis Array Count
    fileprivate func handleCocooiArrCount(_ cocoii: NSMutableArray, _ birdnumber: Any, _ i: Int, _ necId: Int) {
        for  j in 0..<cocoii.count {
            if ((cocoii.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                let cocoiDis : CoccidiosisTurkey = cocoii.object(at: j) as! CoccidiosisTurkey
                
                let FetchObsArr =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(birdnumber as! NSNumber, farmname: farmArray[i] as! String, catName: "Coccidiosis" ,Obsid: cocoiDis.observationId!,necId:necId as NSNumber)
                if FetchObsArr.count > 0 {
                    debugPrint("coccdiosis obs are available")
                } else {
                    handleFetchObsArrCountValidationCocooi(cocoiDis, i, birdnumber, j, necId)
                }
            } else {
                let cocoiDis : CoccidiosisTurkey = cocoii.object(at: j) as! CoccidiosisTurkey
                CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithObsIDTurkey(cocoiDis.observationId!, necId: necId as NSNumber)
            }
        }
    }
    // MARK: - 🦠 💾 Save Coccidiosis Category Data
    func saveCocoiCat(_ completion: (_ status: Bool) -> Void) {
        let farm = farmArray.object(at: nsIndexPathFromExist)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        let bird = (items.object(at: 0) as AnyObject).object(at: 0)
        UserDefaults.standard.set(bird, forKey: "bird")
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let cocoii = CoreDataHandlerTurkey().fetchAllCocoiiDataUsinglngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        var  necId = Int()
        
        if postingIdFromExistingNavigate == "Exting"{
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        for i in 0..<farmArray.count {
            for x in 0..<(items[i] as AnyObject).count {
                let birdnumber = (items.object(at: i) as AnyObject).object(at: x)
                handleCocooiArrCount(cocoii, birdnumber, i, necId)
            }
        }
        
        dataArrayCocoi = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird as! NSNumber, farmname: farm as! String, catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        completion (true)
    }
    // MARK: - ⚕️📊 Handle Fetch Observation Array Count for GI Tract
    fileprivate func handleFetchObsArrCountGreatThanZeroGITrack(_ gitract: GITractTurkey, _ i: Int, _ birdnumber: Any, _ j: Int, _ necId: Int) {
        if gitract.measure! == "Y,N" {
            let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if gitract.observationField == "Feed in Crop"{
                
                let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                    catName: "GITract",
                    obsName: gitract.observationField!,
                    formName: farmArray[i] as! String,
                    obsVisibility: true,
                    birdNo: birdnumber as! NSNumber,
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
                    formName: farmArray[i] as! String,
                    obsVisibility: false,
                    birdNo: birdnumber as! NSNumber,
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
        else if ( gitract.measure! == "Actual"){
            let trimmed = gitract.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "GITract",
                obsName: gitract.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
    // MARK: - ⚕️ Handle GI Tract Array
    fileprivate func handleGITrackArr(_ gitract: NSMutableArray, _ birdnumber: Any, _ i: Int, _ necId: Int) {
        for  j in 0..<gitract.count
        {
            if ((gitract.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                
                let gitract : GITractTurkey = gitract.object(at: j) as! GITractTurkey
                
                let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(birdnumber as! NSNumber, farmname: farmArray[i] as! String, catName: "GITract",Obsid: gitract.observationId!,necId: necId as NSNumber)
                if FetchObsArr.count > 0 {
                    debugPrint("GITract obs available")
                } else {
                    handleFetchObsArrCountGreatThanZeroGITrack(gitract, i, birdnumber, j, necId)
                }
            }  else {
                let gitract : GITractTurkey = gitract.object(at: j) as! GITractTurkey
                CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithObsIDTurkey(gitract.observationId!,necId: necId as NSNumber)
            }
        }
    }
    // MARK: - ⚕️ Save GI Tract Category Data
    func saveGiTractCat(_ completion: (_ status: Bool) -> Void) {
        let farm = farmArray.object(at: nsIndexPathFromExist)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        let bird = (items.object(at: 0) as AnyObject).object(at: 0)
        UserDefaults.standard.set(bird, forKey: "bird")
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let gitract =  CoreDataHandlerTurkey().fetchAllGITractDataUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        var  necId = Int()
        
        if postingIdFromExistingNavigate == "Exting" {
            
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        for i in 0..<farmArray.count {
            for x in 0..<(items[i] as AnyObject).count {
                let birdnumber = (items.object(at: i) as AnyObject).object(at: x)
                handleGITrackArr(gitract, birdnumber, i, necId)
            }
        }
        
        dataArrayGiTract = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird as! NSNumber, farmname: farm as! String, catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
        
    }
    
    fileprivate func handleIfFetchObsArrCountGreaterThanZeroRespArr(_ resp: RespiratoryTurkey, _ i: Int, _ birdnumber: Any, _ j: Int, _ necId: Int) {
        if resp.measure! == "Y,N" ||  resp.measure! == "Actual" {
            let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "Resp",
                obsName: resp.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
                obsPoint: 0,
                index: j,
                obsId: Int(resp.observationId!),
                measure: trimmed,
                quickLink: resp.quicklinks!,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngId as NSNumber,
                refId: resp.refId!,
                actualText: resp.measure ?? ""
            )
            
            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
            
        }
        else {
            let trimmed = resp.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let array = (trimmed.components(separatedBy: ",") as [String])
            
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "Resp",
                obsName: resp.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
                obsPoint: Int(array[0])!,
                index: j,
                obsId: Int(resp.observationId!),
                measure: trimmed,
                quickLink: resp.quicklinks!,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngId as NSNumber,
                refId: resp.refId!,
                actualText: resp.measure ?? ""
            )
            
            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
            
        }
    }
    
    fileprivate func handleRespArrLoop(_ resp: NSMutableArray, _ birdnumber: Any, _ i: Int, _ necId: Int) {
        for j in 0..<resp.count {
            if ((resp.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                let resp : RespiratoryTurkey = resp.object(at: j) as! RespiratoryTurkey
                
                let FetchObsArr =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(birdnumber as! NSNumber, farmname: farmArray[i] as! String, catName: "Resp",Obsid: resp.observationId!,necId: necId as NSNumber)
                if FetchObsArr.count > 0 {
                    debugPrint("Respiration Observations.")
                } else {
                    handleIfFetchObsArrCountGreaterThanZeroRespArr(resp, i, birdnumber, j, necId)
                }
            } else {
                let resp : RespiratoryTurkey = resp.object(at: j) as! RespiratoryTurkey
                CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithObsIDTurkey(resp.observationId!,necId: necId as NSNumber)
            }
        }
    }
    // MARK: - 🫁 💾 Save Respiratory Category Data
    func saveResCat(_ completion: (_ status: Bool) -> Void) {
        let farm = farmArray.object(at: nsIndexPathFromExist)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        let bird = (items.object(at: 0) as AnyObject).object(at: 0)
        UserDefaults.standard.set(bird, forKey: "bird")
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let resp =  CoreDataHandlerTurkey().fetchAllRespiratoryusingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        var  necId = Int()
        
        if postingIdFromExistingNavigate == "Exting"{
            
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        for i in 0..<farmArray.count {
            for x in 0..<(items[i] as AnyObject).count {
                let birdnumber = (items.object(at: i) as AnyObject).object(at: x)
                handleRespArrLoop(resp, birdnumber, i, necId)
            }
        }
        
        dataArrayRes = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird as! NSNumber, farmname: farm as! String, catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
    }
    
    fileprivate func handleImmuneAndBirdNumber(_ immune: ImmuneTurkey, _ i: Int, _ birdnumber: Any, _ j: Int, _ necId: Int) {
        if immune.measure! == "Y,N" {
            let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            
            let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                catName: "Immune",
                obsName: immune.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
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
            
        } else if ( immune.measure! == "Actual") {
            let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            let farmWeight =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkeyWithFarmName(farmArray[i] as! String,necropsyId:necId as NSNumber)
            let arrdata = farmWeight.object(at: 0) as! CaptureNecropsyDataTurkey
            var result: Float
            if arrdata.farmWeight! != "" {
                // result = 0.00
                result = Float(arrdata.farmWeight!)! / Float(arrdata.noOfBirds!)!
            } else {
                result = 0.0
            }
            
            let immuneData = CoreDataHandlerTurkeyModels.imumneSwithcCaptureData(
                catName: "Immune",
                obsName: immune.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
                obsPoint: result,
                index: j,
                obsId: Int(immune.observationId!),
                measure: trimmed,
                quickLink: immune.quicklinks!,
                necId: necId as NSNumber,
                isSync: true,
                lngId: lngId as NSNumber,
                refId: immune.refId!,
                actualText: "\(Int(result))"
            )
            
            CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkeyImmuneCase(data: immuneData)
            
        } else if ( immune.measure! == "F,M"){
            let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            
            let data = CoreDataHandlerTurkeyModels.turkeySexNecropsyData(
                catName: "Immune",
                obsName: immune.observationField!,
                formName: farmArray[i] as! String,
                obsVisibility: false,
                birdNo: birdnumber as! NSNumber,
                obsPoint: 0,
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
            
        } else {
            let trimmed = immune.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let array = (trimmed.components(separatedBy: ",") as [String])
            
            if immune.refId == 58 {
                
                let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                    catName: "Immune",
                    obsName: immune.observationField!,
                    formName: farmArray[i] as! String,
                    obsVisibility: false,
                    birdNo: birdnumber as! NSNumber,
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
                    formName: farmArray[i] as! String,
                    obsVisibility: false,
                    birdNo: birdnumber as! NSNumber,
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
    }
    
    fileprivate func handleFarmArrayIteraton(_ immu: NSMutableArray, _ birdnumber: Any, _ i: Int, _ necId: Int) {
        for j in 0..<immu.count {
            if ((immu.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                let immune : ImmuneTurkey = immu.object(at: j) as! ImmuneTurkey
                let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(birdnumber as! NSNumber, farmname: farmArray[i] as! String, catName: "Immune",Obsid: immune.observationId!,necId:necId as NSNumber)
                
                if FetchObsArr.count > 0 {
                    debugPrint("immune obs list.")
                } else {
                    
                    handleImmuneAndBirdNumber(immune, i, birdnumber, j, necId)
                }
            } else {
                let immune : ImmuneTurkey = immu.object(at: j) as! ImmuneTurkey
                CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithObsIDTurkey(immune.observationId!,necId: necId as NSNumber)
                
            }
        }
    }
    // MARK: - 🛡️💾 Save Immune Category Data
    func saveImmuneCat(_ completion: (_ status: Bool) -> Void) {
        let farm = farmArray.object(at: nsIndexPathFromExist)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        let bird = (items.object(at: 0) as AnyObject).object(at: 0)
        UserDefaults.standard.set(bird, forKey: "bird")
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let immu = CoreDataHandlerTurkey().fetchAllImmuneUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        var necId = UserDefaults.standard.integer(forKey: "necId") as Int
        
        if postingIdFromExistingNavigate == "Exting" {
            
            necId = postingIdFromExisting
            
            let farmWeight =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkeyWithFarmName(farm as! String ,necropsyId:necId as NSNumber)
            let arrdata = farmWeight.object(at: 0) as! CaptureNecropsyDataTurkey
            let result: Double
            if arrdata.farmWeight == "" {
                result = 0.0
            } else {
                result = Double(arrdata.farmWeight!)! / Double(arrdata.noOfBirds!)!
            }
            
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkeyBodyWeight("Immune", obsName: "Body Weight", formName: farm as! String, obsPoint: Int(result), index: self.items.count, necId:  necId as NSNumber, isSync: true)
        }
        
        for i in 0..<farmArray.count {
            for x in 0..<(items[i] as AnyObject).count {
                let birdnumber = (items.object(at: i) as AnyObject).object(at: x)
                handleFarmArrayIteraton(immu, birdnumber, i, necId)
            }
        }
        
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird as! NSNumber, farmname: farm as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        completion (true)
        
    }
    
    func fethDataTrueValue(_ tagName:NSString) {
        print(appDelegateObj.testFuntion())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func handleSkletaDataTag0(_ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        for i in 0..<2 {
            
            let n  = String(describing: skleta?.refId!)
            if i == 0 {
                let imageName = "skeltaMuscular" + "_" + n + "_n"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
            
            if i == 1 {
                let imageName = "skeltaMuscular" + "_" + n + "_y"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
        }
    }
    
    fileprivate func handleBtnTag0ClickedPopup(_ skleta: inout CaptureNecropsyViewDataTurkey?, _ sender: UIButton, _ obsName: inout String, _ refId: inout Int, _ obsNameArr: inout NSMutableArray, _ infoImage: NSMutableArray) {
        if btnTag == 0 {
            skleta = dataSkeltaArray.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            obsName  = skleta?.obsName ?? ""
            refId = skleta?.refId as! Int
            
            obsNameArr =  self.setObsImageDescForSkleta(desc: refId)
            
            if skleta?.measure ==  "Y,N" {
                handleSkletaDataTag0(skleta, infoImage)
            } else if skleta?.measure ==  "Actual" {
                let image = UIImage(named:"image001")
                infoImage.add(image!)
            } else {
                let n  = String(describing: skleta?.refId!)
                let trimmed = skleta?.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let array = (trimmed?.components(separatedBy: ",") as [String])
                
                for i in 0..<array.count {
                    let imageName = "skeltaMuscular" + "_" + n + "_0" + String(i)
                    var image = UIImage(named:imageName)
                    if image == nil {
                        image = UIImage(named:"image001")
                    }
                    infoImage.add(image!)
                }
            }
        }
    }
    
    fileprivate func handleSkletaDataTag1(_ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        for i in 0..<2 {
            let n  = String(describing: skleta?.refId!)
            
            if i == 0 {
                let imageName = "Coccidiosis" + "_" + n + "_n"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
                
            }
            
            if i == 1 {
                let imageName = "Coccidiosis" + "_" + n + "_y"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
        }
    }
    
    fileprivate func handleBtnTag1ClickedPopup(_ skleta: inout CaptureNecropsyViewDataTurkey?, _ sender: UIButton, _ obsName: inout String, _ refId: inout Int, _ obsNameArr: inout NSMutableArray, _ infoImage: NSMutableArray) {
        if btnTag == 1 {
            
            skleta = dataArrayCocoi.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            obsName = skleta?.obsName ?? ""
            refId = skleta?.refId as! Int
            
            obsNameArr = self.setObsImageDescForCocodis(desc: refId)
            
            if skleta?.measure ==  "Y,N" {
                handleSkletaDataTag1(skleta, infoImage)
            } else if skleta?.measure ==  "Actual" {
                let image = UIImage(named:"image001")
                infoImage.add(image!)
                
            } else {
                
                let trimmed = skleta?.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let array = (trimmed?.components(separatedBy: ",") as [String])
                
                for i in 0..<array.count {
                    let n  = String(describing: skleta?.refId!)
                    let imageName = "Coccidiosis" + "_" + n + "_0" + String(i)
                    var image = UIImage(named:imageName)
                    if image == nil {
                        image = UIImage(named:"image001")
                    }
                    infoImage.add(image!)
                    
                }
            }
        }
    }
    
    fileprivate func handleSklLetaDataTag2(_ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        for i in 0..<2 {
            let n  = String(describing: skleta?.refId!)
            if i == 0 {
                let imageName = "GITract" + "_" + n + "_n"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
                
            }
            
            if i == 1 {
                let imageName = "GITract" + "_" + n + "_y"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
        }
    }
    
    fileprivate func handleBtnTag2ClickedPopup(_ skleta: inout CaptureNecropsyViewDataTurkey?, _ sender: UIButton, _ obsName: inout String, _ refId: inout Int, _ obsNameArr: inout NSMutableArray, _ infoImage: NSMutableArray) {
        if btnTag == 2 {
            skleta = dataArrayGiTract.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            obsName  = skleta?.obsName ?? ""
            refId = skleta?.refId as? Int ?? 0
            obsNameArr =  self.setObsImageDescForGitract(desc: refId)
            
            if skleta?.measure ==  "Y,N" {
                handleSklLetaDataTag2(skleta, infoImage)
            } else if skleta?.measure ==  "Actual" {
                let image = UIImage(named:"image001")
                infoImage.add(image!)
                
            } else {
                
                let trimmed = skleta?.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let array = (trimmed?.components(separatedBy: ",") as [String])
                
                for i in 0..<array.count {
                    let n  = String(describing: skleta?.refId!)
                    
                    let imageName = "GITract" + "_" + n + "_0" + String(i)
                    var image = UIImage(named:imageName)
                    if image == nil {
                        image = UIImage(named:"image001")
                    }
                    infoImage.add(image!)
                    
                }
            }
        }
    }
    
    fileprivate func handleSkletaDataTag3(_ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        for i in 0..<2 {
            let n  = String(describing: skleta?.refId!)
            if i == 0 {
                let imageName = "Resp" + "_" + n + "_n"
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
                
            }
            
            if i == 1 {
                let imageName = "Resp" + "_" + n + "_y"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
        }
    }
    
    fileprivate func handleBtnTag3ClickedPopup(_ skleta: inout CaptureNecropsyViewDataTurkey?, _ sender: UIButton, _ obsName: inout String, _ refId: inout Int, _ obsNameArr: inout NSMutableArray, _ infoImage: NSMutableArray) {
        if btnTag == 3 {
            
            skleta  = dataArrayRes.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            obsName = skleta?.obsName ?? ""
            refId = skleta?.refId as! Int
            obsNameArr =  self.setObsImageDescForResp(desc: refId)
            if skleta?.measure ==  "Y,N" {
                handleSkletaDataTag3(skleta, infoImage)
            } else if skleta?.measure ==  "Actual" {
                let image = UIImage(named:"image001")
                infoImage.add(image!)
                
            } else {
                
                let trimmed = skleta?.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let array = (trimmed?.components(separatedBy: ",") as [String])
                for i in 0..<array.count {
                    let n  = String(describing: skleta?.refId!)
                    let imageName = "Resp" + "_" + n + "_0" + String(i)
                    var image = UIImage(named:imageName)
                    if image == nil {
                        image = UIImage(named:"image001")
                    }
                    infoImage.add(image!)
                }
            }
        }
    }
    
    fileprivate func handleRefId58Validation(_ refId: Int, _ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        if refId == 58 {
            let a = NSMutableArray()
            a.add("0")
            a.add("3")
            a.add("7")
            
            for i in 0..<a.count {
                let n  = String(describing: skleta?.refId!)
                let imageName = "Immune" + "_" + n + "_0" + String(i)
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
                
            }
        } else {
            
            let trimmed = skleta?.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let array = (trimmed?.components(separatedBy: ",") as [String])
            
            for i in 0..<array.count {
                let n  = String(describing: skleta?.refId!)
                
                let imageName = "Immune" + "_" + n + "_0" + String(i)
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
                
            }
        }
    }
    
    fileprivate func handleSklDataMeasureClickedPopup(_ skleta: CaptureNecropsyViewDataTurkey?, _ infoImage: NSMutableArray) {
        for i in 0..<2 {
            let n  = String(describing: skleta?.refId!)
            if i == 0 {
                let imageName = "Immune" + "_" + n + "_n"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
            
            if i == 1 {
                let imageName = "Immune" + "_" + n + "_y"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                infoImage.add(image!)
            }
        }
    }
    
    @objc func clickHelpPopUp(_ sender:UIButton) {
        let infoImage = NSMutableArray()
        var skleta : CaptureNecropsyViewDataTurkey!
        var obsName = String()
        var refId = Int()
        var obsNameArr = NSMutableArray()
        
        handleBtnTag0ClickedPopup(&skleta, sender, &obsName, &refId, &obsNameArr, infoImage)
        handleBtnTag1ClickedPopup(&skleta, sender, &obsName, &refId, &obsNameArr, infoImage)
        handleBtnTag2ClickedPopup(&skleta, sender, &obsName, &refId, &obsNameArr, infoImage)
        handleBtnTag3ClickedPopup(&skleta, sender, &obsName, &refId, &obsNameArr, infoImage)
        
        if btnTag == 4 {
            skleta = dataArrayImmu.object(at: sender.tag) as? CaptureNecropsyViewDataTurkey
            obsName = skleta.obsName!
            refId = skleta.refId as! Int
            obsNameArr = self.setObsImageDescForImmune(desc: refId)
            
            if skleta.measure ==  "Y,N" {
                handleSklDataMeasureClickedPopup(skleta, infoImage)
            } else if skleta.measure ==  "Actual"  || skleta.measure == "F,M" {
                let image = UIImage(named:"image001")
                infoImage.add(image!)
                return
            }
            else {
                
                handleRefId58Validation(refId, skleta, infoImage)
            }
        }
        buttonPopup = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonPopup.backgroundColor = UIColor(white: 0, alpha: 0.5)
        buttonPopup.addTarget(self, action: #selector(buttonActionpopup), for: .touchUpInside)
        
        self.view.addSubview(buttonPopup)
        
        self.customPopView1 =  SimpleCustomViewTurkey(frame: CGRect(    x: 25, y: 150    , width: 975, height: 422))
        self.customPopView1.infoImages = infoImage
        self.customPopView1.obsNmae = obsName
        self.customPopView1.obsData = skleta
        self.customPopView1.btnIndex = btnTag
        self.customPopView1.obsDescArr = obsNameArr
        
        if postingIdFromExistingNavigate == "Exting"{
            
            self.customPopView1.necId =  postingIdFromExisting
        } else {
            
            self.customPopView1.necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        self.customPopView1.infoLinkkDelegateT = self
        buttonPopup.addSubview(self.customPopView1!);
        
    }
    
    fileprivate func switchCase1(_ obsDescArr: NSMutableArray) {
        if lngId == 1 {
            obsDescArr.add(Constants.noLesion)
            obsDescArr.add("(<50%) footpad.")
            obsDescArr.add("(>50%) footpad or a footpad that is <50% but has toe involvement.")
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
    }
    
    fileprivate func extractedFunc1(_ obsDescArr: NSMutableArray) {
        if lngId == 1 {
            obsDescArr.add(Constants.noLesion)
            obsDescArr.add(Constants.growth50)
            obsDescArr.add(Constants.growth50GreaterStr)
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
    }
    
    fileprivate func switchCase5(_ obsDescArr: NSMutableArray) {
        if lngId == 1 {
            obsDescArr.add(Constants.noLesion)
            obsDescArr.add(Constants.growth50)
            obsDescArr.add(Constants.growth50GreaterStr)
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
    }
    
    fileprivate func switchCase6(_ obsDescArr: NSMutableArray) {
        if lngId == 1 {
            obsDescArr.add("No.")
            obsDescArr.add("Yes (widening of growth plate).")
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
    }
    
    fileprivate func switchCase7(_ obsDescArr: NSMutableArray) {
        if lngId == 1 {
            obsDescArr.add(Constants.normalStr)
            obsDescArr.add("Weak snap.")
            obsDescArr.add("Folding bone rather than snap.")
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
    }
    
    func setObsImageDescForSkleta(desc: Int) -> NSMutableArray {
        let obsDescArr = NSMutableArray()
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        // Common Yes/No cases
        let yesNoCases: Set<Int> = [2, 3, 4, 8, 9, 11, 12, 13, 598, 602, 597, 603]
        // Common N/A cases with 2 items
        let naTwoCases: Set<Int> = [300, 10, 16, 14]
        // Common N/A cases with 4 items
        let naFourCases: Set<Int> = [601, 605]
        
        if yesNoCases.contains(desc) {
            if lngId == 1 {
                obsDescArr.add("No.")
                obsDescArr.add(Constants.yesStr)
            } else if lngId == 5 {
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
            }
        } else if naTwoCases.contains(desc) {
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
        } else if naFourCases.contains(desc) {
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
        } else {
            switch desc {
            case 1, 596:
                switchCase1(obsDescArr)
                
            case 5, 599:
                switchCase5(obsDescArr)
                
            case 6, 600:
                switchCase6(obsDescArr)
                
            case 7:
                switchCase7(obsDescArr)
                
            default:
                obsDescArr.add("N/A.")
                obsDescArr.add("N/A.")
            }
        }
        
        return obsDescArr
    }
    
    fileprivate func extractedFunc(_ obsDescArr: NSMutableArray) -> NSMutableArray {
        if lngId == 1 {
            obsDescArr.add(noGrossLesionStr)
            obsDescArr.add("<5 lesions/cm2.")
            obsDescArr.add("5 lesions/cm2.")
            obsDescArr.add("Lesions coalescent.")
            obsDescArr.add("Lesions completely coalescent with petechial hemorrhage or red mucosa.")
        } else if lngId == 5 {
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
            obsDescArr.add(Constants.sinLesionStr)
        }
        
        return obsDescArr
    }
    
    func setObsImageDescForCocodis(desc : Int) -> NSMutableArray {
        var obsDescArr = NSMutableArray()
        switch desc {
        case 23 :
            lngId = UserDefaults.standard.integer(forKey: "lngId")
            obsDescArr = extractedFunc(obsDescArr)
            
            break
            
        case 24 :
            if lngId == 1{
                obsDescArr.add(noGrossLesionStr)
                obsDescArr.add("Few petechial hemorrhages.")
                obsDescArr.add("Numerous patechiae.")
                obsDescArr.add("Numerous petechiae and gut ballooning.")
                obsDescArr.add("Bloody and ballooned.")
            }
            else if lngId == 5{
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
            }
            
            break
            
        case 25 , 21:
            if lngId == 1{
                obsDescArr.add("No oocysts.")
                obsDescArr.add("1-10 Oocysts per low power field.")
                obsDescArr.add("11-20 Oocysts per low power field.")
                obsDescArr.add("21-50 Oocysts per low power field")
                obsDescArr.add(">50 Oocysts per low power field.")
            }
            else if lngId == 5{
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
            }
            break
            
        case 26 :
            if lngId == 1{
                obsDescArr.add(noGrossLesionStr)
                obsDescArr.add("Petechiae without blood. ")
                obsDescArr.add("Blood in the cecal contents; cecal wall somewhat thickened (normal contents) ")
                obsDescArr.add("Blood or cecal cores present, walls greatly thickened (no contents).")
                obsDescArr.add("Cecal wall greatly distended with blood or cores.")
            }
            else if lngId == 5{
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
                obsDescArr.add(Constants.sinLesionStr)
            }
            
            break
            
        case 22 , 609 , 607 , 610 , 612 , 611 , 608 , 614 , 613 , 616:
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A. ")
            obsDescArr.add("N/A ")
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A")
            break
            
        case 615 :
            obsDescArr.add("No.")
            obsDescArr.add(Constants.yesStr)
            break
        default:
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
            break
            
        }
        
        return obsDescArr
        
    }
    
    
    func setObsImageDescForGitract(desc: Int) -> NSMutableArray {
        let obsDescArr = NSMutableArray()
        let giTractlngId = UserDefaults.standard.integer(forKey: "lngId")
        
        // Define a dictionary for specific cases and descriptions
        let descriptions: [Int: [Int: [String]]] = [
            27: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            28: [
                1: [Constants.normalStr, "Swollen glands.", "Swollen glands and enlarged.", "Greatly enlarged and flaccid."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            29: [
                1: [
                    "A normal smooth lining of the gizzard with no (change 'no' to minimal) roughening to the surface lining through rough appearance to the lining but no ulcerations or hemorrhages present.",
                    "Erosion that does not go through gizzard lining.",
                    "Severe erosion through gizzard lining.",
                    "Erosions into the gizzard muscle."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            31: [
                1: ["<50% of gizzard contents is litter.", ">50% gizzard contents is litter."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            32: [
                1: [
                    "Normal gut tone and color.",
                    "Loss of tone with either decreased or increased thickness of intestinal tract. Slight loss of tensile strength. Reddening of duodenal loop alone is not a reason to justify this score but is to be considered if a slight redness extends into the midgut.",
                    "Intestine lays flat or has no tone when opened. There may be significant loss of tensile strength and thinning. Intestine may have a layer of mucous, moderate reddening, cellular debris, and an increased amount of fluid or orange material present.",
                    "A generalized thinning and loss of intestinal mucosal surface. Significant feed passage is observed. There may be formation of diphtheritic membrane and/or severe reddening with petechiae hemorrhaging readily apparent. No tensile strength of gut. Ballooning of gut may be observed."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            33: [
                1: ["No evidence of necrotic enteritis present.", "Necrotic enteritis present."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            34: [
                1: ["No.", "Multiple fragments of undigested feed present in colon."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            35: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            37: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            45: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            675: [
                1: ["No.", Constants.yesStr],
                5: ["No.", Constants.yesStr]
            ],
            46: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            622: [
                1: [
                    "Normal gut tone and color.",
                    "Loss of tone with either decreased or increased thickness of intestinal tract. Slight loss of tensile strength. Reddening of duodenal loop alone is not a reason to justify this score but is to be considered if a slight redness extends into the midgut.",
                    "Intestine lays flat or has no tone when opened. There may be significant loss of tensile strength and thinning. Intestine may have a layer of mucous, moderate reddening, cellular debris, and an increased amount of fluid or orange material present.",
                    "A generalized thinning and loss of intestinal mucosal surface. Significant feed passage is observed. There may be formation of diphtheritic membrane and/or severe reddening with petechiae hemorrhaging readily apparent. No tensile strength of gut. Ballooning of gut may be observed."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            632: [
                1: ["No.", Constants.yesStr],
                5: ["No.", Constants.yesStr]
            ],
            633: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            634: [
                1: ["No.", Constants.yesStr],
                5: ["No.", Constants.yesStr]
            ],
            617: [
                1: ["No.", Constants.yesStr],
                5: ["No.", Constants.yesStr]
            ],
            624: [
                1: ["No.", Constants.yesStr],
                5: ["No.", Constants.yesStr]
            ],
            618: [
                1: ["N/A.", "N/A.", "N/A.", "N/A."],
                5: ["N/A.", "N/A.", "N/A.", "N/A."]
            ],
            627: [
                1: ["N/A.", "N/A.", "N/A.", "N/A."],
                5: ["N/A.", "N/A.", "N/A.", "N/A."]
            ],
            619: [
                1: [
                    "A normal smooth lining of the gizzard with no (change 'no' to minimal) roughening to the surface lining through rough appearance to the lining but no ulcerations or hemorrhages present.",
                    "Erosion that does not go through gizzard lining.",
                    "Severe erosion through gizzard lining.",
                    "Erosions into the gizzard muscle."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            47: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            621: [
                1: ["<50% of gizzard contents is litter.", ">50% gizzard contents is litter."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            40: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            36: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            41: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            39: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            38: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ],
            48: [
                1: ["N/A.", "N/A."],
                5: ["N/A.", "N/A."]
            ]
        ]
        
        // Handle cases with specific descriptions
        if let lngSpecificDescriptions = descriptions[desc], let result = lngSpecificDescriptions[giTractlngId] {
            obsDescArr.addObjects(from: result)
        } else {
            // Fallback for other cases
            obsDescArr.add("N/A.")
            obsDescArr.add("N/A.")
        }
        
        return obsDescArr
    }
    
    func setObsImageDescForResp(desc: Int) -> NSMutableArray {
        let obsDescArr = NSMutableArray()
        let respLngId = UserDefaults.standard.integer(forKey: "lngId")
        
        // Define a dictionary for specific cases and descriptions
        let descriptions: [Int: [Int: [String]]] = [
            49: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            50: [
                1: [
                    Constants.normalStr,
                    "Slight mucus and/or slight hyperemia.",
                    "Copious mucus and/or moderate hyperemia.",
                    "Severe hyperemia and/or Hemorrhagic and/or Diphtheritic."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            51: [
                1: [
                    Constants.normalStr,
                    "Suds.",
                    "Frothy suds or single focus of exudates.",
                    "Multifocal to diffuse exudate or exudate + pericarditis.",
                    "Pericarditis + perihepatitis."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            638: [1: ["No.", Constants.yesStr]],
            635: [1: ["No.", Constants.yesStr]],
            640: [1: ["No.", Constants.yesStr]],
            639: [1: ["No.", Constants.yesStr]],
            636: [
                1: [
                    Constants.normalStr,
                    "Slight mucus and/or slight hyperemia.",
                    "Copious mucus and/or moderate hyperemia.",
                    "Severe hyperemia and/or Hemorrhagic and/or Diphtheritic."
                ],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ]
        ]
        
        // Default descriptions for other specific cases
        let defaultDescriptions: [Int: [String]] = [
            52: ["N/A.", "N/A."],
            53: ["N/A.", "N/A."],
            54: ["N/A.", "N/A."],
            637: ["N/A.", "N/A.", "N/A.", "N/A.", "N/A."]
        ]
        
        // Handle cases with specific descriptions
        if let lngSpecificDescriptions = descriptions[desc], let result = lngSpecificDescriptions[respLngId] {
            obsDescArr.addObjects(from: result)
            return obsDescArr
        }
        
        // Handle default descriptions
        if let result = defaultDescriptions[desc] {
            obsDescArr.addObjects(from: result)
            return obsDescArr
        }
        
        // Fallback for other cases
        obsDescArr.addObjects(from: ["N/A.", "N/A."])
        return obsDescArr
    }
    
    func setObsImageDescForImmune(desc: Int) -> NSMutableArray {
        let obsDescArr = NSMutableArray()
        let immuneLngId = UserDefaults.standard.integer(forKey: "lngId")
        
        // Define a dictionary for cases with different descriptions
        let descriptions: [Int: [Int: [String]]] = [
            58: [
                1: ["Very small.", "Default.", "Large."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            57: [
                1: ["NA", "NA.", "NA.", "NA."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            59: [
                1: ["Absent.", "Presents."],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            61: [
                1: ["No.", Constants.yesStr],
                5: [Constants.sinLesionStr, Constants.sinLesionStr]
            ],
            1958: [
                1: [Constants.yesStr, "No."]
            ],
            1960: [
                1: [Constants.yesStr, "No."]
            ],
            1878: [
                1: [Constants.yesStr, "No."]
            ]
        ]
        
        // Define default descriptions for other cases
        let defaultDescriptions: [Int] = [60, 55, 65, 63, 81, 64, 66, 647, 650, 643, 641, 645]
        
        // Handle specific cases using the dictionary
        if let lngSpecificDescriptions = descriptions[desc], let result = lngSpecificDescriptions[immuneLngId] {
            obsDescArr.addObjects(from: result)
            return obsDescArr
        }
        
        if defaultDescriptions.contains(desc) {
            obsDescArr.addObjects(from: ["N/A.", "N/A."])
            return obsDescArr
        }
        
        // Handle other cases with generic "N/A."
        obsDescArr.addObjects(from: ["N/A.", "N/A."])
        return obsDescArr
    }
    
    func cancelBtnActionTurkey (_ btnTag: Int, data:CaptureNecropsyViewDataTurkey){
        
        buttonPopup.alpha = 0
        
        if btnTag == 0
        {
            dataSkeltaArray.removeAllObjects()
            let necId = getNecId()
            
            dataSkeltaArray =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(data.birdNo!, farmname: data.formName!, catName: data.catName!,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
            
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
            neccollectionView.reloadData()
        }
        if btnTag == 1
        {
            dataArrayCocoi.removeAllObjects()
            let necId = getNecId()
            
            dataArrayCocoi = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(data.birdNo!, farmname: data.formName!, catName: data.catName!,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
            neccollectionView.reloadData()
            
        }
        if btnTag == 2
        {
            dataArrayGiTract.removeAllObjects()
            let necId = getNecId()
            
            dataArrayGiTract =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(data.birdNo!, farmname: data.formName!, catName: data.catName!,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
            neccollectionView.reloadData()
            
        }
        if btnTag == 3
        {
            dataArrayRes.removeAllObjects()
            let necId = getNecId()
            
            dataArrayRes =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(data.birdNo!, farmname: data.formName!, catName: data.catName!,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
            
            neccollectionView.reloadData()
        }
        if btnTag == 4
        {
            dataArrayImmu.removeAllObjects()
            let necId = getNecId()
            
            dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(data.birdNo!, farmname: data.formName!, catName: data.catName!,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
            
            neccollectionView.reloadData()
        }
        
    }
    
    
    func getNecId() -> Int {
        if postingIdFromExistingNavigate == "Exting" {
            return postingIdFromExisting
        } else {
            return UserDefaults.standard.integer(forKey: "necId")
        }
    }
    
    
    
    @objc func buttonActionpopup(_ sender: UIButton!) {
        buttonPopup.alpha = 0
        
    }
    
    @objc func quickLink(_ sender : UIButton){
        
        
        let form = farmArray[sender.tag] as? String
        let ageArry = (ageArray[sender.tag] as? String)!
        let index = sender.tag
        
        var birNo  = Int()
        
        for i in 0..<self.farmArray.count {
            let f  = self.farmArray.object(at: i) as! String
            if f == form {
                
                birNo  = (self.items.object(at: i) as AnyObject).count
            }
        }
        
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AllBirdsViewControllerTurkey") as? AllBirdsViewControllerTurkey
        
        var necId = Int()
        if postingIdFromExistingNavigate == "Exting"{
            
            necId =  postingIdFromExisting
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        mapViewControllerObj!.postingIdFromExistingNavigate = postingIdFromExistingNavigate as NSString
        mapViewControllerObj!.necId = necId
        mapViewControllerObj!.formName = form!
        mapViewControllerObj!.ageValue = ageArry
        mapViewControllerObj!.birdNo = birNo
        mapViewControllerObj!.index = index
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        
    }
    
    fileprivate func handleObsPointValidationsPlusBtnClick(_ array: ([String]), _ skleta1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ skleta: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for i in 0..<array.count {
            let lastElement = (Int(array.last!)! as Int)
            if lastElement == Int(array[i])! {
                debugPrint("count is not equal")
            } else {
                if Int(array[i])! as NSNumber == skleta1.obsPoint {
                    cell.incrementLabel.text = String(array[i+1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "skeltaMuscular",
                        obsName: skleta1.obsName!,
                        formName: skleta.formName!,
                        obsVisibility: Bool(truncating: skleta1.objsVisibilty!),
                        birdNo: skleta.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i + 1])!,
                        obsId: Int(skleta1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handleObsPointValidationPlusBtnClicked(_ skleta1: CaptureNecropsyViewDataTurkey, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell, _ skleta: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        if skleta1.obsPoint == 0 {
            if Int(array[0]) != 0 {
                cell.incrementLabel.text = String(array[0])
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName: "skeltaMuscular",
                    obsName: skleta1.obsName!,
                    formName: skleta.formName!,
                    obsVisibility: Bool(skleta1.objsVisibilty!),
                    birdNo: skleta.birdNo!,
                    camraImage: image!,
                    obsPoint: Int(array[0])!,
                    obsId: Int(skleta1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                
            } else {
                cell.incrementLabel.text = String(array[1])
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName: "skeltaMuscular",
                    obsName: skleta1.obsName!,
                    formName: skleta.formName!,
                    obsVisibility: Bool(skleta1.objsVisibilty!),
                    birdNo: skleta.birdNo!,
                    camraImage: image!,
                    obsPoint: Int(array[1])!,
                    obsId: Int(skleta1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
            }
        } else {
            handleObsPointValidationsPlusBtnClick(array, skleta1, cell, skleta, image, rowIndex, necId)
        }
    }
    
    fileprivate func handlePlusButtonClickBtnTag0(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        
        let image = UIImage(named:"image001")
        var  necId = Int()
        
        if postingIdFromExistingNavigate == "Exting" {
            
            necId = postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(skleta.birdNo!, farmname: skleta.formName!, catName: skleta.catName!,Obsid: skleta.obsID!,necId: necId as NSNumber)
        
        let skleta1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            handleObsPointValidationPlusBtnClicked(skleta1, array, cell, skleta, image, rowIndex, necId)
        }
        
        dataSkeltaArray.removeAllObjects()
        dataSkeltaArray = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(skleta.birdNo! , farmname: skleta.formName!, catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handlePlusButtonClickElseBtnTag1(_ array: ([String]), _ cocoi1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ cocoi: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ necId: Int, _ rowIndex: Int) {
        for  i in 0..<array.count
        {
            let lastElement = (Int(array.last!)! as Int)
            if lastElement == Int(array[i])!
            {
                debugPrint("for cocci count is not equal")
            }
            else
            {
                if Int(array[i])! as NSNumber == cocoi1.obsPoint
                {
                    cell.incrementLabel.text = String(array[i+1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Coccidiosis",
                        obsName: cocoi1.obsName!,
                        formName: cocoi.formName!,
                        obsVisibility: Bool(cocoi1.objsVisibilty!),
                        birdNo: cocoi.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i + 1])!,
                        obsId: Int(cocoi1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
                
            }
            
        }
    }
    
    fileprivate func handlePlusButtonClickBtnTag1(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        let cocoi : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        
        let image = UIImage(named:"image001")
        
        var necId = getNecId()
        
        
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(cocoi.birdNo!, farmname: cocoi.formName!, catName: cocoi.catName!,Obsid: cocoi.obsID!,necId:necId as NSNumber)
        
        let cocoi1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            if cocoi1.obsPoint == 0
            {
                if Int(array[0]) != 0
                {
                    cell.incrementLabel.text = String(array[0])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Coccidiosis",
                        obsName: cocoi1.obsName!,
                        formName: cocoi.formName!,
                        obsVisibility: Bool(cocoi1.objsVisibilty!),
                        birdNo: cocoi.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(cocoi1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                } else {
                    cell.incrementLabel.text = String(array[1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Coccidiosis",
                        obsName: cocoi1.obsName!,
                        formName: cocoi.formName!,
                        obsVisibility: Bool(cocoi1.objsVisibilty!),
                        birdNo: cocoi.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[1])!,
                        obsId: Int(cocoi1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    
                }
            } else {
                handlePlusButtonClickElseBtnTag1(array, cocoi1, cell, cocoi, image, necId, rowIndex)
            }
        }
        dataArrayCocoi.removeAllObjects()
        if postingIdFromExistingNavigate == "Exting"{
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        
        dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(cocoi.birdNo! , farmname: cocoi.formName!, catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handlePlusButtonClickElseBtnTag2(_ array: ([String]), _ gitract1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ gitract: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ necId: Int, _ rowIndex: Int) {
        for  i in 0..<array.count
        {
            let lastElement = (Int(array.last!)! as Int)
            if lastElement == Int(array[i])!
            {
                debugPrint("gitrect count is not equal")
            }
            else
            {
                if (Int(array[i])! as NSNumber)  == gitract1.obsPoint
                {
                    cell.incrementLabel.text = String(array[i+1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "GITract",
                        obsName: gitract1.obsName!,
                        formName: gitract.formName!,
                        obsVisibility: Bool(gitract1.objsVisibilty!),
                        birdNo: gitract.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i + 1])!,
                        obsId: Int(gitract1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
            }
        }
    }
    
    fileprivate func handlePlusButtonClickBtnTag2(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        
        let image = UIImage(named:"image001")
        
        var necId = getNecId()
        
        let FetchObsArr =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(gitract.birdNo!, farmname: gitract.formName!, catName: gitract.catName!,Obsid: gitract.obsID!,necId:necId as NSNumber)
        
        let gitract1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            if gitract1.obsPoint == 0
            {
                if Int(array[0]) != 0
                {
                    cell.incrementLabel.text = String(array[0])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "GITract",
                        obsName: gitract1.obsName!,
                        formName: gitract.formName!,
                        obsVisibility: Bool(gitract1.objsVisibilty!),
                        birdNo: gitract.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(gitract1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                }
                else
                {
                    cell.incrementLabel.text = String(array[1])
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "GITract",
                        obsName: gitract1.obsName!,
                        formName: gitract.formName!,
                        obsVisibility: Bool(gitract1.objsVisibilty!),
                        birdNo: gitract.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[1])!,
                        obsId: Int(gitract1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                }
                
                
            }
            else
            {
                handlePlusButtonClickElseBtnTag2(array, gitract1, cell, gitract, image, necId, rowIndex)
            }
        }
        
        dataArrayGiTract.removeAllObjects()
        if postingIdFromExistingNavigate == "Exting"{
            necId =  postingIdFromExisting
        }
        else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(gitract.birdNo! , farmname: gitract.formName!, catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handlePlusButtonClickElseBtnTag3(_ array: ([String]), _ resp1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ resp: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ necId: Int, _ rowIndex: Int) {
        for i in 0..<array.count
        {
            let lastElement = (Int(array.last!)! as Int)
            if lastElement == Int(array[i])!
            {
                debugPrint("Resp Count is not here.")
            }
            else
            {
                if Int(array[i])! as NSNumber == resp1.obsPoint
                {
                    cell.incrementLabel.text = String(array[i+1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Resp",
                        obsName: resp1.obsName!,
                        formName: resp.formName!,
                        obsVisibility: Bool(resp1.objsVisibilty!),
                        birdNo: resp.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i + 1])!,
                        obsId: Int(resp1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handlePlusButtonClickBtnTag3(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        let resp : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        let image = UIImage(named:"image001")
        var necId = getNecId()
        
        let FetchObsArr =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(resp.birdNo!, farmname: resp.formName!, catName: resp.catName!,Obsid: resp.obsID!,necId: necId as NSNumber)
        
        let resp1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            if resp1.obsPoint == 0
            {
                if Int(array[0]) != 0
                {
                    cell.incrementLabel.text = String(array[0])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Resp",
                        obsName: resp1.obsName!,
                        formName: resp.formName!,
                        obsVisibility: Bool(resp1.objsVisibilty!),
                        birdNo: resp.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(resp1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                }
                else
                
                {
                    cell.incrementLabel.text = String(array[1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName: "Resp",
                        obsName: resp1.obsName!,
                        formName: resp.formName!,
                        obsVisibility: Bool(resp1.objsVisibilty!),
                        birdNo: resp.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[1])!,
                        obsId: Int(resp1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                }
                
            }
            else
            {
                handlePlusButtonClickElseBtnTag3(array, resp1, cell, resp, image, necId, rowIndex)
            }
        }
        
        dataArrayRes.removeAllObjects()
        
        if postingIdFromExistingNavigate == "Exting"{
            
            necId =  postingIdFromExisting
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        dataArrayRes =   CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(resp.birdNo! , farmname: resp.formName!, catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handlePlusButtonClickElseBtnTag4(_ array: ([String]), _ immune1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ immune: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ necId: Int, _ rowIndex: Int) {
        for  i in 0..<array.count
        {
            
            let lastElement = (Int(array.last!)! as Int)
            if lastElement == Int(array[i])!
            {
                debugPrint("immune count is equal to each other")
            }
            else
            {
                if Int(array[i])! as NSNumber == immune1.obsPoint
                {
                    cell.incrementLabel.text = String(array[i+1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "Immune",
                        obsName: immune1.obsName!,
                        formName: immune.formName!,
                        obsVisibility: Bool(immune1.objsVisibilty!),
                        birdNo: immune.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i + 1])!,
                        obsId: Int(immune1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handlePlusButtonClickBtnTag4(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        let image = UIImage(named:"image001")
        
        var necId = getNecId()
        
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId: necId as NSNumber)
        
        let immune1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            if immune1.obsPoint == 0 {
                if Int(array[0]) != 0 {
                    cell.incrementLabel.text = String(array[0])
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "Immune",
                        obsName: immune1.obsName!,
                        formName: immune.formName!,
                        obsVisibility: Bool(immune1.objsVisibilty!),
                        birdNo: immune.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(immune1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                } else {
                    cell.incrementLabel.text = String(array[1])
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "Immune",
                        obsName: immune1.obsName!,
                        formName: immune.formName!,
                        obsVisibility: Bool(immune1.objsVisibilty!),
                        birdNo: immune.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[1])!,
                        obsId: Int(immune1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                }
            } else {
                handlePlusButtonClickElseBtnTag4(array, immune1, cell, immune, image, necId, rowIndex)
            }
        }
        
        dataArrayImmu.removeAllObjects()
        
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handlePostingIdFromExistingNavigateValidations() {
        if postingIdFromExistingNavigate == "Exting" {
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        } else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
    }
    
    @objc func plusButtonClick (_ sender: UIButton){
        let rowIndex :Int = sender.tag
        isFirstTimeLaunch = false
        lastSelectedIndex = IndexPath(row: rowIndex, section: 0)
        
        let cell = neccollectionView.cellForItem(at: lastSelectedIndex!) as! CaptureNecroStep2TurkeyCell
        let trimmed = cell.mesureValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let array = (trimmed.components(separatedBy: ",") as [String])
        
        if btnTag == 0 {
            handlePlusButtonClickBtnTag0(rowIndex, array, cell)
        }
        if btnTag == 1 {
            handlePlusButtonClickBtnTag1(rowIndex, array, cell)
        }
        if btnTag == 2 {
            handlePlusButtonClickBtnTag2(rowIndex, array, cell)
        }
        if btnTag == 3 {
            handlePlusButtonClickBtnTag3(rowIndex, array, cell)
        }
        if btnTag == 4 {
            handlePlusButtonClickBtnTag4(rowIndex, array, cell)
        }
        
        handlePostingIdFromExistingNavigateValidations()
    }
    
    fileprivate func handleObsArrBtnTag0(_ array: ([String]), _ skleta1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ skleta: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for i in 0..<array.count {
            if Int(array[i]) != 1 {
                
                if skleta1.obsPoint == 1 && Int(array[i]) == 0 {
                    
                    cell.incrementLabel.text = array[0]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "skeltaMuscular",
                        obsName: skleta1.obsName!,
                        formName: skleta.formName!,
                        obsVisibility: Bool(skleta1.objsVisibilty!),
                        birdNo: skleta.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(skleta1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
                if Int(array[i])! as NSNumber == skleta1.obsPoint {
                    cell.incrementLabel.text = array[i-1]
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:    "skeltaMuscular",
                        obsName: skleta1.obsName!,
                        formName: skleta.formName!,
                        obsVisibility: Bool(skleta1.objsVisibilty!),
                        birdNo: skleta.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i - 1])!,
                        obsId: Int(skleta1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    break
                }
            }
        }
    }
    
    fileprivate func handleBtnTag0minusBtnClicked(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 0 {
            
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            let image = UIImage(named:"image001")
            
            let  necId = getNecId()
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(skleta.birdNo!, farmname: skleta.formName!, catName: skleta.catName!,Obsid: skleta.obsID!,necId: necId as NSNumber)
            
            let skleta1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0, skleta1.obsPoint != 0  {
                
                handleObsArrBtnTag0(array, skleta1, cell, skleta, image, rowIndex, necId)
                
            }
            
            dataSkeltaArray.removeAllObjects()
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(skleta.birdNo! , farmname: skleta.formName!, catName: "skeltaMuscular",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleObspointArrBtnTag1(_ array: ([String]), _ cocoi: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ cocoi1: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for  i in 0..<array.count {
            if Int(array[i]) != 1 {
                if cocoi.obsPoint == 1 && Int(array[i]) == 0 {
                    
                    cell.incrementLabel.text = array[0]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:    "Coccidiosis",
                        obsName: cocoi1.obsName!,
                        formName: cocoi.formName!,
                        obsVisibility: Bool(cocoi1.objsVisibilty!),
                        birdNo: cocoi.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(cocoi1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    break
                    
                }
                if Int(array[i])! as NSNumber == cocoi1.obsPoint {
                    cell.incrementLabel.text = array[i-1]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:   "Coccidiosis",
                        obsName: cocoi1.obsName!,
                        formName: cocoi.formName!,
                        obsVisibility: Bool(cocoi1.objsVisibilty!),
                        birdNo: cocoi.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i - 1])!,
                        obsId: Int(cocoi1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
            }
        }
    }
    
    fileprivate func handleBtnTag1MinusBtnClicked(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 1 {
            
            let cocoi : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            let image = UIImage(named:"image001")
            var  necId  = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(cocoi.birdNo!, farmname: cocoi.formName!, catName: cocoi.catName!,Obsid: cocoi.obsID!,necId: necId as NSNumber)
            
            let cocoi1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 && cocoi1.obsPoint != 0 {
                
                handleObspointArrBtnTag1(array, cocoi, cell, cocoi1, image, rowIndex, necId)
                
            }
            
            dataArrayCocoi.removeAllObjects()
            dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(cocoi.birdNo! , farmname: cocoi.formName!, catName: "Coccidiosis",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        }
    }
    
    fileprivate func handleObsPointBtnTag2(_ array: ([String]), _ gitract1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ gitract: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for  i in 0..<array.count {
            if Int(array[i]) != 1 {
                if gitract1.obsPoint == 1 && Int(array[i]) == 0 {
                    
                    cell.incrementLabel.text = array[0]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:   "GITract",
                        obsName: gitract1.obsName!,
                        formName: gitract.formName!,
                        obsVisibility: Bool(gitract1.objsVisibilty!),
                        birdNo: gitract.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(gitract1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
                if Int(array[i])! as NSNumber == gitract1.obsPoint {
                    cell.incrementLabel.text = array[i-1]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:   "GITract",
                        obsName: gitract1.obsName!,
                        formName: gitract.formName!,
                        obsVisibility: Bool(gitract1.objsVisibilty!),
                        birdNo: gitract.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i - 1])!,
                        obsId: Int(gitract1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handleBtnTag2MinusBtnClicked(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 2 {
            
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            let image = UIImage(named:"image001")
            var  necId = getNecId()
            
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(gitract.birdNo!, farmname: gitract.formName!, catName: gitract.catName!,Obsid: gitract.obsID!,necId: necId as NSNumber)
            
            let gitract1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 && gitract1.obsPoint != 0 {
                
                handleObsPointBtnTag2(array, gitract1, cell, gitract, image, rowIndex, necId)
                
            }
            dataArrayGiTract.removeAllObjects()
            dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(gitract.birdNo! , farmname: gitract.formName!, catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleObsPOintBtnTag3(_ array: ([String]), _ resp1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ resp: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for  i in 0..<array.count {
            if Int(array[i]) != 1 {
                if resp1.obsPoint == 1 && Int(array[i]) == 0 {
                    cell.incrementLabel.text = array[0]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "Resp",
                        obsName: resp1.obsName!,
                        formName: resp.formName!,
                        obsVisibility: Bool(resp1.objsVisibilty!),
                        birdNo: resp.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(resp1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
                
                if Int(array[i])! as NSNumber == resp1.obsPoint {
                    cell.incrementLabel.text = array[i-1]
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:  "Resp",
                        obsName: resp1.obsName!,
                        formName: resp.formName!,
                        obsVisibility: Bool(resp1.objsVisibilty!),
                        birdNo: resp.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i - 1])!,
                        obsId: Int(resp1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handleBtnTag3minusBtnClicked(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 3 {
            
            let resp : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            let image = UIImage(named:"image001")
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(resp.birdNo!, farmname: resp.formName!, catName: resp.catName!,Obsid: resp.obsID!,necId:necId as NSNumber)
            
            let resp1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 && resp1.obsPoint != 0 {
                handleObsPOintBtnTag3(array, resp1, cell, resp, image, rowIndex, necId)
                
            }
            
            dataArrayRes.removeAllObjects()
            
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(resp.birdNo! , farmname: resp.formName!, catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleObsPointArrBtnTag4(_ array: ([String]), _ immune1: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell, _ immune: CaptureNecropsyViewDataTurkey, _ image: UIImage?, _ rowIndex: Int, _ necId: Int) {
        for i in 0..<array.count {
            if Int(array[i]) != 1 {
                if immune1.obsPoint == 1 && Int(array[i]) == 0 {
                    cell.incrementLabel.text = array[0]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:   "Immune",
                        obsName: immune1.obsName!,
                        formName: immune.formName!,
                        obsVisibility: Bool(immune1.objsVisibilty!),
                        birdNo: immune.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[0])!,
                        obsId: Int(immune1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                    
                }
                if Int(array[i])! as NSNumber == immune1.obsPoint {
                    cell.incrementLabel.text = array[i-1]
                    
                    let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                        catName:   "Immune",
                        obsName: immune1.obsName!,
                        formName: immune.formName!,
                        obsVisibility: Bool(immune1.objsVisibilty!),
                        birdNo: immune.birdNo!,
                        camraImage: image!,
                        obsPoint: Int(array[i - 1])!,
                        obsId: Int(immune1.obsID!),
                        necId: necId as NSNumber,
                        isSync: true
                    )
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                    
                    break
                }
            }
        }
    }
    
    fileprivate func handleBtnTag4MinusBtnClicked(_ rowIndex: Int, _ array: ([String]), _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 4 {
            let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            let image = UIImage(named:"image001")
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId: necId as NSNumber)
            
            let immune1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 && immune1.obsPoint != 0 {
                handleObsPointArrBtnTag4(array, immune1, cell, immune, image, rowIndex, necId)
                
            }
            
            dataArrayImmu.removeAllObjects()
            
            dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    @objc func minusButtonClick (_ sender: UIButton){
        let rowIndex :Int = sender.tag
        isFirstTimeLaunch = false
        lastSelectedIndex = IndexPath(row: rowIndex, section: 0)
        let cell = neccollectionView.cellForItem(at: lastSelectedIndex!) as! CaptureNecroStep2TurkeyCell
        let trimmed = cell.mesureValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let array = (trimmed.components(separatedBy: ",") as [String])
        
        handleBtnTag0minusBtnClicked(rowIndex, array, cell)
        handleBtnTag1MinusBtnClicked(rowIndex, array, cell)
        handleBtnTag2MinusBtnClicked(rowIndex, array, cell)
        handleBtnTag3minusBtnClicked(rowIndex, array, cell)
        handleBtnTag4MinusBtnClicked(rowIndex, array, cell)
        
        if postingIdFromExistingNavigate == "Exting" {
            
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        } else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
    }
    
    fileprivate func updateSexValueInImmuneCategory(rowIndexIs : Int) {
        let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndexIs) as! CaptureNecropsyViewDataTurkey
        var  necId = Int()
        if postingIdFromExistingNavigate == "Exting"{
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId:necId as NSNumber)
        
        if FetchObsArr.count > 0 {
            
            
            let obsData = CoreDataHandlerTurkeyModels.updateSkeletaTurkeySexValueObs(
                catName: "Immune",
                obsName: immune.obsName!,
                formName: immune.formName!,
                obsVisibility: true,
                birdNo: immune.birdNo!,
                obsPoint: 1,
                obsId: immune.obsID as! NSInteger,
                necId: necId as NSNumber,
                isSync: true,
                actualText: selectedSexValue
            )
            
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseTurkeySexValue(obsData, index: rowIndexIs)
            
            
            
        }
        
        dataArrayImmu.removeAllObjects()
        if postingIdFromExistingNavigate == "Exting" {
            
            necId =  postingIdFromExisting
        } else {
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    @objc func turkeySexBtnClick(_ sender: UIButton) {
        
        let rowIndex :Int = sender.tag
        isFirstTimeLaunch = false
        lastSelectedIndex = IndexPath(row: rowIndex, section: 0)
        
        let index = sender.tag
        
        let cell = neccollectionView.cellForItem(at: lastSelectedIndex!) as! CaptureNecroStep2TurkeyCell
        
        
        if turkeyBirdSex.count > 0 {
            self.dropDownVIewNew(arrayData: turkeyBirdSex as? [String] ?? [String](), kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index  in
                
                selectedSexValue = selectedVal
                
                if selectedVal == "Female" {
                    selectedSexValue = "2"
                } else if selectedVal == "N/A" {
                    selectedSexValue = "0"
                } else {
                    selectedSexValue = "1"
                }
                
                cell.turkeySexLbl.text  = selectedVal
                
                
                if btnTag == 4 {
                    
                    updateSexValueInImmuneCategory(rowIndexIs: rowIndex)
                }
                
                if postingIdFromExistingNavigate == "Exting"{
                    
                    CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
                    self.printSyncLblCount()
                } else if UserDefaults.standard.bool(forKey: "Unlinked") == true{
                    
                    let necId = UserDefaults.standard.integer(forKey: "necId") as Int
                    CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
                    self.printSyncLblCount()
                    
                } else {
                    let necId = UserDefaults.standard.integer(forKey: "necId") as Int
                    CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
                    self.printSyncLblCount()
                }
            }
            self.dropHiddenAndShow()
        }
    }
    
    
    fileprivate func handleFetchObs(_ FetchObsArr: NSArray, _ skleta1: CaptureNecropsyViewDataTurkey, _ skleta: CaptureNecropsyViewDataTurkey, _ sender: UISwitch, _ rowIndex: Int, _ necId: Int) {
        if FetchObsArr.count > 0 {
            
            
            let imageName = "skeltaMuscular" + "_" + skleta1.obsName! + "_n"
            var image = UIImage(named:imageName)
            if image == nil {
                image = UIImage(named:"image001")
            }
            
            
            let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                catName:    "skeltaMuscular",
                obsName: skleta1.obsName!,
                formName: skleta.formName!,
                obsVisibility: sender.isOn,
                birdNo: skleta.birdNo!,
                camraImage: image!,
                obsPoint: incrementValue,
                obsId: Int(skleta1.obsID!),
                necId: necId as NSNumber,
                isSync: true
            )
            
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
            
        }
    }
    
    fileprivate func handleBtnTag1Validation(_ rowIndex: Int, _ sender: UISwitch) {
        if btnTag == 1 {
            
            let cocoi : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(cocoi.birdNo!, farmname: cocoi.formName!, catName: cocoi.catName!,Obsid: cocoi.obsID!,necId: necId as NSNumber)
            
            let cocoi1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let imageName = "Coccidiosis" + "_" + cocoi1.obsName! + "_n"
                var image = UIImage(named:imageName)
                if image == nil {
                    image = UIImage(named:"image001")
                }
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName:   "Coccidiosis",
                    obsName: cocoi1.obsName!,
                    formName: cocoi.formName!,
                    obsVisibility: sender.isOn,
                    birdNo: cocoi.birdNo!,
                    camraImage: image!,
                    obsPoint: incrementValue,
                    obsId: Int(cocoi1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                
            }
            
            dataArrayCocoi.removeAllObjects()
            
            dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(cocoi.birdNo! , farmname: cocoi.formName!, catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleBtnTag2Validation(_ rowIndex: Int, _ sender: UISwitch) {
        if btnTag == 2 {
            
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(gitract.birdNo!, farmname: gitract.formName!, catName: gitract.catName!,Obsid: gitract.obsID!,necId:necId as NSNumber)
            
            let gitract1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let imageName = "GITract" + "_" + gitract1.obsName! + "_n"
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                }
                
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName:   "GITract",
                    obsName: gitract1.obsName!,
                    formName: gitract.formName!,
                    obsVisibility: sender.isOn,
                    birdNo: gitract.birdNo!,
                    camraImage: image!,
                    obsPoint: incrementValue,
                    obsId: Int(gitract1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                
            }
            
            dataArrayGiTract.removeAllObjects()
            
            dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(gitract.birdNo! , farmname: gitract.formName!, catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleBtnTag3Validation(_ rowIndex: Int, _ sender: UISwitch) {
        if btnTag == 3 {
            
            let resp : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            var  necId = getNecId()
            
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(resp.birdNo!, farmname: resp.formName!, catName: resp.catName!,Obsid: resp.obsID!,necId:necId as NSNumber)
            
            let resp1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let imageName = "Resp" + "_" + resp1.obsName! + "_n"
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                    
                }
                
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName:   "Resp",
                    obsName: resp1.obsName!,
                    formName: resp.formName!,
                    obsVisibility: sender.isOn,
                    birdNo: resp.birdNo!,
                    camraImage: image!,
                    obsPoint: incrementValue,
                    obsId: Int(resp1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                
                
            }
            
            dataArrayRes.removeAllObjects()
            
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(resp.birdNo! , farmname: resp.formName!, catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
    }
    
    fileprivate func handleBtnTag4Validation(_ rowIndex: Int, _ sender: UISwitch) {
        if btnTag == 4 {
            
            let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId:necId as NSNumber)
            
            let immune1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let imageName = "Immune" + "_" + immune1.obsName! + "_n"
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                    
                }
                
                let input = CoreDataHandlerTurkeyModels.SkeletaUpdateSwithCaseTurkey(
                    catName:   "Immune",
                    obsName: immune1.obsName!,
                    formName: immune.formName!,
                    obsVisibility: sender.isOn,
                    birdNo: immune.birdNo!,
                    camraImage: image!,
                    obsPoint: incrementValue,
                    obsId: Int(immune1.obsID!),
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwithCaseTurkey(input: input, index: rowIndex)
                
            }
            
            dataArrayImmu.removeAllObjects()
            
            dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
    }
    
    @objc func switchClick(_ sender:UISwitch){
        
        let rowIndex :Int = sender.tag
        
        lastSelectedIndex = IndexPath(row: rowIndex, section: 0)
        
        if btnTag == 0 {
            
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(skleta.birdNo!, farmname: skleta.formName!, catName: skleta.catName!,Obsid: skleta.obsID!,necId:necId as NSNumber)
            
            let skleta1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            handleFetchObs(FetchObsArr, skleta1, skleta, sender, rowIndex, necId)
            
            dataSkeltaArray.removeAllObjects()
            if postingIdFromExistingNavigate == "Exting"{
                necId =  postingIdFromExisting
            } else {
                necId = UserDefaults.standard.integer(forKey: "necId") as Int
            }
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(skleta.birdNo! , farmname: skleta.formName!, catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
        
        handleBtnTag1Validation(rowIndex, sender)
        handleBtnTag2Validation(rowIndex, sender)
        handleBtnTag3Validation(rowIndex, sender)
        handleBtnTag4Validation(rowIndex, sender)
        
        if postingIdFromExistingNavigate == "Exting"{
            
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        }
        else if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            
        }
        else{
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
        
    }
    
    
    @objc func clickImage(_ sender: UIButton) {
        
        
        if btnTag == 0 {
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            photoDict = NSMutableDictionary()
            photoDict.setValue(sender.tag, forKey: "index")
            photoDict.setValue(skleta.formName, forKey: "formName")
            photoDict.setValue(skleta.catName, forKey: "catName")
            photoDict.setValue(skleta.obsName, forKey: "obsName")
            photoDict.setValue(skleta.birdNo, forKey: "birdNo")
            photoDict.setValue(skleta.obsID, forKey: "obsid")
            photoDict.setValue(skleta.necropsyId, forKey: "necId")
        }
        
        if btnTag == 1 {
            let cocoii : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            photoDict = NSMutableDictionary()
            photoDict.setValue(sender.tag, forKey: "index")
            photoDict.setValue(cocoii.formName, forKey: "formName")
            photoDict.setValue(cocoii.catName, forKey: "catName")
            photoDict.setValue(cocoii.obsName, forKey: "obsName")
            photoDict.setValue(cocoii.birdNo, forKey: "birdNo")
            photoDict.setValue(cocoii.obsID, forKey: "obsid")
            photoDict.setValue(cocoii.necropsyId, forKey: "necId")
        }
        
        if btnTag == 2 {
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            photoDict = NSMutableDictionary()
            photoDict.setValue(sender.tag, forKey: "index")
            photoDict.setValue(gitract.formName, forKey: "formName")
            photoDict.setValue(gitract.catName, forKey: "catName")
            photoDict.setValue(gitract.obsName, forKey: "obsName")
            photoDict.setValue(gitract.birdNo, forKey: "birdNo")
            photoDict.setValue(gitract.obsID, forKey: "obsid")
            photoDict.setValue(gitract.necropsyId, forKey: "necId")
        }
        
        if btnTag == 3 {
            let res : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            photoDict = NSMutableDictionary()
            photoDict.setValue(sender.tag, forKey: "index")
            photoDict.setValue(res.formName, forKey: "formName")
            photoDict.setValue(res.catName, forKey: "catName")
            photoDict.setValue(res.obsName, forKey: "obsName")
            photoDict.setValue(res.birdNo, forKey: "birdNo")
            photoDict.setValue(res.obsID, forKey: "obsid")
            photoDict.setValue(res.necropsyId, forKey: "necId")
        }
        
        if btnTag == 4 {
            let immu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            
            photoDict = NSMutableDictionary()
            photoDict.setValue(sender.tag, forKey: "index")
            photoDict.setValue(immu.formName, forKey: "formName")
            photoDict.setValue(immu.catName, forKey: "catName")
            photoDict.setValue(immu.obsName, forKey: "obsName")
            photoDict.setValue(immu.birdNo, forKey: "birdNo")
            photoDict.setValue(immu.obsID, forKey: "obsid")
            photoDict.setValue(immu.necropsyId, forKey: "necId")
        }
        
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "imageTurkey") as? ImageViewTurkeyController
        mapViewControllerObj!.imageDict = photoDict
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
        
    }
    
    
    @objc func takePhoto(_ sender: UIButton) {
        let imageArrWithIsyncIsTrue = CoreDataHandlerTurkey().fecthPhotoWithiSynsTrueTurkey(true)
        if imageArrWithIsyncIsTrue.count == 8 {
            postAlert(Constants.alertStr, message: "Maximum limit of image has been exceeded. Limit will be reset after next sync.")
        }
        else{
            if btnTag == 0 {
                let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
                
                photoDict = NSMutableDictionary()
                photoDict.setValue(sender.tag, forKey: "index")
                photoDict.setValue(skleta.formName, forKey: "formName")
                photoDict.setValue(skleta.catName, forKey: "catName")
                photoDict.setValue(skleta.obsName, forKey: "obsName")
                photoDict.setValue(skleta.birdNo, forKey: "birdNo")
                photoDict.setValue(skleta.obsID, forKey: "obsid")
            }
            
            if btnTag == 1 {
                let cocoii : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
                
                photoDict = NSMutableDictionary()
                photoDict.setValue(sender.tag, forKey: "index")
                photoDict.setValue(cocoii.formName, forKey: "formName")
                photoDict.setValue(cocoii.catName, forKey: "catName")
                photoDict.setValue(cocoii.obsName, forKey: "obsName")
                photoDict.setValue(cocoii.birdNo, forKey: "birdNo")
                photoDict.setValue(cocoii.obsID, forKey: "obsid")
            }
            
            if btnTag == 2 {
                let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
                
                photoDict = NSMutableDictionary()
                photoDict.setValue(sender.tag, forKey: "index")
                photoDict.setValue(gitract.formName, forKey: "formName")
                photoDict.setValue(gitract.catName, forKey: "catName")
                photoDict.setValue(gitract.obsName, forKey: "obsName")
                photoDict.setValue(gitract.birdNo, forKey: "birdNo")
                photoDict.setValue(gitract.obsID, forKey: "obsid")
            }
            
            if btnTag == 3 {
                let res : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
                
                photoDict = NSMutableDictionary()
                photoDict.setValue(sender.tag, forKey: "index")
                photoDict.setValue(res.formName, forKey: "formName")
                photoDict.setValue(res.catName, forKey: "catName")
                photoDict.setValue(res.obsName, forKey: "obsName")
                photoDict.setValue(res.birdNo, forKey: "birdNo")
                photoDict.setValue(res.obsID, forKey: "obsid")
            }
            
            if btnTag == 4 {
                let immu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
                
                photoDict = NSMutableDictionary()
                photoDict.setValue(sender.tag, forKey: "index")
                photoDict.setValue(immu.formName, forKey: "formName")
                photoDict.setValue(immu.catName, forKey: "catName")
                photoDict.setValue(immu.obsName, forKey: "obsName")
                photoDict.setValue(immu.birdNo, forKey: "birdNo")
                photoDict.setValue(immu.obsID, forKey: "obsid")
            }
            
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.cameraCaptureMode = .photo
                    
                    present(imagePicker, animated: true)
                } else {
                    postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                }
            } else {
                postAlert("Camera inaccessable", message: "Application cannot access the camera.")
            }
        }}
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var number = 5
        let numberPointer = UnsafeMutableRawPointer(&number)
        if let pickedImage:UIImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]) as? UIImage {
            self.imageWasSavedSuccessfully(pickedImage, didFinishSavingWithError: nil, context:numberPointer)
            //        let selectorToCall = #selector(CaptureNecropsyDataViewController.imageWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, nil, nil)
        }
        imagePicker.dismiss(animated: true)
    }
    /******************************************************************************************************/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc func imageWasSavedSuccessfully(_ image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if error != nil {
            print(appDelegateObj.testFuntion())
        }
        else {
            DispatchQueue.main.async(execute: { () -> Void in
                
                var necId  = Int()
                
                if self.postingIdFromExistingNavigate == "Exting"{
                    
                    necId =  self.postingIdFromExisting
                }
                else{
                    necId = UserDefaults.standard.integer(forKey: "necId") as Int
                }
                
                let imageData = image.jpegData(compressionQuality: 0.2)
                let compressedImage : UIImage = UIImage(data: imageData!)!
                
                
                let turkeyImageData = CoreDataHandlerTurkeyModels.SkeletalTurkeyImageData(
                    catName: self.photoDict.value(forKey: "catName") as! String, obsName: self.photoDict.value(forKey: "obsName") as! String, formName: self.photoDict.value(forKey: "formName") as! String, birdNo: self.photoDict.value(forKey: "birdNo") as! NSNumber, camraImage: compressedImage, obsId: self.photoDict.value(forKey: "obsid") as! Int , necropsyId : necId as NSNumber, isSync :true
                )
                
                CoreDataHandlerTurkey().saveCaptureSkeletaImageInDatabaseTurkey(turkeyImageData)
                
                
                if self.postingIdFromExistingNavigate == "Exting"{
                    
                    CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(self.postingIdFromExisting as NSNumber)
                    CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(self.postingIdFromExisting as NSNumber, isSync : true)
                    self.printSyncLblCount()
                }
                else if UserDefaults.standard.bool(forKey: "Unlinked") == true{
                    let necId = UserDefaults.standard.integer(forKey: "necId") as Int
                    CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
                    self.printSyncLblCount()
                    
                }
                else{
                    let necId = UserDefaults.standard.integer(forKey: "necId") as Int
                    CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
                    self.printSyncLblCount()
                }
                
                
                self.neccollectionView.reloadData()
            })
        }
    }
    
    func addAcivityIndicator()
    {
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 600, y: view.frame.midY - 25, width: 60, height: 60)
        activityView.backgroundColor = UIColor.white
        activityView.startAnimating()
        
        self.view.alpha = 0.7
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(activityView)
    }
    
    func hideActivityIndicator()
    {
        self.view.alpha = 1
        self.view.isUserInteractionEnabled = true
        self.increaseBirdBtn.isUserInteractionEnabled = true
        self.decBirdNumberBtn.isUserInteractionEnabled = true
        self.addFormBtn.isUserInteractionEnabled = true
        
        activityView.removeFromSuperview()
    }
    
    fileprivate func handlePostingIdFromExistingNavigate() {
        if postingIdFromExistingNavigate == "Exting" {
            
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        } else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
    }
    
    fileprivate func handleAddImmuneResponse(_ status: Bool) {
        if status == true {
            if self.farmRow == 0 {
                self.isFirstTimeLaunch = true
            }
            if self.postingIdFromExistingNavigate == "Exting"{
                self.isFirstTimeLaunch = true
            }
            
            self.neccollectionView.reloadData()
            
            self.birdsCollectionView.reloadData()
            
            //  var frameBird = CGFloat((self.noOfBirdsArr1[self.farmRow] as AnyObject).count) as CGFloat * 60
            var frameBird: CGFloat = 0
            if let birdCount = (self.noOfBirdsArr1[self.farmRow] as AnyObject).count {
                
                switch birdCount {
                case 2:
                    frameBird = 80
                case 3:
                    frameBird = 161
                case 4:
                    frameBird = 237
                case 5:
                    frameBird = 313
                case 6:
                    frameBird = 392
                case 7:
                    frameBird = 468
                case 8:
                    frameBird = 548
                case 9, 10:
                    frameBird = 550
                default:
                    frameBird = CGFloat(birdCount) * 60
                }
            }
            UserDefaults.standard.set((self.noOfBirdsArr1[self.farmRow] as AnyObject).count, forKey: "bird")
            
            
            self.traingleImageView.frame = CGRect(x: 276 + frameBird, y: 229, width: 24, height: 24)
            
            //self.hideActivityIndicator()
            
            self.increaseBirdBtn.isUserInteractionEnabled = true
            self.decBirdNumberBtn.isUserInteractionEnabled = true
            self.addFormBtn.isUserInteractionEnabled = true
            
            let totalNoOfBirdInForm  = (self.noOfBirdsArr1[self.farmRow] as AnyObject).count as Int
            if self.postingIdFromExistingNavigate == "Exting"{
                let birdCount = totalNoOfBirdInForm - 1
                let indxPth = NSIndexPath(item: birdCount, section: 0);
                self.birdsCollectionView!.selectItem(at: indxPth as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
                
            } else {
                
                self.birdsCollectionView!.selectItem(at: IndexPath(item: totalNoOfBirdInForm - 1, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
                
            }
            Helper.dismissGlobalHUD(self.view)
        }
    }
    
    fileprivate func handleAddCocoiResponseData(_ status: Bool) {
        if status == true {
            self.addGitractResponseData(self.noOfBirdsArr1, completion: { (status) in
                if status == true {
                    self.addrespResponseData(self.noOfBirdsArr1, completion: { (status) in
                        if status == true {
                            handleImmuneResponseCompletion(status: status)
                        }
                    })
                }
            })
        }
    }
    
    func handleImmuneResponseCompletion(status: Bool) {
        self.addImmuneResponseData(self.noOfBirdsArr1, completion: { (status) in
            handleAddImmuneResponse(status)
        })
    }
    
    fileprivate func handleFormIndex(_ numOfLoop: Int, _ formIndex: Int, _ isBirdCount: inout Bool?, _ noOfBirdsArr: NSMutableArray, _ i: Int) {
        if numOfLoop > 10 {
            if formIndex == self.farmRow + 1 {
                isBirdCount = true
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: "You can not add more than 10 birds")
                self.view.alpha = 1
                self.view.isUserInteractionEnabled = true
                self.increaseBirdBtn.isUserInteractionEnabled = true
                self.decBirdNumberBtn.isUserInteractionEnabled = true
                self.addFormBtn.isUserInteractionEnabled = true
                Helper.dismissGlobalHUD(self.view)
            }
        } else {
            noOfBirdsArr.add(i + 1)
        }
    }
    
    
    
    
    
    fileprivate func handleCaptureNecropsy(_ isBirdCount: inout Bool?) {
        for object in self.captureNecropsy {
            let formIndexVal =  (object.value(forKey: "farmName")! as AnyObject).substring(with: NSRange(location: 0, length: 1)) as String
            let formIndex = Int(formIndexVal)! as Int
            let noOfBirds : Int = Int(object.value(forKey: "noOfBirds") as! String)!
            
            let noOfBirdsInFarmArr  = NSMutableArray()
            
            var  numOfLoop = 0
            for i in 0..<noOfBirds {
                numOfLoop = i  + 1
                
                handleFormIndex(numOfLoop, formIndex, &isBirdCount, noOfBirdsInFarmArr, i)
            }
            
            self.items.add(noOfBirdsInFarmArr)
            noOfBirdsArr1.add(noOfBirdsInFarmArr)
            
        }
    }
    
    func addBirdResponseData() { //(completion: (status: Bool) -> Void) {
        
        isFirstTimeLaunch = false
        
        var isBirdCount : Bool! = false
        
        var postingId = Int()
        if postingIdFromExistingNavigate == "Exting" {
            postingId = postingIdFromExisting
            
            self.items.removeAllObjects()
            
            CoreDataHandlerTurkey().updateBirdNumberInNecropsystep1withNecIdTurkey(postingId as NSNumber, index: self.farmRow,isSync :true)
            
            noOfBirdsArr1  = NSMutableArray()
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(postingId as NSNumber) as! [NSManagedObject]
        } else {
            postingId = UserDefaults.standard.integer(forKey: "necId") as Int
            self.items.removeAllObjects()
            
            CoreDataHandlerTurkey().updateBirdNumberInNecropsystep1withNecIdTurkey(postingId as NSNumber, index: self.farmRow,isSync :true)
            
            noOfBirdsArr1  = NSMutableArray()
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(postingId as NSNumber) as! [NSManagedObject]
        }
        
        handleCaptureNecropsy(&isBirdCount)
        
        self.addBirdInNotes()
        
        if isBirdCount == false {
            
            self.addSkeltonResponseData(noOfBirdsArr1) { (status) in
                if status == true {
                    self.addCocoiResponseData(self.noOfBirdsArr1, completion: { (status) in
                        handleAddCocoiResponseData(status)
                    })
                }
            }
        }
        
        handlePostingIdFromExistingNavigate()
    }
    
    func loadMoveScroll() {
        let totalNoOfBirdInForm  = (self.noOfBirdsArr1[self.farmRow] as AnyObject).count as Int
        let birdCount = totalNoOfBirdInForm - 1
        
        let indxPth = NSIndexPath(item: birdCount, section: 0);
        self.birdsCollectionView!.selectItem(at: indxPth as IndexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        Helper.dismissGlobalHUD(self.view)
    }
    
    func addSkeltonResponseData (_ noOfBirdsArr1: NSMutableArray,completion: (_ status: Bool) -> Void) {
        let formName = UserDefaults.standard.value(forKey: "farm") as! String
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        let skeletenArr = CoreDataHandlerTurkey().fetchAllSeettingdataWithLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        for i in 0..<skeletenArr.count {
            if ((skeletenArr.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                
                let skleta : SkeletaTurkey = skeletenArr.object(at: i) as! SkeletaTurkey
                switch skleta.measure {
                case "Y,N","Actual":
                    let necId = getNecId()
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "skeltaMuscular",
                        obsName: skleta.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: skleta.observationId!.intValue,
                        measure: skleta.measure!,
                        quickLink: skleta.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: skleta.refId!,
                        actualText: skleta.measure ?? ""
                    )
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                default:
                    let trimmed = skleta.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    
                    let necId = getNecId()
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "skeltaMuscular",
                        obsName: skleta.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: Int(array[0])!,
                        index: self.items.count,
                        obsId: skleta.observationId!.intValue,
                        measure: skleta.measure!,
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
        
        self.dataSkeltaArray.removeAllObjects()
        let necId = getNecId()
        self.dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey((noOfBirdsArr1[self.farmRow] as AnyObject).count! as NSNumber, farmname: formName , catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        completion (true)
    }
    
    func addCocoiResponseData (_ noOfBirdsArr1: NSMutableArray,completion: (_ status: Bool) -> Void) {
        
        var formName =  UserDefaults.standard.value(forKey: "farm") as! String
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let cocoiArr = CoreDataHandlerTurkey().fetchAllCocoiiDataUsinglngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        for i in 0..<cocoiArr.count
        {
            if ((cocoiArr.object(at: i) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                
                let cocoiDis : CoccidiosisTurkey = cocoiArr.object(at: i) as! CoccidiosisTurkey
                
                if cocoiDis.measure! == "Y,N" || cocoiDis.measure! == "Actual" {
                    
                    var necId = getNecId()
                    
                    
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Coccidiosis",
                        obsName: cocoiDis.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: cocoiDis.observationId!.intValue,
                        measure: cocoiDis.measure!,
                        quickLink: cocoiDis.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: cocoiDis.refId!,
                        actualText: cocoiDis.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    
                }
                
                else
                {
                    let trimmed = cocoiDis.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    
                    var necId = getNecId()
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Coccidiosis",
                        obsName: cocoiDis.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: Int(array[0])!,
                        index: self.items.count,
                        obsId: cocoiDis.observationId!.intValue,
                        measure: cocoiDis.measure!,
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
        
        self.dataArrayCocoi.removeAllObjects()
        
        var  necId = getNecId()
        self.dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey((noOfBirdsArr1[self.farmRow] as AnyObject).count as! NSNumber, farmname: formName , catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
        
    }
    
    
    func addGitractResponseData (_ noOfBirdsArr1: NSMutableArray,completion: (_ status: Bool) -> Void) {
        
        
        var formName  = UserDefaults.standard.value(forKey: "farm") as! String
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let gitract1 =  CoreDataHandlerTurkey().fetchAllGITractDataUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for  j in 0..<gitract1.count
        {
            if ((gitract1.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                
                let gitract2 : GITractTurkey = gitract1.object(at: j) as! GITractTurkey
                
                if gitract2.measure! == "Y,N" || gitract2.measure! == "Actual" {
                    
                    var necId = getNecId()
                    
                    
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "GITract",
                        obsName: gitract2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: gitract2.observationId!.intValue,
                        measure: gitract2.measure!,
                        quickLink: gitract2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: gitract2.refId!,
                        actualText: gitract2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                }
                
                else
                {
                    let trimmed = gitract2.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    var necId = getNecId()
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "GITract",
                        obsName: gitract2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: Int(array[0])!,
                        index: self.items.count,
                        obsId: gitract2.observationId!.intValue,
                        measure: gitract2.measure!,
                        quickLink: gitract2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: gitract2.refId!,
                        actualText: gitract2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    
                    
                }
                
            }
        }
        
        
        self.dataArrayGiTract.removeAllObjects()
        
        var  necId = getNecId()
        
        self.dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey((noOfBirdsArr1[self.farmRow] as AnyObject).count as! NSNumber, farmname: formName , catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
        
    }
    
    func addrespResponseData (_ noOfBirdsArr1: NSMutableArray,completion: (_ status: Bool) -> Void) {
        
        var formName = UserDefaults.standard.value(forKey: "farm") as! String
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let resp1 =  CoreDataHandlerTurkey().fetchAllRespiratoryusingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        for  j in 0..<resp1.count
        {
            if ((resp1.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                let resp2 : RespiratoryTurkey = resp1.object(at: j) as! RespiratoryTurkey
                if resp2.measure! == "Y,N" || resp2.measure! == "Actual" {
                    var necId = getNecId()
                    
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Resp",
                        obsName: resp2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: resp2.observationId!.intValue,
                        measure: resp2.measure!,
                        quickLink: resp2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: resp2.refId!,
                        actualText: resp2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                }
                else
                {
                    let trimmed = resp2.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    
                    let necId = getNecId()
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Resp",
                        obsName: resp2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: Int(array[0])!,
                        index: self.items.count,
                        obsId: resp2.observationId!.intValue,
                        measure: resp2.measure!,
                        quickLink: resp2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: resp2.refId!,
                        actualText: resp2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    
                }
            }
        }
        
        self.dataArrayRes.removeAllObjects()
        
        var  necId = getNecId()
        
        self.dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey((noOfBirdsArr1[self.farmRow] as AnyObject).count as! NSNumber, farmname: formName , catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
        
    }
    
    func addImmuneResponseData (_ noOfBirdsArr1: NSMutableArray,completion: (_ status: Bool) -> Void) {
        
        var formName = UserDefaults.standard.value(forKey: "farm") as! String
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        UserDefaults.standard.synchronize()
        let immu1 =   CoreDataHandlerTurkey().fetchAllImmuneUsingLngIdTurkey(lngId: lngId as NSNumber).mutableCopy() as! NSMutableArray
        
        for  j in 0..<immu1.count
        {
            if ((immu1.object(at: j) as AnyObject).value(forKey: "visibilityCheck") as AnyObject).int32Value == 1 {
                let immune2 : ImmuneTurkey = immu1.object(at: j) as! ImmuneTurkey
                if immune2.measure! == "Y,N" {
                    
                    var necId = getNecId()
                    
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Immune",
                        obsName: immune2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: immune2.observationId!.intValue,
                        measure: immune2.measure!,
                        quickLink: immune2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: immune2.refId!,
                        actualText: immune2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                }
                else if ( immune2.measure! == "Actual"){
                    var necId = getNecId()
                    
                    let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                        catName: "Immune",
                        obsName: immune2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count! as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: immune2.observationId!.intValue,
                        measure: immune2.measure!,
                        quickLink: immune2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: immune2.refId!,
                        actualText: immune2.measure ?? ""
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                    
                    let farmWeight =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkeyWithFarmName(formName ,necropsyId:necId as NSNumber)
                    
                    let arrdata = farmWeight.object(at: 0) as! CaptureNecropsyDataTurkey
                    var result: Double
                    if arrdata.farmWeight! != ""{
                        result = Double(arrdata.farmWeight!)! / Double(arrdata.noOfBirds!)!
                    }
                    else{
                        result = 0.0
                    }
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkeyBodyWeight("Immune", obsName: immune2.observationField!, formName: formName, obsPoint: Int(result), index: self.items.count, necId:  necId as NSNumber, isSync: true)
                    
                }
                
                else if immune2.measure! == "F,M" {
                    
                    var necId = getNecId()
                    
                    let data = CoreDataHandlerTurkeyModels.turkeySexNecropsyData(
                        catName: "Immune",
                        obsName: immune2.observationField!,
                        formName: formName,
                        obsVisibility: false,
                        birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                        obsPoint: 0,
                        index: self.items.count,
                        obsId: immune2.observationId!.intValue,
                        measure: immune2.measure!,
                        quickLink: immune2.quicklinks!,
                        necId: necId as NSNumber,
                        isSync: true,
                        lngId: lngId as NSNumber,
                        refId: immune2.refId!,
                        actualText: "0"
                    )
                    
                    CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkeySex(data: data)
                    
                }
                else
                {
                    let trimmed = immune2.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    
                    if immune2.observationField == "Bursa Size"
                    {
                        
                        var necId = getNecId()
                        
                        
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Immune",
                            obsName: immune2.observationField!,
                            formName: formName,
                            obsVisibility: false,
                            birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                            obsPoint: Int(array[3])!,
                            index: self.items.count,
                            obsId: immune2.observationId!.intValue,
                            measure: immune2.measure!,
                            quickLink: immune2.quicklinks!,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: immune2.refId!,
                            actualText: immune2.measure ?? ""
                        )
                        
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                        
                        
                    }
                    else
                    {
                        
                        var necId = getNecId()
                        let data = CoreDataHandlerTurkeyModels.switchCaseCaptureSkeletaDataTurkey(
                            catName: "Immune",
                            obsName: immune2.observationField!,
                            formName: formName,
                            obsVisibility: false,
                            birdNo: (noOfBirdsArr1[self.farmRow] as AnyObject).count as NSNumber,
                            obsPoint: Int(array[0])!,
                            index: self.items.count,
                            obsId: immune2.observationId!.intValue,
                            measure: immune2.measure!,
                            quickLink: immune2.quicklinks!,
                            necId: necId as NSNumber,
                            isSync: true,
                            lngId: lngId as NSNumber,
                            refId: immune2.refId!,
                            actualText: immune2.measure ?? ""
                        )
                        
                        CoreDataHandlerTurkey().saveCaptureSkeletaInDatabaseOnSwithCaseTurkey(data)
                        
                        
                    }
                    
                }
            }
        }
        
        self.dataArrayImmu.removeAllObjects()
        
        var  necId = getNecId()
        
        
        self.dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey((noOfBirdsArr1[self.farmRow] as AnyObject).count as! NSNumber, farmname: formName, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        
        completion (true)
        
    }
    
    @objc func saveSuccess()
    {
        self.addBirdResponseData()
    }
    
    fileprivate func handleValidations(_ farmName: String, _ noOfBird: Int) {
        if dataSkeltaArray.count > 0 {
            
            var  necId = getNecId()
            
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: 0) as! CaptureNecropsyViewDataTurkey
            CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey(skleta.obsID!, formName: farmName , catName: skleta.catName!, birdNo: noOfBird as NSNumber, necId : necId as NSNumber)
            
            dataSkeltaArray.removeAllObjects()
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(1, farmname: farmName , catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if dataArrayCocoi.count > 0 {
            
            var necId = getNecId()
            
            let skleta1 : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: 0) as! CaptureNecropsyViewDataTurkey
            CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey(skleta1.obsID!, formName: farmName , catName: skleta1.catName!, birdNo: noOfBird as NSNumber, necId : necId as NSNumber)
            
            dataArrayCocoi.removeAllObjects()
            
            dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(1, farmname: farmName , catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
        if dataArrayGiTract.count > 0 {
            
            var  necId = getNecId()
            
            let skleta2 : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: 0) as! CaptureNecropsyViewDataTurkey
            CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey(skleta2.obsID!, formName: farmName , catName: skleta2.catName!, birdNo: noOfBird as NSNumber, necId : necId as NSNumber)
            
            dataArrayGiTract.removeAllObjects()
            dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(1, farmname: farmName , catName: "GITract",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
        
        
        if dataArrayRes.count > 0 {
            
            var necId = getNecId()
            
            let skleta3 : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: 0) as! CaptureNecropsyViewDataTurkey
            CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey(skleta3.obsID!, formName: farmName , catName: skleta3.catName!, birdNo:noOfBird as NSNumber, necId : necId as NSNumber)
            
            dataArrayRes.removeAllObjects()
            
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(1, farmname: farmName , catName: "Resp",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
    }
    
    fileprivate func manageFarmArray() {
        for i in 0..<farmArray.count {
            let formName = farmArray.object(at: i)
            
            var necId = getNecId()
            
            let isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithFormTurkey("skeltaMuscular", formName: formName as! String,necId: necId as NSNumber)
            
            let noOfBird = isNotes.count as Int
            
            let noOfBirdsArrSkelt  = NSMutableArray()
            
            for i in 0..<noOfBird {
                
                noOfBirdsArrSkelt.add(i+1)
                
            }
            items.add(noOfBirdsArrSkelt)
        }
    }
    
    fileprivate func handleDataArrayImmu(_ farmName: String, _ noOfBird: Int) {
        if dataArrayImmu.count > 0 {
            
            var necId = getNecId()
            
            let skleta4 : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
            CoreDataHandlerTurkey().deleteCaptureNecropsyViewDataWithFarmnameandBirdsizeTurkey(skleta4.obsID!, formName: farmName , catName: skleta4.catName!, birdNo: noOfBird as NSNumber, necId : necId as NSNumber)
            let farmWeight =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkeyWithFarmName(farmName ,necropsyId:necId as NSNumber)
            
            
            let arrdata = farmWeight.object(at: 0) as! CaptureNecropsyDataTurkey
            var result: Double
            result = 0.0
            if arrdata.farmWeight! != "" {
                result = Double(arrdata.farmWeight!)! / Double(arrdata.noOfBirds!)!
            }
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkeyBodyWeight("Immune", obsName: skleta4.obsName!, formName: farmName, obsPoint: Int(result), index: self.items.count, necId:  necId as NSNumber, isSync: true)
            
            dataArrayImmu.removeAllObjects()
            dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(1, farmname: farmName , catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        }
    }
    
    fileprivate func handleFarmRow() {
        if self.farmRow == 0 {
            self.isFirstTimeLaunch = true
        }
        if postingIdFromExistingNavigate == "Exting"{
            self.isFirstTimeLaunch = true
        }
    }
    
    fileprivate func handleCoreDataValidation(_ postingId: Int) {
        if CoreDataHandlerTurkey().reduceBirdNumberInNecropsystep1WithNecIdTurkey(postingId as NSNumber, index: self.farmRow) == true {
            
            var  farmName = UserDefaults.standard.value(forKey: "farm") as! String
            var  necId = getNecId()
            
            let isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithFormTurkey("skeltaMuscular", formName: farmName, necId: necId as NSNumber)
            
            let noOfBird = isNotes.count as Int
            
            if noOfBird == 1 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:oneBirdRequiredStr)
                
                traingleImageView.frame = CGRect(x: 276, y: 229, width: 24, height: 24)
                
            }
            
            items.removeAllObjects()
            
            CoreDataHandlerTurkey().deleteNotesBirdWithFarmnameTurkey(farmName, birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
            
            handleValidations(farmName, noOfBird)
            handleDataArrayImmu(farmName, noOfBird)
            
            manageFarmArray()
            
            handleFarmRow()
            
            neccollectionView.reloadData()
            birdsCollectionView.reloadData()
            birdsCollectionView.selectItem(at: IndexPath(item: 0 , section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            
        } else {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:oneBirdRequiredStr)
        }
    }
    
    func deleteBirdResponseData (_ completion: (_ status: Bool) -> Void) {
        
        var postingId = Int()
        if postingIdFromExistingNavigate == "Exting"{
            postingId = postingIdFromExisting
        } else {
            postingId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        handleCoreDataValidation(postingId)
        
        traingleImageView.frame = CGRect(x: 276, y: 229, width: 24, height: 24)
        
        if postingIdFromExistingNavigate == "Exting" {
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        } else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
        
        completion (true)
    }
    
    @objc func deleteSuccess() {
        
        self.deleteBirdResponseData { (status) in
            if status == true {
                Helper.dismissGlobalHUD(self.view)
                self.increaseBirdBtn.isUserInteractionEnabled = true
                self.decBirdNumberBtn.isUserInteractionEnabled = true
                self.addFormBtn.isUserInteractionEnabled = true
                UserDefaults.standard.set(1, forKey: "bird")
            }
        }
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = birdsCollectionView.indexPathForItem(at: touchPoint) {
                let cell = birdsCollectionView.cellForItem(at: indexPath)
                let testButton = UIButton(frame: CGRect(x: 0, y: 20, width:20, height: 20))
                testButton.backgroundColor = .green
                testButton.setTitle("Test Button", for: UIControl.State())
                testButton.addTarget(self, action:#selector(CaptureNecroStep2Turkey.buttonAction(_:)), for: .touchUpInside)
                cell?.contentView.addSubview(testButton)
                testButton.tag  = indexPath.row
            }
        }
    }
    
    @objc func buttonAcn(_ sender: UIButton!) {
        summaryRepo.removeFromSuperview()
        backBttnn.removeFromSuperview()
    }
    
    func yesButtonFunc (){
        CommonClass.sharedInstance.updateCountTurkey()
        let navigateContrler = self.storyboard?.instantiateViewController(withIdentifier: "ReportTurkey") as? ReportDashboardTurkey
        AllValidSessions.sharedInstance.complexName = lblComplex.text as NSString? ?? ""
        AllValidSessions.sharedInstance.complexDate = lblDate.text as NSString? ?? ""
        self.navigationController?.pushViewController(navigateContrler ?? UIViewController(), animated: false)
    }
    
    func noButtonFunc (){
        CommonClass.sharedInstance.updateCountTurkey()
        let navigateContrler = self.storyboard?.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as? DashViewControllerTurkey
        AllValidSessions.sharedInstance.complexName = ""
        self.navigationController?.pushViewController(navigateContrler!, animated: false)
    }
    
    func crossButtonFunct (){
        summaryRepo.removeFromSuperview()
        backBttnn.removeFromSuperview()
    }
    
    
    @objc func buttonAction(_ sender: UIButton!) {
        items.removeObject(at: sender.tag)
        let btn = sender as UIButton
        btn .removeFromSuperview()
        birdsCollectionView.reloadData()
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: 500))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: 500))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // MARK: - COLLECTION VIEW DATA SOURCE AND DELEGATES
    
    fileprivate func existingFarmCount() -> Int {
        if postingIdFromExistingNavigate == "Exting"{
            
            return (items[self.farmRow] as AnyObject).count
            
        }
        else
        {
            return (items[0] as AnyObject).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView == birdsCollectionView {
            if isFarmClick == true {
                return (items[self.farmRow] as AnyObject).count
            }
            
            if items.count > 0 {
                
                if isFirstTimeLaunch == true
                {
                    return existingFarmCount()
                }
                else {
                    if farmRow == 0 {
                        return (items[0] as AnyObject).count
                        
                    } else {
                        
                        if Constants.isForUnlinkedTurkey == true
                        {
                            return (items[farmArray.count - 1] as AnyObject).count
                        }
                        else
                        {
                            //  return (items[selectedFarmIndexTurkey] as AnyObject).count
                            return (items[farmRow] as AnyObject).count
                        }
                    }
                }
            }
            return 0
            
        } else if collectionView == neccollectionView {
            switch btnTag {
            case 0:
                return dataSkeltaArray.count
            case 1:
                return dataArrayCocoi.count
            case 2:
                return dataArrayGiTract.count
            case 3:
                return dataArrayRes.count
            default:
                return dataArrayImmu.count
            }
        }
        else if collectionView == formCollectionView{
            return self.farmArray.count
        }
        return 0
    }
    // make a cell for each cell index path
    fileprivate func handleBirdsCollectionViewBtnTag0(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        var isNotes = NSArray()
        if dataSkeltaArray.count > 0 {
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: 0) as! CaptureNecropsyViewDataTurkey
            let formName = skleta.formName
            let catName = skleta.catName
            let noOfBird  = indexPath.row + 1
            
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName! , formName: formName! , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
            
        } else {
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            let catName = "skeltaMuscular"
            let noOfBird  = indexPath.row + 1
            
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName , formName: formName , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        
        if isNotes.count > 0
        {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            if (note.notes == "")
            {
                cell.editImage.alpha = 0
            }
            else
            {
                cell.editImage.alpha = 1
            }
        }
        else
        {
            cell.editImage.alpha = 0
        }
    }
    
    fileprivate func handleBirdsCollectionViewBtnTag1(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        var isNotes = NSArray()
        if dataArrayCocoi.count>0
        {
            let cocoii : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: 0) as! CaptureNecropsyViewDataTurkey
            
            let formName = cocoii.formName
            let catName = cocoii.catName
            let noOfBird  = indexPath.row + 1
            
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName! , formName: formName! , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        else
        {
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            let catName = "Coccidiosis"
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName , formName: formName , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        
        if isNotes.count > 0
        {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            if (note.notes == "")
            {
                cell.editImage.alpha = 0
            }
            else
            {
                cell.editImage.alpha = 1
            }
        }
        
        else
        {
            cell.editImage.alpha = 0
        }
    }
    
    fileprivate func handleBirdsCollectionViewBtnTag2(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        var isNotes = NSArray()
        if dataArrayGiTract.count > 0
        {
            
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: 0) as! CaptureNecropsyViewDataTurkey
            let formName = gitract.formName
            let catName = gitract.catName
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName! , formName: formName! , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
            
        }
        else
        {
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            let catName = "GITract"
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName , formName: formName , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        
        
        if isNotes.count > 0
        {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            if (note.notes == "")
            {
                cell.editImage.alpha = 0
            }
            else
            {
                cell.editImage.alpha = 1
            }
        }
        else
        {
            cell.editImage.alpha = 0
            
        }
    }
    
    fileprivate func handleBirdsCollectionViewBtnTag3(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        var isNotes = NSArray()
        if dataArrayRes.count>0
        {
            let res : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: 0) as! CaptureNecropsyViewDataTurkey
            
            let formName = res.formName
            let catName = res.catName
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName! , formName: formName! , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
            
        }
        else
        {
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            let catName = "Resp"
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName , formName: formName , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        
        
        if isNotes.count > 0
        {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            if (note.notes == "")
            {
                cell.editImage.alpha = 0
            }
            else
            {
                cell.editImage.alpha = 1
            }
        }
        
        else
        {
            cell.editImage.alpha = 0
        }
    }
    
    fileprivate func handleBirdsCollectionViewBtnTag4(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        var isNotes = NSArray()
        if dataArrayImmu.count>0{
            let immu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
            
            let formName = immu.formName
            let catName = immu.catName
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName! , formName: formName! , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        else{
            
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            let catName = "Immune"
            let noOfBird  = indexPath.row + 1
            var  necId = getNecId()
            
            isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName , formName: formName , birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
        }
        
        if isNotes.count > 0
        {
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            if (note.notes == "")
            {
                cell.editImage.alpha = 0
            }
            else
            {
                cell.editImage.alpha = 1
                
            }
            
        }
        
        else
        {
            cell.editImage.alpha = 0
            
        }
    }
    
    fileprivate func handleBirdsCollectionViewIsFarmClickFalseCase(_ cell: CaptureNecroStep2TurkeyCell, _ indexPath: IndexPath) {
        if isNewFarm == true
        {
            cell.birdsCountLabel?.text =  String(describing:((items.object(at: farmArray.count-1) as AnyObject).object(at: indexPath.row) ))
        }
        else
        {
            if isFirstTimeLaunch == true
            {
                if postingIdFromExistingNavigate == "Exting"{
                    cell.birdsCountLabel?.text =  String(describing:((items.object(at: self.farmRow)  as AnyObject).object(at: indexPath.row)))
                } else {
                    cell.birdsCountLabel?.text =  String(describing:((items.object(at: 0) as AnyObject).object(at: indexPath.row)))
                }
                
            } else {
                cell.birdsCountLabel?.text =  String(describing: ((items.object(at: farmRow) as AnyObject).object(at: indexPath.row) ))
            }
        }
    }
    
    fileprivate func handleNeccollectionViewBtnTag0(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
        let measure = skleta.measure
        cell.mesureValue = measure!
        cell.myLabel.text = skleta.obsName
        var  necId = getNecId()
        
        cell.turkeySexView.alpha = 0
        cell.turkeySexView.isHidden = true
        
        
        
        let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(skleta.birdNo!, farmname: skleta.formName!, catName: skleta.catName!, Obsid: skleta.obsID!, obsName: skleta.obsName!,necId: necId as NSNumber)
        if photoArr.count > 0
        {
            cell.badgeButton.alpha = 1
            cell.badgeButton.badgeString = String(photoArr.count) as String
            cell.badgeButton.badgeTextColor = UIColor.white
            cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
        }
        else
        {
            cell.badgeButton.alpha = 0
        }
        
        if measure == "Y,N" {
            
            let n  = String(describing: skleta.refId!)
            let imageName = "skeltaMuscular" + "_" + n + "_n"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            
            if skleta.objsVisibilty == 1 {
                cell.switchNecropsyBtn.isOn = true
            } else {
                cell.switchNecropsyBtn.isOn = false
            }
            
            cell.switchNecropsyBtn.alpha = 1
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 0
        }
        else if ( measure == "Actual"){
            
            let image = UIImage(named:"image001")
            cell.observationImage.image =  image
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 1
            cell.textFieldActual.text = skleta.actualText
        }
        else {
            let n  = String(describing: skleta.refId!)
            let imageName = "skeltaMuscular" + "_" + n + "_00"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            cell.observationImage.image =  image
            
            cell.incrementLabel.text = String(skleta.obsPoint!.int32Value)
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 1
            cell.minusButton.alpha = 1
            cell.incrementLabel.alpha = 1
            cell.textFieldActual.alpha = 0
        }
    }
    
    fileprivate func handleNeccollectionViewBtnTag1(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        let cocoii : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
        cell.myLabel.text = cocoii.obsName
        let measure = cocoii.measure
        cell.mesureValue = measure!
        cell.turkeySexView.alpha = 0
        cell.turkeySexView.isHidden = true
        var necId = getNecId()
        
        let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(cocoii.birdNo!, farmname: cocoii.formName!, catName: cocoii.catName!, Obsid: cocoii.obsID!, obsName: cocoii.obsName!,necId: necId as NSNumber)
        if photoArr.count > 0
        {
            cell.badgeButton.alpha = 1
            cell.badgeButton.badgeString = String(photoArr.count) as String
            cell.badgeButton.badgeTextColor = UIColor.white
            cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
        }
        else
        {
            cell.badgeButton.alpha = 0
        }
        if measure == "Y,N" {
            
            let n  = String(describing: cocoii.refId!)
            let imageName = "Coccidiosis" + "_" + n + "_n"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            
            if cocoii.objsVisibilty == 1
            {
                cell.switchNecropsyBtn.isOn = true
            }
            else
            {
                cell.switchNecropsyBtn.isOn = false
            }
            
            cell.switchNecropsyBtn.alpha = 1
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 0
            
        }
        
        else if ( measure == "Actual"){
            
            let image = UIImage(named:"image001")
            cell.observationImage.image =  image
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 1
            cell.textFieldActual.text = cocoii.actualText
            
        }
        
        else{
            let n  = String(describing: cocoii.refId!)
            let imageName = "Coccidiosis" + "_" + n + "_00"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            cell.incrementLabel.text = String(cocoii.obsPoint!.int32Value)
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 1
            cell.minusButton.alpha = 1
            cell.incrementLabel.alpha = 1
            cell.textFieldActual.alpha = 0
            
        }
    }
    
    fileprivate func handleNeccollectionViewBtnTag2(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
        cell.myLabel.text = gitract.obsName
        cell.turkeySexView.alpha = 0
        cell.turkeySexView.isHidden = true
        let measure = gitract.measure
        cell.mesureValue = measure!
        var necId = getNecId()
        
        
        let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(gitract.birdNo!, farmname: gitract.formName!, catName: gitract.catName!, Obsid: gitract.obsID!, obsName: gitract.obsName!,necId: necId as NSNumber)
        if photoArr.count > 0
        {
            cell.badgeButton.alpha = 1
            cell.badgeButton.badgeString = String(photoArr.count) as String
            cell.badgeButton.badgeTextColor = UIColor.white
            cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
        }
        else
        {
            cell.badgeButton.alpha = 0
            
        }
        
        if measure == "Y,N" {
            
            let n  = String(describing: gitract.refId!)
            
            let imageName = "GITract" + "_" + n + "_n"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            
            if gitract.objsVisibilty == 1
            {
                cell.switchNecropsyBtn.isOn = true
            }
            else
            {
                cell.switchNecropsyBtn.isOn = false
            }
            
            cell.switchNecropsyBtn.alpha = 1
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 0
            
        }
        
        else if ( measure == "Actual"){
            let image = UIImage(named:"image001")
            
            cell.observationImage.image =  image
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 1
            cell.textFieldActual.text = gitract.actualText
            
        }
        
        else{
            let n  = String(describing: gitract.refId!)
            let imageName = "GITract" + "_" + n + "_00"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            cell.incrementLabel.text = String(gitract.obsPoint!.int32Value)
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 1
            cell.minusButton.alpha = 1
            cell.incrementLabel.alpha = 1
            cell.textFieldActual.alpha = 0
            
        }
    }
    
    fileprivate func handleNeccollectionViewBtnTag3(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        let res : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
        cell.myLabel.text = res.obsName
        cell.turkeySexView.alpha = 0
        cell.turkeySexView.isHidden = true
        let measure = res.measure
        cell.mesureValue = measure!
        var necId = getNecId()
        
        
        let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(res.birdNo!, farmname: res.formName!, catName: res.catName!, Obsid: res.obsID!, obsName: res.obsName!,necId: necId as NSNumber)
        if photoArr.count > 0
        {
            cell.badgeButton.alpha = 1
            cell.badgeButton.badgeString = String(photoArr.count) as String
            cell.badgeButton.badgeTextColor = UIColor.white
            cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
        }
        else
        {
            cell.badgeButton.alpha = 0
        }
        
        if measure == "Y,N" {
            
            let n  = String(describing: res.refId!)
            let imageName = "Resp" + "_" + n + "_n"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            
            if res.objsVisibilty == 1
            {
                cell.switchNecropsyBtn.isOn = true
            }
            else
            {
                cell.switchNecropsyBtn.isOn = false
            }
            
            cell.switchNecropsyBtn.alpha = 1
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 0
            
        }
        
        else if ( measure == "Actual"){
            
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 1
            cell.textFieldActual.text = res.actualText
            let image = UIImage(named:"image001")
            
            cell.observationImage.image =  image
        }
        
        else{
            let n  = String(describing: res.refId!)
            let imageName = "Resp" + "_" + n + "_00"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            cell.observationImage.image =  image
            
            cell.incrementLabel.text = String(res.obsPoint!.int32Value)
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 1
            cell.minusButton.alpha = 1
            cell.incrementLabel.alpha = 1
            cell.textFieldActual.alpha = 0
            
        }
    }
    
    fileprivate func handleNeccollectionViewBtnTagMeasureYN(_ immu: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell) {
        let n  = String(describing: immu.refId!)
        let imageName = "Immune" + "_" + n + "_n"
        var image = UIImage(named:imageName)
        if image == nil
        {
            image = UIImage(named:"image001")
        }
        cell.observationImage.frame = CGRect(x: 0, y: 0, width: 235, height: 343)
        
        if n == "1960" {
            cell.observationImage.frame = CGRect(x: 0, y: 0, width: 235, height: 235)
        }
        cell.observationImage.image =  image
        
        if immu.objsVisibilty == 1
        {
            cell.switchNecropsyBtn.isOn = true
        }
        else
        {
            cell.switchNecropsyBtn.isOn = false
        }
        
        cell.switchNecropsyBtn.alpha = 1
        cell.plusButton.alpha = 0
        cell.minusButton.alpha = 0
        cell.incrementLabel.alpha = 0
        cell.textFieldActual.alpha = 0
        cell.turkeySexView.alpha = 0
        cell.turkeySexView.isHidden = true
    }
    
    fileprivate func handleNeccollectionViewOtherValidations(_ measure: String?, _ immu: CaptureNecropsyViewDataTurkey, _ cell: CaptureNecroStep2TurkeyCell) {
        if measure == "Y,N" {
            
            handleNeccollectionViewBtnTagMeasureYN(immu, cell)
            
        } else if ( measure == "Actual"){
            
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 1
            cell.textFieldActual.text = immu.actualText
            let image = UIImage(named:"image001")
            cell.observationImage.image =  image
            cell.turkeySexView.alpha = 0
            cell.turkeySexView.isHidden = true
        } else if ( measure == "F,M") {
            
            let n  = String(describing: immu.refId!)
            let imageName = "Immune" + "_" + n + "_n"
            var image = UIImage(named:imageName)
            if image == nil
            {
                image = UIImage(named:"image001")
            }
            
            cell.observationImage.image =  image
            
            if immu.actualText == "0"  || immu.actualText == "0.0" || immu.actualText == "0.00"
            {
                cell.turkeySexLbl.text = "N/A"
            }
            else if immu.actualText == "2" || immu.actualText == "2.00" || immu.actualText == "2.0"
            {
                cell.turkeySexLbl.text = "Female"
            }
            else
            {
                cell.turkeySexLbl.text = "Male"
            }
            cell.turkeySexView.alpha = 1
            cell.turkeySexView.isHidden = false
            cell.switchNecropsyBtn.alpha = 0
            cell.plusButton.alpha = 0
            cell.minusButton.alpha = 0
            cell.incrementLabel.alpha = 0
            cell.textFieldActual.alpha = 0
            
        } else {
            cell.turkeySexView.alpha = 0
            cell.turkeySexView.isHidden = true
            
            if immu.refId == 58
            {
                let n  = String(describing: immu.refId!)
                let imageName = "Immune" + "_" + n + "_01"
                
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                }
                
                cell.observationImage.image =  image
                cell.incrementLabel.text = String(immu.obsPoint!.int32Value)
                cell.switchNecropsyBtn.alpha = 0
                cell.plusButton.alpha = 1
                cell.minusButton.alpha = 1
                cell.incrementLabel.alpha = 1
                cell.textFieldActual.alpha = 0
            }
            else
            {
                let n  = String(describing: immu.refId!)
                let imageName = "Immune" + "_" + n + "_00"
                var image = UIImage(named:imageName)
                if image == nil
                {
                    image = UIImage(named:"image001")
                }
                
                cell.observationImage.image =  image
                cell.incrementLabel.text = String(immu.obsPoint!.int32Value)
                cell.switchNecropsyBtn.alpha = 0
                cell.plusButton.alpha = 1
                cell.minusButton.alpha = 1
                cell.incrementLabel.alpha = 1
                cell.textFieldActual.alpha = 0
            }
        }
    }
    
    fileprivate func handleTurkeyBirdSexCompletionActionValidations(_ indexPath: IndexPath,_ immune: CaptureNecropsyViewDataTurkey) {
        var necId = getNecId()
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId: necId as NSNumber)
        
        let resp1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            
            let obsData = CoreDataHandlerTurkeyModels.updateSkeletaTurkeySexValueObs(
                catName: "Immune",
                obsName: resp1.obsName!,
                formName: immune.formName!,
                obsVisibility: true,
                birdNo: resp1.birdNo!,
                obsPoint: 1,
                obsId: resp1.obsID as! NSInteger,
                necId: necId as NSNumber,
                isSync: true,
                actualText: selectedSexValue
            )
            
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseTurkeySexValue(obsData, index: indexPath.row)
            
        }
        
        dataArrayImmu.removeAllObjects()
        
        necId =  getNecId()
        
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
    }
    
    fileprivate func handleSelectedValueAndSetSexValueInVariable(_ selectedVal: String) {
        if selectedVal == "Female" {
            selectedSexValue = "2"
        } else if selectedVal == "N/A" {
            selectedSexValue = "0"
        } else {
            selectedSexValue = "1"
        }
    }
    
    fileprivate func handlePostingIdFromExistingPostingIdFromExistingNavigate() {
        if postingIdFromExistingNavigate == "Exting" {
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        } else if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
    }
    
    fileprivate func handleTurkeybirdSexCompletionAction(_ cell: CaptureNecroStep2TurkeyCell, _ indexPath: IndexPath) {
        cell.turkeybirdSexCompletion = {[unowned self] ( error) in
            
            if turkeyBirdSex.count > 0 {
                self.dropDownVIewNew(arrayData: turkeyBirdSex as? [String] ?? [String](), kWidth: cell.turkeySexView.frame.width, kAnchor: cell.turkeySexView, yheight: cell.turkeySexView.bounds.height) { [unowned self] selectedVal, index  in
                    
                    selectedSexValue = selectedVal
                    handleSelectedValueAndSetSexValueInVariable(selectedVal)
                    
                    if btnTag == 4 {
                        let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
                        handleTurkeyBirdSexCompletionActionValidations(indexPath, immune)
                    }
                    
                    handlePostingIdFromExistingPostingIdFromExistingNavigate()
                    neccollectionView.reloadData()
                }
                
                self.dropHiddenAndShow()
            }
        }
    }
    
    fileprivate func handleBtnTagValidationsNecCollectionView(_ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell) {
        if btnTag == 0 {
            handleNeccollectionViewBtnTag0(indexPath, cell)
            
        } else if btnTag == 1 {
            handleNeccollectionViewBtnTag1(indexPath, cell)
        }
        else if btnTag == 2 {
            handleNeccollectionViewBtnTag2(indexPath, cell)
        } else if btnTag == 3 {
            handleNeccollectionViewBtnTag3(indexPath, cell)
            
        } else {
            let immu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: indexPath.row) as! CaptureNecropsyViewDataTurkey
            cell.myLabel.text = immu.obsName
            
            let measure = immu.measure
            cell.mesureValue = measure!
            cell.turkeySexView.alpha = 0
            cell.turkeySexView.isHidden = true
            var necId = getNecId()
            
            let photoArr = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey(immu.birdNo!, farmname: immu.formName!, catName: immu.catName!, Obsid: immu.obsID!, obsName: immu.obsName!,necId: necId as NSNumber)
            if photoArr.count > 0
            {
                cell.badgeButton.alpha = 1
                cell.badgeButton.badgeString = String(photoArr.count) as String
                cell.badgeButton.badgeTextColor = UIColor.white
                cell.badgeButton.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
            }
            else
            {
                cell.badgeButton.alpha = 0
            }
            
            handleNeccollectionViewOtherValidations(measure, immu, cell)
            
        }
    }
    
    fileprivate func handleFormCollectionViewFarmValidation(_ farmLength: String, _ age: String, _ indexPath: IndexPath, _ cell: CaptureNecroStep2TurkeyCell, _ house: String) {
        if farmLength.count > 60  {
            
            let fullName = farmLength
            let myStringPrefix = String(fullName.prefix(60)) // result is "1234"
            let firstName = myStringPrefix + "..." + " " + "[" + age + "]"
            
            
            var farmName2 = String()
            let range = firstName.range(of: ".")
            if range != nil{
                var abc = String(firstName[range!.upperBound...]) as NSString
                farmName2 = String(indexPath.row+1) + "." + " " + String(describing:abc)
            }
            
            cell.houseLbl.text = "HNo. " +  house
            cell.farmLabel.text = farmName2
            
        } else {
            
            var farmLengthAge  : String = (farmArray[indexPath.row] as? String)!
            let myStringPrefix = String(farmLengthAge.prefix(60)) // result is "1234"
            
            farmLengthAge = myStringPrefix + " " + "[" + age + "]"
            
            var farmName2 = String()
            let range = farmLengthAge.range(of: ".")
            if range != nil{
                var abc = String(farmLengthAge[range!.upperBound...]) as NSString
                farmName2 = String(indexPath.row+1) + "." + " " + String(describing:abc)
                
            }
            
            cell.farmLabel.text = farmName2
            cell.houseLbl.text = "HNo. " +  house
        }
    }
    
    fileprivate func handleBirdCollectionViewAllValidations(_ cell: CaptureNecroStep2TurkeyCell, _ indexPath: IndexPath) {
        if (cell.isSelected) {
            let image = UIImage(named: "addbird_bg_select")
            
            cell.bgImageView.image = image
            let image2 = UIImage(named: "edit")
            cell.editImage.image = image2
            cell.notePopBtn.alpha = 1
            
        } else {
            let image = UIImage(named: "addbird_bg_unselect1")
            cell.bgImageView.image = image
            let image1 = UIImage(named: "edit_black")
            cell.editImage.image = image1
            cell.notePopBtn.alpha = 0
        }
        
        if btnTag == 0 {
            handleBirdsCollectionViewBtnTag0(indexPath, cell)
        }
        
        if btnTag == 1 {
            
            handleBirdsCollectionViewBtnTag1(indexPath, cell)
        }
        
        if btnTag == 2 {
            handleBirdsCollectionViewBtnTag2(indexPath, cell)
        }
        
        if btnTag == 3 {
            handleBirdsCollectionViewBtnTag3(indexPath, cell)
        }
        
        if btnTag == 4 {
            handleBirdsCollectionViewBtnTag4(indexPath, cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CaptureNecroStep2TurkeyCell
        
        if collectionView == birdsCollectionView {
            handleBirdCollectionViewAllValidations(cell, indexPath)
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CaptureNecroStep2Turkey.longPress(_:)))
            longPressRecognizer.view?.tag = indexPath.row
            
            cell.addGestureRecognizer(longPressRecognizer)
            
            
            if isFarmClick == true {
                cell.birdsCountLabel?.text = String(describing:((items.object(at: self.farmRow) as AnyObject).object(at: indexPath.row) ))
            } else {
                handleBirdsCollectionViewIsFarmClickFalseCase(cell, indexPath)
            }
            cell.notePopBtn.tag = indexPath.row
            cell.notePopBtn.addTarget(self, action: #selector(CaptureNecroStep2Turkey.notesPopView), for: .touchUpInside)
            return cell
            
        } else if collectionView == formCollectionView {
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 5.0
            cell.layer.borderColor = UIColor.clear.cgColor
            
            cell.QuickLink.isUserInteractionEnabled = true
            cell.quickLinkIcon.isHidden = false
            
            if (cell.isSelected) {
                cell.backgroundColor = UIColor(red: 1.0, green: 93/255, blue: 48/255, alpha: 1.0) // highlight selection
                cell.QuickLink.alpha = 1
                cell.quickLinkIcon.alpha = 1
                farmRow = indexPath.row
                selectedFarmIndexTurkey = indexPath.row
            }  else {
                
                cell.backgroundColor = UIColor(red: 1.0, green: 141/255, blue: 54/255, alpha: 1.0)
                cell.QuickLink.alpha = 0
                cell.quickLinkIcon.alpha = 0
            }
            
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.5
            
            var farmLength : String = (farmArray[indexPath.row] as? String)!
            let age : String = (ageArray[indexPath.row] as? String)!
            let house : String = (houseArray[indexPath.row] as? String)!
            handleFormCollectionViewFarmValidation(farmLength, age, indexPath, cell, house)
            
            cell.QuickLink.addTarget(self, action: #selector(CaptureNecroStep2Turkey.quickLink(_:)), for: .touchUpInside)
            cell.QuickLink.tag = indexPath.row
            return cell
            
        } else if collectionView == neccollectionView {
            
            cell.textFieldActual.delegate = self
            cell.switchNecropsyBtn.isUserInteractionEnabled = true
            cell.badgeButton.isUserInteractionEnabled = true
            cell.plusButton.isUserInteractionEnabled = true
            cell.minusButton.isUserInteractionEnabled = true
            cell.cameraButtonOutlet.isUserInteractionEnabled = true
            cell.helpButtonOutlet.isUserInteractionEnabled = true
            cell.textFieldActual.isUserInteractionEnabled = true
            cell.turkySexBtn.isUserInteractionEnabled = true
            if observationImageFrameTemp == nil {
                observationImageFrameTemp = cell.observationImage.frame
            }
            
            handleBtnTagValidationsNecCollectionView(indexPath, cell)
            
            cell.textFieldActual.tag = indexPath.row
            
            cell.plusButton.addTarget(self, action: #selector(CaptureNecroStep2Turkey.plusButtonClick(_:)), for: .touchUpInside)
            
            cell.minusButton.addTarget(self, action: #selector(CaptureNecroStep2Turkey.minusButtonClick(_:)), for: .touchUpInside)
            
            cell.cameraButtonOutlet.addTarget(self, action: #selector(CaptureNecroStep2Turkey.takePhoto(_:)), for: .touchUpInside)
            
            cell.helpButtonOutlet.addTarget(self, action:#selector(CaptureNecroStep2Turkey.clickHelpPopUp(_:)), for: .touchUpInside)
            
            cell.badgeButton.addTarget(self, action: #selector(CaptureNecroStep2Turkey.clickImage(_:)), for: .touchUpInside)
            
            cell.switchNecropsyBtn .addTarget(self, action: #selector(CaptureNecroStep2Turkey.switchClick(_:)) , for:.valueChanged)
            
            handleTurkeybirdSexCompletionAction(cell, indexPath)
            cell.helpButtonOutlet.tag = indexPath.row
            cell.textFieldActual.delegate = self
            cell.switchNecropsyBtn.tag = indexPath.row
            cell.tag = indexPath.row
            cell.badgeButton.tag = indexPath.row
            cell.cameraButtonOutlet.tag = indexPath.row
            cell.plusButton.tag = indexPath.row
            cell.minusButton.tag =  indexPath.row
            
            return cell
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == formCollectionView {
            
            isBirdClick = false
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CaptureNecroStep2TurkeyCell
            let cell = collectionView.cellForItem(at: indexPath) as! CaptureNecroStep2TurkeyCell
            
            cell.backgroundColor = UIColor(red: 1.0, green: 93/255, blue: 48/255, alpha: 1.0)
            cell.QuickLink.alpha = 1
            cell.quickLinkIcon.alpha = 1
            
            traingleImageView.frame = CGRect(x: 274, y: 229, width: 24, height: 24)
            farmRow = indexPath.row
            selectedFarmIndexTurkey = indexPath.row
            isFarmClick = true
            // self.farmRow = indexPath.row
            let farm = farmArray.object(at: self.farmRow)
            UserDefaults.standard.set(farm, forKey: "farm")
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
            self.perform(#selector(CaptureNecroStep2Turkey.loadformdata), with: nil, afterDelay:1)
            
        }
        
        else if collectionView == birdsCollectionView{
            isBirdClick = true
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CaptureNecroStep2TurkeyCell
            let cell = collectionView.cellForItem(at: indexPath) as! CaptureNecroStep2TurkeyCell
            
            cell.notePopBtn.alpha = 1
            
            let image = UIImage(named: "addbird_bg_select")
            
            cell.bgImageView.image = image
            
            let image2 = UIImage(named: "edit")
            
            cell.editImage.image = image2
            
            let cellFrameInSuperview = collectionView.convert(cell.frame, to: view)
            
            traingleImageView.frame = CGRect(x: cellFrameInSuperview.origin.x + 10, y: cellFrameInSuperview.origin.y - 2, width: traingleImageView.frame.size.width, height: traingleImageView.frame.size.width)
            
            let bird = (items.object(at: self.farmRow) as AnyObject).object(at: indexPath.row)
            UserDefaults.standard.set(bird, forKey: "bird")
            
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
            
            self.callLodaBirdData(bird as! NSNumber)
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if collectionView == birdsCollectionView {
            
            isBirdClick = true
            
            birdsCollectionView.reloadData()
            
        }
        
        if collectionView == formCollectionView {
            
            isBirdClick = false
            
            formCollectionView.reloadData()
        }
        return true
    }
    
    // MARK: - DROP DOWN HIDDEN AND SHOW
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    
    
    
    @objc func loadformdata(){
        
        let rowToSelect:IndexPath = IndexPath(row: tableViewSelectedRow, section: 0)
        
        tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        var necId = Int()
        if postingIdFromExistingNavigate == "Exting"{
            
            necId =  postingIdFromExisting
        }
        else{
            necId = UserDefaults.standard.integer(forKey: "necId") as Int
        }
        
        if tableViewSelectedRow == 0 {
            dataSkeltaArray.removeAllObjects()
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey( UserDefaults.standard.object(forKey: "farm") as! String, catName: "skeltaMuscular",birdNo: 1,necId : necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if tableViewSelectedRow == 1 {
            dataArrayCocoi.removeAllObjects()
            
            dataArrayCocoi =   CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(UserDefaults.standard.object(forKey: "farm") as! String, catName: "Coccidiosis" ,birdNo: 1,necId : necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        
        if tableViewSelectedRow == 2 {
            dataArrayGiTract.removeAllObjects()
            
            dataArrayGiTract =   CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey( UserDefaults.standard.object(forKey: "farm") as! String, catName: "GITract",birdNo: 1,necId : necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if tableViewSelectedRow == 3 {
            dataArrayRes.removeAllObjects()
            
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey( UserDefaults.standard.object(forKey: "farm") as! String, catName: "Resp",birdNo: 1,necId : necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if tableViewSelectedRow == 4 {
            dataArrayImmu.removeAllObjects()
            
            dataArrayImmu =   CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",birdNo: 1,necId : necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        birdsCollectionView.reloadData()
        
        birdsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        
        neccollectionView.reloadData()
        UserDefaults.standard.setValue(1, forKey: "bird")
        UserDefaults.standard.synchronize()
        
        Helper.dismissGlobalHUD(self.view)
        
    }
    
    
    fileprivate func fetchFarmForImmuneCatgry(_ bird: NSNumber, _ necId: Int) {
        dataArrayImmu.removeAllObjects()
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        neccollectionView.reloadData()
        
        if dataArrayImmu.count > 0
        {
            neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
        }
    }
    
    func callLodaBirdData(_ bird : NSNumber)  {
        
        if self.farmRow == 0
        {
            self.isFirstTimeLaunch =  true
        }
        
        let  bird = UserDefaults.standard.value(forKey: "bird") as! NSNumber
        var  necId = getNecId()
        
        if btnTag == 0 {
            
            dataSkeltaArray.removeAllObjects()
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            
            if dataSkeltaArray.count > 0
            {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
            }
        }
        
        if btnTag == 1 {
            
            dataArrayCocoi.removeAllObjects()
            dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Coccidiosis",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            
            if dataArrayCocoi.count > 0
            {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
            }
        }
        
        if btnTag == 2 {
            
            dataArrayGiTract.removeAllObjects()
            dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "GITract",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            
            if dataArrayGiTract.count > 0
            {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
            }
        }
        
        if btnTag == 3 {
            
            dataArrayRes.removeAllObjects()
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(bird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Resp",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            
            if dataArrayRes.count > 0
            {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.top)
                
            }
        }
        
        if btnTag == 4 {
            
            fetchFarmForImmuneCatgry(bird, necId)
        }
        
        Helper.dismissGlobalHUD(self.view)
        
    }
    
    // MARK: - TABLE VIEW DATA SOURCE AND DELEGATES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:StartNecropsyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StartNecropsyTableViewCell
        
        if (cell.isSelected) {
            cell.bgView.backgroundColor = UIColor(red: 1.0, green: 93/255, blue: 48/255, alpha: 1.0)
            
        } else {
            cell.bgView.backgroundColor = UIColor(red: 1.0, green: 141/255, blue: 54/255, alpha: 1.0)
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.dataLabel.text = categoryArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldSelectItemAtIndexPath indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noOfBird = UserDefaults.standard.integer(forKey: "bird")
        let cell: StartNecropsyTableViewCell = tableView.cellForRow(at: indexPath) as! StartNecropsyTableViewCell
        tableViewSelectedRow = indexPath.row
        isBirdClick = false
        
        // Handle first-time launch
        if farmRow == 0 {
            isFirstTimeLaunch = true
        }
        
        // Reset background color for previous selection
        if btnTag == 0 {
            let removeIndexPath: IndexPath = IndexPath(row: 0, section: 0)
            if let removeCell = tableView.cellForRow(at: removeIndexPath) as? StartNecropsyTableViewCell {
                removeCell.bgView.backgroundColor = UIColor(red: 1.0, green: 141/255, blue: 54/255, alpha: 1.0)
            }
        }
        
        // Use a switch statement for row handling
        switch indexPath.row {
        case 0:
            btnTag = 0
            cell.bgView.backgroundColor = UIColor(red: 1.0, green: 93/255, blue: 48/255, alpha: 1.0)
            dataSkeltaArray.removeAllObjects()
            let necId = getNecId()
            dataSkeltaArray = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(
                noOfBird as NSNumber,
                farmname: UserDefaults.standard.string(forKey: "farm") ?? "",
                catName: "skeltaMuscular",
                necId: necId as NSNumber
            ).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            if dataSkeltaArray.count > 0 {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            }
            
        case 1:
            btnTag = 1
            dataArrayCocoi.removeAllObjects()
            let necId = getNecId()
            dataArrayCocoi = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(
                noOfBird as NSNumber,
                farmname: UserDefaults.standard.string(forKey: "farm") ?? "",
                catName: "Coccidiosis",
                necId: necId as NSNumber
            ).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            if dataArrayCocoi.count > 0 {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            }
            
        case 2:
            btnTag = 2
            dataArrayGiTract.removeAllObjects()
            let necId = getNecId()
            dataArrayGiTract = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(
                noOfBird as NSNumber,
                farmname: UserDefaults.standard.string(forKey: "farm") ?? "",
                catName: "GITract",
                necId: necId as NSNumber
            ).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            if dataArrayGiTract.count > 0 {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            }
            
        case 3:
            btnTag = 3
            dataArrayRes.removeAllObjects()
            let necId = getNecId()
            dataArrayRes = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(
                noOfBird as NSNumber,
                farmname: UserDefaults.standard.string(forKey: "farm") ?? "",
                catName: "Resp",
                necId: necId as NSNumber
            ).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            if dataArrayRes.count > 0 {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            }
            
        case 4:
            btnTag = 4
            dataArrayImmu.removeAllObjects()
            let necId = getNecId()
            dataArrayImmu = CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(
                noOfBird as NSNumber,
                farmname: UserDefaults.standard.string(forKey: "farm") ?? "",
                catName: "Immune",
                necId: necId as NSNumber
            ).mutableCopy() as! NSMutableArray
            neccollectionView.reloadData()
            if dataArrayImmu.count > 0 {
                neccollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
            }
            
        default:
            break
        }
        
        // Save the selected index and update the cell background color
        UserDefaults.standard.set(btnTag, forKey: "clickindex")
        cell.bgView.backgroundColor = UIColor(red: 1.0, green: 93/255, blue: 48/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:StartNecropsyTableViewCell = tableView.cellForRow(at: indexPath) as! StartNecropsyTableViewCell
        cell.bgView.backgroundColor = UIColor(red: 1.0, green: 141/255, blue: 54/255, alpha: 1.0)
        if btnTag == 0
        {
            let removeindexPath : IndexPath = IndexPath(row: 0, section: 0)
            let removecell:StartNecropsyTableViewCell = tableView.cellForRow(at: removeindexPath) as! StartNecropsyTableViewCell
            removecell.bgView.backgroundColor = UIColor(red: 1.0, green: 141/255, blue: 54/255, alpha: 1.0)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        return view
    }
    
    //MARK: UITextFiled Delegate Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    fileprivate func updateBodyWeightValue(_ rowIndex: Int, _ currentText: String) {
        let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
        
        var  necId = getNecId()
        
        let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(immune.birdNo!, farmname: immune.formName!, catName: immune.catName!,Obsid: immune.obsID!,necId:necId as NSNumber)
        
        let immune1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
        if FetchObsArr.count > 0 {
            
            let data = CoreDataHandlerTurkeyModels.updateWeightSkeletaData(
                catName: "Immune",
                obsName: immune1.obsName!,
                formName: immune.formName!,
                birdNo: immune.birdNo!,
                actualName: currentText,
                index: rowIndex,
                necId: necId as NSNumber,
                isSync: true
            )
            
            CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: data)
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        var currentText = ""
        
        if (isBackSpace == -92) {
            currentText = textField.text!.substring(to: textField.text!.index(before: textField.text!.endIndex))
        }
        else {
            currentText = textField.text! + string
        }
        
        if (string == "1" || string == "2" || string == "3" || string == "4" || string == "5" || string == "6" || string == "7" || string == "8" || string == "9" || string == "0" || string == "." || isBackSpace == -92 ){
            
            var _ : Bool!
            if(self.checkCharacter(string, textfield11: textField)){
                
                let rowIndex :Int = textField.tag
                bursaSelectedIndex =  IndexPath(row: rowIndex, section: 0)
                
                let cell = neccollectionView.cellForItem(at: bursaSelectedIndex!) as! CaptureNecroStep2TurkeyCell
                if textField == cell.textFieldActual {
                    
                    let computationString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    let length = computationString.count
                    if (length > 5) {
                        return false;
                    }
                    
                }
                
                updateBodyWeightValue(rowIndex, currentText)
            }
            return true
            
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let rowIndex :Int = textField.tag
        bursaSelectedIndex = IndexPath(row: rowIndex, section: 0)
        
        let cell = neccollectionView.cellForItem(at: bursaSelectedIndex!) as! CaptureNecroStep2TurkeyCell
        cell.textFieldActual.becomeFirstResponder()
        //cell.textFieldActual.tag = 2
        cell.textFieldActual.returnKeyType = UIReturnKeyType.done
        animateViewMoving(true, moveValue: 100)
    }
    
    fileprivate func updateSessionStatus() {
        if postingIdFromExistingNavigate == "Exting"{
            
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        }
        else if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            
        } else {
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(false, moveValue: 100)
        let rowIndex :Int = textField.tag
        lastSelectedIndex = IndexPath(row: rowIndex, section: 0)
        if btnTag == 0 {
            
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(skleta.birdNo!, farmname: skleta.formName!, catName: skleta.catName!,Obsid: skleta.obsID!,necId: necId as NSNumber)
            
            let skleta1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                
                let data = CoreDataHandlerTurkeyModels.updateWeightSkeletaData(
                    catName: "skeltaMuscular",
                    obsName: skleta1.obsName!,
                    formName: skleta.formName!,
                    birdNo: skleta.birdNo!,
                    actualName: textField.text!,
                    index: rowIndex,
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: data)
            }
            
            dataSkeltaArray.removeAllObjects()
            
            necId = getNecId()
            
            dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(skleta.birdNo! , farmname: skleta.formName!, catName: "skeltaMuscular",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if btnTag == 1 {
            let cocoi : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(cocoi.birdNo!, farmname: cocoi.formName!, catName: cocoi.catName!,Obsid: cocoi.obsID!,necId: necId as NSNumber)
            
            let cocoi1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let data = CoreDataHandlerTurkeyModels.updateWeightSkeletaData(
                    catName: "Coccidiosis",
                    obsName: cocoi1.obsName!,
                    formName: cocoi.formName!,
                    birdNo: cocoi.birdNo!,
                    actualName: textField.text!,
                    index: rowIndex,
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: data)
            }
            
            dataArrayCocoi.removeAllObjects()
            
            necId =  getNecId()
            
            dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(cocoi.birdNo! , farmname: cocoi.formName!, catName: "Coccidiosis",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if btnTag == 2 {
            
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(gitract.birdNo!, farmname: gitract.formName!, catName: gitract.catName!,Obsid: gitract.obsID!,necId: necId as NSNumber)
            
            let gitract1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let data = CoreDataHandlerTurkeyModels.updateWeightSkeletaData(
                    catName: "GITract",
                    obsName: gitract1.obsName!,
                    formName: gitract.formName!,
                    birdNo: gitract.birdNo!,
                    actualName: textField.text!,
                    index: rowIndex,
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: data)
            }
            
            dataArrayGiTract.removeAllObjects()
            
            necId =  getNecId()
            
            dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(gitract.birdNo! , farmname: gitract.formName!, catName: "GITract",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            
            
        }
        
        if btnTag == 3 {
            
            let resp : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId = getNecId()
            
            let FetchObsArr =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationIDTurkey(resp.birdNo!, farmname: resp.formName!, catName: resp.catName!,Obsid: resp.obsID!,necId: necId as NSNumber)
            
            let resp1 : CaptureNecropsyViewDataTurkey = FetchObsArr.object(at: 0) as! CaptureNecropsyViewDataTurkey
            if FetchObsArr.count > 0 {
                
                let data = CoreDataHandlerTurkeyModels.updateWeightSkeletaData(
                    catName: "Resp",
                    obsName: resp1.obsName!,
                    formName: resp.formName!,
                    birdNo: resp.birdNo!,
                    actualName: textField.text!,
                    index: rowIndex,
                    necId: necId as NSNumber,
                    isSync: true
                )
                
                CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnActualClickTurkey(data: data)
            }
            
            dataArrayRes.removeAllObjects()
            necId =  getNecId()
            
            dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(resp.birdNo! , farmname: resp.formName!, catName: "Resp",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        if btnTag == 4 {
            
            let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: rowIndex) as! CaptureNecropsyViewDataTurkey
            
            var  necId =  getNecId()
            
            dataArrayImmu.removeAllObjects()
            
            
            dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(immune.birdNo! , farmname: immune.formName!, catName: "Immune",necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            
        }
        
        updateSessionStatus()
        textField.resignFirstResponder()
    }
    
    //MARK: Custom Actionß
    
    func croppIngimage(_ imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    
    @objc func buttonAcntion(_ sender: UIButton!) {
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
    }
    
    func refreshPageafterAddFeedTurkey(_ formName: String){
        
        isFirstTimeLaunch = false
        
        customPopV.removeFromSuperview()
        
        self.items.removeAllObjects()
        self.farmArray.removeAllObjects()
        self.ageArray.removeAllObjects()
        self.houseArray.removeAllObjects()
        buttonback.alpha = 0
        buttonback.removeFromSuperview()
        
        isFarmClick = false
        isNewFarm = true
        btnTag = 0
        
        
        if postingIdFromExistingNavigate == "Exting"{
            var  postingId = postingIdFromExisting
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1NecIdTurkey(postingId as NSNumber) as! [NSManagedObject]
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(postingIdFromExisting as NSNumber)
            self.printSyncLblCount()
        }
        else if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncNecropsystep1WithneccIdTurkey(necId as NSNumber, isSync : true)
            self.printSyncLblCount()
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(necId as NSNumber) as! [NSManagedObject]
            
        }
        else{
            var postingId = UserDefaults.standard.integer(forKey: "necId") as Int
            self.captureNecropsy =  CoreDataHandlerTurkey().FetchNecropsystep1neccIdTurkey(postingId as NSNumber) as! [NSManagedObject]
            let necId = UserDefaults.standard.integer(forKey: "necId") as Int
            CoreDataHandlerTurkey().updateisSyncTrueOnPostingSessionTurkey(necId as NSNumber)
            self.printSyncLblCount()
            
        }
        
        for object in captureNecropsy {
            let noOfBirds : Int = Int(object.value(forKey: "noOfBirds") as! String)!
            let refreshNoOfBirdsArr  = NSMutableArray()
            
            var numOfLoop = 0
            for i in 0..<noOfBirds {
                
                numOfLoop  = i + 1
                
                if numOfLoop > 10
                {
                    debugPrint("count mismatch")
                } else {
                    refreshNoOfBirdsArr.add(i+1)
                }
            }
            items.add(refreshNoOfBirdsArr)
            farmArray.add(object.value(forKey: "farmName")!)
            ageArray.add(object.value(forKey: "age")!)
            houseArray.add(object.value(forKey: "houseNo")!)
            
        }
        
        let rowToSelect:IndexPath = IndexPath(row: 0, section: 0)
        
        self.farmRow = self.farmArray.count - 1
        
        tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        var necId = getNecId()
        
        dataSkeltaArray.removeAllObjects()
        
        dataSkeltaArray =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(formName, catName: "skeltaMuscular",birdNo: 1,necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        
        dataArrayCocoi.removeAllObjects()
        
        dataArrayCocoi =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(formName, catName: "Coccidiosis" ,birdNo: 1,necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        
        
        dataArrayGiTract.removeAllObjects()
        
        dataArrayGiTract =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(formName, catName: "GiTractTurkey",birdNo:  1,necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        
        dataArrayRes.removeAllObjects()
        dataArrayRes =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(formName, catName: "Resp",birdNo: 1,necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        dataArrayImmu.removeAllObjects()
        dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameTurkey(formName, catName: "Immune",birdNo: 1,necId: necId as NSNumber).mutableCopy() as! NSMutableArray
        self.addBirdInNotes()
        
        if self.farmArray.count > 0 {
            formCollectionView.dataSource = self
            formCollectionView.delegate = self
            self.formCollectionView!.reloadData()
            formCollectionView.selectItem(at: IndexPath(item: self.farmArray.count - 1, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
            
        }
        
        if items.count > 0 {
            birdsCollectionView.dataSource = self
            birdsCollectionView.delegate = self
            
            self.birdsCollectionView!.reloadData()
            
            birdsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        }
        traingleImageView.frame = CGRect(x: 274, y: 229, width: 24, height: 24)
        birdsCollectionView.reloadData()
        
        birdsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.left)
        
        let farm = farmArray.object(at: farmArray.count - 1)
        UserDefaults.standard.set(farm, forKey: "farm")
        UserDefaults.standard.synchronize()
        
        neccollectionView.reloadData()
        isNewFarm = false
    }
    
    func buttonPressedDroper() {
        buttonDroper.alpha = 0
    }
    
    func addPopBack (){
        
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
        UserDefaults.standard.set(1, forKey: "bird")
        self.tableView.reloadData()
        self.birdsCollectionView.reloadData()
        self.formCollectionView.reloadData()
        self.neccollectionView.reloadData()
    }
    
    func noFarmUpdate()
    {
        
        customPopV.removeFromSuperview()
        buttonback.removeFromSuperview()
        UserDefaults.standard.set(1, forKey: "bird")
        self.tableView.reloadData()
        self.birdsCollectionView.reloadData()
        self.formCollectionView.reloadData()
        self.neccollectionView.reloadData()
        farmRow = selectedFarmIndexTurkey
    }
    
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected() == true{
                self.ssologoutMethod()
                CoreDataHandlerTurkey().deleteAllDataTurkey("CustmerTurkey")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            buttonbg.removeFromSuperview()
            customPopVi.removeView(view)
        }
    }
    
    
    
    
    
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func buttonPres() {
        customPopVi.removeView(view)
        buttonbg.removeFromSuperview()
    }
    
    
    @objc func notesPopView(_ sender : UIButton){
        
        let notesDict = NSMutableArray()
        
        if btnTag == 0, dataSkeltaArray.count > 0 {
            
            let skleta : CaptureNecropsyViewDataTurkey = dataSkeltaArray.object(at: 0) as! CaptureNecropsyViewDataTurkey
            notesDict.add(skleta)
            self.opennoteView(sender, notesDict: notesDict)
            
        }
        
        if btnTag == 1 ,dataArrayCocoi.count > 0
        {
            
            
            let cocoiDis : CaptureNecropsyViewDataTurkey = dataArrayCocoi.object(at: 0) as! CaptureNecropsyViewDataTurkey
            notesDict.add(cocoiDis)
            self.opennoteView(sender, notesDict: notesDict)
            
        }
        if btnTag == 2 , dataArrayGiTract.count > 0 {
            
            let gitract : CaptureNecropsyViewDataTurkey = dataArrayGiTract.object(at: sender.tag) as! CaptureNecropsyViewDataTurkey
            notesDict.add(gitract)
            self.opennoteView(sender, notesDict: notesDict)
            
        }
        if btnTag == 3  , dataArrayRes.count > 0  {
            
            let resp : CaptureNecropsyViewDataTurkey = dataArrayRes.object(at: 0) as! CaptureNecropsyViewDataTurkey
            notesDict.add(resp)
            self.opennoteView(sender, notesDict: notesDict)
            
        }
        if btnTag == 4 , dataArrayImmu.count > 0
        {
            let immune : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
            notesDict.add(immune)
            self.opennoteView(sender, notesDict: notesDict)
            
        }
    }
    
    func opennoteView(_ sender : UIButton , notesDict : NSMutableArray){
        notesBGbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        notesBGbtn.backgroundColor = UIColor.black
        notesBGbtn.alpha = 0.6
        notesBGbtn.setTitle("", for: UIControl.State())
        notesBGbtn.addTarget(self, action: #selector(notesButtonAcn), for: .touchUpInside)
        self.view.addSubview(notesBGbtn)
        notesView = NotesTurkey.loadFromNibNamed("NotesTurkey") as! NotesTurkey
        notesView.notesDelegate = self
        notesView.noOfBird = sender.tag + 1
        notesView.notesDict = notesDict
        
        
        notesView.necIdFromExisting = postingIdFromExisting
        notesView.strExist = postingIdFromExistingNavigate
        notesView.finalizeValue = finalizeValue
        notesView.center = self.view.center
        self.view.addSubview(notesView)
    }
    
    func openNoteFunc(){
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
        
    }
    func doneBtnFunc (_ notes : NSMutableArray , notesText : String, noOfBird : Int){
        if notes.count > 0
        {
            let skleta : CaptureNecropsyViewDataTurkey = notes.object(at: 0) as! CaptureNecropsyViewDataTurkey
            
            let formName = skleta.formName
            let catName  = skleta.catName
            
            var  necId = getNecId()
            
            let isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName!, formName: formName!, birdNo: noOfBird as NSNumber, necId: necId as NSNumber)
            let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
            let catArr = ["skeltaMuscular","Coccidiosis","GITract","Resp","Immune"] as NSArray
            
            if note.notes!.isEmpty && notesText.isEmpty
            {
                for i in  0..<catArr.count
                {
                    var  necId = getNecId()
                    
                    CoreDataHandlerTurkey().updateNoofBirdWithNotesTurkey(catArr.object(at: i) as! String,  formName: note.formName!, birdNo: note.noofBirds!,notes:note.notes!,necId: necId as NSNumber,isSync :true)
                    
                }
                return
            } else {
                
                if isNotes.count > 0
                {
                    let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
                    for i in  0..<catArr.count
                    {
                        var  necId = getNecId()
                        
                        CoreDataHandlerTurkey().updateNoofBirdWithNotesTurkey(catArr.object(at: i) as! String,  formName: note.formName!, birdNo: note.noofBirds!,notes:notesText,necId: necId as NSNumber,isSync :true)
                    }
                }
                else {
                    for i in  0..<catArr.count {
                        var  necId = getNecId()
                        
                        CoreDataHandlerTurkey().saveNoofBirdWithNotesTurkey(catArr.object(at: i) as! String , notes: notesText, formName: formName! , birdNo: noOfBird as NSNumber, index: 0 , necId: necId as NSNumber, isSync :true)
                    }
                }
            }
            
            updateSessionStatus()
        }
        
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
        birdsCollectionView.reloadData()
        birdsCollectionView.selectItem(at: IndexPath(item: noOfBird-1, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
    }
    @objc func notesButtonAcn(_ sender: UIButton!) {
        self.notesBGbtn.removeFromSuperview()
        self.notesView.removeFromSuperview()
        
    }
    
    
    func checkCharacter( _ inputChar : String , textfield11 : UITextField ) -> Bool {
        
        let newCharacters = CharacterSet(charactersIn: inputChar)
        let boolIsNumber = CharacterSet.decimalDigits.isSuperset(of: newCharacters)
        if boolIsNumber == true {
            return true
        } else {
            
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
        }
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
        
    }
    
    func postingNotesdoneBtnFunc(_ notesText : String){
        print(appDelegateObj.testFuntion())
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func syncBtnAction(_ sender: AnyObject) {
        
        if self.allSessionArr().count > 0 {
            if WebClass.sharedInstance.connected() == true{
                
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                self.callSyncApi()
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
            }
        } else {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    
    @IBAction func addBirds(_ sender: AnyObject) {
        
        let formName = UserDefaults.standard.value(forKey: "farm") as! String
        
        for i in 0..<farmArray.count
        {
            let farm = farmArray.object(at: i) as! String
            if farm == formName, (items.object(at: i) as AnyObject).count == 10 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"You can not add more than 10 birds")
                return
                
            }
        }
        
        self.increaseBirdBtn.isUserInteractionEnabled = false
        self.decBirdNumberBtn.isUserInteractionEnabled = false
        self.addFormBtn.isUserInteractionEnabled = false
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Adding Bird...", comment: ""))
        self.perform(#selector(CaptureNecroStep2Turkey.saveSuccess), with: nil, afterDelay: 1.0)
        
    }
    
    @IBAction func deleteBirds(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: NSLocalizedString(Constants.alertStr, comment: ""), message: "Are you sure you want to delete this bird? You will lose the data by deleting this bird.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Cancel", style: .default)
        
        let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            self.isFirstTimeLaunch = false
            let formName = UserDefaults.standard.value(forKey: "farm") as! String
            
            for i in 0..<self.farmArray.count {
                let farm = self.farmArray.object(at: i) as! String
                if farm == formName, (self.items.object(at: i) as AnyObject).count == 1 {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:self.oneBirdRequiredStr)
                    return
                    
                }
            }
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Deleting Bird...", comment: ""))
            self.perform(#selector(CaptureNecroStep2Turkey.deleteSuccess), with: nil, afterDelay: 1.0)
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        CommonClass.sharedInstance.updateCountTurkey()
        
        if  finalizeValue == 1 {
            
            
            
            var necId =  postingIdFromExisting
            var  totalWeight = Double()
            var selectedFarmName = ""
            
            
            for bird in 1...(items[self.farmRow] as AnyObject).count! {
                var  currentBird = bird as NSNumber
                dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(currentBird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
                
                let NewImmu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
                
                var  getWeight = NewImmu.actualText ?? ""
                
                totalWeight = totalWeight + (getWeight as NSString).doubleValue
                totalWeight = totalWeight.rounded(toPlaces: 3)
                
            }
            selectedFarmName = UserDefaults.standard.string(forKey: "farm") ?? ""
            
            CoreDataHandlerTurkey().updateNecropsyFarmWeightstep1WithNecIdTurkey(necId as NSNumber, isSync: true, farmWeight: "\(totalWeight)", farmName: selectedFarmName as NSString )
            
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            var  postingId = Int()
            
            if UserDefaults.standard.bool(forKey: "Unlinked") == true {
                postingId = 0
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as? DashViewControllerTurkey
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
                
            } else if postingIdFromExistingNavigate == "Exting" {
                self.navigationController?.popViewController(animated: true)
                
                
                
                
                var  necId =  postingIdFromExisting
                var  totalWeight = Double()
                
                var selectedFarmName = ""
                
                
                for bird in 1...(items[self.farmRow] as AnyObject).count! {
                    var currentBird = bird as NSNumber
                    dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(currentBird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
                    
                    let NewImmu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
                    
                    var  getWeight = NewImmu.actualText ?? ""
                    
                    totalWeight = totalWeight + (getWeight as NSString).doubleValue
                    totalWeight = totalWeight.rounded(toPlaces: 3)
                    
                }
                selectedFarmName = UserDefaults.standard.string(forKey: "farm") ?? ""
                
                CoreDataHandlerTurkey().updateNecropsyFarmWeightstep1WithNecIdTurkey(necId as NSNumber, isSync: true, farmWeight: "\(totalWeight)", farmName: selectedFarmName as NSString )
                
                
                
            } else {
                postingId = UserDefaults.standard.integer(forKey: "postingId")
                CoreDataHandlerTurkey().updateFinalizeDataWithNecTurkey(postingId as NSNumber, finalizeNec: 1)
                backBttnn = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
                backBttnn.backgroundColor = UIColor.black
                backBttnn.alpha = 0.6
                backBttnn.setTitle("", for: UIControl.State())
                backBttnn.addTarget(self, action: #selector(buttonAcn), for: .touchUpInside)
                self.view.addSubview(backBttnn)
                
                summaryRepo = summaryReportTurkey.loadFromNibNamed("summaryReportTurkey") as! summaryReportTurkey
                summaryRepo.sumarryDelegate = self
                summaryRepo.center = self.view.center
                
                
                
                var necId =  postingId
                var  totalWeight =  Double()
                
                var selectedFarmName = ""
                for bird in 1...(items[self.farmRow] as AnyObject).count! {
                    
                    var   currentBird = bird as NSNumber
                    dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(currentBird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
                    
                    let NewImmu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
                    let getWeight = NewImmu.actualText ?? ""
                    totalWeight = totalWeight + (getWeight as NSString).doubleValue
                    totalWeight = totalWeight.rounded(toPlaces: 3)
                    
                }
                selectedFarmName = UserDefaults.standard.string(forKey: "farm") ?? ""
                
                CoreDataHandlerTurkey().updateNecropsyFarmWeightstep1WithNecIdTurkey(necId as NSNumber, isSync: true, farmWeight: "\(totalWeight)" , farmName: selectedFarmName as NSString)
                
                self.view.addSubview(summaryRepo)
            }
        }}
    
    @IBAction func addFramActionButton(_ sender: AnyObject) {
        //  selectedFarmIndexTurkey = farmArray.count
        farmRow =  farmArray.count
        buttonback = UIButton(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        buttonback.backgroundColor = UIColor.black
        buttonback.alpha = 0.6
        buttonback.setTitle("", for: UIControl.State())
        buttonback.addTarget(self, action: #selector(buttonAcntion), for: .touchUpInside)
        self.view.addSubview(buttonback)
        
        customPopV = AddFarmTurkey.loadFromNibNamed("AddFarmTurkey") as! AddFarmTurkey
        
        
        customPopV.AddFarmDelegate = self
        
        if postingIdFromExistingNavigate == "Exting"{
            
            var necId =  postingIdFromExisting
            customPopV.necIdExIsting = "Exting"
            customPopV.necIdExist = necId
        }
        
        customPopV.delegeterefreshPage = self
        customPopV.center = self.view.center
        self.view.addSubview(customPopV)
        
        
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
        
        if postingIdFromExistingNavigate == "Exting" {
            
            var necId =  postingIdFromExisting
            var  totalWeight = Double()
            var selectedFarmName = ""
            
            for bird in 1...(items[self.farmRow] as AnyObject).count! {
                var currentBird = bird as NSNumber
                dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(currentBird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
                
                let NewImmu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
                
                var getWeight = NewImmu.actualText ?? ""
                
                totalWeight = totalWeight + (getWeight as NSString).doubleValue
                totalWeight = totalWeight.rounded(toPlaces: 3)
                
            }
            selectedFarmName = UserDefaults.standard.string(forKey: "farm") ?? ""
            
            CoreDataHandlerTurkey().updateNecropsyFarmWeightstep1WithNecIdTurkey(necId as NSNumber, isSync: true, farmWeight: "\(totalWeight)", farmName: selectedFarmName as NSString )
            
        }
        else
        {
            
            activityView.removeFromSuperview()
            var  postingId = UserDefaults.standard.integer(forKey: "postingId")
            CoreDataHandlerTurkey().updateFinalizeDataWithNecTurkey(postingId as NSNumber, finalizeNec: 1)
            
            
            
            
            var  necId =  postingId
            var  totalWeight = Double()
            
            var selectedFarmName = ""
            for bird in 1...(items[self.farmRow] as AnyObject).count! {
                
                var currentBird = bird as NSNumber
                dataArrayImmu =  CoreDataHandlerTurkey().fecthFrmWithCatnameWithBirdAndObservationTurkey(currentBird , farmname: UserDefaults.standard.object(forKey: "farm") as! String, catName: "Immune",necId: necId as NSNumber).mutableCopy() as! NSMutableArray
                
                let NewImmu : CaptureNecropsyViewDataTurkey = dataArrayImmu.object(at: 0) as! CaptureNecropsyViewDataTurkey
                var getWeight = NewImmu.actualText ?? ""
                totalWeight = totalWeight + Double((getWeight as NSString).floatValue)
                totalWeight = totalWeight.rounded(toPlaces: 3)
                
            }
            selectedFarmName = UserDefaults.standard.string(forKey: "farm") ?? ""
            
            CoreDataHandlerTurkey().updateNecropsyFarmWeightstep1WithNecIdTurkey(necId as NSNumber, isSync: true, farmWeight: "\(totalWeight)" , farmName: selectedFarmName as NSString)
        }
        
        
        activityView.removeFromSuperview()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func logOut(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
        
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
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
        
        
        for i in 0..<postingArrWithAllData.count{
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count{
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    func callSyncApi(){
        //  objApiSync.feedprogram()
    }
    
    //MARK -- Delegate SyNC Api
    func failWithError(statusCode:Int){
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
            }
            if lngId == 1000 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again(NA))", comment: ""))
            }
            else if lngId == 3 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
            
        }
    }
    func failWithErrorInternal(){
        Helper.dismissGlobalHUD(self.view)
        
        self.printSyncLblCount()
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    
    func didFinishApi(){
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnection() {
        
        self.printSyncLblCount()
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
    func printSyncLblCount() {
        syncNotiCount.text = String(self.allSessionArr().count)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}



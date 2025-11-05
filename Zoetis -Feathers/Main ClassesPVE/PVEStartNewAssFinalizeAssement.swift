//
//  PVEStartNewAssFinalizeAssement.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 12/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON
import RSSelectionMenu
import CloudKit

class PVEStartNewAssFinalizeAssement: BaseViewController  , UISearchBarDelegate {
    
    let sharedManager = PVEShared.sharedInstance
    
    @IBOutlet weak var bgView: GradientButton!
    
    @IBOutlet weak var headerView: UIView!
    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var scoreGradientView: UIView!
    @IBOutlet weak var scoreParentView: UIView!
    
    var selectedIndex = Int()
    var selectedAssessmentId = Int()
    var currentArr = [[String : AnyObject]]()
    var fullScore = Int()
    var currentCategoryTotalScore = Int()
    var currentSel_seq_Number = NSNumber()
    var currentSel_CategoryIndex = Int()
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var draftBtn: UIButton!
    @IBOutlet weak var draftCenterBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var assessmentDateLbl : UITextField!
    @IBOutlet weak var customerLbl : UITextField!
    @IBOutlet weak var complexLbl : UITextField!
    @IBOutlet weak var currentCategoryScoreLbl : UILabel!
    var assessmentArr = NSArray()
    var questionsArr = NSArray()
    
    var dummyArr = NSArray()
    var sumOfMaxMarks = Int()
    
    var newDropDown = DropDown()
    var liveQuesArr = NSArray()
    var inactiveQuessArr = NSArray()
    var otherQuessArr = NSArray()
    var tempDict = PVE_AssessmentQuestion()
    var copyliveQuesArr = NSArray()
    var copyInactiveQuessArr = NSArray()
    var clickedDateIndpath = NSIndexPath()
    
    private var noOfCatcherArr = [[String : String]]()
    private var noOfVaccinatorsArr = [[String : String]]()
    private var vaccinInfoDetailArr = [[String : Any]]()
    private var vaccinInfoPlusBtnClicked = Bool()
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    fileprivate   var isLiveVaccineOn = Bool()
    fileprivate var isInActiveVaccineOn = Bool()
    var livePoint = Int()
    var InactivePoint = Int()
    var searchBar = UISearchBar()
    var simpleSelectedArray = [String]()
    var simpleSelectedIdArray = [Int]()
    var selectedAntigenArray = [SelectedData]()
    var antigenNameArr = [String]()
    var antigenIdArr = [String]()
    
    var items = [String]()
    var itemsIds = [String]()
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        vaccinInfoDetailArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as? [[String : Any]] ?? []
        
        setupHeader()
        
        currentCategoryTotalScore = 0
        newDropDown.anchorView = searchBar
        
        tblView.register(UINib(nibName: "VaccineEvaluationCell", bundle: nil), forCellReuseIdentifier: "VaccineEvaluationCell")
        
        let nibName = UINib(nibName: "VaccineInformationHeader", bundle: nil)
        tblView.register(nibName, forHeaderFooterViewReuseIdentifier: "VaccineInformationHeader")
        
        let nibCatchers = UINib(nibName: "NoOfCatchersHeader", bundle: nil)
        tblView.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "NoOfCatchersHeader")
        
        let nibVaccinators = UINib(nibName: "NoOfVaccinatorsHeader", bundle: nil)
        tblView.register(nibVaccinators, forHeaderFooterViewReuseIdentifier: "NoOfVaccinatorsHeader")
        
        let nibQuestionCellHeader = UINib(nibName: "QuestionCellHeader", bundle: nil)
        tblView.register(nibQuestionCellHeader, forHeaderFooterViewReuseIdentifier: "QuestionCellHeader")
        
        let nibLiveVaccineHeader = UINib(nibName: "liveVaccineHeader", bundle: nil)
        tblView.register(nibLiveVaccineHeader, forHeaderFooterViewReuseIdentifier: "liveVaccineHeader")
    }
    
    func setupUI(){
        
        DispatchQueue.main.async {
            self.coustomerView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.bounds.origin.y == 0{
            self.view.bounds.origin.y += keyboardFrame.height
        }
        tblView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
        }
        tblView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setInitialValues()
        peHeaderViewController.onGoingSessionView.isHidden = true
        peHeaderViewController.syncView.isHidden = true
        noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        setupUI()
        tblView.reloadData()
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Start New Assessment"
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    func saveDataInDraft() {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PVEDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                
                let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
                let catArray = assessmentArr.value(forKey: "category_Name") as? NSArray ?? NSArray()
                
                let timeStampStr = sharedManager.generateCurrentTimeStamp()
                CoreDataHandlerPVE().saveSyncDetailsInDB(maxScoreArray: [], scoreArray: [], categoryArray: catArray, syncId: timeStampStr,  dataTypeStr: "draft")
                
                CoreDataHandlerPVE().saveSyncAssCatDetails(type: "draft", syncId: timeStampStr)
                CoreDataHandlerPVE().saveSyncAssQuestions(type: "draft", syncId: timeStampStr)
                
                CoreDataHandlerPVE().saveSyncImageDetailsInDB(syncId: timeStampStr)
                let PVE_ImageEntitySyncArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_ImageEntitySync")
                
                CoreDataHandler().deleteAllData("PVE_Session")
                CoreDataHandler().deleteAllData("PVE_ImageEntity")
                CoreDataHandlerPVE().resetCurrentSessionDetailsInDB()
                break
            }
        }
        
    }
    
    @IBAction func draftBtnAction(_ sender: Any) {
        
        let errorMSg = "Are you sure you want to save assessment in draft?"
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            NSLog("OK Pressed")
            self.saveDataInDraft()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func saveFinalizedData(){
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PVEDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                
                let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
                
                var scoreArr = [Any]()
                scoreArr = CoreDataHandlerPVE().fetchScoredArr(seq_NumberArr).scoreArr as! [Any]
                scoreArr.removeLast()
                scoreArr.append(sharedManager.vaccineEvaluationScoreTotal)
                
                var max_MarksArr = [Int]()
                max_MarksArr = CoreDataHandlerPVE().fetchScoredArr(seq_NumberArr).max_MarksArr as! [Int]
                
                if currentSel_seq_Number == 6 {
                    let seq_NumberArr = assessmentArr.value(forKey: "max_Mark")  as? NSArray ?? NSArray()
                    let marks = seq_NumberArr.lastObject as! Int
                    max_MarksArr.append(marks)
                }
                
                
                let catArray = assessmentArr.value(forKey: "category_Name") as? NSArray ?? NSArray()
                
                let timeStampStr = sharedManager.generateCurrentTimeStamp()
                
                CoreDataHandlerPVE().saveSyncDetailsInDB(maxScoreArray: max_MarksArr as NSArray, scoreArray: scoreArr as NSArray, categoryArray: catArray, syncId: timeStampStr,  dataTypeStr: "sync")
                
                CoreDataHandlerPVE().saveSyncAssCatDetails(type: "sync", syncId: timeStampStr)
                CoreDataHandlerPVE().saveSyncAssQuestions(type: "sync", syncId: timeStampStr)
                
                CoreDataHandlerPVE().saveSyncImageDetailsInDB(syncId: timeStampStr)
                let PVE_ImageEntitySyncArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_ImageEntitySync")
                
                CoreDataHandler().deleteAllData("PVE_Session")
                CoreDataHandler().deleteAllData("PVE_ImageEntity")
                CoreDataHandlerPVE().resetCurrentSessionDetailsInDB()
                
                break
            }
        }
    }
    
    @IBAction func syncBtnAction(_ sender: Any) {
        
        for (indx, _) in vaccinInfoDetailArr.enumerated() {
            
            if vaccinInfoDetailArr[indx]["man"] as? String == "" || vaccinInfoDetailArr[indx]["name"] as? String == "" || (vaccinInfoDetailArr[indx]["serotype"] as? [String])?.isEmpty ?? true {
                showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                
                selectColeectionViewCell(currentSel_CategoryIndex: 1)
                let selectedItem = IndexPath(row: Int(truncating: NSNumber(value: 1)), section: 0)
                collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .centeredVertically)
                
                let indexPath = IndexPath(row: indx, section: 4)
                self.tblView.scrollToRow(at:  indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
                showtoast(message: "Please enter vaccine details in the Vaccine preparation, Storage & Sterility Tab.")
                
                return
            }
            
        }
        
        
        let errorMSg = "Are you sure you want to finish the assessment? After finishing the information can't be edited."
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            NSLog("OK Pressed")
            self.saveFinalizedData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func getEvaluationDateFromDB(key:String) -> Date{
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Session")
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0] as! Date
    }
    
    func setInitialValues() {
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Session")
        let arr = valuee.value(forKey: "xSelectedCategoryIndex")  as! NSArray
        let selectedIndx = arr[0] as! Int
        self.currentSel_CategoryIndex = Int(truncating: NSNumber(value: selectedIndx))
        
        currentCategoryTotalScore = selectedIndx
        customerLbl.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
        complexLbl.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
        assessmentDateLbl.text = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
        
        assessmentArr = CoreDataHandlerPVE().fetchDetailsForAssessmentCategoriesDetails()
        
        let selectedItem = IndexPath(row: Int(truncating: NSNumber(value: currentSel_CategoryIndex)), section: 0)
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .centeredVertically)
        
        let seq_Number = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        currentSel_seq_Number = seq_Number[self.currentSel_CategoryIndex] as! NSNumber
        fetchCurrentArrayForSeqNo(seq_Number: currentSel_seq_Number)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,selector: #selector(reloadSNATblViewNoti), name: NSNotification.Name("reloadSNATblViewNoti"),object: nil)
        
        selectColeectionViewCell(currentSel_CategoryIndex: Int(truncating: NSNumber(value: self.currentSel_CategoryIndex)))
        self.collectionView(collectionView, didSelectItemAt: selectedItem)
        
        tblView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tblView.reloadData()
        setMarksLabel()
        
    }
    
    @objc private func reloadSNATblViewNoti(noti: NSNotification){
        
        currentCategoryTotalScore = 0
        assessmentArr = CoreDataHandlerPVE().fetchDetailsForAssessmentCategoriesDetails()
        resetBoderderCatcherVac()
        tblView.reloadData()
        
        let allCategorySelected = checkAllCategorySeledtedOneQuestion()
        setMarksLabel()
    }
    
    func setMarksLabel() {
        currentCategoryScoreLbl.text = CoreDataHandlerPVE().fetchSumOfSelectedMarks(currentSel_seq_Number)
        
        if currentSel_seq_Number == 6 {
            let seq_NumberArr = assessmentArr.value(forKey: "max_Mark")  as? NSArray ?? NSArray()
            let marks = seq_NumberArr.lastObject as! Int
            currentCategoryScoreLbl.text = "\(String(format: "%.2f", sharedManager.vaccineEvaluationScoreTotal)) / \(String(describing: marks))"
        }
    }
    
    @IBAction func infoBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        selectedIndex = indexPath!.section as Int
        
        var max_ScoreArr = questionsArr.value(forKey: "max_Score") as? [Int]
        var max_Score = max_ScoreArr![indexPath!.row]
        
        var infoArr = questionsArr.value(forKey: "information") as? [String]
        var infoStr = infoArr![indexPath!.row]
        
        var folder_PathArr = questionsArr.value(forKey: "folder_Path") as? [String]
        var folder_Path = folder_PathArr![indexPath!.row]
        
        var image_NameArr = questionsArr.value(forKey: "image_Name") as? [String]
        var image_Name = image_NameArr![indexPath!.row]
        
        var assessmentArr = questionsArr.value(forKey: "assessment") as? [String]
        var assessment = assessmentArr![indexPath!.row]
        
        var idArr = questionsArr.value(forKey: "id") as? [Int]
        var qId = idArr![indexPath!.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "InfoPVEViewController") as! InfoPVEViewController
        
        if currentSel_seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            if selectedIndex == 4{
                
                max_ScoreArr = liveQuesArr.value(forKey: "max_Score") as? [Int]
                max_Score = max_ScoreArr![indexPath!.row]
                
                infoArr = liveQuesArr.value(forKey: "information") as? [String]
                infoStr = infoArr![indexPath!.row]
                
                folder_PathArr = liveQuesArr.value(forKey: "folder_Path") as? [String]
                folder_Path = folder_PathArr![indexPath!.row]
                
                image_NameArr = liveQuesArr.value(forKey: "image_Name") as? [String]
                image_Name = image_NameArr![indexPath!.row]
                
                assessmentArr = liveQuesArr.value(forKey: "assessment") as? [String]
                assessment = assessmentArr![indexPath!.row]
                
            }
            else if selectedIndex == 5{
                
                max_ScoreArr = inactiveQuessArr.value(forKey: "max_Score") as? [Int]
                max_Score = max_ScoreArr![indexPath!.row]
                
                infoArr = inactiveQuessArr.value(forKey: "information") as? [String]
                infoStr = infoArr![indexPath!.row]
                
                folder_PathArr = inactiveQuessArr.value(forKey: "folder_Path") as? [String]
                folder_Path = folder_PathArr![indexPath!.row]
                
                image_NameArr = inactiveQuessArr.value(forKey: "image_Name") as? [String]
                image_Name = image_NameArr![indexPath!.row]
                
                assessmentArr = inactiveQuessArr.value(forKey: "assessment") as? [String]
                assessment = assessmentArr![indexPath!.row]
            }
            else{
                max_ScoreArr = otherQuessArr.value(forKey: "max_Score") as? [Int]
                max_Score = max_ScoreArr![indexPath!.row]
                
                infoArr = otherQuessArr.value(forKey: "information") as? [String]
                infoStr = infoArr![indexPath!.row]
                
                folder_PathArr = otherQuessArr.value(forKey: "folder_Path") as? [String]
                folder_Path = folder_PathArr![indexPath!.row]
                
                image_NameArr = otherQuessArr.value(forKey: "image_Name") as? [String]
                image_Name = image_NameArr![indexPath!.row]
                
                assessmentArr = otherQuessArr.value(forKey: "assessment") as? [String]
                assessment = assessmentArr![indexPath!.row]
            }
        }
        else{
            max_ScoreArr = questionsArr.value(forKey: "max_Score") as? [Int]
            max_Score = max_ScoreArr![indexPath!.row]
            
            infoArr = questionsArr.value(forKey: "information") as? [String]
            infoStr = infoArr![indexPath!.row]
            
            folder_PathArr = questionsArr.value(forKey: "folder_Path") as? [String]
            folder_Path = folder_PathArr![indexPath!.row]
            
            image_NameArr = questionsArr.value(forKey: "image_Name") as? [String]
            image_Name = image_NameArr![indexPath!.row]
            
            assessmentArr = questionsArr.value(forKey: "assessment") as? [String]
            assessment = assessmentArr![indexPath!.row]
            
            idArr = questionsArr.value(forKey: "id") as? [Int]
            qId = idArr![indexPath!.row]
        }
        
        vc.questionIs = "(\(max_Score)) \(assessment)"
        vc.questionDescriptionIs = "\(infoStr)"
        vc.imageUrlString = "\(folder_Path)/" + "\(image_Name)"
        vc.questionId = "\(qId)"
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func notesBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        questionsArr = CoreDataHandlerPVE().fetchAssessmentQuestion(currentSel_seq_Number) as NSArray
        selectedIndex = indexPath!.section as Int
        
        var max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
        var seq_Number = max_ScoreArr![0]
        
        var idArr = questionsArr.value(forKey: "id") as? [Int]
        var id = idArr![indexPath!.row]
        
        var commentArr = questionsArr.value(forKey: "comment") as? [String]
        var comment = commentArr![indexPath!.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVECommentPopupViewController") as! PVECommentPopupViewController
        vc.delegate = self
        
        if currentSel_seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            if selectedIndex == 4
            {
                max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                vc.seq_Number = seq_Number
                
                idArr = liveQuesArr.value(forKey: "id") as? [Int]
                id = idArr![indexPath!.row]
                vc.rowId = id
                
                commentArr = liveQuesArr.value(forKey: "comment") as? [String]
                comment = commentArr![indexPath!.row]
                vc.commentStr = comment
            }
            else if selectedIndex == 5
            {
                max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                vc.seq_Number = seq_Number
                
                idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                id = idArr![indexPath!.row]
                vc.rowId = id
                
                commentArr = inactiveQuessArr.value(forKey: "comment") as? [String]
                comment = commentArr![indexPath!.row]
                vc.commentStr = comment
            }
            else{
                max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                vc.seq_Number = seq_Number
                
                idArr = otherQuessArr.value(forKey: "id") as? [Int]
                id = idArr![indexPath!.row]
                vc.rowId = id
                
                commentArr = otherQuessArr.value(forKey: "comment") as? [String]
                comment = commentArr![indexPath!.row]
                vc.commentStr = comment
            }
        }
        
        else{
            max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
            seq_Number = max_ScoreArr![0]
            vc.seq_Number = seq_Number
            
            idArr = questionsArr.value(forKey: "id") as? [Int]
            id = idArr![indexPath!.row]
            vc.rowId = id
            
            commentArr = questionsArr.value(forKey: "comment") as? [String]
            comment = commentArr![indexPath!.row]
            vc.commentStr = comment
        }
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
}

extension PVEStartNewAssFinalizeAssement:  UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBAction func cameraBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        selectedIndex = indexPath!.section as Int
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Session")
        let valueArr = valuee.value(forKey: "cameraEnabled") as! NSArray
        if valueArr.count > 0 {
            let isCameraOn = valueArr[0] as! String
            if isCameraOn == "true"{
                
                let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
                let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
                if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVEVaccinationCrewSafetyCell
                {
                    
                    let imgCount = Int(cell.imgCountBtn.titleLabel?.text ?? "0")
                    if imgCount == 5 {
                        if cell.imgCountBtn.isHidden == true{
                        }else{
                            postAlert("Reached maximum!", message: "Reached maximum limit of images for this question.")
                            return
                        }
                    }else{
                        
                    }
                }
                
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                        imagePicker.allowsEditing = false
                        imagePicker.sourceType = .camera
                        imagePicker.cameraCaptureMode = .photo
                        imagePicker.delegate = self
                        
                        imagePicker.view.tag = indexPath!.row
                        present(imagePicker, animated: true, completion: {})
                    } else {
                        postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
                    }
                }else{
                }
            }
        }
    }
    
    /************* Alert View Methods ***********************************/
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /**************************************************************************************************/
    
    /******************************  Image Picker Delegate Methods ***************************************/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        //
        if let pickedImage: UIImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]) as? UIImage {
            let imageData: Data? = pickedImage.jpegData(compressionQuality: 0.1)
            
            
            questionsArr = CoreDataHandlerPVE().fetchAssessmentQuestion(currentSel_seq_Number) as NSArray
            
            if currentSel_seq_Number == 2
            {
                liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
                inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
                otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
                
                if selectedIndex == 4
                {
                    
                    let max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
                    let seq_Number = max_ScoreArr![imagePicker.view.tag]
                    
                    let idArr = liveQuesArr.value(forKey: "id") as? [Int]
                    let id = idArr![imagePicker.view.tag]
                    
                    
                    CoreDataHandlerPVE().updateImageDataInAssementDetails(seq_Number, rowId: id, imageData: imageData!)
                }
                
                else if selectedIndex == 5
                {
                    let max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                    let seq_Number = max_ScoreArr![imagePicker.view.tag]
                    
                    let idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                    let id = idArr![imagePicker.view.tag]
                    
                    
                    CoreDataHandlerPVE().updateImageDataInAssementDetails(seq_Number, rowId: id, imageData: imageData!)
                }
                else
                {
                    let max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                    let seq_Number = max_ScoreArr![imagePicker.view.tag]
                    
                    let idArr = otherQuessArr.value(forKey: "id") as? [Int]
                    let id = idArr![imagePicker.view.tag]
                    
                    CoreDataHandlerPVE().updateImageDataInAssementDetails(seq_Number, rowId: id, imageData: imageData!)
                }
            }
            
            else
            {
                let max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
                let seq_Number = max_ScoreArr![imagePicker.view.tag]
                
                let idArr = questionsArr.value(forKey: "id") as? [Int]
                let id = idArr![imagePicker.view.tag]
                
                CoreDataHandlerPVE().updateImageDataInAssementDetails(seq_Number, rowId: id, imageData: imageData!)
            }
            
            
            
            imagePicker.dismiss(animated: true, completion: {
                
                self.tblView.reloadData()
                
            })
        }
        /******************************************************************************************************/
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            dismiss(animated: true, completion: {
            })
        }
        
    }
    
    @IBAction func btnImageCountAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        selectedIndex = indexPath!.section as Int
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GroupImagesPVEViewController") as! GroupImagesPVEViewController
        vc.imagesDataArray = getImageDataArr(currentSelectedBtnIndex: indexPath!.row)
        self.navigationController?.present(vc, animated: false, completion: nil)
        
    }
    
    func getImageDataArr(currentSelectedBtnIndex:Int) -> [Data]{
        
        questionsArr = CoreDataHandlerPVE().fetchAssessmentQuestion(currentSel_seq_Number) as NSArray
        
        var max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
        var seq_Number = max_ScoreArr![0]
        
        var idArr = questionsArr.value(forKey: "id") as? [Int]
        var id = idArr![currentSelectedBtnIndex]
        
        var tempArr = NSArray()
        
        if currentSel_seq_Number == 2 {
            
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            if selectedIndex == 4 {
                
                max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                
                idArr = liveQuesArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
            else if selectedIndex == 5 {
                
                max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                
                idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
            else {
                max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![0]
                
                idArr = otherQuessArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
            
        }
        else {
            max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
            seq_Number = max_ScoreArr![0]
            
            idArr = questionsArr.value(forKey: "id") as? [Int]
            id = idArr![currentSelectedBtnIndex]
        }
        
        tempArr = CoreDataHandlerPVE().getImageDataForCurrentAssementDetails("", seqNumber: NSNumber(value: seq_Number), rowId: id, entity: "PVE_ImageEntity")
        
        let imgDaraArr = tempArr.value(forKey: "imageData") as? [Data]
        return imgDaraArr!
        
    }
    
}


extension PVEStartNewAssFinalizeAssement{
    
    func coleraVaccineGetScore(percentCanterLRTotal:Int) -> Int{
        
        switch percentCanterLRTotal {
        case 0..<92:
            return 0
        case 92..<94 :
            return 2
        case 94..<96:
            return 4
        case 96..<98:
            return 6
        case 98..<100:
            return 8
        case 100 :
            return 10
        default:
            return 0
        }
    }
    
    func inactivatedVaccineGetScore(siteOfInjectScored:Int) -> Int{
        
        switch siteOfInjectScored {
        case 0..<92:
            return 0
        case 92..<94 :
            return 4
        case 94..<96:
            return 8
        case 96..<98:
            return 12
        case 98..<100:
            return 16
        case 100 :
            return 20
        default:
            return 0
        }
    }
    
    
    
}

extension PVEStartNewAssFinalizeAssement: VaccinatorsPlusBtnDelegate,NoOfvaccinatorsMinusDelegate {
    
    func updateVaccinatorsArrInDB(currentIndPath: NSIndexPath, nameStr: String, emailStr: String, mobileStr: String) {
        
        CoreDataHandlerPVE().updateArrayInfoFor("", currentIndPath: currentIndPath, text: nameStr, forAttribute: "cat_NoOfVaccinatorsDetailsArr", entityName: "PVE_Session")
        
        noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as! [[String : String]]
        
    }
    
    func vaccinatorMinusBtnTapped(count: Int) {
        
        noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        
        if noOfVaccinatorsArr.count > 0 {
            tblView.beginUpdates()
            
            noOfVaccinatorsArr.remove(at: noOfVaccinatorsArr.count-1)
            var indPathArr = [NSIndexPath]()
            indPathArr = [IndexPath(row: noOfVaccinatorsArr.count, section: 2) as NSIndexPath]
            tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfVaccinatorsArr, forAttribute: "cat_NoOfVaccinatorsDetailsArr")
            let noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
            
            
            if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
            {
                cell.numberr = noOfVaccinatorsArr.count
                cell.txtFeild.text = "\(cell.numberr)"
                cell.bgBtn.layer.borderColor = UIColor.black.cgColor
                cell.bgBtn.layer.borderWidth = 1.0
            }
            
            tblView.endUpdates()
            tblView.reloadData()
            view.endEditing(true)
        }
        
    }
    
    func vaccinatorPlusBtnTapped(count: Int) {
        
        if count >= 200 {
            
            if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
            {
                cell.bgBtn.layer.borderColor = UIColor.red.cgColor
                cell.bgBtn.layer.borderWidth = 2.0
            }
            
            showtoast(message: "You have reached to your maximum limit of 200.")
            
            return
        }
        
        noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
        {
            cell.bgBtn.layer.borderColor = UIColor.black.cgColor
            cell.bgBtn.layer.borderWidth = 1.0
        }
        
        if count  ==  noOfVaccinatorsArr.count{
            
            tblView.beginUpdates()
            
            let indexPath = IndexPath(row: noOfVaccinatorsArr.count, section: 2)
            tblView.insertRows(at: [indexPath], with: .bottom)
            noOfVaccinatorsArr.append(["name" : "", "serology" : ""])
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfVaccinatorsArr, forAttribute: "cat_NoOfVaccinatorsDetailsArr")
            let noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
            
            if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
            {
                cell.numberr = noOfVaccinatorsArr.count
                cell.txtFeild.text = "\(cell.numberr)"
            }
            
            self.noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
            view.endEditing(true)
            tblView.endUpdates()
            tblView.reloadData()
            
            return
        }
        
        if count != 0 {
            
            tblView.beginUpdates()
            
            if count < noOfVaccinatorsArr.count && noOfVaccinatorsArr.count > 0{
                
                let ddd = noOfVaccinatorsArr.count - count
                var indPathArr = [NSIndexPath]()
                for indx in 1...ddd {
                    noOfVaccinatorsArr.remove(at: noOfVaccinatorsArr.count-1)
                    indPathArr.append(IndexPath(row: indx, section: 2) as NSIndexPath)
                }
                tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
                
            }else{
                
                if noOfVaccinatorsArr.count > 0{
                    var indPathArr = [NSIndexPath]()
                    for indx in 1...noOfVaccinatorsArr.count {
                        indPathArr.append(IndexPath(row: indx-1, section: 2) as NSIndexPath)
                    }
                    tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
                    noOfVaccinatorsArr.removeAll()
                }
                
                var indPathArr = [NSIndexPath]()
                
                for indx in 1...count {
                    noOfVaccinatorsArr.append(["name" : "", "serology" : ""])
                    indPathArr.append(IndexPath(row: indx-1, section: 2) as NSIndexPath)
                }
                
                tblView.insertRows(at: indPathArr as [IndexPath], with: .bottom)
                
            }
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfVaccinatorsArr, forAttribute: "cat_NoOfVaccinatorsDetailsArr")
            noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
            tblView.endUpdates()
            view.endEditing(true)
            
        }
    }
    
    func vaccinatorsbtnMinusTapped(clickedBtnIndPath: NSIndexPath) {
        if noOfVaccinatorsArr.count > 0{
            tblView.beginUpdates()
            let indexPath = IndexPath(row: clickedBtnIndPath.row, section: 2)
            var indPathArr = [NSIndexPath]()
            indPathArr.append(indexPath as NSIndexPath)
            tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
            noOfVaccinatorsArr.remove(at: noOfVaccinatorsArr.count-1)
            
            if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
            {
                cell.numberr = noOfVaccinatorsArr.count
                cell.txtFeild.text = "\(cell.numberr)"
                cell.bgBtn.layer.borderColor = UIColor.black.cgColor
                cell.bgBtn.layer.borderWidth = 1.0
            }
            
            tblView.endUpdates()
            tblView.reloadData()
            view.endEditing(true)
        }
    }
    
}

extension PVEStartNewAssFinalizeAssement: NoOfCatchersMinusDelegate,CatchersPlusBtnDelegate , AddedComment{
    
    func updatedComment(commentStr: String) {
        
    }
    
    
    func resetBoderderCatcherVac() {
        if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
        {
            cell.bgBtn.layer.borderColor = UIColor.black.cgColor
            cell.bgBtn.layer.borderWidth = 1.0
        }
        if  let cell = self.tblView.headerView(forSection: 2) as? NoOfVaccinatorsHeader
        {
            cell.bgBtn.layer.borderColor = UIColor.black.cgColor
            cell.bgBtn.layer.borderWidth = 1.0
        }
        tblView.reloadData()
    }
    
    func updateCatchersArrInDB(currentIndPath: NSIndexPath, nameStr: String, emailStr: String, mobileStr: String) {
        
        CoreDataHandlerPVE().updateArrayInfoFor("", currentIndPath: currentIndPath, text: nameStr, forAttribute: "cat_NoOfCatchersDetailsArr", entityName: "PVE_Session")
        noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as! [[String : String]]
    }
    
    
    func catchersbtnMinusBtnTapped(count: Int) {
        
        noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        
        if noOfCatcherArr.count > 0 {
            tblView.beginUpdates()
            
            noOfCatcherArr.remove(at: noOfCatcherArr.count-1)
            var indPathArr = [NSIndexPath]()
            indPathArr = [IndexPath(row: noOfCatcherArr.count, section: 1) as NSIndexPath]
            tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfCatcherArr, forAttribute: "cat_NoOfCatchersDetailsArr")
            let noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
            
            if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
            {
                cell.numberr = noOfCatcherArr.count
                cell.noOfCatchersTxtFeild.text = "\(cell.numberr)"
                cell.bgBtn.layer.borderColor = UIColor.black.cgColor
                cell.bgBtn.layer.borderWidth = 1.0
            }
            
            
            tblView.endUpdates()
            tblView.reloadData()
            view.endEditing(true)
        }
        
    }
    
    func catchersbtnPlusBtnTapped(count: Int) {
        
        if count >= 200 {
            
            if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
            {
                cell.bgBtn.layer.borderColor = UIColor.red.cgColor
                cell.bgBtn.layer.borderWidth = 2.0
            }
            
            showtoast(message: "You have reached to your maximum limit of 200.")
            
            return
        }
        
        noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        
        if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
        {
            cell.bgBtn.layer.borderColor = UIColor.black.cgColor
            cell.bgBtn.layer.borderWidth = 1.0
        }
        
        if count  ==  noOfCatcherArr.count{
            
            tblView.beginUpdates()
            
            let indexPath = IndexPath(row: noOfCatcherArr.count, section: 1)
            tblView.insertRows(at: [indexPath], with: .bottom)
            noOfCatcherArr.append(["name" : "", "serology" : ""])
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfCatcherArr, forAttribute: "cat_NoOfCatchersDetailsArr")
            let noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
            
            if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
            {
                cell.numberr = noOfCatcherArr.count
                cell.noOfCatchersTxtFeild.text = "\(cell.numberr)"
            }
            
            tblView.endUpdates()
            tblView.reloadData()
            view.endEditing(true)
            
            return
        }
        
        
        if count != 0 {
            
            tblView.beginUpdates()
            
            if count < noOfCatcherArr.count && noOfCatcherArr.count > 0{
                
                let ddd = noOfCatcherArr.count - count
                var indPathArr = [NSIndexPath]()
                for indx in 1...ddd {
                    noOfCatcherArr.remove(at: noOfCatcherArr.count-1)
                    indPathArr.append(IndexPath(row: indx, section: 1) as NSIndexPath)
                }
                tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
                
            }else{
                
                if noOfCatcherArr.count > 0{
                    var indPathArr = [NSIndexPath]()
                    for indx in 1...noOfCatcherArr.count {
                        indPathArr.append(IndexPath(row: indx-1, section: 1) as NSIndexPath)
                    }
                    tblView.deleteRows(at: indPathArr as [IndexPath], with: .bottom)
                    noOfCatcherArr.removeAll()
                }
                
                var indPathArr = [NSIndexPath]()
                
                for indx in 1...count {
                    //noOfCatcherArr.append("newCell")
                    noOfCatcherArr.append(["name" : "", "serology" : ""])
                    indPathArr.append(IndexPath(row: indx-1, section: 1) as NSIndexPath)
                }
                
                tblView.insertRows(at: indPathArr as [IndexPath], with: .bottom)
                
            }
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: noOfCatcherArr, forAttribute: "cat_NoOfCatchersDetailsArr")
            
            tblView.endUpdates()
            view.endEditing(true)
            
        }
    }
    
    func catchersbtnMinusTapped(clickedBtnIndPath: NSIndexPath) {
        if noOfCatcherArr.count > 0{
            tblView.beginUpdates()
            let indexPath = IndexPath(row: clickedBtnIndPath.row, section: 1)
            var indPathArr = [NSIndexPath]()
            indPathArr.append(indexPath as NSIndexPath)
            tblView.deleteRows(at: indPathArr as [IndexPath], with: .top)
            noOfCatcherArr.remove(at: noOfCatcherArr.count-1)
            
            if  let cell = self.tblView.headerView(forSection: 1) as? NoOfCatchersHeader
            {
                cell.numberr = noOfCatcherArr.count
                cell.noOfCatchersTxtFeild.text = "\(cell.numberr)"
            }
            
            tblView.endUpdates()
            tblView.reloadData()
            view.endEditing(true)
        }
    }
}

extension PVEStartNewAssFinalizeAssement: VaccinatorInfoDetailPlusBtnTapped,VaccineInfoDetailsMinusBtnDelegate  {
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, Str: String, fieldType: String) {
        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: fieldType, currentIndPath: currentIndPath, text: Str, id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
        vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
        
    }
    
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, vacNameStr: String) {
        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "name", currentIndPath: currentIndPath, text: vacNameStr, id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
        vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
        
    }
    
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, noteStr: String) {
        if noteStr.count == 0 {
            vaccinInfoPlusBtnClicked = true
        }else{
            vaccinInfoPlusBtnClicked = false
        }
        
        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "note", currentIndPath: currentIndPath, text: noteStr, id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
        
        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
        
    }
    
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, serialStr: String) {
        
        if serialStr.count == 0 {
            vaccinInfoPlusBtnClicked = true
        }else{
            vaccinInfoPlusBtnClicked = false
        }
        
        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serial", currentIndPath: currentIndPath, text: serialStr, id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
        
        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
        //  tblView.reloadData()
        
    }
    
    
    func vaccineInfoDetailsMinusBtnTapped(clickedBtnIndPath: NSIndexPath) {
        tblView.beginUpdates()
        vaccinInfoDetailArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as? [[String : Any]] ?? []
        
        if vaccinInfoDetailArr.count > 0 {
            let indexPath = IndexPath(row: vaccinInfoDetailArr.count-1, section: 6)
            vaccinInfoDetailArr.remove(at: vaccinInfoDetailArr.count-1)
            tblView.deleteRows(at: [indexPath], with: .none)
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: vaccinInfoDetailArr, forAttribute: "cat_vaccinInfoDetailArr")
            vaccinInfoPlusBtnClicked = false
        }
        tblView.endUpdates()
        view.endEditing(true)
        tblView.reloadData()
    }
    
    func vaccinatorInfoDetailPlusBtnTapped(clickedBtnIndPath: NSIndexPath) {
        
        for (indx, _) in vaccinInfoDetailArr.enumerated() {
            
            let indexPath = IndexPath(row: indx, section: 6)
            
            if  let cell = self.tblView.cellForRow(at: indexPath ) as? PVEVaccineInfoDetailsCell
            {
                if cell.vacManTxtFld.text! == "" || cell.vacNameTxtFld.text! == "" || cell.serotypeTxtFld.text! == "" {/*|| cell.serialTxtFld.text! == "" || cell.expiryTxtFld.text! == "" || cell.siteOfInjTxtFld.text! == ""{*/
                    
                    if cell.vacManTxtFld.text! == "" {
                        self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.vacManBtn)
                    }
                    if cell.vacNameTxtFld.text! == "" {
                        self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.vacNameBtn)
                    }
                    if cell.serotypeTxtFld.text! == "" {
                        self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.serotypeBtn)
                    }
                }
            }
            
        }
        
        for (indx, _) in vaccinInfoDetailArr.enumerated() {
            
            if  vaccinInfoDetailArr[indx]["man"] as? String == "" || vaccinInfoDetailArr[indx]["name"] as? String == "" || vaccinInfoDetailArr[indx]["serotype"] as? String == "" /* vaccinInfoDetailArr[indx]["serial"] as? String == "" || vaccinInfoDetailArr[indx]["expDate"] as? String == "" || vaccinInfoDetailArr[indx]["siteOfInj"] as? String == "" */{
                showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
                
                return
            }
        }
        
        tblView.beginUpdates()
        
        vaccinInfoDetailArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as? [[String : Any]] ?? []
        
        vaccinInfoDetailArr.append(["man" : "", "man_id" : 0, "name" : "", "name_id" : 0, "serotype" : "", "serotype_id" : 0, "serial" : "", "expDate" : "", "siteOfInj" : "", "siteOfInj_id" : 0, "note" : "", "otherAntigen" :"" , "showMore" : "No" , "vaccine_id" : 0 ])
        let indexPath = IndexPath(row: vaccinInfoDetailArr.count-1, section: 6)
        
        
        simpleSelectedArray.removeAll()
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: vaccinInfoDetailArr, forAttribute: "cat_vaccinInfoDetailArr")
        vaccinInfoDetailArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as? [[String : Any]] ?? []
        tblView.insertRows(at: [indexPath], with: .bottom)
        vaccinInfoPlusBtnClicked = true
        
        tblView.endUpdates()
        view.endEditing(true)
        tblView.reloadData()
        
    }
    
    // MARK: Switch for Live & Inactivated Vaccine
    @objc func switchTapped(sender:UISwitch) {
        
        if sender.tag == 4 {
            
            let idArr = (liveQuesArr).value(forKey: "id") as? [Int]
            let seqArr = (liveQuesArr).value(forKey: "seq_Number") as? [Int]
            let switchStatus = ((sender as AnyObject).isOn)
            isLiveVaccineOn = switchStatus ?? true
            if let dataArr = idArr {
                for index in 0..<dataArr.count
                {
                    if isLiveVaccineOn {
                        CoreDataHandlerPVE().updateAssementDetails((seqArr!.first)!, id: idArr![index], isSel: !isLiveVaccineOn)
                        
                        CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], isLiveVaccineOn, forAttribute: "liveVaccineSwitch" , comment: "" , forComment : "liveComment")
                    }
                    else
                    {
                        CoreDataHandlerPVE().updateAssementDetails((seqArr!.first)!, id: idArr![index], isSel: !isLiveVaccineOn)
                        CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], isLiveVaccineOn, forAttribute: "liveVaccineSwitch", comment: Constants.liveComment,  forComment : "liveComment")
                    }
                }
            }
        }
        else if sender.tag == 5 {
            
            let idArr = (inactiveQuessArr).value(forKey: "id") as? [Int]
            let seqArr = (inactiveQuessArr).value(forKey: "seq_Number") as? [Int]
            let switchStatus = ((sender as AnyObject).isOn)
            isInActiveVaccineOn = switchStatus ?? true
            if let dataArr = idArr {
                for index in 0..<dataArr.count
                {
                    if isInActiveVaccineOn {
                        CoreDataHandlerPVE().updateAssementDetails((seqArr!.first)!, id: idArr![index], isSel: !isInActiveVaccineOn)
                        CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], isInActiveVaccineOn, forAttribute: "inactiveVaccineSwitch" ,comment: "",  forComment : "inactiveComment")
                    }
                    else
                    {
                        CoreDataHandlerPVE().updateAssementDetails((seqArr!.first)!, id: idArr![index], isSel: !isInActiveVaccineOn)
                        CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], isInActiveVaccineOn, forAttribute: "inactiveVaccineSwitch" , comment: Constants.inactiveComment,  forComment : "inactiveComment")
                    }
                }
            }
        }
        tblView.reloadData()
    }
    
    // MARK: button For Show More & Less
    @objc func showMoreTapped(sender:UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "No"
        
        if let isShow = vaccinInfoDetailArr[currentIndPath!.row]["showMore"]  as? String
        {
            print(isShow)
            if isShow == "No"
            {
                CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "Yes", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                
                CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serial", currentIndPath: currentIndPath! as NSIndexPath, text: "Yes", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                
                vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "Yes"
            }
            else
            {
                CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "No", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "No"
            }
            
        }
        
        
        tblView.reloadData()
    }
    
}


extension PVEStartNewAssFinalizeAssement: VacEvalDelegate,RefreshCommentIconBtnDelegate  {
    func RefreshCommentBtnIcon() {
        
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Session")
        let arr = valuee.value(forKey: "xSelectedCategoryIndex")  as! NSArray
        let selectedIndx = arr[0] as! Int
        
        selectColeectionViewCell(currentSel_CategoryIndex: Int(truncating: NSNumber(value: selectedIndx)))
        
        tblView.reloadData()
    }
    
    func reloadVacEvalContent() {
        tblView.reloadData()
    }
    
}
extension PVEStartNewAssFinalizeAssement: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSel_seq_Number == 2 {  //Vaccine Prepraion Section
            return 7
        }else{
            return 1
        }
    }
    
    
    @IBAction func vaccinatorsPlusBtnAction(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSel_seq_Number == 2 {  //Vaccine Prepraion Section
            if section == 3 {
                return otherQuessArr.count
            }
            if section == 1 {
                return 0
            }
            if section == 2 {
                return 0
            }
            if section == 4 {
                if isLiveVaccineOn == true {
                    return liveQuesArr.count
                }
                else{
                    return 1
                }
            }
            if section == 5 {
                if isInActiveVaccineOn == true {
                    return inactiveQuessArr.count
                }
                else{
                    return 1
                }
                
            }
            if section == 6 {
                return vaccinInfoDetailArr.count
            }
            else{
                return 1
            }
        }
        else if currentSel_seq_Number == 6 { // Vaccine Evaluation Section
            
            return 1
        }
        else{
            return questionsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentSel_seq_Number == 2 {  //Vaccine Prepraion Section
            if indexPath.section == 0 {
                return 200.0
            }
            else if indexPath.section == 1 || indexPath.section == 2{
                return 60.0 //\\\ ---Vaccine Info Detail Cell-----
            }
            else if indexPath.section == 4 || indexPath.section == 5{
                return 80.0 //\\\ ---Crew Safty Cell-----
            }
            else if indexPath.section == 6{
                
                
                if vaccinInfoDetailArr[indexPath.row].keys.contains("showMore"){
                    if vaccinInfoDetailArr[indexPath.row]["showMore"] as! String == "No"
                    {
                        return 93
                    }
                    else
                    {
                        return 300
                    }
                }
                else
                {
                    return 300
                }
                
                
            }
            else{
                return 80.0
            }
        }
        else if currentSel_seq_Number == 6 {
            return 1350.0
        }else{
            return 80.0
        }
        //return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentSel_seq_Number == 2 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccineInfoTypeCell", for: indexPath) as! PVEVaccineInfoTypeCell
                cell.isComesFromDraft = false

                
                cell.refreshFreeSerologyBtnState()
                cell.refreshRadioButton()
                
//                let housingStr = sharedManager.getSessionValueForKeyFromDB(key: "housing") as! String
//                if housingStr == "Floor" {
//                    cell.serologyViewForFreeHousing.isHidden = false
//                }else{
//                    cell.serologyViewForFreeHousing.isHidden = true
//                }
                
                cell.crewLeaderTxtField.text = sharedManager.getSessionValueForKeyFromDB(key: "cat_crewLeaderName") as? String
                cell.crewLeaderEmailTxtField.text = sharedManager.getSessionValueForKeyFromDB(key: "cat_crewLeaderEmail") as? String
                let catcherCount = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? String
                cell.numberOfCatcherTextField.text = catcherCount
                
                cell.companyRepNameTxtField.text = sharedManager.getSessionValueForKeyFromDB(key: "cat_companyRepName") as? String
     //           cell.companyRepEmailTxtField.text = sharedManager.getSessionValueForKeyFromDB(key: "cat_companyRepEmail") as? String
                let noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? String
                cell.numberOfVacconatorsTextField.text = noOfVaccinatorsArr
                
                return cell
            }
//            else if indexPath.section == 1 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "PVETeamMemberCatchersCell", for: indexPath) as! PVETeamMemberCatchersCell
//                cell.currentIndPath = indexPath as NSIndexPath
//                cell.delegate = self
//                if noOfCatcherArr.count > indexPath.row{
//                    
//                    if noOfCatcherArr[indexPath.row].keys.contains("name"){
//                        cell.nameTxtField.text = noOfCatcherArr[indexPath.row]["name"] ?? ""
//                    }else{
//                        cell.nameTxtField.text = ""
//                    }
//                    if noOfCatcherArr[indexPath.row].keys.contains("email"){
//                        cell.emailTxtField.text = noOfCatcherArr[indexPath.row]["email"] ?? ""
//                    }else{
//                        cell.emailTxtField.text = ""
//                    }
//                    if noOfCatcherArr[indexPath.row].keys.contains("mobile"){
//                        cell.mobileTxtField.text = noOfCatcherArr[indexPath.row]["mobile"] ?? ""
//                    }else{
//                        cell.mobileTxtField.text = ""
//                    }
//                }else{
//                    cell.nameTxtField.text = ""
//                    cell.mobileTxtField.text = ""
//                    cell.emailTxtField.text = ""
//                }
//                
//                if cell.currentIndPath.row == 0 {
//                    cell.teamMemberTitleLbl.isHidden = false
//                }else{
//                    cell.teamMemberTitleLbl.isHidden = true
//                }
//                
//                return cell
//            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVETeamMemeberVaccinatorsCell", for: indexPath) as! PVETeamMemeberVaccinatorsCell
                cell.currentIndPath = indexPath as NSIndexPath
                cell.delegate = self
                
                if noOfVaccinatorsArr.count > indexPath.row{
                    
                    if noOfVaccinatorsArr[indexPath.row].keys.contains("name"){
                        cell.nameTxtField.text = noOfVaccinatorsArr[indexPath.row]["name"] ?? ""
                        
                    }else{
                        cell.nameTxtField.text = ""
                    }
                    if noOfVaccinatorsArr[indexPath.row].keys.contains("email"){
                        cell.emailTxtField.text = noOfVaccinatorsArr[indexPath.row]["email"] ?? ""
                    }else{
                        cell.emailTxtField.text = ""
                    }
                    if noOfVaccinatorsArr[indexPath.row].keys.contains("mobile"){
                        cell.mobileTxtField.text = noOfVaccinatorsArr[indexPath.row]["mobile"] ?? ""
                    }else{
                        cell.mobileTxtField.text = ""
                    }
                }
                else{
                    cell.nameTxtField.text = ""
                    cell.mobileTxtField.text = ""
                    cell.emailTxtField.text = ""
                }
                
                if cell.currentIndPath.row == 0 {
                    cell.teamMemberTitleLbl.isHidden = false
                }else{
                    cell.teamMemberTitleLbl.isHidden = true
                }
                
                if noOfVaccinatorsArr[indexPath.row]["serology"] ?? "" == "" {
                    cell.serologySelUnSelectImg.image =  UIImage(named: "uncheckIconPE")
                }else{
                    cell.serologySelUnSelectImg.image =  UIImage(named: "checkIconPE")
                }
                cell.serologyView.isHidden = true

//                let housingStr = sharedManager.getSessionValueForKeyFromDB(key: "housing") as! String
//                if housingStr == "Floor" {
//                    cell.serologyView.isHidden = true
//                }else{
//                    cell.serologyView.isHidden = false
//                }
                return cell
            }
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                cell.setCellAndControllsNew(qArr:otherQuessArr, currentIndd: indexPath as NSIndexPath)
                cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                if cameraState == "true"{
                    cell.cameraIcon.alpha = 1.0
                    cell.cameraBtn.alpha = 1.0
                }else{
                    cell.cameraIcon.alpha = 0.2
                    cell.cameraBtn.alpha = 0.2
                }
                
                if(indexPath.row % 2 == 0) {
                    cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                } else {
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                }
                
                return cell
            }
            else if indexPath.section == 4 {
                
                if isLiveVaccineOn == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    cell.setCellAndControllsNew(qArr:liveQuesArr, currentIndd: indexPath as NSIndexPath)
                    cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                    let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                    if cameraState == "true"{
                        cell.cameraIcon.alpha = 1.0
                        cell.cameraBtn.alpha = 1.0
                    }else{
                        cell.cameraIcon.alpha = 0.2
                        cell.cameraBtn.alpha = 0.2
                    }
                    
                    //cell.saveDelegate = self
                    if(indexPath.row % 2 == 0) {
                        cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                    } else {
                        cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                    }
                    return cell
                    
                }
                else if  isLiveVaccineOn == false {
                    
                    let isSelecteLivedArr = liveQuesArr.value(forKey: "liveComment") as? [String]
                    let liveComment = isSelecteLivedArr![0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "switchVaccineNote", for: indexPath) as! Vaccine_NoteTypeCell
                    cell.currentIndPath = indexPath as NSIndexPath
                    cell.type = "sync"
                    cell.QuesIdArr = liveQuesArr
                    cell.SwitchState = isLiveVaccineOn
                    
                    //  cell.notetxtView.text = Constants.liveComment
                    cell.notetxtView.text = liveComment
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    
                    cell.setCellAndControllsNew(qArr:liveQuesArr, currentIndd: indexPath as NSIndexPath)
                    cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                    let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                    if cameraState == "true"{
                        cell.cameraIcon.alpha = 1.0
                        cell.cameraBtn.alpha = 1.0
                    }else{
                        cell.cameraIcon.alpha = 0.2
                        cell.cameraBtn.alpha = 0.2
                    }
                    
                    if(indexPath.row % 2 == 0) {
                        cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                    } else {
                        cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                    }
                    return cell
                    
                }
                
            }
            
            else if indexPath.section == 5 {
                
                if isInActiveVaccineOn == true
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    
                    cell.setCellAndControllsNew(qArr:inactiveQuessArr, currentIndd: indexPath as NSIndexPath)
                    cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                    let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                    if cameraState == "true"{
                        cell.cameraIcon.alpha = 1.0
                        cell.cameraBtn.alpha = 1.0
                    }else{
                        cell.cameraIcon.alpha = 0.2
                        cell.cameraBtn.alpha = 0.2
                    }
                    
                    if(indexPath.row % 2 == 0) {
                        cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                    } else {
                        cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                    }
                    
                    return cell
                    
                }
                else if isInActiveVaccineOn == false {
                    let isSelecteLivedArr = inactiveQuessArr.value(forKey: "inactiveComment") as? [String]
                    let liveComment = isSelecteLivedArr![0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "switchVaccineNote", for: indexPath) as! Vaccine_NoteTypeCell
                    cell.currentIndPath = indexPath as NSIndexPath
                    cell.QuesIdArr = inactiveQuessArr
                    cell.SwitchState = isInActiveVaccineOn
                    
                    cell.notetxtView.text = liveComment
                    cell.type = "sync"
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    
                    cell.setCellAndControllsNew(qArr:inactiveQuessArr, currentIndd: indexPath as NSIndexPath)
                    cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                    let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                    if cameraState == "true"{
                        cell.cameraIcon.alpha = 1.0
                        cell.cameraBtn.alpha = 1.0
                    }else{
                        cell.cameraIcon.alpha = 0.2
                        cell.cameraBtn.alpha = 0.2
                    }
                    
                    if(indexPath.row % 2 == 0) {
                        cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                    } else {
                        cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                    }
                    return cell
                }
                
            }
            else if indexPath.section == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccineInfoDetailsCell", for: indexPath) as! PVEVaccineInfoDetailsCell
                cell.currentIndPath = indexPath as NSIndexPath
                cell.delegate = self
                cell.showMoreBtn.tag = indexPath.row
                cell.showMoreBtn.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
                
                if vaccinInfoDetailArr.count > indexPath.row{
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("man"){
                        cell.vacManTxtFld.text = vaccinInfoDetailArr[indexPath.row]["man"]  as? String
                    }else{
                        cell.vacManTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("name"){
                        cell.vacNameTxtFld.text = vaccinInfoDetailArr[indexPath.row]["name"] as? String
                    }else{
                        cell.vacNameTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("serotype"){
                        
                        if vaccinInfoDetailArr[indexPath.row]["serotype"] as? String == ""
                        {
                            cell.serotypeTxtFld.text = vaccinInfoDetailArr[indexPath.row]["serotype"]  as? String
                        }
                        else
                        {
                            
                            items.removeAll()
                            itemsIds.removeAll()
                            items = (vaccinInfoDetailArr[indexPath.row]["serotype"] as? [String])!
                            itemsIds = (vaccinInfoDetailArr[indexPath.row]["serotype_id"] as? [String])!
                            
                            selectedAntigenArray.removeAll()
                            
                            for id in 0..<items.count {
                                let item = SelectedData(id:  Int(itemsIds[id] as? String ?? "")!, name: items[id])
                                selectedAntigenArray.append(item)
                            }
                            
                            cell.serotypeTxtFld.text =  items.joined(separator: " , ")
                        }
                        
                    }else{
                        cell.serotypeTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row]["serial"]  as? String == vaccinInfoDetailArr[indexPath.row]["name"]  as? String
                    {
                        cell.serialTxtFld.text = ""
                    }
                    else
                    {
                        if vaccinInfoDetailArr[indexPath.row].keys.contains("serial"){
                            if vaccinInfoDetailArr[indexPath.row]["serial"]  as? String != "Yes" {
                                cell.serialTxtFld.text = vaccinInfoDetailArr[indexPath.row]["serial"]  as? String
                            }
                            
                        }else{
                            cell.serialTxtFld.text = ""
                            
                        }
                        
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("expDate"){
                        cell.expiryTxtFld.text = vaccinInfoDetailArr[indexPath.row]["expDate"]  as? String
                    }else{
                        cell.expiryTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("note"){
                        cell.notetxtView.text = vaccinInfoDetailArr[indexPath.row]["note"] as? String
                    }else{
                        cell.notetxtView.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("siteOfInj"){
                        cell.siteOfInjTxtFld.text = vaccinInfoDetailArr[indexPath.row]["siteOfInj"]  as? String
                    }else{
                        cell.siteOfInjTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("otherAntigen"){
                        cell.otherAntigenTxtFld.text = vaccinInfoDetailArr[indexPath.row]["otherAntigen"] as? String
                    }else{
                        cell.otherAntigenTxtFld.text = ""
                    }
                    
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("showMore"){
                        if vaccinInfoDetailArr[indexPath.row]["showMore"] as! String == "No"
                        {
                            cell.showMoreBtn.setImage(UIImage(named: "up"), for: .normal)
                        }
                        else
                        {
                            cell.showMoreBtn.setImage(UIImage(named: "down"), for: .normal)
                        }
                    }
                    
                }else{
                    cell.vacManTxtFld.text = ""
                    cell.vacNameTxtFld.text = ""
                    cell.serotypeTxtFld.text = ""
                    cell.serialTxtFld.text = ""
                    cell.expiryTxtFld.text = ""
                    cell.siteOfInjTxtFld.text = ""
                    cell.notetxtView.text = ""
                    cell.otherAntigenTxtFld.text = ""
                    
                }
                
                if vaccinInfoDetailArr[indexPath.row]["man"] as? String == ""{
                    self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.vacManBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.vacManBtn)
                }
                
                if vaccinInfoDetailArr[indexPath.row]["name"] as? String == ""{
                    self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.vacNameBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.vacNameBtn)
                }
                
                if vaccinInfoDetailArr[indexPath.row]["serotype"] as? String == ""{
                    self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.serotypeBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.serotypeBtn)
                }
                
                if vaccinInfoDetailArr[indexPath.row]["serial"] as? String == ""{
                    // self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.serialBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.serialBtn)
                }
                
                if vaccinInfoDetailArr[indexPath.row]["expDate"] as? String == ""{
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.expiryBtn)
                }
                
                if (vaccinInfoDetailArr[indexPath.row]["siteOfInj"] as? String) == ""{
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.siteOfInjBtn)
                }
                
                cell.refreshVacNameField()
                
                let otherAntgnStr = vaccinInfoDetailArr[indexPath.row]["serotype"] as? [String]
                let searchString = "Other"
                let result = otherAntgnStr?.contains(where: searchString.contains) as? Bool
                
                if result == true
                {
                    cell.refreshAntigenView(str:"Other")
                } else{
                    cell.refreshAntigenView(str:"nk")
                }
                return cell
            }
            
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                cell.setCellAndControllsNew(qArr:otherQuessArr, currentIndd: indexPath as NSIndexPath)
                cell.tag = Int("\(indexPath.section)" + "\(indexPath.row)")!
                let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
                if cameraState == "true"{
                    cell.cameraIcon.alpha = 1.0
                    cell.cameraBtn.alpha = 1.0
                }else{
                    cell.cameraIcon.alpha = 0.2
                    cell.cameraBtn.alpha = 0.2
                }
                
                if(indexPath.row % 2 == 0) {
                    cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
                } else {
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
                }
                
                return cell
            }
            
            
        }
        else if currentSel_seq_Number == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VaccineEvaluationCell", for: indexPath) as! VaccineEvaluationCell
            cell.delegate = self
            cell.refreshVacEvalFields()
            setMarksLabel()
            
            let isDyeAdded = sharedManager.getSessionValueForKeyFromDB(key: "vacEval_DyeAdded") as! Bool
            if isDyeAdded == true{
                cell.yesBtnImg.image = UIImage(named: "radioActive")
                cell.noBtnImg.image = UIImage(named: "radioInactive")
            }else{
                cell.yesBtnImg.image = UIImage(named: "radioInactive")
                cell.noBtnImg.image = UIImage(named: "radioActive")
            }
            
            cell.notetxtView.textContainer.lineFragmentPadding = 12
            cell.selectionStyle = .none
            
            let commentStr = sharedManager.getSessionValueForKeyFromDB(key: "vacEval_Comment")
            cell.notetxtView.text = commentStr as? String
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
            
            cell.setCellAndControllsNew(qArr:questionsArr, currentIndd: indexPath as NSIndexPath)
            cell.cameraBtn.tag = Int(truncating: currentSel_seq_Number)
            let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as! String
            if cameraState == "true"{
                cell.cameraIcon.alpha = 1.0
                cell.cameraBtn.alpha = 1.0
            }else{
                cell.cameraIcon.alpha = 0.2
                cell.cameraBtn.alpha = 0.2
            }
            
            
            if(indexPath.row % 2 == 0) {
                cell.contentView.backgroundColor =  #colorLiteral(red: 0.9998950362, green: 1, blue: 0.9998714328, alpha: 1)
            } else {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.937254902, blue: 0.9764705882, alpha: 1)
            }
            
            return cell
            
        }
    }
    
    
    func antigenFunc (selectedRow : Int)
    {
        selectedAntigenArray.removeAll()
        
        if vaccinInfoDetailArr[selectedRow]["serotype"] != nil
        {
            
            if let items = vaccinInfoDetailArr[selectedRow]["serotype"] as? [String]
            {
                debugPrint(items)
                let itemsIds = (vaccinInfoDetailArr[selectedRow]["serotype_id"] as? [String])!
                
                for id in 0..<items.count {
                    let item = SelectedData(id:  Int(itemsIds[id] as? String ?? "")!, name: items[id])
                    selectedAntigenArray.append(item)
                }
                debugPrint(selectedAntigenArray)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return .leastNormalMagnitude
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5  || section == 3 || section == 4 || section == 6{
            if section == 1 {
                if noOfCatcherArr.count > 0{
                    return 0
                }else{
                    return 0
                }
            }
            if section == 2 {
                if noOfVaccinatorsArr.count > 0{
                    return 0
                }else{
                    return 0
                }
            }
            if section == 4  {
                return 43.0
            }
            if section == 5
            {
                return 43.0
            }
            if section == 6 {
                
                if vaccinInfoDetailArr.count > 0{
                    return 85.0
                }else{
                    return 73.0
                }
            }
            if section == 3 {
                return 73.0
            }
            
            else{
                return 60.0
            }
        }else if section == 1 || section == 2 {
            return CGFloat.leastNormalMagnitude

        }
        
        else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoOfCatchersHeader" ) as! NoOfCatchersHeader
            headerView.delegate = self
            if noOfCatcherArr.count > 0{
                headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
            }else{
                headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
            }
            
            if headerView.noOfCatchersTxtFeild.text == "0"{
                headerView.noOfCatchersTxtFeild.text = ""
            }else{
            }
            return nil
        }
        if section == 2 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoOfVaccinatorsHeader" ) as! NoOfVaccinatorsHeader
            headerView.delegate = self
            if noOfVaccinatorsArr.count > 0{
                headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
            }else{
                headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
            }
            if headerView.txtFeild.text == "0"{
                headerView.txtFeild.text = ""
            }else{
            }
            return nil
        }
        
        if section == 4 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveVaccineHeader" ) as! liveVaccineHeader
            headerView.vaccineNameLbl.text = "Live Vaccines"
            headerView.vacineSwitch.tag = section
            headerView.vacineSwitch.isOn =  isLiveVaccineOn
            headerView.vacineSwitch.addTarget(self, action: #selector(switchTapped), for:UIControl.Event.valueChanged)
            return headerView
        }
        
        if section == 5 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveVaccineHeader" ) as! liveVaccineHeader
            
            headerView.vaccineNameLbl.text = "Inactivated Vaccines"
            headerView.vacineSwitch.tag = section
            
            headerView.vacineSwitch.isOn = isInActiveVaccineOn
            headerView.vacineSwitch.addTarget(self, action: #selector(switchTapped), for:UIControl.Event.valueChanged)
            return headerView
        }
        if section == 6 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VaccineInformationHeader" ) as! VaccineInformationHeader
            headerView.currntSection = section
            headerView.delegate = self
            if vaccinInfoDetailArr.count > 0{
                headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
            }else{
                headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
            }
            return headerView
        }
        if section == 3 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionCellHeader" ) as! QuestionCellHeader
            return headerView
        }
        else{
            return nil
        }
    }
    
}

extension PVEStartNewAssFinalizeAssement: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assessmentArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath as IndexPath) as! CollectionViewCell
        let categoryArr = assessmentArr.value(forKey: "category_Name") as? NSArray ?? NSArray()
        cell.categoryName.text = categoryArr[indexPath.row] as? String
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectColeectionViewCell(currentSel_CategoryIndex: indexPath.row)
        self.view.endEditing(true)
        
    }
    
    func selectColeectionViewCell(currentSel_CategoryIndex:Int) {
        
        self.currentSel_CategoryIndex = currentSel_CategoryIndex
        
        CoreDataHandlerPVE().updateSessionDetails(1, text: self.currentSel_CategoryIndex, forAttribute: "xSelectedCategoryIndex")
        
        let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        currentSel_seq_Number = seq_NumberArr[self.currentSel_CategoryIndex] as! NSNumber
        
        fetchCurrentArrayForSeqNo(seq_Number: currentSel_seq_Number)
        
        if Int(truncating: currentSel_seq_Number) == 6{
            draftBtn.isHidden = false
            finishBtn.isHidden = false
            draftCenterBtn.isHidden = true
        }else{
            draftBtn.isHidden = true
            finishBtn.isHidden = true
            draftCenterBtn.isHidden = false
        }
        if currentSel_CategoryIndex == 0{
            backBtn.isHidden = false
        }else{
            backBtn.isHidden = true
        }
        
    }
    
    func checkAllCategorySeledtedOneQuestion() -> Bool {
        
        var allCategoryAttampted = Bool()
        let seq_NumberArrr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        for (ind, _) in seq_NumberArrr.enumerated() {
            let seqNo = seq_NumberArrr[ind] as! NSNumber
            if seqNo == 6 {
            }
            else {
                var sumvalue =  CoreDataHandlerPVE().fetchSumOfSelectedMarksModify(seqNo).0
                print("printing sumvalue= ",sumvalue)
                
                if sumvalue == 0 {
                    allCategoryAttampted = true
                }
            }
        }
        
        if allCategoryAttampted == false {
            finishBtn.alpha = 1.0
            finishBtn.isUserInteractionEnabled = true
        }else{
            finishBtn.alpha = 0.5
            finishBtn.isUserInteractionEnabled = false
        }
        
        return allCategoryAttampted
    }
    
    func fetchCurrentArrayForSeqNo(seq_Number:NSNumber){
        
        currentCategoryTotalScore = 0
        questionsArr = CoreDataHandlerPVE().fetchAssessmentQuestion(currentSel_seq_Number) as NSArray
        
        if seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            let isSelecteLivedArr = liveQuesArr.value(forKey: "liveVaccineSwitch") as? [Bool]
            isLiveVaccineOn = isSelecteLivedArr![0]
            print(isLiveVaccineOn)
            
            let isSelecteInactiveArr = inactiveQuessArr.value(forKey: "inactiveVaccineSwitch") as? [Bool]
            isInActiveVaccineOn = isSelecteInactiveArr![0]
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        tblView.reloadData()
    }
    
    
    @IBAction func vaccinaManBtnAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_VaccineManDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        let vaccineNamesIdArr = vaccineManArr.value(forKey: "id") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVEVaccineInfoDetailsCell
                {
                    if currentIndPath! == cell.currentIndPath as IndexPath {
                        cell.vacManTxtFld.text = selectedVal
                        self.sharedManager.setBorderBlue(btn: cell.vacManBtn)
                        
                        let id = vaccineNamesIdArr[index]
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "name", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "vaccine_id", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "man", currentIndPath: currentIndPath! as NSIndexPath, text: selectedVal, id: id, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serial", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "expDate", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "siteOfInj", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "note", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "otherAntigen", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        if id as! Int == 17{
                            cell.vacNameBtn.isUserInteractionEnabled = false
                            cell.vacNameTxtFld.isUserInteractionEnabled = true
                            cell.vacNameDropIcon.isHidden = true
                        }else{
                            cell.vacNameBtn.isUserInteractionEnabled = true
                            cell.vacNameTxtFld.isUserInteractionEnabled = false
                            cell.vacNameDropIcon.isHidden = false
                        }
                        
                        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                    }
                    
                }
                self.tblView.reloadData()
                
            }
            
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func vaccinaNameBtnAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let manId = vaccinInfoDetailArr[currentIndPath!.row]["man_id"]
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_VaccineNamesDetails", id:  manId as! Int, keyStr: "mfg_Id")
        
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        let vaccineNamesIdArr = vaccineManArr.value(forKey: "id") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            // New Update added
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            // code by Raman to clear all fields when vaccine name is changed
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serial", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "expDate", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "siteOfInj", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "note", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "otherAntigen", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVEVaccineInfoDetailsCell
                {
                    if currentIndPath! == cell.currentIndPath as IndexPath {
                        cell.vacNameTxtFld.text = selectedVal
                        cell.serotypeTxtFld.text = ""
                        self.sharedManager.setBorderBlue(btn: cell.vacNameBtn)
                        
                        let id = vaccineNamesIdArr[index]
                        
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "vaccine_id", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "name", currentIndPath: currentIndPath! as NSIndexPath, text: selectedVal, id: id, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "vaccine_id", currentIndPath: currentIndPath! as NSIndexPath, text: id as Any, id: id, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "No", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "No"
                        
                        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                        self.tblView.reloadRows(at: [currentIndPath!], with: .none)
                        print(vaccinInfoDetailArr)
                        
                    }
                    
                }
                
            }
            
            self.dropHiddenAndShow()
        }else{
            showtoast(message: "Please select the manufacturer first.")
        }
        
        
    }
    
    // MARK: Serotype Button Action.
    @IBAction func serotypeBtnAction(_ sender: UIButton) {
        
        antigenNameArr.removeAll()
        antigenIdArr.removeAll()
        
        view.endEditing(true)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        if vaccinInfoDetailArr[currentIndPath!.row]["name"] as? String == ""
        {
            showtoast(message: "Please select the vaccine first.")
            return
        }
        
        let vaccineId = vaccinInfoDetailArr[currentIndPath!.row]["vaccine_id"]
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_SerotypeDetails", id:  vaccineId as! Int, keyStr: "vaccine_Id")
        let vaccineNamesArr = vaccineManArr.value(forKey: "type") as? NSArray ?? NSArray()
        let vaccineNamesIdArr = vaccineManArr.value(forKey: "id") as? NSArray ?? NSArray()
        
        let strdata = (vaccinInfoDetailArr as [[String :Any]])[currentIndPath!.row]
        
        let result: [String: Any] = strdata
        
        simpleSelectedArray = (result["serotype"] as? [String] ?? [])
        
        if  vaccineNamesArr.count > 0 {
            
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: vaccineNamesArr as! [String]) { (cell, name, indexPath) in
                cell.textLabel?.text = name
            }
            
            selectionMenu.cellSelectionStyle = .tickmark
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (sender.bounds.height) * CGFloat(((vaccineNamesArr as! [String]).count)) + 10)), from: self)
            
            selectionMenu.setSelectedItems(items: simpleSelectedArray) { [self] (name, index, selected, selectedItems) in
                
                antigenFunc(selectedRow: currentIndPath!.row)
                
                if let indexOfFirstSuchElement = self.selectedAntigenArray.firstIndex(where: { $0.name == name })
                {
                    self.selectedAntigenArray.remove(at: indexOfFirstSuchElement)
                }
                else{
                    let objData = SelectedData(id: vaccineNamesIdArr.object(at: index) as! Int, name: name ?? "")
                    self.selectedAntigenArray.append(objData)
                    
                }
                
                antigenNameArr = self.selectedAntigenArray.map { $0.name }
                antigenIdArr =  self.selectedAntigenArray.map { String($0.id) }
                
                if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVEVaccineInfoDetailsCell
                {
                    
                    if currentIndPath! == cell.currentIndPath as IndexPath {
                        cell.serotypeTxtFld.text = antigenNameArr.joined(separator: " , ")
                        self.sharedManager.setBorderBlue(btn: cell.serotypeBtn)
                    }
                    let idArrnew =  self.selectedAntigenArray.map { ($0.id) }
                    
                    if idArrnew.contains(37){
                        
                        cell.otherAntigenBtn.isUserInteractionEnabled = true
                        cell.otherAntigenTxtFld.isUserInteractionEnabled = true
                        cell.otherAntigenBtn.backgroundColor = .white
                        cell.otherAntigenTxtFld.placeholder = "Enter"
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "otherAntigen", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: "37", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "Yes", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "Yes"
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: antigenNameArr, id: antigenIdArr, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        // New Fix
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serial", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: "37", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        
                        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                        
                        antigenNameArr.removeAll()
                        antigenIdArr.removeAll()
                        
                    }else{
                        cell.otherAntigenBtn.isUserInteractionEnabled = false
                        cell.otherAntigenTxtFld.isUserInteractionEnabled = false
                        cell.otherAntigenBtn.backgroundColor = .lightGray
                        cell.otherAntigenTxtFld.placeholder = ""
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "otherAntigen", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "No", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: antigenNameArr, id: antigenIdArr, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        
                        
                        vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "No"
                        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                        
                    }
                }
                
            }
            self.tblView.reloadRows(at: [currentIndPath!], with: .none)
            
        }
        
        else{
            
            let vaccineId = 0
            let vaccineManArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_SerotypeDetails", id:  vaccineId as! Int, keyStr: "vaccine_Id")
            let vaccineNamesArr = vaccineManArr.value(forKey: "type") as? NSArray ?? NSArray()
            let vaccineNamesIdArr = vaccineManArr.value(forKey: "id") as? NSArray ?? NSArray()
            
            
            if  vaccineNamesArr.count > 0 {
                
                self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                    
                    if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVEVaccineInfoDetailsCell
                    {
                        if currentIndPath! == cell.currentIndPath as IndexPath {
                            cell.serotypeTxtFld.text = selectedVal
                            self.sharedManager.setBorderBlue(btn: cell.serotypeBtn)
                            
                            let id = vaccineNamesIdArr[index]
                            
                            var nameArray = [String]()
                            nameArray.append("\(selectedVal)")
                            
                            var idArray = [String]()
                            idArray.append("\(id)")
                            
                            antigenNameArr = nameArray
                            antigenIdArr =  idArray
                            
                            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "serotype", currentIndPath: currentIndPath! as NSIndexPath, text: antigenNameArr, id: antigenIdArr, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                            
                            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "otherAntigen", currentIndPath: currentIndPath! as NSIndexPath, text: "", id: id, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                            
                            CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "showMore", currentIndPath: currentIndPath! as NSIndexPath, text: "Yes", id: "", forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                            
                            vaccinInfoDetailArr[currentIndPath!.row]["showMore"] = "Yes"
                            
                            if id as! Int == 37{
                                cell.otherAntigenBtn.isUserInteractionEnabled = true
                                cell.otherAntigenTxtFld.isUserInteractionEnabled = true
                                cell.otherAntigenBtn.backgroundColor = .white
                                cell.otherAntigenTxtFld.placeholder = "Enter"
                            }else{
                                cell.otherAntigenBtn.isUserInteractionEnabled = false
                                cell.otherAntigenTxtFld.isUserInteractionEnabled = false
                                cell.otherAntigenBtn.backgroundColor = .lightGray
                                cell.otherAntigenTxtFld.placeholder = ""
                            }
                            
                            self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                        }
                        
                    }
                    self.tblView.reloadData()
                }
                
                self.dropHiddenAndShow()
            }
        }
        
    }
    
    @IBAction func expiryBtnAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        clickedDateIndpath = indexPath! as NSIndexPath
        
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.isPVEVacExpiry = true
        datePickerPopupViewController.canSelectPreviousDate = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    @IBAction func siteOfInjectBtnAction(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_SiteInjctsDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        let vaccineNamesIdArr = vaccineManArr.value(forKey: "id") as? NSArray ?? NSArray()
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVEVaccineInfoDetailsCell
                {
                    if currentIndPath! == cell.currentIndPath as IndexPath {
                        cell.siteOfInjTxtFld.text = selectedVal
                        self.sharedManager.setBorderBlue(btn: cell.siteOfInjBtn)
                        let id = vaccineNamesIdArr[index]
                        CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "siteOfInj", currentIndPath: currentIndPath! as NSIndexPath, text: selectedVal, id: id, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                        self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
                    }
                    
                }
                
            }
            
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func serologySelectUnSelForFreeCellBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVEVaccineInfoTypeCell
        {
            var isFreeSerology = Bool()
            isFreeSerology = sharedManager.getSessionValueForKeyFromDB(key: "isFreeSerology") as! Bool
            if isFreeSerology == true{
                cell.serologySelUnSelectImg.image =  UIImage(named: "uncheckIconPE")
                CoreDataHandlerPVE().updateSessionDetails(1, text: false, forAttribute: "isFreeSerology")
            }else{
                cell.serologySelUnSelectImg.image =  UIImage(named: "checkIconPE")
                CoreDataHandlerPVE().updateSessionDetails(1, text: true, forAttribute: "isFreeSerology")
            }
            
            let farmStr = sharedManager.getSessionValueForKeyFromDB(key: "farm") as? String
            let houseStr = sharedManager.getSessionValueForKeyFromDB(key: "houseNumber") as? String
            cell.serologyForFreeTxtField.text = "\(farmStr ?? "") - \(houseStr ?? "")"
        }
        
    }
    
    @IBAction func serologyBtnAction(_ sender: UIButton) {
        
        let farmHouseNoArr = sharedManager.getSessionValueForKeyFromDB(key: "farmHouseNoArr") as! [[String : String]]
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        var serologyStrArr = [String]()
        for (_, obj) in farmHouseNoArr.enumerated() {
            let dict = obj as NSDictionary
            serologyStrArr.append("\(dict["farm"] as! String) - \(dict["house"] as! String)")
        }
        
        if  farmHouseNoArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: serologyStrArr, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVEVaccineInfoTypeCell
                {
                    cell.serologyForFreeTxtField.text = selectedVal
                }
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func serologySelectUnSelCellBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        if  let cell = self.tblView.cellForRow(at: currentIndPath!) as? PVETeamMemeberVaccinatorsCell
        {
            
            if currentIndPath! == cell.currentIndPath as IndexPath {
                var seroStr = String()
                if noOfVaccinatorsArr[currentIndPath!.row]["serology"] ?? "" == "" {
                    cell.serologySelUnSelectImg.image =  UIImage(named: "checkIconPE")
                    seroStr = "selected"
                }else{
                    cell.serologySelUnSelectImg.image =  UIImage(named: "uncheckIconPE")
                    seroStr = ""
                }
                
                CoreDataHandlerPVE().updateArrayForSerology("", currentIndPath: currentIndPath! as NSIndexPath, text:
                                                                seroStr, forAttribute: "cat_NoOfVaccinatorsDetailsArr", entityName: "PVE_Session")
                
            }
        }
        
        noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as! [[String : String]]
        
    }
    
    @IBAction func serologyCellBtnAction(_ sender: UIButton) {
        
        let farmHouseNoArr = sharedManager.getSessionValueForKeyFromDB(key: "farmHouseNoArr") as! [[String : String]]
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        var serologyStrArr = [String]()
        for (_, obj) in farmHouseNoArr.enumerated() {
            let dict = obj as NSDictionary
            serologyStrArr.append("\(dict["farm"] as! String) - \(dict["house"] as! String)")
        }
        
        if  farmHouseNoArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: serologyStrArr, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVETeamMemeberVaccinatorsCell
                {
                    cell.serologyTxtFld.text = selectedVal
                }
                
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func crewLeaderBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineNamesArr = ["Crew leader"]
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr , kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVEVaccineInfoTypeCell
                {
                    cell.crewLeaderTxtField.text = selectedVal
                }
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}


extension PVEStartNewAssFinalizeAssement: DatePickerPopupViewControllerProtocol{
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        
        
        if  let cell = self.tblView.cellForRow(at: clickedDateIndpath as IndexPath) as? PVEVaccineInfoDetailsCell
        {
            if clickedDateIndpath as IndexPath == cell.currentIndPath as IndexPath {
                cell.expiryTxtFld.text = string
                self.sharedManager.setBorderBlue(btn: cell.expiryBtn)
                CoreDataHandlerPVE().updateVacInfoArrFor("", currentField: "expDate", currentIndPath: clickedDateIndpath as NSIndexPath, text: string, id: 0, forAttribute: "cat_vaccinInfoDetailArr", entityName: "PVE_Session")
                self.vaccinInfoDetailArr = self.sharedManager.getSessionValueForKeyFromDB(key: "cat_vaccinInfoDetailArr") as! [[String : Any]]
            }
            
        }
        
    }
    
    func doneButtonTapped(string:String){
    }
}


// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension  PVEStartNewAssFinalizeAssement {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Bar")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("text ")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("text end ")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("text Cancel Button")
        
    }
}

struct SelectedData
{
    var id : Int
    var name: String
}




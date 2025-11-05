//
//  PVEViewFinalizeAssement.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 01/04/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class PVEViewFinalizeAssement: BaseViewController {
    
    let sharedManager = PVEShared.sharedInstance
    var currentTimeStamp = ""
    
    @IBOutlet weak var headerView: UIView!
    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var scoreGradientView: UIView!
    @IBOutlet weak var scoreParentView: UIView!
    
    
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
    @IBOutlet weak var syncToWebBtn: UIButton!
    var assessmentArrIs = NSArray()
    var questionsArr = NSArray()
    var sumOfMaxMarks = Int()
    
    var selectedIndex = Int()
    var liveQuesArr = NSArray()
    var inactiveQuessArr = NSArray()
    var otherQuessArr = NSArray()
    var dummyArr = NSArray()
    
    fileprivate   var isLiveVaccineOn = Bool()
    fileprivate var isInActiveVaccineOn = Bool()
    
    var clickedDateIndpath = NSIndexPath()
    
    private var noOfCatcherArr = [[String : String]]()
    private var noOfVaccinatorsArr = [[String : String]]()
    private var vaccinInfoDetailArr = [[String : Any]]()
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "sync", syncId: currentTimeStamp)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        noOfCatcherArr = getDraftValueForKey(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        noOfVaccinatorsArr = getDraftValueForKey(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        vaccinInfoDetailArr = getDraftValueForKey(key: "cat_vaccinInfoDetailArr") as? [[String : Any]] ?? []
        
        setupHeader()
        
        currentCategoryTotalScore = 0
        
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
        noOfCatcherArr = getDraftValueForKey(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        setupUI()
        tblView.reloadData()
        
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Completed Assessment"
        
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func draftBtnAction(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PVEDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func syncBtnAction(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PVEDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                
                let seq_NumberArr = assessmentArrIs.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
                
                var scoreArr = CoreDataHandlerPVE().fetchScoredArrForSyncId(currentTimeStamp, seqNoArr: seq_NumberArr).scoreArr as! [Any]
                scoreArr.removeLast()
                scoreArr.append(sharedManager.vaccineEvaluationScoreTotal)
                
               
                var max_MarksArr = CoreDataHandlerPVE().fetchScoredArrForSyncId(currentTimeStamp, seqNoArr: seq_NumberArr).max_MarksArr as! [Int]
                
                if currentSel_seq_Number == 6 {
                    let seq_NumberArr = assessmentArrIs.value(forKey: "max_Mark")  as? NSArray ?? NSArray()
                    // let marks = seq_NumberArr[Int(truncating: currentSel_seq_Number) - 1] as! Int
                    let marks = seq_NumberArr.lastObject as! Int
                    max_MarksArr.append(marks)
                }
                
                let catArray = assessmentArrIs.value(forKey: "category_Name") as? NSArray ?? NSArray()
                
                CoreDataHandlerPVE().updateDraftToSync(currentTimeStamp, type: "sync", maxScoreArray: max_MarksArr as NSArray, scoreArray: scoreArr as NSArray, categoryArray: catArray)
                
                break
            }
        }
    }
    
 
    
    private func setInitialValues() {
        
        let selectedIndx = getDraftValueForKey(key: "xSelectedCategoryIndex") as! Int
        currentSel_CategoryIndex = selectedIndx
        currentCategoryTotalScore = selectedIndx
        customerLbl.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
        complexLbl.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
        assessmentDateLbl.text = getDraftValueForKey(key: "evaluationDate") as? String
        
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId") as? Int
        assessmentArrIs = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: currentTimeStamp)
        
        let selectedItem = IndexPath(row: Int(truncating: NSNumber(value: currentSel_CategoryIndex)), section: 0)
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .centeredVertically)
        
        let seq_Number = assessmentArrIs.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
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
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId") as? Int
        assessmentArrIs = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: currentTimeStamp)
        
        tblView.reloadData()
        setMarksLabel()
        
    }
    
    func setMarksLabel() {
        
        if currentSel_seq_Number == 6 {
            
            let seq_NumberArr = assessmentArrIs.value(forKey: "max_Mark")  as? NSArray ?? NSArray()
            let marks = seq_NumberArr.lastObject as! Int
            currentCategoryScoreLbl.text = "\(String(format: "%.2f", sharedManager.vaccineEvaluationScoreTotal)) / \(String(describing: marks))"
            
        }
        else{
            currentCategoryScoreLbl.text = CoreDataHandlerPVE().fetchDraftSumOfSelectedMarks(currentSel_seq_Number, type: "sync", syncId: currentTimeStamp)
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
        selectedIndex = indexPath!.section as Int
        
        questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(currentSel_seq_Number, type: "sync", syncId: currentTimeStamp) as NSArray
        var max_ScoreArr: [Int]?
        var idArr: [Int]?
        var commentArr: [String]?
     
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVECommentPopupViewController") as! PVECommentPopupViewController
        vc.delegate = self
        vc.typeStr = "draft"
        vc.timeStampStr = currentTimeStamp
        
        if currentSel_seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            if selectedIndex == 4
            {
                max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
         
                vc.seq_Number =  max_ScoreArr![0]
                
                idArr = liveQuesArr.value(forKey: "id") as? [Int]
                vc.rowId = idArr![indexPath!.row]
                
                commentArr = liveQuesArr.value(forKey: "comment") as? [String]
                vc.commentStr = commentArr![indexPath!.row]
            }
            else if selectedIndex == 5
            {
                max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                vc.seq_Number = max_ScoreArr![0]
                
                idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                vc.rowId = idArr![indexPath!.row]
                
                commentArr = inactiveQuessArr.value(forKey: "comment") as? [String]
                vc.commentStr = commentArr![indexPath!.row]
            }
            else{
                max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                vc.seq_Number = max_ScoreArr![0]
                idArr = otherQuessArr.value(forKey: "id") as? [Int]
                vc.rowId =  idArr![indexPath!.row]
                commentArr = otherQuessArr.value(forKey: "comment") as? [String]
                vc.commentStr = commentArr![indexPath!.row]
            }
        }
        
        else{
            max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
            vc.seq_Number = max_ScoreArr![0]
            idArr = questionsArr.value(forKey: "id") as? [Int]
            vc.rowId = idArr![indexPath!.row]
            
            commentArr = questionsArr.value(forKey: "comment") as? [String]
            vc.commentStr = commentArr![indexPath!.row]
        }
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
}

extension PVEViewFinalizeAssement:  UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //PVE_SyncImageEntity
    @IBAction func cameraBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        selectedIndex = indexPath!.section as Int
        
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
        
        if let pickedImage: UIImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]) as? UIImage {
            let imageData: Data? = pickedImage.jpegData(compressionQuality: 0.5)
            
            questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(currentSel_seq_Number, type: "sync", syncId: currentTimeStamp) as NSArray
            var max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
            var seq_Number = max_ScoreArr![imagePicker.view.tag]
            var idArr = questionsArr.value(forKey: "id") as? [Int]
            var id = idArr![imagePicker.view.tag]
            
            
            if currentSel_seq_Number == 2
            {
                liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
                inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
                otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
                
                if selectedIndex == 4
                {
                    max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
                    seq_Number = max_ScoreArr![imagePicker.view.tag]
                    idArr = liveQuesArr.value(forKey: "id") as? [Int]
                    id = idArr![imagePicker.view.tag]
                }
                else  if selectedIndex == 5
                {
                    max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                    seq_Number = max_ScoreArr![imagePicker.view.tag]
                    idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                    id = idArr![imagePicker.view.tag]
                }
                else
                {
                    max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                    seq_Number = max_ScoreArr![imagePicker.view.tag]
                    idArr = otherQuessArr.value(forKey: "id") as? [Int]
                    id = idArr![imagePicker.view.tag]
                }
            }
            else
            {
                max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![imagePicker.view.tag]
                idArr = questionsArr.value(forKey: "id") as? [Int]
                id = idArr![imagePicker.view.tag]
            }
            
            CoreDataHandlerPVE().updateImageDataInAssementDetails(seq_Number, rowId: id, imageData: imageData!)
            imagePicker.dismiss(animated: true)
        }
        /******************************************************************************************************/
        func imagePickerControllerDidCancel(_ _: UIImagePickerController) {
            
            //   print("User canceled image")
            dismiss(animated: true)
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
        
        questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(currentSel_seq_Number, type: "sync", syncId: currentTimeStamp) as NSArray
        
        var max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
        var seq_Number = max_ScoreArr![0]
        
        var idArr = questionsArr.value(forKey: "id") as? [Int]
        var id = idArr![currentSelectedBtnIndex]
        
        var tempArr = NSArray()
        
        if currentSel_seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            if selectedIndex == 4
            {
                
                max_ScoreArr = liveQuesArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![imagePicker.view.tag]
                idArr = liveQuesArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
            else if selectedIndex == 5
            {
                max_ScoreArr = inactiveQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![imagePicker.view.tag]
                idArr = inactiveQuessArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
            else
            {
                max_ScoreArr = otherQuessArr.value(forKey: "seq_Number") as? [Int]
                seq_Number = max_ScoreArr![imagePicker.view.tag]
                idArr = otherQuessArr.value(forKey: "id") as? [Int]
                id = idArr![currentSelectedBtnIndex]
            }
        }
        else
        {
            max_ScoreArr = questionsArr.value(forKey: "seq_Number") as? [Int]
            seq_Number = max_ScoreArr![imagePicker.view.tag]
            
            idArr = questionsArr.value(forKey: "id") as? [Int]
            id = idArr![currentSelectedBtnIndex]          }
        
        if currentTimeStamp.count > 0{
            tempArr = CoreDataHandlerPVE().getImageDataForCurrentAssementDetails(currentTimeStamp, seqNumber: NSNumber(value: seq_Number), rowId: id, entity: "PVE_ImageEntitySync")
        }else{
            tempArr = CoreDataHandlerPVE().getImageDataForCurrentAssementDetails(currentTimeStamp, seqNumber: NSNumber(value: seq_Number), rowId: id, entity: "PVE_ImageEntity")
        }
        
        let imgDaraArr = tempArr.value(forKey: "imageData") as? [Data]
        
        return imgDaraArr!
        
    }
}

extension PVEViewFinalizeAssement{
    
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

extension PVEViewFinalizeAssement: VacEvalDelegate,RefreshCommentIconBtnDelegate {
    func RefreshCommentBtnIcon() {
        let selectedIndx = getDraftValueForKey(key: "xSelectedCategoryIndex") as! Int
        
        selectColeectionViewCell(currentSel_CategoryIndex: Int(truncating: NSNumber(value: selectedIndx)))
        
        tblView.reloadData()
    }
    
    func reloadVacEvalContent() {
        tblView.reloadData()
    }
}

extension PVEViewFinalizeAssement: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSel_seq_Number == 2 {  //Vaccine Prepraion Section
            return 7
        }else{
            return 1
        }
    }
    
    @IBAction func vaccinatorsPlusBtnAction(_ sender: Any) {
        print(appDelegateObj.testFuntion())
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard currentSel_seq_Number == 2 else {
            return currentSel_seq_Number == 6 ? 1 : questionsArr.count
        }

        switch section {
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return otherQuessArr.count
        case 4:
            return isLiveVaccineOn ? liveQuesArr.count : 1
        case 5:
            return isInActiveVaccineOn ? inactiveQuessArr.count : 1
        case 6:
            return vaccinInfoDetailArr.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentSel_seq_Number {
        case 2:  // Vaccine Preparation Section
            switch indexPath.section {
            case 0: return 200.0
            case 1, 2: return 60.0  // Vaccine Info Detail Cell
            case 4, 5: return 80.0  // Crew Safety Cell
            case 6:
                let showMore = (vaccinInfoDetailArr[indexPath.row]["showMore"] as? String) ?? Constants.noStr
                return showMore == Constants.noStr ? 93.0 : 300.0
            default: return 80.0
            }
        case 6:
            return 1350.0
        default:
            return 80.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentSel_seq_Number == 2 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccineInfoTypeCell", for: indexPath) as! PVEVaccineInfoTypeCell
                cell.timeStampStr = currentTimeStamp
                cell.isUserInteractionEnabled = false
                
                cell.refreshFreeSerologyBtnState()
                cell.refreshRadioButton()
                cell.serologyViewForFreeHousing.isHidden = true

//                let housingStr = getDraftValueForKey(key: "housing") as! String
//                if housingStr == "Floor" {
//                    cell.serologyViewForFreeHousing.isHidden = false
//                }else{
//                    cell.serologyViewForFreeHousing.isHidden = true
//                }
                
                cell.crewLeaderTxtField.text = getDraftValueForKey(key: "cat_crewLeaderName") as? String
                cell.crewLeaderEmailTxtField.text = getDraftValueForKey(key: "cat_crewLeaderEmail") as? String
                let countOfCatcher = getDraftValueForKey(key: "cat_NoOfCatchersDetailsArr") as? String
                cell.numberOfCatcherTextField.text = countOfCatcher
                let noOfVaccinatorsArr = getDraftValueForKey(key: "cat_NoOfVaccinatorsDetailsArr") as? String
                cell.numberOfVacconatorsTextField.text = noOfVaccinatorsArr
                
                cell.companyRepNameTxtField.text = getDraftValueForKey(key: "cat_companyRepName") as? String
                cell.companyRepEmailTxtField.text = getDraftValueForKey(key: "cat_companyRepEmail") as? String
                
                return cell
            }
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVETeamMemberCatchersCell", for: indexPath) as! PVETeamMemberCatchersCell
                cell.currentIndPath = indexPath as NSIndexPath
                cell.isUserInteractionEnabled = false
                
                if noOfCatcherArr.count > indexPath.row{
                    
                    if noOfCatcherArr[indexPath.row].keys.contains("name"){
                        cell.nameTxtField.text = noOfCatcherArr[indexPath.row]["name"] ?? ""
                    }else{
                        cell.nameTxtField.text = ""
                    }
                    if noOfCatcherArr[indexPath.row].keys.contains("email"){
                        cell.emailTxtField.text = noOfCatcherArr[indexPath.row]["email"] ?? ""
                    }else{
                        cell.emailTxtField.text = ""
                    }
                    if noOfCatcherArr[indexPath.row].keys.contains("mobile"){
                        cell.mobileTxtField.text = noOfCatcherArr[indexPath.row]["mobile"] ?? ""
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
                if cell.currentIndPath.row == 0 {
                    cell.teamMemberTitleLbl.isHidden = false
                }else{
                    cell.teamMemberTitleLbl.isHidden = true
                }
                
                return cell
            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVETeamMemeberVaccinatorsCell", for: indexPath) as! PVETeamMemeberVaccinatorsCell
                cell.currentIndPath = indexPath as NSIndexPath
                // cell.delegate = self
                cell.isUserInteractionEnabled = false
                
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
                }  else{
                    cell.nameTxtField.text = ""
                    cell.mobileTxtField.text = ""
                    cell.emailTxtField.text = ""
                }
                
                
                if cell.currentIndPath.row == 0 {
                    cell.teamMemberTitleLbl.isHidden = false
                }else{
                    cell.teamMemberTitleLbl.isHidden = true
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
                
                
//                let housingStr = getDraftValueForKey(key: "housing") as! String
//                if housingStr == "Floor" {
//                    cell.serologyView.isHidden = true
//                }else{
//                    cell.serologyView.isHidden = false
//                }
                
                
                return cell
            }
            
            
            else if indexPath.section == 4 {
                if isLiveVaccineOn == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    cell.typeStr = "sync"
                    cell.timeStampStr = currentTimeStamp
                    cell.setCellAndControllsNew(qArr:liveQuesArr, currentIndd: indexPath as NSIndexPath)
                    let cameraState = getDraftValueForKey(key: "cameraEnabled") as! String
                    
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
                else if  isLiveVaccineOn == false{
                    
                    let isSelecteLivedArr = liveQuesArr.value(forKey: "liveComment") as? [String]
                    let liveComment: String!
                    liveComment = isSelecteLivedArr![0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "switchVaccineNote", for: indexPath) as! Vaccine_NoteTypeCell
                    cell.currentIndPath = indexPath as NSIndexPath
                    cell.type = "sync"
                    cell.notetxtView.text = liveComment
                    return cell
                }
                else
                {
                    let isSelecteLivedArr = liveQuesArr.value(forKey: "liveComment") as? [String]
                    let liveComment = isSelecteLivedArr![0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "switchVaccineNote", for: indexPath) as! Vaccine_NoteTypeCell
                    cell.currentIndPath = indexPath as NSIndexPath
                    cell.notetxtView.text =  "\(liveComment)"
                    cell.type = "sync"
                    return cell
                    
                }
            }
            
            else if indexPath.section == 5 {
                
                if isInActiveVaccineOn == true
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
                    cell.typeStr = "sync"
                    cell.timeStampStr = currentTimeStamp
                    cell.setCellAndControllsNew(qArr:inactiveQuessArr, currentIndd: indexPath as NSIndexPath)
                    let cameraState = getDraftValueForKey(key: "cameraEnabled") as! String
                    
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
                    cell.notetxtView.text =  "\(liveComment)"
                    cell.type = "sync"
                    return cell
                }
                else
                {
                    let isSelecteLivedArr = inactiveQuessArr.value(forKey: "inactiveComment") as? [String]
                    let liveComment = isSelecteLivedArr![0]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "switchVaccineNote", for: indexPath) as! Vaccine_NoteTypeCell
                    cell.currentIndPath = indexPath as NSIndexPath
                    cell.type = "sync"
                    cell.notetxtView.text =  "\(liveComment)"
                    return cell
                }
            }
            else if indexPath.section == 6 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccineInfoDetailsCell", for: indexPath) as! PVEVaccineInfoDetailsCell
                cell.currentIndPath = indexPath as NSIndexPath
                
                if vaccinInfoDetailArr.count > indexPath.row{
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("man"){
                        
                        cell.vacManTxtFld.text = vaccinInfoDetailArr[indexPath.row]["man"]  as? String
                    }else{
                        cell.vacManTxtFld.isEnabled = false
                        cell.vacManTxtFld.text = ""
                    }
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("name"){
                        cell.vacNameTxtFld.text = vaccinInfoDetailArr[indexPath.row]["name"] as? String
                    }else{
                        cell.vacNameTxtFld.text = ""
                    }
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("serotype"){
                        let antigenName =  (vaccinInfoDetailArr[indexPath.row]["serotype"] as? [String])!.joined(separator: ",")
                        cell.serotypeTxtFld.text = antigenName
                    }
                    else{
                        cell.serotypeTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("serial"){
                        cell.serialTxtFld.isEnabled = false
                        if vaccinInfoDetailArr[indexPath.row]["serial"]  as? String != "Yes" {
                            cell.serialTxtFld.text = vaccinInfoDetailArr[indexPath.row]["serial"]  as? String
                        }
                        
                    }else{
                        cell.serialTxtFld.isEnabled = false
                        cell.serialTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("expDate"){
                        cell.expiryTxtFld.text = vaccinInfoDetailArr[indexPath.row]["expDate"]  as? String
                    }else{
                        cell.expiryTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("note"){
                        cell.notetxtView.text = vaccinInfoDetailArr[indexPath.row]["note"] as? String
                        cell.notetxtView.isEditable = false
                        
                        cell.notetxtView.isScrollEnabled = true
                    }else{
                        cell.notetxtView.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("siteOfInj"){
                        cell.siteOfInjTxtFld.text = vaccinInfoDetailArr[indexPath.row]["siteOfInj"]  as? String
                    }else{
                        cell.siteOfInjTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("otherAntigen"){
                        cell.otherAntigenTxtFld.isEnabled = false
                        cell.otherAntigenTxtFld.text = vaccinInfoDetailArr[indexPath.row]["otherAntigen"] as? String
                    }else{
                        cell.otherAntigenTxtFld.isEnabled = false
                        cell.otherAntigenTxtFld.text = ""
                    }
                    
                    if vaccinInfoDetailArr[indexPath.row].keys.contains("showMore"){
                        if vaccinInfoDetailArr[indexPath.row]["showMore"] as! String == Constants.noStr
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
                  //  self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.serialBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.serialBtn)
                }
                
                if vaccinInfoDetailArr[indexPath.row]["expDate"] as? String == ""{
                  //  self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.expiryBtn)
                }else{
                    self.sharedManager.setBorderBlue(btn: cell.expiryBtn)
                }
                
                if (vaccinInfoDetailArr[indexPath.row]["siteOfInj"] as? String) == ""{
                  //  self.sharedManager.setBorderRedForMandatoryFiels(forBtn: cell.siteOfInjBtn)
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
                cell.typeStr = "sync"
                cell.timeStampStr = currentTimeStamp
                cell.setCellAndControllsNew(qArr:otherQuessArr, currentIndd: indexPath as NSIndexPath)
                let cameraState = getDraftValueForKey(key: "cameraEnabled") as! String
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
            cell.typeStr = "sync"
            cell.timeStampStr = currentTimeStamp
            cell.isUserInteractionEnabled = false
            cell.delegate = self
            cell.refreshVacEvalFields()
            setMarksLabel()
            
            
            let isDyeAdded = getDraftValueForKey(key: "vacEval_DyeAdded") as? Bool ?? false
            if isDyeAdded == true{
                cell.yesBtnImg.image = UIImage(named: "radioActive")
                cell.noBtnImg.image = UIImage(named: "radioInactive")
            }else{
                cell.yesBtnImg.image = UIImage(named: "radioInactive")
                cell.noBtnImg.image = UIImage(named: "radioActive")
            }
            
            cell.notetxtView.textContainer.lineFragmentPadding = 12
            cell.selectionStyle = .none
            
            let commentStr = getDraftValueForKey(key: "vacEval_Comment")
            cell.notetxtView.text = commentStr as? String
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PVEVaccinationCrewSafetyCell", for: indexPath) as! PVEVaccinationCrewSafetyCell
            cell.typeStr = "sync"
            cell.timeStampStr = currentTimeStamp
            
            cell.setCellAndControllsNew(qArr:questionsArr, currentIndd: indexPath as NSIndexPath)
            let cameraState = getDraftValueForKey(key: "cameraEnabled") as! String
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
               return .leastNormalMagnitude
           }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return CGFloat.leastNormalMagnitude//noOfCatcherArr.isEmpty ? 73.0 : 85.0
        case 2:
            return CGFloat.leastNormalMagnitude//noOfVaccinatorsArr.isEmpty ? 0  : 0//73.0 : 85.0
        case 3:
            return 73.0
        case 4, 5:
            return 43.0
        case 6:
            return vaccinInfoDetailArr.isEmpty ? 73.0 : 85.0
        case 0:
            return 0.0
        default:
            return 60.0
        }
    }
    
    fileprivate func handleSection1(_ tableView: UITableView) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoOfCatchersHeader" ) as! NoOfCatchersHeader
        headerView.isUserInteractionEnabled = false
        if noOfCatcherArr.count  > 0{
            headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
        }else{
            headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
        }
        
        headerView.noOfCatchersTxtFeild.text = "\(noOfCatcherArr.count)"
        headerView.numberr = noOfCatcherArr.count
        if headerView.noOfCatchersTxtFeild.text == "0"{
            headerView.noOfCatchersTxtFeild.text = ""
        }
        //return headerView
        return nil
    }
    
    fileprivate func handleSection2(_ tableView: UITableView) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NoOfVaccinatorsHeader" ) as! NoOfVaccinatorsHeader
        headerView.isUserInteractionEnabled = false
        if noOfVaccinatorsArr.count > 0{
            headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
        }else{
            headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
        }
        headerView.txtFeild.text = "\(noOfVaccinatorsArr.count)"
        headerView.numberr = noOfVaccinatorsArr.count
        if headerView.txtFeild.text == "0"{
            headerView.txtFeild.text = ""
        }
        //return headerView
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            return handleSection1(tableView)
        }
        if section == 2 {
            return handleSection2(tableView)
        }
        
        if section == 4 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveVaccineHeader" ) as! liveVaccineHeader
            
            headerView.vaccineNameLbl.text = "Live Vaccines"
            headerView.vacineSwitch.tag = section
            headerView.vacineSwitch.isOn = isLiveVaccineOn
            headerView.vacineSwitch.isUserInteractionEnabled = false
            return headerView
        }
        
        if section == 5 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "liveVaccineHeader" ) as! liveVaccineHeader
            
            headerView.vaccineNameLbl.text = "Inactivated Vaccines"
            headerView.vacineSwitch.tag = section
            headerView.vacineSwitch.isOn = isInActiveVaccineOn
            headerView.vacineSwitch.isUserInteractionEnabled = false
            return headerView
        }
        if section == 6 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VaccineInformationHeader" ) as! VaccineInformationHeader
            headerView.currntSection = section
            headerView.isUserInteractionEnabled = false
            if vaccinInfoDetailArr.count > 0{
                headerView.headerImg.image = UIImage(named: "footerNavigationExpand")
            }else{
                headerView.headerImg.image = UIImage(named: "footerNavigationRounded")
            }
            
            return headerView
        }
        if section == 3 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionCellHeader" ) as! QuestionCellHeader
            headerView.isUserInteractionEnabled = false
            return headerView
        } else {
            return UIView()
        }
    }
}

extension PVEViewFinalizeAssement: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assessmentArrIs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath as IndexPath) as! CollectionViewCell
        let categoryArr = assessmentArrIs.value(forKey: "category_Name") as? NSArray ?? NSArray()
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
        if currentSel_CategoryIndex == 0{
            backBtn.isHidden = false
        }else{
            backBtn.isHidden = true
        }
    }
    
    
    func selectColeectionViewCell(currentSel_CategoryIndex:Int) {
        
        self.currentSel_CategoryIndex = currentSel_CategoryIndex
        CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: true, text: self.currentSel_CategoryIndex, forAttribute: "xSelectedCategoryIndex")
        let seq_NumberArr = assessmentArrIs.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        currentSel_seq_Number = seq_NumberArr[self.currentSel_CategoryIndex] as! NSNumber
        fetchCurrentArrayForSeqNo(seq_Number: currentSel_seq_Number)
    }
    
    func checkAllCategorySeledtedOneQuestion() -> Bool {
        
        var allCategoryAttampted = Bool()
        let seq_NumberArrr = assessmentArrIs.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        for (ind, _) in seq_NumberArrr.enumerated() {
            let seqNo = seq_NumberArrr[ind] as! NSNumber
            if seqNo == 6 {
                print("SeqNo is 6, perform no action.")
            }else{
                let marksTxt = CoreDataHandlerPVE().fetchDraftSumOfSelectedMarks(seqNo, type: "sync", syncId: currentTimeStamp)
                //let marksTxt = CoreDataHandlerPVE().fetchSumOfSelectedMarks(seqNo)
                let marks = marksTxt.components(separatedBy: "/")
                if marks[0] == "0" {
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
        
        questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(seq_Number, type: "sync", syncId: currentTimeStamp) as NSArray
        
        
        if seq_Number == 2
        {
            liveQuesArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Live")}) as NSArray
            inactiveQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).contains("Inactivated")}) as NSArray
            otherQuessArr = questionsArr.filter({(($0 as! NSObject).value(forKey: "pVE_Vacc_Type") as! String).isEmpty}) as NSArray
            
            let isSelecteLivedArr = liveQuesArr.value(forKey: "liveVaccineSwitch") as? [Bool]
            isLiveVaccineOn = isSelecteLivedArr![0]
            
            
            let isSelecteInactiveArr = inactiveQuessArr.value(forKey: "inactiveVaccineSwitch") as? [Bool]
            isInActiveVaccineOn = isSelecteInactiveArr![0]
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("reloadSNATblViewNoti"), object: nil, userInfo: nil)
        tblView.reloadData()
        
        
    }
    
    
    @IBAction func vaccinaManBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_VaccineManDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                var tempArr = [[String : String]]()
                
                for (indx, _) in self.vaccinInfoDetailArr.enumerated() {
                    let indexPath = IndexPath(row: indx, section: 3)
                    if  let cell = self.tblView.cellForRow(at: indexPath ) as? PVEVaccineInfoDetailsCell
                    {
                        if currentIndPath! == cell.currentIndPath as IndexPath {
                            cell.vacManTxtFld.text = selectedVal
                        }
                        
                        tempArr.append(["man" : cell.vacManTxtFld.text!, "name" :cell.vacNameTxtFld.text!, "serotype" : cell.serotypeTxtFld.text!, "serial" :cell.serialTxtFld.text!, "expDate" : cell.expiryTxtFld.text!, "siteOfInj" : cell.siteOfInjTxtFld.text!])
                    }
                }
                
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func vaccinaNameBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_VaccineNamesDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                var tempArr = [[String : String]]()
                
                for (indx, _) in self.vaccinInfoDetailArr.enumerated() {
                    let indexPath = IndexPath(row: indx, section: 3)
                    if  let cell = self.tblView.cellForRow(at: indexPath ) as? PVEVaccineInfoDetailsCell
                    {
                        if currentIndPath! == cell.currentIndPath as IndexPath {
                            cell.vacNameTxtFld.text = selectedVal
                        }
                        
                        tempArr.append(["man" : cell.vacManTxtFld.text!, "name" :cell.vacNameTxtFld.text!, "serotype" : cell.serotypeTxtFld.text!, "serial" :cell.serialTxtFld.text!, "expDate" : cell.expiryTxtFld.text!, "siteOfInj" : cell.siteOfInjTxtFld.text!])
                    }
                }
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func serotypeBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_SerotypeDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "Type") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                var tempArr = [[String : String]]()
                
                for (indx, _) in self.vaccinInfoDetailArr.enumerated() {
                    let indexPath = IndexPath(row: indx, section: 3)
                    if  let cell = self.tblView.cellForRow(at: indexPath ) as? PVEVaccineInfoDetailsCell
                    {
                        if currentIndPath! == cell.currentIndPath as IndexPath {
                            cell.serotypeTxtFld.text = selectedVal
                        }
                        
                        tempArr.append(["man" : cell.vacManTxtFld.text!, "name" :cell.vacNameTxtFld.text!, "serotype" : cell.serotypeTxtFld.text!, "serial" :cell.serialTxtFld.text!, "expDate" : cell.expiryTxtFld.text!, "siteOfInj" : cell.siteOfInjTxtFld.text!])
                    }
                }
            }
            self.dropHiddenAndShow()
        }
        
    }
    
    @IBAction func expiryBtnAction(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        clickedDateIndpath = indexPath! as NSIndexPath
        
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    @IBAction func siteOfInjectBtnAction(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let currentIndPath = self.tblView.indexPathForRow(at:buttonPosition)
        
        let vaccineManArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_SiteInjctsDetails")
        let vaccineNamesArr = vaccineManArr.value(forKey: "name") as? NSArray ?? NSArray()
        
        if  vaccineNamesArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: vaccineNamesArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                var tempArr = [[String : String]]()
                
                for (indx, _) in self.vaccinInfoDetailArr.enumerated() {
                    let indexPath = IndexPath(row: indx, section: 3)
                    if  let cell = self.tblView.cellForRow(at: indexPath ) as? PVEVaccineInfoDetailsCell
                    {
                        if currentIndPath! == cell.currentIndPath as IndexPath {
                            cell.siteOfInjTxtFld.text = selectedVal
                        }
                        
                        tempArr.append(["man" : cell.vacManTxtFld.text!, "name" :cell.vacNameTxtFld.text!, "serotype" : cell.serotypeTxtFld.text!, "serial" :cell.serialTxtFld.text!, "expDate" : cell.expiryTxtFld.text!, "siteOfInj" : cell.siteOfInjTxtFld.text!])
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
            if sender.isSelected {
                sender.isSelected = false
                cell.serologySelUnSelectImg.image =  UIImage(named: "uncheckIconPE")
            }else{
                cell.serologySelUnSelectImg.image =  UIImage(named: "checkIconPE")
                sender.isSelected = true
            }
            
            let farmStr = getDraftValueForKey(key: "farm") as? String
            let houseStr = getDraftValueForKey(key: "houseNumber") as? String
            cell.serologyForFreeTxtField.text = "\(farmStr ?? "") - \(houseStr ?? "")"
        }
        
    }
    
    @IBAction func serologyBtnAction(_ sender: UIButton) {
        
        let farmHouseNoArr = getDraftValueForKey(key: "farmHouseNoArr") as! [[String : String]]
        
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
        let indexPath = self.tblView.indexPathForRow(at:buttonPosition)
        if  let cell = self.tblView.cellForRow(at: indexPath!) as? PVETeamMemeberVaccinatorsCell
        {
            if sender.isSelected {
                sender.isSelected = false
                cell.serologySelUnSelectImg.image =  UIImage(named: "uncheckIconPE")
            }else{
                cell.serologySelUnSelectImg.image =  UIImage(named: "checkIconPE")
                sender.isSelected = true
            }
        }
    }
    
    @IBAction func serologyCellBtnAction(_ sender: UIButton) {
        
        let farmHouseNoArr = getDraftValueForKey(key: "farmHouseNoArr") as! [[String : String]]
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
    
    @IBAction func synToWebBtnAction(_ sender: UIButton) {
        let errorMSg = "Are you sure, you want to sync this session data to web?"
        let alertController = UIAlertController(title: "PVE", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.singleDataSync()
        }
        let cancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func singleDataSync(){
        
        if ConnectionManager.shared.hasConnectivity() {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: PVEDashboardViewController.self) {
                    Constants.syncToWebTapped = true
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "forceSync"),object: nil, userInfo:["id": currentTimeStamp]))
                    self.navigationController!.popToViewController(controller, animated: true)
                }
            }
        }
        else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
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

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


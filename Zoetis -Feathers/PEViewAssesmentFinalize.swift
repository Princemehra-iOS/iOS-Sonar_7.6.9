//
//  PEAssesmentFinalize.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 13/12/19.
//  Copyright © 2019  . All rights reserved.
//

import UIKit
import SwiftyJSON


class PEViewAssesmentFinalize: BaseViewController , DatePickerPopupViewControllerProtocol {
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var switchA = 0
    var switchB = 0
    var deviceIDFORSERVER = ""
    var saveTypeString : [Int] = []
    var totalImageToSync : [Int] = []
    var callRequest4Int = 0
    var isFromEditMicro : Bool = false
    var peHeaderViewController:PEHeaderViewController!
    var peNewAssessment:PENewAssessment!
    var dropdownManager = ZoetisDropdownShared.sharedInstance
    var delegate: PECategorySelectionDelegate? = nil
    var currentArr : [AssessmentQuestions] = []
    var selectedCategory : PENewAssessment?
    var collectionviewIndexPath = IndexPath(row: 0, section: 0)
    var jsonRe : JSON = JSON()
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var tableviewIndexPath = IndexPath(row: 0, section: 0)
    var catArrayForCollectionIs : [PENewAssessment] = []
    var catArrayForTableIs = NSArray()
    var certificateData : [PECertificateData] = []
    var inovojectData : [InovojectData] = []
    var dayOfAgeData : [InovojectData] = []
    var dayOfAgeSData : [InovojectData] = []
    var showExtendedPE:Bool = false
    var fsrSign = ""
    var sanitationQuesArr = [PE_ExtendedPEQuestion]()
    var refriCamerAssesment =  [PE_AssessmentInProgress]()
    var refrigtorProbeArray  : [PE_Refrigators] = []
    var refrigator_Selected_NA_QuestionArray = [Int:Int]()
    var selctedNACategoryArray = [Int]()
    var regionID = Int()
    var submitExtend : Bool = false
    var categoarylabelText : String = ""
    var textValue  : Int?
    var tempArr : [JSONDictionary]  = []
    
    @IBOutlet weak var constraintConstantHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonFinishAssessment: PESubmitButton!
    @IBOutlet weak var buttonSaveAsDraft: PESubmitButton!
    @IBOutlet weak var constraintTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForMultiSignature: UIView!
    @IBOutlet weak var buttonSaveAsDraftInitial: PESubmitButton!
    @IBOutlet weak var synWebBtn: PESubmitButton!
    @IBOutlet weak var assessmentDateText: PEFormTextfield!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sig_Name: UILabel!
    @IBOutlet weak var lblNA: UILabel!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var viewForSignature: UIView!
    @IBOutlet weak var sig_EmployeeID: UITextField!
    @IBOutlet weak var scoreParentView: UIView!
    @IBOutlet weak var sig_Date: UITextField!
    @IBOutlet weak var sig_Phone: UITextView!
    @IBOutlet weak var lblRepresentative2: UILabel!
    @IBOutlet weak var imgSignature2: UIImageView!
    @IBOutlet weak var lblTitle2: UITextField!
    @IBOutlet weak var sig_imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var extendedMicroSwitch: UISwitch!
    @IBOutlet weak var lblextenderMicro: UILabel!
    @IBOutlet weak var collectionViewSignature: UICollectionView!
    @IBOutlet weak var tableViewSignature: UITableView!
    @IBOutlet weak var resultScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet fileprivate weak var tableview: UITableView!
    @IBOutlet weak var selectedCustomer: PEFormLabel!
    @IBOutlet weak var selectedComplex: PEFormLabel!
    @IBOutlet weak var scoreGradientView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var bckButton: PESubmitButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    // MARK:  Back Button Action
    @IBAction func backButton(_ sender: Any) {
        if isFromEditMicro {
            isFromEditMicro = false
            self.navigationController?.popViewController(animated: true)
        }else {
            cleanSessionAndMoveTOStart()
            
        }
    }
    
    private func cleanSessionAndMoveTOStart(){
        if(regionID == 3){
            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PEViewStartNewAssessment") as? PEViewStartNewAssessment
            vc?.peNewAssessment = self.peNewAssessment
            if vc != nil {
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PEViewStartNewAssesmentINT") as? PEViewStartNewAssesmentINT
            vc?.peNewAssessment = self.peNewAssessment
            if vc != nil {
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
    }
    // MARK: Extended Micro Switch
    @IBAction func extendedMicroSwitch(_ sender: UISwitch) {
        if extendedMicroSwitch.isOn
        {
            self.submitExtend = true
            UserDefaults.standard.set(true, forKey:"ExtendedMicro")
            UserDefaults.standard.setValue(true, forKey: "extendedAvailable")
            self.synWebBtn.isEnabled = true
            self.synWebBtn.alpha = 1.0
        }
        else
        {
            self.submitExtend = false
            UserDefaults.standard.setValue(false, forKey: "extendedAvailable")
            UserDefaults.standard.set(false, forKey:"ExtendedMicro")
            self.synWebBtn.isEnabled = false
            self.synWebBtn.alpha = 0.3
            
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        self.navigationController?.navigationBar.isHidden = true
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        viewForSignature.isHidden = true
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "View Assessment"
        peHeaderViewController.assId = "C-\(peNewAssessment.dataToSubmitID!)"
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
        
        viewForMultiSignature.isHidden = true
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        
        
        let  peNewAssessmentArray1 = CoreDataHandlerPE().getOfflineAssessmentArray(id:peNewAssessment.dataToSubmitID ?? "")
        sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
        
        showExtendedPE = peNewAssessment.sanitationValue ?? false
        
        let seq_Number : NSArray = NSArray()
        for obj in peNewAssessmentArray1 {
            seq_Number.adding(obj.sequenceNo)
        }
       
        var carColIdArray : [Int] = []
  
        var row = 0
        
        for cat in peNewAssessmentArray1 {
            if !carColIdArray.contains(cat.sequenceNo ?? 0){
                carColIdArray.append(cat.sequenceNo ?? 0)
                if(cat.catName == "Refrigerator"){
                    cat.catName = "Refrigerator\n/Freezer\n/Liquid Nitrogen" // "Sanitation and Embrex Evaluation"
                    
                }
                catArrayForCollectionIs.append(cat)
                
            }
        }
        
        for cat in catArrayForCollectionIs{
            if cat.doa.count > 0 {
                var idArr : [Int] = []
                for obj in  cat.doa {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: obj)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                            debugPrint("no data..")
                        }else{
                            idArr.append(data!.id ?? 0)
                            dayOfAgeData.append(data!)
                        }
                    }
                }
            }
        }
        
        for cat in catArrayForCollectionIs{
            if cat.doaS.count > 0 {
                var idArr : [Int] = []
                for obj in  cat.doaS {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: obj)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                            debugPrint("no DOA data..")
                        }else{
                            idArr.append(data!.id ?? 0)
                            dayOfAgeSData.append(data!)
                        }
                    }
                }
            }
        }
        
        for cat in catArrayForCollectionIs{
            if cat.inovoject.count > 0 {
                var idArr : [Int] = []
                for obj in  cat.inovoject {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: obj)
                    if idArr.contains(data!.id ?? 0){
                        debugPrint("no inovo data found.")
                    }else{
                        idArr.append(data!.id ?? 0)
                        inovojectData.append(data!)
                    }
                }
            }
        }
        
        
        for cat in catArrayForCollectionIs{
            if cat.vMixer.count > 0 {
                var idArr : [Int] = []
                for obj in  cat.vMixer {
                    let data = CoreDataHandlerPE().getCertificateData(doaId: obj)
                    if idArr.contains(data!.id ?? 0){
                        debugPrint("no certificate data..")
                    }else{
                        idArr.append(data!.id ?? 0)
                        certificateData.append(data!)
                    }
                }
            }
        }
        
        if certificateData.count > 0 {
            self.certificateData =  self.certificateData.sorted(by: {
                let id1 = $0.id as? Int ?? 0
                let id2 = $1.id as? Int ?? 0
                return id1 < id2
            })
            
        }
        
        
        for cat in catArrayForCollectionIs {
            if cat.catISSelected == 1 {
                row = cat.sequenceNo ?? 0 - 1
                selectedCategory = cat
            }
        }
        if  selectedCategory?.evaluationDate?.count == nil {
            selectedCategory = catArrayForCollectionIs.first
        }
        
        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
        
        super.viewDidLoad()
        tableview.register(PEQuestionTableViewCell.nib, forCellReuseIdentifier: PEQuestionTableViewCell.identifier)
        tableview.register(CrewInformationCell.nib, forCellReuseIdentifier: CrewInformationCell.identifier)
        tableview.register(InovojectCell.nib, forCellReuseIdentifier: InovojectCell.identifier)
        tableview.register(InovojectNewTableViewCell.nib, forCellReuseIdentifier: InovojectNewTableViewCell.identifier)
        tableview.register(RefrigatorQuesCell.nib, forCellReuseIdentifier: RefrigatorQuesCell.identifier)
        tableview.register(SetFrezzerPointCell.nib, forCellReuseIdentifier: SetFrezzerPointCell.identifier)
        let refrigatorTempProbeCell = UINib(nibName: "RefrigatorTempProbeCell", bundle: nil)
        tableview.register(refrigatorTempProbeCell, forHeaderFooterViewReuseIdentifier: "RefrigatorTempProbeCell")
        let frezerFooterViewCell = UINib(nibName: "FrezerFooterViewCell", bundle: nil)
        tableview.register(frezerFooterViewCell, forHeaderFooterViewReuseIdentifier: "FrezerFooterViewCell")
        let frezerHeaderViewCell = UINib(nibName: "SetFrezzerPointCell", bundle: nil)
        tableview.register(frezerHeaderViewCell, forHeaderFooterViewReuseIdentifier: "SetFrezzerPointCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        if !(isFromEditMicro) {
            row = 0
            collectionviewIndexPath = IndexPath(row: row, section: 0)
            lblextenderMicro.isHidden = true
            extendedMicroSwitch.isHidden = true
            extendedMicroSwitch.isUserInteractionEnabled = false
            tableview.isUserInteractionEnabled = true
        }
        else {
            if self.peNewAssessment.IsEMRequested == false {
                self.extendedMicroSwitch.isOn = false
                self.synWebBtn.isEnabled = false
                self.synWebBtn.alpha = 0.3
                UserDefaults.standard.setValue(false, forKey: "extendedAvailable")
                UserDefaults.standard.set(false, forKey:"ExtendedMicro")
                
            }
            else {
                synWebBtn.setTitle("Sync to Web", for: .normal)
                self.synWebBtn.isEnabled = true
                self.synWebBtn.alpha = 1.0
            }
            
            lblextenderMicro.isHidden = false
            extendedMicroSwitch.isHidden = false
            extendedMicroSwitch.isUserInteractionEnabled = true
        }
        
        selectedCategory = catArrayForCollectionIs[0]
        selectinitialCell()
        
        selectedComplex.text = catArrayForCollectionIs.first?.siteName
        selectedCustomer.text = catArrayForCollectionIs.first?.customerName
        assessmentDateText.text =  catArrayForCollectionIs.first?.evaluationDate
        chechForLastCategory()
        setupUI()

        sig_Date.text = selectedCategory?.sig_Date
        
        fsrSign = selectedCategory?.FSTSignatureImage ?? ""
        sig_Name.text = selectedCategory?.sig_Name
        lblRepresentative2.text = selectedCategory?.sig_Name2
        sig_Phone.text = selectedCategory?.sig_Phone
        sig_EmployeeID.text = selectedCategory?.sig_EmpID
        lblTitle2.text = selectedCategory?.sig_EmpID2
        let data = CoreDataHandlerPE().getImageByImageID(idArray:(selectedCategory?.sig)!)
        DispatchQueue.main.async() {
            self.sig_imageView.image = UIImage(data: data)
        }
        
        if selectedCategory?.sig2 ?? 0 > 0 {
            let data2 = CoreDataHandlerPE().getImageByImageID(idArray:(selectedCategory?.sig2)!)
            DispatchQueue.main.async() {
                self.imgSignature2.image = UIImage(data: data2)
            }
        }
        if regionID == 3
        {
            
            if showExtendedPE {
                
                if(catArrayForCollectionIs.last?.catName == "Sanitation and Embrex Evaluation"){
                    catArrayForCollectionIs.remove(at: catArrayForCollectionIs.count-1)
                }
                
                let catObjectPE = PENewAssessment()
                catObjectPE.catName = "Extended Microbial" // "Sanitation and Embrex Evaluation"
                catObjectPE.sequenceNo = 12
                catObjectPE.sequenceNoo = 12
                catArrayForCollectionIs.append(catObjectPE)
                
                tableview.register(UINib(nibName: "PlateInfoCell", bundle: nil), forCellReuseIdentifier: "PlateInfoCell")
                
                let nibPlateInfoHeader = UINib(nibName: "PlateInfoHeader", bundle: nil)
                tableview.register(nibPlateInfoHeader, forHeaderFooterViewReuseIdentifier: "PlateInfoHeader")
                
                
            }
            else{
                if(catArrayForCollectionIs.last?.catName == "Sanitation and Embrex Evaluation"){
                    catArrayForCollectionIs.remove(at: catArrayForCollectionIs.count-1)
                }
            }
        }
        collectionView.reloadData()
        tableview.reloadData()
        collectionView(collectionView, didSelectItemAt: collectionviewIndexPath)
        self.collectionView.selectItem(at: self.collectionviewIndexPath, animated: false, scrollPosition: .left)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScores(_:)), name: NSNotification.Name.init(rawValue: "RefreshExtendedPEScores") , object: nil)
        collectionViewSignature.reloadData()
        synWebBtn.isHidden = false
        if isFromEditMicro{
            bckButton.isHidden = true
            
        }
        else {
            bckButton.isHidden = false
            
        }
        
        if(regionID == 3){
            lblNA.isHidden = true
            btnNA.isHidden = true
        }else{
            lblNA.isHidden = false
            btnNA.isHidden = false
            showHideNA(sequenceNoo: self.selectedCategory?.sequenceNoo ?? 0, catName: self.selectedCategory?.catName ?? "")
        }
        
    }
    
    @objc func  refreshScores(_ notification: NSNotification){
        let sanitationIndex =  notification.userInfo?["index"]  as? Int
        refreshScore(sanitationIndex ?? -1)
    }
    
    func refreshScore(_ sanitationIndex:Int){
        self.sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "")
        let score = sanitationQuesArr.map({($0.currentScore ?? 0)}).reduce(0,+)
        
        resultScoreLabel.text = "\(score)"
        totalScoreLabel.text = "100"
        
    }
    
    func setupUI(){
        synWebBtn.setSyncWebButtonUI()
        let nibCatchers = UINib(nibName: "PETableviewHeaderFooterView", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PETableviewHeaderFooterView")
        let nibCas = UINib(nibName: "PEInovojectHeaderFooterView", bundle: nil)
        tableview.register(nibCas, forHeaderFooterViewReuseIdentifier: "PEInovojectHeaderFooterView")
        let nibCasa = UINib(nibName: "PEHeaderDayOfAge", bundle: nil)
        tableview.register(nibCasa, forHeaderFooterViewReuseIdentifier: "PEHeaderDayOfAge")
        let peTableviewConsumerQualityHeader = UINib(nibName: "PETableviewConsumerQualityHeader", bundle: nil)
        tableview.register(peTableviewConsumerQualityHeader, forHeaderFooterViewReuseIdentifier: "PETableviewConsumerQualityHeader")
        
        coustomerView.setCornerRadiusFloat(radius: 24)
        customerGradientView.setCornerRadiusFloat(radius: 24)
        DispatchQueue.main.async {
            self.customerGradientView.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
        scoreParentView.backgroundColor =  UIColor.cellAlternateBlueCOlor()
    }
    
    
    func refreshTableView(){
        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
        tableview.reloadData()
    }
    
    func refreshArray(){
        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
    }
    
    func filterCategory()  {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessment.evaluationID == object.evaluationID{
                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
    }
    
    func getRandomNumber(maxNumber: Int, listSize: Int)-> Int {
        var randomNumbers = Set<Int>()
        var sum = 0
        while randomNumbers.count < listSize {
            let randomNumber = Int(arc4random_uniform(UInt32(maxNumber+1)))
            sum = sum + randomNumber
            randomNumbers.insert(randomNumber)
        }
        return sum
    }
    
    
    private func updateScore()  {
     
        resultScoreLabel.text = String(selectedCategory?.catResultMark ?? 0)
        totalScoreLabel.text = String(selectedCategory?.catMaxMark ?? 0)
        let finalResult = CoreDataHandlerPE().fetchCustomerWithCatIDCount(Int64(selectedCategory?.sequenceNo ?? 0))
        if  finalResult != 0{
            resultScoreLabel.text = String(finalResult ?? 0)
        }
        
    }
    
    private func selectinitialCell() {
        collectionView.selectItem(at: collectionviewIndexPath, animated: false, scrollPosition: .left)
        updateScore()
    }
    
    // MARK: Finalize Button Action
    @IBAction func finalizeButtonClicked(_ sender: Any) {
        
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
    // MARK:  Draft Button Action
    @IBAction func draftBtnClicked(_ sender: Any) {
        let errorMSg = "Are you sure you want to save assessment in Draft?"
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            NSLog("OK Pressed")
            self.saveDraftData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func draftButtonClickedInitial(_ sender: Any) {
        let errorMSg = "Are you sure you want to save assessment in Draft?"
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            NSLog("OK Pressed")
            self.saveDraftData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK:  Save Finalize Data
    private func saveFinalizedData(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEFinishPopupViewController") as! PEFinishPopupViewController
        vc.validationSuccessFull = {[unowned self] ( error) in
            self.finishSession()
        }
        self.navigationController?.present(vc, animated: false, completion: nil)
        
    }
    
    // MARK:  Get Offline Assessment's From DB
    func getAssessmentInOfflineFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInOffline")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK:  Get Drafted Assessment's Count
    func getDraftCountFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.last ?? 0
    }
    // MARK:  Save Draft Data
    private func saveDraftData(){
        var allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
        let draftNumber = getDraftCountFromDb()
        var count = 0
        CoreDataHandlerPE().saveDraftPEInDB(newAssessmentArray: allAssesmentArr as? [PENewAssessment] ?? [], draftNumber: draftNumber + 1)
        finishSession()
    }
    // MARK:  Finish Session
    func finishSession()  {
        cleanSession()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
    }
    // MARK:  Clean Session
    private func cleanSession(){
        
        let peNewAssessmentSurrentIs =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
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
        peNewAssessmentNew.evaluationDate = peNewAssessmentSurrentIs.evaluationDate
        self.navigationController?.popToViewController(ofClass: PEDashboardViewController.self)
    }
    
}
// MARK:  Table View delegate's
extension PEViewAssesmentFinalize: UITableViewDelegate, UITableViewDataSource{
    
    func checkForTraning()-> Bool{
        var currentAssessmentIs = CoreDataHandlerPE().getSavedOfflineAssessmentPEObject(id: peNewAssessment.dataToSubmitNumber ?? 0)
        debugPrint(currentAssessmentIs)
        return true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if catArrayForTableIs.count > 0 {
            var assessment = catArrayForTableIs[0] as? PE_AssessmentInProgress
            if assessment?.sequenceNoo == 1  {
                if checkForTraning(){
                    return 5
                } else {
                    return 4
                }
            } else if assessment?.sequenceNoo == 3 {
                if regionID != 3{
                    return 1
                }
                else
                {
                    if peNewAssessment.evaluationID == 1{
                        return 1
                    }
                    else{
                        return 2
                    }
                }
                
            }
          
            if selectedCategory?.sequenceNoo == 12 && selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
                return 1
            }
            if selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
                return 3
            }
            else {
                return 1
            }
        }
        if selectedCategory?.sequenceNoo == 12 && selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
            return 1
        }
        if selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
            return 3
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if checkForTraning(){
            if section == 0 && selectedCategory?.sequenceNoo == 12 && selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen" {
                return sanitationQuesArr.count
            }
            
            if (selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                return 2
            }
            if section == 1 {
                return certificateData.count
            }
            if section == 2 {
                return inovojectData.count
            }
            if section == 3 {
                return dayOfAgeData.count
            }
            if section == 4 {
                return dayOfAgeSData.count
            }
            return catArrayForTableIs.count
        } else {
            var assessment = catArrayForTableIs[0] as? PE_AssessmentInProgress
            if assessment?.sequenceNoo == 3 {
                if section == 0 {
                    return catArrayForTableIs.count                }
                if section == 1 {
                    return 1
                }
            } else {
                if section == 1 {
                    return inovojectData.count
                }
                if section == 2 {
                    return dayOfAgeData.count
                }
                if section == 3 {
                    return dayOfAgeSData.count
                }
            }
            return catArrayForTableIs.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if checkForTraning(){
            if(selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                if indexPath.section == 1 {
                    return 130
                }
                if indexPath.section == 2 {
                    return 200
                }
            }
        }
        if selectedCategory?.sequenceNoo == 12 && selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
          
            return 70
        }
        let assessment = catArrayForTableIs[indexPath.row] as? PE_AssessmentInProgress
        if selectedCategory?.sequenceNoo == 3 {
            if (indexPath.section == 0){
                if selectedCategory?.sequenceNoo == 3 && assessment?.rollOut == "Y" && assessment?.qSeqNo == 1{
                    return 120
                }
                else {
                    return 70
                }
            }
            else {
                return 0
            }
        }
        
        if selectedCategory?.sequenceNoo == 11   && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
            return 80
            
        }
        if(selectedCategory?.catName != "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
            if indexPath.section > 0 {
                return 130
            }
        }
        
        var height:CGFloat = CGFloat()
        height = self.estimatedHeightOfLabel(text: assessment?.assDetail1 ?? "") + 50
        return height
        
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        
        let size = CGSize(width: view.frame.width - 16, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let font = UIFont(name: "HelveticaNeue-Bold", size: 20)//font type and size
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if checkForTraning(){
            if indexPath.section == 0 && selectedCategory?.sequenceNoo == 12 && selectedCategory?.catName == "Extended Microbial"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PlateInfoCell", for: indexPath) as! PlateInfoCell
                cell.currentIndex = indexPath.row
                cell.plateTypeBtn.isUserInteractionEnabled = false
                if self.peNewAssessment.IsEMRequested == false{
                    self.tableview.isUserInteractionEnabled = true
                    cell.blueGreenMoldTxtField.isUserInteractionEnabled = true
                    cell.bacteriaTxtField.isUserInteractionEnabled = true
                    cell.noteBtn.isUserInteractionEnabled = true
                }
                else {
                    self.tableview.isUserInteractionEnabled = true
                    cell.blueGreenMoldTxtField.isUserInteractionEnabled = false
                    cell.bacteriaTxtField.isUserInteractionEnabled = false
                }
                
                if sanitationQuesArr.count > indexPath.row{
                    cell.setValues(quesObj: sanitationQuesArr[indexPath.row], index: indexPath.row)
                }
                cell.plateTypeCompletion = {
                    [unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    
                    
                    let plateTypes = PlateTypesDAO.sharedInstance.fetchPlateTypes(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
                    let arr = plateTypes.map{ $0.value}
                    self.dropDownVIewNew(arrayData: arr as! [String], kWidth: cell.plateTypeBtn.frame.width, kAnchor: cell.plateTypeBtn, yheight: cell.plateTypeBtn.bounds.height) {
                        [unowned self] selectedVal, index  in
                        if indexPath.row > -1 && self.sanitationQuesArr.count > indexPath.row{
                            let quesObj = self.sanitationQuesArr[indexPath.row]
                            if index > -1 && plateTypes.count > index{
                                self.sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "")
                                
                                quesObj.plateTypeDescription = plateTypes[index].value
                                quesObj.plateTypeId =  plateTypes[index].id
                                
                                self.sanitationQuesArr[indexPath.row] = quesObj
                                SanitationEmbrexQuestionMasterDAO.sharedInstance.updateAssessmentQuestion(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "", questionId: Int64(quesObj.questionId ?? "") ?? 0, questionVM: quesObj)
                                
                            }
                            self.tableview.beginUpdates()
                            self.tableview.reloadRows(at: [indexPath], with: .none)
                            self.tableview.endUpdates()
                            
                        }
                    }
                    
                    self.dropHiddenAndShow()
                }
                cell.commentsCompletion = {[unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    
                    self.sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "")
                    var comments = self.sanitationQuesArr[indexPath.row].userComments ?? ""
                    var questionObj = self.sanitationQuesArr[indexPath.row]
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
                    vc.textOfTextView = comments
                    if peNewAssessment.IsEMRequested == false {
                        vc.editable = true
                    }
                    else {
                        vc.editable = false
                    }
                    vc.commentCompleted = {[unowned self] ( note) in
                        if note == "" {
                            let image = UIImage(named: "PEcomment.png")
                            cell.noteBtn.setImage(image, for: .normal)
                            
                        } else {
                            let image = UIImage(named: "PECommentSelected.png")
                            cell.noteBtn.setImage(image, for: .normal)
                        }
                        
                        questionObj.userComments = note ?? ""
                        self.sanitationQuesArr[indexPath.row] = questionObj
                        if questionObj != nil{
                            SanitationEmbrexQuestionMasterDAO.sharedInstance.updateAssessmentQuestion(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: self.peNewAssessment?.serverAssessmentId ?? "", questionId: Int64(questionObj.questionId ?? "") ?? 0, questionVM: questionObj)
                            tableView.beginUpdates()
                            tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .automatic)
                            tableView.endUpdates()
                        }
                    }
                    if vc.editable{
                        self.navigationController?.present(vc, animated: false, completion: nil)
                    }else{
                        if comments != nil && comments != ""{
                            self.navigationController?.present(vc, animated: false, completion: nil)
                        }
                    }
                }
                self.refreshScore(indexPath.row)
                cell.assessmentId = peNewAssessment?.serverAssessmentId
                return cell
            }
            
            if(selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                
                return  setUpRerigatorQuesCell(tableView, cellForRowAt: indexPath)
            }
            else{
             
                if indexPath.section == 1,
                   let cell = tableView.dequeueReusableCell(withIdentifier: CrewInformationCell.identifier) as? CrewInformationCell {
                    if certificateData.count > indexPath.row {
                        cell.config(data: certificateData[indexPath.row])
                    }
                    cell.isUserInteractionEnabled = false
                    return cell
                }
                
                if indexPath.section == 2 {
                    return self.setupInovojectCell(tableView, cellForRowAt: indexPath)
                }
                if indexPath.section == 3
                {
                    return self.setupDayOfAgeCell(tableView, cellForRowAt: indexPath)
                }
                if indexPath.section == 4{
                    return self.setupDayOfAgeSCell(tableView, cellForRowAt: indexPath)
                }
                else {
                    return  self.setupPEQuestionTableViewCell(tableView, cellForRowAt: indexPath)
                }
            }
            
        } else {
            let assessment = catArrayForTableIs[0] as? PE_AssessmentInProgress
            if assessment?.sequenceNoo == 3 && assessment?.catName?.lowercased()
                != "miscellaneous" {
                if indexPath.section == 0 {
                    return  self.setupPEQuestionTableViewCell(tableView, cellForRowAt: indexPath)              }
                if indexPath.section == 1 {
                    return UITableViewCell()
                }
            }
            else if(assessment?.sequenceNoo == 12 && assessment?.catName?.lowercased()
                    != "Refrigator\n/Fridger\n/Liquid Nitriogen" ){
                if indexPath.section == 1 {
                    return self.setupInovojectCell(tableView, cellForRowAt: indexPath)
                }
            }
            
            else {
                if indexPath.section == 1 {
                    return self.setupInovojectCell(tableView, cellForRowAt: indexPath)
                }
                if indexPath.section == 2 {
                    return self.setupDayOfAgeCell(tableView, cellForRowAt: indexPath)
                }
                if indexPath.section == 3 {
                    return self.setupDayOfAgeSCell(tableView, cellForRowAt: indexPath)
                } else {
                    return  self.setupPEQuestionTableViewCell(tableView, cellForRowAt: indexPath)
                }
            }
        }
        
        return UITableViewCell()
    }
    // MARK:  Setup PE  Rerigator questions data */
    
    func setUpRerigatorQuesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RefrigatorQuesCell {
        
        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
        
        var assesmentArray = [PE_AssessmentInProgress]()
        var arrayRefri = [PE_AssessmentInProgress]()
        var arrayFreezer = [PE_AssessmentInProgress]()
        var arrayLiquid = [PE_AssessmentInProgress]()
        arrayRefri.append(catArrayForTableIs[0] as! PE_AssessmentInProgress)
        arrayRefri.append(catArrayForTableIs[1] as! PE_AssessmentInProgress)
        arrayFreezer.append(catArrayForTableIs[5] as! PE_AssessmentInProgress)
        arrayFreezer.append(catArrayForTableIs[6] as! PE_AssessmentInProgress)
        arrayLiquid.append(catArrayForTableIs[11] as! PE_AssessmentInProgress)
        arrayLiquid.append(catArrayForTableIs[12] as! PE_AssessmentInProgress)
        if(indexPath.section == 0){
            assesmentArray = arrayRefri
        }
        else if(indexPath.section == 1){
            assesmentArray = arrayFreezer
        }
        else if(indexPath.section == 2){
            assesmentArray = arrayLiquid
        }
        self.refriCamerAssesment = assesmentArray
        if let cell = tableView.dequeueReusableCell(withIdentifier: RefrigatorQuesCell.identifier) as? RefrigatorQuesCell{
            
            var assessment = assesmentArray[indexPath.row] as? PE_AssessmentInProgress
            if(refrigtorProbeArray.count > 0){
                
                for refri in refrigtorProbeArray{
                    if(refri.id == assesmentArray[indexPath.row].assID){
                        if(refri.isNA ?? false){
                            cell.btn_NA.isSelected = true
                            cell.contentView.alpha = 0.3
                            cell.btn_Switch.isUserInteractionEnabled = false
                            cell.btn_Info.isUserInteractionEnabled = false
                            cell.btn_Camera.isUserInteractionEnabled = false
                            cell.btn_Comment.isUserInteractionEnabled = false
                        }
                        else{
                            cell.btn_NA.isSelected = false
                            cell.contentView.alpha = 1
                            cell.btn_Switch.isUserInteractionEnabled = true
                            cell.btn_Info.isUserInteractionEnabled = true
                            cell.btn_Camera.isUserInteractionEnabled = true
                            cell.btn_Comment.isUserInteractionEnabled = true
                        }
                        if(refri.isCheck ??  false){
                            cell.switchClicked(status: true)
                            cell.btn_Switch.setOn(true, animated: false)
                        }
                        else{
                            cell.switchClicked(status: false)
                            cell.btn_Switch.setOn(false, animated: false)
                        }
                    }
                }
            }
            
            cell.lblQuestion.text = assesmentArray[indexPath.row].assDetail1
            
            if(indexPath.section == 0 ){
                if(indexPath.row  == 0){
                    cell.contentView.backgroundColor = .clear
                }
                else{
                    cell.contentView.backgroundColor = .white
                }
            }
            else if( indexPath.section == 1){
                if(indexPath.row  == 0){
                    cell.contentView.backgroundColor = .clear
                }
                else{
                    cell.contentView.backgroundColor = .white
                }
            }
            else{
                if(indexPath.row  == 0){
                    cell.contentView.backgroundColor = .white
                }
                else{
                    cell.contentView.backgroundColor = .clear
                }
            }
            
            
            if assessment?.camera == 1 {
                cell.btn_Camera.isEnabled = true
                cell.btn_Camera.alpha = 1
            } else {
                cell.btn_Camera.isEnabled = false
                cell.btn_Camera.alpha = 0.3
            }
            
            let imageCount = assessment?.images as? [Int]
            let cnt = imageCount?.count
            let ttle = String(cnt ?? 0)
            cell.btn_ImageCount.setTitle(ttle,for: .normal)
            if ttle == "0"{
                cell.btn_ImageCount.isHidden = true
            } else {
                cell.btn_ImageCount.isHidden = false
            }
            
            let image1 = UIImage(named: "PEcomment.png")
            let image2 = UIImage(named: "PECommentSelected.png")
            if assessment?.note == "" || assessment?.note == nil {
                cell.btn_Comment.setImage(image1, for: .normal)
            } else {
                cell.btn_Comment.setImage(image2, for: .normal)
            }
            
            cell.btn_NA.isUserInteractionEnabled = false
            cell.btnNA  = {[unowned self] () in
                
                var switchisCheck = false
                let refri = catArrayForTableIs[0] as! PE_AssessmentInProgress
                refrigtorProbeArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(refri.serverAssessmentId ?? "0") ?? 0)
                if(refrigtorProbeArray.count > 0){
                    
                    for refrii in refrigtorProbeArray{
                        if(refrii.id == assesmentArray[indexPath.row].assID){
                            if(refrii.isCheck ?? false){
                                switchisCheck = true
                            }
                            else{
                                switchisCheck = false
                            }
                        }
                    }
                }
                if(cell.btn_NA.isSelected){
                    if(self.refrigator_Selected_NA_QuestionArray[indexPath.section] == indexPath.row){
                        self.refrigator_Selected_NA_QuestionArray[indexPath.section] = nil
                    }
                    cell.contentView.alpha = 1
                    cell.btn_Switch.isUserInteractionEnabled = true
                    cell.btn_Info.isUserInteractionEnabled = true
                    cell.btn_Camera.isUserInteractionEnabled = true
                    cell.btn_Comment.isUserInteractionEnabled = true
                    assessment?.isNA = false
                    
                    if(switchisCheck) {
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:"" , value: 0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: false,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:  "" , value: 0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: false,schAssmentId:  Int(selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    } else {
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:"" , value: 0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: false,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:  "" , value: 0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: false,schAssmentId:  Int(selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    }
                }
                else{
                    assessment?.isAllowNA = true
                    self.refrigator_Selected_NA_QuestionArray[indexPath.section] = indexPath.row
                    cell.contentView.alpha = 0.3
                    cell.btn_Switch.isUserInteractionEnabled = false
                    cell.btn_Info.isUserInteractionEnabled = false
                    cell.btn_Camera.isUserInteractionEnabled = false
                    cell.btn_Comment.isUserInteractionEnabled = false
                    assessment?.isNA = true
                    
                    if(switchisCheck) {
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: true,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: true,schAssmentId: Int(selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    } else {
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ??  "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: true,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: true,schAssmentId: Int(selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    }
                }
                cell.btn_NA.isSelected = !cell.btn_NA.isSelected
                refrigtorProbeArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(refri.serverAssessmentId ?? "0") ?? 0)
            }
            
            cell.imagesCompletion  = {[unowned self] ( error) in
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "GroupImagesPEViewController") as! GroupImagesPEViewController
                self.refreshArray()
                vc.imagesArray = assessment?.images as? [Int] ?? [0]
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
            
            cell.infoCompletion = {[unowned self] ( error) in
                self.tableviewIndexPath = indexPath
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "InfoPEViewController") as! InfoPEViewController
                let maxMarksIs =  assessment?.assMaxScore as? Int ?? 0
                let boldMark1 =  "("
                let boldMark2 =  ") "
                let mrk = String(maxMarksIs)
                let str  =  boldMark1 + mrk + boldMark2 + (assessment?.assDetail1 ?? "")
                vc.questionDescriptionIs = str
                vc.imageDataBase64 = assessment?.informationImage ?? ""
                vc.infotextIs = assessment?.informationText ?? ""
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
            cell.btn_Switch.isUserInteractionEnabled = false
            cell.completion = { [unowned self] (status, error) in
                DispatchQueue.main.async {
                    self.tableviewIndexPath = indexPath
                    
                    self.tableview.isUserInteractionEnabled = false
                    if status ?? false {
                        var result = Int(self.resultScoreLabel.text ?? "0") ?? 0
                        let maxMarks =  assessment?.assMaxScore ?? 0
                        result = result + Int(truncating: maxMarks)
                        self.selectedCategory?.catResultMark = result
                        assessment?.catResultMark = result as NSNumber
                        self.resultScoreLabel.text = String(result)
                        assessment?.assStatus = 1
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: false,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                            
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: true,schAssmentId: Int(selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    } else {
                        var result = Int(self.resultScoreLabel.text ?? "0") ?? 0
                        let maxMarks = assessment?.assMaxScore ?? 0
                        result = result - Int(truncating: maxMarks)
                        self.selectedCategory?.catResultMark = result
                        assessment?.catResultMark = result as NSNumber
                        self.resultScoreLabel.text = String(result)
                        assessment?.assStatus = 0
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assessment?.assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assessment?.assID as! Int,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: false,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assessment?.assID as! NSNumber,  labelText: assessment?.assDetail1 ?? "", rollOut: "Y", unit:"" , value: 0.0,catID: assessment?.catID as! NSNumber,isCheck: false,isNA: true,schAssmentId: Int(self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    }
                    
                    if(selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
                    }
                    else{
                        catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
                    }
                    self.chechForLastCategory()
                    self.tableview.isUserInteractionEnabled = true
                }
                
            }
            
            cell.commentCompletion = {[unowned self] ( error) in
                self.tableviewIndexPath = indexPath
                self.refreshArray()
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
                vc.textOfTextView = assessment?.note ?? ""
                vc.infoText = assessment?.informationText ?? ""
                
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
            return cell
        }
        return UITableViewCell() as! RefrigatorQuesCell
    }
    // MARK:  Setup Cell for Inovoject Questioner
    func setupInovojectCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> InovojectNewTableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: InovojectNewTableViewCell.identifier) as? InovojectNewTableViewCell{
            cell.config(data:inovojectData[indexPath.row])
            if inovojectData[indexPath.row].invoHatchAntibiotic == 1 {
                cell.showHatcheryAnitibiotics()
            } else {
                cell.hideHatcheryAntibiotics()
            }
            if inovojectData[indexPath.row].vaccineMan?.lowercased().containsCaseInsensitive(string: "other") ?? false {
                cell.showOthersConstraint()
            } else {
                cell.hideOthersConstraint()
            }
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor = UIColor.white
            } else{
                cell.contentView.backgroundColor = UIColor.getHeaderTopGradient()
            }
            cell.hatcheryAntibioticsSwitch.isUserInteractionEnabled = false
            cell.tfProgramName.isUserInteractionEnabled = false
            cell.tfAntibioticText.isUserInteractionEnabled = false
            cell.tfOtherManText.isUserInteractionEnabled = false
            return cell
        }
        return UITableViewCell() as! InovojectNewTableViewCell
    }
    
    // MARK:  Set up cell for Day Of Age Questioner
    func setupDayOfAgeCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> InovojectCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: InovojectCell.identifier) as? InovojectCell{
            cell.config(data:dayOfAgeData[indexPath.row])
            cell.isUserInteractionEnabled = false
            cell.gradientVIew.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
            return cell
        }
        return UITableViewCell() as! InovojectCell
    }
    
    // MARK:  Set up cell for Day Of Age Sub Questioner
    func setupDayOfAgeSCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> InovojectCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: InovojectCell.identifier) as? InovojectCell{
            cell.config(data:dayOfAgeSData[indexPath.row])
            cell.isUserInteractionEnabled = false
            
            DispatchQueue.main.async {
                cell.gradientVIew.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
            }
            return cell
        }
        return UITableViewCell() as! InovojectCell
    }
    
    
    // MARK:  Set up Customer Vaccine View
    func setCustomerVaccineView(_ tableView: UITableView , section:Int) -> PETableviewConsumerQualityHeader {
        if selectedCategory?.sequenceNoo == 3{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PETableviewConsumerQualityHeader" ) as! PETableviewConsumerQualityHeader
            
            headerView.nameMicro.text =  self.peNewAssessment.micro
            headerView.nameResidue.text =  self.peNewAssessment.residue
            headerView.isUserInteractionEnabled = false
            
            headerView.microComplete =
            {[unowned self] ( error) in
                print("add",( error))
                self.peNewAssessment.micro  = error ?? ""
                CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment: self.peNewAssessment)
            }
            headerView.residueComplete =
            {[unowned self] ( error) in
                print("add",( error))
                self.peNewAssessment.residue  = error ?? ""
                
                CoreDataHandlerPE().updateDraftInDoGInProgressInDB(newAssessment: self.peNewAssessment)
            }
            return headerView as! PETableviewConsumerQualityHeader
        }
        return UIView() as! PETableviewConsumerQualityHeader
    }
    
    // MARK:  Set up cell for PE Questioner
    func setupPEQuestionTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PEQuestionTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PEQuestionTableViewCell.identifier) as? PEQuestionTableViewCell{
            var assessment = catArrayForTableIs[indexPath.row] as? PE_AssessmentInProgress
            if regionID != 3
            {
                cell.requiredComntBtn.isHidden = true
                if((assessment?.isAllowNA) ?? false ){
                    cell.btn_NA.isHidden = false
                    cell.lbl_NA.isHidden = false
                   
                    if((assessment?.isNA) ?? false){
                        cell.btn_NA.isSelected = true
                        if  assessment?.rollOut == "Y" && assessment?.sequenceNoo == 3{
                            cell.txtQCCount.text =  "NA"
                            cell.txtQCCount.isUserInteractionEnabled = true
                        }
                        if  assessment?.rollOut == "Y" && assessment?.catName == "Miscellaneous"{
                            cell.txtQCCount.text =  "NA"
                            cell.txtQCCount.isUserInteractionEnabled = true
                        }
                    }
                    else{
                        if  assessment?.rollOut == "Y" && assessment?.sequenceNoo == 3{
                            cell.txtQCCount.text =  ""
                            cell.txtQCCount.isUserInteractionEnabled = true
                        }
                        if   assessment?.rollOut == "Y" && assessment?.catName == "Miscellaneous"{
                            cell.txtQCCount.text =  ""
                            cell.txtQCCount.isUserInteractionEnabled = true
                        }
                        cell.btn_NA.isSelected = false
                    }
                }
                
                else{
                    cell.requiredComntBtn.isHidden = true
                    cell.btn_NA.isHidden = true
                    cell.lbl_NA.isHidden = true
                }
            }
            else{
                cell.btn_NA.isHidden = true
                cell.btn_NA.isHidden = true
                cell.lbl_NA.isHidden = true
                cell.requiredComntBtn.isHidden = true
            }
            
            if((assessment?.isNA) ?? false){
                cell.btn_NA.isSelected = true
                cell.contentView.alpha = 0.3
                cell.btnImageCount.isUserInteractionEnabled = false
                cell.noteBtn.isUserInteractionEnabled = false
                cell.cameraBTn.isUserInteractionEnabled = false
                cell.assessmentLbl.isUserInteractionEnabled = false
                cell.switchBtn.isUserInteractionEnabled = false
                cell.btnInfo.isUserInteractionEnabled = false
                cell.txtQCCount.isUserInteractionEnabled = false
            }
            else{
                cell.btn_NA.isSelected = false
                cell.contentView.alpha = 1
                cell.btnImageCount.isUserInteractionEnabled = true
                cell.noteBtn.isUserInteractionEnabled = true
                cell.cameraBTn.isUserInteractionEnabled = true
                cell.assessmentLbl.isUserInteractionEnabled = true
                cell.switchBtn.isUserInteractionEnabled = true
                cell.btnInfo.isUserInteractionEnabled = true
                cell.txtQCCount.isUserInteractionEnabled = true
            }
            
            
            let maxMarksIs =  assessment?.assMaxScore as? Int ?? 0
            let boldMark1 =  "("
            let boldMark2 =  ") "
            let mrk = String(maxMarksIs)
            let assDetail1 = assessment?.assDetail1 ?? ""
            
            if assessment?.rollOut == "Y" && assessment?.sequenceNoo == 3 && assessment?.qSeqNo == 12
            {
                cell.txtQCCount.text =  assessment?.qcCount ?? ""
                cell.showQcCountextField()
            } else if assessment?.rollOut == "Y" && assessment?.catName == "Miscellaneous" && assessment?.qSeqNo == 1
            {
                cell.txtQCCount.text =  assessment?.ampmValue ?? ""
                cell.showAMPMValuetextField()
            } else if assessment?.rollOut == "Y" && assessment?.sequenceNoo == 3  && assessment?.qSeqNo == 1
            {
                cell.txtPersonName.text =  assessment?.personName ?? ""
                cell.txtFrequency.text =  assessment?.frequency ?? ""
                cell.showFrequencytextField()
            }
            
            else if assessment?.rollOut == "Y" && assessment?.sequenceNoo == 5 && assessment?.qSeqNo == 5
            {
                cell.txtQCCount.text = assessment?.ppmValue ?? ""
                cell.showPPMField()
                
                self.peNewAssessment.ppmValue  =  cell.txtQCCount.text
                CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment: self.peNewAssessment)
            }
            
            else {
                cell.hideAMPMValuetextField()
                cell.hideQcCountextField()
            }
            cell.setGraddientAndLayerQcCountextFieldView()
            cell.txtPersonName.isUserInteractionEnabled = false
            cell.txtFrequency.isUserInteractionEnabled = false
            cell.txtQCCount.isUserInteractionEnabled = false
            cell.assessmentLbl.text =  boldMark1 + mrk + boldMark2 + (assessment?.assDetail1 ?? "")
            cell.assessmentLbl.attributedText =   cell.assessmentLbl.text?.withBoldText(text: boldMark1 + mrk + boldMark2)
            if(indexPath.row % 2 == 0) {
                cell.contentView.backgroundColor =  UIColor.cellAlternateBlueCOlor()
            } else {
                cell.contentView.backgroundColor =   UIColor.white
            }
            if assessment?.camera == 1 {
                cell.cameraBTn.isEnabled = true
                cell.cameraBTn.alpha = 1
            } else {
                cell.cameraBTn.isEnabled = false
                cell.cameraBTn.alpha = 0.3
            }
            
            if assessment?.assStatus == 1 {
                cell.switchBtn.setOn(true, animated: false)
            } else {
                cell.switchBtn.setOn(false, animated: false)
            }
            let imageCount = assessment?.images as? [Int]
            let cnt = imageCount?.count
            let ttle = String(cnt ?? 0)
            cell.btnImageCount.setTitle(ttle,for: .normal)
            if ttle == "0"{
                cell.btnImageCount.isHidden = true
            } else {
                cell.btnImageCount.isHidden = false
            }
            let image1 = UIImage(named: "PEcomment.png")
            let image2 = UIImage(named: "PECommentSelected.png")
            if assessment?.note?.count ?? 0 < 1 {
                cell.noteBtn.setImage(image1, for: .normal)
            } else {
                cell.noteBtn.setImage(image2, for: .normal)
            }
            cell.requiredComntBtn.isHidden = true
            cell.switchBtn.isUserInteractionEnabled = false
            cell.completion = { [unowned self] (status, error) in
                self.tableviewIndexPath = indexPath
                if status ?? false {
                    var result = Int(self.resultScoreLabel.text ?? "0") ?? 0
                    let maxMarks =  assessment?.assMaxScore ?? 0
                    result = result + Int(maxMarks)
                    self.selectedCategory?.catResultMark = result
                    assessment?.catResultMark = result as NSNumber
                    self.resultScoreLabel.text = String(result)
                    assessment?.assStatus = 1
                    self.updateAssessmentInDb(assessment : assessment!)
                }
                else {
                    var result = Int(self.resultScoreLabel.text ?? "0") ?? 0
                    let maxMarks = assessment?.assMaxScore ?? 0
                    result = result - Int(maxMarks)
                    self.selectedCategory?.catResultMark = result
                    assessment?.catResultMark = result as NSNumber
                    self.resultScoreLabel.text = String(result)
                    assessment?.assStatus = 0
                    self.updateAssessmentInDb(assessment : assessment!)
                }
                self.refreshTableView()
                self.updateScore()
                self.chechForLastCategory()
            }
            cell.imagesCompletion  = {[unowned self] ( error) in
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "GroupImagesPEViewController") as! GroupImagesPEViewController
                self.refreshArray()
                assessment = self.catArrayForTableIs[indexPath.row] as? PE_AssessmentInProgress
                vc.imagesArray = assessment?.images as? [Int] ?? [0]
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
            cell.commentCompletion = {[unowned self] ( error) in
                self.tableviewIndexPath = indexPath
                self.refreshArray()
                assessment = self.catArrayForTableIs[indexPath.row] as? PE_AssessmentInProgress
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
                vc.textOfTextView = assessment?.note ?? ""
                vc.infoText = assessment?.informationText ?? ""
                
                vc.editable = false
                vc.commentCompleted = {[unowned self] ( note) in
                    
                }
                if vc.editable{
                    self.navigationController?.present(vc, animated: false, completion: nil)
                }else{
                    if assessment?.note != nil && assessment?.note != ""{
                        self.navigationController?.present(vc, animated: false, completion: nil)
                    }
                }
            }
            cell.cameraCompletion = {[unowned self] ( error) in
                self.tableviewIndexPath = indexPath
                self.takePhoto(cell.cameraBTn)
            }
            cell.infoCompletion = {[unowned self] ( error) in
                self.tableviewIndexPath = indexPath
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "InfoPEViewController") as! InfoPEViewController
                let maxMarksIs =  assessment?.assMaxScore as? Int ?? 0
                let boldMark1 =  "("
                let boldMark2 =  ") "
                let mrk = String(maxMarksIs)
                let str  =  boldMark1 + mrk + boldMark2 + (assessment?.assDetail1 ?? "")
                vc.questionDescriptionIs = str
                vc.imageDataBase64 = assessment?.informationImage ?? ""
                vc.infotextIs = assessment?.informationText ?? ""
                
                self.navigationController?.present(vc, animated: false, completion: nil)
            }
            return cell
        }
        return UITableViewCell() as! PEQuestionTableViewCell
    }
    
    // MARK: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    // MARK:  Done Button Tabbed with Date
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        
        certificateData[tableviewIndexPath.row].certificateDate = string
        CoreDataHandlerPE().updateVMixerInDB(peCertificateData:  self.certificateData[tableviewIndexPath.row], id:  self.certificateData[tableviewIndexPath.row].id ?? 0)
        tableview.reloadData()
    }
    
    func doneButtonTapped(string:String){
        certificateData[tableviewIndexPath.row].certificateDate = string
        CoreDataHandlerPE().updateVMixerInDB(peCertificateData:  self.certificateData[tableviewIndexPath.row], id:  self.certificateData[tableviewIndexPath.row].id ?? 0)
        tableview.reloadData()
    }
    
    // MARK:  Show Date Picker
    func showDatePicker(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Selection", bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier: "DatePickerPopupViewController") as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.canSelectPreviousDate = false
        navigationController?.present(datePickerPopupViewController, animated: false, completion: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedCategory?.sequenceNoo == 12 && section == 0 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PlateInfoHeader" ) as! PlateInfoHeader
            headerView.isUserInteractionEnabled = false
            if(btnNA.isSelected ){
                headerView.contentView.alpha = 0.3
                
            }
            else{
                headerView.contentView.alpha = 1.0
            }
            return headerView
            
        }
        if selectedCategory?.sequenceNoo == 11 && section == 2 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"{
            let array =   CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SetFrezzerPointCell" ) as! SetFrezzerPointCell
            headerView.isUserInteractionEnabled = false
            if(btnNA.isSelected && self.selctedNACategoryArray.contains(78)){
                headerView.contentView.alpha = 0.3
            }
            else{
                headerView.contentView.alpha = 1.0
            }
            headerView.setGraddientAndLayerQcCountextFieldView()
            var assessment = array[2] as? PE_AssessmentInProgress
            
            var unitValue = ""
            var valueText = ""
            refrigtorProbeArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
            if(self.refrigtorProbeArray.count > 0){
                
                var ar = array[10] as? PE_AssessmentInProgress
                
                for j in 0..<self.refrigtorProbeArray.count{
                    if(ar?.assID == self.refrigtorProbeArray[j].id){
                        headerView.unitTxtFld.text  = self.refrigtorProbeArray[j].unit ?? ""
                        headerView.valueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                    }
                    
                }
                unitValue = headerView.unitTxtFld.text ?? ""
                valueText = headerView.valueTxtFld.text ?? ""
            }
            
            
            headerView.unitCompletion = { sender,txtfld ,textLabel in
                var unitArray = ["Fahrenheit","Celsius"]
                if  unitArray.count > 0 {
                    self.dropDownVIewNew(arrayData: unitArray ?? [], kWidth: (sender ?? UIButton()).frame.width, kAnchor: sender ?? UIButton(), yheight: (sender ?? UIButton()).bounds.height) {  selectedVal,index  in
                        txtfld.text = selectedVal
                        unitValue = txtfld.text ?? ""
                        if(textLabel == "Frezzer"){
                            assessment = array[10] as? PE_AssessmentInProgress
                            valueText = headerView.valueTxtFld.text ?? ""
                        }
                        
                        let assID = assessment?.assID
                        if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assID as! Int)) {
                            let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assID as! Int,  labelText: textLabel, rollOut: "Y", unit: unitValue , value: Double(valueText) ?? 0.0 ,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: false ,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                            CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        } else {
                            let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assID as! NSNumber,  labelText: textLabel, rollOut: "Y", unit: unitValue , value: Double(valueText) ?? 0.0,catID: assessment?.catID as! NSNumber,isCheck: true,isNA: false ,schAssmentId: self.selectedCategory?.assID ?? 0 )
                            CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        }
                    }
                    self.dropHiddenAndShow()
                }
            }
            
            headerView.valueCompletion = { value , textLabel in
                if(textLabel == "Frezzer"){
                    unitValue =  headerView.unitTxtFld.text ?? ""
                    assessment = array[10] as? PE_AssessmentInProgress
                }
                valueText = value?.text ?? ""
                let assID = assessment?.assID
                if(CoreDataHandlerPE().someDraftRefriEntityExists(id: assID as! Int)) {
                    let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(id:assID as! Int,  labelText: textLabel, rollOut: "Y", unit: unitValue , value:  Double(valueText) ?? 0.0,catID: 1,isCheck: true,isNA: false,serverAssessmentId: Int( self.selectedCategory?.serverAssessmentId ?? "0") ?? 0)
                    CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                } else {
                    let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(id:assID as! NSNumber,  labelText: textLabel, rollOut: "Y", unit: unitValue , value: Double(valueText) ?? 0.0 ,catID: 1,isCheck: true,isNA: false,schAssmentId: self.selectedCategory?.assID ?? 0)
                    CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                }
            }
            return headerView
            
        }
        if catArrayForTableIs.count > 0 {
            if checkForTraning(){
                
                if selectedCategory?.sequenceNoo == 1 {
                    if section == 1 {
                        
                        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PETableviewHeaderFooterView" ) as! PETableviewHeaderFooterView
                        headerView.isUserInteractionEnabled = false
                        headerView.lblTitle.text = "Vaccine Mixer Observer"
                        headerView.lblSubTitle.text = "Crew Information"
                        
                        headerView.addCompletion = {[unowned self] ( error) in
                            let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:0,name:"",date:"",isCertExpired: false,isReCert: false,vacOperatorId: 0, signatureImg: "", fsrSign: "", isManuallyAdded: false)
                            let certificateData = PECertificateData(info: certificModel)
                            let id = self.saveVMixerInPEModule(peCertificateData: certificateData)
                            certificateData.id = id
                            self.certificateData.append(certificateData)
                            DispatchQueue.main.async {
                                UIView.performWithoutAnimation {
                                    self.tableview.reloadData()
                                }
                            }
                        }
                        headerView.minusCompletion = {[unowned self] ( error) in
                            
                            if self.certificateData.count > 0 {
                                let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:0,name:"",date:"",isCertExpired: false,isReCert: false,vacOperatorId: 0, signatureImg: "", fsrSign: "", isManuallyAdded: false)
                               
                                self.certificateData.removeLast()
                            }
                            if self.certificateData.count > 1 {
                                UIView.performWithoutAnimation {
                                    self.tableview.reloadData()
                                    self.scrollToBottom(section:1)
                                }
                            } else {
                                UIView.performWithoutAnimation {
                                    self.tableview.reloadData()
                                }
                            }
                        }
                        
                        return headerView
                    }  else if section == 2 {
                        return self.setPEInovojectHeaderFooterView(tableView, section: section)
                    }
                    else if section == 3 {
                        return self.setPEHeaderDayOfAge(tableView, section: section)
                    }
                    else if section == 4 {
                        return self.setPEHeaderDayOfAgeS(tableView, section: section)
                    }
                } else if selectedCategory?.sequenceNoo == 3 {
                    if section == 1 {
                        return self.setCustomerVaccineView(tableView,section: section)
                        
                    } else {
                        return UIView()
                    }
                }
                
            } else {
                if selectedCategory?.sequenceNoo == 3 {
                    if section == 1 {
                        return self.setCustomerVaccineView(tableView,section: section)
                    } else {
                        return UIView()
                    }
                }
                if section == 1 {
                    return self.setPEInovojectHeaderFooterView(tableView, section: section)
                } else if section == 2 {
                    return self.setPEHeaderDayOfAge(tableView, section: section)
                } else if section == 3 {
                    return self.setPEHeaderDayOfAgeS(tableView, section: section)
                }
                
                else {
                    return UIView()
                }
            }
        }
        
        
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
            let refri = catArrayForTableIs[0] as! PE_AssessmentInProgress
            
            refrigtorProbeArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(refri.serverAssessmentId ?? "0") ?? 0)
            let array =   CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
            if (section == 0)  {
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RefrigatorTempProbeCell.identifier)as! RefrigatorTempProbeCell
                footerView.isUserInteractionEnabled = false
                if(btnNA.isSelected && self.selctedNACategoryArray.contains(78)){
                    footerView.contentView.alpha = 0.3
                }
                else{
                    footerView.contentView.alpha = 1
                }
                
                var unitValue = ""
                var valueText = ""
                if(self.refrigtorProbeArray.count > 0){
                    for i in 2...4{
                        var ar = array[i] as? PE_AssessmentInProgress
                        for j in 0..<self.refrigtorProbeArray.count-1{
                            if(ar?.assID == self.refrigtorProbeArray[j].id){
                                if(i == 2){
                                    footerView.topTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.topValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                    
                                }
                                if(i == 3){
                                    footerView.middleTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.middleValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                }
                                if(i == 4) {
                                    footerView.bottomTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.bottomValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                }
                            }
                        }
                        
                    }
                }
                if(refrigtorProbeArray.count > 0){
                    for i in refrigtorProbeArray{
                        let refri = i as! PE_Refrigators
                        if(refri.unit != ""){
                            footerView.main_UnitTextFld.text = refri.unit ?? ""
                        }
                        
                    }
                    
                }
                footerView.setGraddientAndLayerQcCountextFieldView()
                return footerView
            }
            else if ( section == 1){
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RefrigatorTempProbeCell.identifier)as! RefrigatorTempProbeCell
                footerView.isUserInteractionEnabled = false
                footerView.mainTempUnit.isHidden = true
                if(btnNA.isSelected && self.selctedNACategoryArray.contains(78)){
                    footerView.contentView.alpha = 0.3
                    
                }
                else{
                    footerView.contentView.alpha = 1
                }
               
                var unitValue = ""
                var valueText = ""
                
                
                if(self.refrigtorProbeArray.count > 0){
                    for i in 7...9{
                        var ar = array[i] as? PE_AssessmentInProgress
                        
                        for j in 0..<self.refrigtorProbeArray.count{
                            if(ar?.assID == self.refrigtorProbeArray[j].id){
                                if(i == 7){
                                    footerView.topTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.topValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                }
                                if(i == 8){
                                    footerView.middleTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.middleValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                }
                                if(i == 9){
                                    footerView.bottomTxtFld.text = self.refrigtorProbeArray[j].unit ?? ""
                                    footerView.bottomValueTxtFld.text = "\(self.refrigtorProbeArray[j].value ?? 0.0)"
                                }
                            }
                            
                        }
                        
                    }
                }
                footerView.setGraddientAndLayerQcCountextFieldView()
                return footerView
            }
            else{
                let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FrezerFooterViewCell.identifier)as! FrezerFooterViewCell
                footerView.isUserInteractionEnabled = false
                if(btnNA.isSelected && self.selctedNACategoryArray.contains(78)){
                    footerView.contentView.alpha = 0.3
                }
                else{
                    footerView.contentView.alpha = 1
                    
                }
                footerView.textFieldView.text  = self.peNewAssessment.refrigeratorNote ?? ""
                footerView.setGraddientAndLayerQcCountextFieldView()
                return footerView
            }
        }
        
        
        return UIView()
    }
    // MARK:  Set up PE Inovoject Header Footer View
    func setPEInovojectHeaderFooterView(_ tableView: UITableView , section:Int) -> PEInovojectHeaderFooterView {
        if selectedCategory?.sequenceNoo == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEInovojectHeaderFooterView" ) as! PEInovojectHeaderFooterView
            headerView.isUserInteractionEnabled = false
            headerView.lblTitle.text = "In Ovo"
            headerView.txtCSize.text = peNewAssessment.iCS
            headerView.txtDType.text = peNewAssessment.iDT
            headerView.txtAntiBiotic.text = peNewAssessment.hatcheryAntibioticsText
            
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn1)
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn2)
            headerView.setGraddientAndLayerAntibioticTextView()
            headerView.isUserInteractionEnabled = false
            
            return headerView
        } else {
            return UIView() as! PEInovojectHeaderFooterView
        }
    }
    
    
    // MARK:  Set up PE Header for Day Of Age Cell
    func setPEHeaderDayOfAge(_ tableView: UITableView , section:Int) -> PEHeaderDayOfAge {
        if selectedCategory?.sequenceNoo == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEHeaderDayOfAge" ) as! PEHeaderDayOfAge
            headerView.isUserInteractionEnabled = false
            headerView.lblTitle.text = "Day of Age Spray Application"
            headerView.txtCSize.text = peNewAssessment.dDT
            headerView.txtDType.text = peNewAssessment.dCS
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn1)
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn2)
            headerView.txtAntiBiotic.text = peNewAssessment.hatcheryAntibioticsDoaText
            headerView.setGraddientAndLayerAntibioticTextView()
            if peNewAssessment.hatcheryAntibioticsDoa == 1 {
                headerView.switchHatchery.setOn(true, animated: false)
                headerView.showAntiBioticTextView()
            } else {
                headerView.hideAntiBioticTextView()
            }
            headerView.isUserInteractionEnabled = false
            
            return headerView
        } else {
            return UIView() as! PEHeaderDayOfAge
        }
    }
    
    
    // MARK:  Set up Header for Day Of Age Sub
    func setPEHeaderDayOfAgeS(_ tableView: UITableView , section:Int) -> PEHeaderDayOfAge {
        if selectedCategory?.sequenceNoo == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEHeaderDayOfAge" ) as! PEHeaderDayOfAge
            headerView.lblTitle.text = "Day of Age Subcutaneous"
            headerView.txtCSize.text = peNewAssessment.dDDT
            headerView.txtDType.text = peNewAssessment.dDCS
            headerView.txtAntiBiotic.text = peNewAssessment.hatcheryAntibioticsDoaSText
            
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn1)
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn2)
            headerView.setGraddientAndLayerAntibioticTextView()
            if peNewAssessment.hatcheryAntibioticsDoaS == 1 {
                headerView.switchHatchery.setOn(true, animated: false)
                headerView.showAntiBioticTextView()
            } else {
                headerView.hideAntiBioticTextView()
            }
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn1)
            headerView.setDropdownStartAsessmentBtn(imageName: "dd",btn:headerView.btn2)
            headerView.isUserInteractionEnabled = false
            
            return headerView
        } else {
            return UIView() as! PEHeaderDayOfAge
        }
    }
    
    func refreshTableviewAndScrolToBottom(section:Int){
        self.tableview.reloadData()
        scrollToBottom(section:section)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
            if(section == 2) {
                return 100
            }
        }
        else{
            if section > 0 {
                if selectedCategory?.sequenceNoo == 1{
                    return 95.0
                }
                if selectedCategory?.sequenceNoo == 3{
                    return 95.0
                }
            }else{
                if  selectedCategory?.sequenceNoo == 12{
                    if section == 0 {
                        return 70.0
                    }else{
                        return 0.0
                    }
                }
            }
            return 0.0
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(selectedCategory?.sequenceNoo == 11 && selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
            if ((  section == 0) || ( section == 1)) {
                return 350
            }
            else{
                return 200
            }
        }
        
        return 0
    }
    func scrollToBottom(section:Int){
        
        var indexPathOfTab = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            if self.checkForTraning(){
                if section == 1 {
                    indexPathOfTab = IndexPath(
                        row: self.certificateData.count - 1 ,
                        section:1)
                }
                if section == 2 {
                    indexPathOfTab = IndexPath(
                        row: self.inovojectData.count - 1 ,
                        section:2)
                }
                if section == 3 {
                    indexPathOfTab = IndexPath(
                        row: self.dayOfAgeData.count - 1 ,
                        section:3)
                }
            } else {
                if section == 1 {
                    indexPathOfTab = IndexPath(
                        row: self.inovojectData.count - 1 ,
                        section:1)
                }
                if section == 2 {
                    indexPathOfTab = IndexPath(
                        row: self.dayOfAgeData.count - 1 ,
                        section:2)
                }
            }
            self.tableview.scrollToRow(at: indexPathOfTab, at: .none, animated: false)
        }
    }
    
    func updateAssessmentInDb(assessment:PE_AssessmentInProgress) {
        CoreDataHandlerPE().updateCatDetailsForStatus(assessment:assessment)
    }
    
    func updateNoteAssessmentInProgressPE(assessment:PE_AssessmentInProgress)  {
        CoreDataHandlerPE().updateNoteAssessmentInProgress(assessment:assessment)
    }
    func updateCategoryInDb(assessment:PENewAssessment) {
        CoreDataHandlerPE().updateCategortIsSelcted(assessment:assessment)
    }
}
// MARK:  Extension & Collection view Delegate's
extension PEViewAssesmentFinalize : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView  == collectionViewSignature {
            return certificateData.count + 1
        }
        else {
            
            return catArrayForCollectionIs.count + 1 ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView  == collectionViewSignature {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignaturesCollectionViewCell", for: indexPath as IndexPath) as! SignaturesCollectionViewCell
            if certificateData.count > indexPath.row {
                cell.imgSignature.contentMode = .scaleAspectFit
                cell.imgSignature.image = CodeHelper.sharedInstance.convertToImage(base64: certificateData[indexPath.row].signatureImg)
                cell.lblSignatureName.text = "Vaccination Mixer Operator Name : \(certificateData[indexPath.row].name ?? "")"
            }
            if certificateData.count == indexPath.row {
                if certificateData.count > 0 {
                    let data = CodeHelper.sharedInstance.convertToImage(base64: certificateData[0].fsrSign)
                    DispatchQueue.main.async() {
                        cell.imgSignature.contentMode = .scaleAspectFit
                        cell.imgSignature.image =  data
                        cell.lblSignatureName.text = "FSR Sign"
                    }
                }
            }
            
            return cell
        }
        else {
            if indexPath.row == catArrayForCollectionIs.count  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewIDPE", for: indexPath as IndexPath) as! PECategoryCell
                // let category = catArrayForCollectionIs[indexPath.row]
                cell.imageview.image = UIImage(named: "tabUnselect")!
                if tableview.isHidden{
                    cell.imageview.image =  UIImage(named: "tabSelect")!
                }
                
                cell.categoryLabel.text = "Final"
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewIDPE", for: indexPath as IndexPath) as! PECategoryCell
                cell.imageview.image = UIImage(named: "tabUnselect")!
                let category = catArrayForCollectionIs[indexPath.row]
                if let isSelected = selectedCategory?.catISSelected {
                    if selectedCategory?.sequenceNo == category.sequenceNo{
                        
                        if isSelected == 1{
                            cell.imageview.image =  UIImage(named: "tabSelect")!
                        }
                    }
                    
                }
                
                cell.categoryLabel.text = category.catName ?? ""
                return cell
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewSignature {
            
            return CGSize(width: collectionViewSignature.frame.width, height: collectionViewSignature.frame.height)
        }
        else {
            if catArrayForCollectionIs.count == 6{
                if indexPath.row == 3{
                    return CGSize(width: 146, height: 68)
                } else if indexPath.row == 4{
                    return CGSize(width: 126, height: 68)
                }else{
                    return CGSize(width: 136, height: 68)
                }
            }
            
            else{
                if indexPath.row == 3{
                    return CGSize(width: 171, height: 68)
                } else if indexPath.row == 4{
                    return CGSize(width: 151, height: 68)
                }else{
                    return CGSize(width: 161, height: 68)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        categoarylabelText = ""
        self.synWebBtn.isEnabled = true
        self.synWebBtn.alpha = 1.0
        self.bckButton.isHidden = true
        self.synWebBtn.setTitle("Sync to Web", for: .normal)
        self.tableview.isUserInteractionEnabled = true
        let cellsArray = self.collectionView.visibleCells
        if cellsArray.count > 0{
            for cell in cellsArray{
                if cell as! PECategoryCell == self.collectionView.cellForItem(at: indexPath) as! PECategoryCell{
                    (cell as! PECategoryCell).imageview.image = UIImage(named: "tabSelect") ?? UIImage()
                    
                }else{
                    (cell as! PECategoryCell).imageview.image = UIImage(named: "tabUnselect") ?? UIImage()
                }
            }
        }
        
        
        if indexPath.row == catArrayForCollectionIs.count {
            categoarylabelText = ""
            tableview.isHidden = true
            self.scoreParentView.isHidden = true
            viewForSignature.isHidden = false
            viewForMultiSignature.isHidden = false
            
            lblextenderMicro.isHidden = true
            extendedMicroSwitch.isHidden = true
            extendedMicroSwitch.isUserInteractionEnabled = false
            if peNewAssessment.evaluationID == 2 {
                self.scoreParentView.isHidden = true
                
                viewForSignature.isHidden = true
                viewForMultiSignature.isHidden = false
                constraintConstantHeight.constant = 0
            }
            collectionView.reloadItems(at: [IndexPath.init(row: indexPath.row, section: 0)])
        } else {
            tableview.isHidden = false
            self.scoreParentView.isHidden = false
            viewForSignature.isHidden = true
            selectedCategory?.catISSelected = 0
            viewForMultiSignature.isHidden = true
            self.updateCategoryInDb(assessment:selectedCategory!)
            if catArrayForCollectionIs.count > indexPath.row{
                
                collectionviewIndexPath = indexPath
                selectedCategory = catArrayForCollectionIs[indexPath.row]
                selectedCategory?.catISSelected = 1
                self.updateCategoryInDb(assessment:selectedCategory!)
                chechForLastCategory()
                catArrayForTableIs = CoreDataHandlerPE().fetchViewAssessmentCustomerWithCatID(selectedCategory?.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber: peNewAssessment.dataToSubmitNumber ?? 0)
                let totalMark = selectedCategory?.catMaxMark ?? 0
                totalScoreLabel.text = String(totalMark)
                resultScoreLabel.text = String(0)
                if(selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                    lblextenderMicro.isHidden = true
                    extendedMicroSwitch.isHidden = true
                    extendedMicroSwitch.isUserInteractionEnabled = false
                    if(catArrayForTableIs.count > 0){
                        let refri = catArrayForTableIs[0] as! PE_AssessmentInProgress
                        refrigtorProbeArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(refri.serverAssessmentId ?? "0") ?? 0)
                    }
                }
                if(selectedCategory?.catName == "Extended Microbial"){
                    categoarylabelText = "Extended Microbial"
                    
                    selectedCategory?.sequenceNoo = 12
                    extendedMicroSwitch.isUserInteractionEnabled = true
                    if self.peNewAssessment.IsEMRequested == false {
                        if self.submitExtend == true {
                            self.extendedMicroSwitch.isOn = true
                            self.synWebBtn.isEnabled = true
                            self.synWebBtn.alpha = 1.0
                            UserDefaults.standard.setValue(true, forKey: "extendedAvailable")
                            UserDefaults.standard.set(true, forKey:"ExtendedMicro")
                            
                        }
                        else {
                            self.extendedMicroSwitch.isOn = false
                            self.synWebBtn.isEnabled = false
                            self.synWebBtn.alpha = 0.3
                            UserDefaults.standard.setValue(false, forKey: "extendedAvailable")
                            UserDefaults.standard.set(false, forKey:"ExtendedMicro")
                        }
                        
                        lblextenderMicro.isHidden = false
                        extendedMicroSwitch.isHidden = false
                        self.synWebBtn.setTitle("Finish Extended Microbial", for: .normal)
                        
                        
                    } else {
                        self.synWebBtn.isEnabled = true
                        self.synWebBtn.alpha = 1.0
                        lblextenderMicro.isHidden = true
                        extendedMicroSwitch.isHidden = true
                        UserDefaults.standard.setValue(true, forKey: "extendedAvailable")
                        UserDefaults.standard.set(true, forKey:"ExtendedMicro")
                        self.synWebBtn.setTitle("Sync to Web", for: .normal)
                    }
                }
                else{
                    categoarylabelText = ""
                    self.tableview.isUserInteractionEnabled = true
                    lblextenderMicro.isHidden = true
                    extendedMicroSwitch.isHidden = true
                    extendedMicroSwitch.isUserInteractionEnabled = false
                    catArrayForTableIs = CoreDataHandlerPE().fetchCustomerWithCatID(selectedCategory?.sequenceNo as? NSNumber ?? 0)
                    if(checkCategoryisNA()){
                        self.btnNA.isSelected = true
                    }
                    else{
                        self.btnNA.isSelected = false
                    }
                }
                tableview.reloadData()
                updateScore()
              
                if regionID != 3
                {
                    if(selectedCategory?.catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen"){
                        showHideNA(sequenceNoo: selectedCategory?.sequenceNoo ?? 0,catName: selectedCategory?.catName ?? "")
                    }
                    else{
                        showHideNA(sequenceNoo: selectedCategory?.sequenceNoo ?? 0, catName: selectedCategory?.catName ?? "")
                    }
                }
                
                refreshTableView()
            }
        }
        synWebBtn.isHidden = false
    }
    // MARK:  Show Hide is NA
    func showHideNA(sequenceNoo:Int,catName:String){
        
        if( sequenceNoo == 11 && catName == "Refrigerator\n/Freezer\n/Liquid Nitrogen" ){
            lblNA.isHidden = true
            btnNA.isHidden = true
            scoreParentView.isHidden = true
        }
        else if(sequenceNoo == 1 || sequenceNoo == 2){
            lblNA.isHidden = true
            btnNA.isHidden = true
            scoreParentView.isHidden = false
        }
        else{
            lblNA.isHidden = false
            btnNA.isHidden = false
            scoreParentView.isHidden = false
        }
    }
    // MARK: Check Category Is NA
    func checkCategoryisNA() -> Bool{
        self.refreshArray()
        for  obj in catArrayForTableIs {
            let assessment = obj as? PE_AssessmentInProgress
            if assessment?.isNA == false{
                return false
            }
        }
        return true
    }
    
    func updateCategoriesInShared(){
    }
    // MARK:  Check for Last Category
    func chechForLastCategory(){
        var  peNewAssessmentArray = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: peNewAssessment.serverAssessmentId ?? "")
        var catArrayForCollectionIsAre : [PENewAssessment] = []
        var carColIdArray : [Int] = []
        for cat in peNewAssessmentArray {
            if !carColIdArray.contains(cat.sequenceNo ?? 0){
                carColIdArray.append(cat.sequenceNo ?? 0)
                catArrayForCollectionIsAre.append(cat)
            }
        }
        
        
        let count = catArrayForCollectionIs.count - 1
        if count > 0 {
            if let cat = catArrayForCollectionIs[count] as? PENewAssessment {
                if cat.sequenceNo == selectedCategory?.sequenceNo {
                    bckButton.isHidden = true
                    
                } else {
                    bckButton.isHidden = false
                }
            }
            else {
                bckButton.isHidden = false
                
            }
            
            if let cat = catArrayForCollectionIs[0] as? PENewAssessment{
                if cat.sequenceNo == selectedCategory?.sequenceNo{
                    bckButton.isHidden = false
                }  else {
                    bckButton.isHidden = true
                }
            } else {
                bckButton.isHidden = true
            }
            
            for cat in catArrayForCollectionIsAre {
                if cat.catResultMark == 0 {
                    
                    return
                }
            }
        }
    }
}

// MARK:  Extension
extension PEViewAssesmentFinalize{
    
    func anyCategoryContainValueOrNot() -> Bool{
        let peNewAssessmentSurrentIs = ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0]
        for obj in peNewAssessmentSurrentIs.peCategoryArray{
            if obj.resultMark ?? 0 > 0 {
                return true
            }
            return false
        }
        return false
    }
    
    func getCategoryAlreadyDone() -> PECategory{
        let peNewAssessmentSurrentIs = ZoetisDropdownShared.sharedInstance.sharedPEOnGoingSession[0]
        for obj in peNewAssessmentSurrentIs.peCategoryArray{
            if obj.isSelected {
                return obj
            }
        }
        return PECategory(nil)
    }
    
    
}

// MARK:  ************** Camera Button Action ***************************************/
extension PEViewAssesmentFinalize: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    @objc func takePhoto(_ sender: UIButton) {
        
    }
    
    // MARK: ************* Alert View Methods ***********************************/
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /**************************************************************************************************/
    
    // MARK: ******************************  Image Picker Delegate Methods ***************************************/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let pickedImage: UIImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]) as? UIImage {
            
            let imageData = pickedImage.jpegData(compressionQuality: 0.5)
            saveImageInPEModule(imageData:imageData!)
            self.refreshArray()
            let assessment = self.catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
            if let cell = tableview.cellForRow(at: tableviewIndexPath) as? PEQuestionTableViewCell {
                let imageCount = assessment?.images as? [Int]
                let cnt = imageCount?.count
                let ttle = String(cnt ?? 0)
                cell.btnImageCount.setTitle(ttle,for: .normal)
                if ttle == "0"{
                    cell.btnImageCount.isHidden = true
                } else {
                    cell.btnImageCount.isHidden = false
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: {
        })
    }
    /******************************************************************************************************/
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: {
            
        })
    }
    // MARK:  Save Image in PE Module
    private func saveImageInPEModule(imageData:Data){
        let imageCount = getImageCountInPEModule()
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().saveImageInPEModule(assessment: assessment!, imageId: imageCount+1, imageData: imageData)
    }
    
    // MARK: Get Image Count In PE Module
    func getImageCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "imageId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK:  Save DOA in PE Module
    private func saveDOAInPEModule(inovojectData:InovojectData) -> Int{

        let imageCount = getDOACountInPEModule()
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().saveDOAPEModule(assessment: assessment!, doaId: imageCount+1,inovojectData: inovojectData)
        return imageCount+1
        
    }
    // MARK:  Save Inovoject in PE Module
    private func saveInovojectInPEModule(inovojectData:InovojectData) -> Int{
        
        let imageCount = getDOACountInPEModule()
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().saveInovojectPEModule(assessment: assessment!, doaId: imageCount+1,inovojectData: inovojectData)
        return imageCount+1
        
    }
    // MARK:  Save vaccine Mixture in PE Module
    private func saveVMixerInPEModule(peCertificateData:PECertificateData) -> Int{
        
        let imageCount = getVMixerCountInPEModule()
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().saveVMixerPEModule(assessment: assessment!, id: imageCount+1, peCertificateData: peCertificateData)
        return imageCount+1
        
    }
    
    // MARK:  get DOA Count in PE Module
    func getDOACountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DayOfAge")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "doaId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK:  Get Vaccine Mixture Count in PE Module
    func getVMixerCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VMixer")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "vmid") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK:  Delete DOA Data in PE Module
    private func deleteDOAInPEModule(id:Int) {
        
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().updateDOAMinusCategortIsSelcted(assessment: assessment!, doaId: id)
        
    }
    // MARK:  Delete Inovoject Data in PE Module
    private func deleteInovojectInPEModule(id:Int) {
        
        var assessment = catArrayForTableIs[tableviewIndexPath.row] as? PE_AssessmentInProgress
        CoreDataHandlerPE().updateInovojectMinusCategortIsSelcted(assessment: assessment!, doaId: id)
        
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


extension PEViewAssesmentFinalize{
    // MARK: Change date Fromate
    func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "MMM d, yyyy"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd"
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }
        return ""
    }
    
    // MARK: - Date Formatter
    func convertSign_DateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "MMM d, yyyy"
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }
        return ""
    }
    
    
    
    // MARK:  Create Sync Request for Refregerator Data
    func createSyncRequestRefrigator(dictArray: PE_Refrigators) -> JSONDictionary{
        let userId = UserDefaults.standard.integer(forKey: "Id")
        let f = dictArray.value
        let s = NSString(format: "%.2f", f ?? "")
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        let value = Double((s ) as Substring) as? NSNumber
        let json = [
            "Id": 0,
            "AssessmentId": dictArray.schAssmentId ?? 0 ,
            "AssessmentDetailId": dictArray.id ?? 0 ,
            "RefValue": value ?? 0.0,
            "RefUnit": dictArray.unit ?? "",
            "IsNa": dictArray.isNA ?? false,
            "IsCheck": dictArray.isCheck ?? false,
            "UserId": userId ?? 0,
            "CreatedAt": "2023-01-31T14:57:39.582Z"
        ] as JSONDictionary
        return json
    }
    
    func detectDateFormat(of dateString: String) -> String? {
        // List of common date formats to check
        let dateFormats = [
            "yyyy-MM-dd",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "dd-MM-yyyy",
            "yyyy/MM/dd",
            "MMMM d, yyyy",
            "MMM dd, yyyy"
            
        ]
        
        for format in dateFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            // Try to parse the string into a Date object
            if let _ = dateFormatter.date(from: dateString) {
                return format // Return the matching format
            }
        }
        
        return nil // Return nil if no format matches
    }
    
    
    // MARK: Create Sync Request for Assessement
    func createSyncRequest(dict: PENewAssessment ,certificationData : [PECertificateData]) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dict.dataToSubmitID ?? ""
        
        let evaluationDate = dict.evaluationDate
        if UniID == "" {
            UniID = dict.draftID ?? ""
        }
        var Complete = 1
        var Draft = 0
        var SaveType = 1
        saveTypeString.append(11)
        var AssessmentId = dict.dataToSubmitNumber ?? 0
        
        let deviceIdForServer = "\(UniID)_1_iOS_\(udid)"
        deviceIDFORSERVER = deviceIdForServer
        
        if AssessmentId == 0 {
            if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
                deviceIDFORSERVER = dict.assDetail2 ?? ""
            }
            AssessmentId = dict.draftNumber ?? 0
            Draft = 1
            Complete = 0
            SaveType = 0
            saveTypeString.append(00)
        }
        if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
            deviceIDFORSERVER = dict.assDetail2 ?? ""
        }
        var serverAssessmentId:Int64 = 0
        if dict.serverAssessmentId != nil{
            serverAssessmentId = Int64( dict.serverAssessmentId ?? "") ?? 0
        }
        let DocId = ""
        let VisitId = dict.visitID
        let CustomerId = dict.customerId
        let countryID = dict.countryID
        let SiteId = dict.siteId
        let IncubationStyle = dict.incubation
        let EvaluationId = dict.evaluationID
        var EvaluationDate = ""
        let EvaulaterId = dict.evaluatorID
        var hacheryAntibiotics:Bool = false
        if dict.hatcheryAntibiotics == 1{
            hacheryAntibiotics = true
        }
    
        var  TSRId  = dict.selectedTSRID
        
        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
        let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray ()
        let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray ()
        if dict.selectedTSR?.count ?? 0 > 0 {
            if visitNameArray.contains(dict.selectedTSR ?? ""){
                let indexOfe =  visitNameArray.index(of: dict.selectedTSR ?? "") //
                TSRId = visitIDArray[indexOfe] as? Int ?? 0
            }
        }
        
        let HatchAnti = false
        var Camera = false
        if  dict.camera == 1 {
            Camera = true
        }
        
        var man = dict.manufacturer  ?? ""
        var manOther =  ""
        if  man != "" {
            if let character = dict.manufacturer?.character(at:0) {
                if character == "S"{
                    let str =  man.replacingOccurrences(of: "S", with: "")
                    manOther = str
                    man = "Other"
                }
            }
        }
        var eggg = ""
        var egggOther =  ""
        let xx = String(dict.noOfEggs ?? 000)
        if xx != "0" {
            let last3 = String(xx.suffix(3))
            if last3 ==  "000" {
                let str =  xx.replacingOccurrences(of: "000", with: "")
                egggOther = str
                eggg = "Other"
            } else {
                eggg = xx
            }
        }
        
        var breeedd = dict.breedOfBird  ?? ""
        var breeeddOther =  ""
        if breeedd != "" {
            if let character = breeedd.character(at:0) {
                if character == "S".character(at: 0){
                    let str =  breeedd.replacingOccurrences(of: "S", with: "")
                    breeeddOther = str
                    breeedd = "Other"
                    
                }
            }
        }
        breeeddOther = dict.breedOfBirdOther ?? ""
        
        var ManufacturerId = 0
        var EggID = 0
        var breeddId = 0
        
        var manufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Manufacturer")
        var manufacutrerNameArray = manufacutrerDetailsArray.value(forKey: "mFG_Name") as? NSArray ?? NSArray()
        var manufacutrerIDArray = manufacutrerDetailsArray.value(forKey: "mFG_Id") as? NSArray ?? NSArray()
        if man != "" {
            let indexOfd = manufacutrerNameArray.index(of: man) // 3
            ManufacturerId = manufacutrerIDArray[indexOfd] as? Int ?? 0
        }
        
        var BirdBreedDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_BirdBreed")
        var BirdBreedNameArray = BirdBreedDetailsArray.value(forKey: "birdBreedName") as? NSArray ?? NSArray()
        var BirdBreedIDArray = BirdBreedDetailsArray.value(forKey: "birdId") as? NSArray ?? NSArray()
        if breeedd != "" {
            let indexOfe = BirdBreedNameArray.index(of: breeedd) // 3
            breeddId = BirdBreedIDArray[indexOfe] as? Int ?? 0
        }
    
        let EggsDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Eggs")
        var EggsNameArray = EggsDetailsArray.value(forKey: "eggCount") as? NSArray ?? NSArray()
        var EggsIDArray = EggsDetailsArray.value(forKey: "eggId") as? NSArray ?? NSArray()
        if eggg != "" {
            let indexOfp = EggsNameArray.index(of: eggg) // 3
            EggID = EggsIDArray[indexOfp] as? Int ?? 0
        }
        
        let FlockAgeId = dict.isFlopSelected
        let Status_Type = dict.statusType ?? 0
        let UserId = dict
            .userID
        let RepresentativeName = ""
        let Notes = dict.notes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY HH:mm:ss Z"
        let date = dict.evaluationDate?.toDate(withFormat: "MM/dd/YYYY")
        var dateSig = ""
        let ddd = dict.sig_Date ?? ""
        if ddd != "" {
            dateSig = self.convertDateFormat(inputDate: ddd)
        }
        
        
        let sig_Nametext2 = dict.sig_Name2
        let sig_Nametext = dict.sig_Name
        let sig_Phonetext = dict.sig_Phone
        let sig_EmployeeIDtext = dict.sig_EmpID
        let sig_EmployeeIDtext2 = dict.sig_EmpID2
        let sigNumber = dict.sig ?? 0
        let sigNumber2 = dict.sig2 ?? 0
        
        var base64Str = ""
        var base64Str2 = ""
        if sigNumber == 0 {
        } else {
            base64Str = CoreDataHandlerPE().getImageBase64ByImageID(idArray:(dict.sig) ?? 0)
        }
        if sigNumber2 == 0 {
        } else {
            base64Str2 = CoreDataHandlerPE().getImageBase64ByImageID(idArray:(dict.sig2) ?? 0)
        }
        
        var DisplayId = dict.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        
        DisplayId = "C-" + UniID
        var iStle = 0
     
        let iStleDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_IncubationStyle")
        var iStleNameArray = iStleDetailsArray.value(forKey: "incubationStylesName") as? NSArray ?? NSArray()
        var iStleIDArray = iStleDetailsArray.value(forKey: "incubationId") as? NSArray ?? NSArray()
        if IncubationStyle?.count ?? 0 > 1 {
            let indexOfe = iStleNameArray.index(of: IncubationStyle ?? "") // 3
            iStle = iStleIDArray[indexOfe] as? Int ?? 0
        }
        var rollID = 0
    
        let rollDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Roles")
        var rollNameArray = rollDetailsArray.value(forKey: "roleName") as? NSArray ?? NSArray()
        var rollIDArray = rollDetailsArray.value(forKey: "roleId") as? NSArray ?? NSArray()
        if sig_EmployeeIDtext?.count ?? 0 > 1 {
            let indexOfe = rollNameArray.index(of: sig_EmployeeIDtext ?? "") // 3
            rollID = rollIDArray[indexOfe] as? Int ?? 0
        }
        
        var rollID2 = 0
        if sig_EmployeeIDtext2?.count ?? 0 > 1 {
            let indexOfe = rollNameArray.index(of: sig_EmployeeIDtext2 ?? "") // 3
            rollID2 = rollIDArray[indexOfe] as? Int ?? 0
        }
        
        var json : JSONDictionary = JSONDictionary()
        if dateSig != ""{
        }else{
            let convertDateFormatter = DateFormatter()
            convertDateFormatter.dateFormat = "yyyy-MM-dd"
            convertDateFormatter.timeZone = Calendar.current.timeZone
            convertDateFormatter.locale = Calendar.current.locale
        }
        let userInfo = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: dict.serverAssessmentId ?? "")
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
 
        var evalDateStr = ""
        if regionId == 3 {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yyyy"
            
            // Convert the string to a Date object
            if let date = inputFormatter.date(from: evaluationDate ?? "") {
                
                // Create another DateFormatter for the desired output format
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy-MM-dd"
                
                let formattedDateString = outputFormatter.string(from: date)
                evalDateStr = formattedDateString
            } else {
                print("Invalid date format")
            }
        }
        else
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            
            if let date = inputFormatter.date(from: evaluationDate ?? "") {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy-MM-dd"
                
                let formattedDateString = outputFormatter.string(from: date)
                evalDateStr = formattedDateString
            } else {
                print("Invalid date format")
            }
        }

        
        let inovoFluid : Bool
        let basicTransfer : Bool
        let countryIDSelc = dict.countryID
        inovoFluid = dict.fluid!
        basicTransfer = dict.basicTransfer!
        let isEMRequested = dict.IsEMRequested ?? false
        
        let handMix : Bool
        
        handMix = dict.isHandMix!
        let ppmValue = dict.ppmValue ?? ""
        var FSRsign = ""
        if certificationData.count > 0 {
            FSRsign = certificateData[0].fsrSign
        }
        if regionID == 3
        {
            json = [
                "AppAssessmentId":String(AssessmentId),
                "DisplayId":DisplayId?.prefix(22),
                "VisitId": VisitId,
                "CustomerId": CustomerId,
                "SiteId": SiteId,
                "IncubationStyle": iStle,
                "EvaluationId": EvaluationId,
                "BreedBirds": breeddId == 0 ? "" : breeddId,
                "EvaluationDate": evalDateStr,
                "EvaulaterId": EvaulaterId ?? 0,
                "TSRId": TSRId,
                "Camera": Camera,
                "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                "EggsPerFlat": EggID == 0 ? "" : EggID,
                "Notes": Notes,
                "Status_Type": Status_Type,
                "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                "SaveType":SaveType,
                "UserId": UserId,
                "DeviceId": deviceIDFORSERVER,
                "RepresentativeName":sig_Nametext,
                "RepresentativeName2":sig_Nametext2,
                "RepresentativeNotes":sig_Phonetext,
                "SignatureImage": base64Str,
                "SignatureImage2": base64Str2,
                "ManufacturerOther": manOther,
                "BreedOfBirdsOther": breeeddOther,
                "EggsPerFlatOther": egggOther,
                "RoleId":rollID,
                "RoleId2":rollID2 == 0 ? "" : rollID2,
                "EvaluationTypeText": dict.evaluationName,
                "AppCreationTime": UniID.prefix(22),
                "SignatureDate":dateSig,
                "AssessmentId":serverAssessmentId,
                "DoubleSanitation":hacheryAntibiotics,
                "SanitationEmbrex": dict.sanitationValue ?? false, //dict.extndMicro ?? false,
                "HasChlorineStrips" :  dict.isChlorineStrip ?? false,
                "FSTSignatureImage": FSRsign,
                "IsAutomaticFail" :  dict.isAutomaticFail ?? false,
                "IsEMRequested" : isEMRequested,
                "RefrigeratorNote": "",
                "RegionId" : regionId,
                "IsInterMicrobial": userInfo?.isExtendedPE ?? false,
                "CountryId":countryID,
                "IsInovoFluids": false,
                "IsBasicTrfAssessment" :  false,
                "ChlorineId" :  "",
                "Handmix" : handMix ?? false,
                "Chlorine_Value" : ppmValue
            ] as JSONDictionary
            return json
        }
        else
        {
            json = [
                "AppAssessmentId":String(AssessmentId),
                "DisplayId":DisplayId?.prefix(22),
                "VisitId": VisitId,
                "CustomerId": CustomerId,
                "SiteId": SiteId,
                "IncubationStyle": iStle,
                "EvaluationId": EvaluationId,
                "BreedBirds": breeddId == 0 ? "" : breeddId,
                "EvaluationDate": evalDateStr,
                "EvaulaterId": EvaulaterId ?? 0,
                "TSRId": TSRId,
                "Camera": Camera,
                "ManufacturerId": ManufacturerId == 0 ? "" : ManufacturerId,
                "EggsPerFlat": EggID == 0 ? "" : EggID,
                "Notes": Notes,
                "FlockAgeId": FlockAgeId == 0 ? "" : FlockAgeId,
                "SaveType":SaveType,
                "UserId": UserId,
                "DeviceId": deviceIDFORSERVER,
                "RepresentativeName":sig_Nametext,
                "RepresentativeName2":sig_Nametext2,
                "RepresentativeNotes":sig_Phonetext,
                "SignatureImage": base64Str,
                "SignatureImage2": base64Str2,
                "ManufacturerOther": manOther,
                "BreedOfBirdsOther": breeeddOther,
                "EggsPerFlatOther": egggOther,
                "RoleId":rollID,
                "RoleId2":rollID2 == 0 ? "" : rollID2,
                "EvaluationTypeText": dict.evaluationName,
                "AppCreationTime": UniID.prefix(22),
                "SignatureDate":dateSig,
                "AssessmentId":serverAssessmentId,
                "DoubleSanitation":hacheryAntibiotics,
                "SanitationEmbrex": false ,//userInfo?.isExtendedPE ?? false,
                "HasChlorineStrips" :  dict.isChlorineStrip ?? false,
                "IsAutomaticFail" :  dict.isAutomaticFail ?? false,
                "RefrigeratorNote": dict.refrigeratorNote ?? "",
                "RegionId" : regionId,
                "IsInterMicrobial": dict.extndMicro,
                "CountryId":countryIDSelc,
                "IsInovoFluids": inovoFluid,
                "IsBasicTrfAssessment" :  basicTransfer,
                "ChlorineId" : dict.clorineId ?? 0
            ] as JSONDictionary
            return json
        }
        
    }
    // MARK: Create Sync request for Inovoject Data
    func createSyncRequestForInvoject(dictArray: PENewAssessment,inovojectData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        
        var score = 0
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = inovojectData.invoHatchAntibiotic
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1 {
            HatcheryAntibiotics = true
        }
        
        var x = 0

        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if inovojectData.ampuleSize != "" {
            let xx = inovojectData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        
        var otherVaccine = ""
        var ManufacturerId = 0
      
        var VaccineId = 0
        var vNameDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        var vNameArray = vNameDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        var vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        if vNameArray.contains(inovojectData.vaccineMan){
            let indexOfe = vNameArray.index(of: inovojectData.vaccineMan) // 3
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
        } else {
            VaccineId = 0
        }

        var vNameDetailsArrayIS = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
        var vNameArrayIS = vNameDetailsArrayIS.value(forKey: "name") as? NSArray ?? NSArray()
        var vNameIDArrayIS = vNameDetailsArrayIS.value(forKey: "id") as? NSArray ?? NSArray()
        var vNameMfgIdArrayIS = vNameDetailsArrayIS.value(forKey: "mfgId") as? NSArray ?? NSArray()
        
        if vNameArrayIS.contains(inovojectData.name){
            let indexOfe = vNameArrayIS.index(of: inovojectData.name) // 3
            VaccineId = vNameIDArrayIS[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArrayIS[indexOfe] as? Int ?? 0
        } else if (inovojectData.name != ""){
            otherVaccine = inovojectData.name ?? ""
        }
        
        let DManufacturerId = 0
        var DNameArray = NSArray()
        var dManufacture = 0
        
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(inovojectData.id)_iOS_"
        
        let ampulePerBag = Int(inovojectData.ampulePerBag ?? "0")
        var AntibioticInformation  =  ""
        if HatcheryAntibiotics {
            AntibioticInformation =  inovojectData.invoHatchAntibioticText ?? ""
        }
        var json = [
            "VaccineId":  VaccineId == 0 ? "" : VaccineId,
            "AmpulePerbag":ampulePerBag == 0 ? "" : ampulePerBag,
            "AmpuleSize":  x == 0 ? "" : x,
            "AppAssessmentId": String(AssessmentId),
            "BagSizeType":inovojectData.bagSizeType,
            "Device_Id": deviceIDFORSERVER,
            "DiluentMfg": inovojectData.vaccineMan,
            "DisplayId": DisplayId?.prefix(22),
            "HatcheryAntibiotics": HatcheryAntibiotics,
            "ManufacturerId":  ManufacturerId == 0 ? "" : ManufacturerId,
            "ModuleAssessmentCatId": dictArray.catID,
            "Dosage": inovojectData.dosage,
            "StrUniqueId":unique,
            "OtherText":otherVaccine,
            "SecquenceId":0,
            "AntibioticInformation": AntibioticInformation,
            "DiluentsMfgOtherName":inovojectData.doaDilManOther ?? "",
            "ProgramName": inovojectData.invoProgramName,
            "AssessmentId":serverAssessmentId
            
        ] as JSONDictionary
        let doaDilManOther =  inovojectData.doaDilManOther ?? ""
        
        if doaDilManOther == "" {
            json.removeValue(forKey: "DiluentsMfgOtherName")
        }
        if ManufacturerId == 0  {
            json["ManufacturerId"] =  ManufacturerId == 0 ? "" : ManufacturerId
            json.removeValue(forKey: "ManufacturerId")
        }
        return json
        
    }
    // MARK: Create Sync request for DOA
    func createSyncRequestForDOA(dictArray: PENewAssessment,dayOfAgeData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = dictArray.hatcheryAntibioticsDoa
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1  {
            HatcheryAntibiotics = true
        }
        var x = 0

        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if dayOfAgeData.ampuleSize != "" {
            let xx = dayOfAgeData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        
        var VaccineId = 0
        var otherVaccine = ""
        var ManufacturerId = 0

        var vNameDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
        var vNameArray = vNameDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
        var vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        var vNameMfgIdArray = vNameDetailsArray.value(forKey: "mfgId") as? NSArray ?? NSArray()
        
        if vNameArray.contains(dayOfAgeData.name){
            let indexOfe =  vNameArray.index(of: dayOfAgeData.name)
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArray[indexOfe] as? Int ?? 0
        } else if (dayOfAgeData.name != ""){
            otherVaccine = dayOfAgeData.name ?? ""
        }
 
        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if vManufacutrerNameArray.contains(dayOfAgeData.vaccineMan){
            let indexOfe =  vManufacutrerNameArray.index(of: dayOfAgeData.vaccineMan) //
            ManufacturerId = vManufacutrerIDArray[indexOfe] as? Int ?? 0
        }
        
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(dayOfAgeData.id)_iOS_"
        let ampulePerBag = Int(dayOfAgeData.ampulePerBag ?? "0")
        
        var AntibioticInformation  =  ""
        if HatcheryAntibiotics {
            AntibioticInformation =  dictArray.hatcheryAntibioticsDoaText ?? ""
            
        }
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let json = [
            "AppAssessmentId": String(AssessmentId),
            "DayOfAgeAmpulePerbag": ampulePerBag == 0 ? "" : ampulePerBag,
            "DayOfAgeAmpuleSize":  x == 0 ? "" : x,
            "DayOfAgeBagSizeType": dictArray.dDT,
            "DayOfAgeMfgId":  ManufacturerId == 0 ? "" : ManufacturerId,
            "DayOfAgeMfgNameId":  VaccineId == 0 ? "" : VaccineId,
            "DayOfBagHatcheryAntibiotics": HatcheryAntibiotics,
            "Device_Id": deviceIDFORSERVER,
            "DiluentMfg": dictArray.dCS,
            "DisplayId": DisplayId?.prefix(22),
            "ModuleAssessmentCatId": dictArray.catID,
            "DayOfAgeDosage": dayOfAgeData.dosage,
            "StrUniqueId":unique,
            "OtherText":otherVaccine,
            "SecquenceId":0,
            "AntibioticInformation":AntibioticInformation,
            "AssessmentId":serverAssessmentId
            
        ] as JSONDictionary
        return json
        
    }
    // MARK: Create Sync Request for DOAS
    func createSyncRequestForDOAS(dictArray: PENewAssessment,dayOfAgeData :InovojectData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let  HatcheryAntibioticsInt = dictArray.hatcheryAntibioticsDoaS
        
        var HatcheryAntibiotics = false
        if HatcheryAntibioticsInt == 1  {
            HatcheryAntibiotics = true
        }
        var x = 0
 
        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
        if dayOfAgeData.ampuleSize != "" {
            let xx = dayOfAgeData.ampuleSize?.replacingOccurrences(of: " ", with: "")
            let indexOfe =  ampleSizeesNameArray.index(of: xx)
            x = ampleSizeIDArray[indexOfe] as? Int  ?? 0
        }
        var VaccineId = 0
        var otherVaccine = ""
        var ManufacturerId = 0

        var vNameDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
        var vNameArray = vNameDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
        var vNameIDArray = vNameDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        var vNameMfgIdArray = vNameDetailsArray.value(forKey: "mfgId") as? NSArray ?? NSArray()
        if vNameArray.contains(dayOfAgeData.name){
            let indexOfe =  vNameArray.index(of: dayOfAgeData.name) //
            VaccineId = vNameIDArray[indexOfe] as? Int ?? 0
            ManufacturerId = vNameMfgIdArray[indexOfe] as? Int ?? 0
        } else if (dayOfAgeData.name != ""){
            otherVaccine = dayOfAgeData.name ?? ""
        }
        
        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if vManufacutrerNameArray.contains(dayOfAgeData.vaccineMan){
            let indexOfe =  vManufacutrerNameArray.index(of: dayOfAgeData.vaccineMan) //
            ManufacturerId = vManufacutrerIDArray[indexOfe] as? Int ?? 0
        }
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(dayOfAgeData.id)_iOS_"
        var AntibioticInformation  =  ""
        
        if HatcheryAntibiotics {
            AntibioticInformation =  dictArray.hatcheryAntibioticsDoaSText ?? ""
        }
        let ampulePerBag = Int(dayOfAgeData.ampulePerBag ?? "0")
        var json = [
            
            "DayAgeSubcutaneousBagSizeType": dictArray.dDDT,
            "Device_Id": deviceIDFORSERVER,
            "DisplayId": DisplayId?.prefix(22) ?? "",
            "ModuleAssessmentCatId":  dictArray.catID ?? "",
            "StrUniqueId":unique,
            "SecquenceId": 0,
            "AppAssessmentId":  String(AssessmentId)] as JSONDictionary
        
        json["DayAgeSubcutaneousHatcheryAntibiotics"] = HatcheryAntibiotics
        json["DayAgeSubcutaneousMfgId"] =  ManufacturerId == 0 ? "" : ManufacturerId
        json["DayAgeSubcutaneousDosage"] = dayOfAgeData.dosage ?? ""
        json["DayAgeSubcutaneousMfgNameId"] =  VaccineId == 0 ? "" : VaccineId;
        json["OtherText"] =  otherVaccine
        json["DayAgeSubcutaneousDiluentMfg"] =   dictArray.dDCS
        json["DayAgeSubcutaneousAmpuleSize"] =   x == 0 ? "" : x
        json["DayAgeSubcutaneousAmpulePerbag"] =  ampulePerBag == 0 ? "" : (ampulePerBag ?? 0)
        json["AntibioticInformation"] =  AntibioticInformation
        json["AssessmentId"] = serverAssessmentId
        return json
        
    }
    // MARK: Create Synce Request for Certificate Data
    func createSyncRequestForCertificateData(dictArray: PENewAssessment,peCertificateData :PECertificateData) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(peCertificateData.id)_iOS_"
        
        var resultString = String()
        if(regionID != 3){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.date(from: peCertificateData.certificateDate ?? "")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if date != nil {
                resultString = dateFormatter.string(from: date ?? Date())
                
            } else {
                resultString =  ""
            }
        }
        else{
            resultString = peCertificateData.certificateDate ?? ""
        }
        
        
        if regionID == 3 {
            let json = [
                "Id": AssessmentId,
                "AssessmentId": serverAssessmentId,//AssessmentId,
                "AssessmentDetailId": AssessmentId,
                "ModuleAssessmentId": 0,
                "Name": peCertificateData.name,
                "CertificationDate": resultString,
                "AlternateName": "string",
                "CertificationDate2": "2020-05-23T06:36:50.915Z",
                "ModuleAssessmentCatId":  dictArray.catID,
                "userId": dictArray.userID,
                "DeviceId": deviceIDFORSERVER,
                "ResidueName": dictArray.residue,
                "MicroSamplesName": dictArray.micro,
                "EvaluationTypeId": 1,
                "AppAssessmentId": String(AssessmentId),
                "DisplayId": DisplayId?.prefix(22),
                "StrUniqueId":unique,
                "VacOperatorId": peCertificateData.vacOperatorId ?? 0,
                "IsCertiExpired": peCertificateData.isCertExpired,
                "IsRecert": peCertificateData.isReCert,
                "SignatureImg": peCertificateData.signatureImg ?? ""
            ] as JSONDictionary
            return json
            
        }
        else
        {
            let json = [
                "Id": AssessmentId,
                "AssessmentId": serverAssessmentId,//AssessmentId,
                "AssessmentDetailId": AssessmentId,
                "ModuleAssessmentId": 0,
                "Name": peCertificateData.name,
                "CertificationDate": resultString,
                "AlternateName": "string",
                "CertificationDate2": "2020-05-23T06:36:50.915Z",
                "ModuleAssessmentCatId":  dictArray.catID,
                "userId": dictArray.userID,
                "DeviceId": deviceIDFORSERVER,
                "ResidueName": dictArray.residue,
                "MicroSamplesName": dictArray.micro,
                "EvaluationTypeId": 1,
                "AppAssessmentId": String(AssessmentId),
                "DisplayId": DisplayId?.prefix(22),
                "StrUniqueId":unique,
                "SignatureImg": peCertificateData.signatureImg ?? ""
            ] as JSONDictionary
            return json
        }
        
    }
    // MARK: Create Sync Request for Residue Data
    func createSyncRequestForResidueData(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var serverAssessmentId: Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(dictArray.residue)_iOS_"
        
        let json = [
            "AssessmentId": serverAssessmentId,
            "AssessmentDetailId": dictArray.assID ?? 0,
            "StrUniqueId": unique,
            "ModuleAssessmentId": dictArray.catID,
            "ResidueName":dictArray.residue,
            "MicroSamplesName": dictArray.micro,
            "EvaluationTypeId": 1,
            "AppAssessmentId": String(AssessmentId),
            "DisplayId": DisplayId?.prefix(22),
            "UserId": dictArray.userID,
            "CreatedAt": "2020-06-11T12:53:38.930Z",
            "DeviceId": deviceIDFORSERVER,
            "ModuleAssessmentCatId": dictArray.catID
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: Create Sync Request for Micro Data
    func createSyncRequestForMicroData(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        let timestamp = Date().currentTimeMillis()
        let unique = "\(deviceIDFORSERVER)_\(dictArray.micro)_iOS_"
        
        let json = [
            "Id": AssessmentId,
            "AssessmentId": serverAssessmentId,
            "AssessmentDetailId": dictArray.assID ?? 0,
            "ModuleAssessmentId": 0,
            "Name": "",
            "CertificationDate": "",
            "AlternateName": "string",
            "CertificationDate2": "2020-05-23T06:36:50.915Z",
            "ModuleAssessmentCatId":  dictArray.catID,
            "userId": dictArray.userID,
            "DeviceId": deviceIDFORSERVER,
            "ResidueName": dictArray.residue,
            "MicroSamplesName": dictArray.micro,
            "EvaluationTypeId": 1,
            "AppAssessmentId": String(AssessmentId),
            "DisplayId": DisplayId?.prefix(22),
            "StrUniqueId":unique
        ] as JSONDictionary
        return json
        
    }
    // MARK: Get Assessments Status Check
    func getAssessmentStatusCheck(assessmentId: String){
        
        if peNewAssessment.IsEMRequested == false && synWebBtn.currentTitle == "Finish Extended Microbial"
        {
            self.syncExtendedMicrobial()
        }
        else
        {
            ZoetisWebServices.shared.checkAssessment(controller: self, assessmentId: assessmentId, parameters: [:], completion: { [weak self] (json, error) in
                let data = json["Data"].arrayValue.map {  PEStatus($0) }
                let status = data[0].IsStatus
                if status ?? false{
                    self?.showAlert(title: "Already approved", message: "Assessment can not be updated as its already approved", owner: self!)
                }else{
                    self?.syncBtnTapped(showHud: true)
                }
            })
        }
        
    }
    
    // MARK: Sync Functionality
	/// 19- June-2025: As per the communication with Binu and Imran - Data sync to web will be not saved on server if asessment is already approved, We are getting API success 200 to escape from error popup.
    func syncBtnTapped(showHud: Bool){
        if self.submitExtend == true && self.categoarylabelText != "Extended Microbial" {
            let alert = UIAlertController(title: "Alert!", message: "Please finish Extended Microbial first or turn off the switch in order to sync the other data",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            if !extendedMicroSwitch.isHidden{
                if self.submitExtend == true {
                    self.peNewAssessment.IsEMRequested = true
                    self.syncExtendedMicrobial()
                }
                else {
                    self.peNewAssessment.IsEMRequested = false
                }
            }
        }
        
        if peNewAssessment.IsEMRequested == true {
            CoreDataHandlerPE().updateOfflineIsEMRequested(isEMRequested: true)
        }
        else
        {
            CoreDataHandlerPE().updateOfflineIsEMRequested(isEMRequested: false)
        }
        
        
        if ConnectionManager.shared.hasConnectivity() {
            var inovojectDataArr : [JSONDictionary]  = []
            var dayOfAgeDataArr : [JSONDictionary]  = []
            var dayOfAgeSDataArr : [JSONDictionary]  = []
            var certificateDataArr : [JSONDictionary]  = []
            var vaccineMicroSamplesDataArr : [JSONDictionary]  = []
            var vaccineResidueMoldsDataArr : [JSONDictionary]  = []
            var refrigratorDataArr : [JSONDictionary]  = []
            
            
            if(regionID != 3){
                refrigratorDataArr.removeAll()
                var assId  = UserDefaults.standard.value(forKey: "currentServerAssessmentId")
                let refriArray = CoreDataHandlerPE().getOfflineREfriData(id: Int(assId as! String) ?? 0)
                for objn in  refriArray {
                    if objn != nil {
                        let data = self.createSyncRequestRefrigator(dictArray: objn)
                        refrigratorDataArr.append(data)
                    }
                }
            }
            self.showGlobalProgressHUDWithTitle(self.view, title: "Data syncing...")
            
            dayOfAgeSData.removeAll()
            if peNewAssessment.doaS.count > 0 {
                var idArr : [Int] = []
                for objn in  peNewAssessment.doaS {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                dayOfAgeSData.append(data!)
                            }
                        }
                    }
                }
            }
            
            dayOfAgeData.removeAll()
            if peNewAssessment.doa.count > 0 {
                var idArr : [Int] = []
                for objn in  peNewAssessment.doa {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                            //   // // print("already there",idArr)
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                dayOfAgeData.append(data!)
                            }
                        }
                    }
                }
            }
            inovojectData.removeAll()
            if peNewAssessment.inovoject.count > 0 {
                var idArr : [Int] = []
                for objn in  peNewAssessment.inovoject {
                    let data = CoreDataHandlerPE().getPEDOAData(doaId: objn)
                    if data != nil {
                        if idArr.contains(data!.id ?? 0){
                        }else{
                            idArr.append(data!.id ?? 0)
                            if data != nil{
                                inovojectData.append(data!)
                            }
                        }
                    }
                }
            }
            certificateData.removeAll()
            if peNewAssessment.vMixer.count > 0 {
                var idArr : [Int] = []
                for objn in  peNewAssessment.vMixer {
                    let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
                    if idArr.contains(data!.id ?? 0){
                    }else{
                        idArr.append(data!.id ?? 0)
                        if data != nil{
                            certificateData.append(data!)
                            
                        }
                    }
                }
            }
            tempArr.removeAll()
            let json = createSyncRequest(dict: peNewAssessment, certificationData: certificateData)
            tempArr.append(json)
            
            if inovojectData.count > 0 {
                for item in inovojectData {
                    let json = createSyncRequestForInvoject(dictArray: peNewAssessment, inovojectData: item)
                    inovojectDataArr.append(json)
                }
            }
            if dayOfAgeData.count > 0 {
                for item in dayOfAgeData {
                    let json = createSyncRequestForDOA(dictArray: peNewAssessment, dayOfAgeData: item)
                    dayOfAgeDataArr.append(json)
                }
            }
            if dayOfAgeSData.count > 0 {
                for item in dayOfAgeSData {
                    let json = createSyncRequestForDOAS(dictArray: peNewAssessment, dayOfAgeData: item)
                    dayOfAgeSDataArr.append(json)
                }
            }
            if certificateData.count > 0 {
                for item in certificateData {
                    let json = createSyncRequestForCertificateData(dictArray: peNewAssessment, peCertificateData: item)
                    certificateDataArr.append(json)
                }
            }
            if peNewAssessment.evaluationID == 2 {
                let json = createSyncRequestForResidueData(dictArray: peNewAssessment)
                vaccineResidueMoldsDataArr.append(json)
            }
            if peNewAssessment.evaluationID == 2 {
                let json = createSyncRequestForMicroData(dictArray: peNewAssessment)
                vaccineMicroSamplesDataArr.append(json)
            }
            var AssessmentId = Int(self.peNewAssessment.serverAssessmentId ?? "0") ?? 0
            if AssessmentId == 0 {
                AssessmentId = self.peNewAssessment.dataToSubmitNumber ?? 0
            }
            var paramForDoaInnovoject = JSONDictionary()
            if( regionID != 3 ){
                paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr,"RefrigeratorData":refrigratorDataArr,
                                         "DeviceId": deviceIDFORSERVER,"AssessmentDetailsId" :AssessmentId] as JSONDictionary
            }
            else{
                paramForDoaInnovoject = ["InovojectData":inovojectDataArr,"DayOfAgeData":dayOfAgeDataArr,"DayAgeSubcutaneousDetailsData":dayOfAgeSDataArr,"VaccineMixerObservedData":certificateDataArr,"VaccineResidueMoldsData":vaccineResidueMoldsDataArr,"VaccineMicroSamplesData":vaccineMicroSamplesDataArr,
                                         "DeviceId": deviceIDFORSERVER,"AssessmentDetailsId" :AssessmentId] as JSONDictionary
            }
            var idArr = [String]()
            for val in tempArr{
                let id = val["AssessmentId"] as? Int64 ?? 0
                if id != 0{
                    idArr.append("\(id)")
                }
            }
            var arr = [PESanitationDTO]()
            for id in idArr{
                let tempPEArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.sendExtendedPEFilledDTO(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: id)
                arr.append(contentsOf: tempPEArr)
            }
            
            var param = ["AssessmentData":tempArr,"appVersion":Bundle.main.versionNumber,"IsSendEmail":"false"] as JSONDictionary
            
            self.convertDictToJson(dict: param,apiName: "add assessment")
            ZoetisWebServices.shared.sendPostDataToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
                if error != nil {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                }
                guard let `self` = self, error == nil else { return }
                
                if json["StatusCode"]  == 200{
                    
                    
                    self.callRequest2(paramForDoaInnovoject: paramForDoaInnovoject, json: json)
                } else {
                    self.dismissGlobalHUD(self.view)
                    self.showAlert(title: "Error", message: "Something went wrong in Assessment sync. Please try again.", owner: self)
                }
            })
        }
    }
    
    // MARK: ------------ Extended Micro Create Sync Request --------------
    func createSyncRequestForExtendedMicro(dict: PENewAssessment ,certificationData : [PECertificateData]) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dict.dataToSubmitID ?? ""
        
        var arr = [PESanitationDTO]()
        let ExtendedPEArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.sendExtendedPEFilledDTO(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment?.serverAssessmentId ?? "")
        arr.append(contentsOf: ExtendedPEArr)
        
        var extendedData : [[String: Any]]?
        let jsonEncoder = JSONEncoder()
        let jsonDataArr = try? jsonEncoder.encode(arr)
        if jsonDataArr != nil{
            extendedData = try! JSONSerialization.jsonObject(with: jsonDataArr!, options: []) as? [[String: Any]]
        }
        
        
        let evaluationDate = dict.evaluationDate
        if UniID == "" {
            UniID = dict.draftID ?? ""
        }
        var Complete = 1
        var Draft = 0
        var SaveType = 1
        saveTypeString.append(11)
        var AssessmentId = dict.dataToSubmitNumber ?? 0
        
        let deviceIdForServer = "\(UniID)_1_iOS_\(udid)"
        deviceIDFORSERVER = deviceIdForServer
        
        if AssessmentId == 0 {
            //  print("draft id id",dict.assDetail2 )
            if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
                deviceIDFORSERVER = dict.assDetail2 ?? ""
            }
            AssessmentId = dict.draftNumber ?? 0
            Draft = 1
            Complete = 0
            SaveType = 0
            saveTypeString.append(00)
        }
        if dict.assDetail2?.lowercased().contains("_1_ios") ?? false{
            deviceIDFORSERVER = dict.assDetail2 ?? ""
        }
        var serverAssessmentId:Int64 = 0
        if dict.serverAssessmentId != nil{
            serverAssessmentId = Int64( dict.serverAssessmentId ?? "") ?? 0
        }
        let DocId = ""
        let VisitId = dict.visitID
        let CustomerId = dict.customerId
        let SiteId = dict.siteId
        
        let EvaluationId = dict.evaluationID
        var EvaluationDate = ""
        
      
        let Status_Type = dict.statusType ?? 0
        let UserId = dict.userID
        let RepresentativeName = ""
      
        let dateFormatter = DateFormatter()
        
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        dateFormatter.dateFormat="MM/dd/YYYY"
        
        let date = dict.evaluationDate?.toDate(withFormat: "MM/dd/YYYY")
        var dateSig = ""
        let ddd = dict.sig_Date ?? ""
        if ddd != "" {
            dateSig = self.convertDateFormat(inputDate: ddd)
        }
        
        var DisplayId = dict.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        // dict.evaluationDate = dateSig
        
        var json : JSONDictionary = JSONDictionary()
        if dateSig != ""{
            dict.evaluationDate = dateSig
        }else {
            let convertDateFormatter = DateFormatter()
            convertDateFormatter.dateFormat = "yyyy-MM-dd"
            convertDateFormatter.timeZone = Calendar.current.timeZone
            convertDateFormatter.locale = Calendar.current.locale
        }
        if regionId == 3 {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yyyy"
            
            // Convert the string to a Date object
            if let date = inputFormatter.date(from: evaluationDate ?? "") {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy-MM-dd"
    
                dict.evaluationDate = evaluationDate
            } else {
                print("Invalid date format")
            }
        }
        else
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd/MM/yyyy"
            
            if let date = inputFormatter.date(from: evaluationDate ?? "") {
                
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy-MM-dd"
                dict.evaluationDate = evaluationDate
            } else {
                print("Invalid date format")
            }
        }
   
        let appVersion = "\(Bundle.main.versionNumber)"
        
        var saveType = 0
        if self.extendedMicroSwitch.isOn
        {
            saveType = 1
            self.peNewAssessment.IsEMRequested = true
            CoreDataHandlerPE().updateOfflineIsEMRequested(isEMRequested: true)
        }
        else
        {
            self.peNewAssessment.IsEMRequested = false
            CoreDataHandlerPE().updateOfflineIsEMRequested(isEMRequested: false)
            saveType = 0
        }
        
        tempArr.removeAll()
        
        json = [
            "AssessmentId":serverAssessmentId,
            "DeviceId": deviceIDFORSERVER,
            "UserId": UserId,
            "EvaluationId": EvaluationId ?? 0,
            "SaveType":saveType,
            "Status_Type": Status_Type,
            "IsEMRequested" : true,
            "IsSendEmail": true,
            "appVersion": appVersion,
            "SanitationEmbrexScoresDataModel":extendedData
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: ------------ Call Extended Micro Sync API --------------
    func callExtendedMicro(param:JSONDictionary){
        
        ZoetisWebServices.shared.sendExtendedMicroToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            
            guard let `self` = self, error == nil else { return }
            if json["StatusCode"]  == 200{
                
                self.dismissGlobalHUD(self.view)
                
                if self.extendedMicroSwitch.isHidden == false {
                    let errorMsg = "Your Extended Microbial Assessment has been submitted successfully."
                    let alertController = UIAlertController(title: "Success!", message: errorMsg, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                        if let nav = self.navigationController {
                            for controller in nav.viewControllers {
                                if controller.isKind(of: PEDashboardViewController.self) {
                                    nav.popToViewController(controller, animated: true)
                                    return // ✅ stop loop after popping
                                }
                            }
                        } else {
                            // Fallback if not inside navigation controller
                            self.dismiss(animated: true)
                        }
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } else {
              //  self.showAlert(title: "Error", message: "Something went wrong in Extended Micro data sync, Please try again.", owner: self)
                self.dismissGlobalHUD(self.view)
              
            }
        })
    }
    
    // MARK: Sync Button Action
    @IBAction func syncBtnAction(_ sender: Any) {
        if ConnectionManager.shared.hasConnectivity(){
            let errorMSg = "Are you sure, you want to sync the data?"
            let alertController = UIAlertController(title: "Data available", message: errorMSg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                _ in
                
                self.tempArr.removeAll()
                self.syncBtnTapped(showHud: true)
                // As per discussion with Imran and binu we have commented this code so that client can submit their assessment irsepective of their Assessment Approved or not.
              //  self.getAssessmentStatusCheck(assessmentId: self.peNewAssessment.serverAssessmentId ?? "")
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                _ in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
        }
    }
    
    // MARK: Post request for Score
    func createSyncRequestForScore(dictArray: PENewAssessment) -> JSONDictionary{
        var UniID = dictArray.dataToSubmitID ?? ""
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        var score = 0
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var TextAmPm = ""
        var PersonName = ""
        var FrequencyValue = 32
        var QCCount = ""
        var PPMValue = ""
        
        if dictArray.rollOut == "Y" && dictArray.sequenceNoo == 3 && dictArray.qSeqNo == 12
        {
            QCCount =  dictArray.qcCount ?? ""
        } else if dictArray.rollOut == "Y" && dictArray.catName == "Miscellaneous"
        {
            TextAmPm =  dictArray.ampmValue ?? ""
        }
        else if  dictArray.rollOut == "Y" && dictArray.sequenceNoo == 5  && dictArray.qSeqNo == 5
                    
        {
            PPMValue =  dictArray.ppmValue ?? ""              }
        
        else if dictArray.rollOut == "Y" && dictArray.sequenceNoo == 3 && dictArray.qSeqNo == 1
        {
            PersonName =  dictArray.personName ?? ""
            let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
            let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
            let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
            if dictArray.frequency?.count ?? 0 > 0 {
                if visitNameArray.contains(dictArray.frequency ?? ""){
                    let indexOfe =  visitNameArray.index(of: dictArray.frequency ?? "")
                    FrequencyValue = visitIDArray[indexOfe] as? Int ?? 0
                }
            }
        }
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        if regionId == 3 {
            let json = [
                "DisplayId":DisplayId?.prefix(22) ?? "",
                "AppAssessmentId": String(AssessmentId),
                "ModuleAssessmentId": dictArray.assID ??  0,
                "AssessmentScore": score,
                "UserId": dictArray.userID ?? 0,
                "Device_Id": deviceIDFORSERVER,
                "QCCount":QCCount,
                "PersonName":PersonName,
                "FrequencyValue": FrequencyValue == 32 ? "" : FrequencyValue,
                "TextAmPm":TextAmPm,
                "AssessmentId": serverAssessmentId,
                "SequenceNo":dictArray.sequenceNoo ?? 0,
                "MaxScore":dictArray.assMaxScore ?? 0,
                "Chlorine_Value": PPMValue,
                "isNA":dictArray.isNA ?? false
            ] as JSONDictionary
            return json
            
        }
        else
        {
            let json = [
                "DisplayId":DisplayId?.prefix(22) ?? "",
                "AppAssessmentId": String(AssessmentId),
                "ModuleAssessmentId": dictArray.assID ??  0,
                "AssessmentScore": score,
                "UserId": dictArray.userID ?? 0,
                "Device_Id": deviceIDFORSERVER,
                "QCCount":QCCount,
                "PersonName":PersonName,
                "FrequencyValue": FrequencyValue == 32 ? "" : FrequencyValue,
                "TextAmPm":TextAmPm,
                "AssessmentId": serverAssessmentId,
                "SequenceNo":dictArray.sequenceNoo ?? 0,
                "MaxScore":dictArray.assMaxScore ?? 0,
                "isNA":dictArray.isNA ?? false
            ] as JSONDictionary
            return json
            
        }
    }
    
    // MARK: Create Sync Request for Comment
    func createSyncRequestForComment(dictArray: PENewAssessment) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }

        var score = 0
        
        if  dictArray.assStatus == 1 {
            score = dictArray.assMaxScore ?? 0
        } else {
            score = dictArray.assMinScore ?? 0
        }
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        DisplayId = "C-" + UniID
        
        var serverAssessmentId:Int64 = 0
        if let id = dictArray.serverAssessmentId{
            serverAssessmentId = Int64(id ?? "") ?? 0
        }
        
        let json = [
            "DisplayId":DisplayId?.prefix(22) ?? "",
            "AppAssessmentId":  String(AssessmentId),
            "ModuleAssessmentId": dictArray.assID ?? 0,
            "Comment": dictArray.note ?? "",
            "UserId": dictArray.userID ?? 0,
            "ModuleId": 1,
            "DeviceId":deviceIDFORSERVER,
            "AssessmentId":serverAssessmentId
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: Handle Sync Response
    private func handleSyncResponse(_ json: JSON) {
        
        let sNumber = peNewAssessment.dataToSubmitNumber ?? 0
        let dNumber = peNewAssessment.draftNumber ?? 0
        var  getOfflineArray : [PENewAssessment] = []
        var  getDraftArray : [PENewAssessment] = []
        if sNumber != 0 {
            getOfflineArray = CoreDataHandlerPE().getOfflineAssessmentArray(id:peNewAssessment.dataToSubmitID ?? "" )
        }
        if dNumber != 0 {
            getDraftArray = CoreDataHandlerPE().getDraftAssessmentArray(id:peNewAssessment.draftNumber ?? 0)
        }
        callRequest4Int = 0
        
        totalImageToSync = []
        
        if getOfflineArray.count > 0 {
            var carColIdArray : [Int] = []
            var catArray : [PENewAssessment] = []
            var catAllRowArray : [PENewAssessment] = []
            for cat in getOfflineArray {
                if !carColIdArray.contains(cat.sequenceNo ?? 0){
                    carColIdArray.append(cat.sequenceNo ?? 0)
                    catArray.append(cat)
                }
            }
            for objCt in catArray{
                let catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatID(objCt.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber:peNewAssessment.dataToSubmitNumber as NSNumber? ?? 0) as? [PENewAssessment] ?? []
                
                catAllRowArray.append(contentsOf: catArrayForTableIs)
            }
            var ScoreDataArr : [JSONDictionary]  = []
            var comntArray : [JSONDictionary]  = []
            var imgArray : [JSONDictionary]  = []
            imgArray.removeAll()
            for objCtIs in catAllRowArray {
                let json = createSyncRequestForScore(dictArray: objCtIs)
                let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                ScoreDataArr.append(json)
                comntArray.append(jsonComment)
            }
            let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":ScoreDataArr] as JSONDictionary
            self.callRequest3(param:param)
            
        }
        
        if getDraftArray.count > 0 {
            var carColIdArray : [Int] = []
            var catArray : [PENewAssessment] = []
            var catAllRowArray : [PENewAssessment] = []
            for cat in getDraftArray {
                if !carColIdArray.contains(cat.sequenceNo ?? 0){
                    carColIdArray.append(cat.sequenceNo ?? 0)
                    catArray.append(cat)
                }
            }
            for objCt in catArray{
                var catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatIDDraft(objCt.sequenceNo as NSNumber? ?? 0,draftNumber:peNewAssessment  .draftNumber as? NSNumber ?? 0) as? [PENewAssessment] ?? []
                
                catAllRowArray.append(contentsOf: catArrayForTableIs)
            }
            var tempArr : [JSONDictionary]  = []
            var comntArray : [JSONDictionary]  = []
            for objCtIs in catAllRowArray {
                let json = createSyncRequestForScore(dictArray: objCtIs)
                let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                tempArr.append(json)
                comntArray.append(jsonComment)
            }
            let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":tempArr] as JSONDictionary
            self.callRequest3(param:param)
        }
    }
    
    // MARK: Post Request for DOA Data
    func callRequest2(paramForDoaInnovoject:JSONDictionary,json:JSON){
        let mjson = json
        self.convertDictToJson(dict: paramForDoaInnovoject,apiName: "add inovoject and day of age")
        ZoetisWebServices.shared.sendAddDayOfAgeAndInvoject(controller: self, parameters: paramForDoaInnovoject, completion: { [weak self] (json, error) in
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let `self` = self, error == nil else { return }
            
            if json["StatusCode"]  == 200{
                self.handleSyncResponse(mjson)
                
            } else {
                self.dismissGlobalHUD(self.view)
                self.showAlert(title: "Error", message: "Something went wrong in Vaccination sync, Please try again.", owner: self)
            }
        })
    }
    
    // MARK: Post Request for Score Data
    func callRequest3(param:JSONDictionary){
        self.convertDictToJson(dict: param,apiName: "add score")
        ZoetisWebServices.shared.sendScoresDataToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
            if error != nil {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let `self` = self, error == nil else { return }
            if json["StatusCode"]  == 200{
                self.CalculateImageCount()
            } else {
                self.dismissGlobalHUD(self.view)
                self.showAlert(title: "Error", message: "Something went wrong in Score sync, Please try again.", owner: self)
            }
        })
    }
    
    // MARK: Post Request for Images Data of Assessment
    func createSyncRequestForImage(dictArray: PENewAssessment,img:Int) -> JSONDictionary{
        
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")!
        var UniID = dictArray.dataToSubmitID ?? ""
        
        if UniID == "" {
            UniID = dictArray.draftID ?? ""
        }
        
        var AssessmentId = dictArray.dataToSubmitNumber ?? 0
        if AssessmentId == 0 {
            AssessmentId = dictArray.draftNumber ?? 0
        }
        let deviceIdForServer = "\(UniID)_\(AssessmentId)_iOS_\(udid)"
        var DisplayId = dictArray.evaluationDate
        DisplayId = DisplayId?.replacingOccurrences(of: "/", with: "")
        var siteId = String(dictArray.siteId ?? 0)
        DisplayId = "C-" + UniID
        let base64Str = CoreDataHandlerPE().getImageBase64ByImageID(idArray:img)
        totalImageToSync.append(img)
        let imageName = "ImgName-" + siteId + String(img ?? 0)
        let unique = "\(deviceIDFORSERVER)_\(String(img ?? 0))_iOS_"
     
        let json = [
            "DisplayId":DisplayId,
            "Id": AssessmentId,
            "AssessmentDetailId": AssessmentId,
            "ModuleAssessmentId": dictArray.assID ?? 0,
            "Comment": dictArray.note,
            "UserId": dictArray.userID ?? 0,
            "CreatedAt": "2020-05-08T13:51:26.02701Z",
            "ModuleId": 1,
            "CommentTypeId": 1,
            "DeviceId":deviceIDFORSERVER,
            "ImageBase64String":base64Str,
            "FolderPath": "",
            "ImageName": imageName,
            "StrUniqueId":unique,
            "AssessmentId":deviceIdForServer
        ] as JSONDictionary
        return json
        
    }
    
    // MARK: Calculate Images Count
    func CalculateImageCount(){
        
        let sNumber = peNewAssessment.dataToSubmitNumber ?? 0
        let dNumber = peNewAssessment.draftNumber ?? 0
        var  getOfflineArray : [PENewAssessment] = []
        var  getDraftArray : [PENewAssessment] = []
        if sNumber != 0 {
            getOfflineArray = CoreDataHandlerPE().getOfflineAssessmentArray(id:peNewAssessment.dataToSubmitID ?? "" )
            CoreDataHandlerPE().updateOfflineStatus(assessment: peNewAssessment)
        }
        if dNumber != 0 {
            getDraftArray = CoreDataHandlerPE().getDraftAssessmentArray(id:peNewAssessment.draftNumber ?? 0)
        }
        callRequest4Int = 0
        
        totalImageToSync = []
        
        if getOfflineArray.count > 0 {
            var carColIdArray : [Int] = []
            var catArray : [PENewAssessment] = []
            var catAllRowArray : [PENewAssessment] = []
            for cat in getOfflineArray {
                if !carColIdArray.contains(cat.sequenceNo ?? 0){
                    carColIdArray.append(cat.sequenceNo ?? 0)
                    catArray.append(cat)
                }
            }
            for objCt in catArray{
                let catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatID(objCt.sequenceNo as NSNumber? ?? 0,dataToSubmitNumber:peNewAssessment.dataToSubmitNumber as NSNumber? ?? 0) as? [PENewAssessment] ?? []
                
                catAllRowArray.append(contentsOf: catArrayForTableIs)
            }
            var tempArr : [JSONDictionary]  = []
            var comntArray : [JSONDictionary]  = []
            var imgArray : [JSONDictionary]  = []
            
            for objCtIs in catAllRowArray {
                let json = createSyncRequestForScore(dictArray: objCtIs)
                let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                for i in objCtIs.images{
                    let status = CoreDataHandlerPE().imageAlreadySyncStatus(imageId: i) as? Bool ?? false
                    if status {
                        
                    } else {
                        let jsonIMages = createSyncRequestForImage(dictArray: objCtIs,img:i)
                        imgArray.append(jsonIMages)
                    }
                }
                tempArr.append(json)
                comntArray.append(jsonComment)
            }
            let param = ["AssessmentCommentsData":comntArray,"AssessmentScoreData":tempArr] as JSONDictionary
            var arrayCount  = 0
            var imgDic :  [JSONDictionary] = []
            
            if imgArray.count > 3 {
                for objimgr in imgArray{
                    arrayCount  = arrayCount + 1
                    imgDic.append(objimgr)
                    if arrayCount == 3  {
                        let ss  = imgDic as?  [JSONDictionary]  ?? []
                        var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                        arrayCount  = 0
                        imgDic.removeAll()
                        self.callRequest4(paramForImages:paramForImages)
                    }
                }
                if  arrayCount > 0 {
                    let ss  = imgDic as?  [JSONDictionary]  ?? []
                    var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                    arrayCount  = 0
                    imgDic.removeAll()
                    self.callRequest4(paramForImages:paramForImages)
                }
            } else {
                var  paramForImages  = ["AssessmentImages":imgArray] as JSONDictionary
                self.callRequest4(paramForImages:paramForImages)
            }
            
        }
        
        if getDraftArray.count > 0 {
            var carColIdArray : [Int] = []
            var catArray : [PENewAssessment] = []
            var catAllRowArray : [PENewAssessment] = []
            for cat in getDraftArray {
                if !carColIdArray.contains(cat.sequenceNo ?? 0){
                    carColIdArray.append(cat.sequenceNo ?? 0)
                    catArray.append(cat)
                }
            }
            for objCt in catArray{
                var catArrayForTableIs = CoreDataHandlerPE().fetchCustomerForSyncWithCatIDDraft(objCt.sequenceNo as NSNumber? ?? 0,draftNumber:peNewAssessment.draftNumber as? NSNumber ?? 0) as? [PENewAssessment] ?? []
                
                catAllRowArray.append(contentsOf: catArrayForTableIs)
            }
            var tempArr : [JSONDictionary]  = []
            var comntArray : [JSONDictionary]  = []
            var imgArray : [JSONDictionary]  = []
            
            for objCtIs in catAllRowArray {
                let json = createSyncRequestForScore(dictArray: objCtIs)
                let jsonComment = createSyncRequestForComment(dictArray: objCtIs)
                for i in objCtIs.images{
                    let status = CoreDataHandlerPE().imageAlreadySyncStatus(imageId: i) as? Bool ?? false
                    if status {
                        
                    } else {
                        let jsonIMages = createSyncRequestForImage(dictArray: objCtIs,img:i)
                        imgArray.append(jsonIMages)
                    }
                }
                tempArr.append(json)
                comntArray.append(jsonComment)
                
            }
            let param = ["AssessmentScoreData":tempArr,"AssessmentCommentsData":comntArray] as JSONDictionary
            var arrayCount  = 0
            var imgDic :  [JSONDictionary] = []
            
            if imgArray.count > 3 {
                for objimgr in imgArray{
                    arrayCount  = arrayCount + 1
                    imgDic.append(objimgr)
                    if arrayCount == 3  {
                        let ss  = imgDic as?  [JSONDictionary]  ?? []
                        var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                        arrayCount  = 0
                        imgDic.removeAll()
                        self.callRequest4(paramForImages:paramForImages)
                    }
                }
                if  arrayCount > 0 {
                    let ss  = imgDic as?  [JSONDictionary]  ?? []
                    var  paramForImages  = ["AssessmentImages":ss] as JSONDictionary
                    arrayCount  = 0
                    imgDic.removeAll()
                    self.callRequest4(paramForImages:paramForImages)
                }
            } else {
                var  paramForImages  = ["AssessmentImages":imgArray] as JSONDictionary
                self.callRequest4(paramForImages:paramForImages)
            }
            
        }
    }
    
    // MARK: Get Off Line Saved Assessments from DB
    func getAllAssessmentInOfflineFromDb() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDFor(entityName: "PE_AssessmentInOffline")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
        
        var carColIdArrayDraft : [Int] = []
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArrayDraft.contains(obj as? Int ?? 0){
                carColIdArrayDraft.append(obj as? Int ?? 0)
            }
        }
        let allAssesmentOffArr = CoreDataHandlerPE().fetchDetailsWithUserIDFor(entityName: "PE_AssessmentInDraft")
        let carColIdArrayOffNumbers  = allAssesmentOffArr.value(forKey: "draftNumber") as? NSArray ?? []
        var carColIdArrayOff : [Int] = []
        for obj in carColIdArrayOffNumbers {
            if !carColIdArrayOff.contains(obj as? Int ?? 0){
                carColIdArrayOff.append(obj as? Int ?? 0)
            }
        }
        let syncCount = carColIdArrayOff.count
        let syncCount2 = carColIdArrayDraft.count
        return syncCount + syncCount2
    }
    
    // MARK: Call Request for images
    func callRequest4(paramForImages:JSONDictionary){
        callRequest4Int = callRequest4Int + 1
        ZoetisWebServices.shared.sendMultipleImagesBase64ToServer(controller: self, parameters: paramForImages, completion: { [weak self] (json, error) in
            self?.callRequest4Int = self!.callRequest4Int - 1
            
            if error != nil {
                let syncArr = self?.getAllAssessmentInOfflineFromDb()
                if syncArr ?? 0 > 0{
                    self?.syncBtnTapped(showHud: false)
                } else {
                    self?.showtoast(message: "Data synced successfully.")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                }
            }
            guard let `self` = self, error == nil else { return }
            if json["StatusCode"]  == 200{
                if self.saveTypeString.contains(11)
                {
                    if self.saveTypeString.contains(00) {
                        CoreDataHandlerPE().updateDraftStatus(assessment: self.peNewAssessment)
                    }
                    CoreDataHandlerPE().updateOfflineStatus(assessment: self.peNewAssessment)
                } else {
                    CoreDataHandlerPE().updateDraftStatus(assessment: self.peNewAssessment)
                }
                if ConnectionManager.shared.hasConnectivity() {
                    
                    if self.callRequest4Int == 0 {
                        
                        if regionID == 3
                        {
                            if peNewAssessment.IsEMRequested == true {
                                self.syncExtendedMicrobial()
                            }
                        }
                        
                        let syncArr = self.getAllAssessmentInOfflineFromDb()
                        if syncArr > 0{
                            
                            self.showtoast(message: "Data synced successfully.")
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                            self.dismissGlobalHUD(self.view)
                            self.syncBtnTapped(showHud: true)
                            
                        } else {
                            for i in self.totalImageToSync{
                                CoreDataHandlerPE().setImageStatusTrue(idArray: i)
                            }
                            
                            self.showtoast(message: "Data synced successfully.")
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
                            self.dismissGlobalHUD(self.view)
                        }
                    }
                }
            } else {
                self.dismissGlobalHUD(self.view)
            }
            
        })
    }
    
    // MARK: Sync Extended Microbial
    func syncExtendedMicrobial ()
    {
        var extendedMicroArr : [JSONDictionary]  = []
        
        self.showGlobalProgressHUDWithTitle(self.view, title: "Data syncing...")
        
        certificateData.removeAll()
        if peNewAssessment.vMixer.count > 0 {
            var idArr : [Int] = []
            for objn in  peNewAssessment.vMixer {
                let data = CoreDataHandlerPE().getCertificateData(doaId: objn)
                if idArr.contains(data!.id ?? 0){
                }else{
                    idArr.append(data!.id ?? 0)
                    if data != nil{
                        certificateData.append(data!)
                        
                    }
                }
            }
        }
        
        let jsonExtendedMicro = self.createSyncRequestForExtendedMicro(dict: peNewAssessment, certificationData: self.certificateData)
        extendedMicroArr.append(jsonExtendedMicro)
        let ExtendedMicroparam = ["ExtendedMicrobialData":extendedMicroArr] as JSONDictionary
    //    self.convertDictToJson(dict: ExtendedMicroparam,apiName: "Assessment_AddEMAssessment")
        self.callExtendedMicro(param: ExtendedMicroparam)
        
    }
    
}


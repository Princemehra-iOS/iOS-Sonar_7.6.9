//
//  PVEDraftSNAssessment.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 22/03/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON
class PVEDraftSNAssessment: BaseViewController {
    
    let sharedManager = PVEShared.sharedInstance
    
    @IBOutlet weak var headerView: UIView!
    var peHeaderViewController:PEHeaderViewController!
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    private var breedOfBirdsArray : [String] = []
    private var farmNameArr = [[String:Any]]()
    
    @IBOutlet weak var viewForGradient: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    var assesssmentCellHeight : CGFloat = 435.0
    
    var currentTimeStamp = ""
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        setupHeader()
        setupUI()
        
    }
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: currentTimeStamp)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        peHeaderViewController.onGoingSessionView.isHidden = true
        peHeaderViewController.syncView.isHidden = true
        
        
        tblView.reloadData()
        
        if  let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell
        {
            self.reloadCellUI(cell: cell)
        }
        tblView.reloadData()
        
    }
    
    func setupUI(){
        btnNext.setNextButtonUI()
        btnNext.titleLabel?.textColor = .white
        tblView.backgroundView = nil
        tblView.backgroundView?.backgroundColor = .clear
        
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Draft Assessment"
        
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    func generateSeveyNumber(dateStr:String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.MMddyyyyStr
        let siteId = sharedManager.getSessionValueForKeyFromDB(key: "siteId") as? Int ?? 0
        let evaluationDateStr = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
        let savedDateString = evaluationDateStr?.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        let generatedServeyNo = "S-" + savedDateString! + "\(siteId)"
        return generatedServeyNo
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func action_SyncToWeb(_ sender: Any) {
        let errorMSg = "Are you sure, you want to sync this session data to web?"
        let alertController = UIAlertController(title: "PVE", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.singleDataSync()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func singleDataSync(){
        
        if ConnectionManager.shared.hasConnectivity() {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: PVEDashboardViewController.self) {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "forceSync"),object: nil, userInfo:["id": currentTimeStamp]))
                    Constants.syncToWebTapped = true
                    self.navigationController!.popToViewController(controller, animated: true)
                }
            }
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
        } 
    }
    
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}


extension PVEDraftSNAssessment: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return self.assesssmentCellHeight
        case 1:
            return 250
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DraftStartNewAssignmentCell", for: indexPath) as! StartNewAssignmentCell
            cell.selectionStyle = .none
            cell.timeStampStr = currentTimeStamp
            cell.customerTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
            cell.siteIdTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
            
            cell.evaluationDateTxtfield.text = getDraftValueForKey(key: "evaluationDate") as? String
            cell.accManagerTxtfield.text = getDraftValueForKey(key: "accountManager") as? String
            cell.breedOfBirdsTxtfield.text = getDraftValueForKey(key: "breedOfBirds") as? String
            cell.breedOfBirdsFemaleTxtfield.text = getDraftValueForKey(key: "breedOfBirdsFemale") as? String
            cell.housingTxtfield.text = getDraftValueForKey(key: "housing") as? String
            cell.evaluationForTxtfield.text = getDraftValueForKey(key: "evaluationFor") as? String
            cell.breedOfBirdsOtherTxtfield.text = getDraftValueForKey(key: "breedOfBirdsOther") as? String
            cell.breedOfBirdsFemaleOtherTxtfield.text = getDraftValueForKey(key: "breedOfBirdsFemaleOther") as? String
            cell.farmNameTxtfield.text = getDraftValueForKey(key: "farm") as? String
            cell.houseNoTxtfield.text = getDraftValueForKey(key: "houseNumber") as? String
            cell.noOfBirdsTxtfield.text = "\(getDraftValueForKey(key: "noOfBirds"))"
            cell.evaluatorTxtfield.text = getDraftValueForKey(key: "evaluator") as? String
            cell.ageOfBirdsTxtfield.text = "\(getDraftValueForKey(key: "ageOfBirds"))"
            
            if getDraftValueForKey(key: "noOfBirds") as! Int == 0 {
                cell.noOfBirdsTxtfield.text = ""
            }
            if getDraftValueForKey(key: "ageOfBirds") as! Int == 0 {
                cell.ageOfBirdsTxtfield.text = ""
            }
            
            let cameraState = getDraftValueForKey(key: "cameraEnabled") as? String
            if cameraState == "true"{
                cell.switchBtn.isOn = true
                // cell.cameraImg.alpha  = 1.0
            }else{
                cell.switchBtn.isOn = false
                // cell.cameraImg.alpha  = 0.5
            }
            
            cell.selectButton()
            
            cell.backgroundColor = UIColor.clear
            
            //    }
            return cell
        }
            
        default: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.addNote_StartNewAssCell, for: indexPath) as! AddNote_StartNewAssCell
            //cell.notetxtView.text = getValueFromDB(key: "notes")
            // cell.notetxtView.layer.borderColor = UIColor.black.cgColor
            cell.notetxtView.textContainer.lineFragmentPadding = 12
            cell.selectionStyle = .none
            cell.timeStampStr = currentTimeStamp
            cell.notetxtView.text = getDraftValueForKey(key: "notes") as? String
            
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}


//  MARK:------------------------------Button Action and Set Values in Fields-----------------

extension PVEDraftSNAssessment{
    
    @IBAction func evaluationDateBtnAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.isPVE = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    @IBAction func customerBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Customer_PVE")
        let namesArray = array.value(forKey: "customerName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.customer, dropDownArr: namesArray)
    }
    
    @IBAction func evaluationForBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_EvaluationFor")
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.evaluationFor, dropDownArr: namesArray)
    }
    
    @IBAction func siteIdBtnAction(_ sender: UIButton) {
        
        let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
        let arr = dataArr.value(forKey: "customerId") as! NSArray
        let custId = arr[0] as? Int ?? 0
        
        let namesArray = CoreDataHandlerPVE().fetchCustomerWithCustId( custId as NSNumber)
        let siteNameArr = namesArray.value(forKey: "complexName") as? NSArray ?? NSArray()
        
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.siteId, dropDownArr: siteNameArr as? [String])
    }
    
    @IBAction func accountManagerBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssignUserDetails")
        let namesArray = array.value(forKey: "fullName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.accountManager, dropDownArr: namesArray)
    }
    
    @IBAction func evaluatorBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Evaluator")
        let namesArray = array.value(forKey: "fullName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.evaluationDetails, dropDownArr: namesArray)
    }
    
    @IBAction func breedOfBirdsBtnAction(_ sender: UIButton) {
        let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
        let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 1)
        
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.breedOfBirds, dropDownArr: namesArray)
    }
    
    @IBAction func breedOfBirdsFemaleBtnAction(_ sender: UIButton) {
        
        let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
        let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 2)
        
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.breedOfBirdsFemale, dropDownArr: namesArray)
    }
    
    @IBAction func ageOfBirdsBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AgeOfBirds")
        let namesArray = array.value(forKey: "age") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.ageOfBirds, dropDownArr: namesArray)
    }
    
    @IBAction func housingBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Housing")
        let namesArray = array.value(forKey: "housingName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.housing, dropDownArr: namesArray)
    }
    
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?){
        
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField)
                self.tblView.reloadData()
                self.tblView.reloadInputViews()
            }
            self.dropHiddenAndShow()
        } else {
            print(appDelegateObj.testFuntion())
        }
        
        let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: currentTimeStamp)
        print("dataSavedInDB-----\(dataSavedInDB)")
        
    }
    
    func setValueInTextFields(selectedValue: String, selectedIndex: Int, clickedField:String) {
        
        if  let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell
        {
            switch clickedField {
            case Constants.ClickedFieldStartNewAssPVE.customer:do {
                
                cell.customerTxtfield.text = selectedValue
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Customer_PVE")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "customerId") as! Int
                let customerName = (array.object(at: selectedIndex) as AnyObject).value(forKey: "customerName") as! String
                
                CoreDataHandlerPVE().updateUserInfoSavedInDB(customerName, forAttribute: "customer")
                CoreDataHandlerPVE().updateUserInfoSavedInDB(id, forAttribute: "customerId")
                
                CoreDataHandlerPVE().updateUserInfoSavedInDB("", forAttribute: "complexName")
                CoreDataHandlerPVE().updateUserInfoSavedInDB(0, forAttribute: "complexId")
                
            }
            case Constants.ClickedFieldStartNewAssPVE.housing:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Housing")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "housingId") as! Int
                
                self.setBorderBlue(btn: cell.housingBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "housingId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "housing")
                
            }
            case Constants.ClickedFieldStartNewAssPVE.ageOfBirds:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AgeOfBirds")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.ageOfBirdsBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "ageOfBirdsId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "ageOfBirds")
                
            }
            case Constants.ClickedFieldStartNewAssPVE.breedOfBirds:do {
                
                let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
                
                let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 1)
                
                
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.breedOfBirdsBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsOtherBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "breedOfBirds")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "breedOfBirdsId")
                
                self.reloadCellUI(cell: cell)
                
            }
            case Constants.ClickedFieldStartNewAssPVE.breedOfBirdsFemale:do {
                
                //let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_BreedOfBirds")
                
                let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
                
                let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 2)
                
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleOtherBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "breedOfBirdsFemale")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "breedOfBirdsFemaleId")
                
                self.reloadCellUI(cell: cell)
                
            }
                
            case Constants.ClickedFieldStartNewAssPVE.accountManager:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssignUserDetails")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.accManagerBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "accountManagerId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "accountManager")
            }
            case Constants.ClickedFieldStartNewAssPVE.siteId:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Complex_PVE")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "complexId") as! Int
                
                CoreDataHandlerPVE().updateUserInfoSavedInDB(selectedValue, forAttribute: "complexName")
                CoreDataHandlerPVE().updateUserInfoSavedInDB(id, forAttribute: "complexId")
                
                let customerStr = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
                let customerId = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customerId")
                
                CoreDataHandlerPVE().saveCustomerComplexDetailsPoupInDB(customerStr!, customerId: customerId as! Int, complexName: selectedValue, complexId: id)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "")
                
            }
            case Constants.ClickedFieldStartNewAssPVE.evaluationFor:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_EvaluationFor")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.evaluationForBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsOtherBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleOtherBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "evaluationFor")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "evaluationForId")
                
                self.assesssmentCellHeight = 455.0
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: "", forAttribute: "breedOfBirds")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: 0, forAttribute: "breedOfBirdsId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: "", forAttribute: "breedOfBirdsFemale")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: 0, forAttribute: "breedOfBirdsFemaleId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: "", forAttribute: "breedOfBirdsOther")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: "", forAttribute: "breedOfBirdsFemaleOther")
                
                self.reloadCellUI(cell: cell)
                
            }
            case Constants.ClickedFieldStartNewAssPVE.evaluationType:do {
                
                
            }
            case Constants.ClickedFieldStartNewAssPVE.evaluationDetails:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Evaluator")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.evaluatorBtn)
                
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: id, forAttribute: "evaluatorId")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: selectedValue, forAttribute: "evaluator")
                
            }
                
            default:
                do {print(appDelegateObj.testFuntion())}
            }
        }
        
    }
    
    func reloadCellUI(cell:StartNewAssignmentCell)  {
        
        let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: currentTimeStamp)
        
        let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        if evaluationForId == 4 {
            cell.breesOfBirdsTitleLbl.text = "Breed of Birds*"
            cell.breesOfBirdsSuperView.isHidden = true
        }
        else if evaluationForId == 5 {
            cell.breesOfBirdsTitleLbl.text = "Breed of Birds (Male)"
            cell.breesOfBirdsSuperView.isHidden = false
        }
        
        
        var viewHeight : CGFloat = 0
        let viewX : CGFloat = cell.frame.size.width - cell.cameraToggleSuperView.frame.size.width
        
        if evaluationForId == 4{
            
            self.assesssmentCellHeight = 435.0
            viewHeight = 170 + 60 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        if evaluationForId == 4 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 65 + 45 + 5
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        
        if evaluationForId == 5 {
            
            viewHeight = 170
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String != "Other" {
            self.assesssmentCellHeight = 435.0
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirdsFemale") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        
        self.setupOtherFields(cell: cell)
        
    }
    
    
    func setupOtherFields(cell:StartNewAssignmentCell) {
        
        cell.breesOfBirdsFemaleOtherSuperView.isHidden = true
        
        let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: currentTimeStamp)
        
        let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        
        if evaluationForId == 4 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
            
        }else if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
        }else{
            cell.breesOfBirdsMaleOtherSuperView.isHidden = true
        }
        
        
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirdsFemale") as? String == "Other"  {
            cell.breesOfBirdsFemaleOtherSuperView.isHidden = false
        }else{
            cell.breesOfBirdsFemaleOtherSuperView.isHidden = true
        }
        
    }
    
    func getTodayDateSring() -> String {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)
        return DateInFormat
    }
    
    
    func setBorderBlueForCalender(btn:UIButton) {
        let superviewCurrent =  btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self),view == btn {
                view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
            }
        }
    }
    
    func setBorderBlue(btn:UIButton) {
        let superviewCurrent =  btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self),view == btn {
                view.setDropdownStartAsessmentView(imageName:"dd")
            }
        }
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        checkValidation()
    }
}

// MARK: - Other Delegates -------------Date Picker Delegate------------------

extension PVEDraftSNAssessment: DatePickerPopupViewControllerProtocol{
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        
        let isDateExistInDB = checkDateInDB(dateStr: string)
        
        if !isDateExistInDB.0 {
            if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StartNewAssignmentCell {
                cell.evaluationDateTxtfield.text = string
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: string, forAttribute: "evaluationDate")
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: objDate, forAttribute: "objEvaluationDate")
                self.setBorderBlueForCalender(btn: cell.evaluationDateBtn)
                let generatedServeyNo = generateSeveyNumber(dateStr: string)
                CoreDataHandlerPVE().updateDraftSNAFor(currentTimeStamp, syncedStatus: false, text: generatedServeyNo, forAttribute: "serveyNo")
                tblView.reloadData()
            }
        } else {
            showAlert(title: Constants.alertStr, message: "Assessment already exists for the customer, complex and date. Please try another one.", owner: self)
        }
    }
    
    func checkDateInDB(dateStr:String) -> (Bool, String) {
        
        var isDateExistInDB = Bool()
        var dateExistInRelatedDB = String()
        
        let valueePVE_Sync = CoreDataHandlerPVE().fetchDetailsForSyncDataForSync(syncId: currentTimeStamp)
        let dateCreatedArr = valueePVE_Sync.value(forKey: "evaluationDate") as! NSArray
        if dateCreatedArr.count > 0 { // Atleast one was returned
            for (indx, _) in dateCreatedArr.enumerated() {
                if dateStr == dateCreatedArr[indx] as! String {
                    isDateExistInDB = true
                    dateExistInRelatedDB = "Sync"
                }
            }
        }
        
        return (isDateExistInDB,dateExistInRelatedDB)
    }
    
    
    func doneButtonTapped(string:String) {
        print("doneButtonTapped")
    }
}


extension PVEDraftSNAssessment {
    
    private func setBorderRedForMandatoryFiels(forBtn:UIButton) {
        
        let superviewCurrent =  forBtn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self) {
                view.layer.borderColor = UIColor.red.cgColor
                view.layer.borderWidth = 2.0
            }
        }
    }
    
    fileprivate func textfieldValidation(_ evaluationForId: Int, _ cell: StartNewAssignmentCell) {
        if (evaluationForId == 5 && cell.breedOfBirdsFemaleTxtfield.text?.count == 0) || (evaluationForId == 0 && cell.breedOfBirdsFemaleTxtfield.text?.count == 0) || (cell.breedOfBirdsFemaleTxtfield.text?.count == 0) {
            setBorderRedForMandatoryFiels(forBtn: cell.breedOfBirdsFemaleBtn)
        }
        if (evaluationForId == 5 && cell.breedOfBirdsFemaleOtherTxtfield.text?.count == 0 && cell.breesOfBirdsMaleOtherSuperView.isHidden == false){
            setBorderRedForMandatoryFiels(forBtn: cell.breedOfBirdsFemaleOtherBtn)
        }
        if (evaluationForId == 5 && cell.breesOfBirdsMaleOtherSuperView.isHidden == false && cell.breedOfBirdsOtherTxtfield.text?.count == 0) || (evaluationForId == 4 && cell.breedOfBirdsOtherTxtfield.text?.count == 0 && cell.breesOfBirdsMaleOtherSuperView.isHidden == false) {
            setBorderRedForMandatoryFiels(forBtn: cell.breedOfBirdsOtherBtn)
        }
    }
    
    fileprivate func pveValidation(_ cell: StartNewAssignmentCell, _ evaluationForId: Int) {
        if cell.customerTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.customerBtn)
        }
        if cell.evaluationDateTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.evaluationDateBtn)
        }
        
        if cell.noOfBirdsTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.noOfBirdsBtn)
        }
        
        if cell.evaluatorTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.evaluatorBtn)
        }
        if cell.siteIdTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.siteIdBtn)
        }
        
        if cell.evaluationForTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.evaluationForBtn)
        }
        if cell.accManagerTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.accManagerBtn)
        }
        
        if cell.breedOfBirdsTxtfield.text?.count == 0 {
            setBorderRedForMandatoryFiels(forBtn: cell.breedOfBirdsBtn)
        }
        
        textfieldValidation(evaluationForId, cell)
        showAlert(title: Constants.alertStr, message: Constants.pleaseEnterMandatoryFields, owner: self)
    }
    
    private func checkValidationnn() -> Bool {
        if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell {
            let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: currentTimeStamp)
            var evaluationForId = Int()
            if dataSavedInDB.count > 0 {
                let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
                evaluationForId = arr[0] as! Int
            } else {
                evaluationForId = 0
            }
            if cell.evaluationDateTxtfield.text?.count == 0 || cell.evaluatorTxtfield.text?.count == 0 || cell.siteIdTxtfield.text?.count == 0 || cell.customerTxtfield.text?.count == 0 || cell.evaluationForTxtfield.text?.count == 0 || cell.accManagerTxtfield.text?.count == 0 || cell.breedOfBirdsTxtfield.text?.count == 0 {
                pveValidation(cell, evaluationForId)
            }
        }
        return true
    }

    func checkValidation() {
        if checkValidationnn(),
           let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell {
            let isDateExistInDB = checkDateInDB(dateStr: cell.evaluationDateTxtfield.text ?? "")
            if !isDateExistInDB.0 {
                let currentSyncedStatus = getDraftValueForKey(key: "syncedStatus") as! Bool
                UserDefaults.standard.set(currentSyncedStatus, forKey: "syncedStatus")
                let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PVEDraftSNAFinalizeAssement") as! PVEDraftSNAFinalizeAssement
                vc.currentTimeStamp = currentTimeStamp
                navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlert(title: Constants.alertStr, message: "Assessment already exists for the customer, complex and date. Please try another one.", owner: self)
                setBorderRedForMandatoryFiels(forBtn: cell.evaluationDateBtn)
            }
        }
    }
}

//
//  PVEStartNewAssessment.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 11/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
class PVEStartNewAssessment: BaseViewController {
    
    let sharedManager = PVEShared.sharedInstance
    @IBOutlet weak var bgView: GradientButton!
    
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
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap1.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap1)
        
        setupHeader()
        setupUI()
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        peHeaderViewController.onGoingSessionView.isHidden = true
        peHeaderViewController.syncView.isHidden = true
        
        
        let dateSaved = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
        if dateSaved == "" {
            
            let getCurrentDate = self.getTodayDateSring()
            CoreDataHandlerPVE().updateSessionDetails(1, text: getCurrentDate, forAttribute: "evaluationDate")
            
            let todaysDate = NSDate()
            CoreDataHandlerPVE().updateSessionDetails(1, text: todaysDate, forAttribute: "objEvaluationDate")
            
            let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_EvaluationFor")
            let namesArray = array.value(forKey: "name") as! [String]
            let idArray = array.value(forKey: "id") as! [Int]
            CoreDataHandlerPVE().updateSessionDetails(1, text: namesArray[0], forAttribute: "evaluationFor")
            CoreDataHandlerPVE().updateSessionDetails(1, text: idArray[0], forAttribute: "evaluationForId")
            
        }
        
        tblView.reloadData()
        
        if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell
        {
            self.reloadCellUI(cell: cell)
        }
        tblView.reloadData()
        
    }
    
    func setupUI(){
        
        tblView.backgroundView = nil
        tblView.backgroundView?.backgroundColor = .clear
        
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Start New Assessment"
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    func generateSeveyNumber(dateStr:String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.MMddyyyyStr
        let siteId = sharedManager.getSessionValueForKeyFromDB(key: "siteId") as! Int
        let evaluationDateStr = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
        let savedDateString = evaluationDateStr?.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        let generatedServeyNo = "S-" + savedDateString! + "\(siteId)"
        return generatedServeyNo
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}

extension PVEStartNewAssessment: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return  self.assesssmentCellHeight
        case 1:
            return  250
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.startNewAssignmentCell, for: indexPath) as! StartNewAssignmentCell
            cell.selectionStyle = .none
            
            cell.customerTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
            cell.siteIdTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
            
            
            let valuee = CoreDataHandlerPVE().fetchCurrentSessionInDB()
            if valuee.count > 0{
                
                cell.evaluationDateTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
                cell.accManagerTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "accountManager") as? String
                cell.breedOfBirdsTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String
                cell.breedOfBirdsFemaleTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirdsFemale") as? String
                cell.housingTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "housing") as? String
                cell.evaluationForTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "evaluationFor") as? String
                cell.breedOfBirdsOtherTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirdsOther") as? String
                cell.breedOfBirdsFemaleOtherTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirdsFemaleOther") as? String
                cell.farmNameTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "farm") as? String
                cell.houseNoTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "houseNumber") as? String
                cell.noOfBirdsTxtfield.text = "\(sharedManager.getSessionValueForKeyFromDB(key: "noOfBirds"))"
                cell.evaluatorTxtfield.text = sharedManager.getSessionValueForKeyFromDB(key: "evaluator") as? String
                cell.ageOfBirdsTxtfield.text = "\(sharedManager.getSessionValueForKeyFromDB(key: "ageOfBirds"))"
                
                if sharedManager.getSessionValueForKeyFromDB(key: "noOfBirds") as! Int == 0 {
                    cell.noOfBirdsTxtfield.text = ""
                }
                if sharedManager.getSessionValueForKeyFromDB(key: "ageOfBirds") as! Int == 0 {
                    cell.ageOfBirdsTxtfield.text = ""
                }
                
                let cameraState = sharedManager.getSessionValueForKeyFromDB(key: "cameraEnabled") as? String
                if cameraState == "true"{
                    cell.switchBtn.isOn = true
                }else{
                    cell.switchBtn.isOn = false
                }
                
                cell.selectButton()
                
                cell.backgroundColor = UIColor.clear
                
            }
            return cell
        }
            
        default: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.addNote_StartNewAssCell, for: indexPath) as! AddNote_StartNewAssCell
            cell.notetxtView.textContainer.lineFragmentPadding = 12
            cell.selectionStyle = .none
            
            let valuee = CoreDataHandlerPVE().fetchCurrentSessionInDB()
            if valuee.count > 0{
                let arr = valuee.value(forKey: "notes")  as! NSArray
                cell.notetxtView.text = arr[0] as? String
            }
            
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

extension PVEStartNewAssessment{
    
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
        let custId = arr[0] as! Int
        
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
        
        let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
        let arr = dataArr.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        
        let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 1)
        
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.breedOfBirds, dropDownArr: namesArray)
    }
    
    @IBAction func breedOfBirdsFemaleBtnAction(_ sender: UIButton) {
        
        let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
        let arr = dataArr.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
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
            
        }
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
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "housingId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "housing")
                
            }
            case Constants.ClickedFieldStartNewAssPVE.ageOfBirds:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AgeOfBirds")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.ageOfBirdsBtn)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "ageOfBirdsId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "ageOfBirds")
                
                
            }
            case Constants.ClickedFieldStartNewAssPVE.breedOfBirds:do {
                
                let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
                let arr = dataArr.value(forKey: "evaluationForId") as! NSArray
                let evaluationForId = arr[0] as! Int
                
                let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 1)
                
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.breedOfBirdsBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsOtherBtn)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "breedOfBirds")
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "breedOfBirdsId")
                
                self.reloadCellUI(cell: cell)
                
            }
            case Constants.ClickedFieldStartNewAssPVE.breedOfBirdsFemale:do {
                
                let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
                let arr = dataArr.value(forKey: "evaluationForId") as! NSArray
                let evaluationForId = arr[0] as! Int
                
                let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 2)
                
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleBtn)
                self.setBorderBlue(btn: cell.breedOfBirdsFemaleOtherBtn)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "breedOfBirdsFemale")
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "breedOfBirdsFemaleId")
                
                self.reloadCellUI(cell: cell)
                
            }
                
            case Constants.ClickedFieldStartNewAssPVE.accountManager:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssignUserDetails")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.accManagerBtn)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "accountManagerId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "accountManager")
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
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "evaluationFor")
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "evaluationForId")
                
                self.assesssmentCellHeight = 455.0
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "breedOfBirds")
                CoreDataHandlerPVE().updateSessionDetails(1, text: 0, forAttribute: "breedOfBirdsId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "breedOfBirdsFemale")
                CoreDataHandlerPVE().updateSessionDetails(1, text: 0, forAttribute: "breedOfBirdsFemaleId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "breedOfBirdsOther")
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "breedOfBirdsFemaleOther")
                
                self.reloadCellUI(cell: cell)
                
            }
            case Constants.ClickedFieldStartNewAssPVE.evaluationType:do {
                
            }
            case Constants.ClickedFieldStartNewAssPVE.evaluationDetails:do {
                
                let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Evaluator")
                let id = (array.object(at: selectedIndex) as AnyObject).value(forKey: "id") as! Int
                
                self.setBorderBlue(btn: cell.evaluatorBtn)
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: id, forAttribute: "evaluatorId")
                CoreDataHandlerPVE().updateSessionDetails(1, text: selectedValue, forAttribute: "evaluator")
                
            }
                
            default:
                do {print(appDelegateObj.testFuntion())}
            }
        }
        
    }
    
    func reloadCellUI(cell:StartNewAssignmentCell)  {
        
        let dataSavedInDB =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
        
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
        if evaluationForId == 4 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String == "Other" {
            
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
        if evaluationForId == 5 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 5 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String != "Other" {
            self.assesssmentCellHeight = 435.0
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        
        if evaluationForId == 5 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirdsFemale") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        
        
        self.setupOtherFields(cell: cell)
        
    }
    
    
    func setupOtherFields(cell:StartNewAssignmentCell) {
        
        cell.breesOfBirdsFemaleOtherSuperView.isHidden = true
        
        let dataSavedInDB =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
        
        let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        
        if evaluationForId == 4 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
            
        }else if evaluationForId == 5 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
        }else{
            cell.breesOfBirdsMaleOtherSuperView.isHidden = true
        }
        
        
        if evaluationForId == 5 && sharedManager.getSessionValueForKeyFromDB(key: "breedOfBirdsFemale") as? String == "Other"  {
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
        
        if let text = sharedManager.getSessionValueForKeyFromDB(key: "housing") as? String, !text.isEmpty {
            print(appDelegateObj.testFuntion())
        } else {
            CoreDataHandlerPVE().updateSessionDetails(1, text: 0, forAttribute: "housingId")
            CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "housing")
        }
    }
}

// MARK: - Other Delegates -------------Date Picker Delegate------------------

extension PVEStartNewAssessment: DatePickerPopupViewControllerProtocol{
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        
        let isDateExistInDB = checkDateInDB(dateStr: string)
        
        if !isDateExistInDB.0 {
            
            if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell {
                ///-----dateCreated
                
                cell.evaluationDateTxtfield.text = string
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: string, forAttribute: "evaluationDate")
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: objDate, forAttribute: "objEvaluationDate")
                
                self.setBorderBlueForCalender(btn: cell.evaluationDateBtn)
                
                let generatedServeyNo = generateSeveyNumber(dateStr: string)
                CoreDataHandlerPVE().updateSessionDetails(1, text: generatedServeyNo, forAttribute: "serveyNo")
                tblView.reloadData()
            }
        } else {
            showAlert(title: Constants.alertStr, message: "Assessment already exists for the customer, complex and date. Please try another one.", owner: self)
            if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell {
                setBorderRedForMandatoryFiels(forBtn: cell.evaluationDateBtn)
            }
        }
    }
    
    
    func checkDateInDB(dateStr:String) -> (Bool, String) {
        
        var isDateExistInDB = Bool()
        var dateExistInRelatedDB = String()
        
        let valueePVE_Sync = CoreDataHandlerPVE().fetchDetailsForSyncData()
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
        print("string:",string)
    }
}


extension PVEStartNewAssessment {
    
    private func setBorderRedForMandatoryFiels(forBtn:UIButton) {
        
        let superviewCurrent =  forBtn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self) {
                view.layer.borderColor = UIColor.red.cgColor
                view.layer.borderWidth = 2.0
            }
        }
    }
    
    fileprivate func otherFields(_ cell: StartNewAssignmentCell) {
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
    }
    
    private func checkValidationnn() -> Bool {
        var isAllValidationOk = true
        
        if let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell,cell.evaluationDateTxtfield.text?.count == 0 || cell.evaluatorTxtfield.text?.count == 0 || cell.siteIdTxtfield.text?.count == 0 || cell.customerTxtfield.text?.count == 0 || cell.evaluationForTxtfield.text?.count == 0 || cell.accManagerTxtfield.text?.count == 0 ||  cell.breedOfBirdsTxtfield.text?.count == 0 ||  cell.noOfBirdsTxtfield.text?.count == 0 {
            
            if cell.customerTxtfield.text?.count == 0 {
                setBorderRedForMandatoryFiels(forBtn: cell.customerBtn)
            }
            if cell.evaluationDateTxtfield.text?.count == 0 {
                setBorderRedForMandatoryFiels(forBtn: cell.evaluationDateBtn)
            }
            
            if cell.noOfBirdsTxtfield.text?.count == 0 {
                setBorderRedForMandatoryFiels(forBtn: cell.noOfBirdsBtn)
            }
            otherFields(cell)
            showAlert(title: Constants.alertStr, message: Constants.pleaseEnterMandatoryFields, owner: self)
            isAllValidationOk = false
            
        }
        return isAllValidationOk
    }

    func checkValidation() {
        
        if checkValidationnn() == true, let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell {
            
            let isDateExistInDB = checkDateInDB(dateStr: cell.evaluationDateTxtfield.text ?? "")
            
            if !isDateExistInDB.0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: Constants.ControllerIdentifier.PVEFinalizeSNA) as! PVEStartNewAssFinalizeAssement
                
                navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlert(title: Constants.alertStr, message: "Assessment already exists for the customer, complex and date. Please try another one.", owner: self)
                setBorderRedForMandatoryFiels(forBtn: cell.evaluationDateBtn)
            }
        }
    }
    
    
    func getTimeStamp() -> String {
        let postingId = UserDefaults.standard.integer(forKey: "postingId")
        var lblTimeStamp = String()
        lblTimeStamp = lblTimeStamp.replacingOccurrences(of: "/", with: "", options: .regularExpression)
        lblTimeStamp = lblTimeStamp.replacingOccurrences(of: ":", with: "", options: .regularExpression)
        let string = lblTimeStamp as String
        let character: Character = "i"
        if (string).contains(character) {
            print(appDelegateObj.testFuntion())
        } else {
            let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier")! as! String
            let sessionGUID1 = lblTimeStamp + "_" + String(describing: postingId as NSNumber)
            lblTimeStamp = sessionGUID1 + "_" + "iOS" + "_" + String(udid)
        }
        return lblTimeStamp
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}



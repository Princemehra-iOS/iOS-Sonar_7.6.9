//
//  bacterialSurveyVC.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 30/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class BacterialSurveyVC: BaseViewController {
    
    @IBOutlet weak var sessionBtn: UIButton!
    @IBOutlet weak var loggedInUser: UILabel!
    @IBOutlet weak var bacterialSurveyTableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    
    var isCompanyFieldCheck = false
    var isSiteFieldCheck = false
    var isDateFieldCheck  = false
    var isbarcodeFieldCheck = false
    var isNoOfPlates = false
    var isMandatoryFieldValidate = false
    var isDisablePlusBtn = false
    var isSubmitBtnClicked = false
    var autogenratedID = Bool()
    var seesionProgress = true
    var defaultDate = ""
    var defaultDateWithTimeStamp = ""
    var dateForBarcode = ""
    var globalBarcode = ""
    
    var delegate: DatePickerPopupViewControllerProtocol?
    var canSelectPreviousDate = true
    var progressSession = NSArray()
    var progressSession1 = NSArray()
    var rowCount: [Int] = []
    var stringForBarcode  = ""
    var customerIdArray = NSArray()
    var selectedCompanyId = ""
    var selectedCompany = ""
    var selectedBarcode = ""
    var selectedSite = ""
    var selectedReviewer = ""
    var selectedRequestor = ""
    var selectedSampleCollectionDate = ""
    var selectedSampleCollectedBy = ""
    var selectedEmailId = ""
    var isPlusBtnClicked = false
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var sampleCollectionDateStr = ""
    var displayPlateIdCount = 0
    var barcodeForPlateId = ""
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    var sessionId = Int()
    var plateArr = NSArray()
    let selectSiteString = "Select Site"
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.sessionBtn.isHidden = true
        self.bacterialSurveyTableView.reloadData()
        CoreDataHandlerMicro().updateRequestorBacterialServeyFormDetails(sessionId, text: "", forAttribute: "company")
    }
    
    func barCodeDateWithTimeStamp(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYYmmss"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func barCodeDateWithoutTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.MMddyyyyStr
        let dateString = formatter.string(from: Date())
        return dateString
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.bacterialSurveyTableView.layer.cornerRadius = 20
        self.bacterialSurveyTableView.layer.masksToBounds = true
    
        let sessionprogresss = UserDefaults.standard.bool(forKey: "sessionprogresss")
        if sessionprogresss {
            progressSession = CoreDataHandlerMicro().fetchAllData("ProgressSessionMicrobial")
            let id = UserDefaults.standard.integer(forKey: "sessionId")
            plateArr =  CoreDataHandlerMicro().fetchSampleInfo(id )
        }
        
        sampleCollectionDateStr = ""
        defaultDateWithTimeStamp =  barCodeDateWithTimeStamp(date: Date())
        defaultDate = barCodeDateWithoutTimeStamp()
        
        self.bacterialSurveyTableView.reloadData()
        _ = CoreDataHandlerMicro().fetchDataForBacterialServeyForm(NSNumber(value: sessionId))
    }
    
    func saveDataIntoDB(cell: BacterialCaseInfoCell) {
        CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
        
        var date = ""
        if dateForBarcode.isEmpty {
            date = defaultDateWithTimeStamp.replacingOccurrences(of: "/", with: "")
        } else {
            date = dateForBarcode.replacingOccurrences(of: "/", with: "")
        }
        
        let sessionDataInProgress = CoreDataHandlerMicrodataModels.SessionProgressData(
            barcode: cell.barcodeTxt.text!, // Barcode text from the cell
            company: cell.selectedCompanyTxt.text!, // Company name text from the cell
            companyId: Int(self.selectedCompanyId) ?? 0, // Company ID, safely cast to Int, default to 0 if nil
            emailId: cell.emailIdTxt.text!, // Email text from the cell
            requestor: cell.requestorTxt.text!, // Requestor text from the cell
            reviewer: cell.reviewerTxt.text!, // Reviewer text from the cell
            sampleCollectedBy: cell.sampleColletedByTxt.text!, // Sample collected by text from the cell
            sampleCollectionDate: cell.sampleCollectionDateTxt.text!, // Sample collection date text from the cell
            sampleCollectionDateWithTimeStamp: date, // The timestamp (date variable) passed directly
            sessionId: Int(self.sessionId), // Session ID cast to an Int
            site: cell.siteTxt.text!, // Site text from the cell
            siteId: 3022, // Static Site ID (3022) – if dynamic, replace this with a variable
            manualEnteredBarCode: self.globalBarcode // The global barcode from the class property
        )
        
        CoreDataHandlerMicro().saveSessionProgress(data: sessionDataInProgress)
        UserDefaults.standard.set(true, forKey: "sessionprogresss")
    }
    
    //MARK: - Menu Button action
    @IBAction func actionMenu(_ sender: Any) {
        self.bacterialSurveyTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        if let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BacterialCaseInfoCell {
            let fields = [cell.selectedCompanyTxt.text, cell.siteTxt.text, cell.reviewerTxt.text, cell.emailIdTxt.text]
            
            if fields.allSatisfy({ $0?.isEmpty ?? true }) {
                print("All fields are empty")
            } else {
                self.saveDataIntoDB(cell: cell)
            }
        }        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func sampleCollectedByAction(_ sender: UIButton) {
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as! String
        setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.SampleCollectedBy, dropDownArr: [firstName])
    }
    
    @IBAction func siteBtnAction(_ sender: UIButton) {
        
        guard isCompanyFieldCheck else {
            Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please select Company first.")
            return
        }
        let index = IndexPath(row: 0, section: 0)
        let cell = bacterialSurveyTableView.cellForRow(at: index) as! BacterialCaseInfoCell
        
        if cell.selectedCompanyTxt.text! == "Training" {
            cell.siteTxt.placeholder = selectSiteString
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId, dropDownArr: ["Site1","Site2","Site3","Site4"])
        } else {
            cell.siteBtn.layer.borderColor = UIColor.red.cgColor
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId, dropDownArr: [""])
            cell.siteTxt.text = ""
            cell.siteBtn.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func companyBtnAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
        let customerNamesArray = customerDetailsArray.value(forKey: "customerName") as! NSArray
        setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.company, dropDownArr: customerNamesArray as? [String])

    }
    
    @IBAction func reviewerBtnAction(_ sender: UIButton) {
        
        let  reviewerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer")
        let  reviewerNamesArray = reviewerDetailsArray.value(forKey: "reviewerName") as? NSArray ?? NSArray()
        setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.reviewer, dropDownArr: reviewerNamesArray as? [String])
    }
    
    //MARK: - Drop down View load
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?){
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField)
            }
            self.dropHiddenAndShow()
        }
    }
    
    fileprivate func manageSiteIdCase(_ cell: BacterialCaseInfoCell, _ selectedValue: String) {
        cell.siteTxt.text = selectedValue
        self.selectedSite =  cell.siteTxt.text ?? "" == selectSiteString ? "" : cell.siteTxt.text ?? ""
        var date = dateForBarcode.replacingOccurrences(of: "/", with: "")
        if dateForBarcode.isEmpty {
            date = defaultDateWithTimeStamp.replacingOccurrences(of: "/", with: "")
        }
        
        let nameString = String(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "") + " " + String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "") + "\(String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "").count > 0 ? " " : "")" + String(UserDefaults.standard.value(forKey: "LastName") as? String ?? "")
        
        let initials = nameString.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        
        cell.barcodeTxt.text = initials + "-" + "\(String(describing: date))" + "" + (cell.siteTxt.text ?? "")
        self.globalBarcode = cell.barcodeTxt.text ?? "" + "-B"
        _ = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
        
        if (cell.siteTxt.text != nil) {
            cell.buttonForCornerRadius.layer.masksToBounds = true
            cell.buttonForCornerRadius.layer.cornerRadius = 23
            cell.buttonForCornerRadius.layer.borderWidth = 1
            cell.buttonForCornerRadius.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        }
        self.isSiteFieldCheck = false
        
        if (cell.siteTxt.text != nil) {
            self.isSiteFieldCheck = true
        }
        
        CoreDataHandlerMicro().updateRequestorBacterialServeyFormDetails(cell.tag, text: selectedValue, forAttribute: "site")
    }
    
    fileprivate func manageCompanyCase(_ cell: BacterialCaseInfoCell, _ selectedIndex: Int, _ selectedValue: String) {
        cell.siteTxt.text = ""
        self.isSiteFieldCheck = false
        // var customerNamesId = NSArray()
       // var customerDetailsArray = NSArray()
        let microCustomerArr = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer") 
        let customerId = (microCustomerArr.object(at: selectedIndex) as AnyObject).value(forKey: "customerId") as! Int
        appDelegate.selectedCompany = cell.selectedCompanyTxt.text ?? " "
        self.selectedCompany = cell.selectedCompanyTxt.text ?? " "
        //cell.selectedCompanyTxt.text ?? " "
        self.selectedCompanyId = "\(customerId)"
        
        appDelegate.selectedCompany = selectedValue
        cell.selectedCompanyTxt.text = selectedValue
        CoreDataHandlerMicro().updateRequestorBacterialServeyFormDetails(cell.tag, text: selectedValue, forAttribute: "company")
        
        self.selectedCompany = selectedValue
        cell.companyBtn.layer.borderColor = UIColor.red.cgColor
        
        if(cell.selectedCompanyTxt.text != nil) {
            self.isCompanyFieldCheck = true
            cell.companyBtn.layer.masksToBounds = true
            cell.companyBtn.layer.cornerRadius = 23
            cell.companyBtn.layer.borderWidth = 1
            cell.companyBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        }
    }
    
    func setValueInTextFields(selectedValue: String, selectedIndex: Int, clickedField:String) {
        if let cell = self.bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? BacterialCaseInfoCell {
            cell.companyBtn.layer.masksToBounds = true
            cell.companyBtn.layer.cornerRadius = 23
            cell.companyBtn.layer.borderWidth = 1
            
            switch clickedField {
            case Constants.ClickedFieldMicrobialSurvey.SampleCollectedBy:
                cell.sampleColletedByTxt.text = selectedValue
            case Constants.ClickedFieldMicrobialSurvey.company:
                manageCompanyCase(cell, selectedIndex, selectedValue)
                
            case Constants.ClickedFieldMicrobialSurvey.siteId:
                manageSiteIdCase(cell, selectedValue)
                
            case Constants.ClickedFieldMicrobialSurvey.reviewer:
                cell.reviewerTxt.text = selectedValue
                self.selectedReviewer =  cell.reviewerTxt.text ?? " "
                CoreDataHandlerMicro().updateRequestorBacterialServeyFormDetails(cell.tag, text: selectedValue, forAttribute: "reviewer")
            default:
                break
            }
        }
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    @IBAction func sessionBtnAction(_ sender: UIButton) {
        
        let sessionData = CoreDataHandlerMicrodataModels.CustomerSessionData(
            barcode: selectedBarcode,
            company: self.selectedCompany,
            companyId: Int(self.selectedCompanyId) ?? 0,
            emailId: self.selectedEmailId,
            requestor: self.selectedRequestor,
            reviewer: self.selectedReviewer,
            sampleCollectedBy: self.selectedSampleCollectedBy,
            sampleCollectionDate: self.selectedSampleCollectionDate,
            sessionId: "\(self.sessionId)",
            site: self.selectedSite,
            siteId: 3022
        )

        CoreDataHandlerMicro().saveCustomerDetailsInDBSessionData(sessionData)

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //MARK: - Submit Button action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        let auto = UserDefaults.standard.bool(forKey: "autogenratedID")
        if !auto {
            CoreDataHandlerMicro().autoIncrementidtable()
            sessionId = CoreDataHandlerMicro().fetchFromAutoIncrement()
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
            UserDefaults.standard.set(true, forKey: "autogenratedID")
        }

        
        self.isSubmitBtnClicked = true
        self.isMandatoryFieldValidate = true
        self.bacterialSurveyTableView.reloadData()
        if self.isCompanyFieldCheck && self.isSiteFieldCheck && isNoOfPlates {
            if let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BacterialCaseInfoCell,
                let email = cell.emailIdTxt.text, !email.isEmpty {
                
                let arrayOfEmail = email.components(separatedBy: ",")
                for item in arrayOfEmail {
                    guard isValidEmail(item) else {
                        Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please enter valid email.")
                        return
                    }
                }
            }
            
            let details = CoreDataHandlerMicrodataModels.submitDataCustomerDetails(
                
                barcode: selectedBarcode,
                company: self.selectedCompany,
                companyId: Int(self.selectedCompanyId) ?? 0,
                emailId: self.selectedEmailId,
                requestor: self.selectedRequestor,
                reviewer: self.selectedReviewer,
                sampleCollectedBy: self.selectedSampleCollectedBy,
                sampleCollectionDate: self.selectedSampleCollectionDate,
                sessionId: Int(self.sessionId),
                site: self.selectedSite,
                siteId: 3022
            )
            
            CoreDataHandlerMicro().saveCustomerDetailsInDBSubmitData(details)
            
            let sessiondata = CoreDataHandlerMicro().fetchAllData("MicrobialSession")
            print(sessiondata)
            UserDefaults.standard.removeObject(forKey: "autogenratedID")
            UserDefaults.standard.removeObject(forKey: "sessionprogresss")
            CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
            CoreDataHandlerMicro().deleteAllData("MicrobialSampleInfo")
            let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        } else {
            Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please fill al the mandatory fields.")
        }
    }
    
    //MARK: - Save Draft Button action
    @IBAction func saveAsDraftBtnAction(_ sender: UIButton) {
        let auto = UserDefaults.standard.bool(forKey: "autogenratedID")
        if !auto {
            CoreDataHandlerMicro().autoIncrementidtable()
            sessionId  = CoreDataHandlerMicro().fetchFromAutoIncrement()
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
            UserDefaults.standard.set(true, forKey: "autogenratedID")
        }
        seesionProgress = false
        CoreDataHandlerMicro().deleteAllData("ProgressSessionMicrobial")
        CoreDataHandlerMicro().deleteAllData("MicrobialSampleInfo")
        
        
        let sessionData = CoreDataHandlerMicrodataModels.CustomerDetails(
            barcode: selectedBarcode,
                 company: self.selectedCompany,
                 companyId: Int(self.selectedCompanyId) ?? 0,
                 emailId: self.selectedEmailId,
                 requestor: self.selectedRequestor,
                 reviewer: self.selectedReviewer,
                 sampleCollectedBy: self.selectedSampleCollectedBy,
                 sampleCollectionDate: self.selectedSampleCollectionDate,
                 sessionId: Int(self.sessionId),
                 site: self.selectedSite,
                 siteId: 3022,
                 draftCheck: "draft"
             )
        
        CoreDataHandlerMicro().saveCustomerDetailsInDraftData(customerDetails: sessionData)
        
        UserDefaults.standard.removeObject(forKey: "autogenratedID")
        UserDefaults.standard.removeObject(forKey: "sessionprogresss")
        
        let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    //MARK: - Delete plate button action
    @IBAction func globaldeleteBtnAction(_ sender: UIButton) {
        if plateArr.count > 0 {
            let index1 = IndexPath(row: sender.tag, section: 2)
            let cell1 = bacterialSurveyTableView.cellForRow(at: index1) as! BacterialTextfieldInfoCell
            let sessid = UserDefaults.standard.integer(forKey: "sessionId")
            CoreDataHandlerMicro().deleteLastRowData(sessionId: sessid, plateId: cell1.plateIdTxt.text ?? "")
            plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessid)
        }
    
        let index = IndexPath(row: sender.tag, section: 1)
        let cell = bacterialSurveyTableView.cellForRow(at: index) as! BacterialSampleInfoCell
        cell.noOfPlates.text = plateArr.count == 0 ? "" : "\(plateArr.count)"
        UIView.performWithoutAnimation {
             bacterialSurveyTableView.reloadSections([index.section, IndexPath(row: 0, section: 2).section], with: .none)
        }
    }

    //MARK: - Check box Button action
    @IBAction func checkMarkUpdateAction(_ sender: UIButton) {
        let index = IndexPath(row: sender.tag, section: 2)
        let sessid = UserDefaults.standard.integer(forKey: "sessionId")
        let cell = bacterialSurveyTableView.cellForRow(at: index) as! BacterialTextfieldInfoCell
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            CoreDataHandlerMicro().updateCheckMark(sessid, plateId: cell.plateIdTxt.text ?? "", checkMark: "false")
            sender.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        } else {
            CoreDataHandlerMicro().updateCheckMark(sessid, plateId: cell.plateIdTxt.text ?? "", checkMark: "true")
            sender.setImage(UIImage(named: "checkIcon"), for: .normal)
        }
        
        plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessid)
        UIView.performWithoutAnimation {
            bacterialSurveyTableView.reloadData()
        }
    }
    

    @IBAction func checkMarkUpdateMicrosporeAction(_ sender: UIButton) {
        let index = IndexPath(row: sender.tag, section: 2)
        let sessid = UserDefaults.standard.integer(forKey: "sessionId")
        let cell = bacterialSurveyTableView.cellForRow(at: index) as! BacterialTextfieldInfoCell
       
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            CoreDataHandlerMicro().updateMicrosporeCheckMark(sessid, plateId: cell.plateIdTxt.text ?? "", checkMark: "true")
            sender.setImage(UIImage(named: "checkIcon"), for: .normal)
        } else {
            CoreDataHandlerMicro().updateMicrosporeCheckMark(sessid, plateId: cell.plateIdTxt.text ?? "", checkMark: "false")
            sender.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        }
        
        plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessid)
        UIView.performWithoutAnimation {
            bacterialSurveyTableView.reloadData()
        }
    }
    
    //MARK: - Plus Button action
    @IBAction func plusBtnAction(_ sender: UIButton) {
        
        isPlusBtnClicked = true
        let auto = UserDefaults.standard.bool(forKey: "autogenratedID")
        if !auto {
            CoreDataHandlerMicro().autoIncrementidtable()
            sessionId  = CoreDataHandlerMicro().fetchFromAutoIncrement()
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
            UserDefaults.standard.set(true, forKey: "autogenratedID")
        }
        
        let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 1) ) as? BacterialSampleInfoCell
        
        if( Int(cell?.noOfPlates.text ?? "") ?? 0 > 200) {
            let alert = UIAlertController(title: Constants.alertStr, message: "Number of plates exceeding 200", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
                cell?.noOfPlates.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if !self.isCompanyFieldCheck || !self.isSiteFieldCheck {
            let alert = UIAlertController(title: Constants.alertStr, message: "Please enter all mandatory fields", preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                self.bacterialSurveyTableView.reloadData()
            }
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            return
        }
    
        if let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BacterialCaseInfoCell,
            let barCode = cell.barcodeTxt.text {
            
            guard  !barCode.isEmpty && barCode != "B-" && barCode.contains("B-")  else {
                Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please enter valid barcode.")
                cell.barcodeBtn.layer.borderColor = UIColor.red.cgColor
                return
            }
            cell.barcodeBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        }
        
        if(cell?.noOfPlates.text == "" ) {
            Helper.showAlertMessage(self, titleStr: Constants.alertStr, messageStr: "Please Enter A Value")
            bacterialSurveyTableView.reloadData()
            return
            
        } else if cell?.noOfPlates.isEnabled == false {
            //var lastVal = UserDefaults.standard.integer(forKey: "lastVal")
            //lastVal = lastVal+1
            let lastVal = plateArr.count + 1
            UserDefaults.standard.set(lastVal, forKey: "lastVal")
            let sessionIdNew = UserDefaults.standard.integer(forKey: "sessionId")
            let plate =  "\(String(describing: self.globalBarcode))-" + "\(lastVal)"
            CoreDataHandlerMicro().saveSampleInfoDataInDB(plate, plateId: lastVal, sampleDescriptiopn: "", additionalTests: "Bacterial", checkMark: "true", microsporeCheck: "false", sessionId: sessionIdNew)
            plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessionIdNew)
            
        } else {
            let txtVale = Int(cell?.noOfPlates.text ?? "")!
            let sessionIdNw = UserDefaults.standard.integer(forKey: "sessionId")
            UserDefaults.standard.set(txtVale, forKey: "lastVal")
            
            for i in 0..<txtVale {
                let plate =  "\(String(describing: self.globalBarcode))-" + "\(i+1)"
                CoreDataHandlerMicro().saveSampleInfoDataInDB(plate, plateId: i, sampleDescriptiopn: "", additionalTests: "Bacterial", checkMark: "true", microsporeCheck: "false", sessionId: sessionIdNw)
            }
            plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessionIdNw)
            cell?.noOfPlates.isEnabled = false
        }

        self.bacterialSurveyTableView.reloadData()
    }
    
    //MARK: - Date Selection
    @IBAction func dateBtnAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.delegate = self
        datePickerPopupViewController.canSelectPreviousDate = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
}

//MARK: - Date picker Delegate
extension BacterialSurveyVC: DatePickerPopupViewControllerProtocol{
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        
        if  let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? BacterialCaseInfoCell {
            cell.sampleCollectionDateTxt.text = string
            
            dateForBarcode = barCodeDateWithTimeStamp(date: objDate) //cell.sampleCollectionDateTxt.text ?? ""
            cell.sampleCollectionDateBtn.layer.masksToBounds = true
            cell.sampleCollectionDateBtn.layer.cornerRadius = 23
            cell.sampleCollectionDateBtn.layer.borderWidth = 1
            
            if(cell.sampleCollectionDateTxt.text == ""){
                cell.sampleCollectionDateBtn.layer.borderColor = UIColor.red.cgColor
            } else {
                self.isDateFieldCheck = true
                cell.sampleCollectionDateBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            }
            
            stringForBarcode =  dateForBarcode.replacingOccurrences(of: "/", with: "")
            self.selectedSite =  cell.siteTxt.text ?? "" == selectSiteString ? "" : cell.siteTxt.text ?? ""
            cell.barcodeTxt.text = "B-\(stringForBarcode)" + "" + self.selectedSite
            self.globalBarcode = cell.barcodeTxt.text ?? ""
            selectedBarcode = "B-\(stringForBarcode)" + "" + "\(String(describing: cell.siteTxt.text!))"
            
            cell.barcodeBtn.layer.masksToBounds = true
            cell.barcodeBtn.layer.cornerRadius = 23
            cell.barcodeBtn.layer.borderWidth = 1
            
            if cell.barcodeTxt.text == "" {
                cell.barcodeBtn.layer.borderColor = UIColor.red.cgColor
            } else {
                self.isbarcodeFieldCheck = true
            }
        }
        
    }
    
    
    func doneButtonTapped(string: String) {
        if  let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? BacterialCaseInfoCell {
            cell.sampleCollectionDateTxt.text = string
            
            dateForBarcode = cell.sampleCollectionDateTxt.text ?? ""
            
            cell.sampleCollectionDateBtn.layer.masksToBounds = true
            cell.sampleCollectionDateBtn.layer.cornerRadius = 23
            cell.sampleCollectionDateBtn.layer.borderWidth = 1
            
            if (cell.sampleCollectionDateTxt.text == "") {
                cell.sampleCollectionDateBtn.layer.borderColor = UIColor.red.cgColor
            } else {  self.isDateFieldCheck = true
                cell.sampleCollectionDateBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            }
            
            stringForBarcode =  dateForBarcode.replacingOccurrences(of: "/", with: "")
            
            cell.barcodeTxt.text = "B-\(stringForBarcode)" + "" + "\(String(describing: cell.siteTxt.text!))"
            self.globalBarcode = cell.barcodeTxt.text ?? ""
            selectedBarcode = "B-\(stringForBarcode)" + "" + "\(String(describing: cell.siteTxt.text!))"
            
            cell.barcodeBtn.layer.masksToBounds = true
            cell.barcodeBtn.layer.cornerRadius = 23
            cell.barcodeBtn.layer.borderWidth = 1
            
            if cell.barcodeTxt.text == "" {
                cell.barcodeBtn.layer.borderColor = UIColor.red.cgColor
            } else {
                self.isbarcodeFieldCheck = true
            }
        }
    }
}

//MARK: - Table View delegates and DataSource
extension BacterialSurveyVC: UITableViewDelegate,UITableViewDataSource,BacterialSampleInfoCellDelegate {
    
    func noOfPlates(count: Int, clicked: Bool) {
        if count  > 0 {
            self.isNoOfPlates = true
            bacterialSurveyTableView.reloadData()
        } else {
            self.isNoOfPlates = false
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            if plateArr.count > 0 {
                return plateArr.count
            } else {
                return progressSession1.count
            }
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        switch indexPath.section {
        case 0:
            height = 344
        case 1:
            height = 140
        case 2:
            height = 51
        default:
            height = 0
        }
        return height
    }
    
    fileprivate func extractedFunc1(_ data: ProgressSessionMicrobial, _ cell: BacterialCaseInfoCell) {
        if data.company != "" {
            cell.selectedCompanyTxt.text =  data.company
            self.isCompanyFieldCheck = true
            
        } else if cell.selectedCompanyTxt.text == "" && isSubmitBtnClicked {
            self.isCompanyFieldCheck = false
            cell.companyBtn.layer.borderColor = UIColor.red.cgColor
        }
        
        
        if data.emailId != "" && cell.emailIdTxt.text == "" {
            cell.emailIdTxt.text = data.emailId
        }
        
        
        if data.site != "" && data.site != selectSiteString {
            self.isSiteFieldCheck = true
            cell.siteTxt.text = data.site
        } else if cell.siteTxt.text == "" && (isSubmitBtnClicked || isPlusBtnClicked) {
            self.isSiteFieldCheck = false
            cell.buttonForCornerRadius.layer.borderColor = UIColor.red.cgColor
        }
        
        if data.reviewer != "" {
            cell.reviewerTxt.text = data.reviewer
        }
        
        if (data.sampleCollectedBy != nil) {
            cell.sampleColletedByTxt.text = data.sampleCollectedBy
        }
        
        if (data.sampleCollectionDate != ""){
            cell.sampleCollectionDateTxt.text = data.sampleCollectionDate
        }
    }
    
    fileprivate func cellForRowIfCondition(_ cell: BacterialCaseInfoCell) {
        let data = progressSession.object(at: 0) as! ProgressSessionMicrobial
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as! String
        
        self.loggedInUser.text = firstName
        cell.requestorTxt.text = firstName
        cell.sampleColletedByTxt.text = firstName
        
        selectedEmailId = data.emailId ?? ""
        
        extractedFunc1(data, cell)
        
        barcodeForPlateId =  cell.barcodeTxt.text ?? " "
        bacterialSurveyTableView.allowsSelection = false
        
        if plateArr.count > 0 {
            isPlusBtnClicked = true
            cell.barcodeTxt.isEnabled = false
            cell.barcodeTxt.textColor = UIColor.lightGray
        } else {
            cell.barcodeTxt.isEnabled = true
            cell.barcodeTxt.textColor = UIColor.black
        }
        
        if cell.selectedCompanyTxt.text != nil {
            isCompanyFieldCheck = true
        }
        
        if data.barcode != "" {
            cell.barcodeTxt.text = data.barcode
        }
        
        if !self.globalBarcode.isEmpty {
            cell.barcodeTxt.text = self.globalBarcode
        } else {
            
            let sampleCollectionDateWithTimeStamp = data.sampleCollectionDateWithTimeStamp ?? ""
            let nameString = String(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "") + " " + String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "") + "\(String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "").count > 0 ? " " : "")" + String(UserDefaults.standard.value(forKey: "LastName") as? String ?? "")
            
            let initials = nameString.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
            cell.barcodeTxt.text = initials + "-" + "\(String(describing: sampleCollectionDateWithTimeStamp.replacingOccurrences(of: "/", with: "")))" + "" + "\(data.site ?? "")" + "-B"
            
            self.globalBarcode = cell.barcodeTxt.text ?? ""
        }
    }
    
    fileprivate func extractedFunc(_ cell: BacterialCaseInfoCell) {
        let nameString = String(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "") + " " + String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "") + "\(String(UserDefaults.standard.value(forKey: "MiddleName") as? String ?? "").count > 0 ? " " : "")" + String(UserDefaults.standard.value(forKey: "LastName") as? String ?? "")
        
        let initials = nameString.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        
        if(dateForBarcode == "") {
            cell.barcodeTxt.text = initials + "-" + "\(defaultDateWithTimeStamp.replacingOccurrences(of: "/", with: ""))" + "" + "\(String(describing: cell.siteTxt.text!))" + "-B"
        } else {
            cell.barcodeTxt.text =  initials + "-" + "\(dateForBarcode.replacingOccurrences(of: "/", with: ""))" + "" + "\(String(describing: cell.siteTxt.text!))" + "-B"
        }
        self.globalBarcode = cell.barcodeTxt.text ?? ""
    }
    
    fileprivate func extractedFunc2(_ cell: BacterialCaseInfoCell) {
        if isPlusBtnClicked {
            cell.companyBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            
            if(cell.selectedCompanyTxt.text == "") {
                cell.companyBtn.layer.masksToBounds = true
                cell.companyBtn.layer.cornerRadius = 23
                cell.companyBtn.layer.borderWidth = 1
                cell.companyBtn.layer.borderColor = UIColor.red.cgColor
            }
            cell.siteBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            
            if (cell.siteTxt.text == "") {
                cell.buttonForCornerRadius.layer.masksToBounds = true
                cell.buttonForCornerRadius.layer.cornerRadius = 23
                cell.buttonForCornerRadius.layer.borderWidth = 1
                cell.buttonForCornerRadius.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    fileprivate func cellForRowElseCondition(_ cell: BacterialCaseInfoCell) {
        if !self.globalBarcode.isEmpty {
            cell.barcodeTxt.text = self.globalBarcode
        } else {
            extractedFunc(cell)
        }
        
        extractedFunc2(cell)
        
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as! String
        self.loggedInUser.text = firstName
        cell.requestorTxt.text = firstName
        cell.sampleColletedByTxt.text = firstName
        
        selectedEmailId = cell.emailIdTxt.text ?? ""
        cell.selectedCompanyTxt.text =  selectedCompany
        
        if cell.barcodeTxt.text == "" {
            cell.barcodeBtn.layer.borderColor = UIColor.red.cgColor
        }
        
        if self.isSubmitBtnClicked || self.isPlusBtnClicked {
            
            cell.companyBtn.layer.masksToBounds = true
            cell.companyBtn.layer.cornerRadius = 23
            cell.companyBtn.layer.borderWidth = 1
            
            if(cell.selectedCompanyTxt.text == "") {
                cell.companyBtn.layer.borderColor = UIColor.red.cgColor
            } else {
                self.isCompanyFieldCheck = true
                cell.companyBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            }
            
            cell.buttonForCornerRadius.layer.masksToBounds = true
            cell.buttonForCornerRadius.layer.cornerRadius = 23
            cell.buttonForCornerRadius.layer.borderWidth = 1
            
            if(cell.siteTxt.text == "" || cell.siteTxt.text == selectSiteString) {
                cell.buttonForCornerRadius.layer.borderColor = UIColor.red.cgColor
                self.isSiteFieldCheck = false
            } else {
                self.isSiteFieldCheck = true
                cell.siteBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            }
            
            cell.sampleCollectionDateBtn.layer.masksToBounds = true
            cell.sampleCollectionDateBtn.layer.cornerRadius = 23
            cell.sampleCollectionDateBtn.layer.borderWidth = 1
            
            if cell.barcodeTxt.text == "" {
                cell.barcodeBtn.layer.borderColor = UIColor.red.cgColor
            } else {
                self.isbarcodeFieldCheck = true
                cell.barcodeBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
            }
            cell.tag = sessionId
        }
        
        barcodeForPlateId =  cell.barcodeTxt.text ?? " "
        bacterialSurveyTableView.allowsSelection = false
    }
    
    fileprivate func indexPathSectionIndexZero(_ cell: BacterialCaseInfoCell, _ indexPath: IndexPath) -> UITableViewCell {
        cell.companyBtn.tag = indexPath.row
        
        if cell.sampleCollectionDateTxt.text == "" {
            cell.sampleCollectionDateTxt.text = defaultDate
        }
        
        UserDefaults.standard.setValue(cell.barcodeTxt.text, forKey: "barcode")
        
        cell.barcodeBtn.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        
        if(self.isPlusBtnClicked) && plateArr.count > 0 {
            cell.barcodeTxt.isEnabled = false
            cell.barcodeTxt.textColor = UIColor.lightGray
        } else {
            cell.barcodeTxt.isEnabled = true
            cell.barcodeTxt.textColor = UIColor.black
        }
        
        if progressSession.count > 0 {
            cellForRowIfCondition(cell)
        } else {
            cellForRowElseCondition(cell)
        }
        
        if isPlusBtnClicked && isCompanyFieldCheck && plateArr.count > 0 {
            cell.companyBtn.isEnabled = false
            cell.selectedCompanyTxt.isEnabled = false
            cell.selectedCompanyTxt.textColor = .lightGray
            cell.siteBtn.isEnabled = false
            cell.siteTxt.isEnabled = false
            cell.siteTxt.textColor = .lightGray
            cell.sampleCollectionDateBtn.isEnabled = false
            cell.sampleCollectionDateBtn2.isEnabled = false
            cell.sampleCollectionDateTxt.isEnabled = false
            cell.sampleCollectionDateTxt.textColor = .lightGray
        } else {
            cell.companyBtn.isEnabled = true
            cell.selectedCompanyTxt.isEnabled = true
            cell.selectedCompanyTxt.textColor = .black
            cell.siteBtn.isEnabled = true
            cell.siteTxt.isEnabled = true
            cell.siteTxt.textColor = .black
            cell.sampleCollectionDateBtn.isEnabled = true
            cell.sampleCollectionDateTxt.isEnabled = true
            cell.sampleCollectionDateTxt.textColor = .black
            cell.sampleCollectionDateBtn2.isEnabled = true
        }
        return cell
    }
    
    fileprivate func manageIndexPathOne(_ cell: BacterialSampleInfoCell, _ indexPath: IndexPath) -> UITableViewCell {
        //cell.delegate = self as? BacterialSampleInfoCellDelegate
        cell.plusBtnOutlet.tag = indexPath.row
        cell.noOfPlates.delegate = self
        
        if plateArr.count > 0 {
            self.isNoOfPlates = true
            cell.noOfPlates.text = String(plateArr.count)
        } else {
            cell.noOfPlates.text = ""
            let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? BacterialCaseInfoCell
            cell?.companyBtn.isEnabled = true
            cell?.selectedCompanyTxt.textColor = .black
            cell?.siteBtn.isEnabled = true
            cell?.siteTxt.textColor = .black
            cell?.barcodeTxt.isEnabled = true
            cell?.barcodeTxt.textColor = .black
            cell?.sampleCollectionDateBtn2.isEnabled = true
            cell?.sampleCollectionDateTxt.textColor = .black
        }
        
        let numberOfPlates = Int(cell.noOfPlates.text ?? "0") ?? 0
        if isPlusBtnClicked && numberOfPlates > 0 {
            cell.plateContainerView.layer.borderWidth = 1
            cell.plateContainerView.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        } else {
            cell.plateContainerView.layer.borderWidth = 1
            cell.plateContainerView.layer.borderColor = UIColor.red.cgColor
        }
        
        if numberOfPlates == 0 {
            CoreDataHandlerMicro().deleteAllData("MicrobialSampleInfo")
        }
        
        if isSubmitBtnClicked {
            appDelegateObj.testFuntion()
            isSubmitBtnClicked = false
            if numberOfPlates > 0 {
                self.isNoOfPlates = true
                cell.plateContainerView.layer.borderWidth = 1
                cell.plateContainerView.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
                
            } else {
                self.isNoOfPlates = false
                cell.plateContainerView.layer.borderWidth = 1
                cell.plateContainerView.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if(isCompanyFieldCheck && isSiteFieldCheck && isDateFieldCheck) {
            cell.plusBtnOutlet.isEnabled = true
        }
        
        if numberOfPlates > 0 {
            cell.noOfPlates.isEnabled = false
            cell.plusBtnOutlet.isEnabled = true
        }
        
        if self.plateArr.count == 0 {
            cell.noOfPlates.isEnabled = true
            cell.plusBtnOutlet.isEnabled = true
        } else if self.plateArr.count == 200 {
            cell.plusBtnOutlet.isEnabled = false
        }
        
        return cell
    }
    
    fileprivate func indexPathTwo(_ cell: BacterialTextfieldInfoCell, _ indexPath: IndexPath) -> UITableViewCell {
        cell.microsporeCheck.tag = indexPath.row
        cell.chkBtnTag.tag = indexPath.row
        cell.sampleDescriptionTxt.tag = indexPath.row
        
        let plateData = plateArr[indexPath.row] as! MicrobialSampleInfo
        cell.plateIdTxt.text = plateData.noOfPlates
        cell.bacterialTxt.text = plateData.additionalTests
        cell.sampleDescriptionTxt.text = plateData.sampleDescription
        
        if plateData.checkMark == "false" {
            cell.chkBtnTag.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        } else {
            cell.chkBtnTag.setImage(UIImage(named: "checkIcon"), for: .normal)
        }
        
        if plateData.microsporeCheckMark == "false" {
            cell.microsporeCheck.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        } else {
            cell.microsporeCheck.setImage(UIImage(named: "checkIcon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BacterialCaseInfoCell", for: indexPath) as! BacterialCaseInfoCell
            return indexPathSectionIndexZero(cell, indexPath)
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BacterialSampleInfoCell", for: indexPath) as! BacterialSampleInfoCell
            return manageIndexPathOne(cell, indexPath)
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BacterialTextfieldInfoCell", for: indexPath) as! BacterialTextfieldInfoCell
            return indexPathTwo(cell, indexPath)
        default:
            return UITableViewCell()
        }
    }
}





//MARK: - Text field delegates
extension BacterialSurveyVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = IndexPath(row: textField.tag, section: 2)
        let cell = bacterialSurveyTableView.cellForRow(at: index) as? BacterialTextfieldInfoCell
        let cell1 = bacterialSurveyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BacterialCaseInfoCell
        
        if textField == cell?.sampleDescriptionTxt {
            let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
            CoreDataHandlerMicro().updateSampledesc(sessionId, plateId: cell?.plateIdTxt.text ?? "", sampleDesc: textField.text ?? "")
            plateArr =  CoreDataHandlerMicro().fetchSampleInfo(sessionId)
            bacterialSurveyTableView.reloadData()
        } else if textField == cell1?.barcodeTxt {
            self.globalBarcode = textField.text ?? ""
        } else if textField == cell1?.emailIdTxt {
            let email = cell1?.emailIdTxt.text ?? ""
            let arrayOfEmail = email.components(separatedBy: ",")
            
            for item in arrayOfEmail {
                guard isValidEmail(item) else {
                    if  email.isEmpty {
                        cell1?.emailIdButton.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
                    } else {
                        cell1?.emailIdButton.layer.borderColor = UIColor.red.cgColor
                    }
                    return
                }
            }
            cell1?.emailIdButton.layer.borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        let cell = bacterialSurveyTableView.cellForRow(at: IndexPath(row: textField.tag, section: 2)) as? BacterialTextfieldInfoCell
        let cell1 = bacterialSurveyTableView.cellForRow(at: IndexPath(row: textField.tag, section: 1)) as? BacterialSampleInfoCell
        if cell1?.noOfPlates == textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: newString)) else {
                return false
            }
            return textField.text!.count < 3 || string == ""
        }
        
        if cell?.sampleDescriptionTxt == textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz.,-()")
            guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: newString)) else {
                return false
            }
            return true
        }
        return true
    }
}

struct SessionPlateData:Codable {
    var p_id:Int
    var p_desc:String
    var checkstatus:Bool
}

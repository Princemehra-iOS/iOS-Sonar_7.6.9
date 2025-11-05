//
//  ComplexPoupVC.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 05/12/19.
//  Copyright © 2019 Nitin kumar Kanojia. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Reachability
class PELandingPoupViewController: BaseViewController {
    
    @IBOutlet weak var sitelabel: PEFormLabel!
    @IBOutlet weak var customerlabel: PEFormLabel!
    @IBOutlet weak var selectCustomerButton: UIButton!
    @IBOutlet weak var selectSiteButton: UIButton!
    @IBOutlet weak var selectCustomerText: UITextField!
    @IBOutlet weak var selectSiteText: UITextField!
    var peNewAssessment:PENewAssessment!
    var jsonRe : JSON = JSON()
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var infoImageDataResponse = InfoImageDataResponse(nil)
    @IBOutlet weak var nextButton: PESubmitButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var siteView: UIView!
    @IBOutlet weak var customerView: UIView!
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    var fromSyncDel : Bool = false
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        sitelabel.addLabelWithAstric(placeHolder: "Site")
        customerlabel.addLabelWithAstric(placeHolder: "Customer")
        peNewAssessment = PENewAssessment()
        
        siteView.setDropdownView()
        customerView.setDropdownView()
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        nextButton.setNextButtonUI()
        let customerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Customer")
        let customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray()
        //let customerIDArray = customerDetailsArray.value(forKey: "customerID") as! NSArray
        //let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        //let peNewAssessmentCurrentIs =  CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
        //PEDataService.sharedInstance.getScheduledAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", viewController: self, completion: <#T##(String?, NSError?) -> Void#>)
        let newUserLogin = UserDefaults.standard.bool(forKey: "PENewUserLoginFlag") as? Bool ?? true
        // set(true, forKey: "PENewUserLoginFlag")
        if newUserLogin{
            
        }
        if fromSyncDel {
        
        } else {
        if  customerNamesArray.count > 0 {
            _ = UserDefaults.standard
            let customerId = UserDefaults.standard.integer(forKey: "PE_Selected_Customer_Id") as? Int ?? 0
            //userDefault.set(nil, forKey: "PE_Selected_Customer_Id")
            
            if customerId != 0 {
                
            } else {
                let cleanSession =  UserDefaults.standard.bool(forKey: "PECleanSession")
                if newUserLogin{
                    DispatchQueue.main.async{
                        self.showAlertDifferentLogin()
                    }
                }else{
                    self.fetchCustomersEveryTime()
                }
//                if cleanSession {
//
//                } else {
//                self.showAlertDifferentLogin()
//                }
            }
        } else {
            startMasterDataUpdate()
            }
        }
        customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        customerView.layer.borderWidth = 2.0
        
        siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        siteView.layer.borderWidth = 2.0
        
    }
    
    
    @IBAction func closeController(_ sender: Any) {
        
        let userDefault = UserDefaults.standard
        userDefault.set(nil, forKey: "PE_Selected_Customer_Id")
        userDefault.set(nil, forKey: "PE_Selected_Customer_Name")
        userDefault.set(nil, forKey: "PE_Selected_Site_Id")
        userDefault.set(nil, forKey: "PE_Selected_Site_Name")
        NotificationCenter.default.post(Notification(name:
        Notification.Name(rawValue: "MoveToDashBoard"),object: nil))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func startMasterDataUpdate(){
        if ConnectionManager.shared.hasConnectivity() {
            fetchAllCustomer()
        } else {
            let errorMSg = "Internet not available , Please connect and then try."
            let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                _ in
                self.fetchAllCustomer()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                _ in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertDifferentLogin(){
          let errorMSg = "Seems you are login with different user or you do not have selected customer and site. Please allow app to fetch data for you."
          let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
              _ in
            self.fetchAllCustomer()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MoveToDashBoard"),object: nil))
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            
            customerView.layer.borderColor = UIColor.red.cgColor
            customerView.layer.borderWidth = 2.0
            return
        }
        
        guard let complex = self.peNewAssessment.siteName, complex.count > 0 else {
            siteView.layer.borderColor = UIColor.red.cgColor
            siteView.layer.borderWidth = 2.0
            return
        }
       // CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
        UserDefaults.standard.set(false, forKey:"PECleanSession")
                
        
        var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
        var jsonRe : JSON = JSON()
        jsonRe = (getJSON("QuestionAns") ?? JSON())
        pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
        
        let userDefault = UserDefaults.standard
        userDefault.set(self.peNewAssessment.customerId, forKey: "PE_Selected_Customer_Id")
        userDefault.set(self.peNewAssessment.customerName, forKey: "PE_Selected_Customer_Name")
        userDefault.set(self.peNewAssessment.siteId, forKey: "PE_Selected_Site_Id")
        userDefault.set(self.peNewAssessment.siteName, forKey: "PE_Selected_Site_Name")
        
        
        saveAssessmentInProgressDataInDB()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func saveAssessmentInProgressDataInDB()  {
        
       // self.deleteAllData("PE_AssessmentInProgress")
        let firstNameIs =  UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        let LastName =  UserDefaults.standard.value(forKey: "LastName") as? String ?? ""
            
        self.peNewAssessment.username = firstNameIs
        self.peNewAssessment.firstname = firstNameIs
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        self.peNewAssessment.userID = userID
        self.peNewAssessment.evaluatorID = userID
        peNewAssessment.evaluatorName = firstNameIs + " " + LastName
      //  CoreDataHandlerPE().updateAssessmentInProgressInDB(newAssessment: self.peNewAssessment)
        
    }
    
    @IBAction func customerBtnAction(_ sender: UIButton) {
        customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        customerView.layer.borderWidth = 2.0
        var customerNamesArray = NSArray()
        var customerIDArray = NSArray()
        var customerDetailsArray = NSArray()
        customerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Customer")
        customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray();
        customerIDArray = customerDetailsArray.value(forKey: "customerID")  as? NSArray ?? NSArray();
        if  customerNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: customerNamesArray as? [String] ?? [String]() , kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index  in
                self.selectCustomerText.text = selectedVal
                self.selectSiteText.text = ""
                let indexOfItem = customerNamesArray.index(of: selectedVal)
                self.peNewAssessment.customerName = selectedVal
                self.peNewAssessment.siteName = ""
                self.peNewAssessment.customerId = customerIDArray[indexOfItem] as? Int
                
            }
            self.dropHiddenAndShow()
        }
    }
    
    @IBAction func siteBtnAction(_ sender: UIButton) {
        siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        siteView.layer.borderWidth = 2.0
        guard let customer = self.peNewAssessment.customerName, customer.count > 0 else {
            //   showtoast(message: "Select Customer")
            return
        }
        var siteNamesArray = NSArray()
        var siteDetailsArray = NSArray()
        var siteIDArray = NSArray()
       // siteDetailsArray =  CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Sites")
        siteDetailsArray =  CoreDataHandlerPE().fetchSitesForCoustomerDetailsFor(entityName: "PE_Sites", customerId: self.peNewAssessment.customerId ?? 0)
      
        siteNamesArray = siteDetailsArray.value(forKey: "siteName") as? NSArray ?? NSArray()
        siteIDArray = siteDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
        
        if  siteNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: siteNamesArray as? [String] ?? [String]() , kWidth: selectSiteButton.frame.width, kAnchor: selectSiteButton, yheight: selectSiteButton.bounds.height) { [unowned self] selectedVal, index in
                self.selectSiteText.text = selectedVal
                let indexOfItem = siteNamesArray.index(of: selectedVal)
                self.peNewAssessment.siteName = selectedVal
                self.peNewAssessment.siteId = siteIDArray[indexOfItem] as? Int
            }
            self.dropHiddenAndShow()
        } else{
            showAlert(title: "Alert", message: "No Site available this customer", owner: self)
        }
    }
    
    
    //MARKS: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
}




extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            //return try?
            let dict = try? JSONSerialization.jsonObject(with: data, options: [])// as? [String: Any]
            return dict as? [String : Any]
        }
        return nil
    }
}

//
//  ComplexPoupVC.swift
//  TestApp
//
//  Created by Nitin kumar Kanojia on 08/11/19.
//  Copyright © 2019 Nitin kumar Kanojia. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

protocol ComplexDelegate {
    func fetchGetAPIResponse()
    func stopLoader()
}

class ComplexPoupViewController: BaseViewController {
    
    let sharedManager = PVEShared.sharedInstance
    var delegate: ComplexDelegate? = nil
    
    @IBOutlet weak var gradientViewBG: GradientButton!
    
    @IBOutlet weak var siteView: UIView!
    @IBOutlet weak var customerView: UIView!
    
    @IBOutlet weak var selectCustomerButton: UIButton!
    @IBOutlet weak var selectComplexButton: UIButton!
    @IBOutlet weak var selectCompanyText: UITextField!
    @IBOutlet weak var selectComplexText: UITextField!
    @IBOutlet weak var btn_updateCustomerDetails: UIButton!
    
    var currentSelectedModule = String()
    var customerId = Int()
    var siteId = Int()
    var isUpdateCustomer : Bool = false
    let yourAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0, green: 107/255, blue: 173/255, alpha: 1.0),
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.gradientViewBG.setGradient(topGradientColor: UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
        siteView.setDropdownView()
        customerView.setDropdownView()
        setBorderBlackFiels(forBtn:selectCustomerButton)
        
        customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        customerView.layer.borderWidth = 2.0
        siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        siteView.layer.borderWidth = 2.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopLoader(notification:)), name: Notification.Name("stopComplexPopupLosder"), object: nil)
        let attributeString = NSMutableAttributedString(
            string: "Note: If you do not see your customer name here, please click here to update.",
            attributes: yourAttributes
        )
        btn_updateCustomerDetails.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func getValueFromDB(key:String) -> String{
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_LoginRespone")
        //   print("fetchedLoginResultFromDB valuee----\(valuee)")
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]  as! String
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        CoreDataHandler().deleteAllData("PVE_Session")
        
        customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        customerView.layer.borderWidth = 2.0
        siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        siteView.layer.borderWidth = 2.0
        
        
        let getCustomerArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Customer_PVE")
        
        if getCustomerArr.count > 0{
            let Id =  UserDefaults.standard.value(forKey: "Id") as? Int
            CoreDataHandlerPVE().saveUserInfoInDB(userId: Id!)
            
            CoreDataHandlerPVE().saveSessionDetailsInDB()
            let pVE_Session =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
            fetchMasterDataIfCountZero()
            
            return
        }else{
            
            fetchCustomerList()
            let Id =  UserDefaults.standard.value(forKey: "Id") as? Int
            CoreDataHandlerPVE().saveUserInfoInDB(userId: Id!)
            CoreDataHandlerPVE().saveSessionDetailsInDB()
            let pVE_Session =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
        }
        
    }
    
    func fetchMasterDataIfCountZero() {
        
        if  getCountFor(key: "Customer_PVE") == 0 ||
                getCountFor(key: "Complex_PVE") == 0 ||
                getCountFor(key: "PVE_EvaluationType") == 0 ||
                getCountFor(key: "PVE_EvaluationFor") == 0 ||
                getCountFor(key: "PVE_SiteIDName") == 0 ||
                getCountFor(key: "PVE_AgeOfBirds") == 0 ||
                getCountFor(key: "PVE_BreedOfBirds") == 0 ||
                getCountFor(key: "PVE_Housing") == 0 ||
                getCountFor(key: "PVE_AssignUserDetails") == 0 ||
                getCountFor(key: "PVE_Evaluator") == 0 ||
                getCountFor(key: "PVE_AssessmentCategoriesDetails") == 0 ||
                getCountFor(key: "PVE_AssessmentQuestion") == 0 ||
                getCountFor(key: "PVE_SerotypeDetails") == 0 ||
                getCountFor(key: "PVE_SurveyTypeDetails") == 0 ||
                getCountFor(key: "PVE_VaccineManDetails") == 0 ||
                getCountFor(key: "PVE_VaccineNamesDetails") == 0 ||
                getCountFor(key: "PVE_SiteInjctsDetails") == 0
        {
            fetchCustomerList()
            
            let Id =  UserDefaults.standard.value(forKey: "Id") as? Int
            CoreDataHandlerPVE().saveUserInfoInDB(userId: Id!)
            CoreDataHandlerPVE().saveSessionDetailsInDB()
        }
    }
    
    func getCountFor(key:String) -> Int {
        let getCustomerArr = CoreDataHandlerPVE().fetchDetailsFor(entityName: key)
        return getCustomerArr.count
    }
    
    @IBAction func action_updateCustomerDetails(_ sender: Any) {
        self.isUpdateCustomer = true
        self.fetchCustomerList()
    }
    
    private func setBorderBlackFiels(forBtn:UIButton) {
        
        let superviewCurrent =  forBtn.superview
        customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        customerView.layer.borderWidth = 2.0
        
        siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        siteView.layer.borderWidth = 2.0
    }
    
    private func checkValidation() -> Bool{
        var isAllValidationOk = Bool()
        isAllValidationOk = true
        if selectCompanyText.text?.count == 0{
            customerView.layer.borderColor = UIColor.red.cgColor
            customerView.layer.borderWidth = 2.0
            isAllValidationOk = false
        }
        if selectComplexText.text?.count == 0{
            siteView.layer.borderColor = UIColor.red.cgColor
            siteView.layer.borderWidth = 2.0
            isAllValidationOk = false
        }
        return isAllValidationOk
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "isSession")
        UserDefaults.standard.synchronize()
        if checkValidation() == true{
            
            self.dismiss(animated: true, completion: nil)
            CoreDataHandlerPVE().saveCustomerComplexDetailsPoupInDB(self.selectCompanyText.text!, customerId: self.customerId, complexName: self.selectComplexText.text!, complexId: self.siteId)
            CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "")
            let dataSavedInDB =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
            refreshDashboardPVE()
            updateEvaluatorIfExist()
            
        }else{
            showAlert(title: "Alert", message: "Please fill the mandatory fields.", owner: self)
            
        }
        
        stopLoader()
    }
    
    func updateEvaluatorIfExist(){
        
        let currentUserId =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        
        let evalArr = CoreDataHandlerPVE().fetchDetailsForEntity(entityName: "PVE_Evaluator", id: currentUserId , keyStr: "id")
        if evalArr.count > 0 {
            var evaluatorNameStr = String()
            evaluatorNameStr = (UserDefaults.standard.string(forKey: "FirstName") ?? "") + " " + (UserDefaults.standard.string(forKey: "LastName") ?? "")
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: evaluatorNameStr, forAttribute: "evaluator")
            CoreDataHandlerPVE().updateSessionDetails(1, text: currentUserId, forAttribute: "evaluatorId")
            print("EvaluatorIdExistInList")
        }else{
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "evaluator")
            CoreDataHandlerPVE().updateSessionDetails(1, text: 0, forAttribute: "evaluatorId")
            print("EvaluatorId Not ExistInList")
        }
        
    }
    
    private func refreshDashboardPVE() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "dashboardOnGoingBeginNoti"),object: nil))
        delegate?.stopLoader()
        
    }
    
    func setBorderBlue(btn:UIButton) {
        
        let superviewCurrent =  btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of:UIButton.self) {
                if view == btn{
                    view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
                } else{
                    view.setDropdownStartAsessmentView(imageName:"dd")
                }
            }
        }
        
    }
    
    
    
    @IBAction func customerBtnAction(_ sender: UIButton) {
        var customerNamesArray = NSArray()
        var customerDetailsArray = NSArray()
        customerDetailsArray = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Customer_PVE")
        customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray()
        
        if  customerNamesArray.count > 0 {
            self.dropDownVIewNew(arrayData: customerNamesArray as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index  in
                
                self.customerId = (customerDetailsArray.object(at: index) as AnyObject).value(forKey: "customerId") as! Int
                self.selectCompanyText.text = selectedVal
                
                self.selectComplexText.text = ""
                
                CoreDataHandlerPVE().updateUserInfoSavedInDB(selectedVal, forAttribute: "customer")
                CoreDataHandlerPVE().updateUserInfoSavedInDB(self.customerId, forAttribute: "customerId")
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "")
                let dataSavedInDB =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
                
                self.customerView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                self.customerView.layer.borderWidth = 2.0
                
            }
            self.dropHiddenAndShow()
        }
    }
    
    @IBAction func complexBtnAction(_ sender: UIButton) {
        
        if selectCompanyText.text?.count == 0 {
            customerView.layer.borderColor = UIColor.red.cgColor
            customerView.layer.borderWidth = 2.0
            siteView.layer.borderColor = UIColor.red.cgColor
            siteView.layer.borderWidth = 2.0
            showAlert(title: "Alert", message: "Please select customer to fetch related complex list.", owner: self)
            return
        }
        
        var siteNameArr = NSArray()
        var siteDetailsArray = NSArray()
        siteDetailsArray = CoreDataHandlerPVE().fetchCustomerWithCustId( customerId as NSNumber)
        
        siteNameArr = siteDetailsArray.value(forKey: "complexName") as? NSArray ?? NSArray()
        if  siteNameArr.count > 0 {
            
            self.dropDownVIewNew(arrayData: siteNameArr as! [String], kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) { [unowned self] selectedVal, index in
                
                self.selectComplexText.text = selectedVal
                
                let complexId = (siteDetailsArray.object(at: index) as AnyObject).value(forKey: "complexId") as? Int
                
                self.siteId = complexId!
                
                CoreDataHandlerPVE().updateUserInfoSavedInDB(selectedVal, forAttribute: "complexName")
                CoreDataHandlerPVE().updateUserInfoSavedInDB(self.siteId, forAttribute: "complexId")
                
                CoreDataHandlerPVE().updateSessionDetails(1, text: "", forAttribute: "")
                let dataSavedInDB =  CoreDataHandlerPVE().fetchCurrentSessionInDB()
                
                self.siteView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
                self.siteView.layer.borderWidth = 2.0
                
            }
            self.dropHiddenAndShow()
        } else{
            showAlert(title: "Alert", message: "The complex not available.", owner: self)
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

extension ComplexPoupViewController {
    
    private func fetchCustomerList(){
        
        CoreDataHandler().deleteAllData("Customer_PVE")
        
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...Please wait")
        
        let Id =  UserDefaults.standard.value(forKey: "Id") as? Int
        
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        ZoetisWebServices.shared.getCustomerListForPVE(controller: self, countryID: String(countryId), parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handlefetchCustomerResponse(json)
        })
    }
    
    private func handlefetchCustomerResponse(_ json: JSON) {
        
        let jsonObject = CustomerPVEResponse(json)
        
        sharedManager.sharedCustomerNameArrPVE = jsonObject.getAllCustomerNames(customerArray: jsonObject.customerArray ?? [])
        sharedManager.sharedCustomerPVE =  jsonObject.customerArray ?? []
        fetchComplexListForPVE()
    }
    
    private func fetchComplexListForPVE(){
        CoreDataHandler().deleteAllData("Complex_PVE")
        selectComplexText.text = ""
        
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        ZoetisWebServices.shared.getComplexListForPVE(controller: self, countryID: String(countryId), parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handlefetchAllComplexesResponseForPVE(json)
        })
    }
    
    private func handlefetchAllComplexesResponseForPVE(_ json: JSON) {
        //
        let jsonObject = PVEGetComplexResponse(json)
        sharedManager.sharedComplexResArrPVE = jsonObject.getAllComplexNames(complexArray: jsonObject.complexArray ?? [])
        sharedManager.sharedComplexResPVE =  jsonObject.complexArray ?? []
        fetchEvaluationTypeList()
        
    }
    
}


// MARK: ------------------------------Fetch & Save Response in CoreData-----------------

extension ComplexPoupViewController{
    
    private func fetchEvaluationTypeList(){
        CoreDataHandler().deleteAllData("PVE_EvaluationType")
        ZoetisWebServices.shared.getEvaluationTypeForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleEvaluationTypeResponse(json)
        })
    }
    
    private func handleEvaluationTypeResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetEvaluationTypeResponse(json)
        sharedManager.sharedEvaluationTypeResArrPVE = jsonObject.getEvaluationTypes(dataArray: jsonObject.evaluationTypeArr ?? [])
        sharedManager.sharedEvaluationTypeResPVE =  jsonObject.evaluationTypeArr ?? []
        fetchEvaluationForList()
    }
    
    //---fetchEvaluationTypeList-------------
    
    private func fetchEvaluationForList(){
        CoreDataHandler().deleteAllData("PVE_EvaluationFor")
        ZoetisWebServices.shared.getEvaluationForForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleEvaluationForResponse(json)
        })
    }
    
    private func handleEvaluationForResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetEvaluationForResponse(json)
        sharedManager.sharedEvaluationForResArrPVE = jsonObject.getEvaluationFor(dataArray: jsonObject.evaluationForArr ?? [])
        sharedManager.sharedEvaluationForResPVE =  jsonObject.evaluationForArr ?? []
        fetchSiteIdNameResponse()
    }
    
    //---fetchSiteIdNameResponse-------------
    
    private func fetchSiteIdNameResponse(){
        
        CoreDataHandler().deleteAllData("PVE_SiteIDName")
        ZoetisWebServices.shared.getSiteIdNameForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleSiteIdNameResponse(json)
        })
    }
    
    private func handleSiteIdNameResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetSiteIdNameResponse(json)
        sharedManager.sharedSiteIdNameResArrPVE = jsonObject.getSiteIdNameResponse(dataArray: jsonObject.siteIdNameArr ?? [])
        sharedManager.sharedSiteIdNameResPVE =  jsonObject.siteIdNameArr ?? []
        // //   print("PVE_SiteIDName---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_SiteIDName"))")
        fetchtAgeOfBirdsResponse()
    }
    
    //---fetchSiteIdNameResponse-------------
    
    private func fetchtAgeOfBirdsResponse(){
        CoreDataHandler().deleteAllData("PVE_AgeOfBirds")
        ZoetisWebServices.shared.getAgeOfBirdsForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleAgeOfBirdsResponse(json)
        })
    }
    
    private func handleAgeOfBirdsResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetAgeOfBirdsResponse(json)
        sharedManager.sharedAgeOfBirdsResArrPVE = jsonObject.getAgeOfBirdsResponse(dataArray: jsonObject.ageOfBirdsArr ?? [])
        sharedManager.sharedAgeOfBirdsResPVE =  jsonObject.ageOfBirdsArr ?? []
        // //   print("PVE_AgeOfBirds---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AgeOfBirds"))")
        fetchtBreedOfBirdsResponse()
    }
    
    //---fetchtBreedOfBirdsResponse-------------
    
    private func fetchtBreedOfBirdsResponse(){
        CoreDataHandler().deleteAllData("PVE_BreedOfBirds")
        ZoetisWebServices.shared.getBreedOfBirdsForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleBreedOfBirdsResponse(json)
        })
    }
    
    private func handleBreedOfBirdsResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetBreedOfBirdsResponse(json)
        sharedManager.sharedBreedOfBirdsResArrPVE = jsonObject.getBreedOfBirdsResponse(dataArray: jsonObject.breedOfBirdsArr ?? [])
        sharedManager.sharedBreedOfBirdsResPVE = jsonObject.breedOfBirdsArr ?? []
        //   print("PVE_BreedOfBirds---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_BreedOfBirds"))")
        fetchtHousingDetailsResponse()
    }
    
    //---fetchtHousingDetailsResponse-------------
    
    private func fetchtHousingDetailsResponse(){
        
        CoreDataHandler().deleteAllData("PVE_Housing")
        ZoetisWebServices.shared.getHousingDetailsForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleHousingDetailsResponse(json)
        })
    }
    
    private func handleHousingDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetHousingDetailsResponse(json)
        sharedManager.sharedHousingDetailsResArrPVE = jsonObject.getHousingDetailsResponse(dataArray: jsonObject.housingArr ?? [])
        sharedManager.sharedHousingDetailsResPVE =  jsonObject.housingArr ?? []
        ////   print("PVE_Housing---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Housing"))")
        fetchtAssignUserDetailResponse()
    }
    
    //---fetchtHousingDetailsResponse-------------Zoetis Account Manager
    
    private func fetchtAssignUserDetailResponse(){
        
        CoreDataHandler().deleteAllData("PVE_AssignUserDetails")
        ZoetisWebServices.shared.getAssignUserDetailForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleAssignUserDetailResponse(json)
        })
    }
    
    private func handleAssignUserDetailResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetAssignUserDetailsResponse(json)
        sharedManager.sharedAssignUserDetailsResArrPVE = jsonObject.getAssignUserDetailsResponse(dataArray: jsonObject.userDetailsArr ?? [])
        sharedManager.sharedAssignUserDetailsResPVE =  jsonObject.userDetailsArr ?? []
        ////   print("PVE_AssignUserDetails---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssignUserDetails"))")
        fetchtEvaluatorDetailsResponse()
    }
    
    //---fetchtEvaluatorDetailsResponse-------------Zoetis Account Manager
    
    private func fetchtEvaluatorDetailsResponse(){
        
        CoreDataHandler().deleteAllData("PVE_Evaluator")
        ZoetisWebServices.shared.getEvaluatorDetailForPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleEvaluatorDetailsResponse(json)
        })
    }
    
    private func handleEvaluatorDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVEGetEvaluatorDetailsResponse(json)
        sharedManager.sharedEvaluatorDetailsResArrPVE = jsonObject.getEvaluatorDetails(dataArray: jsonObject.evaluatorArr ?? [])
        sharedManager.sharedEvaluatorDetailsResPVE =  jsonObject.evaluatorArr ?? []
        ////   print("PVE_Evaluator---\(CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Evaluator"))")
        fetchtAssessmentCategoriesResponse()
    }
    
    // ---- Fetch Category Details for PVE -----------------
    
    private func fetchtAssessmentCategoriesResponse(){
        
        
        CoreDataHandler().deleteAllData("PVE_AssessmentCategoriesDetails")
        CoreDataHandler().deleteAllData("PVE_AssessmentQuestion")
        
        ZoetisWebServices.shared.getAssessmentCategoriesDetailsPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleAssessmentCategoriesResponse(json)
        })
    }
    
    private func handleAssessmentCategoriesResponse(_ json: JSON) {
        //
        let jsonObject = PVEAssessmentCategoriesDetailsResponse(json)
        sharedManager.sharedAssCategoriesDetailsResArrPVE = jsonObject.getCategoriesDetailsResponse(dataArray: jsonObject.categoriesDetailsArr ?? [])
        sharedManager.sharedAssCategoriesDetailsResPVE =  jsonObject.categoriesDetailsArr ?? []
        let currntAA = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssessmentCategoriesDetails")
        let assessmentQuestionArray = currntAA.value(forKey: "assessmentQuestion") as! NSObject
        fetchtSerotypeDetailsResponse()
        
    }
    
    // ---- Fetch fetchtSerotypeDetailsResponse for PVE -----------------
    
    private func fetchtSerotypeDetailsResponse(){
        
        CoreDataHandler().deleteAllData("PVE_SerotypeDetails")
        
        ZoetisWebServices.shared.getSerotypeDetailsPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleSerotypeDetailsResponse(json)
        })
    }
    
    private func handleSerotypeDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVESerotypeDetailsResponse(json)
        getSurveyTypeDetailsPVE()
    }
    
    // ---- Fetch fetchtSerotypeDetailsResponse for PVE -----------------
    
    private func getSurveyTypeDetailsPVE(){
        
        
        CoreDataHandler().deleteAllData("PVE_SurveyTypeDetails")
        
        ZoetisWebServices.shared.getSurveyTypeDetailsPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleSurveyTypeDetailsResponse(json)
        })
    }
    
    private func handleSurveyTypeDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVESurveyTypeDetailsResponse(json)
        
        fetchtVaccineManDetailsPVE()
        
    }
    
    
    // ---- Fetch getVaccineManDetailsPVE for PVE -----------------
    
    private func fetchtVaccineManDetailsPVE(){
        
        CoreDataHandler().deleteAllData("PVE_VaccineManDetails")
        
        ZoetisWebServices.shared.getVaccineManDetailsPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleVaccineManDetailsResponse(json)
        })
    }
    
    private func handleVaccineManDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVEVaccineManDetailsResponse(json)
        
        getVaccineNamesDetailsPVE()
    }
    
    // ---- Fetch getVaccineNamesDetailsPVE for PVE -----------------
    
    private func getVaccineNamesDetailsPVE(){
        
        CoreDataHandler().deleteAllData("PVE_VaccineNamesDetails")
        
        ZoetisWebServices.shared.getVaccineNamesDetailsPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handlegetVaccineNamesDetailsResponse(json)
        })
    }
    
    private func handlegetVaccineNamesDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVEVaccineNameDetailsResponse(json)
        
        getSiteInjctsDetailssPVE()
        
    }
    
    // ---- Fetch getSiteInjctsDetailssPVE for PVE -----------------
    
    private func getSiteInjctsDetailssPVE(){
        
        CoreDataHandler().deleteAllData("PVE_SiteInjctsDetails")
        ZoetisWebServices.shared.getSiteInjctsDetailssPVE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            self.handleSiteInjctsDetailsResponse(json)
        })
    }
    
    private func handleSiteInjctsDetailsResponse(_ json: JSON) {
        //
        let jsonObject = PVESiteInjctsDetailsResponse(json)
        
        dismissGlobalHUD(self.view)
        UserDefaults.standard.set(false, forKey: "getApiCalled")
        if !isUpdateCustomer {
            self.showGlobalProgressHUDWithTitle(self.view, title: "Fetching Images...Please wait, This may take a while.")
            delegate?.fetchGetAPIResponse()
        }
        else {
            Helper.dismissGlobalHUD(self.view)
        }
        
    }
    
    
    
    private func getBlankPDFDetailsPVE(){
        
        CoreDataHandler().deleteAllData("PVE_PdfDetails")
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            self.showGlobalProgressHUDWithTitle(self.view, title: "")
            
            let jsonDict = ["ReportType" : "1"]
            
            if let theJSONData = try? JSONSerialization.data( withJSONObject: jsonDict, options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("SNA Json = \n\(theJSONText)")
            }
            
            ZoetisWebServices.shared.getblankPDFPVE(controller: self, parameters: jsonDict, completion: { [weak self] (json, error) in
                guard let `self` = self, error == nil else { return }
                print("res json -- \(json)")
                self.handleblankPdfResponse(json)
                
            })
            //  showtoast(message: "Downloading")
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download PDF.", comment: ""))
        }
        stopLoader()
        
    }
    
    private func handleblankPdfResponse(_ json: JSON) {
        
        let jsonObject = PVEBlankPdfResponse(json)
        
    }
    
    private func getOtherPDFDetailsPVE(){
        
        CoreDataHandler().deleteAllData("PVE_PdfDetails")
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            self.showGlobalProgressHUDWithTitle(self.view, title: "")
            
            let jsonDict = ["ReportType" : "0"]
            
            if let theJSONData = try? JSONSerialization.data( withJSONObject: jsonDict, options: .prettyPrinted),
               let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("SNA Json = \n\(theJSONText)")
            }
            
            ZoetisWebServices.shared.getblankPDFPVE(controller: self, parameters: jsonDict, completion: { [weak self] (json, error) in
                guard let `self` = self, error == nil else { return }
                print("res json -- \(json)")
                self.handleOtherPdfResponse(json)
                
            })
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString("Alert", comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download PDF.", comment: ""))
        }
        stopLoader()
        
    }
    
    private func handleOtherPdfResponse(_ json: JSON) {
        
        let jsonObject = PVEOtherPdfResponse(json)
        
    }
    
    @objc func stopLoader(notification: NSNotification){
        
        dismissGlobalHUD(self.view)
    }
    
    func stopLoader() {
        dismissGlobalHUD(self.view)
    }
    
}




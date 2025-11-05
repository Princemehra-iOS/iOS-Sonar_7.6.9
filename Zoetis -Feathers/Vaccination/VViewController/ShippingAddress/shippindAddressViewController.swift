//
//  shippindAddressViewController.swift
//  Zoetis -Feathers
//
//  Created by PRINCE on 28/09/24.
//

import UIKit

class shippindAddressViewController: BaseViewController , UITextFieldDelegate {
    
    var onDismiss: (() -> Void)?
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addressline1TxtFld: UITextField!
    @IBOutlet weak var addressline2TxtFld: UITextField!
    @IBOutlet weak var zipCodeTxtFld: UITextField!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var selectedState: UILabel!
    @IBOutlet weak var selectedCity: UILabel!
    @IBOutlet weak var selectedCountry: UILabel!
    @IBOutlet weak var fsmName: UILabel!
    @IBOutlet weak var siteNameLbl: UILabel!
    @IBOutlet weak var otherAdrrsBtn: UIButton!
    @IBOutlet weak var otherImgView: UIImageView!
    @IBOutlet weak var zipCodeValidation: UILabel!
    @IBOutlet weak var ShippingZipCodeValidation: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    
    var curentCertification:VaccinationCertificationVM?
  
    let maxLengthForTextField1 = 50
    let maxLengthForTextField3 = 35
    let maxLengthForTextField2 = 7
    var countryList = [VaccinationCountry]()
    var stateList = [VaccinationState]()
    var isSafetyCertification:Bool = false
    var shippingInfo : ShippingAddressDTO?
    
    var OtherAddresShippingInfo : ShippingAddressDTO?
    var countryId = Int()
    var stateId = Int()
    var trainingId = Int()
    var fssId = Int()
    var isOtherAddressSelected: Bool = false
    var otherStateId = Int()
    
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    
    //*****  Other Address Fields *****
    @IBOutlet weak var shipLblState: UILabel!
    @IBOutlet weak var shipLblZip: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var shippingAdrsView: UIView!
    var isChecked: Bool = true
    @IBOutlet weak var mainViewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shippingAddressline1TxtFld: UITextField!
    @IBOutlet weak var shippingAddressline2TxtFld: UITextField!
    @IBOutlet weak var shippingZipCodeTxtFld: UITextField!
    @IBOutlet weak var shippingCityTextField: UITextField!
    @IBOutlet weak var ShippingStateBtn: UIButton!
    @IBOutlet weak var ShippingCountryBtn: UIButton!
    @IBOutlet weak var shippingSelectedState: UILabel!
    @IBOutlet weak var shippingSelectedCountry: UILabel!
    @IBOutlet weak var OtherShippingAdrsView: UIView!
    @IBOutlet weak var siteAddressStateDropDwnImage: UIImageView!
    var OthercurentCertification = VaccinationCertificationVM()
    @IBOutlet weak var contentView: UIView!
    
    
    fileprivate func setupSavedShippingInfo(_ shippingInfoDB: ShippingAddressDTO? , _ otherAddresShippingInfoDB: ShippingAddressDTO?) {
        if curentCertification?.fsmName != "" {
            if let selecFsmName = curentCertification?.fsrName {
                fsmName.text = selecFsmName
            } else {
                fsmName.text = curentCertification?.selectedFsmName
            }
        } else {
            fsmName.text =  shippingInfoDB?.fssName
        }
        
        if let certId = curentCertification?.certificationId {
            let approverData = ApproverStore.shared.getApprover(for: certId)
            fsmName.text = approverData?.approverName
        }
        if let certId = curentCertification?.siteName {
            siteNameLbl.text = curentCertification?.siteName
        }
        
        shippingInfo = shippingInfoDB!
        OtherAddresShippingInfo = otherAddresShippingInfoDB
        if let otherAddress = otherAddresShippingInfoDB,
           (otherAddress.address1?.isEmpty == false || otherAddress.stateName?.isEmpty == false) {
            self.showOtherShippingAddressView()
            
            OtherAddresShippingInfo = otherAddress
            
            self.shippingAddressline1TxtFld.text = OtherAddresShippingInfo?.address1
            self.shippingAddressline2TxtFld.text = OtherAddresShippingInfo?.address2
            self.shippingCityTextField.text = OtherAddresShippingInfo?.city
            self.shippingZipCodeTxtFld.text = OtherAddresShippingInfo?.pincode
            
            self.countryId = OtherAddresShippingInfo?.countryID ?? 0
            self.otherStateId = OtherAddresShippingInfo?.stateID ?? 0
            self.shippingSelectedState.text = OtherAddresShippingInfo?.stateName
            self.shippingSelectedCountry.text = OtherAddresShippingInfo?.countryName
            
            self.addressline1TxtFld.text = shippingInfo?.address1
            self.addressline2TxtFld.text = shippingInfo?.address2
            self.cityTextField.text = shippingInfo?.city
            self.zipCodeTxtFld.text = shippingInfo?.pincode
            self.countryId = shippingInfo?.countryID ?? 0
            self.stateId = shippingInfo?.stateID ?? 0
            self.selectedState.text = shippingInfo?.stateName
            self.selectedCountry.text = shippingInfo?.countryName
 
        }
        else
        {
            
            self.setUpShippingAddressView(isVisible: true, height: 500)
            
            self.addressline1TxtFld.text = shippingInfo?.address1
            self.addressline2TxtFld.text = shippingInfo?.address2
            self.cityTextField.text = shippingInfo?.city
            self.zipCodeTxtFld.text = shippingInfo?.pincode
            self.countryId = shippingInfo?.countryID ?? 0
            self.stateId = shippingInfo?.stateID ?? 0
            self.selectedState.text = shippingInfo?.stateName
            self.selectedCountry.text = shippingInfo?.countryName
            
        }

        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        self.curentCertification?.FSSId = shippingInfo?.fssID
        
    }
    
    
    fileprivate func SavedShippingInfoDetails(_ shippingInfoDB: ShippingAddressDTO? , _ otherAddresShippingInfoDB: ShippingAddressDTO?) {
        if curentCertification?.fsmName != "" {
            if let selecFsmName = curentCertification?.fsrName {
                fsmName.text = selecFsmName
            } else {
                fsmName.text = curentCertification?.selectedFsmName
            }
        } else {
            fsmName.text =  shippingInfoDB?.fssName
        }
        
        if let certId = curentCertification?.certificationId {
            let approverData = ApproverStore.shared.getApprover(for: certId)
            fsmName.text = approverData?.approverName
        }
        if let certId = curentCertification?.siteName {
            siteNameLbl.text = curentCertification?.siteName
        }
        
        shippingInfo = shippingInfoDB!
        OtherAddresShippingInfo = otherAddresShippingInfoDB
        if let otherAddress = otherAddresShippingInfoDB,
           (otherAddress.address1?.isEmpty == false || otherAddress.stateName?.isEmpty == false) {
            // Proceed with non-empty address1 or stateName
            OtherAddresShippingInfo = otherAddress
            
            self.showOtherShippingAddressView()

            OtherAddresShippingInfo = otherAddress
            
            self.shippingAddressline1TxtFld.text = OtherAddresShippingInfo?.address1
            self.shippingAddressline2TxtFld.text = OtherAddresShippingInfo?.address2
            self.shippingCityTextField.text = OtherAddresShippingInfo?.city
            self.shippingZipCodeTxtFld.text = OtherAddresShippingInfo?.pincode
            
            self.countryId = OtherAddresShippingInfo?.countryID ?? 0
            self.otherStateId = OtherAddresShippingInfo?.stateID ?? 0
            self.shippingSelectedState.text = OtherAddresShippingInfo?.stateName
            self.shippingSelectedCountry.text = OtherAddresShippingInfo?.countryName
            
            self.addressline1TxtFld.text = shippingInfo?.address1
            self.addressline2TxtFld.text = shippingInfo?.address2
            self.cityTextField.text = shippingInfo?.city
            self.zipCodeTxtFld.text = shippingInfo?.pincode
            var countryAddressId = String(shippingInfo?.countryID ?? 0)
            self.countryId = shippingInfo?.countryID ?? 0
            self.stateId = shippingInfo?.stateID ?? 0
            self.selectedState.text = shippingInfo?.stateName
            self.selectedCountry.text = shippingInfo?.countryName
            
        }
        else
        {
            self.setUpShippingAddressView(isVisible: true, height: 500)
            
            self.addressline1TxtFld.text = shippingInfo?.address1
            self.addressline2TxtFld.text = shippingInfo?.address2
            self.cityTextField.text = shippingInfo?.city
            self.zipCodeTxtFld.text = shippingInfo?.pincode
            var countryAddressId = String(shippingInfo?.countryID ?? 0)
            self.countryId = shippingInfo?.countryID ?? 0
            self.stateId = shippingInfo?.stateID ?? 0
            self.selectedState.text = shippingInfo?.stateName
            self.selectedCountry.text = shippingInfo?.countryName
            
            shippingInfo?.siteId = Int(curentCertification?.siteId ?? "")
            shippingInfo?.siteName = curentCertification?.siteName

        }
        
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        self.curentCertification?.FSSId = shippingInfo?.fssID
        
    }
    
    fileprivate func handleShippingInfo(_ shippingInfoDB: inout ShippingAddressDTO?) {
        
        var otherAddressInfoDB: ShippingAddressDTO?
        
        if curentCertification?.selectedFsmId == nil || curentCertification?.selectedFsmId == "" {
            shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
            otherAddressInfoDB = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
        } else {
            shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
            otherAddressInfoDB = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
        }
        
        
        if shippingInfoDB != nil {
            shippingInfo = shippingInfoDB!
            OtherAddresShippingInfo = otherAddressInfoDB!
            
            if trainingId != 0
            {
                let address = OtherAddresShippingInfo?.address1?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let state = OtherAddresShippingInfo?.stateName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let pincode = OtherAddresShippingInfo?.pincode?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                if address.isEmpty || state.isEmpty || pincode.isEmpty {
                    
                    self.addressline1TxtFld.text = shippingInfo?.address1
                    self.addressline2TxtFld.text = shippingInfo?.address2
                    self.cityTextField.text = shippingInfo?.city
                    self.zipCodeTxtFld.text = shippingInfo?.pincode
                    let handledCountryId = String(shippingInfo?.countryID ?? 0)
                    self.countryId = shippingInfo?.countryID ?? 0
                    self.stateId = shippingInfo?.stateID ?? 0
                    
                    let handledStateId = String(shippingInfo?.stateID ?? 0)
                    self.selectedState.text = shippingInfo?.stateName
                    self.selectedCountry.text = shippingInfo?.countryName
               
                }
                else
                {
                    self.addressline1TxtFld.text = OtherAddresShippingInfo?.address1
                    self.addressline2TxtFld.text = OtherAddresShippingInfo?.address2
                    self.cityTextField.text = OtherAddresShippingInfo?.city
                    self.zipCodeTxtFld.text = OtherAddresShippingInfo?.pincode
                    let handledCountryId = String(OtherAddresShippingInfo?.countryID ?? 0)
                    self.countryId = OtherAddresShippingInfo?.countryID ?? 0
                    self.otherStateId = OtherAddresShippingInfo?.stateID ?? 0
                    
                    let handledStateId = String(OtherAddresShippingInfo?.stateID ?? 0)
                    self.selectedState.text = OtherAddresShippingInfo?.stateName
                    self.selectedCountry.text = OtherAddresShippingInfo?.countryName
                }
            }
            else
            {
                let address = OtherAddresShippingInfo?.address1?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let state = OtherAddresShippingInfo?.stateName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let pincode = OtherAddresShippingInfo?.pincode?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let city = OtherAddresShippingInfo?.city?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                if address.isEmpty && state.isEmpty && pincode.isEmpty  && city.isEmpty {

                    self.setUpShippingAddressView(isVisible: true, height: 500)

                    self.addressline1TxtFld.text = shippingInfo?.address1
                    self.addressline2TxtFld.text = shippingInfo?.address2
                    self.cityTextField.text = shippingInfo?.city
                    self.zipCodeTxtFld.text = shippingInfo?.pincode
                    let handledCountryId = String(shippingInfo?.countryID ?? 0)
                    self.countryId = shippingInfo?.countryID ?? 0
                    self.stateId = shippingInfo?.stateID ?? 0
                    
                    let handledStateId = String(shippingInfo?.stateID ?? 0)
                    self.selectedState.text = shippingInfo?.stateName
                    self.selectedCountry.text = shippingInfo?.countryName
                }
                else
                {
                    self.showOtherShippingAddressView()

                      self.shippingAddressline1TxtFld.text = OtherAddresShippingInfo?.address1
                      self.shippingAddressline2TxtFld.text = OtherAddresShippingInfo?.address2
                      self.shippingCityTextField.text = OtherAddresShippingInfo?.city
                      self.shippingZipCodeTxtFld.text = OtherAddresShippingInfo?.pincode
                      self.countryId = OtherAddresShippingInfo?.countryID ?? 0
                      self.otherStateId = OtherAddresShippingInfo?.stateID ?? 0
                      self.shippingSelectedState.text = OtherAddresShippingInfo?.stateName
                      self.shippingSelectedCountry.text = OtherAddresShippingInfo?.countryName
                  
                      self.addressline1TxtFld.text = shippingInfo?.address1
                      self.addressline2TxtFld.text = shippingInfo?.address2
                      self.cityTextField.text = shippingInfo?.city
                      self.zipCodeTxtFld.text = shippingInfo?.pincode
                      let handledCountryId = String(shippingInfo?.countryID ?? 0)
                      self.countryId = shippingInfo?.countryID ?? 0
                      self.stateId = shippingInfo?.stateID ?? 0
                      
                      let handledStateId = String(shippingInfo?.stateID ?? 0)
                      self.selectedState.text = shippingInfo?.stateName
                      self.selectedCountry.text = shippingInfo?.countryName

                }
                
            }
            
            if curentCertification?.selectedFsmId == nil {
                fsmName.text =  curentCertification?.fsrName
            } else {
                fsmName.text =  curentCertification?.selectedFsmName
            }
            
            if curentCertification?.siteName == nil {
                siteNameLbl.text =  ""
            } else {
                siteNameLbl.text =  curentCertification?.siteName
            }
            
            self.curentCertification?.FSSId = shippingInfo?.fssID
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
        
        if let certId = curentCertification?.certificationId {
            let approverData = ApproverStore.shared.getApprover(for: certId)
            fsmName.text = approverData?.approverName
        }
    }
    
    fileprivate func handleCertificationValidation() {
        if (self.curentCertification == nil || self.curentCertification?.certificationId == nil),
           (isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"),
           let certobj = VaccinationDashboardDAO.sharedInstance.getStartedCertObjByCategory(
            userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "",
            certificationCategoryId: VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
           ) {
            self.curentCertification = certobj
        }
        
        if self.curentCertification == nil || self.curentCertification?.certificationId == nil {
            self.curentCertification = VaccinationCertificationVM()
        }
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        countryBtn.setTitle("", for: .normal)
        stateBtn.setTitle("", for: .normal)
        cityTextField.tintColor = .black
        addressline1TxtFld.tintColor = .black
        addressline2TxtFld.tintColor = .black
        zipCodeTxtFld.tintColor = .black
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.countryBtn.isUserInteractionEnabled = false
        self.setupCertification()
        setBorderView(countryBtn)
        setBorderView(stateBtn)
        setBorderForTxtFld(addressline1TxtFld , padding: 10)
        setBorderForTxtFld(addressline2TxtFld, padding: 10)
        setBorderForTxtFld(cityTextField, padding: 10)
        setBorderForTxtFld(zipCodeTxtFld, padding: 10)
        
        setBorderView(ShippingStateBtn)
        setBorderView(ShippingCountryBtn)
        
        setBorderForTxtFld(shippingAddressline1TxtFld , padding: 10)
        setBorderForTxtFld(shippingAddressline2TxtFld, padding: 10)
        setBorderForTxtFld(shippingCityTextField, padding: 10)
        setBorderForTxtFld(shippingZipCodeTxtFld, padding: 10)
        
        otherAdrrsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        addAddressBtn.setGradient(topGradientColor: UIColor.getEmployeeStartBtnUpperGradient(), bottomGradientColor: UIColor.getDashboardTableHeaderLowerGradColor())
        
        handleCertificationValidation()
        
        headerView.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        headerView.setGradient(topGradientColor: UIColor.getDashboardTableHeaderUpperGradColor(), bottomGradientColor: UIColor.getDashboardTableHeaderLowerGradColor())
        mainContentView.setGradient(topGradientColor: UIColor.white , bottomGradientColor: UIColor.getAddEmployeeGradient())
        
        if let country = selectedCountry.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            switch country {
            case "united states":
                lblState.text = "State*"
                lblZip.text = "Zip Code*"
                shipLblState.text = "State*"
                shipLblZip.text = "Zip Code*"
            case "canada":
                lblState.text = "Province*"
                lblZip.text = "Postal Code*"
                shipLblState.text = "Province*"
                shipLblZip.text = "Postal Code*"
            default:
                lblState.text = "State*"
                lblZip.text = "Zip Code*"
                shipLblState.text = "State*"
                shipLblZip.text = "Zip Code*"
            }
        }


        if self.curentCertification?.certificationCategoryId == "1" {
            isSafetyCertification = true
        }
        
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {
            self.addressline1TxtFld.isUserInteractionEnabled = false
            self.addressline2TxtFld.isUserInteractionEnabled = false
            self.cityTextField.isUserInteractionEnabled = false
            self.zipCodeTxtFld.isUserInteractionEnabled = false
            self.countryBtn.isUserInteractionEnabled = false
            self.stateBtn.isUserInteractionEnabled = false
            self.addAddressBtn.isUserInteractionEnabled = false
            self.otherAdrrsBtn.isUserInteractionEnabled = false
           
            self.headerLbl.text = "Shipping Address Details"
            self.addAddressBtn.setTitle("Done", for: .normal)
        }
        self.checkFieldInteraction()
        
    }
    func checkFieldInteraction () {
        
        stateBtn.titleLabel?.alpha = 0
        ShippingStateBtn.titleLabel?.alpha = 0
        ShippingCountryBtn.titleLabel?.alpha = 0
        checkBoxBtn.titleLabel?.alpha = 0
        let textFields = [addressline1TxtFld, addressline2TxtFld, cityTextField, zipCodeTxtFld]
        if Constants.updateSiteAddress == true
        {
            for tf in textFields {
                tf?.isUserInteractionEnabled = true
            }
        }
        else{

            for tf in textFields {
                tf?.isUserInteractionEnabled = false
                tf?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                tf?.textColor = .darkGray
            }
            stateBtn.isUserInteractionEnabled = false
            stateBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            selectedState.textColor = UIColor.darkGray.withAlphaComponent(1.0)
           
            countryBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            selectedCountry.textColor = UIColor.darkGray.withAlphaComponent(1.0)
            siteAddressStateDropDwnImage.isHidden = true

        }
        
    }
    
    func setupCertification() {
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.draft.rawValue || curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {
            let shippingInfoAcknowldge = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(Constants.selectedSiteId) ?? 0 )
            var otherShippingAddress = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(Constants.selectedSiteId) ?? 0 )
            var shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId)
            var id = self.trainingId
            if id == 0 {
                id = Int(curentCertification?.siteId ?? "") ?? 0
                shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId,id)
                
                Constants.updateSiteAddress = false
                if (shippingInfoDB?.address1?.isEmpty ?? true) ||
                   (shippingInfoDB?.pincode?.isEmpty ?? true) ||
                   (shippingInfoDB?.city?.isEmpty ?? true) ||
                   (shippingInfoDB?.stateName?.isEmpty ?? true) {
                    Constants.updateSiteAddress = true
                }
            }
            else
            {
                otherShippingAddress = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingAddressByTrainingId(trainingId: id)
                shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId)
            }
           
            if shippingInfoDB != nil {
                if let data = UserDefaults.standard.data(forKey: "\(curentCertification?.selectedFsmId ?? "")"),
                   let savedUser = try? JSONDecoder().decode(ShippingAddressDTO.self, from: data) {
                    if id == 0 {
                        SavedShippingInfoDetails(shippingInfoAcknowldge, otherShippingAddress)
                    }
                    else
                    {
                        SavedShippingInfoDetails(shippingInfoDB, otherShippingAddress)
                    }
                    
                } else {
                    setupSavedShippingInfo(shippingInfoDB , otherShippingAddress)
                }
            }
        } else {
            var shippingInfoDB: ShippingAddressDTO?
            shippingInfoDB = nil
            handleShippingInfo(&shippingInfoDB)
        }
    }
    // MARK: Add Address Button Action
    @IBAction func doneBtnAction(_ sender: Any) {
        countryBtn.setTitle("", for: .normal)
        stateBtn.setTitle("", for: .normal)
        
        // ✅ Stop here if validations fail
//           guard checkVaidations() else {
//               return
//           }
//           
//           self.dismiss(animated: true) {
//               self.onDismiss?()
//           }
        
        
        if checkVaidations() {
            self.dismiss(animated: true) {
                self.onDismiss?()
            }
        }
        
        if curentCertification?.selectedFsmId == nil {
            self.shippingInfo?.fssID =  Int(curentCertification?.fsrId ?? "")
        }
        else{
            self.shippingInfo?.fssID = Int(self.curentCertification?.selectedFsmId ?? "")
        }
        
        if curentCertification?.certificationId == nil || curentCertification?.certificationId == "0" {
            self.shippingInfo?.trainingID = 0
            self.curentCertification?.TrainingId = 0
        }
        else{
            self.shippingInfo?.trainingID =  Int(curentCertification?.certificationId ?? "")
        }
      
        self.OtherAddresShippingInfo?.id = Int(self.curentCertification?.Id ?? 0)
        
        self.shippingInfo?.id = Int(self.curentCertification?.Id ?? 0)
        self.shippingInfo?.fssName = self.fsmName.text
        // New Change to set the Crtificate Sync Status to make it available for Syncing
        self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
        if let encoded = try? JSONEncoder().encode(shippingInfo) {
            UserDefaults.standard.set(encoded, forKey: "\(curentCertification?.selectedFsmId ?? "")")
        }
   
        if isOtherAddressSelected
        {
            
            self.OtherAddresShippingInfo?.address1 = OthercurentCertification.Address1 ?? shippingAddressline1TxtFld.text
            self.OtherAddresShippingInfo?.address2 = OthercurentCertification.Address2 ?? shippingAddressline2TxtFld.text
            
            self.OtherAddresShippingInfo?.pincode = OthercurentCertification.Pincode ?? shippingZipCodeTxtFld.text
            self.OtherAddresShippingInfo?.city = OthercurentCertification.City ?? shippingCityTextField.text
            
            self.OtherAddresShippingInfo?.siteName = curentCertification?.siteName
            self.OtherAddresShippingInfo?.siteId = Int(self.curentCertification?.siteId ?? "")
            
            self.OtherAddresShippingInfo?.stateName = OthercurentCertification.StateName ?? selectedState.text
            self.OtherAddresShippingInfo?.stateID = OthercurentCertification.StateId
            
            self.OtherAddresShippingInfo?.adddressType = isOtherAddressSelected
            self.OtherAddresShippingInfo?.trainingID = Int(curentCertification?.certificationId ?? "")
            self.OtherAddresShippingInfo?.id = Int(curentCertification?.certificationId ?? "")
            
            OtherAddresShippingInfo?.countryID = self.countryId
            let countryName = VaccinationCustomersDAO.sharedInstance.fetchCountryNameFromCountryId(countryId: "\(countryId)")
            OtherAddresShippingInfo?.countryName = countryName
            
            OtherAddresShippingInfo?.stateID = self.otherStateId
            let stateName = VaccinationCustomersDAO.sharedInstance.fetchStateNameFromStateId(stateId: "\(self.otherStateId)")
            OtherAddresShippingInfo?.stateName = stateName
                        
            saveCountryAndState(certId: OthercurentCertification.certificationId ?? "",
                                countryId: OthercurentCertification.CountryId,
                                stateId: OthercurentCertification.StateId,
                                addressLine1: OthercurentCertification.Address1,
                                addressLine2:OthercurentCertification.Address2,
                                city: OthercurentCertification.City,
                                zip: OthercurentCertification.Pincode,
                                siteId: Int(curentCertification?.siteId ?? ""),
                                siteName:OthercurentCertification.siteName,
                                countryName:OthercurentCertification.CountryName,
                                stateName:OthercurentCertification.StateName,
                                isOtherAddress:isOtherAddressSelected )
            // New Change to set the Crtificate Data so that i wont become nil when we make changes & go back directly to draft Section
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
     //       VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.OthercurentCertification)
        }
        else{
            
            self.shippingInfo?.countryID = Int(self.countryId)
            self.shippingInfo?.countryName = selectedCountry.text
            
            self.shippingInfo?.address1 = addressline1TxtFld.text
            self.shippingInfo?.address2 = addressline2TxtFld.text
            
            self.shippingInfo?.pincode = zipCodeTxtFld.text
            self.shippingInfo?.city = cityTextField.text
            
            self.shippingInfo?.siteName = curentCertification?.siteName
            self.shippingInfo?.siteId = Int(self.curentCertification?.siteId ?? "")
            
            self.shippingInfo?.stateName = selectedState.text
            self.shippingInfo?.stateID =  Int(self.stateId)
            self.shippingInfo?.adddressType = isOtherAddressSelected
            self.shippingInfo?.trainingID = Int(curentCertification?.certificationId ?? "")
            self.shippingInfo?.id = Int(curentCertification?.certificationId ?? "")
            self.curentCertification?.Pincode = zipCodeTxtFld.text
            
            OtherAddresShippingInfo?.countryID = self.countryId
            OtherAddresShippingInfo?.countryName = selectedCountry.text
            
            OtherAddresShippingInfo?.stateID = self.otherStateId
            let otherstateName = VaccinationCustomersDAO.sharedInstance.fetchStateNameFromStateId(stateId: "\(self.otherStateId)")
            OtherAddresShippingInfo?.stateName = otherstateName
            
            saveSiteAddress(certId: curentCertification?.certificationId ?? "",
                                countryId: Int(self.countryId),
                                stateId: Int(self.stateId),
                                addressLine1: self.addressline1TxtFld.text,
                                addressLine2: self.addressline2TxtFld.text,
                                city: self.cityTextField.text,
                                zip: self.zipCodeTxtFld.text,
                                siteId: Int(curentCertification?.siteId ?? ""),
                                siteName:curentCertification?.siteName,
                                countryName:curentCertification?.CountryName,
                                stateName:curentCertification?.StateName,
                                isOtherAddress:isOtherAddressSelected )
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
            
        }
        
        if isChecked
        {
            var shippingInfoArr = [ShippingAddressDTO]()
            shippingInfoArr.append(shippingInfo!)
            VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: shippingInfoArr)
            
            var otherInfo = [ShippingAddressDTO]()
            otherInfo.append(OtherAddresShippingInfo!)
            VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: otherInfo)
        }
        else
        {
            var shippingInfoArr = [ShippingAddressDTO]()
            shippingInfoArr.append(shippingInfo!)
            VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: shippingInfoArr)
            
            if let info = OtherAddresShippingInfo {
                info.address1 = ""
                info.address2 = ""
                info.city = ""
                info.pincode = ""
                info.stateName = ""
                info.stateID = 0
                info.countryID = 0
                info.countryName = ""
            
                OtherAddresShippingInfo = info
            }
            
            var otherInfo = [ShippingAddressDTO]()
            otherInfo.append(OtherAddresShippingInfo!)
            VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: otherInfo)
        }
        self.curentCertification?.FSSId = shippingInfo?.fssID
       
    }
    // MARK: Cross Button Action
    @IBAction func crossBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Country Button Action
    @IBAction func countryBtnAction(_ sender: Any) {
        countryList = VaccinationCustomersDAO.sharedInstance.getCountryListVM()
        countryList = countryList.sorted { $0.countryName ?? "" < $1.countryName ?? "" }
        self.setDropDown(countryBtn)
    }
    
    // MARK: State Button Action
    @IBAction func StateBtnAction(_ sender: Any) {
        stateList = VaccinationCustomersDAO.sharedInstance.getStateListVM(user_id: UserContext.sharedInstance.userDetailsObj?.userId ?? Constants.noIdFoundStr)
        stateList = stateList.sorted { $0.stateName ?? "" < $1.stateName ?? "" }
        if selectedCountry.text != "" {
            self.setDropDown(stateBtn)
        }
        else {
            let alertController = UIAlertController(title: Constants.alertStr, message: "Please select a country first.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: Shipping State Button Action
    @IBAction func ShippingStateBtnAction(_ sender: Any) {
        stateList = VaccinationCustomersDAO.sharedInstance.getStateListVM(user_id: UserContext.sharedInstance.userDetailsObj?.userId ?? Constants.noIdFoundStr)
        stateList = stateList.sorted { $0.stateName ?? "" < $1.stateName ?? "" }
        if shippingSelectedCountry.text != "" {
            self.setDropDown(ShippingStateBtn)
        }
        else {
            let alertController = UIAlertController(title: Constants.alertStr, message: "Please select a country first.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Other Site Address Button Action
    @IBAction func otherAdresBtnActn(_ sender: Any) {

        isOtherAddressSelected = true
        shippingInfo?.adddressType = true
        Constants.getSiteAdderss = false
        curentCertification?.isOtherAddress = isOtherAddressSelected
        
        addressline1TxtFld.text = self.OtherAddresShippingInfo?.address1
        addressline2TxtFld.text = self.OtherAddresShippingInfo?.address2
        zipCodeTxtFld.text = self.OtherAddresShippingInfo?.pincode
        cityTextField.text = self.OtherAddresShippingInfo?.city
        selectedState.text = self.OtherAddresShippingInfo?.stateName

    }
    
    // MARK: Check Box Button Action
    @IBAction func checkBoxBtnActn(_ sender: UIButton) {
        if isChecked {
          
            self.setUpShippingAddressView(isVisible: true, height: 500)
    
            addressline1TxtFld.text = self.shippingInfo?.address1
            addressline2TxtFld.text = self.shippingInfo?.address2
            zipCodeTxtFld.text = self.shippingInfo?.pincode
            cityTextField.text = self.shippingInfo?.city
            selectedState.text = self.shippingInfo?.stateName
            
            shippingInfo?.siteId = Int(curentCertification?.siteId ?? "")
            shippingInfo?.siteName = curentCertification?.siteName
            shippingInfo?.countryID = countryId
            
            let handledCountryId = String(countryId)
            let countryName = VaccinationCustomersDAO.sharedInstance.fetchCountryNameFromCountryId(countryId: handledCountryId)
            shippingInfo?.countryName = countryName
            
            shippingInfo?.stateID = self.stateId
            let stateName = VaccinationCustomersDAO.sharedInstance.fetchStateNameFromStateId(stateId: "\(self.stateId)")
            shippingInfo?.stateName = stateName
        }
        else {
            self.showOtherShippingAddressView()
            
            [addressline1TxtFld, addressline2TxtFld, cityTextField, zipCodeTxtFld].forEach {
                  $0.layer.borderColor =  UIColor.getBorderColorr().cgColor
              }
              [countryBtn, stateBtn].forEach {
                  $0.layer.borderColor =  UIColor.getBorderColorr().cgColor
              }

              // Also hide any validation labels
              zipCodeValidation.isHidden = true
                        
            shippingAddressline1TxtFld.text = self.OtherAddresShippingInfo?.address1
            shippingAddressline2TxtFld.text = self.OtherAddresShippingInfo?.address2
            shippingZipCodeTxtFld.text = self.OtherAddresShippingInfo?.pincode
            shippingCityTextField.text = self.OtherAddresShippingInfo?.city
            shippingSelectedState.text = self.OtherAddresShippingInfo?.stateName
            
            OtherAddresShippingInfo?.siteId = Int(curentCertification?.siteId ?? "")
            OtherAddresShippingInfo?.siteName = curentCertification?.siteName
            OtherAddresShippingInfo?.countryID = countryId
            OtherAddresShippingInfo?.fssID = curentCertification?.FSSId
            OtherAddresShippingInfo?.fssName = curentCertification?.FSSName
            
            let handledCountryId = String(countryId)
            let countryName = VaccinationCustomersDAO.sharedInstance.fetchCountryNameFromCountryId(countryId: handledCountryId)
            OtherAddresShippingInfo?.countryName = countryName
            shippingSelectedCountry.text = countryName
  
        }
    }
    
    // MARK: SHow other SHipping address view
    func showOtherShippingAddressView(withHeight height: CGFloat = 700) {
        self.mainViewHightConstraint.constant = height
        self.OtherShippingAdrsView.isHidden = false
        
        checkBoxBtn.setImage(UIImage(named: "checkbox-shiping"), for: .normal)
        shippingAdrsView.isHidden = true
        isOtherAddressSelected = true
        isChecked = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.mainContentView.setGradientcheck(
                topGradientColor: .white,
                bottomGradientColor: UIColor.getAddEmployeeGradient()
            )
        })
    }

    // MARK: SHow Site address view
    func setUpShippingAddressView(isVisible: Bool, height: CGFloat) {
        self.mainViewHightConstraint.constant = height
        self.OtherShippingAdrsView.isHidden = isVisible
        
        checkBoxBtn.setImage(UIImage(named: "shiping_Uncheckbox"), for: .normal)
        isChecked = false
        isOtherAddressSelected = false
        shippingAdrsView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.mainContentView.setGradientcheck(
                topGradientColor: .white,
                bottomGradientColor: UIColor.getAddEmployeeGradient()
            )
        })
    }
    
    // MARK: - Validations check
    func checkVaidations() -> Bool {
        // can delete this
        var isValidated = true
        let red = UIColor.red.cgColor
        let borderClr = UIColor.getBorderColorr().cgColor

        // Reset all borders
        [addressline1TxtFld, addressline2TxtFld, cityTextField, zipCodeTxtFld,
         shippingAddressline1TxtFld, shippingCityTextField, shippingZipCodeTxtFld].forEach { $0.layer.borderColor = borderClr }
        [countryBtn, stateBtn, ShippingCountryBtn, ShippingStateBtn].forEach { $0.layer.borderColor = borderClr }

        zipCodeValidation.isHidden = true
        ShippingZipCodeValidation.isHidden = true

        var isSiteAddressValid = true
        var isShippingAddressValid = true

        // ✅ CASE 1: isChecked is true → validate ONLY shipping address
        if isChecked {
            if shippingAddressline1TxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                shippingAddressline1TxtFld.layer.borderColor = red
                isShippingAddressValid = false
            }
            if shippingSelectedCountry.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                ShippingCountryBtn.layer.borderColor = red
                isShippingAddressValid = false
            }
            if shippingSelectedState.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                ShippingStateBtn.layer.borderColor = red
                isShippingAddressValid = false
            }
            if shippingCityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                shippingCityTextField.layer.borderColor = red
                isShippingAddressValid = false
            }
            if shippingZipCodeTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                shippingZipCodeTxtFld.layer.borderColor = red
                isShippingAddressValid = false
            }
            if !validateZipCode(shippingZipCodeTxtFld.text, forCountryID: OtherAddresShippingInfo?.countryID, textField: shippingZipCodeTxtFld, errorLabel: ShippingZipCodeValidation) {
                isShippingAddressValid = false
            }

            isValidated = isShippingAddressValid
        }

        // ✅ CASE 2: isChecked is false → validate ONLY site address
        else {
            if addressline1TxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                addressline1TxtFld.layer.borderColor = red
                isSiteAddressValid = false
            }
            if selectedCountry.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                countryBtn.layer.borderColor = red
                isSiteAddressValid = false
            }
            if selectedState.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                stateBtn.layer.borderColor = red
                isSiteAddressValid = false
            }
            if cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                cityTextField.layer.borderColor = red
                isSiteAddressValid = false
            }
            if zipCodeTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                zipCodeTxtFld.layer.borderColor = red
                isSiteAddressValid = false
            }
            if !validateZipCode(zipCodeTxtFld.text, forCountryID: shippingInfo?.countryID, textField: zipCodeTxtFld, errorLabel: zipCodeValidation) {
                isSiteAddressValid = false
            }

            isValidated = isSiteAddressValid
        }

        if !isValidated {
            self.showValidationAlert(alertText: Constants.mandatoryFields)
        }

        return isValidated
    }

    // MARK: Zip/ Postal Code Validation
    func validateZipCode(_ zip: String?, forCountryID countryID: Int?, textField: UITextField, errorLabel: UILabel) -> Bool {
        guard let countryID = countryID,
              let zip = zip?.trimmingCharacters(in: .whitespacesAndNewlines),
              !zip.isEmpty else {
            return true // Assume valid if not provided
        }

        errorLabel.isHidden = true
        textField.layer.borderColor = UIColor.clear.cgColor

        switch countryID {
        case 31:
            // 🇨🇦 Canada: Postal code should be 6 characters excluding space
            let zipNoSpaces = zip.replacingOccurrences(of: " ", with: "")
            if zipNoSpaces.count != 6 {
                errorLabel.text = "* Please enter a valid postal code."
                errorLabel.isHidden = false
                textField.layer.borderColor = UIColor.red.cgColor
                return false
            }

        case 40:
            // 🇺🇸 USA: 5-digit or 5+4 ZIP
            let usRegex = #"^\d{5}(-\d{4})?$"#
            if zip.range(of: usRegex, options: .regularExpression) == nil {
                errorLabel.text = "* Please enter a valid ZIP code."
                errorLabel.isHidden = false
                textField.layer.borderColor = UIColor.red.cgColor
                return false
            }

        default:
            break // Other countries: no specific validation
        }

        return true
    }

    
    
    
    func showValidationAlert(alertText : String) {
        let alertController = UIAlertController(title: Constants.alertStr, message: alertText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Get State List for Selected Country.
    private func getVaccinationStateList(countryId: String,stateId:Int?){
        DataService.sharedInstance.getVaccinationStateList(countryId: countryId, viewController: self,stateId: stateId, completion: { [weak self] (status, error) in
            guard let _ = self, error == nil else { return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationStatesList)
                }
            }
        })
    }
    // MARK: - Set dropdown for Country & State Button.
    func setDropDown(_ btn:UIButton){
        
        if curentCertification?.certificationStatus != VaccinationCertificationStatus.submitted.rawValue{
            var arr = self.countryList.map{ $0.countryName}
            if btn == countryBtn{
                arr = self.countryList.map{ $0.countryName}
            }
            else if btn == stateBtn{
                arr = self.stateList.map{ $0.stateName}
            }
            else if btn == ShippingStateBtn{
                arr = self.stateList.map{ $0.stateName}
            }
            
            self.dropDownVIewNew(arrayData: arr as! [String], kWidth: btn.frame.width, kAnchor: btn, yheight: btn.bounds.height) {
                [unowned self] selectedVal, index  in
                
                if btn == stateBtn {
                    selectedState.text = selectedVal
                    let element = self.stateList[index]

                        self.curentCertification?.StateId = Int(element.stateId ?? "")
                        self.curentCertification?.StateName = element.stateName ?? ""
                        self.shippingInfo?.stateID = Int(element.stateId ?? "")
                        self.shippingInfo?.stateName = element.stateName ?? ""
                        self.stateId = Int(element.stateId ?? "") ?? 0
                   
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                    if stateBtn.layer.borderColor == UIColor.red.cgColor {
                        stateBtn.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
                    }
                }
                
                else if btn == ShippingStateBtn {
                    shippingSelectedState.text = selectedVal
                    let element = self.stateList[index]
                    
                    self.OthercurentCertification.StateName =  element.stateName ?? ""
                    self.OthercurentCertification.StateId = Int(element.stateId ?? "")
                    self.OtherAddresShippingInfo?.stateID = Int(element.stateId ?? "")
                    self.OtherAddresShippingInfo?.stateName = element.stateName ?? ""
                    self.otherStateId = Int(element.stateId ?? "") ?? 0
                    
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                    if ShippingStateBtn.layer.borderColor == UIColor.red.cgColor {
                        ShippingStateBtn.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
                    }
                }

                else {
                    selectedCountry.text = selectedVal
                    selectedState.text = ""
                    let country = VaccinationCustomersDAO.sharedInstance.fetchCountryIdFromCountryName(countryName: selectedVal)
                    let value = country.first
                    let dropCountryId = value?.countryId ?? ""
                    self.getVaccinationStateList(countryId: dropCountryId,stateId: nil)
                    let ss = self.curentCertification?.StateId ?? 0
                    let element = self.countryList[index]
                   
                    self.shippingInfo?.countryID = Int(element.countryId ?? "")
                    self.shippingInfo?.countryName = selectedCountry.text
                    
                    if isOtherAddressSelected {
                        self.OthercurentCertification.CountryId =  Int(element.countryId ?? "")
                        self.OthercurentCertification.CountryName = selectedCountry.text
                        self.OtherAddresShippingInfo?.countryID = Int(element.countryId ?? "")
                        self.OtherAddresShippingInfo?.countryName = selectedCountry.text
                    }
                    else {
                        self.curentCertification?.CountryId = Int(element.countryId ?? "")
                        self.curentCertification?.CountryName = selectedCountry.text
                    }
                    
                    self.shippingInfo?.pincode = ""
                    self.zipCodeTxtFld.text = ""
                    self.countryId = Int(element.countryId ?? "") ?? 0
                    
                    if isOtherAddressSelected{
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                    }
                    else{
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                    }
                    
                    if countryBtn.layer.borderColor == UIColor.red.cgColor {
                        countryBtn.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
                    }
                }
            }
            self.dropHiddenAndShow()
        }
    }
    
    // MARK: - DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    // MARK: - Set Border View
    func setBorderView(_ btn:UIButton){
        btn.layer.borderWidth  = 2
        btn.layer.borderColor = UIColor.getBorderColorr().cgColor
        btn.layer.cornerRadius = 18.5
        btn.backgroundColor = UIColor.white
    }
    // MARK: - Set Textfield Border
    func setBorderForTxtFld(_ textField:UITextField ,  padding: CGFloat){
        textField.delegate = self
        textField.layer.borderWidth  = 2
        textField.layer.borderColor = UIColor.getBorderColorr().cgColor
        textField.layer.cornerRadius = 18.5
        textField.backgroundColor = UIColor.white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    // MARK: Zip Code field Validation.
    fileprivate func setupZipcodeValidation(input: String) -> Bool {
        // Reset red border color if previously set
        if zipCodeTxtFld.layer.borderColor == UIColor.red.cgColor {
            zipCodeTxtFld.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/255, blue: 253/255, alpha: 1).cgColor
        }
        
        // 1. Reject multiple consecutive spaces
        if input.contains("  ") {
            return false
        }
        // 2. Reject any character outside of A-Z, a-z, 0-9, and space
        let allowedCharset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ")
        if input.rangeOfCharacter(from: allowedCharset.inverted) != nil {
            return false
        }
        
        let countryIdIsv = selectedCountry.text
        let uppercasedInput = input.uppercased()
        
        if countryIdIsv == "United States" {
            // USA: Allow 5 digits or 5+4 format
            let usRegex = #"^\d{0,5}(-\d{0,4})?$"#
            return uppercasedInput.range(of: usRegex, options: .regularExpression) != nil
            
        } else if countryIdIsv == "Canada" {
            // Canada: Allow "A1A 1A1" or partial, with at most one space
            let caRegex = #"^[A-Z]{0,1}[0-9]{0,1}[A-Z]{0,1}( ?[0-9]{0,1}[A-Z]{0,1}[0-9]{0,1})?$"#
            return uppercasedInput.range(of: caRegex, options: .regularExpression) != nil
            
        } else {
            // Other countries: Allow all
            return true
        }
    }
    // MARK: Textfield Delegates.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        
        if textField == addressline1TxtFld {
            if addressline1TxtFld.layer.borderColor == UIColor.red.cgColor {
                addressline1TxtFld.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            }
            self.curentCertification?.Address1 = textField.text
            self.shippingInfo?.address1 = textField.text
            return newLength <= maxLengthForTextField1
        }
        
        else if textField == shippingAddressline1TxtFld {
            
            if shippingAddressline1TxtFld.layer.borderColor == UIColor.red.cgColor {
                shippingAddressline1TxtFld.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            }
            self.OthercurentCertification.Address1 = textField.text
            self.OtherAddresShippingInfo?.address1 = textField.text
            return newLength <= maxLengthForTextField1
        }
        
        else if textField == addressline2TxtFld {
            
            self.curentCertification?.Address2 = textField.text
            self.shippingInfo?.address2 = textField.text
            if addressline2TxtFld.layer.borderColor == UIColor.red.cgColor {
                addressline2TxtFld.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            }
            return newLength <= maxLengthForTextField3
        }
        else if textField == shippingAddressline2TxtFld {
            
            self.OthercurentCertification.Address2 = textField.text
            self.OtherAddresShippingInfo?.address2 = textField.text
            if shippingAddressline2TxtFld.layer.borderColor == UIColor.red.cgColor {
                shippingAddressline2TxtFld.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            }
            return newLength <= maxLengthForTextField3
        }
        else if textField == zipCodeTxtFld {
            guard !string.isEmpty else {
                return true
            }
            
            self.curentCertification?.Pincode = textField.text
            self.shippingInfo?.pincode = textField.text
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            return setupZipcodeValidation(input: currentText)
        }
        else if textField == shippingZipCodeTxtFld {
            guard !string.isEmpty else {
                return true
            }
            
            self.OthercurentCertification.Pincode = textField.text
            self.OtherAddresShippingInfo?.pincode = textField.text
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            return setupZipcodeValidation(input: currentText)
        }
        else if textField == cityTextField && cityTextField.layer.borderColor == UIColor.red.cgColor {
            
            self.curentCertification?.City = textField.text
            self.shippingInfo?.city = textField.text
            cityTextField.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            return newLength <= maxLengthForTextField3
        }
        else if textField == shippingCityTextField && shippingCityTextField.layer.borderColor == UIColor.red.cgColor {
            
            self.OthercurentCertification.City = textField.text
            self.OtherAddresShippingInfo?.city = textField.text
            shippingCityTextField.layer.borderColor = UIColor(displayP3Red: 216/255, green: 236/228, blue: 253/255, alpha: 1).cgColor
            return newLength <= maxLengthForTextField3
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92){
            debugPrint("shipping back space pressed.")
        } else if ((textField.text?.count)! > 45  ){
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == addressline1TxtFld {
            self.curentCertification?.Address1 = textField.text
            self.shippingInfo?.address1 = textField.text
        }
        else if textField == shippingAddressline1TxtFld {
            self.OthercurentCertification.Address1 = textField.text
            self.OtherAddresShippingInfo?.address1 =  self.OthercurentCertification.Address1
        }
        else if textField == addressline2TxtFld {
            self.curentCertification?.Address2 = textField.text
            self.shippingInfo?.address2 = textField.text
        }
        else if textField == shippingAddressline2TxtFld {
            self.OthercurentCertification.Address2 = textField.text
            self.OtherAddresShippingInfo?.address2 = self.OthercurentCertification.Address2
        }
        else if textField == cityTextField {
            self.curentCertification?.City = textField.text
            self.shippingInfo?.city = textField.text
        }
        else if textField == shippingCityTextField {
            self.OthercurentCertification.City = textField.text
            self.OtherAddresShippingInfo?.city = self.OthercurentCertification.City
        }
        else if textField == zipCodeTxtFld {
            self.curentCertification?.Pincode = textField.text
            self.shippingInfo?.pincode = textField.text
        }
        else if textField == shippingZipCodeTxtFld {
            self.OthercurentCertification.Pincode = textField.text
            self.OtherAddresShippingInfo?.pincode =  self.OthercurentCertification.Pincode
        }
        
        if isOtherAddressSelected{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
        else{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
    }
}


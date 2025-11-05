//
//  AddEmployeesVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 12/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit
import SwiftReorder

class AddEmployeesVC: BaseViewController, UITextFieldDelegate{
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var addEmployeesLbl: UILabel!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var headerContainerVw: UIView!
    @IBOutlet weak var mainContentVw: UIView!
    @IBOutlet weak var dateVw: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var customerlbl: UILabel!
    @IBOutlet weak var customerVw: UIView!
    @IBOutlet weak var employeesTblVw: UITableView!
    @IBOutlet weak var costShippingNumberLbl: UILabel!
    @IBOutlet weak var costShippingNumberVw: UIView!
    @IBOutlet weak var siteVw: UIView!
    @IBOutlet weak var siteLbl: UILabel!
    @IBOutlet weak var fieldServiceVw: UIView!
    @IBOutlet weak var fieldServiceLbl: UILabel!
    @IBOutlet weak var fieldServiceManagerVw: UIView!
    @IBOutlet weak var fieldServiceManagerLbl: UILabel!
    @IBOutlet weak var managerVw: UIView!
    @IBOutlet weak var managerlbl: UILabel!
    @IBOutlet weak var AnnualertificationBtn: UIButton!
    @IBOutlet weak var reCertBtn: UIButton!
    @IBOutlet weak var newSiteBtn: UIButton!
    @IBOutlet weak var existingSiteBtn: UIButton!
    @IBOutlet weak var gpView: UIView!
    @IBOutlet weak var sectionHeaderVw: UIView!
    @IBOutlet weak var addEmployeeBtn: UIButton!
    @IBOutlet weak var removeEmployeeBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var gpColleagueVw: UIView!
    @IBOutlet weak var gpColleagueTxtFld: UITextField!
    @IBOutlet weak var gpColleagueJobTitleVw: UIView!
    @IBOutlet weak var gpColleagueJobTitleTxtFld: UITextField!
    @IBOutlet weak var gpSupervisorVw: UIView!
    @IBOutlet weak var gpSupervisorTxtFld: UITextField!
    @IBOutlet weak var gpSupervisorJobTitleVw: UIView!
    @IBOutlet weak var gpSupervisorJobTitleTxtFld: UITextField!
    @IBOutlet weak var customerTxtFld: UITextField!
    @IBOutlet weak var costShippingTxtFld: UITextField!
    @IBOutlet weak var siteTxtFld: UITextField!
    @IBOutlet weak var serviceTechTxtFld: UITextField!
    @IBOutlet weak var managerTxtFld: UITextField!
    @IBOutlet weak var fsmTxtFld: UITextField!
    @IBOutlet weak var annualBtn: UIButton!
    @IBOutlet weak var annualLbl: UILabel!
    @IBOutlet weak var recertificateBtn: UIButton!
    @IBOutlet weak var recertificateLbl: UILabel!
    @IBOutlet weak var fsmStackView: UIStackView!
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var gpSuperView: UIView!
    @IBOutlet weak var sectionHeaderMainVw: UIView!
    @IBOutlet weak var sectionHeaderMainVwConstraint: NSLayoutConstraint!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var customerDropDownImgVw: UIImageView!
    @IBOutlet weak var siteBtn: UIButton!
    @IBOutlet weak var siteDropdownImgVw: UIImageView!
    @IBOutlet weak var fsmDropDownImgVw: UIImageView!
    @IBOutlet weak var fsmBtn: UIButton!
    @IBOutlet weak var siteView: UIView!
	var approverId:Int?
    // MARK: - VARIABLES
    
    var tShirtArr:[DropwnMasterDataVM] = [DropwnMasterDataVM]()
    var langArr:[DropwnMasterDataVM] = [DropwnMasterDataVM]()
    var rolesArr:[DropwnMasterDataVM] = [DropwnMasterDataVM]()
    var popover:UIPopoverPresentationController?
    var customers = [VaccinationCustomersVM]()
    var customerSites =  [VaccinationCustomerSitesVM]()
    var fieldServiceManagers =  [VaccinationFSMVM]()
    var showRedFieldsValidation = false
    var isSafetyCertification:Bool = false
    var isReCertification = false
    var isExistingSite = false
    var curentCertification: VaccinationCertificationVM?
    var employeesAddedArr = [VaccinationEmployeeVM]()
    var tableviewIndexPath = IndexPath(row: 0, section: 0)
    var buttonBg = UIButton()
    var datePickerNew : UIDatePicker!
    var vaccinationHeaderView: VaccinationHeaderContainerVC!
    var initialLoad = true
    var addEmployeeBtnClicked:Bool = true
    var fssId = Int()
    var trainingId = Int()
    var status : VaccinationCertificationStatus?
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        configureTblVwCell()
        setupHeaderView()
        getMasterData()
        registerTxtFld()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateEmployeeData(_:)), name: NSNotification.Name.init(rawValue: "AddEmployeesVaccination") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateEmployeeRoles(_:)), name: NSNotification.Name.init(rawValue: "UpdateEmployeeRoles") , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (self.curentCertification == nil || self.curentCertification?.certificationId == nil){
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                
                if let certobj = VaccinationDashboardDAO.sharedInstance.getStartedCertObjByCategory(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationCategoryId: VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID){
                    self.curentCertification = certobj
                }
                self.fieldServiceManagerLbl.isHidden = true
                showsiteVw()
                fsmBtn.isHidden = false
                fsmDropDownImgVw.isHidden = false
            }
        }
        
        if (self.curentCertification == nil || self.curentCertification?.certificationId == nil){
            if !(self.curentCertification  != nil){
                self.curentCertification = VaccinationCertificationVM()
            }
            self.curentCertification?.certificationId = UUID().uuidString
            let dateFormatterObj =  DateFormatter()
            
            dateFormatterObj.locale = Calendar.current.locale
            dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            self.curentCertification?.scheduledDate = dateFormatterObj.string(from: Date())
            if Constants.modeType == "new_operator"{
                self.curentCertification?.certificationCategoryId = "0"
                self.curentCertification?.certificationCategoryName = "Operator"
                
                self.fieldServiceManagerLbl.isHidden = true
                fsmBtn.isHidden = false
                fsmDropDownImgVw.isHidden = false
            }else if Constants.modeType == "safety"{
                self.fieldServiceManagerLbl.isHidden = true
                self.curentCertification?.certificationCategoryId =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                self.curentCertification?.certificationCategoryName =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
            }
            
        }
        if self.curentCertification?.certificationCategoryId == "1"{
            isSafetyCertification = true
        }
        setUpFsmUI()
        configureVwForSafetyCertification()
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
        } else if self.curentCertification?.certificationCategoryId == nil || self.curentCertification?.certificationCategoryId == "" {
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            customers = VaccinationCustomersDAO.sharedInstance.getCustomersVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "")
            if self.curentCertification?.customerId != nil &&  self.curentCertification?.customerId != ""{
                customerSites = VaccinationCustomersDAO.sharedInstance.getCustomerSitesVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", customerId: self.curentCertification?.customerId ?? "")
            }
            self.fieldServiceManagerLbl.isHidden = true
            fsmBtn.isHidden = false
            fsmDropDownImgVw.isHidden = false
            showCustomerVw()
            showsiteVw()
        }else if !isSafetyCertification && self.curentCertification?.certificationCategoryId == "0"{
            customers = VaccinationCustomersDAO.sharedInstance.getCustomersVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "")
            if self.curentCertification?.customerId != nil &&  self.curentCertification?.customerId != ""{
                customerSites = VaccinationCustomersDAO.sharedInstance.getCustomerSitesVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", customerId: self.curentCertification?.customerId ?? "")
            }
            if curentCertification?.certificationCategoryId == "0"{
                if self.customerTxtFld.isHidden{
                    self.customerTxtFld.isHidden = false
                }
                if self.siteTxtFld.isHidden{
                    self.siteTxtFld.isHidden = false
                }
                self.customerTxtFld.text = curentCertification?.customerName
                self.siteTxtFld.text = curentCertification?.siteName
                self.fsmTxtFld.text = curentCertification?.selectedFsmName
                self.fieldServiceManagerLbl.isHidden = true
                fsmBtn.isHidden = false
                fsmDropDownImgVw.isHidden = false
            }
            showCustomerVw()
            showsiteVw()
            self.customerlbl.isHidden = true
            self.siteLbl.isHidden = true
        }
        
        
        if !isSafetyCertification{
            employeesAddedArr = AddEmployeesDAO.sharedInstance.getAllCertEmployees(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "")
        }
        
        UserFilledQuestionnaireDAO.sharedInstance.saveQuestionData( userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:self.curentCertification?.certificationId ?? "", isSafetyCert:isSafetyCertification)
        
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
            enableOrDisable(false)
        } else{
            enableOrDisable( true)
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set("AddEmployeesVC", forKey: "ViewCertificationsVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if status == VaccinationCertificationStatus.submitted {
            fsmBtn.isHidden = true
            fsmTxtFld.isUserInteractionEnabled = false
        }
        
        self.fieldServiceManagers = VaccinationCustomersDAO.sharedInstance.getFSMListVM(user_id: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
    }
    
    // MARK: - INITIAL UI METHODS
    
    func configureTblVwCell(){
        employeesTblVw.delegate = self
        employeesTblVw.reorder.delegate = self
        employeesTblVw.dataSource = self
        employeesTblVw.allowsSelection = false
        employeesTblVw.allowsMultipleSelectionDuringEditing = false
        employeesTblVw.register(AddEmployeeTableViewCell.nib, forCellReuseIdentifier: AddEmployeeTableViewCell.identifier)
    }
    
    
    func setUpFsmUI(){
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            self.annualBtn.isHidden = true
            self.annualLbl.isHidden = true
            self.recertificateBtn.isHidden = true
            self.recertificateLbl.isHidden = true
        }else if !isSafetyCertification && self.curentCertification?.certificationCategoryId == "0"{
            self.annualBtn.isHidden = true
            self.annualLbl.isHidden = true
            self.recertificateBtn.isHidden = true
            self.recertificateLbl.isHidden = true
        }else{
            self.toggleView.isHidden = true
            self.fsmStackView.isHidden = true
        }
    }
    
    func registerTxtFld(){
        costShippingTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        managerTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        gpSupervisorTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        gpSupervisorJobTitleTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        gpColleagueTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        gpColleagueJobTitleTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        
    }
    
    func saveData(){
        if self.curentCertification != nil{
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
            }else{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
            }
        }
    }
    
    
    func showCustomerVw(){
        if customers.count  > 0{
            if customers.count  == 1{
                let element = customers[0]
                self.customerTxtFld.text = element.customerName ?? ""
                self.curentCertification?.customerId = element.customerId
                self.curentCertification?.customerName = element.customerName
                customerBtn.isHidden = true
                customerDropDownImgVw.isHidden = true
                self.customerTxtFld.isUserInteractionEnabled = false
                saveData()
                showsiteVw()
            }else{
                customerBtn.isHidden = false
                customerDropDownImgVw.isHidden = false
            }
        }else{
            customerBtn.isHidden = false
            customerDropDownImgVw.isHidden = false
        }
    }
    
    func showsiteVw(){
        if self.curentCertification?.customerId != nil && self.curentCertification?.customerId != ""{
            customerSites = VaccinationCustomersDAO.sharedInstance.getCustomerSitesVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", customerId: self.curentCertification?.customerId ?? "")
        }
        if customerSites.count  > 0{
            if customerSites.count  == 1{
                let element = customerSites[0]
                self.siteTxtFld.text = element.siteName ?? ""
                self.curentCertification?.siteId = element.siteId
                self.curentCertification?.siteName = element.siteName
                siteBtn.isHidden = true
                siteDropdownImgVw.isHidden = true
                self.siteTxtFld.isUserInteractionEnabled = false
                saveData()
            }else{
                siteBtn.isHidden = false
                siteDropdownImgVw.isHidden = false
            }
        }else{
            siteBtn.isHidden = false
            siteDropdownImgVw.isHidden = false
        }
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if initialLoad{
            setupUI()
            
            setBordeViewWithColor(gpSupervisorVw)
            setBordeViewWithColor(gpSupervisorJobTitleVw)
            setBordeViewWithColor(gpColleagueVw)
            setBordeViewWithColor(gpColleagueJobTitleVw)
            gpView.setGradientThreeColors(topGradientColor: UIColor.white, midGradientColor: UIColor.white, bottomGradientColor: UIColor.getAddEmployeeGradient())
            
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                gpSuperView.isHidden = false
                employeesTblVw.isHidden = true
            }else{
                employeesTblVw.isHidden = false
                gpSuperView.isHidden = true
            }
            addEmployeeBtn.isHidden = true
            removeEmployeeBtn.isHidden = true
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                addEmployeesLbl.text = "Add Info."
                sectionHeaderVw.isHidden = false
                addEmployeesLbl.isHidden = false
            } else{
                if employeesAddedArr.count > 0{
                    addEmployeesLbl.text = "Add Employees (\(employeesAddedArr.count))"
                }else{
                    addEmployeesLbl.text = "Add Employees"
                }
                
            }
            initialLoad = false
        }
    }
    
    func setupUI(){
        mainContentVw.setGradient(topGradientColor: UIColor.white , bottomGradientColor: UIColor.getAddEmployeeGradient())
        sectionHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderUpperGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderLowerGradColor())
        setBorderView(dateVw)
        setBorderView(costShippingNumberVw)
        setBorderView(customerVw)
        setBorderView(managerVw)
        setBorderView(fieldServiceVw)
        setBorderView(fieldServiceManagerVw)
        setBorderView(siteVw)
        sectionHeaderVw.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        addEmployeeBtn.setBackgroundImage(UIImage.init(named: "addIcon_new"), for: .normal)
        
        removeEmployeeBtn
            .setBackgroundImage(UIImage.init(named: "minusBtn"), for: .normal)
        
        startBtn.setGradient(topGradientColor: UIColor.getEmployeeStartBtnUpperGradient(), bottomGradientColor: UIColor.getDashboardTableHeaderLowerGradColor())
        
    }
    
    func setBorderView(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
        view.backgroundColor = UIColor.white
    }
    
    func setupHeaderView(){
        vaccinationHeaderView = VaccinationHeaderContainerVC()
        
        if isSafetyCertification{
            vaccinationHeaderView.titleOfHeader = "359 form"
        } else{
            vaccinationHeaderView.titleOfHeader = "Operator Certification"
        }
        
        self.headerContainerVw.addSubview(vaccinationHeaderView.view)
        self.topviewConstraint(vwTop: vaccinationHeaderView.view)
    }
    
    func configureVwForSafetyCertification(){
        dateLbl.isHidden = false
        customerlbl.isHidden = isSafetyCertification
        costShippingNumberLbl.isHidden = isSafetyCertification
        siteLbl.isHidden = isSafetyCertification
        fieldServiceLbl.isHidden = isSafetyCertification
        managerlbl.isHidden = isSafetyCertification
        customerTxtFld.isHidden = !isSafetyCertification
        costShippingTxtFld.isHidden = !isSafetyCertification
        siteTxtFld.isHidden = !isSafetyCertification
        serviceTechTxtFld.isHidden = !isSafetyCertification
        managerTxtFld.isHidden = !isSafetyCertification
        sectionHeaderMainVw.isHidden = false//isSafetyCertification
        employeesTblVw.isHidden = isSafetyCertification
        
        if isSafetyCertification{
            let dateFormatterObj =  DateFormatter()
            dateFormatterObj.locale = Calendar.current.locale
            
            dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            self.curentCertification?.scheduledDate = self.dateLbl.text ?? ""
            dateLbl.text = CodeHelper.sharedInstance.convertDateFormater( dateFormatterObj.string(from: Date()))
            self.curentCertification?.scheduledDate = dateFormatterObj.string(from: Date())
            newSiteBtn.isUserInteractionEnabled = true
            existingSiteBtn.isUserInteractionEnabled = true
            AnnualertificationBtn.isUserInteractionEnabled = true
            reCertBtn.isUserInteractionEnabled = true
            annualBtn.isUserInteractionEnabled = true
            recertificateBtn.isUserInteractionEnabled = true
            addEmployeeBtn.isHidden = true
            removeEmployeeBtn.isHidden = true
            
            if !isExistingSite{
                newSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                existingSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            } else{
                newSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                existingSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            }
            
            if curentCertification?.certificationTypeId == VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID{
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            }else{
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            }
            
            setValues()
            self.serviceTechTxtFld.text = "\(UserContext.sharedInstance.userDetailsObj?.firstname ?? "") \(UserContext.sharedInstance.userDetailsObj?.lastName ?? "")"
        } else{
            
            newSiteBtn.isUserInteractionEnabled = false
            existingSiteBtn.isUserInteractionEnabled = false
            AnnualertificationBtn.isUserInteractionEnabled = false
            reCertBtn.isUserInteractionEnabled = false
            annualBtn.isUserInteractionEnabled = false
            recertificateBtn.isUserInteractionEnabled = false
            managerlbl.isHidden = true
            managerTxtFld.isHidden = false
            costShippingNumberLbl.isHidden = true
            costShippingTxtFld.isHidden = false
            setValues()
        }
    }
    
    func setBordeViewWithColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
        view.backgroundColor = UIColor.white
    }
    
    
    func setValues(){
        dateLbl.text = CodeHelper.sharedInstance.convertDateFormater(curentCertification?.scheduledDate ?? "") ?? ""
        customerlbl.text = curentCertification?.customerName ?? ""
        costShippingTxtFld.text = curentCertification?.customerShippingId ?? ""
        siteLbl.text = (curentCertification?.siteName ?? "")
        customerTxtFld.text = curentCertification?.customerName ?? ""
        siteTxtFld.text =  (curentCertification?.siteName ?? "")
        if curentCertification?.fsrName != nil && curentCertification?.fsrName != ""{
            fieldServiceLbl.text = curentCertification?.fsrName ?? ""
        } else{
            var strArr = [String]()
            if UserContext.sharedInstance.userDetailsObj?.firstname != ""{
                strArr.append(UserContext.sharedInstance.userDetailsObj?.firstname ?? "")
            }
            if UserContext.sharedInstance.userDetailsObj?.lastName != ""{
                strArr.append( UserContext.sharedInstance.userDetailsObj?.lastName ?? "")
            }
            fieldServiceLbl.text = strArr.joined(separator: " ") ?? ""
        }
        managerlbl.text = curentCertification?.fsmName ?? ""
        managerTxtFld.text = curentCertification?.fsmName ?? ""
        fsmTxtFld.text = curentCertification?.selectedFsmName ?? ""
        newSiteBtn.isUserInteractionEnabled = false
        existingSiteBtn.isUserInteractionEnabled = false
        AnnualertificationBtn.isUserInteractionEnabled = false
        reCertBtn.isUserInteractionEnabled = false
        annualBtn.isUserInteractionEnabled = false
        recertificateBtn.isUserInteractionEnabled = false
        
        if curentCertification?.isExistingSite ?? false{
            newSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            existingSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
        } else{
            newSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            existingSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
        }
        if curentCertification?.certificationTypeId ?? "" == VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID{
            AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            reCertBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            annualBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            recertificateBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
        }else{
            AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            reCertBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            annualBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
            recertificateBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
        }
        
        gpColleagueTxtFld.text = self.curentCertification?.colleagueName
        gpColleagueJobTitleTxtFld.text = self.curentCertification?.colleagueJobTitle
        gpSupervisorTxtFld.text = self.curentCertification?.supervisorName
        gpSupervisorJobTitleTxtFld.text = self.curentCertification?.supervisorJobTitle
        
    }
    
    // MARK: - OBJC SELECTORS
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if  managerTxtFld.isFirstResponder ||
                serviceTechTxtFld.isFirstResponder ||
                siteTxtFld.isFirstResponder ||
                costShippingTxtFld.isFirstResponder ||
                customerTxtFld.isFirstResponder ||
                gpSupervisorJobTitleTxtFld.isFirstResponder ||
                gpSupervisorJobTitleVw.isFirstResponder ||
                gpSupervisorTxtFld.isFirstResponder ||
                gpColleagueJobTitleTxtFld.isFirstResponder ||
                gpColleagueTxtFld.isFirstResponder  {
            
        } else {
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            
            if self.view.bounds.origin.y == 0{
                self.view.bounds.origin.y += keyboardFrame.height - 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if  managerTxtFld.isFirstResponder ||
                serviceTechTxtFld.isFirstResponder ||
                siteTxtFld.isFirstResponder ||
                costShippingTxtFld.isFirstResponder ||
                customerTxtFld.isFirstResponder ||
                gpSupervisorJobTitleTxtFld.isFirstResponder ||
                gpSupervisorJobTitleVw.isFirstResponder ||
                gpSupervisorTxtFld.isFirstResponder ||
                gpColleagueJobTitleTxtFld.isFirstResponder ||
                gpColleagueTxtFld.isFirstResponder  {
            
        } else {
            if self.view.bounds.origin.y != 0 {
                self.view.bounds.origin.y = 0
            }
            employeesTblVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @objc func textFieldEditingDidChange(_ textField: UITextField){
        
        switch textField {
        case costShippingTxtFld:
            if curentCertification?.customerShippingId != textField.text{
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            curentCertification?.customerShippingId = textField.text
            break;
            
        case managerTxtFld:
            if curentCertification?.fsmName != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
//            if self.showRedFieldsValidation{
//                self.showMandatoryFieldsColor()
//            }
            curentCertification?.fsmName = textField.text?.capitalizingFirstLetter()
            break;
            
        case costShippingTxtFld:
            if curentCertification?.customerShippingId != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            curentCertification?.customerShippingId = textField.text
            
        case gpColleagueTxtFld:
            if self.curentCertification?.colleagueName != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            self.curentCertification?.colleagueName = textField.text
            
        case gpColleagueJobTitleTxtFld:
            if self.curentCertification?.colleagueJobTitle != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            self.curentCertification?.colleagueJobTitle = textField.text
            
        case gpSupervisorTxtFld:
            if self.curentCertification?.supervisorName != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            self.curentCertification?.supervisorName = textField.text
            
        case gpSupervisorJobTitleTxtFld:
            if self.curentCertification?.supervisorJobTitle != textField.text
            {
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            self.curentCertification?.supervisorJobTitle = textField.text
        default:
            break;
        }
        
        gpColleagueTxtFld.text = self.curentCertification?.colleagueName ?? ""
        gpColleagueJobTitleTxtFld.text = self.curentCertification?.colleagueJobTitle ?? ""
        gpSupervisorTxtFld.text = self.curentCertification?.supervisorName ?? ""
        gpSupervisorJobTitleTxtFld.text = self.curentCertification?.supervisorJobTitle ?? ""
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
        } else{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        var newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        var result = true
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92){
            
        } else if ((textField.text?.count)! > 45  ){
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended for: \(textField.text ?? "")")

        // Example: Update a property when editing ends
        if textField == managerTxtFld {
            if curentCertification?.fsmName != textField.text {
                curentCertification?.syncStatus = VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            if self.showRedFieldsValidation {
                self.showMandatoryFieldsColor()
            }
            curentCertification?.fsmName = textField.text?.capitalizingFirstLetter()
        }
    }
    
    @objc func updateEmployeeData(_ notification: NSNotification){
        if let index = notification.userInfo?["index"]  as? Int{
            if index > -1{
                if let empObj = notification.userInfo?["emp"]  as? VaccinationEmployeeVM{
                    if employeesAddedArr.count > 0{
                        if employeesAddedArr[index].firstName != empObj.firstName{
                            self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                            
                        }
                        if employeesAddedArr[index].middleName != empObj.middleName{
                            self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                            
                        }
                        if employeesAddedArr[index].startDate != empObj.startDate{
                            self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                            
                        }
                        if employeesAddedArr[index].lastName != empObj.lastName{
                            self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                            
                        }
                        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                        } else  {
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                        }
                        employeesAddedArr[index] = empObj
                        if self.curentCertification?.certificationId != nil &&  empObj.employeeId != nil{
                            
                            AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: empObj)
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateEmployeeRoles(_ notification: NSNotification){
        if let index = notification.userInfo?["index"]  as? Int{
            if let selectedVal = notification.userInfo?["selectedValue"]  as? String{
                if self.employeesAddedArr.count > index{
                    var emp =  self.employeesAddedArr[index]
                    if emp.selectedRolesStr != selectedVal{
                        self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                        } else if self.curentCertification?.certificationCategoryId == nil || self.curentCertification?.certificationCategoryId == "" || self.curentCertification?.certificationCategoryId == "2"{
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                        }
                    }
                    emp.selectedRolesStr = selectedVal
                    if let selectedObjStr = notification.userInfo?["selectedObjStr"]  as? String{
                        emp.rolesArrStr = selectedObjStr
                    }
                    AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: emp)
                    
                    self.employeesAddedArr[index] = emp
                    self.employeesTblVw.beginUpdates()
                    self.employeesTblVw.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
                    self.employeesTblVw.endUpdates()
                }
            }
        }
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    func enableOrDisable(_ flag:Bool){
        customerTxtFld.isEnabled = flag
        costShippingTxtFld.isEnabled = flag
        siteTxtFld.isEnabled = flag
        serviceTechTxtFld.isEnabled = false
        managerTxtFld.isEnabled = flag
        addEmployeeBtn.isHidden = flag//!
        removeEmployeeBtn.isHidden =  flag//!
        removeEmployeeBtn.isUserInteractionEnabled = flag
        addEmployeeBtn.isUserInteractionEnabled = flag
        AnnualertificationBtn.isUserInteractionEnabled = flag
        reCertBtn.isUserInteractionEnabled = flag
        annualBtn.isUserInteractionEnabled = flag
        recertificateBtn.isUserInteractionEnabled = flag
        newSiteBtn.isUserInteractionEnabled = flag
        existingSiteBtn.isUserInteractionEnabled = flag
        gpColleagueTxtFld.isUserInteractionEnabled = flag
        gpColleagueJobTitleTxtFld.isUserInteractionEnabled = flag
        gpSupervisorTxtFld.isUserInteractionEnabled = flag
        gpSupervisorJobTitleTxtFld.isUserInteractionEnabled = flag
        serviceTechTxtFld.isUserInteractionEnabled = false
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            addEmployeeBtn.isHidden = true//!
            removeEmployeeBtn.isHidden =  true//!
            
        }else{
            addEmployeeBtn.isHidden = false//!
            removeEmployeeBtn.isHidden =  false
        }
    }
    
    
    func getMasterData(){
        tShirtArr = AddEmployeesDAO.sharedInstance.getMasterDropdownData(loginUserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", valueType:MasterDataDropdownStatus.TShirtSize)
        langArr = AddEmployeesDAO.sharedInstance.getMasterDropdownData(loginUserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", valueType:MasterDataDropdownStatus.Languages)
        rolesArr = AddEmployeesDAO.sharedInstance.getMasterDropdownData(loginUserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", valueType:MasterDataDropdownStatus.UserRoles)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func validate(){

        var hasCertificationFilled = true
        
        if curentCertification?.fsmName != nil && curentCertification?.fsmName != "" {
            
            //Extra Validation
            hasCertificationFilled = true
        } else {
            hasCertificationFilled = false
        }
        
        let selectedFsmName = curentCertification?.selectedFsmName
        
        if let fsmId = fieldServiceManagers.first(where: { $0.fsmName == selectedFsmName     })?.fsmId {
            curentCertification?.selectedFsmId = fsmId
        } else {
            print("FSM not found.")
        }
//        self.fieldServiceManagers
        if isSafetyCertification && (curentCertification?.selectedFsmId == nil || curentCertification?.selectedFsmId == "") {
            hasCertificationFilled = true
        } else {
            hasCertificationFilled = false
        }
        
        if curentCertification?.siteId != nil && curentCertification?.siteId != "" {
            hasCertificationFilled = true
        }else{
            hasCertificationFilled = false
        }
        
        if curentCertification?.customerId != nil && curentCertification?.customerId != "" {
            hasCertificationFilled = true
        }else{
            hasCertificationFilled = false
        }
        
        
        var hasEmpInfoFilled = true
        if employeesAddedArr.count > 0{
            for emp in employeesAddedArr{
                if emp.firstName != nil && emp.firstName != "" {
                    hasEmpInfoFilled = hasEmpInfoFilled && true
                }else{
                    hasEmpInfoFilled = hasEmpInfoFilled && false
                }
                
                if emp.lastName != nil && emp.lastName != "" {
                    hasEmpInfoFilled = hasEmpInfoFilled && true
                }else{
                    hasEmpInfoFilled = hasEmpInfoFilled && false
                }
                
                if emp.selectedTshirtId != nil && emp.selectedTshirtId != "" {
                    hasEmpInfoFilled = hasEmpInfoFilled && true
                }else{
                    hasEmpInfoFilled = hasEmpInfoFilled && false
                }
                
                if emp.selectedLangId != nil && emp.selectedLangId != "" {
                    hasEmpInfoFilled = hasEmpInfoFilled && true
                }else{
                    hasEmpInfoFilled = hasEmpInfoFilled && false
                }
                
                if emp.selectedRolesStr != nil && emp.selectedRolesStr != "" {
                    hasEmpInfoFilled = hasEmpInfoFilled && true
                }else{
                    hasEmpInfoFilled = hasEmpInfoFilled && false
                }
            }
            
        }else{
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                hasEmpInfoFilled = hasEmpInfoFilled && true
            }else{
                hasEmpInfoFilled = hasEmpInfoFilled && false
                displayAlertMessage(userMessage: "Please add employee(s) to continue.")
                return
            }
        }
        
        let certificateId = self.curentCertification?.certificationId ?? ""
        let custId = self.curentCertification?.customerId ?? ""
        let custName = self.curentCertification?.customerName ?? ""
        let siteId = self.curentCertification?.siteId ?? ""
        let siteName = self.curentCertification?.siteName ?? ""
        let custShip = self.costShippingTxtFld.text ?? ""
        let selectdFsm = self.curentCertification?.selectedFsmId ?? ""
        let selectedDate = self.curentCertification?.scheduledDate ?? ""
        let hatchrymngerName = self.curentCertification?.fsmName ?? ""
        
        ApproverStore.shared.setOtherCertificateDetail(for: certificateId, customerId: custId, customerName: custName, siteId: siteId, siteName: siteName, custShipping: custShip, selectedFsmId: selectdFsm, dateSchedule: selectedDate, htchMngr: hatchrymngerName)
        
        if hasCertificationFilled {
            if hasEmpInfoFilled{
                if curentCertification?.certificationCategoryId !=  "2"
                {
                    if curentCertification?.selectedFsmId == nil || curentCertification?.selectedFsmId == "" {
                        self.showMandatoryFieldsColor()
                        displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.") // New addition
                        return
                    }
                    
                    if curentCertification?.siteId == nil || curentCertification?.siteId == "" {
                        self.showMandatoryFieldsColor()
                        displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.") // New addition
                        return
                    }
                    
                    if curentCertification?.fsmName == nil ||  curentCertification?.fsmName == ""
                    {
                        self.showMandatoryFieldsColor()
                        displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.") // New addition
                        return
                    }
                }
                
                if curentCertification?.fsmName != nil && curentCertification?.fsmName != ""{
                    
                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                        
                        let ccData = fetchCountryAndState(certId: curentCertification?.certificationId ?? "")
                        
                        if let savedCountry = ccData?.countryId,
                           let savedState = ccData?.stateId {
                        } else {
                            let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId)
                            if shippingInfoDB != nil {
                                let countryID = shippingInfoDB?.countryID
                                let stateId = shippingInfoDB?.stateID
                                saveCountryAndState(certId: curentCertification?.certificationId ?? "",
                                                    countryId: countryID,
                                                    stateId: stateId,
                                                    addressLine1: shippingInfoDB?.address1,
                                                    addressLine2: shippingInfoDB?.address2,
                                                    city: shippingInfoDB?.city,
                                                    zip: shippingInfoDB?.pincode,
                                                    siteId: shippingInfoDB?.siteId,
                                                    siteName: shippingInfoDB?.siteName,
                                                    countryName: shippingInfoDB?.countryName,
                                                    stateName: shippingInfoDB?.stateName,
                                                    isOtherAddress: shippingInfoDB?.adddressType)
                                self.getVaccinationStateList(countryId: String(countryID ?? 0),stateId: stateId)
                            }
                        }
                        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
                        delay(2.0) {
                            self.dismissGlobalHUD(self.view)
                            self.navigatetToQuestionnaireScreen(trainingId: self.trainingId, fssId: self.fssId)
                        }
                    } else {
                        if curentCertification?.certificationStatus == VaccinationCertificationStatus.draft.rawValue {
                            
                            let ccData = fetchCountryAndState(certId: curentCertification?.certificationId ?? "")
                            
                            if let savedCountry = ccData?.countryId,
                                let savedState = ccData?.stateId {
                                
                                if trainingId != 0
                                {
                                    if let otherShippingInfo = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingAddressByTrainingId(trainingId: self.trainingId) {
                                        VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: [otherShippingInfo])
                                    } else {
                                        VaccinationCustomersDAO.sharedInstance.saveOtherAddressInDB(newAssessment: nil)
                                    }
                                    
                                    if let shippingInfo = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId) {
                                        VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: [shippingInfo])
                                        
                                        Constants.updateSiteAddress = false

                                        if (shippingInfo.address1?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
                                           (shippingInfo.pincode?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
                                           (shippingInfo.city?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ||
                                           (shippingInfo.stateName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) {
                                            Constants.updateSiteAddress = true
                                        }
                                    }
                                    
                                    else {
                                        VaccinationCustomersDAO.sharedInstance.saveShippingInfoInDB(newAssessment: nil)
                                    }
                                    
                                }
                                
                            } else {
                                let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: self.trainingId)
                                
                                Constants.updateSiteAddress = false
                                if (shippingInfoDB?.address1?.isEmpty ?? true) ||
                                   (shippingInfoDB?.pincode?.isEmpty ?? true) ||
                                   (shippingInfoDB?.city?.isEmpty ?? true) ||
                                   (shippingInfoDB?.stateName?.isEmpty ?? true) {
                                    Constants.updateSiteAddress = true
                                }
                                
                                
                                if shippingInfoDB != nil, let ccId = shippingInfoDB?.countryID,
                                   shippingInfoDB?.countryID != nil, ccId != 0 {
                                    let countryID = shippingInfoDB?.countryID
                                    let stateId = shippingInfoDB?.stateID
                                    saveCountryAndState(certId: curentCertification?.certificationId ?? "",
                                                        countryId: countryID,
                                                            stateId: stateId,
                                                        addressLine1: shippingInfoDB?.address1,
                                                        addressLine2: shippingInfoDB?.address2,
                                                        city: shippingInfoDB?.city,
                                                        zip: shippingInfoDB?.pincode,
                                                        siteId: shippingInfoDB?.siteId,
                                                        siteName: shippingInfoDB?.siteName,
                                                        countryName: shippingInfoDB?.countryName,
                                                        stateName: shippingInfoDB?.stateName,
                                                        isOtherAddress: shippingInfoDB?.adddressType
                                    )
                                    self.getVaccinationStateList(countryId: String(countryID ?? 0),stateId: stateId)
                                } else {
                                    self.getShippingDetails()
                                }
                            }
                        } else {
                            self.getShippingDetails()
                        }
                        
                        let alertController = UIAlertController(title: "Confirmation Required", message: "Please confirm you have entered the hatchery manager's full name.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { [self]
                            _ in
                            if self.curentCertification?.selectedFsmId == self.curentCertification?.fsrId {
                                self.curentCertification?.selectedFsmId = nil
                            }
                            self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
                            delay(2.0) {
                                self.dismissGlobalHUD(self.view)
                                if self.curentCertification?.certificationStatus == VaccinationCertificationStatus.draft.rawValue {
                                    self.navigatetToQuestionnaireScreen(trainingId: self.trainingId)
                                } else {
                                    self.navigatetToQuestionnaireScreen()
                                }
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default){
                            _ in
                            self.dismissGlobalHUD(self.view)
                            self.managerTxtFld.becomeFirstResponder()
                        }
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async{
                        self.showMandatoryFieldsColor()
                    }
                   // displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.")
                }
            }else{
                self.employeesTblVw.reloadData()
                displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.")
            }
        }else{
            DispatchQueue.main.async{
                self.showMandatoryFieldsColor()
            }
            self.employeesTblVw.reloadData()
            
            
            if curentCertification?.customerId == nil ||
               curentCertification?.siteId == nil ||
               curentCertification?.fsmName == nil ||
               (curentCertification?.fsmName?.removeWhitespace() == "") ||
               curentCertification?.selectedFsmId == nil {
                
                displayAlertMessage(userMessage: "Please enter details in all the fields marked as mandatory.")
            }
          
        }
        
    }
    
    // MARK: - Get Shipping Details
    private func getShippingDetails(){
        
        if curentCertification?.selectedFsmId == nil || curentCertification?.selectedFsmId == ""
        {
            var UpdateCertification = curentCertification?.fsrId
            curentCertification?.selectedFsmId = UpdateCertification
        }
        
        if let certId = curentCertification?.certificationId {
            let approverData = ApproverStore.shared.getApprover(for: certId)
            curentCertification?.selectedFsmId = approverData?.approverId
        }
        
        DataService.sharedInstance.getShippingDetails(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found",  SelectedFsmId:self.curentCertification?.selectedFsmId ?? "", SelectedSiteId: self.curentCertification?.siteId ?? "", certId: curentCertification?.certificationId ?? "", viewController: self, completion: { [weak self] (status, error) in
            guard let _ = self, error == nil else { self?.dismissGlobalHUD(self?.view ?? UIView()); return }
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    
                    UserDefaults.standard.set(true, forKey: "hasVaccinationDataLoaded")
                    self?.dismissGlobalHUD(self?.view ?? UIView());
                    
                    UserContext.sharedInstance.markSynced(apiCallName: .getSubmittedCertifications)
                    //
                }
            }
            UserDefaults.standard.set(true, forKey: "hasVaccinationDataLoaded")
            self?.dismissGlobalHUD(self?.view ?? UIView());
            let countryId = UserDefaults.standard.value(forKey: "countryId") as? Int
            if self?.curentCertification?.selectedFsmId == self?.curentCertification?.fsrId {
                self?.curentCertification?.selectedFsmId = nil
            }
            self?.getVaccinationStateList(countryId: String(countryId ?? 0))
        })
    }
    
    private func getVaccinationStateList(countryId: String,stateId:Int? = nil) {
        _ = Helper.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
        DataService.sharedInstance.getVaccinationStateList(countryId: countryId, viewController: self,stateId: stateId, completion: { [weak self] (status, error) in
            DispatchQueue.main.async {
                self?.dismissGlobalHUD(self?.view ?? UIView())
            }
            guard let _ = self, error == nil else { return }
            
            if status == VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY || status == VaccinationConstants.VaccinationStatus.COREDATA_FETCHED_SUCCESSFULLY{
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    UserContext.sharedInstance.markSynced(apiCallName: .getVaccinationStatesList)
                    
                }
            }
            
        })
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Fill Data", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    func setRedBorderColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.red.cgColor
    }
    
    func showMandatoryFieldsColor(){
        
        if curentCertification?.customerId != nil && curentCertification?.customerId?.removeWhitespace() != ""{
            setBorderView(customerVw)
        }else{
            setRedBorderColor(customerVw)
        }
        if curentCertification?.siteId != nil && curentCertification?.siteId?.removeWhitespace() != ""{
            setBorderView(siteVw)
        }else{
            setRedBorderColor(siteVw)
        }
        if curentCertification?.fsmName != nil && curentCertification?.fsmName?.removeWhitespace() != ""{
            setBorderView(managerVw)
        }else{
            setRedBorderColor(managerVw)
        }
        if curentCertification?.selectedFsmId != nil && curentCertification?.selectedFsmId?.removeWhitespace() != ""{
            setBorderView(fieldServiceManagerVw)
        }
        else{
            setRedBorderColor(fieldServiceManagerVw)
        }
    }
    
    func fillCurrentCertificationObj(){
        let dateFormatterObj =  DateFormatter()
        
        dateFormatterObj.timeZone = Calendar.current.timeZone
        dateFormatterObj.locale = Calendar.current.locale
        dateFormatterObj.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if (self.curentCertification == nil){
            self.curentCertification = VaccinationCertificationVM()
        }
        self.curentCertification?.scheduledDate = dateFormatterObj.string(from: Date())
        self.curentCertification?.customerShippingId = self.costShippingTxtFld.text ?? ""
        
        self.curentCertification?.customerName = self.customerTxtFld.text ?? ""
        
        self.curentCertification?.siteName = self.siteTxtFld.text ?? "" ?? ""
        self.curentCertification?.fsrName = self.serviceTechTxtFld.text ?? ""
        self.curentCertification?.fsmName = self.managerTxtFld.text ?? ""
        self.curentCertification?.selectedFsmName = self.fsmTxtFld.text ?? ""
        self.curentCertification?.selectedFsmId = self.fsmTxtFld.text ?? ""
        
        for fsManager in self.fieldServiceManagers{
            if (fsManager.fsmName == self.fsmTxtFld.text){
                self.curentCertification?.selectedFsmId = fsManager.fsmId
            }
        }
        if isReCertification{
            self.curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.RE_CERTIFICATION_TYPE_ID
        } else{
            self.curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID
        }
        
        self.curentCertification?.isExistingSite = isExistingSite
        
        self.curentCertification?.colleagueName = gpColleagueTxtFld.text ?? ""
        self.curentCertification?.colleagueJobTitle = gpColleagueJobTitleTxtFld.text ?? ""
        self.curentCertification?.supervisorName = gpSupervisorTxtFld.text ?? ""
        self.curentCertification?.supervisorJobTitle = gpSupervisorJobTitleTxtFld.text ?? ""
        
        
        if isSafetyCertification{
            self.curentCertification?.certificationCategoryId = VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
            
            self.curentCertification?.certificationCategoryName = VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
        }
    }
    
    func navigatetToQuestionnaireScreen(trainingId : Int = 0, fssId: Int = 0){
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "QuestionnaireVC") as? QuestionnaireVC
        if self.trainingId != 0 {
            vc?.trainingId = self.trainingId
        }
        Constants.selectedSiteId = curentCertification?.siteId ?? ""
        vc?.fssId = self.fssId
        vc?.AssessmentDate = dateLbl.text ?? ""
        let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "")
        if startedObj != nil{
            if self.fsmTxtFld.text != ""{
                vc?.curentCertification = self.curentCertification
            }else{
                vc?.curentCertification = startedObj
            }
        }else{
            vc?.curentCertification = self.curentCertification
        }
		vc?.approverId = approverId
        if !isSafetyCertification{
            vc?.employeesAddedArr = employeesAddedArr
        }
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
        } else{
            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
        }
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func scrollToTblVwIndex(){
        if employeesAddedArr.count > 0{
            if employeesAddedArr.count > 1{
                self.employeesTblVw.scrollToRow(at: IndexPath.init(row: employeesAddedArr.count - 1, section: 0), at: .bottom, animated: true)
            } else{
                self.employeesTblVw.scrollToRow(at: IndexPath.init(row: employeesAddedArr.count - 1, section: 0), at: .top, animated: true)
            }
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func annualCertBtnAction(_ sender: UIButton) {
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {
            
        }else{
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                isReCertification = false
                curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                } else{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                }
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                
            }else if isSafetyCertification || self.curentCertification?.certificationCategoryId == "0"{
                isReCertification = false
                curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.ANNUAL_CERTIFICATION_TYPE_ID
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                if isSafetyCertification || self.curentCertification?.certificationCategoryId == "0"{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"0", certObj: self.curentCertification!)
                } else{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                }
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                
            }
        }
    }
    
    @IBAction func reCertbtnAction(_ sender: UIButton){
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {
            
        }else{
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                isReCertification = true
                curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.RE_CERTIFICATION_TYPE_ID
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                }else{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                }
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            }else if isSafetyCertification || self.curentCertification?.certificationCategoryId == "0"{
                isReCertification = true
                curentCertification?.certificationTypeId = VaccinationConstants.LookupMaster.RE_CERTIFICATION_TYPE_ID
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                if isSafetyCertification || self.curentCertification?.certificationCategoryId == "0"{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"0", certObj: self.curentCertification!)
                }else{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                }
                AnnualertificationBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                reCertBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
                annualBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
                recertificateBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            }
        }
    }
    
    @IBAction func newSiteCertificationBtnAction(_ sender: UIButton) {
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {}else{
            isExistingSite = false
            curentCertification?.isExistingSite = false
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
            }else{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
            }
            newSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
            existingSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
        }
    }
    // MARK: - Existing Site Button Action
    @IBAction func existingSiteBtnAction(_ sender: UIButton) {
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue {}else{
            isExistingSite = true
            curentCertification?.isExistingSite = true
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
            }else{
                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
            }
            newSiteBtn.setBackgroundImage(UIImage.init(named: "unselectedBtn"), for: .normal)
        }
        existingSiteBtn.setBackgroundImage(UIImage.init(named: "selectedBtn"), for: .normal)
        
    }
    
    @IBAction func addEmpoyeeAction(_ sender: UIButton) {
        
        if addEmployeeBtnClicked{
            addEmployeeBtnClicked = false
            var empObj =  VaccinationEmployeeVM()
            empObj.sortOrder =  Int32(employeesAddedArr.count)//+ 1
            empObj.sortOrder! += 1
            empObj.employeeId =  UUID().uuidString
            empObj.certificationId = curentCertification?.certificationId
            empObj.siteId = curentCertification?.siteId
            empObj.customerId = curentCertification?.customerId
            empObj.userId = UserContext.sharedInstance.userDetailsObj?.userId
            if self.curentCertification?.certificationId != nil &&  empObj.employeeId != nil{
                AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: empObj)
                AddEmployeesDAO.sharedInstance.linkEmpToQuestionnaire(empId:empObj.employeeId  ?? "", userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:curentCertification?.certificationId ?? "")
                employeesAddedArr.append(empObj)
            }
            
            employeesTblVw.reloadData()
            
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                addEmployeesLbl.text = "Add Info."
            } else{
                if employeesAddedArr.count > 0{
                    addEmployeesLbl.text = "Add Employees (\(employeesAddedArr.count))"
                }else{
                    addEmployeesLbl.text = "Add Employees"
                }
            }
            
            employeesTblVw.beginUpdates()
            employeesTblVw.endUpdates()
            
            self.scrollToTblVwIndex()
            addEmployeeBtnClicked = true
            employeesTblVw.setNeedsDisplay()
            employeesTblVw.layoutIfNeeded()
        }
    }
    // MARK: - Delete Employee
    @IBAction func removeEmployeeAction(_ sender: UIButton) {
        if addEmployeeBtnClicked{
            addEmployeeBtnClicked = false
            if employeesAddedArr.count > 0{
                AddEmployeesDAO.sharedInstance.deleteEmployeeObj(empId:employeesAddedArr[employeesAddedArr.count - 1].employeeId ?? "", userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:curentCertification?.certificationId ?? "")
                
                AddEmployeesDAO.sharedInstance.removeEmployeeFromBridge(empId:employeesAddedArr[employeesAddedArr.count - 1].employeeId ?? "", userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:curentCertification?.certificationId ?? "")
                employeesAddedArr.removeLast()
            }
            
            if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                addEmployeesLbl.text = "Add Info."
            } else{
                if employeesAddedArr.count > 0{
                    addEmployeesLbl.text = "Add Employees (\(employeesAddedArr.count))"
                }else{
                    addEmployeesLbl.text = "Add Employees"
                }
            }
            employeesTblVw.reloadData()
            self.scrollToTblVwIndex()
            addEmployeeBtnClicked = true
        }
    }
    // MARK: - Add Button Action
    @IBAction func addBtnAction(_ sender: UIButton) {
        for textfield in self.view.subviews where textfield is UITextField{
            textfield.resignFirstResponder()
        }
        showRedFieldsValidation = true
        if isSafetyCertification{
            
            fillCurrentCertificationObj()
            validate()
            
        } else{
            validate()
        }
        
    }
    // MARK: - Site Button Action
    @IBAction func siteBtnAction(_ sender: UIButton) {
        if curentCertification?.certificationStatus != VaccinationCertificationStatus.submitted.rawValue{
            let arr = self.customerSites.map{ $0.siteName}
            self.dropDownVIewNew(arrayData: arr as! [String], kWidth: siteView.frame.width, kAnchor: siteView, yheight: siteView.bounds.height) {
                [unowned self] selectedVal, index  in
                let element = self.customerSites[index]
                self.curentCertification?.siteId = element.siteId
                self.curentCertification?.siteName = element.siteName
                if self.curentCertification?.siteId != element.siteId{
                    self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                }
                if self.siteTxtFld.isHidden{
                    self.siteTxtFld.isHidden = false
                }
                self.siteTxtFld.text = element.siteName ?? ""
                self.saveData()
                if self.showRedFieldsValidation{
                    self.showMandatoryFieldsColor()
                }
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK: - FSM Button Action
    @IBAction func fsmBtnAction(_ sender: UIButton) {
        self.fieldServiceManagers = VaccinationCustomersDAO.sharedInstance.getFSMListVM(user_id: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        let arr = self.fieldServiceManagers.map{ $0.fsmName}
        self.dropDownVIewNew(arrayData: arr as! [String], kWidth: fieldServiceManagerVw.frame.width, kAnchor: fieldServiceManagerVw, yheight: fieldServiceManagerVw.bounds.height) {
            [unowned self] selectedVal, index  in
            let element = self.fieldServiceManagers[index]
            let certificateId = self.curentCertification?.certificationId ?? ""
            self.curentCertification?.selectedFsmId = element.fsmId
            self.curentCertification?.selectedFsmName = element.fsmName
            
            print("selected FSM Name  = " , element.fsmName ?? "")
            print("selected FSM ID  = " , element.fsmId ?? 0)
            
            let approverId = element.fsmId ?? "0"
//            self.approverId = approverId
//            UserDefaults.standard.setValue(approverId, forKey: "\(certificateId)")
            if let fsmName = element.fsmName {
                ApproverStore.shared.setApprover(for: certificateId, approverId: approverId, approverName: fsmName)
            }
            if self.curentCertification?.selectedFsmId != element.fsmId {
                self.curentCertification?.syncStatus = VaccinationCertificationSyncStatus.syncReady.rawValue
            }
            self.fsmTxtFld.text = element.fsmName ?? ""
            self.saveData()
            if self.showRedFieldsValidation {
                self.showMandatoryFieldsColor()
            }
        }
        self.dropHiddenAndShow()
    }
    // MARK: - Customer Button Action.
    @IBAction func customerBtnAction(_ sender: UIButton) {
        if curentCertification?.certificationStatus != VaccinationCertificationStatus.submitted.rawValue{
            
            let arr = self.customers.map{ $0.customerName}
            self.dropDownVIewNew(arrayData: arr as! [String], kWidth: customerView.frame.width, kAnchor: customerView, yheight: customerView.bounds.height) {
                [unowned self] selectedVal, index  in
                let element = self.customers[index]
                self.curentCertification?.customerId = element.customerId
                self.curentCertification?.customerName = element.customerName
                if self.curentCertification?.customerId != element.customerId{
                    self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                }
                if customerTxtFld.isHidden{
                    self.customerTxtFld.isHidden = false
                }
                self.customerTxtFld.text = element.customerName ?? ""
                self.siteTxtFld.text = ""
                self.curentCertification?.siteId = nil
                self.curentCertification?.siteName = nil
                self.saveData()
                self.showsiteVw()
                if self.showRedFieldsValidation{
                    self.showMandatoryFieldsColor()
                }
            }
            self.dropHiddenAndShow()
        }
    }
}

// MARK: - EXTENSION TABLE VIEW DATA SOURCE AND DELEGATE

extension AddEmployeesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeesAddedArr.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = UIColor.getHeaderTopGradient()
        } else{
            cell.contentView.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: AddEmployeeTableViewCell.identifier, for: indexPath) as? AddEmployeeTableViewCell{
            if employeesAddedArr.count > 0 && employeesAddedArr.count > indexPath.row {
                cell.showRedFieldsValidation = showRedFieldsValidation
                cell.index = indexPath.row
                if employeesAddedArr.count - 1  == indexPath.row{
                    cell.contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                }else{
                    cell.contentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                }
                if indexPath.row % 2 == 0{
                    cell.assignWhitebackgroundVw()
                } else{
                    cell.assignBorderVw()
                }
                
                if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                    cell.enableOrDisable(flag: false)
                }else{
                    cell.enableOrDisable(flag: true)
                }
                cell.setValues(employee:employeesAddedArr[indexPath.row])
                if showRedFieldsValidation{
                    cell.changeMandatoryFieldsBorder()
                }
                if showRedFieldsValidation{
                    DispatchQueue.main.async{
                        cell.changeMandatoryFieldsBorder()
                    }
                }
                cell.tShirtCompletion = {
                    [unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    let arr = self.tShirtArr.map{ $0.value}
                    self.dropDownVIewNew(arrayData: arr as! [String], kWidth: cell.tShirtSizeVw.frame.width, kAnchor: cell.tShirtSizeVw, yheight: cell.tShirtSizeVw.bounds.height) { [unowned self] selectedVal, index  in
                        if indexPath.row > -1 && self.employeesAddedArr.count > indexPath.row{
                            var employeeObj = self.employeesAddedArr[indexPath.row]
                            if index > -1 && self.tShirtArr.count > index{
                                if employeeObj.selectedTshirtId != self.tShirtArr[index].id{
                                    self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                                }
                                if self.isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: self.curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                                } else{
                                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: self.curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                                }
                                
                                employeeObj.selectedTshirtId =  self.tShirtArr[index].id
                                employeeObj.selectedTshirtValue =  self.tShirtArr[index].value
                                
                                if self.curentCertification?.certificationId != nil &&  employeeObj.employeeId != nil{
                                    self.employeesAddedArr[indexPath.row] = employeeObj
                                    AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: self.curentCertification?.certificationId ?? "", employeeObj: employeeObj)
                                }
                                self.employeesTblVw.beginUpdates()
                                self.employeesTblVw.reloadRows(at: [indexPath], with: .automatic)
                                self.employeesTblVw.endUpdates()
                            }
                        }
                        
                    }
                    self.dropHiddenAndShow()
                }
                cell.languageCompletion = {
                    [unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    let arr = self.langArr.map{ $0.value}
                    self.dropDownVIewNew(arrayData: arr as! [String], kWidth: cell.certlangVw.frame.width, kAnchor: cell.certlangVw, yheight: cell.certlangVw.bounds.height) {
                        [unowned self] selectedVal, index  in
                        if indexPath.row > -1 && self.employeesAddedArr.count > indexPath.row{
                            var employeeObj = self.employeesAddedArr[indexPath.row]
                            if index > -1 && self.langArr.count > index{
                                if employeeObj.selectedLangId != self.langArr[index].id{
                                    self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                                }
                                if self.isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: self.curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                                } else {
                                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: self.curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                                }
                                employeeObj.selectedLangId =  self.langArr[index].id!
                                employeeObj.selectedLangValue =  self.langArr[index].value!
                                if self.curentCertification?.certificationId != nil &&  employeeObj.employeeId != nil{
                                    self.employeesAddedArr[indexPath.row] = employeeObj
                                    AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: self.curentCertification?.certificationId ?? "", employeeObj: employeeObj)
                                }
                                self.employeesTblVw.beginUpdates()
                                self.employeesTblVw.reloadRows(at: [indexPath], with: .automatic)
                                self.employeesTblVw.endUpdates()
                            }
                        }
                    }
                    self.dropHiddenAndShow()
                }
                
                cell.rolesCompletion = {
                    [unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    
                    self.resignFirstResponder()
                    
                    let arr = self.rolesArr.map{ $0.value}
                    if indexPath.row > -1 && self.employeesAddedArr.count > indexPath.row{
                        let selectedValueObjStr = self.employeesAddedArr[indexPath.row].rolesArrStr
                        
                        var selectedRoleArr = [DropwnMasterDataVM]()
                        if selectedValueObjStr != "" && selectedValueObjStr != nil{
                            let data = selectedValueObjStr?.data(using: .utf8)
                            let decoder = JSONDecoder()
                            do{
                                if data != nil{
                                    selectedRoleArr =  try decoder.decode([DropwnMasterDataVM].self, from: data!) ?? [DropwnMasterDataVM]()
                                }
                            }catch{
                            }
                        }
                        self.displayEmployeePopup(view: cell.roleBtn, rolesArr: self.rolesArr, defaultRolesArr: selectedRoleArr, empId: self.employeesAddedArr[indexPath.row].employeeId ?? "", indexPath: indexPath
                        )
                    }
                }
                
                cell.startDateCompletion = {
                    [unowned self] ( error) in
                    self.tableviewIndexPath = indexPath
                    self.datePicker()
                }
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func displayEmployeePopup(view: UIButton, rolesArr: [DropwnMasterDataVM], defaultRolesArr: [DropwnMasterDataVM]?, empId:String, indexPath: IndexPath){
        self.resignFirstResponder()
        let storyboard: UIStoryboard = UIStoryboard(name: "Certification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MultiSelectDropdownVC") as! MultiSelectDropdownVC
        vc.curentCertification = curentCertification
        vc.rolesArr = rolesArr
        if defaultRolesArr != nil{
            vc.defaultRoles = defaultRolesArr!
        }
        vc.employeeId = empId
        vc.indexPath = indexPath
        vc.curentCertification = curentCertification
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = view
        var height = 132
        if rolesArr.count > 0{
            height = (rolesArr.count) * 44
        }
        
        popover.sourceRect = CGRect(x: (view.bounds.minX), y: (view.bounds.minY)/1 - 11, width: 150, height: 22)
        popover.delegate = self as? UIPopoverPresentationControllerDelegate
        vc.preferredContentSize = CGSize(width: Int(150), height: height)
        popover.permittedArrowDirections = [.up,.down]
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Tableview Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  98
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 64))
        view.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        view.setGradient(topGradientColor: UIColor.getDashboardTableHeaderUpperGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderLowerGradColor())
        
        let lbl = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: self.view.frame.width-200, height: 20))
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
            lbl.text = "Add Info."
        } else{
            if employeesAddedArr.count > 0{
                lbl.text = "Add Employees (\(employeesAddedArr.count))"
            }else{
                lbl.text = "Add Employees"
            }
        }
        lbl.textColor = UIColor.white
        view.addSubview(lbl)
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{}else{
            
            let btn = UIButton()
            btn.tag = section
            btn.addTarget(self, action: #selector (removeEmployeeAction(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setBackgroundImage(UIImage.init(named: "minusBtn"), for: .normal)
            view.addSubview(btn)
            btn.heightAnchor.constraint(equalToConstant: 34).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 34).isActive = true
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width-22-33).isActive = true
            
            let btnAdd = UIButton()
            btnAdd.tag = section
            btnAdd.addTarget(self, action: #selector (addEmpoyeeAction(_:)), for: .touchUpInside)
            btnAdd.translatesAutoresizingMaskIntoConstraints = false
            btnAdd.setBackgroundImage(UIImage.init(named: "addIcon_new"), for: .normal)
            view.addSubview(btnAdd)
            btnAdd.heightAnchor.constraint(equalToConstant: 34).isActive = true
            btnAdd.widthAnchor.constraint(equalToConstant: 34).isActive = true
            btnAdd.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
            btnAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width-22-33-33-25).isActive = true
            
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            confirmDelete(indexPath: indexPath)
        }
    }
    
    func confirmDelete(indexPath: IndexPath){
        let alertController = UIAlertController(title: "Delete Employee", message: "Are you sure do you want to delete?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
            _ in
            self.deleteEmployeeAction(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Delete Button Action (Minus)
    func deleteEmployeeAction(indexPath: IndexPath){
        if employeesAddedArr.count > 0{
            let currentIndex = indexPath.row
            AddEmployeesDAO.sharedInstance.deleteEmployeeObj(empId:employeesAddedArr[currentIndex].employeeId ?? "", userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:curentCertification?.certificationId ?? "")
            
            AddEmployeesDAO.sharedInstance.removeEmployeeFromBridge(empId:employeesAddedArr[currentIndex].employeeId ?? "", userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId:curentCertification?.certificationId ?? "")
            employeesAddedArr.remove(at: currentIndex)
            employeesTblVw.reloadData()
        }
    }
    
}

// MARK: - EXTENSION POPOVER PRESENTATIN CONTROLLER DELEGATE

extension AddEmployeesVC: UIPopoverPresentationControllerDelegate{
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

// MARK: - EXTENSION DATE PICKER PROTOCOL

extension AddEmployeesVC: DatePickerPopupViewControllerProtocol{
    func doneButtonTapped(string: String) {
        
    }
    
    func doneButtonTappedWithDate(string: String, objDate: Date) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.string(from: objDate)
        if employeesAddedArr.count > tableviewIndexPath.row{
            var emp = employeesAddedArr[tableviewIndexPath.row]
            if emp.startDate != date{
                
                self.curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
                if isSafetyCertification || self.curentCertification?.certificationCategoryId == "1"{
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certificationCategoryId:"1", certObj: self.curentCertification!)
                } else {
                    VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .AddEmployeesVC, certificationId: curentCertification?.certificationId  ?? "", subModule: nil, certObj: self.curentCertification!)
                }
            }
            emp.startDate = date
            employeesAddedArr[tableviewIndexPath.row] = emp
            AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: emp)
        }
        self.employeesTblVw.beginUpdates()
        self.employeesTblVw.reloadRows(at: [tableviewIndexPath], with: .automatic)
        self.employeesTblVw.endUpdates()
    }
    
    func datePicker(){
        if curentCertification?.certificationStatus != VaccinationCertificationStatus.submitted.rawValue{
            self.view.endEditing(true)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Selection", bundle:nil)
            let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier: "DatePickerPopupViewController") as! DatePickerPopupViewController
            datePickerPopupViewController.delegate = self //as! DatePickerPopupViewControllerProtocol
            datePickerPopupViewController.canSelectPreviousDate = true
            datePickerPopupViewController.isVaccinationModule = true
            
            navigationController?.present(datePickerPopupViewController, animated: false, completion: nil)
        }
    }
}

// MARK: - EXTENSION TABLE VIEW REORDER DELEGATE
extension AddEmployeesVC: TableViewReorderDelegate{
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item = employeesAddedArr[sourceIndexPath.row]
        employeesAddedArr.remove(at: sourceIndexPath.row)
        employeesAddedArr.insert(item, at: destinationIndexPath.row)
        
        tableView.reloadData()
        
        var smallerIndex = sourceIndexPath.row
        var largerIndex = destinationIndexPath.row
        
        if sourceIndexPath.row > destinationIndexPath.row{
            largerIndex = sourceIndexPath.row
            smallerIndex = destinationIndexPath.row
        }
        
        for index in smallerIndex...largerIndex{
            var empObj = self.employeesAddedArr[index]
            empObj.sortOrder = ( Int32(index) + 1)
            self.employeesAddedArr[index] = empObj
            
            if self.curentCertification?.certificationId != nil &&  empObj.employeeId != nil{
                AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: self.curentCertification?.certificationId ?? "", employeeObj: empObj)
            }
        }
    }
}

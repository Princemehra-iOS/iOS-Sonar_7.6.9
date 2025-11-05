//
//  QuestionnaireVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 15/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//
//info_attendee

import UIKit

class QuestionnaireVC: BaseViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var safetyAwarenessAssessmentVw: UIView!
    @IBOutlet weak var safetyAwarenessAssessmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveAsDraftBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var quesScrollView: UIScrollView!
    @IBOutlet weak var gpColleagueStackVw: UIStackView!
    @IBOutlet weak var btnStackVw: UIStackView!
    @IBOutlet weak var gpSupervisorStackVw: UIStackView!
    @IBOutlet weak var safetyAwarenessGPHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var safetyAwarenessGPVw: UIView!
    @IBOutlet weak var headerContainerVw: UIView!
    @IBOutlet weak var safetyAwarenessStackVw: UIStackView!
    @IBOutlet weak var tblVwHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionnaireTblVw: UITableView!
    @IBOutlet weak var gpColleagueNameVw: UIView!
    @IBOutlet weak var gpColleagueJobTitle: UIView!
    @IBOutlet weak var gpSupervisorVw: UIView!
    @IBOutlet weak var gpSupervisorJobTitleVw: UIView!
    @IBOutlet weak var supervisornameTxtfld: UITextField!
    @IBOutlet weak var supervisorJobTitleTxtFld: UITextField!
    @IBOutlet weak var colleaguenameTxtFld: UITextField!
    @IBOutlet weak var colleagueNameJobTitileTxtFld: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var sitenameLbl: UILabel!
    @IBOutlet weak var stackVwAcknowledgement: UIStackView!
    @IBOutlet weak var customerOperatorBtn: UIButton!
    @IBOutlet weak var acknowledgementBtn: UIButton!
    @IBOutlet weak var safetyAwarenessBtn: UIButton!
    @IBOutlet weak var operatorCertImgVw: UIImageView!
    @IBOutlet weak var safetyAwarenessImgVw: UIImageView!
    @IBOutlet weak var acknowledgementImgVw: UIImageView!
    @IBOutlet weak var acknowledgementVw: UIView!
    @IBOutlet weak var operationCertificationVw: UIView!
    @IBOutlet weak var safetyAwarenessVw: UIView!
    @IBOutlet weak var tblVwTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var vaccinationMixingVw: UIView!
    @IBOutlet weak var vaccinationMixingBtn: UIButton!
    @IBOutlet weak var vaccinationMixingImgVw: UIImageView!
    // MARK: - VARIABLES AND CONSTANTS
    
    var subModule:String = ""
    var numberofCellsInCollection = 1
    var tableviewIndexPath = IndexPath(row: 0, section: 0)
    var cellLockdownMode = false
    var curentCertification:VaccinationCertificationVM?
    var questionnaireVMObj:  QuestionnaireVM?
    var currentQuestionTypeObj: VaccinationQuestionTypeVM?
    let certificationTypeId = VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
    var selectedEmpIndex:Int = 0
    var employeesAddedArr = [VaccinationEmployeeVM]()
    var vaccinationHeaderView: VaccinationHeaderContainerVC!
    var AssessmentDate:String = ""
    var trainingId = Int()
    var fssId = Int()
	var approverId:Int?
    var selectedStateName:String?
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        
        removeAllBtn()
        registerCells()
        setupUI()
        setupHeaderView()
        fetchQuestionnaireData()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuestionnaireData(_:)), name: NSNotification.Name.init(rawValue: "UpdateQuestionnaireObj") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateEmpObj(_:)), name: NSNotification.Name.init(rawValue: "UpdateEmployeeSign") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateEmployeeSelection(_:)), name: NSNotification.Name.init(rawValue: "UpdateEmployeeSelection") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        subModule = VaccinationSubModuleNames.OperationCertification.rawValue
        
        if  subModule == "" || subModule == VaccinationSubModuleNames.OperationCertification.rawValue || subModule == VaccinationSubModuleNames.SafetyCertification.rawValue || subModule == VaccinationSubModuleNames.VaccineMixing.rawValue{
            operatorAction(true)
        } else if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            if operatorCertImgVw != nil && safetyAwarenessImgVw != nil{
                acknowledgementAction()
            }
        }
        if !(curentCertification?.certificationCategoryId == certificationTypeId){
            if subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue{
                safetyAwarenessAction()
            }
            if subModule == VaccinationSubModuleNames.VaccineMixing.rawValue{
                vaccineMixingAction()
            }
        }
        tblVwHeightConstraint.constant = questionnaireTblVw.contentSize.height
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule: subModule, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
            enableOrDisable(false)
        } else{
            enableOrDisable( true)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(subModule, forKey: "ViewCertificationsVC")
    }
    
    // MARK: - INITIAL UI SETUP
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addGradient()
    }
    
    func removeAllBtn(){
        btnStackVw.removeArrangedSubview(backBtn)
        btnStackVw.removeArrangedSubview(saveAsDraftBtn)
        btnStackVw.removeArrangedSubview(submitBtn)
        
        backBtn.isUserInteractionEnabled = false
        saveAsDraftBtn.isUserInteractionEnabled = false
        submitBtn.isUserInteractionEnabled = false
        
        backBtn.isHidden = true
        saveAsDraftBtn.isHidden = true
        submitBtn.isHidden = true
        
    }
    
    func registerCells(){
        questionnaireTblVw.delegate = self
        questionnaireTblVw.dataSource = self
        questionnaireTblVw.register(QuestionnaireTableViewCell.nib, forCellReuseIdentifier: QuestionnaireTableViewCell.identifier)
        
        questionnaireTblVw.register(AcknowledgementTableViewCell.nib, forCellReuseIdentifier: AcknowledgementTableViewCell.identifier)
        questionnaireTblVw.register(SignatureTableViewCell.nib, forCellReuseIdentifier: SignatureTableViewCell.identifier)
        
    }
    
    func setupUI(){
        operatorCertImgVw.image = UIImage.init(named: "tabSelect")
        safetyAwarenessImgVw.image = UIImage.init(named: "tabUnselect")
        acknowledgementImgVw.image = UIImage.init(named: "tabUnselect")
        vaccinationMixingImgVw.image = UIImage.init(named: "tabUnselect")
        
        customerOperatorBtn.roundCorners(corners: [.topRight, .topLeft], radius: 18.5)
        safetyAwarenessBtn.roundCorners(corners: [.topRight, .topLeft], radius: 18.5)
        acknowledgementBtn.roundCorners(corners: [.topRight, .topLeft], radius: 18.5)
        safetyAwarenessAssessmentVw.isHidden = false
        safetyAwarenessAssessmentHeightConstraint.constant = 71
        safetyAwarenessStackVw.isHidden = false
        
        if !AssessmentDate.trimmingCharacters(in: .whitespaces).isEmpty {
            dateLbl.text = AssessmentDate
        } else {
            if let scheduledDate = curentCertification?.scheduledDate {
                // Pass Date directly since convertDateFormater expects Date
                dateLbl.text = CodeHelper.sharedInstance.convertDateFormater(scheduledDate)
            } else {
                dateLbl.text = ""
            }
        }
        
        sitenameLbl.text = (curentCertification?.siteName ?? "")
        customerLbl.text = curentCertification?.customerName
        tblVwTopConstraint.constant = 22.5
        
        if curentCertification?.certificationCategoryId == certificationTypeId{
            safetyAwarenessGPVw.isHidden = false
            safetyAwarenessAssessmentVw.isHidden = false
            dateLbl.text = AssessmentDate ?? ""
            tblVwTopConstraint.constant = 0
            gpColleagueStackVw.isHidden = true
            gpSupervisorStackVw.isHidden = true
            safetyAwarenessGPVw.isHidden = true
            safetyAwarenessGPHeightConstraint.constant = 0
            customerLbl.text = curentCertification?.customerName
            setBordeViewWithColor(gpColleagueNameVw)
            setBordeViewWithColor(gpColleagueJobTitle)
            setBordeViewWithColor(gpSupervisorVw)
            setBordeViewWithColor(gpSupervisorJobTitleVw)
            stackVwAcknowledgement.removeArrangedSubview(safetyAwarenessBtn)
            stackVwAcknowledgement.removeArrangedSubview(safetyAwarenessImgVw)
            stackVwAcknowledgement.removeArrangedSubview(safetyAwarenessVw)
            safetyAwarenessImgVw.removeFromSuperview()
            safetyAwarenessBtn.removeFromSuperview()
            safetyAwarenessVw.removeFromSuperview()
            
            stackVwAcknowledgement.removeArrangedSubview(vaccinationMixingBtn)
            stackVwAcknowledgement.removeArrangedSubview(vaccinationMixingImgVw)
            stackVwAcknowledgement.removeArrangedSubview(vaccinationMixingVw)
            
            vaccinationMixingImgVw.removeFromSuperview()
            vaccinationMixingBtn.removeFromSuperview()
            vaccinationMixingVw.removeFromSuperview()
            
            customerOperatorBtn.setTitle("Safety Awareness", for: .normal)
            operatorCertImgVw.image = UIImage.init(named: "tabSelect")
            safetyAwarenessImgVw.image = UIImage.init(named: "tabUnselect")
            acknowledgementImgVw.image = UIImage.init(named: "tabUnselect")
            vaccinationMixingImgVw.image = UIImage.init(named: "tabUnselect")
            
            
            
            
        } else{
            customerOperatorBtn.setTitle("Customer Operator", for: .normal)
            numberofCellsInCollection = 3
            tblVwTopConstraint.constant = 0
            gpColleagueStackVw.isHidden = true
            gpSupervisorStackVw.isHidden = true
            safetyAwarenessGPVw.isHidden = true
            safetyAwarenessGPHeightConstraint.constant = 0
        }
        
    }
    
    func setupHeaderView(){
        vaccinationHeaderView = VaccinationHeaderContainerVC()
        if curentCertification?.certificationCategoryId == VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID{
            vaccinationHeaderView.titleOfHeader = "359 form"
        } else{
            vaccinationHeaderView.titleOfHeader = "Operator Certification"
        }
        self.headerContainerVw.addSubview(vaccinationHeaderView.view)
        self.topviewConstraint(vwTop: vaccinationHeaderView.view)
    }
    
    func fetchQuestionnaireData(){
                
        questionnaireVMObj = UserFilledQuestionnaireDAO.sharedInstance.fetchQuestionnaireData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "")
        
        
        linkEmployees()
        
        if curentCertification?.certificationCategoryId == VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID{
            selectCurrentCertificationdata( VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_QUESTION_TYPE_ID)
        }
        
        else{
            selectCurrentCertificationdata(VaccinationConstants.LookupMaster.OPERATOR_CERTIFICATION_QUESTION_TYPE_ID)
        }
        
        questionnaireTblVw.reloadData()
        tblVwHeightConstraint.constant = questionnaireTblVw.contentSize.height
        
    }
    
    // MARK: - OBJC SELECTORS
    
    @objc func  UpdateEmployeeSelection(_ notification: NSNotification){
        if let index = notification.userInfo?["index"]  as? Int{
            if let tabSelection = notification.userInfo?["tabSelection"]  as? Int{
                if let emp = notification.userInfo?["emp"]  as? VaccinationEmployeeVM{
                    if let isSelected = notification.userInfo?["isSelected"]  as? Bool{
                        self.markSyncReady()
                        var tId = VaccinationConstants.LookupMaster.OPERATOR_CERTIFICATION_QUESTION_TYPE_ID
                        if tabSelection == 1{
                            tId = VaccinationConstants.LookupMaster.SAFETY_AWARENESS_QUESTION_TYPE_ID
                        }
                        if tabSelection == 2{
                            tId = VaccinationConstants.LookupMaster.VACCINE_MIXING_TYPE_ID
                        }
                        
                        let typeIdIndex = questionnaireVMObj?.questionTypeObj?.firstIndex(where: {
                            $0.typeId == tId
                        })
                        if typeIdIndex != nil{
                            var employees = questionnaireVMObj?.questionTypeObj?[typeIdIndex!].questionCategories?[index].employees
                            
                            if isSelected{
                                employees?.append(emp)
                                questionnaireVMObj?.questionTypeObj?[typeIdIndex!].questionCategories?[index].employees = employees
                                if ((subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue && tabSelection == 1) || (subModule == VaccinationSubModuleNames.OperationCertification.rawValue && tabSelection == 0) || (subModule == VaccinationSubModuleNames.VaccineMixing.rawValue && tabSelection == 2)){
                                    currentQuestionTypeObj?.questionCategories?[index].employees = employees
                                    
                                }
                                AddEmployeesDAO.sharedInstance.addEmpToCategory(empId: emp.employeeId ?? "", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", catId: currentQuestionTypeObj?.questionCategories?[index].categoryId ??  "", typeId: currentQuestionTypeObj?.questionCategories?[index].typeId ??  "")
                                
                            }else{
                                let empIndex = employees!.firstIndex(where: {
                                    $0.employeeId == emp.employeeId
                                })
                                if empIndex != nil{
                                    employees?.remove(at: empIndex!)
                                    questionnaireVMObj?.questionTypeObj?[typeIdIndex!].questionCategories![index].employees = employees
                                    
                                    if ((subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue && tabSelection == 1) || (subModule == VaccinationSubModuleNames.OperationCertification.rawValue && tabSelection == 0) || (subModule == VaccinationSubModuleNames.VaccineMixing.rawValue && tabSelection == 2)){
                                        currentQuestionTypeObj?.questionCategories?[index].employees = employees
                                        
                                        AddEmployeesDAO.sharedInstance.deleteEmpByCategory(empId: emp.employeeId ?? "", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", catId: currentQuestionTypeObj?.questionCategories?[index].categoryId ??  "", typeId: currentQuestionTypeObj?.questionCategories?[index].typeId ??  "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func  updateEmpObj(_ notification: NSNotification){
        if let rowIndex = notification.userInfo?["rowIndex"]  as? Int{
            
            if let index = notification.userInfo?["index"] as? Int{
                selectedEmpIndex = index
                if let sign = notification.userInfo?["sign"]  as? String{
                    if rowIndex == 1{
                        if index > -1{
                            selectedEmpIndex = index
                            if index > -1 && index == employeesAddedArr.count + 1 {
                                
                                curentCertification?.fsrSignature = sign
                                
                                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                            }
                            if index > -1 && index == employeesAddedArr.count{
                                curentCertification?.hatcheryManagerSign = sign
                                VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                            }
                            if employeesAddedArr.count > index{
                                var emp = employeesAddedArr[index]
                                emp.signBase64 = sign
                                employeesAddedArr[index] = emp
                                AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: emp)
                            }
                        }
                    }
                    if rowIndex == 2{
                        curentCertification?.hatcheryManagerSign = sign
                        
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                    }
                    if rowIndex == 3{
                        curentCertification?.fsrSignature = sign
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                        
                    }
                    markSyncReady()
                }
                if  let hasSignCleared = notification.userInfo?["hasSignCleared"]  as? Bool{
                    selectedEmpIndex = index
                    if rowIndex == 1{
                        var empIndex = index
                        if empIndex > -1 && empIndex == employeesAddedArr.count + 1 {
                            curentCertification?.fsrSignature = ""
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                        }
                        if empIndex > -1 && empIndex == employeesAddedArr.count{
                            curentCertification?.hatcheryManagerSign = ""
                            VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                        }
                        
                        if rowIndex == 1 && employeesAddedArr.count > 0 && empIndex > -1 && employeesAddedArr.count > empIndex{
                            var emp = employeesAddedArr[index]
                            emp.signBase64 = nil
                            employeesAddedArr[index] = emp
                            AddEmployeesDAO.sharedInstance.addCertEmployee(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "", employeeObj: emp)
                        }
                        
                    }
                    if rowIndex == 2{
                        curentCertification?.hatcheryManagerSign = nil
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                    }
                    if rowIndex == 3{
                        curentCertification?.fsrSignature = nil
                        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
                        
                    }
                    markSyncReady()
                }else{
                    //  markSyncReady()
                    self.questionnaireTblVw.beginUpdates()
                    questionnaireTblVw.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with:  .automatic)
                    self.questionnaireTblVw.endUpdates()
                }
                
            }
        }
    }
    
    @objc func updateQuestionnaireData(_ notification: NSNotification){
        if let sectionIndex = notification.userInfo?["sectionIndex"]  as? Int{
            if sectionIndex > -1{
                if let rowIndex = notification.userInfo?["rowIndex"]  as? Int{
                    if let questionObj = notification.userInfo?["questionObj"]  as? VaccinationQuestionVM{
                        self.markSyncReady()
                        if  questionnaireVMObj != nil && questionnaireVMObj?.questionTypeObj != nil && (questionnaireVMObj?.questionTypeObj!.count)! > 0{
                            updateCurrentindex(sectionIndex: sectionIndex, rowIndex:rowIndex , questionObj: questionObj)
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc  func nextBtnAction(_ sender: UIButton){
        
    }
    
    @objc  func shippingBtnAction(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Certification", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "shippindAddressViewController") as! shippindAddressViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.curentCertification = curentCertification
        popupVC.trainingId = self.trainingId ?? 0
        popupVC.fssId = fssId
       
        popupVC.onDismiss = { [weak self] in
            guard let self = self else { return }
            
            for cell in questionnaireTblVw.visibleCells {
                if let signatureCell = cell as? SignatureTableViewCell {
                    signatureCell.updateWithShippingInfo()
                    break // if only one cell matches
                }
            }
    
        }
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func customerOperatorBtn(_ sender: UIButton) {
        operatorAction()
    }
    
    // MARK: - VAccine Mixing & Handling ACTIONS
    @IBAction func vaccineMixingBtnAction(_ sender: UIButton) {
        vaccineMixingAction()
    }
    
    
    
    
    @IBAction func backBtnAcction(_ sender: UIButton) {
        
        if  subModule == "" || subModule == VaccinationSubModuleNames.OperationCertification.rawValue || subModule == VaccinationSubModuleNames.SafetyCertification.rawValue{
            navigateToAddEmployee()
            
        } else if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            if curentCertification?.certificationCategoryId == VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID{
                operatorAction()
            } else{
                if operatorCertImgVw != nil && safetyAwarenessImgVw != nil{
                    safetyAwarenessAction()
                }
            }
            
        } else{
            if !(curentCertification?.certificationCategoryId == certificationTypeId){
                if subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue{
                    operatorAction()
                    
                }
            }
        }
    }
    
    @IBAction func safetyAwarenessBtnAction(_ sender: UIButton) {
        safetyAwarenessAction()
    }
    
    @IBAction func acknowledgementBtnAction(_ sender: UIButton) {
        acknowledgementAction()
    }
    
    @IBAction func saveAsDraftBtnAction(_ sender: UIButton) {
        navigateToDashboard(status: VaccinationCertificationStatus.draft)
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        if curentCertification?.certificationCategoryId != "1" {
            if curentCertification?.certificationStatus == VaccinationCertificationStatus.draft.rawValue || curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue  {
                var newTrainingId = 0
                if trainingId == 0
                {
                    newTrainingId =  Int(curentCertification?.certificationId ?? "") ?? 0
                }
                else
                {
                    newTrainingId = trainingId
                }
                let siteId = Int(curentCertification?.siteId ?? "")
                let shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfoByTrainingId(trainingId: newTrainingId, siteId)
                let OtherShippingAddressDetails =  VaccinationCustomersDAO.sharedInstance.fetchOtherShippingAddressByTrainingId(trainingId: newTrainingId, siteId)
            
                let isMainValid = isValidAddress(shippingInfoDB)
                let isOtherValid = isValidAddress(OtherShippingAddressDetails)
                
                if !isMainValid && !isOtherValid {
                    displayAlertMessageForAddress(userMessage: "Please enter all the address details to submit the certification")
                    return
                }
               
//                if shippingInfoDB != nil {
//                    
//                    if shippingInfoDB?.address1 == "" || shippingInfoDB?.pincode == "" || shippingInfoDB?.city == "" || shippingInfoDB?.countryID == 0 || shippingInfoDB?.stateID == 0
//                    {
//                        displayAlertMessageForAddress(userMessage: "Please enter all the address details to submit the certification")
//                        return
//                    }
//                }
            }
            else{
                var shippingInfoDB: ShippingAddressDTO?
                var OtherShippingAddressDetails: ShippingAddressDTO?
                
                if curentCertification?.selectedFsmId == nil || curentCertification?.selectedFsmId == "" {
                    shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
                    OtherShippingAddressDetails = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
                    
                }
                else {
                    shippingInfoDB = VaccinationCustomersDAO.sharedInstance.fetchShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
                    OtherShippingAddressDetails = VaccinationCustomersDAO.sharedInstance.fetchOtherShippingInfo(siteId: Int(self.curentCertification?.siteId ?? "") ?? 0 )
                }
                
                debugPrint(OtherShippingAddressDetails)
               
                 let isMainValid = isValidAddress(shippingInfoDB)
                 let isOtherValid = isValidAddress(OtherShippingAddressDetails)
                 
                 if !isMainValid && !isOtherValid {
                     displayAlertMessageForAddress(userMessage: "Please enter all the address details to submit the certification")
                     return
                 }
                
                
//                if shippingInfoDB != nil {
//                    
//                    if shippingInfoDB?.address1 == ""  || shippingInfoDB?.pincode == "" || shippingInfoDB?.city == ""
//                    {
//                        
//                        displayAlertMessageForAddress(userMessage: "Please enter all the address details to submit the certification")
//                        return
//                    }
//                    
//                }
            }
        }
        
        
        if  subModule == "" || subModule == VaccinationSubModuleNames.OperationCertification.rawValue || subModule == VaccinationSubModuleNames.SafetyCertification.rawValue{
            //Navigate back to the Employees Screen
            if curentCertification?.certificationCategoryId == VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID{
                acknowledgementAction()
                //               operatorAction()
            } else{
                if operatorCertImgVw != nil && safetyAwarenessImgVw != nil{
                    safetyAwarenessAction()
                }
            }
            
        } else if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            if operatorCertImgVw != nil && safetyAwarenessImgVw != nil{
                navigateToDashboard(status: VaccinationCertificationStatus.submitted)
                //Navigate to the Dashboard with the status as Submitted
            }
            if curentCertification?.certificationCategoryId == certificationTypeId{
                if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
                    navigateToDashboard(status: VaccinationCertificationStatus.submitted)
                }
                
            }
        } else{
            if !(curentCertification?.certificationCategoryId == certificationTypeId){
                if subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue{
                    acknowledgementAction()
                    
                }else if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
                    navigateToDashboard(status: VaccinationCertificationStatus.submitted)
                }
            }
        }
    }
    
    //MARK: 👇  Validate Shipping address & Other Shipping Address
    func isValidAddress(_ address: ShippingAddressDTO?) -> Bool {
        guard let address = address else { return false }
        return !(address.address1?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) &&
               !(address.pincode?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) &&
               !(address.city?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) &&
               address.countryID != 0 &&
               address.stateID != 0
    }
    
    
    
    @IBAction func showPopover(_ sender: UIButton){
        displayEmployeePopup(view: sender, employeesArr: (currentQuestionTypeObj?.questionCategories?[sender.tag].employees) ?? [], index: sender.tag)
    }
    
    // MARK: - METHODS AND FUNCTIONS
    
    func markSyncReady(){
        curentCertification?.syncStatus =  VaccinationCertificationSyncStatus.syncReady.rawValue
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
    }
    
    func enableOrDisable(_ flag:Bool){
        supervisornameTxtfld.isUserInteractionEnabled = flag
        supervisorJobTitleTxtFld.isUserInteractionEnabled = flag
        colleaguenameTxtFld.isUserInteractionEnabled = flag
    }
    
    func configureAcknowledgenmentVw(){
        removeAllBtn()
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
            
        } else{
            saveAsDraftBtn.isHidden = false
            submitBtn.isHidden = false
            saveAsDraftBtn.isUserInteractionEnabled = true
            submitBtn.isUserInteractionEnabled = true
            
            
            btnStackVw.addArrangedSubview(saveAsDraftBtn)
            btnStackVw.addArrangedSubview(submitBtn)
        }
    }
    
    func addACtions(){
        
    }
    
    func  configureSafetyAwarenessVw(){
        removeAllBtn()
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
        }else{
            
            saveAsDraftBtn.isHidden = false
            saveAsDraftBtn.isUserInteractionEnabled = true
            btnStackVw.addArrangedSubview(saveAsDraftBtn)
        }
    }
    
    
    
    func  configureVaccineMixingVw(){
        removeAllBtn()
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
        }else{
            
            saveAsDraftBtn.isHidden = false
            saveAsDraftBtn.isUserInteractionEnabled = true
            btnStackVw.addArrangedSubview(saveAsDraftBtn)
        }
    }
    
    func configureOperatorCertVw(){
        removeAllBtn()
        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
            backBtn.isHidden = false
            backBtn.isUserInteractionEnabled = true
            btnStackVw.addArrangedSubview(backBtn)
        }else{
            backBtn.isHidden = false
            backBtn.isUserInteractionEnabled = true
            btnStackVw.addArrangedSubview(backBtn)
            saveAsDraftBtn.isHidden = false
            saveAsDraftBtn.isUserInteractionEnabled = true
            btnStackVw.addArrangedSubview(saveAsDraftBtn)
        }
    }
    
    
    func `updateCurrentindex`(sectionIndex:Int, rowIndex:Int, questionObj:VaccinationQuestionVM){
        let objIndex = questionnaireVMObj?.questionTypeObj!.firstIndex(where: {
            $0.typeId == questionObj.typeId!
        })
        if let index = objIndex{
            
            if let question = questionnaireVMObj?.questionTypeObj![index].questionCategories![sectionIndex].questionArr![rowIndex]{
                if question.questionId != nil && question.questionId == questionObj.questionId{
                    questionnaireVMObj?.questionTypeObj![index].questionCategories![sectionIndex].questionArr![rowIndex] = questionObj
                    if currentQuestionTypeObj != nil{
                        if currentQuestionTypeObj?.questionCategories != nil && currentQuestionTypeObj?.questionCategories!.count ?? 0 > sectionIndex && (currentQuestionTypeObj?.questionCategories![sectionIndex].questionArr?.count)! > rowIndex{
                            currentQuestionTypeObj?.questionCategories![sectionIndex].questionArr![rowIndex] = questionObj
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    func linkEmployees(){
        
        
        if curentCertification?.certificationCategoryId == "2" {
            employeesAddedArr = AddEmployeesDAO.sharedInstance.getAllCertEmployees(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: curentCertification?.certificationId ?? "")
        }
    }
    
    func selectCurrentCertificationdata(_ id:String)-> Bool{
        var didSet = false
        if currentQuestionTypeObj?.typeId != id{
            let filteredArr = questionnaireVMObj?.questionTypeObj?.filter({
                $0.typeId == id
            })
            if filteredArr != nil && filteredArr!.count > 0{
                currentQuestionTypeObj = filteredArr?[0]
            }
            
            didSet = true
        }
        return didSet
    }
    
    
    func setValues(){
        
    }
    
    
    func displayEmployeePopup(view: UIButton, employeesArr: [VaccinationEmployeeVM], index:Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "Certification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectEmployeePopoverVC") as! SelectEmployeePopoverVC
        vc.employeesAddedArr = employeesAddedArr //employeesArr
        vc.curentCertification = curentCertification
        vc.questionnaireSectionIndex = index
        
        
        if subModule == VaccinationSubModuleNames.SafetyAwareness.rawValue{
            vc.selectedTab = 1
        }
        else if subModule == VaccinationSubModuleNames.VaccineMixing.rawValue{
            vc.selectedTab = 2
        }
        else{
            vc.selectedTab = 0
        }
        
        vc.categoryEmployees = (currentQuestionTypeObj?.questionCategories?[index].employees) ?? []
        
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.sourceView = view
        popover.sourceRect = CGRect(x: (view.bounds.width) - 46, y: (view.bounds.height)/1 - 11, width: 44, height: 22)
        popover.delegate = self as? UIPopoverPresentationControllerDelegate
        vc.preferredContentSize = CGSize(width: 411, height: 484.5)
        popover.permittedArrowDirections = [.up,.down]
        present(vc, animated: true, completion: nil)
    }
    
    
    func scrollToTblVwIndex(){
        if questionnaireVMObj?.questionTypeObj != nil{
            if (questionnaireVMObj?.questionTypeObj?.count)! > 0{
                questionnaireTblVw.scrollToRow(at:IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
    }
    
    
    func operatorAction(_ firstLoad:Bool = false){
        subModule = VaccinationSubModuleNames.OperationCertification.rawValue
        if submitBtn != nil{
            submitBtn.setTitle("Next", for: .normal)
        }
        
        questionnaireTblVw.isScrollEnabled = true
        
        
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
        configureOperatorCertVw()
        if operatorCertImgVw != nil{
            operatorCertImgVw.image = UIImage.init(named: "tabSelect")
        }
        if safetyAwarenessImgVw != nil{
            safetyAwarenessImgVw.image = UIImage.init(named: "tabUnselect")
        }
        if acknowledgementImgVw != nil{
            acknowledgementImgVw.image = UIImage.init(named: "tabUnselect")
        }
        if vaccinationMixingImgVw != nil {
            vaccinationMixingImgVw.image = UIImage.init(named: "tabUnselect")
        }
        
        if curentCertification?.certificationCategoryId == certificationTypeId{
            
            if self.selectCurrentCertificationdata(VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_QUESTION_TYPE_ID){
                self.questionnaireTblVw.reloadData()
                if !firstLoad{
                    self.scrollToTblVwIndex()
                }
                
            }
        }else{
            if self.selectCurrentCertificationdata(VaccinationConstants.LookupMaster.OPERATOR_CERTIFICATION_QUESTION_TYPE_ID){
                self.questionnaireTblVw.reloadData()
                if !firstLoad{
                    self.scrollToTblVwIndex()
                }
                
            }
            
        }
    }
    
    
    func safetyAwarenessAction(){
        configureSafetyAwarenessVw()
        questionnaireTblVw.isScrollEnabled = true
        subModule = VaccinationSubModuleNames.SafetyAwareness.rawValue
        
        if submitBtn != nil{        submitBtn.setTitle("Next", for: .normal)}
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
        
        operatorCertImgVw.image = UIImage.init(named: "tabUnselect")
        safetyAwarenessImgVw.image = UIImage.init(named: "tabSelect")
        acknowledgementImgVw.image = UIImage.init(named: "tabUnselect")
        vaccinationMixingImgVw.image = UIImage.init(named: "tabUnselect")
        if selectCurrentCertificationdata(VaccinationConstants.LookupMaster.SAFETY_AWARENESS_QUESTION_TYPE_ID){
            self.questionnaireTblVw.reloadData()
            self.scrollToTblVwIndex()
        }
    }
    
    func vaccineMixingAction(){
        
        configureVaccineMixingVw()
        questionnaireTblVw.isScrollEnabled = true
        subModule = VaccinationSubModuleNames.VaccineMixing.rawValue
        
        if submitBtn != nil{        submitBtn.setTitle("Next", for: .normal)}
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.VaccineMixing.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
        
        operatorCertImgVw.image = UIImage.init(named: "tabUnselect")
        safetyAwarenessImgVw.image = UIImage.init(named: "tabUnselect")
        vaccinationMixingImgVw.image = UIImage.init(named: "tabSelect")
        acknowledgementImgVw.image = UIImage.init(named: "tabUnselect")
        
        if selectCurrentCertificationdata(VaccinationConstants.LookupMaster.VACCINE_MIXING_TYPE_ID){
            self.questionnaireTblVw.reloadData()
            self.scrollToTblVwIndex()
        }
        
        
    }
    
    func acknowledgementAction(){
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.questionnaireTblVw.scrollToRow(at: indexPath, at: .top, animated: false)
        configureAcknowledgenmentVw()
        questionnaireTblVw.isScrollEnabled = false
        subModule = VaccinationSubModuleNames.Acknowledgement.rawValue
        if submitBtn != nil{
            submitBtn.setTitle("Submit", for: .normal)
        }
        currentQuestionTypeObj = nil
        VaccinationDashboardDAO.sharedInstance.insertLastVisitedModuleName(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", lastModuleName: .QuestionnaireVC, certificationId: curentCertification?.certificationId ?? UUID().uuidString, subModule:VaccinationSubModuleNames.OperationCertification.rawValue, certificationCategoryId:curentCertification?.certificationCategoryId  ?? "", certObj: curentCertification!)
        acknowledgementImgVw.image = UIImage.init(named: "tabSelect")
        self.questionnaireTblVw.reloadData()
        self.questionnaireTblVw.scrollToRow(at: indexPath, at: .top, animated: false)
        if operatorCertImgVw != nil{
            operatorCertImgVw.image = UIImage.init(named: "tabUnselect")
        }
        if   safetyAwarenessImgVw != nil{
            safetyAwarenessImgVw.image = UIImage.init(named: "tabUnselect")
        }
        
        if vaccinationMixingImgVw != nil {
            vaccinationMixingImgVw.image = UIImage.init(named: "tabUnselect")
            
        }
    }
    
    
    func addGradient(){
        // operatorCertCustomerVw.setGradientThreeColors(topGradientColor: UIColor.white, midGradientColor: UIColor.white, bottomGradientColor: UIColor.getAddEmployeeGradient())
        safetyAwarenessGPVw.setGradientThreeColors(topGradientColor: UIColor.white, midGradientColor: UIColor.white, bottomGradientColor: UIColor.getAddEmployeeGradient())
        safetyAwarenessAssessmentVw.setGradientThreeColors(topGradientColor: UIColor.white, midGradientColor: UIColor.white, bottomGradientColor: UIColor.getAddEmployeeGradient())
        if submitBtn != nil{
            submitBtn.setGradient(topGradientColor: UIColor.getEmployeeStartBtnUpperGradient(), bottomGradientColor: UIColor.getDashboardTableHeaderLowerGradColor())
        }
        if saveAsDraftBtn != nil{
            saveAsDraftBtn.setGradient(topGradientColor: UIColor.getViewCertUpperGradColor() , bottomGradientColor: UIColor.getViewCertLowerGradColor())
        }
        
    }
    
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Fill Signatures", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    func displayAlertMessageForAddress(userMessage: String) {
        let myAlert = UIAlertController(title: "Fill Address Details", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    func submitDataPopup(msg:String, status: VaccinationCertificationStatus, header: String){
        let errorMSg = msg//"Data available for sync, Do you want to sync now?"
        let alertController = UIAlertController(title: header, message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.submitData(status: status)
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func submitData(status: VaccinationCertificationStatus){
        VaccinationDashboardDAO.sharedInstance.updateCertificationStatus(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "",  certificationId: curentCertification?.certificationId ?? "" , status: status, certCategoryId: curentCertification?.certificationCategoryId ?? "", certObj: curentCertification!)
        
        if status == .submitted{
            if (UserContext.sharedInstance.userDetailsObj?.roleId?.contains(VaccinationConstants.Roles.ROLE_FSM_ID) ?? false || UserContext.sharedInstance.userDetailsObj?.roleId?.contains(VaccinationConstants.Roles.ROLE_TSR_ID) ?? false ) {
                VaccinationDashboardDAO.sharedInstance.updateCertobj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificatonId: curentCertification?.certificationId ?? "", statusId: "4")
            }else{
                VaccinationDashboardDAO.sharedInstance.updateCertobj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificatonId: curentCertification?.certificationId ?? "", statusId: "3")
            }
            
        } else if status == .draft{
            VaccinationDashboardDAO.sharedInstance.updateCertobj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificatonId: curentCertification?.certificationId ?? "",  statusId: "2")
        }
        
		VaccinationDashboardDAO.sharedInstance.updateSubmittedDate(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "",  certificationId: curentCertification?.certificationId ?? "", status: status,certCategoryId:curentCertification?.certificationCategoryId ?? "", certObj: curentCertification!, submittedDate: nil,approverId:approverId)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshCertifications"), object: nil)
        navigateToDashboardVC()
    }
    
    func setBordeViewWithColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
        view.backgroundColor = UIColor.white
    }
    
    
    
    func getAcknowldgementLblTxt(empobj:VaccinationEmployeeVM)-> String{
        var nameArr = [String]()
        if empobj.firstName != nil && empobj.firstName != ""{
            nameArr.append(empobj.firstName!)
        }
        if empobj.middleName != nil && empobj.middleName != ""{
            nameArr.append(empobj.middleName!)
        }
        if empobj.lastName != nil && empobj.lastName != ""{
            nameArr.append(empobj.lastName!)
        }
        
        var currentDate = ""//CodeHelper.sharedInstance.convertDateFormater(curentCertification?.scheduledDate ?? "")
        currentDate = AssessmentDate //dateFormatter.string(from: curentCertification?.submittedDate ?? Date())
        let nameStr = nameArr.joined(separator: " ")
        
        var ackPart = "The undersigned acknowledges that on \(currentDate) at \(curentCertification?.siteName ?? ""), \(nameStr), provided Inovoject device operation material, and that the undersigned was in attendance throughout such training. The undersigned also acknowledges and agrees that any failure of the undersigned to operate the Inovoject® device in full compliance with the operational material or to otherwise deviate from the training provided to the undersigned constitutes a misuse of Zoetis, LLC equipment."
        return ackPart
        
    }
    
    // MARK: - NAVIGATION METHODS
    
    private func navigateToDashboardVC(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: VaccinationDashboardVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
            }
        }
    }
    
    private func navigateToAddEmployee(){
        var vcFound = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddEmployeesVC.self) {
                vcFound = true
                self.navigationController!.popToViewController(controller, animated: true)
            }
        }
        
        if !vcFound{
            let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeesVC") as? AddEmployeesVC
            vc?.curentCertification = curentCertification
            
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    private func navigateToDashboard(status: VaccinationCertificationStatus){
        if status == .draft{
            submitDataPopup(msg: "Are you sure you want to save certification in Draft?", status: status, header:"Save Draft")
        } else if status == .submitted{//curentCertification?.hatcheryManagerSign != nil && curentCertification?.hatcheryManagerSign != "" &&
            if   curentCertification?.fsrSignature != nil && curentCertification?.fsrSignature != ""{
                var isFilled = true
                for emp in employeesAddedArr{
                    if emp.signBase64 != nil && emp.signBase64 != "" {
                        isFilled = isFilled && true
                    }else{
                        isFilled = isFilled && false
                    }
                }
                if isFilled{
                    
                    if curentCertification?.certificationCategoryName != "Safety"
                    {
                        showAlertWithCancelAndSubmit(
                            on: self,
                            title:"⚠️ Shipping Address Check" , // "Alert",
                            message: "Please check your shipping address before submitting the certification.",
                            onCancel: {
                                debugPrint("❌ Cancel tapped")
                            },
                            onSubmit: {
                                self.submitData(status: status)
                                debugPrint("✅ Submit tapped")
                            }
                        )
                    }
                    else
                    {
                        submitDataPopup(msg: "Are you sure you want to submit the certification?", status: status, header:"Submit Certification")
                    }
                    
                }else{
                    displayAlertMessage(userMessage: "Please enter all the signatures to submit the certification")
                }
            }else{
                displayAlertMessage(userMessage: "Please enter all the signatures to submit the certification")
            }
            
        }
    }
    
    
    func showAlertWithCancelAndSubmit(on viewController: UIViewController,
                                       title: String,
                                       message: String,
                                       cancelTitle: String = "Cancel",
                                       submitTitle: String = "Submit",
                                       onCancel: (() -> Void)? = nil,
                                       onSubmit: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }
        
        let submitAction = UIAlertAction(title: submitTitle, style: .default) { _ in
            onSubmit?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        viewController.present(alert, animated: true)
    }

}
// MARK: - EXTENSION TABLE VIEW DATA SOURCE AND DELEGATES

extension QuestionnaireVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            return 2
        } else{
            if currentQuestionTypeObj != nil && currentQuestionTypeObj?.questionCategories != nil &&  (currentQuestionTypeObj?.questionCategories!.count)! > section && currentQuestionTypeObj?.questionCategories![section].questionArr != nil {
                return (currentQuestionTypeObj?.questionCategories![section].questionArr!.count)!
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 67))
        view.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        let lbl = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: self.view.frame.width-41, height: 24))
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            lbl.text = "Acknowledgement Form"  //\(curentCertification?.fsrName ?? "")
        } else{
            if let categoryName = (currentQuestionTypeObj?.questionCategories![section].categoryName){
                lbl.text = categoryName  + " - " + "Job Task Description"
            }
        }
        lbl.textColor = UIColor.white
        view.setGradient(topGradientColor: UIColor.getDashboardTableHeaderUpperGradColor(), bottomGradientColor: UIColor.getDashboardTableHeaderLowerGradColor())
        view.addSubview(lbl)
        
        
        if curentCertification?.certificationCategoryId == "2" || curentCertification?.certificationCategoryId == "0" && subModule != VaccinationSubModuleNames.Acknowledgement.rawValue{
            let btn = UIButton()
            btn.tag = section
            btn.addTarget(self, action: #selector (showPopover(_:)), for: .touchUpInside)
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setBackgroundImage(UIImage.init(named: "orange_background"), for: .normal)
            view.addSubview(btn)
            
            btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 169.5).isActive = true
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 11).isActive = true
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width-42-169.5).isActive = true
            
            let imgVw = UIImageView()
            imgVw.image = UIImage.init(named: "info_attendees")
            imgVw.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imgVw)
            imgVw.heightAnchor.constraint(equalToConstant: 29).isActive = true
            imgVw.widthAnchor.constraint(equalToConstant: 25.5).isActive = true
            imgVw.topAnchor.constraint(equalTo: btn.topAnchor, constant: 7).isActive = true
            imgVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width-20-25.5-42).isActive = true
            
            let attendesLbl = UILabel()
            attendesLbl.translatesAutoresizingMaskIntoConstraints = false
            attendesLbl.backgroundColor = UIColor.clear
            attendesLbl.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            attendesLbl.font = UIFont.boldSystemFont(ofSize: 20)
            attendesLbl.textColor = UIColor.white
            attendesLbl.text  = "Attendees"
            attendesLbl.lineBreakMode = .byWordWrapping
            attendesLbl.textAlignment = .right
            
            view.addSubview(attendesLbl)
            attendesLbl.heightAnchor.constraint(equalToConstant: 24.5).isActive = true
            attendesLbl.widthAnchor.constraint(equalToConstant: 97).isActive = true
            attendesLbl.topAnchor.constraint(equalTo: btn.topAnchor, constant: 7).isActive = true
            attendesLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width-20-25.5-42-97-12.5).isActive = true
        }
        view.roundCorners(corners: [.topLeft,  .topRight], radius: 18.5)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            if indexPath.row == 0{
                return 100
            } else if indexPath.row == 1{
                return 250
            } else{
                return 220
            }
        }
        return 67
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 27
    }
    
    func getSafwetyAckTxt(empobj:VaccinationEmployeeVM)-> String{
        var nameArr = [String]()
        if empobj.firstName != nil && empobj.firstName != ""{
            nameArr.append(empobj.firstName!)
        }
        if empobj.middleName != nil && empobj.middleName != ""{
            nameArr.append(empobj.middleName!)
        }
        if empobj.lastName != nil && empobj.lastName != ""{
            nameArr.append(empobj.lastName!)
        }
        var currentDate = ""
        currentDate = AssessmentDate

        
        let nameStr = nameArr.joined(separator: " ")
        var ackPart = "On \(currentDate), I received safety information for \(curentCertification?.siteName ?? "") from \(curentCertification?.fsmName ?? "") in which I support the inovoject systems. I agree that I have been provided with the above information and I understand everything that has been communicated to me. I understand that I am expected to comply with the safety policies for this hatchery and all safety policies in place for Global Poultry. I will not knowingly endanger myself or any other person."
        return ackPart
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            if indexPath.row == 0{
                if let cell = tableView.dequeueReusableCell(withIdentifier: AcknowledgementTableViewCell.identifier, for: indexPath) as? AcknowledgementTableViewCell{
                    if curentCertification?.certificationCategoryId == "2"{
                        if  selectedEmpIndex == (employeesAddedArr.count + 1) {
                            var emp = VaccinationEmployeeVM()
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            
                            if self.curentCertification?.certificationCategoryId == "1"{
                                cell.acknowledgementLbl.text = getSafwetyAckTxt(empobj: emp)
                            }
                        }
                        if selectedEmpIndex == (employeesAddedArr.count){
                            var emp = VaccinationEmployeeVM()
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            if self.curentCertification?.certificationCategoryId == "1"{
                                cell.acknowledgementLbl.text = getSafwetyAckTxt(empobj: emp)
                            }
                        }
                        if employeesAddedArr.count > 0 && employeesAddedArr.count > selectedEmpIndex && selectedEmpIndex > -1{
                            var emp =  VaccinationEmployeeVM()//employeesAddedArr[selectedEmpIndex]
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            
                            
                        }
                    } else{
                        if  selectedEmpIndex == (employeesAddedArr.count + 1) {
                            var emp = VaccinationEmployeeVM()
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            if self.curentCertification?.certificationCategoryId == "1"{
                                cell.acknowledgementLbl.text = getSafwetyAckTxt(empobj: emp)
                            }
                            
                        }
                        if selectedEmpIndex == (employeesAddedArr.count){
                            var emp = VaccinationEmployeeVM()
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            if self.curentCertification?.certificationCategoryId == "1"{
                                cell.acknowledgementLbl.text = getSafwetyAckTxt(empobj: emp)
                            }
                            
                        }
                        
                        if employeesAddedArr.count > 0 && employeesAddedArr.count > selectedEmpIndex && selectedEmpIndex > -1{
                            var emp =  VaccinationEmployeeVM()//employeesAddedArr[selectedEmpIndex]
                            emp.firstName = UserContext.sharedInstance.userDetailsObj?.firstname
                            emp.lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            cell.acknowledgementLbl.text = getAcknowldgementLblTxt(empobj: emp)
                            
                        }
                    }
                    
                    return cell
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: SignatureTableViewCell.identifier, for: indexPath) as? SignatureTableViewCell{
                    cell.rowIndex = indexPath.row
                    cell.isFromCertification = true
                    cell.fullSiteAddressView.isHidden = false
                    cell.operatorSignLbl.isHidden = false
                    cell.nextBtn.addTarget(self, action:  #selector (nextBtnAction(_:)), for: .touchUpInside)
                    cell.previousBtn.addTarget(self, action:  #selector (nextBtnAction(_:)), for: .touchUpInside)
                    cell.trainingId = self.trainingId
                    if self.curentCertification?.certificationCategoryId == "1" {
                        cell.shippindAddressBtn.isHidden = true
                        cell.buttonBgView.isHidden = true
                        cell.fullSiteAddressView.isHidden = true
                      //  cell.shipToLbl.isHidden = true //3839
                    }
                    else {
                        cell.shippindAddressBtn.isHidden = false
                      // cell.shipToLbl.isHidden = false  //3839
                    }
                    cell.updateSignatureBox()
                    cell.shippindAddressBtn.addTarget(self, action: #selector (shippingBtnAction(_:)) , for: .touchUpInside)
                    cell.showHideBtn(flag: false)
                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                        cell.signImgVw.isUserInteractionEnabled = false
                        cell.signView.isUserInteractionEnabled = false
                        cell.shippindAddressBtn.isHidden = true
                        cell.buttonBgView.isHidden = true
                    }
                    else
                    {
                        cell.signImgVw.isUserInteractionEnabled = true
                        cell.signView.isUserInteractionEnabled = true
                    }
                    if indexPath.row == 1{
                        cell.curentCertification = curentCertification
                        if cell.employeesAddedArr.count == 0{
                            cell.employeesAddedArr = employeesAddedArr
                            cell.empIndex = 0
                            //*************************
                            if cell.empIndex > -1 && cell.empIndex == employeesAddedArr.count + 1 {
                                var fullName = ""
                                let firstname = UserContext.sharedInstance.userDetailsObj?.firstname
                                fullName = firstname ?? ""
                                let lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                                if lastName != nil && lastName != ""{
                                    fullName = firstname ?? "" +  " " + (lastName ?? "")
                                }
                                cell.deviceOperatorNamebl.text  = "Vaccine Mixer Name: \(fullName)"
                                if curentCertification?.fsrSignature != nil && !(curentCertification?.fsrSignature!.isEmpty)!{
                                    cell.hideShowImgVw(false)
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.fsrSignature!)! )
                                }else{
                                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                        cell.clearBtn.isHidden = true
                                        cell.hideShowImgVw(true)
                                    }else{
                                        cell.clearBtn.isHidden = false
                                        
                                        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                            cell.clearBtn.isHidden = true
                                            cell.hideShowImgVw(false)
                                        }else{
                                            cell.clearBtn.isHidden = false
                                        }
                                    }
                                    
                                    cell.hideShowImgVw(true)
                                }
                                cell.operatorSignLbl.text = "Vaccine Mixer Signature*"
                                cell.operatorSignLbl.text = cell.operatorSignLbl.text ?? "" + "*"
                                cell.nextBtn.isEnabled = false
                                cell.nextBtn.isUserInteractionEnabled = false
                                cell.nextBtn.isHidden = true
                                cell.previousBtn.isEnabled = true
                                cell.previousBtn.isUserInteractionEnabled = true
                                cell.previousBtn.isHidden = false
                            }
                            if cell.empIndex > -1 && cell.empIndex == employeesAddedArr.count {
                                cell.operatorSignLbl.text = "Hatchery Manager"
                                cell.nextBtn.isEnabled = true
                                cell.nextBtn.isUserInteractionEnabled = true
                                cell.nextBtn.isHidden = false
                                if employeesAddedArr.count > 0{
                                    
                                    cell.previousBtn.isEnabled = true
                                    cell.previousBtn.isUserInteractionEnabled = true
                                    cell.previousBtn.isHidden = false
                                }else{
                                    cell.previousBtn.isEnabled = false
                                    cell.previousBtn.isUserInteractionEnabled = false
                                    cell.previousBtn.isHidden = true
                                }
                                var hManager = curentCertification?.fsmName ?? ""
                                if curentCertification?.fsmName != nil{
                                    cell.deviceOperatorNamebl.text  = "Hatchery Manager Name: \( curentCertification?.fsmName ?? "")"
                                }
                                if curentCertification?.hatcheryManagerSign != nil && !(curentCertification?.hatcheryManagerSign!.isEmpty)!{
                                    cell.signView.clearCanvas()
                                    cell.operatorSignLbl.isHidden = true
                                    cell.hideShowImgVw(false)
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.hatcheryManagerSign!)! )
                                }
                                else{
                                    cell.hideShowImgVw(true)
                                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                        cell.clearBtn.isHidden = true
                                        cell.hideShowImgVw(false)
                                    }else{
                                        cell.clearBtn.isHidden = false
                                    }
                                }
                            }
                            if cell.empIndex > 0 && cell.empIndex < employeesAddedArr.count {}
                            
                            //---*********************
                            if employeesAddedArr.count  > 0{
                                cell.empIndex = 0
                                
                                cell.deviceOperatorNamebl.text = cell.getEmpName(empobj: cell.employeesAddedArr[cell.empIndex])
                                let emp = employeesAddedArr[cell.empIndex]
                                if emp.signBase64 != nil && !emp.signBase64!.isEmpty{
                                    cell.hideShowImgVw(false)
                                    
                                    cell.operatorSignLbl.isHidden = true
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:emp.signBase64! )
                                }else{
                                    cell.hideShowImgVw(true)
                                    cell.operatorSignLbl.isHidden = false
                                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                        cell.clearBtn.isHidden = true
                                        cell.hideShowImgVw(false)
                                    }else{
                                        cell.clearBtn.isHidden = false
                                    }
                                }
                            }
                        }
                        if cell.empIndex == 0{
                            cell.previousBtn.isHidden = true
                            
                            if curentCertification?.certificationCategoryName != "Safety" {
                                let emp = employeesAddedArr[cell.empIndex]
                                if emp.signBase64 != nil && !emp.signBase64!.isEmpty{
                                    cell.hideShowImgVw(false)
                                    
                                    cell.operatorSignLbl.isHidden = true
                                    cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:emp.signBase64! )
                                }
                            }
                                                        
                        }
                        
                        if cell.empIndex > -1 && cell.empIndex == employeesAddedArr.count + 1 {
                            var fullName = ""
                            let firstname = UserContext.sharedInstance.userDetailsObj?.firstname
                            fullName = firstname ?? ""
                            let lastName = UserContext.sharedInstance.userDetailsObj?.lastName
                            fullName = firstname! + " " + (lastName ?? "") ?? ""
                            cell.deviceOperatorNamebl.text = "Field Service Technician: \(fullName)"
                            if curentCertification?.fsrSignature != nil && !(curentCertification?.fsrSignature!.isEmpty)!{
                                cell.hideShowImgVw(false)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.fsrSignature!)! )
                            }else{
                                if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                    cell.clearBtn.isHidden = true
                                    cell.hideShowImgVw(true)
                                }else{
                                    cell.clearBtn.isHidden = false
                                    
                                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                        cell.clearBtn.isHidden = true
                                        cell.hideShowImgVw(false)
                                    }else{
                                        cell.clearBtn.isHidden = false
                                    }
                                    
                                }
                                
                                cell.hideShowImgVw(true)
                            }
                            cell.operatorSignLbl.text = "Field Service Technician Signature*"
                            cell.operatorSignLbl.text = cell.operatorSignLbl.text ?? "" + "*"
                            cell.nextBtn.isEnabled = false
                            cell.nextBtn.isUserInteractionEnabled = false
                            cell.nextBtn.isHidden = true
                            cell.previousBtn.isEnabled = true
                            cell.previousBtn.isUserInteractionEnabled = true
                            cell.previousBtn.isHidden = false
                        }
                        if cell.empIndex > -1 && cell.empIndex == employeesAddedArr.count{
                            cell.operatorSignLbl.text = "Hatchery Manager Signature*"
                            cell.nextBtn.isEnabled = true
                            cell.nextBtn.isUserInteractionEnabled = true
                            cell.nextBtn.isHidden = false
                            if employeesAddedArr.count > 0{
                                
                                cell.previousBtn.isEnabled = true
                                cell.previousBtn.isUserInteractionEnabled = true
                                cell.previousBtn.isHidden = false//
                            }else{
                                cell.previousBtn.isEnabled = false
                                cell.previousBtn.isUserInteractionEnabled = false
                                cell.previousBtn.isHidden = true
                            }
                            var hManager = curentCertification?.fsmName ?? ""
                            if curentCertification?.fsmName != nil{
                                cell.deviceOperatorNamebl.text  = "Hatchery Manager Name: \( curentCertification?.fsmName ?? "")"
                            }
                            if curentCertification?.hatcheryManagerSign != nil && !(curentCertification?.hatcheryManagerSign!.isEmpty)!{
                                cell.hideShowImgVw(false)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.hatcheryManagerSign!)! )
                            }else{
                                cell.hideShowImgVw(true)
                                if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                    cell.clearBtn.isHidden = true
                                    cell.hideShowImgVw(false)
                                }else{
                                    cell.clearBtn.isHidden = false
                                }
                            }
                        }
                        
                        if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                            cell.clearBtn.isHidden = true
                        }else{
                            cell.clearBtn.isHidden = false
                        }
                        
                      
                       // cell.operatorSignLbl.text = cell.operatorSignLbl.text ?? "" + "*"
                    }else{
                        if indexPath.row == 2{
                            cell.operatorSignLbl.text = "Hatchery Manager"
                            if curentCertification?.hatcheryManagerSign != nil  && !(curentCertification?.hatcheryManagerSign?.isEmpty)!{
                                cell.hideShowImgVw(false)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.hatcheryManagerSign!)! )
                            }else{
                                cell.hideShowImgVw(true)
                            }
                            if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                cell.clearBtn.isHidden = true
                            }else{
                                cell.clearBtn.isHidden = false
                            }
                            
                        } else if indexPath.row == 3{
                            cell.operatorSignLbl.text = "Vaccine Mixer Signature*"
                            cell.operatorSignLbl.text = cell.operatorSignLbl.text  ?? "" + "*"
                            if curentCertification?.fsrSignature != nil  && !(curentCertification?.fsrSignature?.isEmpty)!{
                                cell.hideShowImgVw(false)
                                cell.signImgVw.image = CodeHelper.sharedInstance.convertToImage(base64:(curentCertification?.fsrSignature!)! )
                            }else{
                                cell.hideShowImgVw(true)
                            }
                            if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                cell.clearBtn.isHidden = true
                            }else{
                                cell.clearBtn.isHidden = false
                            }
                        }
                        
                        cell.removeConstraint()
                        cell.showHideBtn(flag: true)
                    }
                    return cell
                }
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionnaireTableViewCell.identifier, for: indexPath) as? QuestionnaireTableViewCell{
                
                if currentQuestionTypeObj != nil && currentQuestionTypeObj?.questionCategories != nil &&  (currentQuestionTypeObj?.questionCategories!.count)! > indexPath.section && currentQuestionTypeObj?.questionCategories![indexPath.section].questionArr != nil && (currentQuestionTypeObj?.questionCategories![indexPath.section].questionArr?.count)! > indexPath.row{
                    cell.setValues(questionObj: (currentQuestionTypeObj?.questionCategories![indexPath.section].questionArr![indexPath.row])!)
                    cell.sectionIndex = indexPath.section
                    cell.rowIndex = indexPath.row
                    cell.segmentControl.tag = indexPath.row
                    if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                        cell.enableOrDisable(false)
                    } else{
                        cell.enableOrDisable( true)
                    }
                    if curentCertification?.certificationCategoryId == "2" || curentCertification?.certificationCategoryId == "0"{
                        
                        cell.commentCompletion = {[unowned self] ( error) in
                            self.tableviewIndexPath = indexPath
                            var questionObj:VaccinationQuestionVM?
                            if self.currentQuestionTypeObj != nil && self.currentQuestionTypeObj?.questionCategories
                                != nil && (self.currentQuestionTypeObj?.questionCategories?.count)! > self.tableviewIndexPath.section && self.currentQuestionTypeObj?.questionCategories![self.tableviewIndexPath.section].questionArr != nil  && (self.currentQuestionTypeObj?.questionCategories![self.tableviewIndexPath.section].questionArr?.count)! > self.tableviewIndexPath.row  {
                                questionObj = self.currentQuestionTypeObj?.questionCategories![self.tableviewIndexPath.section].questionArr![self.tableviewIndexPath.row]
                            }
                            var comments = questionObj?.userComments ?? ""
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
                            vc.textOfTextView = comments
                            if self.curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                                vc.editable = false
                            } else{
                                vc.editable = true
                            }
                            vc.commentCompleted = {[unowned self] ( note) in
                                if note == "" {
                                    let image = UIImage(named: "PEcomment.png")
                                    cell.commentBtn.setImage(image, for: .normal)
                                    
                                } else {
                                    let image = UIImage(named: "PECommentSelected.png")
                                    cell.commentBtn.setImage(image, for: .normal)
                                    
                                }
                                if  questionObj?.userComments != note{
                                    if self.curentCertification?.certificationStatus != VaccinationCertificationStatus.submitted.rawValue{
                                        self.markSyncReady()
                                    }
                                }
                                questionObj?.userComments = note ?? ""
                                if questionObj != nil{
                                    
                                    
                                    UserFilledQuestionnaireDAO.sharedInstance.updateQuestionUserResponse(vmObj: questionObj!)
                                    self.updateCurrentindex(sectionIndex: self.tableviewIndexPath.section, rowIndex: self.tableviewIndexPath.row, questionObj: questionObj!)
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
                        cell.showCommectVw()
                    }else{
                        cell.hideCommentVw()
                    }
                    
                    if indexPath.row % 2 == 0{
                        cell.contentView.backgroundColor = UIColor.white
                    } else{
                        cell.contentView.backgroundColor = UIColor.getHeaderTopGradient()
                    }
                    if (currentQuestionTypeObj?.questionCategories![indexPath.section].questionArr?.count)! - 1 == indexPath.row{
                        cell.colorVw.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                        cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                    }else{
                        cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                        cell.colorVw.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if subModule == VaccinationSubModuleNames.Acknowledgement.rawValue{
            return 1
        }else{
            if currentQuestionTypeObj != nil && currentQuestionTypeObj?.questionCategories != nil {
                return (currentQuestionTypeObj?.questionCategories!.count)!
            }
        }
        return 1
    }
    
    
}

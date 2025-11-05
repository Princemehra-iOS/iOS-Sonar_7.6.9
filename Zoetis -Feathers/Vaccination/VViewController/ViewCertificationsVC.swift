//
//  ViewCertificationsVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 13/05/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ViewCertificationsVC: BaseViewController {
    // MARK: - OUTLETS
    
    @IBOutlet weak var certificationsTblVw: UITableView!
    @IBOutlet weak var headerContainerVw: UIView!
    @IBOutlet weak var sectionHeadeVw: UIView!
    
    // MARK: - VARIABLES
    
    var vaccinationHeaderView: VaccinationHeaderContainerVC!
    var upcomingCertificationsArr = [VaccinationCertificationVM]()
    var  status:VaccinationCertificationStatus = .draft
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        certificationsTblVw.setCornerRadius = 18.5
        setupHeaderView()
        registerTblVwCells()
        setupUI()
    }
    
    @IBAction    override func viewWillAppear(_ animated: Bool) {
        upcomingCertificationsArr = VaccinationDashboardDAO.sharedInstance.getStartedCertificationsByStatusVM(userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", status: status, syncStatus: nil)
        certificationsTblVw.reloadData()
        let userDefaults = UserDefaults.standard
        userDefaults.set(status.rawValue, forKey: "ViewCertificationsVC")
        if upcomingCertificationsArr.count == 0{
            self.certificationsTblVw.isHidden = true
        }
        
    }
    // MARK: - INITIAL UI SET UP
    
    func setupUI(){
        sectionHeadeVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        sectionHeadeVw.backgroundColor = UIColor.getPopupSectionHeaderColor()
        sectionHeadeVw.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
    }
    
    
    func setupHeaderView(){
        vaccinationHeaderView = VaccinationHeaderContainerVC()
        if status == VaccinationCertificationStatus.draft{
            vaccinationHeaderView.titleOfHeader = "Draft Certifications"
        } else if status == VaccinationCertificationStatus.submitted{
            vaccinationHeaderView.titleOfHeader = "Submitted Certifications"
        }
        
        self.headerContainerVw.addSubview(vaccinationHeaderView.view)
        self.topviewConstraint(vwTop: vaccinationHeaderView.view)
        
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
    }
    
    
    func registerTblVwCells(){
        certificationsTblVw.delegate = self
        certificationsTblVw.dataSource = self
        certificationsTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
    }
    
}
// MARK: - EXTENSION TABLE VIEW DATA SOURCE AND DELEGATES

extension ViewCertificationsVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingCertificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VaccinationCertificationsTableViewCell.identifier, for: indexPath) as? VaccinationCertificationsTableViewCell{
            if upcomingCertificationsArr.count > 0 && upcomingCertificationsArr.count > indexPath.row{
                if status != .draft{
                    cell.hideDeleteBtn()
                    cell.editBtn.setImage(UIImage.init(named: "ViewCertification"), for: .normal)
                }
                cell.closeBtn?.tag = indexPath.row
                cell.editBtn.tag = indexPath.row
                cell.editBtn.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
                
                cell.closeBtn?.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
                cell.setValues(vaccinationCertificatonObj: upcomingCertificationsArr[indexPath.row])
                
                cell.removeCertVw()
                cell.setWhiteBackgroundColor()
                cell.addCertCategory(vaccinationCertificatonObj: upcomingCertificationsArr[indexPath.row])
            }
            
            return cell
        }
        return UITableViewCell()
    }
}
// MARK: - EXTENSION VIEW CERTIFICATION VC

extension ViewCertificationsVC{
    @objc func editBtnAction(_ sender: UIButton){
        editAction(sender.tag)
    }
    
    @objc func deleteBtnAction(_ sender: UIButton){
        deleteBtnPopup(index: sender.tag)
    }
    
    func deleteBtnPopup(index:Int){
        let errorMSg = "Are you sure you want to delete the draft?"
        let alertController = UIAlertController(title: "Delete Draft", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.deleteAction(index)
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAction(_ selectedIndex:Int){
        if upcomingCertificationsArr.count > 0 && selectedIndex < upcomingCertificationsArr.count{
            UserFilledQuestionnaireDAO.sharedInstance.deleteVaccinationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: upcomingCertificationsArr[selectedIndex].certificationId ?? "")
            AddEmployeesDAO.sharedInstance.deleteEmployeeByCertification(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: upcomingCertificationsArr[selectedIndex].certificationId ?? "")
            VaccinationDashboardDAO.sharedInstance.deleteStartedCertObjByCertificationId(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: upcomingCertificationsArr[selectedIndex].certificationId ?? "")
            
            
            upcomingCertificationsArr.remove(at: [selectedIndex])
            self.certificationsTblVw.reloadData()
        }
    }
    
    func editAction(_ selectedIndex:Int){
        if upcomingCertificationsArr.count > 0 && selectedIndex < upcomingCertificationsArr.count{
            let certificationId = upcomingCertificationsArr[selectedIndex].certificationId
            let certificationStatusObj = VaccinationDashboardDAO.sharedInstance.getScheduledCertificationStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: certificationId ?? "", certCategoryId: upcomingCertificationsArr[selectedIndex].certificationCategoryId ?? "", certObj: upcomingCertificationsArr[selectedIndex])
            
            DataService.sharedInstance.getFilledCertObj(certificationId: upcomingCertificationsArr[selectedIndex].certificationId ?? "", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", siteId: upcomingCertificationsArr[selectedIndex].siteId ?? "", customerId: upcomingCertificationsArr[selectedIndex].customerId ?? "", fssId: Int(upcomingCertificationsArr[selectedIndex].selectedFsmId ?? "") ?? 0, FsrId: upcomingCertificationsArr[selectedIndex].fsrId ?? "")
            
            if certificationStatusObj.certificationCategoryId == "1"{
                navigatetToAddEmloyees(index: selectedIndex, safetyCertification: true, fssId: Int(upcomingCertificationsArr[selectedIndex].selectedFsmId ?? "") ?? 0, trainingId: Int(upcomingCertificationsArr[selectedIndex].systemCertificationId ?? "") ?? 0)
            } else{
                navigatetToAddEmloyees(index: selectedIndex, fssId: Int(upcomingCertificationsArr[selectedIndex].selectedFsmId ?? "") ?? 0, trainingId: Int(upcomingCertificationsArr[selectedIndex].systemCertificationId ?? "") ?? 0)
            }
        }
    }
    // MARK: - NAVIGATIONS
    
    func navigatetToAddEmloyees(index:Int?, safetyCertification:Bool = false, fssId: Int = 0, trainingId: Int = 0){
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEmployeesVC") as? AddEmployeesVC
        vc?.isSafetyCertification = safetyCertification
        vc?.trainingId = trainingId
        vc?.fssId = fssId
//        vc?.status = status
        if index != nil && index! > -1{
            if !safetyCertification {
                if let indx = index, upcomingCertificationsArr.count > indx {
                    vc?.curentCertification = upcomingCertificationsArr[indx]
                }
//                vc?.curentCertification = upcomingCertificationsArr[index!]
                let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: vc?.curentCertification?.certificationId ?? "")
                
                if startedObj != nil{
                    vc?.curentCertification = startedObj
                }
                if vc?.curentCertification?.certificationCategoryId == "0"{
                    vc?.curentCertification?.certificationCategoryId =  "0"
                    vc?.curentCertification?.certificationCategoryName =  "Operator"
                }else{
                    vc?.curentCertification?.certificationCategoryId =  "2"
                    vc?.curentCertification?.certificationCategoryName =  "Operator"
                }
            }  else {
                if let indx = index, upcomingCertificationsArr.count > indx {
                    vc?.curentCertification = upcomingCertificationsArr[indx]
                }
//                vc?.curentCertification = upcomingCertificationsArr[index!]
                let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: vc?.curentCertification?.certificationId ?? "")
                
                if startedObj != nil{
                    vc?.curentCertification = startedObj
                }
                vc?.curentCertification?.certificationCategoryId =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                vc?.curentCertification?.certificationCategoryName =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
            }
        }
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func navigatetToQuestionnaireScreen(index:Int?, subModule:String = ""){
        let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "QuestionnaireVC") as? QuestionnaireVC
        vc?.subModule = subModule
        if index != nil && index! > -1{
            if let indx = index, upcomingCertificationsArr.count > indx {
                vc?.curentCertification = upcomingCertificationsArr[indx]
            }
            //vc?.curentCertification = upcomingCertificationsArr[index!]
            let startedObj = VaccinationDashboardDAO.sharedInstance.onlyScheduledCertStatusVM(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", certificationId: vc?.curentCertification?.certificationId ?? "")
            if startedObj != nil{
                vc?.curentCertification = startedObj
            }
            var safetyCertification  = false
            if vc?.curentCertification?.certificationCategoryId == "1"{
                safetyCertification = true
            }
            if !safetyCertification{
                
                if let indx = index, upcomingCertificationsArr.count > indx {
                    vc?.curentCertification = upcomingCertificationsArr[indx]
                }
                //vc?.curentCertification = upcomingCertificationsArr[index!]
                vc?.curentCertification?.certificationCategoryId =  "2"
                vc?.curentCertification?.certificationCategoryName =  "Operator"
            }  else{
                vc?.curentCertification?.certificationCategoryId =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_ID
                vc?.curentCertification?.certificationCategoryName =  VaccinationConstants.LookupMaster.SAFETY_CERTIFICATION_CATEGORY_VALUE
            }
            
        }
        
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
}




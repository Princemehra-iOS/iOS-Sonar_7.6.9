//
//  PEDraftViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Reachability

class PEDraftViewController: BaseViewController {
    var regionID = Int()
    var peAssessmentDraftArray : [PENewAssessment] = []
    var popFlagArray: [Bool] = [Bool]()
    var peHeaderViewController:PEHeaderViewController!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var lblCustomer: PEFormLabel!
    @IBOutlet weak var lblSite: PEFormLabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var assIdLabel: UILabel!
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        DispatchQueue.main.async {
            self.coustomerView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Draft Assessments"
        tableview.register(PE_DraftCell.nib, forCellReuseIdentifier: PE_DraftCell.identifier)
        headerView.addSubview(peHeaderViewController.view)
        
        tableview.register(PE_DraftIntCell.nib, forCellReuseIdentifier: PE_DraftIntCell.identifier)
        headerView.addSubview(peHeaderViewController.view)
        
        topviewConstraint(vwTop: peHeaderViewController.view)
        let nibCatchers = UINib(nibName: "PEDraftHeader", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PEDraftHeader")
        let nibCatchers1 = UINib(nibName: "PEDraftIntHeader", bundle: nil)
        tableview.register(nibCatchers1, forHeaderFooterViewReuseIdentifier: "PEDraftIntHeader")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        deleteDeletedAssessments()
        
        lblCustomer.text = UserDefaults.standard.string(forKey: "PE_Selected_Customer_Name") ?? ""
        lblSite.text = UserDefaults.standard.string(forKey: "PE_Selected_Site_Name") ?? ""
    }
    
    // MARK: Get Drafted Assessments Count
    func getDraftCountFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftID") as? NSArray ?? []
        var carColIdArray : [String] = []
        
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? String ?? ""){
                carColIdArray.append(obj as? String ?? "")
            }
        }
        return carColIdArray.count
    }
    
    // MARK: Get Drafted Assessments
    private func getAllDateArrayStored() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject(ofCurrentAssessment:true)
        var carColIdArray : [String] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.draftID ?? ""){
                carColIdArray.append(obj.draftID ?? "")
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    
}
// MARK: PE Draft View Controller Extensions & Table View Delegates
extension PEDraftViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peAssessmentDraftArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = CGFloat()
        height = 70
        return height
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if regionID == 3{
            if let cell = tableView.dequeueReusableCell(withIdentifier: PE_DraftCell.identifier) as? PE_DraftCell{
                cell.selectionStyle = .none
                cell.config(peNewAssessment:peAssessmentDraftArray[indexPath.row])
                cell.rejectIndicatorBtn.tag = indexPath.row
                cell.extendedRejectedComment.tag = indexPath.row
                
                cell.rejectIndicatorBtn.addTarget(self, action: #selector(addInfoPopup(sender:)), for: .touchUpInside)
                cell.extendedRejectedComment.addTarget(self, action: #selector(addExtendedInfoPopup(sender:)), for: .touchUpInside)
                
                popFlagArray.append(false)
                cell.deleteCompletion  = {[unowned self] ( error) in
                    let assessment = self.peAssessmentDraftArray[indexPath.row]
                    var date = assessment.evaluationDate
                    date = date?.replacingOccurrences(of: "/", with: "")
                    
                    var siteId = String(assessment.siteId ?? 0)
                    
                    let draftID = assessment.draftID ?? ""
                    date = "C-" + draftID.prefix(20)
                    
                    
                    let errorMSg = "Are you sure you want to delete the assessment" + (date ?? "") + "?"
                    let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        _ in
                        CoreDataHandlerPE().deleteDraftByDrafyNumber(assessment.draftID ?? "")
                        CoreDataHandlerPE().deleteDraftByAssessmentId(assessment.draftID ?? "")
                        
                        CoreDataHandlerPE().deleteRefregratorDataByStartAssessment(assessment.serverAssessmentId ?? "")
                        CoreDataHandlerPE().deleteDraftedRefregratorDataByAssessmentId(assessment.draftID ?? "")
                        
                        PEDeletedDraftsDAO.sharedInstance.saveDeletedAssessmentsInfo(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "" , serverAssessmentId: assessment.serverAssessmentId ?? "")
                        PEInfoDAO.sharedInstance.deleteInfoObj(assessment.serverAssessmentId ?? "")
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.deleteExistingSanitationQues(assessment.serverAssessmentId ?? "")
                        
                        PEAssessmentsDAO.sharedInstance.updateAssessmentStatus(status:"Schedule",userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: assessment.serverAssessmentId ?? "")
                        self.deleteDeletedAssessments()
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                cell.editCompletion  = {[unowned self] ( error) in
                    
                    Constants.isPPmValueChanged = false
                    Constants.switchCount = 0
                    Constants.isfromDraftStartVC = true
                    let assessment = self.peAssessmentDraftArray[indexPath.row]
                    UserDefaults.standard.set(assessment.serverAssessmentId ?? "", forKey: "currentServerAssessmentId")
                    let pervioudAssesID = UserDefaults.standard.value(forKey: "assIID") as? String ?? ""
                    if(pervioudAssesID  != assessment.serverAssessmentId){
                        UserDefaults.standard.set(assessment.refrigeratorNote ?? "", forKey:"re_note")
                        UserDefaults.standard.set(assessment.serverAssessmentId ,forKey:"assIID")
                    }
                    let userDefault = UserDefaults.standard
                    userDefault.set(assessment.customerId, forKey: "PE_Selected_Customer_Id")
                    userDefault.set(assessment.customerName, forKey: "PE_Selected_Customer_Name")
                    userDefault.set(assessment.siteId, forKey: "PE_Selected_Site_Id")
                    userDefault.set(assessment.siteName, forKey: "PE_Selected_Site_Name")
                    if assessment.statusType == 2{
                        UserDefaults.standard.setValue(true, forKey: "isFromDraft")
                        UserDefaults.standard.synchronize()
                    }else{
                        UserDefaults.standard.setValue(false, forKey: "isFromDraft")
                        UserDefaults.standard.synchronize()
                    }
                    let delete  = CoreDataHandlerPE().deleteDraftAndMoveToSessionInProgress(assessment.draftNumber ?? 0)
                    if delete{
                        if self.anyCategoryContainValueOrNot(){
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
                            
                            if vc != nil{
                                vc!.navigationController?.navigationBar.isHidden = true
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        } else {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftStartNewAssessment") as? PEDraftStartNewAssessment
                            if vc != nil{
                                vc!.navigationController?.navigationBar.isHidden = true
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }
                    }
                }
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: PE_DraftIntCell.identifier) as? PE_DraftIntCell{
                cell.selectionStyle = .none
                cell.config(peNewAssessment:peAssessmentDraftArray[indexPath.row])
                cell.rejectIndicatorBtn.tag = indexPath.row
                cell.rejectIndicatorBtn.addTarget(self, action: #selector(addInfoPopup(sender:)), for: .touchUpInside)
                popFlagArray.append(false)
                cell.deleteCompletion  = {[unowned self] ( error) in
                    let assessment = self.peAssessmentDraftArray[indexPath.row]
                    var date = assessment.evaluationDate
                    date = date?.replacingOccurrences(of: "/", with: "")
                    
                    var siteId = String(assessment.siteId ?? 0)
                    
                    let draftID = assessment.draftID ?? ""
                    date = "C-" + draftID.prefix(20)
                    
                    
                    let errorMSg = "Are you sure you want to delete the assessment" + (date ?? "") + "?"
                    let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        _ in
                        CoreDataHandlerPE().deleteDraftByDrafyNumber(assessment.draftID ?? "")
                        CoreDataHandlerPE().deleteDraftByAssessmentId(assessment.draftID ?? "")
                        
                        CoreDataHandlerPE().deleteRefregratorDataByStartAssessment(assessment.serverAssessmentId ?? "")
                        CoreDataHandlerPE().deleteDraftedRefregratorDataByAssessmentId(assessment.draftID ?? "")
                        
                        PEDeletedDraftsDAO.sharedInstance.saveDeletedAssessmentsInfo(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "" , serverAssessmentId: assessment.serverAssessmentId ?? "")
                        PEInfoDAO.sharedInstance.deleteInfoObj(assessment.serverAssessmentId ?? "")
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.deleteExistingSanitationQues(assessment.serverAssessmentId ?? "")
                        
                        PEAssessmentsDAO.sharedInstance.updateAssessmentStatus(status:"Schedule",userId:UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: assessment.serverAssessmentId ?? "")
                        self.deleteDeletedAssessments()
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                cell.editCompletion  = {[unowned self] ( error) in
                    let assessment = self.peAssessmentDraftArray[indexPath.row]
                    let pervioudAssesID = UserDefaults.standard.value(forKey: "assIID") as? String ?? ""
                    if(pervioudAssesID  != assessment.serverAssessmentId){
                        UserDefaults.standard.set(assessment.refrigeratorNote ?? "", forKey:"re_note")
                        UserDefaults.standard.set(assessment.serverAssessmentId ,forKey:"assIID")
                    }
                    
                    UserDefaults.standard.set(assessment.serverAssessmentId ?? "", forKey: "currentServerAssessmentId")
                    
                    let userDefault = UserDefaults.standard
                    userDefault.set(assessment.customerId, forKey: "PE_Selected_Customer_Id")
                    userDefault.set(assessment.customerName, forKey: "PE_Selected_Customer_Name")
                    userDefault.set(assessment.siteId, forKey: "PE_Selected_Site_Id")
                    userDefault.set(assessment.siteName, forKey: "PE_Selected_Site_Name")
                    if assessment.statusType == 2{
                        UserDefaults.standard.setValue(true, forKey: "isFromDraft")
                        UserDefaults.standard.synchronize()
                    }else{
                        UserDefaults.standard.setValue(false, forKey: "isFromDraft")
                        UserDefaults.standard.synchronize()
                    }
                    let delete  = CoreDataHandlerPE().deleteDraftAndMoveToSessionInProgress(assessment.draftNumber ?? 0)
                    if delete{
                        if self.anyCategoryContainValueOrNot(){
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as? PEDraftAssesmentFinalize
                            if vc != nil{
                                vc!.navigationController?.navigationBar.isHidden = true
                                
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        } else {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftStartNewAssessment") as? PEDraftStartNewAssessment
                            if vc != nil{
                                vc!.navigationController?.navigationBar.isHidden = true
                                
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let NewcountryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        if regionID == 3{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEDraftHeader" ) as! PEDraftHeader
            return headerView
        }else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PEDraftIntHeader" ) as! PEDraftIntHeader
            return headerView
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 77.0
    }
    
    // MARK: Delete Deleted Assessments
    private func deleteDeletedAssessments(){
        if ConnectionManager.shared.hasConnectivity() {
            self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
            PEDataService.sharedInstance.deleteDeletedAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView());
                    return
                }
                self?.peAssessmentDraftArray = self?.getAllDateArrayStored() ?? [PENewAssessment]()
                self?.peAssessmentDraftArray = self?.peAssessmentDraftArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") } ?? []
                self?.tableview.tableFooterView = UIView()
                self?.tableview.reloadData()
                if self?.peAssessmentDraftArray.count ?? 0 < 1{
                    self?.tableview.isHidden = true
                }
                let mainQueue = OperationQueue.main
                mainQueue.addOperation{
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                }
            })
        }else{
            peAssessmentDraftArray = getAllDateArrayStored()
            peAssessmentDraftArray = peAssessmentDraftArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") }
            tableview.tableFooterView = UIView()
            tableview.reloadData()
            if peAssessmentDraftArray.count < 1{
                tableview.isHidden = true
            }
        }
    }
    
    // MARK: Add Info Popup
    @objc func addInfoPopup(sender: UIButton){
        loadPopupVw(index: sender.tag)
    }
    
    // MARK: Add Extended Info popup
    @objc func addExtendedInfoPopup(sender: UIButton)
    {
        loadEXMicroPopupVw(index: sender.tag)
    }
    
    // MARK: Load Info Popup
    private func loadPopupVw(index: Int){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
        vc.headerValue = "Rejection Comment"
        vc.textOfTextView = self.peAssessmentDraftArray[index].rejectionComment ?? ""
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    // MARK: Load Extended Micro Popup
    private func loadEXMicroPopupVw(index: Int){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
        vc.headerValue = "Extended Micro Rejection Comment"
        vc.textOfTextView = self.peAssessmentDraftArray[index].emRejectedComment ?? ""
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    // MARK: Check Any Category Contain Value or Not
    func anyCategoryContainValueOrNot() -> Bool{
        let peNewAssessmentInDB = CoreDataHandlerPE().getOnGoingDraftAssessmentArrayPEObject()
        if peNewAssessmentInDB.count > 1 {
            return true
        }
        return false
    }
        
    // MARK: DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
}

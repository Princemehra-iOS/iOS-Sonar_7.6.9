//
//  PEDraftViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability

class PESessionViewController: BaseViewController {
    
    var peHeaderViewController:PEHeaderViewController!
    var peAssessmentDraftArray : [PENewAssessment] = []
    var peAssessmentRejectedArray : [PENewAssessment] = []
    var pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(nil)
    var jsonRe : JSON = JSON()
    var popFlagArray: [Bool] = [Bool]()
    var isInfoVisible = false
    var regionID = Int()
    var sanitationQuesArr = [PE_ExtendedPEQuestion]()
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var customerGradientView: UIView!
    @IBOutlet weak var coustomerView: UIView!
    @IBOutlet weak var lblCustomer: PEFormLabel!
    @IBOutlet weak var lblSite: PEFormLabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var popupBackView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var closePopupBtn: UIButton!
    @IBOutlet weak var txtViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var idPopupView: UIView!
    @IBOutlet weak var assIdLabel: UILabel!
    let serverAssesIdStr = "serverAssessmentId = %@"
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        DispatchQueue.main.async {
            self.closePopupBtn.addTarget(self, action: #selector(self.closePopupBtnAction), for: .touchUpInside)
            self.coustomerView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setCornerRadiusFloat(radius: 24)
            self.customerGradientView.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
        }
        
        tableview.register(PE_SessionCell.nib, forCellReuseIdentifier: PE_SessionCell.identifier)
        
        let nibCatchers = UINib(nibName: "PESessionHeader", bundle: nil)
        tableview.register(nibCatchers, forHeaderFooterViewReuseIdentifier: "PESessionHeader")
        
        tableview.register(PE_SessionIntCell.nib, forCellReuseIdentifier: PE_SessionIntCell.identifier)
        
        let nibCatchers1 = UINib(nibName: "PESessionIntHeader", bundle: nil)
        tableview.register(nibCatchers1, forHeaderFooterViewReuseIdentifier: "PESessionIntHeader")
        
        if ConnectionManager.shared.hasConnectivity() {
            self.deleteDeletedAssessments()
        }else{
            if !Constants.isFromRejected{
                peHeaderViewController = PEHeaderViewController()
                peHeaderViewController.titleOfHeader = "View Assessments"
                headerView.addSubview(peHeaderViewController.view)
                topviewConstraint(vwTop: peHeaderViewController.view)
                peAssessmentDraftArray = getAllDateArrayStored()
                peAssessmentDraftArray = peAssessmentDraftArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") }
            }else{
                peHeaderViewController = PEHeaderViewController()
                peHeaderViewController.titleOfHeader = "Rejected Assessments"
                headerView.addSubview(peHeaderViewController.view)
                topviewConstraint(vwTop: peHeaderViewController.view)
                peAssessmentRejectedArray = getAllRejectedDateArrayStored()
                peAssessmentRejectedArray = peAssessmentRejectedArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") }
            }
            tableview.tableFooterView = UIView()
            tableview.reloadData()
            if peAssessmentDraftArray.count < 1 && peAssessmentRejectedArray.count < 1{
                tableview.isHidden = true
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let sortedArray = peAssessmentDraftArray.sorted {
            let evalDate1 = $0.evaluationDate ?? ""
            let evalDate2 = $1.evaluationDate ?? ""
            let evalDateObj1 = dateFormatter.date(from: evalDate1)
            let evalDateObj2 = dateFormatter.date(from: evalDate2)
            if evalDateObj1 != nil && evalDateObj2 != nil{
                return evalDateObj1! > evalDateObj2!
            }
            return false
        }
        peAssessmentDraftArray = sortedArray
        
        let PE_Selected_Customer_Name = UserDefaults.standard.string(forKey: "PE_Selected_Customer_Name") ?? ""
        let PE_Selected_Site_Name = UserDefaults.standard.string(forKey: "PE_Selected_Site_Name") ?? ""
        lblCustomer.text = PE_Selected_Customer_Name
        lblSite.text =  PE_Selected_Site_Name
    }
    // MARK: - Get Rejected Assessments
    private func getAllRejectedDateArrayStored() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        let drafts  = CoreDataHandlerPE().getRejectedAssessmentArrayPEObject(ofCurrentAssessment:false)
        var carColIdArray : [String] = []
        for obj in drafts {
            if !carColIdArray.contains(obj.serverAssessmentId ?? ""){
                carColIdArray.append(obj.serverAssessmentId ?? "")
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    // MARK: - Get All Data Array
    private func getAllDateArrayStored() -> [PENewAssessment]{
        var peAssessmentArray : [PENewAssessment] = []
        let drafts  = CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
        var carColIdArray : [String] = []
        for obj in drafts {
            print(obj.dataToSubmitID ?? "no id")
            if !carColIdArray.contains(obj.dataToSubmitID ?? ""){
                carColIdArray.append(obj.dataToSubmitID ?? "")
                peAssessmentArray.append(obj)
            }
        }
        return peAssessmentArray
    }
    // MARK: - Delete Deleated Assessments
    private func deleteDeletedAssessments(){
        if ConnectionManager.shared.hasConnectivity() {
            self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
            PEDataService.sharedInstance.deleteDeletedAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? Constants.noIdFoundStr, viewController: self, completion: { [weak self] (status, error) in
                guard let _ = self, error == nil else {
                    self?.dismissGlobalHUD(self?.view ?? UIView());
                    return
                }
                
                if !Constants.isFromRejected{
                    self?.peHeaderViewController = PEHeaderViewController()
                    self?.peHeaderViewController.titleOfHeader = "View Assessments"
                    self?.headerView.addSubview(self!.peHeaderViewController.view)
                    self?.topviewConstraint(vwTop: self?.peHeaderViewController.view ?? UIView())
                    self?.peAssessmentDraftArray = self?.getAllDateArrayStored() ?? []
                    self?.peAssessmentDraftArray = self?.peAssessmentDraftArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") } ?? []
                }else{
                    self?.peHeaderViewController = PEHeaderViewController()
                    self?.peHeaderViewController.titleOfHeader = "Rejected Assessments"
                    self?.headerView.addSubview(self?.peHeaderViewController.view ?? UIView())
                    self?.topviewConstraint(vwTop: self?.peHeaderViewController.view ?? UIView())
                    self?.peAssessmentRejectedArray = self?.getAllRejectedDateArrayStored() ?? []
                    self?.peAssessmentRejectedArray = self?.peAssessmentRejectedArray.sorted { ($0.evaluationDate ?? "") > ($1.evaluationDate ?? "") } ?? []
                }
                self?.tableview.tableFooterView = UIView()
                self?.tableview.reloadData()
                if self?.peAssessmentDraftArray.count ?? 0 < 1 && self?.peAssessmentRejectedArray.count ?? 0 < 1{
                    self?.tableview.isHidden = true
                }
                self?.dismissGlobalHUD(self?.view ?? UIView())
            })
        }else{
            print(appDelegateObj.testFuntion())
        }
    }
}
// MARK: - Extension & TableView Delegates
extension PESessionViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !Constants.isFromRejected{
            return peAssessmentDraftArray.count
        } else {
            return peAssessmentRejectedArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if regionID == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PE_SessionCell.identifier) as? PE_SessionCell {
                popFlagArray.append(false)
                if !Constants.isFromRejected {
                    cell.infoButton.isHidden = true
                    cell.editBtn.tag = indexPath.row
                    cell.editBtn.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
                    cell.config(peNewAssessment:peAssessmentDraftArray[indexPath.row], index: indexPath)
                } else {
                    cell.infoButton.isHidden = false
                    cell.infoButton.tag = indexPath.row
                    cell.emRejectedComentBtn.tag = indexPath.row
                    cell.infoButton.addTarget(self, action: #selector(addInfoPopup(sender:)), for: .touchUpInside)
                    cell.emRejectedComentBtn.addTarget(self, action: #selector(addExtendedInfoPopup(sender:)), for: .touchUpInside)
                    cell.config(peNewAssessment:peAssessmentRejectedArray[indexPath.row], index: indexPath)
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PE_SessionIntCell.identifier) as? PE_SessionIntCell{
                popFlagArray.append(false)
                if !Constants.isFromRejected{
                    cell.infoButton.isHidden = true
                    cell.config(peNewAssessment:peAssessmentDraftArray[indexPath.row], index: indexPath)
                }else{
                    cell.infoButton.isHidden = false
                    cell.infoButton.tag = indexPath.row
                    cell.infoButton.addTarget(self, action: #selector(addInfoPopup(sender:)), for: .touchUpInside)
                    cell.config(peNewAssessment:peAssessmentRejectedArray[indexPath.row], index: indexPath)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    // MARK: - Edit Button Action
    @objc func editPressed(_ sender: UIButton){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "PEViewAssesmentFinalize") as? PEViewAssesmentFinalize
        vc?.peNewAssessment = peAssessmentDraftArray[sender.tag]
        if peAssessmentDraftArray[sender.tag].evaluationID == 1{
            vc?.collectionviewIndexPath = IndexPath(row: 5, section: 0)
            
        } else {
            vc?.collectionviewIndexPath = IndexPath(row: 3, section: 0)
            
        }
        vc?.isFromEditMicro = true
        UserDefaults.standard.set(vc?.peNewAssessment.serverAssessmentId ?? "" , forKey: "currentServerAssessmentId")
        let userDefault = UserDefaults.standard
        
        userDefault.set(peAssessmentDraftArray[sender.tag].customerId, forKey: "PE_Selected_Customer_Id")
        userDefault.set(peAssessmentDraftArray[sender.tag].customerName, forKey: "PE_Selected_Customer_Name")
        userDefault.set(peAssessmentDraftArray[sender.tag].siteId, forKey: "PE_Selected_Site_Id")
        userDefault.set(peAssessmentDraftArray[sender.tag].siteName, forKey: "PE_Selected_Site_Name")
        
        if vc != nil{
            navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    fileprivate func handleRegion(indexPath:IndexPath) {
        if self.regionID == 3 {
            if self.peAssessmentRejectedArray[indexPath.row].isEMRejected == true && self.peAssessmentRejectedArray[indexPath.row].isPERejected == true {
                Constants.isAssessmentRejected = true
                self.moveAssessmentTodraft(index: indexPath.row)
            } else if self.peAssessmentRejectedArray[indexPath.row].isEMRejected == true && self.peAssessmentRejectedArray[indexPath.row].isPERejected == false {
                Constants.isAssessmentRejected = true
                self.movePEToDraft(index: indexPath.row)
            } else {
                self.moveAssessmentTodraft(index: indexPath.row)
            }
        } else {
            self.moveAssessmentTodraft(index: indexPath.row)
        }
    }
    
    fileprivate func handleYesAction(indexPath:IndexPath) {
        let rejectedCountIS = UserDefaults.standard.value(forKey: "rejectedCountIS") as? Int ?? 0
        if rejectedCountIS - 1  < 0 {
            UserDefaults.standard.setValue(0, forKey: "rejectedCountIS")
        } else {
            UserDefaults.standard.setValue(rejectedCountIS - 1, forKey: "rejectedCountIS")
        }
        
        UserDefaults.standard.set(self.peAssessmentRejectedArray[indexPath.row].serverAssessmentId , forKey: "currentServerAssessmentId")
        self.sanitationQuesArr = SanitationEmbrexQuestionMasterDAO.sharedInstance.fetchAssessmentSanitationQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId:  self.peAssessmentRejectedArray[indexPath.row].serverAssessmentId ?? "")
        self.handleRegion(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Constants.isFromRejected {
            
            if regionID == 3 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "PEViewStartNewAssessment") as? PEViewStartNewAssessment
                vc?.peNewAssessment = peAssessmentDraftArray[indexPath.row]
                vc?.editExtendedMicro = Constants.noStr
                UserDefaults.standard.set(vc?.peNewAssessment.serverAssessmentId ?? "" , forKey: "currentServerAssessmentId")
                let userDefault = UserDefaults.standard
                
                userDefault.set(peAssessmentDraftArray[indexPath.row].customerId, forKey: "PE_Selected_Customer_Id")
                userDefault.set(peAssessmentDraftArray[indexPath.row].customerName, forKey: "PE_Selected_Customer_Name")
                userDefault.set(peAssessmentDraftArray[indexPath.row].siteId, forKey: "PE_Selected_Site_Id")
                userDefault.set(peAssessmentDraftArray[indexPath.row].siteName, forKey: "PE_Selected_Site_Name")
                
                if vc != nil{
                    navigationController?.pushViewController(vc!, animated: true)
                }
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PEViewStartNewAssesmentINT") as? PEViewStartNewAssesmentINT
                vc?.peNewAssessment = peAssessmentDraftArray[indexPath.row]
                UserDefaults.standard.set(vc?.peNewAssessment.serverAssessmentId ?? "" , forKey: "currentServerAssessmentId")
                UserDefaults.standard.set(peAssessmentDraftArray[indexPath.row].refrigeratorNote ?? "", forKey:"re_note")
                UserDefaults.standard.set(peAssessmentDraftArray[indexPath.row].serverAssessmentId ,forKey:"assIID")
                let userDefault = UserDefaults.standard
                userDefault.set(peAssessmentDraftArray[indexPath.row].customerId, forKey: "PE_Selected_Customer_Id")
                userDefault.set(peAssessmentDraftArray[indexPath.row].customerName, forKey: "PE_Selected_Customer_Name")
                userDefault.set(peAssessmentDraftArray[indexPath.row].siteId, forKey: "PE_Selected_Site_Id")
                userDefault.set(peAssessmentDraftArray[indexPath.row].siteName, forKey: "PE_Selected_Site_Name")
                
                if vc != nil {
                    navigationController?.pushViewController(vc!, animated: true)
                }
            }
        } else {
            let errorMSg = "Are you sure you want to move assessment to draft?"
            let alertController = UIAlertController(title: "Move Assessment to Draft", message: errorMSg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                _ in
                self.handleYesAction(indexPath: indexPath)
            }
            let cancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.cancel)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Mve PE to Draft
    func movePEToDraft (index :Int)
    {
        let allAssesmentArr = CoreDataHandlerPE().getRejectedAssessmentArrayPEObject(ofCurrentAssessment:true)
        let draftNumber = getDraftCountFromDb()
        CoreDataHandlerPE().saveDraftPEInDB(newAssessmentArray: allAssesmentArr , draftNumber: draftNumber + 1, isfromRejected: true)
        
        if ConnectionManager.shared.hasConnectivity() {
            self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
            self.getRejectedAssessmentImagesListByUser(assId: self.peAssessmentRejectedArray[index].serverAssessmentId ?? "")
            self.peAssessmentRejectedArray.remove(at: index)
        }else{
            let predicate = NSPredicate(format:serverAssesIdStr, self.peAssessmentRejectedArray[index].serverAssessmentId ?? "")
            CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentRejected", predicate: predicate)
            self.peAssessmentRejectedArray.remove(at: index)
            self.tableview.reloadData()
            self.showDraftTost()
            self.navigationController?.popToViewController(ofClass: PEDraftViewController.self)
        }
        
    }
    
    fileprivate func saveRefrigeratorDataInDB(_ refrigtorArray: [PE_Refrigators], _ index: Int) {
        for refrii in refrigtorArray{
            if(CoreDataHandlerPE().checkSameAssesmentEntityExists(id: Int(refrii.id ?? 0),serverAssessmentId: Int(peAssessmentRejectedArray[index].serverAssessmentId ?? "0") ?? 0)){
                
                let updatedData = CoreDataHandlerPEModels.updateRefrigatorData(
                    id: Int(refrii.id ?? 0),
                    labelText: refrii.labelText ?? "",
                    rollOut: refrii.rollOut ?? "",
                    unit: refrii.unit ?? "",
                    value: refrii.value ?? 0.0,
                    catID: refrii.catID ?? 0,
                    isCheck: refrii.isCheck ?? false,
                    isNA: refrii.isNA ?? false,
                    serverAssessmentId: Int(self.peAssessmentRejectedArray[index].serverAssessmentId ?? "0") ?? 0
                )

                CoreDataHandlerPE().updateRefrigatorInDB(data: updatedData)
                
            } else {
                
                let refrigeratorData = CoreDataHandlerPEModels.refrigeratorData(
                    id: refrii.id ?? 0,
                      labelText: refrii.labelText ?? "",
                      rollOut: refrii.rollOut ?? "",
                      unit: refrii.unit ?? "",
                      value: refrii.value ?? 0.0,
                      catID: refrii.catID ?? 0,
                      isCheck: refrii.isCheck ?? false,
                      isNA: refrii.isNA ?? false,
                      schAssmentId: refrii.schAssmentId ?? 0
                )

                CoreDataHandlerPE().saveRefrigatorInDB(refrigeratorData: refrigeratorData)
                
            }
        }
    }
    
    func moveAssessmentTodraft(index: Int) {
        let allAssesmentArr = CoreDataHandlerPE().getRejectedAssessmentArrayPEObject(ofCurrentAssessment:true)
        
        let draftNumber = getDraftCountFromDb()
        CoreDataHandlerPE().saveDraftPEInDB(newAssessmentArray: allAssesmentArr , draftNumber: draftNumber + 1, isfromRejected: true)
        
        if regionID != 3 {
            var refrigtorArray = CoreDataHandlerPE().getRejectREfriData(id: Int(self.peAssessmentRejectedArray[index].serverAssessmentId ??  "0") ?? 0)
            if(refrigtorArray.count > 0) {
                for refrii in refrigtorArray {
                    if(CoreDataHandlerPE().checkDraftSameAssesmentEntityExists(id: Int(refrii.id ?? 0),serverAssessmentId: Int(self.peAssessmentRejectedArray[index].serverAssessmentId ??  "0") ?? 0)){
                        
                        let draftData = CoreDataHandlerPEModels.updateDraftRefrigeratorData(
                            id: Int(refrii.id ?? 0),
                             labelText: refrii.labelText ?? "",
                             rollOut: refrii.rollOut ?? "",
                             unit: refrii.unit ?? "",
                             value: refrii.value ?? 0.0,
                             catID: refrii.catID ?? 0,
                             isCheck: refrii.isCheck ?? false,
                             isNA: refrii.isNA ?? false,
                             serverAssessmentId: Int(self.peAssessmentRejectedArray[index].serverAssessmentId ?? "0") ?? 0
                        )

                        CoreDataHandlerPE().updateDraftRefrigatorInDB(draftData)
                        
                    } else {
                        
                        let draftData = CoreDataHandlerPEModels.RefrigatorDraftData(
                                id: refrii.id ?? 0,
                                labelText: refrii.labelText ?? "",
                                rollOut: refrii.rollOut ?? "",
                                unit: refrii.unit ?? "",
                                value: refrii.value ?? 0.0,
                                catID: refrii.catID ?? 0,
                                isCheck: refrii.isCheck ?? false,
                                isNA: refrii.isNA ?? false,
                                schAssmentId: refrii.schAssmentId ?? 0
                        )

                        CoreDataHandlerPE().saveDraftRefrigatorInDB(draftData)
                        
                    }
                }
            }
            
            refrigtorArray = CoreDataHandlerPE().getRejectREfriData(id: Int(peAssessmentRejectedArray[index].serverAssessmentId ?? "0") ?? 0)
            if(refrigtorArray.count > 0) {
                saveRefrigeratorDataInDB(refrigtorArray, index)
            }
            let predicate = NSPredicate(format:"schAssmentId = %@", self.peAssessmentRejectedArray[index].serverAssessmentId ?? "")
            CoreDataHandlerPE().deleteExisitingData(entityName: "PE_Refrigator_Rejected", predicate: predicate)
            
        }
        if ConnectionManager.shared.hasConnectivity() {
            self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
            self.getRejectedAssessmentImagesListByUser(assId: self.peAssessmentRejectedArray[index].serverAssessmentId ?? "")
            self.peAssessmentRejectedArray.remove(at: index)
        } else {
            let predicate = NSPredicate(format:serverAssesIdStr, self.peAssessmentRejectedArray[index].serverAssessmentId ?? "")
            CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentRejected", predicate: predicate)
            self.peAssessmentRejectedArray.remove(at: index)
            self.tableview.reloadData()
            self.showDraftTost()
            self.navigationController?.popToViewController(ofClass: PEDraftViewController.self)
        }
    }
    
    func showDraftTost() {
        self.showtoast(message: "Assessment moved to draft")
    }
    
    // MARK: - Convert JSON String to Dict
    func convertToDictionary(text: String) -> JSON! {
        if let data = text.data(using: .utf8) {
            return self.getJSONFrom(Data: data)
        }
        return nil
    }
    
    func getJSONFrom(Data data: Data) -> JSON? {
        do {
            return try JSON(data: data, options: .mutableContainers)
        } catch _ {
            return nil
        }
    }
    

    // MARK: - Get Images Count
    func getImageCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "imageId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK: - Change Data Format
    func convertDateFormat(inputDate: String) -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = appDelegateObj.mmddyyStr
        
        let oldDate = olDateFormatter.date(from: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = Constants.yyyyMMddStr
        
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }
        return ""
    }
    // MARK: - Dismiss Loader
    func dismissHUD(){
        let mainQueue = OperationQueue.main
        mainQueue.addOperation{
            self.dismissGlobalHUD(self.view)
        }
    }

    // MARK: - Filter Category Count
    func filterCategoryCount(peNewAssessmentOf:PENewAssessment) -> Int {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessmentOf.evaluationID == object.evaluationID{
                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
        return pECategoriesAssesmentsResponse.peCategoryArray.count
    }
    
    // MARK: - Get DOA Count In PE
    func getDOACountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DayOfAge")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "doaId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    // MARK: - Get Vaccine Mixture
    func getVMixerCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VMixer")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "vmid") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0) {
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }

    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.yyyyMMddHHmmss//this your string date format
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC") //TimeZone(name: "UTC") //as TimeZone
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            return ""
        }
        
        dateFormatter.dateFormat = Constants.MMddyyyyStr///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC") //NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate ?? Date())
        
        return timeStamp
    }

    // MARK: - Finish & Clean Session
    func finishSession()  {
        cleanSession()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboardPE"),object: nil))
    }
    // MARK: - Get Draft Data Count
    func getDraftCountFromDb() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftID") as? NSArray ?? []
        var carColIdArray : [String] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? String ?? ""){
                carColIdArray.append(obj as? String ?? "")
            }
        }
        return carColIdArray.count
    }
    // MARK: - Clean Session
    private func cleanSession() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateComplexOnDashboard"),object: nil))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        showtoast(message: "In Dev")
    }
    // MARK: - Add Info Pop Up
    @objc func addInfoPopup(sender: UIButton){
        loadPopupVw(index: sender.tag)
    }
    // MARK: - Extended Micro Pop Up
    @objc func addExtendedInfoPopup(sender: UIButton)
    {
        loadExtendedPopupVw(index: sender.tag)
    }
    // MARK: - Close PopUp
    @objc func closePopupBtnAction(){
        hidePopup()
    }
    // MARK: - DROP DOWN HIDDEN AND SHOW
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    // MARK: - Load Pop Up View
    private func loadPopupVw(index: Int){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
        vc.headerValue = "Rejection Comment"
        vc.textOfTextView = peAssessmentRejectedArray[index].rejectionComment ?? ""
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    // MARK: - Load Extended Pop UP View
    private func loadExtendedPopupVw(index: Int){
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommentPopupViewController") as! CommentPopupViewController
        vc.headerValue = "Extended Micro Rejection Comment"
        //        vc.titleValue = "Comment"
        vc.textOfTextView = peAssessmentRejectedArray[index].emRejectedComment ?? ""
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    // MARK: - Hide Popup View
    private func hidePopup(){
        popupBackView.isHidden = true
        popupView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if regionID == 3 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PESessionHeader") as! PESessionHeader
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PESessionIntHeader") as! PESessionIntHeader
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 77.0
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.adjustUITextViewHeight()
    }
    
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension PESessionViewController {
    // MARK: - Get rejected Assessments Images
    private func getRejectedAssessmentImagesListByUser(assId: String) {
        let param = ["assessmentId":assId] as JSONDictionary
        ZoetisWebServices.shared.getRejectedAssessmentImagesListByUser(controller: self, parameters: param, completion: { [weak self] (json, error) in
            guard let _ = self, error == nil else {
                self?.dismissGlobalHUD(self?.view ?? UIView())
                return
            }
            let mainQueue = OperationQueue.main
            mainQueue.addOperation {
                self?.handlGetRejectedAssessmentImagesListByUser(json, assId)
            }
        })
    }
    
    // MARK: - Handle Rejected Assessments Images List
    private func handlGetRejectedAssessmentImagesListByUser(_ json: JSON, _ assId: String) {
        var dataDic : [String:Any] = [:]
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        
        let dataArray = dataDic["Data"] as? [Any] ?? []
        
        for obj in dataArray {
            DispatchQueue.main.async {
                let objDic = obj as? [String:Any] ?? [:]
                let base64Encoded = objDic["ImageBase64"] as? String ?? ""
                let DisplayId = objDic["DisplayId"] as? String ?? ""
                let UserId = objDic["UserId"] as? Int ?? 0
                let Assessment_Id = objDic["Assessment_Id"] as? Int ?? 0
                let Module_Assessment_Categories_Id = objDic["Module_Assessment_Categories_Id"] as? Int ?? 0
                let decodedData = Data(base64Encoded: base64Encoded) ?? Data()
                let AppCreationTime = DisplayId.replacingOccurrences(of: "C-", with: "")
                let imageCount = self.getImageCountInPEModule()
                CoreDataHandlerPE().saveImageInGetApi(imageId:imageCount+1,imageData:decodedData)
                CoreDataHandlerPE().saveImageIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:AppCreationTime)
                CoreDataHandlerPE().saveImageOngoingDraftIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:AppCreationTime)
                CoreDataHandlerPE().saveImageDraftIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:AppCreationTime)
            }
        }
        let predicate = NSPredicate(format:serverAssesIdStr, assId )
        CoreDataHandlerPE().deleteExisitingData(entityName: "PE_AssessmentRejected", predicate: predicate)
        
        self.tableview.reloadData()
        self.showDraftTost()
        self.navigationController?.popToViewController(ofClass: PEDraftViewController.self)
        self.dismissGlobalHUD(self.view ?? UIView())
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}

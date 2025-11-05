//
//  PEScheduleVC.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 20/11/20.
//

import UIKit

class PEScheduleVC: BaseViewController {
    
    @IBOutlet weak var headerView: UIView!
    var peHeaderViewController:PEHeaderViewController!
    @IBOutlet weak var scheduleTblVw: UITableView!
    
    var scheduledAssessmentsArr = [PENewAssessment]()
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Scheduled Assessments"
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
        
        scheduleTblVw.register(VaccinationCertificationsTableViewCell.nib, forCellReuseIdentifier: VaccinationCertificationsTableViewCell.identifier)
        
        let nibPlateInfoHeader = UINib(nibName: "PE_ScheduleHeader", bundle: nil)
        scheduleTblVw.register(nibPlateInfoHeader, forHeaderFooterViewReuseIdentifier: "PE_ScheduleHeader")
        
        let nibPlateInfoHeader1 = UINib(nibName: "PE_ScheduleIntHeader", bundle: nil)
        scheduleTblVw.register(nibPlateInfoHeader1, forHeaderFooterViewReuseIdentifier: "PE_ScheduleIntHeader")
        
        scheduledAssessmentsArr = PEAssessmentsDAO.sharedInstance.getVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        if scheduledAssessmentsArr.count > 0{
            DispatchQueue.main.async {
                self.scheduleTblVw.reloadData()
            }
        }else{
            self.scheduleTblVw.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scheduledAssessmentsArr = PEAssessmentsDAO.sharedInstance.getVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "")
        if scheduledAssessmentsArr.count > 0{
            DispatchQueue.main.async {
                self.scheduleTblVw.reloadData()
            }
        }else{
            self.scheduleTblVw.isHidden = true
        }
    }    
}

extension PEScheduleVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledAssessmentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VaccinationCertificationsTableViewCell.identifier, for: indexPath) as? VaccinationCertificationsTableViewCell{
            cell.removeBtnVw()
            if scheduledAssessmentsArr.count > 0 && indexPath.row < scheduledAssessmentsArr.count{
                cell.setPEValues(vaccinationCertificatonObj:scheduledAssessmentsArr[indexPath.row] )
                if scheduledAssessmentsArr.count - 1 == indexPath.row{
                    cell.layer.masksToBounds = true
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 18.5)
                } else {
                    cell.contentView.roundVsCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let regionId = UserDefaults.standard.integer(forKey: "Regionid")
        if regionId == 3 {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PE_ScheduleHeader" ) as! PE_ScheduleHeader
            return headerView
        }else{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PE_ScheduleIntHeader" ) as! PE_ScheduleIntHeader
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    fileprivate func navigateToDraftAssessmentFinalize(_ assessment: PENewAssessment, _ assessmentId: String) {
        let delete  = CoreDataHandlerPE().deleteDraftAndMoveToSessionInProgress(assessment.draftNumber!)
        if delete{
            if self.anyCategoryContainValueOrNot(serverAssessmentId:assessmentId){
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftAssesmentFinalize") as! PEDraftAssesmentFinalize
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PEDraftStartNewAssessment") as! PEDraftStartNewAssessment
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if scheduledAssessmentsArr.count > 0 && scheduledAssessmentsArr.count > indexPath.row, let assessmentId = scheduledAssessmentsArr[indexPath.row].serverAssessmentId {
            UserDefaults.standard.set(assessmentId , forKey: "currentServerAssessmentId")
            let userDefault = UserDefaults.standard
            userDefault.set(scheduledAssessmentsArr[indexPath.row].customerId, forKey: "PE_Selected_Customer_Id")
            userDefault.set(scheduledAssessmentsArr[indexPath.row].customerName, forKey: "PE_Selected_Customer_Name")
            userDefault.set(scheduledAssessmentsArr[indexPath.row].siteId, forKey: "PE_Selected_Site_Id")
            userDefault.set(scheduledAssessmentsArr[indexPath.row].siteName, forKey: "PE_Selected_Site_Name")
            
            if let assessment = PEAssessmentsDAO.sharedInstance.getDraftAssessment(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", serverAssessmentId: assessmentId){
                
                navigateToDraftAssessmentFinalize(assessment, assessmentId)
            } else {
                
                if anyCategoryContainValueOrNot(serverAssessmentId: assessmentId){
                    let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "PEAssesmentFinalize") as! PEAssesmentFinalize
                    vc.scheduledAssessment = scheduledAssessmentsArr[indexPath.row]
                    vc.scheduledAssessment?.scheduledDate = Date()
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let regionID = UserDefaults.standard.integer(forKey: "Regionid")
                    if regionID == 3 {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "PEStartNewAssessment") as! PEStartNewAssessment
                        vc.scheduledAssessment = scheduledAssessmentsArr[indexPath.row]
                        vc.scheduledAssessment?.scheduledDate = Date()
                        navigationController?.pushViewController(vc, animated: true)
                    } else {
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "PEStartNewAssessmentINT") as! PEStartNewAssessmentINT
                        vc.scheduledAssessment = scheduledAssessmentsArr[indexPath.row]
                        vc.scheduledAssessment?.scheduledDate = Date()
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func anyCategoryContainValueOrNot(serverAssessmentId:String) -> Bool{
        let peNewAssessmentInDB = CoreDataHandlerPE().getOnGoingAssessmentArrayPEObject(serverAssessmentId: serverAssessmentId ?? "")
        if peNewAssessmentInDB.count > 1 {
            return true
        }
        return false
    }
}

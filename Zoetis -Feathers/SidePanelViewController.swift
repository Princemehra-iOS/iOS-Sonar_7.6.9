

//
//  SidePanelViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 07/01/20.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    var menuArr: Array<MenuInformation>!
    var arrayMenuOptions = [Dictionary<String,String>]()
    let globaclDashboarStr = "Global Dashboard"
    
    enum CellIdentifiers {
        static let MenuInfoCell = "MenuInfoCell"
        
    }
    
    func updateArrayMenuOptionsForMicrobial(){
        arrayMenuOptions.append(["title":globaclDashboarStr, "icon":"appsIconPE"])
        arrayMenuOptions.append(["title":"Dashboard", "icon":"dashboardIconPE"])
        arrayMenuOptions.append(["title":"Help", "icon":"helpIconPE"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutIconPE"])
        tableView.reloadData()
    }
    
    func updateArrayMenuOptionsForPVE(){
        arrayMenuOptions.append(["title":globaclDashboarStr, "icon":"appsIconPE"])
        arrayMenuOptions.append(["title":"PVE \nDashboard", "icon":"dashboardIconPE"])
        arrayMenuOptions.append(["title":"Start New Assessment", "icon":"startAssessmentIconPE"])
        arrayMenuOptions.append(["title":"View Assessment", "icon":"viewAssessmentIconPE"])
       // arrayMenuOptions.append(["title":"Reports", "icon":"reportsIconPE"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutIconPE"])
        tableView.reloadData()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":globaclDashboarStr, "icon":"appsIconPE"])
        arrayMenuOptions.append(["title":"PE Dashboard", "icon":"dashboardIconPE"])
        arrayMenuOptions.append(["title":"View  Assessment", "icon":"viewAssessmentIconPE"])
        arrayMenuOptions.append(["title":"Scheduled Assessments", "icon":"startAssessmentIconPE"])
        arrayMenuOptions.append(["title":"Training & Education", "icon":"trainingSidemenuIconPE"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutIconPE"])
        tableView.reloadData()
    }
    
    func updateArrayMenuOptionsMBL(){
        arrayMenuOptions.append(["title":globaclDashboarStr, "icon":"appsIconPE"])
        arrayMenuOptions.append(["title":"Microbial Dashboard", "icon":"dashboardIconPE"])
        arrayMenuOptions.append(["title":"New Requisition", "icon":"startAssessmentIconPE"])
        arrayMenuOptions.append(["title":"View Requisition", "icon":"viewAssessmentIconPE"])
       // arrayMenuOptions.append(["title":"Help", "icon":"helpIconPE"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutIconPE"])
        tableView.reloadData()
    }
    
    func updateArrayMenuOptionsVaccination(){
        arrayMenuOptions.append(["title":globaclDashboarStr, "icon":"appsIconPE"])
        arrayMenuOptions.append(["title":"Dashboard", "icon":"dashboardIconPE"])
        arrayMenuOptions.append(["title":"View Training & Certification", "icon":"reportsIconPE"])
        arrayMenuOptions.append(["title":"Drafts", "icon":"draftIconPE"])
        arrayMenuOptions.append(["title":"Logout", "icon":"logoutIconPE"])
        tableView.reloadData()
    }
    
    func updateArrayMenuOptionsFlockHealth(){
        self.tableView.backgroundColor = UIColor(displayP3Red: 62/255, green: 62/255, blue: 62/255, alpha: 1.0)
        self.tableView.separatorStyle = .none
        arrayMenuOptions.append(["title":NSLocalizedString(globaclDashboarStr, comment: ""), "icon":"appPvGlobalashboard"])
        arrayMenuOptions.append(["title":NSLocalizedString("Language", comment: ""), "icon":"languageIcon"])
        arrayMenuOptions.append(["title":NSLocalizedString("Poultry Health Monitoring", comment: ""), "icon":"slider_dashboard"])
        arrayMenuOptions.append(["title": NSLocalizedString("Start New Session", comment: "") , "icon":"slider_start_new_session"])
        arrayMenuOptions.append(["title": NSLocalizedString("Open Existing Session", comment: "") , "icon":"slider_open_existing"])
        arrayMenuOptions.append(["title": NSLocalizedString("Training & Education", comment: ""), "icon":"slider_training"])
        arrayMenuOptions.append(["title":NSLocalizedString("Reports", comment: "") , "icon":"slider_reports"])
        arrayMenuOptions.append(["title": NSLocalizedString("Help", comment: "") , "icon":"slider_help"])
        arrayMenuOptions.append(["title": NSLocalizedString("Settings", comment: "") , "icon":"slider_setings"])
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        let userType =   UserDefaults.standard.string(forKey:"userType")        
        
        if userType == "PE" {// For PE
            updateArrayMenuOptions()
        }else if userType == "PVE"{
            updateArrayMenuOptionsForPVE()
        }else if userType == "Microbial"{
            updateArrayMenuOptionsMBL()
        }else if userType == "FlockHealth"{
            updateArrayMenuOptionsFlockHealth()
        }else if userType == "Vaccination"{
            updateArrayMenuOptionsVaccination()
        }
        
        tableView.separatorColor = UIColor.black
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        NotificationCenter.default.addObserver(self,selector: #selector(logoutClickedNoti), name: NSNotification.Name("LogoutClicked"),object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 238.0/255, green: 247.0/255, blue: 1.0, alpha: 1.0).cgColor, UIColor(red: 207.0/255, green: 225.0/255, blue: 242.0/255, alpha: 1.0).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    @objc private func logoutClickedNoti(notification: NSNotification){
        let errorMSg = Constants.areYouSureToLogoutStr
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            
            UserDefaults.standard.removeObject(forKey: "login")
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) 
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}

// MARK: Table View Data Source
extension SidePanelViewController: UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userType =   UserDefaults.standard.string(forKey:"userType")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuInfoCell
        cell.bottomLineLbl.isHidden = (userType == "FlockHealth")
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        cell.backgroundColor = .clear
        if arrayMenuOptions.count - 1 == indexPath.row {
            cell.bottomLineLbl.isHidden = true
        }
        
        if (userType == "FlockHealth") {
            lblTitle.textColor = .white
            lblTitle.font = lblTitle.font.withSize(14.5)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let arr = arrayMenuOptions[indexPath.row]
        delegate?.didSelectLeftPenal(indexPath.row, selectedDetails: arr)
        if indexPath.row == 5 {
            print("Test Body")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}

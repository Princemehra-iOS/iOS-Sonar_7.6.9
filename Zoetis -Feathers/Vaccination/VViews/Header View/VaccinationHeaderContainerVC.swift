//
//  PEHeaderViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 25/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SwiftyJSON

class VaccinationHeaderContainerVC: BaseViewController {
    
    // MARK: - OUTLETS

    @IBOutlet weak var onGoingSessionView: UIView!
    @IBOutlet weak var syncView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelFirstname: UILabel!
    @IBOutlet weak var labelSyncCount: UILabel!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var labelCountBackgroundVw: UIImageView!
    @IBOutlet weak var killSessionBtn: UIButton!
    
    // MARK: - VARIABLES

    var titleOfHeader: String = "0"
    var titleofSync: String = ""
    var showSession : Bool = false
    var isVaccinationModule = false
    var hasVaccinationSynced = false
    
    // MARK: - INIT METHODS

    init(){
        super.init(nibName:"VaccinationHeaderContainerVC", bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        syncView.isHidden = true
        onGoingSessionView.isHidden = true
        if (titleOfHeader == "Process Evaluation" || titleOfHeader
            == "Training & Certification") {
            syncView.isHidden = false
            onGoingSessionView.isHidden = false
        }
        if titleofSync == "0"{
            labelSyncCount.isHidden = true
            labelCountBackgroundVw.isHidden = true
        }else{
            labelSyncCount.isHidden = false
            labelCountBackgroundVw.isHidden = false
        }
        if showSession {
            killSessionBtn.isHidden = false
        }else{
            killSessionBtn.isHidden = true
        }
        labelTitle.text = titleOfHeader
        labelSyncCount.text = titleofSync
        labelFirstname.text = String(UserDefaults.standard.value(forKey: "FirstName") as? String ?? "") + " " + String(UserDefaults.standard.value(forKey: "LastName") as? String ?? "")
        if showSession {
            onGoingSessionView.isHidden = false
        } else {
            onGoingSessionView.isHidden = true
        }
    }
    
    func finishSession()  {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ClearSafetyCertifications"),object: nil))
    }
    
    // MARK: - IBACTIONS

    @IBAction func menuButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
        
    }
    
    @IBAction func clickToKillSession(_ sender: Any) {
        let errorMSg =  "Are you sure you want to reset safety certification data?"
        let alertController = UIAlertController(title: "Clear Session", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            
            self.finishSession()
        }
        let cancelAction = UIAlertAction(title: Constants.noStr, style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        let errorMSg = Constants.areYouSureToLogoutStr
        let alertController = UIAlertController(title: "Alert", message: errorMSg as? String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "LogoutClicked"),object: nil))
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func syncBtnClicked(_ sender: Any) {
        if titleOfHeader == "Training & Certification"{
            hasVaccinationSynced = true
            NotificationCenter.default.post(name: NSNotification.Name("SubmitVaccinationCertifications"), object: nil, userInfo: nil)
        } else{
            NotificationCenter.default.post(name: NSNotification.Name("NavToSession"), object: nil, userInfo: nil)
        }
    }
}

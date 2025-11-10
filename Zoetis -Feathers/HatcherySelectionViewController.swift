//
//  HatcherySelectionViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 04/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class HatcherySelectionViewController: BaseViewController {
     
     @IBOutlet weak var hatcheryButton: UIButton!
     @IBOutlet weak var breederButton: UIButton!
     @IBOutlet weak var growoutButton: UIButton!
     @IBOutlet weak var processEvalBtn: UIButton!
     @IBOutlet weak var vaccinationButton: UIButton!
     @IBOutlet weak var footerView: UIView!
     @IBOutlet weak var labelPE: UILabel!
     @IBOutlet weak var btnMicrobial: UIButton!
     @IBOutlet weak var labelMicrobial: UILabel!
    @IBOutlet weak var labelVaccination: UILabel!
     let vesionStr = "Version "
     @IBOutlet weak var lblVersionName: UILabel!
     
    var regionID = Int()
     var bottomViewController:BottomViewController!
     var path: UIBezierPath!
     
     override func viewDidLoad() {
        print("<<<<",self)
          super.viewDidLoad()
          self.navigationItem.setHidesBackButton(true, animated: true)
          regionID = UserDefaults.standard.integer(forKey: "Regionid")
          UserContext.sharedInstance.setUserDetailsObjFromDB()
          setupHeader()
          processEvalBtn.alpha = 0.3
          labelPE.alpha = 0.3
          processEvalBtn.isUserInteractionEnabled = false
          btnMicrobial.alpha = 0.3
          labelMicrobial.alpha = 0.3
          btnMicrobial.isUserInteractionEnabled = false
          vaccinationButton.alpha = 0.3
          labelVaccination.alpha = 0.3
          vaccinationButton.isUserInteractionEnabled = false
          var liveAlbums = 3
          let environmentIs = Constants.Api.versionUrl
         
          if environmentIs.contains("stageapi") {
              liveAlbums = 0
          } else if environmentIs.contains("devapi") {
              liveAlbums = 1
          } else if environmentIs.contains("supportapi") {
              liveAlbums = 2
          } else {
              liveAlbums = 3
          }
          
          switch liveAlbums {
          case 0:
               lblVersionName.text = vesionStr + Bundle.main.versionNumber + " (UAT)"

          case 1:
               lblVersionName.text = vesionStr + Bundle.main.versionNumber + " (Dev)"

          case 2:
               lblVersionName.text = vesionStr + Bundle.main.versionNumber + " (Dev Support)"
              
          case 3:
               lblVersionName.text = vesionStr + Bundle.main.versionNumber

          default:
               lblVersionName.text = vesionStr + Bundle.main.versionNumber
          }
          
          let ModuleIdsArray =   UserDefaults.standard.string(forKey:"ModuleIdsArray")
          let arr = ModuleIdsArray?.components(separatedBy: "~")
          if (arr?.contains("18") ?? false) {
               processEvalBtn.alpha = 1
               labelPE.alpha = 1
               processEvalBtn.isUserInteractionEnabled = true
               vaccinationButton.alpha = 1
               labelVaccination.alpha = 1
               vaccinationButton.isUserInteractionEnabled = true
               
          }
          if (arr?.contains("21") ?? false) {
               btnMicrobial.alpha = 1
               labelMicrobial.alpha = 1
               btnMicrobial.isUserInteractionEnabled = true
          }
          if (arr?.contains("26") ?? false) {
               vaccinationButton.alpha = 1
               labelVaccination.alpha = 1
               vaccinationButton.isUserInteractionEnabled = true
          }
          if( regionID != 3){
               vaccinationButton.alpha = 0.3
               labelVaccination.alpha = 0.3
               vaccinationButton.isUserInteractionEnabled = false
          }
     }
     
     override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.setValue(true, forKey: "OnGlobalFromPE")
     }
     
     private func setupHeader() {
          bottomViewController = BottomViewController()
          self.footerView.addSubview(bottomViewController.view)
          self.topviewConstraint(vwTop: bottomViewController.view)
     }
     
     // MARK: IBActions
     // MARK:  ********** Breeder Button Action**************************************/
     @IBAction func clickedBreeder(_ sender: Any) {
          transitionAnimationPVE(view: breederButton, animationOptions: .transitionCrossDissolve, isReset: true)
     }
     // MARK:  **********Hatchery Button Action **************************************/
     @IBAction func clickedHatchery(_ sender: Any) {
          transitionAnimationPE(view: hatcheryButton, animationOptions: .transitionCrossDissolve, isReset: true)
          
     }
     // MARK:  ********** Flock Health Button Action**************************************/
     @IBAction func clickedGrowout(_ sender: Any) {
          self.navigateToGrownoutSelectionPE()
     }
     
     @IBAction func clickedVaccinationBtn(_ sender: Any) {
          let ModuleIdsArray =   UserDefaults.standard.string(forKey:"ModuleIdsArray")
          
          let arr = ModuleIdsArray?.components(separatedBy: "~")
          if (arr?.contains("18") ?? false) {
               self.showGlobalProgressHUDWithTitle(self.view, title: "")

               self.dismissGlobalHUD(self.view)
               Constants.baseUrl = Constants.Api.tcBaseUrl
               self.navigateToVaccinationAndCertification()
          }
     }
     
     // MARK:  ********** Microbial Button Clicked **************************************/
     @IBAction func microbialClicked(_ sender: Any) {
          Constants.baseUrl = Constants.Api.miBaseUrl
          navigateToMicrobial()
     }
     // MARK:  ********** PE BUtton Clicked**************************************/
     @IBAction func processEvalBtnClicked(_ sender: Any) {
          Constants.baseUrl = Constants.Api.peBaseUrl
          self.navigateToPEDashboard()
     }
     
     func transitionAnimationPE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
          self.navigateToModuleSelectionPE()
     }
     
     func transitionAnimationPVE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
          self.navigateToModuleSelectionPVE()
     }
     // MARK:  ********** Navigate to Tranning And Certification Module **************************************/
     private func navigateToVaccinationAndCertification(){
          UserDefaults.standard.set("Vaccination", forKey: "userType")
          let vc = UIStoryboard.init(name: Constants.Storyboard.VACCINATIONCERTIFICATION, bundle: Bundle.main).instantiateViewController(withIdentifier: "VaccinationDashboardVC") as? VaccinationDashboardVC
          self.navigationController?.pushViewController(vc!, animated: false)
     }
     // MARK:  ********** Navigate to Module Selection for PE**************************************/
     private func navigateToModuleSelectionPE() {
          let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "HatcherySelectionViewController") as? HatcherySelectionViewController
          self.navigationController?.pushViewController(vc!, animated: false)
     }
     private func navigateToPEDashboard() {
          
          self.showGlobalProgressHUDWithTitle(self.view, title: "")
          UserDefaults.standard.set("PE", forKey: "userType")
          let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
          let keychainHelper = AccessTokenHelper()
          let FCMToken = keychainHelper.getFromKeychain(keyed: "Token")
          let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String ?? ""
          let param = ["UserId":userID,"ModuleId":18,"FCMToken":FCMToken,"DeviceId":udid] as JSONDictionary
          ZoetisWebServices.shared.sendFCMTokenDataToServer(controller: self, parameters: param, completion: {(json, error) in
               print(json)
          })
          self.dismissGlobalHUD(self.view)
          let vc = UIStoryboard.init(name: Constants.Storyboard.peStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PEDashboardViewController") as? PEDashboardViewController
          self.navigationController?.pushViewController(vc!, animated: true)
          
     }
     // MARK:  ********** Navigate to Module Selection for PVE**************************************/
     private func navigateToModuleSelectionPVE(){
          let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "PulletSelectionViewController") as? PulletSelectionViewController
          self.navigationController?.pushViewController(vc!, animated: false)
     }
     // MARK:  ********** Navigate to Flock health Module **************************************/
     private func navigateToGrownoutSelectionPE(){
          let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GrownoutSelectionViewController") as? GrownoutSelectionViewController
          self.navigationController?.pushViewController(vc!, animated: false)
     }
     // MARK:  ********** Navigate to Microbial Module **************************************/
     private func navigateToMicrobial(){
          
          self.showGlobalProgressHUDWithTitle(self.view, title: "")
          UserDefaults.standard.set("Microbial", forKey: "userType")
          let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
          let keychainHelper = AccessTokenHelper()
          let FCMToken = keychainHelper.getFromKeychain(keyed: "Token")
          let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String ?? ""
          let param = ["UserId":userID,"ModuleId":21,"FCMToken":FCMToken,"DeviceId":udid] as JSONDictionary
          ZoetisWebServices.shared.sendFCMTokenDataToServer(controller: self, parameters: param, completion: { (json, error) in
               print(json)
          })
          self.dismissGlobalHUD(self.view)
          UserDefaults.standard.set("Microbial", forKey: "userType")
          let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
          self.navigationController?.pushViewController(vc!, animated: false)
     }
}

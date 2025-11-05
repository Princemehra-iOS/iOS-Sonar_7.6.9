//
//  HatcherySelectionViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 04/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class GrownoutSelectionViewController: BaseViewController {
    
    @IBOutlet weak var hatcheryButton: UIButton!
    @IBOutlet weak var breederButton: UIButton!
    @IBOutlet weak var growoutButton: UIButton!
    @IBOutlet weak var processEvalBtn: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var labelPE: UILabel!
    @IBOutlet weak var btnMicrobial: UIButton!
    @IBOutlet weak var labelMicrobial: UILabel!
    let versionStr = "Version "
    var bottomViewController:BottomViewController!
    var path: UIBezierPath!
    
    @IBOutlet weak var lblVersion: UILabel!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupHeader()
        let ModuleIdsArray = UserDefaults.standard.string(forKey:"ModuleIdsArray")
        let arr = ModuleIdsArray?.components(separatedBy: "~")

        processEvalBtn.alpha = 0.3
        labelPE.alpha = 0.3
        processEvalBtn.isUserInteractionEnabled = false
        
        if (arr?.contains("1") ?? false) {
            processEvalBtn.alpha = 1
            labelPE.alpha = 1
            processEvalBtn.isUserInteractionEnabled = true
        }
        if (arr?.contains("2") ?? false) {
            processEvalBtn.alpha = 1
            labelPE.alpha = 1
            processEvalBtn.isUserInteractionEnabled = true
        }
        
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
            lblVersion.text = versionStr + Bundle.main.versionNumber + " (UAT)"

        case 1:
            lblVersion.text = versionStr + Bundle.main.versionNumber + " (Dev)"

        case 2:
            lblVersion.text = versionStr + Bundle.main.versionNumber + " (Dev Support)"
            
        case 3:
            lblVersion.text = versionStr + Bundle.main.versionNumber

        default:
            lblVersion.text = versionStr + Bundle.main.versionNumber
        }        
      
    }
    private func setupHeader() {
        bottomViewController = BottomViewController()
        self.footerView.addSubview(bottomViewController.view)
        self.topviewConstraint(vwTop: bottomViewController.view)
    }
    
    // MARK: IBActions
    
    @IBAction func clickedBreeder(_ sender: Any) {
        self.navigateToModuleSelectionPVE()
    }
    
    @IBAction func clickedHatchery(_ sender: Any) {
        self.navigateToModuleSelectionPE()
        
    }
    @IBAction func clickedGrowout(_ sender: Any) {
        print("clickedGrowout")
    }
    
    @IBAction func microbialClicked(_ sender: Any) {
        let RoleId =  UserDefaults.standard.string(forKey: "RoleId")
        if RoleId != "TSR",
           RoleId != "FSR" {
            navigateToMicrobial()
        }
    }
    
    @IBAction func processEvalBtnClicked(_ sender: Any) {
        Constants.baseUrl = Constants.Api.fhBaseUrl
        self.callDashBoard()
    }
    
    private func navigateToModuleSelectionPE() {
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "HatcherySelectionViewController") as? HatcherySelectionViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    private func navigateToModuleSelectionPVE() {
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "PulletSelectionViewController") as? PulletSelectionViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    private func navigateToMicrobial() {
        UserDefaults.standard.set(3, forKey: "moduleID")
        let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    private func callDashBoard() {
        
        UserDefaults.standard.set("FlockHealth", forKey: "userType")

        UserDefaults.standard.set(true, forKey: "newlogin")
        
        let birdTypeId = UserDefaults.standard.integer(forKey: "birdTypeId")
        let storyboard =  UIStoryboard.init(name: Constants.Storyboard.pve360Storyboard, bundle: Bundle.main)
        
        if birdTypeId == 1 {
            UserDefaults.standard.set(4, forKey: "chick")
            UserDefaults.standard.set(true, forKey: "ChickenBird")
            UserDefaults.standard.set(false, forKey: "turkey")
            
            let mapViewControllerObj = storyboard.instantiateViewController(withIdentifier: "DashView_Controller") as? DashViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
        } else if birdTypeId == 2 {
            LanguageUtility.setAppleLAnguageTo(lang: "en")
            UserDefaults.standard.set(5, forKey: "chick")
            UserDefaults.standard.set(true, forKey: "TurkeyBird")
            UserDefaults.standard.set(false, forKey: "Chicken")
            
            let mapViewControllerObj = storyboard.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as? DashViewControllerTurkey
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
        } else if birdTypeId == 3 {
            
            let mapViewControllerObj = storyboard.instantiateViewController(withIdentifier: "BirdsSelectionVC") as? BirdsSelectionVC
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
        }
    }
}

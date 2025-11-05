//
//  HatcheryLandingViewController.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 04/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

class HatcheryLandingViewController: BaseViewController {

    @IBOutlet weak var popUpBgImgView: UIImageView!
    @IBOutlet weak var hatcheryView: UIView!
    @IBOutlet weak var breederView: UIView!
    @IBOutlet weak var growoutView: UIView!

    var selectedBtnStr = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetViewandButtons(selectedBtn: selectedBtnStr)
        
    }

    // MARK: Custom Functions

    private func navigateToPEDashboard(moduleSelected:String){
        let vc = UIStoryboard.init(name: Constants.Storyboard.peStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PEDashboardViewController") as? PEDashboardViewController
        vc!.currentSelectedModule = moduleSelected
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    // MARK: IBActions
    
    @IBAction func clickedHatchery(_ sender: Any) {
        resetViewandButtons(selectedBtn: Constants.Module.hatchery)
    }
    
    @IBAction func clickedBreeder(_ sender: Any) {
        resetViewandButtons(selectedBtn: Constants.Module.breeder)
    }
    
    @IBAction func clickedGrowout(_ sender: Any) {
        resetViewandButtons(selectedBtn: Constants.Module.growout)
    }
    
    @IBAction func clickedProcessEvaluation(_ sender: Any) {
        navigateToPEDashboard(moduleSelected: Constants.Module.hatchery_PV)
    }

    @IBAction func clickedPulletVaccineEvaluation(_ sender: Any) {
        navigateToPVEDashboard(moduleSelected: Constants.Module.breeder_PVE)

//        let vc = UIStoryboard.init(name: Constants.Storyboard.pveStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PVEDashboardViewController") as? PVEDashboardViewController
//        self.navigationController?.pushViewController(vc!, animated: false)
    }

    private func navigateToPVEDashboard(moduleSelected:String){
        let vc = UIStoryboard.init(name: Constants.Storyboard.pveStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PVEDashboardViewController") as? PVEDashboardViewController
        vc!.currentSelectedModule = moduleSelected
        self.navigationController?.pushViewController(vc!, animated: false)
    }

    
   @IBAction func clickedMicrobial(_ sender: Any) {

        let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
        self.navigationController?.pushViewController(vc!, animated: false)

    }
    
    @IBAction func clickedChickQuality(_ sender: Any) {
        showToast(message: "Breeder Clicked")
    }
    
    @IBAction func clickedBreakoutAnalysis(_ sender: Any) {
        showToast(message: "Breeder Clicked")
    }
    
    
    
}


extension HatcheryLandingViewController{
    
    func resetViewandButtons(selectedBtn:String) {
        switch selectedBtn {
        case Constants.Module.hatchery:do {
            popUpBgImgView.image = UIImage(named: Constants.Image.popup_bg_hatchery)
            hatcheryView.isHidden = false
            breederView.isHidden = true
            growoutView.isHidden = true
            }
        case Constants.Module.breeder:do {
            popUpBgImgView.image = UIImage(named: Constants.Image.popup_bg_breeder)
            hatcheryView.isHidden = true
            breederView.isHidden = false
            growoutView.isHidden = true
            }
        case Constants.Module.growout:do {
            popUpBgImgView.image = UIImage(named: Constants.Image.popup_bg_growout)
            hatcheryView.isHidden = true
            breederView.isHidden = true
            growoutView.isHidden = false
            }
        default:
            print("xxx")
        }
    }
    
}

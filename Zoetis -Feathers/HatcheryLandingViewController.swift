//
//  HatcheryLandingViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 04/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class HatcheryLandingViewController: BaseViewController {

    @IBOutlet weak var btnBreeder: UIButton!
    @IBOutlet weak var btnGrowout: UIButton!
    @IBOutlet weak var buttonProcessEvaluation: UIButton!
    @IBOutlet weak var hatcheryButton: UIButton!
    @IBOutlet weak var imgViewBackGround: UIImageView!
    var selectedBtnStr = String()
    @IBOutlet weak var hatcheryView: UIView!
    @IBOutlet weak var breederView: UIView!
    @IBOutlet weak var growoutView: UIView!

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        resetViewandButtons(selectedBtn: selectedBtnStr)
    }
    
    // MARK: Custom Functions

    private func navigateToPEDashboard() {
        let RoleId = UserDefaults.standard.string(forKey: "RoleId")
        if RoleId == "TSR" && RoleId == "FSR" {
            let vc = UIStoryboard.init(name: Constants.Storyboard.peStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PEDashboardViewController") as? PEDashboardViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    private func navigateToPVEDashboard(moduleSelected:String) {
        UserDefaults.standard.set(2, forKey: "moduleID")
        let vc = UIStoryboard.init(name: Constants.Storyboard.pveStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PVEDashboardViewController") as? PVEDashboardViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    // MARK: IBActions
    @IBAction func clickedBreeder(_ sender: Any) {
        btnBreeder.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
            self?.btnBreeder.transform = .identity
        }, completion: { (success) -> Void in
            if success {
                self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
            }
        })
    }
    
    @IBAction func clickedGrowout(_ sender: Any) {
        btnGrowout.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
            self?.btnGrowout.transform = .identity
        }, completion: { (success) -> Void in
            if success {
                self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
            }
        })
    }
    
    @IBAction func clickedProcessEvaluation(_ sender: Any) {
        buttonProcessEvaluation.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
            self?.buttonProcessEvaluation.transform = .identity
        }, completion: { (success) -> Void in
            if success {
                self.navigateToPEDashboard()
            }
        })
    }
    
   @IBAction func clickedMicrobial(_ sender: Any) {

        let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "Microbial") as? MicrobialViewController
        self.navigationController?.pushViewController(vc!, animated: false)

    }
    
    @IBAction func clickedChickQuality(_ sender: Any) {
        print("clickedChickQuality")
    }
    
    @IBAction func clickedBreakoutAnalysis(_ sender: Any) {
        print("clickedBreakoutAnalysis")
    }
    
    
    @IBAction func hatcheryButtonClicked(_ sender: Any) {
          hatcheryButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
          UIView.animate(withDuration: 2.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: .allowUserInteraction,
            animations: { [weak self] in
              self?.hatcheryButton.transform = .identity
            }, completion: { (success) -> Void in
               if success {
                    self.navigationController?.popToViewController(ofClass: HatcherySelectionViewController.self)
                }
            })
    }
    
    @IBAction func PVEClicked(_ sender: Any) {
      navigateToPVEDashboard(moduleSelected:"Breeder")
    }
    
}


extension HatcheryLandingViewController{
  
}

//
//  BreederLandingViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/01/20.
//  Copyright © 2020 . All rights reserved.
//
import UIKit
import Foundation

class BreederLandingViewController: BaseViewController {

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
      //  resetViewandButtons(selectedBtn: selectedBtnStr)

    }
    
    // MARK: Custom Functions

    private func navigateToPEDashboard(){
             let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GlobalDashboardViewController") as? GlobalDashboardViewController
             self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func navigateToPVEDashboard(moduleSelected:String){
             let vc = UIStoryboard.init(name: Constants.Storyboard.pveStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PVEDashboardViewController") as? PVEDashboardViewController
            // vc?.currentSelectedModule = moduleSelected
             self.navigationController?.pushViewController(vc!, animated: false)
    }
    // MARK: IBActions
    
    @IBAction func clickedBreeder(_ sender: Any) {
//        //   showtoast(message: "Breeder Clicked")
//        resetViewandButtons(selectedBtn: Constants.Module.breeder)
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
//         //   showtoast(message: "Growout Clicked")
//          resetViewandButtons(selectedBtn: Constants.Module.growout)
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
         //   showtoast(message: "Breeder Clicked")
       // navigateToPVEDashboard()
    }
    
    @IBAction func clickedBreakoutAnalysis(_ sender: Any) {
         //   showtoast(message: "Breeder Clicked")
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
    
    @IBAction func pveClicked(_ sender: Any) {
      navigateToPVEDashboard(moduleSelected:"Breeder")
    }
    
    
    
}





extension HatcheryLandingViewController{
    
    func resetViewandButtons(selectedBtn:String) {
        switch selectedBtn {
        case Constants.Module.hatchery:
            imgViewBackGround.image = UIImage(named: Constants.Image.popup_bg_hatchery)
            
            hatcheryButton.setBackgroundImage(UIImage(named: "hatchery_landing_icon"), for: .normal)
            btnBreeder.setBackgroundImage(UIImage(named: "breeder_icon_unselect"), for: .normal)
            btnGrowout.setBackgroundImage(UIImage(named: "growout_icon_unselect"), for: .normal)
                      
            hatcheryView.isHidden = false
            breederView.isHidden = true
            growoutView.isHidden = true
            
        case Constants.Module.breeder: //breeder_landing_icon
            imgViewBackGround.image = UIImage(named: Constants.Image.popup_bg_breeder)
           // btnBreeder.backgroundImage = UIImage(named: "breeder_landing_icon")
            
             hatcheryButton.setBackgroundImage(UIImage(named: "hatchery_icon_unselect"), for: .normal)
             btnBreeder.setBackgroundImage(UIImage(named: "breeder_landing_icon"), for: .normal)
             btnGrowout.setBackgroundImage(UIImage(named: "growout_icon_unselect"), for: .normal)
            
            
            hatcheryView.isHidden = true
            breederView.isHidden = false
            growoutView.isHidden = true
            
        case Constants.Module.growout:
            imgViewBackGround.image = UIImage(named: Constants.Image.popup_bg_growout)
            
            hatcheryButton.setBackgroundImage(UIImage(named: "hatchery_icon_unselect"), for: .normal)
            btnBreeder.setBackgroundImage(UIImage(named: "breeder_icon_unselect"), for: .normal)
            btnGrowout.setBackgroundImage(UIImage(named: "growout_landing_icon"), for: .normal)
                       
            
            hatcheryView.isHidden = true
            breederView.isHidden = true
            growoutView.isHidden = false
        
        default:

            break
        }
    }
    
}

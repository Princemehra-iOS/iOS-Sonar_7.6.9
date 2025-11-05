//
//  ModuleSelectionViewController.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 04/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

class ModuleSelectionViewController: BaseViewController {

    var path: UIBezierPath!
    @IBOutlet weak var popUpBgImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  //popUpBgImgView.image = UIImage(named: "popup_bg_breeder")
  //popUpBgImgView.image = UIImage(named: "popup_bg_hatchery")

    // MARK: Custom Functions
    
    private func navigateToHatcheryViewController(isModule: String){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "HatcheryLandingViewController") as? HatcheryLandingViewController
        vc!.selectedBtnStr = isModule
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    // MARK: IBActions
    
    @IBAction func clickedHatchery(_ sender: Any) {
        showToast(message: "Hatchery Clicked")
        navigateToHatcheryViewController(isModule: Constants.Module.hatchery)
    }
    
    @IBAction func clickedBreeder(_ sender: Any) {
        showToast(message: "Breeder Clicked")
        navigateToHatcheryViewController(isModule: Constants.Module.breeder)
    }
    
    @IBAction func clickedGrowout(_ sender: Any) {
        showToast(message: "Growout Clicked")
        navigateToHatcheryViewController(isModule: Constants.Module.growout)
    }
    
}

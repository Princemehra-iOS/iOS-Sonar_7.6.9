//
//  PVEDashboardViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 09/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
class PVEDashboardViewController: BaseViewController, ComplexDelegate {
    func didSelectedName(SelectedName: String) {
        print("SelectedName---\(SelectedName)")
    }
    
    @IBOutlet weak var buttonMenu: UIButton!
   var currentSelectedModule = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addComplexPopup()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
       
    @IBAction func actionMenu(_ sender: Any) {
        self.onSlideMenuButtonPressed(self.buttonMenu)
    }
    
    @IBAction func startNewAssessmentBtnAction(_ sender: Any) {
        print("startNewAssessmentBtnAction")
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEStartNewAssessment") as! PVEStartNewAssessment
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func viewAssessmentBtnAction(_ sender: Any) {
        print("viewAssessmentBtnAction")
    }

    @IBAction func logOutBtnAction(_ sender: Any) {
        print("logOutBtnAction")
        addComplexPopup()

    }
    
    func addComplexPopup() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ComplexPoupVC") as! ComplexPoupViewController
        vc.currentSelectedModule = Constants.Module.breeder_PVE
        vc.delegate = self
        navigationController?.present(vc, animated: false, completion: nil)
    }
}

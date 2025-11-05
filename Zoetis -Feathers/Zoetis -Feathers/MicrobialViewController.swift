//
//  MicrobialViewController.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 10/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

class MicrobialViewController: BaseViewController {
    
    @IBOutlet weak var buttonMenu: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var microbialPopUpView: customView!
    
    var selectedSurvey :String = ""
    
    @IBOutlet weak var backViewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backViewBtn.isHidden = true
        self.microbialPopUpView.isHidden = true
    }
    
    @IBAction func newRequisitionBtnClk(_ sender: UIButton) {
        
        self.backViewBtn.isHidden = false
        self.microbialPopUpView.isHidden = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func backViewBtnClk(_ sender: UIButton) {
        
        self.backViewBtn.isHidden = true
        self.microbialPopUpView.isHidden = true
    }
    
    
    @IBAction func bacterialSurveyBtnClk(_ sender: UIButton) {
        
    let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "BacterialSurveyViewController") as? BacterialSurveyViewController
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.surveySelected = "MicrobialSyrvey"
        
        print(appDelegate.surveySelected)
        
        
        
      //  self.present(vc!, animated: false, completion: nil)
        
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    
    @IBAction func environmentalSurveyBtnClk(_ sender: customButton) {
        
        let vc = UIStoryboard.init(name: Constants.Storyboard.microbialStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "EnvironmentalSurveyViewController") as? EnvironmentalSurveyViewController
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.surveySelected = "MicrobialSyrvey"
//
//        print(appDelegate.surveySelected)
        
        
        
        //  self.present(vc!, animated: false, completion: nil)
        
        self.navigationController?.pushViewController(vc!, animated: false)
        
        
    }
    
    
    
    @IBAction func actionMenu(_ sender: Any) {
        self.onSlideMenuButtonPressed(self.buttonMenu)
    }
    
}

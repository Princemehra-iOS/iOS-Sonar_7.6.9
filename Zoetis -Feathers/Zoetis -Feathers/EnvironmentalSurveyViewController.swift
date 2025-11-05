//
//  EnvironmentalSurveyViewController.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 11/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

class EnvironmentalSurveyViewController: BaseViewController {

    @IBOutlet weak var surveyTitle: UILabel!
    
    @IBOutlet weak var yesImageView: UIImageView!
    
    @IBOutlet weak var noImageView: UIImageView!
    
    @IBOutlet weak var requestorTxt: UITextField!
    
    @IBOutlet weak var companyTxt: customButton!
    
    @IBOutlet weak var surveyConductedOnDropDownBtn: customButton!
    
    @IBOutlet weak var purposeOfSurveyDropDownBtn: customButton!
    
    @IBOutlet weak var sampleCollectedByDropDownBtn: customButton!
    
    @IBOutlet weak var siteDropDownBtn: customButton!
    
    @IBOutlet weak var reviewerDropDwnBtn: customButton!
    
    @IBOutlet weak var sampleCollectionDateDropDownBtn: customButton!
    
    @IBOutlet weak var transferInDropDownBtn: customButton!
    
    @IBOutlet weak var barcodeTxt: FormTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var buttonMenu: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func ackYesBtnClk(_ sender: UIButton) {
        
        
        //  UIImageView(image: image)
        
        self.yesImageView.image  =  UIImage(named:"Radio_Btn")!
        self.noImageView.image  =  UIImage(named:"Radio_Btn01")!
    }
    
    
    @IBAction func ackNoBtnClk(_ sender: UIButton) {
        
        self.noImageView.image  =  UIImage(named:"Radio_Btn")!
        self.yesImageView.image  =  UIImage(named:"Radio_Btn01")!
    }
    
    
    
    @IBAction func actionMenu(_ sender: Any) {
        self.onSlideMenuButtonPressed(self.buttonMenu)
    }

}

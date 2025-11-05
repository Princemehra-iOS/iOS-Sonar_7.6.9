//
//  FeatherPulpViewController.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 12/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

class FeatherPulpViewController: BaseViewController {

    @IBOutlet weak var surveyTitle: UILabel!
    
    
    @IBOutlet weak var yesImageView: UIImageView!
    
    @IBOutlet weak var noImageView: UIImageView!
    
    
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

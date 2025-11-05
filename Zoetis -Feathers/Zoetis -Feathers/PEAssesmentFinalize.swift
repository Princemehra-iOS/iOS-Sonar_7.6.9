//
//  PEAssesmentFinalize.swift
//  Zoetis -Feathers
//
//  Created by Suraj Kumar Panday on 13/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import UIKit

class PEAssesmentFinalize: BaseViewController {
    @IBOutlet weak var buttonMenu: UIButton!
      
     override func viewWillAppear(_ animated: Bool) {
           navigationController?.navigationBar.isHidden = false
     }
           
      @IBAction func actionMenu(_ sender: Any) {
          self.onSlideMenuButtonPressed(self.buttonMenu)
      }
        
      @IBAction func btnAction(_ sender: Any) {
          print("btnAction")
      }
      
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
      }

}

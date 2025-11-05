//
//  GradientDemoVC.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

class GradientDemoVC: UIViewController{
    

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
       // currentArr.append(["nnn": "qq"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
       
    @IBAction func actionMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

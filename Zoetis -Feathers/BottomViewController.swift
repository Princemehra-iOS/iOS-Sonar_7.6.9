//
//  BottomViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class BottomViewController: UIViewController {
    @IBOutlet weak var upperViewOrange: UIView!
    
     init(){
         super.init(nibName:"BottomViewController", bundle: nil);
     }
        
     required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
     }
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()

        upperViewOrange.clipsToBounds = true
        upperViewOrange.layer.cornerRadius = 20
        if #available(iOS 11.0, *) {
            upperViewOrange.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }

}

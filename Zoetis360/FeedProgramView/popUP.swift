//
//  popUP.swift
//  Zoetis -Feathers
//
//  Created by "" on 10/10/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit


protocol popUPnavigation {
    func noPopUpPosting()
    func YesPopUpPosting()
    
    
}
extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

class popUP: UIView {
    var delegatenEW:popUPnavigation!
    var strFeddName = String()
    @IBOutlet weak var MAINVIEW: UIView!
    @IBOutlet weak var lblFedPrgram: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    @IBAction func yesButtAction(_ sender: AnyObject) {
        
        delegatenEW.YesPopUpPosting()
        self.removeFromSuperview()
    }
    @IBAction func noButtonAction(_ sender: AnyObject) {
        delegatenEW.noPopUpPosting()
        self.removeFromSuperview()
        
    }
    
    
    
    
}

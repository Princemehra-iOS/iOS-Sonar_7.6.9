//
//  infoLinkPopUp.swift
//  Zoetis -Feathers
//
//  Created by "" on 18/10/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol closeButton {
    func noPopUpPosting()
}

class infoLink: UIView {

    // MARK: - Variables
    var delegateInfo:closeButton!
    
    // MARK: - Outlets
    @IBOutlet weak var backBtnA: UIButton!
    
    // MARK: - IBACTIONS
    @IBAction func doneButtAction(_ sender: AnyObject) {
        appDelegateObj.testFuntion()
    }
    
    @IBAction func noButtonAction(_ sender: AnyObject) {
        delegateInfo.noPopUpPosting()
        self.removeFromSuperview()
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func showView(_ view1: UIView, frame1: CGRect) -> UIView
    {
        self.frame = frame1
        view1.addSubview(self)
        self.alpha = 0
        let transitionOptions = UIView.AnimationOptions.transitionCurlDown
        UIView.transition(with: self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 1
            
        }, completion: { finished in
            appDelegateObj.testFuntion()
        })
        return self
    }
    
    func removeView(_ view1: UIView) -> UIView
    {
        let transitionOptions = UIView.AnimationOptions.transitionCurlUp
        UIView.transition(with: self, duration: 0.75, options: transitionOptions, animations: {
            self.alpha = 0
            
        }, completion: { finished in
            self.removeFromSuperview()

        })
        
        return self
    }
    
}


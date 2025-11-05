//
//  startNecrPopUpTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 27/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

protocol necropsyPop {
    
    func startNecropsyBtnFunc ()
    func crossBtnFunc ()
    
    
}

class startNecrPopUpTurkey: UIView {
    
    // MARK: - OUTLET
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - VARIABLES
    var delegateStartNec: necropsyPop!
    
    // MARK: - ❌ Cross / Close Button Action
    @IBAction func crossBtnAction(_ sender: UIButton) {
        delegateStartNec.crossBtnFunc()
    }
    // MARK: - 🦃🔬 Start Necropsy Button Action
    @IBAction func startNecrBtnAction(_ sender: UIButton) {
        delegateStartNec.startNecropsyBtnFunc()
    }
    
    // MARK: - METHOD & FUNCTION
    override func draw(_ rect: CGRect) {
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 4
        bgView.layer.borderColor = UIColor.white.cgColor
    }
    
}

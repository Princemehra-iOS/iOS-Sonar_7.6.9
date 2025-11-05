//
//  feedPopUpTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 26/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

protocol  feedPop {
    func yesBtnPop()
    func noBtnPop()
}



class feedPopUpTurkey: UIView {
    
    // MARK: - VARIABLES
    var delegatefeedPop :feedPop!
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblFedPrgram: UILabel!
        
    override func draw(_ rect: CGRect) {
        appDelegateObj.testFuntion()
    }
    
    // MARK: - IBACTIONS
    @IBAction func yesBtnAction(_ sender: UIButton) {
        delegatefeedPop.yesBtnPop()
    }
    
    @IBAction func noBtnAction(_ sender: UIButton) {
        delegatefeedPop.noBtnPop()
    }
  
}

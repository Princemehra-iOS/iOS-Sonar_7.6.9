//
//  startNecrPopUpTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 27/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//

import UIKit

protocol necropsyPop {

    func startNecropsyBtnFunc ()
    func crossBtnFunc ()

}

class startNecrPopUpTurkey: UIView {

    @IBOutlet weak var bgView: UIView!

    var delegateStartNec: necropsyPop!

    @IBAction func crossBtnAction(_ sender: UIButton) {

        delegateStartNec.crossBtnFunc()
    }

    @IBAction func startNecrBtnAction(_ sender: UIButton) {
        delegateStartNec.startNecropsyBtnFunc()
    }

    override func draw(_ rect: CGRect) {

        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 4
        bgView.layer.borderColor = UIColor.white.cgColor
     }

}

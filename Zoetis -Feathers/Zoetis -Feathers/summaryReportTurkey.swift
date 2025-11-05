//
//  summaryReportTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 26/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.

import UIKit

protocol summmaryReportTUR {

    func yesButtonFunc ()
    func noButtonFunc ()
    func crossButtonFunct ()

}

class summaryReportTurkey: UIView {

    var sumarryDelegate: summmaryReportTUR!

    override func draw(_ rect: CGRect) {
        appDelegateObj.testFuntion()
    }

    @IBAction func yesBtnAction(_ sender: UIButton) {

        sumarryDelegate.yesButtonFunc()
    }

    @IBAction func noBtnAction(_ sender: UIButton) {

        sumarryDelegate.noButtonFunc()
    }

    @IBAction func crossBtnAction(_ sender: UIButton) {

       sumarryDelegate.crossButtonFunct()
    }

}

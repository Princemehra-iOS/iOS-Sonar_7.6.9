//  summaryReport.swift
//  Zoetis -Feathers
//  Created by "" on 12/11/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit

protocol summaryReportProtocol: class {
    func yesButtonFunc ()
    func noButtonFunc ()
    func crossButtonFunct ()
}

class summaryReport: UIView {

    var summaryReportDelegate: summaryReportProtocol!

    @IBOutlet weak var bgView: UIView!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "summaryReport", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView

    }

    override func draw(_ rect: CGRect) {

        bgView.layer.cornerRadius = 7

    }

    @IBAction func yesAction(_ sender: AnyObject) {

        self.summaryReportDelegate.yesButtonFunc()
    }

    @IBAction func noAction(_ sender: AnyObject) {

        self.summaryReportDelegate.noButtonFunc()

    }

    @IBAction func closeBttn(_ sender: AnyObject) {

        self.summaryReportDelegate.crossButtonFunct()

    }

}

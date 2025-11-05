//  startNecropsyXib.swift
//  Zoetis -Feathers
//  Created by "" on 08/12/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit

protocol startNecropsyP: class {
    func startNecropsyBtnFunc ()
    func crossBtnFunc ()
}

class startNecropsyXib: UIView {

    var necropsyDelegate: startNecropsyP!

class func instanceFromNib() -> UIView {
        return UINib(nibName: "startNecropsyXib", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    @IBOutlet weak var bgView: UIView!
    override func draw(_ rect: CGRect) {

        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 4
        bgView.layer.borderColor = UIColor.white.cgColor

    }

    @IBAction func startNecropsyBttn(_ sender: AnyObject) {

        self.necropsyDelegate.startNecropsyBtnFunc()

    }

    @IBAction func crossBtnAction(_ sender: AnyObject) {

        self.necropsyDelegate.crossBtnFunc()

    }

}

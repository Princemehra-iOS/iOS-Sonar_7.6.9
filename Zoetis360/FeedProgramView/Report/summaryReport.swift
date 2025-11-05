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
    // MARK: - VARIABLES
    var summaryReportDelegate :summaryReportProtocol!
    // MARK: - OUTLET
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var reportLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "summaryReport", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        
        
    }
    // MARK: - METHOD & FUNCTION
    override func draw(_ rect: CGRect) {
        
        reportLbl.text = NSLocalizedString("View summary report ?", comment: "")
        summaryLbl.text = NSLocalizedString("Summary Report", comment: "")
        yesBtn.setTitle(NSLocalizedString("Yes", comment: ""), for: .normal)
        noBtn.setTitle(NSLocalizedString(Constants.noStr, comment: ""), for: .normal)
        bgView.layer.cornerRadius = 7
        
    }
    
    // MARK: - IBACTION
    @IBAction func yesAction(_ sender: AnyObject) {
        self.summaryReportDelegate.yesButtonFunc()
    }
    
    @IBAction func noAction(_ sender: AnyObject) {
        self.summaryReportDelegate.noButtonFunc()
        UserDefaults.standard.removeObject(forKey: "unCustId")
    }
    
    @IBAction func closeBttn(_ sender: AnyObject) {
        self.summaryReportDelegate.crossButtonFunct()
    }
  
}

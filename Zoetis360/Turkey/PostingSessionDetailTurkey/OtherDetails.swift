//
//  OtherDetails.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/10/23.
//

import UIKit

// MARK: - PROTOCOL & FUNCTIONS
protocol otherFuncDetails {
    func DoneFunc ()
}

class OtherDetails: UIView {

    @IBOutlet weak var liveTxtFld: UITextField!
    @IBOutlet weak var mortalityTxtFld: UITextField!
    @IBOutlet weak var avgAgeTxtField: UITextField!
    @IBOutlet weak var avgWeightTxtFld: UITextField!
    @IBOutlet weak var outTimeTxtFld: UITextField!
    @IBOutlet weak var fcrTxtFld: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    var liveText = String()
    var mortalityText = String()
    var avgAgeText = String()
    var avgWeightText = String()
    var outTimeText = String()
    var fcrText = String()
    var buttonDroper = UIButton ()
    var otherFuncDetailsDelegate: otherFuncDetails!
    
    @IBOutlet weak var fcr: UILabel!
    
    @IBOutlet weak var livablityLbl: UILabel!
    @IBOutlet weak var sevenDaylbl: UILabel!
    @IBOutlet weak var timeOutlbl: UILabel!
    
    @IBOutlet weak var weightlbl: UILabel!
   
    @IBOutlet weak var agrlbl: UILabel!
    
    @IBOutlet weak var Details: UILabel!
   
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        otherFuncDetailsDelegate.DoneFunc()
    }
    
    override func draw(_ rect: CGRect) {
        
        self.bgView.layer.cornerRadius = 7
        self.bgView.layer.borderWidth = 3
        self.bgView.layer.borderColor = UIColor.white.cgColor
        
        fcrTxtFld.text = fcrText
        liveTxtFld.text = liveText
        avgAgeTxtField.text = avgAgeText
        avgAgeTxtField.text = avgAgeText
        outTimeTxtFld.text = outTimeText
        mortalityTxtFld.text = mortalityText
        avgWeightTxtFld.text = avgWeightText
        
        buttonDroper.alpha = 0
        buttonDroper.frame = CGRect(x: 0, y: 0, width: 942, height: 428)
        buttonDroper.addTarget(self, action: #selector(AddFarmTurkey.buttonPressedDroper), for: .touchUpInside)
        buttonDroper.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.addSubview(buttonDroper)
        
        
        livablityLbl.text = NSLocalizedString("Livability:", comment: "")
        sevenDaylbl.text = NSLocalizedString("Avg. 7 Day Mortality:", comment: "")
        timeOutlbl.text = NSLocalizedString("Avg. Out Time:", comment: "")
        weightlbl.text = NSLocalizedString("Avg. Weight:", comment: "")
        agrlbl.text =  NSLocalizedString("Avg. Age:", comment: "")
        
        fcr.text =  NSLocalizedString("FCR:", comment: "")
        
        Details.text = NSLocalizedString("Other Details", comment: "")
        doneBtn.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
       
    }
}

//
//  File.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 24/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol VaccineEvaluationMarksDelegate: AnyObject {
    func processEvaluationScore(percentCanterLRTotal: Int, siteOfInjectScored: Int)
}

class PVEVaccineEvaluationCell: UITableViewCell {
    
    weak var delegate: VaccineEvaluationMarksDelegate?
    
    let sharedManager = PVEShared.sharedInstance
    
    @IBOutlet weak var centerLLbl: UILabel!
    @IBOutlet weak var wingLLbl: UILabel!
    @IBOutlet weak var musculLLbl: UILabel!
    @IBOutlet weak var missedLLbl: UILabel!
    
    @IBOutlet weak var centerLTxtField: UITextField!
    @IBOutlet weak var wingLTxtField: UITextField!
    @IBOutlet weak var musculLTxtField: UITextField!
    @IBOutlet weak var missedLTxtField: UITextField!
    @IBOutlet weak var leftTotalLbl: UILabel!
    
    
    @IBOutlet weak var centerRLbl: UILabel!
    @IBOutlet weak var wingRLbl: UILabel!
    @IBOutlet weak var musculRLbl: UILabel!
    @IBOutlet weak var missedRLbl: UILabel!
    
    @IBOutlet weak var centerRTxtField: UITextField!
    @IBOutlet weak var wingRTxtField: UITextField!
    @IBOutlet weak var musculRTxtField: UITextField!
    @IBOutlet weak var missedRTxtField: UITextField!
    @IBOutlet weak var rightTotalLbl: UILabel!
    
    @IBOutlet weak var percentCenterLLbl: UILabel!
    @IBOutlet weak var percentWingBandLLbl: UILabel!
    @IBOutlet weak var percentMusculLLbl: UILabel!
    @IBOutlet weak var percentMissedLLbl: UILabel!
    
    @IBOutlet weak var percentCenterRLbl: UILabel!
    @IBOutlet weak var percentWingBandRLbl: UILabel!
    @IBOutlet weak var percentMusculRLbl: UILabel!
    @IBOutlet weak var percentMissedRLbl: UILabel!
    
    @IBOutlet weak var centerLRTotalLbl: UILabel!
    @IBOutlet weak var wingLRTotalLbl: UILabel!
    @IBOutlet weak var muscleLRTotalLbl: UILabel!
    @IBOutlet weak var missedLRTotalLbl: UILabel!
    @IBOutlet weak var totalLRLbl: UILabel!
    
    @IBOutlet weak var percentCenterLRTotalLbl: UILabel!
    @IBOutlet weak var percentWingLRTotalLbl: UILabel!
    @IBOutlet weak var percentMuscleLRTotalLbl: UILabel!
    @IBOutlet weak var percenMissedLRTotalLbl: UILabel!
    
    
    // ------- Inactivated Vaccines-----
    
    @IBOutlet weak var musculHitInstraTxtField: UITextField!
    @IBOutlet weak var missedInstraTxtField: UITextField!
    @IBOutlet weak var musculHitInstraLbl: UILabel!
    @IBOutlet weak var missedInstraLbl: UILabel!
    
    @IBOutlet weak var percentMusculHitInstraLbl: UILabel!
    @IBOutlet weak var percentMissedInstraLbl: UILabel!
    @IBOutlet weak var musculHitSubcutanousTxtField: UITextField!
    @IBOutlet weak var missedSubcutanousTxtField: UITextField!
    
    @IBOutlet weak var musculHitSubcutanousLbl: UILabel!
    @IBOutlet weak var missedSubcutanousLbl: UILabel!
    @IBOutlet weak var percentMusculHitSubcutanousLbl: UILabel!
    @IBOutlet weak var percentMissedSubcutanousLbl: UILabel!
    
    
    @IBOutlet weak var totalOfInstraLbl: UILabel!
    @IBOutlet weak var totalOfSubcutanousLbl: UILabel!
    @IBOutlet weak var totalOfInstraAndSubcutanousMuscleHitLbl: UILabel!
    @IBOutlet weak var percentTotalOfInstraAndSubcutanousMuscleHitLbl: UILabel!
    @IBOutlet weak var totalOfInstraAndSubcutanousMissedLbl: UILabel!
    @IBOutlet weak var percentTotalOfInstraAndSubcutanousMissedLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension PVEVaccineEvaluationCell: UITextFieldDelegate{
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
    func resetAllFields()  {
        
        centerLTxtField.text = "0"
        wingLTxtField.text = "0"
        musculLTxtField.text = "0"
        missedLTxtField.text = "0"
        leftTotalLbl.text = "0"
        
        centerRTxtField.text = "0"
        wingRTxtField.text = "0"
        musculRTxtField.text = "0"
        missedRTxtField.text = "0"
        rightTotalLbl.text = "0"
        
        percentCenterLLbl.text = "0"
        percentWingBandLLbl.text = "0"
        percentMusculLLbl.text = "0"
        percentMissedLLbl.text = "0"
        
        percentCenterRLbl.text = "0"
        percentWingBandRLbl.text = "0"
        percentMusculRLbl.text = "0"
        percentMissedRLbl.text = "0"
        
        centerLRTotalLbl.text = "0"
        wingLRTotalLbl.text = "0"
        muscleLRTotalLbl.text = "0"
        missedLRTotalLbl.text = "0"
        totalLRLbl.text = "0"
        
        percentCenterLRTotalLbl.text = "0"
        percentWingLRTotalLbl.text = "0"
        percentMuscleLRTotalLbl.text = "0"
        percenMissedLRTotalLbl.text = "0"
        
    }
    
    fileprivate func leftreportValues(_ textField: UITextField, _ newString: String, _ value: Int?) {
        if textField == centerLTxtField {
            
            centerLLbl.text = newString
            sharedManager.centerLTxtFieldValue = value ?? 0
        }
        if textField == wingLTxtField {
            wingLLbl.text = newString
            sharedManager.wingLTxtFieldValue = value ?? 0
        }
        if textField == musculLTxtField {
            musculLLbl.text = newString
            sharedManager.musculLTxtFieldValue = value ?? 0
        }
        if textField == missedLTxtField {
            missedLLbl.text = newString
            sharedManager.missedLTxtFieldValue = value ?? 0
        }
    }
    
    fileprivate func rightWingValue(_ textField: UITextField, _ newString: String, _ value: Int?) {
        // SubQ Right Wing -----------
        if textField == centerRTxtField {
            centerRLbl.text = newString
            sharedManager.centerRTxtFieldValue = value ?? 0
            
        }
        if textField == wingRTxtField {
            wingRLbl.text = newString
            sharedManager.wingRTxtFieldValue = value ?? 0
        }
        if textField == musculRTxtField {
            musculRLbl.text = newString
            sharedManager.musculRTxtFieldValue = value ?? 0
        }
        if textField == missedRTxtField {
            missedRLbl.text = newString
            sharedManager.missedRTxtFieldValue = value ?? 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let value: Int? = Int(newString)
        
        var centerTotalValue: Int? = 0
        var siteOfInjectTotalValue: Int? = 0
        
        
        leftreportValues(textField, newString, value)
        
        let totalSubQLeft: Int? = sharedManager.centerLTxtFieldValue + sharedManager.wingLTxtFieldValue + sharedManager.musculLTxtFieldValue + sharedManager.missedLTxtFieldValue
        
        leftTotalLbl.text = "\(totalSubQLeft ?? 0)"
        
        if totalSubQLeft ?? 0 > 0 {
            percentCenterLLbl.text = "\(sharedManager.centerLTxtFieldValue * 100 / (totalSubQLeft ?? 0))"
            percentWingBandLLbl.text = "\(sharedManager.wingLTxtFieldValue * 100 / (totalSubQLeft ?? 0))"
            percentMusculLLbl.text = "\(sharedManager.musculLTxtFieldValue * 100 / (totalSubQLeft ?? 0))"
            percentMissedLLbl.text = "\(sharedManager.missedLTxtFieldValue * 100 / (totalSubQLeft ?? 0))"
        }
        
        rightWingValue(textField, newString, value)
        
        let totalSubQRight: Int? = sharedManager.centerRTxtFieldValue + sharedManager.wingRTxtFieldValue + sharedManager.musculRTxtFieldValue + sharedManager.missedRTxtFieldValue
        rightTotalLbl.text = "\(totalSubQRight ?? 0)"
        
        if totalSubQRight ?? 0 > 0  && totalSubQLeft ?? 0 > 0{
            
            percentCenterRLbl.text = "\(sharedManager.centerRTxtFieldValue * 100 / (totalSubQRight ?? 0))"
            percentWingBandRLbl.text = "\(sharedManager.wingRTxtFieldValue * 100 / (totalSubQRight ?? 0))"
            percentMusculRLbl.text = "\(sharedManager.musculRTxtFieldValue * 100 / (totalSubQRight ?? 0))"
            percentMissedRLbl.text = "\(sharedManager.missedRTxtFieldValue * 100 / (totalSubQRight ?? 0))"
            
            centerLRTotalLbl.text = "\(sharedManager.centerLTxtFieldValue + sharedManager.centerRTxtFieldValue) "
            wingLRTotalLbl.text = "\(sharedManager.wingLTxtFieldValue + sharedManager.wingRTxtFieldValue) "
            muscleLRTotalLbl.text = "\(sharedManager.musculLTxtFieldValue + sharedManager.musculRTxtFieldValue) "
            missedLRTotalLbl.text = "\(sharedManager.missedLTxtFieldValue + sharedManager.missedRTxtFieldValue) "
            
        
            var percentCanterLTotal = sharedManager.centerLTxtFieldValue * 100 / (totalSubQLeft ?? 0)
            var percentCanterRTotal = sharedManager.centerRTxtFieldValue * 100 / (totalSubQRight ?? 0)
            percentCenterLRTotalLbl.text = "\(percentCanterLTotal/2 + percentCanterRTotal/2)"
            
            // For Delegate
            centerTotalValue = percentCanterLTotal/2 + percentCanterRTotal/2
           
            var percentWingLTotal = sharedManager.wingLTxtFieldValue * 100 / (totalSubQLeft ?? 0)
            var percentWingRTotal = sharedManager.wingRTxtFieldValue * 100 / (totalSubQRight ?? 0)
            percentWingLRTotalLbl.text = "\(percentWingLTotal/2 + percentWingRTotal/2)"
            
           
            var percentMuscleLTotal = sharedManager.musculLTxtFieldValue * 100 / (totalSubQLeft ?? 0)
            var percentMuscleRTotal = sharedManager.musculRTxtFieldValue * 100 / (totalSubQRight ?? 0)
            percentMuscleLRTotalLbl.text = "\(percentMuscleLTotal/2 + percentMuscleRTotal/2)"
            
           
            var percenMissedLTotal = sharedManager.musculLTxtFieldValue * 100 / (totalSubQLeft ?? 0)
            var percenMissedRTotal = sharedManager.musculRTxtFieldValue * 100 / (totalSubQRight ?? 0)
            percenMissedLRTotalLbl.text = "\(percenMissedLTotal/2 + percenMissedRTotal/2)"
            
        }
        
        
        if textField == musculHitInstraTxtField {
            musculHitInstraLbl.text = newString
            sharedManager.musculHitInstraLblValue = value ?? 0
        }
        if textField == missedInstraTxtField {
            missedInstraLbl.text = newString
            sharedManager.missedInstraLblValue = value ?? 0
        }
        
        let totalOfInstra: Int? = sharedManager.musculHitInstraLblValue + sharedManager.missedInstraLblValue
        totalOfInstraLbl.text = "\(totalOfInstra ?? 0)"
        
        if totalOfInstra ?? 0 > 0{
            
            percentMusculHitInstraLbl.text = "\(sharedManager.musculHitInstraLblValue * 100 / (totalOfInstra ?? 0))"
            percentMissedInstraLbl.text = "\(sharedManager.missedInstraLblValue * 100 / (totalOfInstra ?? 0))"
            
        }
        
        if textField == musculHitSubcutanousTxtField {
            musculHitSubcutanousLbl.text = newString
            sharedManager.musculHitSubcutanousLblValue = value ?? 0
        }
        if textField == missedSubcutanousTxtField {
            missedSubcutanousLbl.text = newString
            sharedManager.missedSubcutanousLblValue = value ?? 0
        }
        
        let totalOfSubcutanous: Int? = sharedManager.musculHitSubcutanousLblValue + sharedManager.missedSubcutanousLblValue
        totalOfSubcutanousLbl.text = "\(totalOfSubcutanous ?? 0)"
        
        if totalOfSubcutanous ?? 0 > 0 && totalOfInstra ?? 0 > 0{
            
            percentMusculHitSubcutanousLbl.text = "\(sharedManager.musculHitSubcutanousLblValue * 100 / (totalOfSubcutanous ?? 0))"
            percentMissedSubcutanousLbl.text = "\(sharedManager.missedSubcutanousLblValue * 100 / (totalOfSubcutanous ?? 0))"
            
            totalOfInstraAndSubcutanousMuscleHitLbl.text = "\(sharedManager.musculHitInstraLblValue + sharedManager.musculHitSubcutanousLblValue)"
            totalOfInstraAndSubcutanousMissedLbl.text = "\(sharedManager.missedInstraLblValue + sharedManager.missedSubcutanousLblValue)"
            
            var percentmusculHitInstraLblValue = sharedManager.musculHitInstraLblValue * 100 / (totalOfInstra ?? 0)
            var percentmusculHitSubcutanousLblValue = sharedManager.musculHitSubcutanousLblValue * 100 / (totalOfSubcutanous ?? 0)
            
            percentTotalOfInstraAndSubcutanousMuscleHitLbl.text = "\(percentmusculHitInstraLblValue/2 + percentmusculHitSubcutanousLblValue/2)"
            siteOfInjectTotalValue = percentmusculHitInstraLblValue/2 + percentmusculHitSubcutanousLblValue/2
           
            var percentmissedInstraLblValue = sharedManager.missedInstraLblValue * 100 / (totalOfSubcutanous ?? 0)
            var percentmissedSubcutanousLblValue = sharedManager.missedSubcutanousLblValue * 100 / (totalOfSubcutanous ?? 0)
            percentTotalOfInstraAndSubcutanousMissedLbl.text = "\(percentmissedInstraLblValue/2 + percentmissedSubcutanousLblValue/2)"
        }
        
        delegate?.processEvaluationScore(percentCanterLRTotal:centerTotalValue ?? 0, siteOfInjectScored: siteOfInjectTotalValue ?? 0)
        
        return true
    }
    
}

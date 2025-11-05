//
//  PETableviewHeaderFooterView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PETableviewConsumerQualityHeader: UITableViewHeaderFooterView {
    
    // MARK: - OUTLETS

    @IBOutlet weak var nameMicro: PEFormTextfield!
    @IBOutlet weak var nameResidue: PEFormTextfield!
    
    // MARK: - VARIABLES

    var microComplete:((_ string: String?) -> Void)?
    var residueComplete:((_ string: String?) -> Void)?
}

// MARK: - EXTENSION FOR TEXTFIELD DELEGATES

extension PETableviewConsumerQualityHeader: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameMicro{
            microComplete?(textField.text)
            
        }
        if textField == nameResidue{
            
            residueComplete?(textField.text)
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
}

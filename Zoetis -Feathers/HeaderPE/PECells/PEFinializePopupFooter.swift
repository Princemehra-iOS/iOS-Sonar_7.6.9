//
//  PETableviewHeaderFooterView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PEFinializePopupFooter: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var txtManagerName: PEFormTextfield!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var employeeIDView: UIView!
    @IBOutlet weak var hatcheryManagerNameView: UIView!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var doneButton: PESubmitButton!
    @IBOutlet weak var txtPhone: PEFormTextfield!
    @IBOutlet weak var txtEmployeeID: PEFormTextfield!
    
    
    var doneClickedCompletion:((_ string: String?) -> Void)?
    var txtPhoneComplete:((_ string: String?) -> Void)?
    var txtManagerNameComplete:((_ string: String?) -> Void)?
    var txtEmployeeIdComplete:((_ string: String?) -> Void)?
    
    
    @IBAction func doneClicked(_ sender: Any) {
        doneClickedCompletion?("")
    }
    
}

extension PEFinializePopupFooter: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPhone{
            txtPhoneComplete?(textField.text)
            
        }
        if textField == txtManagerName{
            
            txtManagerNameComplete?(textField.text)
        }
        if textField == txtEmployeeID{
            
            txtEmployeeIdComplete?(textField.text)
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

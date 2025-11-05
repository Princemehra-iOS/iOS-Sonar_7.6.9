//
//  PETableviewHeaderFooterView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PEHeaderDayOfAge: UITableViewHeaderFooterView , UITextFieldDelegate {
    
    // MARK: - OUTLETS

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var switchHatchery: UISwitchCustom!
    @IBOutlet weak var btn2: customButton!
    @IBOutlet weak var btn1: customButton!
    @IBOutlet weak var txtDType: PEFormTextfield!
    @IBOutlet weak var txtCSize: PEFormTextfield!
    @IBOutlet weak var antiBioticTextView: UIView!
    @IBOutlet weak var abTextView: UIView!
    @IBOutlet weak var txtAntiBiotic: PEFormTextfield!
    @IBOutlet weak var actionMinus: UIButton!
    @IBOutlet weak var actionAdd: UIButton!
    
    // MARK: - VARIABLES
    
    var addCompletion:((_ error: String?) -> Void)?
    var minusCompletion:((_ error: String?) -> Void)?
    var dTypeCompletion:((_ error: String?) -> Void)?
    var cSizeCompletion:((_ error: String?) -> Void)?
    var switchCompletion:((_ status: Bool?) -> Void)?
    var txtAntiBioticCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var subTitle: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtAntiBiotic.delegate = self
        txtAntiBiotic.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        
    }
    
    // MARK: - IB ACTIONS

    @IBAction func minusTapped(_ sender: Any) {
        minusCompletion?(nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addCompletion?(nil)
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        if switchHatchery.isOn {
            switchCompletion?(true)
            showAntiBioticTextView()
            
        } else {
            switchCompletion?(false)
            hideAntiBioticTextView()
        }
    }
    
    @IBAction func dTypeClicked(_ sender: Any) {
        dTypeCompletion?(nil)
    }
    
    @IBAction func cSizeClicked(_ sender: Any) {
        cSizeCompletion?(nil)
    }
    
    // MARK: - METHODS

    func setDropdownStartAsessmentBtn(imageName:String,btn:UIButton) {
        DispatchQueue.main.async {
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            btn.layer.borderWidth = 2.0
            let superviewCurrent =  self.superview
            for subview in superviewCurrent?.subviews ?? [] {
                if let img = subview as? UIImageView{
                    img.image = UIImage(named: imageName)
                }
            }
        }
    }
    
    func setGraddientAndLayerAntibioticTextView() {
        DispatchQueue.main.async {
            self.abTextView.backgroundColor = UIColor.white
            self.abTextView.layer.cornerRadius = 20
            self.abTextView.layer.masksToBounds = true
            self.abTextView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.abTextView.layer.borderWidth = 2.0
        }
    }
    
    func showAntiBioticTextView(){
        antiBioticTextView.isHidden = false
        abTextView.isHidden = false
        txtAntiBiotic.isHidden = false
    }
    
    func hideAntiBioticTextView(){
        antiBioticTextView.isHidden = true
        abTextView.isHidden = true
        txtAntiBiotic.isHidden = true
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField){
        txtAntiBioticCompletion?(textField.text)
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtAntiBioticCompletion?(textField.text)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
}

// MARK: - UISWITCH CLASS

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}

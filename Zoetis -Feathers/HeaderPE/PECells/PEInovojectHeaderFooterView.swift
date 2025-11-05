//
//  PETableviewHeaderFooterView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PEInovojectHeaderFooterView: UITableViewHeaderFooterView , UITextFieldDelegate{
    
    // MARK: - OUTLETS

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btn1: customButton!
    @IBOutlet weak var switchHatchery: UISwitchCustom!
    @IBOutlet weak var btn2: customButton!
    @IBOutlet weak var actionMinus: UIButton!
    @IBOutlet weak var actionAdd: UIButton!
    @IBOutlet weak var txtDType: PEFormTextfield!
    @IBOutlet weak var txtCSize: PEFormTextfield!
    @IBOutlet weak var antiBioticTextView: UIView!
    @IBOutlet weak var abTextView: UIView!
    @IBOutlet weak var txtAntiBiotic: PEFormTextfield!
    
    // MARK: - VARIABLES

    var subTitle: String?
    var addCompletion:((_ error: String?) -> Void)?
    var minusCompletion:((_ error: String?) -> Void)?
    var dTypeCompletion:((_ error: String?) -> Void)?
    var cSizeCompletion:((_ error: String?) -> Void)?
    var switchCompletion:((_ status: Bool?) -> Void)?
    var txtAntiBioticCompletion:((_ txtAntiBiotic: String?) -> Void)?
    
    // MARK: - METHODS

    override func awakeFromNib() {
        super.awakeFromNib()
        txtAntiBiotic.delegate = self
    }
    
    func setDropdownStartAsessmentBtn(imageName:String,btn:UIButton) {
        
        DispatchQueue.main.async {
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            btn.layer.borderWidth = 2.0
            let superviewCurrent =  self.superview
            if superviewCurrent != nil && superviewCurrent?.subviews.count ?? 0 > 0 {
                for subview in superviewCurrent!.subviews {
                    if let img = subview as? UIImageView{
                        img.image = UIImage(named: imageName)
                    }
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
    
    // MARK: - IB ACTIONS
    
    @IBAction func minusTapped(_ sender: Any) {
        minusCompletion?(nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addCompletion?(nil)
    }
    
    @IBAction func dTypeClicked(_ sender: Any) {
        dTypeCompletion?(nil)
    }
    
    @IBAction func cSizeClicked(_ sender: Any) {
        cSizeCompletion?(nil)
    }
    
    @IBAction func hatcheryClicked(_ sender: Any) {
        if switchHatchery.isOn {
            switchCompletion?(true)
            showAntiBioticTextView()
            
        } else {
            switchCompletion?(false)
            hideAntiBioticTextView()
        }
        
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

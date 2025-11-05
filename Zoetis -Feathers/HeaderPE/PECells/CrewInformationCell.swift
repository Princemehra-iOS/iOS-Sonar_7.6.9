//
//  CrewInformationCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class CrewInformationCell: UITableViewCell , UITextFieldDelegate {
    
    // MARK: - OUTLETS

    @IBOutlet weak var btnDate: customButton!
    @IBOutlet weak var btnName: customButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var nameTF: PEFormTextfield!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateTxt: PEFormTextfield!
    @IBOutlet weak var selectedDate: customButton!
    
    // MARK: - VARIABLES

    var dateClickedCompletion:((_ error: String?) -> Void)?
    var nameCompletion:((_ error: String?) -> Void)?
    var beginEditingCompletion:((_ str: String?) -> Void)?
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateTxt.delegate = self
        nameTF.delegate = self
        btnDate.setDropdownStartAsessmentView(imageName:"calendarIconPE")
        btnName.setDropdownStartAsessmentView(imageName:"")
        nameTF.delegate = self
        gradientView.setGradient(topGradientColor: UIColor.getGradientUpperColorStartAssessmentMid(), bottomGradientColor: UIColor.getGradientLowerColor())
        // Initialization code
    }
    
    
    func config(data:PECertificateData){
        self.nameTF.text = data.name
        self.dateTxt.text = data.certificateDate as? String ?? ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // MARK: - IBACTIONS

    @IBAction func dateClicked(_ sender: Any) {
        dateClickedCompletion?(nil)
        
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameCompletion?(textField.text)
        //   print("TextField did end editing method called\(textField.text!)")
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

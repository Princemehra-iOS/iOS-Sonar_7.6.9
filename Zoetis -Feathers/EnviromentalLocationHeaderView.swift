//
//  EnviromentalLocationHeaderView.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 13/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

protocol EnviromentalLocationHeaderViewDelegates: class {
    func addLocationButtonPressed(_ view: EnviromentalLocationHeaderView)
    func std20ButtonPressed(_ view: EnviromentalLocationHeaderView)
    func stdButtonPressed(_ view: EnviromentalLocationHeaderView)
    func std40ButtonPressed(_ view: EnviromentalLocationHeaderView)
    func deleteLocationButtonPressed(_ view: EnviromentalLocationHeaderView)
    func checkBoxButtonPressed(_ view: EnviromentalLocationHeaderView)
    func locationTypeButtonPressed(_ view: EnviromentalLocationHeaderView)
    func plusButtonPressed(_ view: EnviromentalLocationHeaderView)
    func minusButtonPressed(_ view: EnviromentalLocationHeaderView)
    func collapsableButtonPressed(_ view: EnviromentalLocationHeaderView)
    func generatePlateIdButtonPressed(_ view: EnviromentalLocationHeaderView)
    func textFieldDidEndEditingForHeader(_ view: EnviromentalLocationHeaderView, _ textField: UITextField)
}

class EnviromentalLocationHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sampleInfoTitleContainerView: GradientView!
    @IBOutlet weak var sampleInfoTitleContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sampleInfoTitleContainerViewTop: NSLayoutConstraint!
    @IBOutlet weak var sampleInfoTitleLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var deleteLocationButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var locationTypelabel: UILabel!
    @IBOutlet weak var locationTypeButton: customButton!
    @IBOutlet weak var locationTypeTextField: UITextField!
    
    @IBOutlet weak var noOfPlatesLabel: UILabel!
    @IBOutlet weak var noOfPlatesTextField: UITextField!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var noOfPlatesButton: customButton!
    
    @IBOutlet weak var generatePlateIdButton: UIButton!
    @IBOutlet weak var platesTitleView: UIView!
    @IBOutlet weak var locationTypeContainerView: GradientView!
    @IBOutlet weak var locationTypeContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backgrounfView: GradientView!
    
    @IBOutlet weak var collapsableButton: GradientButton1!
    
    @IBOutlet weak var btnsStackView: UIStackView!
    @IBOutlet weak var btnStd20: GradientButton1!
    @IBOutlet weak var btnStd40: GradientButton1!
    @IBOutlet weak var btnStd: GradientButton1!
    weak var delegate: EnviromentalLocationHeaderViewDelegates?
    
    
    @IBAction func addLocationButtonPressed(_ sender: UIButton) {
        self.delegate?.addLocationButtonPressed(self)
    }
    
    @IBAction func deleteLocationButtonPressed(_ sender: UIButton) {
        self.delegate?.deleteLocationButtonPressed(self)
    }
    
    @IBAction func checkBoxButtonPressed(_ sender: UIButton) {
        self.delegate?.checkBoxButtonPressed(self)
    }
    
    @IBAction func locationTypeButtonPressed(_ sender: UIButton) {
        self.delegate?.locationTypeButtonPressed(self)
    }

    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        self.delegate?.plusButtonPressed(self)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        self.delegate?.minusButtonPressed(self)
    }
    
    @IBAction func collapsableButtonPressed(_ sender: UIButton) {
        self.delegate?.collapsableButtonPressed(self)
    }
    
    @IBAction func generatePlateId(_ sender: Any) {
        self.delegate?.generatePlateIdButtonPressed(self)
    }
    @IBAction func std20ButtonEvent(_ sender: UIButton) {
        self.delegate?.std20ButtonPressed(self)
    }
    
    @IBAction func std40BtnEvent(_ sender: UIButton) {
        self.delegate?.std40ButtonPressed(self)
    }
    
    @IBAction func stdBtnEvent(_ sender: UIButton) {
        self.delegate?.stdButtonPressed(self)
    }
}


//MARK: - Text field delegates
extension EnviromentalLocationHeaderView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //   print("Working")
        self.delegate?.textFieldDidEndEditingForHeader(self, textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        
        if noOfPlatesTextField == textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: newString)) else {
                return false
            }
            return textField.text!.count < 3 || string == ""
        }
        return true
    }
}

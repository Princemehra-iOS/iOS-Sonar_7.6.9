//
//  PVEVaccineInfoDetailsCellSection3.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 24/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation

//1. delegate method
protocol VaccineInfoDetailsMinusBtnDelegate: AnyObject {
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, Str: String , fieldType:String)
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, serialStr: String)
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, vacNameStr: String)
    func updateVaccineInfoDetailsArrInDB(currentIndPath: NSIndexPath, noteStr: String)
    
}

class PVEVaccineInfoDetailsCell: UITableViewCell {
    
    weak var delegate: VaccineInfoDetailsMinusBtnDelegate?
    var currentIndPath = NSIndexPath()
    
    let sharedManager = PVEShared.sharedInstance
    
    @IBOutlet weak var vacManView: UIView!
    @IBOutlet weak var vacManBtn: UIButton!
    @IBOutlet weak var vacManTxtFld: UITextField!
    
    @IBOutlet weak var vacNameView: UIView!
    @IBOutlet weak var vacNameBtn: UIButton!
    @IBOutlet weak var vacNameTxtFld: UITextField!
    @IBOutlet weak var vacNameDropIcon: UIImageView!
    
    @IBOutlet weak var otherAntigenView: UIView!
    @IBOutlet weak var otherAntigenBtn: UIButton!
    @IBOutlet weak var otherAntigenTxtFld: UITextField!
    @IBOutlet weak var otherTempGrayBtn: UIButton!
    
    @IBOutlet weak var serotypeView: UIView!
    @IBOutlet weak var serotypeBtn: UIButton!
    @IBOutlet weak var serotypeTxtFld: UITextField!
    
    @IBOutlet weak var serialView: UIView!
    @IBOutlet weak var serialBtn: UIButton!
    @IBOutlet weak var serialTxtFld: UITextField!
    
    @IBOutlet weak var expiryDatView: UIView!
    @IBOutlet weak var expiryBtn: UIButton!
    @IBOutlet weak var expiryTxtFld: UITextField!
    
    @IBOutlet weak var siteOfInjView: UIView!
    @IBOutlet weak var siteOfInjBtn: UIButton!
    @IBOutlet weak var siteOfInjTxtFld: UITextField!
    
    @IBOutlet weak var notetxtView: UITextView!
    @IBOutlet weak var showMoreBtn: UIButton!
    
    
    func refreshFramess(frame:CGRect) {
        
        if  vacManTxtFld.text == ""{
            self.sharedManager.setBorderRedForMandatoryFiels(forBtn: vacManBtn)
        }
        if  vacNameTxtFld.text == ""{
            self.sharedManager.setBorderRedForMandatoryFiels(forBtn: vacNameBtn)
        }
        if  serotypeTxtFld.text == ""{
            self.sharedManager.setBorderRedForMandatoryFiels(forBtn: serotypeBtn)
        }
        
    }
    
    func refreshAntigenView(str:String){
        if str.lowercased() == "other" {
             otherAntigenBtn.isUserInteractionEnabled = false
             otherAntigenTxtFld.isUserInteractionEnabled = true
             otherAntigenBtn.backgroundColor = .white
             otherAntigenTxtFld.placeholder = "Enter"
         } else {
             otherAntigenBtn.isUserInteractionEnabled = false
             otherAntigenTxtFld.isUserInteractionEnabled = false
             otherAntigenBtn.backgroundColor = .lightGray
             otherAntigenTxtFld.placeholder = ""
         }
    }
    
    func refreshVacNameField(){
        
        if vacManTxtFld.text  == "Other"{
            vacNameBtn.isUserInteractionEnabled = false
            vacNameTxtFld.isUserInteractionEnabled = true
            vacNameDropIcon.isHidden = true
        }else{
            vacNameBtn.isUserInteractionEnabled = true
            vacNameTxtFld.isUserInteractionEnabled = false
            vacNameDropIcon.isHidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let btns = [vacManBtn,vacNameBtn,serotypeBtn,serialBtn,expiryBtn,siteOfInjBtn]
        for btn in btns{
            
            let superviewCurrent =  btn?.superview
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    if view == expiryBtn{
                        view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
                    } else{
                        view.setDropdownStartAsessmentView(imageName:"dd")
                    }
                }
            }
        }
        
        notetxtView.textContainerInset = .init(top: 13, left: 0, bottom: 0, right: 0)
        notetxtView.textContainer.lineFragmentPadding = 18
        notetxtView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notetxtView.layer.borderWidth = 2.0;
        
        
        showMoreBtn.backgroundColor = .getTextViewBorderColorStartAssessment()
        showMoreBtn.layer.cornerRadius = 20
        showMoreBtn.layer.borderWidth = 2.0
        showMoreBtn.layer.borderColor = UIColor.clear.cgColor
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}

extension PVEVaccineInfoDetailsCell: UITextFieldDelegate{
    
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
    
    fileprivate func extractedFunc(_ newString: String) {
        if newString.count > 0 {
            delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, Str: newString, fieldType: "otherAntigen")
        }else{
            delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, Str: "", fieldType: "otherAntigen")
        }
    }
    
    fileprivate func extractedFunc1(_ newString: String) {
        self.sharedManager.setBorderBlue(btn: serialBtn)
        
        if newString.count > 0 {
            delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, serialStr: newString)
            
        } else {
            delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, serialStr: "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if textField == vacNameTxtFld {
            if newString.count > 40 {
                return false
            }
            if newString.count > 0 {
                self.sharedManager.setBorderBlue(btn: vacNameBtn)
                delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, vacNameStr: newString)
            } else {
                delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, vacNameStr: "")
            }
            
        } else if textField == otherAntigenTxtFld {
            if newString.count > 40{
                return false
            }
            extractedFunc(newString)
            
        } else if textField == serialTxtFld {
            
            if newString.count > 40 {
                return false
            }
            
            extractedFunc1(newString)
        }
        return true
    }
}


extension PVEVaccineInfoDetailsCell: UITextViewDelegate {
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }else{
            let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
            
            if newString.count > 0 {
                delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, noteStr: newString)
            }else{
                delegate?.updateVaccineInfoDetailsArrInDB(currentIndPath: currentIndPath, noteStr: "")
            }
        }
        return true
    }
    
    
}


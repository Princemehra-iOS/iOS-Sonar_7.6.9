//
//  PVEVaccineInformationCellSection0.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 24/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

class PVEVaccineInfoTypeCell: UITableViewCell {
    
    let sharedManager = PVEShared.sharedInstance
    @IBOutlet weak var contractImg : UIImageView!
    @IBOutlet weak var companyImg : UIImageView!
    
    @IBOutlet weak var serologyBtn: UIButton!
    @IBOutlet weak var crewLeaderBtn: UIButton!
    
    @IBOutlet weak var serologyViewForFreeHousing: UIView!
    @IBOutlet weak var farmHousePickerForFreeHousing: UIView!
    @IBOutlet weak  var serologyForFreeTxtField : UITextField!
    
    @IBOutlet weak var serologySelUnSelectImg : UIImageView!
    @IBOutlet weak  var crewLeaderTxtField : UITextField!
    @IBOutlet weak  var crewLeaderEmailTxtField : UITextField!
    @IBOutlet weak var numberOfCatcherTextField : UITextField!
    @IBOutlet weak  var companyRepNameTxtField : UITextField!
    @IBOutlet weak  var companyRepEmailTxtField : UITextField!
    @IBOutlet weak var numberOfVacconatorsTextField : UITextField!

    var isComesFromDraft: Bool = false
    var timeStampStr = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let crewLeaderBtn = crewLeaderBtn, let superview = crewLeaderBtn.superview {
            for view in superview.subviews {
                if view.isKind(of: UIButton.self), view == crewLeaderBtn {
                    view.setDropdownStartAsessmentView(imageName: "dd")
                }
            }
        }
        
        refreshRadioButton()
    }
    
    func refreshFreeSerologyBtnState() {
        var isFreeSerology = Bool()
        if timeStampStr.count > 0 {
            isFreeSerology = getDraftValueForKey(key: "isFreeSerology") as! Bool
        } else {
            isFreeSerology = sharedManager.getSessionValueForKeyFromDB(key: "isFreeSerology") as! Bool
        }
        
        serologySelUnSelectImg.image = isFreeSerology == false ? UIImage(named: "uncheckIconPE") : UIImage(named: "checkIconPE")
    }
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: timeStampStr)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    func refreshRadioButton() {
        var selectedVaccineInfoType = String()
        if timeStampStr.count > 0{
            selectedVaccineInfoType = getDraftValueForKey(key: "cat_selectedVaccineInfoType") as! String
        }else{
            selectedVaccineInfoType = sharedManager.getSessionValueForKeyFromDB(key: "cat_selectedVaccineInfoType") as! String
        }
        contractImg.image = selectedVaccineInfoType == "contract" ? UIImage(named: "radioActive") : UIImage(named: "radioInactive")
        companyImg.image = selectedVaccineInfoType == "contract" ? UIImage(named: "radioInactive") : UIImage(named: "radioActive")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func contractBtnAction(_ sender: Any) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: "contract", forAttribute: "cat_selectedVaccineInfoType")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: "contract", forAttribute: "cat_selectedVaccineInfoType")
        }
        refreshRadioButton()
        
    }
    @IBAction func companyBtnAction(_ sender: Any) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: "company", forAttribute: "cat_selectedVaccineInfoType")
        }else{
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: "company", forAttribute: "cat_selectedVaccineInfoType")
            
        }
        refreshRadioButton()
    }
    
    
}


extension PVEVaccineInfoTypeCell: UITextFieldDelegate{
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Restrict non-numeric input for mobile number fields
        if [numberOfCatcherTextField, numberOfVacconatorsTextField].contains(textField),
           !CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Character limit checks
        if [numberOfCatcherTextField, numberOfVacconatorsTextField].contains(textField), newString.count > 4 {
            return false
        }
        if [crewLeaderTxtField, crewLeaderEmailTxtField, companyRepNameTxtField, companyRepEmailTxtField].contains(textField),
           newString.count > 40 {
            return false
        }
        
        // Define attribute mapping
        let attributeMapping: [UITextField: String] = [
            crewLeaderTxtField: "cat_crewLeaderName",
            crewLeaderEmailTxtField: "cat_crewLeaderEmail",
            numberOfCatcherTextField: "cat_NoOfCatchersDetailsArr",
            companyRepNameTxtField: "cat_companyRepName",
            companyRepEmailTxtField: "cat_companyRepEmail",
            numberOfVacconatorsTextField: "cat_NoOfVaccinatorsDetailsArr"
        ]
        if textField == numberOfVacconatorsTextField {
            if isComesFromDraft == true {
                CoreDataHandlerPVE().updateArrayInfoFor("", text: newString, forAttribute: "cat_NoOfVaccinatorsDetailsArr", entityName: "PVE_Sync")
             
            } else {
                
                CoreDataHandlerPVE().updateArrayInfoFor("", text: newString, forAttribute: "cat_NoOfVaccinatorsDetailsArr", entityName: "PVE_Session")
            }
            
        }
        if textField == numberOfCatcherTextField {
            if isComesFromDraft == true {
                CoreDataHandlerPVE().updateArrayInfoFor("", text: newString, forAttribute: "cat_NoOfCatchersDetailsArr", entityName: "PVE_Sync")
            } else {
                CoreDataHandlerPVE().updateArrayInfoFor("", text: newString, forAttribute: "cat_NoOfCatchersDetailsArr", entityName: "PVE_Session")
            }
        }
        // Save data if the field is mapped
        if let attribute = attributeMapping[textField] {
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString, forAttribute: attribute)
            } else {
                CoreDataHandlerPVE().updateSessionDetails(1, text: newString, forAttribute: attribute)
            }
        }
        
        return true
    }
}

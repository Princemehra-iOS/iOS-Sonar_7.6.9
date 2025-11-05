//
//  StartNewAssignmentNoteCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 16/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

class StartNewAssignmentCell: UITableViewCell {
    
    let sharedManager = PVEShared.sharedInstance
    var timeStampStr = ""
    
    @IBOutlet weak var cameraImg: UIImageView!
    
    @IBOutlet weak var evaluationDateBtn: UIButton!
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var accManagerBtn: UIButton!
    @IBOutlet weak var breedOfBirdsBtn: UIButton!
    @IBOutlet weak var housingBtn: UIButton!
    @IBOutlet weak var evaluationForBtn: UIButton!
    @IBOutlet weak var siteIdBtn: UIButton!
    @IBOutlet weak var evaluatorBtn: UIButton!
    @IBOutlet weak var ageOfBirdsBtn: UIButton!
    
    @IBOutlet weak var breedOfBirdsOtherBtn: UIButton!
    @IBOutlet weak var breedOfBirdsFemaleBtn: UIButton!
    @IBOutlet weak var breedOfBirdsOtherTxtfield: UITextField!
    @IBOutlet weak var breedOfBirdsFemaleTxtfield: UITextField!
    @IBOutlet weak var breedOfBirdsFemaleOtherBtn: UIButton!
    @IBOutlet weak var breedOfBirdsFemaleOtherTxtfield: UITextField!
    
    
    @IBOutlet weak var evaluationDateTxtfield: UITextField!
    @IBOutlet weak var customerTxtfield: UITextField!
    @IBOutlet weak var accManagerTxtfield: UITextField!
    @IBOutlet weak var breedOfBirdsTxtfield: UITextField!
    @IBOutlet weak var housingTxtfield: UITextField!
    @IBOutlet weak var evaluationForTxtfield: UITextField!
    @IBOutlet weak var siteIdTxtfield: UITextField!
    @IBOutlet weak var evaluatorTxtfield: UITextField!
    @IBOutlet weak var ageOfBirdsTxtfield: UITextField!
    
    @IBOutlet weak var farmNameBtn: UIButton!
    @IBOutlet weak var farmNameTxtfield: UITextField!
    @IBOutlet weak var houseNoBtn: UIButton!
    @IBOutlet weak var houseNoTxtfield: UITextField!
    @IBOutlet weak var noOfBirdsBtn: UIButton!
    @IBOutlet weak var noOfBirdsTxtfield: UITextField!
    
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var birdWelfareImg : UIImageView!
    @IBOutlet weak var birdPresentationImg : UIImageView!
    @IBOutlet weak var cameraToggleSuperView: UIView!
    @IBOutlet weak var breesOfBirdsSuperView: UIView!
    @IBOutlet weak var farmNameSuperView: UIView!
    
    @IBOutlet weak var breesOfBirdsTitleLbl: UILabel!
    @IBOutlet weak var breesOfBirdsMaleOtherSuperView: UIView!
    @IBOutlet weak var breesOfBirdsFemaleOtherSuperView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let btns = [evaluationDateBtn,accManagerBtn,breedOfBirdsBtn,housingBtn,evaluationForBtn,evaluatorBtn,ageOfBirdsBtn,farmNameBtn,houseNoBtn,noOfBirdsBtn, breedOfBirdsOtherBtn, breedOfBirdsFemaleBtn, breedOfBirdsFemaleOtherBtn]
        for btn in btns{
            
            let superviewCurrent =  btn?.superview
            for view in superviewCurrent!.subviews {
                if view.isKind(of:UIButton.self) {
                    if view == evaluationDateBtn{
                        view.setDropdownStartAsessmentView(imageName:"calendarIconPE")
                    } else{
                        view.setDropdownStartAsessmentView(imageName:"dd")
                    }
                }
            }
        }
        
    }
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: timeStampStr)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    func selectButton(){
        var selectedBirdTypeId = Int()
        
        if timeStampStr.count > 0 {
            selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId") as! Int
        }else{
            selectedBirdTypeId = sharedManager.getSessionValueForKeyFromDB(key: "selectedBirdTypeId") as! Int
        }
        if selectedBirdTypeId == 14 {
            birdWelfareImg.image = UIImage(named: "checkIconPE")
            birdPresentationImg.image = UIImage(named: "uncheckIconPE")
        }else{
            birdWelfareImg.image = UIImage(named: "uncheckIconPE")
            birdPresentationImg.image = UIImage(named: "checkIconPE")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        var cameraBtnSelected = String()
        if sender.isOn == true {
            cameraBtnSelected = "true"
        }else{
            cameraBtnSelected = "false"
        }
        
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: cameraBtnSelected, forAttribute: "cameraEnabled")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: cameraBtnSelected, forAttribute: "cameraEnabled")
        }
    }
    
    
    @IBAction func birdWelfareBtnAction(_ sender: UIButton) {
        
        birdWelfareImg.image = UIImage(named: "checkIconPE")
        birdPresentationImg.image = UIImage(named: "uncheckIconPE")
        
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: 14, forAttribute: "selectedBirdTypeId")
            CoreDataHandlerPVE().updateStatusForSync(timeStampStr, text: false, forAttribute: "syncedStatus")
            
        }else{
            
            CoreDataHandlerPVE().updateSessionDetails(1, text: 14, forAttribute: "selectedBirdTypeId")
        }
        
    }
    
    @IBAction func birdPresentationBtnAction(_ sender: UIButton) {
        
        birdWelfareImg.image = UIImage(named: "uncheckIconPE")
        birdPresentationImg.image = UIImage(named: "checkIconPE")
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: 13, forAttribute: "selectedBirdTypeId")
            CoreDataHandlerPVE().updateStatusForSync(timeStampStr, text: false, forAttribute: "syncedStatus")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: 13, forAttribute: "selectedBirdTypeId")
        }
    }
}

extension StartNewAssignmentCell: UITextFieldDelegate{
    
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
    
 
    
    fileprivate func handleHouseNoTxtfield(_ newString: String) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString ?? "", forAttribute: "houseNumber")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: newString ?? "", forAttribute: "houseNumber")
        }
    }
    
    fileprivate func handleNoOfBirdsTxtfield(_ newString: String) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "noOfBirds")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "noOfBirds")
        }
        self.sharedManager.setBorderBlue(btn: noOfBirdsBtn)
    }
    
    fileprivate func handleBreedOfBirdsOtherTxtfield(_ newString: String) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString ?? "", forAttribute: "breedOfBirdsOther")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: newString ?? "", forAttribute: "breedOfBirdsOther")
        }
        self.sharedManager.setBorderBlue(btn: breedOfBirdsOtherBtn)
    }
    
    fileprivate func handleBreedOfBirdsFemaleOtherTxtfield(_ newString: String) {
        if timeStampStr.count > 0 {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString ?? "", forAttribute: "breedOfBirdsFemaleOther")
        }else{
            CoreDataHandlerPVE().updateSessionDetails(1, text: newString ?? "", forAttribute: "breedOfBirdsFemaleOther")
        }
        self.sharedManager.setBorderBlue(btn: breedOfBirdsFemaleOtherBtn)
    }
    
    fileprivate func validateAgeOfBirdsTxtfield(_ textField: UITextField, _ newString: String) {
        if textField == ageOfBirdsTxtfield {
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: Int(newString) ?? 0, forAttribute: "ageOfBirds")
            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: Int(newString) ?? 0, forAttribute: "ageOfBirds")
            }
            self.sharedManager.setBorderBlue(btn: ageOfBirdsBtn)
        }
    }
    
    fileprivate func handleAgeOfBirdsTextField(_ sum: Int, _ newString: inout String) -> Bool {
        if sum == 0 && newString.count > 0 {
            newString = "0"
            return false
        } else {
            return true
        }
    }
    
    fileprivate func handleFarmNameTxtfield(_ newString: String) -> Bool {
        return newString.count <= 40
    }
    
    fileprivate func handleAgeOfBirdsAndNoOfBirds(_ newString: String) -> Bool {
        if newString.count > 5 {
            return false
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Numeric-only fields with max 5 digits and no all-zero values
        if [ageOfBirdsTxtfield, noOfBirdsTxtfield].contains(textField) {
            return handleNumericTextField(textField, newString: newString, input: string)
        }
        
        switch textField {
        case farmNameTxtfield:
            return handleFarmNameField(newString)
            
        case houseNoTxtfield:
            return handleGenericTextField(newString, maxLength: 40) {
                handleHouseNoTxtfield(newString)
                sharedManager.setBorderBlue(btn: houseNoBtn)
            }
            
        case noOfBirdsTxtfield:
            handleNoOfBirdsTxtfield(newString)
            return true
            
        case breedOfBirdsOtherTxtfield:
            return handleGenericTextField(newString, maxLength: 40) {
                handleBreedOfBirdsOtherTxtfield(newString)
            }
            
        case breedOfBirdsFemaleOtherTxtfield:
            return handleGenericTextField(newString, maxLength: 40) {
                handleBreedOfBirdsFemaleOtherTxtfield(newString)
            }
            
        default:
            return true
        }
    }
    
    private func handleNumericTextField(_ textField: UITextField, newString: String, input: String) -> Bool {
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: input)) else {
            return false
        }
        
        guard newString.count <= 5 else {
            return false
        }
        
        let sum = newString.compactMap { $0.wholeNumberValue }.reduce(0, +)
        if sum == 0 && !newString.isEmpty {
            return false
        }
        
        updateAgeOrNoOfBirds(for: textField, with: newString)
        return true
    }

    private func handleFarmNameField(_ newString: String) -> Bool {
        let isValid = handleFarmNameTxtfield(newString)
        if isValid {
            CoreDataHandlerPVE().updateSessionDetails(1, text: newString, forAttribute: "farm")
            sharedManager.setBorderBlue(btn: farmNameBtn)
        }
        return isValid
    }

    private func handleGenericTextField(_ newString: String, maxLength: Int, update: () -> Void) -> Bool {
        guard newString.count <= maxLength else { return false }
        update()
        return true
    }

    private func updateAgeOrNoOfBirds(for textField: UITextField, with newString: String) {
        let value = Int(newString) ?? 0
        let attribute: String
        let button: UIButton
        
        if textField == ageOfBirdsTxtfield {
            attribute = "ageOfBirds"
            button = ageOfBirdsBtn
        } else {
            attribute = "noOfBirds"
            button = noOfBirdsBtn
        }
        
        if !timeStampStr.isEmpty {
            CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: value, forAttribute: attribute)
        } else {
            CoreDataHandlerPVE().updateSessionDetails(1, text: value, forAttribute: attribute)
        }
        
        sharedManager.setBorderBlue(btn: button)
    }
    
}

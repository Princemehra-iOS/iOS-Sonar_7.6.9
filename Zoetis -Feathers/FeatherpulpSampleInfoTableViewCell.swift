//
//  FeatherpulpSampleInfoTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 21/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol FeatherpulpSampleInfoTableViewCellProtocol{
    func textFieldShouldBeginEditing(textFieldType: UITextField)
}

class FeatherpulpSampleInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceTestCollectionView: UICollectionView!
    @IBOutlet weak var enterNoOfPlatesTextField: UITextField!
    @IBOutlet weak var ageWeeksTextField: UITextField!
    @IBOutlet weak var farmeEnterNameTextField: UITextField!
    @IBOutlet weak var ageDaysTextField: UITextField!
    @IBOutlet weak var specimenTypeTextField: UITextField!
    @IBOutlet weak var spimenTypeDropdownButton: UIButton!
    
    let padding = CGFloat(5.0)
    let collectionViewCellIdentifier = "FeatherpulpSampleInfoTestCollectionViewCell"
    let borderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
    let cornerRadius = CGFloat(18.0)
    var delegate : FeatherpulpSampleInfoTableViewCellProtocol?
    var arrTestOptions = [MicrobialFeatherpulpServiceTestSampleInfo]()
    var timeStamp = ""
    var textFieldActionShouldStartEditingBlock: ((_ textField: UITextField) -> Void)? = nil
    var textFieldActionDidEndEditingBlock: ((_ textField: UITextField) -> Void)? = nil
    var specimentDropDownBtnAction: ((_ textField: UITextField) -> Void)? = nil
    var sessionType : REQUISITION_SAVED_SESSION_TYPE = .SHOW_DRAFT_FOR_EDITING
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAttributes(){
        self.ageDaysTextField.setLeftPaddingPoints(padding)
        self.ageDaysTextField.setRightPaddingPoints(padding)
        self.ageDaysTextField.layer.cornerRadius = cornerRadius
        self.ageDaysTextField.layer.borderWidth = 1.0
        self.ageDaysTextField.layer.borderColor = borderColor
        self.ageDaysTextField.delegate = self
        
        self.enterNoOfPlatesTextField.setLeftPaddingPoints(padding)
        self.enterNoOfPlatesTextField.setRightPaddingPoints(padding)
        self.enterNoOfPlatesTextField.layer.cornerRadius = cornerRadius
        self.enterNoOfPlatesTextField.layer.borderWidth = 1.0
        self.enterNoOfPlatesTextField.layer.borderColor = borderColor
        self.enterNoOfPlatesTextField.delegate = self
        
        self.ageWeeksTextField.setLeftPaddingPoints(padding)
        self.ageWeeksTextField.setRightPaddingPoints(padding)
        self.ageWeeksTextField.layer.cornerRadius = cornerRadius
        self.ageWeeksTextField.layer.borderWidth = 1.0
        self.ageWeeksTextField.layer.borderColor = borderColor
        self.ageWeeksTextField.delegate = self
        
        self.farmeEnterNameTextField.setLeftPaddingPoints(padding)
        self.farmeEnterNameTextField.setRightPaddingPoints(padding)
        self.farmeEnterNameTextField.layer.cornerRadius = cornerRadius
        self.farmeEnterNameTextField.layer.borderWidth = 1.0
        self.farmeEnterNameTextField.layer.borderColor = borderColor
        self.farmeEnterNameTextField.delegate = self
        
        self.specimenTypeTextField.setLeftPaddingPoints(padding)
        self.specimenTypeTextField.setRightPaddingPoints(padding)
        self.specimenTypeTextField.layer.cornerRadius = cornerRadius
        self.specimenTypeTextField.layer.borderWidth = 1.0
        self.specimenTypeTextField.layer.borderColor = borderColor
        self.specimenTypeTextField.delegate = self
        self.specimenTypeTextField.inputView = UIView()
        
        self.serviceTestCollectionView.delegate = self
        self.serviceTestCollectionView.dataSource = self
        self.serviceTestCollectionView.register(UINib(nibName: "FeatherpulpSampleInfoTestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
        self.unableDisableAccordingToSessionType()
    }
    
    func unableDisableAccordingToSessionType(){
        switch  self.sessionType{
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.ageDaysTextField.isEnabled = false
            self.enterNoOfPlatesTextField.isEnabled = false
            self.ageWeeksTextField.isEnabled = false
            self.farmeEnterNameTextField.isEnabled = false
            self.specimenTypeTextField.isEnabled = false

        default: break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func specimenBtnAction(_ sender: UIButton) {
        self.specimentDropDownBtnAction?(self.specimenTypeTextField)
    }
}


extension FeatherpulpSampleInfoTableViewCell: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldActionShouldStartEditingBlock?(textField)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.ageDaysTextField, self.ageWeeksTextField, self.enterNoOfPlatesTextField:
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldActionDidEndEditingBlock?(textField)
    }
}


extension FeatherpulpSampleInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrTestOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as? FeatherpulpSampleInfoTestCollectionViewCell
        cell?.checkboxButton.setTitle(self.arrTestOptions[indexPath.row].testType, for: .normal)
        let btnCheckImg = UIImage(named: self.arrTestOptions[indexPath.row].isCheckBoxSelected!.boolValue ? "checkIcon" : "uncheckIcon")
        cell?.checkboxButton.setImage(btnCheckImg, for: .normal)
        cell?.checkboxButton.isEnabled = !(self.sessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY)
        cell?.textCheckUncheckAction = {
            if let isSelected = self.arrTestOptions[indexPath.row].isCheckBoxSelected{
                if isSelected.boolValue{
                    self.arrTestOptions[indexPath.row].isCheckBoxSelected = false
                }else{
                    self.arrTestOptions[indexPath.row].isCheckBoxSelected = true
                }
                let predicate = NSPredicate(format: "timeStamp = %@ && testId = %d", argumentArray: [self.timeStamp, self.arrTestOptions[indexPath.row].testId])
                MicrobialFeatherpulpServiceTestSampleInfo.updateBoolTypesTestOptions(key: "isCheckBoxSelected", value: self.arrTestOptions[indexPath.row].isCheckBoxSelected!.boolValue, predicate: predicate)
            }
            self.serviceTestCollectionView.reloadData()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 , height: collectionView.frame.size.height)
    }
}

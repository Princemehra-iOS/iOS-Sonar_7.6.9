//
//  BacterialFormCell.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 03/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol BacterialFormCellDelegates: class {
    func reasonForVisitButtonPressed_Bacterial(_ cell: BacterialFormCell)
    func companyButtonPressed_Bacterial(_ cell: BacterialFormCell)
    func siteButtonPressed_Bacterial(_ cell: BacterialFormCell)
    func reviewerButtonPressed_Bacterial(_ cell: BacterialFormCell)
    func sampleDateButtonPressed_Bacterial(_ cell: BacterialFormCell)
    
    func barcode_bacterial(cell: BacterialFormCell, activeTextField: UITextField)
    func noteEntered_Bacterial(cell: BacterialFormCell, activeTextView: UITextView)
}


class BacterialFormCell: UITableViewCell {
    
    @IBOutlet weak var requestorTextFieldContainerView: GradientView!
    @IBOutlet weak var reasonForVisitButton: customButton!
    @IBOutlet weak var companyButton: customButton!
    @IBOutlet weak var siteButton: customButton!
    @IBOutlet weak var sampleDateButton: customButton!
    @IBOutlet weak var barcodeButton: customButton!
    
    @IBOutlet weak var requestorTextField: UITextField!
    @IBOutlet weak var reasonForVisitTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var sampleDateTextField: UITextField!
    
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var requisitionSavedSessionType = REQUISITION_SAVED_SESSION_TYPE.CREATE_NEW_SESSION
    weak var delegate: BacterialFormCellDelegates?
    var defaultBorderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noteTextView.delegate = self
        self.configureCell()
    }
    
    func disableAllEvents(){
        
        if requisitionSavedSessionType == .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY {
            reasonForVisitButton.isUserInteractionEnabled = false
            companyButton.isUserInteractionEnabled = false
            siteButton.isUserInteractionEnabled = false
            sampleDateButton.isUserInteractionEnabled = false
            barcodeButton.isUserInteractionEnabled = false
            companyTextField.isUserInteractionEnabled = false
            siteTextField.isUserInteractionEnabled = false
            sampleDateTextField.isUserInteractionEnabled = false
            barcodeTextField.isUserInteractionEnabled = false
            noteTextView.isUserInteractionEnabled = false
        }
    }
    
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureCell() {
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        requestorTextField.text = firstName
        
        self.requestorTextField.isUserInteractionEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func reasonForVisitButtonPressed(_ sender: UIButton) {
        self.delegate?.reasonForVisitButtonPressed_Bacterial(self)
    }
        
    @IBAction func companyButtonPressed(_ sender: UIButton) {
        self.delegate?.companyButtonPressed_Bacterial(self)
    }
    
    @IBAction func siteButtonPressed(_ sender: UIButton) {
        self.delegate?.siteButtonPressed_Bacterial(self)
    }
    
    @IBAction func reviewerButtonPressed(_ sender: UIButton) {
        self.delegate?.reviewerButtonPressed_Bacterial(self)
    }
    
    @IBAction func sampleDateButtonPressed(_ sender: UIButton) {
        self.delegate?.sampleDateButtonPressed_Bacterial(self)
    }
    
    func configureMandatoryFiledsValidation(_ header: LocationTypeHeaderModel,
                                            isSubmitButtonPressed: Bool,
                                            currentSessionInProgressModel: RequisitionModel) {
        
        if (header.isPlusButtonPressed || isSubmitButtonPressed) && currentSessionInProgressModel.company.isEmpty {
            self.companyButton.layer.borderColor = UIColor.red.cgColor
        } else {
            self.companyButton.layer.borderColor = defaultBorderColor
        }
        
        if (header.isPlusButtonPressed || isSubmitButtonPressed) && currentSessionInProgressModel.site.isEmpty {
            self.siteButton.layer.borderColor = UIColor.red.cgColor
        } else {
            self.siteButton.layer.borderColor = defaultBorderColor
        }
        
        if (header.isPlusButtonPressed || isSubmitButtonPressed) && currentSessionInProgressModel.barCode == "B-" {
            self.barcodeButton.layer.borderColor = UIColor.red.cgColor
        } else {
            self.barcodeButton.layer.borderColor = defaultBorderColor
        }

    }
    
}

//MARK: - TextField and TextView delegates
extension BacterialFormCell: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.barcode_bacterial(cell: self, activeTextField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.noteEntered_Bacterial(cell: self, activeTextView: textView)
    }
}

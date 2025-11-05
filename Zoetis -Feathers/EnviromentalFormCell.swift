//
//  EnviromentalFormCell.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 13/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol EnviromentalFormCellDelegates: AnyObject {
    func reasonForVisitButtonPressed(_ cell: EnviromentalFormCell)
    func sampleCollectedPressed(_ cell: EnviromentalFormCell)
    func companyButtonPressed(_ cell: EnviromentalFormCell)
    func siteButtonPressed(_ cell: EnviromentalFormCell)
    func reviewerButtonPressed(_ cell: EnviromentalFormCell)
    func surveyConductedButtonPressed(_ cell: EnviromentalFormCell)
    func sampleDateButtonPressed(_ cell: EnviromentalFormCell)
    func purposeOfSurveyButtonPressed(_ cell: EnviromentalFormCell)
    func transferInButtonPressed(_ cell: EnviromentalFormCell)
    func emailEntered(cell: EnviromentalFormCell, activeTextField: UITextField)
    func noteEntered(cell: EnviromentalFormCell, activeTextView: UITextView)
}

class EnviromentalFormCell: UITableViewCell {

    @IBOutlet weak var requestorTextFieldContainerView: GradientView!
    @IBOutlet weak var reasonForVisitButton: customButton!
    @IBOutlet weak var sampleCollectedByButton: customButton!
    @IBOutlet weak var companyButton: customButton!
    @IBOutlet weak var siteButton: customButton!
    @IBOutlet weak var emailButton: customButton!
    @IBOutlet weak var surveyConductedButton: customButton!
    @IBOutlet weak var sampleDateButton: customButton!
    @IBOutlet weak var purposeOfSurveyButton: customButton!
    @IBOutlet weak var barcodeButton: customButton!
    
    @IBOutlet weak var requestorTextField: UITextField!
    @IBOutlet weak var reasonForVisitTextField: UITextField!
    @IBOutlet weak var sampleCollectedByText: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var surveyConductedTextField: UITextField!
    @IBOutlet weak var sampleDateTextField: UITextField!
    @IBOutlet weak var purposeOfSurveyTextField: UITextField!
    @IBOutlet weak var transferInTextField: UITextField!
    @IBOutlet weak var transferInButton: customButton!
    
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    var requisitionSavedSessionType = REQUISITION_SAVED_SESSION_TYPE.CREATE_NEW_SESSION
    weak var enviromentalFormCellDelegates: EnviromentalFormCellDelegates?
    var defaultBorderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noteTextView.delegate = self
        self.configureCell()
    }
    
    func disableAllEvents() {
        switch requisitionSavedSessionType {
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            reasonForVisitButton.isUserInteractionEnabled = false
            sampleCollectedByButton.isUserInteractionEnabled = false
            companyButton.isUserInteractionEnabled = false
            siteButton.isUserInteractionEnabled = false
            surveyConductedButton.isUserInteractionEnabled = false
            sampleDateButton.isUserInteractionEnabled = false
            purposeOfSurveyButton.isUserInteractionEnabled = false
            sampleDateTextField.isUserInteractionEnabled = false
            barcodeTextField.isUserInteractionEnabled = false
            barcodeButton.isUserInteractionEnabled = false
            
            requestorTextField.isUserInteractionEnabled = false
            reasonForVisitTextField.isUserInteractionEnabled = false
            sampleCollectedByText.isUserInteractionEnabled = false
            companyTextField.isUserInteractionEnabled = false
            siteTextField.isUserInteractionEnabled = false
            surveyConductedTextField.isUserInteractionEnabled = false
            sampleDateTextField.isUserInteractionEnabled = false
            purposeOfSurveyTextField.isUserInteractionEnabled = false
//            transferInTextField.isUserInteractionEnabled = false
//            transferInButton.isUserInteractionEnabled = false
            
            barcodeTextField.isUserInteractionEnabled = false
            noteTextView.isUserInteractionEnabled = false
            
            
        default: break
        }
    }
    
    func configureCell() {
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        requestorTextField.text = firstName
        sampleCollectedByText.text = firstName
        //reviewerTextField.text = firstName
        
        self.requestorTextField.isUserInteractionEnabled = false
        self.sampleCollectedByText.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func reasonForVisitButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.reasonForVisitButtonPressed(self)
    }
    
    @IBAction func sampleCollectedButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.sampleCollectedPressed(self)
    }
    
    @IBAction func companyButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.companyButtonPressed(self)
    }
    
    @IBAction func siteButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.siteButtonPressed(self)
    }
    
    @IBAction func surveyConductedButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.surveyConductedButtonPressed(self)
    }
    
    @IBAction func sampleDateButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.sampleDateButtonPressed(self)
    }
    
    
    @IBAction func purposeOfSurveyButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.purposeOfSurveyButtonPressed(self)
    }
    @IBAction func transferInButtonPressed(_ sender: UIButton) {
        self.enviromentalFormCellDelegates?.transferInButtonPressed(self)
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
        
        if (header.isPlusButtonPressed || isSubmitButtonPressed) && currentSessionInProgressModel.barCode == "E-" {
            self.barcodeButton.layer.borderColor = UIColor.red.cgColor
        } else {
            self.barcodeButton.layer.borderColor = defaultBorderColor
        }
    }
}

//MARK: - TextField and TextView delegates
extension EnviromentalFormCell: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.enviromentalFormCellDelegates?.emailEntered(cell: self, activeTextField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.enviromentalFormCellDelegates?.noteEntered(cell: self, activeTextView: textView)
    }
}



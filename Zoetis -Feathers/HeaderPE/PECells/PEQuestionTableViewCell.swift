//
//  PEQuestionTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 25/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit






class PEQuestionTableViewCell: UITableViewCell , UITextFieldDelegate{
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var questionDistanceFromSwitch: NSLayoutConstraint! // 10
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblQCCount: UILabel!
    @IBOutlet weak var txtFldWidth: NSLayoutConstraint!
    @IBOutlet weak var txtQCCount: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var btnImageCount: UIButton!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var cameraBTn: UIButton!
    @IBOutlet weak var assessmentLbl: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var maximumMarksLabel: UILabel!
    @IBOutlet weak var lbl_NA: UILabel!
    @IBOutlet weak var btn_NA: UIButton!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var txtFrequency: PEFormTextfield!
    @IBOutlet weak var viewFrequency: UIView!
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var txtPersonName: PEFormTextfield!
    @IBOutlet weak var viewPersonName: UIView!
    
    @IBOutlet weak var requiredComntBtn: UIButton!
    
    
    let amPmStr = "AM/PM Value *"
    let ppmValStr = "PPM Value *"
    // MARK: - VARIABLES
    var lastPPMText : String?
    var ppmText : String?
    var completion:((_ status: Bool?, _ error: String?) -> Void)?
    var cameraCompletion:((_ error: String?) -> Void)?
    var commentCompletion:((_ error: String?) -> Void)?
    var imagesCompletion:((_ error: String?) -> Void)?
    var infoCompletion:((_ error: String?) -> Void)?
    var txtQCCountCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var txtAMPMCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var txtNamePersonCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var txtFrequencyCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var btnFrequencyClickedCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var assessmentProgress : PE_AssessmentInProgress?
    var btnInventoryClickedCompletion:((_ txtAntiBiotic: String?) -> Void)?
    var btnNA:(()-> Void)?
    
    var txtPPMCompletion:((_ txtAntiBiotic: String?) -> Void)?
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - INITIAL METHODS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtQCCount.delegate = self
        txtPersonName.delegate = self
        txtFrequency.delegate = self
        txtQCCount.keyboardType = .default
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - METHODS
    
    func setControls(controlType: String?) {
        switch controlType {
        case "Drop Value": do{
            switchBtn.isHidden = false
        }
        case "Text": do{
            switchBtn.isHidden = true
        }
        default:
            
            break
        }
        
    }
    
    func setGraddientAndLayerQcCountextFieldView() {
        DispatchQueue.main.async {
            self.textFieldView.backgroundColor = UIColor.white
            self.textFieldView.layer.cornerRadius = 20
            self.textFieldView.layer.masksToBounds = true
            self.textFieldView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.textFieldView.layer.borderWidth = 2.0
            
            self.viewFrequency.backgroundColor = UIColor.white
            self.viewFrequency.layer.cornerRadius = 20
            self.viewFrequency.layer.masksToBounds = true
            self.viewFrequency.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.viewFrequency.layer.borderWidth = 2.0
            
            self.viewPersonName.backgroundColor = UIColor.white
            self.viewPersonName.layer.cornerRadius = 20
            self.viewPersonName.layer.masksToBounds = true
            self.viewPersonName.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
            self.viewPersonName.layer.borderWidth = 2.0
            
            
            
            
            
        }
    }
    
    func hideFrequencyFields()  {
        lblFrequency.isHidden = true
        lblPersonName.isHidden = true
        viewFrequency.isHidden = true
        viewPersonName.isHidden = true
        
        
    }
    func showFrequencyFields()  {
        lblFrequency.isHidden = false
        lblPersonName.isHidden = false
        viewFrequency.isHidden = false
        viewPersonName.isHidden = false
        
    }
    
    
    func showQcCountextField()  {
        hideFrequencyFields()
        lblQCCount.isHidden = false
        lblQCCount.text = "QC Count *"
        questionDistanceFromSwitch.constant = 290
        textFieldView.isHidden = false
        txtQCCount.placeholder = "QC Count"
        txtFldWidth.constant = 160
        txtQCCount.isHidden = false
        
    }
    
    func hideQcCountextField()  {
        hideFrequencyFields()
        lblQCCount.isHidden = true
        lblQCCount.text = "QC Count *"
        txtQCCount.placeholder = "QC Count"
        questionDistanceFromSwitch.constant = 10
        textFieldView.isHidden = true
        txtFldWidth.constant = 0
        txtQCCount.isHidden = true
        
    }
    
    func showAMPMValuetextField()  {
        hideFrequencyFields()
        lblQCCount.isHidden = false
        lblQCCount.text = amPmStr
        questionDistanceFromSwitch.constant = 290
        textFieldView.isHidden = false
        txtQCCount.placeholder = "AM/PM Value"
        txtFldWidth.constant = 160
        txtQCCount.isHidden = false
    }
    
    func showPPMField() {
        hideFrequencyFields()
        lblQCCount.isHidden = false
        lblQCCount.text = ppmValStr
        questionDistanceFromSwitch.constant = 290
        textFieldView.isHidden = false
        txtQCCount.placeholder = "PPM Value"
        txtFldWidth.constant = 160
        txtQCCount.isHidden = false
    }
    
    func hidePPMfield() {
        hideFrequencyFields()
        lblQCCount.isHidden = true
        lblQCCount.text = ppmValStr
        txtQCCount.placeholder = "PPM Value"
        questionDistanceFromSwitch.constant = 10
        textFieldView.isHidden = true
        txtFldWidth.constant = 0
        txtQCCount.isHidden = true
        
    }
    
    func hideAMPMValuetextField()  {
        
        hideFrequencyFields()
        lblQCCount.isHidden = true
        lblQCCount.text = amPmStr
        txtQCCount.placeholder = "AM/PM Value"
        questionDistanceFromSwitch.constant = 10
        textFieldView.isHidden = true
        txtFldWidth.constant = 0
        txtQCCount.isHidden = true
        
        
    }
    
    func showFrequencytextField()  {
        showFrequencyFields()
        lblQCCount.isHidden = true
        txtQCCount.isHidden = true
        questionDistanceFromSwitch.constant = 290
        textFieldView.isHidden = true
        txtFldWidth.constant = 160
        txtQCCount.isHidden = true
        
    }
    
    @IBAction func inventorybtnClicked(_ sender: Any) {
        btnInventoryClickedCompletion?(nil)
    }
    
    @IBAction func na_BtnClicked(_ sender: Any) {
        btnNA?()
    }
    @IBAction func frequencyBtnClicked(_ sender: Any) {
        btnFrequencyClickedCompletion?(nil)
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        infoCompletion?(nil)
    }
    
    @IBAction func imagesCountClicked(_ sender: Any) {
        imagesCompletion?(nil)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        completion?(sender.isOn,nil)
    }
        
    @IBAction func commentClicked(_ sender: Any) {
        commentCompletion?(nil)
    }
    
    @IBAction func cameraBtnCLicked(_ sender: Any) {
        print(appDelegateObj.testFuntion())
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        cameraCompletion?(nil)
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtQCCount {
            if lblQCCount.text == amPmStr{
                txtAMPMCompletion?(textField.text)
            }
            else if lblQCCount.text == ppmValStr{
                
                if ppmText != textField.text{
                    ppmText = textField.text
                    txtPPMCompletion?(textField.text)
                }
                else
                {
                    if textField.text == "" {
                        Constants.isPPmValueChanged = false
                    }
                }
            }
            else {
                txtQCCountCompletion?(textField.text)
            }
        }
        if textField == txtPersonName {
            txtNamePersonCompletion?(textField.text)
        }
        
        if textField == txtFrequency {
            txtFrequencyCompletion?(textField.text)
            
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //   print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //   print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //   print("TextField should end editing method called")
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtQCCount {
            var maxLength = 0
            if lblQCCount.text == ppmValStr
            {
                maxLength = 4
            }
            else
            {
                maxLength = 255
            }
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length <= maxLength {
                return true
            } else {
                return false
            }
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
}



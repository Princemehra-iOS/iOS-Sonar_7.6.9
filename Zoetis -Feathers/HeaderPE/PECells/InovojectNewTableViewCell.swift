//
//  InovojectNewTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 17/09/20.
//

import UIKit

class InovojectNewTableViewCell: UITableViewCell , UITextFieldDelegate {
    
    // MARK: - OUTLETS

    @IBOutlet weak var programNameVw: UIView!
    @IBOutlet weak var diluentManufacturerVw: UIView!
    @IBOutlet weak var otherVw: UIView!
    @IBOutlet weak var bagSizeVw: UIView!
    @IBOutlet weak var hatcheryAntibioticsSwitch: UISwitch!
    @IBOutlet weak var vaccineNameVw: UIView!
    @IBOutlet weak var ampuleSizeVw: UIView!
    @IBOutlet weak var hatcheryAntibiotisVw: UIView!
    @IBOutlet weak var ampulePerBagVw: UIView!
    @IBOutlet weak var dosageVw: UIView!
    @IBOutlet weak var hatcheryAntibioticsConstraint: NSLayoutConstraint!//120
    @IBOutlet weak var othersConstraint: NSLayoutConstraint!//130
    @IBOutlet weak var othersLblConstraint: NSLayoutConstraint!//52
    @IBOutlet weak var tfVaccineMan: PEFormTextfield!
    @IBOutlet weak var tfAmpleSize: PEFormTextfield!
    @IBOutlet weak var tfAmpleBag: PEFormTextfield!
    @IBOutlet weak var tfBagSize: PEFormTextfield!
    @IBOutlet weak var tfDosage: PEFormTextfield!
    @IBOutlet weak var tfDiluentManu: PEFormTextfield!
    @IBOutlet weak var tfProgramName: PEFormTextfield!
    @IBOutlet weak var tfAntibioticText: PEFormTextfield!
    @IBOutlet weak var tfOtherManText: PEFormTextfield!
    @IBOutlet weak var otherManuView: UIView!
    @IBOutlet weak var antiBioView: UIView!
    
    
    @IBOutlet weak var vaccineNameBtn: UIButton!
    @IBOutlet weak var bagsizeBtn: UIButton!
    
    // MARK: - VARIABLES

    var vaccineManufacturerCompletion:((_ string: String?) -> Void)?
    var ampleSizeCompletion:((_ string: String?) -> Void)?
    var bagSizeCompletion:((_ string: String?) -> Void)?
    var ampleSizeTypeCompletion:((_ string: String?) -> Void)?
    var doseCompletion:((_ string: String?) -> Void)?
    var amplePerBagCompletion:((_ string: String?) -> Void)?
    var diluentManuCompletion:((_ string: String?) -> Void)?
    var nameCompletion:((_ string: String?) -> Void)?
    var programCompletion:((_ string: String?) -> Void)?
    var antibioticCompletion:((_ string: String?) -> Void)?
    var switchCompletion:((_ string: String?) -> Void)?
    var otherManCompletion:((_ string: String?) -> Void)?
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - METHODS

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfProgramName.delegate = self
        tfAntibioticText.delegate = self
        tfOtherManText.delegate = self
        setBordeViewWithColor(diluentManufacturerVw)
        setBordeViewWithColor(otherVw)
        setBordeViewWithColor(bagSizeVw)
        setBordeViewWithColor(vaccineNameVw)
        setBordeViewWithColor(ampuleSizeVw)
        setBordeViewWithColor(hatcheryAntibiotisVw)
        setBordeViewWithColor(ampulePerBagVw)
        setBordeViewWithColor(dosageVw)
        setBordeViewWithColor(programNameVw
        )
        
    }
    
    func setBordeViewWithColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
    }
    func showOthersConstraint(){
        otherManuView.isHidden = false
        othersConstraint.constant = 130
        othersLblConstraint.constant = 52
    }
    
    func hideOthersConstraint(){
        otherManuView.isHidden = true
        othersConstraint.constant = 0
        othersLblConstraint.constant = 0
    }
    
    func showHatcheryAnitibiotics(){
        antiBioView.isHidden = false
        
        hatcheryAntibioticsConstraint.constant = 120
    }
    
    func hideHatcheryAntibiotics(){
        antiBioView.isHidden = true
        
        hatcheryAntibioticsConstraint.constant = 0
    }
    
    
    func config(data:InovojectData){
        if data.invoHatchAntibiotic == 1 {
            hatcheryAntibioticsSwitch.setOn(true, animated: false)
        } else {
            hatcheryAntibioticsSwitch.setOn(false, animated: false)
        }
        
        tfDiluentManu.text = data.vaccineMan
        tfVaccineMan.text = data.name
        tfAmpleSize.text = data.ampuleSize
        tfAmpleBag.text = data.ampulePerBag
        tfBagSize.text = data.bagSizeType
        tfDosage.text = data.dosage
        tfProgramName.text = data.invoProgramName
        tfAntibioticText.text = data.invoHatchAntibioticText
        tfOtherManText.text = data.doaDilManOther
        
    }
    
    // MARK: - IBACTIONS

    @IBAction func switchClicked(_ sender: Any) {
        
        if hatcheryAntibioticsSwitch.isOn{
            showHatcheryAnitibiotics()
            switchCompletion?("on")
            
        } else{
            hideHatcheryAntibiotics()
            switchCompletion?("")
            
        }
    }
    
    
    @IBAction func diluentManufacturerBtn(_ sender: UIButton) {
        diluentManuCompletion?("")
    }
    
    
    @IBAction func bagSizeAction(_ sender: UIButton) {
        bagSizeCompletion?("")
    }
        
    @IBAction func vaccineNameBtnAction(_ sender: UIButton) {
        nameCompletion?("")
    }
    
    
    @IBAction func ampuleSizeBtnAction(_ sender: UIButton) {
        ampleSizeCompletion?("")
    }
    
    @IBAction func ampulePerBagBtnAction(_ sender: UIButton) {
        
        amplePerBagCompletion?("")
    }
    
    
    @IBAction func dosageBtnAction(_ sender: UIButton) {
        print("dosageBtnAction")
        
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfProgramName{
            programCompletion?(textField.text)
        }
        if textField == tfAntibioticText{
            antibioticCompletion?(textField.text)
        }
        if textField == tfOtherManText {
            
            otherManCompletion?(textField.text)
        }
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

//
//  InovojectCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 08/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class InovojectCell: UITableViewCell , UITextFieldDelegate {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var btnDosage: customButton!
    @IBOutlet weak var imgDD: UIImageView!
    @IBOutlet weak var viewVaccineMan: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewAmpleSize: UIView!
    @IBOutlet weak var viewAmpleBag: UIView!
    @IBOutlet weak var viewBagSize: UIView!
    @IBOutlet weak var viewDosage: UIView!
    @IBOutlet weak var viewDiluentManufacturer: UIView!
    @IBOutlet weak var vaccineDD: UIImageView!
    @IBOutlet weak var btnVaccineName: customButton!
    @IBOutlet weak var gradientVIew: UIView!
    @IBOutlet weak var tfVaccineMan: PEFormTextfield!
    @IBOutlet weak var tfName: PEFormTextfield!
    @IBOutlet weak var tfAmpleSize: PEFormTextfield!
    @IBOutlet weak var tfAmpleBag: PEFormTextfield!
    @IBOutlet weak var tfBagSize: PEFormTextfield!
    @IBOutlet weak var tfDosage: PEFormTextfield!
    @IBOutlet weak var tfDiluentManu: PEFormTextfield!
    
    
    @IBOutlet weak var ampuleSizeBtn: UIButton!
    @IBOutlet weak var dosageBtn: UIButton!
    
    // MARK: - VARIABLES
    
    var vaccineManufacturerCompletion:((_ string: String?) -> Void)?
    var ampleSizeCompletion:((_ string: String?) -> Void)?
    var ampleSizeTypeCompletion:((_ string: String?) -> Void)?
    var doseCompletion:((_ string: String?) -> Void)?
    var amplePerBagCompletion:((_ string: String?) -> Void)?
    var diluentManuCompletion:((_ string: String?) -> Void)?
    var nameCompletion:((_ string: String?) -> Void)?
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - METHODS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let btnArray = [viewVaccineMan,viewName,viewAmpleSize,viewAmpleBag,viewBagSize,viewDosage,viewDiluentManufacturer]
        
        for item in btnArray{
            if item != nil {
                for view in item!.subviews {
                    if view.isKind(of:UIButton.self) {
                        
                        view.setDropdownStartAsessmentView(imageName:"dd")
                        
                    }
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func hideVaccineBtn(){
        tfName.isUserInteractionEnabled = true
        btnVaccineName.isUserInteractionEnabled = false
        vaccineDD.isHidden = true
    }
    func showVaccineBtn(){
        tfName.isUserInteractionEnabled = false
        btnVaccineName.isUserInteractionEnabled = true
        vaccineDD.isHidden = false
    }
    
    func config(data:InovojectData,isDayOfAge:Bool? = false){
        tfVaccineMan.text = data.vaccineMan
        tfName.text = data.name
        
        if tfVaccineMan.text == "Other"{
            self.hideVaccineBtn()
        } else {
            self.showVaccineBtn()
        }
        
        
        tfAmpleSize.text = data.ampuleSize
        tfAmpleBag.text = data.ampulePerBag
        tfBagSize.text = data.bagSizeType
        tfDosage.text = data.dosage
        tfDiluentManu.text = data.dilute
        if isDayOfAge == true {
            imgDD.isHidden = false
            btnDosage.isUserInteractionEnabled = true
            tfDosage.isUserInteractionEnabled = false
        } else {
            imgDD.isHidden = true
            btnDosage.isUserInteractionEnabled = true
            tfDosage.isUserInteractionEnabled = false
            
        }
        
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func actnVaccineMan(_ sender: Any) {
        vaccineManufacturerCompletion?("")
        
    }
    
    @IBAction func actnAmpleSize(_ sender: Any) {
        ampleSizeCompletion?("")
    }
    
    @IBAction func actnAmpleBag(_ sender: Any) {
        amplePerBagCompletion?("")
    }
    
    @IBAction func actnBagSize(_ sender: Any) {
        ampleSizeTypeCompletion?("")
    }
    
    @IBAction func actnDosage(_ sender: Any) {
        doseCompletion?("")
    }
    
    
    @IBAction func actnDilManu(_ sender: Any) {
        diluentManuCompletion?("")
        
    }
    
    @IBAction func nameClicked(_ sender: Any) {
        nameCompletion?("")
    }
    
    // MARK: - TEXTFIELD DELEGATES
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameCompletion?(textField.text)
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

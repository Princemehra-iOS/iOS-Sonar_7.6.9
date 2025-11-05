//
//  AddEmployeeTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 10/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit

class AddEmployeeTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var startDateTxtFld: UITextField!
    @IBOutlet weak var startDateVw: UIView!
    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var firstnameDropdownVw: UIView!
    @IBOutlet weak var middleNameVw: UIView!
    @IBOutlet weak var lastNameVw: UIView!
    @IBOutlet weak var ampulePerBagVw: UIView!
    @IBOutlet weak var certlangVw: UIView!
    @IBOutlet weak var tShirtSizeVw: UIView!
    @IBOutlet weak var dropdownFirstNameImgVw: UIImageView!
    @IBOutlet weak var textFldFirstnameTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var startDateImgVw: UIImageView!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var middleNameTxtFld: UITextField!
    @IBOutlet weak var lastnameTxtFld: UITextField!
    @IBOutlet weak var ampulePerBagTxtFld: UITextField!
    @IBOutlet weak var tShirtSizeTxtFld: UITextField!
    @IBOutlet weak var languageTxtFld: UITextField!
    @IBOutlet weak var roleBtn: UIButton!
    @IBOutlet weak var langBtn: UIButton!
    @IBOutlet weak var tShirtBtn: UIButton!
    
    // MARK: - VARIABLES
    
    static let identifier =  "addEmployeeTableViewCell"
    var currentEmployeeIbj:VaccinationEmployeeVM?
    var index = -1
    var showRedFieldsValidation = false
    var languageCompletion:((_ string: String?) -> Void)?
    var tShirtCompletion:((_ string: String?) -> Void)?
    var rolesCompletion:((_ string: String?) -> Void)?
    var startDateCompletion:((_ string: String?) -> Void)?
    var initialLoad = true
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    
    // MARK: - UI AND OTHER METHODS
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if initialLoad{
            setBorderUI()
            initialLoad = false
        }
    }
    
    func enableOrDisable(flag:Bool) {
        firstNameTxtFld.isEnabled = flag
        middleNameTxtFld.isEnabled = flag
        lastnameTxtFld.isEnabled = flag
        ampulePerBagTxtFld.isEnabled = flag
        tShirtSizeTxtFld.isEnabled = flag
        languageTxtFld.isEnabled = flag
        startDateTxtFld.isEnabled = flag
        langBtn.isUserInteractionEnabled = flag
        tShirtBtn.isUserInteractionEnabled = flag
    }
    
    func setValues(employee: VaccinationEmployeeVM){
        firstNameTxtFld.text = employee.firstName
        middleNameTxtFld.text = employee.middleName
        lastnameTxtFld.text = employee.lastName
        ampulePerBagTxtFld.text = employee.selectedRolesStr
        tShirtSizeTxtFld.text = employee.selectedTshirtValue
        languageTxtFld.text = employee.selectedLangValue
        currentEmployeeIbj = employee
        startDateTxtFld.text = CodeHelper.sharedInstance.convertDateFormater(employee.startDate ?? "")
        if showRedFieldsValidation{
            changeMandatoryFieldsBorder()
        }
        //StartDate.Text = Date formatter
    }
    
    func setBorderUI(){
        setBorderView(firstnameDropdownVw)
        setBorderView(middleNameVw)
        setBorderView(lastNameVw)
        setBorderView(ampulePerBagVw)
        setBorderView(certlangVw)
        setBorderView(tShirtSizeVw)
        setBorderView(startDateVw)
        
    }
    
    func hideDropdownImgVw(){
        dropdownFirstNameImgVw.isHidden = true
        textFldFirstnameTrailingConstraint.constant = 11//42
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorderUI()
        firstNameTxtFld.delegate = self
        middleNameTxtFld.delegate = self
        lastnameTxtFld.delegate = self
        ampulePerBagTxtFld.delegate = self
        tShirtSizeTxtFld.delegate = self
        languageTxtFld.delegate = self
        startDateTxtFld.delegate = self
        firstNameTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        middleNameTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        lastnameTxtFld.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField){
        currentEmployeeIbj?.selectedRolesStr = ampulePerBagTxtFld.text
        switch textField {
        case  firstNameTxtFld :
            currentEmployeeIbj?.firstName = firstNameTxtFld.text
            currentEmployeeIbj?.firstName = textField.text?.capitalizingFirstLetter()
            firstNameTxtFld.text = textField.text?.capitalizingFirstLetter()
            break;
            
        case middleNameTxtFld:
            currentEmployeeIbj?.middleName = middleNameTxtFld.text
            currentEmployeeIbj?.middleName = textField.text?.capitalizingFirstLetter()
            middleNameTxtFld.text = textField.text?.capitalizingFirstLetter()
            break;
            
        case lastnameTxtFld:
            currentEmployeeIbj?.lastName = lastnameTxtFld.text
            currentEmployeeIbj?.lastName = textField.text?.capitalizingFirstLetter()
            lastnameTxtFld.text = textField.text?.capitalizingFirstLetter()
            break;
            
        default:
            break;
        }
        if showRedFieldsValidation{
            changeMandatoryFieldsBorder()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddEmployeesVaccination"), object: nil, userInfo: ["index":index, "emp":currentEmployeeIbj])
    }
    
    func assignWhitebackgroundVw(){
        setBorderView(firstnameDropdownVw)
        setBorderView(startDateVw)
        setBorderView(middleNameVw)
        setBorderView(lastNameVw)
        setBorderView(ampulePerBagVw)
        setBorderView(certlangVw)
        setBorderView(tShirtSizeVw)
    }
    
    func assignBorderVw(){
        setBordeViewWithColor(startDateVw)
        
        setBordeViewWithColor(firstnameDropdownVw)
        setBordeViewWithColor(middleNameVw)
        setBordeViewWithColor(lastNameVw)
        setBordeViewWithColor(ampulePerBagVw)
        setBordeViewWithColor(certlangVw)
        setBordeViewWithColor(tShirtSizeVw)
    }
    
    func changeMandatoryFieldsBorder(){
        if currentEmployeeIbj != nil{
            changeFirstNameColor()
            changeLastNameColor()
            changeRolesColor()
            changeLangColor()
            changeTshirtColor()
        }
    }
    
    func changeFirstNameColor(){
        if currentEmployeeIbj?.firstName != nil && currentEmployeeIbj?.firstName?.removeWhitespace() !=  ""{
            setBordeViewWithColor(firstnameDropdownVw)
        }else{
            setRedBorderColor(firstnameDropdownVw)
        }
    }
    
    func changeLastNameColor(){
        if currentEmployeeIbj?.lastName != nil && currentEmployeeIbj?.lastName?.removeWhitespace() !=  ""{
            setBordeViewWithColor(lastNameVw)
        }else{
            setRedBorderColor(lastNameVw)
        }
    }
    
    func changeRolesColor(){
        if currentEmployeeIbj?.selectedRolesStr != nil && currentEmployeeIbj?.selectedRolesStr?.removeWhitespace() !=  ""{
            setBordeViewWithColor(ampulePerBagVw)
        }else{
            setRedBorderColor(ampulePerBagVw)
        }
    }
    
    func changeLangColor(){
        if currentEmployeeIbj?.selectedLangId != nil && currentEmployeeIbj?.selectedLangId.removeWhitespace() !=  ""{
            setBordeViewWithColor(certlangVw)
        }else{
            setRedBorderColor(certlangVw)
        }
    }
    
    func changeTshirtColor(){
        if currentEmployeeIbj?.selectedTshirtId != nil && currentEmployeeIbj?.selectedTshirtId?.removeWhitespace() !=  ""{
            setBordeViewWithColor(tShirtSizeVw)
        }else{
            setRedBorderColor(tShirtSizeVw)
        }
    }
    
    
    func setBorderView(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
        view.backgroundColor = UIColor.white
    }
    
    func setBordeViewWithColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.getBorderColorr().cgColor
        view.layer.cornerRadius = 18.5
    }
    
    func setRedBorderColor(_ view:UIView){
        view.layer.borderWidth  = 2
        view.layer.borderColor = UIColor.red.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func tShirtBtnAction(_ sender: UIButton) {
        sendData()
        tShirtCompletion?("")
    }
    
    @IBAction func languageBtnAction(_ sender: UIButton) {
        sendData()
        languageCompletion?("")
    }
    
    
    @IBAction func strtDateBtn(_ sender: UIButton) {
        startDateCompletion?("")
    }
    
    
    @IBAction func rolesBtnAction(_ sender: UIButton) {
        self.resignFirstResponder()
        rolesCompletion?("")
    }
    
}
// MARK: - EXTENSION

extension AddEmployeeTableViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sendData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && string == " " {
            return false
        }

        if textField.text?.last == " " && string == " " {
            return false
        }

        if string == " " {
            return true
        }

        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            return false
        }

        return true
    }
    
    func sendData(){
        if currentEmployeeIbj == nil{
            currentEmployeeIbj = VaccinationEmployeeVM()
        }
        
        currentEmployeeIbj?.firstName = firstNameTxtFld.text
        currentEmployeeIbj?.middleName = middleNameTxtFld.text
        currentEmployeeIbj?.lastName = lastnameTxtFld.text
        currentEmployeeIbj?.selectedRolesStr = ampulePerBagTxtFld.text
        if showRedFieldsValidation{
            changeMandatoryFieldsBorder()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddEmployeesVaccination"), object: nil, userInfo: ["index":index, "emp":currentEmployeeIbj])
    }
    
    
    
}

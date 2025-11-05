//
//  SetFrezzerPointCell.swift
//  Zoetis -Feathers
//
//  Created by ankur sangwan on 10/01/23.
//

import UIKit

class SetFrezzerPointCell: UITableViewHeaderFooterView,UITextFieldDelegate {

    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var valueTxtFld: UITextField!
    
    @IBOutlet weak var unitTxtFld: UITextField!
    var unitCompletion:((_ sende: UIButton?,_ txtFld: UITextField,_ textLabel: String) -> Void)?
    var valueCompletion:((_ sende: UITextField?,_ textLabel: String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTxtFld.delegate = self
    }

    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    @IBAction func action_Unit(_ sender: UIButton) {
        unitCompletion?(sender,unitTxtFld,"Frezzer")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      
        if(textField == self.valueTxtFld){
            valueCompletion?(textField, "Frezzer")
        }
        
            
        
    }
    func setGraddientAndLayerQcCountextFieldView() {
        DispatchQueue.main.async {
            self.unitView.backgroundColor = UIColor.white
            self.unitView.layer.cornerRadius = 20
            self.unitView.layer.masksToBounds = true
            self.unitView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.unitView.layer.borderWidth = 2.0
            self.valueView.backgroundColor = UIColor.white
            self.valueView.layer.cornerRadius = 20
            self.valueView.layer.masksToBounds = true
            self.valueView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.valueView.layer.borderWidth = 2.0
         }
    }
}

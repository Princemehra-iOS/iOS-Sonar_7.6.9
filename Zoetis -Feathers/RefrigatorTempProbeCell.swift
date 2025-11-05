//
//  RefrigatorTempProbeCell.swift
//  Zoetis -Feathers
//
//  Created by ankur sangwan on 03/01/23.
//

import UIKit

class RefrigatorTempProbeCell: UITableViewHeaderFooterView ,UITextFieldDelegate{

    @IBOutlet weak var mainTempUnit: UIView!
    
    @IBOutlet weak var main_UnitTextFld: PEFormTextfield!
   
    @IBOutlet weak var bottomValueTxtFld: UITextField!
    @IBOutlet weak var middleValueTxtFld: UITextField!
    @IBOutlet weak var topValueTxtFld: UITextField!
    @IBOutlet weak var topTxtFld: UITextField!
    @IBOutlet weak var middleTxtFld: UITextField!
    @IBOutlet weak var bottomTxtFld: UITextField!
    @IBOutlet weak var topUnitView: UIView!
    @IBOutlet weak var topValueView: UIView!
  
    @IBOutlet weak var middleUnitView: UIView!
    @IBOutlet weak var middleValueView: UIView!
    @IBOutlet weak var bottomUnitView: UIView!
    @IBOutlet weak var bottomValueView: UIView!
    var unitCompletion:((_ sende: UIButton?,_ txtFld: UITextField,_ textLabel: String) -> Void)?
    var valueCompletion:((_ sende: UITextField?,_ textLabel: String) -> Void)?
    var mainTempUnitCompletion:((_ sende: UIButton?,_ txtFld: UITextField,_ textLabel: String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        topValueTxtFld.delegate = self
        middleValueTxtFld.delegate = self
        bottomValueTxtFld.delegate = self
        // Initialization code
    }

  
    class var nib: UINib {        
        return UINib(nibName: identifier, bundle: nil)
    }
    class var identifier: String {
        return String(describing: self)
    }
    
   
  
    @IBAction func action_MainTemp(_ sender: UIButton) {
        mainTempUnitCompletion?(sender,main_UnitTextFld,"Main")
    }
    
    @IBAction func action_UnitTop(_ sender: UIButton) {
        unitCompletion?(sender,topTxtFld,"Top")
    }
   
    
    @IBAction func action_UnitMiddle(_ sender: UIButton) {
        unitCompletion?(sender,middleTxtFld,"Middle")
    }
    
    @IBAction func action_UnitBottom(_ sender: UIButton) {
        unitCompletion?(sender,bottomTxtFld,"Bottom")
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == self.topValueTxtFld){
            valueCompletion?(textField, "Top")
        }
        else if (textField == self.middleValueTxtFld){
            valueCompletion?(textField, "Middle")
        }
        else{
            valueCompletion?(textField, "Bottom")
        }
   }
    
    func setGraddientAndLayerQcCountextFieldView() {
        DispatchQueue.main.async {
            self.mainTempUnit.backgroundColor = UIColor.white
            self.mainTempUnit.layer.cornerRadius = 20
            self.mainTempUnit.layer.masksToBounds = true
            self.mainTempUnit.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.mainTempUnit.layer.borderWidth = 2.0
            
            
            self.topUnitView.backgroundColor = UIColor.white
            self.topUnitView.layer.cornerRadius = 20
            self.topUnitView.layer.masksToBounds = true
            self.topUnitView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.topUnitView.layer.borderWidth = 2.0
            
            
            self.topValueView.backgroundColor = UIColor.white
            self.topValueView.layer.cornerRadius = 20
            self.topValueView.layer.masksToBounds = true
            self.topValueView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.topValueView.layer.borderWidth = 2.0
            
            self.middleUnitView.backgroundColor = UIColor.white
            self.middleUnitView.layer.cornerRadius = 20
            self.middleUnitView.layer.masksToBounds = true
            self.middleUnitView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.middleUnitView.layer.borderWidth = 2.0
            
            self.middleValueView.backgroundColor = UIColor.white
            self.middleValueView.layer.cornerRadius = 20
            self.middleValueView.layer.masksToBounds = true
            self.middleValueView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.middleValueView.layer.borderWidth = 2.0
            
            self.bottomUnitView.backgroundColor = UIColor.white
            self.bottomUnitView.layer.cornerRadius = 20
            self.bottomUnitView.layer.masksToBounds = true
            self.bottomUnitView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.bottomUnitView.layer.borderWidth = 2.0
            
            self.bottomValueView.backgroundColor = UIColor.white
            self.bottomValueView.layer.cornerRadius = 20
            self.bottomValueView.layer.masksToBounds = true
            self.bottomValueView.layer.borderColor = UIColor.getTextViewBorderColorRefrigatorStartAssessment().cgColor
            self.bottomValueView.layer.borderWidth = 2.0
         }
    }
}

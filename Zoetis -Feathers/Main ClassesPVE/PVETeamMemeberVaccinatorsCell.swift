//
//  PVETeamMemeberNoOfVaccinatorsCellSection4.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 25/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol NoOfvaccinatorsMinusDelegate: AnyObject {
    func vaccinatorsbtnMinusTapped(clickedBtnIndPath: NSIndexPath)
    func updateVaccinatorsArrInDB(currentIndPath: NSIndexPath, nameStr: String, emailStr: String, mobileStr: String)
}

class PVETeamMemeberVaccinatorsCell: UITableViewCell {

    weak var delegate: NoOfvaccinatorsMinusDelegate?
    let sharedManager = PVEShared.sharedInstance
    var currentIndPath = NSIndexPath()
    
    @IBOutlet weak  var nameTxtField : UITextField!
    @IBOutlet weak  var emailTxtField : UITextField!
    @IBOutlet weak  var mobileTxtField : UITextField!

    @IBOutlet weak var serologyView: UIView!
    @IBOutlet weak var farmHousePickerView: UIView!

    @IBOutlet weak var serologyTxtFld: UITextField!
    @IBOutlet weak var serologyBtn: UIButton!
    @IBOutlet weak var serologySelUnSelectImg : UIImageView!
    @IBOutlet weak  var teamMemberTitleLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func btnMinusTapped(sender: AnyObject) {
        delegate?.vaccinatorsbtnMinusTapped(clickedBtnIndPath: currentIndPath)
    }
}


extension PVETeamMemeberVaccinatorsCell: UITextFieldDelegate{
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newString.count > 60{
            return false
        }

        if textField == nameTxtField{
            delegate?.updateVaccinatorsArrInDB(currentIndPath: currentIndPath, nameStr: newString, emailStr: "", mobileStr: "")
        }
        if textField == emailTxtField{
            delegate?.updateVaccinatorsArrInDB(currentIndPath: currentIndPath, nameStr: "", emailStr: newString, mobileStr: "")
        }
        if textField == mobileTxtField{
            delegate?.updateVaccinatorsArrInDB(currentIndPath: currentIndPath, nameStr: "", emailStr: "", mobileStr: newString)
        }
        return true
    }

}

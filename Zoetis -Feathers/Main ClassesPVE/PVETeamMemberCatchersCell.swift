//
//  PVETeamMemberNoOfCatchersCellSection2.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 25/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol NoOfCatchersMinusDelegate: AnyObject {
    func catchersbtnMinusTapped(clickedBtnIndPath: NSIndexPath)
    func updateCatchersArrInDB(currentIndPath: NSIndexPath, nameStr: String, emailStr: String, mobileStr: String)

}

class PVETeamMemberCatchersCell: UITableViewCell {

    weak var delegate: NoOfCatchersMinusDelegate?
    let sharedManager = PVEShared.sharedInstance
    var currentIndPath = NSIndexPath()

    @IBOutlet weak  var nameTxtField : UITextField!
    @IBOutlet weak  var emailTxtField : UITextField!
    @IBOutlet weak  var mobileTxtField : UITextField!

    @IBOutlet weak  var teamMemberTitleLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnMinusTapped(sender: AnyObject) {
        delegate?.catchersbtnMinusTapped(clickedBtnIndPath: currentIndPath)
    }
}


extension PVETeamMemberCatchersCell: UITextFieldDelegate{
    
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
            delegate?.updateCatchersArrInDB(currentIndPath: currentIndPath, nameStr: newString, emailStr: "", mobileStr: "")
        }
        if textField == emailTxtField{
            delegate?.updateCatchersArrInDB(currentIndPath: currentIndPath, nameStr: "", emailStr: newString, mobileStr: "")
        }
        if textField == mobileTxtField{
            delegate?.updateCatchersArrInDB(currentIndPath: currentIndPath, nameStr: "", emailStr: "", mobileStr: newString)
        }

   
        return true
    }

}

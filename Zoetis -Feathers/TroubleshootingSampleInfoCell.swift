//
//  TroubleshootingSampleInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 03/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol TroubleshootingSampleInfoCellDelegate {
    
     func noOfPlates(count: Int, clicked :Bool)
}

class TroubleshootingSampleInfoCell: UITableViewCell {
    
    var delegate: TroubleshootingSampleInfoCellDelegate? = nil
    
    @IBOutlet weak var noOfPlates: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func plusBtnAction(_ sender: UIButton) {
        guard let text =  noOfPlates.text  else {
            return
        }
       delegate?.noOfPlates(count: Int(text)!, clicked: true)
    }
}

extension TroubleshootingSampleInfoCell: UITextFieldDelegate{
    
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
        print(newString)
        //let tagg = self.tag as NSNumber
        
        return true
    }
    
}

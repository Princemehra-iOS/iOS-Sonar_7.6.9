//
//  NoOfVaccinatorsHeader.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 26/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol VaccinatorsPlusBtnDelegate: AnyObject {
    func vaccinatorPlusBtnTapped(count: Int)
    func vaccinatorMinusBtnTapped(count: Int)
}

class NoOfVaccinatorsHeader: UITableViewHeaderFooterView {

    weak var delegate: VaccinatorsPlusBtnDelegate?
    var currentIndPath = NSIndexPath()
    var numberr = Int()
    @IBOutlet weak var txtFeild : UITextField!
    @IBOutlet weak var headerImg : UIImageView!
    @IBOutlet weak var bgBtn : UIButton!

    let sharedManager = PVEShared.sharedInstance

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        numberr = noOfVaccinatorsArr.count
        txtFeild.text = "\(numberr)"

    }
    
    @IBAction func vaccinatorPlusBtnTapped(sender: AnyObject) {

        delegate?.vaccinatorPlusBtnTapped(count: numberr)
    }
    
    @IBAction func vaccinatorMinusBtnTapped(sender: AnyObject) {

        let noOfVaccinatorsArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfVaccinatorsDetailsArr") as? [[String : String]] ?? []
        
        delegate?.vaccinatorMinusBtnTapped(count: noOfVaccinatorsArr.count)
    }

}


extension NoOfVaccinatorsHeader: UITextFieldDelegate{
    
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
        
        guard CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        //let tagg = self.tag as NSNumber
        if newString.count > 0 {
            
            numberr = (newString as NSString).integerValue

        }
        return true
    }
    
}

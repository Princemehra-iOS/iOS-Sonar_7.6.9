//
//  NoOfCatchersHeader.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 26/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol CatchersPlusBtnDelegate: AnyObject {
    func catchersbtnPlusBtnTapped(count: Int)
    func catchersbtnMinusBtnTapped(count: Int)
}

class NoOfCatchersHeader: UITableViewHeaderFooterView {

    weak var delegate: CatchersPlusBtnDelegate?
    var currentIndPath = NSIndexPath()
    var numberr = Int()
    @IBOutlet weak var noOfCatchersTxtFeild : UITextField!
    @IBOutlet weak var headerImg : UIImageView!
    @IBOutlet weak var bgBtn : UIButton!


    let sharedManager = PVEShared.sharedInstance

    override func awakeFromNib() {
        super.awakeFromNib()
        let noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []
        numberr = noOfCatcherArr.count
        noOfCatchersTxtFeild.text = "\(numberr)"
        // Initialization code
    }

    
    @IBAction func catchersbtnPlusBtnTapped(sender: AnyObject) {

        delegate?.catchersbtnPlusBtnTapped(count: numberr)
    }
    
    @IBAction func catchersbtnMinusBtnTapped(sender: AnyObject) {
        //4. call delegate method
        //check delegate is not nil with `?`
        let noOfCatcherArr = sharedManager.getSessionValueForKeyFromDB(key: "cat_NoOfCatchersDetailsArr") as? [[String : String]] ?? []

        delegate?.catchersbtnMinusBtnTapped(count: noOfCatcherArr.count)
    }

}


extension NoOfCatchersHeader: UITextFieldDelegate{
    
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
        if newString.count > 0 {
            
            numberr = (newString as NSString).integerValue

        }
        return true
    }
    
}

//
//  BacterialCaseInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 30/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class BacterialCaseInfoCell: UITableViewCell
{
    
    
    @IBOutlet weak var requestorTxt: UITextField!
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var selectedCompanyTxt: UITextField!
    @IBOutlet weak var siteTxt: UITextField!
    @IBOutlet weak var siteBtn: UIButton!
    @IBOutlet weak var buttonForCornerRadius: customButton!
    @IBOutlet weak var reviewerBtn: UIButton!
    @IBOutlet weak var reviewerTxt: UITextField!
    @IBOutlet weak var sampleColletedByTxt: UITextField!
    @IBOutlet weak var sampleCollectedByBtn: UIButton!
    @IBOutlet weak var sampleCollectionDateBtn: UIButton!
    @IBOutlet weak var sampleCollectionDateBtn2: UIButton!
    @IBOutlet weak var sampleCollectionDateTxt: UITextField!
    @IBOutlet weak var barcodeTxt: UITextField!
    
    @IBOutlet weak var barcodeBtn: customButton!
    @IBOutlet weak var emailIdTxt: UITextField!
    @IBOutlet weak var emailIdButton: customButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension BacterialCaseInfoCell: UITextFieldDelegate{
    
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
        
        //Set Value in CoreData
        CoreDataHandlerMicro().updateRequestorBacterialServeyFormDetails(self.tag, text: newString, forAttribute: "requestor")
        
        return true
    }
    
}

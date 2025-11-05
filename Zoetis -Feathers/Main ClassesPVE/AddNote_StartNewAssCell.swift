//
//  AddNote_StartNewAssCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 17/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import Foundation
import UIKit

class AddNote_StartNewAssCell: UITableViewCell {

    @IBOutlet weak var notetxtView: UITextView!
    var timeStampStr = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notetxtView.textContainer.lineFragmentPadding = 12
        notetxtView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        notetxtView.layer.borderWidth = 2.0;

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddNote_StartNewAssCell: UITextViewDelegate {
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
    
    
     
     func textViewDidEndEditing(_ textView: UITextView) {
         textView.backgroundColor = UIColor.white
     }
     
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if text == "\n" {
             textView.resignFirstResponder()
             return false
         }else{
            let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
            
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftSNAFor(timeStampStr, syncedStatus: false, text: newString, forAttribute: "notes")

            }else{
                CoreDataHandlerPVE().updateSessionDetails(1, text: newString, forAttribute: "notes")

            }
            
        }
         return true
     }
    
    
}

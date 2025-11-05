//
//  AddNote_StartNewAssCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 17/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class AddNote_StartNewAssCell: UITableViewCell {

    @IBOutlet weak var notetxtView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddNote_StartNewAssCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         textView.backgroundColor = UIColor.lightGray
     }
     
     func textViewDidEndEditing(_ textView: UITextView) {
         textView.backgroundColor = UIColor.white
     }
     
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if text == "\n" {
             textView.resignFirstResponder()
             return false
         }
         return true
     }
    
    
}

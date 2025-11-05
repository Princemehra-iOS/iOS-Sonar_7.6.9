//
//  MicrobialSampleInfoCellTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol MicrobialSampleInfoCellDelegate {
    func noOfPlates(count: Int, clicked :Bool)
}

class MicrobialSampleInfoCell: UITableViewCell {

    var delegate: MicrobialSampleInfoCellDelegate? = nil
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var numberOfPlatesView: customView!
    
    @IBOutlet weak var plusBtnOutlet: UIButton!
    
    @IBOutlet weak var toggleExpandCollapseBtn: UIButton!
    
    

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
        delegate?.noOfPlates(count: Int(text) ?? 0, clicked: true)
    }
    
    func unableDisableAccordingToSessionType(sessionType: REQUISITION_SAVED_SESSION_TYPE){
        switch  sessionType{
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.plusBtnOutlet.isEnabled = false
            self.minusBtn.isEnabled = false
            self.noOfPlates.isEnabled = false
            self.toggleExpandCollapseBtn.isEnabled = false
        default:
            break
        }
    }
}

extension MicrobialSampleInfoCell: UITextFieldDelegate{
    
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


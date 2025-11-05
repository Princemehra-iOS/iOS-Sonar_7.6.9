//
//  MicrobialTextfieldInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class MicrobialTextfieldInfoCell: UITableViewCell {

    @IBOutlet weak var PlateIdTxt: UILabel!
    @IBOutlet weak var DisplayPlateIdTxt: UILabel!
    @IBOutlet weak var FlockIdTxt: UITextField!
    @IBOutlet weak var HouseNoTxt: UITextField!
    @IBOutlet weak var hvtCheck: UIButton!
    @IBOutlet weak var seroTypeCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func unableDisableAccordingToSessionType(sessionType: REQUISITION_SAVED_SESSION_TYPE){
        switch  sessionType{
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.FlockIdTxt.isEnabled = false
            self.HouseNoTxt.isEnabled = false
            self.hvtCheck.isEnabled = false
            self.seroTypeCheck.isEnabled = false
        default:
            break
        }
    }
}

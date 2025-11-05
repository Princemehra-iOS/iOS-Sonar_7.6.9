//
//  DraftInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 07/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class DraftInfoCell: UITableViewCell {
    
    
    @IBOutlet weak var requisitionNumberTxt: UILabel!
    
    @IBOutlet weak var requisitionDateTxt: UILabel!
    
    @IBOutlet weak var  surveyType: UILabel!
    
    @IBOutlet weak var actionImage: UIImageView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

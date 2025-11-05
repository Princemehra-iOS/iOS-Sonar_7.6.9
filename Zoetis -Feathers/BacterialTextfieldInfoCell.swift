//
//  BacterialTextfieldInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 31/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import CoreData
//protocol BacterialTextfieldInfoCellDelegate {
//    func removeRows()
//}

class BacterialTextfieldInfoCell: UITableViewCell {
    
    
    var isSelectedStatus : Bool = false
    
    @IBOutlet weak var bacterialTxt: UILabel!
    
    @IBOutlet weak var sampleDescriptionTxt: UITextField!
    
    @IBOutlet weak var plateIdTxt: UILabel!
    
     var completion:((_ error: String?) -> Void)?
    
    @IBOutlet weak var chkBtnTag: UIButton!
    
    @IBOutlet weak var microsporeCheck: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

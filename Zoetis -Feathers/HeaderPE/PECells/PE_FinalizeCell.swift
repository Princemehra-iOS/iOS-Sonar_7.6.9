//
//  PE_FinalizeCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PE_FinalizeCell: UITableViewCell {

    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
     
     override func layoutSubviews() {
         super.layoutSubviews()
      
     }
     
     class var identifier: String {
         return String(describing: self)
     }
     
     class var nib: UINib {
         return UINib(nibName: identifier, bundle: nil)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

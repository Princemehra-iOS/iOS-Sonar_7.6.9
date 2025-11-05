//
//  PEFinializeHeaderTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by kuldeep Singh on 18/10/22.
//

import UIKit

class PEFinializeHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPlusMinus: UIButton!
    @IBOutlet weak var lblScore: UILabel!
    
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

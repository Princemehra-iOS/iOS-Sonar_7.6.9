//
//  AcknowledgementTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 29/05/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class AcknowledgementTableViewCell: UITableViewCell {

    @IBOutlet weak var acknowledgementLbl: UILabel!
    
    static let identifier = "acknowledgementTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var classIdentifier: String {
         return String(describing: self)
     }
     
     class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    
}

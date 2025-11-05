//
//  NecropsyTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 25/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class NecropsyTableViewCell: UITableViewCell {

    // MARK: - OUTLET
    @IBOutlet weak var sessionDateLbl: UILabel!
    @IBOutlet weak var complexLbl: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

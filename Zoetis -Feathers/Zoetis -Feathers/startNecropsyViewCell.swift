//
//  startNecropsyViewCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 23/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//

import UIKit

class startNecropsyViewCell: UITableViewCell {

    @IBOutlet weak var sessionDateLbl: UILabel!
    @IBOutlet weak var sessionType: UILabel!
    @IBOutlet weak var complexDateLbl: UILabel!
    @IBOutlet weak var veterinarianLbl: UILabel!

    @IBOutlet weak var langLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

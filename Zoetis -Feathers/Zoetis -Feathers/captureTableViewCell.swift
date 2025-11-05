//
//  captureTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 21/10/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class captureTableViewCell: UITableViewCell {

    @IBOutlet weak var farmLabel: UILabel!

    @IBOutlet weak var houseNo: UILabel!
    @IBOutlet weak var feedProgramLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var flockIdLabel: UILabel!

    @IBOutlet weak var ageLabel: UILabel!

    @IBOutlet weak var noOfBirdsLabel: UILabel!

    @IBOutlet weak var sickLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

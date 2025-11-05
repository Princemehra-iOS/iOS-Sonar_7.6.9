//
//  CapNecropsyStep1TblCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//

import UIKit

class CapNecropsyStep1TblCell: UITableViewCell {

    @IBOutlet weak var farmNameLbl: UILabel!
    @IBOutlet weak var feedProgramLbl: UILabel!
    @IBOutlet weak var flockIdLbl: UILabel!
    @IBOutlet weak var breedLbl: UILabel!
    @IBOutlet weak var noOfBirdsLbl: UILabel!
@IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var abfLbl: UILabel!
    @IBOutlet weak var sexLbl: UILabel!
    @IBOutlet weak var sickLbl: UILabel!
    @IBOutlet weak var farmWeightLbl: UILabel!
    @IBOutlet weak var houseNoLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

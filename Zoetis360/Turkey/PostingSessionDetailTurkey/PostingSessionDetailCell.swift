//
//  PostingSessionDetailCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class PostingSessionDetailCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var farmNameLbl: UILabel!
    @IBOutlet weak var feedProgramLbl: UILabel!
    @IBOutlet weak var flockIdLbl: UILabel!
    @IBOutlet weak var breedLbl: UILabel!
    @IBOutlet weak var sexLbl: UILabel!
    @IBOutlet weak var farmWeightLbl: UILabel!
    @IBOutlet weak var sickLbl: UILabel!
    @IBOutlet weak var abfLbl: UILabel!
    @IBOutlet weak var houseNoLbl: UILabel!
    @IBOutlet weak var noOfBirdsLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var badgeButton: MIBadgeButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var genLbl: UILabel!
    
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: - METHODS AND FUNCTIONS
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


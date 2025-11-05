//
//  PostingSessionDetailTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 8/22/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class PostingSessionDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var farmsLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var townsendFarms: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var badgeBttn: MIBadgeButton!
    @IBOutlet weak var houseNoLbl: UILabel!
    @IBOutlet weak var noofBirdsLbl: UILabel!
    @IBOutlet weak var feedPrgrmLbl: UILabel!
    
    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Function & Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

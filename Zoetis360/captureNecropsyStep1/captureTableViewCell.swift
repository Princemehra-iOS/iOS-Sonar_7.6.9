//
//  captureTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 21/10/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class captureTableViewCell: UITableViewCell {
    
  

   // MARK: - OUTLET
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var houseNo: UILabel!
    @IBOutlet weak var feedProgramLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var flockIdLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var noOfBirdsLabel: UILabel!
    @IBOutlet weak var sickLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

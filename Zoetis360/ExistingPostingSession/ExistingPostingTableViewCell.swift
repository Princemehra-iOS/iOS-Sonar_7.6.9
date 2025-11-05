//
//  ExistingPostingTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 04/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class ExistingPostingTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var sessionTypeLabel: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var complexLabel: UILabel!
    @IBOutlet weak var veterinartionLabel: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    @IBOutlet weak var eyeIamgeView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: - Method & Function
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ReviewerSelectionTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 08/06/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ReviewerSelectionTableViewCell: UITableViewCell {
    var selectUnselectButton: ((Any) -> Void)?
    @IBOutlet weak var checkUncheckReviewerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectUnselectButtonAction(_ sender: UIButton) {
        self.selectUnselectButton?(sender)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

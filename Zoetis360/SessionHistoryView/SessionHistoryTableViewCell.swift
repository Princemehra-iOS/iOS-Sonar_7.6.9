//
//  SessionHistoryTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 22/08/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class SessionHistoryTableViewCell: UITableViewCell {


   // MARK: - OUTLET
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionType: UILabel!
    @IBOutlet weak var typeComplexLabel: UILabel!
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var feedProgram: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

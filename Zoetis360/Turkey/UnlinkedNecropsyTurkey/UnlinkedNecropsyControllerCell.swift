//  UnlinkedNecropsyControllerCell.swift
//  Zoetis -Feathers
//  Created by Manish Behl on 23/03/18.
//  Copyright © 2018 . All rights reserved.

import UIKit

class UnlinkedNecropsyControllerCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var necroLblLng: UILabel!
    @IBOutlet weak var necroWithoutDateLabel: UILabel!
    @IBOutlet weak var necroWithoutComplexLbl: UILabel!
    @IBOutlet weak var postingDateLbl: UILabel!
    @IBOutlet weak var postingSessionTypeLbl: UILabel!
    @IBOutlet weak var postingComplexLbl: UILabel!
    @IBOutlet weak var postingVeteranarianLbl: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    
    // MARK: - VIEW CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - METHOD & FUNCTION
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

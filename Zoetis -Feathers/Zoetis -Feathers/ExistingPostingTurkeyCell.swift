//
//  ExistingPostingTurkeyCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 15/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//

import UIKit

class ExistingPostingTurkeyCell: UITableViewCell {

    @IBOutlet weak var lblLng: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sessionTypeLbl: UILabel!
    @IBOutlet weak var veterinarianLbl: UILabel!
    @IBOutlet weak var eyeBlueImage: UIImageView!
    @IBOutlet weak var complexLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

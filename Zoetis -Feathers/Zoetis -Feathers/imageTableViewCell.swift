//
//  imageTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 29/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class imageTableViewCell: UITableViewCell {

    @IBOutlet weak var farmNamelabel: UILabel!
    @IBOutlet weak var cateNamelabel: UILabel!
    @IBOutlet weak var observationLabel: UILabel!
    @IBOutlet weak var birdNumberLabl: UILabel!

    @IBOutlet weak var cameraImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

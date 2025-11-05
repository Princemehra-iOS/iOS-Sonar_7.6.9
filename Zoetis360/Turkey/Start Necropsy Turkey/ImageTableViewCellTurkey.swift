//
//  ImageTableViewCellTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 4/26/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class ImageTableViewCellTurkey: UITableViewCell {

    // MARK: - OUTLETS
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

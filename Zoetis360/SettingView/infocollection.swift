//
//  infocollection.swift
//  Zoetis -Feathers
//
//  Created by "" on 02/12/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class infocollection: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var obsDesc: UITextView!
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var birdsDescriptions: UILabel!
    
    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

//
//  FeatherpulpSampleInfoTestCollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 21/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class FeatherpulpSampleInfoTestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkboxButton: UIButton!
    var textCheckUncheckAction: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkboxButton.sizeToFit()
        // Initialization code
    }
    @IBAction func testCheckBoxBtnAction(_ sender: UIButton) {
        self.textCheckUncheckAction?()
    }
    
}

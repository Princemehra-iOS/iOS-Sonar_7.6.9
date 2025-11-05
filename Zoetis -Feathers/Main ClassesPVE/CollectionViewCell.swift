//
//  CollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 23/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell:UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var imageview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    
    override var isSelected: Bool {
         didSet {
            self.imageview.image = isSelected ? UIImage(named: "tabSelect.pdf")!: UIImage(named: "tabUnselect.pdf")!
         }
    }
    
}
    


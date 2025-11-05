//
//  PECategoryCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 31/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class PECategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    override var isSelected: Bool {
         didSet {
            self.imageview.image = isSelected ? UIImage(named: "tabSelect.pdf")!: UIImage(named: "tabUnselect.pdf")!
         }
    }
    
    
    
    
    
    
    
}

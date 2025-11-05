//
//  CollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 23/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

class PESubHeaderTitleAssessmentCell:UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override var isSelected: Bool {
        didSet {
            self.categoryName.backgroundColor = isSelected ? UIColor(red: 246.0 / 255.0, green: 121.0 / 255.0, blue: 45.0 / 255.0, alpha: CGFloat(1)) : UIColor.black
        }
    }
}



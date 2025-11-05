//
//  CollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 23/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation

class CollectionViewCell:UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
//F6792D -- orange
   // @IBOutlet weak var imageView: UIImageView! // for example - some UI element inside cell ...

     override var isSelected: Bool {
         didSet {
            self.categoryName.backgroundColor = isSelected ? UIColor(red: 246.0 / 255.0, green: 121.0 / 255.0, blue: 45.0 / 255.0, alpha: CGFloat(1)) : UIColor.black
            // self.categoryName.alpha = isSelected ? 0.75 : 1.0
         }
       }
    
}
    


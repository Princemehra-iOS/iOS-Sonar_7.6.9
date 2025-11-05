//
//  AcknowledgementCollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 15/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit

class AcknowledgementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var acknowledgeBtn: UIButton!
    @IBOutlet weak var mainVw: UIView!
    
    static let identifier = "acknowledgementCollectionViewCell"
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
}

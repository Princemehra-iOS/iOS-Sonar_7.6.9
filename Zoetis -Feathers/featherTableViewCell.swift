//
//  featherTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 17/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class featherTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var Plate_ID: UILabel!
    
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var FlockIDtxt: UITextField!
    
    @IBOutlet weak var HouseNotxt: UITextField!
    
    
    
    @IBOutlet weak var myButton: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    
    @IBAction func additionalTestAction(_ sender: UIButton) {
        print(appDelegateObj.testFuntion())
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//
//  UnlinkedNecropsiesTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 8/22/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class UnlinkedNecropsiesTableViewCell: UITableViewCell {
    // MARK: 🟠 - OUTLET
    @IBOutlet weak var complexLabel: UILabel!
    @IBOutlet weak var farmNameLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var vetLable: UILabel!
    @IBOutlet weak var lblLng: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var complexLblPostingSession: UILabel!
    @IBOutlet weak var dateLblPostingSession: UILabel!
    @IBOutlet weak var sessionLblPostingSesson: UILabel!
    @IBOutlet weak var veterinarianLblPostingSession: UILabel!
    
    @IBAction func linkButtonAction(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
    
    // MARK: 🟠 - METHOD & FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

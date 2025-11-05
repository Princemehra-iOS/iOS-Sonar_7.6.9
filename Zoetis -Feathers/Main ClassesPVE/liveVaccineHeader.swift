//
//  JourneyDetailHeader.swift
//  Cheapflightsfares
//
//  Created by CFF on 3/8/22.
//  Copyright © 2019 Cheapflightsfares. All rights reserved.
//

import Foundation
import UIKit

//1. delegate method

class liveVaccineHeader: UITableViewHeaderFooterView {
 
    @IBOutlet weak var vaccineNameLbl: UILabel!
 
    @IBOutlet weak var vacineSwitch: UISwitch!
    var currentIndPath = NSIndexPath()
    var currntSection = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vaccineNameLbl.layer.cornerRadius = 5
        vaccineNameLbl.layer.masksToBounds = true

    }
    
    
    @IBAction func vaccineSwitchAction(_ sender: UISwitch) {
        appDelegateObj.testFuntion()
    }
    

}

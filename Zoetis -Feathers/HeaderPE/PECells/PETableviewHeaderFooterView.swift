//
//  PETableviewHeaderFooterView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 07/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PETableviewHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var actionMinus: UIButton!
    @IBOutlet weak var actionAdd: UIButton!
    
    var addCompletion:((_ error: String?) -> Void)?
    var minusCompletion:((_ error: String?) -> Void)?
    var certificateData : [PECertificateData] = []
    
    @IBAction func minusTapped(_ sender: Any) {
        minusCompletion?(nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        addCompletion?(nil)
    }
}

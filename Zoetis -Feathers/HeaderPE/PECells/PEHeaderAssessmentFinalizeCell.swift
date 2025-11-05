//
//  TopCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 24/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

class PEHeaderAssessmentFinalizeCell: UITableViewCell {

    @IBOutlet weak var labelAssessmentDate: UITextField!
    @IBOutlet weak var labelCustomerName: UITextField!
    @IBOutlet weak var labelComplexName: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func configData(newAssessment:PENewAssessment)  {
        labelAssessmentDate.text = newAssessment.evaluationDate
        labelCustomerName.text = newAssessment.customer?.customerName ?? ""
        labelComplexName.text = newAssessment.complex?.complexName ?? ""
    }

}

//
//  StartNewAssignmentNoteCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 16/12/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//

import Foundation
import UIKit

class StartNewAssignmentCell: UITableViewCell {

    @IBOutlet weak var evaluationDateBtn: UIButton!
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var surveyNoBtn: UIButton!
    @IBOutlet weak var accManagerBtn: UIButton!
    @IBOutlet weak var breedOfBirdsBtn: UIButton!
    @IBOutlet weak var housingBtn: UIButton!
    @IBOutlet weak var evaluationTypeBtn: UIButton!
    @IBOutlet weak var evaluationForBtn: UIButton!
    @IBOutlet weak var siteIdBtn: UIButton!
    @IBOutlet weak var evaluatorBtn: UIButton!
    @IBOutlet weak var ageOfBirdsBtn: UIButton!
    
    @IBOutlet weak var evaluationDateTxtfield: UITextField!
    @IBOutlet weak var customerTxtfield: UITextField!
    @IBOutlet weak var surveyNoTxtfield: UITextField!
    @IBOutlet weak var accManagerTxtfield: UITextField!
    @IBOutlet weak var breedOfBirdsTxtfield: UITextField!
    @IBOutlet weak var housingTxtfield: UITextField!
    @IBOutlet weak var evaluationTypeTxtfield: UITextField!
    @IBOutlet weak var evaluationForTxtfield: UITextField!
    @IBOutlet weak var siteIdTxtfield: UITextField!
    @IBOutlet weak var evaluatorTxtfield: UITextField!
    @IBOutlet weak var ageOfBirdsTxtfield: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}

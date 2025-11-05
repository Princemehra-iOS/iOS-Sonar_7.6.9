//
//  EnvironmentalCaseInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 02/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class EnvironmentalCaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var requestorTxt: UITextField!
    
    @IBOutlet weak var companyBtn: UIButton!
    
    @IBOutlet weak var selectedCompanyTxt: UITextField!
    
    
    @IBOutlet weak var surveyConductedOnBtn: UIButton!
    
    @IBOutlet weak var surveyConductedOnTxt: UITextField!
    
    @IBOutlet weak var purposeOfSurveyBtn: UIButton!
    
    @IBOutlet weak var purposeOfSurveyTxt: UITextField!
    
    @IBOutlet weak var sampleCollectedByBtn: UIButton!
    
    @IBOutlet weak var sampleCollectedByTxt: UITextField!
    
    
    @IBOutlet weak var siteBtn: UIButton!
    
    @IBOutlet weak var siteTxt: UITextField!
    
    @IBOutlet weak var reviewerBtn: UIButton!
    
    @IBOutlet weak var reviewerTxt: UITextField!
    
    @IBOutlet weak var sampleCollectionDateBtn: UIButton!
    
    @IBOutlet weak var sampleCollectionDateTxt: UITextField!
    
    @IBOutlet weak var transferInBtn: UIButton!
    
    @IBOutlet weak var transferInTxt: UITextField!
    
    
    @IBOutlet weak var barcodeTxt: UITextField!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

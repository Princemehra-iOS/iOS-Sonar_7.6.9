//
//  MicrobialCaseInfoCellTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class MicrobialCaseInfoCell: UITableViewCell {
    
    @IBOutlet weak var reviewerTextFieldSuperView: customView!
    @IBOutlet weak var typeOfBirdView: customView!
    @IBOutlet weak var requestorTxt: UITextField!
    @IBOutlet weak var reasonForVisitTxt: UITextField!
    @IBOutlet weak var selectedCompanyTxt: UITextField!
    @IBOutlet weak var barcodeTxt: UITextField!
    @IBOutlet weak var sampleCollectedByTxt: UITextField!
    @IBOutlet weak var siteTxt: UITextField!
    @IBOutlet weak var reviewerBtn: customButton!
    @IBOutlet weak var reviewerTxt: UITextField!
    @IBOutlet weak var sampleCollectionDateTxt: UITextField!
    @IBOutlet weak var sampleCollectionDateBtn: customButton!
   
    @IBOutlet weak var caseInfoContainerView: GradientView!


    @IBOutlet weak var companySelectionView: UIView!
    @IBOutlet weak var siteSelectionView: UIView!
    @IBOutlet weak var barcodeSelectionView: UIView!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var defaultBorderColor = UIColor(red: 204.0/255, green: 227.0/255, blue: 1.0, alpha: 1.0).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.caseInfoContainerView.topGradientColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        //        self.caseInfoContainerView.bottomGradientColor = UIColor(red: 210/255, green: 231/255, blue: 1.0, alpha: 1)
        //        self.contentView.layer.cornerRadius = 20
        //        self.contentView.layer.masksToBounds = true
        
        let firstName = UserDefaults.standard.value(forKey: "FirstName") as? String ?? ""
        self.sampleCollectedByTxt.text = firstName
        self.reviewerTxt.text = firstName
        self.requestorTxt.text = firstName
        
        caseInfoContainerView.firstColor =  UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        caseInfoContainerView.secondColor =  UIColor(red: 210/255, green: 231/255, blue: 1.0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func unableDisableAccordingToSessionType(sessionType: REQUISITION_SAVED_SESSION_TYPE){
        switch  sessionType{
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.requestorTxt.isEnabled = false
            self.selectedCompanyTxt.isEnabled = false
            self.reasonForVisitTxt.isEnabled = false
            self.barcodeTxt.isEnabled = false
            self.sampleCollectedByTxt.isEnabled = false
            self.siteTxt.isEnabled = false
            self.reviewerBtn.isEnabled = false
            self.reviewerTxt.isEnabled = false
            self.sampleCollectionDateTxt.isEnabled = false
            self.sampleCollectionDateBtn.isEnabled = false
            self.noteTextView.isUserInteractionEnabled = false
        default: break
        }
    }

}

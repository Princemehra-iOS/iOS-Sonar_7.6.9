//
//  CaptureNecroStep2TurkeyCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 21/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class CaptureNecroStep2TurkeyCell: UICollectionViewCell {
    
    // MARK: - VARIABLS
    var mesureValue: String = ""
    var incrementValue  = 0
    
    // MARK: - OUTLETS
    @IBOutlet weak var observationImage: UIImageView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var badgeButton: MIBadgeButton!
    @IBOutlet weak var textFieldActual: UITextField!
    @IBOutlet weak var switchNecropsyBtn: UISwitch!
    
    // Mark :- Bird Collection View Cell
    
    @IBOutlet weak var houseLbl: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var editImage: UIImageView!
    
    // Mark :- Form Collection View Cell
    
    @IBOutlet weak var quickLinkIcon: UIImageView!
    @IBOutlet weak var helpButtonOutlet: UIButton!
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var QuickLink: UIButton!
    @IBOutlet weak var notePopBtn: UIButton!
    @IBOutlet weak var birdsCountLabel: UILabel!
    @IBOutlet weak var incrementLabel: UILabel!
    
    
    @IBOutlet weak var turkeySexView: UIView!
    
    @IBOutlet weak var turkeySexLbl: UILabel!
    
    @IBOutlet weak var turkySexBtn: UIButton!
    var turkeybirdSexCompletion:((_ string: String?) -> Void)?
    // MARK: - METHOD & FUNCTIONS
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }

    @IBAction func turkeySexBtn(_ sender: Any) {
        turkeybirdSexCompletion?("")
    }
    
    
    
}


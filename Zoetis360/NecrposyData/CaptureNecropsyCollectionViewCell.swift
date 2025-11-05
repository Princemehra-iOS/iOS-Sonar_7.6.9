//
//  CaptureNecropsyCollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 8/25/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class CaptureNecropsyCollectionViewCell: UICollectionViewCell {
    // MARK: - OUTLET
    @IBOutlet weak var helpButtonAction: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var switchNec: UISwitch!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var myLabeldata: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var QuickLink: UIButton!
    @IBOutlet weak var dataIncrement: UILabel!
    @IBOutlet weak var switchBirds: UISwitch!
    @IBOutlet weak var sliderBirds: UISlider!
    @IBOutlet weak var textFieldActual: UITextField!
    
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var quickLinkIcon: UIImageView!
    @IBOutlet weak var observationImage: UIImageView!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var notePopBtn: UIButton!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var badgeButton: MIBadgeButton!
    
   // New Update
    @IBOutlet weak var birdSexView: UIView!
    @IBOutlet weak var birdSexBtn: UIButton!
    @IBOutlet weak var birdSexLbl: UILabel!
    
    @IBOutlet weak var birdsCountLabel: UILabel!
    @IBOutlet weak var incrementLabel: UILabel!
    
    var birdSexCompletion:((_ string: String?) -> Void)?
   
    // MARK: - VARIABLES
    var mesureValue: String = ""
    var incrementValue  = 0
    // MARK: - VIEW LIFE CYCLE
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
   
    // MARK: 🟠 Bird Sex Button Action
    @IBAction func birdSexBtn(_ sender: Any) {
        birdSexCompletion?("")
    }
        
    
}
class CaptureNecropsyCollectionViewCellModel {
    var name : String!
//    var switchOnorOff : Bool!
//    var arrayImage : NSMutableArray!
}

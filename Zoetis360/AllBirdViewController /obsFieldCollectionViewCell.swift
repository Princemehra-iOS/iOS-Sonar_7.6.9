//
//  obsFieldCollectionViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 18/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class obsFieldCollectionViewCell: UICollectionViewCell  {

    // MARK: - OUTLET
    @IBOutlet weak var obsNameLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var imageBrdNumber: UIImageView!
    @IBOutlet weak var lblBirdSize: UILabel!
    @IBOutlet weak var incrementBtnOutlet: UIButton!
    @IBOutlet weak var minusBtnOutlet: UIButton!

    @IBOutlet weak var switchQuickLink: UISwitch!
    @IBOutlet weak var actualTexField: UITextField?
    
    @IBOutlet weak var birdSexView: UIView!
    
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var birdSexBtn: UIButton!
    
    
    // MARK: - VARIABLE
    var incernmeString :Int = 0


    // MARK: - IBACTION
    @IBAction func incrementBtn(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
 
    @IBAction func minusBtn(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }

    
    @IBAction func birdSxBtn(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
    
    
}

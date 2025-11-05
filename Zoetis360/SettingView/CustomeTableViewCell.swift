//
//  CustomeTableViewCell.swift
//  CollectionViewWithMovingItem
//
//  Created by Chandan Singh on 8/21/16.
//  Copyright © 2016 Cao Jiannan. All rights reserved.
//

import UIKit
typealias WSCompletionBlock1 = (_ responseData :String?) ->()

// MARK: - Protocols
protocol CustomeTableViewCellDelegate{
    func didTapedSwitch(_ cell:CustomeTableViewCell)
}

class CustomeTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var infoLInkView: UIButton!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    
    // MARK: - Variables
    var deleget : CustomeTableViewCellDelegate!
    var completionBlock1: WSCompletionBlock?

    // MARK: - View Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Function & Methods
    func setUpTableViewCell(_ cellinfo : CustomeTableViewCellModel){
        lblName.text = cellinfo.name
        switchView.setOn(cellinfo.switchOnorOff, animated:false)
    }
    
    // MARK: - IBACTIONS
    @IBAction func switchAction(_ sender: AnyObject) {
        appDelegateObj.testFuntion()
    }
}


class CustomeTableViewCellModel {
    var name : String!
    var switchOnorOff : Bool!
    var arrayImage : NSMutableArray!
}

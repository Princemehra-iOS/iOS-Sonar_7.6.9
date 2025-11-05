//
//  SettingTblCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 16/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
typealias SWSCompletionBlock1 = (_ responseData :String?) ->()
// MARK: - PROTOCOLS
protocol SettingustomeTableViewCellDelegate{
    func didTapedSwitch(_ cell:SettingTblCell)
}

class SettingTblCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var infoLInkView: UIButton!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    // MARK: - VARIABLES
    var deleget : SettingustomeTableViewCellDelegate!
    var completionBlock1: SWSCompletionBlock1?
    
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func setUpTableViewCell(_ cellinfo : SettingCustomeTableViewCellModel){
        lblName.text = cellinfo.name
        switchView.setOn(cellinfo.switchOnorOff, animated:false)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // MARK: - IBACTION
    @IBAction func switchAction(_ sender: AnyObject) {
        print(appDelegateObj.testFuntion())
    }
    
}
class SettingCustomeTableViewCellModel {
    var name : String!
    var switchOnorOff : Bool!
    var arrayImage : NSMutableArray!
}

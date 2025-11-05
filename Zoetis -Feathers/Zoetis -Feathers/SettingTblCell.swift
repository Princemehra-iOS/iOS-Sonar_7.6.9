//
//  SettingTblCell.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 16/03/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//

import UIKit
typealias SWSCompletionBlock1 = (_ responseData: String?) ->Void
protocol SettingustomeTableViewCellDelegate {
    func didTapedSwitch(_ cell: SettingTblCell)
}
class SettingTblCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchView: UISwitch!

    @IBOutlet weak var infoLInkView: UIButton!

    @IBOutlet weak var checkBoxOutlet: UIButton!
    var deleget: SettingustomeTableViewCellDelegate!
    var completionBlock1: SWSCompletionBlock1?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setUpTableViewCell(_ cellinfo: SettingCustomeTableViewCellModel) {
        lblName.text = cellinfo.name
        switchView.setOn(cellinfo.switchOnorOff, animated: false)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchAction(_ sender: AnyObject) {

        //completionBlock1!(responseData: "hi")
    }

}
class SettingCustomeTableViewCellModel {
    var name: String!
    var switchOnorOff: Bool!
    var arrayImage: NSMutableArray!
}

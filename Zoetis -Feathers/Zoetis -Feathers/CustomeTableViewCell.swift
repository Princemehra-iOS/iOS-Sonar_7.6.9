//
//  CustomeTableViewCell.swift
//  CollectionViewWithMovingItem
//
//  Created by Chandan Singh on 8/21/16.
//  Copyright © 2016 Cao Jiannan. All rights reserved.
//

import UIKit
typealias WSCompletionBlock1 = (_ responseData: String?) ->Void

protocol CustomeTableViewCellDelegate {
    func didTapedSwitch(_ cell: CustomeTableViewCell)
}

class CustomeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchView: UISwitch!

    @IBOutlet weak var infoLInkView: UIButton!

    @IBOutlet weak var checkBoxOutlet: UIButton!
    var deleget: CustomeTableViewCellDelegate!
    var completionBlock1: WSCompletionBlock?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpTableViewCell(_ cellinfo: CustomeTableViewCellModel) {
        lblName.text = cellinfo.name
        switchView.setOn(cellinfo.switchOnorOff, animated: false)
    }

//    func showbuttonClick(cellinfo:CustomeTableViewCellModel, completionBlock:WSCompletionBlock1)
//    {
//        lblName.text = cellinfo.name
//        switchView.setOn(cellinfo.switchOnorOff, animated:false)
//        completionBlock1 = completionBlock
//    }

    @IBAction func switchAction(_ sender: AnyObject) {

        //completionBlock1!(responseData: "hi")
    }
}

class CustomeTableViewCellModel {
    var name: String!
    var switchOnorOff: Bool!
    var arrayImage: NSMutableArray!
}

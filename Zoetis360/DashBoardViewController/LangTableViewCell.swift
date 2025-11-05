//
//  LangTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by kuldeep Singh on 28/10/22.
//

import UIKit

class LangTableViewCell: UITableViewCell {

    // MARK: 🟠 - OUTLET
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    // MARK: 🟠 - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  imageTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 29/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class imageTableViewCell: UITableViewCell {

    // MARK: - OUTLET
    @IBOutlet weak var farmNamelabel: UILabel!
    @IBOutlet weak var cateNamelabel: UILabel!
    @IBOutlet weak var observationLabel: UILabel!
    @IBOutlet weak var birdNumberLabl: UILabel!
    
    
    @IBOutlet weak var frmnamrDum: UILabel!
    @IBOutlet weak var obsnameDum: UILabel!
    
    @IBOutlet weak var birdNoDum: UILabel!
    @IBOutlet weak var catNameDum: UILabel!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    var lngId = NSInteger()
    override func awakeFromNib() {
        super.awakeFromNib()
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        if lngId == 4 {
            frmnamrDum.text = "Nome da unidade:"
            catNameDum.text = "Sistema envolvido:"
            obsnameDum.text = "Lesão observada:"
            birdNoDum.text  = "Nº da ave:"
        }
        else
        {
            frmnamrDum.text = "Farm name:"
            catNameDum.text = "Category name:"
            obsnameDum.text = "Observation name:"
            birdNoDum.text  = "Bird no:"
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

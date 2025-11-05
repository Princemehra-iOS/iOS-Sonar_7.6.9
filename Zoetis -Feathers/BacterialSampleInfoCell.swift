//
//  BacterialSampleInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 31/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol BacterialSampleInfoCellDelegate {
    
    func noOfPlates(count: Int, clicked :Bool)
   
}


class BacterialSampleInfoCell: UITableViewCell {
    
    var delegate: BacterialSampleInfoCellDelegate? = nil
   
  
    @IBOutlet weak var plateContainerView: customView!
    
    @IBOutlet weak var plusBtnOutlet: UIButton!
    
     @IBOutlet weak var noOfPlates: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.noOfPlates.keyboardType = .phonePad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func plusBtnAction(_ sender: UIButton) {
    
        let barcode = UserDefaults.standard.value(forKey: "barcode")
        guard let text =  noOfPlates.text  else {
            return
        }
        
        if (text == "") {
            noOfPlates.text = "enter a value"
            return
        } else {
            let sessionId = UserDefaults.standard.integer(forKey: "sessionId")
            
            if let txtVale = Int(noOfPlates.text!) {  // Ensure safe conversion
                for i in 0..<txtVale {
                    let plate = "\(String(describing: barcode!))-" + "\(i + 1)"
                    CoreDataHandlerMicro().saveSampleInfoDataInDB(plate, plateId: i, sampleDescriptiopn: "", additionalTests: "Bacterial", checkMark: "false", microsporeCheck: "false", sessionId: sessionId)
                }
            }
        }
        delegate?.noOfPlates(count: Int(text)!, clicked: true)
    }
}

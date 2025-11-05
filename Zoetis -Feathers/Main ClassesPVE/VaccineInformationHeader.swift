//
//  JourneyDetailHeader.swift
//  Cheapflightsfares
//
//  Created by CFF on 1/30/19.
//  Copyright © 2019 Cheapflightsfares. All rights reserved.
//

import Foundation
import UIKit

//1. delegate method
protocol VaccinatorInfoDetailPlusBtnTapped: AnyObject {
    func vaccinatorInfoDetailPlusBtnTapped(clickedBtnIndPath: NSIndexPath)
    func vaccineInfoDetailsMinusBtnTapped(clickedBtnIndPath: NSIndexPath)
}

class VaccineInformationHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var vaccineManLbl: UILabel!
    @IBOutlet weak var vaccineNameLbl: UILabel!
    @IBOutlet weak var serotypeLbl: UILabel!
    @IBOutlet weak var serialLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var siteOfInjLbl: UILabel!

    weak var delegate: VaccinatorInfoDetailPlusBtnTapped?
    var currentIndPath = NSIndexPath()
    var currntSection = Int()
    
    @IBOutlet weak var headerImg : UIImageView!

    func refreshFramess(frame:CGRect) {
        var btnsize = (self.frame.size.width - 10 * 6) / 6
        debugPrint(btnsize)
     }

    @IBAction func vaccinatorInfoDetailPlusBtnTapped(sender: AnyObject) {
        let indexPath = IndexPath(row: 0, section: currntSection)
        delegate?.vaccinatorInfoDetailPlusBtnTapped(clickedBtnIndPath: indexPath as NSIndexPath)
    }

    @IBAction func vaccinatorInfoDetailMinusBtnTapped(sender: AnyObject) {
        let indexPath = IndexPath(row: 0, section: currntSection)
        delegate?.vaccineInfoDetailsMinusBtnTapped(clickedBtnIndPath: indexPath as NSIndexPath)
    }
}

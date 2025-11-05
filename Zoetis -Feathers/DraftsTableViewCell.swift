//
//  DraftsTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 04/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class DraftsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSite: UILabel!
    @IBOutlet weak var btnDeleteDraft: UIButton!
    @IBOutlet weak var btnEditDraft: UIButton!
    @IBOutlet weak var lblDraftRequisitionNumber: UILabel!
    @IBOutlet weak var lblDraftDate: UILabel!
    @IBOutlet weak var lblDraftRequisitionType: UILabel!
    
    //MARK:- Other Properties
    var arrViewRequistion: [Microbial_EnviromentalSurveyFormSubmitted] = []
    var buttonDeleteAction: ((Any) -> Void)?
    var buttonEditAction: ((Any) -> Void)?
    private let blankText = "N/A"
    
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnDeleteDraft.addTarget(self, action: #selector(deletBtnAction(_:)), for: .touchUpInside)
        self.btnEditDraft.addTarget(self, action: #selector(editBtnAction(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc private func editBtnAction(_ sender: UIButton?) {
        self.buttonEditAction?(sender!)
    }
    
    @objc private func deletBtnAction(_ sender: UIButton?) {
        self.buttonDeleteAction?(sender!)
    }

    func setCornerRadiusOfFirstAndLastCell(indexPath: IndexPath){
        self.roundCorners(corners: [.allCorners], radius: 0.0)
        switch indexPath.row {
        case 0:
            self.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        case (arrViewRequistion.count - 1):
            self.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 18.5)
        default:
            break
        }
    }
    
    func showData(indexPath: IndexPath) {
        
        self.lblDraftRequisitionType.text = RequisitionType.getRequisitionTypeStringValue(type: Int(arrViewRequistion[indexPath.row].requisitionType ?? 0))
        self.lblDraftRequisitionNumber.text = arrViewRequistion[indexPath.row].reqNo ?? blankText
        self.lblDraftDate.text = arrViewRequistion[indexPath.row].sampleCollectionDate ?? blankText
        self.labelSite.text = arrViewRequistion[indexPath.row].site ?? blankText
    }
    
}

//
//  ViewRequisistionTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 02/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class ViewRequisistionTableViewCell: UITableViewCell {
    
    
    //MARK:- Outlets
    @IBOutlet weak var btnPdf: UIButton!
    @IBOutlet weak var btnActions: UIButton!
    @IBOutlet weak var lblSurveyType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRequisitionDate: UILabel!
    @IBOutlet weak var lblRequisitionNumber: UILabel!
    
    //MARK:- Other Properties
    var arrViewRequistion: [Microbial_EnviromentalSurveyFormSubmitted] = []
    private let blankText = ""
    var viewSubmittedRequisitionDetails: ((Any) -> Void)?
    var pdfOfSubmittedRequisition: ((Any) -> Void)?

    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnPdf.isHidden = true
        self.btnActions.addTarget(self, action: #selector(viewSubmittedRequisitionDetailsBtnAction(_:)), for: .touchUpInside)
        self.btnPdf.addTarget(self, action: #selector(pdfBtnAction(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func viewSubmittedRequisitionDetailsBtnAction(_ sender: UIButton){
        self.viewSubmittedRequisitionDetails?(sender)
    }
    
    @objc func pdfBtnAction(_ sender: UIButton){
        self.pdfOfSubmittedRequisition?(sender)
    }
    

    func setCornerRadiusOfFirstAndLastCell(indexPath: IndexPath){
        let firstCellIndex = 0
        let lastCellIndex = (arrViewRequistion.count - 1)
        self.roundCorners(corners: [.allCorners], radius: 0.0)
        switch indexPath.row {
        case firstCellIndex:
            self.roundCorners(corners: [.topLeft, .topRight], radius: 18.5)
        case lastCellIndex:
            self.roundCorners(corners: [.bottomRight, .bottomLeft], radius: 18.5)
        default:
            break
        }
    }
    
    func showData(indexPath: IndexPath) {
        
        self.lblSurveyType.text = RequisitionType.getRequisitionTypeStringValue(type: arrViewRequistion[indexPath.row].requisitionType?.intValue ?? 0)
        self.lblRequisitionNumber.text = arrViewRequistion[indexPath.row].reqNo ?? blankText
        self.lblRequisitionDate.text = arrViewRequistion[indexPath.row].sampleCollectionDate ?? blankText
        self.lblStatus.text = ViewRequisitionViewModel().getCaseStatusString(id: arrViewRequistion[indexPath.row].reqStatus?.intValue ?? 0)
            //CASE_STATUS.getCaseStatusInStringValue(type: arrViewRequistion[indexPath.row].reqStatus?.intValue ?? 0)
    }
    
}

//
//  PE_FinalizeCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PE_DraftCell: UITableViewCell {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblAssessment: UILabel!
    @IBOutlet weak var lblEvaluationDate: UILabel!
    @IBOutlet weak var lblEvaluationType: UILabel!
    @IBOutlet weak var lblEvaluator: UILabel!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var rejectIndicatorBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var idInfoImg: UIImageView!
    @IBOutlet weak var extendedMicroLbl: UILabel!
    
    @IBOutlet weak var extendedRejectedComment: UIButton!
    
    @IBOutlet weak var extendedMicroStatus: UILabel!
    let inProcessStr = "In Progress"
    
    // MARK: - VARIABLES
    
    var tipView: ToolTipView?
    let blackTranparentView = UIView()
    var tipPosition : ToolTipPosition = .middle
    var tapGestureOnLabel1 : ((UITapGestureRecognizer) -> ())?
    var editCompletion:((_ string: String?) -> Void)?
    var deleteCompletion:((_ string: String?) -> Void)?
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - METHODS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PE_SessionCell.tapFunctionForInfo))
        self.idInfoImg.isUserInteractionEnabled = true
        self.idInfoImg.addGestureRecognizer(tap1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func tapFunctionForInfo(sender: UITapGestureRecognizer) {
        self.tapGestureOnLabel1?(sender)
    }
    
    func showToolTipTest(cell: PE_DraftCell, sender: UIView, refRange: String, tapGuesture: UITapGestureRecognizer) {
        
        self.tipView?.removeFromSuperview()
        self.blackTranparentView.removeFromSuperview()
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        blackTranparentView.frame = viewController?.view.frame ?? CGRect.zero
        blackTranparentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        viewController?.view.addSubview(blackTranparentView)
        
        let tipWidth: CGFloat = 220
        let tipHeight: CGFloat = 80
        let point = tapGuesture.location(in: viewController?.view)
        var tipX = point.x - tipWidth / 2 - 10
        var tipY: CGFloat = point.y - 90
        
        if self.tipPosition == .right {
            tipX = point.x - tipWidth - 27
            tipY = point.y - tipHeight / 2  + 6
        }
        tipView = ToolTipView(frame: CGRect(x: tipX, y: tipY, width: tipWidth, height: tipHeight), text: refRange, tipPos: self.tipPosition)
        
        viewController?.view.addSubview(tipView ?? UIView())
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(blackTransparentViewTapped(sender:)))
        blackTranparentView.isUserInteractionEnabled = true
        blackTranparentView.addGestureRecognizer(tap1)
        performShow(tipView)
    }
    
    @objc func blackTransparentViewTapped(sender:UITapGestureRecognizer) {
        self.blackTranparentView.removeFromSuperview()
        self.tipView?.removeFromSuperview()
    }
    
    func performShow(_ v: UIView?) {
        v?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut, animations: {
            v?.transform = .identity
        }) { finished in
            // do something once the animation finishes, put it here
        }
    }
    
    func config(peNewAssessment:PENewAssessment) {
        
        if peNewAssessment.extndMicro == false {
            extendedRejectedComment.isHidden = true
            
            deleteBtn.isHidden = peNewAssessment.isPERejected ?? false
            rejectIndicatorBtn.isHidden = !(peNewAssessment.isPERejected ?? false)
            
            extendedRejectedComment.isHidden = true
            extendedMicroLbl.text = peNewAssessment.sanitationValue == true ? "Yes" : Constants.noStr
            extendedMicroStatus.text = peNewAssessment.sanitationValue == true ? inProcessStr : "N/A"
        } else {
            extendedRejectedComment.isHidden = false
            extendedMicroStatus.text = peNewAssessment.isEMRejected == true ? inProcessStr : "Rejected"
            
            if peNewAssessment.sanitationValue == true {
                extendedMicroLbl.text = peNewAssessment.sanitationValue == true ? "Incomplete" : "N/A"
            }
        }
        
        self.tapGestureOnLabel1 = { (sender) in
            let assId = "C-" + "\(peNewAssessment.draftID ?? "")"
            self.showToolTipTest(cell: self, sender: self.parentViewController?.view ?? UIView(), refRange: assId, tapGuesture: sender)
        }
        
        lblEvaluationDate.text = peNewAssessment.evaluationDate
        lblEvaluationType.text = peNewAssessment.evaluationName
        lblEvaluator.text = peNewAssessment.customerName
        lblSiteName.text = peNewAssessment.siteName
        if peNewAssessment.isEMRejected == true {
            extendedMicroStatus.text = "Rejected"
            extendedRejectedComment.isHidden = false
        } else {
            if peNewAssessment.sanitationValue == false {
                extendedMicroLbl.text = Constants.noStr
                extendedMicroStatus.text = "N/A"
                extendedRejectedComment.isHidden = true
            } else {
                extendedMicroLbl.text = "Yes"
                extendedMicroStatus.text = inProcessStr
                extendedRejectedComment.isHidden = true
            }
        }
        
        let draftID = peNewAssessment.draftID ?? ""
        let date = "C-" + draftID.prefix(20)
        if peNewAssessment.statusType == 2 && peNewAssessment.isPERejected == true{
            rejectIndicatorBtn.isHidden = false
            deleteBtn.isHidden = true
        } else {
            rejectIndicatorBtn.isHidden = true
            if peNewAssessment.isPERejected == false && peNewAssessment.isEMRejected == true {
                deleteBtn.isHidden = true
                rejectIndicatorBtn.isHidden = true
                extendedRejectedComment.isHidden = false
            } else if peNewAssessment.isPERejected == true && peNewAssessment.isEMRejected == true {
               deleteBtn.isHidden = true
               rejectIndicatorBtn.isHidden = false
               extendedRejectedComment.isHidden = false
               
            } else if peNewAssessment.isPERejected == true && peNewAssessment.isEMRejected == false {
                deleteBtn.isHidden = true
                rejectIndicatorBtn.isHidden = false
             } else {
                deleteBtn.isHidden = false
            }
        }
        lblAssessment.text = date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func editClicked(_ sender: Any) {
        editCompletion?("")
    }
    
    @IBAction func delClicked(_ sender: Any) {
        deleteCompletion?("")
    }
    
}

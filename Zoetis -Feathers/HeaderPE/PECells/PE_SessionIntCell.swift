//
//  PE_FinalizeCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PE_SessionIntCell: UITableViewCell {
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblAssessment: UILabel!
    @IBOutlet weak var lblEvaluationDate: UILabel!
    @IBOutlet weak var lblEvaluationType: UILabel!
    @IBOutlet weak var lblEvaluator: UILabel!
    @IBOutlet weak var lblSiteName: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var idInfoImg: UIImageView!
    @IBOutlet weak var extendedMicroLbl: UILabel!
    
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
    
    func showToolTipTestInt(cell: PE_SessionIntCell, sender: UIView, refRange: String, tapGuesture: UITapGestureRecognizer) {
        
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
    
    func showToolTipTest(cell: PE_SessionCell, sender: UIView, refRange: String, tapGuesture: UITapGestureRecognizer) {
        
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
    func performShow(_ v: UIView?) {
        v?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut, animations: {
            v?.transform = .identity
        }) { finished in
            // do something once the animation finishes, put it here
        }
    }
    @objc func blackTransparentViewTapped(sender:UITapGestureRecognizer) {
        self.blackTranparentView.removeFromSuperview()
        self.tipView?.removeFromSuperview()
    }
    
    
    
    func config(peNewAssessment:PENewAssessment, index: IndexPath)  {
        self.tapGestureOnLabel1 = { (sender) in
            let assId = "C-" + "\(peNewAssessment.dataToSubmitID ?? "")"
            self.showToolTipTestInt(cell: self, sender: self.parentViewController?.view ?? UIView(), refRange: assId, tapGuesture: sender)
        }
        lblEvaluationDate.text = peNewAssessment.evaluationDate
        lblEvaluationType.text = peNewAssessment.evaluationName
        lblEvaluator.text = peNewAssessment.customerName
        lblSiteName.text = peNewAssessment.siteName
        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: peNewAssessment.serverAssessmentId ?? "")
        if infoObj?.isExtendedPE ?? false {
            extendedMicroLbl.text = "Yes"
        } else {
            extendedMicroLbl.text = "No"
        }
        let countryName = peNewAssessment.countryName
        if !Constants.isFromRejected {
            lblCountryName.text = countryName
        } else {
            lblCountryName.text = countryName
            lblAction.text = "Rejected"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


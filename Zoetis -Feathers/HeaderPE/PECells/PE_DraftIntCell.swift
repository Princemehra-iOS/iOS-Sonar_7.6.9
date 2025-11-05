//
//  PE_FinalizeCell.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 19/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class PE_DraftIntCell: UITableViewCell {
    
    // MARK: - OUTLETS

    @IBOutlet weak var lblCountryName: UILabel!
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
    
    // MARK: - VARIABLES

    var tipView: ToolTipView?
    let blackTranparentView = UIView()
    var tipPosition : ToolTipPosition = .middle
    var tapGestureOnLabel1 : ((UITapGestureRecognizer) -> ())?
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    var editCompletion:((_ string: String?) -> Void)?
    var deleteCompletion:((_ string: String?) -> Void)?
    
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
    
    func showToolTipTestInt(cell: PE_DraftIntCell, sender: UIView, refRange: String, tapGuesture: UITapGestureRecognizer) {
        
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
    
    func config(peNewAssessment:PENewAssessment)  {
        self.tapGestureOnLabel1 = { (sender) in
            let assId = "C-" + "\(peNewAssessment.draftID ?? "")"
            self.showToolTipTestInt(cell: self, sender: self.parentViewController?.view ?? UIView(), refRange: assId, tapGuesture: sender)
        }
        
        lblEvaluationDate.text = peNewAssessment.evaluationDate
        lblEvaluationType.text = peNewAssessment.evaluationName
        lblEvaluator.text = peNewAssessment.customerName
        lblSiteName.text = peNewAssessment.siteName
        lblCountryName.text = peNewAssessment.countryName
        
        let draftID = peNewAssessment.draftID ?? ""
        let date = "C-" + draftID.prefix(20)
        if peNewAssessment.statusType == 2 {
            rejectIndicatorBtn.isHidden = false
            deleteBtn.isHidden = true
        } else {
            rejectIndicatorBtn.isHidden = true
            deleteBtn.isHidden = false
        }
        lblAssessment.text = date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    // MARK: - IB ACTIONS

    @IBAction func editClicked(_ sender: Any) {
        editCompletion?("")
    }
    
    @IBAction func delClicked(_ sender: Any) {
        deleteCompletion?("")
    }
    
}

//
//  EnviromentalSampleInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 14/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

protocol EnviromentalSampleInfoCellDelegate: AnyObject {
    func locationValueButtonPressed(_ cell: EnviromentalSampleInfoCell)
    func bacterialCheckBoxButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton)
    func micoscoreCheckBoxButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton)
    func textFieldDidEndEditing(_ cell: EnviromentalSampleInfoCell, _ activeTextField: UITextField)
    func mediaTypeButtonPressed(_ cell: EnviromentalSampleInfoCell)
    func samplingTypeButtonPressed(_ cell: EnviromentalSampleInfoCell)
    func notesButtonPressed(_ cell: EnviromentalSampleInfoCell, _ sender: UIButton)
}

class EnviromentalSampleInfoCell: UITableViewCell {

    @IBOutlet weak var searchBarLocation: UISearchBar!
    @IBOutlet weak var plateIdLabel: UILabel!
    @IBOutlet weak var locationValueButton: customButton!
    @IBOutlet weak var locationValueTextField: UITextField!
    @IBOutlet weak var sampleDescriptionTextField: UITextField!
    @IBOutlet weak var sampleDescriptionButton: customButton!
    @IBOutlet weak var mediaTypeButton: customButton!
    @IBOutlet weak var samplingTypeButton: customButton!
    @IBOutlet weak var mediaTypeTextField: UITextField!
    @IBOutlet weak var infoIconImage: UIImageView!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var bacterialCheckBoxButton: UIButton!
    @IBOutlet weak var additionalTestLabel: UILabel!
    @IBOutlet weak var infoDetailButton: UIButton!
    @IBOutlet weak var lineBetweenCellsView: UIView!
    @IBOutlet weak var lineBetweenCellsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteButtonNew: UIButton!
    @IBOutlet weak var samplingTextField: UITextField!
    weak var delegate: EnviromentalSampleInfoCellDelegate?
    var requisitionSavedSessionType = REQUISITION_SAVED_SESSION_TYPE.CREATE_NEW_SESSION
    var isPlateIdGenerated = false
    var addInfoPlate : ((UIButton)->())?
    
    var tipView: ToolTipView?
    let blackTranparentView = UIView()
    var tipPosition : ToolTipPosition = .right
    var tapGestureOnLabel1 : ((UITapGestureRecognizer) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.disableAllEventsAccordingToSavedSession()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PE_SessionCell.tapFunctionForInfo))
                self.infoIconImage.isUserInteractionEnabled = true
                self.infoIconImage.addGestureRecognizer(tap1)
    }
    
    
    @objc func tapFunctionForInfo(sender: UITapGestureRecognizer) {
        self.tapGestureOnLabel1?(sender)
    }

    func disableAllEventsAccordingToSavedSession(){
        switch requisitionSavedSessionType {
        case .SHOW_SUBMITTED_REQUISITION_FOR_READ_ONLY:
            self.disableAllEvents()
            
        default: break
        }
    }
    
    func showNewTip(data : String) {
        self.tapGestureOnLabel1 = { (sender) in
            self.showToolTipTest(cell: self, sender: self.parentViewController?.view ?? UIView(), refRange: data, tapGuesture: sender)
        }
    }
    
   func showToolTipTest(cell: EnviromentalSampleInfoCell, sender: UIView, refRange: String, tapGuesture: UITapGestureRecognizer) {
   
//               self.tipView?.removeFromSuperview()
//               self.blackTranparentView.removeFromSuperview()
               
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
    func disableAllEventsAccordingToPlateIdsGenerated(){
        switch isPlateIdGenerated {
        case true:
            self.disableAllEvents()
        case false:
            self.enableAllEvents()
        }
    }
    
    
    func enableAllEvents(){
        locationValueButton.isUserInteractionEnabled = true
//        locationValueTextField.isUserInteractionEnabled = true
        sampleDescriptionTextField.isUserInteractionEnabled = true
        sampleDescriptionButton.isEnabled = true
        bacterialCheckBoxButton.isEnabled = true
        mediaTypeButton.isEnabled = true
       // mediaTypeTextField.isEnabled = true
    }
    
    func disableAllEvents(){
        locationValueButton.isUserInteractionEnabled = false
        locationValueTextField.isUserInteractionEnabled = false
        sampleDescriptionTextField.isUserInteractionEnabled = false
        sampleDescriptionButton.isEnabled = false
        bacterialCheckBoxButton.isEnabled = false
        mediaTypeButton.isUserInteractionEnabled = false
        mediaTypeTextField.isUserInteractionEnabled = false
        
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func ActionInfoDetailPlate(_ sender: UIButton) {
        addInfoPlate?(sender)
    }
    @IBAction func locationValueButtonPressed(_ sender: UIButton) {
        delegate?.locationValueButtonPressed(self)
    }
    
    @IBAction func bacterialCheckBoxButtonPressed(_ sender: UIButton) {
        delegate?.bacterialCheckBoxButtonPressed(self, sender)
    }
    @IBAction func micoscoreCheckBoxButtonPressed(_ sender: UIButton) {
        delegate?.micoscoreCheckBoxButtonPressed(self, sender)
    }
    
    @IBAction func mediaTypeButtonPressed(_ sender: UIButton) {
        delegate?.mediaTypeButtonPressed(self)
    }
    
    @IBAction func samplingMethodTypeButtonPressed(_ sender: UIButton) {
        delegate?.samplingTypeButtonPressed(self)
    }
    
    @IBAction func noteButtonNewPressed(_ sender: UIButton) {
        delegate?.notesButtonPressed(self, sender)
    }
    
    @IBAction func notesButtonPressed(_ sender: UIButton) {
        delegate?.notesButtonPressed(self, sender)
    }
}


//MARK: - Text field delegates
extension EnviromentalSampleInfoCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidEndEditing(self, textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension UIButton {
    func displayTooltip(_ message: String, completion: (() -> Void)? = nil) {
        let tooltipBottomPadding: CGFloat = 12
        let tooltipCornerRadius: CGFloat = 6
        let tooltipAlpha: CGFloat = 0.95
        let pointerBaseWidth: CGFloat = 14
        let pointerHeight: CGFloat = 8
        let padding = CGPoint(x: 18, y: 12)
        
        let tooltip = UIView()
        
        let tooltipLabel = UILabel()
        tooltipLabel.text = "    \(message)    "
        tooltipLabel.font = UIFont.systemFont(ofSize: 12)
        tooltipLabel.contentMode = .center
        tooltipLabel.textColor = .white
        tooltipLabel.layer.backgroundColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        tooltipLabel.layer.cornerRadius = tooltipCornerRadius
        
        tooltip.addSubview(tooltipLabel)
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.bottomAnchor.constraint(equalTo: tooltip.bottomAnchor, constant: -pointerHeight).isActive = true
        tooltipLabel.topAnchor.constraint(equalTo: tooltip.topAnchor).isActive = true
        tooltipLabel.leadingAnchor.constraint(equalTo: tooltip.leadingAnchor).isActive = true
        tooltipLabel.trailingAnchor.constraint(equalTo: tooltip.trailingAnchor).isActive = true
        
        let labelHeight = message.height(withWidth: .greatestFiniteMagnitude, font: UIFont.systemFont(ofSize: 12)) + padding.y
        let labelWidth = message.width(withHeight: .zero, font: UIFont.systemFont(ofSize: 12)) + padding.x
        
        let pointerTip = CGPoint(x: labelWidth / 2, y: labelHeight + pointerHeight)
        let pointerBaseLeft = CGPoint(x: labelWidth / 2 - pointerBaseWidth / 2, y: labelHeight)
        let pointerBaseRight = CGPoint(x: labelWidth / 2 + pointerBaseWidth / 2, y: labelHeight)
        
        let pointerPath = UIBezierPath()
        pointerPath.move(to: pointerBaseLeft)
        pointerPath.addLine(to: pointerTip)
        pointerPath.addLine(to: pointerBaseRight)
        pointerPath.close()
        
        let pointer = CAShapeLayer()
        pointer.path = pointerPath.cgPath
        pointer.fillColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 44 / 255, alpha: 1).cgColor
        
        tooltip.layer.addSublayer(pointer)
        (superview ?? self).addSubview(tooltip)
        tooltip.translatesAutoresizingMaskIntoConstraints = false
        tooltip.bottomAnchor.constraint(equalTo: topAnchor, constant: -tooltipBottomPadding + pointerHeight).isActive = true
        tooltip.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tooltip.heightAnchor.constraint(equalToConstant: labelHeight + pointerHeight).isActive = true
        tooltip.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        
        tooltip.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            tooltip.alpha = tooltipAlpha
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                tooltip.alpha = 0
            }, completion: { _ in
                tooltip.removeFromSuperview()
                completion?()
            })
        })
    }
}
extension String {
    func width(withHeight constrainedHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withWidth constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

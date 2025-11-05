//
//  CommentPopupViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 03/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation

class CommentPopupViewController: BaseViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: PEFormLabel!
    @IBOutlet weak var txtCommentTypt: UITextField!
    @IBOutlet weak var btnSelectComment: customButton!
    @IBOutlet weak var selectCommentTxt: UITextField!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var titleLblWidthContraints: NSLayoutConstraint!
    
    // MARK: - VARIABLES
    
    var infoText: String = ""
    var textOfTextView:String = ""
    var headerValue:String = "Notes"
    var titleValue:String = ""
    var editable:Bool = true
    var commentCompleted:((_ error: String?) -> Void)?
    
    // MARK: - METHODS

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        txtView.delegate = self
        txtView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        txtView.textContainer.lineFragmentPadding = 12
        txtView.text = ""
        headerLabel.text = headerValue
        titleLabel.text = titleValue
        titleLblWidthContraints.constant = 0
        //addLabelWithAstric(placeHolder: titleValue)
        okBtn.setNextButtonUI()
        btnCopy.setNextButtonUI()
        btnSelectComment.superview?.setDropdownStartAsessmentView(imageName:"dd")
        txtView.text = textOfTextView
        if editable {
            okBtn.isHidden = false
        } else {
            
            self.txtView.isUserInteractionEnabled = false
            okBtn.isUserInteractionEnabled = false
            okBtn.alpha = 0.6
            okBtn.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first ?? UITouch()
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    // MARK: - IB ACTIONS

    @IBAction func copyInfo(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string =  infoText
        if let _ = pasteboard.string {
            self.txtView.text = pasteboard.string
        }
    }
    
    @IBAction func btnCrossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonTapped(_ sender: Any) {
        self.commentCompleted?(txtView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actnCommentTYpe(_ sender: Any) {
        self.dropDownVIewNew(arrayData: ["User_Comment","Admin_Comment"], kWidth: btnSelectComment.frame.width, kAnchor: btnSelectComment, yheight: btnSelectComment.bounds.height) { [unowned self] selectedVal, index  in
            self.txtCommentTypt.text = selectedVal
        }
        self.dropHiddenAndShow()
    }
}

// MARK: - EXTENSION FOR TEXTFIELD DELEGATE

extension CommentPopupViewController:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ _textView: UITextView) -> Bool {
        return true
    }
}

//
//  CommentPopupViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 05/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation

//1. delegate method
protocol RefreshCommentIconBtnDelegate: AnyObject {
    func RefreshCommentBtnIcon()
}

class PVECommentPopupViewController: BaseViewController {

    weak var delegate: RefreshCommentIconBtnDelegate?

    @IBOutlet weak var okBtn: UIButton!
   
    @IBOutlet weak var txtCommentTypt: UITextField!
    @IBOutlet weak var btnSelectComment: customButton!
    @IBOutlet weak var selectCommentTxt: UITextField!
    @IBOutlet weak var txtView: UITextView!
   
    var seq_Number = Int()
    var rowId = Int()
    var commentStr = String()
    var timeStampStr = ""
    var typeStr = ""
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        txtView.delegate = self
        txtView.layer.borderColor = UIColor.getTextViewBorderColorStartAssessment().cgColor
        txtView.textContainer.lineFragmentPadding = 12
  
        okBtn.setNextButtonUI()
        btnSelectComment.superview?.setDropdownStartAsessmentView(imageName:"dd")
        if typeStr == "sync"{
            txtView.isUserInteractionEnabled = false
        }
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtView.text = commentStr

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            let touch: UITouch = touches.first!
            if (touch.view?.tag == 1111){
                self.dismiss(animated: true, completion: nil)
            }
        }

    @IBAction func btnCrossClicked(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonTapped(_ sender: Any) {

        
        if timeStampStr.count > 0 {
        CoreDataHandlerPVE().updateDraftCommentAssDetails(seq_Number, rowId: rowId, commentStr: commentStr, type: typeStr, syncId: timeStampStr)
        }else{

        CoreDataHandlerPVE().updateCommentAssementDetails(seq_Number, rowId: rowId, commentStr: commentStr)
        }
        delegate?.RefreshCommentBtnIcon()
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func actnCommentTYpe(_ sender: Any) {
    self.dropDownVIewNew(arrayData: ["User_Comment","Admin_Comment"], kWidth: btnSelectComment.frame.width, kAnchor: btnSelectComment, yheight: btnSelectComment.bounds.height) { [unowned self] selectedVal, index  in
          self.txtCommentTypt.text = selectedVal
         
          }
          self.dropHiddenAndShow()
    
    }
    
    //MARKS: DROP DOWN HIDDEN AND SHOW
     func dropHiddenAndShow(){
         if dropDown.isHidden{
             let _ = dropDown.show()
         } else {
             dropDown.hide()
         }
     }
}


extension PVECommentPopupViewController:UITextViewDelegate{
    //MARK...
    
    func textViewShouldBeginEditing(_ _textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView == txtView ) {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }else{
            let newString = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
            commentStr = newString
       }
        return true
    }
    
}

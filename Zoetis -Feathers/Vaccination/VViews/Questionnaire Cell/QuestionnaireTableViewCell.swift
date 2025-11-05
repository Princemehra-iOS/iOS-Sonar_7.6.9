//
//  QuestionnaireTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 15/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import UIKit

class QuestionnaireTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var segmentControl: UISwitch!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var colorVw: UIView!
    @IBOutlet weak var commentBtnVwConstraint: NSLayoutConstraint!
    
    // MARK: - VARIABLES
    
    static let identifier = "questionnaireTableViewCell"
    var commentCompletion:((_ error: String?) -> Void)?
    class var classIdentifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    var rowIndex:Int = -1
    var sectionIndex:Int = -1
    var questionObj: VaccinationQuestionVM?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationTxtField.delegate = self
        // Initialization code
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if let quesObj = questionObj{
            UserFilledQuestionnaireDAO.sharedInstance.updateQuestionUserResponse(vmObj: quesObj)
        }
        
    }
    
    @IBAction func commentBtnAction(_ sender: UIButton) {
        commentCompletion?(nil)
    }
    
    @IBAction func changeStateAction(_ sender: UISwitch) {
        
        if questionObj != nil {
              questionObj?.selectedResponse = segmentControl.isOn
              UserFilledQuestionnaireDAO.sharedInstance.updateQuestionUserResponse(vmObj: questionObj!)
              
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateQuestionnaireObj"), object: nil, userInfo: ["sectionIndex": sectionIndex, "rowIndex": rowIndex, "questionObj": questionObj])
          }
   
    }
    
    // MARK: - METHODS
    
    func showCommectVw(){
        print(appDelegateObj.testFuntion())
    }
    
    func hideCommentVw(){
        commentBtnVwConstraint.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func enableOrDisable(_ flag:Bool){
        segmentControl.isUserInteractionEnabled = flag
    }
    
    
    func setValues(questionObj: VaccinationQuestionVM){
        questionDescription.text = questionObj.questionDescription
        self.questionObj = questionObj
        segmentControl.isOn = questionObj.selectedResponse
        if questionObj.locationPhone != nil{
            locationTxtField.text = questionObj.locationPhone
        }
        if questionObj.questionType == "Textbox"{
            segmentControl.isHidden = true
            locationView.isHidden = false
            locationView.layer.borderColor = UIColor.black.cgColor
            locationView.layer.borderWidth = 1.0
        }else{
            locationView.isHidden = true
            segmentControl.isHidden = false
        }
        if  questionObj.userComments != nil && questionObj.userComments! != "" {
            let image = UIImage(named: Constants.peCommentSelectedStr)
            commentBtn.setImage(image, for: .normal)
        } else{
            let image = UIImage(named: Constants.peCommentImageStr)
            commentBtn.setImage(image, for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        questionObj?.locationPhone = textField.text
        UserFilledQuestionnaireDAO.sharedInstance.updateQuestionUserResponse(vmObj: questionObj!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateQuestionnaireObj"), object: nil, userInfo: ["sectionIndex":sectionIndex, "rowIndex":rowIndex, "questionObj":questionObj])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}



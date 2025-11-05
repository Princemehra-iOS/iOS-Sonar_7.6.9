//
//  PlateInfoCell.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 04/11/20.
//


import Foundation
import UIKit

class PlateInfoCell: UITableViewCell {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var sampleNumberLbl: UILabel!
    @IBOutlet weak var plateTypeTxtField: UITextField!
    @IBOutlet weak var plateLocationLbl: UILabel!
    @IBOutlet weak var bacteriaTxtField: UITextField!
    @IBOutlet weak var blueGreenMoldTxtField: UITextField!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var plateTypeBtn: UIButton!
    
    // MARK: - VARIABLES
    
    var quesObj:PE_ExtendedPEQuestion?
    var currentIndex = -1
    var assessmentId:String?
    var plateTypeCompletion:((_ string: String?) -> Void)?
    var commentsCompletion:((_ string: String?) -> Void)?
    
    // MARK: - INITIAL METHODS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plateTypeTxtField.delegate = self
        bacteriaTxtField.delegate = self
        blueGreenMoldTxtField.delegate = self
        plateTypeTxtField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        bacteriaTxtField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        blueGreenMoldTxtField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: - METHODS
    
    func setValues(quesObj:PE_ExtendedPEQuestion, index: Int){
        sampleNumberLbl.text = quesObj.sampleId
        if index < 19{
            plateTypeTxtField.text = "TSA"
        }else{
            plateTypeTxtField.text = "MacConkey"
        }
        plateLocationLbl.text = quesObj.questionDescription
        if let bCount = quesObj.bacteriaCount{
            bacteriaTxtField.text = "\(bCount)"
        }
        if let bMoldCount = quesObj.blueGreenMoldCount{
            blueGreenMoldTxtField.text = "\(bMoldCount)"
        }
        if let score = quesObj.currentScore{
            scoreLbl.text = "\(score)"
        }
        if quesObj.userComments != nil && quesObj.userComments != ""{
            let image = UIImage(named: Constants.peCommentSelectedStr)
            noteBtn.setImage(image, for: .normal)
        }else{
            let image = UIImage(named: Constants.peCommentImageStr)
            noteBtn.setImage(image, for: .normal)
        }
        self.quesObj = quesObj
    }
    // MARK: - Update Score
    func updateScore(){
        if self.quesObj?.questionDescription != "Control (Non Exposed) Plate"{
            var score = 0
       /* doubt for this change as per sonar */
            if let bacteriaCount = self.quesObj?.bacteriaCount,
               let blueGreenMoldCount = self.quesObj?.blueGreenMoldCount {
                score = (bacteriaCount < 5 && blueGreenMoldCount < 1) ? 5 : 0
                scoreLbl.text = "\(score)"
                self.quesObj?.currentScore = score
            }
        }
        
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField){
        switch textField {
        case plateTypeTxtField:
            
            break;
        case bacteriaTxtField:
            if bacteriaTxtField.text == "" || bacteriaTxtField.text == nil{
                self.quesObj?.bacteriaCount = 0
            }else{
                self.quesObj?.bacteriaCount = Int32(bacteriaTxtField.text ?? "0") ?? 0
            }
            break;
        case blueGreenMoldTxtField:
            
            if blueGreenMoldTxtField.text == "" || blueGreenMoldTxtField.text == nil{
                self.quesObj?.blueGreenMoldCount = 0
                
            }else{
                self.quesObj?.blueGreenMoldCount = Int32(blueGreenMoldTxtField.text ?? "0") ?? 0
            }
            break;
        default:
            break;
            
        }
        updateScore()
        if self.quesObj != nil{
            SanitationEmbrexQuestionMasterDAO.sharedInstance.updateAssessmentQuestion(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: assessmentId ?? "", questionId: Int64(self.quesObj?.questionId ?? "0")!, questionVM: self.quesObj!)
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshExtendedPEScores"), object: nil, userInfo: nil)
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func plateTypeBtnAction(_ sender: UIButton) {
        plateTypeCompletion?("")
    }
    
    @IBAction func noteBtnAction(_ sender: UIButton) {
        commentsCompletion?("")
    }
    
}

// MARK: - EXTENSION FOR TEXTFIELD DELEGATE

extension PlateInfoCell: UITextFieldDelegate {
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {self.endEditing(true)}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0"{
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if bacteriaTxtField.text == "" || bacteriaTxtField.text == nil{
            self.quesObj?.bacteriaCount = 0
            bacteriaTxtField.text = "0"
        }else{
            self.quesObj?.bacteriaCount = Int32(bacteriaTxtField.text ?? "0") ?? 0
        }
        
        if blueGreenMoldTxtField.text == "" || blueGreenMoldTxtField.text == nil{
            blueGreenMoldTxtField.text = "0"
            self.quesObj?.blueGreenMoldCount = 0
            
        }else{
            self.quesObj?.blueGreenMoldCount = Int32(blueGreenMoldTxtField.text ?? "0") ?? 0
        }
        updateScore()
        if self.quesObj != nil{
            SanitationEmbrexQuestionMasterDAO.sharedInstance.updateAssessmentQuestion(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: assessmentId ?? "", questionId: Int64(self.quesObj?.questionId ?? "0")!, questionVM: self.quesObj!)
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshExtendedPEScores"), object: nil, userInfo: ["index":currentIndex])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == bacteriaTxtField || textField == blueGreenMoldTxtField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
}

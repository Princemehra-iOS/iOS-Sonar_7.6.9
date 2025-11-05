//
//  PVEVaccinationCrewSafetyCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 26/12/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit
protocol saveVaccineCheckPVECrewSafetyCell: AnyObject {
    func liveVaccineSwitch (State : Bool ,SelectedIndex: Int)
}
class PVEVaccinationCrewSafetyCell: UITableViewCell {
    
    var saveDelegate: saveVaccineCheckPVECrewSafetyCell?
    
    let sharedManager = PVEShared.sharedInstance
    var currentAssessmentDetails = [String : AnyObject]()
    var selectedAssessmentId = Int()
    var qArrr = NSArray()
    var currentInd = IndexPath()
    @IBOutlet weak var cameraIcon : UIImageView!
    @IBOutlet weak var cameraBtn : UIButton!
    @IBOutlet weak var notesBtn : UIButton!
    @IBOutlet weak var imgCountBtn : UIButton!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var addCommentView: UIView!
    
    @IBOutlet weak var addComment: UITextView!
    @IBOutlet weak var txtField : UITextField!
    @IBOutlet weak var txtFieldBtn : UIButton!
    
    @IBOutlet weak var subHeaderLbl: UILabel!
    @IBOutlet weak var subHeaderBgLineLbl: UILabel!
    @IBOutlet weak var subHeaderBgBoxLbl: UILabel!
    
    @IBOutlet weak var assessmentLbl: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    var vaccineStateBool = Bool()
    
    var timeStampStr = ""
    var typeStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellAndControllsNew(qArr:NSArray, currentIndd:NSIndexPath) {
        
        currentInd = currentIndd as IndexPath
        qArrr = qArr
        
        
        let assessmentStrArr = qArr.value(forKey: "assessment") as? [String]
        let assessmentStr = assessmentStrArr![currentInd.row]
        
        let typesStrArr = qArr.value(forKey: "types") as? [String]
        let typesStr = typesStrArr![currentInd.row]
        
        let isSelectedArr = qArr.value(forKey: "isSelected") as? [Bool]
        let isSelected = isSelectedArr![currentInd.row]
        
        let max_ScoreArr = qArr.value(forKey: "max_Score") as? [Int]
        let max_Score = max_ScoreArr![currentInd.row]
        
        if max_Score > 0 {
            
            assessmentLbl.text = "(\(max_Score)) \(assessmentStr)"
            assessmentLbl.attributedText = assessmentLbl.text?.withBoldText(text: "\(max_Score)")
            //
        }else{
            assessmentLbl.text = "\(assessmentStr)"
        }
        
        switch typesStr {
        case "Drop Value":
            switchBtn.isHidden = false
            switchBtn.isOn = isSelected
            txtField.isHidden = true
        case "Text":
            switchBtn.isHidden = true
            txtField.isHidden = false
        default:
            
            break
            //   print("No control matched")
        }
        
        txtFieldBtn.isHidden = txtField.isHidden
        
        let enteredTextArr = qArr.value(forKey: "enteredText") as? [String]
        let enteredTextStr = enteredTextArr![currentInd.row]
        
        txtField.text = "\(enteredTextStr)"
        let valuee = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Session")
        let valueArr = valuee.value(forKey: "cameraEnabled") as! NSArray
        if valueArr.count > 0 {
            let isCameraOn = valueArr[0] as! String
            if isCameraOn == "true"{
                cameraIcon.alpha = 1.0
                cameraBtn.alpha = 1.0
            }else{
                cameraIcon.alpha = 0.2
                cameraBtn.alpha = 0.2
            }
            
        }
        
        let commentArr = qArrr.value(forKey: "comment") as? [String]
        let comment = commentArr![currentInd.row]
        if comment.count > 0 {
            notesBtn.setImage(UIImage(named: Constants.peCommentSelectedStr), for: .normal)
        }else{
            notesBtn.setImage(UIImage(named: "commentIconPE.png"), for: .normal)
        }
        
        let seq_NumberArr = qArrr.value(forKey: "seq_Number") as? [Int]
        let seq_Number = seq_NumberArr![currentInd.row]
        
        let idArr = qArr.value(forKey: "id") as? [Int]
        let id = idArr![currentInd.row]
        
        var tempArr = NSArray()
        if timeStampStr.count > 0{
            tempArr = CoreDataHandlerPVE().getImageDataForCurrentAssementDetails(timeStampStr, seqNumber: NSNumber(value: seq_Number), rowId: id, entity: "PVE_ImageEntitySync")
        }else{
            tempArr = CoreDataHandlerPVE().getImageDataForCurrentAssementDetails(timeStampStr, seqNumber: NSNumber(value: seq_Number), rowId: id, entity: "PVE_ImageEntity")
        }
        
        if tempArr.count > 0 {
            imgCountBtn.isHidden = false
            imgCountBtn.setTitle("\(tempArr.count)", for: .normal)
            //   print("In Cell before tempArr--\(tempArr.count)")
        }else{
            imgCountBtn.isHidden = true
        }
        
        subHeaderLbl.isHidden = true
        subHeaderBgLineLbl.isHidden = subHeaderLbl.isHidden
        subHeaderBgBoxLbl.isHidden = subHeaderLbl.isHidden
        
        subHeaderLbl.layer.cornerRadius = 5
        subHeaderLbl.layer.masksToBounds = true
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func methodExtracted1(_ id: Int, _ btnStateBool: Bool, _ seq_Number: Int) {
        if id == 127 || id == 128 {
            if btnStateBool == true {
                if id == 127 {
                    CoreDataHandlerPVE().updateDraftAssDetails(seq_Number, id: 128, isSel: !btnStateBool, type: typeStr, syncId: timeStampStr)
                } else {
                    CoreDataHandlerPVE().updateDraftAssDetails(seq_Number, id: 127, isSel: !btnStateBool, type: typeStr, syncId: timeStampStr)
                }
            }
            CoreDataHandlerPVE().updateDraftAssDetails(seq_Number, id: id, isSel: btnStateBool, type: typeStr, syncId: timeStampStr)
        } else {
            CoreDataHandlerPVE().updateDraftAssDetails(seq_Number, id: id, isSel: btnStateBool, type: typeStr, syncId: timeStampStr)
        }
        
        CoreDataHandlerPVE().updateStatusForSync(timeStampStr, text: false, forAttribute: "syncedStatus")
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        var btnStateBool = true
        
        let isSelectedArr = qArrr.value(forKey: "isSelected") as? [Bool]
        let isSelected = isSelectedArr![currentInd.row]
        
        let seq_NumberArr = qArrr.value(forKey: "seq_Number") as? [Int]
        let seq_Number = seq_NumberArr![currentInd.row]
        
        let idArr = qArrr.value(forKey: "id") as? [Int]
        let id = idArr![currentInd.row]
        btnStateBool = true

        if isSelected == true {
            btnStateBool = false
        }
        
        if timeStampStr.count > 0 {
            methodExtracted1(id, btnStateBool, seq_Number)
            
        } else {// updateDraftAssDetails
            if id == 127 || id == 128 {
                if btnStateBool == true
                {
                    if id == 127 {
                        CoreDataHandlerPVE().updateAssementDetails(seq_Number, id: 128, isSel: !btnStateBool)
                    } else {
                        CoreDataHandlerPVE().updateAssementDetails(seq_Number, id: 127, isSel: !btnStateBool)
                    }
                }
                CoreDataHandlerPVE().updateAssementDetails(seq_Number, id: id, isSel: btnStateBool)
            } else {
                CoreDataHandlerPVE().updateAssementDetails(seq_Number, id: id, isSel: btnStateBool)
            }
        }
    }
}


extension PVEVaccinationCrewSafetyCell: UITextFieldDelegate{
    
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
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "1234567890").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        
        if newString.count > 5{
            return false
        }
        
        if newString.count > 0 {
            
            let seq_NumberArr = qArrr.value(forKey: "seq_Number") as? [Int]
            let seq_Number = seq_NumberArr![currentInd.row]
            
            let idArr = qArrr.value(forKey: "id") as? [Int]
            let id = idArr![currentInd.row]
            
            if timeStampStr.count > 0 {
                CoreDataHandlerPVE().updateDraftAssFieldTextDetails(seq_Number, id: id, text: newString, type: typeStr, syncId: timeStampStr)
                CoreDataHandlerPVE().updateStatusForSync(timeStampStr, text: false, forAttribute: "syncedStatus")
                
            }else{
                CoreDataHandlerPVE().updateAssementFieldTextDetails(seq_Number, id: id, text: newString)
            }
            
        }
        return true
    }
    
}


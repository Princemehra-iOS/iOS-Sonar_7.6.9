//
//  Vaccine_NoteTypeCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 04/03/22.
//

import Foundation
import UIKit
import Siren

protocol AddedComment: AnyObject {
    func updatedComment( commentStr: String)
    
}

class Vaccine_NoteTypeCell: UITableViewCell {
    
    weak var delegate: AddedComment?
    var TimeStampCurrent = ""
    @IBOutlet weak var notetxtView: UITextField!
    var timeStampStr = ""
    var type = ""
    var currentIndPath = NSIndexPath()
    var QuesIdArr = NSArray()
    var SwitchState = Bool()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notetxtView.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension Vaccine_NoteTypeCell: UITextFieldDelegate {
    
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
    
    fileprivate func handleIndex4(_ idArr: [Int]?, _ newString: String) {
        if let dataArr = idArr {
            for index in 0..<dataArr.count {
                if SwitchState {
                    
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDraft(SwitchState , id: idArr![index], type: "draft", syncId: timeStampStr , forAttribute: "liveVaccineSwitch" , comment: "" , forComment : "liveComment")
                } else {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDraft(SwitchState, id: idArr![index], type: "draft", syncId: timeStampStr, forAttribute: "liveVaccineSwitch" , comment: newString , forComment : "liveComment")
                }
            }
        }
    }
    
    fileprivate func handleDataArrElse(_ idArr: [Int]?, _ newString: String) {
        if let dataArr = idArr {
            for index in 0..<dataArr.count {
                if SwitchState {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDraft(SwitchState,  id: idArr![index], type: "draft", syncId: timeStampStr, forAttribute: "inactiveVaccineSwitch" , comment: "",  forComment : "inactiveComment")
                } else {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDraft(SwitchState,  id: idArr![index], type: "draft", syncId: timeStampStr, forAttribute: "inactiveVaccineSwitch" , comment: newString,  forComment : "inactiveComment")
                }
            }
        }
    }
    
    fileprivate func handleCurrentIndexNotDraft(_ idArr: [Int]?, _ newString: String) {
        if let dataArr = idArr {
            for index in 0..<dataArr.count {
                if SwitchState {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], SwitchState, forAttribute: "liveVaccineSwitch" , comment: "" , forComment : "liveComment")
                } else {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], SwitchState, forAttribute: "liveVaccineSwitch", comment: newString,  forComment : "liveComment")
                }
            }
        }
    }
    
    fileprivate func handleElseNotDraftSectionNot4(_ idArr: [Int]?, _ newString: String) {
        if let dataArr = idArr {
            for index in 0..<dataArr.count {
                if SwitchState {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], SwitchState, forAttribute: "inactiveVaccineSwitch" ,comment: "",  forComment : "inactiveComment")
                } else {
                    CoreDataHandlerPVE().updateLiveVaccineSavedInDB(id: idArr![index], SwitchState, forAttribute: "inactiveVaccineSwitch" , comment: newString,  forComment : "inactiveComment")
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let idArr = (QuesIdArr).value(forKey: "id") as? [Int]
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(newString)
        
        if newString.count > 60 {
            return false
        }
        
        if type == "draft" {
            if currentIndPath.section == 4 {
                handleIndex4(idArr, newString)
            } else {
                handleDataArrElse(idArr, newString)
            }
        } else {
            
            if currentIndPath.section == 4 {
                handleCurrentIndexNotDraft(idArr, newString)
            } else {
                handleElseNotDraftSectionNot4(idArr, newString)
            }
        }
        return true
    }
}

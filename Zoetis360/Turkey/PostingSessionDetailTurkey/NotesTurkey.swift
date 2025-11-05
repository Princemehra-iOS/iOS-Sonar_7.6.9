//
//  NotesTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 27/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

// MARK: - PROTOCOL & FUNCTIONS
protocol turkeyNotes {
    func openNoteFunc ()
    func doneBtnFunc (_ notes : NSMutableArray , notesText : String , noOfBird : Int)
    func postingNotesdoneBtnFunc(_ notesText : String)
}

class NotesTurkey: UIView {
    
    // MARK: - VARIABLES
    var notesDelegate: turkeyNotes!
    var noOfBird :Int!
    var necId : Int!
    var strExist :String!
    var necIdFromExisting :Int!
    var finalizeValue :Int!
    var notesDict : NSMutableArray!
    
    // MARK: - OUTLETS
    @IBOutlet weak var mainViewBck: UIView!
    @IBOutlet weak var doneButtobn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - IBACTIONS
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        
        notesDelegate.doneBtnFunc(self.notesDict ,notesText: textView.text,noOfBird: noOfBird)
        notesDelegate.postingNotesdoneBtnFunc(textView.text)
    }
    
    @IBAction func crossBtnAction(_ sender: UIButton) {
        
        notesDelegate.openNoteFunc()
    }
    
    @IBAction func cancelBttn(_ sender: AnyObject) {
        
        notesDelegate.openNoteFunc()
    }
    
    // MARK: - TEXTFIELD DELEGATES
    func textViewShouldReturn(_ textView: UITextView){
        
        textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    override func draw(_ rect: CGRect) {
        
        textView.isEditable = true
        doneButtobn.alpha = 1
        
        if notesDict.count > 0 {
            
            let skleta : CaptureNecropsyViewDataTurkey = notesDict.object(at: 0) as! CaptureNecropsyViewDataTurkey
            
            let formName = skleta.formName
            let catName  = skleta.catName
            
            if strExist == "Exting"{
                necId = necIdFromExisting
                
            } else {
                necId = UserDefaults.standard.integer(forKey: "necId") as Int
            }
            
            let isNotes = CoreDataHandlerTurkey().fetchNoofBirdWithNotesTurkey(catName!, formName: formName!, birdNo: noOfBird as NSNumber,necId: necId as NSNumber)
            if isNotes.count > 0 {
                let note : NotesBirdTurkey = isNotes[0] as! NotesBirdTurkey
                textView.text =  note.notes
            }
            
        } else {
            
            let str =  UserDefaults.standard.value(forKey: "postingSessionNotes") as! String
            if str.isEmpty {
                debugPrint("textview is empty.")
            } else {
                textView.text = str
            }
        }
        
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        mainViewBck.layer.borderWidth = 1.0
        mainViewBck.layer.cornerRadius = 8
    }
    
    
}

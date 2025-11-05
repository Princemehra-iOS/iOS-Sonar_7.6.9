//
//  DatepickerClass.swift
//  Zoetis -Feathers
//
//  Created by "" on 12/28/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
protocol DatePickerDelegateCommon: class {
    func didCancel()
    func didDone()
}


class DatepickerClass: NSObject {
    
    weak var delegate:DatePickerDelegateCommon?
    static let sharedInstance = DatepickerClass()
    
    func pickUpDate() -> (button: UIButton, donebutton: UIBarButtonItem ,spaceButton:UIBarButtonItem, cancelButton : UIBarButtonItem ,datePicker:UIDatePicker) {
        
        let buttonBg: UIButton = UIButton()
        buttonBg.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.8)
      
        var xFrame = Int()
        var widthFrame = Int()
        
        if #available(iOS 13.4, *) {
            xFrame = 350
            widthFrame = 320
        }else{
            xFrame = 200
            widthFrame = 600
        }
        // DatePicker
        var  datePicker = UIDatePicker(frame:CGRect(x: xFrame, y: 200, width: widthFrame, height: 300))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 3
        datePicker.layer.borderColor = UIColor.white.cgColor

        var xToolBar = Int()
        var widthToolBar = Int()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = UIColor.white
            xToolBar = 350
            widthToolBar  = 320
        }else{
            xToolBar = 200
            widthToolBar  = 600
        }
        buttonBg.addSubview(datePicker)
  
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.frame = CGRect(x: xToolBar, y: 150, width: widthToolBar, height: 50)
        toolBar.isTranslucent = true
        toolBar.layer.borderWidth = 1
        toolBar.layer.cornerRadius = 3
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.tintColor = UIColor.red
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action:nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        buttonBg.addSubview(toolBar)
        return ( buttonBg, doneButton, spaceButton ,  cancelButton, datePicker)
        
    }
    func setMaximumDate() -> (button: UIButton, donebutton: UIBarButtonItem ,spaceButton:UIBarButtonItem, cancelButton : UIBarButtonItem ,datePicker:UIDatePicker) {
        
        let buttonBg: UIButton = UIButton()
        buttonBg.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.8)
       
        
        var datePicker = UIDatePicker(frame:CGRect(x: 200, y: 200, width: 600, height: 300))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 3
        datePicker.layer.borderColor = UIColor.white.cgColor
        datePicker.maximumDate = Date()
        
        buttonBg.addSubview(datePicker)
       
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.frame = CGRect(x: 200, y: 150, width: 600, height: 50)
        toolBar.isTranslucent = true
        toolBar.layer.borderWidth = 1
        toolBar.layer.cornerRadius = 3
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.tintColor = UIColor.red
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action:nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        buttonBg.addSubview(toolBar)
        return ( buttonBg, doneButton, spaceButton ,  cancelButton, datePicker)
    }
}


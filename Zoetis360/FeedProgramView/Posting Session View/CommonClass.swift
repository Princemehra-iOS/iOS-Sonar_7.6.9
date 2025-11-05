////  CommonClass.swift
////  Zoetis -Feathers
////  Created by "" on 23/08/16.
////  Copyright © 2016 "". All rights reserved.
//  CommonClass.swift
//  Zoetis -Feathers
//  Created by "" on 23/08/16.
//  Copyright © 2016 "". All rights reserved.

import UIKit

protocol DatePickerDelegate: class {
    func didCancel()
    func didDone()
}
func showDropDown(_ button:UIButton, lblName: UILabel, array:NSArray,tagSelection:Int) {
    
    if (button.superview?.frame)!.height - button.frame.origin.y < 200 {
        Dropper.sharedInstance.showWithAnimationWithBlocks(0.15, options: .left, position: .top, button:button , newItems:array, tagSelection: tagSelection) { (routeResponse,strainResponse,fieldResponse,dosageResponse)  in
            print(routeResponse)
            
            if tagSelection == 1 {
                
                lblName.text = routeResponse?.routeName
            } else if tagSelection == 10{
                lblName.text = strainResponse?.strainName
                
            }
            else if tagSelection == 30{
                
                lblName.text = dosageResponse?.doseName
                
            }
            else {
                lblName.text = fieldResponse?.strainName
                
            }
        }}
    else {
        Dropper.sharedInstance.showWithAnimationWithBlocks(0.15, options: .left, position: .bottom, button:button , newItems:array, tagSelection: tagSelection) { (routeResponse,strainResponse,fieldResponse,dosageResponse) in
            
            
            if tagSelection == 1 {
                
                lblName.text = routeResponse?.routeName
            } else if tagSelection == 10{
                lblName.text = strainResponse?.strainName
                
            } else if tagSelection == 30{
                lblName.text = dosageResponse?.doseName
                
                
            } else {
                lblName.text = fieldResponse?.strainName
                
            }
        }
    }
}
func hideDropDown() {
    
    Dropper.sharedInstance.hideWithAnimation(0.1)
}


//////// Turkey
func showDropDownTurkey(_ button:UIButton, lblName: UILabel, array:NSArray,tagSelection:Int ) {
    
    if (button.superview?.frame)!.height - button.frame.origin.y < 200 {
        DropperTurkey.sharedInstance.showWithAnimationWithBlocks(0.15, options: .left, position: .top, button:button , newItems:array, tagSelection: tagSelection) { (responseData,strainResponse,fieldResponse) in
            print(responseData)
            
            // lblName.text = responseData?.routeName
            
            if tagSelection == 1 {
                
                lblName.text = responseData?.routeName
            } else if tagSelection == 10{
                lblName.text = strainResponse?.strainName
                
            }else{
                lblName.text = fieldResponse?.strainName
                
                
            }
            
            
        }
    } else {
        
        DropperTurkey.sharedInstance.showWithAnimationWithBlocks(0.15, options: .left, position: .bottom, button:button , newItems:array, tagSelection: tagSelection) { (responseData,strainResponse,fieldResponse) in
            print(responseData)
            //lblName.text = responseData?.routeName
            if tagSelection == 1 {
                
                lblName.text = responseData?.routeName
            } else if tagSelection == 10{
                lblName.text = strainResponse?.strainName
                
            }else {
                lblName.text = fieldResponse?.strainName
                
                
            }
            
        }
    }
}
func hideDropDownTurkey() {
    
    DropperTurkey.sharedInstance.hideWithAnimation(0.1)
}

class CommonClass: NSObject {
    
    weak var delegate:DatePickerDelegate?
    static let sharedInstance = CommonClass()
    
    func pickUpDate() -> (button: UIButton, donebutton: UIBarButtonItem ,spaceButton:UIBarButtonItem, cancelButton : UIBarButtonItem ,datePicker:UIDatePicker) {
        
        let buttonBg: UIButton = UIButton()
        var xFrame = Int()
        var widthFrame : Int
        
        if #available(iOS 13.4, *) {
            xFrame = 350
            widthFrame = 320
        }else{
            xFrame = 200
            widthFrame = 600
        }
        buttonBg.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonBg.frame = CGRect(x: 0, y: 0, width: 400, height: 400) // X, Y, width, height
        buttonBg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.8)
      
        // DatePicker
        var datePicker = UIDatePicker(frame: CGRect(x: xFrame, y: 200, width: widthFrame, height: 350))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        var xToolBar = CGFloat()
        var widthToolBar = Int()
        if #available(iOS 13.4, *) {
            xToolBar = CGFloat(350)
            widthToolBar  = 320
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = UIColor.white
        }else{
            xToolBar = CGFloat(200)
            widthToolBar = 600
        }
        
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 3
        datePicker.layer.borderColor = UIColor.white.cgColor
        // New addition prince
        //        datePicker.calendar = Calendar(identifier: .gregorian)
        //        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.month = -12
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate as NSDate
        datePicker.minimumDate = minDate as Date
        
        buttonBg.addSubview(datePicker)
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.frame = CGRect(x: xToolBar, y: (datePicker.frame.origin.y - 50), width: CGFloat(widthToolBar), height: CGFloat(50.0))
        toolBar.isTranslucent = true
        toolBar.layer.borderWidth = 1
        toolBar.layer.cornerRadius = 3
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.tintColor = UIColor.red
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: nil, action: nil)
        
        // doneButton.
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action:nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        buttonBg.addSubview(toolBar)
        return ( buttonBg, doneButton, spaceButton ,  cancelButton, datePicker)
    }
    
    
    func pickUpDateFeed() -> (button: UIButton, donebutton: UIBarButtonItem ,spaceButton:UIBarButtonItem, cancelButton : UIBarButtonItem ,datePicker:UIDatePicker) {
        
        let buttonBg: UIButton = UIButton()
        var xFrame = Int()
        
        if #available(iOS 13.4, *) {
            xFrame = 350
            
        }else{
            xFrame = 200
            
        }
        buttonBg.setTitleColor(UIColor.blue, for: UIControl.State())
        buttonBg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonBg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.8)
       
        // DatePicker
        let  datePicker = UIDatePicker(frame:CGRect(x: xFrame, y: 200, width: 600, height: 300))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 3
        datePicker.layer.borderColor = UIColor.white.cgColor
   
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = UIColor.white
        }

        var xToolBar = Int()
        var widthToolBar = Int()
        if #available(iOS 13.4, *) {
            xToolBar = 350
            widthToolBar  = 320
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = UIColor.white
        }else{
            xToolBar = 200
            widthToolBar = 600
        }

        buttonBg.addSubview(datePicker)
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.frame = CGRect(x: xToolBar, y: 150, width: widthToolBar, height: 50)
        toolBar.isTranslucent = true
        toolBar.layer.borderWidth = 1
        toolBar.layer.cornerRadius = 3
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.tintColor = UIColor.red
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: nil, action: nil)
        
        // doneButton.
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action:nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        buttonBg.addSubview(toolBar)
        return ( buttonBg, doneButton, spaceButton ,  cancelButton, datePicker)
    }
    
    
    func updateCount (){
        
        let totalExustingArr = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSession = totalExustingArr.object(at: i) as! PostingSession
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandler().FetchFeedProgram(pid!)
            if feedProgram.count == 0{
                CoreDataHandler().updatePostingSessionOndashBoard(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandler().deletefieldVACDataWithPostingId(pid!)
                CoreDataHandler().deleteDataWithPostingIdHatchery(pid!)
            }
            
        }
    }
    
    func updateCountTurkey(){
        let totalExustingArr = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(1, birdTypeId: 1).mutableCopy() as! NSMutableArray
        for i in 0..<totalExustingArr.count{
            let postingSession : PostingSessionTurkey = totalExustingArr.object(at: i) as! PostingSessionTurkey
            let pid = postingSession.postingId
            let feedProgram =  CoreDataHandlerTurkey().FetchFeedProgramTurkey(pid!)
            if feedProgram.count == 0{
                CoreDataHandlerTurkey().updatePostingSessionOndashBoardTurkey(pid!, vetanatrionName: "", veterinarianId: 0, captureNec: 2)
                CoreDataHandlerTurkey().deletefieldVACDataWithPostingIdTurkey(pid!)
                CoreDataHandlerTurkey().deleteDataWithPostingIdHatcheryTurkey(pid!)
            }
        }
    }
}

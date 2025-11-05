//
//  DatePickerPopupViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 14/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol DatePickerPopupViewControllerProtocol {
    func doneButtonTapped(string:String)
    
    func doneButtonTappedWithDate(string:String, objDate:Date)
    
}

class DatePickerPopupViewController: BaseViewController {
    @IBOutlet weak var buttonBg: UIButton!
    var delegate: DatePickerPopupViewControllerProtocol?
    var canSelectPreviousDate : Bool = false
    var isPVE : Bool = false
    var isPVEVacExpiry : Bool = false
    var isVaccinationModule:Bool = false
    var evaluationDate:String?
    var isCertificateDate = 0
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!
    var regionID = Int()
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        regionID = UserDefaults.standard.integer(forKey: "Regionid")
        pickUpDate()
    }
    
    func pickUpDate() {
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 3
        datePicker.layer.borderColor = UIColor.white.cgColor
        let components: NSDateComponents = NSDateComponents()
        components.month = -12

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.backgroundColor = .white
        }
        
        if isPVE == true {
            datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
        } else if isPVEVacExpiry == true && canSelectPreviousDate == true{
            let theDaysLater = TimeInterval(1200.months)
            datePicker.minimumDate = Date().addingTimeInterval(-theDaysLater)
        } else if isVaccinationModule && canSelectPreviousDate{
            let theDaysLater = TimeInterval(1200.months)
            datePicker.minimumDate = Date().addingTimeInterval(-theDaysLater)
            datePicker.maximumDate = Date()
        } else {
            if evaluationDate != nil && evaluationDate != "" {
                let theDaysLater = TimeInterval(3.months)
                let dateFormatterObj = CodeHelper.sharedInstance.getDateFormatterObj("")
                dateFormatterObj.dateFormat = Constants.MMddyyyyStr
                
                if regionID != 3 {
                    dateFormatterObj.dateFormat = Constants.ddMMyyyStr
                }
                
                let evaluationDateObj = dateFormatterObj.date(from:self.evaluationDate!)
                
                let currentQuarterDate = evaluationDateObj?.startOfQuarter.startOfMonth()
                let lastDateOfCurrentQuarter = currentQuarterDate?.addingTimeInterval(theDaysLater).endOfMonth()
                if currentQuarterDate != nil && lastDateOfCurrentQuarter != nil {
                    datePicker.minimumDate = currentQuarterDate
                    datePicker.maximumDate =  lastDateOfCurrentQuarter
                }
            } else {
                
                if isCertificateDate == 0 {
                    let theDaysLater = TimeInterval(3.months)
                    datePicker.minimumDate = Date().addingTimeInterval(-theDaysLater)
                    datePicker.maximumDate = Date()
                }
            }
        }
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.layer.borderWidth = 1
        toolBar.layer.cornerRadius = 3
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.tintColor = UIColor.red
        
        // Adding Button ToolBar
        let donebutton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: nil, action: #selector(doneClick1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: nil, action: #selector(dismissKeyboard))
        toolBar.setItems([cancelButton,spaceButton,donebutton], animated: false)
        toolBar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneClick1() {
        let dateFormatter = DateFormatter()
        if regionID != 3 {
            dateFormatter.dateFormat = Constants.ddMMyyyStr
        } else {
            dateFormatter.dateFormat=Constants.MMddyyyyStr
        }
        
        let strdate1 = dateFormatter.string(from: datePicker.date) as String

        delegate?.doneButtonTappedWithDate(string: strdate1, objDate: datePicker.date)
        self.isPVE = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelClick1() {
        dismiss(animated: true, completion: nil)
        self.isPVE = true
    }
    
    @objc func buttonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    var formatted: String {
        return Date.formatter.string(from: self)
    }
}

extension Int {
    
    var seconds: Int {
        return self
    }
    
    var minutes: Int {
        return self.seconds * 60
    }
    
    var hours: Int {
        return self.minutes * 60
    }
    
    var days: Int {
        return self.hours * 24
    }
    
    var weeks: Int {
        return self.days * 7
    }
    
    var months: Int {
        return self.weeks * 4
    }
    
    var years: Int {
        return self.months * 12
    }
}

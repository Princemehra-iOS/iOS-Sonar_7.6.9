//
//  TroubleshootingSurveyVC.swift
//  Zoetis -Feathers
//
//  Created by Avinash Singh on 03/01/20.
//  Copyright © 2020 . All rights reserved.
//
import UIKit
import SwiftyJSON

class TroubleshootingSurveyVC:BaseViewController
{
    
    var isPlusBtnClicked : Bool = false
    
    var barcodeForPlateId :String = ""
    
    var displayPlateIdCount : Int = 0
    
    let dropdownManager = ZoetisDropdownShared.sharedInstance
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var TroubleshootingTableView: UITableView!
    
    
    var rowCount = Int()
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonMenu: UIButton!
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    
    @IBAction func siteBtnAction(_ sender: UIButton) {
        
        if appDelegate.selectedCompany == "Training"
        {
            setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.siteId , dropDownArr: dropdownManager.sharedHatcherySiteArrMicroabial ?? [])
        }
        else
        {
            let alert = UIAlertController(title: "App Message", message: "No data.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func companyBtnAction(_ sender: UIButton) {
        
        var customerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Customer")
        var customerNamesArray = customerDetailsArray.value(forKey: "customerName") as? NSArray ?? NSArray()
        setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.company, dropDownArr: customerNamesArray as? [String] )
    }
    
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?){
        
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.setValueInTextFields(selectedValue: selectedVal, selectedIndex: index, clickedField: clickedField)
            }
            self.dropHiddenAndShow()
            
        }
    }
    
    @IBAction func reviewerBtnAction(_ sender: UIButton) {
  
       var reviewerDetailsArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "Micro_Reviewer")
       var reviewerNamesArray = reviewerDetailsArray.value(forKey: "reviewerName") as? NSArray ?? NSArray()
        setDropdrown(sender, clickedField: Constants.ClickedFieldMicrobialSurvey.reviewer, dropDownArr: reviewerNamesArray as? [String])
    }
    
    
    
    func setValueInTextFields(selectedValue: String, selectedIndex: Int, clickedField:String) {
        
        if  let cell = self.TroubleshootingTableView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? TroubleshootingCaseInfoCell
        {
            switch clickedField {
                
            case Constants.ClickedFieldMicrobialSurvey.company:do {
                appDelegate.selectedCompany = selectedValue
                cell.selectedCompanyTxt.text = selectedValue
            }
            case Constants.ClickedFieldMicrobialSurvey.siteId:do {
                cell.siteTxt.text = selectedValue
            }
                
            case Constants.ClickedFieldMicrobialSurvey.reviewer:do {
                cell.reviewerTxt.text = selectedValue
            }
                
            default:
                do {print(appDelegateObj.testFuntion())}
            }
        }
        
    }
    
    
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    
}

extension TroubleshootingSurveyVC: UITableViewDelegate,UITableViewDataSource,TroubleshootingSampleInfoCellDelegate{
    
    func noOfPlates(count: Int, clicked: Bool) {
        rowCount = count
        
        if (rowCount > 0)
        {
            isPlusBtnClicked = clicked
        }
        else{
            isPlusBtnClicked = false
        }
        TroubleshootingTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   print("fdfdf")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return rowCount
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        switch indexPath.section {
        case 0:
            height = 344
        case 1:
            height = 158
        case 2:
            height = 51
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TroubleshootingCaseInfoCell", for: indexPath) as! TroubleshootingCaseInfoCell
            
            cell.requestorTxt.text = "John Smith"
            cell.sampleCollectedByTxt.text = "John Smith"
            cell.barcodeTxt.text = "T-\(Date.getCurrentDate())"
            
            if(self.isPlusBtnClicked == true)
            {
                cell.barcodeTxt.isEnabled = false
                cell.barcodeTxt.textColor = UIColor.lightGray
            }
            else
            {
                cell.barcodeTxt.isEnabled = true
                cell.barcodeTxt.textColor = UIColor.black
            }
            
            barcodeForPlateId =  cell.barcodeTxt.text ?? " "
            
            
            TroubleshootingTableView.allowsSelection = false
            return cell
            
        }
        case 1:do{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TroubleshootingSampleInfoCell", for: indexPath) as! TroubleshootingSampleInfoCell
            cell.delegate = self
            return cell
            
        }
        case 2:do{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TroubleshootingTextFieldInfoCell", for: indexPath) as! TroubleshootingTextFieldInfoCell
            
            cell.PlateIdTxt.text = barcodeForPlateId + "-\(String(displayPlateIdCount))"
            
            displayPlateIdCount = displayPlateIdCount + 1
            
            return cell
            
        }
            
        default:
            return UITableViewCell()
        }
        
    }
    
}

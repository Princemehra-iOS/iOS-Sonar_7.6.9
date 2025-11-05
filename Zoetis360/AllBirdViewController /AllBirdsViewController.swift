//
//  AllBirdsViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 26/09/16.
//  Copyright © 2016 "". All rights reserved.
//
import UIKit
import CoreData

class AllBirdsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate {
    
    // MARK: - VARIABLES
    var quickLinkArray  = NSMutableArray()
    var obsNameArray = NSMutableArray()
    var obsFiledArray = NSMutableArray()
    var observationArray = NSMutableArray()
    var birdArray = NSMutableArray()
    var categoryArray = NSMutableArray()
    var birdNo = Int()
    var formName = String()
    var  necId = Int()
    var obsArr = NSMutableArray()
    var storedOffsets = [Int: CGFloat]()
    var postingIdFromExistingNavigate = NSString()
    var ageValue = String()
    var index = Int()
    var dragger: TableViewDragger!
    
    // MARK: - OUTLET
    @IBOutlet weak var bgTableView: UITableView!
    @IBOutlet weak var lblForm: UILabel!
    @IBOutlet weak var lblHouseNo: UILabel!
    
    var BirdSex = NSArray ()
    var selectedSexValue: String = "N/A"
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        BirdSex = ["Male", "Female" ,"N/A"]
        self.loadData()
        self.bgTableView.estimatedRowHeight = 100
        
        dragger = TableViewDragger(tableView: bgTableView)
        dragger.availableHorizontalScroll = false
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
    }
    
    // MARK: - METHOD & FUNCTIONS
    func loadData() {
        
        let farmName =  formName + " " + "[" + ageValue + "]"
        var farmName2 = String()
        let range = farmName.range(of: ".")
        if range != nil{
            let abc = String(farmName[range!.upperBound...]) as NSString
            farmName2 = String(index+1) + "." + " " + String(describing:abc)
        }
        
        lblForm.text = farmName2
        let hNo =  CoreDataHandler().FetchNecropsystep1NecIdWithFarmName(formName ,necropsyId:necId as NSNumber)
        if hNo.count > 0{
            let hNo = hNo.object(at: 0) as! CaptureNecropsyData
            lblHouseNo.text = hNo.houseNo
        }
        
        var dict = [String: AnyObject]()
        
        var i = -1
        
        let arr =  CoreDataHandler().fetchCaptureWithFormNameNecSkeltonData(farmName: formName, necID : necId as NSNumber)
        
        for  j in 0..<arr.count {
            
            if ((arr.object(at: j) as AnyObject).value(forKey: "quickLink") as AnyObject).int32Value == 1 {
                
                self.obsNameArray.add((arr.object(at: j) as AnyObject).value(forKey: "obsName")!)
                
                self.observationArray.add(arr.object(at: j))
                i = i + 1
                
                let obsName = (self.observationArray.object(at: i) as AnyObject).value(forKey: "obsName") as! String
                let matchObsName = self.obsNameArray.object(at: i) as! String
                
                if obsName == matchObsName {
                    dict[matchObsName] = arr.object(at: j) as AnyObject
                }
            }
        }
        
        let arrKeys =  [String] (dict.keys) as NSArray
        let sortedArrKeys = arrKeys.sortedArray(using: [NSSortDescriptor(key: "self", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]) as NSArray
        self.obsNameArray.removeAllObjects()
        
        for i in 0..<sortedArrKeys.count {
            let obsName = sortedArrKeys.object(at: i) as! String
            self.obsNameArray.add(obsName)
            let captureN = dict[obsName] as! CaptureNecropsyViewData
            let noOfBird = self.birdNo
            let obsDictVal = NSMutableDictionary()
            
            for j in 0..<noOfBird {
                obsDictVal.setObject(captureN, forKey: j+1 as NSCopying)
            }
            obsArr.add(obsDictVal)
        }
        
        if obsArr.count > 0 {
            self.setTemperaryObsNameArray()
            self.bgTableView.reloadData()
        } else {
            Helper.showAlertMessage((UIApplication.shared.keyWindow?.rootViewController)!,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No quicklink is selected. Please go to Settings and select quicklink.", comment: ""))
        }
    }
    
    
    // MARK: - IBACTION
    @IBAction func cancelBtn(_ sender: AnyObject) {
        navigateRoot()
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        navigateRoot()
    }
    // MARK: 🟠 Move to Root View
    func navigateRoot()  {
        let isQuickLink : Bool = true
        UserDefaults.standard.set(isQuickLink, forKey: "isQuickLink")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: 🟠 - TABLE VIEW DATA SOURCE AND DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.obsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? allBirdsTableViewCell
        if cell == nil {
            cell = allBirdsTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 180, height: 100)
        cell!.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? allBirdsTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? allBirdsTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    // MARK: 🟠 - COLLECTION VIEW DATA SOURCE AND DELEGATES
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.obsArr[section] as AnyObject).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "obsName", for: indexPath) as! ObsNameCollectionViewCell
            cell.obsNameLabel.text = self.obsNameArray.object(at: collectionView.tag) as? String
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "obsField", for: indexPath) as! obsFieldCollectionViewCell
            cell.backgroundColor = UIColor.white
            let d  = self.obsArr.object(at: collectionView.tag) as! NSDictionary
            let arr = d.allKeys as NSArray
            let captureNec :  CaptureNecropsyViewData = (d.object(forKey: arr.object(at: indexPath.row - 1)) as? CaptureNecropsyViewData)!
            let fethchArr = CoreDataHandler().fecthFrmWithBirdAndObservation(indexPath.row as NSNumber, farmname: captureNec.formName!, obsId: captureNec.obsID!, necId: necId as NSNumber)
            
            let c = fethchArr.object(at: 0) as! CaptureNecropsyViewData
            cell.birdSexView?.alpha = 0
            cell.birdSexView.isHidden = true
            
            if c.measure == "Y,N"
            {
                cell.switchQuickLink.alpha = 1
                cell.actualTexField?.alpha = 0
                cell.incrementBtnOutlet.alpha = 0
                cell.minusBtnOutlet.alpha = 0
                cell.displayLabel.alpha = 0
                
                if c.objsVisibilty == 1{
                    cell.switchQuickLink.isOn = true
                }
                else{
                    cell.switchQuickLink.isOn = false
                }
            }
            else if c.measure == "Actual"
            {
                cell.actualTexField?.delegate = self as UITextFieldDelegate
                cell.switchQuickLink.alpha = 0
                cell.actualTexField?.alpha = 1
                cell.incrementBtnOutlet.alpha = 0
                cell.minusBtnOutlet.alpha = 0
                cell.displayLabel.alpha = 0
                cell.actualTexField?.tag = indexPath.row
                cell.actualTexField?.text = c.actualText
            }
            
            else if c.measure == "F,M"
            {
                cell.switchQuickLink.alpha = 0
                cell.actualTexField?.alpha = 0
                cell.incrementBtnOutlet.alpha = 0
                cell.minusBtnOutlet.alpha = 0
                cell.displayLabel.alpha = 0
                cell.birdSexView.isHidden = false
                cell.sexLabel.isHidden = false
                cell.birdSexBtn.isHidden = false
                cell.birdSexView.alpha = 1
                cell.sexLabel.alpha = 1
                cell.birdSexBtn.alpha = 1
                cell.birdSexView.layer.borderColor = UIColor.black.cgColor
                cell.birdSexView.layer.borderWidth = 1.0
                cell.birdSexView.layer.cornerRadius = 5.0
                cell.birdSexView.clipsToBounds = true
                if let text = c.actualText?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let value = Double(text) {
                    switch value {
                    case 1:
                        cell.sexLabel.text = "Male"
                    case 2:
                        cell.sexLabel.text = "Female"
                    default:
                        cell.sexLabel.text = "N/A"
                    }
                } else {
                    cell.sexLabel.text = "N/A"
                }
            }
            else{
                cell.switchQuickLink.alpha = 0
                cell.actualTexField?.alpha = 0
                cell.incrementBtnOutlet.alpha = 1
                cell.minusBtnOutlet.alpha = 1
                cell.displayLabel.alpha = 1
                cell.displayLabel.text = String(c.obsPoint!.int32Value)
            }
            cell.lblBirdSize.text = String(indexPath.row)
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.incrementBtnOutlet.addTarget(self, action: #selector(AllBirdsViewController.plusButtonClick(_:)), for: .touchUpInside)
            cell.incrementBtnOutlet.tag = indexPath.row
            cell.minusBtnOutlet.addTarget(self, action: #selector(AllBirdsViewController.minusButtonClick(_:)), for: .touchUpInside)
            cell.minusBtnOutlet.tag = indexPath.row
            cell.switchQuickLink .addTarget(self, action: #selector(AllBirdsViewController.switchClick(_:)) , for:.valueChanged)
            cell.switchQuickLink.tag = indexPath.row
            cell.birdSexBtn.addTarget(self, action: #selector(AllBirdsViewController.birdSexClick(_:)), for: .touchUpInside)
            cell.birdSexBtn.tag = indexPath.row
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appDelegateObj.testFuntion()
    }
    
    
    // MARK: 🟠 - Plus Button Action
    fileprivate func updateObsDataInSkeleta(_ array: ([String]), _ cell: obsFieldCollectionViewCell, _ obsName: Any, _ formNameValue: String, _ noOfBird: Int, _ captureNec: CaptureNecropsyViewData) {
        if Int(array[0]) != 0
        {
            cell.displayLabel.text = String(array[0])
            CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnStepper(obsName as! String, formName: formNameValue, birdNo: noOfBird as NSNumber, obsId: captureNec.obsID!, index: Int(array[0])!, necId :necId as NSNumber)
        }
        else
        {
            cell.displayLabel.text = String(array[1])
            CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnStepper(obsName as! String, formName: formNameValue, birdNo: noOfBird as NSNumber, obsId: captureNec.obsID!, index: Int(array[1])!, necId :necId as NSNumber)
        }
    }
    
    @objc func plusButtonClick (_ sender: UIButton){
        guard let cell = sender.superview!.superview as? obsFieldCollectionViewCell else {
            return
        }
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.bgTableView)
        let cellIndexPath = self.bgTableView.indexPathForRow(at: pointInTable)
        let noOfBird =  cell.incrementBtnOutlet.tag as Int
        if cellIndexPath?.row == nil{
            return
        }
        let obsName = self.obsNameArray.object(at: (cellIndexPath?.row)!)
        let formNameValue  = self.formName as String
        
        guard let d = self.obsArr.object(at: (cellIndexPath?.row)!) as? NSDictionary else {
            return
        }
        let arr = d.allKeys as NSArray
        
        let noofBirdArrOnObs = NSMutableArray()
        
        for i in 0..<arr.count
        {
            noofBirdArrOnObs.add(i+1)
        }
        
        let captureNec :  CaptureNecropsyViewData = (d.object(forKey: noofBirdArrOnObs.object(at: cell.incrementBtnOutlet.tag - 1)) as? CaptureNecropsyViewData)!
        let trimmed = captureNec.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let array = (trimmed.components(separatedBy: ",") as [String])
        let fethchArr = CoreDataHandler().fecthFrmWithBirdAndObservation(noOfBird as NSNumber, farmname: formNameValue, obsId: captureNec.obsID!, necId: necId as NSNumber)
        let c = fethchArr.object(at: 0) as! CaptureNecropsyViewData
        
        if c.obsPoint == 0
        {
            updateObsDataInSkeleta(array, cell, obsName, formNameValue, noOfBird, captureNec)
        }
        else
        {
            for  i in 0..<array.count
            {
                let lastElement = (Int(array.last!)! as Int)
                if lastElement == Int(array[i])!
                {
                    debugPrint("last element is not there.")
                }
                else
                {
                    let value =  Int(array[i] as String)!
                    if  (value as NSNumber == c.obsPoint)
                    {
                        cell.displayLabel.text = String(array[i+1])
                        CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnStepper(obsName as! String, formName: formNameValue, birdNo: noOfBird as NSNumber, obsId: captureNec.obsID!, index: Int(array[i+1])!, necId :necId as NSNumber)
                        break
                    }
                }
            }
        }
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            CoreDataHandler().updateisSyncNecropsystep1WithneccId(necId as NSNumber, isSync : true)
        } else{
            CoreDataHandler().updateisSyncTrueOnPostingSession(necId as NSNumber)
        }
    }
    // MARK: 🟠 Minus Button Action
    fileprivate func updateObservationDataOnMinusBtnClick(_ c: CaptureNecropsyViewData, _ array: ([String]), _ cell: obsFieldCollectionViewCell, _ obsName: Any, _ formNameValue: String, _ noOfBird: Int, _ captureNec: CaptureNecropsyViewData) {
        if c.obsPoint == 0
        {
            debugPrint("minus button obs check")
        }
        else
        {
            for  i in 0..<array.count
            {
                if Int(array[i]) == 1
                {
                    debugPrint("minus aray check")
                }
                else
                {
                    if c.obsPoint == 1 && Int(array[i]) == 0 {
                        
                        cell.displayLabel.text = array[0]
                        CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnStepper(obsName as! String, formName: formNameValue, birdNo: noOfBird as NSNumber, obsId: captureNec.obsID!, index: Int(array[0])!, necId :necId as NSNumber)
                        break
                        
                    }
                    let value = Int(array[i])
                    if ((value! as NSNumber) == c.obsPoint)
                    {
                        cell.displayLabel.text = array[i-1]
                        CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnStepper(obsName as! String, formName: formNameValue, birdNo: noOfBird as NSNumber, obsId: captureNec.obsID!, index: Int(array[i-1])!, necId :necId as NSNumber)
                        break
                    }
                }
            }
        }
    }
    
    @objc func minusButtonClick (_ sender: UIButton){
        
        guard let cell = sender.superview!.superview as? obsFieldCollectionViewCell else {
            return
        }
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.bgTableView)
        let cellIndexPath = self.bgTableView.indexPathForRow(at: pointInTable)
        let noOfBird =  cell.incrementBtnOutlet.tag as Int
        if cellIndexPath?.row == nil{
            return
        }
        let obsName = self.obsNameArray.object(at: (cellIndexPath?.row)!)
        let formNameValue  = self.formName as String
        
        guard let d = self.obsArr.object(at: (cellIndexPath?.row)!) as? NSDictionary else {
            return
        }
        let arr = d.allKeys as NSArray
        let noofBirdArrOnObs = NSMutableArray()
        
        for i in 0..<arr.count
        {
            noofBirdArrOnObs.add(i+1)
        }
        let captureNec :  CaptureNecropsyViewData = (d.object(forKey: noofBirdArrOnObs.object(at: cell.incrementBtnOutlet.tag - 1)) as? CaptureNecropsyViewData)!
        let trimmed = captureNec.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let array = (trimmed.components(separatedBy: ",") as [String])
        let fethchArr = CoreDataHandler().fecthFrmWithBirdAndObservation(noOfBird as NSNumber, farmname: formNameValue, obsId: captureNec.obsID!, necId: necId as NSNumber)
        
        let c = fethchArr.object(at: 0) as! CaptureNecropsyViewData
        
        if fethchArr.count > 0 {
            updateObservationDataOnMinusBtnClick(c, array, cell, obsName, formNameValue, noOfBird, captureNec)
        }
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            CoreDataHandler().updateisSyncNecropsystep1WithneccId(necId as NSNumber, isSync : true)
            
        } else {
            CoreDataHandler().updateisSyncTrueOnPostingSession(necId as NSNumber)
        }
    }
    // MARK: 🟠 Switch Click
    @objc func switchClick(_ sender:UISwitch){
        
        guard let cell = sender.superview!.superview as? obsFieldCollectionViewCell else{
            return
        }
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.bgTableView)
        let cellIndexPath = self.bgTableView.indexPathForRow(at: pointInTable)
        let noOfBird =  cell.incrementBtnOutlet.tag as Int
        
        let formNameValue  = self.formName as String
        if cellIndexPath?.row == nil{
            return
        }
        
        guard let d = self.obsArr.object(at: (cellIndexPath?.row)!) as? NSDictionary else {
            return
        }
        let arr = d.allKeys as NSArray
        let noofBirdArrOnObs = NSMutableArray()
        
        for i in 0..<arr.count
        {
            noofBirdArrOnObs.add(i+1)
        }
        let captureNec :  CaptureNecropsyViewData = (d.object(forKey: noofBirdArrOnObs.object(at: cell.incrementBtnOutlet.tag - 1)) as? CaptureNecropsyViewData)!
        let fethchArr = CoreDataHandler().fecthFrmWithBirdAndObservation(noOfBird as NSNumber, farmname: formNameValue, obsId: captureNec.obsID!, necId: necId as NSNumber)
        let c = fethchArr.object(at: 0) as! CaptureNecropsyViewData
        
        CoreDataHandler().updateSwitchDataInCaptureSkeletaInDatabaseOnSwitch(formNameValue, birdNo: noOfBird as NSNumber, obsId: c.obsID!, obsVisibility: sender.isOn, necId : necId as NSNumber)
        
        cell.switchQuickLink.isOn = sender.isOn
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            
            CoreDataHandler().updateisSyncNecropsystep1WithneccId(necId as NSNumber, isSync : true)
        } else {
            CoreDataHandler().updateisSyncTrueOnPostingSession(necId as NSNumber)
        }
        
    }
    // MARK: 🟠 Bird Sec Button Click
    fileprivate func handleSelectedVal(_ selectedVal: String) {
        if selectedVal == "Female" {
            selectedSexValue = "2"
        } else if selectedVal == "N/A" {
            selectedSexValue = "0"
        } else {
            selectedSexValue = "1"
        }
    }
    
    fileprivate func handleArrAndDictionary(_ arr: NSArray, _ noofBirdArrOnObs: NSMutableArray, _ d: NSDictionary, _ noOfBird: Int, _ formNameValue: String,_ cell:obsFieldCollectionViewCell) {
        for i in 0..<arr.count {
            noofBirdArrOnObs.add(i+1)
        }
        let captureNec :  CaptureNecropsyViewData = (d.object(forKey: noofBirdArrOnObs.object(at: cell.incrementBtnOutlet.tag - 1)) as? CaptureNecropsyViewData)!
        let fethchArr = CoreDataHandler().fecthFrmWithBirdAndObservation(noOfBird as NSNumber, farmname: formNameValue, obsId: captureNec.obsID!, necId: necId as NSNumber)
        let c = fethchArr.object(at: 0) as! CaptureNecropsyViewData
        
        CoreDataHandler().updateBirdSexDataInCaptureSkeletaInDatabase(formNameValue, birdNo: noOfBird as NSNumber, obsId: c.obsID!, BirdSex: selectedSexValue, necId : necId as NSNumber)
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true {
            CoreDataHandler().updateisSyncNecropsystep1WithneccId(necId as NSNumber, isSync : true)
        } else {
            CoreDataHandler().updateisSyncTrueOnPostingSession(necId as NSNumber)
        }
    }
    
    @objc func birdSexClick(_ sender:UIButton) {
        
        guard let cell = getCellFromSender(sender) else {
            return
        }
        
        if BirdSex.count > 0 {
            self.dropDownVIewNew(arrayData: BirdSex as? [String] ?? [String](), kWidth: cell.birdSexView.frame.width, kAnchor: cell.birdSexView, yheight: cell.birdSexView.bounds.height) { [unowned self] selectedVal, index  in
                cell.sexLabel.text = selectedVal
                selectedSexValue = selectedVal
                
                handleSelectedVal(selectedVal)
                
                let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.bgTableView)
                let cellIndexPath = self.bgTableView.indexPathForRow(at: pointInTable)
                let noOfBird =  cell.incrementBtnOutlet.tag as Int
                let formNameValue  = self.formName as String
                if cellIndexPath?.row == nil {
                    return
                }
                
                guard let d = self.obsArr.object(at: (cellIndexPath?.row)!) as? NSDictionary else {
                    return
                }
                let arr = d.allKeys as NSArray
                let noofBirdArrOnObs = NSMutableArray()
                
                handleArrAndDictionary(arr, noofBirdArrOnObs, d, noOfBird, formNameValue,cell)
            }
            self.dropHiddenAndShow()
        }
    }
    // MARK: 🟠 Get Specific Selected Cell
    func getCellFromSender(_ sender: UIView) -> obsFieldCollectionViewCell? {
        var view: UIView? = sender
        while view != nil {
            if let cell = view as? obsFieldCollectionViewCell {
                return cell
            }
            view = view?.superview
        }
        return nil
    }
    
    // MARK: 🟠 - DROP DOWN HIDDEN AND SHOW
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    
    // MARK: 🟠 - TEXTFIELD DELEGATES
    func textFieldDidEndEditing(_ textField: UITextField){
        
        
        let cell = textField.superview!.superview as! obsFieldCollectionViewCell
        let pointInTable: CGPoint = textField.convert(textField.bounds.origin, to: self.bgTableView)
        let cellIndexPath = self.bgTableView.indexPathForRow(at: pointInTable)
        let noOfBird =   cell.actualTexField?.tag
        let formNameValue  = self.formName as String
        
        if cellIndexPath?.row == nil{
            return
        }
        let d  = self.obsArr.object(at: (cellIndexPath?.row)!) as! NSDictionary
        let arr = d.allKeys as NSArray
        let noofBirdArrOnObs = NSMutableArray()
        
        for i in 0..<arr.count
        {
            noofBirdArrOnObs.add(i+1)
        }
        let captureNec :  CaptureNecropsyViewData = (d.object(forKey: noofBirdArrOnObs.object(at: cell.incrementBtnOutlet.tag - 1)) as? CaptureNecropsyViewData)!
        
        CoreDataHandler().updateObsDataInCaptureSkeletaInDatabaseOnActual(formName , formName: formNameValue, birdNo: noOfBird! as NSNumber, obsId: captureNec.obsID!, actualName: textField.text!, necId: necId as NSNumber)
        
        if UserDefaults.standard.bool(forKey: "Unlinked") == true{
            CoreDataHandler().updateisSyncNecropsystep1WithneccId(necId as NSNumber, isSync : true)
        }else {
            CoreDataHandler().updateisSyncTrueOnPostingSession(necId as NSNumber)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (string == "1" || string == "2" || string == "3" || string == "4" || string == "5" || string == "6" || string == "7" || string == "8" || string == "9" || string == "0" || string == "." || isBackSpace == -92 ){
            var _ : Bool!
            if(self.checkCharacter(string, textField: textField)){
                let cell = textField.superview!.superview as! obsFieldCollectionViewCell
                if textField == cell.actualTexField
                {
                    var computationString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    let length = computationString.count
                    if (length > 5) {
                        return false;
                    }
                }
            }
            return true
        }
        return false
    }
    
    func checkCharacter( _ inputChar : String , textField : UITextField ) -> Bool {
        
        let newCharacters = CharacterSet(charactersIn: inputChar)
        let boolIsNumber = CharacterSet.decimalDigits.isSuperset(of: newCharacters)
        if boolIsNumber == true {
            return true
        }
        else {
            
            if inputChar == "." {
                let countdots = textField.text!.components(separatedBy: ".").count - 1
                if countdots == 0 {
                    return true
                    
                } else {
                    if countdots > 0 && inputChar == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: 🟠 - EXTENSION
extension AllBirdsViewController {
    
    func setTemperaryObsNameArray() {
        let savedMovedBirdsSequences = CoreDataHandler().fetchAllBirdsSwapedIndexes()
        if savedMovedBirdsSequences.count > 0 {
            restoreSavedBirdOrder(savedMovedBirdsSequences)
        } else {
            reorderObsByQuickIndex()
        }
    }
    
    private func restoreSavedBirdOrder(_ savedMovedBirdsSequences: [Any]) {
        let savedBirdNameArray = NSMutableArray()
        for object in savedMovedBirdsSequences {
            savedBirdNameArray.add((object as AnyObject).birdName ?? "")
        }
        reorderObsArrBySavedNames(savedBirdNameArray)
        reorderObsNameArrayBySavedNames(savedBirdNameArray)
    }
    
    private func reorderObsArrBySavedNames(_ savedBirdNameArray: NSMutableArray) {
        for (index, bird) in savedBirdNameArray.enumerated() {
            for (birdIndex, object) in obsArr.enumerated() {
                let obsName = ((object as! NSDictionary).allValues[0] as! CaptureNecropsyViewData).obsName
                if obsName == bird as? String && index < self.obsArr.count {
                    let movedOBS = self.obsArr[birdIndex]
                    self.obsArr.removeObject(at: birdIndex)
                    self.obsArr.insert(movedOBS, at: index)
                }
            }
        }
    }
    
    private func reorderObsNameArrayBySavedNames(_ savedBirdNameArray: NSMutableArray) {
        for (index, bird) in savedBirdNameArray.enumerated() {
            for (birdIndex, obsBird) in obsNameArray.enumerated() {
                if let obsName = obsBird as? String, obsName == bird as? String, index < self.obsNameArray.count {
                    let movedOBSBird = self.obsNameArray[birdIndex]
                    self.obsNameArray.removeObject(at: birdIndex)
                    self.obsNameArray.insert(movedOBSBird, at: index)
                }
            }
        }
    }
    struct QuickIndexObject {
        var quickIndex = 0
        var obsName = ""
    }
    private func reorderObsByQuickIndex() {
        
        var arrOfIndex = [QuickIndexObject]()
        for iteam in self.obsArr {
            guard let captureData = (iteam as? NSDictionary)?.allValues[0] as? CaptureNecropsyViewData else { continue }
            var catName = captureData.catName
            let obsName = captureData.obsName
            catName = mapCategoryName(catName)
            let fetchdata = CoreDataHandler().fetchAllSeetingByObs(entityName: catName!, obsName: obsName!)
            if let quickIndex = getQuickIndex(catName: catName!, fetchdata: fetchdata), quickIndex > 0 {
                arrOfIndex.append(QuickIndexObject(quickIndex: quickIndex, obsName: obsName!))
            }
        }
        reorderObsArrByQuickIndex(arrOfIndex)
        reorderObsNameArrayByQuickIndex(arrOfIndex)
    }
    
    private func mapCategoryName(_ catName: String?) -> String? {
        switch catName {
        case "skeltaMuscular": return "Skeleta"
        case "Resp": return "Respiratory"
        default: return catName
        }
    }
    
    private func getQuickIndex(catName: String, fetchdata: NSArray) -> Int? {
        switch catName {
        case "Skeleta":
            return (fetchdata.object(at: 0) as? Skeleta)?.quicklinkIndex as? Int
        case "Coccidiosis":
            return (fetchdata.object(at: 0) as? Coccidiosis)?.quicklinkIndex as? Int
        case "GITract":
            return (fetchdata.object(at: 0) as? GITract)?.quicklinkIndex as? Int
        case "Respiratory":
            return (fetchdata.object(at: 0) as? Respiratory)?.quicklinkIndex as? Int
        case "Immune":
            return (fetchdata.object(at: 0) as? Immune)?.quicklinkIndex as? Int
        default:
            return nil
        }
    }
    
    private func reorderObsArrByQuickIndex(_ arrOfIndex: [QuickIndexObject]) {
        for quickIndexObject in arrOfIndex {
            for (birdIndex, object) in obsArr.enumerated() {
                let obsName = ((object as! NSDictionary).allValues[0] as! CaptureNecropsyViewData).obsName
                if quickIndexObject.quickIndex < self.obsArr.count, obsName == quickIndexObject.obsName {
                    let movedOBS = self.obsArr[birdIndex]
                    self.obsArr.removeObject(at: birdIndex)
                    self.obsArr.insert(movedOBS, at: quickIndexObject.quickIndex)
                }
            }
        }
    }
    
    private func reorderObsNameArrayByQuickIndex(_ arrOfIndex: [QuickIndexObject]) {
        for object in arrOfIndex {
            for (birdIndex, obsBird) in obsNameArray.enumerated() {
                if let obsName = obsBird as? String, object.quickIndex < self.obsNameArray.count, obsName == object.obsName {
                    let movedOBSBird = self.obsNameArray[birdIndex]
                    self.obsNameArray.removeObject(at: birdIndex)
                    self.obsNameArray.insert(movedOBSBird, at: object.quickIndex)
                }
            }
        }
    }
    
    // ... existing code ...
    // MARK: 🟠 Save Birds Sequesnce in Database
    func saveBirdsSequencesInDB() {
        CoreDataHandler().deleteAllBirdsSwapedIndexes()
        for (index, birdName) in self.obsNameArray.enumerated() {
            if let name = birdName as? String {
                CoreDataHandler().saveAllBirdsSwapedIndexes(name, index: index)
            }
        }
    }
}
// MARK: 🟠 - EXTENSION
extension AllBirdsViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        if indexPath != newIndexPath {
            let movedOBS = self.obsArr[indexPath.row]
            self.obsArr.removeObject(at: indexPath.row)
            self.obsArr.insert(movedOBS, at: newIndexPath.row)
            
            let movedBirdName = self.obsNameArray[indexPath.row]
            self.obsNameArray.removeObject(at: indexPath.row)
            self.obsNameArray.insert(movedBirdName, at: newIndexPath.row)
            
            self.bgTableView.moveRow(at: indexPath, to: newIndexPath)
            
            if let obsId = ((movedOBS as! NSDictionary).allValues[0] as? CaptureNecropsyViewData)?.obsName,
               var catName = ((movedOBS as! NSDictionary).allValues[0] as? CaptureNecropsyViewData)?.catName {
                
                if catName == "skeltaMuscular" {
                    catName = "Skeleta"
                }
                else if catName == "Resp" {
                    catName = "Respiratory"
                }
                CoreDataHandler().updateSettingDataQuickIndex(obsId, obsId: 0, quicklinkIndex: newIndexPath.row, entityName: catName)
            }
            
            self.saveBirdsSequencesInDB()
        }
        return true
    }
    
    func dragger(_ dragger: TableViewDragger, shouldDragAt indexPath: IndexPath) -> Bool {
        return true
    }
}

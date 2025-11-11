
//  Report_MainVCViewController.swift
//  Zoetis -Feathers
//  Created by "" on 28/11/16.
//  Copyright © 2016 "". All rights reserved.


import UIKit
import Charts
import Reachability

class Report_MainVCViewController: UIViewController,GI_TtactDelegate,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - VARIABLES
    
    var preparedArray = NSMutableArray()
    var hasError: Bool?
    var sessionDate = NSString()
    var verticalValues = [String]()
    var sessionDataArray = NSArray()
    var droperTableView  =  UITableView ()
    var headerTitle = NSString()
    var customPopView1 :UserListView!
    let buttonbg1 = UIButton ()
    let buttonbg = UIButton ()
    var complexArr  = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var validSessions = NSMutableArray()
    var airSacData: AirsacData?
    var entries_Array = NSMutableArray()
    
    // MARK: - OUTLET
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var btnComplex: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @objc func methodOfReceivedNotification(notification: Notification){
        //Take Action on Notification
        UserDefaults.standard.set(0, forKey: "postingId")
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Report_MainVCViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        Regions.countryId = UserDefaults.standard.integer(forKey: "countryId")
        Regions.languageID = UserDefaults.standard.bool(forKey: "turkeyReport") ? 1 : UserDefaults.standard.integer(forKey: "lngId")
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
     
        
       AllValidSessions.sharedInstance.allValidSession.removeAllObjects()
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
     
        
        lblComplex.text = AllValidSessions.sharedInstance.complexName.length > 0 ? AllValidSessions.sharedInstance.complexName as String : NSLocalizedString("- Select -", comment: "")
        btnComplex.isUserInteractionEnabled = !(AllValidSessions.sharedInstance.complexName.length > 0)
        lblComplex.isEnabled = !(AllValidSessions.sharedInstance.complexName.length > 0)
        lblComplex.backgroundColor = btnComplex.isUserInteractionEnabled ? UIColor.clear : UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        
        sessionDataArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionAndComplex(1,complexName : lblComplex.text! as NSString) as NSArray
        if sessionDataArray.count > 0 {
            let sessionDat = NSMutableArray()
            for i in 0..<sessionDataArray.count {
                if ((sessionDataArray.object(at: i) as AnyObject).value(forKey: "lngId") as! Int == Regions.languageID) {
                    sessionDat.add(sessionDataArray.object(at: i))
                }
            }
        }
        for i in 0..<sessionDataArray.count {
            
            let date = ((sessionDataArray.object(at: i) as AnyObject).value(forKey: "sessiondate")!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let date1 = dateFormatter.date(from: date as! String)
            let date2 = dateFormatter.date(from: AllValidSessions.sharedInstance.complexDate as String)
            switch date1?.compare(date2!) {
            case .orderedAscending?     :   print("Date A is earlier than date B")
                AllValidSessions.sharedInstance.allValidSession.add((sessionDataArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
                break
            case .orderedDescending?    :   print("Date A is later than date B")
                break
            case .orderedSame?          :   print("The two dates are the same")
                AllValidSessions.sharedInstance.allValidSession.add((sessionDataArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
                break
            case .none: break
                
            }
        }
        var complexIDArray = NSMutableArray()
        var complexIDArray2 = NSArray()
        complexArr.removeAllObjects()
        
        let complexDataArray : NSArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSession(1, birdTypeId: 1) as NSArray
        
        for i in 0..<complexDataArray.count {
            if ((complexDataArray.object(at: i) as AnyObject).value(forKey: "lngId") as! Int == Regions.languageID) {
                complexArr.add((complexDataArray.object(at: i) as AnyObject).value(forKey: "complexName")!)
                complexIDArray.add((complexDataArray.object(at: i) as AnyObject).value(forKey: "complexId")!)
            }
        }
        
        complexIDArray = self.removeDuplicates2(complexIDArray)
        
        for i in 0..<complexIDArray.count {
            complexIDArray2 = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionAndUniqueComplex(complexIDArray[i] as! NSNumber)
        }
        for i in 0..<complexIDArray2.count {
            complexArr.add((complexIDArray2.object(at: i) as AnyObject).value(forKey: "complexName")!)
        }
        complexArr = self.removeDuplicates(complexArr)
        btnComplex.layer.borderWidth = 1
        btnComplex.layer.cornerRadius = 3.5
        btnComplex.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        Regions.countryId = UserDefaults.standard.integer(forKey: "countryId")
        Regions.languageID = UserDefaults.standard.integer(forKey: "lngId")
        
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func removeDuplicates(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<String>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! String) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value as! String)
                // ... Append the value.
                result.add(value as! String)
            }
        }
        
        return result
    }
    func removeDuplicates2(_ array: NSMutableArray) -> NSMutableArray {
        var encountered = Set<NSNumber>()
        let result = NSMutableArray()
        for value in array {
            if encountered.contains(value as! NSNumber) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value as! NSNumber)
                // ... Append the value.
                result.add(value as! NSNumber)
            }
        }
        
        return result
    }
    
    @IBAction func didSelectOnComplex(_ sender: AnyObject) {
        
        view.endEditing(true)
        
        tableViewpop()
        
        if complexArr.count < 4 {
            
            droperTableView.frame = CGRect( x: btnComplex.frame.origin.x, y: btnComplex.frame.origin.y+40, width: 270, height: 130)
        }
        else{
            droperTableView.frame = CGRect( x: btnComplex.frame.origin.x, y: btnComplex.frame.origin.y+40, width: 270, height: 190)
            
        }
        droperTableView.reloadData()
    }
    func tableViewpop()  {
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonbg.addTarget(self, action: #selector(Report_MainVCViewController.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        droperTableView.delegate = self
        droperTableView.dataSource = self
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.lightGray.cgColor
        buttonbg.addSubview(droperTableView)
    }
    @objc func buttonPressed1() {
        
        buttonbg.removeFromSuperview()
    }
    @IBAction func btn_GI_Track_Pressed(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
        verticalValues = CoreDataHandler().getObservationNameForGITract(refID: Regions.getObservationsGITract(countryID: Regions.countryId)) as! [String]
        verticalValues = observationNameCrop(values: verticalValues) as! [String]

        self.headerTitle = "GI Tract"
        self.callCommonFunction("Gi_tract")
        dataSet.categoryName = "Gi_tract"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            self.performSegue(withIdentifier: "giTract", sender: sender)
        } else { CalculationError.hasError = false }
    }
    
    // MARK: - IBACTIONS
    @IBAction func btn_Coccidiosis_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(true, forKey: "isCocci")
        
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
    }
    
    @IBAction func btn_Immune_Action(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
        verticalValues = CoreDataHandler().getObservationNameForImmune(refID: Regions.getObservationsForImmune(countryID: Regions.countryId)) as! [String]
        dataSet.categoryName = "immune"
        dataSet.axisLables = verticalValues
        self.callCommonFunction("immune")
        
        self.performSegue(withIdentifier: "immune", sender: sender)
    }
    @IBAction func btn_Respiratory_Action(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
            self.entries_Array.removeAllObjects()
        }
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
        
        verticalValues = CoreDataHandler().getObservationNameForRespiratory(refID: Regions.getObservationsResp(countryID: Regions.countryId)) as! [String]
        
        verticalValues = observationNameCrop(values: verticalValues) as! [String]
        
        self.headerTitle = "Respiratory Tract"
        self.callCommonFunction("resp")
        airSecCalculation()
        dataSet.categoryName = "resp"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            self.performSegue(withIdentifier: "resp", sender: sender)
        } else { CalculationError.hasError = false }
    }
    
    
    
    
    @IBAction func btn_Summary_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr: NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
    }
    @IBAction func btn_Skeletal_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        
        if lblComplex.text == NSLocalizedString("- Select -", comment: "") {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("Please select a complex first.", comment: ""))
            return
        }
        
        if self.preparedArray.count > 0 {
            
            self.preparedArray.removeAllObjects()
        }
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
        verticalValues = CoreDataHandler().getObservationNameForSkelatal(refID: Regions.getobservationsSkeletal(countryID: Regions.countryId)) as! [String]
        verticalValues = observationNameCrop(values: verticalValues) as! [String]
        self.headerTitle = NSLocalizedString("Skeletal/Muscular/Integumentary", comment: "") as NSString
        self.callCommonFunction("skeltaMuscular")
        dataSet.categoryName = "skeltaMuscular"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            self.performSegue(withIdentifier: "skeltaMuscular", sender: sender)
        } else {
            CalculationError.hasError = false
        }
    }
    
    // MARK: - Delegates Handling
    
    func didFinishWithParsing(finishedArray : NSArray){
        
        if verticalValues.count != finishedArray.count {
            CalculationError.hasError = true
            return
        }
        let chartDataSet : BarChartDataSet = setChartData(dataPoints: verticalValues, values: finishedArray as! [Float])!
        self.preparedArray.add(chartDataSet)
    }
    @nonobjc func didFinishWithParsingWithFarmData(_ finishedArray : [Float]){
        
    }
    func setChartData(dataPoints: [String], values: [Float]) -> BarChartDataSet? {
        
        // formatter.xAxisLabel = verticalValues
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            //let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: UtilityClass.convertDateFormater(sessionDate as String))
        
        return chartDataSet
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complexArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell ()
        
        let cocoii  = complexArr.object(at: indexPath.row) as! String
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel!.text = cocoii
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = complexArr[indexPath.row] as! String
        lblComplex.text = str
        
        AllValidSessions.sharedInstance.allValidSession.removeAllObjects()
        sessionDataArray = CoreDataHandler().fetchAllPostingExistingSessionwithFullSessionAndComplex(1,complexName : lblComplex.text! as NSString) as NSArray
        
        
        for i in 0..<sessionDataArray.count {
            if(((sessionDataArray.object(at: i) as AnyObject).value(forKey: "lngId")!) as! Int == Regions.languageID){
                AllValidSessions.sharedInstance.allValidSession.add((sessionDataArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
            }
        }
        
        buttonPressed1()
    }
    // MARK: - Common Function
    
    func callCommonFunction(_ catName : NSString)  {
        guard let rawArray = AllValidSessions.sharedInstance.allValidSession as? [NSNumber] else {
//            self.showAlert(title: "Alert", message: "Report data not available. Please sync your session first.", owner: self)
            print("❌ allValidSession is nil or not a [NSNumber]")
            return
        }
        let arrayOfIds = rawArray.map { $0.intValue }
        
       // var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        if arrayOfIds.count > 2 {
            
            for i in 0..<3 {//(arrayOfIds.count-2...arrayOfIds.count).reversed(){
                
                let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    return
                }
                
                let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
                let allFarmDataArray = NSMutableArray()
                
                var totalBirdsPerFarm : Float = 0
                
                for j in 0..<lastSessionDataArray.count {
                    
                    let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                    
                    let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                    let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                    
                    totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                    
                    let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
                    
                    allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
                }
                modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            }
        }
        
        else if arrayOfIds.count > 1 {
            
            for i in 0..<2 {
                
                let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    return
                }
                
                let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
                let allFarmDataArray = NSMutableArray()
                
                var totalBirdsPerFarm : Float = 0
                
                for j in 0..<lastSessionDataArray.count {
                    
                    let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                    
                    let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                    
                    let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                    
                    totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                    
                    let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
                    
                    allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
                }
                modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            }
        }
        else{
            
            let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.last as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                return
            }
            
            let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.last as! NSNumber).mutableCopy() as! NSMutableArray
            
            sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "giTract" || segue.identifier == "skeltaMuscular")  {
            let barChartVC = segue.destination as! BarChartViewController
            barChartVC.recivedDataArray = self.preparedArray
            barChartVC.origionalDataArray = self.preparedArray
            barChartVC.headerTitle = self.headerTitle
            barChartVC.verticalValues = self.verticalValues
        }
        if (segue.identifier == "resp"){
            let barChartVC = segue.destination as! BarChartViewController
            barChartVC.recivedDataArray = self.preparedArray
            barChartVC.origionalDataArray = self.preparedArray
            barChartVC.airSacChartData = self.airSacData
            barChartVC.headerTitle = self.headerTitle
            barChartVC.verticalValues = self.verticalValues
        }
        if segue.identifier == "immune" && CalculationError.hasError == false {
            let barChartVC = segue.destination as! ImmuneBarChartViewController
            barChartVC.recivedDataArray = self.preparedArray
            barChartVC.verticalValues = self.verticalValues
        }
        if segue.identifier == "summary" {
            let summaryVC = segue.destination as! SummaryReportsViewController
            summaryVC.recivedDataArray = sessionDataArray
        }
    }
    
    @IBAction func leftSlideMenuBTNaCTION(_ sender: AnyObject) {
        // SlideNavigationController.sharedInstance().toggleLeftMenu()
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
}

extension Report_MainVCViewController {
    
    func didFinishWithParsingAirSac(_ finishedArray: NSArray, birds: Float) {
        
        var airSac0 : Float = 0
        var airSac1 : Float = 0
        var airSac2 : Float = 0
        var airSac3 : Float = 0
        var airSac4 : Float = 0
        
        airSac0 = finishedArray[0] as! Float
        airSac1 = finishedArray[1] as! Float
        airSac2 = finishedArray[2] as! Float
        airSac3 = finishedArray[3] as! Float
        airSac4 = finishedArray[4] as! Float
        
        airSac0 = airSac0*100/birds
        airSac1 = airSac1*100/birds
        airSac2 = airSac2*100/birds
        airSac3 = airSac3*100/birds
        airSac4 = airSac4*100/birds
        
        let entry = BarChartDataEntry(x: Double(self.entries_Array.count) , yValues: [Double(airSac0),Double(airSac1),Double(airSac2),Double(airSac3),Double(airSac4)])
        self.entries_Array.add(entry)
    }
    
    func airSecCalculation() {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        //arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        
        var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            return
        }
        
        let farmNames = NSMutableArray()
        
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            
            farmNames.add(NSString(format: "%@(%@)",farmName,(lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "age") as! NSString))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupAirSec(lastFarmDataArray, birdsCount: numberOfBirds.floatValue, catName: "Resp", referanceID: 51)
        }
                
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        
        if let values = verticalValues.last {
            debugPrint(values)
            dataSet.stackLabels = [verticalValues.last!.trimmingCharacters(in: .whitespaces)+" 0",verticalValues.last!.trimmingCharacters(in: .whitespaces)+" 1",verticalValues.last!.trimmingCharacters(in: .whitespaces)+" 2",verticalValues.last!.trimmingCharacters(in: .whitespaces)+" 3",verticalValues.last!.trimmingCharacters(in: .whitespaces)+" 4"]
            dataSet.colors = [UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        }
        
        let farmNames1 = NSMutableArray()
        for frNme in farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            farmNames1.add(frNme1.crop())
        }
        self.airSacData = AirsacData(chartData: BarChartData(dataSets: [dataSet]), xAxisIndexs: farmNames1 as! [String], sessionDate: ((objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString) as String)
    }
}

struct AirsacData {
    let chartData: BarChartData
    let xAxisIndexs: [String]
    let sessionDate: String
}


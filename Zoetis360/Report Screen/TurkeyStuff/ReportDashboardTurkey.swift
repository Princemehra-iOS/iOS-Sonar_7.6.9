
import UIKit
import Charts

import Gigya
import GigyaTfa
import GigyaAuth




class ReportDashboardTurkey: UIViewController,GI_TtactDelegate,UITableViewDelegate,UITableViewDataSource{
    // MARK: - VARIABLES
    var preparedArray = NSMutableArray()
    var hasError: Bool?
    var sessionDate = NSString()
    var verticalValues = [String]()
    var sessionDataArray = NSArray()
    var validSessions = NSMutableArray()
    var droperTableView  =  UITableView ()
    var airSacData: AirsacData?
    var headerTitle = NSString()
    var customPopView1 :UserListView!
    let buttonbg = UIButton ()
    var complexArr  = Array<String>()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var entries_Array = NSMutableArray()
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    
    // MARK: - OUTLET
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var btnComplex: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    @objc func methodOfReceivedNotification(notification: Notification){
        UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
        appDelegate.sendFeedVariable = ""
        let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
        self.navigationController?.pushViewController(navigateTo, animated: false)
    }
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(ReportDashboardTurkey.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
        AllValidSessions.sharedInstance.isDirect = false
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        
        AllValidSessions.sharedInstance.allValidSession.removeAllObjects()
        
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
        Regions.countryId = UserDefaults.standard.integer(forKey: "countryId")
        Regions.languageID = UserDefaults.standard.bool(forKey: "turkeyReport") ? 1 : UserDefaults.standard.integer(forKey: "lngId")
        
        lblComplex.text = AllValidSessions.sharedInstance.complexName.length > 0 ? AllValidSessions.sharedInstance.complexName as String : NSLocalizedString("- Select -", comment: "")
        btnComplex.isUserInteractionEnabled = !(AllValidSessions.sharedInstance.complexName.length > 0)
        lblComplex.isEnabled = !(AllValidSessions.sharedInstance.complexName.length > 0)
        lblComplex.backgroundColor = btnComplex.isUserInteractionEnabled ? UIColor.clear : UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        
        sessionDataArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionAndComplexTurkey(1,complexName : lblComplex.text! as NSString) as NSArray
        
        if sessionDataArray.count > 0 {
            let sessionDat = NSMutableArray()
            for i in 0..<sessionDataArray.count {
                if ((sessionDataArray.object(at: i) as AnyObject).value(forKey: "lngId") as! Int == Regions.languageID) {
                    sessionDat.add(sessionDataArray.object(at: i))
                }
            }
            UtilityClass.sortArrayForKey(key: "sessiondate", unsortedArray: sessionDat)
            AllValidSessions.sharedInstance.isDirect = true
        }
        else{
            let complexDataArray : NSArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionTurkey(1, birdTypeId: 1) as NSArray
            
            let sessionDat = NSMutableArray()
            for i in 0..<complexDataArray.count {
                if ((complexDataArray.object(at: i) as AnyObject).value(forKey: "lngId") as! Int == Regions.languageID) {
                    sessionDat.add(complexDataArray.object(at: i))
                }
            }
            
            for i in 0..<sessionDat.count {
                complexArr.append((sessionDat.object(at: i) as AnyObject).value(forKey: "complexName") as! String)
            }
            complexArr = UtilityClass.removeDuplicates(complexArr)
        }
        btnComplex.layer.borderWidth = 1
        btnComplex.layer.cornerRadius = 3.5
        btnComplex.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        Regions.countryId = UserDefaults.standard.integer(forKey: "countryId")
        Regions.languageID = UserDefaults.standard.integer(forKey: "lngId")
    }
    // MARK: - IBACTION
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
    
    @IBAction func btn_GI_Track_Pressed(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if lblComplex.text == "- Select -" {
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Please select a complex first.")
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"No historical data.")
            return
        }
        
        verticalValues = CoreDataHandlerTurkey().getObservationNameForGITractTurkey(refID: Regions.getObservationsGITractTr(countryID: Regions.countryId)) as! [String]
        self.headerTitle = "GI Tract (Turkey)"
        ReportsCalculation.commonCalculationFunction("Gi_tractTr", viewCnt: self)
        dataSet.categoryName = "Gi_tractTr"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            navigateToController()
        } else { CalculationError.hasError = false }
    }
    
    @IBAction func btn_Microscopy_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(true, forKey: "isCocci")
        
        if lblComplex.text == "- Select -" {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Please select a complex first.")
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"No historical data.")
            return
        }
    }
    
    @IBAction func btn_Immune_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        
        if lblComplex.text == "- Select -" {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Please select a complex first.")
            return
        }
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"No historical data.")
            return
        }
        verticalValues = CoreDataHandlerTurkey().getObservationNameForImmuneTurkey(refID: Regions.getObservationsForImmuneTr(countryID: Regions.countryId)) as! [String]
        
        dataSet.categoryName = "immuneTr"
        dataSet.axisLables = verticalValues
        self.headerTitle = "Immune/Others (Turkey)"
        ReportsCalculation.commonCalculationFunction("immuneTr", viewCnt: self)
        
        if CalculationError.hasError == false {
            navigateToController()
        } else { CalculationError.hasError = false }
    }
    
    func navigateToController() {
        
        let barChartVC = TurkeyBarChartViewController(nibName: "TurkeyBarChart", bundle: nil)
        barChartVC.recivedDataArray = self.preparedArray
        barChartVC.origionalDataArray = self.preparedArray
        barChartVC.headerTitle = self.headerTitle
        barChartVC.airSacChartData = self.airSacData
        barChartVC.verticalValues = self.verticalValues
        self.navigationController!.pushViewController(barChartVC, animated: true)
    }
    
    @IBAction func btn_Respiratory_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if lblComplex.text == "- Select -" {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Please select a complex first.")
            return
        }
        
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:"Alert", messageStr:"No historical data.")
            return
        }
        
        verticalValues = CoreDataHandlerTurkey().getObservationNameForRespiratoryTurkey(refID: Regions.getObservationsRespTr(countryID: Regions.countryId)) as! [String]
        
        self.headerTitle = "Respiratory Tract (Turkey)"
        ReportsCalculation.commonCalculationFunction("respTr", viewCnt: self)
        airSecCalculation()
        dataSet.categoryName = "respTr"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            navigateToController()
        } else { CalculationError.hasError = false }
    }
    
    @IBAction func btn_Summary_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        if lblComplex.text == "- Select -" {
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr: "Please select a complex first.")
            return
        }
    }
    
    @IBAction func btn_Skeletal_Action(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        UserDefaults.standard.set(false, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocci")
        
        if lblComplex.text == "- Select -" {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"Please select a complex first.")
            return
        }
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        if AllValidSessions.sharedInstance.allValidSession.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:"Alert" , messageStr:"No historical data.")
            return
        }
        verticalValues = CoreDataHandlerTurkey().getObservationNameForSkelatalTurkey(refID: Regions.getobservationsSkeletalTr(countryID: Regions.countryId)) as! [String]
        
        self.headerTitle = "Skeletal/Muscular/Integumentary (Turkey)"
        ReportsCalculation.commonCalculationFunction("skeltaMuscularTr", viewCnt: self)
        dataSet.categoryName = "skeltaMuscularTr"
        dataSet.axisLables = verticalValues
        if CalculationError.hasError == false {
            navigateToController()
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
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: UtilityClass.convertDateFormater(sessionDateSingle as String))
        
        return chartDataSet
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complexArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell ()
        
        let cocoii  = complexArr[indexPath.row] as String
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel!.text = cocoii
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = complexArr[indexPath.row]
        lblComplex.text = str
        AllValidSessions.sharedInstance.allValidSession.removeAllObjects()
        sessionDataArray = CoreDataHandlerTurkey().fetchAllPostingExistingSessionwithFullSessionAndComplexTurkey(1,complexName : lblComplex.text! as NSString) as NSArray
        UtilityClass.setupSessionIDs(rawArray: sessionDataArray)
        // UtilityClass.sortArrayForDictKey(key: "sessiondate", unsortedArray: sessionDataArray)
        buttonPressed1()
    }
    // MARK: - Common Function
    // MARK: - Navigation
    // MARK: - METHOD & FUNCTION
    func tableViewpop()  {
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonbg.addTarget(self, action: #selector(ReportDashboardTurkey.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        
        droperTableView.delegate = self
        droperTableView.dataSource = self
        
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.black.cgColor
        
        buttonbg.addSubview(droperTableView)
    }
    @objc func buttonPressed1() {
        
        buttonbg.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "giTractTr" || segue.identifier == "skeltaMuscularTr" || segue.identifier == "immuneTr")  {
            let barChartVC = segue.destination as! BarChartViewController
            barChartVC.recivedDataArray = self.preparedArray
            barChartVC.origionalDataArray = self.preparedArray
            barChartVC.headerTitle = self.headerTitle
            barChartVC.verticalValues = self.verticalValues
        }
        if (segue.identifier == "respTr"){
            let barChartVC = segue.destination as! BarChartViewController
            barChartVC.recivedDataArray = self.preparedArray
            barChartVC.origionalDataArray = self.preparedArray
            barChartVC.airSacChartData = self.airSacData
            barChartVC.headerTitle = self.headerTitle
            barChartVC.verticalValues = self.verticalValues
        }
        if segue.identifier == "summaryTr" {
            let summaryVC = segue.destination as! SummaryReportsMIcroscopy
            summaryVC.recivedDataArray = sessionDataArray
        }
    }
    
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            
            UserDefaults.standard.removeObject(forKey: "login")
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
            buttonbg.removeFromSuperview()
            _ = customPopView1.removeView(view)
            
        }
    }
    
    
    
    
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func leftSlideMenuBTNaCTION(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
}

extension ReportDashboardTurkey {
    
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
        
        // verticalValues = self.farmNames as NSArray as! [String]
        
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
        
        // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        var lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
        
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
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            modalObj.setupAirSec(lastFarmDataArray, birdsCount: numberOfBirds.floatValue, catName: "Resp", referanceID: 637)
        }
        
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        dataSet.stackLabels = [verticalValues[2]+" 0",verticalValues[2]+" 1",verticalValues[2]+" 2",verticalValues[2]+" 3",verticalValues[2]+" 4"]
        dataSet.colors = [UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        
        let farmNames1 = NSMutableArray()
        for frNme in farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            //""
            farmNames1.add(frNme1.crop())
        }
        self.airSacData = AirsacData(chartData: BarChartData(dataSets: [dataSet]), xAxisIndexs: farmNames1 as! [String], sessionDate: ((objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString) as String)
    }
    
}


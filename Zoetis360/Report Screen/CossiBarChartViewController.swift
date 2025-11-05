//
//  CossiBarChartViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 08/12/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import Charts
import Reachability

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class CossiBarChartViewController: UIViewController,GI_TtactDelegate,ChartViewDelegate {
    
    // MARK: - VARIABLES
    let objApiSync = ApiSync()
    let buttonbg1 = UIButton ()
    var customPopView1 :UserListView!
    let buttonbg = UIButton ()
    var preparedArray = NSMutableArray()
    var isFarmSelected:Bool?
    var subjectString = NSString()
    var sessionDate = NSString()
    var verticalValues =  [String]()
    var indexValueArray =  [Int]()
    var verticalValuesForWeek =  [String]()
    var farmNames = NSMutableArray()
    var headerTitle = NSString()
    var total_birds : Float = 0
    var maxFarmCount : Int = 0
    let dateLable = UILabel()
    let chartNameLable = UILabel()
    var chartNameString = NSString()
    var isMove = Bool()
    var isByWeeakChart = Bool()
    var Eimeria_Acervulina_Gross_Array = NSMutableArray()
    var Eimeria_Maxima_Gross_Array = NSMutableArray()
    var Eimeria_Maxima_Micro_Array = NSMutableArray()
    var Eimeria_Tenella_Gross_Array = NSMutableArray()
    var entries_Array = NSMutableArray()
    var index : Int  = 0
    let lineChartView = LineChartView()
    var chartData = BarChartData()
    let rightArrow = UIButton()
    let leftArrow = UIButton()
    var totalStr = String()
    var lngId = NSInteger()
    let noHistoricData = "No historical data."
    let lastCocciSessioinTxt = "Coccidiosis Summary Last Session"
    let EiMaximaGrossTxt = "Eimeria maxima gross"
    let eimeriaStr = "Eimeria acervulina gross"
    let eimeriaTenStr = "Eimeria tenella gross"
    let eimeriaMaxStr = "Eimeria maxima micro"
    
    // MARK: - OUTLET
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var incedenceText: UIImageView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var btnHistorical: UIButton!
    @IBOutlet weak var btnLastSession: UIButton!
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        self.btnHistorical.isHidden = false
        self.btnLastSession.isHidden = false
        UserDefaults.standard.set(false, forKey: "isBackPress")
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.delegate = self
        // barChartView.xAxis.valueFormatter = formatter
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 105.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.xAxis.labelRotationAngle = 90
        self.barChartView.dragEnabled = true
        barChartView.xAxis.wordWrapEnabled = false
        barChartView.rightAxis.enabled = false
        chartNameLable.frame = CGRect(x: self.view.frame.midX - 300, y: 66, width: 600, height: 30)
        chartNameLable.text = NSLocalizedString(lastCocciSessioinTxt, comment: "") as String
        chartNameLable.textAlignment = .center
        self.view.addSubview(chartNameLable)
        chartNameLable.font = UIFont.systemFont(ofSize: 18)
        
        dateLable.frame = CGRect(x: 115, y: 66, width: 200, height: 30)
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        self.view .addSubview(dateLable)
        dateLable.font = UIFont.systemFont(ofSize: 12)
        
        totalStr = NSLocalizedString("Total Farms:", comment: "")
        
        self.rightArrow.frame = CGRect(x: btnShare.frame.origin.x+12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.rightArrow)
        rightArrow.isUserInteractionEnabled = false
        self.rightArrow.setImage(UIImage(named: "next_icon"), for: .normal)
        
        self.leftArrow.frame = CGRect(x: btnShare.frame.origin.x-12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.leftArrow)
        leftArrow.isUserInteractionEnabled = false
        self.leftArrow.setImage(UIImage(named: "back_icon"), for: .normal)
        
        //self.view.addSubview(self.moreLable)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        lngId = UserDefaults.standard.integer(forKey: "lngId")

        //print(AllValidSessions.sharedInstance.allValidSession)
        barChartView.legend.verticalAlignment = .top
        self.subjectString = NSLocalizedString(lastCocciSessioinTxt, comment: "") as NSString
        self.BtnSummuaryPressed(self.btnLastSession)
    }
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        return verticalValues[Int(value)]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Delegates handling
    
    func didFinishWithParsing(finishedArray : NSArray){
        
        let chartDataSet : BarChartDataSet = setChartDataForFarm(verticalValues as [String], values: finishedArray as! [Float], lable:UtilityClass.convertDateFormater(sessionDate as String) as NSString)!
        
        self.preparedArray.add(chartDataSet)
    }
    func didFinishWithParsingWithFarmData (_ finishedArray : NSArray){
        
        maxFarmCount+=1
        
        var Eimeria_Acervulina_Gross : Float = 0
        var Eimeria_Maxima_Gross : Float = 0
        var Eimeria_Maxima_Micro : Float = 0
        var Eimeria_Tenella_Gross : Float = 0
        
        Eimeria_Acervulina_Gross = finishedArray[0] as! Float
        Eimeria_Maxima_Gross = finishedArray[1] as! Float
        Eimeria_Maxima_Micro = finishedArray[2] as! Float
        Eimeria_Tenella_Gross = finishedArray[3] as! Float
        
        Eimeria_Maxima_Micro = Eimeria_Maxima_Micro*100/self.total_birds
        Eimeria_Acervulina_Gross = Eimeria_Acervulina_Gross*100/self.total_birds
        Eimeria_Maxima_Gross = Eimeria_Maxima_Gross*100/self.total_birds
        Eimeria_Tenella_Gross = Eimeria_Tenella_Gross*100/self.total_birds
        
        Eimeria_Maxima_Gross = (Eimeria_Maxima_Gross.isNaN) ? 0 : Eimeria_Maxima_Gross
        Eimeria_Acervulina_Gross = (Eimeria_Acervulina_Gross.isNaN) ? 0 : Eimeria_Acervulina_Gross
        Eimeria_Maxima_Micro = (Eimeria_Maxima_Micro.isNaN) ? 0 : Eimeria_Maxima_Micro
        Eimeria_Tenella_Gross = (Eimeria_Tenella_Gross.isNaN) ? 0 : Eimeria_Tenella_Gross
        
        self.Eimeria_Maxima_Gross_Array.add(Eimeria_Maxima_Gross)
        self.Eimeria_Acervulina_Gross_Array.add(Eimeria_Acervulina_Gross)
        self.Eimeria_Maxima_Micro_Array.add(Eimeria_Maxima_Micro)
        self.Eimeria_Tenella_Gross_Array.add(Eimeria_Tenella_Gross)
        
        if isFarmSelected! &&
           ((Eimeria_Maxima_Gross > 0) || (Eimeria_Maxima_Micro > 0) || (Eimeria_Tenella_Gross > 0) || (Eimeria_Acervulina_Gross > 0)) {
            verticalValuesForWeek.append(verticalValues[maxFarmCount-1])
            indexValueArray.append(maxFarmCount-1)
        }

        
    }
    
    func didFinishWithParsingWithEimeriaAcervulinaGross (_ finishedArray : NSArray){
        
        var Eimeria_Acervulina_Gross0 : Float = 0
        var Eimeria_Acervulina_Gross1 : Float = 0
        var Eimeria_Acervulina_Gross2 : Float = 0
        var Eimeria_Acervulina_Gross3 : Float = 0
        var Eimeria_Acervulina_Gross4 : Float = 0
        
        Eimeria_Acervulina_Gross0 = finishedArray[0] as! Float
        Eimeria_Acervulina_Gross1 = finishedArray[1] as! Float
        Eimeria_Acervulina_Gross2 = finishedArray[2] as! Float
        Eimeria_Acervulina_Gross3 = finishedArray[3] as! Float
        Eimeria_Acervulina_Gross4 = finishedArray[4] as! Float
        
        verticalValues = self.farmNames as NSArray as! [String]
        
        Eimeria_Acervulina_Gross0 = Eimeria_Acervulina_Gross0*100/self.total_birds
        Eimeria_Acervulina_Gross1 = Eimeria_Acervulina_Gross1*100/self.total_birds
        Eimeria_Acervulina_Gross2 = Eimeria_Acervulina_Gross2*100/self.total_birds
        Eimeria_Acervulina_Gross3 = Eimeria_Acervulina_Gross3*100/self.total_birds
        Eimeria_Acervulina_Gross4 = Eimeria_Acervulina_Gross4*100/self.total_birds
        
        let entry = BarChartDataEntry(x: Double(index) ,yValues: [Double(Eimeria_Acervulina_Gross0),Double(Eimeria_Acervulina_Gross1),Double(Eimeria_Acervulina_Gross2),Double(Eimeria_Acervulina_Gross3),Double(Eimeria_Acervulina_Gross4)])
        
        index += 1
        maxFarmCount += 1
        self.entries_Array.add(entry)
    }
    func didFinishWithParsingMaximaGross(_ finishedArray: NSArray) {
        
        var Eimeria_Maxima_Gross0 : Float = 0
        var Eimeria_Maxima_Gross1 : Float = 0
        var Eimeria_Maxima_Gross2 : Float = 0
        var Eimeria_Maxima_Gross3 : Float = 0
        var Eimeria_Maxima_Gross4 : Float = 0
        
        Eimeria_Maxima_Gross0 = finishedArray[0] as! Float
        Eimeria_Maxima_Gross1 = finishedArray[1] as! Float
        Eimeria_Maxima_Gross2 = finishedArray[2] as! Float
        Eimeria_Maxima_Gross3 = finishedArray[3] as! Float
        Eimeria_Maxima_Gross4 = finishedArray[4] as! Float
        
        
        verticalValues = self.farmNames as NSArray as! [String]
        
        Eimeria_Maxima_Gross0 = Eimeria_Maxima_Gross0*100/self.total_birds
        Eimeria_Maxima_Gross1 = Eimeria_Maxima_Gross1*100/self.total_birds
        Eimeria_Maxima_Gross2 = Eimeria_Maxima_Gross2*100/self.total_birds
        Eimeria_Maxima_Gross3 = Eimeria_Maxima_Gross3*100/self.total_birds
        Eimeria_Maxima_Gross4 = Eimeria_Maxima_Gross4*100/self.total_birds
        
        let entry = BarChartDataEntry(x: Double(index) ,yValues: [Double(Eimeria_Maxima_Gross0),Double(Eimeria_Maxima_Gross1),Double(Eimeria_Maxima_Gross2),Double(Eimeria_Maxima_Gross3),Double(Eimeria_Maxima_Gross4)])
        index += 1
        maxFarmCount += 1
        self.entries_Array.add(entry)
    }
    func didFinishWithParsingMaximaMicro(_ finishedArray: NSArray) {
        
        var Eimeria_Maxima_Micro0 : Float = 0
        var Eimeria_Maxima_Micro1 : Float = 0
        var Eimeria_Maxima_Micro2 : Float = 0
        var Eimeria_Maxima_Micro3 : Float = 0
        var Eimeria_Maxima_Micro4 : Float = 0
        
        Eimeria_Maxima_Micro0 = finishedArray[0] as! Float
        Eimeria_Maxima_Micro1 = finishedArray[1] as! Float
        Eimeria_Maxima_Micro2 = finishedArray[2] as! Float
        Eimeria_Maxima_Micro3 = finishedArray[3] as! Float
        Eimeria_Maxima_Micro4 = finishedArray[4] as! Float
        
        verticalValues = self.farmNames as NSArray as! [String]
        
        Eimeria_Maxima_Micro0 = Eimeria_Maxima_Micro0*100/self.total_birds
        Eimeria_Maxima_Micro1 = Eimeria_Maxima_Micro1*100/self.total_birds
        Eimeria_Maxima_Micro2 = Eimeria_Maxima_Micro2*100/self.total_birds
        Eimeria_Maxima_Micro3 = Eimeria_Maxima_Micro3*100/self.total_birds
        Eimeria_Maxima_Micro4 = Eimeria_Maxima_Micro4*100/self.total_birds
        
        let entry = BarChartDataEntry(x: Double(index) ,yValues: [Double(Eimeria_Maxima_Micro0),Double(Eimeria_Maxima_Micro1),Double(Eimeria_Maxima_Micro2),Double(Eimeria_Maxima_Micro3),Double(Eimeria_Maxima_Micro4)])
        index += 1
        maxFarmCount += 1
        self.entries_Array.add(entry)
    }
    
    func didFinishWithParsingTenellaGross(_ finishedArray: NSArray) {
        
        var Eimeria_Tenella_Gross0 : Float = 0
        var Eimeria_Tenella_Gross1 : Float = 0
        var Eimeria_Tenella_Gross2 : Float = 0
        var Eimeria_Tenella_Gross3 : Float = 0
        var Eimeria_Tenella_Gross4 : Float = 0
        
        Eimeria_Tenella_Gross0 = finishedArray[0] as! Float
        Eimeria_Tenella_Gross1 = finishedArray[1] as! Float
        Eimeria_Tenella_Gross2 = finishedArray[2] as! Float
        Eimeria_Tenella_Gross3 = finishedArray[3] as! Float
        Eimeria_Tenella_Gross4 = finishedArray[4] as! Float
        
        verticalValues = self.farmNames as NSArray as! [String]
        
        Eimeria_Tenella_Gross0 = Eimeria_Tenella_Gross0*100/self.total_birds
        Eimeria_Tenella_Gross1 = Eimeria_Tenella_Gross1*100/self.total_birds
        Eimeria_Tenella_Gross2 = Eimeria_Tenella_Gross2*100/self.total_birds
        Eimeria_Tenella_Gross3 = Eimeria_Tenella_Gross3*100/self.total_birds
        Eimeria_Tenella_Gross4 = Eimeria_Tenella_Gross4*100/self.total_birds
        
        let entry = BarChartDataEntry(x: Double(index) , yValues: [Double(Eimeria_Tenella_Gross0),Double(Eimeria_Tenella_Gross1),Double(Eimeria_Tenella_Gross2),Double(Eimeria_Tenella_Gross3),Double(Eimeria_Tenella_Gross4)])
        index += 1
        maxFarmCount += 1
        self.entries_Array.add(entry)
    }
    
    func setChartDataForFarm(_ dataPoints: [String], values: [Float],lable: NSString) -> BarChartDataSet? {
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i) ,y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: lable as String)
        
        return chartDataSet
    }
    
    func setLineChartDataForFarm(_ dataPoints: [String], values: [Float],lable: NSString) -> LineChartDataSet? {
        
        var dataEntries: [ChartDataEntry] = []
        self.barChartView.xAxis.labelCount = dataPoints.count
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x:Double(i) , y: Double(values[indexValueArray[i]]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: lable as String)
        
        return chartDataSet
    }
    
    // MARK: - Common Function
    
    fileprivate func handleForLoop0To3CommonFunction(_ arrayOfIds: inout [Int], _ modalObj: GI_Tract_Modal, _ catName: NSString) {
        for i in 0..<3 {
            let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds[i] as NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
                self.barChartView.clear()
                return
            }
            
            let objectArray : NSMutableArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds[i] as NSNumber).mutableCopy() as! NSMutableArray
            
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
    
    fileprivate func handleArrOfIdsLoop0To2CommonFunction(_ arrayOfIds: inout [Int], _ modalObj: GI_Tract_Modal, _ catName: NSString) {
        for i in 0..<2{
            
            let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds[i] as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
                self.barChartView.clear()
                return
            }
            
            let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
            
            sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId : necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            
        }
    }
    
    fileprivate func handleLastSessionDataCommonFunction(_ lastSessionDataArray: NSArray, _ arrayOfIds: [Int], _ modalObj: GI_Tract_Modal, _ catName: NSString) {
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
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
    
    func callCommonFunction(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        if arrayOfIds.count > 2 {
            
            handleForLoop0To3CommonFunction(&arrayOfIds, modalObj, catName)
        } else if arrayOfIds.count > 1 {
            
            handleArrOfIdsLoop0To2CommonFunction(&arrayOfIds, modalObj, catName)
        } else {
            
            let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
            
            handleLastSessionDataCommonFunction(lastSessionDataArray, arrayOfIds, modalObj, catName)
            
        }
    }
    
    // MARK: - Button Actions
    @IBAction func BtnSummuaryPressed(_ sender: UIButton) {
        isFarmSelected = false
        self.rightArrow.isHidden = true
       
        
        self.incedenceText.image = UIImage(named: "per-\(Regions.languageID)")
        barChartView.xAxis.centerAxisLabelsEnabled = false
        barChartView.viewPortHandler.resetBarChart(chart: barChartView)
        self.dragDetected(isEdgeRight: true, isEdgeLeft: true)
        
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        
        dateLable.isHidden = true
        isMove = true
        moveFrame(false)
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.subjectString = NSLocalizedString(lastCocciSessioinTxt, comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.titleLabel?.text == NSLocalizedString("Summary", comment: "") || bt.titleLabel?.text == NSLocalizedString("Last session", comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        
        self.btnHistorical.isHidden = false
        self.btnLastSession.isHidden = false
        self.btnLastSession.isSelected = true
        self.btnHistorical.isSelected = false
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        
        verticalValues = [NSLocalizedString(eimeriaStr, comment: ""), NSLocalizedString(EiMaximaGrossTxt, comment: ""),NSLocalizedString(eimeriaMaxStr, comment: ""),NSLocalizedString(eimeriaTenStr, comment: "")]
        
        verticalValues = observationNameCrop(values: verticalValues) as! [String]
        
        self.headerTitle = "Coccidiosis"
        
        self.callCommonFunction("Coccidiosis")
        
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        
        barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        
        var barData : ChartDataSet = ChartDataSet()
        if self.preparedArray.count > 0 {
            barData  = (self.preparedArray[0] as? ChartDataSet)!
            barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
            
            let summaryChartData = BarChartData(dataSets: [barData])
            barChartView.data = summaryChartData
        }
        if barData.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
    }
    
    fileprivate func extractedFunc(_ age: Int32, _ totalBirdsWeek1: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week1FarmDataArray: NSMutableArray) {
        if age > 0 && age < 8 {
            
            totalBirdsWeek1 = totalBirdsWeek1+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week1FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleAgeGreaterThan7LessThan15(_ age: Int32, _ totalBirdsWeek2: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week2FarmDataArray: NSMutableArray) {
        if age > 7 && age < 15 {
            
            totalBirdsWeek2 = totalBirdsWeek2+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week2FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleFunctionGreaterThan14LessThan5(_ age: Int32, _ totalBirdsWeek3: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week3FarmDataArray: NSMutableArray) {
        if age > 14 && age < 22 {
            
            totalBirdsWeek3 = totalBirdsWeek3+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week3FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleAgeGreaterThan22LessThan29(_ age: Int32, _ totalBirdsWeek4: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week4FarmDataArray: NSMutableArray) {
        if age > 21 && age < 29 {
            
            totalBirdsWeek4 = totalBirdsWeek4+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week4FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleAgeGreaterThan28LessThan36(_ age: Int32, _ totalBirdsWeek5: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week5FarmDataArray: NSMutableArray) {
        if age > 28 && age < 36 {
            
            totalBirdsWeek5 = totalBirdsWeek5+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week5FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func toggleBtnIsSelected(_ sender: UIButton) {
        for gestture in self.lineChartView.gestureRecognizers! {
            if gestture.isKind(of: UIGestureRecognizer.self) {
                self.lineChartView.removeGestureRecognizer(gestture)
            }
        }
        
        moveFrame(true)
        maxFarmCount = 0
        isMove = false
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
    }
    
    fileprivate func handleBtnByWeekPressedValidation3543(_ age: Int32, _ totalBirdsWeek6: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week6FarmDataArray: NSMutableArray) {
        if age > 35 && age < 43 {
            
            totalBirdsWeek6 = totalBirdsWeek6+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week6FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleBtnByWeekPressedValidation4250(_ age: Int32, _ totalBirdsWeek7: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week7FarmDataArray: NSMutableArray) {
        if age > 42 && age < 50 {
            
            totalBirdsWeek7 = totalBirdsWeek7+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week7FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleBtnByWeekPressedValidation4957(_ age: Int32, _ totalBirdsWeek8: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week8FarmDataArray: NSMutableArray) {
        if age > 49 && age < 57 {
            
            totalBirdsWeek8 = totalBirdsWeek8+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week8FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleBtnByWeekPressedValidation5664(_ age: Int32, _ totalBirdsWeek9: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week9FarmDataArray: NSMutableArray) {
        if age > 56 && age < 64 {
            
            totalBirdsWeek9 = totalBirdsWeek9+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week9FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleBtnByWeekPressedValidation63(_ age: Int32, _ totalBirdsWeek10: inout Float, _ numberOfBirds: NSString, _ farmName: NSString, _ necID: NSNumber, _ week10FarmDataArray: NSMutableArray) {
        if age > 63 {
            
            totalBirdsWeek10 = totalBirdsWeek10+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName, postingId: necID)
            
            week10FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
    }
    
    fileprivate func handleEmeriaAcerValidation() {
        if self.Eimeria_Acervulina_Gross_Array.count > 0 {
            
            preparedArray.removeAllObjects()
            
            var chartDataSet : LineChartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Eimeria_Acervulina_Gross_Array as NSArray as! [Float], lable: NSLocalizedString(eimeriaStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Eimeria_Maxima_Gross_Array as NSArray as! [Float], lable:NSLocalizedString(EiMaximaGrossTxt, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Eimeria_Maxima_Micro_Array as NSArray as! [Float], lable:NSLocalizedString(eimeriaMaxStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Eimeria_Tenella_Gross_Array as NSArray as! [Float], lable:NSLocalizedString(eimeriaTenStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
        }
    }
    
    @IBAction func BtnByWeekPressed(_ sender: UIButton) {
        isByWeeakChart = true
        isFarmSelected = true
        self.rightArrow.isHidden = true
        self.leftArrow.isHidden = true
      
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(true, forKey: "isCocciFarm")
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        dateLable.isHidden = false
        verticalValues.removeAll()
        verticalValues = ["\(NSLocalizedString("Week", comment: "")) 1","\(NSLocalizedString("Week", comment: "")) 2","\(NSLocalizedString("Week", comment: "")) 3","\(NSLocalizedString("Week", comment: "")) 4","\(NSLocalizedString("Week", comment: "")) 5","\(NSLocalizedString("Week", comment: "")) 6","\(NSLocalizedString("Week", comment: "")) 7","\(NSLocalizedString("Week", comment: "")) 8","\(NSLocalizedString("Week", comment: "")) 9","\(NSLocalizedString("Week", comment: "")) 10"]
        self.Eimeria_Maxima_Gross_Array.removeAllObjects()
        self.Eimeria_Maxima_Micro_Array.removeAllObjects()
        self.Eimeria_Tenella_Gross_Array.removeAllObjects()
        self.Eimeria_Acervulina_Gross_Array.removeAllObjects()
        self.verticalValuesForWeek.removeAll()
        indexValueArray.removeAll()
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        isMove = false
        moveFrame(true)
        
        lineChartView.frame = self.barChartView.frame
        
        self.view.addSubview(lineChartView)
        lineChartView.xAxis.labelPosition = .bottom
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        lineChartView.leftAxis.valueFormatter = numberFormatter as? IAxisValueFormatter
        
        lineChartView.animate(xAxisDuration: 3.0)
        lineChartView.pinchZoomEnabled = false
        
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.axisMaximum = 105.0
        lineChartView.rightAxis.axisMinimum = 0.0
        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelRotationAngle = 90
        lineChartView.chartDescription?.text = ""
        
        lineChartView.rightAxis.enabled = false
        lineChartView.isHidden = false
        self.barChartView.isHidden = true
        toggleBtnIsSelected(sender)
        self.subjectString = NSLocalizedString("Coccidiosis by week", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        let arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        let objectArray1 = CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        sessionDate = (objectArray1.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.lineChartView.clear()
            return
        }
        let modalObj = GI_Tract_Modal()
        modalObj.delegate = self
        
        let week1FarmDataArray = NSMutableArray()
        let week2FarmDataArray = NSMutableArray()
        let week3FarmDataArray = NSMutableArray()
        let week4FarmDataArray = NSMutableArray()
        let week5FarmDataArray = NSMutableArray()
        let week6FarmDataArray = NSMutableArray()
        let week7FarmDataArray = NSMutableArray()
        let week8FarmDataArray = NSMutableArray()
        let week9FarmDataArray = NSMutableArray()
        let week10FarmDataArray = NSMutableArray()
        
        var totalBirdsWeek1 : Float = 0
        var totalBirdsWeek2 : Float = 0
        var totalBirdsWeek3 : Float = 0
        var totalBirdsWeek4 : Float = 0
        var totalBirdsWeek5 : Float = 0
        var totalBirdsWeek6 : Float = 0
        var totalBirdsWeek7 : Float = 0
        var totalBirdsWeek8 : Float = 0
        var totalBirdsWeek9 : Float = 0
        var totalBirdsWeek10 : Float = 0
        for j in 0..<lastSessionDataArray.count {
            
            let age = ((lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as! NSString).intValue
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            extractedFunc(age, &totalBirdsWeek1, numberOfBirds, farmName, necID, week1FarmDataArray)
            handleAgeGreaterThan7LessThan15(age, &totalBirdsWeek2, numberOfBirds, farmName, necID, week2FarmDataArray)
            handleFunctionGreaterThan14LessThan5(age, &totalBirdsWeek3, numberOfBirds, farmName, necID, week3FarmDataArray)
            handleAgeGreaterThan22LessThan29(age, &totalBirdsWeek4, numberOfBirds, farmName, necID, week4FarmDataArray)
            handleAgeGreaterThan28LessThan36(age, &totalBirdsWeek5, numberOfBirds, farmName, necID, week5FarmDataArray)
            handleBtnByWeekPressedValidation3543(age, &totalBirdsWeek6, numberOfBirds, farmName, necID, week6FarmDataArray)
            handleBtnByWeekPressedValidation4250(age, &totalBirdsWeek7, numberOfBirds, farmName, necID, week7FarmDataArray)
            handleBtnByWeekPressedValidation4957(age, &totalBirdsWeek8, numberOfBirds, farmName, necID, week8FarmDataArray)
            handleBtnByWeekPressedValidation5664(age, &totalBirdsWeek9, numberOfBirds, farmName, necID, week9FarmDataArray)
            handleBtnByWeekPressedValidation63(age, &totalBirdsWeek10, numberOfBirds, farmName, necID, week10FarmDataArray)
        }
        
        self.total_birds = totalBirdsWeek1
        modalObj.setupCocciDataByFarm(week1FarmDataArray,birdsCount: totalBirdsWeek1 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek2
        modalObj.setupCocciDataByFarm(week2FarmDataArray,birdsCount: totalBirdsWeek2 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek3
        modalObj.setupCocciDataByFarm(week3FarmDataArray,birdsCount: totalBirdsWeek3 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek4
        modalObj.setupCocciDataByFarm(week4FarmDataArray,birdsCount: totalBirdsWeek4 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek5
        modalObj.setupCocciDataByFarm(week5FarmDataArray,birdsCount: totalBirdsWeek5 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek6
        modalObj.setupCocciDataByFarm(week6FarmDataArray,birdsCount: totalBirdsWeek6 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek7
        modalObj.setupCocciDataByFarm(week7FarmDataArray,birdsCount: totalBirdsWeek7 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek8
        modalObj.setupCocciDataByFarm(week8FarmDataArray,birdsCount: totalBirdsWeek8 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek9
        modalObj.setupCocciDataByFarm(week9FarmDataArray,birdsCount: totalBirdsWeek9 , catName: "Coccidiosis")
        
        self.total_birds = totalBirdsWeek10
        modalObj.setupCocciDataByFarm(week10FarmDataArray,birdsCount: totalBirdsWeek10 , catName: "Coccidiosis")
        
        handleEmeriaAcerValidation()
        
        if self.preparedArray.count < 3 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        
        let barData : LineChartDataSet = (self.preparedArray[0] as? LineChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        barData.circleColors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        
        let barData1 : LineChartDataSet = (self.preparedArray[1] as? LineChartDataSet)!
        barData1.colors = [UIColor.yellow]
        barData1.circleColors = [UIColor.yellow]
        
        
        let barData2 : LineChartDataSet = (self.preparedArray[2] as? LineChartDataSet)!
        barData2.colors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
        barData2.circleColors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
        
        
        let barData3 : LineChartDataSet = (self.preparedArray[3] as? LineChartDataSet)!
        barData3.colors = [UIColor(red: 163/255, green: 91/255, blue: 96/255, alpha: 1)]
        barData3.circleColors = [UIColor(red: 163/255, green: 91/255, blue: 96/255, alpha: 1)]
        
        
        self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValuesForWeek)
        self.lineChartView.xAxis.labelCount = verticalValuesForWeek.count
        let lineDta = LineChartData(dataSets: [barData,barData1,barData2,barData3])
        lineChartView.data = lineDta
        
        if barData.yMax <= 0 && barData1.yMax <= 0 && barData2.yMax <= 0 && barData3.yMax <= 0 {
            lineChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
        }
    }
    
    func findDateInRange(_ sDate : Date, eDate : Date, cdate : Date) -> Bool {
        
        var check = Bool()
        var endate = eDate
        
        while endate.compare(sDate) != .orderedDescending {
            
            check = endate == cdate ? true : false
            if check {
                break
            }
            endate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: endate, options: [])!
        }
        return check
    }
    
    @IBAction func BtnByFarmPressed(_ sender: UIButton) {
        
        barChartView.moveViewToX(-50)
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        isFarmSelected = false
        UserDefaults.standard.set(true, forKey: "isCocciFarm")
        UserDefaults.standard.set(true, forKey: "customBarWidth")
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
       
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        moveFrame(true)
        maxFarmCount = 0
        isMove = false
        self.Eimeria_Maxima_Gross_Array.removeAllObjects()
        self.Eimeria_Maxima_Micro_Array.removeAllObjects()
        self.Eimeria_Tenella_Gross_Array.removeAllObjects()
        self.Eimeria_Acervulina_Gross_Array.removeAllObjects()
        
        lineChartView.isHidden = true
        barChartView.isHidden = false
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        self.subjectString = NSLocalizedString("Coccidiosis by farm", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        let arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {
            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            self.farmNames.add(getFormattedString(lastSessionDataArray: lastSessionDataArray, farmName: farmName, f: f))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupCocciDataByFarm(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Coccidiosis")
        }
        
        let farmNames1 = NSMutableArray()
        if self.Eimeria_Acervulina_Gross_Array.count > 0 {
            
            preparedArray.removeAllObjects()
           // ""
            for frNme in self.farmNames{
                var frNme1 = frNme as! String
                let range = frNme1.range(of: ".")
                frNme1 = String(frNme1[range!.upperBound...])
                farmNames1.add(frNme1.crop())
            }
            verticalValues.removeAll()
            verticalValues = farmNames1 as NSArray as! [String]
            
            var chartDataSet : BarChartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Eimeria_Acervulina_Gross_Array as NSArray as! [Float], lable:NSLocalizedString(eimeriaStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Eimeria_Maxima_Gross_Array as NSArray as! [Float], lable:NSLocalizedString(EiMaximaGrossTxt, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Eimeria_Maxima_Micro_Array as NSArray as! [Float], lable:NSLocalizedString(eimeriaMaxStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Eimeria_Tenella_Gross_Array as NSArray as! [Float], lable:NSLocalizedString(eimeriaTenStr, comment: "") as NSString)!
            self.preparedArray.add(chartDataSet)
            
        }
        
        if self.preparedArray.count < 3 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        
        let barData : BarChartDataSet = (self.preparedArray[0] as? BarChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        
        let barData1 : BarChartDataSet = (self.preparedArray[1] as? BarChartDataSet)!
        barData1.colors = [UIColor.yellow]
        
        let barData2 : BarChartDataSet = (self.preparedArray[2] as? BarChartDataSet)!
        barData2.colors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
        
        let barData3 : BarChartDataSet = (self.preparedArray[3] as? BarChartDataSet)!
        barData3.colors = [UIColor(red: 163/255, green: 91/255, blue: 96/255, alpha: 1)]
        let dataSets: [BarChartDataSet] = [barData,barData1,barData2,barData3]
        let barWidth = 0.1
        let startYear = 0.0
        let groupCount = Double(self.farmNames.count)
        barChartView.xAxis.labelCount = farmNames.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:farmNames1 as! [String])
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = Double(startYear)
        barChartView.xAxis.axisMaximum = groupCount-startYear
        barChartView.xAxis.centerAxisLabelsEnabled = true
        chartData = BarChartData(dataSets: dataSets)
        chartData.groupBars(fromX: Double(0.0), groupSpace: 0.4, barSpace: 0.05)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.setVisibleXRangeMaximum(10)
        dateLable.isHidden = false
        
        self.rightArrow.isHidden = farmNames1.count > 10 ? false : true
        
        self.view.bringSubviewToFront(self.rightArrow)
        
        if barData.yMax == 0.0 && barData1.yMax == 0.0 && barData2.yMax == 0.0 && barData3.yMax == 0.0{
            barChartView.clear()
           
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
            rightArrow.isHidden = true
        }
        barChartView.xAxis.resetCustomAxisMax()
        barChartView.xAxis.resetCustomAxisMin()
    }
    @IBAction func BtnAcrevulinaPressed(_ sender: UIButton) {
        
        barChartView.moveViewToX(-50)
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        isFarmSelected = false
        //self.moreLable.isHidden = false
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        dateLable.isHidden = false
        moveFrame(true)
        isMove = false
        maxFarmCount = 0
        self.Eimeria_Acervulina_Gross_Array.removeAllObjects()
        btnShare.isHidden = false
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.subjectString = NSLocalizedString("Coccidiosis - E. acervulina gross", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first! as NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        
        var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first! as NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        let isSet = lastSessionDataArray.count < 5 ? true : false
        UserDefaults.standard.set(isSet, forKey: "customBarWidth")
        
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {

            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            self.farmNames.add(getFormattedString(lastSessionDataArray: lastSessionDataArray, farmName: farmName, f: f))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupEimeriaAcervulinaGross(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Coccidiosis")
        }
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        
        dataSet.colors = [UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        dataSet.stackLabels = [NSLocalizedString("E. acervulina gross 0", comment: ""),NSLocalizedString("E. acervulina gross 1", comment: ""),NSLocalizedString("E. acervulina gross 2", comment: ""),NSLocalizedString("E. acervulina gross 3", comment: ""),NSLocalizedString("E. acervulina gross 4", comment: "")]
        
        barChartView.xAxis.labelCount = self.farmNames.count
        let farmNames1 = NSMutableArray()
        for frNme in self.farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            //""
            farmNames1.add(frNme1.crop())
        }
        self.rightArrow.isHidden = farmNames1.count > 10 ? false : true
        if farmNames1.count < 11 {
            barChartView.viewPortHandler.resetBarChart(chart: barChartView)
        }
      
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:farmNames1 as! [String])
        let AcreChartData = BarChartData(dataSets: [dataSet])
        self.barChartView.data = AcreChartData
        barChartView.setVisibleXRangeMaximum(10)
        if dataSet.yMax <= 0 {
           // self.moreLable.isHidden  = true
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
        }
    }
    @IBAction func BtnMaximaGrossPressed(_ sender: UIButton) {
        
        barChartView.moveViewToX(-50)
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        isFarmSelected = false
        //self.moreLable.isHidden = false
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        dateLable.isHidden = false
        moveFrame(true)
        isMove = false
        maxFarmCount = 0
        btnShare.isHidden = false
        self.Eimeria_Maxima_Gross_Array.removeAllObjects()
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.subjectString = NSLocalizedString("Coccidiosis - E. maxima gross", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        
        var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        let isSet = lastSessionDataArray.count < 5 ? true : false
        UserDefaults.standard.set(isSet, forKey: "customBarWidth")
        
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            
            self.farmNames.add(getFormattedString(lastSessionDataArray: lastSessionDataArray, farmName: farmName, f: f))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupMaximaGross(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Coccidiosis")
        }
        
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        dataSet.stackLabels = [NSLocalizedString("E. maxima gross 0", comment: ""),NSLocalizedString("E. maxima gross 1", comment: ""),NSLocalizedString("E. maxima gross 2", comment: ""),NSLocalizedString("E. maxima gross 3", comment: ""),NSLocalizedString("E. maxima gross 4", comment: "")]
        dataSet.colors = [ UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        
        let farmNames1 = NSMutableArray()
        for frNme in self.farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            //""
            farmNames1.add(frNme1.crop())
        }
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:farmNames1 as! [String])
        self.barChartView.xAxis.labelCount = dataSet.entryCount
        let maximaChartData = BarChartData(dataSets: [dataSet])
        
        self.barChartView.data = maximaChartData
        barChartView.setVisibleXRangeMaximum(10)
        
        self.rightArrow.isHidden = farmNames1.count > 10 ? false : true
        
        self.view.bringSubviewToFront(self.rightArrow)
      
        if dataSet.yMax <= 0 {
          
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
        }
    }
    
    private func getFormattedString(lastSessionDataArray: NSArray, farmName:NSString,f: Int) -> NSString {
        return NSString(format: "%@(%@)",farmName,(lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "age") as! NSString)
    }
    
    @IBAction func BtnMaximaMicroPressed(_ sender: UIButton) {
        
        barChartView.moveViewToX(-50)
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        isFarmSelected = false
       // self.moreLable.isHidden = false
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        dateLable.isHidden = false
        moveFrame(true)
        isMove = false
        maxFarmCount = 0
        btnShare.isHidden = false
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.Eimeria_Maxima_Micro_Array.removeAllObjects()
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        self.subjectString = NSLocalizedString("Coccidiosis - E. maxima micro", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        
        var lastSessionDataArray  = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        let isSet = lastSessionDataArray.count < 5 ? true : false
        UserDefaults.standard.set(isSet, forKey: "customBarWidth")
        
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {

            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            
            
            self.farmNames.add(getFormattedString(lastSessionDataArray: lastSessionDataArray, farmName: farmName, f: f))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupMaximaMicro(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Coccidiosis")
        }
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        dataSet.stackLabels = ["E. maxima micro 0","E. maxima micro 1","E. maxima micro 2","E. maxima micro 3","E. maxima micro 4"]
        dataSet.colors = [ UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        let maxiMicroData = BarChartData(dataSet: dataSet)
        let farmNames1 = NSMutableArray()
        for frNme in self.farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            //""
            farmNames1.add(frNme1.crop())
        }
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:farmNames1 as! [String])
        self.barChartView.xAxis.labelCount = dataSet.entryCount
        self.barChartView.data = maxiMicroData
        barChartView.setVisibleXRangeMaximum(10)
        if farmNames1.count < 11 {
            barChartView.viewPortHandler.resetBarChart(chart: barChartView)
        }
        self.rightArrow.isHidden = farmNames1.count > 10 ? false : true
       
        self.view.bringSubviewToFront(self.rightArrow)
       
        if dataSet.yMax <= 0 {
            
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
        }
        
    }
    @IBAction func BtnTenellaPressed(_ sender: UIButton) {
        
        barChartView.moveViewToX(-50)
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        isFarmSelected = false
        //self.moreLable.isHidden = false
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        dateLable.isHidden = false
        moveFrame(true)
        isMove = false
        maxFarmCount = 0
        btnShare.isHidden = false
        self.Eimeria_Tenella_Gross_Array.removeAllObjects()
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt == sender {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.subjectString = NSLocalizedString("Coccidiosis - E. tenella gross", comment: "") as NSString
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        chartNameLable.text = self.subjectString as String
        var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            return
        }
        
        let isSet = lastSessionDataArray.count < 5 ? true : false
        UserDefaults.standard.set(isSet, forKey: "customBarWidth")
        
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {
        
            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            
            
            self.farmNames.add(getFormattedString(lastSessionDataArray: lastSessionDataArray, farmName: farmName, f: f))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
            
            modalObj.setupTenellaGross(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Coccidiosis")
        }
        
        let dataSet = BarChartDataSet(entries: self.entries_Array as NSArray as? [ChartDataEntry], label: "")
        dataSet.stackLabels = [NSLocalizedString("E. tenella gross 0", comment: ""),NSLocalizedString("E. tenella gross 1", comment: ""),NSLocalizedString("E. tenella gross 2", comment: ""),NSLocalizedString("E. tenella gross 3", comment: ""),NSLocalizedString("E. tenella gross 4", comment: "")]
        dataSet.colors = [ UIColor.green,UIColor.yellow,UIColor.orange,UIColor.red,UIColor.blue]
        
        let farmNames1 = NSMutableArray()
        for frNme in self.farmNames{
            var frNme1 = frNme as! String
            let range = frNme1.range(of: ".")
            frNme1 = String(frNme1[range!.upperBound...])
            //""
            farmNames1.add(frNme1.crop())
        }
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:farmNames1 as! [String])
        self.barChartView.xAxis.labelCount = dataSet.entryCount
        
        let tenellaChartData = BarChartData(dataSets: [dataSet])
        
        self.barChartView.data = tenellaChartData
        barChartView.setVisibleXRangeMaximum(10)
        if farmNames1.count < 11 {
            barChartView.viewPortHandler.resetBarChart(chart: barChartView)
        }
        self.rightArrow.isHidden = farmNames1.count > 10 ? false : true
        
        self.view.bringSubviewToFront(self.rightArrow)
        
        if dataSet.yMax <= 0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
        }
    }
    
    
    
    @IBAction func btnLastSessionPressed(_ sender: AnyObject) {
        
        self.btnLastSession.isSelected = true
        self.btnHistorical.isSelected = false
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        self.subjectString = NSLocalizedString(lastCocciSessioinTxt, comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        self.callCommonFunction("Coccidiosis")
        let barData : ChartDataSet = (self.preparedArray[0] as? ChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        chartData = BarChartData(dataSets: [barData])
     
        
        barChartView.data = chartData
        
        if barData.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
    }
    
    @IBAction func btnHistoricalPressed(_ sender: AnyObject) {
        
        self.btnLastSession.isSelected = false
        self.btnHistorical.isSelected = true
        self.subjectString = NSLocalizedString("Coccidiosis Summary Historical", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        if self.preparedArray.count < 2 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricData, comment: ""))
            self.barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            return
        } else {
            self.btnShare.isHidden = false
            self.incedenceText.isHidden = false
        }
        
        let barData : ChartDataSet = (self.preparedArray[0] as? ChartDataSet)!
        
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        
        let barData1 : ChartDataSet = (self.preparedArray[1] as? ChartDataSet)!
        barData1.colors = [UIColor(red: 168/255, green: 81/255, blue: 79/255, alpha: 1)]
        
        var barData2 = ChartDataSet()
        var groupSpace = 0.4
        var barSpace = 0.05
        
        if self.preparedArray.count > 2 {
            
            barData2  = (self.preparedArray[2] as? ChartDataSet)!
            barData2.colors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
            
            chartData = BarChartData(dataSets: [barData,barData1,barData2])
            groupSpace = 0.2
            barSpace = 0.02
        }
        else{
            
            chartData = BarChartData(dataSets: [barData,barData1])
        }
        
        chartData.groupBars(fromX: Double(-0.5), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        if barData.yMax == 0.0 && barData1.yMax == 0.0 && barData2.yMax == 0.0{
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
    }
    @IBOutlet weak var btnShare: UIButton!
    @IBAction func btnSharePressed(_ sender: AnyObject) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //""
        let imageToShare = image!.cropToBounds(image!, width: 958, height: 583 ,ismove: isMove)
        
        let activityViewController = UIActivityViewController(activityItems:[imageToShare,self.subjectString], applicationActivities: nil)
        activityViewController.setValue(self.subjectString, forKey: "subject")
        activityViewController.popoverPresentationController?.sourceView = self.btnShare
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
        
    }
    func moveFrame(_ isMove:Bool) {
        
        var rect = barChartView.frame
        rect.origin.y = isMove ? 111 : 166
        rect.size.height = isMove ? 590 : 529
        barChartView.frame = rect
        
        rect = btnShare.frame
        rect.origin.y = isMove ? 66 : 126
        btnShare.frame = rect
        
        rect = chartNameLable.frame
        rect.origin.y = isMove ? 66 : 126
        chartNameLable.frame = rect
        
        
        
    }
    @IBAction func backBTN(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "isBackPress")
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
        
    }
    func setupBottumTabs(_ numberOfTabs : Int) {
        
        let eachBtnWidth = self.view.frame.size.width/CGFloat(numberOfTabs)
        
        for i in 0..<numberOfTabs {
            
            let btn  = UIButton()
            btn.setTitle(NSString(format: "%d",i) as String, for: UIControl.State())
            btn.setTitleColor(UIColor.blue, for: UIControl.State())
            btn.frame = CGRect(x: CGFloat(i)*eachBtnWidth , y: 728, width: eachBtnWidth , height: 40)
            btn.setBackgroundImage(UIImage(named: "tab_unselect" ), for: UIControl.State())
            btn.setBackgroundImage(UIImage(named: "tab_select2" ), for: .selected)
            
            self.view.addSubview(btn)
        }
    }
}


extension CossiBarChartViewController{
    
    func dragDetected(isEdgeRight:Bool, isEdgeLeft: Bool) {
        self.rightArrow.isHidden = isEdgeRight
        self.leftArrow.isHidden = isEdgeLeft
    }
}



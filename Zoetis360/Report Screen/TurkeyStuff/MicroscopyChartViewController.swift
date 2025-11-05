//
//  CossiBarChartViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 08/12/16.
//  Copyright © 2016 "". All rights reserved.
// manish commits

import UIKit
import Charts
import Reachability

import Gigya
import GigyaTfa
import GigyaAuth



// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MicroscopyChartViewController: UIViewController,MicroscopyCalculationsDelegates,userLogOut,ChartViewDelegate {
    
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var incedenceText: UIImageView!
    
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    //let moreLable = UILabel()
    let rightArrow = UIButton()
    let leftArrow = UIButton()
    var totalStr = String()
    
    let buttonbg1 = UIButton ()
    var customPopView1 :UserListView!
    let buttonbg = UIButton ()
    var preparedArray = NSMutableArray()
    
    var indexValueArray =  [Int]()
    var verticalValuesForWeek =  [String]()
    
    var subjectString = NSString()
    
    var sessionDate = NSString()
    var verticalValues =  [String]()
    var farmNames = NSMutableArray()
    var headerTitle = NSString()
    var total_birds : Float = 0
    var maxFarmCount : Int = 0
    let dateLable = UILabel()
    
    let chartNameLable = UILabel()
    var chartNameString = NSString()
    var isMove = Bool()
    
    var Coccidia_Array = NSMutableArray()
    var Bacteria_Motile_Array = NSMutableArray()
    var Bacteria_Nonmotile_Array = NSMutableArray()
    var Pepto_Array = NSMutableArray()
    
    var entries_Array = NSMutableArray()
    var index : Int  = 0
    let lineChartView = LineChartView()
    var chartData = BarChartData()
    
    //var formatter : RangeValueFormatter = RangeValueFormatter()
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var btnHistorical: UIButton!
    @IBOutlet weak var btnLastSession: UIButton!
    
    var isFarmSelected:Bool?
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.btnHistorical.isHidden = false
        self.btnLastSession.isHidden = false
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 105.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.xAxis.labelRotationAngle = 90
        barChartView.dragEnabled = true
        barChartView.delegate = self
        // barChartView.drag
        barChartView.xAxis.wordWrapEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.legend.verticalAlignment = .top
        chartNameLable.frame = CGRect(x: self.view.frame.midX - 200, y: 66, width: 400, height: 30)
        chartNameLable.text = NSLocalizedString("Microscopy Summary Last Session", comment: "") as String
        chartNameLable.textAlignment = .center
        self.view.addSubview(chartNameLable)
        chartNameLable.font = UIFont.systemFont(ofSize: 18)
        dateLable.frame = CGRect(x: 115, y: 66, width: 200, height: 30)
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        self.view .addSubview(dateLable)
        dateLable.font = UIFont.systemFont(ofSize: 12)
        self.incedenceText.image = UIImage(named: "per-\(Regions.languageID)")
        
        //self.moreLable.frame = CGRect(x: 115, y: btnShare.frame.origin.y+30 , width: 450, height: 20)
        //self.moreLable.font = UIFont.boldSystemFont(ofSize: 14)
        // self.moreLable.textAlignment = .left
        totalStr = "Total Farms:"
        
        self.rightArrow.frame = CGRect(x: btnShare.frame.origin.x+12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.rightArrow)
        rightArrow.isUserInteractionEnabled = false
        self.rightArrow.setImage(UIImage(named: "next_icon"), for: .normal)
        
        self.leftArrow.frame = CGRect(x: btnShare.frame.origin.x-12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.leftArrow)
        leftArrow.isUserInteractionEnabled = false
        self.leftArrow.setImage(UIImage(named: "back_icon"), for: .normal)
        
        // self.view.addSubview(self.moreLable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.subjectString = NSLocalizedString("Microscopy Summary Last Session", comment: "") as NSString
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
        
        let axisLables = nameCrop(inputSting: verticalValues)
        let chartDataSet : BarChartDataSet = setChartDataForFarm(axisLables, values: finishedArray as! [Float], lable:UtilityClass.convertDateFormater(sessionDate as String) as NSString)!
        
        self.preparedArray.add(chartDataSet)
    }
    func didFinishWithParsingWithFarmData (_ finishedArray : NSArray){
        
        maxFarmCount+=1
        
        var Coccidia : Float = 0
        var Bacteria_Motile : Float = 0
        var Bacteria_Nonmotile : Float = 0
        var Pepto : Float = 0
        
        Coccidia = finishedArray[0] as! Float
        Bacteria_Motile = finishedArray[1] as! Float
        Bacteria_Nonmotile = finishedArray[2] as! Float
        Pepto = finishedArray[3] as! Float
        
        Bacteria_Nonmotile = Bacteria_Nonmotile*100/self.total_birds
        Coccidia = Coccidia*100/self.total_birds
        Bacteria_Motile = Bacteria_Motile*100/self.total_birds
        Pepto = Pepto*100/self.total_birds
        
        Bacteria_Motile = (Bacteria_Motile.isNaN) ? 0 : Bacteria_Motile
        Coccidia = (Coccidia.isNaN) ? 0 : Coccidia
        Bacteria_Nonmotile = (Bacteria_Nonmotile.isNaN) ? 0 : Bacteria_Nonmotile
        Pepto = (Pepto.isNaN) ? 0 : Pepto
        
        self.Bacteria_Motile_Array.add(Bacteria_Motile)
        self.Coccidia_Array.add(Coccidia)
        self.Bacteria_Nonmotile_Array.add(Bacteria_Nonmotile)
        self.Pepto_Array.add(Pepto)
        
        if !isFarmSelected! {
            
            if (Bacteria_Motile > 0) || (Coccidia > 0) || (Bacteria_Nonmotile > 0) || (Pepto > 0) {
                verticalValuesForWeek.append(verticalValues[maxFarmCount-1])
                indexValueArray.append(maxFarmCount-1)
            }
        }
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
    
    func callCommonFunction(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        //arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = MIcroscopyCalculations()
        
        modalObj.delegate = self
        
        if arrayOfIds.count > 2 {
            
            for i in 0..<3{
                
                
                let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    self.barChartView.clear()
                    return
                }
                
                let objectArray : NSMutableArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
                let allFarmDataArray = NSMutableArray()
                
                var totalBirdsPerFarm : Float = 0
                
                for j in 0..<lastSessionDataArray.count {
                    
                    let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                    
                    let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                    
                    let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                    
                    totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                    
                    let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
                    
                    allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
                }
                
                modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
                
            }
        }
        
        else if arrayOfIds.count > 1 {
            
            for i in 0..<2{
                
                let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    self.barChartView.clear()
                    return
                }
                
                let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
                let allFarmDataArray = NSMutableArray()
                
                var totalBirdsPerFarm : Float = 0
                
                for j in 0..<lastSessionDataArray.count {
                    
                    let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                    
                    let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                    
                    let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                    
                    totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                    
                    let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId : necID) as NSArray
                    
                    allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
                }
                
                modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
                
            }
        }
        else{
            
            let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                self.barChartView.clear()
                return
            }
            
            let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
            
            sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            
        }
    }
    
    // MARK: - Button Actions
    @IBAction func BtnSummuaryPressed(_ sender: UIButton) {
        isFarmSelected = false
        self.rightArrow.isHidden = true
        self.leftArrow.isHidden = true
        
        
        //self.moreLable.isHidden = true
        barChartView.xAxis.centerAxisLabelsEnabled = false
        barChartView.viewPortHandler.resetBarChart(chart: barChartView)
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
        UserDefaults.standard.set(false, forKey: "customBarWidth")
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        self.dragDetected(isEdgeRight: true, isEdgeLeft: true)
        dateLable.isHidden = true
        isMove = true
        moveFrame(false)
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        lineChartView.isHidden = true
        barChartView.isHidden = false
        self.subjectString = NSLocalizedString("Microscopy Summary Last Session", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        for btn in self.view.subviews {
            if btn.isKind(of: UIButton.self) {
                let bt = btn as! UIButton
                if bt.tag == 100 || bt.titleLabel?.text == NSLocalizedString("Last session", comment: "") {
                    bt.isSelected = true
                } else{
                    bt.isSelected = false
                }
            }
        }
        
        self.btnHistorical.isHidden = false
        self.btnLastSession.isHidden = false
        
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        verticalValues = nameCrop(inputSting: MicroscopyObservationNameArray)
        self.headerTitle = "Microscopy"
        self.callCommonFunction("Microscopy")
        
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.pinchZoomEnabled = false
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        
        var barData : ChartDataSet = ChartDataSet()
        if self.preparedArray.count > 0 {
            barData  = (self.preparedArray[0] as? ChartDataSet)!
            barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
            
            let chartData = BarChartData(dataSets: [barData])
            barData.notifyDataSetChanged()
            chartData.notifyDataChanged()
            barChartView.notifyDataSetChanged()
            barChartView.data = chartData
        }
        if barData.yMax <= 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            self.dateLable.isHidden = true
        }
        print(chartData.xMin)
    }
    
    @IBAction func BtnByWeekPressed(_ sender: UIButton) {
        isFarmSelected = false
        self.rightArrow.isHidden = true
        self.leftArrow.isHidden = true
        
        barChartView.xAxis.centerAxisLabelsEnabled = false
        UserDefaults.standard.set(true, forKey: "isCocciFarm")
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        dateLable.isHidden = false
        verticalValues = weekArray
        self.Bacteria_Motile_Array.removeAllObjects()
        self.Bacteria_Nonmotile_Array.removeAllObjects()
        self.Pepto_Array.removeAllObjects()
        self.Coccidia_Array.removeAllObjects()
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        isMove = false
        moveFrame(true)
        
        self.verticalValuesForWeek.removeAll()
        indexValueArray.removeAll()
        
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
        // lineChartView.xAxis.valueFormatter = formatter
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelRotationAngle = 90
        lineChartView.chartDescription?.text = ""
        
        lineChartView.rightAxis.enabled = false
        lineChartView.isHidden = false
        self.barChartView.isHidden = true
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
        self.subjectString = NSLocalizedString("Microscopy by week", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        let arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        //arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        let objectArray1 = CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first! as NSNumber).mutableCopy() as! NSMutableArray
        sessionDate = (objectArray1.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        
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
        
        let modalObj = MIcroscopyCalculations()
        
        modalObj.delegate = self
        
        let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.last! as NSNumber)
        
        if lastSessionDataArray.count == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            self.lineChartView.clear()
            return
        }
        
        for j in 0..<lastSessionDataArray.count {
            
            let age = ((lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as! NSString).intValue
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            if age > 0 && age < 8 {
                
                totalBirdsWeek1 = totalBirdsWeek1+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week1FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 7 && age < 15 {
                
                totalBirdsWeek2 = totalBirdsWeek2+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week2FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 14 && age < 22 {
                
                totalBirdsWeek3 = totalBirdsWeek3+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week3FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 21 && age < 29 {
                
                totalBirdsWeek4 = totalBirdsWeek4+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week4FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 28 && age < 36 {
                
                totalBirdsWeek5 = totalBirdsWeek5+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week5FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 35 && age < 43 {
                
                totalBirdsWeek6 = totalBirdsWeek6+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week6FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 42 && age < 50 {
                
                totalBirdsWeek7 = totalBirdsWeek7+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week7FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 49 && age < 57 {
                
                totalBirdsWeek8 = totalBirdsWeek8+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week8FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 56 && age < 64 {
                
                totalBirdsWeek9 = totalBirdsWeek9+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week9FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            if age > 63 {
                
                totalBirdsWeek10 = totalBirdsWeek10+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                
                week10FarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
        }
        
        self.total_birds = totalBirdsWeek1
        modalObj.setupCocciDataByFarm(week1FarmDataArray,birdsCount: totalBirdsWeek1 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek2
        modalObj.setupCocciDataByFarm(week2FarmDataArray,birdsCount: totalBirdsWeek2 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek3
        modalObj.setupCocciDataByFarm(week3FarmDataArray,birdsCount: totalBirdsWeek3 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek4
        modalObj.setupCocciDataByFarm(week4FarmDataArray,birdsCount: totalBirdsWeek4 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek5
        modalObj.setupCocciDataByFarm(week5FarmDataArray,birdsCount: totalBirdsWeek5 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek6
        modalObj.setupCocciDataByFarm(week6FarmDataArray,birdsCount: totalBirdsWeek6 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek7
        modalObj.setupCocciDataByFarm(week7FarmDataArray,birdsCount: totalBirdsWeek7 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek8
        modalObj.setupCocciDataByFarm(week8FarmDataArray,birdsCount: totalBirdsWeek8 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek9
        modalObj.setupCocciDataByFarm(week9FarmDataArray,birdsCount: totalBirdsWeek9 , catName: "Microscopy")
        
        self.total_birds = totalBirdsWeek10
        modalObj.setupCocciDataByFarm(week10FarmDataArray,birdsCount: totalBirdsWeek10 , catName: "Microscopy")
        
        if self.Coccidia_Array.count > 0 {
            
            preparedArray.removeAllObjects()
            
            var chartDataSet : LineChartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Coccidia_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[0] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Bacteria_Motile_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[1] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Bacteria_Nonmotile_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[2] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setLineChartDataForFarm(verticalValuesForWeek as [String], values: self.Pepto_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[3] as NSString)!
            
            self.preparedArray.add(chartDataSet)
        }
        
        if self.preparedArray.count < 3 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
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
        
        if barData.yMax <= 0.0 && barData1.yMax <= 0.0 && barData2.yMax <= 0.0 && barData3.yMax <= 0.0{
            lineChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            self.dateLable.isHidden = true
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
        
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.barChartView.moveViewToX(-50)
        }
        dragDetected(isEdgeRight: false, isEdgeLeft: true)
        UserDefaults.standard.set(true, forKey: "isCocciFarm")
        UserDefaults.standard.set(true, forKey: "customBarWidth")
        isFarmSelected = true
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        //self.moreLable.isHidden = false
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        moveFrame(true)
        maxFarmCount = 0
        isMove = false
        self.Bacteria_Motile_Array.removeAllObjects()
        self.Bacteria_Nonmotile_Array.removeAllObjects()
        self.Pepto_Array.removeAllObjects()
        self.Coccidia_Array.removeAllObjects()
        
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
        self.subjectString = NSLocalizedString("Microscopy by farm", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnHistorical.isHidden = true
        self.btnLastSession.isHidden = true
        self.entries_Array.removeAllObjects()
        self.farmNames.removeAllObjects()
        index = 0
        self.total_birds = 0.0
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = MIcroscopyCalculations()
        
        modalObj.delegate = self
        
        var lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            self.barChartView.clear()
            return
        }
        let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        dateLable.text = NSString(format: "%@",UtilityClass.convertDateFormater(sessionDate as String)) as String
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        for f in 0..<lastSessionDataArray.count {
            
            
            let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
            
            
            self.farmNames.add(NSString(format: "%@(%@)",farmName,(lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "age") as! NSString))
            
            let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.total_birds = numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            modalObj.setupCocciDataByFarm(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Microscopy")
        }
        
        let farmNames1 = NSMutableArray()
        if self.Coccidia_Array.count > 0 {
            
            preparedArray.removeAllObjects()
            
            for frNme in self.farmNames{
                var frNme1 = frNme as! String
                let range = frNme1.range(of: ".")
                frNme1 = String(frNme1[range!.upperBound...])
                //""
                farmNames1.add(frNme1.crop())
            }
            
            verticalValues = farmNames1 as NSArray as! [String]
            
            var chartDataSet : BarChartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Coccidia_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[0] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Bacteria_Motile_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[1] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Bacteria_Nonmotile_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[2] as NSString)!
            self.preparedArray.add(chartDataSet)
            
            chartDataSet = setChartDataForFarm(verticalValues as [String], values: self.Pepto_Array as NSArray as! [Float], lable:MicroscopyObservationNameArray[3] as NSString)!
            self.preparedArray.add(chartDataSet)
            
        }
        
        if self.preparedArray.count < 3 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
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
        //self.view.bringSubview(toFront: self.moreLable)
        self.view.bringSubviewToFront(self.rightArrow)
        // moreLable.text = totalStr + " \(farmNames1.count)" + (farmNames1.count > 10 ? " (Swipe left or right on graph to see all the farms)" : "")
        // moreLable.attributedText = customString(inputStr: moreLable.text!)
        
        if barData.yMax == 0.0 && barData1.yMax == 0.0 && barData2.yMax == 0.0 && barData3.yMax == 0.0{
            barChartView.clear()
            // self.moreLable.isHidden = true
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            dateLable.isHidden = true
            rightArrow.isHidden = true
        }
        barChartView.xAxis.resetCustomAxisMax()
        barChartView.xAxis.resetCustomAxisMin()
    }
    
    @IBAction func btnLastSessionPressed(_ sender: AnyObject) {
        
        self.btnLastSession.isSelected = true
        self.btnHistorical.isSelected = false
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        self.subjectString = NSLocalizedString("Microscopy Summary Last Session", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        if self.preparedArray.count > 0 {
            self.preparedArray.removeAllObjects()
        }
        self.callCommonFunction("Microscopy")
        let barData : ChartDataSet = (self.preparedArray[0] as? ChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        chartData = BarChartData(dataSets: [barData])
        print(chartData.xMin)
        
        barChartView.data = chartData
        
        if barData.yMax <= 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            self.dateLable.isHidden = true
        }
    }
    
    @IBAction func btnHistoricalPressed(_ sender: AnyObject) {
        
        self.btnLastSession.isSelected = false
        self.btnHistorical.isSelected = true
        self.subjectString = NSLocalizedString("Microscopy Summary Historical", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        if self.preparedArray.count < 2 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
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
        if barData.yMax <= 0.0 && barData1.yMax <= 0.0 && barData2.yMax <= 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            self.dateLable.isHidden = true
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
        
        UserDefaults.standard.set(false, forKey: "isCocciFarm")
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
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            self.ssologoutMethod()
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
    
    func buttonPressed11() {
        _ = customPopView1.removeView(view)
        buttonbg1.removeFromSuperview()
    }
    
    
    
    func failWithInternetConnection() {
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("You are currently offline. Please go online to sync data.", comment: ""))
    }
}

extension MicroscopyChartViewController{
    
    func dragDetected(isEdgeRight:Bool, isEdgeLeft: Bool) {
        
        self.rightArrow.isHidden = isEdgeRight
        self.leftArrow.isHidden = isEdgeLeft
        
    }
}


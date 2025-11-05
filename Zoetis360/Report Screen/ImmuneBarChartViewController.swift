//
//  ImmuneBarChartViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 06/12/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import Charts
import Reachability

 class ImmuneBarChartViewController: UIViewController,GI_TtactDelegate,IAxisValueFormatter,ChartViewDelegate {
   
     // MARK: - VARIABLES

     var lngId = NSInteger()
     //let formatter:RangeValueFormatter = RangeValueFormatter()
     let chartNameLable = UILabel()
     let objApiSync = ApiSync()
     let customLegends = UIImageView()
     var chartData = BarChartData()
     var sessionDate = NSString()
     var recivedDataArray = NSArray()
     var subjectString = NSString()
     var farmNames = NSMutableArray()
     var total_birds : Float = 0
     var verticalValues = [String]()
     var entries_Array = NSMutableArray()
     let rightArrow = UIButton()
     let leftArrow = UIButton()
     var totalStr = String()
     
     // MARK: - OUTLET
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var btnImmune: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
    @IBOutlet weak var btnHistorical: UIButton!
    @IBOutlet weak var btnLastSession: UIButton!
    @IBOutlet weak var incedenceText: UIImageView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
   
     // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        
        super.viewDidLoad()
        
        UserDefaults.standard.set(false, forKey: "isBackPress")
        barChartView.isHidden = true
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        barChartView.chartDescription?.text = ""
        barChartView.leftAxis.axisMaximum = 8.5
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMinimum = 0.0
        
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelRotationAngle = 90
        
        self.barChartView.scaleXEnabled = true
        self.barChartView.scaleYEnabled = false
        self.barChartView.dragEnabled = true
        self.barChartView.xAxis.wordWrapEnabled = false
        
        chartNameLable.frame = CGRect(x: self.view.frame.midX - 200, y: 116, width: 400, height: 30)
        chartNameLable.text = ""
        chartNameLable.textAlignment = .center
        self.view.addSubview(chartNameLable)
        chartNameLable.font = UIFont.systemFont(ofSize: 18)
        
        barChartView.delegate = self
        
        self.customLegends.frame = CGRect(x: 116, y: barChartView.frame.origin.y+100 , width: 100, height: 10)
        self.customLegends.image = UIImage(named: "Custom_legent")
        
        
        totalStr = NSLocalizedString("Total Farms:", comment: "")
        
        self.rightArrow.frame = CGRect(x: btnShare.frame.origin.x+12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.rightArrow)
        rightArrow.isUserInteractionEnabled = false
        self.rightArrow.setImage(UIImage(named: "next_icon"), for: .normal)
        
        self.leftArrow.frame = CGRect(x: btnShare.frame.origin.x-12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.leftArrow)
        leftArrow.isUserInteractionEnabled = false
        self.leftArrow.setImage(UIImage(named: "back_icon"), for: .normal)
        leftArrow.isHidden = true
        
        self.view.addSubview(self.customLegends)
        
    }
     override func viewWillAppear(_ animated: Bool) {
         
         lngId = UserDefaults.standard.integer(forKey: "lngId")

         barChartView.legend.verticalAlignment = .top
         self.customLegends.isHidden = true
         self.btnHistorical.isHidden = true
         self.btnLastSession.isHidden = true
         self.btnShare.isHidden = true
         self.incedenceText.image = UIImage(named: "bursa-\(Regions.languageID)")
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .none
         barChartView.leftAxis.valueFormatter = numberFormatter as? IAxisValueFormatter
         
         if CalculationError.hasError {
             self.navigationController?.popViewController(animated: true)
             CalculationError.hasError = false
         }
     }
     override func viewDidAppear(_ animated: Bool) {
         barChartView.isHidden = false
         self.btnImmunePressed(self.btnImmune)
         self.btnShare.isHidden = false
         
         
     }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
   
     // MARK: - IBACTION
    @IBAction func btnLastSessionPressed(_ sender: AnyObject) {
        
        self.subjectString = NSLocalizedString("Others Last Session", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        self.btnLastSession.isSelected = true
        self.btnHistorical.isSelected = false
        self.btnShare.isHidden = false
        barChartView.leftAxis.axisMaximum = 105

        let reports: ReportsCalculation = ReportsCalculation()
        if UserDefaults.standard.bool(forKey: "turkeyReport"){
            reports.callCommonFunction(dataSet.categoryName as NSString)
        }else{
            reports.callCommonFunctionChicken(dataSet.categoryName as NSString)
        }
        
        chartNameLable.text = self.subjectString as String
        let barData : ChartDataSet = dataSet.currentSet
        var lastChartData = BarChartData(dataSets: [barData])
        
        var singleColorBlue = Bool()
        var singleColorRed = Bool()
        
        var valArr = Array<Double>()
        for  i in 0..<barData.entryCount
        {
            let chartDataEntry = barData.entryForIndex(i)!
            let val = chartDataEntry.y
            if val > 0
            {
                valArr.append(val)
            }
            
        }
        let sortedNumbers = valArr.sorted()
        
        let colorArr = NSMutableArray()
        for j in 0..<sortedNumbers.count
        {
            let indexVal = sortedNumbers[j]
            if indexVal > 19.5 && singleColorRed == false
            {
                colorArr.add(UIColor.red)
                singleColorRed = true
            }
            else if indexVal < 20 && singleColorBlue == false
            {
                colorArr.add(UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1))
                singleColorBlue = true
            }
        }
        
        if colorArr.count > 1 {
            self.customLegends.isHidden = false
        } else {
            self.customLegends.isHidden = true
        }
        
        barData.colors = colorArr.mutableCopy() as! [NSUIColor]

        barChartView.data = lastChartData
        
        if barData.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
    }
    
    @IBAction func btnHistoricalPressed(_ sender: AnyObject) {
        self.customLegends.isHidden = true
        self.subjectString = NSLocalizedString("Others Historical", comment: "") as NSString
        chartNameLable.text = NSLocalizedString("Others Historical", comment: "")
        self.btnLastSession.isSelected = false
        self.btnHistorical.isSelected = true
        self.incedenceText.isHidden = false
        self.btnShare.isHidden = false
        barChartView.leftAxis.axisMaximum = 105
        var groupSpace = 0.7
        let barSpace = 0.05
        var strPoint = -0.5

        if recivedDataArray.count < 2 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
            self.incedenceText.isHidden = true
            self.btnShare.isHidden = true
            barChartView.clear()
            return
        }
        
        let barData : ChartDataSet = (recivedDataArray[0] as? ChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        
        let barData1 : ChartDataSet = (recivedDataArray[1] as? ChartDataSet)!
        barData1.colors = [UIColor(red: 168/255, green: 81/255, blue: 79/255, alpha: 1)]
        
        var barData2 = ChartDataSet()
        
        if recivedDataArray.count > 2 {
            
            barData2 = (recivedDataArray[2] as? ChartDataSet)!
            barData2.colors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
            
            chartData = BarChartData(dataSets: [barData,barData1,barData2])
            strPoint = -0.5
            groupSpace = 0.55
        }
        else{
            chartData = BarChartData(dataSets: [barData,barData1])
        }
        
        chartData.groupBars(fromX: Double(strPoint), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        
        if barData.yMax == 0.0 && barData1.yMax == 0.0 && barData2.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true

        }
        
        barChartView.leftAxis.axisMinimum = 0.0
    }
     
     
     @IBAction func btnImmunePressed(_ sender: UIButton) {
         barChartView.moveViewToX(-50)
         dragDetected(isEdgeRight: false, isEdgeLeft: true)
         incedenceText.isHidden = false
         self.incedenceText.image = UIImage(named: "bursa-\(Regions.languageID)")
         btnImmune.isSelected = true
         btnOthers.isSelected = false
         //self.moreLable.isHidden = false
         btnShare.isHidden = false
         barChartView.leftAxis.axisMaximum = 8.5
                 moveFrame(false)
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
         
         
         self.subjectString = NSLocalizedString("Immune by Bursa Size", comment: "") as String as NSString
                 chartNameLable.text = self.subjectString as String
                 self.btnHistorical.isHidden = true
                 self.btnLastSession.isHidden = true
                 self.farmNames.removeAllObjects()
                 self.total_birds = 0.0
                 
         var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
         
         //arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
                 
                 let modalObj = GI_Tract_Modal()
                 
                 modalObj.delegate = self
                     var lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
                     
                     if lastSessionDataArray.count == 0 {
                         
                         Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                         self.barChartView.clear()
                         return
                     }
          let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
         sessionDate = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
         
         let isSet = lastSessionDataArray.count < 5 ? true : false
         UserDefaults.standard.set(isSet, forKey: "customBarWidth")
         
                     let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
                     lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
                     
                     for f in 0..<lastSessionDataArray.count {
                         
                         self.total_birds = 0.0
                         
                         let farmName : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "farmName") as! NSString
                         
                         self.farmNames.add(NSString(format: "%@(%@)",farmName,(lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "age") as! NSString))
                         
                         let necID = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                         
                         let numberOfBirds : NSString = (lastSessionDataArray.object(at: f) as AnyObject).value(forKey: "noOfBirds") as! NSString
                         
                         self.total_birds = numberOfBirds.floatValue
                         
                         let lastFarmDataArray : NSArray = CoreDataHandler().fetch_GI_Tract_AllData(farmName,postingId: necID) as NSArray
                         
                         modalObj.setupMeanBursaSize(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: "Immune")
                     }
                 barChartView.xAxis.labelPosition = .bottom
                 barChartView.rightAxis.enabled = false
                 barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
         
         let farmNames1 = NSMutableArray()
         for frNme in self.farmNames{
             var frNme1 = frNme as! String
             let range = frNme1.range(of: ".")
             frNme1 = String(frNme1[range!.upperBound...])
             //""
             farmNames1.add(frNme1.crop())
         }
                 setChart(farmNames1 as NSArray as! [String] , values: self.entries_Array as NSArray as! [Float])
         
     }
     
     @IBAction func btnOthersPressed(_ sender: UIButton)
     {
         self.incedenceText.image = UIImage(named: "per-\(Regions.languageID)")
         UserDefaults.standard.set(true, forKey: "customBarWidth")
         UserDefaults.standard.synchronize()
         btnOthers.isSelected = true
         btnImmune.isSelected = false
         self.btnHistorical.isHidden = false
         self.btnLastSession.isHidden = false
         barChartView.viewPortHandler.resetBarChart(chart: barChartView)
         self.rightArrow.isHidden = true
         self.leftArrow.isHidden = true
        
         incedenceText.isHidden = false
         btnLastSession.isSelected = true
         btnHistorical.isSelected = false
         moveFrame(false)
         self.subjectString = NSLocalizedString("Others Last Session", comment: "") as NSString
         chartNameLable.text = self.subjectString as String
         barChartView.leftAxis.axisMaximum = 105
         barChartView.xAxis.labelPosition = .bottom
         barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
         
         let reports: ReportsCalculation = ReportsCalculation()
         if UserDefaults.standard.bool(forKey: "turkeyReport"){
             reports.callCommonFunction(dataSet.categoryName as NSString)
         }else{
             reports.callCommonFunctionChicken(dataSet.categoryName as NSString)
         }
         
         let barData : ChartDataSet = dataSet.currentSet
       
         var otherChartData = BarChartData(dataSets: [barData])
         
         self.barChartView.xAxis.labelCount = verticalValues.count
         self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
         
         
         var singleColorBlue = Bool()
         var singleColorRed = Bool()
         
         var valArr = Array<Double>()
         for  i in 0..<barData.entryCount
         {
             let chartDataEntry = barData.entryForIndex(i)!
             let val = chartDataEntry.y
             if val > 0
             {
                 valArr.append(val)
             }
             
         }
         let sortedNumbers = valArr.sorted()
         let colorArr = NSMutableArray()
         for j in 0..<sortedNumbers.count
         {
             let indexVal = sortedNumbers[j]
             if indexVal > 19.5 && singleColorRed == false
             {
                 colorArr.add(UIColor.red)
                 singleColorRed = true
             }
             else if indexVal < 20 && singleColorBlue == false
             {
                 colorArr.add(UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1))
                 singleColorBlue = true
             }
         }
         
         if colorArr.count > 1 {
             self.customLegends.isHidden = false
         } else {
             self.customLegends.isHidden = true
         }
         
         barData.colors = colorArr.mutableCopy() as! [NSUIColor]
         barChartView.data = otherChartData
         barChartView.leftAxis.axisMinimum = 0.0
         
         if barData.yMax == 0.0 {
             barChartView.clear()
             self.btnShare.isHidden = true
             self.incedenceText.isHidden = true
         }
     }
   
     @IBAction func btnSharePressed(_ sender: AnyObject) {
         
         UIGraphicsBeginImageContext(view.frame.size)
         view.layer.render(in: UIGraphicsGetCurrentContext()!)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         //""
         let imageToShare = image!.cropToBounds(image!, width: 958, height: 590 ,ismove: true)

         let activityViewController = UIActivityViewController(activityItems:[imageToShare,self.subjectString], applicationActivities: nil)
         activityViewController.setValue("Immune/Others", forKey: "subject")
         activityViewController.popoverPresentationController?.sourceView = self.btnShare
         self.navigationController?.present(activityViewController, animated: true, completion: nil)
     }
     
     @IBAction func backAction(_ sender: AnyObject) {
         self.navigationController?.popViewController(animated: true)
     }
     
     // MARK: - METHODS AND FUNCTIONS
    func infoButtonAction() {
        appDelegateObj.testFuntion()
    }
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        return self.verticalValues[Int(value)]
    }
    func didFinishWithParsing(finishedArray : NSArray){
        appDelegateObj.testFuntion()
    }
  
    func moveFrame(_ isMove:Bool) {
        
        var rect = barChartView.frame
        rect.origin.y = isMove ? 111 : 166
        rect.size.height = isMove ? 590 : 529
        barChartView.frame = rect
        
        rect = btnShare.frame
        rect.origin.y = isMove ? 66 : 126
        btnShare.frame = rect
    }
    func didFinishWithParsingBursaSize(_ bursa_total : Float) {
    
        self.entries_Array.add(bursa_total)
        
    }
    /////New code
    func setChart(_ dataPoints: [String], values: [Float]) {

        var dataEntries: [BarChartDataEntry] = []
        self.rightArrow.isHidden = dataPoints.count > 10 ? false : true
        
        self.view.bringSubviewToFront(self.rightArrow)
        
        self.barChartView.xAxis.labelCount = dataPoints.count
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:dataPoints)
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(x:Double(i) , y : Double(values[i]))
            dataEntries.append(dataEntry)
            
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: UtilityClass.convertDateFormater(sessionDate as String))
        let setNewChartData = BarChartData(dataSet: chartDataSet)
        setNewChartData.barWidth = 0.7
        barChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        barChartView.data = setNewChartData
        barChartView.setVisibleXRangeMaximum(10)
        
        
        if chartDataSet.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            
        }
    }
    func setChartData(_ dataPoints: [String], values: [Double]) -> BarChartDataSet? {
        var dataEntries: [BarChartDataEntry] = []
       
        self.barChartView.xAxis.labelCount = dataPoints.count
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x:Double(i) , y : values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bursa Size")
        return chartDataSet
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

// MARK: - EXTENSION
extension ImmuneBarChartViewController{
    
    func dragDetected(isEdgeRight: Bool, isEdgeLeft: Bool) {
        self.rightArrow.isHidden = isEdgeRight
        self.leftArrow.isHidden = isEdgeLeft
    }
}

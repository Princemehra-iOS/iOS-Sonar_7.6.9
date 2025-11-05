//
//  TurkeyBarChartViewController.swift
//  Zoetis -Feathers
//
//  Created by Pradeep Dahiya on 10/09/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import Charts

class TurkeyBarChartViewController: UIViewController,IAxisValueFormatter,ChartViewDelegate {
    
    // MARK: - VARIABLES
    
    var recivedDataArray = NSArray()
    var origionalDataArray = NSArray()
    let customLegends = UIImageView()
    var verticalValues: [String]! = nil
    var headerTitle: NSString?
    var subjectString = NSString()
    let chartNameLable = UILabel()
    let objApiSync = ApiSync()
    let rightArrow = UIButton()
    let leftArrow = UIButton()
    var airSacChartData: AirsacData?
    let dateLable = UILabel()
    
    // MARK: - OUTLET
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var incedenceText: UIImageView!
    @IBOutlet weak var syncNotificationLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var headerLable: UILabel!
    @IBOutlet weak var btnHistorical: UIButton!
    @IBOutlet weak var btnLastSession: UIButton!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var btnAllObservations: UIButton!
    @IBOutlet weak var btnAirSac: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    let respiratoryTractStr:NSString = "Respiratory Tract (Turkey) "
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        if CalculationError.hasError {
            self.navigationController?.popViewController(animated: true)
            CalculationError.hasError = false
            return
        }
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key(rawValue: convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor)): UIColor.white], for: UIControl.State.selected)
        
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.xAxis.labelRotationAngle  = 90
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 105.0
        barChartView.rightAxis.axisMinimum = 0.0
        barChartView.delegate = self
        let axisLables = observationNameCrop(values: verticalValues) as! [String]
        verticalValues.removeAll()
        verticalValues = axisLables
        barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        
        self.customLegends.frame = CGRect(x: 103, y: barChartView.frame.origin.y+60 , width: 100, height: 10)
        self.customLegends.image = UIImage(named: "Custom_legent")
        self.view.addSubview(self.customLegends)
        
        chartNameLable.frame = CGRect(x: UIScreen.main.bounds.midX - 300, y: 116, width: 600, height: 30)
        chartNameLable.text = "Coccidiosis summary last session"
        chartNameLable.textAlignment = .center
        self.view .addSubview(chartNameLable)
        chartNameLable.font = UIFont.systemFont(ofSize: 18)
        
        self.rightArrow.frame = CGRect(x: btnShare.frame.origin.x+12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.rightArrow)
        rightArrow.isUserInteractionEnabled = false
        self.rightArrow.setImage(UIImage(named: "next_icon"), for: .normal)
        
        self.leftArrow.frame = CGRect(x: btnShare.frame.origin.x-12, y: UIScreen.main.bounds.midY - 25, width: 50, height: 50)
        self.view.addSubview(self.leftArrow)
        leftArrow.isUserInteractionEnabled = false
        self.leftArrow.setImage(UIImage(named: "back_icon"), for: .normal)
        
        self.dragDetected(isEdgeRight: true, isEdgeLeft: true)
        
        dateLable.frame = CGRect(x: 115, y: 119, width: 200, height: 30)
        self.view .addSubview(dateLable)
        dateLable.font = UIFont.systemFont(ofSize: 12)
        
        self.btnAllObservations.setTitle(NSLocalizedString("Summary", comment: ""), for: .normal)
        self.btnAirSac.setTitle(verticalValues[2], for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadSingleSession()
        
        self.btnAllObservations.isHidden = self.headerTitle != respiratoryTractStr
        self.btnAirSac.isHidden = self.headerTitle != respiratoryTractStr
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBACTION
    @IBAction func backAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHistoricalPressed(_ sender: AnyObject) {
        
        self.customLegends.isHidden = true
        self.btnLastSession.isSelected = false
        self.btnHistorical.isSelected = true
        self.subjectString = NSLocalizedString("\(String(describing: self.headerTitle!)) Historical", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        if recivedDataArray.count < 2 {
            self.barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
            return
        } else {
            self.btnShare.isHidden = false
            self.incedenceText.isHidden = false
        }
        
        let barData : ChartDataSet = (recivedDataArray[0] as? ChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        
        let barData1 : ChartDataSet = (recivedDataArray[1] as? ChartDataSet)!
        barData1.colors = [UIColor(red: 168/255, green: 81/255, blue: 79/255, alpha: 1)]
        
        self.barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        
        var barData2 = ChartDataSet()
        var groupSpace = 0.4
        var barSpace = 0.05
        var chartData = BarChartData()
        if recivedDataArray.count > 2 {
            
            barData2 = (recivedDataArray[2] as? ChartDataSet)!
            barData2.colors = [UIColor(red: 163/255, green: 186/255, blue: 96/255, alpha: 1)]
            
            chartData = BarChartData( dataSets: [barData,barData1,barData2])
            groupSpace = 0.2
            barSpace = 0.02
        }
        else{
            chartData = BarChartData( dataSets: [barData,barData1])
        }
        chartData.groupBars(fromX: Double(-0.5), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        
        if barData.yMax == 0.0 && barData1.yMax == 0.0 && barData2.yMax == 0.0 {
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
        let imageToShare = image!.cropToBounds(image!, width: 958, height: self.headerTitle != respiratoryTractStr ? 600 : 585 ,ismove: btnAirSac.isSelected ? false : true)
        
        let activityViewController = UIActivityViewController(activityItems:[imageToShare,self.subjectString], applicationActivities: nil)
        activityViewController.setValue(self.subjectString, forKey: "subject")
        activityViewController.popoverPresentationController?.sourceView = self.btnShare
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func allObservationsPressed(_ sender: UIButton) {
        
        btnLastSession.isHidden = false
        btnHistorical.isHidden = false
        moveFrame(false)
        leftArrow.isHidden = true
        rightArrow.isHidden = true
        dateLable.isHidden = true
        self.dragDetected(isEdgeRight: true, isEdgeLeft: true)
        sender.isSelected = true
        btnAirSac.isSelected = false
        self.barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        if btnHistorical.isSelected{
            btnHistoricalPressed(sender)
        }
        else{
            btnLastSessionPressed(sender)
        }
        
        barChartView.viewPortHandler.resetBarChart(chart: barChartView)
    }
    
    
    @IBAction func btnLastSessionPressed(_ sender: AnyObject) {
        
        self.btnLastSession.isSelected = true
        self.btnHistorical.isSelected = false
        self.btnShare.isHidden = false
        self.incedenceText.isHidden = false
        let reports: ReportsCalculation = ReportsCalculation()
        
        if UserDefaults.standard.bool(forKey: "turkeyReport"){
            reports.callCommonFunction(dataSet.categoryName as NSString)
        }else{
            reports.callCommonFunctionChicken(dataSet.categoryName as NSString)
        }
        self.subjectString = NSLocalizedString("\(String(describing: self.headerTitle!)) Last Session", comment: "") as NSString
        chartNameLable.text = self.subjectString as String
        
        self.barChartView.xAxis.labelCount = verticalValues.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:verticalValues)
        
        let barData : ChartDataSet = dataSet.currentSet
        var chartData = BarChartData(dataSets: [barData])
        
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
        
        self.customLegends.isHidden = true
        
        barData.colors = colorArr.mutableCopy() as! [NSUIColor]
        // barChartView.xAxis.valueFormatter = formatter
        barChartView.data = chartData
        
        if barData.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
        if barData.yMax  >= 20 {
            self.customLegends.isHidden = false
        }
    }
    
    @IBAction func airSacPressed(_ sender: UIButton) {
        
        btnShare.isHidden = false
        btnLastSession.isHidden = true
        btnHistorical.isHidden = true
        btnAllObservations.isSelected = false
        self.customLegends.isHidden = true
        self.chartNameLable.text = self.verticalValues[2]
        dateLable.isHidden = false
        dateLable.text = UtilityClass.convertDateFormater(self.airSacChartData!.sessionDate)
        moveFrame(true)
        sender.isSelected = true
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.airSacChartData!.xAxisIndexs)
        self.barChartView.xAxis.labelCount = (self.airSacChartData?.chartData.dataSets[0].entryCount)!
        self.barChartView.data = self.airSacChartData?.chartData
        self.barChartView.setVisibleXRangeMaximum(10)
        self.rightArrow.isHidden = self.airSacChartData!.xAxisIndexs.count > 10 ? false : true
    }
    
    // MARK: - METHODS AND FUNCTIONS
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        return verticalValues[Int(value)]
    }
    
    
    func loadSingleSession()  {
        
        self.incedenceText.image = UIImage(named: "per-\(Regions.languageID)")
        
        barChartView.legend.verticalAlignment = .top
        self.headerLable.text = NSLocalizedString(self.headerTitle! as String, comment: "")
        self.subjectString = NSLocalizedString("\(String(describing: self.headerTitle!)) Last Session", comment: "") as NSString
        
        chartNameLable.text = self.subjectString as String
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.pinchZoomEnabled = false
        barChartView.rightAxis.enabled = false
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        barChartView.leftAxis.valueFormatter = numberFormatter as? IAxisValueFormatter
        let barData : ChartDataSet = (recivedDataArray[0] as? ChartDataSet)!
        barData.colors = [UIColor(red: 50/255, green: 91/255, blue: 157/255, alpha: 1)]
        let chartData = BarChartData(dataSets: [barData])
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
        self.customLegends.isHidden = true
        
        barData.colors = colorArr.mutableCopy() as! [NSUIColor]
        barChartView.data = chartData
        
        if barData.yMax == 0.0 {
            barChartView.clear()
            self.btnShare.isHidden = true
            self.incedenceText.isHidden = true
        }
        
        if barData.yMax  >= 20 {
            self.customLegends.isHidden = false
        }
        moveFrame(false)
        
    }
    
    func sortFunc(_ num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    func moveFrame(_ isMove:Bool) {
        
        var rect = barChartView.frame
        rect.origin.y = isMove ? 111 : 200
        rect.size.height = isMove ? 590 : 509
        barChartView.frame = rect
        
        rect = btnShare.frame
        rect.origin.y = isMove ? 66 : 126
        btnShare.frame = rect
        
        rect = chartNameLable.frame
        rect.origin.y = isMove ? 66 : 126
        chartNameLable.frame = rect
        
        rect = dateLable.frame
        rect.origin.y = isMove ? 69 : 0
        dateLable.frame = rect
        
    }
    
    
    
    func dragDetected(isEdgeRight:Bool, isEdgeLeft: Bool) {
        self.rightArrow.isHidden = isEdgeRight
        self.leftArrow.isHidden = isEdgeLeft
        
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

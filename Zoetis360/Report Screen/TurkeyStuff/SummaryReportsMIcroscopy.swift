//
//  SummaryReportsViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 02/02/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import Reachability
import WebKit

class SummaryReportsMIcroscopy: UIViewController,UITableViewDelegate,UITableViewDataSource,MicroscopyCalculationsDelegates,NecropcyReportCalculationsDelegates,WKUIDelegate,WKNavigationDelegate {
    @IBOutlet weak var wkwebView: WKWebView!
    @IBOutlet weak var webPreview: WKWebView!
    
    @IBOutlet weak var syncNotificationCount: UILabel!
    var recivedDataArray = NSArray()
    
    var arrayOfItemDict = [[String : AnyObject]]()
    
    var sessionDate = NSString()
    
    var invoiceInfo: [String: AnyObject]!
    
    var reportComposer: ReportComposer!
    var reportComposerDaignostic: ReportComposerDaignostic!
    var subjectString = NSString()
    var HTMLContent: String!
    
    var farmNames = NSString()
    var isSick = NSNumber()
    var totalBirds = NSString()
    var meanAge = NSString()
    var isCocciHistory = Bool()
    
    var BirdSex = NSString()
    var farmWithBirdSex = NSString()
    
    var categoryName = "Microscopy"
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblComplex: UILabel!
    @IBOutlet weak var btnComplex: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    var droperTableView  =  UITableView ()
    var customPopView1 :UserListView!
    let buttonbg1 = UIButton ()
    let buttonbg = UIButton ()
    var complexArr  = NSMutableArray()
    var lngId = NSInteger()
    let noHistoricalData = "No historical data."
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let categoryName = UserDefaults.standard.bool(forKey: "turkeyReport") ? "Microscopy" : "Coccidiosis"
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
        
    }
    // MARK: Custom Methods
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        wkwebView.uiDelegate = self
        btnComplex.layer.borderWidth = 1
        btnComplex.layer.cornerRadius = 3.5
        btnComplex.layer.borderColor = UIColor.lightGray.cgColor
        AllValidSessions.sharedInstance.meanValues.removeAllObjects()
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        complexArr = [NSLocalizedString("Microscopy Summary Report", comment: ""),NSLocalizedString("Microscopy Historical Report", comment: ""),NSLocalizedString("Necropsy Summary Report", comment: ""),NSLocalizedString("Necropsy Historical Report", comment: "")]
        wkwebView.scrollView.maximumZoomScale = 4.0
        wkwebView.scrollView.minimumZoomScale = 1.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.callCommonFunction("Microscopy")
        
        lblComplex.text = complexArr[0] as? String
        self.subjectString = (complexArr[0] as? String)! as NSString
    }
    // MARK: - Common Function
    func callCommonFunctionDaignosticSummary(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = NecropcyReportCalculations()
        
        modalObj.delegate = self
        
        arrayOfItemDict.removeAll()
        
        var lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricalData, comment: ""))
            
            return
        }
        
        var totalBirdsPerFarm : Float = 0
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        
        for j in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            self.farmNames = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            self.isSick = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "sick") as! NSNumber
            self.totalBirds = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            self.meanAge = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as! NSString
            
            if let sexValue = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "sex") as? String {
                switch sexValue {
                case "H", "HH":
                    self.BirdSex = "HH"
                case "L", "LH":
                    self.BirdSex = "LH"
                case "T":
                    self.BirdSex = "T"
                default:
                    self.BirdSex = sexValue as NSString
                }
            }
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            modalObj.setupData(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: catName)
        }
        
        
        let objectArray =  CoreDataHandlerTurkey().fetchCompletePostingSessionTurkey(arrayOfIds.first as! NSNumber)
        
        let complexName = objectArray.value(forKey: "complexName") as! String
        
        let customerName = objectArray.value(forKey: "customerName") as! String
        
        let vetanatrionName = objectArray.value(forKey: "vetanatrionName") as! String
        
        var salesRepName: String = ""
        
        if let salesRepNameDummy = (objectArray as AnyObject).value(forKey: "salesRepName"){
            salesRepName = (objectArray.value(forKey: "salesRepName") as! NSString) as String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "NA" : salesRepNameDummy as! String
        }
        
        let customerRepName = objectArray.value(forKey: "customerRepName") as! String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "" : objectArray.value(forKey: "customerRepName") as! String
        
        let sessiondate = objectArray.value(forKey: "sessiondate") as! String        
        let sessionTypeName = objectArray.value(forKey: "sessionTypeName") as! String

        let typeDate = NSString(format: "%@-%@",UtilityClass.convertDateFormater(sessiondate),sessionTypeName)
        
        reportComposerDaignostic = ReportComposerDaignostic()
        
        if let invoiceHTML = reportComposerDaignostic.renderReports(complexName: complexName, customerName: customerName, vetanatrionName: vetanatrionName, salesRepName: salesRepName, customerRepName: customerRepName, typeDate: typeDate as String,items : arrayOfItemDict) {
            
            wkwebView.loadHTMLString(invoiceHTML, baseURL: Bundle.main.bundleURL)
            HTMLContent = invoiceHTML
        }
    }
    
    func callCommonFunction(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = MIcroscopyCalculations()
        
        modalObj.delegate = self
        
        arrayOfItemDict.removeAll()
        
        var lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricalData, comment: ""))
            
            return
        }
        var totalBirdsPerFarm : Float = 0
        let sortDescriptor = [NSSortDescriptor(key: "age" ,ascending: true , selector: #selector(NSString.localizedStandardCompare(_:)))]
        lastSessionDataArray = lastSessionDataArray.sortedArray(using: sortDescriptor) as NSArray
        
        for j in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            self.farmNames = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            self.isSick = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "sick") as! NSNumber
            
            self.totalBirds = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            self.meanAge = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as! NSString
            
            if let sexValue = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "sex") as? String {
                switch sexValue {
                case "H", "HH":
                    self.BirdSex = "HH"
                case "L", "LH":
                    self.BirdSex = "LH"
                case "T":
                    self.BirdSex = "T"
                default:
                    self.BirdSex = sexValue as NSString  // fallback to whatever it was
                }
            }
            
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            modalObj.setupData(lastFarmDataArray,birdsCount: numberOfBirds.floatValue , catName: catName)
        }
        
        
        let objectArray =  CoreDataHandlerTurkey().fetchCompletePostingSessionTurkey(arrayOfIds.first as! NSNumber)
        
        let complexName = objectArray.value(forKey: "complexName") as! String
        
        let customerName = objectArray.value(forKey: "customerName") as! String
        
        let vetanatrionName = objectArray.value(forKey: "vetanatrionName") as! String
        
        var salesRepName: String = ""
        
        if let salesRepNameDummy = (objectArray as AnyObject).value(forKey: "salesRepName"){
            salesRepName = (objectArray.value(forKey: "salesRepName") as! NSString) as String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "NA" : salesRepNameDummy as! String
        }
        
        let customerRepName = objectArray.value(forKey: "customerRepName") as! String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "" : objectArray.value(forKey: "customerRepName") as! String
                
        let sessiondate = objectArray.value(forKey: "sessiondate") as! String
        
        let sessionTypeName = objectArray.value(forKey: "sessionTypeName") as! String

        
        let typeDate = NSString(format: "%@-%@",UtilityClass.convertDateFormater(sessiondate),sessionTypeName)
        
        reportComposer = ReportComposer()
        
        if let invoiceHTML = reportComposer.renderReports(complexName, customerName: customerName, vetanatrionName: vetanatrionName, salesRepName: salesRepName, customerRepName: customerRepName, typeDate: typeDate as String,items : arrayOfItemDict) {
            
            wkwebView.loadHTMLString(invoiceHTML, baseURL: Bundle.main.bundleURL)
            HTMLContent = invoiceHTML
        }
    }
    
    
    fileprivate func forLoopToThree(_ arrayOfIds: inout [Int], _ modalObj: NecropcyReportCalculations, _ catName: NSString) {
        for i in 0..<3 {
            
            
            let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricalData, comment: ""))
                return
            }
            
            let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
            
            sessionDate = (objectArray.firstObject as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            var age = Int()
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                age = (((lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as AnyObject).intValue)! + age
                
                self.meanAge = NSString(format: "%d",age)
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            self.meanAge = NSString(format: "%.0f",round(Float(age)/Float(lastSessionDataArray.count)))
            self.totalBirds = NSString(format: "%.0f",totalBirdsPerFarm)
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            
        }
    }
    
    fileprivate func handleForLoopTo1(_ arrayOfIds: inout [Int], _ modalObj: NecropcyReportCalculations, _ catName: NSString) {
        for i in 0..<2{
            
            let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricalData, comment: ""))
                
                return
            }
            
            let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
            
            sessionDate = (objectArray.lastObject as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            
            var age = Int()
            
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                age = (((lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as AnyObject).intValue)! + age
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId : necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            self.totalBirds = NSString(format: "%.0f",totalBirdsPerFarm)
            self.meanAge = NSString(format: "%.0f",round(Float(age)/Float(lastSessionDataArray.count)))
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
        }
    }
    
    fileprivate func handleElseConditionArrayOfId(_ lastSessionDataArray: NSArray, _ arrayOfIds: [Int], _ modalObj: NecropcyReportCalculations, _ catName: NSString) {
        if lastSessionDataArray.count == 0 {
            
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(noHistoricalData, comment: ""))
            
            return
        }
        
        let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDate = (objectArray.lastObject as AnyObject).value(forKey: "sessiondate") as! NSString
        
        let allFarmDataArray = NSMutableArray()
        
        var totalBirdsPerFarm : Float = 0
        
        var age = Int()
        
        for j in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            age = (((lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "age") as AnyObject).intValue)! + age
            
            totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
        self.meanAge = NSString(format: "%.0f",round(Float(age)/Float(lastSessionDataArray.count)))
        self.totalBirds = NSString(format: "%.0f",totalBirdsPerFarm)
        modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
    }
    
    func callCommonFunctionHistorical(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = NecropcyReportCalculations()
        
        modalObj.delegate = self
        
        arrayOfItemDict.removeAll()
        
        if arrayOfIds.count > 2 {
            
            forLoopToThree(&arrayOfIds, modalObj, catName)
        } else if arrayOfIds.count > 1 {
            
            handleForLoopTo1(&arrayOfIds, modalObj, catName)
        } else {
            
            let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
            
            handleElseConditionArrayOfId(lastSessionDataArray, arrayOfIds, modalObj, catName)
        }
        
        
        let objectArray = CoreDataHandlerTurkey().fetchCompletePostingSessionTurkey(arrayOfIds.first as! NSNumber)
        
        let complexName = objectArray.value(forKey: "complexName") as! String
        
        let customerName = objectArray.value(forKey: "customerName") as! String
        
        let vetanatrionName = objectArray.value(forKey: "vetanatrionName") as! String
        
        var salesRepName: String = ""
        
        if let salesRepNameDummy = (objectArray as AnyObject).value(forKey: "salesRepName"){
            salesRepName = (objectArray.value(forKey: "salesRepName") as! NSString) as String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "NA" : salesRepNameDummy as! String
        }
        
        let customerRepName = objectArray.value(forKey: "customerRepName") as! String == NSLocalizedString(appDelegateObj.selectStr, comment: "") ? "" : objectArray.value(forKey: "customerRepName") as! String
        
        let sessiondate = objectArray.value(forKey: "sessiondate") as! String
        
        let sessionTypeName = objectArray.value(forKey: "sessionTypeName") as! String
        
        let typeDate = NSString(format: "%@-%@",UtilityClass.convertDateFormater(sessiondate),sessionTypeName)
        
        reportComposer = ReportComposer()
        
        reportComposerDaignostic = ReportComposerDaignostic()
        
        if self.subjectString as String == NSLocalizedString("Necropsy Historical Report", comment: "") {
            if let invoiceHTML = reportComposerDaignostic.renderReports(complexName: complexName, customerName: customerName, vetanatrionName: vetanatrionName, salesRepName: salesRepName, customerRepName: customerRepName, typeDate: typeDate as String,items : arrayOfItemDict) {
                
                wkwebView.loadHTMLString(invoiceHTML, baseURL: Bundle.main.bundleURL)
                HTMLContent = invoiceHTML
            }
        } else {
            if let invoiceHTML = reportComposer.renderReports(complexName, customerName: customerName, vetanatrionName: vetanatrionName, salesRepName: salesRepName, customerRepName: customerRepName, typeDate: typeDate as String,items : arrayOfItemDict) {
                
                wkwebView.loadHTMLString(invoiceHTML, baseURL: Bundle.main.bundleURL)
                HTMLContent = invoiceHTML
            }
        }
    }
    @IBAction func exportToPDF(_ sender: AnyObject) {
        
        
        reportComposer.exportHTMLContentToPDF(HTMLContent)
        
        let template = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(self.subjectString as String).pdf")
        let pdfData: Data = (try? Data.init(contentsOf: URL(fileURLWithPath: reportComposer.pdfFilename)))!
        try? pdfData.write(to: template!, options: [.atomic])
        
        let activityViewController = UIActivityViewController(activityItems:[template as Any,self.subjectString], applicationActivities: nil)
        activityViewController.setValue(self.subjectString, forKey: "subject")
        activityViewController.popoverPresentationController?.sourceView = self.btnShare
        self.navigationController?.present(activityViewController, animated: true, completion: {
            appDelegateObj.testFuntion()
        })
    }
    func didFinishWithParsing(finishedArray : NSArray){
        
        let frNme1 = self.farmNames as String
        
        let range = frNme1.range(of: ".")
        if range != nil{
            self.farmNames = String(frNme1[range!.upperBound...]) as NSString
        }
        
        // Prince Report Changes
        
        farmWithBirdSex = (self.farmNames as String) + " (" + (self.BirdSex as String) + ")" as NSString
        
        let dict = ["acer" : finishedArray[0],"mg" : finishedArray[1],"mm" : finishedArray[2],"tg" : finishedArray[3],"meanAge" : self.meanAge,"isSick" : self.isSick,"birds" : self.totalBirds,"farmName" : farmWithBirdSex , "sessionDate" : UtilityClass.convertDateFormater(sessionDate as String) , "isCocciHistory" : isCocciHistory]
        
        //  let dict = ["acer" : finishedArray[0],"mg" : finishedArray[1],"mm" : finishedArray[2],"tg" : finishedArray[3],"meanAge" : self.meanAge,"isSick" : self.isSick,"birds" : self.totalBirds,"farmName" : self.farmNames , "sessionDate" : UtilityClass.convertDateFormater(sessionDate as String) , "isCocciHistory" : isCocciHistory]
        
        arrayOfItemDict.append(dict as [String : AnyObject])
        
    }
    func didFinishParsingWithAllSummaryData(_ finishedArray : NSArray){
        
        let frNme1 = self.farmNames as String
        
        let range = frNme1.range(of: ".")
        if range != nil{
            self.farmNames = String(frNme1[range!.upperBound...]) as NSString
        }
        
        farmWithBirdSex = (self.farmNames as String) + " (" + (self.BirdSex as String) + ")" as NSString
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 1 {
            
            let dict = ["FP" : finishedArray[0],"amonia" : finishedArray[1],"mouth" : finishedArray[2],"trac" : finishedArray[3],"FHN" : finishedArray[4],"TD" : finishedArray[5],"Rick" : finishedArray[6],"Bone" : finishedArray[7],"Syno" : finishedArray[8],"Bursa" : finishedArray[9],"IP" : finishedArray[10],"air" : finishedArray[11],"retained" : finishedArray[12],"litter" : finishedArray[13],"ge" : finishedArray[14],"pro" : finishedArray[15],"tape" : finishedArray[16],"round" : finishedArray[17],"feed" : finishedArray[18],"enterties" : finishedArray[19],"Intestinal" : finishedArray[20],"Thin_Intestine" : finishedArray[21],"Muscular" : finishedArray[22],"BLS" : finishedArray[23],"feed_P" : finishedArray[24] ,"pericarditis" : finishedArray[25] , "septicemia" : finishedArray[26], "Liver_Granuloma" : finishedArray[26] ,"Active_Bursa" : finishedArray[28] ,"cellulitis" : finishedArray[29],"meanAge" : self.meanAge,"isSick" : self.isSick,"birds" : self.totalBirds,"farmName" : self.farmWithBirdSex , "sessionDate" : UtilityClass.convertDateFormater(sessionDate as String) , "isCocciHistory" : isCocciHistory]
            
            
            arrayOfItemDict.append(dict as [String : AnyObject])
        }
        else{
            let dict = ["FP" : finishedArray[0],"amonia" : finishedArray[1],"mouth" : finishedArray[2],"trac" : finishedArray[3],"FHN" : finishedArray[4],"TD" : finishedArray[5],"Rick" : finishedArray[6],"Bone" : finishedArray[7],"Syno" : finishedArray[8],"Bursa" : finishedArray[9],"IP" : finishedArray[10],"air" : finishedArray[11],"retained" : finishedArray[12],"litter" : finishedArray[13],"ge" : finishedArray[14],"pro" : finishedArray[15],"tape" : finishedArray[16],"round" : finishedArray[17],"feed" : finishedArray[18],"enterties" : finishedArray[19],"Intestinal" : finishedArray[20],"Thin_Intestine" : finishedArray[21],"Muscular" : finishedArray[22],"BLS" : finishedArray[23],"feed_P" : finishedArray[24] ,"cellulitis" : finishedArray[29],"meanAge" : self.meanAge,"isSick" : self.isSick,"birds" : self.totalBirds,"farmName" : self.farmWithBirdSex , "sessionDate" : UtilityClass.convertDateFormater(sessionDate as String) , "isCocciHistory" : isCocciHistory]
            
            
            arrayOfItemDict.append(dict as [String : AnyObject])
        }
    }
    @IBAction func didSelectOnComplex(_ sender: AnyObject) {
        
        view.endEditing(true)
        
        tableViewpop()
        
        if complexArr.count < 4 {
            
            droperTableView.frame = CGRect( x: btnComplex.frame.origin.x, y: btnComplex.frame.origin.y+40, width: 375, height: 130)
        }
        else{
            droperTableView.frame = CGRect( x: btnComplex.frame.origin.x, y: btnComplex.frame.origin.y+40, width: 375, height: 190)
            
        }
        droperTableView.reloadData()
    }
    func tableViewpop()  {
        
        buttonbg.frame = CGRect(x: 0, y: 0, width: 1024, height: 768) // X, Y, width, height
        buttonbg.addTarget(self, action: #selector(self.buttonPressed1), for: .touchUpInside)
        buttonbg.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(buttonbg)
        
        droperTableView.delegate = self
        droperTableView.dataSource = self
        
        droperTableView.layer.cornerRadius = 8.0
        droperTableView.layer.borderWidth = 1.0
        droperTableView.layer.borderColor =  UIColor.lightGray.cgColor
        
        buttonbg.addSubview(droperTableView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        switch indexPath.row {
        case 0:
            isCocciHistory = false
            callCommonFunction(categoryName as NSString)
            self.subjectString = (complexArr[0] as? String)! as NSString
            break
        case 1:
            isCocciHistory = true
            self.subjectString = (complexArr[1] as? String)! as NSString
            AllValidSessions.sharedInstance.meanValues.removeAllObjects()
            callCommonFunctionHistorical(categoryName as NSString)
            break
        case 2:
            isCocciHistory = false
            self.subjectString = (complexArr[2] as? String)! as NSString
            AllValidSessions.sharedInstance.meanValues.removeAllObjects()
            callCommonFunctionDaignosticSummary("AllSummary")
            break
        case 3:
            isCocciHistory = true
            self.subjectString = (complexArr[3] as? String)! as NSString
            AllValidSessions.sharedInstance.meanValues.removeAllObjects()
            callCommonFunctionHistorical("AllSummary")
            break
        default:
            break
        }
        AllValidSessions.sharedInstance.isHistory = isCocciHistory
        buttonPressed1()
    }
    @objc func buttonPressed1() {
        
        buttonbg.removeFromSuperview()
    }
    @IBAction func backAction(_ sender: AnyObject) {
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

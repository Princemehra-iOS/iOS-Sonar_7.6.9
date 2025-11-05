//
//  ReportsCalculation.swift
//  Zoetis -Feathers
//
//  Created by   on 15/02/18.
//  Copyright © 2018   . All rights reserved.
//

import Foundation
import Charts

struct dataSet {
    static var currentSet: BarChartDataSet = BarChartDataSet()
    static var axisLables: Array<String> = Array<String>()
    static var categoryName: String = String()
}

class ReportsCalculation: NSObject,GI_TtactDelegate {
    
    var sessionDate = NSString()
    
    func didFinishWithParsing(finishedArray: NSArray) {
        let axisLables = nameCrop(inputSting: dataSet.axisLables)
        let chartDataSet : BarChartDataSet = setChartData(dataPoints: axisLables, values: finishedArray as! [Float])!
        dataSet.currentSet = chartDataSet
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
    // MARK: - Common Function
    
    func callCommonFunctionChicken(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
      //  arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let lastSessionDataArray : NSArray = CoreDataHandler().fetchLastSessionDetails(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            return
        }
        
        let objectArray =  CoreDataHandler().fetchAllPostingSession(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDateSingle = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        
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
    
    func callCommonFunction(_ catName : NSString)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
        //arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = self
        
        let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
        
        if lastSessionDataArray.count == 0 {
            return
        }
        
        let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray
        
        sessionDateSingle = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
        
        let allFarmDataArray = NSMutableArray()
        
        var totalBirdsPerFarm : Float = 0
        
        for j in 0..<lastSessionDataArray.count {
            
            let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
            
            let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
            
            let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
            
            totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
            
            let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
            
            allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
        }
        modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
    }
    class func commonCalculationFunction(_ catName : NSString, viewCnt: UIViewController)  {
        
        var arrayOfIds:[Int] = AllValidSessions.sharedInstance.allValidSession as! [Int]
        
       // arrayOfIds = arrayOfIds.sorted(by: {$0 > $1})
        
        let modalObj = GI_Tract_Modal()
        
        modalObj.delegate = viewCnt as? GI_TtactDelegate
        
        if arrayOfIds.count > 2 {
            
              for i in 0..<3{
                
                let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(viewCnt,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    return
                }
                
                let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDateSingle = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
                let allFarmDataArray = NSMutableArray()
                
                var totalBirdsPerFarm : Float = 0
                
                for j in 0..<lastSessionDataArray.count {
                    
                    let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                    
                    let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                    
                    let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                    
                    totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                    
                    let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName, postingId: necID)
                    
                    allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
                }
                modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
            }
        }
            
        else if arrayOfIds.count > 1 {
            
             for i in 0..<2{
                
                let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds[i] as! NSNumber)
                
                if lastSessionDataArray.count == 0 {
                    
                    Helper.showAlertMessage(viewCnt,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                    return
                }
                
                let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds[i] as! NSNumber).mutableCopy() as! NSMutableArray
                
                sessionDateSingle = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
                
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
        else{
            
            let lastSessionDataArray : NSArray = CoreDataHandlerTurkey().fetchLastSessionDetailsTurkey(arrayOfIds.first as! NSNumber)
            
            if lastSessionDataArray.count == 0 {
                
                Helper.showAlertMessage(viewCnt,titleStr:NSLocalizedString("Alert", comment: "") , messageStr:NSLocalizedString("No historical data.", comment: ""))
                return
            }
            
            let objectArray =  CoreDataHandlerTurkey().fetchAllPostingSessionTurkey(arrayOfIds.first as! NSNumber).mutableCopy() as! NSMutableArray

             sessionDateSingle = (objectArray.object(at: 0) as AnyObject).value(forKey: "sessiondate") as! NSString
            
            let allFarmDataArray = NSMutableArray()
            
            var totalBirdsPerFarm : Float = 0
            
            for j in 0..<lastSessionDataArray.count {
                
                let farmName : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "farmName") as! NSString
                
                let numberOfBirds : NSString = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "noOfBirds") as! NSString
                
                let necID = (lastSessionDataArray.object(at: j) as AnyObject).value(forKey: "necropsyId") as! NSNumber
                
                totalBirdsPerFarm = totalBirdsPerFarm+numberOfBirds.floatValue
                
                let lastFarmDataArray : NSArray = CoreDataHandlerTurkey().fetch_GI_Tract_AllDataTurkey(farmName,postingId: necID) as NSArray
                
                allFarmDataArray.addObjects(from: lastFarmDataArray as [AnyObject])
            }
            modalObj.setupData(allFarmDataArray,birdsCount: totalBirdsPerFarm , catName: catName)
        }
    }
}


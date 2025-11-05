//
//  MIcroscopyCalculations.swift
//  Zoetis -Feathers
//
//  Created by Pradeep Dahiya on 12/06/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

@objc protocol MicroscopyCalculationsDelegates {
    func didFinishWithParsing(finishedArray : NSArray)
    @objc optional func didFinishWithParsingWithFarmData(_ finishedArray : NSArray)
}

class MIcroscopyCalculations: NSObject {
    
    var delegate: MicroscopyCalculationsDelegates?
    
    func setupData(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        if catName == "Microscopy"{
            self.forMicroscopySummuary(aArray, birdsCount: birdsCount)
        }
    }
    
    func forMicroscopySummuary(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        let preparedArrayForMean = NSMutableArray()
        
        var coccidia : Float = 0
        var bacteriaMotile : Float = 0
        var bacteriaNonMotile : Float = 0
        var pepto : Float = 0
        
        var coccidia_Mean : Float = 0
        var bacteriaMotile_Mean : Float = 0
        var bacteriaNonMotile_Mean : Float = 0
        var pepto_Mean : Float = 0
        
        var isUpdatedCoccidia : Float = 0
        var isUpdatedBacteriaMotile : Float = 0
        var isUpdatedbacteriaNonMotile : Float = 0
        var isUpdatedPepto : Float = 0
        
        var observationSet : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 607 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    coccidia_Mean=coccidia_Mean+value.floatValue
                    coccidia=coccidia+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedCoccidia += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 612 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    bacteriaMotile_Mean=bacteriaMotile_Mean+value.floatValue
                    bacteriaMotile=bacteriaMotile+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedBacteriaMotile += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 613 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    bacteriaNonMotile_Mean=bacteriaNonMotile_Mean+value.floatValue
                    bacteriaNonMotile=bacteriaNonMotile+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedbacteriaNonMotile += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 611 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    pepto_Mean=pepto_Mean+value.floatValue
                    pepto=pepto+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedPepto += 1
                    }
                }
            }
        }
        
        coccidia = (coccidia/birdsCount)*100
        preparedArray.add(coccidia)
        
        bacteriaMotile = (bacteriaMotile/birdsCount)*100
        preparedArray.add(bacteriaMotile)
        
        bacteriaNonMotile = (bacteriaNonMotile/birdsCount)*100
        preparedArray.add(bacteriaNonMotile)
        
        pepto = (pepto/birdsCount)*100
        preparedArray.add(pepto)
        
        preparedArrayForMean.add((coccidia_Mean/isUpdatedCoccidia).isNaN ? 0 : coccidia_Mean/isUpdatedCoccidia)
        preparedArrayForMean.add((bacteriaMotile_Mean/isUpdatedBacteriaMotile).isNaN ? 0 : bacteriaMotile_Mean/isUpdatedBacteriaMotile)
        preparedArrayForMean.add((bacteriaNonMotile_Mean/isUpdatedbacteriaNonMotile).isNaN ? 0 : bacteriaNonMotile_Mean/isUpdatedbacteriaNonMotile)
        preparedArrayForMean.add((pepto_Mean/isUpdatedPepto).isNaN ? 0 : pepto_Mean/isUpdatedPepto)
        
        AllValidSessions.sharedInstance.meanValues.add(preparedArrayForMean)
        
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    
    func setupCocciDataByFarm(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        let preparedArray = NSMutableArray()
        let tempArray = NSMutableArray()
        let preparedArrayForMean1 = NSMutableArray()
        let preparedArrayForMean2 = NSMutableArray()
        let preparedArrayForMean3 = NSMutableArray()
        let preparedArrayForMean4 = NSMutableArray()
        
        var coccidia : Float = 0
        var bacteriaMotile : Float = 0
        var bacteriaNonMotile : Float = 0
        var pepto : Float = 0
        
        var coccidia_Mean : Float = 0
        var bacteriaMotile_Mean : Float = 0
        var bacteriaNonMotile_Mean : Float = 0
        var pepto_Mean : Float = 0
        
        var isUpdatedAC : Float = 0
        var isUpdatedMG : Float = 0
        var isUpdatedMM : Float = 0
        var isUpdatedTG : Float = 0
        
        var observationSet : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 607 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    coccidia_Mean=coccidia_Mean+value.floatValue
                    coccidia=coccidia+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedAC += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 612 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    bacteriaMotile_Mean=bacteriaMotile_Mean+value.floatValue
                    bacteriaMotile=bacteriaMotile+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMG += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 613 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    bacteriaNonMotile_Mean=bacteriaNonMotile_Mean+value.floatValue
                    bacteriaNonMotile=bacteriaNonMotile+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMM += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 611 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    pepto_Mean=pepto_Mean+value.floatValue
                    pepto=pepto+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedTG += 1
                    }
                }
            }
        }
        
        preparedArray.add(coccidia)
        preparedArray.add(bacteriaMotile)
        preparedArray.add(bacteriaNonMotile)
        preparedArray.add(pepto)
        
        preparedArrayForMean1.add((coccidia_Mean/isUpdatedAC).isNaN ? 0 : coccidia_Mean/isUpdatedAC)
        tempArray.add(preparedArrayForMean1)
        
        preparedArrayForMean2.add((bacteriaMotile_Mean/isUpdatedMG).isNaN ? 0 : bacteriaMotile_Mean/isUpdatedMG)
        tempArray.add(preparedArrayForMean2)
        
        preparedArrayForMean3.add((bacteriaNonMotile_Mean/isUpdatedMM).isNaN ? 0 : bacteriaNonMotile_Mean/isUpdatedMM)
        tempArray.add(preparedArrayForMean3)
        
        preparedArrayForMean4.add((pepto_Mean/isUpdatedTG).isNaN ? 0 : pepto_Mean/isUpdatedTG)
        tempArray.add(preparedArrayForMean4)
        
        AllValidSessions.sharedInstance.meanValues.add(tempArray)
        
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
        delegate?.didFinishWithParsingWithFarmData!(preparedArray)
    }
}


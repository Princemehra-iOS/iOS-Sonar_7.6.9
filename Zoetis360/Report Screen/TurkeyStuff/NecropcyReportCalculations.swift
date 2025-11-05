//
//  NecropcyReportCalculations.swift
//  Zoetis -Feathers
//
//  Created by Pradeep Dahiya on 19/06/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit

@objc protocol NecropcyReportCalculationsDelegates {
    func didFinishWithParsing(finishedArray : NSArray)
    @objc optional func didFinishParsingWithAllSummaryData(_ finishedArray : NSArray)
}

class NecropcyReportCalculations: NSObject {
    
    var delegate: NecropcyReportCalculationsDelegates?
    
    let NOT_EXIST: Float = -1
    
    func setupData(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        if catName == "Microscopy" {
            self.forMicroscopySummuary(aArray, birdsCount: birdsCount)
        } else{
            self.allSummaryPDF(aArray, birdsCount: birdsCount)}
    }
    
    fileprivate func handleObservation607(_ aArray: NSArray, _ j: Int, _ observationSet: inout Float, _ coccidia_Mean: inout Float, _ coccidia: inout Float, _ isUpdatedCoccidia: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 607 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            observationSet += 1
            coccidia_Mean=coccidia_Mean+value.floatValue
            coccidia=coccidia+(value.floatValue > 0 ? 1 : 0)
            if value.floatValue > 0 {
                isUpdatedCoccidia += 1
            }
        }
    }
    
    fileprivate func handleObservation612(_ aArray: NSArray, _ j: Int, _ observationSet: inout Float, _ bacteriaMotile_Mean: inout Float, _ bacteriaMotile: inout Float, _ isUpdatedBacteriaMotile: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 612 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            observationSet += 1
            bacteriaMotile_Mean=bacteriaMotile_Mean+value.floatValue
            bacteriaMotile=bacteriaMotile+(value.floatValue > 0 ? 1 : 0)
            if value.floatValue > 0 {
                isUpdatedBacteriaMotile += 1
            }
        }
    }
    
    fileprivate func handleObservation613(_ aArray: NSArray, _ j: Int, _ observationSet: inout Float, _ bacteriaNonMotile_Mean: inout Float, _ bacteriaNonMotile: inout Float, _ isUpdatedbacteriaNonMotile: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 613 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            observationSet += 1
            bacteriaNonMotile_Mean=bacteriaNonMotile_Mean+value.floatValue
            bacteriaNonMotile=bacteriaNonMotile+(value.floatValue > 0 ? 1 : 0)
            if value.floatValue > 0 {
                isUpdatedbacteriaNonMotile += 1
            }
        }
    }
    
    fileprivate func handleObservation611(_ aArray: NSArray, _ j: Int, _ observationSet: inout Float, _ pepto_Mean: inout Float, _ pepto: inout Float, _ isUpdatedPepto: inout Float) {
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
        
        for  j in 0..<aArray.count {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                handleObservation607(aArray, j, &observationSet, &coccidia_Mean, &coccidia, &isUpdatedCoccidia)
                handleObservation612(aArray, j, &observationSet, &bacteriaMotile_Mean, &bacteriaMotile, &isUpdatedBacteriaMotile)
                handleObservation613(aArray, j, &observationSet, &bacteriaNonMotile_Mean, &bacteriaNonMotile, &isUpdatedbacteriaNonMotile)
                handleObservation611(aArray, j, &observationSet, &pepto_Mean, &pepto, &isUpdatedPepto)
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
    
    fileprivate func stageNewObservation(_ aArray: NSArray, _ j: Int, _ Pericarditis: inout Float, _ Liver_Granuloma: inout Float, _ Septicemia: inout Float, _ Active_Bursa: inout Float, _ Cellulitis: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1952 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Pericarditis=Pericarditis+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1957 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1956 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1955 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Active_Bursa=Active_Bursa+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1960 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Cellulitis=Cellulitis+(value.floatValue > 0 ? 1 : 0)
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1958 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func devNewObservation(_ aArray: NSArray, _ j: Int, _ Pericarditis: inout Float, _ Liver_Granuloma: inout Float, _ Septicemia: inout Float, _ Active_Bursa: inout Float, _ Cellulitis: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1870 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Pericarditis=Pericarditis+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1876 { // 1876
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1874 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1873 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Active_Bursa=Active_Bursa+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1878 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Cellulitis=Cellulitis+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func productionNewObservation(_ aArray: NSArray, _ j: Int, _ Pericarditis: inout Float, _ Liver_Granuloma: inout Float, _ Septicemia: inout Float, _ Active_Bursa: inout Float , _ Cellulitis: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2030 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Pericarditis=Pericarditis+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2035 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2034 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
        }
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2033 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Active_Bursa=Active_Bursa+(value.floatValue > 0 ? 1 : 0)
        }
        
        
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2037 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Cellulitis=Cellulitis+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidations1(_ aArray: NSArray, _ j: Int, _ Foot_Pad_Lesions: inout Float, _ Foot_Pad_Lesions_Mean: inout Float, _ Foot_Pad_Lesions_Updated: inout Float, _ Ammonia_Burns: inout Float, _ mouth_Lesions: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 596 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            Foot_Pad_Lesions=Foot_Pad_Lesions+(value.floatValue > 0 ? 1 : 0)
            Foot_Pad_Lesions_Mean = Foot_Pad_Lesions_Mean + value.floatValue
            if value.floatValue > 0 {
                Foot_Pad_Lesions_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 635 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Ammonia_Burns=Ammonia_Burns+(value.floatValue > 0 ? 1 : 0)
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 617 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            mouth_Lesions=mouth_Lesions+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidations2(_ aArray: NSArray, _ j: Int, _ tracheitis: inout Float, _ Tracheitis_Mean: inout Float, _ Tracheitis_Updated: inout Float, _ Femoral_Head_Necrosis: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 636 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            tracheitis=tracheitis+(value.floatValue > 0 ? 1 : 0)
            Tracheitis_Mean = Tracheitis_Mean + value.floatValue
            if value.floatValue > 0 {
                Tracheitis_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 597 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Femoral_Head_Necrosis=Femoral_Head_Necrosis+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons3(_ aArray: NSArray, _ j: Int, _ Tibial_Dyschondroplasia: inout Float, _ Tibial_Dyschondroplasia_Mean: inout Float, _ Tibial_Dyschondroplasia_Updated: inout Float, _ Rickets: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 599 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            Tibial_Dyschondroplasia=Tibial_Dyschondroplasia+(value.floatValue > 0 ? 1 : 0)
            Tibial_Dyschondroplasia_Mean = Tibial_Dyschondroplasia_Mean + value.floatValue
            if value.floatValue > 0 {
                Tibial_Dyschondroplasia_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 600 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Rickets=Rickets+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons4(_ aArray: NSArray, _ j: Int, _ Bone_Strength: inout Float, _ Bone_Strength_Mean: inout Float, _ Bone_Strength_Updated: inout Float, _ Synovitis: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 601 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            Bone_Strength=Bone_Strength+(value.floatValue > 0 ? 1 : 0)
            Bone_Strength_Mean = Bone_Strength_Mean + value.floatValue
            if value.floatValue > 0 {
                Bone_Strength_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 602 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Synovitis=Synovitis+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons5(_ aArray: NSArray, _ j: Int, _ Bursa_Size: inout Float, _ IP: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 641 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            Bursa_Size=Bursa_Size+(value.floatValue > 0 ? 1 : 0)
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 603 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            IP=IP+value.floatValue
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons6(_ aArray: NSArray, _ j: Int, _ air_Sac: inout Float, _ air_Sac_Mean: inout Float, _ air_Sac_Updated: inout Float, _ retained_Yolk: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 637 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            air_Sac=air_Sac+(value.floatValue > 0 ? 1 : 0)
            air_Sac_Mean = air_Sac_Mean + value.floatValue
            if value.floatValue > 0 {
                air_Sac_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 643 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            retained_Yolk=retained_Yolk+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons7(_ aArray: NSArray, _ j: Int, _ wallThikness: inout Float, _ gizzard_Erosions: inout Float, _ gizzard_Erosions_Mean: inout Float, _ gizzard_Erosions_Updated: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 675 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            wallThikness=wallThikness+(value.floatValue > 0 ? 1 : 0)
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 619 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            gizzard_Erosions=gizzard_Erosions+(value.floatValue > 0 ? 1 : 0)
            gizzard_Erosions_Mean = gizzard_Erosions_Mean + value.floatValue
            if value.floatValue > 0 {
                gizzard_Erosions_Updated += 1
            }
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons8(_ aArray: NSArray, _ j: Int, _ enterties: inout Float, _ enterties_Mean: inout Float, _ enterties_Updated: inout Float, _ litter_Eater: inout Float, _ feed_Passage: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 622 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            enterties=enterties+(value.floatValue > 0 ? 1 : 0)
            enterties_Mean = enterties_Mean + value.floatValue
            if value.floatValue > 0 {
                enterties_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 621 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            litter_Eater=litter_Eater+(value.floatValue > 0 ? 1 : 0)
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 624 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            feed_Passage=feed_Passage+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons9(_ aArray: NSArray, _ j: Int, _ proventriculitis: inout Float, _ proventriculitis_Mean: inout Float, _ proventriculitis_Updated: inout Float, _ roundworms: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 633 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
            proventriculitis=proventriculitis+(value.floatValue > 0 ? 1 : 0)
            proventriculitis_Mean = proventriculitis_Mean + value.floatValue
            if value.floatValue > 0 {
                proventriculitis_Updated += 1
            }
        }
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 632 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            roundworms=roundworms+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    fileprivate func handleAllSummaryPDFForLoopValidaitons10(_ aArray: NSArray, _ j: Int, _ tapeworms: inout Float) {
        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 623 {
            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
            tapeworms=tapeworms+(value.floatValue > 0 ? 1 : 0)
        }
    }
    
    func allSummaryPDF(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        let preparedArrayForMean = NSMutableArray()
        
        var feed_Passage : Float = 0
        
        var Foot_Pad_Lesions : Float = 0
        var Ammonia_Burns : Float = 0
        var tracheitis : Float = 0
        var Femoral_Head_Necrosis : Float = 0
        var wallThikness : Float = 0
        var gizzard_Erosions : Float = 0
        var enterties : Float = 0
        var litter_Eater : Float = 0
        var mouth_Lesions : Float = 0
        var proventriculitis : Float = 0
        var roundworms : Float = 0
        var tapeworms : Float = 0
        var Tibial_Dyschondroplasia : Float = 0
        var Rickets : Float = 0
        var Bone_Strength : Float = 0
        var Bursa_Size : Float = 0.0
        var IP : Float = 0.0
        var Synovitis : Float = 0
        var retained_Yolk : Float = 0
        var air_Sac : Float = 0
        var Intestinal_Content: Float = 0
        var Thin_Intestine: Float = 0
        var Muscular_Hemorrhages: Float = 0
        var Bursa_Lesion_Score: Float = 0
      
        var Pericarditis: Float = 0
        var Liver_Granuloma: Float = 0
        var Septicemia: Float = 0
        var Active_Bursa: Float = 0
        var Cellulitis: Float = 0
        
        var air_Sac_Mean : Float = 0
        var Foot_Pad_Lesions_Mean : Float = 0
        var Tracheitis_Mean : Float = 0
        var Tibial_Dyschondroplasia_Mean : Float = 0
        var gizzard_Erosions_Mean : Float = 0
        var proventriculitis_Mean : Float = 0
        var enterties_Mean : Float = 0
        var Bone_Strength_Mean : Float = 0
        var Bursa_Lesion_Score_Mean: Float = 0
        

        
        var air_Sac_Updated : Float = 0
        var Foot_Pad_Lesions_Updated : Float = 0
        var Tracheitis_Updated : Float = 0
        var Tibial_Dyschondroplasia_Updated : Float = 0
        var gizzard_Erosions_Updated : Float = 0
        var proventriculitis_Updated : Float = 0
        var enterties_Updated : Float = 0
        var Bone_Strength_Updated : Float = 0
        var Bursa_Lesion_Score_Updated: Float = 0
        let environmentIs = Constants.Api.versionUrl
        
        for j in 0..<aArray.count {
            handleAllSummaryPDFForLoopValidations1(aArray, j, &Foot_Pad_Lesions, &Foot_Pad_Lesions_Mean, &Foot_Pad_Lesions_Updated, &Ammonia_Burns, &mouth_Lesions)
            handleAllSummaryPDFForLoopValidations2(aArray, j, &tracheitis, &Tracheitis_Mean, &Tracheitis_Updated, &Femoral_Head_Necrosis)
            handleAllSummaryPDFForLoopValidaitons3(aArray, j, &Tibial_Dyschondroplasia, &Tibial_Dyschondroplasia_Mean, &Tibial_Dyschondroplasia_Updated, &Rickets)
            handleAllSummaryPDFForLoopValidaitons4(aArray, j, &Bone_Strength, &Bone_Strength_Mean, &Bone_Strength_Updated, &Synovitis)
            handleAllSummaryPDFForLoopValidaitons5(aArray, j, &Bursa_Size, &IP)
            handleAllSummaryPDFForLoopValidaitons6(aArray, j, &air_Sac, &air_Sac_Mean, &air_Sac_Updated, &retained_Yolk)
            handleAllSummaryPDFForLoopValidaitons7(aArray, j, &wallThikness, &gizzard_Erosions, &gizzard_Erosions_Mean, &gizzard_Erosions_Updated)
            handleAllSummaryPDFForLoopValidaitons8(aArray, j, &enterties, &enterties_Mean, &enterties_Updated, &litter_Eater, &feed_Passage)
            handleAllSummaryPDFForLoopValidaitons9(aArray, j, &proventriculitis, &proventriculitis_Mean, &proventriculitis_Updated, &roundworms)
            handleAllSummaryPDFForLoopValidaitons10(aArray, j, &tapeworms)
        
            if environmentIs.contains("stageapi") {
                stageNewObservation(aArray, j, &Pericarditis, &Liver_Granuloma, &Septicemia, &Active_Bursa, &Cellulitis)
            } else if environmentIs.contains("devapi") {
                devNewObservation(aArray, j, &Pericarditis, &Liver_Granuloma, &Septicemia, &Active_Bursa, &Cellulitis)
            } else {
                productionNewObservation(aArray, j, &Pericarditis, &Liver_Granuloma, &Septicemia, &Active_Bursa, &Cellulitis)
            }
        }
        Foot_Pad_Lesions = (Foot_Pad_Lesions/birdsCount)*100
        preparedArray.add(Foot_Pad_Lesions)
        //1
        Ammonia_Burns = (Ammonia_Burns/birdsCount)*100
        preparedArray.add(Ammonia_Burns)
        //2
        mouth_Lesions = (mouth_Lesions/birdsCount)*100
        preparedArray.add(mouth_Lesions)
        //3
        tracheitis = (tracheitis/birdsCount)*100
        preparedArray.add(tracheitis)
        //4
        Femoral_Head_Necrosis = (Femoral_Head_Necrosis/birdsCount)*100
        preparedArray.add(Femoral_Head_Necrosis)
        //5
        Tibial_Dyschondroplasia = (Tibial_Dyschondroplasia/birdsCount)*100
        preparedArray.add(Tibial_Dyschondroplasia)
        //6
        Rickets = (Rickets/birdsCount)*100
        preparedArray.add(Rickets)
        //7
        Bone_Strength = (Bone_Strength/birdsCount)*100
        preparedArray.add(Bone_Strength)
        //8
        Synovitis = (Synovitis/birdsCount)*100
        preparedArray.add(Synovitis)
        //9
        Bursa_Size = (Bursa_Size/birdsCount)*100
        preparedArray.add(Bursa_Size)
        //10
        IP = (IP/birdsCount)*100
        preparedArray.add(IP)
        //11
        air_Sac = (air_Sac/birdsCount)*100
        preparedArray.add(air_Sac)
        //12
        retained_Yolk = (retained_Yolk/birdsCount)*100
        preparedArray.add(retained_Yolk)
        //13
        litter_Eater = (litter_Eater/birdsCount)*100
        preparedArray.add(litter_Eater)
        //14
        gizzard_Erosions = (gizzard_Erosions/birdsCount)*100
        preparedArray.add(gizzard_Erosions)
        //15
        proventriculitis = (proventriculitis/birdsCount)*100
        preparedArray.add(proventriculitis)
        //16
        tapeworms = (tapeworms/birdsCount)*100
        preparedArray.add(tapeworms)
        //17
        roundworms = (roundworms/birdsCount)*100
        preparedArray.add(roundworms)
        //18
        wallThikness = (wallThikness/birdsCount)*100
        preparedArray.add(wallThikness)
        //19
        enterties = (enterties/birdsCount)*100
        preparedArray.add(enterties)
        //20
        Intestinal_Content = (Intestinal_Content/birdsCount)*100
        preparedArray.add(Intestinal_Content)
        //21
        Thin_Intestine = (Thin_Intestine/birdsCount)*100
        preparedArray.add(Thin_Intestine)
        //22
        Muscular_Hemorrhages = (Muscular_Hemorrhages/birdsCount)*100
        preparedArray.add(Muscular_Hemorrhages)
        //23
        Bursa_Lesion_Score = (Bursa_Lesion_Score/birdsCount)*100
        preparedArray.add(Bursa_Lesion_Score)
        //24
        feed_Passage = (feed_Passage/birdsCount)*100
        preparedArray.add(feed_Passage)
        
       
        Pericarditis = (Pericarditis/birdsCount)*100
        preparedArray.add(Pericarditis)
  
        Liver_Granuloma = (Liver_Granuloma/birdsCount)*100
        preparedArray.add(Liver_Granuloma)
      
        Septicemia = (Septicemia/birdsCount)*100
        preparedArray.add(Septicemia)
        
        Active_Bursa = (Active_Bursa/birdsCount)*100
        preparedArray.add(Active_Bursa)
        
        Cellulitis = (Cellulitis/birdsCount)*100
        preparedArray.add(Cellulitis)
        
        
        preparedArrayForMean.add((Foot_Pad_Lesions_Mean/Foot_Pad_Lesions_Updated).isNaN ? 0 : Foot_Pad_Lesions_Mean/Foot_Pad_Lesions_Updated)
        preparedArrayForMean.add((Tracheitis_Mean/Tracheitis_Updated).isNaN ? 0 : Tracheitis_Mean/Tracheitis_Updated)
        preparedArrayForMean.add((Tibial_Dyschondroplasia_Mean/Tibial_Dyschondroplasia_Updated).isNaN ? 0 : Tibial_Dyschondroplasia_Mean/Tibial_Dyschondroplasia_Updated)
        preparedArrayForMean.add((Bone_Strength_Mean/Bone_Strength_Updated).isNaN ? 0 : Bone_Strength_Mean/Bone_Strength_Updated)
        preparedArrayForMean.add((air_Sac_Mean/air_Sac_Updated).isNaN ? 0 : air_Sac_Mean/air_Sac_Updated)
        preparedArrayForMean.add((gizzard_Erosions_Mean/gizzard_Erosions_Updated).isNaN ? 0 : gizzard_Erosions_Mean/gizzard_Erosions_Updated)
        preparedArrayForMean.add((proventriculitis_Mean/proventriculitis_Updated).isNaN ? 0 : proventriculitis_Mean/proventriculitis_Updated)
        preparedArrayForMean.add((enterties_Mean/enterties_Updated).isNaN ? 0 : enterties_Mean/enterties_Updated)
        preparedArrayForMean.add((Bursa_Lesion_Score_Mean/Bursa_Lesion_Score_Updated).isNaN ? 0 : Bursa_Lesion_Score_Mean/Bursa_Lesion_Score_Updated)
        AllValidSessions.sharedInstance.meanValues.add(preparedArrayForMean)
        delegate?.didFinishParsingWithAllSummaryData!(preparedArray)
    }
}

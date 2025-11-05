//
//  GI_Tract_Modal.swift
//  Zoetis -Feathers
//
//  Created by "" on 01/12/16.
//  Copyright © NOT_EXIST16 "". All rights reserved.
//


import UIKit

@objc protocol GI_TtactDelegate {
    func didFinishWithParsing(finishedArray : NSArray)
    @objc optional func didFinishWithParsingWithFarmData(_ finishedArray : NSArray)
    @objc optional func didFinishParsingWithAllSummaryData(_ finishedArray : NSArray)
    @objc optional func didFinishWithParsingWithEimeriaAcervulinaGross(_ finishedArray : NSArray)
    @objc optional func didFinishWithParsingMaximaGross(_ finishedArray : NSArray)
    @objc optional func didFinishWithParsingMaximaMicro(_ finishedArray : NSArray)
    @objc optional func didFinishWithParsingTenellaGross(_ finishedArray : NSArray)
    @objc optional func didFinishWithParsingAirSac(_ finishedArray : NSArray, birds: Float)
    @objc optional func didFinishWithParsingBursaSize(_ bursaTotal : Float)
}

class GI_Tract_Modal: NSObject {

    var delegate: GI_TtactDelegate?
    
    let NOT_EXIST: Float = -1
    
    func setupData(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        if catName == "Gi_tract" {
            self.forGi_tract(aArray, birdsCount: birdsCount)
        }
        if catName == "Gi_tractTr" {
            self.forGi_tractTr(aArray, birdsCount: birdsCount)
        }
        else if catName == "immune"{
            self.forImmune(aArray, birdsCount: birdsCount)
        }
        else if catName == "immuneTr"{
            self.forImmuneTr(aArray, birdsCount: birdsCount)
        }
        else if catName == "resp"{
            self.forResp(aArray, birdsCount: birdsCount)
        }
        else if catName == "respTr"{
            self.forRespTr(aArray, birdsCount: birdsCount)
        }
        else if catName == "skeltaMuscular"{
            self.forSkeleton(aArray, birdsCount: birdsCount)
        }
        else if catName == "skeltaMuscularTr"{
            self.forSkeletonTr(aArray, birdsCount: birdsCount)
        }
        else if catName == "Coccidiosis"{
            self.forCocciSummuary(aArray, birdsCount: birdsCount)
        }
        else if catName == "AllSummary"{
            self.allSummaryPDF(aArray, birdsCount: birdsCount)
        }
    }
    
    func setupMeanBursaSize(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        var Bursa_Size : Float = 0.0
    
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Immune" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 58 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Bursa_Size=Bursa_Size+value.floatValue
                }
            }
        }
        if Bursa_Size == 0 {
            delegate?.didFinishWithParsingBursaSize!(4)
        }else{
         delegate?.didFinishWithParsingBursaSize!(Bursa_Size/birdsCount)
        }
    }
    func setupCocciDataByFarm(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
    
        let preparedArray = NSMutableArray()
        let tempArray = NSMutableArray()
        let preparedArrayForMean1 = NSMutableArray()
        let preparedArrayForMean2 = NSMutableArray()
        let preparedArrayForMean3 = NSMutableArray()
        let preparedArrayForMean4 = NSMutableArray()
        
        var Eimeria_Acervulina_Gross : Float = 0
        var Eimeria_Maxima_Gross : Float = 0
        var Eimeria_Maxima_Micro : Float = 0
        var Eimeria_Tenella_Gross : Float = 0
        
        var Eimeria_Acervulina_Gross_Mean : Float = 0
        var Eimeria_Maxima_Gross_Mean : Float = 0
        var Eimeria_Maxima_Micro_Mean : Float = 0
        var Eimeria_Tenella_Gross_Mean : Float = 0
        
        var isUpdatedAC : Float = 0
        var isUpdatedMG : Float = 0
        var isUpdatedMM : Float = 0
        var isUpdatedTG : Float = 0
        
        var observationSet : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 23 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Acervulina_Gross_Mean=Eimeria_Acervulina_Gross_Mean+value.floatValue
                    Eimeria_Acervulina_Gross=Eimeria_Acervulina_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedAC += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 24 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Maxima_Gross_Mean=Eimeria_Maxima_Gross_Mean+value.floatValue
                    Eimeria_Maxima_Gross=Eimeria_Maxima_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMG += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 25 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Maxima_Micro_Mean=Eimeria_Maxima_Micro_Mean+value.floatValue
                    Eimeria_Maxima_Micro=Eimeria_Maxima_Micro+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMM += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 26 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Tenella_Gross_Mean=Eimeria_Tenella_Gross_Mean+value.floatValue
                    Eimeria_Tenella_Gross=Eimeria_Tenella_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedTG += 1
                    }
                }
            }
        }
        
        preparedArray.add(Eimeria_Acervulina_Gross)
        preparedArray.add(Eimeria_Maxima_Gross)
        preparedArray.add(Eimeria_Maxima_Micro)
        preparedArray.add(Eimeria_Tenella_Gross)
        
        preparedArrayForMean1.add((Eimeria_Acervulina_Gross_Mean/isUpdatedAC).isNaN ? 0 : Eimeria_Acervulina_Gross_Mean/isUpdatedAC)
        tempArray.add(preparedArrayForMean1)
        
        preparedArrayForMean2.add((Eimeria_Maxima_Gross_Mean/isUpdatedMG).isNaN ? 0 : Eimeria_Maxima_Gross_Mean/isUpdatedMG)
        tempArray.add(preparedArrayForMean2)
        
        preparedArrayForMean3.add((Eimeria_Maxima_Micro_Mean/isUpdatedMM).isNaN ? 0 : Eimeria_Maxima_Micro_Mean/isUpdatedMM)
        tempArray.add(preparedArrayForMean3)
        
        preparedArrayForMean4.add((Eimeria_Tenella_Gross_Mean/isUpdatedTG).isNaN ? 0 : Eimeria_Tenella_Gross_Mean/isUpdatedTG)
        tempArray.add(preparedArrayForMean4)
        
        AllValidSessions.sharedInstance.meanValues.add(tempArray)
        
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
        delegate?.didFinishWithParsingWithFarmData!(preparedArray)
    }
    func setupEimeriaAcervulinaGross(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        let preparedArray = NSMutableArray()
        
        var Eimeria_Acervulina_Gross0 : Float = 0
        var Eimeria_Acervulina_Gross1 : Float = 0
        var Eimeria_Acervulina_Gross2 : Float = 0
        var Eimeria_Acervulina_Gross3 : Float = 0
        var Eimeria_Acervulina_Gross4 : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 23 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Eimeria_Acervulina_Gross0=Eimeria_Acervulina_Gross0+(value.floatValue == 0 ? 1 : 0)
                    Eimeria_Acervulina_Gross1=Eimeria_Acervulina_Gross1+(value.floatValue == 1 ? 1 : 0)
                    Eimeria_Acervulina_Gross2=Eimeria_Acervulina_Gross2+(value.floatValue == 2 ? 1 : 0)
                    Eimeria_Acervulina_Gross3=Eimeria_Acervulina_Gross3+(value.floatValue == 3 ? 1 : 0)
                    Eimeria_Acervulina_Gross4=Eimeria_Acervulina_Gross4+(value.floatValue == 4 ? 1 : 0)
                }
            }
        }
        preparedArray.add(Eimeria_Acervulina_Gross0)
        preparedArray.add(Eimeria_Acervulina_Gross1)
        preparedArray.add(Eimeria_Acervulina_Gross2)
        preparedArray.add(Eimeria_Acervulina_Gross3)
        preparedArray.add(Eimeria_Acervulina_Gross4)
        
        delegate?.didFinishWithParsingWithEimeriaAcervulinaGross!(preparedArray)
    }
    func setupMaximaGross(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        let preparedArray = NSMutableArray()
        
        var Eimeria_Maxima_Gross0 : Float = 0
        var Eimeria_Maxima_Gross1 : Float = 0
        var Eimeria_Maxima_Gross2 : Float = 0
        var Eimeria_Maxima_Gross3 : Float = 0
        var Eimeria_Maxima_Gross4 : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 24 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Eimeria_Maxima_Gross0=Eimeria_Maxima_Gross0+(value.floatValue == 0 ? 1 : 0)
                    Eimeria_Maxima_Gross1=Eimeria_Maxima_Gross1+(value.floatValue == 1 ? 1 : 0)
                    Eimeria_Maxima_Gross2=Eimeria_Maxima_Gross2+(value.floatValue == 2 ? 1 : 0)
                    Eimeria_Maxima_Gross3=Eimeria_Maxima_Gross3+(value.floatValue == 3 ? 1 : 0)
                    Eimeria_Maxima_Gross4=Eimeria_Maxima_Gross4+(value.floatValue == 4 ? 1 : 0)
                }
            }
        }
        
        preparedArray.add(Eimeria_Maxima_Gross0)
        preparedArray.add(Eimeria_Maxima_Gross1)
        preparedArray.add(Eimeria_Maxima_Gross2)
        preparedArray.add(Eimeria_Maxima_Gross3)
        preparedArray.add(Eimeria_Maxima_Gross4)
        
        delegate?.didFinishWithParsingMaximaGross!(preparedArray)
    }
    func setupMaximaMicro(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        let preparedArray = NSMutableArray()
        
        var Eimeria_Maxima_Micro0 : Float = 0
        var Eimeria_Maxima_Micro1 : Float = 0
        var Eimeria_Maxima_Micro2 : Float = 0
        var Eimeria_Maxima_Micro3 : Float = 0
        var Eimeria_Maxima_Micro4 : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 25 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Eimeria_Maxima_Micro0=Eimeria_Maxima_Micro0+(value.floatValue == 0 ? 1 : 0)
                    Eimeria_Maxima_Micro1=Eimeria_Maxima_Micro1+(value.floatValue == 1 ? 1 : 0)
                    Eimeria_Maxima_Micro2=Eimeria_Maxima_Micro2+(value.floatValue == 2 ? 1 : 0)
                    Eimeria_Maxima_Micro3=Eimeria_Maxima_Micro3+(value.floatValue == 3 ? 1 : 0)
                    Eimeria_Maxima_Micro4=Eimeria_Maxima_Micro4+(value.floatValue == 4 ? 1 : 0)
                }
            }
        }
        
        preparedArray.add(Eimeria_Maxima_Micro0)
        preparedArray.add(Eimeria_Maxima_Micro1)
        preparedArray.add(Eimeria_Maxima_Micro2)
        preparedArray.add(Eimeria_Maxima_Micro3)
        preparedArray.add(Eimeria_Maxima_Micro4)
        
        delegate?.didFinishWithParsingMaximaMicro!(preparedArray)
    }
    func setupTenellaGross(_ aArray : NSArray , birdsCount : Float , catName : NSString) {
        
        let preparedArray = NSMutableArray()
        
        var Eimeria_Tenella_Gross0 : Float = 0
        var Eimeria_Tenella_Gross1 : Float = 0
        var Eimeria_Tenella_Gross2 : Float = 0
        var Eimeria_Tenella_Gross3 : Float = 0
        var Eimeria_Tenella_Gross4 : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 26 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Eimeria_Tenella_Gross0=Eimeria_Tenella_Gross0+(value.floatValue == 0 ? 1 : 0)
                    Eimeria_Tenella_Gross1=Eimeria_Tenella_Gross1+(value.floatValue == 1 ? 1 : 0)
                    Eimeria_Tenella_Gross2=Eimeria_Tenella_Gross2+(value.floatValue == 2 ? 1 : 0)
                    Eimeria_Tenella_Gross3=Eimeria_Tenella_Gross3+(value.floatValue == 3 ? 1 : 0)
                    Eimeria_Tenella_Gross4=Eimeria_Tenella_Gross4+(value.floatValue == 4 ? 1 : 0)
                }
            }
        }
        
        preparedArray.add(Eimeria_Tenella_Gross0)
        preparedArray.add(Eimeria_Tenella_Gross1)
        preparedArray.add(Eimeria_Tenella_Gross2)
        preparedArray.add(Eimeria_Tenella_Gross3)
        preparedArray.add(Eimeria_Tenella_Gross4)
        
        delegate?.didFinishWithParsingTenellaGross!(preparedArray)
    }
    func forCocciSummuary(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        let preparedArrayForMean = NSMutableArray()
        
        var Eimeria_Acervulina_Gross : Float = 0
        var Eimeria_Maxima_Gross : Float = 0
        var Eimeria_Maxima_Micro : Float = 0
        var Eimeria_Tenella_Gross : Float = 0
        
        var Eimeria_Acervulina_Gross_Mean : Float = 0
        var Eimeria_Maxima_Gross_Mean : Float = 0
        var Eimeria_Maxima_Micro_Mean : Float = 0
        var Eimeria_Tenella_Gross_Mean : Float = 0
        
        var isUpdatedAC : Float = 0
        var isUpdatedMG : Float = 0
        var isUpdatedMM : Float = 0
        var isUpdatedTG : Float = 0
        
        var observationSet : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Coccidiosis" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 23 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Acervulina_Gross_Mean=Eimeria_Acervulina_Gross_Mean+value.floatValue
                    Eimeria_Acervulina_Gross=Eimeria_Acervulina_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedAC += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 24 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Maxima_Gross_Mean=Eimeria_Maxima_Gross_Mean+value.floatValue
                    Eimeria_Maxima_Gross=Eimeria_Maxima_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMG += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 25 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Maxima_Micro_Mean=Eimeria_Maxima_Micro_Mean+value.floatValue
                    Eimeria_Maxima_Micro=Eimeria_Maxima_Micro+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedMM += 1
                    }
                }
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 26 {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    observationSet += 1
                    Eimeria_Tenella_Gross_Mean=Eimeria_Tenella_Gross_Mean+value.floatValue
                    Eimeria_Tenella_Gross=Eimeria_Tenella_Gross+(value.floatValue > 0 ? 1 : 0)
                    if value.floatValue > 0 {
                        isUpdatedTG += 1
                    }
                }
            }
        }
        
        Eimeria_Acervulina_Gross = (Eimeria_Acervulina_Gross/birdsCount)*100
        preparedArray.add(Eimeria_Acervulina_Gross)
        
        Eimeria_Maxima_Gross = (Eimeria_Maxima_Gross/birdsCount)*100
        preparedArray.add(Eimeria_Maxima_Gross)
        
        Eimeria_Maxima_Micro = (Eimeria_Maxima_Micro/birdsCount)*100
        preparedArray.add(Eimeria_Maxima_Micro)
        
        Eimeria_Tenella_Gross = (Eimeria_Tenella_Gross/birdsCount)*100
        preparedArray.add(Eimeria_Tenella_Gross)
        
        preparedArrayForMean.add((Eimeria_Acervulina_Gross_Mean/isUpdatedAC).isNaN ? 0 : Eimeria_Acervulina_Gross_Mean/isUpdatedAC)
        preparedArrayForMean.add((Eimeria_Maxima_Gross_Mean/isUpdatedMG).isNaN ? 0 : Eimeria_Maxima_Gross_Mean/isUpdatedMG)
        preparedArrayForMean.add((Eimeria_Maxima_Micro_Mean/isUpdatedMM).isNaN ? 0 : Eimeria_Maxima_Micro_Mean/isUpdatedMM)
        preparedArrayForMean.add((Eimeria_Tenella_Gross_Mean/isUpdatedTG).isNaN ? 0 : Eimeria_Tenella_Gross_Mean/isUpdatedTG)
        
        AllValidSessions.sharedInstance.meanValues.add(preparedArrayForMean)
        
        UserDefaults.standard.set(AllValidSessions.sharedInstance.meanValues, forKey: "meanArray")
        
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
        
    }
    
    func forSkeleton(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        
        var Foot_Pad_Lesions : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(1) ? 0 : NOT_EXIST
        var Scratched_Birds : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(2) ? 0 : NOT_EXIST
        
        var Corneal_Ulcers: Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(3) ? 0 : NOT_EXIST
        var Femoral_Head_Necrosis : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(4) ? 0 : NOT_EXIST
        
        var Tibial_Dyschondroplasia : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(5) ? 0 : NOT_EXIST
        var Rickets : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(6) ? 0 : NOT_EXIST
        var Bone_Strength : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(7) ? 0 : NOT_EXIST
        
        var Synovitis : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(8) ? 0 : NOT_EXIST
        var Infectious_Process : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(9) ? 0 : NOT_EXIST
        var Breast_Myopathy : Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(12) ? 0 : NOT_EXIST
        
        var Muscular_Hemorrhages: Float = Regions.getobservationsSkeletal(countryID: Regions.countryId).contains(14) ? 0 : NOT_EXIST
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "skeltaMuscular" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1) && Foot_Pad_Lesions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Foot_Pad_Lesions=(Foot_Pad_Lesions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2) && Scratched_Birds != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Scratched_Birds=(Scratched_Birds)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 3) && Corneal_Ulcers != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Scratched_Birds=(Scratched_Birds)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 4) && Femoral_Head_Necrosis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Femoral_Head_Necrosis=(Femoral_Head_Necrosis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 5) && Tibial_Dyschondroplasia != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Tibial_Dyschondroplasia=(Tibial_Dyschondroplasia)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 6) && Rickets != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Rickets=(Rickets)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 7) && Bone_Strength != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Bone_Strength=(Bone_Strength)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 8) && Synovitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Synovitis=(Synovitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 9) && Infectious_Process != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Infectious_Process=(Infectious_Process)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 12) && Breast_Myopathy != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Breast_Myopathy=(Breast_Myopathy)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 14) && Muscular_Hemorrhages != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Muscular_Hemorrhages=(Muscular_Hemorrhages)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        if Foot_Pad_Lesions != NOT_EXIST {
            Foot_Pad_Lesions = (Foot_Pad_Lesions/birdsCount)*100
            preparedArray.add(Foot_Pad_Lesions)
        }
        
        if Scratched_Birds != NOT_EXIST {
            Scratched_Birds = (Scratched_Birds/birdsCount)*100
            preparedArray.add(Scratched_Birds)
        }
        
        if Corneal_Ulcers != NOT_EXIST {
            Corneal_Ulcers = (Corneal_Ulcers/birdsCount)*100
            preparedArray.add(Corneal_Ulcers)
        }
        
        if Femoral_Head_Necrosis != NOT_EXIST {
            Femoral_Head_Necrosis = (Femoral_Head_Necrosis/birdsCount)*100
            preparedArray.add(Femoral_Head_Necrosis)
        }
        
        if Tibial_Dyschondroplasia != NOT_EXIST {
            Tibial_Dyschondroplasia = (Tibial_Dyschondroplasia/birdsCount)*100
            preparedArray.add(Tibial_Dyschondroplasia)
        }
        
        if Rickets != NOT_EXIST {
            Rickets = (Rickets/birdsCount)*100
            preparedArray.add(Rickets)
        }
        
        if Bone_Strength != NOT_EXIST {
            Bone_Strength = (Bone_Strength/birdsCount)*100
            preparedArray.add(Bone_Strength)
        }
        
        if Synovitis != NOT_EXIST {
            Synovitis = (Synovitis/birdsCount)*100
            preparedArray.add(Synovitis)
        }
        
        if Infectious_Process != NOT_EXIST {
            Infectious_Process = (Infectious_Process/birdsCount)*100
            preparedArray.add(Infectious_Process)
        }
        
        if Breast_Myopathy != NOT_EXIST {
            Breast_Myopathy = (Breast_Myopathy/birdsCount)*100
            preparedArray.add(Breast_Myopathy)
        }
        
        if Muscular_Hemorrhages != NOT_EXIST{
            Muscular_Hemorrhages = (Muscular_Hemorrhages/birdsCount)*100
            preparedArray.add(Muscular_Hemorrhages)
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    func forSkeletonTr(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        
        var Foot_Pad_Lesions : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(596) ? 0 : NOT_EXIST
        var Scratched_Birds : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(597) ? 0 : NOT_EXIST
        var Corneal_Ulcers : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(598) ? 0 : NOT_EXIST
        
        var Tibial_Dyschondroplasia : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(599) ? 0 : NOT_EXIST
        var Rickets : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(600) ? 0 : NOT_EXIST
        var Bone_Strength : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(601) ? 0 : NOT_EXIST
        
        var Synovitis : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(602) ? 0 : NOT_EXIST
        var Infectious_Process : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(603) ? 0 : NOT_EXIST
        var Woody_Breast : Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(604) ? 0 : NOT_EXIST
        
        var Tibial_Head_Necrosis: Float = Regions.getobservationsSkeletalTr(countryID: Regions.countryId).contains(605) ? 0 : NOT_EXIST
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "skeltaMuscular" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 596) && Foot_Pad_Lesions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Foot_Pad_Lesions=(Foot_Pad_Lesions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 597) && Scratched_Birds != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Scratched_Birds=(Scratched_Birds)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 598) && Corneal_Ulcers != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Corneal_Ulcers=(Corneal_Ulcers)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 599) && Tibial_Dyschondroplasia != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Tibial_Dyschondroplasia=(Tibial_Dyschondroplasia)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 600) && Rickets != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Rickets=(Rickets)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 601) && Bone_Strength != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Bone_Strength=(Bone_Strength)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 602) && Synovitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Synovitis=(Synovitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 603) && Infectious_Process != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Infectious_Process=(Infectious_Process)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 604) && Woody_Breast != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Woody_Breast=(Woody_Breast)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 605) && Tibial_Head_Necrosis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Tibial_Head_Necrosis=(Tibial_Head_Necrosis)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        if Foot_Pad_Lesions != NOT_EXIST {
            Foot_Pad_Lesions = (Foot_Pad_Lesions/birdsCount)*100
            preparedArray.add(Foot_Pad_Lesions)
        }
        
        if Scratched_Birds != NOT_EXIST {
            Scratched_Birds = (Scratched_Birds/birdsCount)*100
            preparedArray.add(Scratched_Birds)
        }
        
        if Corneal_Ulcers != NOT_EXIST {
            Corneal_Ulcers = (Corneal_Ulcers/birdsCount)*100
            preparedArray.add(Corneal_Ulcers)
        }
        
        if Tibial_Dyschondroplasia != NOT_EXIST {
            Tibial_Dyschondroplasia = (Tibial_Dyschondroplasia/birdsCount)*100
            preparedArray.add(Tibial_Dyschondroplasia)
        }
        
        if Rickets != NOT_EXIST {
            Rickets = (Rickets/birdsCount)*100
            preparedArray.add(Rickets)
        }
        
        if Bone_Strength != NOT_EXIST {
            Bone_Strength = (Bone_Strength/birdsCount)*100
            preparedArray.add(Bone_Strength)
        }
        
        if Synovitis != NOT_EXIST {
            Synovitis = (Synovitis/birdsCount)*100
            preparedArray.add(Synovitis)
        }
        
        if Infectious_Process != NOT_EXIST {
            Infectious_Process = (Infectious_Process/birdsCount)*100
            preparedArray.add(Infectious_Process)
        }
        
        if Woody_Breast != NOT_EXIST {
            Woody_Breast = (Woody_Breast/birdsCount)*100
            preparedArray.add(Woody_Breast)
        }
        
        if Tibial_Head_Necrosis != NOT_EXIST{
            Tibial_Head_Necrosis = (Tibial_Head_Necrosis/birdsCount)*100
            preparedArray.add(Tibial_Head_Necrosis)
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    func forResp(_ aArray : NSArray , birdsCount : Float) {
    
        let preparedArray = NSMutableArray()
        
        var conjunctivitis : Float = Regions.getObservationsResp(countryID: Regions.countryId).contains(49) ? 0 : NOT_EXIST
        var tracheitis : Float = Regions.getObservationsResp(countryID: Regions.countryId).contains(50) ? 0 : NOT_EXIST
        var air_Sac : Float = Regions.getObservationsResp(countryID: Regions.countryId).contains(51) ? 0 : NOT_EXIST
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Resp" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID  {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 49) && conjunctivitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    conjunctivitis=(conjunctivitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 50) && tracheitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    tracheitis=(tracheitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 51) && air_Sac != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    air_Sac=(air_Sac)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        
        if conjunctivitis != NOT_EXIST{
            conjunctivitis = (conjunctivitis/birdsCount)*100
            preparedArray.add(conjunctivitis)
        }
        
        if tracheitis != NOT_EXIST{
            tracheitis = (tracheitis/birdsCount)*100
            preparedArray.add(tracheitis)
        }
        
        if air_Sac != NOT_EXIST{
            air_Sac = (air_Sac/birdsCount)*100
            preparedArray.add(air_Sac)
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    
    }
    
    func forRespTr(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        
        var conjunctivitis : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(635) ? 0 : NOT_EXIST
        var tracheitis : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(636) ? 0 : NOT_EXIST
        var air_Sac : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(637) ? 0 : NOT_EXIST
        
        var Aspergillosis : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(638) ? 0 : NOT_EXIST
        var Lung_Congestion : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(639) ? 0 : NOT_EXIST
        var Sinusitis : Float = Regions.getObservationsRespTr(countryID: Regions.countryId).contains(640) ? 0 : NOT_EXIST
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Resp" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 635) && conjunctivitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    conjunctivitis=(conjunctivitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 636) && tracheitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    tracheitis=(tracheitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 637) && air_Sac != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    air_Sac=(air_Sac)+(value.floatValue > 0 ? 1 : 0)
                }
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 638) && Aspergillosis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Aspergillosis=(Aspergillosis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 639) && Lung_Congestion != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Lung_Congestion=(Lung_Congestion)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 640) && Sinusitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Sinusitis=(Sinusitis)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        
        if conjunctivitis != NOT_EXIST{
            conjunctivitis = (conjunctivitis/birdsCount)*100
            preparedArray.add(conjunctivitis)
        }
        
        if tracheitis != NOT_EXIST{
            tracheitis = (tracheitis/birdsCount)*100
            preparedArray.add(tracheitis)
        }
        
        if air_Sac != NOT_EXIST{
            air_Sac = (air_Sac/birdsCount)*100
            preparedArray.add(air_Sac)
        }
        
        if Aspergillosis != NOT_EXIST{
            Aspergillosis = (Aspergillosis/birdsCount)*100
            preparedArray.add(Aspergillosis)
        }
        
        if Lung_Congestion != NOT_EXIST{
            Lung_Congestion = (Lung_Congestion/birdsCount)*100
            preparedArray.add(Lung_Congestion)
        }
        
        if Sinusitis != NOT_EXIST{
            Sinusitis = (Sinusitis/birdsCount)*100
            preparedArray.add(Sinusitis)
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
        
    }
    
    func forImmune(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        
        var retained_Yolk : Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(59) ? 0 : NOT_EXIST
        var cardiovascular_Hydropericardium : Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(55) ? 0 : NOT_EXIST
        var Bursa_Lesion_Score: Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(57) ? 0 : NOT_EXIST
        
        var Pericarditis: Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1870) ? 0 : NOT_EXIST
        var Septicemia: Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1874) ? 0 : NOT_EXIST
        var  Liver_Granuloma : Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1875) ? 0 : NOT_EXIST
        var  Active_Bursa : Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1873) ? 0 : NOT_EXIST
        var  Cellulitis : Float = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1878) ? 0 : NOT_EXIST
        
        let environmentIs = Constants.Api.versionUrl
        let  lngId = UserDefaults.standard.integer(forKey: "lngId")
          
        
        if environmentIs.contains("stageapi") {
            if lngId == 1 {
                Pericarditis = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1952) ? 0 : NOT_EXIST
                Septicemia = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1956) ? 0 : NOT_EXIST
                Liver_Granuloma  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1957) ? 0 : NOT_EXIST
                Active_Bursa  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1955) ? 0 : NOT_EXIST
                Cellulitis  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1960) ? 0 : NOT_EXIST
            }
        } else if environmentIs.contains("devapi") {
            Pericarditis = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1870) ? 0 : NOT_EXIST
            Septicemia = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1874) ? 0 : NOT_EXIST
            Liver_Granuloma = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1875) ? 0 : NOT_EXIST
            Active_Bursa = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1873) ? 0 : NOT_EXIST
            Cellulitis  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(1878) ? 0 : NOT_EXIST
            
        } else {
            Pericarditis = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(2030) ? 0 : NOT_EXIST
            Septicemia = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(2034) ? 0 : NOT_EXIST
            Liver_Granuloma  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(2035) ? 0 : NOT_EXIST
            Active_Bursa  = Regions.getObservationsForImmune(countryID: Regions.countryId).contains(2033) ? 0 : NOT_EXIST
        }
        
        
        
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Immune" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 59) && retained_Yolk != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    retained_Yolk=(retained_Yolk == NOT_EXIST ? 0 : retained_Yolk)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 55) && cardiovascular_Hydropericardium != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    cardiovascular_Hydropericardium=(cardiovascular_Hydropericardium == NOT_EXIST ? 0 : cardiovascular_Hydropericardium)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 57) && Bursa_Lesion_Score != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Bursa_Lesion_Score=(Bursa_Lesion_Score == NOT_EXIST ? 0 : Bursa_Lesion_Score)+(value.floatValue > 0 ? 1 : 0)
                }
                if environmentIs.contains("stageapi") {
                    if lngId == 1 {
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1952) && Pericarditis != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Pericarditis=(Pericarditis == NOT_EXIST ? 0 : Pericarditis)+(value.floatValue > 0 ? 1 : 0)
                        }
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1956) && Septicemia != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Septicemia=(Septicemia == NOT_EXIST ? 0 : Septicemia)+(value.floatValue > 0 ? 1 : 0)
                        }
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1957) && Liver_Granuloma != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Liver_Granuloma=(Liver_Granuloma == NOT_EXIST ? 0 : Liver_Granuloma)+(value.floatValue > 0 ? 1 : 0)
                        }
                        
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1955) && Active_Bursa != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Active_Bursa=(Active_Bursa == NOT_EXIST ? 0 : Active_Bursa)+(value.floatValue > 0 ? 1 : 0)
                        }
                        
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1960) && Cellulitis != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Cellulitis=(Cellulitis == NOT_EXIST ? 0 : Cellulitis)+(value.floatValue > 0 ? 1 : 0)
                        }
                    }
                } else if environmentIs.contains("devapi") {
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1870) && Pericarditis != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Pericarditis=(Pericarditis == NOT_EXIST ? 0 : Pericarditis)+(value.floatValue > 0 ? 1 : 0)
                        }
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1874) && Septicemia != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Septicemia=(Septicemia == NOT_EXIST ? 0 : Septicemia)+(value.floatValue > 0 ? 1 : 0)
                        }
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1875) && Liver_Granuloma != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Liver_Granuloma=(Liver_Granuloma == NOT_EXIST ? 0 : Liver_Granuloma)+(value.floatValue > 0 ? 1 : 0)
                        }
                        
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1873) && Active_Bursa != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Active_Bursa=(Active_Bursa == NOT_EXIST ? 0 : Active_Bursa)+(value.floatValue > 0 ? 1 : 0)
                        }
                        if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1878) && Cellulitis != NOT_EXIST {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Cellulitis=(Cellulitis == NOT_EXIST ? 0 : Cellulitis)+(value.floatValue > 0 ? 1 : 0)
                        }
                    
                } else {
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2030) && Pericarditis != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Pericarditis=(Pericarditis == NOT_EXIST ? 0 : Pericarditis)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2034) && Septicemia != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Septicemia=(Septicemia == NOT_EXIST ? 0 : Septicemia)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2035) && Liver_Granuloma != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Liver_Granuloma=(Liver_Granuloma == NOT_EXIST ? 0 : Liver_Granuloma)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2033) && Active_Bursa != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Active_Bursa=(Active_Bursa == NOT_EXIST ? 0 : Active_Bursa)+(value.floatValue > 0 ? 1 : 0)
                    }
                    
                   
                }
            }
        }
        
        if retained_Yolk != NOT_EXIST {
            retained_Yolk = (retained_Yolk/birdsCount)*100
            preparedArray.add(retained_Yolk)
        }
        
        if cardiovascular_Hydropericardium != NOT_EXIST {
            cardiovascular_Hydropericardium = (cardiovascular_Hydropericardium/birdsCount)*100
            preparedArray.add(cardiovascular_Hydropericardium)
        }
        if Bursa_Lesion_Score != NOT_EXIST {
            Bursa_Lesion_Score = (Bursa_Lesion_Score/birdsCount)*100
            preparedArray.add(Bursa_Lesion_Score)
        }
        if lngId == 1 {
            if Pericarditis != NOT_EXIST {
                Pericarditis = (Pericarditis/birdsCount)*100
                preparedArray.add(Pericarditis)
            }
            if Septicemia != NOT_EXIST {
                Septicemia = (Septicemia/birdsCount)*100
                preparedArray.add(Septicemia)
            }
            if Liver_Granuloma != NOT_EXIST {
                Liver_Granuloma = (Liver_Granuloma/birdsCount)*100
                preparedArray.add(Liver_Granuloma)
            }
            if Active_Bursa != NOT_EXIST {
                Active_Bursa = (Active_Bursa/birdsCount)*100
                preparedArray.add(Active_Bursa)
            }
            
            if Cellulitis != NOT_EXIST {
                Cellulitis = (Cellulitis/birdsCount)*100
                preparedArray.add(Cellulitis)
            }
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    
    func forImmuneTr(_ aArray : NSArray , birdsCount : Float) {
        
        let preparedArray = NSMutableArray()
        
        var retained_Yolk : Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(643) ? 0 : NOT_EXIST
        var cardiovascular_Hydropericardium : Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(641) ? 0 : NOT_EXIST
        var Splenomegaly: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(645) ? 0 : NOT_EXIST
        
        var CecalTonsilsHemorrhages: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(647) ? 0 : NOT_EXIST
        
        var Dehydration: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(648) ? 0 : NOT_EXIST
        var ThymusAtrophy: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(649) ? 0 : NOT_EXIST
        
        var Omphalitis: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(650) ? 0 : NOT_EXIST
        
        var LiverGramnuloma: Float = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(2036) ? 0 : NOT_EXIST
        
        var Cellulitis: Float = 0.0 // Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(1960) ? 0 : NOT_EXIST
        
        let environmentIs = Constants.Api.versionUrl
        if environmentIs.contains("stageapi") {
        Cellulitis = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(1960) ? 0 : NOT_EXIST
        LiverGramnuloma = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(1958) ? 0 : NOT_EXIST
        }
        else if environmentIs.contains("devapi") {
        Cellulitis = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(1878) ? 0 : NOT_EXIST
        LiverGramnuloma = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(1876) ? 0 : NOT_EXIST //1876
        }
        else
        {
            Cellulitis = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(2037) ? 0 : NOT_EXIST
            LiverGramnuloma = Regions.getObservationsForImmuneTr(countryID: Regions.countryId).contains(2036) ? 0 : NOT_EXIST
        }
        
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "Immune" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 643) && retained_Yolk != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    retained_Yolk=(retained_Yolk == NOT_EXIST ? 0 : retained_Yolk)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 641) && cardiovascular_Hydropericardium != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    cardiovascular_Hydropericardium=(cardiovascular_Hydropericardium == NOT_EXIST ? 0 : cardiovascular_Hydropericardium)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 645) && Splenomegaly != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Splenomegaly=(Splenomegaly == NOT_EXIST ? 0 : Splenomegaly)+(value.floatValue > 0 ? 1 : 0)
                }
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 647) && CecalTonsilsHemorrhages != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    CecalTonsilsHemorrhages=(CecalTonsilsHemorrhages == NOT_EXIST ? 0 : CecalTonsilsHemorrhages)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 648) && Dehydration != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Dehydration=(Dehydration == NOT_EXIST ? 0 : Dehydration)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 649) && ThymusAtrophy != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    ThymusAtrophy=(ThymusAtrophy == NOT_EXIST ? 0 : ThymusAtrophy)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 650) && Omphalitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Omphalitis=(Omphalitis == NOT_EXIST ? 0 : Omphalitis)+(value.floatValue > 0 ? 1 : 0)
                }
             
                if environmentIs.contains("stageapi") {
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1960) && Cellulitis != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Cellulitis=(Cellulitis == NOT_EXIST ? 0 : Cellulitis)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1958) && retained_Yolk != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        LiverGramnuloma=(LiverGramnuloma == NOT_EXIST ? 0 : LiverGramnuloma)+(value.floatValue > 0 ? 1 : 0)
                    }
                }
                else if environmentIs.contains("devapi") {
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1878) && Cellulitis != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Cellulitis=(Cellulitis == NOT_EXIST ? 0 : Cellulitis)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1876) && retained_Yolk != NOT_EXIST { // 1876
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        LiverGramnuloma=(LiverGramnuloma == NOT_EXIST ? 0 : LiverGramnuloma)+(value.floatValue > 0 ? 1 : 0)
                    }
                }
                else
                {
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2037) && Cellulitis != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        Cellulitis=(Cellulitis == NOT_EXIST ? 0 : Cellulitis)+(value.floatValue > 0 ? 1 : 0)
                    }
                    if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2036) && retained_Yolk != NOT_EXIST {
                        let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                        LiverGramnuloma=(LiverGramnuloma == NOT_EXIST ? 0 : LiverGramnuloma)+(value.floatValue > 0 ? 1 : 0)
                    }
                }
               
               
            }
        }
        
        if retained_Yolk != NOT_EXIST {
            retained_Yolk = (retained_Yolk/birdsCount)*100
            preparedArray.add(retained_Yolk)
        }
        
        if cardiovascular_Hydropericardium != NOT_EXIST {
            cardiovascular_Hydropericardium = (cardiovascular_Hydropericardium/birdsCount)*100
            preparedArray.add(cardiovascular_Hydropericardium)
        }
        if Splenomegaly != NOT_EXIST {
            Splenomegaly = (Splenomegaly/birdsCount)*100
            preparedArray.add(Splenomegaly)
        }
        if CecalTonsilsHemorrhages != NOT_EXIST {
            CecalTonsilsHemorrhages = (CecalTonsilsHemorrhages/birdsCount)*100
            preparedArray.add(CecalTonsilsHemorrhages)
        }
        if Dehydration != NOT_EXIST {
            Dehydration = (Dehydration/birdsCount)*100
            preparedArray.add(Dehydration)
        }
        if ThymusAtrophy != NOT_EXIST {
            ThymusAtrophy = (ThymusAtrophy/birdsCount)*100
            preparedArray.add(ThymusAtrophy)
        }
        if Omphalitis != NOT_EXIST {
            Omphalitis = (Omphalitis/birdsCount)*100
            preparedArray.add(Omphalitis)
        }
        
        if LiverGramnuloma != NOT_EXIST {
            LiverGramnuloma = (LiverGramnuloma/birdsCount)*100
            preparedArray.add(LiverGramnuloma)
        }
        
        if Cellulitis != NOT_EXIST {
            Cellulitis = (Cellulitis/birdsCount)*100
            preparedArray.add(Cellulitis)
        }
        
        
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    func forGi_tract(_ aArray : NSArray , birdsCount : Float)  {
        
        let preparedArray = NSMutableArray()
        
        var enteritis : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(32) ? 0 : NOT_EXIST
        var feed_Passage : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(34) ? 0 : NOT_EXIST
        var gizzard_Erosions : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(29) ? 0 : NOT_EXIST
        var litter_Eater : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(31) ? 0 : NOT_EXIST
        var mouth_Lesions : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(27) ? 0 : NOT_EXIST
        var necrotic_Enteritis : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(33) ? 0 : NOT_EXIST
        var proventriculitis : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(28) ? 0 : NOT_EXIST
        var roundworms : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(37) ? 0 : NOT_EXIST
        var tapeworms : Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(35) ? 0 : NOT_EXIST
        var Intestinal_Content: Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(41) ? 0 : NOT_EXIST
        var Thin_Intestine: Float = Regions.getObservationsGITract(countryID: Regions.countryId).contains(38) ? 0 : NOT_EXIST
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "GITract" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 32) && enteritis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    enteritis=(enteritis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 34) && feed_Passage != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    feed_Passage=(feed_Passage)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 29) && gizzard_Erosions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    gizzard_Erosions=(gizzard_Erosions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 31) && litter_Eater != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    litter_Eater=(litter_Eater)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 27) && mouth_Lesions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    mouth_Lesions=(mouth_Lesions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 33) && necrotic_Enteritis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    necrotic_Enteritis=(necrotic_Enteritis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 28) && proventriculitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    proventriculitis=(proventriculitis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 37) && roundworms != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    roundworms=(roundworms)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 35) && tapeworms != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    tapeworms=(tapeworms)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 41) && Intestinal_Content != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Intestinal_Content=(Intestinal_Content)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 38) && Thin_Intestine != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Thin_Intestine=(Thin_Intestine)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        if enteritis != NOT_EXIST {
            enteritis = (enteritis/birdsCount)*100
            preparedArray.add(enteritis)
        }
        
        if feed_Passage != NOT_EXIST {
            feed_Passage = (feed_Passage/birdsCount)*100
            preparedArray.add(feed_Passage)
        }
        
        if gizzard_Erosions != NOT_EXIST {
            gizzard_Erosions = (gizzard_Erosions/birdsCount)*100
            preparedArray.add(gizzard_Erosions)
        }
        
        if litter_Eater != NOT_EXIST {
            litter_Eater = (litter_Eater/birdsCount)*100
            preparedArray.add(litter_Eater)
        }
        
        if mouth_Lesions != NOT_EXIST {
            mouth_Lesions = (mouth_Lesions/birdsCount)*100
            preparedArray.add(mouth_Lesions)
        }
        
        if necrotic_Enteritis != NOT_EXIST {
            necrotic_Enteritis = (necrotic_Enteritis/birdsCount)*100
            preparedArray.add(necrotic_Enteritis)
        }

        if proventriculitis != NOT_EXIST {
            proventriculitis = (proventriculitis/birdsCount)*100
            preparedArray.add(proventriculitis)
        }
        
        if roundworms != NOT_EXIST{
            roundworms = (roundworms/birdsCount)*100
            preparedArray.add(roundworms)
        }
        
        if tapeworms != NOT_EXIST {
            tapeworms = (tapeworms/birdsCount)*100
            preparedArray.add(tapeworms)
        }
        
        if Thin_Intestine != NOT_EXIST {
            Thin_Intestine = (Thin_Intestine/birdsCount)*100
            preparedArray.add(Thin_Intestine)
        }
        
        if Intestinal_Content != NOT_EXIST {
            Intestinal_Content = (Intestinal_Content/birdsCount)*100
            preparedArray.add(Intestinal_Content)
        }
        
        
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    func allSummaryPDF(_ aArray : NSArray , birdsCount : Float)  {
        
        let preparedArray = NSMutableArray()
        let preparedArrayForMean = NSMutableArray()
        
        var Foot_Pad_Lesions : Float = 0
        var Ammonia_Burns : Float = 0
        var tracheitis : Float = 0
        var Femoral_Head_Necrosis : Float = 0
        var feed_Passage : Float = 0
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
        
 
        var Cellulitis : Float = 0
        var Pericarditis : Float = 0
        var Septicemia : Float = 0
        var Liver_Granuloma : Float = 0
        var Active_Bursa : Float = 0
        
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
      
          
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                Foot_Pad_Lesions=Foot_Pad_Lesions+(value.floatValue > 0 ? 1 : 0)
                Foot_Pad_Lesions_Mean = Foot_Pad_Lesions_Mean + value.floatValue
                if value.floatValue > 0 {
                    Foot_Pad_Lesions_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 3 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Ammonia_Burns=Ammonia_Burns+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 27 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                mouth_Lesions=mouth_Lesions+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 50 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                tracheitis=tracheitis+(value.floatValue > 0 ? 1 : 0)
                Tracheitis_Mean = Tracheitis_Mean + value.floatValue
                if value.floatValue > 0 {
                    Tracheitis_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 4 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Femoral_Head_Necrosis=Femoral_Head_Necrosis+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 5 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                Tibial_Dyschondroplasia=Tibial_Dyschondroplasia+(value.floatValue > 0 ? 1 : 0)
                Tibial_Dyschondroplasia_Mean = Tibial_Dyschondroplasia_Mean + value.floatValue
                if value.floatValue > 0 {
                    Tibial_Dyschondroplasia_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 6 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Rickets=Rickets+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 7 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                Bone_Strength=Bone_Strength+(value.floatValue > 0 ? 1 : 0)
                Bone_Strength_Mean = Bone_Strength_Mean + value.floatValue
                if value.floatValue > 0 {
                    Bone_Strength_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 8 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Synovitis=Synovitis+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 58 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                Bursa_Size=Bursa_Size+value.floatValue
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 9 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                IP=IP+value.floatValue
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 51 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                air_Sac=air_Sac+(value.floatValue > 0 ? 1 : 0)
                air_Sac_Mean = air_Sac_Mean + value.floatValue
                if value.floatValue > 0 {
                    air_Sac_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 59 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                retained_Yolk=retained_Yolk+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 34 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                feed_Passage=feed_Passage+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 29 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                gizzard_Erosions=gizzard_Erosions+(value.floatValue > 0 ? 1 : 0)
                gizzard_Erosions_Mean = gizzard_Erosions_Mean + value.floatValue
                if value.floatValue > 0 {
                    gizzard_Erosions_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 32 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                enterties=enterties+(value.floatValue > 0 ? 1 : 0)
                enterties_Mean = enterties_Mean + value.floatValue
                if value.floatValue > 0 {
                    enterties_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 31 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                litter_Eater=litter_Eater+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 28 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                proventriculitis=proventriculitis+(value.floatValue > 0 ? 1 : 0)
                proventriculitis_Mean = proventriculitis_Mean + value.floatValue
                if value.floatValue > 0 {
                    proventriculitis_Updated += 1
                }
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 37 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                roundworms=roundworms+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 35 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                tapeworms=tapeworms+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 41 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Intestinal_Content = Intestinal_Content+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 38 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Thin_Intestine = Thin_Intestine + (value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 14 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                Muscular_Hemorrhages = Muscular_Hemorrhages+(value.floatValue > 0 ? 1 : 0)
            }
            if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 57 {
                let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                Bursa_Lesion_Score = Bursa_Lesion_Score + (value.floatValue > 0 ? 1 : 0)
                Bursa_Lesion_Score_Mean = Bursa_Lesion_Score_Mean + value.floatValue
                if value.floatValue > 0 {
                    Bursa_Lesion_Score_Updated += 1
                }
            }
                
              
                let  lngId = UserDefaults.standard.integer(forKey: "lngId")
                if environmentIs.contains("stageapi") {
                    if lngId == 1 {
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1952 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Pericarditis = Pericarditis+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1956 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1957 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
                        }
                        
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1955 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Active_Bursa=Active_Bursa+(value.floatValue > 0 ? 1 : 0)
                        }
                        
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1960 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Cellulitis=Cellulitis+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1958  {
                                let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                                Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
                            }
                    }
                }
                else if environmentIs.contains("devapi") {
                  
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1870 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Pericarditis = Pericarditis+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1874 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
                        }
                    if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 1876 { // 1876 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
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
                else
                {
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2030 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Pericarditis = Pericarditis+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2034 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Septicemia=Septicemia+(value.floatValue > 0 ? 1 : 0)
                        }
                        if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 2035 {
                            let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                            Liver_Granuloma=Liver_Granuloma+(value.floatValue > 0 ? 1 : 0)
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
            }
        }
        
        
        Foot_Pad_Lesions = (Foot_Pad_Lesions/birdsCount)*100
        preparedArray.add(Foot_Pad_Lesions)
        
        Ammonia_Burns = (Ammonia_Burns/birdsCount)*100
        preparedArray.add(Ammonia_Burns)
        
        mouth_Lesions = (mouth_Lesions/birdsCount)*100
        preparedArray.add(mouth_Lesions)
        
        tracheitis = (tracheitis/birdsCount)*100
        preparedArray.add(tracheitis)
        
        Femoral_Head_Necrosis = (Femoral_Head_Necrosis/birdsCount)*100
        preparedArray.add(Femoral_Head_Necrosis)
        
        Tibial_Dyschondroplasia = (Tibial_Dyschondroplasia/birdsCount)*100
        preparedArray.add(Tibial_Dyschondroplasia)
        
        Rickets = (Rickets/birdsCount)*100
        preparedArray.add(Rickets)
        
        Bone_Strength = (Bone_Strength/birdsCount)*100
        preparedArray.add(Bone_Strength)
        
        Synovitis = (Synovitis/birdsCount)*100
        preparedArray.add(Synovitis)
        
        Bursa_Size = Bursa_Size == 0 ? 4 : (Bursa_Size/birdsCount)
        preparedArray.add(Bursa_Size)
        
        IP = (IP/birdsCount)*100
        preparedArray.add(IP)
        
        air_Sac = (air_Sac/birdsCount)*100
        preparedArray.add(air_Sac)
        
        retained_Yolk = (retained_Yolk/birdsCount)*100
        preparedArray.add(retained_Yolk)
        
        litter_Eater = (litter_Eater/birdsCount)*100
        preparedArray.add(litter_Eater)
        
        gizzard_Erosions = (gizzard_Erosions/birdsCount)*100
        preparedArray.add(gizzard_Erosions)
        
        proventriculitis = (proventriculitis/birdsCount)*100
        preparedArray.add(proventriculitis)
        
        tapeworms = (tapeworms/birdsCount)*100
        preparedArray.add(tapeworms)
        
        roundworms = (roundworms/birdsCount)*100
        preparedArray.add(roundworms)
        
        feed_Passage = (feed_Passage/birdsCount)*100
        preparedArray.add(feed_Passage)
        
        enterties = (enterties/birdsCount)*100
        preparedArray.add(enterties)
        
        Intestinal_Content = (Intestinal_Content/birdsCount)*100
        preparedArray.add(Intestinal_Content)
        
        Thin_Intestine = (Thin_Intestine/birdsCount)*100
        preparedArray.add(Thin_Intestine)
        
        Muscular_Hemorrhages = (Muscular_Hemorrhages/birdsCount)*100
        preparedArray.add(Muscular_Hemorrhages)
        
        Bursa_Lesion_Score = (Bursa_Lesion_Score/birdsCount)*100
        preparedArray.add(Bursa_Lesion_Score)

    
            Pericarditis = (Pericarditis/birdsCount)*100
            preparedArray.add(Pericarditis)
            
            Septicemia = (Septicemia/birdsCount)*100
            preparedArray.add(Septicemia)
            
            Liver_Granuloma = (Liver_Granuloma/birdsCount)*100
            preparedArray.add(Liver_Granuloma)
            
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
    
    
    func forGi_tractTr(_ aArray : NSArray , birdsCount : Float)  {
        
        let preparedArray = NSMutableArray()
        
        var enteritis : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(622) ? 0 : NOT_EXIST
        var feed_Passage : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(624) ? 0 : NOT_EXIST
        var gizzard_Erosions : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(619) ? 0 : NOT_EXIST
        var litter_Eater : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(621) ? 0 : NOT_EXIST
        var mouth_Lesions : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(617) ? 0 : NOT_EXIST
        var feedInCrop : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(623) ? 0 : NOT_EXIST
        var proventriculitis : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(618) ? 0 : NOT_EXIST
        //var roundworms : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(37) ? 0 : NOT_EXIST
        var Content : Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(627) ? 0 : NOT_EXIST
        var Intestinal_Content: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(628) ? 0 : NOT_EXIST
        var Thin_Intestine: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(625) ? 0 : NOT_EXIST
        var CropMycosis: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(632) ? 0 : NOT_EXIST
        var Ceca: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(633) ? 0 : NOT_EXIST
        var Hepatomegaly: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(634) ? 0 : NOT_EXIST
        var wallThickness: Float = Regions.getObservationsGITractTr(countryID: Regions.countryId).contains(675) ? 0 : NOT_EXIST
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == "GITract" && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID {
                
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 622) && enteritis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    enteritis=(enteritis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 624) && feed_Passage != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    feed_Passage=(feed_Passage)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 619) && gizzard_Erosions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    gizzard_Erosions=(gizzard_Erosions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 621) && litter_Eater != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    litter_Eater=(litter_Eater)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 617) && mouth_Lesions != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    mouth_Lesions=(mouth_Lesions)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 623) && feedInCrop != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    feedInCrop=(feedInCrop)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 618) && proventriculitis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    proventriculitis=(proventriculitis)+(value.floatValue > 0 ? 1 : 0)
                }
                //                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 37) && roundworms != NOT_EXIST {
                //                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                //                    roundworms=(roundworms)+(value.floatValue > 0 ? 1 : 0)
                //                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 627) && Content != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Content=(Content)+(value.floatValue > 0 ? 1 : 0)
                }
                //                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 628) && Intestinal_Content != NOT_EXIST {
                //                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                //                    Intestinal_Content=(Intestinal_Content)+(value.floatValue > 0 ? 1 : 0)
                //                }
                //                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 625) && Thin_Intestine != NOT_EXIST {
                //                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                //                    Thin_Intestine=(Thin_Intestine)+(value.floatValue > 0 ? 1 : 0)
                //                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 632) && CropMycosis != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    CropMycosis=(CropMycosis)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 633) && Ceca != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    Ceca=(Ceca)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 634) && Hepatomegaly != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    Hepatomegaly=(Hepatomegaly)+(value.floatValue > 0 ? 1 : 0)
                }
                if ((aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == 675) && wallThickness != NOT_EXIST {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "objsVisibilty") as! NSNumber
                    wallThickness=(wallThickness)+(value.floatValue > 0 ? 1 : 0)
                }
            }
        }
        if enteritis != NOT_EXIST {
            enteritis = (enteritis/birdsCount)*100
            preparedArray.add(enteritis)
        }
        
        
        
        if gizzard_Erosions != NOT_EXIST {
            gizzard_Erosions = (gizzard_Erosions/birdsCount)*100
            preparedArray.add(gizzard_Erosions)
        }
        
        if litter_Eater != NOT_EXIST {
            litter_Eater = (litter_Eater/birdsCount)*100
            preparedArray.add(litter_Eater)
        }
        
        if mouth_Lesions != NOT_EXIST {
            mouth_Lesions = (mouth_Lesions/birdsCount)*100
            preparedArray.add(mouth_Lesions)
        }
        
        if feedInCrop != NOT_EXIST {
            feedInCrop = (feedInCrop/birdsCount)*100
            preparedArray.add(feedInCrop)
        }
        
        if proventriculitis != NOT_EXIST {
            proventriculitis = (proventriculitis/birdsCount)*100
            preparedArray.add(proventriculitis)
        }
        
        //        if roundworms != NOT_EXIST{
        //            roundworms = (roundworms/birdsCount)*100
        //            preparedArray.add(roundworms)
        //        }
        //
        if wallThickness != NOT_EXIST {
            wallThickness = (wallThickness/birdsCount)*100
            preparedArray.add(wallThickness)
        }
        if Content != NOT_EXIST {
            Content = (Content/birdsCount)*100
            preparedArray.add(Content)
        }
        
        if Intestinal_Content != NOT_EXIST {
            Intestinal_Content = (Intestinal_Content/birdsCount)*100
            preparedArray.add(Intestinal_Content)
        }
        
        if Thin_Intestine != NOT_EXIST {
            Thin_Intestine = (Thin_Intestine/birdsCount)*100
            preparedArray.add(Thin_Intestine)
        }
        
        if CropMycosis != NOT_EXIST {
            CropMycosis = (CropMycosis/birdsCount)*100
            preparedArray.add(CropMycosis)
        }
        if Ceca != NOT_EXIST {
            Ceca = (Ceca/birdsCount)*100
            preparedArray.add(Ceca)
        }
        if feed_Passage != NOT_EXIST {
            feed_Passage = (feed_Passage/birdsCount)*100
            preparedArray.add(feed_Passage)
        }
        if Hepatomegaly != NOT_EXIST {
            Hepatomegaly = (Hepatomegaly/birdsCount)*100
            preparedArray.add(Hepatomegaly)
        }
        delegate?.didFinishWithParsing(finishedArray: preparedArray)
    }
    
    //MARK: AirSec Calculations
    
    func setupAirSec(_ aArray : NSArray , birdsCount : Float , catName : NSString, referanceID: NSNumber ) {
        
        let preparedArray = NSMutableArray()
        
        var airSec0 : Float = 0
        var airSec1 : Float = 0
        var airSec2 : Float = 0
        var airSec3 : Float = 0
        var airSec4 : Float = 0
        
        for  j in 0..<aArray.count
        {
            if ((aArray.object(at: j) as AnyObject).value(forKey: "catName")) as! NSString == catName && ((aArray.object(at: j) as AnyObject).value(forKey: "lngId")) as! Int == Regions.languageID{
                
                if (aArray.object(at: j) as AnyObject).value(forKey: "refId") as! NSNumber == referanceID {
                    let value = (aArray.object(at: j) as AnyObject).value(forKey: "obsPoint") as! NSNumber
                    airSec0=airSec0+(value.floatValue == 0 ? 1 : 0)
                    airSec1=airSec1+(value.floatValue == 1 ? 1 : 0)
                    airSec2=airSec2+(value.floatValue == 2 ? 1 : 0)
                    airSec3=airSec3+(value.floatValue == 3 ? 1 : 0)
                    airSec4=airSec4+(value.floatValue == 4 ? 1 : 0)
                }
            }
        }
        
        preparedArray.add(airSec0)
        preparedArray.add(airSec1)
        preparedArray.add(airSec2)
        preparedArray.add(airSec3)
        preparedArray.add(airSec4)
        
        delegate?.didFinishWithParsingAirSac?(preparedArray, birds: birdsCount)
    }
}


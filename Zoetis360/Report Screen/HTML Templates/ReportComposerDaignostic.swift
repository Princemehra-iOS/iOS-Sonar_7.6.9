//
//  ReportComposer.swift
//  PDFDemo
//
//  Created by "" on 01/02/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import AVFoundation

class ReportComposerDaignostic: NSObject {
    
    var pathToReportHTMLTemplate = UserDefaults.standard.bool(forKey: "turkeyReport") ?Bundle.main.path(forResource:"DiagnosticReportTr-\(Regions.countryId)\(1)", ofType: "html") : Bundle.main.path(forResource:"DiagnosticReport-\(Regions.countryId)\(Regions.languageID)", ofType: "html")
    
    var pathToSingleItemHTMLTemplate = UserDefaults.standard.bool(forKey: "turkeyReport") ? Bundle.main.path(forResource: "single_item_DignosticTr", ofType: "html") : Bundle.main.path(forResource:"single_item_Dignostic-\(Regions.countryId)\(Regions.languageID)", ofType: "html")
    
    var pathToLastItemHTMLTemplate = UserDefaults.standard.bool(forKey: "turkeyReport") ? Bundle.main.path(forResource: "last_item_daignosticTr", ofType: "html") : Bundle.main.path(forResource:"last_item_daignostic-\(Regions.countryId)\(Regions.languageID)", ofType: "html")
    
    let logoImageURL = WebClass.sharedInstance.connected() == true ? "https://mypoultryview360.com/Images/logo.png" : Bundle.main.path(forResource:"logo", ofType: "png")
    
    let birdsMargin = Regions.countryId == 40 ? "margin-left:-40px" : "margin-left:-180px"
    
    let birdsMarginHistory = Regions.countryId == 40 ? "margin-left:-40px" : "margin-left:-225px"
    
    let birdsMarginSummary = Regions.countryId == 40 ? "margin-left:-60px" : "margin-left:-130px"
    
    let ageMarginHistory = Regions.countryId == 40 ? "margin-left:-20px" : "margin-left:-110px"
    
    let ageMarginSummary = Regions.countryId == 40 ? "margin-left:-45px" : "margin-left:-55px"
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    var meanAge = Float()
    
    override init() {
        super.init()
    }
    
    func SingleItemBirdsMargin(countryID: Int) -> String {
        
        var margin: String = ""
        switch countryID {
        case 35: margin = "margin-left:-100px"
            break
        case 40: margin = "margin-left:-60px"
            break
        default:
            break
        }
        return margin
    }
    
    func SingleItemAgeMargin(countryID: Int) -> String {
        
        var margin: String = ""
        switch countryID {
        case 35: margin = "margin-left:-50px"
            break
        case 40: margin = "margin-left:-40px"
            break
        default:
            break
        }
        return margin
    }
    func renderReports(complexName: String,customerName: String,vetanatrionName: String,salesRepName: String,customerRepName: String,typeDate: String,items: [[String: AnyObject]]) -> String! {
        
        debugPrint("DiagnosticReport-\(Regions.countryId)\(Regions.languageID)")
        
        if pathToReportHTMLTemplate == nil {
            
            pathToReportHTMLTemplate = UserDefaults.standard.bool(forKey: "turkeyReport") ?Bundle.main.path(forResource:"DiagnosticReportTr-\(Regions.countryId)\(1)", ofType: "html") : Bundle.main.path(forResource:"DiagnosticReport-\(Regions.countryId)\(Regions.languageID)", ofType: "html")
        }
        
        if let hederH = Bundle.main.path(forResource:"DiagnosticReport-\(Regions.countryId)\(Regions.languageID)H", ofType: "html"){
            pathToReportHTMLTemplate = items[0]["isCocciHistory"]?.boolValue == false ? pathToReportHTMLTemplate : hederH
        }
        
        if let path = Bundle.main.path(forResource:"single_item_Dignostic-\(Regions.countryId)\(Regions.languageID)H", ofType: "html"){
            pathToSingleItemHTMLTemplate = items[0]["isCocciHistory"]?.boolValue == false ? pathToSingleItemHTMLTemplate : path
        }
        
        if let pathH = Bundle.main.path(forResource:"last_item_daignostic-\(Regions.countryId)\(Regions.languageID)H", ofType: "html"){
            pathToLastItemHTMLTemplate = items[0]["isCocciHistory"]?.boolValue == false ? pathToLastItemHTMLTemplate : pathH
        }
        do {
            var HTMLContent = try? String(contentsOfFile: pathToReportHTMLTemplate!, encoding:  String.Encoding.utf8)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#complexName#", with: complexName)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#CustomerName#", with: customerName)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#vetanatrionName#", with: vetanatrionName)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#salesRepName#", with: salesRepName.count == 0 ? "NA" : salesRepName)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#customerRepName#", with: customerRepName.count == 0 ? "NA" : customerRepName)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#reportTitle#", with: items[0]["isCocciHistory"]?.boolValue == true ? NSLocalizedString("Necropsy Historical Report", comment: "") : NSLocalizedString("Necropsy Summary Report", comment: ""))
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#digHisMargn#", with: items[0]["isCocciHistory"]?.boolValue == true ? "margin-left:-20px":"margin-left:-40px")
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#typeDate#", with: typeDate)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#Farm#", with: items[0]["isCocciHistory"]?.boolValue == true ? "Date" : NSLocalizedString("Farm", comment: ""))
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#LOGO_IMAGE#", with: logoImageURL!)
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "display:none" : "")
            //HTMLContent = HTMLContent!.replacingOccurrences(of: "logo.png\"", with: "logo.png\"")
            
            var allItems = ""
            var birdsTotal = Int()
            
            
            var Foot_Pad_Lesions : Float = 0
            var Ammonia_Burns : Float = 0
            var tracheitis : Float = 0
            var Femoral_Head_Necrosis : Float = 0
            var feed_Passage : Float = 0
            var feed_P : Float = 0
            
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
            
            var Foot_Pad_Lesions_Mean : Float = 0
            var Tracheitis_Mean : Float = 0
            var Tibial_Dyschondroplasia_Mean : Float = 0
            var air_Sac_Mean : Float = 0
            var gizzard_Erosions_Mean : Float = 0
            var proventriculitis_Mean : Float = 0
            var enterties_Mean : Float = 0
            var boneStrength_Mean : Float = 0
            var Bursa_Lesion_Score_Mean: Float = 0
            
            var air_Sac_Updated : Float = 0
            var Bursa_Size_Updated : Float = 0.0
            var Foot_Pad_Lesions_Updated : Float = 0
            var Tracheitis_Updated : Float = 0
            var Tibial_Dyschondroplasia_Updated : Float = 0
            var gizzard_Erosions_Updated : Float = 0
            var proventriculitis_Updated : Float = 0
            var enterties_Updated : Float = 0
            var boneStrength_Updated : Float = 0
            var Bursa_Lesion_Score_Updated: Float = 0
            
            var birdsTotal_Spliter = Int()
            var meanAge_Spliter = Float()
            
            var Foot_Pad_Lesions_Spliter : Float = 0
            var Ammonia_Burns_Spliter : Float = 0
            var tracheitis_Spliter : Float = 0
            var Femoral_Head_Necrosis_Spliter : Float = 0
            var feed_Passage_Spliter : Float = 0
            var feed_P_Spliter : Float = 0
            var gizzard_Erosions_Spliter : Float = 0
            var litter_Eater_Spliter : Float = 0
            var mouth_Lesions_Spliter : Float = 0
            var proventriculitis_Spliter : Float = 0
            var roundworms_Spliter : Float = 0
            var tapeworms_Spliter : Float = 0
            var Tibial_Dyschondroplasia_Spliter : Float = 0
            var Rickets_Spliter : Float = 0
            var Bone_Strength_Spliter : Float = 0
            var Bursa_Size_Spliter : Float = 0.0
            var IP_Spliter : Float = 0.0
            var Synovitis_Spliter : Float = 0
            var retained_Yolk_Spliter : Float = 0
            var air_Sac_Spliter : Float = 0
            var enterties_Spliter : Float = 0
            var Intestinal_Content_Spliter: Float = 0
            var Thin_Intestine_Spliter: Float = 0
            var Muscular_Hemorrhages_Spliter: Float = 0
            var Bursa_Lesion_Score_Spliter: Float = 0
            
            var Foot_Pad_Lesions_Mean_Spliter : Float = 0
            var Tracheitis_Mean_Spliter : Float = 0
            var Tibial_Dyschondroplasia_Mean_Spliter : Float = 0
            var air_Sac_Mean_Spliter : Float = 0
            var gizzard_Erosions_Mean_Spliter : Float = 0
            var proventriculitis_Mean_Spliter : Float = 0
            var enterties_Mean_Spliter : Float = 0
            var boneStrength_Mean_Spliter : Float = 0
            var Bursa_Lesion_Score_Mean_Spliter: Float = 0
            
            var Foot_Pad_Lesions_Mean_Birds_Spliter : Float = 0
            var Tracheitis_Mean_Birds_Spliter : Float = 0
            var Tibial_Dyschondroplasia_Mean_Birds_Spliter : Float = 0
            var air_Sac_Mean_Birds_Spliter : Float = 0
            var gizzard_Erosions_Mean_Birds_Spliter : Float = 0
            var proventriculitis_Mean_Birds_Spliter : Float = 0
            var enterties_Mean_Birds_Spliter : Float = 0
            var boneStrength_Mean_Birds_Spliter : Float = 0
            var Bursa_Lesion_Score_Birds_Spliter: Float = 0
            
            var Pericarditis : Float = 0
            var Septicemia : Float = 0
            var Liver_Granuloma : Float = 0
            var Active_Bursa : Float = 0
            var Cellulitis : Float = 0
           
            var Pericarditis_Spliter : Float = 0
            var Septicemia_Spliter : Float = 0
            var Liver_Granuloma_Spliter : Float = 0
            var Active_Bursa_Spliter : Float = 0
            var Cellulitis_Spliter : Float = 0
            
            
            var index = Int()
            var index_Spliter = Float()
            var index_Total = Int()
            let meanArray = AllValidSessions.sharedInstance.meanValues
            
            
            var needToSplit2532 = Bool()
            var needToSplit3341 = Bool()
            var needToSplit42 = Bool()
            var needToSplit1424 = Bool()
            var needToSplit0114 = Bool()
            var isCheckSum = Bool()
            var isCheckSum1 = Bool()
            var isCheckSum2 = Bool()
            var isCheckSum3 = Bool()
            let  lngId = UserDefaults.standard.integer(forKey: "lngId")
             
            
            for i in 0..<items.count+1 {
                var itemHTMLContent: String!
                
                if i != items.count  {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!, encoding: String.Encoding.utf8)
                    index = 0
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#margin-left:-40px#", with: items[0]["isCocciHistory"]?.boolValue == true ? birdsMargin : SingleItemBirdsMargin(countryID: Regions.countryId))
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#margin-left:-20px#", with: items[0]["isCocciHistory"]?.boolValue == true ? ageMarginHistory : SingleItemAgeMargin(countryID: Regions.countryId))
                    
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Intestinal#", with: NSString(format: "%.1f",items[i]["Intestinal"]!.floatValue) as String)
                    Intestinal_Content = Intestinal_Content+items[i]["Intestinal"]!.floatValue
                    Intestinal_Content_Spliter = Intestinal_Content_Spliter+items[i]["Intestinal"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Thin#", with: NSString(format: "%.1f",items[i]["Thin_Intestine"]!.floatValue) as String)
                    Thin_Intestine = Thin_Intestine+items[i]["Thin_Intestine"]!.floatValue
                    Thin_Intestine_Spliter = Thin_Intestine_Spliter+items[i]["Thin_Intestine"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MuscularHemorrhages#", with: NSString(format: "%.1f",items[i]["Muscular"]!.floatValue) as String)
                    Muscular_Hemorrhages = Muscular_Hemorrhages+items[i]["Muscular"]!.floatValue
                    Muscular_Hemorrhages_Spliter = Muscular_Hemorrhages_Spliter+items[i]["Muscular"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FootpadLesions#", with: NSString(format: "%.1f",items[i]["FP"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Foot_Pad_Lesions_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    
                    Foot_Pad_Lesions = Foot_Pad_Lesions+items[i]["FP"]!.floatValue
                    Foot_Pad_Lesions_Mean = Foot_Pad_Lesions_Mean +
                    (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    
                    Foot_Pad_Lesions_Updated = Foot_Pad_Lesions_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    Foot_Pad_Lesions_Spliter = Foot_Pad_Lesions_Spliter+items[i]["FP"]!.floatValue
                    Foot_Pad_Lesions_Mean_Spliter = Foot_Pad_Lesions_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    
                    Foot_Pad_Lesions_Mean_Birds_Spliter = Foot_Pad_Lesions_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#amonia#", with: NSString(format: "%.1f",items[i]["amonia"]!.floatValue) as String)
                    Ammonia_Burns =  Ammonia_Burns+items[i]["amonia"]!.floatValue
                    Ammonia_Burns_Spliter = Ammonia_Burns_Spliter+items[i]["amonia"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#mouth#", with: NSString(format: "%.1f",items[i]["mouth"]!.floatValue) as String)
                    mouth_Lesions = mouth_Lesions+items[i]["mouth"]!.floatValue
                    mouth_Lesions_Spliter = mouth_Lesions_Spliter+items[i]["mouth"]!.floatValue
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#trac#", with: NSString(format: "%.1f",items[i]["trac"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tracheitis_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    tracheitis = tracheitis+items[i]["trac"]!.floatValue
                    
                    Tracheitis_Mean = Tracheitis_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    
                    Tracheitis_Updated = Tracheitis_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    tracheitis_Spliter = tracheitis_Spliter+items[i]["trac"]!.floatValue
                    Tracheitis_Mean_Spliter = Tracheitis_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    Tracheitis_Mean_Birds_Spliter = Tracheitis_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FHN#", with: NSString(format: "%.1f",items[i]["FHN"]!.floatValue) as String)
                    Femoral_Head_Necrosis = Femoral_Head_Necrosis+items[i]["FHN"]!.floatValue
                    Femoral_Head_Necrosis_Spliter = Femoral_Head_Necrosis_Spliter+items[i]["FHN"]!.floatValue
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TD#", with: NSString(format: "%.1f",items[i]["TD"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tibial_Dyschondroplasia_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    Tibial_Dyschondroplasia = Tibial_Dyschondroplasia+items[i]["TD"]!.floatValue
                    
                    
                    Tibial_Dyschondroplasia_Mean = Tibial_Dyschondroplasia_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    Tibial_Dyschondroplasia_Updated = Tibial_Dyschondroplasia_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    Tibial_Dyschondroplasia_Spliter = Tibial_Dyschondroplasia_Spliter+items[i]["TD"]!.floatValue
                    
                    Tibial_Dyschondroplasia_Mean_Spliter = Tibial_Dyschondroplasia_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    Tibial_Dyschondroplasia_Mean_Birds_Spliter = Tibial_Dyschondroplasia_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Rick#", with: NSString(format: "%.1f",items[i]["Rick"]!.floatValue) as String)
                    Rickets =  Rickets+items[i]["Rick"]!.floatValue
                    Rickets_Spliter = Rickets_Spliter+items[i]["Rick"]!.floatValue
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bone#", with: NSString(format: "%.1f",items[i]["Bone"]!.floatValue) as String)
                    Bone_Strength = Bone_Strength+items[i]["Bone"]!.floatValue
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#boneStrength_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    Bone_Strength_Spliter = Bone_Strength_Spliter+items[i]["Bone"]!.floatValue
                    boneStrength_Mean = boneStrength_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    boneStrength_Updated = boneStrength_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    boneStrength_Mean_Spliter = boneStrength_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    boneStrength_Mean_Birds_Spliter = boneStrength_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Syno#", with: NSString(format: "%.1f",items[i]["Syno"]!.floatValue) as String)
                    Synovitis =  Synovitis+items[i]["Syno"]!.floatValue
                    Synovitis_Spliter = Synovitis_Spliter+items[i]["Syno"]!.floatValue
                    
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bursa#", with: NSString(format: "%.1f",items[i]["Bursa"]!.floatValue) as String)
                    Bursa_Size =  Bursa_Size+items[i]["Bursa"]!.floatValue
                    Bursa_Size_Spliter = Bursa_Size_Spliter+items[i]["Bursa"]!.floatValue
                    Bursa_Size_Updated = Bursa_Size_Updated + ((items[i]["Bursa"]!.floatValue) > 0.0 ? 1.0 : 0)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#IP#", with: NSString(format: "%.1f",items[i]["IP"]!.floatValue) as String)
                    IP =  IP+items[i]["IP"]!.floatValue
                    IP_Spliter = IP_Spliter+items[i]["IP"]!.floatValue
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air#", with: NSString(format: "%.1f",items[i]["air"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air_Sac_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    air_Sac = air_Sac+items[i]["air"]!.floatValue
                    air_Sac_Mean = air_Sac_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    air_Sac_Updated = air_Sac_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    air_Sac_Spliter = air_Sac_Spliter+items[i]["air"]!.floatValue
                    air_Sac_Mean_Spliter = air_Sac_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    air_Sac_Mean_Birds_Spliter = air_Sac_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#retained#", with: NSString(format: "%.1f",items[i]["retained"]!.floatValue) as String)
                    retained_Yolk = retained_Yolk+items[i]["retained"]!.floatValue
                    retained_Yolk_Spliter = retained_Yolk_Spliter+items[i]["retained"]!.floatValue
                    
                    let lngId = UserDefaults.standard.integer(forKey: "lngId")
                    
                    if lngId == 1
                    {
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pericarditis#", with: NSString(format: "%.1f",items[i]["pericarditis"]!.floatValue) as String)
                        Pericarditis = Pericarditis+items[i]["pericarditis"]!.floatValue
                        Pericarditis_Spliter = Pericarditis_Spliter+items[i]["pericarditis"]!.floatValue
                        
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#septicemia#", with: NSString(format: "%.1f",items[i]["septicemia"]!.floatValue) as String)
                        Septicemia = Septicemia+items[i]["septicemia"]!.floatValue
                        Septicemia_Spliter = Septicemia_Spliter+items[i]["septicemia"]!.floatValue
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Liver_Granuloma#", with: NSString(format: "%.1f",items[i]["Liver_Granuloma"]?.floatValue ?? 0) as String)
                        Liver_Granuloma = Liver_Granuloma+(items[i]["Liver_Granuloma"]?.floatValue ?? 0)
                        Liver_Granuloma_Spliter = Liver_Granuloma_Spliter+(items[i]["Liver_Granuloma"]?.floatValue ?? 0)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Active_Bursa#", with: NSString(format: "%.1f",items[i]["Active_Bursa"]?.floatValue ?? 0) as String)
                        Active_Bursa = Active_Bursa+(items[i]["Active_Bursa"]?.floatValue ?? 0)
                        Active_Bursa_Spliter = Active_Bursa_Spliter+(items[i]["Active_Bursa"]?.floatValue ?? 0)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#cellulitis#", with: NSString(format: "%.1f",items[i]["cellulitis"]?.floatValue ?? 0) as String)
                        Cellulitis = Cellulitis+(items[i]["cellulitis"]?.floatValue ?? 0)
                        Cellulitis_Spliter = Cellulitis_Spliter+(items[i]["cellulitis"]?.floatValue ?? 0)
                    }
                    

                    
                    
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#litter#", with: NSString(format: "%.1f",items[i]["litter"]!.floatValue) as String)
                    litter_Eater =  litter_Eater+items[i]["litter"]!.floatValue
                    litter_Eater_Spliter = litter_Eater_Spliter+items[i]["litter"]!.floatValue
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#ge#", with: NSString(format: "%.1f",items[i]["ge"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#gizzard_Erosions_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    gizzard_Erosions = gizzard_Erosions+items[i]["ge"]!.floatValue
                    
                    gizzard_Erosions_Mean = gizzard_Erosions_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    gizzard_Erosions_Updated = gizzard_Erosions_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    gizzard_Erosions_Spliter = gizzard_Erosions_Spliter+items[i]["ge"]!.floatValue
                    gizzard_Erosions_Mean_Spliter = gizzard_Erosions_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    gizzard_Erosions_Mean_Birds_Spliter = gizzard_Erosions_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pro#", with: NSString(format: "%.1f",items[i]["pro"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#proventriculitis_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    proventriculitis =  proventriculitis+items[i]["pro"]!.floatValue
                    
                    proventriculitis_Mean = proventriculitis_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    proventriculitis_Updated = proventriculitis_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    proventriculitis_Spliter = proventriculitis_Spliter+items[i]["pro"]!.floatValue
                    proventriculitis_Mean_Spliter = proventriculitis_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    proventriculitis_Mean_Birds_Spliter = proventriculitis_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties#", with: NSString(format: "%.1f",items[i]["enterties"]!.floatValue) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    enterties = enterties+items[i]["enterties"]!.floatValue
                    
                    enterties_Mean = enterties_Mean + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    enterties_Updated = enterties_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    enterties_Spliter = enterties_Spliter+items[i]["enterties"]!.floatValue
                    enterties_Mean_Spliter = enterties_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    enterties_Mean_Birds_Spliter = enterties_Mean_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    
                    index+=1
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#BursaLesionScore#", with: NSString(format: "%.1f",items[i]["BLS"]!.floatValue) as String)
                    Bursa_Lesion_Score = Bursa_Lesion_Score+items[i]["BLS"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#bursaLesionScore_Mean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                    Bursa_Lesion_Score_Mean = Bursa_Lesion_Score_Mean +
                    (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    
                    Bursa_Lesion_Score_Updated = Bursa_Lesion_Score_Updated + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    Bursa_Lesion_Score_Mean_Spliter = Bursa_Lesion_Score_Mean_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                    Bursa_Lesion_Score_Birds_Spliter = Bursa_Lesion_Score_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                    Bursa_Lesion_Score_Spliter = Bursa_Lesion_Score_Spliter+items[i]["BLS"]!.floatValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#tape#", with: NSString(format: "%.1f",items[i]["tape"]!.floatValue) as String)
                    tapeworms =  tapeworms+items[i]["tape"]!.floatValue
                    tapeworms_Spliter = tapeworms_Spliter+items[i]["tape"]!.floatValue
                    
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#round#", with: NSString(format: "%.1f",items[i]["round"]!.floatValue) as String)
                    roundworms = roundworms+items[i]["round"]!.floatValue
                    roundworms_Spliter = roundworms_Spliter+items[i]["round"]!.floatValue
                    
                  
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed#", with: NSString(format: "%.1f",items[i]["feed"]!.floatValue) as String)
                    feed_Passage = feed_Passage+items[i]["feed"]!.floatValue
                    feed_Passage_Spliter = feed_Passage_Spliter+items[i]["feed"]!.floatValue
                    
                    
                    if let feedValue = items[i]["feed_P"]?.floatValue{
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed_P#", with: NSString(format: "%.1f",feedValue) as String)
                        feed_P = feed_P+feedValue
                        feed_P_Spliter = feed_P_Spliter+feedValue
                    }
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FarmName#", with: items[i]["isCocciHistory"]?.boolValue == true ? items[i]["sessionDate"]! as! String : items[i]["farmName"]! as! String)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "display:none" : "")
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#birds#", with: items[i]["birds"]! as! String)
                    birdsTotal = birdsTotal+items[i]["birds"]!.integerValue
                    birdsTotal_Spliter = birdsTotal_Spliter+items[i]["birds"]!.integerValue
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAge#", with: items[i]["meanAge"]! as! String)
                    meanAge = meanAge+items[i]["meanAge"]!.floatValue
                    meanAge_Spliter = meanAge_Spliter+items[i]["meanAge"]!.floatValue
                    
                    let arrayIndex = i + 1 < items.count ? i + 1 : i
                    index_Spliter+=1
                    
                    if items[arrayIndex]["meanAge"]!.integerValue > 13 && items[arrayIndex]["meanAge"]!.integerValue < 25{
                        
                        if needToSplit0114 == true
                        {
                            needToSplit3341 = false
                            needToSplit42 = false
                            needToSplit2532 = false
                            needToSplit1424 = false
                            needToSplit0114 = false
                            isCheckSum = true
                        }
                        else
                        {
                            if isCheckSum == false
                            {
                                needToSplit0114 = true
                                
                            }
                            else
                            {
                                needToSplit0114 = false
                            }
                            
                        }
                    }
                    
                    else if items[arrayIndex]["meanAge"]!.integerValue > 24 && items[arrayIndex]["meanAge"]!.integerValue < 33{
                        
                        
                        
                        
                        if needToSplit1424 == true
                        {
                            needToSplit3341 = false
                            needToSplit42 = false
                            needToSplit2532 = false
                            needToSplit1424 = false
                            needToSplit0114 = false
                            isCheckSum1 = true
                        }
                        else
                        {
                            if isCheckSum1 == false
                            {
                                needToSplit1424 = true
                            }
                            else{
                                needToSplit1424 = false
                            }
                            
                        }
                        
                        
                        
                    }
                    else if items[arrayIndex]["meanAge"]!.integerValue > 32 && items[arrayIndex]["meanAge"]!.integerValue < 43{
                        
                        
                        if needToSplit2532 == true
                        {
                            needToSplit3341 = false
                            needToSplit42 = false
                            needToSplit2532 = false
                            needToSplit1424 = false
                            needToSplit0114 = false
                            isCheckSum2 = true
                        }
                        else
                        {
                            if isCheckSum2 == false
                            {
                                needToSplit2532 = true
                            }
                            else{
                                needToSplit2532 = false
                                
                            }
                            
                        }
                        
                    }
                    else if items[arrayIndex]["meanAge"]!.integerValue > 42 && items[arrayIndex]["meanAge"]!.integerValue < 81{
                        
                        
                        if needToSplit42 == true
                        {
                            
                            needToSplit3341 = false
                            needToSplit42 = false
                            needToSplit2532 = false
                            needToSplit1424 = false
                            needToSplit0114 = false
                            isCheckSum3 = true
                        }
                        
                        else if needToSplit3341 == true
                        {
                            
                            
                            
                            if (items.count == i + 1)
                            {
                                needToSplit42 = true
                                needToSplit3341 = false
                                needToSplit2532 = false
                                needToSplit1424 = false
                                needToSplit0114 = false
                            }
                            else
                            {
                                needToSplit42 = false
                                needToSplit3341 = false
                                needToSplit2532 = false
                                needToSplit1424 = false
                                needToSplit0114 = false
                                isCheckSum3 = true
                            }
                            
                            
                        }
                        else
                        {
                            
                            if (items.count == i + 1)
                            {
                                needToSplit42 = true
                                needToSplit3341 = false
                                needToSplit2532 = false
                                needToSplit1424 = false
                                needToSplit0114 = false
                            }
                            else
                            {
                                needToSplit42 = false
                                if isCheckSum3 == false
                                {
                                    needToSplit3341 = true
                                }
                                else{
                                    needToSplit3341 = false
                                    
                                }
                                needToSplit2532 = false
                                needToSplit1424 = false
                                needToSplit0114 = false
                            }
                        }
                        
                    }
                    
                    if items[i]["meanAge"]!.integerValue > 13 && items[i]["meanAge"]!.integerValue < 25 {
                        
                        needToSplit0114 = false
                    }
                    if items[i]["meanAge"]!.integerValue > 41 && items[i]["meanAge"]!.integerValue < 81 {
                        
                        needToSplit3341 = false
                    }
                    
                    
                    if  ((needToSplit2532 == true || needToSplit3341 == true || needToSplit42 == true || needToSplit1424 == true || needToSplit0114 == true) && (items[0]["isCocciHistory"]?.boolValue == false)) || (i == items.count-1 && items[0]["isCocciHistory"]?.boolValue == false){
                        
                        isCheckSum = false
                        isCheckSum1 = false
                        isCheckSum2 = false
                        isCheckSum3 = false
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display#", with: "" )
                        
                        if items[i]["meanAge"]!.integerValue > 13 && items[i]["meanAge"]!.integerValue < 25
                        {
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "14 - 24 \(NSLocalizedString("Days", comment: ""))")
                        }
                        else if items[i]["meanAge"]!.integerValue > 0 && items[i]["meanAge"]!.integerValue < 14
                        {
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "01 - 13 \(NSLocalizedString("Days", comment: ""))")
                        }
                        else if items[i]["meanAge"]!.integerValue > 24 && items[i]["meanAge"]!.integerValue < 33
                        {
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "25 - 32 \(NSLocalizedString("Days", comment: ""))")
                        }
                        
                        else  if items[i]["meanAge"]!.integerValue > 32 && items[i]["meanAge"]!.integerValue < 43
                        {
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "33 - 41 \(NSLocalizedString("Days", comment: ""))")
                        }
                        
                        else  if items[i]["meanAge"]!.integerValue > 42 && items[i]["meanAge"]!.integerValue < 81{
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: NSLocalizedString("42 days or older", comment: ""))
                        }
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TotalBirds#", with: NSString(format: "%d",birdsTotal_Spliter) as String )
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAgeTotal#", with: NSString(format: "%.0f",round(Float(meanAge_Spliter/index_Spliter))) as String)
                        
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FP_TOTAL#", with: NSString(format: "%.1f",Foot_Pad_Lesions_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#amonia_TOTAL#", with: NSString(format: "%.1f",Ammonia_Burns_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#mouth_TOTAL#", with: NSString(format: "%.1f",mouth_Lesions_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#trac_TOTAL#", with: NSString(format: "%.1f",tracheitis_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FHN_TOTAL#", with: NSString(format: "%.1f",Femoral_Head_Necrosis_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TD_TOTAL#", with: NSString(format: "%.1f",Tibial_Dyschondroplasia_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Rick_TOTAL#", with: NSString(format: "%.1f",Rickets_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bone_TOTAL#", with: NSString(format: "%.1f",Bone_Strength_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Syno_TOTAL#", with: NSString(format: "%.1f",Synovitis_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bursa_TOTAL#", with: NSString(format: "%.1f",Bursa_Size_Spliter == 0 ? 4 : Bursa_Size_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#IP_TOTAL#", with: NSString(format: "%.1f",IP_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air_TOTAL#", with: NSString(format: "%.1f",air_Sac_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#retained_TOTAL#", with: NSString(format: "%.1f",retained_Yolk_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#litter_TOTAL#", with: NSString(format: "%.1f",litter_Eater_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#ge_TOTAL#", with: NSString(format: "%.1f",gizzard_Erosions_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pro_TOTAL#", with: NSString(format: "%.1f",proventriculitis_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#tape_TOTAL#", with: NSString(format: "%.1f",tapeworms_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#round_TOTAL#", with: NSString(format: "%.1f",roundworms_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed_TOTAL#", with: NSString(format: "%.1f",feed_Passage_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed_P_TOTAL#", with: NSString(format: "%.1f",feed_P_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties_TOTAL#", with: NSString(format: "%.1f",enterties_Spliter/Float(index_Spliter)) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Intestinal_TOTAL#", with: NSString(format: "%.1f",Intestinal_Content_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Thin_TOTAL#", with: NSString(format: "%.1f",Thin_Intestine_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MuscularHemorrhages_TOTAL#", with: NSString(format: "%.1f",Muscular_Hemorrhages_Spliter/Float(index_Spliter)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#bursaLesionSize_TOTAL#", with: NSString(format: "%.1f",Bursa_Lesion_Score_Spliter/Float(index_Spliter)) as String)
                        
                   
                        if lngId == 1
                        {
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pericarditis_TOTAL#", with: NSString(format: "%.1f",Pericarditis_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#septicemia_TOTAL#", with: NSString(format: "%.1f",Septicemia_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Liver_Granuloma_TOTAL#", with: NSString(format: "%.1f",Liver_Granuloma_Spliter/Float(index_Spliter)) as String)
                            
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Active_Bursa_TOTAL#", with: NSString(format: "%.1f",Active_Bursa_Spliter/Float(index_Spliter)) as String)
                                                    
                            
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#cellulitis_TOTAL#", with: NSString(format: "%.1f",Cellulitis_Spliter/Float(index_Spliter)) as String)
                        }
                   
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "display:none" : "")
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Foot_Pad_Lesions_Mean_Total#", with: NSString(format: "%.1f",(Foot_Pad_Lesions_Mean_Spliter/Foot_Pad_Lesions_Mean_Birds_Spliter).isNaN ? 0 : Foot_Pad_Lesions_Mean_Spliter/Foot_Pad_Lesions_Mean_Birds_Spliter) as String)
                        
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties_Mean_Total#", with: NSString(format: "%.1f",(enterties_Mean_Spliter/enterties_Mean_Birds_Spliter).isNaN ? 0 : enterties_Mean_Spliter/enterties_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#boneStrength_Mean_Total#", with: NSString(format: "%.1f",(boneStrength_Mean_Spliter/boneStrength_Mean_Birds_Spliter).isNaN ? 0 : boneStrength_Mean_Spliter/boneStrength_Mean_Birds_Spliter) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tracheitis_Mean_Total#", with: NSString(format: "%.1f",(Tracheitis_Mean_Spliter/Tracheitis_Mean_Birds_Spliter).isNaN ? 0 : Tracheitis_Mean_Spliter/Tracheitis_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tibial_Dyschondroplasia_Mean_Total#", with: NSString(format: "%.1f",(Tibial_Dyschondroplasia_Mean_Spliter/Tibial_Dyschondroplasia_Mean_Birds_Spliter).isNaN ? 0 : Tibial_Dyschondroplasia_Mean_Spliter/Tibial_Dyschondroplasia_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air_Sac_Mean_Total#", with: NSString(format: "%.1f",(air_Sac_Mean_Spliter/air_Sac_Mean_Birds_Spliter).isNaN ? 0 : air_Sac_Mean_Spliter/air_Sac_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#gizzard_Erosions_Mean_Total#", with: NSString(format: "%.1f",(gizzard_Erosions_Mean_Spliter/gizzard_Erosions_Mean_Birds_Spliter).isNaN ? 0 : gizzard_Erosions_Mean_Spliter/gizzard_Erosions_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#proventriculitis_Mean_Total#", with: NSString(format: "%.1f",(proventriculitis_Mean_Spliter/proventriculitis_Mean_Birds_Spliter).isNaN ? 0 : proventriculitis_Mean_Spliter/proventriculitis_Mean_Birds_Spliter) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#bursaLesionSize_Mean_Total#", with: NSString(format: "%.1f",(Bursa_Lesion_Score_Mean_Spliter/Bursa_Lesion_Score_Birds_Spliter).isNaN ? 0 : Bursa_Lesion_Score_Mean_Spliter/Bursa_Lesion_Score_Birds_Spliter) as String)
                        
                        Foot_Pad_Lesions_Spliter = 0
                        Ammonia_Burns_Spliter = 0
                        mouth_Lesions_Spliter = 0
                        tracheitis_Spliter = 0
                        Femoral_Head_Necrosis_Spliter = 0
                        Tibial_Dyschondroplasia_Spliter = 0
                        Rickets_Spliter = 0
                        Bone_Strength_Spliter = 0
                        Synovitis_Spliter = 0
                        Bursa_Size_Spliter = 0
                        IP_Spliter = 0
                        air_Sac_Spliter = 0
                        retained_Yolk_Spliter = 0
                    
                       
                        Pericarditis_Spliter = 0
                        Septicemia_Spliter = 0
                        Liver_Granuloma_Spliter = 0
                        Active_Bursa_Spliter = 0
                        Cellulitis_Spliter = 0
                        
                        litter_Eater_Spliter = 0
                        gizzard_Erosions_Spliter = 0
                        proventriculitis_Spliter = 0
                        tapeworms_Spliter = 0
                        roundworms_Spliter = 0
                        feed_Passage_Spliter = 0
                        feed_P_Spliter = 0
                        enterties_Spliter = 0
                        Bursa_Lesion_Score_Spliter = 0
                        
                        Foot_Pad_Lesions_Mean_Spliter = 0
                        Tracheitis_Mean_Spliter = 0
                        Tibial_Dyschondroplasia_Mean_Spliter = 0
                        air_Sac_Mean_Spliter = 0
                        gizzard_Erosions_Mean_Spliter = 0
                        proventriculitis_Mean_Spliter = 0
                        enterties_Mean_Spliter = 0
                        boneStrength_Mean_Spliter = 0
                        Bursa_Lesion_Score_Mean_Spliter = 0
                        
                        Foot_Pad_Lesions_Mean_Birds_Spliter = 0
                        Tracheitis_Mean_Birds_Spliter = 0
                        Tibial_Dyschondroplasia_Mean_Birds_Spliter = 0
                        air_Sac_Mean_Birds_Spliter = 0
                        gizzard_Erosions_Mean_Birds_Spliter = 0
                        proventriculitis_Mean_Birds_Spliter = 0
                        enterties_Mean_Birds_Spliter = 0
                        boneStrength_Mean_Birds_Spliter = 0
                        Bursa_Lesion_Score_Birds_Spliter = 0
                        
                        birdsTotal_Spliter = 0
                        meanAge_Spliter = 0
                        index_Spliter = 0
                        
                        index_Total += 1
                        
                    } else{
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display#", with: "display:none" )
                    }
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Sick#", with: items[i]["isSick"]!.intValue == 0 ? "" : "checked")
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!, encoding: String.Encoding.utf8)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TotalBirds#", with: NSString(format: "%d",birdsTotal) as String )
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAge#", with: NSString(format: "%.0f",round(meanAge/Float(items.count))) as String)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "display:none" : "")
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#margin-left:-40px#", with: items[0]["isCocciHistory"]?.boolValue == true ? birdsMarginHistory : birdsMarginSummary)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#margin-left:-20px#", with: items[0]["isCocciHistory"]?.boolValue == true ? ageMarginHistory : ageMarginSummary)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"margin-left:-140px", with: items[0]["isCocciHistory"]?.boolValue == true ? "margin-left:-180px" : "margin-left:-140px")
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FP_TOTAL#", with: NSString(format: "%.1f",Foot_Pad_Lesions/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#amonia_TOTAL#", with: NSString(format: "%.1f",Ammonia_Burns/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#mouth_TOTAL#", with: NSString(format: "%.1f",mouth_Lesions/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#trac_TOTAL#", with: NSString(format: "%.1f",tracheitis/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FHN_TOTAL#", with: NSString(format: "%.1f",Femoral_Head_Necrosis/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TD_TOTAL#", with: NSString(format: "%.1f",Tibial_Dyschondroplasia/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Rick_TOTAL#", with: NSString(format: "%.1f",Rickets/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bone_TOTAL#", with: NSString(format: "%.1f",Bone_Strength/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Syno_TOTAL#", with: NSString(format: "%.1f",Synovitis/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Bursa_TOTAL#", with: NSString(format: "%.1f",Bursa_Size == 0 ? 4 : Bursa_Size/Float(items.count) ) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#IP_TOTAL#", with: NSString(format: "%.1f",IP/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air_TOTAL#", with: NSString(format: "%.1f",air_Sac/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#retained_TOTAL#", with: NSString(format: "%.1f",retained_Yolk/Float(items.count)) as String)
                
                    if lngId == 1
                    {
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pericarditis_TOTAL#", with: NSString(format: "%.1f",Pericarditis/Float(items.count)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#septicemia_TOTAL#", with: NSString(format: "%.1f",Septicemia/Float(items.count)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Liver_Granuloma_TOTAL#", with: NSString(format: "%.1f",Liver_Granuloma/Float(items.count)) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Active_Bursa_TOTAL#", with: NSString(format: "%.1f",Active_Bursa/Float(items.count)) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#cellulitis_TOTAL#", with: NSString(format: "%.1f",Cellulitis/Float(items.count)) as String)
                    }
             
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#litter_TOTAL#", with: NSString(format: "%.1f",litter_Eater/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#ge_TOTAL#", with: NSString(format: "%.1f",gizzard_Erosions/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#pro_TOTAL#", with: NSString(format: "%.1f",proventriculitis/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#tape_TOTAL#", with: NSString(format: "%.1f",tapeworms/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#round_TOTAL#", with: NSString(format: "%.1f",roundworms/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed_TOTAL#", with: NSString(format: "%.1f",feed_Passage/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#feed_P_TOTAL#", with: NSString(format: "%.1f",feed_P/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties_TOTAL#", with: NSString(format: "%.1f",enterties/Float(items.count)) as String)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Intestinal_TOTAL#", with: NSString(format: "%.1f",Intestinal_Content/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Thin_TOTAL#", with: NSString(format: "%.1f",Thin_Intestine/Float(items.count)) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MuscularHemorrhages_TOTAL#", with: NSString(format: "%.1f",Muscular_Hemorrhages/Float(items.count)) as String)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#bursaLesionSize_TOTAL#", with: NSString(format: "%.1f",Bursa_Lesion_Score/Float(items.count)) as String)
                    
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Foot_Pad_Lesions_Mean_Total#", with: NSString(format: "%.1f",(Foot_Pad_Lesions_Mean/Foot_Pad_Lesions_Updated).isNaN ? 0 : Foot_Pad_Lesions_Mean/Foot_Pad_Lesions_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tracheitis_Mean_Total#", with: NSString(format: "%.1f",(Tracheitis_Mean/Tracheitis_Updated).isNaN ? 0 : Tracheitis_Mean/Tracheitis_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Tibial_Dyschondroplasia_Mean_Total#", with: NSString(format: "%.1f",(Tibial_Dyschondroplasia_Mean/Tibial_Dyschondroplasia_Updated).isNaN ? 0 : Tibial_Dyschondroplasia_Mean/Tibial_Dyschondroplasia_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#air_Sac_Mean_Total#", with: NSString(format: "%.1f",(air_Sac_Mean/air_Sac_Updated).isNaN ? 0 : air_Sac_Mean/air_Sac_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#bursaLesionSize_Mean_Total#", with: NSString(format: "%.1f",(Bursa_Lesion_Score_Mean/Bursa_Lesion_Score_Updated).isNaN ? 0 : Bursa_Lesion_Score_Mean/Bursa_Lesion_Score_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#gizzard_Erosions_Mean_Total#", with: NSString(format: "%.1f",(gizzard_Erosions_Mean/gizzard_Erosions_Updated).isNaN ? 0 : gizzard_Erosions_Mean/gizzard_Erosions_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#proventriculitis_Mean_Total#", with: NSString(format: "%.1f",(proventriculitis_Mean/proventriculitis_Updated).isNaN ? 0 : proventriculitis_Mean/proventriculitis_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#enterties_Mean_Total#", with: NSString(format: "%.1f",(enterties_Mean/enterties_Updated).isNaN ? 0 : enterties_Mean/enterties_Updated) as String)
                    itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#boneStrength_Mean_Total#", with: NSString(format: "%.1f",(boneStrength_Mean/boneStrength_Updated).isNaN ? 0 : boneStrength_Mean/boneStrength_Updated) as String)
                }
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent!.replacingOccurrences(of:"#ITEMS#", with: allItems)
            AllValidSessions.sharedInstance.meanValues.removeAllObjects()
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        
        let printPageRenderer = UIPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        printPageRenderer.setValue(NSValue(cgRect: page), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        let newPdfData = NSMutableData.init(data: pdfData! as Data)
        UIGraphicsBeginPDFContextToData(newPdfData , CGRect.zero, nil)
        for i in 1...printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            printPageRenderer.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        pdfFilename = "\(getDocDir())/Report.pdf"
        try? newPdfData.write(to: URL(fileURLWithPath: pdfFilename), options: [.atomic])
    }
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        
        return data
    }
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}


//
//  ReportComposer.swift
//  PDFDemo
//
//  Created by "" on 01/02/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import AVFoundation

class ReportComposer: NSObject {
    
    let pathToReportHTMLTemplate = UserDefaults.standard.bool(forKey: "turkeyReport") ? Bundle.main.path(forResource:"reportTr\(1)", ofType: "html") : Bundle.main.path(forResource:"report\(Regions.languageID)", ofType: "html")
    
    let categoryName = UserDefaults.standard.bool(forKey: "turkeyReport") ? "Microscopy" : "Coccidiosis"
        
    var pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item\(Regions.languageID)", ofType: "html")
    
    var pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item\(Regions.languageID)", ofType: "html")
     
    
    //let logoImageURL = NSBundle.mainBundle().pathForResource("logo", ofType: "png")
    
    let logoImageURL = WebClass.sharedInstance.connected() == true ? "https://devaz.mypoultryview360.com/Images/logo.png" : Bundle.main.path(forResource: "logo", ofType: "png")
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    var meanAge = Float()
    
    override init() {
        super.init()
    }
    func renderReports(_ complexName: String,customerName: String,vetanatrionName: String,salesRepName: String,customerRepName: String,typeDate: String,items: [[String: AnyObject]]) -> String! {
        
        if Regions.languageID == 0
        {
            pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item\(1)", ofType: "html")
            pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item\(1)", ofType: "html")
        }
        else{
            pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item\(Regions.languageID)", ofType: "html")
            pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item\(Regions.languageID)", ofType: "html")
        }
        do {
            if let value = pathToReportHTMLTemplate {
                debugPrint(value)
                var HTMLContent = try? String(contentsOfFile: pathToReportHTMLTemplate!, encoding: String.Encoding.utf8)
                
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#complexName#", with: complexName)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#CustomerName#", with: customerName)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#vetanatrionName#", with: vetanatrionName)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#salesRepName#", with: salesRepName.count == 0 ? "NA" : salesRepName)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#customerRepName#", with: customerRepName.count == 0 ? "NA" : customerRepName)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#reportTitle#", with: items[0]["isCocciHistory"]?.boolValue == true ? NSLocalizedString("\(categoryName) Historical Report", comment: "") : NSLocalizedString("\(categoryName) Summary Report", comment: ""))
                
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#typeDate#", with: typeDate)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#Farm#", with: items[0]["isCocciHistory"]?.boolValue == true ? "Date" : NSLocalizedString("Farm", comment: ""))
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#LOGO_IMAGE#", with: logoImageURL!)
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "visibility:hidden" : "")
                //HTMLContent = HTMLContent!.stringByReplacingOccurrencesOfString( "logo.png\"", withString: "logo.png\"")
                
                var allItems = ""
                var birdsTotal = Int()
                
                var AG_Total = Float()
                var MG_Total = Float()
                var MM_Total = Float()
                var TG_Total = Float()
                
                var AGMean_Total = Float()
                var MGMean_Total = Float()
                var MMMean_Total = Float()
                var TGMean_Total = Float()
                
                var AGMean_Total_Birds = Float()
                var MGMean_Total_Birds = Float()
                var MMMean_Total_Birds = Float()
                var TGMean_Total_Birds = Float()
                
                var birdsTotal_Spliter = Int()
                var meanAge_Spliter = Float()
                var AG_Total_Spliter = Float()
                var MG_Total_Spliter = Float()
                var MM_Total_Spliter = Float()
                var TG_Total_Spliter = Float()
                
                var AGMean_Total_Spliter = Float()
                var MGMean_Total_Spliter = Float()
                var MMMean_Total_Spliter = Float()
                var TGMean_Total_Spliter = Float()
                
                var AGMean_Total_Birds_Spliter = Float()
                var MGMean_Total_Birds_Spliter = Float()
                var MMMean_Total_Birds_Spliter = Float()
                var TGMean_Total_Birds_Spliter = Float()
                
                
                var index = Int()
                var index_Spliter = Float()
                var index_Total = Int()
                let meanArray = AllValidSessions.sharedInstance.meanValues
                
                //var needToSplitGreaterThan42 = Bool()
                var needToSplit2532 = Bool()
                var needToSplit3341 = Bool()
                var needToSplit42 = Bool()
                var needToSplit1424 = Bool()
                
                var needToSplit0114 = Bool()
                var isCheckSum = Bool()
                var isCheckSum1 = Bool()
                var isCheckSum2 = Bool()
                var isCheckSum3 = Bool()
                
                for i in 0..<items.count+1 {
                    var itemHTMLContent: String!
                    
                    if i != items.count  {
                        itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!, encoding: String.Encoding.utf8)
                        index = 0
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Acervulina#", with: NSString(format: "%.1f",items[i]["acer"]?.floatValue ?? 0) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#acerMean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                        
                        AG_Total = AG_Total + items[i]["acer"]!.floatValue
                        
                        AGMean_Total = AGMean_Total + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        AGMean_Total_Birds = AGMean_Total_Birds + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                        
                        AG_Total_Spliter = AG_Total_Spliter+items[i]["acer"]!.floatValue
                        AGMean_Total_Spliter = AGMean_Total_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        AGMean_Total_Birds_Spliter = AGMean_Total_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                        
                        index+=1
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MaximaGross#", with: NSString(format: "%.1f",items[i]["mg"]!.floatValue) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#mgMean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                        
                        
                        MG_Total = MG_Total+items[i]["mg"]!.floatValue
                        MGMean_Total = MGMean_Total + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        MGMean_Total_Birds = MGMean_Total_Birds + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                        
                        MG_Total_Spliter = MG_Total_Spliter+items[i]["mg"]!.floatValue
                        MGMean_Total_Spliter = MGMean_Total_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        MGMean_Total_Birds_Spliter = MGMean_Total_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0.0 ? 1.0 : 0)
                        
                        index+=1
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MaximaMicro#", with: NSString(format: "%.1f",items[i]["mm"]!.floatValue) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#mmMean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                        
                        
                        MM_Total = MM_Total+items[i]["mm"]!.floatValue
                        MMMean_Total = MMMean_Total + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        MMMean_Total_Birds = MMMean_Total_Birds + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0 ? 1 : 0)
                        
                        MM_Total_Spliter = MM_Total_Spliter+items[i]["mm"]!.floatValue
                        MMMean_Total_Spliter = MMMean_Total_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        MMMean_Total_Birds_Spliter = MMMean_Total_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0 ? 1 : 0)
                        
                        index+=1
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TenellaGross#", with: NSString(format: "%.1f",items[i]["tg"]!.floatValue) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#tgMean#", with: NSString(format: "%.1f",(((meanArray[i] as! NSArray)[index] as AnyObject).floatValue).isNaN ? 0 : (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)) as String)
                        
                        TG_Total_Spliter = TG_Total_Spliter+items[i]["tg"]!.floatValue
                        TGMean_Total_Spliter = TGMean_Total_Spliter + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        TGMean_Total_Birds_Spliter = TGMean_Total_Birds_Spliter + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0 ? 1 : 0)
                        
                        
                        TG_Total = TG_Total + items[i]["tg"]!.floatValue
                        TGMean_Total = TGMean_Total + (((meanArray[i] as! NSArray)[index] as AnyObject).floatValue)
                        TGMean_Total_Birds = TGMean_Total_Birds + ((((meanArray[i] as! NSArray)[index] as AnyObject).floatValue) > 0 ? 1 : 0)
                        
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#FarmName#", with: items[i]["isCocciHistory"]?.boolValue == true ? items[i]["sessionDate"]! as! String : items[i]["farmName"]! as! String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "visibility:hidden" : "")
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#birds#", with: items[i]["birds"]! as! String)
                        birdsTotal = birdsTotal+items[i]["birds"]!.integerValue
                        birdsTotal_Spliter = birdsTotal_Spliter+items[i]["birds"]!.integerValue
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAge#", with: items[i]["meanAge"]! as! String)
                        meanAge = meanAge+items[i]["meanAge"]!.floatValue
                        meanAge_Spliter = meanAge_Spliter+items[i]["meanAge"]!.floatValue
                        
                        index_Spliter+=1
                        
                        let arrayIndex = i + 1 < items.count ? i + 1 : i
                        
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
                        if  ((needToSplit2532 == true || needToSplit3341 == true || needToSplit42 == true || needToSplit1424 == true || needToSplit0114 == true) && (items[0]["isCocciHistory"]?.boolValue == false)) || (i == items.count-1 && items[0]["isCocciHistory"]?.boolValue == false) {
                            
                            isCheckSum = false
                            isCheckSum1 = false
                            isCheckSum2 = false
                            isCheckSum3 = false
                            
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display#", with: "" )
                            if items[i]["meanAge"]!.integerValue > 0 && items[i]["meanAge"]!.integerValue < 14
                            {
                                itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "01 - 13 \(NSLocalizedString("Days", comment: ""))")
                            }
                            
                            else if items[i]["meanAge"]!.integerValue > 13 && items[i]["meanAge"]!.integerValue < 25
                            {
                                itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "14 - 24 \(NSLocalizedString("Days", comment: ""))")
                            }
                            
                            else if items[i]["meanAge"]!.integerValue > 24 && items[i]["meanAge"]!.integerValue < 33
                            {
                                itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "25 - 32 \(NSLocalizedString("Days", comment: ""))")
                            }
                            
                            else  if items[i]["meanAge"]!.integerValue > 32 && items[i]["meanAge"]!.integerValue < 43
                            {
                                itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: "33 - 41 \(NSLocalizedString("Days", comment: ""))")
                            }
                            
                            else  if items[i]["meanAge"]!.integerValue > 42 && items[i]["meanAge"]!.integerValue < 81
                            {
                                itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"Complex Total", with: NSLocalizedString("42 days or older", comment: ""))
                            }
                            
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TotalBirds#", with: NSString(format: "%d",birdsTotal_Spliter) as String )
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAgeTotal#", with: NSString(format: "%.0f",round(Float(meanAge_Spliter/index_Spliter))) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#AG_TOTAL#", with: NSString(format: "%.1f",AG_Total_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MG_TOTAL#", with: NSString(format: "%.1f",MG_Total_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MM_TOTAL#", with: NSString(format: "%.1f",MM_Total_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TG_TOTAL#", with: NSString(format: "%.1f",TG_Total_Spliter/Float(index_Spliter)) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "display:none" : "")
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#AGMean_Total#", with: NSString(format: "%.1f",(AGMean_Total_Spliter/AGMean_Total_Birds_Spliter).isNaN ? 0 : AGMean_Total_Spliter/AGMean_Total_Birds_Spliter) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MGMean_Total#", with: NSString(format: "%.1f",(MGMean_Total_Spliter/MGMean_Total_Birds_Spliter).isNaN ? 0 : MGMean_Total_Spliter/MGMean_Total_Birds_Spliter) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MMMean_Total#", with: NSString(format: "%.1f",(MMMean_Total_Spliter/MMMean_Total_Birds_Spliter).isNaN ? 0 : MMMean_Total_Spliter/MMMean_Total_Birds_Spliter) as String)
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TGMean_Total#", with: NSString(format: "%.1f",(TGMean_Total_Spliter/TGMean_Total_Birds_Spliter).isNaN ? 0 : TGMean_Total_Spliter/TGMean_Total_Birds_Spliter) as String)
                            
                            AG_Total_Spliter = 0
                            MG_Total_Spliter = 0
                            MM_Total_Spliter = 0
                            TG_Total_Spliter = 0
                            
                            AGMean_Total_Spliter = 0
                            MGMean_Total_Spliter = 0
                            MMMean_Total_Spliter = 0
                            TGMean_Total_Spliter = 0
                            
                            AGMean_Total_Birds_Spliter = 0
                            MGMean_Total_Birds_Spliter = 0
                            MMMean_Total_Birds_Spliter = 0
                            TGMean_Total_Birds_Spliter = 0
                            
                            birdsTotal_Spliter = 0
                            meanAge_Spliter = 0
                            index_Spliter = 0
                            
                            index_Total += 1
                            
                            //                        needToSplit2532 = false
                            //                        needToSplit3341 = false
                            //                        needToSplit42 = false
                            
                        } else{
                            
                            itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display#", with: "display:none" )
                        }
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#Sick#", with: items[i]["isSick"]!.intValue == 0 ? "" : "checked")
                    }
                    else {
                        itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!, encoding: String.Encoding.utf8)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TotalBirds#", with: NSString(format: "%d",birdsTotal) as String )
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MeanAge#", with: NSString(format: "%.0f",round(meanAge/Float(items.count))) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#AG_TOTAL#", with: NSString(format: "%.1f",AG_Total/Float(items.count)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MG_TOTAL#", with: NSString(format: "%.1f",MG_Total/Float(items.count)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MM_TOTAL#", with: NSString(format: "%.1f",MM_Total/Float(items.count)) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TG_TOTAL#", with: NSString(format: "%.1f",TG_Total/Float(items.count)) as String)
                        
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#display:none#", with: items[0]["isCocciHistory"]?.boolValue == true ? "visibility:hidden" : "")
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#AGMean_Total#", with: NSString(format: "%.1f",(AGMean_Total/AGMean_Total_Birds).isNaN ? 0 : AGMean_Total/AGMean_Total_Birds) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MGMean_Total#", with: NSString(format: "%.1f",(MGMean_Total/MGMean_Total_Birds).isNaN ? 0 : MGMean_Total/MGMean_Total_Birds) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#MMMean_Total#", with: NSString(format: "%.1f",(MMMean_Total/MMMean_Total_Birds).isNaN ? 0 : MMMean_Total/MMMean_Total_Birds) as String)
                        itemHTMLContent = itemHTMLContent!.replacingOccurrences(of:"#TGMean_Total#", with: NSString(format: "%.1f",(TGMean_Total/TGMean_Total_Birds).isNaN ? 0 : TGMean_Total/TGMean_Total_Birds) as String)
                    }
                    
                    allItems += itemHTMLContent
                }
                
                HTMLContent = HTMLContent!.replacingOccurrences(of:"#ITEMS#", with: allItems)
                AllValidSessions.sharedInstance.meanValues.removeAllObjects()
                return HTMLContent
            }
        }
        catch {
        }
        
        return nil
    }
    
    func exportHTMLContentToPDF(_ HTMLContent: String){
        let printPageRenderer = UIPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 800) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        printPageRenderer.setValue(NSValue(cgRect: page), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer)
        let newPdfData = NSMutableData.init(data: pdfData!)
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
    func drawPDFUsingPrintPageRenderer(_ printPageRenderer: UIPrintPageRenderer) -> Data! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        
        return data as Data?
    }
    func getDocDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}


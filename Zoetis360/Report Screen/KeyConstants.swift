//
//  KeyConstants.swift
//  Zoetis -Feathers
//
//  Created by   on 29/01/18.
//  Copyright © 2018   . All rights reserved.
//

import Foundation
import Charts

let MicroscopyObservationNameArray = CoreDataHandlerTurkey().getObservationNameForMicroscopy(refID: Regions.getObservationsMicroscopy(countryID: Regions.countryId)) as! [String]
let weekArray = ["\(NSLocalizedString("Week", comment: "")) 1","\(NSLocalizedString("Week", comment: "")) 2","\(NSLocalizedString("Week", comment: "")) 3","\(NSLocalizedString("Week", comment: "")) 4","\(NSLocalizedString("Week", comment: "")) 5","\(NSLocalizedString("Week", comment: "")) 6","\(NSLocalizedString("Week", comment: "")) 7","\(NSLocalizedString("Week", comment: "")) 8","\(NSLocalizedString("Week", comment: "")) 9","\(NSLocalizedString("Week", comment: "")) 10"]

var sessionDateSingle = NSString()

class Regions: NSObject {
    
    static var countryId = UserDefaults.standard.integer(forKey: "countryId")
    static var languageID = UserDefaults.standard.integer(forKey: "lngId")
    
    class func getObservationsMicroscopy(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 35, 40:
            observations = [607,612,613,611]
            break
            
        default: break
            
        }
        return observations!
    }
    
    class func getObservationsForImmune(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        var detailsArray: [Int] = []
        let environmentIs = Constants.Api.versionUrl
        let  lngId = UserDefaults.standard.integer(forKey: "lngId")
        if environmentIs.contains("stageapi") {
            if lngId == 1 {
                detailsArray = [59, 1952, 1956, 1957, 1955]
            }
            else if lngId == 3{
                detailsArray = [59]
            }
            else if lngId == 4{
                detailsArray = [59]
            }
            else
            {
                detailsArray = [59 , 57]
            }
       
        } else if environmentIs.contains("devapi") {
            detailsArray = [59, 1870, 1873, 1874, 1875]
            
        } else {
            detailsArray = [59, 2033, 2035, 2030, 2034]
        }
        
        switch countryID {
            
        case 40: observations = detailsArray
            break
        case 35: observations = [59,57]
            break
        default: break
            
        }
        return observations!
    }
    class func getObservationsForImmuneTr(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        var detailsArray: [Int] = []
        
        let environmentIs = Constants.Api.versionUrl
        
        if environmentIs.contains("stageapi") {
            detailsArray = [643,641,645,647,650,1960 ,1958]
       
        } else if environmentIs.contains("devapi") {
            detailsArray = [643,641,645,647,650,1878 ,1876] // 1876
            
        } else {
            detailsArray = [643,641,645,647,650 ,2036 , 2037] // need to change this for production.
        }
                
        switch countryID {
            
        case 40: observations = detailsArray
            break
        case 35: observations = [643,645,650]
            break
        default: break
            
        }
        return observations!
    }
    
    class func getobservationsSkeletal(countryID: Int) -> Array<Int> {
        
//        var observations: Array<Int>?
//        
//        switch countryID {
//            
//        case 40: observations = [2,3,4,5,6,7,8,9,12]
//            break
//        case 35: observations = [1,4,7,14]
//            break
//        default: break
//            
//        }
//        return observations!
        
        
        var detailsArray: [Int] = []
        let environmentIs = Constants.Api.versionUrl
        let  lngId = UserDefaults.standard.integer(forKey: "lngId")
        if environmentIs.contains("stageapi") {
            if lngId == 1 {
                detailsArray = [1,2,3,4,5,6,7,8,9,12]
            }
            else if lngId == 3{
                detailsArray = [2,3,4,5,6,7,8,9,12]
            }
            else if lngId == 4{
                detailsArray = [2,3,4,5,6,7,8,9,12]
            }
       
        } else if environmentIs.contains("devapi") {
            detailsArray = [1,2,3,4,5,6,7,8,9,12]

        } else {
            detailsArray = [1,2,3,4,5,6,7,8,9,12]
        }
        
        return detailsArray
        
        
        
    }
    class func getobservationsSkeletalTr(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 40: observations = [596,597,598,599,600,601,602,603]
            break
        case 35: observations = [596,601]
            break
            
        default: break
            
        }
        return observations!
    }
    
    class func getObservationsResp(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 40: observations = [49,50,51]
            break
        case 35: observations = [50,51]
            break
        default: break
            
        }
        return observations!
    }
    class func getObservationsRespTr(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 40: observations = [635,636,637,638,639,640]
            break
        case 35: observations = [636,637]
            break
            
        default: break
            
        }
        return observations!
    }
    class func getObservationsGITract(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 40: observations = [32,34,29,31,27,33,28,37,35]
            break
        case 35: observations = [32,34,29,31,27,28,38,41]
            break
        default: break
            
        }
        return observations!
    }
    
    class func getObservationsGITractTr(countryID: Int) -> Array<Int> {
        
        var observations: Array<Int>?
        
        switch countryID {
            
        case 40: observations = [622,619,621,617,623,675,627,632,633,624]
            break
        case 35: observations = [622,624,619,621,617,618]
            break
        default: break
            
        }
        return observations!
    }
}

func nameCrop(inputSting: [String]) -> [String] {
    
    var observationsNames = [String]()
    for Nme in inputSting{
        var frNme1 = Nme as NSString
        frNme1 = frNme1.length > 17 ? NSString(format:"\(frNme1.substring(to: 17)).." as NSString) : frNme1
        observationsNames.append(frNme1 as String)
    }
    return observationsNames
}

class CalculationError: NSObject {
    static var hasError: Bool = false
}

func customString(inputStr: String) -> NSMutableAttributedString {
    let string = inputStr
    let attributedString = NSMutableAttributedString(string: string)
    
    let attributes = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.boldSystemFont(ofSize: 14)]
    let attributesLast = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 10)]
    
    if inputStr.count == 14{
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(attributes), range: NSRange(location: 0, length: 13))
    }
    if inputStr.count == 15{
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(attributes), range: NSRange(location: 0, length: 14))
    }
    if inputStr.count > 15 {
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(attributes), range: NSRange(location: 0, length: 14))
        attributedString.addAttributes(convertToNSAttributedStringKeyDictionary(attributesLast), range: NSRange(location: 15, length: inputStr.count-15))
    }
    return attributedString
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

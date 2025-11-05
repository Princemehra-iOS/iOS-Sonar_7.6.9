//
//  UtilityClass.swift
//  Zoetis -Feathers
//
//  Created by Pradeep Dahiya on 18/04/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation

class UtilityClass: NSObject {
    
    class var sharedInstance: AllValidSessions {
        struct Static {
            static let instance: AllValidSessions = AllValidSessions()
        }
        return Static.instance
    }
    
    class func sortArrayForKey(key: String ,unsortedArray: NSArray) {
        UtilityClass.setTopSessionIDs(sessionDataArray: unsortedArray as NSArray)
    }
    
    class func setTopSessionIDs(sessionDataArray: NSArray) {
        
        for i in 0..<sessionDataArray.count {
            let date = (sessionDataArray.object(at: i) as AnyObject).value(forKey: "sessiondate")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            let date1 = dateFormatter.date(from: date as! String)
            let date2 = dateFormatter.date(from: AllValidSessions.sharedInstance.complexDate as String)
            switch date1?.compare(date2!) {
            case .orderedAscending?     :   print("Date A is earlier than date B")
                AllValidSessions.sharedInstance.allValidSession.add((sessionDataArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
                break
            case .orderedDescending?    :   print("Date A is later than date B")
                break
            case .orderedSame?          :   print("The two dates are the same")
                AllValidSessions.sharedInstance.allValidSession.add((sessionDataArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
                break
            case .none: break
                
            }
        } 
    }
    class func sortArrayForDictKey(key: String ,unsortedArray: NSArray) {
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: key, ascending: true)
        var sortedResults = unsortedArray.sortedArray(using: [descriptor]) as NSArray
        //sortedResults = sortedResults.reversed() as NSArray
        UtilityClass.setupSessionIDs(rawArray: sortedResults)
    }
    class func setupSessionIDs(rawArray: NSArray) {
        for i in 0..<rawArray.count {
            AllValidSessions.sharedInstance.allValidSession.add((rawArray.object(at: i) as AnyObject).value(forKey: "postingId")!)
        }
    }
    class func removeDuplicates(_ array: Array<String>) -> Array<String> {
        var encountered = Set<String>()
        var result = Array<String>()
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        
        return result 
    }
    class func convertDateFormater(_ date: String) -> String{
        if date != "" && Regions.languageID == 3{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = Constants.ddMMyyyStr
            return  dateFormatter.string(from: date!)
        }
        else {
            return date
        }
    }
}

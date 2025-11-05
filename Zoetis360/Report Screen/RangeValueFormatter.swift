//
//  RangeValueFormatter.swift
//  Zoetis -Feathers
//
//  Created by   on 05/07/17.
//  Copyright © 2017   . All rights reserved.
//

import Foundation
import Charts

class RangeValueFormatter: NSObject,IAxisValueFormatter {
    
    var xAxisLabel = [String]()
    
    func initWithXlabelArray(labelArray: [String])  {
        xAxisLabel = labelArray
        
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return xAxisLabel[Int(value)]
    }
}

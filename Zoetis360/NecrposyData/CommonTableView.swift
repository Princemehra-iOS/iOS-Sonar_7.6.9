//
//  CommonTableView.swift
//  CommonTableView
//
//  Created by "" on 02/09/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
// MARK: 🟠 - PROTOCOLS & FUNCTIONS
protocol CommonTableViewDelegate{
    
    func leftController(_ leftController: CommonTableView, didSelectTableView tableView: UITableView ,idenitifier:String ,indexValue :String)
    func SwitchButton(_ butonTag:Int)
    
}

class CommonTableView: NSObject,UITableViewDataSource,UITableViewDelegate{
    
    // MARK: 🟠 - VARIABLES
    var items: [AnyObject] = []
    var cellIdentifier: String = ""
    var tblTag : Int
    
    var delegate: CommonTableViewDelegate?
    
    // MARK: 🟠 - METHODS AND FUNCTIONS
    init(items: [AnyObject]!, cellIdentifier: String! ,tableViewTag :Int) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.tblTag = tableViewTag
        
        super.init()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell:StartNecropsyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StartNecropsyTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.dataLabel.text = items[indexPath.row] as? String
   
        return cell
    }
    
    func switchValueDidChange(_ sender:UISwitch!)
    {
        let  value : Int = sender.tag
        self.delegate?.SwitchButton(value)
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let str = items[indexPath.row] as! String
        let cell:StartNecropsyTableViewCell = tableView.cellForRow(at: indexPath) as! StartNecropsyTableViewCell
        
        cell.bgView.backgroundColor = UIColor.lightGray
        cell.bgView.backgroundColor = UIColor(red: 0.0039, green: 0.7569, blue: 0.8392, alpha: 1.0)
      
        self.delegate?.leftController(self, didSelectTableView: tableView , idenitifier:cellIdentifier,indexValue:str)
    }
    
    // MARK: 🟠 - TABLE VIEW DATA SOURCE AND DELEGATES
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:StartNecropsyTableViewCell = tableView.cellForRow(at: indexPath) as! StartNecropsyTableViewCell
        cell.bgView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
}

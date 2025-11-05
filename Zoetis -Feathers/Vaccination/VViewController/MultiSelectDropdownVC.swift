//
//  MultiSelectDropdownVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 08/05/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class MultiSelectDropdownVC: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var multiSelectTblVw: UITableView!
    
    // MARK: - VARIABLES
    
    var rolesArr = [DropwnMasterDataVM]()
    var defaultRoles = [DropwnMasterDataVM]()
    var curentCertification:VaccinationCertificationVM?
    var indexPath:IndexPath?
    var employeeId:String?
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        registerTblVwCells()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.doneAction(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(self.cancelAction(sender:)))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        selectDefaultRoles()
    }
    
    // MARK: - METHODS AND OBJC SELECTORS
    
    func selectDefaultRoles(){
        var i = 0
        for role in defaultRoles {
            let index = rolesArr.firstIndex(where: {
                $0.id == role.id
            })
            if index != nil{
                rolesArr[index!] = defaultRoles[i]
            }
            i += 1
        }
    }
    
    @objc func doneAction(sender: UIBarButtonItem) {
        // Add the
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func cancelAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerTblVwCells(){
        multiSelectTblVw.delegate = self
        multiSelectTblVw.dataSource = self
        
        multiSelectTblVw.register(SelectEmployeePopoverTableViewCell.nib, forCellReuseIdentifier: SelectEmployeePopoverTableViewCell.identifier)
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func checkBxAction(_ sender: UIButton) {
        if rolesArr.count > 0 && rolesArr.count > sender.tag{
            var dropdownElement  = rolesArr[sender.tag]
            dropdownElement.isSelected = !dropdownElement.isSelected
            rolesArr[sender.tag] = dropdownElement
            self.multiSelectTblVw.beginUpdates()
            self.multiSelectTblVw.reloadRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .automatic)
            self.multiSelectTblVw.endUpdates()
            
            let arr = self.rolesArr.filter{
                $0.isSelected
            }
            let  selectedValArr = arr.map{ $0.value ?? ""}
            let encoder = JSONEncoder()
            var selectedObjStr  = ""
            let dataObj = try? encoder.encode(arr)
            if dataObj != nil{
                let str = NSString(data: dataObj!, encoding: String.Encoding.utf8.rawValue)
                selectedObjStr = str as String?  ?? ""
            }
            let selectedValStr =  selectedValArr.joined(separator: ", ")
          
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateEmployeeRoles"), object: nil, userInfo: ["index":indexPath?.row, "selectedValue":selectedValStr, "selectedObjStr": selectedObjStr])
        }
    }
}

// MARK: - EXTENSION AND TABLE VIEW DATA SOURCE

extension  MultiSelectDropdownVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rolesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SelectEmployeePopoverTableViewCell.identifier, for: indexPath) as? SelectEmployeePopoverTableViewCell{
            if rolesArr.count > 0  && rolesArr.count > indexPath.row{
                cell.checkBxBtn.tag = indexPath.row
                cell.checkBxBtn.addTarget(self, action: #selector(checkBxAction)
                                          , for: .touchUpInside)
                cell.selectionStyle = .none
                cell.removeRoles()
                cell.dropdownVal = rolesArr[indexPath.row]
                cell.empNameLbl.text = rolesArr[indexPath.row].value
                if rolesArr[indexPath.row].isSelected{
                    cell.checkBxBtn.setImage(UIImage.init(named: "checked_box_square"), for: .normal)
                } else{
                    cell.checkBxBtn.setImage(UIImage.init(named: "unchecked_box_square"), for: .normal)
                }
                if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                    cell.enableOrDisable(false)
                } else{
                    cell.enableOrDisable( true)
                }
                cell.setConstraintValues()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

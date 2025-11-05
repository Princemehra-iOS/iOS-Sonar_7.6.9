//
//  SelectEmployeePopoverVC.swift
//  Zoetis -Feathers
//
//  Created by Rishabh Gulati Mobile Programming on 22/04/20.
//  Copyright © 2020 . All rights reserved.
//
//
import UIKit

class SelectEmployeePopoverVC: BaseViewController {
    
    // MARK: - IB ACTIONS
    
    @IBOutlet weak var colorHeaderVw: UIView!
    @IBOutlet weak var totalEmployeesCountLbl: UILabel!
    @IBOutlet weak var employeeTblVw: UITableView!
    @IBOutlet weak var employeesCountVw: UIView!
    
    // MARK: - VARIABLES
    
    var curentCertification:VaccinationCertificationVM?
    var categoryEmployees = [VaccinationEmployeeVM]()
    var questionnaireSectionIndex:Int?
    var selectedTab:Int?
    var employeesAddedArr = [VaccinationEmployeeVM]()
    var isMultiSelectDropdown = false
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        registerTblVwCells()
        totalEmployeesCountLbl.text = "Total Employees: \(employeesAddedArr.count)"
        
        colorHeaderVw.setGradient(topGradientColor: UIColor.getDashboardTableHeaderLowerGradColor(), bottomGradientColor:UIColor.getDashboardTableHeaderUpperGradColor())
        
        markSelectedEmployees()
        
        self.view.setNeedsDisplay()
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - INITIAL UI SETUP
    
    func markSelectedEmployees(){
        var i = 0
        for emp in categoryEmployees{
            let index = employeesAddedArr.firstIndex(where: {
                $0.employeeId == emp.employeeId
            })
            if index != nil{
                var emp = employeesAddedArr[index!]
                emp.isSelected = true
                employeesAddedArr[index!] = emp
            }
            i += 1
        }
    }
    
    
    func registerTblVwCells(){
        employeeTblVw.delegate = self
        employeeTblVw.dataSource = self
        
        employeeTblVw.register(SelectEmployeePopoverTableViewCell.nib, forCellReuseIdentifier: SelectEmployeePopoverTableViewCell.identifier)
    }
    
    @objc func checkEmployee(_ sender: UIButton){
        let index = sender.tag
        
        var emp = employeesAddedArr[index]
        emp.isSelected = !emp.isSelected
        employeesAddedArr[index] =  emp
        self.employeeTblVw.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateEmployeeSelection"), object: nil, userInfo: ["index":questionnaireSectionIndex, "emp":emp, "tabSelection":selectedTab, "isSelected":emp.isSelected])
        
    }
    
}

// MARK: - EXTENSION FOR TABLE VIEW DATA SOURCE AND DELEGATE

extension SelectEmployeePopoverVC:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   employeesAddedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SelectEmployeePopoverTableViewCell.identifier, for: indexPath) as? SelectEmployeePopoverTableViewCell{
            if employeesAddedArr.count > 0 && employeesAddedArr.count > indexPath.row{
                cell.setValues(employeesAddedArr[indexPath.row])
                cell.checkBxBtn.tag = indexPath.row
                cell.checkBxBtn.addTarget(self, action: #selector (checkEmployee(_:)), for: .touchUpInside)
            }
            cell.selectionStyle = .none
            if curentCertification?.certificationStatus == VaccinationCertificationStatus.submitted.rawValue{
                cell.enableOrDisable(false)
            } else{
                cell.enableOrDisable( true)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

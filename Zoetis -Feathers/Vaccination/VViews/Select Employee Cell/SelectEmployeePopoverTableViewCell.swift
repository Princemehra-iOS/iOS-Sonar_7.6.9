//
//  SelectEmployeePopoverTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 22/04/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class SelectEmployeePopoverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBxLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var roleVw: UIView!
    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var checkBxBtn: UIButton!
    
    static let identifier = "selectEmployeePopoverTableViewCell"
    var dropdownVal:DropwnMasterDataVM?
    var isMultiSelectDropdownModeEnabled = false
    var empObj:VaccinationEmployeeVM?
    class var classIdentifier: String {
         return String(describing: self)
     }
     
     class var nib: UINib {
        return UINib(nibName: classIdentifier, bundle: nil)
    }
    
    
    func setConstraintValues(){
        if dropdownVal != nil{
            checkBxLeadingConstraint.constant = 5
        } else{
         checkBxLeadingConstraint.constant = 20
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func removeRoles(){
        if roleLbl != nil && roleVw != nil{
             stackVw.removeArrangedSubview(roleLbl)
                   stackVw.removeArrangedSubview(roleVw)
                   
                   roleLbl.removeFromSuperview()
                   roleVw.removeFromSuperview()
            
        }
       
    }
    
    func setValues(_ empObj:VaccinationEmployeeVM){
        
        self.empObj = empObj
        var nameArr = [String]()
        nameArr.append(empObj.firstName ?? "")
        nameArr.append(empObj.middleName ?? "")
        nameArr.append(empObj.lastName ?? "")
        let name = nameArr.joined(separator: " ")
        empNameLbl.text = name
        roleLbl.text = empObj.selectedRolesStr
        
        if empObj.isSelected{
            checkBxBtn.setImage(UIImage.init(named: "checked_box_square"), for: .normal)
        } else{
            checkBxBtn.setImage(UIImage.init(named: "unchecked_box_square"), for: .normal)
        }
        
        
    }
    
    func enableOrDisable(_ flag:Bool){
        checkBxBtn.isUserInteractionEnabled = flag
    }
    
    func selectMultiSelectDropdown(){
        print(appDelegateObj.testFuntion())
    }

    @IBAction func checkBxAction(_ sender: UIButton){
        print(appDelegateObj.testFuntion())
    }
    
    
}

//
//  VaccinationEmployeeVM.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation

public struct VaccinationEmployeeVM{
    var siteId:String?
    var certificationId:String?
    var customerId:String?
    var employeeId:String?
    var firstName :String?
    var middleName:String?
    var lastName:String?
    var userId:String?
    var rolesArrStr:String?
    var selectedRolesStr:String?
    var selectedTshirtId:String?
    var selectedTshirtValue:String?
    var selectedLangId:String = "1"
    var selectedLangValue:String = "English"
    var isSelected: Bool = false
    var questionaireCategory: String?
    var sortOrder: Int32?
    var signBase64:String?
    var startDate:String?
    var selectedUserId:String?
    var createdDate:Date?
}

//
//  QuesionnaireVMModels.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 16/04/20.
//  Copyright © 2020 Rishabh Gulati. All rights reserved.
//

import Foundation

public struct VaccinationQuestionCategoryVM{
    var categoryId:String?
    var categoryName:String?
    var typeId:String?
    var typeName:String?
    var userId: String?
    var certificationId:String?
    var questionArr:[VaccinationQuestionVM]?
    var employees:[VaccinationEmployeeVM]?
}

public struct VaccinationQuestionTypeVM{
    var typeId:String?
    var typeName:String?
    var userId:String?
    var certificationId:String?
    var questionCategories:[VaccinationQuestionCategoryVM]?
}

public struct VaccinationQuestionVM{
    var certificationId:String?
    var categoryId:String?
    var categoryName:String?
    var questionDescription:String?
    var questionId:String?
    var questionType:String?
    var typeId:String?
    var typeName:String?
    var userId: String?
    var locationPhone: String?
    var selectedResponse:Bool = false
    var userComments: String?
    var sequenceNo:Int?
}

public struct QuestionnaireVM{
    var questionTypeObj: [VaccinationQuestionTypeVM]?
}

public struct VaccinationEmployeeCategoryVM{
    var certificationId:String?
    var employeeId:String?
    var questionCategoryId:String?
    var userId:String?
}

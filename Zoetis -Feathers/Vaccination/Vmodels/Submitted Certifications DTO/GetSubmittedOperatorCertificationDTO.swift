import Foundation

class GetSubmittedOperatorCertificationDTO: Codable {
    var typeID, catID: Int?
    var moduleAssessments: [GetSubmittedModuleAssessmentsDTO]?
    var attendeeList: [GetCertificationAttendeeListDTO]?
    var categorieName: String?

    enum CodingKeys: String, CodingKey {
        case typeID = "TypeId"
        case catID = "catId"
        case moduleAssessments = "ModuleAssessments"
        case attendeeList = "AttendeeList"
        case categorieName = "CategorieName"
    }

    init(typeID: Int?, catID: Int?, moduleAssessments: [GetSubmittedModuleAssessmentsDTO]?, attendeeList: [GetCertificationAttendeeListDTO]?, categorieName: String?) {
        self.typeID = typeID
        self.catID = catID
        self.moduleAssessments = moduleAssessments
        self.attendeeList = attendeeList
        self.categorieName = categorieName
    }
}


import Foundation
struct GetSubmittedVaccineMixingCertificationDTO : Codable {
	let catId : Int?
	let categorieName : String?
	let typeId : Int?
	let moduleAssessments : [GetSubmittedModuleAssessmentsDTO]?
	let attendeeList : [GetCertificationAttendeeListDTO]?

	enum CodingKeys: String, CodingKey {
		case catId = "catId"
		case categorieName = "CategorieName"
		case typeId = "TypeId"
		case moduleAssessments = "ModuleAssessments"
		case attendeeList = "AttendeeList"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		catId = try values.decodeIfPresent(Int.self, forKey: .catId)
		categorieName = try values.decodeIfPresent(String.self, forKey: .categorieName)
		typeId = try values.decodeIfPresent(Int.self, forKey: .typeId)
		moduleAssessments = try values.decodeIfPresent([GetSubmittedModuleAssessmentsDTO].self, forKey: .moduleAssessments)
		attendeeList = try values.decodeIfPresent([GetCertificationAttendeeListDTO].self, forKey: .attendeeList)
	}

}

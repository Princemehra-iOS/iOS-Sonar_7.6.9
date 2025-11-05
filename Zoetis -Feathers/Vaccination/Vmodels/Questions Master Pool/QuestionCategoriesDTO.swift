import Foundation
struct QuestionCategoriesDTO : Codable {
	let catId : Int?
	let categorieName : String?
	let moduleAssessments : [ModuleAssessmentsDTO]?

	enum CodingKeys: String, CodingKey {

		case catId = "catId"
		case categorieName = "CategorieName"
		case moduleAssessments = "ModuleAssessments"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		catId = try values.decodeIfPresent(Int.self, forKey: .catId)
		categorieName = try values.decodeIfPresent(String.self, forKey: .categorieName)
		moduleAssessments = try values.decodeIfPresent([ModuleAssessmentsDTO].self, forKey: .moduleAssessments)
	}

}


import Foundation
struct CertificateQuestionTypesInternalDTO : Codable {
	let typeId : Int?
	let typeName : String?
	let questionCategories : [QuestionCategoriesDTO]?

	enum CodingKeys: String, CodingKey {

		case typeId = "TypeId"
		case typeName = "TypeName"
		case questionCategories = "QuestionCategories"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		typeId = try values.decodeIfPresent(Int.self, forKey: .typeId)
		typeName = try values.decodeIfPresent(String.self, forKey: .typeName)
		questionCategories = try values.decodeIfPresent([QuestionCategoriesDTO].self, forKey: .questionCategories)
	}

}

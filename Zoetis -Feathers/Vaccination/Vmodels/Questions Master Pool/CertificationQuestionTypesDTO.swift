
import Foundation
struct CertificationQuestionTypesDTO : Codable {
	let certificateQuestionTypes : [CertificateQuestionTypesInternalDTO]?

	enum CodingKeys: String, CodingKey {
		case certificateQuestionTypes = "CertificateQuestionTypes"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		certificateQuestionTypes = try values.decodeIfPresent([CertificateQuestionTypesInternalDTO].self, forKey: .certificateQuestionTypes)
	}

}

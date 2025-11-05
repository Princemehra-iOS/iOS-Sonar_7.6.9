
import Foundation
struct MasterQuestionsDTO : Codable {
	let isSuccess : Bool?
	let statusCode : Int?
	let displayMessage : String?
	let responseData : CertificationQuestionTypesDTO?
	let exceptionMessage : String?

	enum CodingKeys: String, CodingKey {

		case isSuccess = "IsSuccess"
		case statusCode = "StatusCode"
		case displayMessage = "DisplayMessage"
		case responseData = "ResponseData"
		case exceptionMessage = "ExceptionMessage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		isSuccess = try values.decodeIfPresent(Bool.self, forKey: .isSuccess)
		statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
		displayMessage = try values.decodeIfPresent(String.self, forKey: .displayMessage)
		responseData = try values.decodeIfPresent(CertificationQuestionTypesDTO.self, forKey: .responseData)
		exceptionMessage = try values.decodeIfPresent(String.self, forKey: .exceptionMessage)
	}

}

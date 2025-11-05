
import Foundation
struct PlateTypesDTO : Codable {
	let id : Int?
	let text : String?

	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case text = "Text"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		text = try values.decodeIfPresent(String.self, forKey: .text)
	}

}

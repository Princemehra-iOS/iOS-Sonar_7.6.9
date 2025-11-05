
import Foundation
struct MasterDataTypesDTO : Codable {
	let languagesList : [LanguagesListDTO]?
	let tshirtSizesList : [TshirtSizesListDTO]?
    let userRoles : [UserRolesDTO]?

	enum CodingKeys: String, CodingKey {

		case languagesList = "LanguagesList"
		case tshirtSizesList = "TshirtSizesList"
        case userRoles = "UserRoles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		languagesList = try values.decodeIfPresent([LanguagesListDTO].self, forKey: .languagesList)
		tshirtSizesList = try values.decodeIfPresent([TshirtSizesListDTO].self, forKey: .tshirtSizesList)
        userRoles = try values.decodeIfPresent([UserRolesDTO].self, forKey: .userRoles)
	}

}


import Foundation
struct RolesDTO : Codable {
	let roleId : Int?
	let roleName : String?

	enum CodingKeys: String, CodingKey {

		case roleId = "RoleId"
		case roleName = "RoleName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		roleId = try values.decodeIfPresent(Int.self, forKey: .roleId)
		roleName = try values.decodeIfPresent(String.self, forKey: .roleName)
	}

}

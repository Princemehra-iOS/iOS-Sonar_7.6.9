import Foundation
struct EmployeesInformationDTO : Codable {
	let id : Int?
	let firstName : String?
	let middleName : String?
	let lastName : String?
	let roles : [RolesDTO]?

	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case firstName = "FirstName"
		case middleName = "MiddleName"
		case lastName = "LastName"
		case roles = "Roles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		middleName = try values.decodeIfPresent(String.self, forKey: .middleName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		roles = try values.decodeIfPresent([RolesDTO].self, forKey: .roles)
	}

}

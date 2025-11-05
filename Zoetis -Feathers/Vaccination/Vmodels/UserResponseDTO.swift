
public struct UserResponseDTO : Codable {
	let id : String?
	let birdTypeId : String?
	let issued : String?//
	let phone : String?
	let nonUSCountryId : String?
	let countryId : String?
	let lastName : String?
	let roleIds : String?
	let userTypeId : String?
	let firstName : String?
	let roleId : String?
	let status : String?
	let complexId : String?
	let termAccepted : String?
	let uMMId : String?
	let expires_in : Int?
	let expires : String?//
	let token_type : String?
	let hasQuates : String?
	let complexTypeId : String?
	let hasAccess : String?
	let access_token : String?

	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case birdTypeId = "BirdTypeId"
		case issued = ".issued"
		case phone = "Phone"
		case nonUSCountryId = "NonUSCountryId"
		case countryId = "CountryId"
		case lastName = "LastName"
		case roleIds = "RoleIds"
		case userTypeId = "UserTypeId"
		case firstName = "FirstName"
		case roleId = "RoleId"
		case status = "Status"
		case complexId = "ComplexId"
		case termAccepted = "TermAccepted"
		case uMMId = "UMMId"
		case expires_in = "expires_in"
		case expires = ".expires"
		case token_type = "token_type"
		case hasQuates = "HasQuates"
		case complexTypeId = "ComplexTypeId"
		case hasAccess = "HasAccess"
		case access_token = "access_token"
	}

    public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		birdTypeId = try values.decodeIfPresent(String.self, forKey: .birdTypeId)
		issued = try values.decodeIfPresent(String.self, forKey: .issued)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		nonUSCountryId = try values.decodeIfPresent(String.self, forKey: .nonUSCountryId)
		countryId = try values.decodeIfPresent(String.self, forKey: .countryId)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		roleIds = try values.decodeIfPresent(String.self, forKey: .roleIds)
		userTypeId = try values.decodeIfPresent(String.self, forKey: .userTypeId)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		roleId = try values.decodeIfPresent(String.self, forKey: .roleId)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		complexId = try values.decodeIfPresent(String.self, forKey: .complexId)
		termAccepted = try values.decodeIfPresent(String.self, forKey: .termAccepted)
		uMMId = try values.decodeIfPresent(String.self, forKey: .uMMId)
		expires_in = try values.decodeIfPresent(Int.self, forKey: .expires_in)
		expires = try values.decodeIfPresent(String.self, forKey: .expires)
		token_type = try values.decodeIfPresent(String.self, forKey: .token_type)
		hasQuates = try values.decodeIfPresent(String.self, forKey: .hasQuates)
		complexTypeId = try values.decodeIfPresent(String.self, forKey: .complexTypeId)
		hasAccess = try values.decodeIfPresent(String.self, forKey: .hasAccess)
		access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
	}

}

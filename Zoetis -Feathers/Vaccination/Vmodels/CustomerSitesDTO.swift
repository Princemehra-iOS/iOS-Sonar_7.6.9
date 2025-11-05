import Foundation
struct CustomerSitesDTO : Codable {
	let customerId : Int?
	let siteId : Int?
	let siteName : String?

	enum CodingKeys: String, CodingKey {

		case customerId = "CustomerId"
		case siteId = "SiteId"
		case siteName = "SiteName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
		siteId = try values.decodeIfPresent(Int.self, forKey: .siteId)
		siteName = try values.decodeIfPresent(String.self, forKey: .siteName)
	}

}

struct FSMListDTO : Codable {
    let fsmId : Int?
    let fsmName : String?

    enum CodingKeys: String, CodingKey {

        case fsmId = "Id"
        case fsmName = "Text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fsmId = try values.decodeIfPresent(Int.self, forKey: .fsmId)
        fsmName = try values.decodeIfPresent(String.self, forKey: .fsmName)
    }

}

struct StateListDTO : Codable {
    let stateId : Int?
    let stateName : String?
    
    enum CodingKeys: String, CodingKey {
        
        case stateId = "StateId"
        case stateName = "StateName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        stateId = try values.decodeIfPresent(Int.self, forKey: .stateId)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
    }
    
}
    struct CountryListDTO : Codable {
        let countryId : Int?
        let countryNamee : String?
        let regionId : Int?
        enum CodingKeys: String, CodingKey {
            
            case regionId = "RegionId"
            case countryId = "CountryId"
            case countryNamee = "CountryName"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
         
            countryId = try values.decodeIfPresent(Int.self, forKey: .countryId)
            countryNamee = try values.decodeIfPresent(String.self, forKey: .countryNamee)
            regionId = try values.decodeIfPresent(Int.self, forKey: .regionId)
        }
        
    }



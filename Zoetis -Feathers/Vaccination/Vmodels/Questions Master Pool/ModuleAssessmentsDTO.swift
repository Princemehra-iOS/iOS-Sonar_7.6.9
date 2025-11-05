import Foundation
struct ModuleAssessmentsDTO : Codable {
	let id : Int?
	let assessment : String?
	let assessment2 : String?
	let minScore : String?
	let midScore : String?
	let maxScore : String?
	let types : String?
	let pVEVaccType : String?
	let moduleCatId : Int?
	let isDeleted : Bool?
	let addValue : Bool?
	let information : String?
	let folderPath : String?
	let imageName : String?
    let sequenceNo : Int?
	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case assessment = "Assessment"
		case assessment2 = "Assessment2"
		case minScore = "MinScore"
		case midScore = "MidScore"
		case maxScore = "MaxScore"
		case types = "Types"
		case pVEVaccType = "PVEVaccType"
		case moduleCatId = "ModuleCatId"
		case isDeleted = "IsDeleted"
		case addValue = "AddValue"
		case information = "Information"
		case folderPath = "FolderPath"
		case imageName = "ImageName"
        case sequenceNo = "SequenceNo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		assessment = try values.decodeIfPresent(String.self, forKey: .assessment)
		assessment2 = try values.decodeIfPresent(String.self, forKey: .assessment2)
		minScore = try values.decodeIfPresent(String.self, forKey: .minScore)
		midScore = try values.decodeIfPresent(String.self, forKey: .midScore)
		maxScore = try values.decodeIfPresent(String.self, forKey: .maxScore)
		types = try values.decodeIfPresent(String.self, forKey: .types)
		pVEVaccType = try values.decodeIfPresent(String.self, forKey: .pVEVaccType)
		moduleCatId = try values.decodeIfPresent(Int.self, forKey: .moduleCatId)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		addValue = try values.decodeIfPresent(Bool.self, forKey: .addValue)
		information = try values.decodeIfPresent(String.self, forKey: .information)
		folderPath = try values.decodeIfPresent(String.self, forKey: .folderPath)
		imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        sequenceNo = try values.decodeIfPresent(Int.self, forKey: .sequenceNo)
	}

}

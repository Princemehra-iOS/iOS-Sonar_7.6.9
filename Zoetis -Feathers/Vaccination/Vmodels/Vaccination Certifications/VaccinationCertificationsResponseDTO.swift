
import Foundation
struct VaccinationCertificationsResponseDTO : Codable {
	let id : Int?
	let scheduleDate : String?
	let customerId : Int?
	let customerName : String?
	let siteId : Int?
	let siteName : String?
	let fSMId : Int?
	let fSMName : String?
	let fSRId : Int?
	let fSRName : String?
	let certificateTypeId : Int?
	let certificateType : String?
	let isDeleted : Bool?
	let comments : String?
	let custShipping : String?
	let existingSite : Bool?
    let trainingStatus : Int?

	enum CodingKeys: String, CodingKey {

		case id = "Id"
		case scheduleDate = "ScheduleDate"
		case customerId = "CustomerId"
		case customerName = "CustomerName"
		case siteId = "SiteId"
		case siteName = "SiteName"
		case fSMId = "FSMId"
		case fSMName = "FSMName"
		case fSRId = "AssingToId"
		case fSRName = "AssignToName"
		case certificateTypeId = "CertificateTypeId"
		case certificateType = "CertificateType"
		case isDeleted = "IsDeleted"
		case comments = "Comments"
		case custShipping = "CustShipping"
		case existingSite = "ExistingSite"
        case trainingStatus = "TrainingStatus"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		scheduleDate = try values.decodeIfPresent(String.self, forKey: .scheduleDate)
		customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
		customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		siteId = try values.decodeIfPresent(Int.self, forKey: .siteId)
		siteName = try values.decodeIfPresent(String.self, forKey: .siteName)
		fSMId = try values.decodeIfPresent(Int.self, forKey: .fSMId)
		fSMName = try values.decodeIfPresent(String.self, forKey: .fSMName)
		fSRId = try values.decodeIfPresent(Int.self, forKey: .fSRId)
		fSRName = try values.decodeIfPresent(String.self, forKey: .fSRName)
		certificateTypeId = try values.decodeIfPresent(Int.self, forKey: .certificateTypeId)
		certificateType = try values.decodeIfPresent(String.self, forKey: .certificateType)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		comments = try values.decodeIfPresent(String.self, forKey: .comments)
		custShipping = try values.decodeIfPresent(String.self, forKey: .custShipping)
		existingSite = try values.decodeIfPresent(Bool.self, forKey: .existingSite)
        trainingStatus = try values.decodeIfPresent(Int.self, forKey: .trainingStatus)
	}

}

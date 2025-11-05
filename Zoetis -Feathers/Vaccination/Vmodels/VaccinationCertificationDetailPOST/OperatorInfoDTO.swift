
import Foundation
class OperatorInfoDTO : Codable {
	var Id : Int64?
	var FirstName : String?
	var MiddleName : String?
	var LastName : String?
	var Roles : [RolesTransferDTO]?
	var CustomerId : Int64?
	var SiteId : Int64?
    var FromDate:String?
    var CreatedBy:Int64?
    var LanguageId:Int64?
    var TshirtSizeId:Int64?
    var OperatorSignature:String?
    var OperatorUniqueId:String?
}

class ShippingAddressDTO: Codable {
    var fssName: String?
    var fssID, trainingID, siteId, id: Int?
    var city, address2: String? , countryName: String? , stateName: String? , siteName: String?
    var stateID,   countryID: Int?
    var address1, pincode: String?
    var adddressType : Bool?

    enum CodingKeys: String, CodingKey {
        case fssName = "FSSName"
        case fssID = "FSSId"
        case trainingID = "TrainingId"
        case id = "Id"
        case city = "City"
        case address2 = "Address2"
        case stateID = "StateId"
        case countryID = "CountryId"
        case address1 = "Address1"
        case pincode = "Pincode"
        case countryName = "CountryName"
        case stateName = "StateName"
        case adddressType = "IsOther"
        case siteId = "SiteId"
        case siteName = "SiteName"
    }

    init(config: TraningCertificationDataModels.ShippingAddressConfig) {
        self.fssName = config.fssName
        self.fssID = config.fssID
        self.trainingID = config.trainingID
        self.id = config.id
        self.city = config.city
        self.address2 = config.address2
        self.stateID = config.stateID
        self.countryID = config.countryID
        self.address1 = config.address1
        self.pincode = config.pincode
        self.countryName = config.countryName
        self.stateName = config.stateName
        self.adddressType = config.addressTypeIs
        self.siteId = config.siteIdIs
        self.siteName = config.siteNameIs
    }
}


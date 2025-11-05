import Foundation

class GetSubmittedOperatorInfoDTO: Codable {
    var customerName: JSONNull?
    var languageName: String?
    var roles: [GetSubmittedRolesDTO]?
    var middleName: String?
    var certificateTypeList: [JSONAny]?
    var tshirtSize: String?
    var tshirtSizeID: Int?
    var certificateDate: JSONNull?
    var languageID, siteID: Int?
    var isSelected: Bool?
    var firstName, lastName: String?
    var hatcheryName: JSONNull?
    var categoriesList: String?
    var fromDate: String?
    var signatureBase64, operatorUniqueID: String?
    var customerID: Int?
    var signatureFilePath: String?
    var certificateName: JSONNull?
    var id: Int?
    var isRemoved: Bool?
    var signatureFileName: String?
    var toDate: JSONNull?

    enum CodingKeys: String, CodingKey {
        case customerName = "CustomerName"
        case languageName = "LanguageName"
        case roles = "Roles"
        case middleName = "MiddleName"
        case certificateTypeList = "CertificateTypeList"
        case tshirtSize = "TshirtSize"
        case tshirtSizeID = "TshirtSizeId"
        case certificateDate = "CertificateDate"
        case languageID = "LanguageId"
        case siteID = "SiteId"
        case isSelected = "IsSelected"
        case firstName = "FirstName"
        case lastName = "LastName"
        case hatcheryName = "HatcheryName"
        case categoriesList = "CategoriesList"
        case fromDate = "FromDate"
        case signatureBase64 = "SignatureBase64"
        case operatorUniqueID = "OperatorUniqueId"
        case customerID = "CustomerId"
        case signatureFilePath = "SignatureFilePath"
        case certificateName = "CertificateName"
        case id = "Id"
        case isRemoved = "IsRemoved"
        case signatureFileName = "SignatureFileName"
        case toDate = "ToDate"
    }

    // Refactored initializer using a dictionary
    init(data: [String: Any]) {
        self.customerName = data["CustomerName"] as? JSONNull
        self.languageName = data["LanguageName"] as? String
        self.roles = data["Roles"] as? [GetSubmittedRolesDTO]
        self.middleName = data["MiddleName"] as? String
        self.certificateTypeList = data["CertificateTypeList"] as? [JSONAny]
        self.tshirtSize = data["TshirtSize"] as? String
        self.tshirtSizeID = data["TshirtSizeId"] as? Int
        self.certificateDate = data["CertificateDate"] as? JSONNull
        self.languageID = data["LanguageId"] as? Int
        self.siteID = data["SiteId"] as? Int
        self.isSelected = data["IsSelected"] as? Bool
        self.firstName = data["FirstName"] as? String
        self.lastName = data["LastName"] as? String
        self.hatcheryName = data["HatcheryName"] as? JSONNull
        self.categoriesList = data["CategoriesList"] as? String
        self.fromDate = data["FromDate"] as? String
        self.signatureBase64 = data["SignatureBase64"] as? String
        self.operatorUniqueID = data["OperatorUniqueId"] as? String
        self.customerID = data["CustomerId"] as? Int
        self.signatureFilePath = data["SignatureFilePath"] as? String
        self.certificateName = data["CertificateName"] as? JSONNull
        self.id = data["Id"] as? Int
        self.isRemoved = data["IsRemoved"] as? Bool
        self.signatureFileName = data["SignatureFileName"] as? String
        self.toDate = data["ToDate"] as? JSONNull
    }
}

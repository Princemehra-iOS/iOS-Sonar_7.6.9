// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rejectedAssessmentModel = try? newJSONDecoder().decode(RejectedAssessmentModel.self, from: jsonData)

import Foundation

// MARK: - RejectedAssessmentModel
struct RejectedAssessmentModel: Codable {
    let success: Bool
    let statusCode: Int
    let message: String
    let data: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let assessmentID: Int
    let appAssessmentID, appCreationTime: String
    let displayID: JSONNull?
    let docID: ID
    let visitID: Int
    let customerName, visitName, incubationStyleName, roleName: String
    let roleName2, breedBirdsName, evaluationName, manufacturerName: String
    let eggsPerFlatName, flockAgeName, tsrName: String
    let saveTypeName: JSONNull?
    let userName, statusName, siteName: String
    let customerID, siteID, incubationStyle, evaluationID: Int
    let breedBirds: Int
    let evaluationDate: String
    let evaulaterID, tsrID: Int
    let approverName: String
    let hatchAnti, camera: Bool
    let manufacturerID, eggsPerFlat: Int
    let notes: String
    let flockAgeID, statusType, saveType, userID: Int
    let manufacturerOther, breedOfBirdsOther, eggsPerFlatOther,refrigeratorNote: String
    let deviceID: DeviceID
    let representativeName: String
    let roleID: Int
    let representativeName2: String
    let roleId2: Int
    let representativeNotes, signatureImage, signatureImage2, signatureDate: String
    let doubleSanitation, sanitationEmbrex, hasChlorineStrips, isAutomaticFail: Bool
    let rejectionComments: String
    let assessmentScoresPostingData: [AssessmentScoresPostingDatum]
    let assessmentCommentsPostingData: [AssessmentCommentsPostingDatum]
    let assessmentNotesData: [JSONAny]
    let inovojectPostingData: [InovojectPostingDatum]
    let dayOfAgePostingData: [DayOfAgePostingDatum]
    let dayAgeSubcutaneousDetailsPostingData: [DayAgeSubcutaneousDetailsPostingDatum]
    let vaccineMixerObservedPostingData: [VaccineMixerObservedPostingDatum]
    let vaccineMicroSamplesPostingData, vaccineResiduePostinData: [JSONAny]
    let sanitationEmbrexScoresPostinData: [SanitationEmbrexScoresPostinDatum]
    
    enum CodingKeys: String, CodingKey {
        case assessmentID = "AssessmentId"
        case appAssessmentID = "AppAssessmentId"
        case appCreationTime = "AppCreationTime"
        case displayID = "DisplayId"
        case docID = "DocId"
        case visitID = "VisitId"
        case customerName = "CustomerName"
        case visitName = "VisitName"
        case incubationStyleName = "IncubationStyleName"
        case roleName = "RoleName"
        case roleName2 = "RoleName2"
        case breedBirdsName = "BreedBirdsName"
        case evaluationName = "EvaluationName"
        case manufacturerName = "ManufacturerName"
        case eggsPerFlatName = "EggsPerFlatName"
        case flockAgeName = "FlockAgeName"
        case tsrName = "TSRName"
        case saveTypeName = "SaveTypeName"
        case userName = "UserName"
        case statusName = "StatusName"
        case siteName = "SiteName"
        case customerID = "CustomerId"
        case siteID = "SiteId"
        case incubationStyle = "IncubationStyle"
        case evaluationID = "EvaluationId"
        case breedBirds = "BreedBirds"
        case evaluationDate = "EvaluationDate"
        case evaulaterID = "EvaulaterId"
        case tsrID = "TSRId"
        case approverName = "ApproverName"
        case hatchAnti = "HatchAnti"
        case camera = "Camera"
        case manufacturerID = "ManufacturerId"
        case eggsPerFlat = "EggsPerFlat"
        case notes = "Notes"
        case flockAgeID = "FlockAgeId"
        case statusType = "Status_Type"
        case saveType = "SaveType"
        case userID = "UserId"
        case manufacturerOther = "ManufacturerOther"
        case breedOfBirdsOther = "BreedOfBirdsOther"
        case eggsPerFlatOther = "EggsPerFlatOther"
        case deviceID = "DeviceId"
        case representativeName = "RepresentativeName"
        case roleID = "RoleId"
        case representativeName2 = "RepresentativeName2"
        case roleId2 = "RoleId2"
        case representativeNotes = "RepresentativeNotes"
        case signatureImage = "SignatureImage"
        case signatureImage2 = "SignatureImage2"
        case signatureDate = "SignatureDate"
        case doubleSanitation = "DoubleSanitation"
        case sanitationEmbrex = "SanitationEmbrex"
        case hasChlorineStrips = "HasChlorineStrips"
        case isAutomaticFail = "IsAutomaticFail"
        case rejectionComments = "RejectionComments"
        case assessmentScoresPostingData = "AssessmentScoresPostingData"
        case assessmentCommentsPostingData = "AssessmentCommentsPostingData"
        case assessmentNotesData = "AssessmentNotesData"
        case inovojectPostingData = "InovojectPostingData"
        case dayOfAgePostingData = "DayOfAgePostingData"
        case dayAgeSubcutaneousDetailsPostingData = "DayAgeSubcutaneousDetailsPostingData"
        case vaccineMixerObservedPostingData = "VaccineMixerObservedPostingData"
        case vaccineMicroSamplesPostingData = "VaccineMicroSamplesPostingData"
        case vaccineResiduePostinData = "VaccineResiduePostinData"
        case sanitationEmbrexScoresPostinData = "SanitationEmbrexScoresPostinData"
        case refrigeratorNote = "RefrigeratorNote"
    }
}

// MARK: - AssessmentCommentsPostingDatum
struct AssessmentCommentsPostingDatum: Codable {
    let appAssessmentID: String
    let strUniqueID: JSONNull?
    let displayID: ID
    let assessmentDetailID, assessmentID: Int
    let assessmentComment: AssessmentComment
    let moduleID: Int
    let createdAt: String
    let userID: Int
    let deviceID: DeviceID
    
    enum CodingKeys: String, CodingKey {
        case appAssessmentID = "AppAssessmentId"
        case strUniqueID = "StrUniqueId"
        case displayID = "DisplayId"
        case assessmentDetailID = "AssessmentDetailId"
        case assessmentID = "AssessmentId"
        case assessmentComment = "AssessmentComment"
        case moduleID = "ModuleId"
        case createdAt = "CreatedAt"
        case userID = "UserId"
        case deviceID = "DeviceId"
    }
}

enum AssessmentComment: String, Codable {
    case empty = ""
    case k = "K"
    case testing = "Testing"
    case uuiu = "Uuiu"
}

enum DeviceID: String, Codable {
    case the07072021163915_1_IOS9F6B7C009C944F15BAA463BE77C9B3A2 = "07072021163915_1_iOS_9F6B7C00-9C94-4F15-BAA4-63BE77C9B3A2"
}

enum ID: String, Codable {
    case c07072021163915 = "C-07072021163915"
}

// MARK: - AssessmentScoresPostingDatum
struct AssessmentScoresPostingDatum: Codable {
    let assessmentID: Int
    let assessmentDetailID, strUniqueID: JSONNull?
    let displayID: ID
    
    let appAssessmentID: String
    let moduleAssessmentID, questionCategoriesID, assessmentScore: Int
    let assessmentType: JSONNull?
    let qcCount: QCCount
    let isNA: Bool?
    let textAmPm: TextAmPm
    let personName: PersonName
    let frequencyValue: Int?
    let userID: Int
    let deviceID: DeviceID
    let notes: JSONNull?
    let createdAt: CreatedAt
    let colorCode: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case assessmentID = "AssessmentId"
        case assessmentDetailID = "AssessmentDetailId"
        case strUniqueID = "StrUniqueId"
        case displayID = "DisplayId"
        case appAssessmentID = "AppAssessmentId"
        case moduleAssessmentID = "ModuleAssessmentId"
        case questionCategoriesID = "QuestionCategoriesId"
        case assessmentScore = "AssessmentScore"
        case assessmentType = "AssessmentType"
        case qcCount = "QCCount"
        case textAmPm = "TextAmPm"
        case personName = "PersonName"
        case frequencyValue = "FrequencyValue"
        case userID = "UserId"
        case deviceID = "Device_Id"
        case notes = "Notes"
        case createdAt = "CreatedAt"
        case colorCode = "ColorCode"
        case isNA = "ISNA"
    }
}

enum CreatedAt: String, Codable {
    case the20210707T065859933 = "2021-07-07T06:58:59.933"
    case the20210707T065859937 = "2021-07-07T06:58:59.937"
    case the20210707T06585994 = "2021-07-07T06:58:59.94"
    case the20210707T065859943 = "2021-07-07T06:58:59.943"
    case the20210707T065859947 = "2021-07-07T06:58:59.947"
    case the20210707T06585995 = "2021-07-07T06:58:59.95"
}

enum PersonName: String, Codable {
    case day = "day"
    case empty = ""
}

enum QCCount: String, Codable {
    case empty = ""
    case yoe = "yoe"
}



enum TextAmPm: String, Codable {
    case bibbrx89F = "bibbrx89&”f"
    case empty = ""
}

// MARK: - DayAgeSubcutaneousDetailsPostingDatum
struct DayAgeSubcutaneousDetailsPostingDatum: Codable {
    let id: Int
    let strUniqueID: String
    let assessmentID, dayAgeSubcutaneousMfgID, dayAgeSubcutaneousMfgNameID: Int
    let dayAgeSubcutaneousHatcheryAntibiotics: Bool
    let dayAgeSubcutaneousAmpuleSize, dayAgeSubcutaneousAmpulePerbag: Int
    let dayAgeSubcutaneousBagSizeType: String
    let dayAgeSubcutaneousSizeTypeValue: JSONNull?
    let dayAgeSubcutaneousDiluentMfg, dayAgeSubcutaneousDosage: String
    let deviceID: DeviceID
    let dayAgeSubcutaneousBagSizeTypeID, dayAgeSubcutaneousDiluentMfgID, secquenceID, moduleAssessmentCatID: Int
    let displayID: ID
    let appAssessmentID: String
    let userID: JSONNull?
    let createdAt, otherText, antibioticInformation: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case strUniqueID = "StrUniqueId"
        case assessmentID = "AssessmentId"
        case dayAgeSubcutaneousMfgID = "DayAgeSubcutaneousMfgId"
        case dayAgeSubcutaneousMfgNameID = "DayAgeSubcutaneousMfgNameId"
        case dayAgeSubcutaneousHatcheryAntibiotics = "DayAgeSubcutaneousHatcheryAntibiotics"
        case dayAgeSubcutaneousAmpuleSize = "DayAgeSubcutaneousAmpuleSize"
        case dayAgeSubcutaneousAmpulePerbag = "DayAgeSubcutaneousAmpulePerbag"
        case dayAgeSubcutaneousBagSizeType = "DayAgeSubcutaneousBagSizeType"
        case dayAgeSubcutaneousSizeTypeValue = "DayAgeSubcutaneousSizeTypeValue"
        case dayAgeSubcutaneousDiluentMfg = "DayAgeSubcutaneousDiluentMfg"
        case dayAgeSubcutaneousDosage = "DayAgeSubcutaneousDosage"
        case deviceID = "Device_Id"
        case dayAgeSubcutaneousBagSizeTypeID = "DayAgeSubcutaneousBagSizeTypeId"
        case dayAgeSubcutaneousDiluentMfgID = "DayAgeSubcutaneousDiluentMfgId"
        case secquenceID = "SecquenceId"
        case moduleAssessmentCatID = "ModuleAssessmentCatId"
        case displayID = "DisplayId"
        case appAssessmentID = "AppAssessmentId"
        case userID = "UserId"
        case createdAt = "CreatedAt"
        case otherText = "OtherText"
        case antibioticInformation = "AntibioticInformation"
    }
}

// MARK: - DayOfAgePostingDatum
struct DayOfAgePostingDatum: Codable {
    let id: Int
    let strUniqueID: String
    let assessmentID, dayOfAgeMfgID, dayOfAgeMfgNameID: Int
    let dayOfBagHatcheryAntibiotics: Bool
    let dayOfAgeAmpuleSize, dayOfAgeAmpulePerbag: Int
    let dayOfAgeBagSizeType: String
    let dayOfBagSizeTypeValue: JSONNull?
    let diluentMfg, dayOfAgeDosage: String
    let deviceID: DeviceID
    let bagSizeTypeID, diluentMfgID, secquenceID, moduleAssessmentCatID: Int
    let displayID: ID
    let appAssessmentID: String
    let userID: JSONNull?
    let createdAt, antibioticInformation, otherText: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case strUniqueID = "StrUniqueId"
        case assessmentID = "AssessmentId"
        case dayOfAgeMfgID = "DayOfAgeMfgId"
        case dayOfAgeMfgNameID = "DayOfAgeMfgNameId"
        case dayOfBagHatcheryAntibiotics = "DayOfBagHatcheryAntibiotics"
        case dayOfAgeAmpuleSize = "DayOfAgeAmpuleSize"
        case dayOfAgeAmpulePerbag = "DayOfAgeAmpulePerbag"
        case dayOfAgeBagSizeType = "DayOfAgeBagSizeType"
        case dayOfBagSizeTypeValue = "DayOfBagSizeTypeValue"
        case diluentMfg = "DiluentMfg"
        case dayOfAgeDosage = "DayOfAgeDosage"
        case deviceID = "Device_Id"
        case bagSizeTypeID = "BagSizeTypeId"
        case diluentMfgID = "DiluentMfgId"
        case secquenceID = "SecquenceId"
        case moduleAssessmentCatID = "ModuleAssessmentCatId"
        case displayID = "DisplayId"
        case appAssessmentID = "AppAssessmentId"
        case userID = "UserId"
        case createdAt = "CreatedAt"
        case antibioticInformation = "AntibioticInformation"
        case otherText = "OtherText"
    }
}

// MARK: - InovojectPostingDatum
struct InovojectPostingDatum: Codable {
    let id, assessmentID: Int
    let strUniqueID: String
    let manufacturerID, vaccineID: Int
    let hatcheryAntibiotics: Bool
    let ampuleSize, ampulePerbag: Int
    let bagSizeType: String
    let bagSizeTypeValue: JSONNull?
    let diluentMfg, dosage: String
    let bagSizeTypeID, secquenceID, diluentMfgID: Int
    let userID: JSONNull?
    let createdAt: String
    let deviceID: DeviceID
    let moduleAssessmentCatID: Int
    let antibioticInformation: String
    let displayID: ID
    let appAssessmentID, otherText: String
    let diluentsMfgOtherName: JSONNull?
    let programName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case assessmentID = "AssessmentId"
        case strUniqueID = "StrUniqueId"
        case manufacturerID = "ManufacturerId"
        case vaccineID = "VaccineId"
        case hatcheryAntibiotics = "HatcheryAntibiotics"
        case ampuleSize = "AmpuleSize"
        case ampulePerbag = "AmpulePerbag"
        case bagSizeType = "BagSizeType"
        case bagSizeTypeValue = "BagSizeTypeValue"
        case diluentMfg = "DiluentMfg"
        case dosage = "Dosage"
        case bagSizeTypeID = "BagSizeTypeId"
        case secquenceID = "SecquenceId"
        case diluentMfgID = "DiluentMfgId"
        case userID = "UserId"
        case createdAt = "CreatedAt"
        case deviceID = "Device_Id"
        case moduleAssessmentCatID = "ModuleAssessmentCatId"
        case antibioticInformation = "AntibioticInformation"
        case displayID = "DisplayId"
        case appAssessmentID = "AppAssessmentId"
        case otherText = "OtherText"
        case diluentsMfgOtherName = "DiluentsMfgOtherName"
        case programName = "ProgramName"
    }
}

// MARK: - SanitationEmbrexScoresPostinDatum
struct SanitationEmbrexScoresPostinDatum: Codable {
    let id, assessmentID, assessmentDetailID, score: Int
    let sampleNo: String
    let plateNo, plateTypeID, baacteria, blueGreenMold: Int
    let comments: String?
    let deviceID: JSONNull?
    let createdBy: Int
    let createdAt: String
    let plateTypeName: PlateTypeName
    let locationName: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case assessmentID = "AssessmentId"
        case assessmentDetailID = "AssessmentDetailId"
        case score = "Score"
        case sampleNo = "SampleNo"
        case plateNo = "PlateNo"
        case plateTypeID = "PlateTypeId"
        case baacteria = "Baacteria"
        case blueGreenMold = "BlueGreenMold"
        case comments = "Comments"
        case deviceID = "DeviceId"
        case createdBy = "CreatedBy"
        case createdAt = "CreatedAt"
        case plateTypeName = "PlateTypeName"
        case locationName = "LocationName"
    }
}

enum PlateTypeName: String, Codable {
    case macConkey = "MacConkey"
    case sw = "SW"
    case tsa = "TSA"
}

// MARK: - VaccineMixerObservedPostingDatum
struct VaccineMixerObservedPostingDatum: Codable {
    let appAssessmentID, strUniqueID: String
    let displayID: ID
    let id, assessmentID: Int
    let assessmentDetailID, moduleAssessmentID: JSONNull?
    let name, certificationDate: String
    let secquenceID: JSONNull?
    let alternateName, createdAt, certificationDate2: String
    let moduleAssessmentCatID, userID: Int
    let deviceID: DeviceID
    
    enum CodingKeys: String, CodingKey {
        case appAssessmentID = "AppAssessmentId"
        case strUniqueID = "StrUniqueId"
        case displayID = "DisplayId"
        case id = "Id"
        case assessmentID = "AssessmentId"
        case assessmentDetailID = "AssessmentDetailId"
        case moduleAssessmentID = "ModuleAssessmentId"
        case name = "Name"
        case certificationDate = "CertificationDate"
        case secquenceID = "SecquenceId"
        case alternateName = "AlternateName"
        case createdAt = "CreatedAt"
        case certificationDate2 = "CertificationDate2"
        case moduleAssessmentCatID = "ModuleAssessmentCatId"
        case userID = "userId"
        case deviceID = "DeviceId"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {print(appDelegateObj.testFuntion())}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil(), value {
            return JSONNull()
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key), value {
            return JSONNull()
        }

        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key2 = JSONCodingKey(stringValue: key)!
            debugPrint(key)
            if let value = value as? Bool {
                try container.encode(value, forKey: key2)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key2)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key2)
            } else if let value = value as? String {
                try container.encode(value, forKey: key2)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key2)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key2)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key2)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

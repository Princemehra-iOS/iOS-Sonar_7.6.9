import Foundation


class GetSubmittedModuleAssessmentsDTO: Codable {
    var assessment2: JSONNull?
    var types: String?
    var locationPhone: String?
    var comments: String?
    var sequenceNo: Int?
    var moduleCatID, recordID: Int?
    var assessment: String?
    var answer: Bool?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case assessment2 = "Assessment2"
        case types = "Types"
        case locationPhone = "LocationPhone"
        case comments = "Comments"
        case sequenceNo = "SequenceNo"
        case moduleCatID = "ModuleCatId"
        case recordID = "recordId"
        case assessment = "Assessment"
        case answer = "Answer"
        case id = "Id"
    }

    init(config: CoreDataHandlerPEModels.SubmittedAssessmentConfig) {
        self.assessment2 = config.assessment2
        self.types = config.types
        self.locationPhone = config.locationPhone
        self.comments = config.comments
        self.sequenceNo = config.sequenceNo
        self.moduleCatID = config.moduleCatID
        self.recordID = config.recordID
        self.assessment = config.assessment
        self.answer = config.answer
        self.id = config.id
    }
}

enum Types: String, Codable {
    case numeric = "Numeric"
    case yesNo = "Yes/No"
}

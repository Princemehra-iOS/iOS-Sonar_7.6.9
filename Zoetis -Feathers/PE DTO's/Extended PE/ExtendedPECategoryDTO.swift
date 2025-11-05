import Foundation
struct ExtendedPECategoryDTO : Codable {
    let id : Int?
    let categoryName : String?
    let sequenceNo : Int?
    let maxMark : Int?
    let evaluationId : Int?
    let assessmentQuestions : [AssessmentQuestionsExtendedPEDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case categoryName = "CategoryName"
        case sequenceNo = "SequenceNo"
        case maxMark = "MaxMark"
        case evaluationId = "EvaluationId"
        case assessmentQuestions = "AssessmentQuestions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        sequenceNo = try values.decodeIfPresent(Int.self, forKey: .sequenceNo)
        maxMark = try values.decodeIfPresent(Int.self, forKey: .maxMark)
        evaluationId = try values.decodeIfPresent(Int.self, forKey: .evaluationId)
        assessmentQuestions = try values.decodeIfPresent([AssessmentQuestionsExtendedPEDTO].self, forKey: .assessmentQuestions)
    }
    
}

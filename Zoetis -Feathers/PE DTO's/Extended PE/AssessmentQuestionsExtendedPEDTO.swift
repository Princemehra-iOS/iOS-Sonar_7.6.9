import Foundation
struct AssessmentQuestionsExtendedPEDTO : Codable {
    let id : Int?
    let categoryId : Int?
    let assessment : String?
    let assessment2 : String?
    let minScore : Int?
    let maxScore : Int?
    let cateType : String?
    let moduleCatId : String?
    let moduleCatName : String?
    let informationText : String?
    let informationImage : String?
    let IsAllowNA : Bool?
    let qSeqNo : Int?
    let rollOut : String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case categoryId = "CategoryId"
        case assessment = "Assessment"
        case assessment2 = "Assessment2"
        case minScore = "MinScore"
        case maxScore = "MaxScore"
        case cateType = "CateType"
        case moduleCatId = "ModuleCatId"
        case moduleCatName = "ModuleCatName"
        case informationText = "InformationText"
        case informationImage = "InformationImage"
        case IsAllowNA = "IsAllowNA"
        case rollOut = "RollOut"
        case qSeqNo = "QSeqNo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        assessment = try values.decodeIfPresent(String.self, forKey: .assessment)
        assessment2 = try values.decodeIfPresent(String.self, forKey: .assessment2)
        minScore = try values.decodeIfPresent(Int.self, forKey: .minScore)
        maxScore = try values.decodeIfPresent(Int.self, forKey: .maxScore)
        cateType = try values.decodeIfPresent(String.self, forKey: .cateType)
        moduleCatId = try values.decodeIfPresent(String.self, forKey: .moduleCatId)
        moduleCatName = try values.decodeIfPresent(String.self, forKey: .moduleCatName)
        informationText = try values.decodeIfPresent(String.self, forKey: .informationText)
        informationImage = try values.decodeIfPresent(String.self, forKey: .informationImage)
        IsAllowNA = try values.decodeIfPresent(Bool.self, forKey: .IsAllowNA)
        rollOut = try values.decodeIfPresent(String.self, forKey: .rollOut)
        qSeqNo = try values.decodeIfPresent(Int.self, forKey: .qSeqNo)
        
    }
    
}

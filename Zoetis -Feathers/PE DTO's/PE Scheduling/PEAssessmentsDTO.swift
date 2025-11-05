import Foundation
struct PEAssessmentsDTO : Codable {
    let success : Bool?
    let statusCode : Int?
    let message : String?
    let data : [ScheduledPEAssessmentsDTO]?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "Success"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([ScheduledPEAssessmentsDTO].self, forKey: .data)
    }
    
}

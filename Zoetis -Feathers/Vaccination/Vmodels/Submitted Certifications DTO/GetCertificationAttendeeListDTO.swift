import Foundation

class GetCertificationAttendeeListDTO: Codable {
    var id: Int?
  //  var text: Text?
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case text = "Text"
    }

    init(id: Int?, text: String?) {
        self.id = id
        self.text = text
    }
}

enum Text: String, Codable {
    case the03D10Ca0Ccef4A6B8E707Bb7Cac6649E = "03D10CA0-CCEF-4A6B-8E70-7BB7CAC6649E"
    case the22E6Ff6864014678A84737D013109C96 = "22E6FF68-6401-4678-A847-37D013109C96"
    case the4D8B323D3E1D4F529EdeB05727B07Cf7 = "4D8B323D-3E1D-4F52-9EDE-B05727B07CF7"
}

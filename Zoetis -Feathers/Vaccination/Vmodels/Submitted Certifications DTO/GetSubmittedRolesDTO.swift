
import Foundation

class GetSubmittedRolesDTO: Codable {
    var roleID: Int?
    var isSelected: Bool?
    var roleName: String?

    enum CodingKeys: String, CodingKey {
        case roleID = "RoleId"
        case isSelected = "IsSelected"
        case roleName = "RoleName"
    }

    init(roleID: Int?, isSelected: Bool?, roleName: String?) {
        self.roleID = roleID
        self.isSelected = isSelected
        self.roleName = roleName
    }
}

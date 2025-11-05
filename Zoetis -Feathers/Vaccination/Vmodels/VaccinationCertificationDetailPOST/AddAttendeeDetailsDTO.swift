
import Foundation

class AddAttendeeDetailsDTO : Codable {
	var TrainingId : Int64?
	var ModuleCatId : Int64?
	var OperatorId : Int64?
	var CreatedBy : Int64?
	var DeviceId : String?
    var OperatorUniqueId:String?
}

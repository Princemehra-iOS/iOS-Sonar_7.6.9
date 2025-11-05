
import Foundation

class ModuleAssessmentsCertDTO : Codable {
	var Assessment_Id : Int64?
	var Assessment : String?
	var Assessment2 : String?
	var MinScore : Int?
	var MidScore : Int?
	var MaxScore : Int?
	var Types : String?
	var PVEVaccType : String?
	var ModuleCatId : Int64?
	var IsDeleted : Bool?
	var AddValue : Bool?
	var Information : String?
	var FolderPath : String?
	var ImageName : String?
	var Answer : Bool?
    var LocationPhone: String?
    var Comments:String?
    var TrainingScheduleId : Int64?
    var DeviceId:String?
    var SequenceNo : Int?
}


import Foundation

class QuestionAnswerDTO : Codable {
	var catId : Int64?
	var CategorieName : String?
	var TypeId : Int64?
	var ModuleAssessments : [ModuleAssessmentsCertDTO]?
	var AddAttendeeDetails : [AddAttendeeDetailsDTO]?
}

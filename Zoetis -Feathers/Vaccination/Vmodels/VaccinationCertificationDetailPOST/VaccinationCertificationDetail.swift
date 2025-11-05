
import Foundation

class VaccinationCertificationDetail : Codable {
    var OperatorCertificate:Bool = true
    var Cretification_Type_Id : Int?
	var OperatorInfo : [OperatorInfoDTO]?
	var QuestionAnswer : [QuestionAnswerDTO]?
    var VacOperatorFSSgAddress : [ShippingAddressDTO]?
	var Id : Int64?
	var ScheduleDate : String?
	var CustomerId : Int64?
	var CustomerName : String?
	var SiteId : Int64?
	var SiteName : String?
	var AssignToName : String?
	var AssingToId : Int64?
	var CertificateTypeId : Int64?
	var CertificateType : String?
	var IsDeleted : Bool?
	var Comments : String?
	var CustShipping : String?
	var ExistingSite : Bool?
	var CreatedBy : Int64?
	var Status : Bool?
//	var OperatorCertificate : Bool?
	var TrainingStatus : String?
    var TrainingStatusId : Int?
    var HatcheryManagerName:String?
    var FSRSignature:String?
    var HatcheryManagerSignature:String?
	var SubmitedDate : String?
    var ApprovedRejectedById: String?
    var GpColleagueName : String?
    var GpColleagueJobTitle : String?
    var GpSupervisorName : String?
    var GpSupervisorJobTitle : String?
    var DeviceId:String?
    var IsAcknowledge:Bool = false
    var ApproverId: String?
}

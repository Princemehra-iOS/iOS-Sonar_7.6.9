import Foundation

public class PESanitationDTO:Codable {
	public var Id : Int?
	public var AssessmentId : Int?
	public var AssessmentDetailId : Int?
	public var Score : Int?
	public var SampleNo : String?
	public var PlateNo : Int?
	public var PlateTypeId : Int?
	public var Baacteria : Int?
	public var BlueGreenMold : Int?
	public var Comments : String?
	public var DeviceId : String?
	public var CreatedBy : Int?
	public var CreatedAt : String?
	public var PlateTypeName : String?
}

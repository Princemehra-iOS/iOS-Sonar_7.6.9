import Foundation

class GetSubmittedTrainingSchedulesInfoDTO: Codable {
    var isDeleted: Bool?
    var isMicrobial: JSONNull?
    var trainingStatusID: Int?
    var schDate, peApproverID: JSONNull?
    var operatorCertificate: Bool?
    var peSaveTypeID: JSONNull?
    var certificateTypeID, trainingStatus: Int?
    var evaluationStatus, peStatusID: JSONNull?
    var scheduleDate, hatcheryManagerSignature: String?
    var approverID: Int?
    var quarter: JSONNull?
    var isTshirtPrinted: Bool?
    var approvedRejectedByID: Int?
    var id: Int?
    var hatcheryManagerSignatureBase64, certificateType, fsrSignatureBase64, customerName: String?
    var assignToName: String?
    var assingToID: Int?
    var gpColleagueJobTitle: String?
    var status, existingSite: Bool?
    var score: JSONNull?
    var isAcknowledge: Bool?
    var custShipping: String?
    var customerID: Int?
    var siteName: String?
    var createdBy: Int?
    var gpSupervisorJobTitle: String?
    var siteID: Int?
    var gpSupervisorName: String?
    var createdDate, trainingType, submitedDate: String?
    var sanitationEmbrex: Bool?
    var roleID: Int??
    var fsrSignature: String?
    var pEevaluationTypeID : JSONNull?
    var gpColleagueName : String?
    var comments : String?
    var hatcheryManagerName, approverName, deviceID: String?
    var peVisitTypeID: JSONNull?
    var certification_Type_Id : Int?
    var approvedRejectedDate: String?

    enum CodingKeys: String, CodingKey {
        case isDeleted = "IsDeleted"
        case isMicrobial = "IsMicrobial"
        case trainingStatusID = "TrainingStatusId"
        case schDate = "SchDate"
        case peApproverID = "PEApproverId"
        case operatorCertificate = "OperatorCertificate"
        case peSaveTypeID = "PeSaveTypeId"
        case certificateTypeID = "CertificateTypeId"
        case trainingStatus = "TrainingStatus"
        case evaluationStatus = "EvaluationStatus"
        case peStatusID = "PeStatusId"
        case scheduleDate = "ScheduleDate"
        case hatcheryManagerSignature = "HatcheryManagerSignature"
        case approverID = "ApproverId"
        case quarter = "Quarter"
        case isTshirtPrinted = "IsTshirtPrinted"
        case approvedRejectedByID = "ApprovedRejectedById"
        case id = "Id"
        case hatcheryManagerSignatureBase64 = "HatcheryManagerSignatureBase64"
        case certificateType = "CertificateType"
        case fsrSignatureBase64 = "FSRSignatureBase64"
        case customerName = "CustomerName"
        case assignToName = "AssignToName"
        case assingToID = "AssingToId"
        case gpColleagueJobTitle = "GpColleagueJobTitle"
        case status = "Status"
        case existingSite = "ExistingSite"
        case score = "Score"
        case isAcknowledge = "IsAcknowledge"
        case custShipping = "CustShipping"
        case customerID = "CustomerId"
        case siteName = "SiteName"
        case createdBy = "CreatedBy"
        case gpSupervisorJobTitle = "GpSupervisorJobTitle"
        case siteID = "SiteId"
        case gpSupervisorName = "GpSupervisorName"
        case createdDate = "CreatedDate"
        case trainingType = "TrainingType"
        case submitedDate = "SubmitedDate"
        case sanitationEmbrex = "Sanitation_Embrex"
        case roleID = "RoleId"
        case fsrSignature = "FSRSignature"
        case pEevaluationTypeID = "PEevaluationTypeId"
        case gpColleagueName = "GpColleagueName"
        case hatcheryManagerName = "HatcheryManagerName"
        case approverName = "ApproverName"
        case deviceID = "DeviceId"
        case approvedRejectedDate = "ApprovedRejectedDate"
        case comments = "Comments"
        case peVisitTypeID = "PEVisitTypeId"
        case certification_Type_Id = "Cretification_Type_Id"
    }

    // Refactored initializer using a dictionary
    init(data: [String: Any]) {
        self.isDeleted = data["IsDeleted"] as? Bool
        self.isMicrobial = data["IsMicrobial"] as? JSONNull
        self.trainingStatusID = data["TrainingStatusId"] as? Int
        self.schDate = data["SchDate"] as? JSONNull
        self.peApproverID = data["PEApproverId"] as? JSONNull
        self.operatorCertificate = data["OperatorCertificate"] as? Bool
        self.peSaveTypeID = data["PeSaveTypeId"] as? JSONNull
        self.certificateTypeID = data["CertificateTypeId"] as? Int
        self.trainingStatus = data["TrainingStatus"] as? Int
        self.evaluationStatus = data["EvaluationStatus"] as? JSONNull
        self.peStatusID = data["PeStatusId"] as? JSONNull
        self.scheduleDate = data["ScheduleDate"] as? String
        self.hatcheryManagerSignature = data["HatcheryManagerSignature"] as? String
        self.approverID = data["ApproverId"] as? Int
        self.quarter = data["Quarter"] as? JSONNull
        self.isTshirtPrinted = data["IsTshirtPrinted"] as? Bool
        self.approvedRejectedByID = data["ApprovedRejectedById"] as? Int
        self.id = data["Id"] as? Int
        self.hatcheryManagerSignatureBase64 = data["HatcheryManagerSignatureBase64"] as? String
        self.certificateType = data["CertificateType"] as? String
        self.fsrSignatureBase64 = data["FSRSignatureBase64"] as? String
        self.customerName = data["CustomerName"] as? String
        self.assignToName = data["AssignToName"] as? String
        self.assingToID = data["AssingToId"] as? Int
        self.gpColleagueJobTitle = data["GpColleagueJobTitle"] as? String
        self.status = data["Status"] as? Bool
        self.existingSite = data["ExistingSite"] as? Bool
        self.score = data["Score"] as? JSONNull
        self.isAcknowledge = data["IsAcknowledge"] as? Bool
        self.custShipping = data["CustShipping"] as? String
        self.customerID = data["CustomerId"] as? Int
        self.siteName = data["SiteName"] as? String
        self.createdBy = data["CreatedBy"] as? Int
        self.gpSupervisorJobTitle = data["GpSupervisorJobTitle"] as? String
        self.siteID = data["SiteId"] as? Int
        self.gpSupervisorName = data["GpSupervisorName"] as? String
        self.createdDate = data["CreatedDate"] as? String
        self.trainingType = data["TrainingType"] as? String
        self.submitedDate = data["SubmitedDate"] as? String
        self.sanitationEmbrex = data["Sanitation_Embrex"] as? Bool
        self.roleID = data["RoleId"] as? Int
        self.fsrSignature = data["FSRSignature"] as? String
        self.pEevaluationTypeID = data["PEevaluationTypeId"] as? JSONNull
        self.gpColleagueName = data["GpColleagueName"] as? String
        self.hatcheryManagerName = data["HatcheryManagerName"] as? String
        self.approverName = data["ApproverName"] as? String
        self.deviceID = data["DeviceId"] as? String
        self.approvedRejectedDate = data["ApprovedRejectedDate"] as? String
        self.comments = data["Comments"] as? String
        self.peVisitTypeID = data["PEVisitTypeId"] as? JSONNull
        self.certification_Type_Id = data["Cretification_Type_Id"] as? Int
    }
}


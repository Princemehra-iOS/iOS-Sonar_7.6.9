
import Foundation

class GetSubmittedCertificationsDTO: Codable {
    var vaccineMixtureCertification: [GetSubmittedVaccineMixingCertificationDTO]?
    var operatorInfo: [GetSubmittedOperatorInfoDTO]?
    var safetyCertification: [GetSubmittedSafetyCertificationDTO]?
    var trainingSchedulesInfo: GetSubmittedTrainingSchedulesInfoDTO?
    var operatorCertification: [GetSubmittedOperatorCertificationDTO]?
    var vacOperatorFSSgAddress: [ShippingAddressDTO]?
    
    enum CodingKeys: String, CodingKey {
        case vaccineMixtureCertification = "VaccineMixtureCertification"
        case operatorInfo = "OperatorInfo"
        case safetyCertification = "SafetyCertification"
        case trainingSchedulesInfo = "TrainingSchedulesInfo"
        case operatorCertification = "OperatorCertification"
        case vacOperatorFSSgAddress = "VacOperatorFSSgAddress"
    }
    
    init(vaccineMixtureCertification: [GetSubmittedVaccineMixingCertificationDTO]?, operatorInfo: [GetSubmittedOperatorInfoDTO]?, safetyCertification: [GetSubmittedSafetyCertificationDTO]?, trainingSchedulesInfo: GetSubmittedTrainingSchedulesInfoDTO?, operatorCertification: [GetSubmittedOperatorCertificationDTO]?, vacOperatorFSSgAddress: [ShippingAddressDTO]?) {
        self.vaccineMixtureCertification = vaccineMixtureCertification
        self.operatorInfo = operatorInfo
        self.safetyCertification = safetyCertification
        self.trainingSchedulesInfo = trainingSchedulesInfo
        self.operatorCertification = operatorCertification
        self.vacOperatorFSSgAddress = vacOperatorFSSgAddress
    }
}

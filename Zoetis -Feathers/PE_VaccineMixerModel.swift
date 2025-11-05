//
//  PE_VaccineMixerModel.swift
//  Zoetis -Feathers
//
//  Created by MobileProgramming on 18/10/22.
//

import Foundation
import SwiftyJSON

public struct VaccineMixerResponse {
    
    let success: Bool?
    let statusCode: Int?
    let message: String?
    let vaccineMixerArray: [VaccineMixerDetail]?
    
    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["Message"].stringValue
        vaccineMixerArray = json["Data"].arrayValue.map { VaccineMixerDetail($0) }
    }
}

public struct VaccineMixerDetail {
    
    let id: Int?
    let Name: String?
    let certificationDate: String?
    let isCertExpired: Bool?
    let signatureImg: String?
    let source: String?
    let certCeatedbyName: String?
    let certCeatedbyId: Int?
    let isManuallyAdded: Bool?

    init(_ json: JSON) {
        id = json["Id"].intValue
        Name = json["Name"].stringValue
        certificationDate = json["CertficationDate"].stringValue
        isCertExpired = json["IsCertExpired"].boolValue
        signatureImg = json["SignatureImg"].string
        certCeatedbyName = json["CertCeatedbyName"].string
        certCeatedbyId = json["CertCeatedby"].int
        source = json["Source"].string
        isManuallyAdded = json["isManuallyAdded"].boolValue


        let NameIs = Name ?? ""
        let idN = id ?? 0
        let certificationDateIs = certificationDate ?? ""
        let isCertExpiredValue = isCertExpired ?? false
        let signatureImgIs = signatureImg ?? ""
        
        let certCreatedById = certCeatedbyId ?? 0
        let certCreatedByName = certCeatedbyName ?? ""
        let source = source ?? ""
        let isManuallyAdded = isManuallyAdded ?? false

        CoreDataHandlerPE().saveVaccineMixerInDB(NSNumber(value: idN),
                                                 Name: NameIs,
                                                 certificationDate: certificationDateIs,
                                                 isCertExpired: isCertExpiredValue,
                                                 signatureImg: signatureImgIs,
                                                 certCreatedById: certCreatedById,
                                                 certCreatedByName: certCreatedByName,
                                                 source: source,
                                                 isManuallyAdded: isManuallyAdded)
        
    }
    
}

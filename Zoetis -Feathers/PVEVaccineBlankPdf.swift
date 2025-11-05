//
//  PVEVaccineManDetails.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import SwiftyJSON




struct PVEBlankPdfResponse {

    let success: Bool?
    let statusCode: Int?
    let message: String?
    let dataArray: [PVEBlankPdfRes]?

    init(_ json: JSON) {
        success = json["Success"].boolValue
        statusCode = json["StatusCode"].intValue
        message = json["DisplayMessage"].stringValue
        dataArray = json["ResponseData"].arrayValue.map { PVEBlankPdfRes($0) }

    }
    
    func getBlankPdfDetails(dataArray:[PVEBlankPdfRes]) -> [String] {
        var nameArr : [String] = []
        for obj in dataArray {
            nameArr.append(obj.fileName ?? "")
            nameArr.append(obj.pdfPath ?? "")
            nameArr.append(obj.pdfCompletePath ?? "")
        }
        return nameArr
    }

}

public struct PVEBlankPdfRes {
    
    
        let fileName: String?
        let pdfPath: String?
        let pdfCompletePath: String?
    
    
        init(_ json: JSON) {
            fileName = json["FileName"].stringValue
            pdfPath = json["PdfPath"].stringValue
            pdfCompletePath = json["PdfCompletePath"].stringValue
            CoreDataHandlerPVE().saveBlankPdfInDB(fileName: fileName!, pdfPathStr: pdfPath!, pdfCompletePathStr: pdfCompletePath!)
    
        }

}


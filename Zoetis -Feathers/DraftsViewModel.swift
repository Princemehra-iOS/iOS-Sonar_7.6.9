//
//  DraftsViewModel.swift
//  Zoetis -Feathers
//
//  Created by Nitish Shamdasani on 04/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

import Foundation


class DraftsViewModel {
    
    private let kAll = "All"
    private let surveyForm = "Microbial_EnviromentalSurveyFormSubmitted"
    private let locationTypeHeaders = "Microbial_LocationTypeHeadersSubmitted"
    private let locationTypePlates = "Microbial_LocationTypeHeaderPlatesSubmitted"
    

    func getData() -> [Microbial_EnviromentalSurveyFormSubmitted]{
        let caseInfoForrequistion = CoreDataHandlerMicro().fetchDataFromDraftsAndRequisition(draftOrSubmit: SessionStatus.saveAsDraft.rawValue, entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        if caseInfoForrequistion.count > 0{
            let arrViewRequisition = caseInfoForrequistion as? [Microbial_EnviromentalSurveyFormSubmitted] ?? []
            var newArr = [Microbial_EnviromentalSurveyFormSubmitted]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            var i = 0
            var j = 0
            var k = 0
            for item in arrViewRequisition {
                
                print("your item date is here : \(item.sampleCollectionDate)")
                if let date = item.sampleCollectionDate {
                    if date == "" {
                        print("date is coming nil k: \(k)")
                        k = k + 1
                    }
                    else {
                    print("coming date j:\(j): \(date)")
                        newArr.append(item)
                    j = j + 1
                    }
                }
                else {
                    print("empty date i: \(i)")
                    i = i + 1
                }
            }
            let sortedArray = newArr.sorted { dateFormatter.date(from: $0.sampleCollectionDate ?? "")! > dateFormatter.date(from: $1.sampleCollectionDate ?? "")! }
            
            return sortedArray

        }else{
            return []
        }
    }
    
    func getRequisitionArray(arrDraft: [Microbial_EnviromentalSurveyFormSubmitted]) -> Array<String>{
        var arrSurvey = Array(Set(arrDraft.map{ "\(RequisitionType.getRequisitionTypeStringValue(type: $0.requisitionType as! Int))" }))
        arrSurvey.insert(kAll, at: 0)
        return arrSurvey
    }
    
    
    func deleteRequisition(_ requisistionDraft: Microbial_EnviromentalSurveyFormSubmitted ){
        if let timeStamp = requisistionDraft.timeStamp {
            let predicate = NSPredicate(format: "timeStamp contains[c] %@", timeStamp)
            CoreDataHandlerMicro().deleteRowDataOfAnEntity(predicate: predicate, entityName: surveyForm)
            CoreDataHandlerMicro().deleteRowDataOfAnEntity(predicate: predicate, entityName: locationTypeHeaders)
            CoreDataHandlerMicro().deleteRowDataOfAnEntity(predicate: predicate, entityName: locationTypePlates)
            MicrobialSelectedUnselectedReviewer.deleteDraftType(timeStamp: timeStamp)
        }
    }
    
    
    func filterDataAccordingToRequisitionSelected(selectedRequistion: String, arrViewRequisition: [Microbial_EnviromentalSurveyFormSubmitted]) -> [Microbial_EnviromentalSurveyFormSubmitted]{
        return arrViewRequisition.filter({$0.requisitionType == RequisitionType.getRequisitionTypeIntValue(type: selectedRequistion) })
    }
    
    
    
}

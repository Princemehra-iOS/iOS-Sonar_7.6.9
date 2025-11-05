//
//  ViewRequisition.swift
//  Zoetis -Feathers
//
//  Created by Abdul Shamim on 25/02/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation


class ViewRequisitionViewModel {
    
    private let kAll = "All"
    
    init() {
        print(appDelegateObj.testFuntion())
    }
    
    
    func getEnviromentalRequisitions() {
        var actualCreatedHeaders = [LocationTypeHeaderModel]()
        
        let allRequisitions = CoreDataHandlerMicro().fetchAllData("Microbial_Enviromental_RequisitionIDs")
      
        for item in allRequisitions {
            if let requisition = item as? Microbial_Enviromental_RequisitionIDs,
                let requisition_Id = requisition.requisition_Id,
                let requisitionType = requisition.requisitionType {
                
                let headersForRequisitionId =   CoreDataHandlerMicro().fetchEnviromentalHeadersWith(requisition_Id: requisition_Id, requisitionType: requisitionType)
                
                for header in headersForRequisitionId {
                   let headerIs = LocationTypeHeaderModel(headerObject: header)
                   actualCreatedHeaders.append(headerIs)
                }
            }
        }
        
        print(actualCreatedHeaders)
        
//        let savedHeader = CoreDataHandlerMicro().fetchAllData(" ")
        let savedPlates = CoreDataHandlerMicro().fetchAllData("Microbial_LocationTypeHeaderPlatesSubmitted")
        print(savedPlates)
    }

    func getData() -> [Microbial_EnviromentalSurveyFormSubmitted]{
        let caseInfoForrequistion = CoreDataHandlerMicro().fetchDataFromDraftsAndRequisition(draftOrSubmit: SessionStatus.submitted.rawValue, entityName: "Microbial_EnviromentalSurveyFormSubmitted")
        if caseInfoForrequistion.count > 0{
            let arrViewRequisition = caseInfoForrequistion as? [Microbial_EnviromentalSurveyFormSubmitted] ?? []
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = Constants.MMddyyyyStr
            
            var sortedArray = arrViewRequisition.sorted { dateFormatter.date(from: $0.sampleCollectionDate ?? "") ?? Date() > dateFormatter.date(from: $1.sampleCollectionDate ?? "") ?? Date() }
            sortedArray = sortedArray.filter({ $0.sampleCollectionDate != "" })

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
    
    
    func filterDataAccordingToRequisitionSelected(selectedRequistion: String, caseStatus: String, arrViewRequisition: [Microbial_EnviromentalSurveyFormSubmitted]) -> [Microbial_EnviromentalSurveyFormSubmitted]{
        let caseStatusReq = self.getCaseStatusId(text: caseStatus)
        
        switch (selectedRequistion, caseStatus) {
        case (let selectedReq, let caseStat) where selectedReq != kAll && caseStat == kAll:
            // when bot the fields are filled
            return arrViewRequisition.filter({$0.requisitionType == RequisitionType.getRequisitionTypeIntValue(type: selectedRequistion)})
            
        case (let selectedReq, let caseStat) where selectedReq == kAll && caseStat != kAll:
//            return self.getData()
            return arrViewRequisition.filter({$0.reqStatus?.intValue == caseStatusReq })

        case (let selectedReq, let caseStat) where selectedReq != kAll && caseStat != kAll:
            return arrViewRequisition.filter({$0.requisitionType == RequisitionType.getRequisitionTypeIntValue(type: selectedRequistion) && $0.reqStatus?.intValue == caseStatusReq})
        
        default:
            return self.getData()
        }
    }
    
    func getCaseStatus() -> [String]{
        let arrMicrobialCaseStatusModel = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialCaseStatus")
        var caseStringArr = arrMicrobialCaseStatusModel.value(forKey: "text")  as? [String] ?? []
        caseStringArr.insert(kAll, at: 0)
        return caseStringArr
    }
    
    func getCaseStatusId(text: String) -> Int {
        guard let caseStatusArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialCaseStatus") as? [MicrobialCaseStatus]  else {
            return -100
        }
        let caseStatusId = caseStatusArray.filter {$0.text == text}
        return caseStatusId.count > 0 ? (caseStatusId[0].id?.intValue ?? -100) : -100
    }
    
    func getCaseStatusString(id: Int) -> String {
        guard let caseStatusArray = CoreDataHandlerMicro().fetchDetailsFor(entityName: "MicrobialCaseStatus") as? [MicrobialCaseStatus]  else {
            return ""
        }
        let caseStatus = caseStatusArray.filter {$0.id?.intValue ?? 0 == id}
        return caseStatus.count > 0 ? (caseStatus[0].text ?? "") : ""
    }
}





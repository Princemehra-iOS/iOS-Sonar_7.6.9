//
//  PEDataService.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 26/08/20.
//

import Foundation
import Foundation
import UIKit

class PEDataService{
    private init(){print("Initializer")}
    static let sharedInstance = PEDataService()
    
    func getScheduledAssessments(loginuserId: String, viewController: UIViewController, completion: @escaping (String?, NSError?) -> Void) {
        let url = ZoetisWebServices.EndPoint.getPEScheduledCertifications.latestUrl + "\(loginuserId)?customerId=null&siteId=null"
        
        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url) { [weak self] (json, error) in
            guard let self = self, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let responseJSONDict = json.dictionary,
                  let response = responseJSONDict["Data"] else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }
            
            let responseStr = response.description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !responseStr.isEmpty,
                  let jsonData = responseStr.data(using: .utf8),
                  let vaccinationCertificationObj = try? JSONDecoder().decode([ScheduledPEAssessmentsDTO].self, from: jsonData),
                  !vaccinationCertificationObj.isEmpty else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }
            
            PEAssessmentsDAO.sharedInstance.saveScheduledAssessments(certificationDTOArr: vaccinationCertificationObj, loginUserId: loginuserId)
            completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
        }
    }
    
    // MARK: Delete Deleted Assessment ......
    func deleteDeletedAssessments(loginuserId: String, viewController: UIViewController, completion: @escaping (String?, NSError?) -> Void) {
        let userId = loginuserId
        var url = ZoetisWebServices.EndPoint.deleteDrafts.latestUrl
        let deletedAssessments = PEDeletedDraftsDAO.sharedInstance.fetchDeletedAssessments(userId: loginuserId)

        // Delete existing data for this user
        PEDeletedDraftsDAO.sharedInstance.deleteExisitingData("PE_DeletedAssessments", predicate: NSPredicate(format: "userId = %@", userId))

        if deletedAssessments.count > 0 {
            url = url + deletedAssessments + "&userId=" + loginuserId + "&appVersion=" + Bundle.main.versionNumber
        } else {
            url = url + "&userId=" + loginuserId + "&appVersion=" + Bundle.main.versionNumber
        }

        ZoetisWebServices.shared.deleteDeletedDrafts(controller: viewController, parameters: [:], url: url) { [weak self] (json, error) in
            guard let self = self, error == nil else {
                completion(nil, error)
                return
            }

            guard let responseJSONDict = json.dictionary,
                  let response = responseJSONDict["Data"] else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }

            let responseStr = response.description
            guard !responseStr.isEmpty, let jsonData = responseStr.data(using: .utf8) else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }

            do {
                // Ensure JSON is in expected format
                if let jsonNew = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                   let deletedIdArray = jsonNew["AssesssmentId"] as? [Any], !deletedIdArray.isEmpty {

                    // Delete existing data
                    PEDeletedDraftsDAO.sharedInstance.deleteExisitingData(predicate: nil)

                    // Process each assessmentId
                    deletedIdArray.forEach { assessmentId in
                        self.getAllDateArrayStored(assessmentId: assessmentId as? Int ?? 0)
                    }

                    completion(responseStr, nil)
                } else {
                    completion(appDelegateObj.noDataFoundStr, nil)
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(appDelegateObj.noDataFoundStr, nil)
            }
        }
    }



    func getAllDateArrayStored(assessmentId: Int){
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let drafts  = CoreDataHandlerPE().getDraftAssessmentArrayPEObject(ofCurrentAssessment:true)
        
        for obj in drafts {
            if obj.serverAssessmentId == String(assessmentId){
                let predicate = NSPredicate(format: "userID == %d AND serverAssessmentId == %d", userID, assessmentId)
                CoreDataHandlerPE().deleteExisitingData(entityName:"PE_AssessmentInDraft", predicate:predicate)
            }
        }
        
        let submited  = CoreDataHandlerPE().getSessionForViewAssessmentArrayPEObject(ofCurrentAssessment:true)
        
        for obj in submited {
            if obj.serverAssessmentId == String(assessmentId){
                let predicate = NSPredicate(format: "userID == %d AND serverAssessmentId == %d", userID, assessmentId)
                CoreDataHandlerPE().deleteExisitingData(entityName:"PE_AssessmentInOffline", predicate:predicate)
            }
        }
    }
    
    // MARK: get Plates Type Assessment ......
    func getPlateTypes(loginuserId: String, viewController: UIViewController, completion: @escaping (String?, NSError?) -> Void) {
        let url = ZoetisWebServices.EndPoint.getPlateTypes.latestUrl

        ZoetisWebServices.shared.getVaccinationServicesResponse(controller: viewController, url: url) { [weak self] (json, error) in
            guard let self = self, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let responseJSONDict = json.dictionary,
                  let response = responseJSONDict["Data"] else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }
            
            let responseStr = response.description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !responseStr.isEmpty,
                  let jsonData = responseStr.data(using: .utf8),
                  let plateTypesObj = try? JSONDecoder().decode([PlateTypesDTO].self, from: jsonData),
                  !plateTypesObj.isEmpty else {
                completion(appDelegateObj.noDataFoundStr, nil)
                return
            }
            
            PlateTypesDAO.sharedInstance.savePlateTypes(userId: loginuserId, plateTypeDTO: plateTypesObj)
            completion(VaccinationConstants.VaccinationStatus.COREDATA_SAVED_SUCCESSFULLY, nil)
        }
    }
}

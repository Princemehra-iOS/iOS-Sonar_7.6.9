//
//  ApproverStore.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 6/18/25.
//

import Foundation

class ApproverStore {
    
    static let shared = ApproverStore()
    private let storageKey = "ApproverStoreData"
    private let OtherDetailsStorageKey = "OtherDetailsStoreData"
    private init() {}
    
    // MARK: - Save Approver Info
    func setApprover(for certificateId: String, approverId: String, approverName: String) {
        var allData = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: [String: String]] ?? [:]
        
        allData[certificateId] = [
            "approverId": approverId,
            "approverName": approverName
        ]
        
        UserDefaults.standard.set(allData, forKey: storageKey)
    }
    
    // MARK: - Get Approver Info
    func getApprover(for certificateId: String) -> (approverId: String, approverName: String)? {
        guard let allData = UserDefaults.standard.dictionary(forKey: storageKey) as? [String: [String: String]],
              let approverData = allData[certificateId],
              let approverId = approverData["approverId"],
              let approverName = approverData["approverName"] else {
            return nil
        }
        
        return (approverId, approverName)
    }
    
    // MARK: - Save Other Info
    func setOtherCertificateDetail(for certificateId: String, customerId: String, customerName: String , siteId: String, siteName: String , custShipping: String , selectedFsmId: String , dateSchedule: String , htchMngr: String) {
        var allData = UserDefaults.standard.dictionary(forKey: OtherDetailsStorageKey) as? [String: [String: String]] ?? [:]
        
        allData[certificateId] = [
            "customerId": customerId,
            "customerName": customerName,
            "siteId": siteId,
            "siteName": siteName,
            "selectedFsm": selectedFsmId,
            "custShipping": custShipping,
            "dateSchedule": dateSchedule,
            "hatchryMngr": htchMngr,
        ]
        
        UserDefaults.standard.set(allData, forKey: OtherDetailsStorageKey)
    }

    
    // MARK: - Get Other Info
    func getOtherCertificateDetail(for certificateId: String) -> (customerId: String, customerName: String ,siteId: String, siteName: String , custShipping: String , selectedFsmId: String , dateSchedule: String , htchMngr: String)? {
        guard let allData = UserDefaults.standard.dictionary(forKey: OtherDetailsStorageKey) as? [String: [String: String]],
              let approverData = allData[certificateId],
              let siteId = approverData["siteId"],
              let siteName = approverData["siteName"],
              let customerId = approverData["customerId"],
              let custShipping = approverData["custShipping"],
              let selectedFsmId = approverData["selectedFsm"],
              let dateSchedule = approverData["dateSchedule"],
              let htchMngr = approverData["hatchryMngr"],
              let customerName = approverData["customerName"] else {
            return nil
        }
        
        return (customerId, customerName, siteId, siteName, custShipping, selectedFsmId, dateSchedule , htchMngr)
    }
    
    
}

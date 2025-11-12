//
//  PELandingPopViewControllerGetMasterData.swift
//  Zoetis -Feathers
//
//  Created by "" on 12/06/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

// MARK: - WebServices
extension PELandingPoupViewController {
    
    private func getPlateTypes(){
        PEDataService.sharedInstance.getPlateTypes(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
                     guard let _ = self, error == nil else { return }
                  
                 })
      }
    
    func fetchAllCustomer(){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading...")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        
        ZoetisWebServices.shared.getCustomerListForPE(controller: self, countryID: String(countryId), parameters: [:], completion: { [weak self] (json, error) in
            guard let allCustomerSelf = self, error == nil else { return }
            allCustomerSelf.handlefetchAllCustomerResponse(json)
        })
    }
    
    func fetchCustomersEveryTime(){
        self.showGlobalProgressHUDWithTitle(self.view, title: "Loading Customers")
        let countryId = UserDefaults.standard.integer(forKey: "nonUScountryId")
        
        ZoetisWebServices.shared.getCustomerListForPE(controller: self, countryID: String(countryId), parameters: [:], completion: { [weak self] (json, error) in
                                                    
            guard let _ = self, error == nil else {
                self?.dismissGlobalHUD(self?.view ?? UIView());
                return
            }
            self?.dismissGlobalHUD(self?.view ?? UIView());
            self?.handlefetchAllCustomerResponse(json, isEverytime: true)
        })
    }
    
    private func handlefetchAllCustomerResponse(_ json: JSON, isEverytime:Bool = false) {
        self.deleteAllData("PE_Customer")
        let jsonObject = CustomerResponse(json)
        if isEverytime{
            fetchSites(isEverytime)
        }else{
            if jsonObject.customerArray?.count ?? 0 > 0 {
                fetchAllDoses()
            } else {
                dismissGlobalHUD(self.view)
            }
        }
    }
    
    private func fetchAllDoses(){
        ZoetisWebServices.shared.getPEDosagesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let allDosesSelf = self, error == nil else { return }
            allDosesSelf.handlefetchAllDosesResponse(json)
        })
        
    }
    
    private func handlefetchAllDosesResponse(_ json: JSON) {
        self.deleteAllData("PE_Dose")
        let jsonObject = PEDoseResponse(json)
        if jsonObject.peDoseArray?.count ?? 0 > 0 {
            fetchEvaluator()
        } else {
            dismissGlobalHUD(self.view)
        }
    }
    
    private func fetchEvaluator(){
        ZoetisWebServices.shared.getEvaluatorListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let evaluatorSelf = self, error == nil else { return }
            evaluatorSelf.handleFetchEvaluatorResponse(json)
        })
    }
    
    private func handleFetchEvaluatorResponse(_ json: JSON) {
        self.deleteAllData("PE_Evaluator")
        let jsonObject = EvaluatorResponse(json)
        if jsonObject.evaluatorArray?.count ?? 0 > 0 {
            fetchApprovers()
        } else {
            dismissGlobalHUD(self.view)
        }
    }
    
    private func fetchApprovers(){
        ZoetisWebServices.shared.getApproversListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let approverSelf = self, error == nil else { return }
            approverSelf.handleFetchApproversResponse(json)
        })
    }
    
    private func handleFetchApproversResponse(_ json: JSON) {
        self.deleteAllData("PE_Approvers")
        let jsonObject = ApproverResponse(json)
        if jsonObject.approverArray?.count ?? 0 > 0 {
            fetchVisitTypes()
        } else {
            dismissGlobalHUD(self.view)
        }
    }
    
    private func fetchVisitTypes(){
        ZoetisWebServices.shared.getVisitTypesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let visitTypeSelf = self, error == nil else { return }
            visitTypeSelf.handleFetchVisitTypesResponse(json)
        })
    }
    
    private func handleFetchVisitTypesResponse(_ json: JSON) {
        self.deleteAllData("PE_VisitTypes")
        let jsonObject = VisitTypesResponse(json)
        if jsonObject.visitTypeArray?.count ?? 0 > 0 {
            fetchEvaluationTypes()
        } else {
            dismissGlobalHUD(self.view)
        }
    }
    
    private func fetchEvaluationTypes(){
        ZoetisWebServices.shared.getEvaluatorTypesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let evaluationTypeSelf = self, error == nil else { return }
            evaluationTypeSelf.handleFetchEvaluationTypesResponse(json)
        })
    }
    
    private func handleFetchEvaluationTypesResponse(_ json: JSON) {
        self.deleteAllData("PE_EvaluationType")
        let jsonObject = EvaluationTypeResponse(json)
        if jsonObject.evaluationTypeArray?.count ?? 0 > 0 {
            fetchSites()
        } else {
            dismissGlobalHUD(self.view)
        }
    }
    
    private func fetchSites(_ isEverytime:Bool = false){
        ZoetisWebServices.shared.getSitesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let siteSelf = self, error == nil else { return }
            siteSelf.handleFetchSitesResponse(json, isEverytime)
        })
    }
    
    private func handleFetchSitesResponse(_ json: JSON,_ isEverytime:Bool = false) {
        self.deleteAllData("PE_Sites")
        let jsonObject = SiteResponse(json)
        if isEverytime{
            dismissGlobalHUD(self.view)
        } else{
            if jsonObject.siteArray?.count ?? 0 > 0 {
                fetchtAssessmentCategoriesResponse()
            } else {
                dismissGlobalHUD(self.view)
            }
        }
    }
    
    
    // ---- Fetch Category Details for PVE -----------------
    
    internal func fetchtAssessmentCategoriesResponse(){
        let evalTypeId = String(peNewAssessment.evalType?.id ?? 1)
        ZoetisWebServices.shared.getAssessmentCategoriesDetailsPE(controller: self, evalType:evalTypeId, moduleID: "1"  , parameters: [:], completion: { [weak self] (json, error) in
            guard let `self` = self, error == nil else { return }
            if let responseJSONDict = json.dictionary{
                           if let response = responseJSONDict["Data"]{
                               let jsonDecoder = JSONDecoder()
                               let responseStr = response.description
                               if responseStr != ""{
                                   let jsonData = try? Data(responseStr.utf8)
                                                     if let data = jsonData{
                                                       let vaccinationCertificationObj = try? jsonDecoder.decode([ExtendedPECategoryDTO].self, from: data)

                                                       if  vaccinationCertificationObj != nil && vaccinationCertificationObj?.count ?? 0 > 0{
                                                        let index = vaccinationCertificationObj?.firstIndex(where: {
                                                            $0.id == 36
                                                        })
                                                        if index != nil{
                                                            let embrex =  vaccinationCertificationObj![index!]
                                                            SanitationEmbrexQuestionMasterDAO.sharedInstance.saveExtendedPEQuestions(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", plateTypeDTO: [embrex])
                                                        }
                                                       }
                                                       
                                                   
                                                       
                                                     }
                               }
                           }
                       }
            
            self.handleAssessmentCategoriesResponse(json)
        })
    }
    
    private func handleAssessmentCategoriesResponse(_ json: JSON) {
        DispatchQueue.main.async {
               UserDefaults.standard.setValue(nil, forKey:"QuestionAns")
               let jsonObject = PECategoriesAssesmentsResponse(json)
               self.saveJSON(json: json, key: "QuestionAns")
               self.fetchtQuestionInfo()
        }
       
    }
    
    internal func fetchtQuestionInfo(){
        let evalTypeId = String(peNewAssessment.evalType?.id ?? 1)
        ZoetisWebServices.shared.getAssessmentQuesInfoPE(controller: self, evalType:evalTypeId, moduleID: "1"  , parameters: [:], completion: { [weak self] (json, error) in
            guard let questionInfoSelf = self, error == nil else { return }
            questionInfoSelf.handlefetchtQuestionInfo(json)
        })
    }
    
    private func handlefetchtQuestionInfo(_ json: JSON) {
        
        let jsonObject = InfoImageDataResponse(json)
        saveJSON(json: json, key: "QuestionAnsInfo")
        fetchManufacturer()
    }
    
    private func fetchManufacturer(){
        ZoetisWebServices.shared.getManufacturerListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let manufacturerSelf = self, error == nil else { return }
            manufacturerSelf.handlefetchManufacturerResponse(json)
        })
    }
    
    
    private func handlefetchManufacturerResponse(_ json: JSON) {
        self.deleteAllData("PE_Manufacturer")
        let jsonObject = ManufacturerResponse(json)
        fetchBirdBreed()
    }
    
    private func fetchBirdBreed(){
        ZoetisWebServices.shared.getBirdBreedListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let birdBreedSelf = self, error == nil else { return }
            birdBreedSelf.handlefetchBirdBreedResponse(json)
        })
    }
    
    
    private func handlefetchBirdBreedResponse(_ json: JSON) {
        self.deleteAllData("PE_BirdBreed")
        let jsonObject = BreedBirdResponse(json)
        self.fetchEggs()
        
    }
    
    private func fetchEggs(){
        ZoetisWebServices.shared.getEggsListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let eggsSelf = self, error == nil else { return }
            eggsSelf.handlefetchEggsResponse(json)
        })
    }
    
    
    private func handlefetchEggsResponse(_ json: JSON) {
        self.deleteAllData("PE_Eggs")
        let jsonObject = EggsResponse(json)
        fetchVManufacturer()
        
        
    }
    
    private func fetchVManufacturer(){
        ZoetisWebServices.shared.getVaccineManufacturerListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let vManufacturerSelf = self, error == nil else { return }
            vManufacturerSelf.handlefetchVManufacturerResponse(json)
        })
    }
    
    
    private func handlefetchVManufacturerResponse(_ json: JSON) {
        
        self.deleteAllData("PE_VManufacturer")
        let jsonObject = VManufacturerResponse(json)
        fetchVaccineNames()
    }
        
    private func fetchVaccineNames(){
        ZoetisWebServices.shared.getVaccineNamesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let vaccineNameSelf = self, error == nil else { return }
            vaccineNameSelf.handlefetchVaccineNamesResponse(json)
        })
    }
    
    
    private func handlefetchVaccineNamesResponse(_ json: JSON) {
        self.deleteAllData("PE_VNames")
        let jsonObject = VNamesResponse(json)
        fetchDiluentManufacturer()
    }
    
    private func fetchDiluentManufacturer(){
        ZoetisWebServices.shared.getDiluentManufacturerList(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let diluentManufacturerSelf = self, error == nil else { return }
            diluentManufacturerSelf.handlefetchDiluentManufacturer(json)
        })
    }
    
    private func handlefetchDiluentManufacturer(_ json: JSON) {
        self.deleteAllData("PE_DManufacturer")
        let jsonObject = DManufacturerResponse(json)
        fetchBagSizes()
        
    }
    
    private func fetchBagSizes(){
        ZoetisWebServices.shared.getBagSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let bagSizesSelf = self, error == nil else { return }
            bagSizesSelf.handlefetchBagSizes(json)
        })
    }
    
    private func handlefetchBagSizes(_ json: JSON) {
        self.deleteAllData("PE_BagSizes")
        let jsonObject = BagSizeResponse(json)
        
        fetchAmplePerBag()
        
    }
    
    private func fetchAmplePerBag(){
        ZoetisWebServices.shared.getAmplePerBag(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let amplePerBagSelf = self, error == nil else { return }
            amplePerBagSelf.handlefetchAmplePerBag(json)
        })
    }
    
    private func handlefetchAmplePerBag(_ json: JSON) {
        self.deleteAllData("PE_AmplePerBag")
        let jsonObject = AmplePerBagResponse(json)
        fetchAmpleSizes()
    }
    
    private func fetchAmpleSizes(){
        ZoetisWebServices.shared.getAmpleSizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let ampleSizeSelf = self, error == nil else { return }
            ampleSizeSelf.handlefetchAmpleSizes(json)
        })
    }
    
    private func handlefetchAmpleSizes(_ json: JSON) {
        self.deleteAllData("PE_AmpleSizes")
        let jsonObject = AmpleSizeResponse(json)
        fetchRoles()
    }
    
    private func fetchRoles(){
        ZoetisWebServices.shared.getPERoles(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let rolesSelf = self, error == nil else { return }
            rolesSelf.handlefetchRoles(json)
        })
    }
    
    private func handlefetchRoles(_ json: JSON) {
        self.deleteAllData("PE_Roles")
        PERolesResponse(json)
        fetchDOADiluentType()
    }
      
    private func fetchDOADiluentType(){
        ZoetisWebServices.shared.getPEDOADiluentType(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let dOADiluentTypeSelf = self, error == nil else { return }
            dOADiluentTypeSelf.handlefetchDOADiluentType(json)
        })
    }
    
    private func handlefetchDOADiluentType(_ json: JSON) {
        self.deleteAllData("PE_DOADiluentType")
        PEDOADiluentTypeResponce(json)
        fetchSubVaccineNames()
    }
    
    
    private func fetchSubVaccineNames(){
        ZoetisWebServices.shared.getVaccineSubNamesListForPE(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let subVaccineNameSelf = self, error == nil else { return }
            subVaccineNameSelf.handlefetchSubVaccineNamesResponse(json)
        })
    }
    
    
    private func handlefetchSubVaccineNamesResponse(_ json: JSON) {
        self.deleteAllData("PE_VSubNames")
        let jsonObject = VSubNamesResponse(json)
        
        fetchPEFrequency()
        
    }
    
    private func fetchPEFrequency(){
          ZoetisWebServices.shared.getPEFrequency(controller: self, parameters: [:], completion: { [weak self] (json, error) in
              guard let pEFrequencySelf = self, error == nil else { return }
              pEFrequencySelf.handlefetchPEFrequency(json)
          })
      }
      
      private func handlefetchPEFrequency(_ json: JSON) {
          self.deleteAllData("PE_Frequency")
          PEFrequencyResponse(json)
          fetchIncubationStyle()
      }
    
    private func fetchIncubationStyle(){
          ZoetisWebServices.shared.getPEIncubationStyle(controller: self, parameters: [:], completion: { [weak self] (json, error) in
              guard let incubationStyleSelf = self, error == nil else { return }
              incubationStyleSelf.handlefetchIncubationStyle(json)
          })
      }
      
      private func handlefetchIncubationStyle(_ json: JSON) {
          self.deleteAllData("PE_IncubationStyle")
          PEIncubationStyleResponse(json)
          fetchDOASizes()
      }
    
    private func fetchDOASizes(){
          ZoetisWebServices.shared.getPEDOASizes(controller: self, parameters: [:], completion: { [weak self] (json, error) in
              guard let DOASSelf = self, error == nil else { return }
              DOASSelf.handlefetchDOASizes(json)
          })
      }
      
      private func handlefetchDOASizes(_ json: JSON) {
          self.deleteAllData("PE_DOASizes")
          PEDOASizesResponse(json)
          getPostingAssessmentListByUser()
      }
    
    
    
    
    
    
    // Api for get assesments
    
    func convertDateFormaterTo(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if date != nil{
        return  dateFormatter.string(from: date!)
        }
        return ""
    }
    
    
}

// MARK: - WebServices get assessments
extension PELandingPoupViewController {
    private func getPostingAssessmentListByUser() {
        ZoetisWebServices.shared.getPostedAssmntListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            self.handlGetPostingAssessmentListByUser(json)
                 
        })
    }
    
    private func handlGetPostingAssessmentListByUser(_ json: JSON) {
        var dataDic : [String:Any] = [:]
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        var dataArray = dataDic["Data"] as? [Any] ?? []
        if  dataArray.count  > 0 {
            self.deleteAllDataWithUserID("PE_AssessmentInOffline")
            self.deleteAllDataWithUserID("PE_AssessmentInDraft")
            self.deleteAllData("PE_ImageEntity")
            
        }
        
        for obj in dataArray {
           
            var objDic =  obj as? [String:Any] ?? [:]
            let SaveType = objDic["SaveType"] as? Int ?? 0
            
            if SaveType != 0 {
                    print("COMPLETED ASSESSMENT : ",self.convertDictToJson(dict: objDic,apiName: "COMPLETED ASSESSMENT :")
                              )
                let peNewAssessmentWas = PENewAssessment()
                let assessmentCommentsPostingData = objDic["AssessmentCommentsPostingData"] as? [[String:Any]] ?? []
                
                let assessmentScoresPostingData = objDic["AssessmentScoresPostingData"] as? [[String:Any]] ?? []
                let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                let serverAssessmentId = objDic["AssessmentId"] as? Int ?? 0
                
                let sanitationEmbrexValue = objDic["SanitationEmbrex"] as? Bool ?? false
                    if sanitationEmbrexValue {
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                    }
                
                           
                let sanitationEmbrex = objDic["SanitationEmbrexScoresPostinData"] as? [[String:Any]] ?? []
                let jsonData = try? JSONSerialization.data(withJSONObject: sanitationEmbrex, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                if jsonData != nil {
                    let dtoArr = try? jsonDecoder.decode([PESanitationDTO].self, from: jsonData!)
                    if dtoArr != nil {
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.saveServiceResponse(assessmentId: "\(serverAssessmentId)", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", dtoArr: dtoArr!)
                    }
                }
                let currentServerAssessmentId = UserDefaults.standard.set(String(serverAssessmentId), forKey: "currentServerAssessmentId")
                peNewAssessmentWas.serverAssessmentId = String(serverAssessmentId)
                let AppCreationTime = objDic["AppCreationTime"] as? String ?? ""
                peNewAssessmentWas.siteId = objDic["SiteId"] as? Int ?? 0
                peNewAssessmentWas.siteName = objDic["SiteName"] as? String ?? ""
                peNewAssessmentWas.customerId = objDic["CustomerId"] as? Int ?? 0
                peNewAssessmentWas.customerName = objDic["CustomerName"] as? String ?? ""
                peNewAssessmentWas.hatcheryAntibiotics = 0
                peNewAssessmentWas.evaluationID  = EvaluationId
               
                if let doubleSanitation =  objDic["DoubleSanitation"] as? Bool{
                    if doubleSanitation {
                        peNewAssessmentWas.hatcheryAntibiotics = 1
                    }
                }
                
                peNewAssessmentWas.userID = objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationDate = convertDateFormatter(date: objDic["EvaluationDate"] as? String ?? "")
                peNewAssessmentWas.visitID = objDic["VisitId"] as? Int ?? 0
                peNewAssessmentWas.visitName =  objDic["VisitName"] as? String ?? ""
                peNewAssessmentWas.selectedTSRID = objDic["TSRId"] as? Int ?? 0
                let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
                let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
                let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                if  peNewAssessmentWas.selectedTSRID != 0 {
                    if visitIDArray.contains( peNewAssessmentWas.selectedTSRID){
                        let indexOfe =  visitIDArray.index(of: peNewAssessmentWas.selectedTSRID)
                        let TSRName = visitNameArray[indexOfe] as? String ?? ""
                        peNewAssessmentWas.selectedTSR =  TSRName
                    }
                }
                peNewAssessmentWas.evaluatorName = objDic["UserName"] as? String ?? ""
                peNewAssessmentWas.evaluatorID =  objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationName = objDic["EvaluationName"] as? String ?? ""
                peNewAssessmentWas.evaluationID = objDic["EvaluationId"] as? Int ?? 0
                peNewAssessmentWas.incubation = objDic["IncubationStyleName"] as? String ?? ""
                peNewAssessmentWas.breedOfBird = objDic["BreedBirdsName"] as? String ?? ""
                peNewAssessmentWas.breedOfBirdOther = objDic["BreedOfBirdsOther"] as? String ?? ""
                peNewAssessmentWas.dataToSubmitID = objDic["AppCreationTime"] as? String ?? ""
                peNewAssessmentWas.manufacturer = objDic["ManufacturerName"] as? String ?? ""
                peNewAssessmentWas.refrigeratorNote = objDic["RefrigeratorNote"] as? String ?? ""
                let manuOthers = objDic["ManufacturerOther"] as? String ?? ""
                if manuOthers != "" {
                    peNewAssessmentWas.manufacturer = "S" + manuOthers
                }
                let eggStr = objDic["EggsPerFlatName"] as? String ?? "0"
                peNewAssessmentWas.noOfEggs = Int64(eggStr)
                let eggsOthers = objDic["EggsPerFlatOther"]  as? String ?? ""
                if eggsOthers != "" {
                    let txt = eggsOthers
                    let str =   txt  + "000"
                    let iii = Int64(str)
                    if  iii != nil{
                    peNewAssessmentWas.noOfEggs = iii!
                    }
                }
                let f = objDic["FlockAgeId"] as? Int ?? 0
                peNewAssessmentWas.isFlopSelected =  f
                let Camera =  objDic["Camera"]  as? Bool ?? false
                if  Camera == true {
                    peNewAssessmentWas.camera = 1
                } else {
                    peNewAssessmentWas.camera = 0
                }
                peNewAssessmentWas.notes = objDic["Notes"] as? String ?? ""
                let strBase64Signatture =  objDic["SignatureImage"] as? String ?? ""
                let representaiveName =  objDic["RepresentativeName"] as? String ?? ""
                let RoleName =  objDic["RoleName"] as? String ?? ""
                let imageData : Data? = Data(base64Encoded: strBase64Signatture, options: .ignoreUnknownCharacters)
                
                let strBase64Signatture2 =  objDic["SignatureImage2"] as? String ?? ""
                let representaiveName2 =  objDic["RepresentativeName2"] as? String ?? ""
                let RoleName2 =  objDic["RoleName2"] as? String ?? ""
               
                let imageData2 : Data = Data(base64Encoded: strBase64Signatture2, options: .ignoreUnknownCharacters) ?? Data()
                
                let representaiveNotes =  objDic["RepresentativeNotes"] as? String ?? ""
                
            
                let SignatureDate =  objDic["SignatureDate"] as? String ?? ""
                let id = self.saveImageInPEModule(imageData: imageData ?? Data())
                let id2 = self.saveImageInPEModule(imageData: imageData2)
                var sigDate = ""
                if SignatureDate != "" {
                    sigDate = self.convertDateFormat(inputDate: SignatureDate)
                } else {
                    sigDate = Date().stringFormat(format: "MMM d, yyyy")
                }
                let param : [String:String] = ["sig":String(id),"sig2":String(id2),"sig_Date":sigDate ,"sig_EmpID":RoleName,"sig_Name":representaiveName ?? "","sig_EmpID2":RoleName2,"sig_Name2":representaiveName2 ?? "","sig_Phone":representaiveNotes ?? ""]
                jsonRe = (getJSON("QuestionAns") ?? JSON())
                pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
                let questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
                let infoImageDataResponse = InfoImageDataResponse(questionInfo)
                let categoryCount = filterCategoryCount(peNewAssessmentOf: peNewAssessmentWas)
                if categoryCount > 0 {
                    for  cat in  pECategoriesAssesmentsResponse.peCategoryArray {
                        for (index, ass) in cat.assessmentQuestions.enumerated(){
                            var peNewAssessmentNew = PENewAssessment()
                            peNewAssessmentNew = peNewAssessmentWas
                            peNewAssessmentNew.serverAssessmentId = peNewAssessmentWas.serverAssessmentId
                            peNewAssessmentNew.cID = index
                            peNewAssessmentNew.catID = cat.id
                            peNewAssessmentNew.catName = cat.categoryName
                            peNewAssessmentNew.catMaxMark = cat.maxMark
                            peNewAssessmentNew.sequenceNo = cat.id
                            peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                            peNewAssessmentNew.catResultMark = cat.maxMark
                            peNewAssessmentNew.catEvaluationID = cat.evaluationID
                            peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                            peNewAssessmentNew.assID = ass.id
                            peNewAssessmentNew.assDetail1 = ass.assessment
                            peNewAssessmentNew.evaluationID = cat.evaluationID
                            peNewAssessmentNew.assDetail2 = ass.assessment2
                            peNewAssessmentNew.assMinScore = ass.minScore
                            peNewAssessmentNew.assMaxScore = ass.maxScore
                            peNewAssessmentNew.assCatType = ass.cateType
                            peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                            peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                            peNewAssessmentNew.assStatus = 1
                            peNewAssessmentNew.informationImage = ass.informationImage
                            peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                            peNewAssessmentNew.isAllowNA = ass.isAllowNA
                            peNewAssessmentNew.qSeqNo = ass.qSeqNo
                            peNewAssessmentNew.rollOut = ass.rollOut
                            peNewAssessmentNew.isNA = ass.isNA
                            CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                        }
                    }
                    let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                    var filterScoreData : [[String:Any]] = [[:]]
                    for questionMark in assessmentScoresPostingData {
                        let AssessmentScore = questionMark["AssessmentScore"] as? Int ?? 0
                        let QCCount = questionMark["QCCount"] as? String ?? ""
                        let FrequencyValue = questionMark["FrequencyValue"] as? Int ?? 32
                        var FrequencyValueStr = ""
                        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
                        let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
                        let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
                        if FrequencyValue != 32 {
                            if visitIDArray.contains(FrequencyValue){
                                let indexOfe =  visitIDArray.index(of: FrequencyValue) //
                                FrequencyValueStr = visitNameArray[indexOfe] as? String ?? ""
                            }
                        }
                        let TextAmPm = questionMark["TextAmPm"] as? String ?? ""
                        let PersonName = questionMark["PersonName"] as? String ?? ""
                        let isNA = questionMark["IsNA"] as? Bool ?? false
                        var assIDD = questionMark["ModuleAssessmentId"] as? Int ?? 64
                        CoreDataHandlerPE().update_isNAInAssessmentInProgress(isNA: isNA,assID:Int(truncating: (assIDD ?? 0) as NSNumber))
                        if FrequencyValueStr.count > 0 {
                            CoreDataHandlerPE().updateFrequencyInAssessmentInProgress(frequency:FrequencyValueStr)
                        }
                        if QCCount.count > 0 {
                            CoreDataHandlerPE().updateQCCountInAssessmentInProgress(qcCount:QCCount)
                        }
                        if PersonName.count > 0 {
                            CoreDataHandlerPE().updatePersonNameInAssessmentInProgress(personName: PersonName)
                        }
                        if TextAmPm.count > 0 {
                            CoreDataHandlerPE().updateAMPMInAssessmentInProgress(ampmValue: TextAmPm)
                        }
                        if AssessmentScore  ==  0  {
                            filterScoreData.append(questionMark)
                        }
                    }
                    var assArray : [Int] = []
                    for cat in filterScoreData {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        assArray.append(assID)
                    }
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assArray {
                            if ( Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInAnsInProgressTable(catISSelected:catISSelected,catResultMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(truncating: objMark.assID ?? 0), userID:Int(truncating: objMark.userID ?? 0))
                            }
                        }
                    }
                    //score ends
                    //comment start
                    var filterCommentData : [[String:Any]] = [[:]]
                    for questionMark in assessmentCommentsPostingData {
                        let AssessmentComment = questionMark["AssessmentComment"] as? String ?? ""
                        if AssessmentComment.count > 0  {
                            filterCommentData.append(questionMark)
                        }
                    }
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in filterCommentData {
                            let AssessmentComment = assID["AssessmentComment"] as? String ?? ""
                            let AssessmentId = assID["AssessmentId"] as? Int ?? 0
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().updateNoteInProgressTable(assID:Int(truncating: objMark.assID ?? 0),text:AssessmentComment)
                            }
                        }
                    }
                    //comment ends
                    let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                    let InovojectPostingData = objDic["InovojectPostingData"] as? [Any] ?? []
                    let VaccineMixerObservedPostingData = objDic["VaccineMixerObservedPostingData"] as? [Any] ?? []
                    
                    // INOVOJECT
                    for inoDic in InovojectPostingData {
                        
                        let inoDicIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = inoDicIS["Dosage"] as? String ?? ""
                        let otherString = inoDicIS["OtherText"] as? String ?? ""
                        let VaccineId = inoDicIS["VaccineId"] as? Int ?? 0
                        let AmpuleSize = inoDicIS["AmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        let AntibioticInformation =  inoDicIS["AntibioticInformation"] as? String ?? ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = inoDicIS["AmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  inoDicIS["HatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = inoDicIS["ManufacturerId"] as? Int ?? 0
                        let BagSizeType = inoDicIS["BagSizeType"] as? String ?? ""
                        let DiluentMfg = inoDicIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        let ProgramName = inoDicIS["ProgramName"] as? String ?? ""
                        let DiluentsMfgOtherName = inoDicIS["DiluentsMfgOtherName"] as? String ?? ""

                        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                 
                        var vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        var vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }  else {
                            VName = otherString
                        }
                        
                        if otherString != "" {
                            VName = otherString
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        var HatcheryAntibioticsIntVal = 0
                        if HatcheryAntibiotics == true{
                            HatcheryAntibioticsIntVal = 1
                        } else {
                            HatcheryAntibioticsIntVal = 0
                        }
                        
                        peNewAssessmentInProgress.iCS  = inoDicIS["BagSizeType"] as? String ?? ""
                        let diluentMfg  = inoDicIS["DiluentMfg"] as? String ?? ""
                        peNewAssessmentInProgress.iDT = diluentMfg
                        
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromInvo: true)

                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                          let inovojectData = InovojectData(info: info)
                        
                        let id = self.saveInovojectInPEModule(inovojectData: inovojectData, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        inovojectData.id = id
                        
                    }
                    let DayPostingData = objDic["DayOfAgePostingData"] as? [Any] ?? []
                    //Day OF AGE
                    for inoDic in DayPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayOfAgeDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayOfAgeMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayOfAgeAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = DayOfAgeIS["DayOfAgeAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayOfBagHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayOfAgeMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayOfAgeBagSizeType"] as? String ?? ""
                        
                        let DiluentMfg = DayOfAgeIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""

                        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx) // 3
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                        }

                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)
                        
                        var  vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var  vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                                
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        
                          let DayOfAgeDataNew = InovojectData(info: info)
                        
                        peNewAssessmentInProgress.dCS  = DiluentMfg
                        peNewAssessmentInProgress.dDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaText = AntibioticInformation
                         let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoa : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        DayOfAgeDataNew.id = id
                    }
                    
                    let DayAgeSubcutaneousDetailsPostingData = objDic["DayAgeSubcutaneousDetailsPostingData"] as? [Any] ?? []
                    
                    for inoDic in DayAgeSubcutaneousDetailsPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayAgeSubcutaneousDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayAgeSubcutaneousMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayAgeSubcutaneousAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        let AmpulePerbag = DayOfAgeIS["DayAgeSubcutaneousAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayAgeSubcutaneousHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayAgeSubcutaneousMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayAgeSubcutaneousBagSizeType"] as? String ?? ""
                        let DiluentMfg = DayOfAgeIS["DayAgeSubcutaneousDiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""

                        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }

                        var vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
                        var vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        } else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()

                        let info = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: info)
                        
                        peNewAssessmentInProgress.dDCS  = DiluentMfg
                        peNewAssessmentInProgress.dDDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaSText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoaS : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(),fromDoaS: true)
                        DayOfAgeDataNew.id = id
                    }
                    //VMIXER
                    for  vmixer in  VaccineMixerObservedPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var CertificationDate = vmixerIS["CertificationDate"] as? String ?? ""
                        var CertificationDateIS = ""
                        if CertificationDate != "" {
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "T", with: "")
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "00", with: "")
                            CertificationDate = CertificationDate.replacingOccurrences(of: ":", with: "")
                            let array = CertificationDate.components(separatedBy: "-")
                            let date = array[2]
                            let month = array[1]
                            let year = array[0]
                            CertificationDateIS = month + "-" +  date + "-" +  year
                        }
                        let isCertExpired = vmixerIS["IsCertExpired"] as? Bool ?? false
                        let isReCert = vmixerIS["IsReCert"] as? Bool ?? false
                        let vacOperatorId = vmixerIS["vacOperatorId"] as? Int ?? 0
                        let signatureImg = vmixerIS["SignatureImg"] as? String ?? ""
                        let isManuallyAdded = vmixerIS["isManuallyAdded"] as? Bool ?? false
                        
                        let imageCount = getVMixerCountInPEModule()
                        
                        let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:imageCount + 1,
                                                                                         name:Name,
                                                                                         date:CertificationDateIS,
                                                                                         isCertExpired: isCertExpired,
                                                                                         isReCert: isReCert,
                                                                                         vacOperatorId: vacOperatorId,
                                                                                         signatureImg: signatureImg,
                                                                                         fsrSign: "", isManuallyAdded: isManuallyAdded)
                        let certificateData = PECertificateData(info: certificModel)
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        CoreDataHandlerPE().saveVMixerPEModuleGet(peCertificateData: certificateData,evalutionID:peNewAssessmentInProgress.evaluationID)
                    }
                    let VaccineMicroSamplesPostingData = objDic["VaccineMicroSamplesPostingData"] as? [Any] ?? []
                    //Micro
                    for  vmixer in  VaccineMicroSamplesPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.micro  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    let VaccineResiduePostinData = objDic["VaccineResiduePostinData"] as? [Any] ?? []
                    //Residue
                    for  vmixer in  VaccineResiduePostinData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.residue  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    let dataToSubmitNumber = self.getAssessmentInOfflineFromDb()
                    for obj in allAssesmentArr {
                        CoreDataHandlerPE().saveDataToSyncPEInDBFromGet(newAssessment: obj as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(), dataToSubmitNumber: dataToSubmitNumber + 1,param:param,formateFromServer: AppCreationTime)
                    }
                    CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
                    CoreDataHandler().deleteAllData("PE_Refrigator")
                }
            } else {
                print("Draft ASSESSMENT : ",self.convertDictToJson(dict: objDic,apiName: "COMPLETED ASSESSMENT :")
                                         )
                
                let peNewAssessmentWas = PENewAssessment()
                let assessmentCommentsPostingData = objDic["AssessmentCommentsPostingData"] as? [[String:Any]] ?? []
                let assessmentScoresPostingData = objDic["AssessmentScoresPostingData"] as? [[String:Any]] ?? []
                let EvaluationId = objDic["EvaluationId"] as? Int ?? 0
                             
                
                let serverAssessmentId = objDic["AssessmentId"] as? Int ?? 0
                let sanitationEmbrexValue = objDic["SanitationEmbrex"] as? Bool ?? false
                if sanitationEmbrexValue {
                    let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil, override: false)
                    PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                }
                
                let sanitationEmbrex = objDic["SanitationEmbrexScoresPostinData"] as? [[String:Any]] ?? []
                let jsonData = try? JSONSerialization.data(withJSONObject: sanitationEmbrex, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                if jsonData != nil{
                    let dtoArr = try? jsonDecoder.decode([PESanitationDTO].self, from: jsonData!)
                    if dtoArr != nil{
                        SanitationEmbrexQuestionMasterDAO.sharedInstance.saveServiceResponse(assessmentId: "\(serverAssessmentId)", userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", dtoArr: dtoArr!)
                    }
                    
                }
                UserDefaults.standard.set(String(serverAssessmentId), forKey: "currentServerAssessmentId")
                peNewAssessmentWas.serverAssessmentId = String(serverAssessmentId)
                let AppCreationTime = objDic["AppCreationTime"] as? String ?? ""
                let DeviceId = objDic["DeviceId"] as? String ?? ""
                peNewAssessmentWas.siteId = objDic["SiteId"] as? Int ?? 0
                peNewAssessmentWas.siteName = objDic["SiteName"] as? String ?? ""
                peNewAssessmentWas.customerId = objDic["CustomerId"] as? Int ?? 0
                peNewAssessmentWas.customerName = objDic["CustomerName"] as? String ?? ""
                peNewAssessmentWas.userID = objDic["UserId"] as? Int ?? 0
                peNewAssessmentWas.evaluationDate = convertDateFormatter(date: objDic["EvaluationDate"] as? String ?? "")
                peNewAssessmentWas.visitID = objDic["VisitId"] as? Int ?? 0
                peNewAssessmentWas.visitName =  objDic["VisitName"] as? String ?? ""
                peNewAssessmentWas.selectedTSRID = objDic["TSRId"] as? Int ?? 0
                peNewAssessmentWas.hatcheryAntibiotics = 0
                peNewAssessmentWas.evaluationID  = EvaluationId
                
                if let doubleSanitation =  objDic["DoubleSanitation"] as? Bool{
                    if doubleSanitation {
                        peNewAssessmentWas.hatcheryAntibiotics = 1
                    }
                }
                let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Approvers")
                let visitNameArray = visitDetailsArray.value(forKey: "username") as? NSArray ?? NSArray()
                let visitIDArray = visitDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                if  peNewAssessmentWas.selectedTSRID != 0 {
                    if visitIDArray.contains( peNewAssessmentWas.selectedTSRID){
                        let indexOfe =  visitIDArray.index(of: peNewAssessmentWas.selectedTSRID)
                        let TSRName = visitNameArray[indexOfe] as? String ?? ""
                        peNewAssessmentWas.selectedTSR =  TSRName
                    }
                }
                
                
                
                peNewAssessmentWas.evaluatorName = objDic["UserName"] as? String ?? ""
                peNewAssessmentWas.evaluatorID =  objDic["UserId"] as? Int ?? 0
                
                peNewAssessmentWas.evaluationName = objDic["EvaluationName"] as? String ?? ""
                peNewAssessmentWas.evaluationID = objDic["EvaluationId"] as? Int ?? 0
                
                peNewAssessmentWas.incubation = objDic["IncubationStyleName"] as? String ?? ""
                peNewAssessmentWas.breedOfBird = objDic["BreedBirdsName"] as? String ?? ""
                peNewAssessmentWas.breedOfBirdOther = objDic["BreedOfBirdsOther"] as? String ?? ""
                peNewAssessmentWas.dataToSubmitID = objDic["DeviceId"] as? String ?? ""
                
                peNewAssessmentWas.manufacturer = objDic["ManufacturerName"] as? String ?? ""
                let manuOthers = objDic["ManufacturerOther"] as? String ?? ""
                if manuOthers != "" {
                    peNewAssessmentWas.manufacturer = "S" + manuOthers
                }
                let eggStr = objDic["EggsPerFlatName"] as? String ?? "0"
                peNewAssessmentWas.noOfEggs = Int64(eggStr)
                
                let eggsOthers = objDic["EggsPerFlatOther"]  as? String ?? ""
                if eggsOthers != "" {
                    let txt = eggsOthers
                    let str =   txt  + "000"
                    let iii = Int64(str)
                    if iii != nil{
                    peNewAssessmentWas.noOfEggs = iii!
                    }
                    
                }
                
                let f = objDic["FlockAgeId"] as? Int ?? 0
                peNewAssessmentWas.isFlopSelected =  f
                let Camera =  objDic["Camera"]  as? Bool ?? false
                if  Camera == true {
                    peNewAssessmentWas.camera = 1
                } else {
                    peNewAssessmentWas.camera = 0
                }
                
                peNewAssessmentWas.notes = objDic["Notes"] as? String ?? ""
                
                
                jsonRe = (getJSON("QuestionAns") ?? JSON())
                pECategoriesAssesmentsResponse =  PECategoriesAssesmentsResponse(jsonRe)
                let questionInfo = (getJSON("QuestionAnsInfo") ?? JSON())
                let infoImageDataResponse = InfoImageDataResponse(questionInfo)
                
                let categoryCount = filterCategoryCount(peNewAssessmentOf: peNewAssessmentWas)
                if categoryCount > 0 {
                    for  cat in  pECategoriesAssesmentsResponse.peCategoryArray {
                        for (index, ass) in cat.assessmentQuestions.enumerated(){
                            var peNewAssessmentNew = PENewAssessment()
                            peNewAssessmentNew = peNewAssessmentWas
                            peNewAssessmentNew.cID = index
                            peNewAssessmentNew.catID = cat.id
                            peNewAssessmentNew.catName = cat.categoryName
                            peNewAssessmentNew.catMaxMark = cat.maxMark
                            peNewAssessmentNew.sequenceNo = cat.id
                            peNewAssessmentNew.sequenceNoo = cat.sequenceNo
                            peNewAssessmentNew.catResultMark = cat.maxMark
                            peNewAssessmentNew.catEvaluationID = cat.evaluationID
                            peNewAssessmentNew.catISSelected = cat.isSelected ? 1:0
                            peNewAssessmentNew.assID = ass.id
                            peNewAssessmentNew.assDetail1 = ass.assessment
                            peNewAssessmentNew.evaluationID = cat.evaluationID
                            peNewAssessmentNew.assDetail2 = ass.assessment2
                            peNewAssessmentNew.assMinScore = ass.minScore
                            peNewAssessmentNew.assMaxScore = ass.maxScore
                            peNewAssessmentNew.assCatType = ass.cateType
                            peNewAssessmentNew.assModuleCatID = ass.moduleCatId
                            peNewAssessmentNew.assModuleCatName = ass.moduleCatName
                            peNewAssessmentNew.assStatus = 1
                            peNewAssessmentNew.informationImage = ass.informationImage
                            peNewAssessmentNew.informationText = infoImageDataResponse.getInfoTextByQuestionId(questionID: ass.id ?? 151)
                            peNewAssessmentNew.isAllowNA = ass.isAllowNA
                            peNewAssessmentNew.qSeqNo = ass.qSeqNo
                            peNewAssessmentNew.rollOut = ass.rollOut
                            peNewAssessmentNew.isNA = ass.isNA
                            CoreDataHandlerPE().saveNewAssessmentInProgressInDB(newAssessment:peNewAssessmentNew)
                        }
                    }
                    let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
                    var filterScoreData : [[String:Any]] = [[:]]
                    for questionMark in assessmentScoresPostingData {
                        let AssessmentScore = questionMark["AssessmentScore"] as? Int ?? 0
                        let QCCount = questionMark["QCCount"] as? String ?? ""
                        
                        let FrequencyValue = questionMark["FrequencyValue"] as? Int ?? 32
                         var FrequencyValueStr = ""
                       
                        let visitDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_Frequency")
                        let visitNameArray = visitDetailsArray.value(forKey: "frequencyName") as? NSArray ?? NSArray()
                        let visitIDArray = visitDetailsArray.value(forKey: "frequencyId") as? NSArray ?? NSArray()
                        if FrequencyValue != 32 {
                            if visitIDArray.contains(FrequencyValue){
                                let indexOfe =  visitIDArray.index(of: FrequencyValue) //
                                FrequencyValueStr = visitNameArray[indexOfe] as? String ?? ""
                            }
                        }
                        
                        
                        let TextAmPm = questionMark["TextAmPm"] as? String ?? ""
                        let PersonName = questionMark["PersonName"] as? String ?? ""
                        let isNA = questionMark["IsNA"] as? Bool ?? false
                        var assIDD = questionMark["ModuleAssessmentId"] as? Int ?? 64
                        CoreDataHandlerPE().update_isNAInAssessmentInProgress(isNA: isNA,assID:Int(truncating: (assIDD ?? 0) as NSNumber))
                        if QCCount.count > 0 {
                            CoreDataHandlerPE().updateQCCountInAssessmentInProgress(qcCount:QCCount)
                        }
                        if FrequencyValueStr.count > 0 {
                            CoreDataHandlerPE().updateFrequencyInAssessmentInProgress(frequency:FrequencyValueStr)
                        }
                        if PersonName.count > 0 {
                            CoreDataHandlerPE().updatePersonNameInAssessmentInProgress(personName: PersonName)
                        }
                        if TextAmPm.count > 0 {
                            CoreDataHandlerPE().updateAMPMInAssessmentInProgress(ampmValue: TextAmPm)
                        }
                        
                        if AssessmentScore  ==  0  {
                            filterScoreData.append(questionMark)
                        }
                    }
                    
                    var assArray : [Int] = []
                    for cat in filterScoreData {
                        let assID = cat["ModuleAssessmentId"] as? Int ?? 0
                        assArray.append(assID)
                    }
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in assArray {
                            
                            if ( Int(truncating: objMark.assID ?? 0) == assID ) {
                                var totalMark = GetLatestMarkOfAss(assID: objMark.assID as? Int ?? 0)
                                let catISSelected = 0
                                let maxMarks =  objMark.assMaxScore ?? 0
                                let reMark = Int(totalMark) - Int(truncating: maxMarks)
                                totalMark = Int(truncating: NSNumber(value: reMark))
                                CoreDataHandlerPE().updateChangeInAnsInProgressTable(catISSelected:catISSelected,catResultMark:Int(totalMark),catID:Int(truncating: objMark.catID ?? 0),assID:Int(objMark.assID ?? 0), userID:Int(objMark.userID ?? 0))
                            }
                            
                        }
                    }
                    //score ends
                    //comment start
                    var filterCommentData : [[String:Any]] = [[:]]
                    for questionMark in assessmentCommentsPostingData {
                        let AssessmentComment = questionMark["AssessmentComment"] as? String ?? ""
                        if AssessmentComment.count > 0  {
                            filterCommentData.append(questionMark)
                        }
                    }
                    
                    
                    for qMark in allAssesmentArr {
                        let objMark = qMark as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
                        for assID in filterCommentData {
                            let AssessmentComment = assID["AssessmentComment"] as? String ?? ""
                            let AssessmentId = assID["AssessmentId"] as? Int ?? 0
                            
                            if ( Int(truncating: objMark.assID ?? 0) == AssessmentId ) {
                                CoreDataHandlerPE().updateNoteInProgressTable(assID:Int(objMark.assID ?? 0),text:AssessmentComment)
                            }
                        }
                    }
                    //comment ends
                    let InovojectPostingData = objDic["InovojectPostingData"] as? [Any] ?? []
                    
                    let VaccineMixerObservedPostingData = objDic["VaccineMixerObservedPostingData"] as? [Any] ?? []
                    
                    
                    for inoDic in InovojectPostingData {
                        
                        let inoDicIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = inoDicIS["Dosage"] as? String ?? ""
                        let otherString = inoDicIS["OtherText"] as? String ?? ""
                        let VaccineId = inoDicIS["VaccineId"] as? Int ?? 0
                        let AmpuleSize = inoDicIS["AmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""
                        let AntibioticInformation =  inoDicIS["AntibioticInformation"] as? String ?? ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = inoDicIS["AmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  inoDicIS["HatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = inoDicIS["ManufacturerId"] as? Int ?? 0
                        let BagSizeType = inoDicIS["BagSizeType"] as? String ?? ""
                        let DiluentMfg = inoDicIS["DiluentMfg"] as? String ?? ""
                        var VName = ""
                        let ProgramName = inoDicIS["ProgramName"] as? String ?? ""
                        let DiluentsMfgOtherName = inoDicIS["DiluentsMfgOtherName"] as? String ?? ""

                        var vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        var vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }  else {
                            VName = otherString
                        }
                        
                        if otherString != "" {
                            VName = otherString
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        var HatcheryAntibioticsIntVal = 0
                        if HatcheryAntibiotics == true{
                            HatcheryAntibioticsIntVal = 1
                        } else {
                            HatcheryAntibioticsIntVal = 0
                        }
                        
                        peNewAssessmentInProgress.iCS  = inoDicIS["BagSizeType"] as? String ?? ""
                        let diluentMfg  = inoDicIS["DiluentMfg"] as? String ?? ""
                        peNewAssessmentInProgress.iDT = diluentMfg
                        
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromInvo: true)

                        var inVoDataNew = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:DiluentMfg,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg,invoHatchAntibiotic: HatcheryAntibioticsIntVal, invoHatchAntibioticText: AntibioticInformation,  invoProgramName: ProgramName, doaDilManOther: DiluentsMfgOtherName)
                        let DayOfAgeDataNew = InovojectData(info: inVoDataNew)
                        let id = self.saveInovojectInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        inVoDataNew.id = id
                    }
                    
                    
                    let DayPostingData = objDic["DayOfAgePostingData"] as? [Any] ?? []
                    for inoDic in DayPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayOfAgeDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayOfAgeMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayOfAgeAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        
                        let AmpulePerbag = DayOfAgeIS["DayOfAgeAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayOfBagHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayOfAgeMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayOfAgeBagSizeType"] as? String ?? ""
                        
                        let DiluentMfg = DayOfAgeIS["DiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx) // 3
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                        }

                        var vDetailsArray = NSArray()
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VNames")
                        vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 1)

                        var  vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var  vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        }else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                                
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        let inVoDataNew = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: inVoDataNew)
                        
                        peNewAssessmentInProgress.dCS  = DiluentMfg
                        peNewAssessmentInProgress.dDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoa = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: infoObj?.subcutaneousAntibioticTxt, dayOfAgeTxt: AntibioticInformation)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoa : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress())
                        DayOfAgeDataNew.id = id
                    }
                    
                    
                    let DayAgeSubcutaneousDetailsPostingData = objDic["DayAgeSubcutaneousDetailsPostingData"] as? [Any] ?? []
                    
                    
                    for inoDic in DayAgeSubcutaneousDetailsPostingData {
                        
                        let DayOfAgeIS = inoDic as? [String:Any] ?? [:]
                        let Dosage = DayOfAgeIS["DayAgeSubcutaneousDosage"] as? String ?? ""
                        let otherText = DayOfAgeIS["OtherText"] as? String ?? ""
                        let VaccineId = DayOfAgeIS["DayAgeSubcutaneousMfgNameId"] as? Int ?? 0
                        let AmpuleSize = DayOfAgeIS["DayAgeSubcutaneousAmpuleSize"] as? Int ?? 0
                        var AmpuleSizeStr = ""

                        var ampleSizeDetailArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AmpleSizes")
                        var ampleSizeesNameArray = ampleSizeDetailArray.value(forKey: "size") as? NSArray ?? NSArray()
                        var ampleSizeIDArray = ampleSizeDetailArray.value(forKey: "id") as? NSArray ?? NSArray()
                        if AmpuleSize != 0 {
                            let indexOfe =  ampleSizeIDArray.index(of: AmpuleSize)
                            AmpuleSizeStr = ampleSizeesNameArray[indexOfe] as? String  ?? ""
                        }
                        let AmpulePerbag = DayOfAgeIS["DayAgeSubcutaneousAmpulePerbag"] as? Int ?? 0
                        let HatcheryAntibiotics =  DayOfAgeIS["DayAgeSubcutaneousHatcheryAntibiotics"] as? Bool ?? false
                        let ManufacturerId = DayOfAgeIS["DayAgeSubcutaneousMfgId"] as? Int ?? 0
                        let BagSizeType = DayOfAgeIS["DayAgeSubcutaneousBagSizeType"] as? String ?? ""
                        let DiluentMfg = DayOfAgeIS["DayAgeSubcutaneousDiluentMfg"] as? String ?? ""
                        var VManufacturerName = ""
                        var VName = ""
                 
                        var vManufacutrerDetailsArray = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VManufacturer")
                        var vManufacutrerNameArray = vManufacutrerDetailsArray.value(forKey: "mfgName") as? NSArray ?? NSArray()
                        var vManufacutrerIDArray = vManufacutrerDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxx =    ManufacturerId
                        if xxx != 0 {
                            let indexOfd = vManufacutrerIDArray.index(of: xxx)
                            if vManufacutrerNameArray.count > indexOfd{
                            VManufacturerName = vManufacutrerNameArray[indexOfd] as? String ?? ""
                            }
                        }
                
                        var vDetailsArray = CoreDataHandlerPE().fetchDetailsForVaccineNames(typeId: 2)
                        var vNameArray = vDetailsArray.value(forKey: "name") as? NSArray ?? NSArray()
                        var vIDArray = vDetailsArray.value(forKey: "id") as? NSArray ?? NSArray()
                        let xxxx =    VaccineId
                        if xxxx != 0 {
                            if vIDArray.contains(xxxx){
                                let indexOfd = vIDArray.index(of: xxxx) // 3
                                VName = vNameArray[indexOfd] as? String ?? ""
                            }
                        } else {
                            if VManufacturerName.lowercased().contains("other"){
                                VName  = otherText
                            }
                        }
                        if otherText != "" {
                            VName = otherText
                        }
                        
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()

                        let inVoDataNew = CoreDataHandlerPEModels.InovojectInfo(id: 0,vaccineMan:VManufacturerName,name:VName,ampuleSize:AmpuleSizeStr,ampulePerBag:String(AmpulePerbag),bagSizeType:BagSizeType,dosage:Dosage, dilute: DiluentMfg)
                        let DayOfAgeDataNew = InovojectData(info: inVoDataNew)
                        
                        peNewAssessmentInProgress.dDCS  = DiluentMfg
                        peNewAssessmentInProgress.dDDT = BagSizeType
                        peNewAssessmentInProgress.micro  = ""
                        peNewAssessmentInProgress.residue = ""
                        if HatcheryAntibiotics == true{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 1
                        } else{
                            peNewAssessmentInProgress.hatcheryAntibioticsDoaS = 0
                        }
                        let AntibioticInformation = DayOfAgeIS["AntibioticInformation"] as? String ?? ""
                        peNewAssessmentInProgress.hatcheryAntibioticsDoaSText = AntibioticInformation
                        let infoObj = PEInfoDAO.sharedInstance.fetchInfoVMObj(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", assessmentId: "\(serverAssessmentId)")
                        
                        let data = CoreDataHandlerPEModels.doaVaccinationSaveData(userId: UserContext.sharedInstance.userDetailsObj?.userId ?? "", isExtendedPE: sanitationEmbrexValue, assessmentId: "\(serverAssessmentId)", date: nil,subcutaneousTxt: AntibioticInformation, dayOfAgeTxt: infoObj?.dayOfAgeTxtAntibiotic)
                        PEInfoDAO.sharedInstance.saveData(vaccineData: data)
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress,fromDoaS : true)
                        let id = self.saveDOAInPEModule(inovojectData: DayOfAgeDataNew, assessment: allAssesmentArr[0] as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(),fromDoaS: true)
                        DayOfAgeDataNew.id = id
                    }
                    
                    for  vmixer in  VaccineMixerObservedPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        var CertificationDate = vmixerIS["CertificationDate"] as? String ?? ""
                        var CertificationDateIS = ""
                        if CertificationDate != "" {
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "T", with: "")
                            CertificationDate =  CertificationDate.replacingOccurrences(of: "00", with: "")
                            CertificationDate = CertificationDate.replacingOccurrences(of: ":", with: "")
                            let array = CertificationDate.components(separatedBy: "-")
                            let date = array[2]
                            let month = array[1]
                            let year = array[0]
                            CertificationDateIS = month + "-" +  date + "-" +  year
                        }
                        let isCertExpired = vmixerIS["IsCertExpired"] as? Bool ?? false
                        let isReCert = vmixerIS["IsReCert"] as? Bool ?? false
                        let vacOperatorId = vmixerIS["vacOperatorId"] as? Int ?? 0
                        let signatureImg = vmixerIS["SignatureImg"] as? String ?? ""
                        let isManuallyAdded = vmixerIS["isManuallyAdded"] as? Bool ?? false
                        let imageCount = getVMixerCountInPEModule()
                        let certificModel = CoreDataHandlerPEModels.CertificateInfo.init(id:imageCount + 1,name:Name,date:CertificationDateIS,isCertExpired: isCertExpired,isReCert: isReCert,vacOperatorId: vacOperatorId, signatureImg: signatureImg, fsrSign: "", isManuallyAdded: isManuallyAdded)
                        
                        let certificateData = PECertificateData(info: certificModel)
                        
                        let peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        
                        CoreDataHandlerPE().saveVMixerPEModuleGet(peCertificateData: certificateData,evalutionID:peNewAssessmentInProgress.evaluationID)
                    }
                    
                    var VaccineMicroSamplesPostingData = objDic["VaccineMicroSamplesPostingData"] as? [Any] ?? []
                    //Micro
                    for  vmixer in  VaccineMicroSamplesPostingData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.micro  = Name
                        
                        
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                        
                    }
                    let VaccineResiduePostinData = objDic["VaccineResiduePostinData"] as? [Any] ?? []
                    
                    //Residue
                    for  vmixer in  VaccineResiduePostinData{
                        let vmixerIS = vmixer as? [String:Any] ?? [:]
                        let Name = vmixerIS["Name"] as? String ?? ""
                        let  peNewAssessmentInProgress = CoreDataHandlerPE().getSavedOnGoingAssessmentPEObject()
                        peNewAssessmentInProgress.residue  = Name
                        CoreDataHandlerPE().updateInDoGInProgressInDB(newAssessment:peNewAssessmentInProgress)
                    }
                    
                    //Saving in Progress Data to Draft
                    let draftNumber = getDraftCountFromDb()
                    for obj in allAssesmentArr {
                        CoreDataHandlerPE().saveGetDraftDataToSyncPEInDBFromGet(newAssessment: obj as? PE_AssessmentInProgress ?? PE_AssessmentInProgress(), dataToSubmitNumber: draftNumber + 1,param:[:],formateFromServer: AppCreationTime,deviceID:DeviceId)
                    }
                    CoreDataHandler().deleteAllData("PE_AssessmentInProgress")
                    CoreDataHandler().deleteAllData("PE_Refrigator")
                }
            }
        }
        getPostingAssessmentImagesListByUser()
        getScheduledAssessments()
    }
    
    private func getScheduledAssessments() {
       
        PEDataService.sharedInstance.getScheduledAssessments(loginuserId: UserContext.sharedInstance.userDetailsObj?.userId ?? "No id found", viewController: self, completion: { [weak self] (status, error) in
            guard let _ = self, error == nil else {
                self?.dismissGlobalHUD(self?.view ?? UIView());
                return
            }
        })
    }
    
    
    private func getPostingAssessmentImagesListByUser() {
        ZoetisWebServices.shared.getPostingAssessmentListByUser(controller: self, parameters: [:], completion: { [weak self] (json, error) in
            guard let zoetisSelf = self, error == nil else { return }
            
            zoetisSelf.handlGetPostingAssessmentImagesListByUser(json)
        })
    }
    
    
    private func handlGetPostingAssessmentImagesListByUser(_ json: JSON) {

        var dataDic : [String:Any] = [:]
      
        if let string = json.rawString() {
            dataDic = string.convertToDictionary() ?? [:]
        }
        
        var dataArray = dataDic["Data"] as? [Any] ?? []
        
        for obj in dataArray {
            DispatchQueue.main.async {
                
                var objDic =  obj as? [String:Any] ?? [:]
                let base64Encoded = objDic["ImageBase64"] as? String ?? ""
                let DisplayId = objDic["DisplayId"] as? String ?? ""
                let DeviceId = objDic["Device_Id"] as? String ?? ""
                let UserId = objDic["UserId"] as? Int ?? 0
                let Assessment_Id = objDic["Assessment_Id"] as? Int ?? 0
                let Module_Assessment_Categories_Id = objDic["Module_Assessment_Categories_Id"] as? Int ?? 0
                let decodedData = Data(base64Encoded: base64Encoded) ?? Data()
                let AppCreationTime = DisplayId.replacingOccurrences(of: "C-", with: "")
                
                let imageCount = self.getImageCountInPEModule()
                CoreDataHandlerPE().saveImageInGetApi(imageId:imageCount+1,imageData:decodedData)
                
                CoreDataHandlerPE().saveImageIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:AppCreationTime)
                CoreDataHandlerPE().saveImageDraftIdGetApi(imageId:imageCount+1,userID:UserId,catID:Module_Assessment_Categories_Id,assID:Assessment_Id,dataToSubmitID:DeviceId)
                
            }
        }
        dismissGlobalHUD(self.view)
    }
    
    
    func getImageCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_ImageEntity")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "imageId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    
    
    
    private func GetLatestMarkOfAss(assID:Int) -> Int{
        let allAssesmentArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_AssessmentInProgress")
        for ass in allAssesmentArr{
            let objMark = ass as? PE_AssessmentInProgress ?? PE_AssessmentInProgress()
            if Int(objMark.assID ?? 0) == assID{
                return  objMark.catResultMark as? Int ?? 0
            }
        }
        return 0
    }
    
    private func saveDOAInPEModule(inovojectData:InovojectData,assessment: PE_AssessmentInProgress,fromDoaS:Bool?=false) -> Int{
        let imageCount = getDOACountInPEModule()
        CoreDataHandlerPE().saveDOAPEModule(assessment: assessment, doaId: imageCount+1,inovojectData: inovojectData,fromDoaS: fromDoaS)
        return imageCount+1
    }
    
    private func saveInovojectInPEModule(inovojectData:InovojectData,assessment: PE_AssessmentInProgress) -> Int{
        let imageCount = getDOACountInPEModule()
         CoreDataHandlerPE().saveInovojectPEModule(assessment: assessment ?? PE_AssessmentInProgress(), doaId: imageCount+1,inovojectData: inovojectData)
        return imageCount+1
        
    }
    
    func getDOACountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_DayOfAge")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "doaId") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    func getVMixerCountInPEModule() -> Int {
        let allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsFor(entityName: "PE_VMixer")
        let carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "vmid") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    func getAssessmentInOfflineFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInOffline")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "dataToSubmitNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count
    }
    
    func getDraftCountFromDb() -> Int {
        var allAssesmentDraftArr = CoreDataHandlerPE().fetchDetailsWithUserIDForAny(entityName: "PE_AssessmentInDraft")
        var carColIdArrayDraftNumbers  = allAssesmentDraftArr.value(forKey: "draftNumber") as? NSArray ?? []
        var carColIdArray : [Int] = []
        for obj in carColIdArrayDraftNumbers {
            if !carColIdArray.contains(obj as? Int ?? 0){
                carColIdArray.append(obj as? Int ?? 0)
            }
        }
        return carColIdArray.count ?? 0
    }
    
    private func saveImageInPEModule(imageData:Data)->Int{
        let imageCount = getImageCountInPEModule()
        CoreDataHandlerPE().saveImageInPEFinishModule(imageId: imageCount+1, imageData: imageData)
        return imageCount+1
    }
    
    
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC") //NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate ?? Date())
        
        return timeStamp
    }
    
    func filterCategoryCount(peNewAssessmentOf:PENewAssessment) -> Int {
        var peCategoryFilteredArray: [PECategory] =  []
        for object in pECategoriesAssesmentsResponse.peCategoryArray{
            if peNewAssessmentOf.evaluationID == object.evaluationID{
                peCategoryFilteredArray.append(object)
            }
        }
        pECategoriesAssesmentsResponse.peCategoryArray = peCategoryFilteredArray
        return pECategoriesAssesmentsResponse.peCategoryArray.count ?? 0
    }
    
    func convertDateFormat(inputDate: String) -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let oldDate = olDateFormatter.date(from: inputDate)
        
        // Date().stringFormat(format: "MMM d, yyyy")
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM d, yyyy"
        
        if oldDate != nil{
            return convertDateFormatter.string(from: oldDate!)
        }else{
            return ""
        }
        
    }
    
}

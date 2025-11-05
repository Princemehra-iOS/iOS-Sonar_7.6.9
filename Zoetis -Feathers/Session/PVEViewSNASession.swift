//
//  PVEViewSNASession.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 31/03/20.
//  Copyright © 2020 . All rights reserved.
//
import UIKit
import Foundation
import SafariServices
import WebKit

class PVEViewSNASession: BaseViewController {
    
    let sharedManager = PVEShared.sharedInstance
    var webView: WKWebView!
    @IBOutlet weak var headerView: UIView!
    var peHeaderViewController:PEHeaderViewController!
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    private var breedOfBirdsArray : [String] = []
    private var farmNameArr = [[String:Any]]()
    
    @IBOutlet weak var viewForGradient: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var syncToWebBtn: UIButton!
    var assesssmentCellHeight : CGFloat = 435.0
    
    var currentTimeStamp = ""
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupHeader()
        setupUI()
        
    }
    
    func getDraftValueForKey(key:String) -> Any{
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "sync", syncId: currentTimeStamp)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        peHeaderViewController.onGoingSessionView.isHidden = true
        peHeaderViewController.syncView.isHidden = true
        
        tblView.reloadData()
        
        if  let cell = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0) ) as? StartNewAssignmentCell
        {
            self.reloadCellUI(cell: cell)
        }
        tblView.reloadData()
        
    }
    
    func setupUI(){
        btnNext.setNextButtonUI()
        btnNext.titleLabel?.textColor = .white
        tblView.backgroundView = nil
        tblView.backgroundView?.backgroundColor = .clear
        
    }
    
    private func setupHeader() {
        
        peHeaderViewController = PEHeaderViewController()
        peHeaderViewController.titleOfHeader = "Completed Assessment"
        
        self.headerView.addSubview(peHeaderViewController.view)
        self.topviewConstraint(vwTop: peHeaderViewController.view)
    }
    
    func generateSeveyNumber(dateStr:String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.MMddyyyyStr
       
        let siteId = sharedManager.getSessionValueForKeyFromDB(key: "siteId") as! Int
        let evaluationDateStr = sharedManager.getSessionValueForKeyFromDB(key: "evaluationDate") as? String
        let savedDateString = evaluationDateStr?.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        let generatedServeyNo = "S-" + savedDateString! + "\(siteId)"
        return generatedServeyNo
        
    }
    
    @IBAction func actionMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func exportLogsBtnAction(_ sender: Any) {
        let syncData = CoreDataHandlerPVE().fetchSingleDataForSync(id: currentTimeStamp)
        for (_, val) in syncData.enumerated() {
            let dict = val as AnyObject
            let json = createSyncRequest(dict: dict)
            let forImgArrJson = getImageDetails(dict: val as AnyObject)
            let syncId = json["syncId"] as? String
            let currentAssessmentQuestJson = getQuestionsDetails(dict: val as AnyObject)
            
            let tempArr = [json]
            let jsonDict = ["AssessmentDataDetails" : tempArr,"AssessmentScoresDataDetails":currentAssessmentQuestJson]
            let createdAt = (dict).value(forKey: "createdAt") as? String

            ///Need to merge score data and image data in the json dict
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                if let status = EmailReportManager.shared.sendEmailReport(dataToAttach: jsonData,from: self, assessmentId:syncId,date: createdAt, isPE: false), !status.0 {
                    if let filePath = status.1 {
                        print(filePath)
                    }
                }
            } catch {
                print("Error converting merged dictionary to JSON: \(error)")
                showAlert(title: "Error", message: "Failed to convert data to JSON.", owner: self)
            }
        }
    }
    
    private func addWebKitView(_ fileUrl:URL) {
        let webVC = WebViewController()
        webVC.fileUrl = fileUrl
        present(webVC, animated: true, completion: nil)
    }
    
    func convertImageToBase64String (imgData: Data) -> String {
        return imgData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func getImageDetails(dict: AnyObject) -> [[String: Any]] {
        
        var tempImgArr = [Data]()
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 19
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId", syncId: syncId!) as? Int
        
        let assessmentArr = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: syncId!)
        let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        let module_Cat_IdArr = assessmentArr.value(forKey: "id")  as? NSArray ?? NSArray()
        
        var imgArr = [[String : Any]]()
        for (indx, seq_Number) in seq_NumberArr.enumerated() {
            let currentModule_Cat_IdArr = module_Cat_IdArr[indx] as! Int
            let savedImgArr = CoreDataHandlerPVE().fetchImgDetailsFromDB(seq_Number as! NSNumber, syncId: syncId!) as NSArray
            
            for (_, currentQObj) in savedImgArr.enumerated() {
                var scoreDict = [String : Any]()
                
                scoreDict.merge(dict: ["Id" : id])
                scoreDict.merge(dict: ["AssessmentDetailId" : Assessment_Detail_Id])
                
                let ModuleAssessmentId = (currentQObj as AnyObject).value(forKey: "id") as! Int
                scoreDict.merge(dict: ["ModuleAssessmentId" : ModuleAssessmentId])
                scoreDict.merge(dict: ["UserId" : userId!])
                scoreDict.merge(dict: ["ModuleId" : Module_cat_id])
                scoreDict.merge(dict: ["DeviceId" : deviceId!])
                
                let imdDataa = (currentQObj as AnyObject).value(forKey: "imageData") as! Data
                let imgBase64Data = self.convertImageToBase64String(imgData: imdDataa)
                scoreDict.merge(dict: ["ImageBase64" : imgBase64Data])
                scoreDict.merge(dict: ["ImageName" : "test"])
                scoreDict.merge(dict: ["Folder_Path" : "test"])
                scoreDict.merge(dict: ["type" :  ""])
                
                let imgSyncId = (currentQObj as AnyObject).value(forKey: "imgSyncId") as! String
                scoreDict.merge(dict: ["imgSyncId" :  imgSyncId])
                tempImgArr.append(imdDataa)
                scoreDict.merge(dict: ["Module_Assessment_Categories_Id" : currentModule_Cat_IdArr])
                
                imgArr.append(scoreDict)
            }
        }
        return imgArr
    }
    
    func getDraftValueForKey(key:String, syncId:String) -> Any {
        let valuee = CoreDataHandlerPVE().fetchDraftForSyncId(type: "draft", syncId: syncId)
        let valueArr = valuee.value(forKey: key) as! NSArray
        return valueArr[0]
    }
    
    func createSyncRequest(dict: AnyObject) -> [String: AnyObject]{
        
        let houseNumber = (dict).value(forKey: "houseNumber")  as? String
        let accountManagerId = (dict).value(forKey: "accountManagerId")  as? Int
        let farm = (dict).value(forKey: "farm")  as? String
        let evaluationForId = (dict).value(forKey: "evaluationForId")  as? Int
        let breedOfBirdsId = (dict).value(forKey: "breedOfBirdsId")  as? Int
        let objEvaluationDate = (dict).value(forKey: "objEvaluationDate") as! Date
        let ageOfBirds = (dict).value(forKey: "ageOfBirds")  as? Int
        let noOfBirds = (dict).value(forKey: "noOfBirds")  as? Int
        let housingId = (dict).value(forKey: "housingId")  as? Int
        let notes = (dict).value(forKey: "notes")  as? String
        let breedOfBirdsFemaleId = (dict).value(forKey: "breedOfBirdsFemaleId")  as? Int
        let breedOfBirdsOther = (dict).value(forKey: "breedOfBirdsOther")  as? String
        let breedOfBirdsFemaleOther = (dict).value(forKey: "breedOfBirdsFemaleOther")  as? String
        
        var selectedBirdTypeId = (dict).value(forKey: "selectedBirdTypeId")  as? Int
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let evaluatorId = (dict).value(forKey: "evaluatorId")  as? Int
        
        let customerId = (dict).value(forKey: "customerId")  as? Int
        let complexId = (dict).value(forKey: "complexId")  as? Int
        let userId = (dict).value(forKey: "userId")  as? Int
        let createdAt = (dict).value(forKey: "createdAt")  as? String
        let syncId = (dict).value(forKey: "syncId")  as? String
        let type = (dict).value(forKey: "type")  as? String
        
        
        let cameraState = (dict).value(forKey: "cameraEnabled")  as? String
        
        var cameraEnabled = Bool()
        
        if cameraState == "true"{
            cameraEnabled = true
            
        }else{
            cameraEnabled = false
        }
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 0
        
        let cat_NoOfCatchersDetailsArr = (dict).value(forKey: "cat_NoOfCatchersDetailsArr")  as? [[String : String]] ?? []
        var catchersViewModelArr = [[String : Any]]()
        
        if cat_NoOfCatchersDetailsArr.count > 0 {
            
            for (index, val) in cat_NoOfCatchersDetailsArr.enumerated(){
                let name = val["name"] ?? ""
                catchersViewModelArr.append(["MemberName" : name,
                                             "Id" : id,
                                             "Module_cat_id" : Module_cat_id,
                                             "Device_Id" : deviceId!,
                                             "Assessment_Detail_Id" : Assessment_Detail_Id,
                                             "UserId" : userId!,
                                             "Sequence_no" : index])
                
            }
        }
        
        
        let cat_NoOfVaccinatorsDetailsArr = (dict).value(forKey: "cat_NoOfVaccinatorsDetailsArr")  as? [[String : String]] ?? []
        var vaccinatorsViewModelArr = [[String : Any]]()
        
        if cat_NoOfVaccinatorsDetailsArr.count > 0 {
            
            for (index, val) in cat_NoOfVaccinatorsDetailsArr.enumerated(){
                let serology = val["serology"] ?? ""
                var IsSerology = Bool()
                if serology == "selected" {
                    IsSerology = true
                }else{
                    IsSerology = false
                }
                vaccinatorsViewModelArr.append(["MemberName" : val["name"] ?? "",
                                                "Id" : id,
                                                "Module_cat_id" : Module_cat_id,
                                                "Device_Id" : deviceId!,
                                                "Assessment_Detail_Id" : Assessment_Detail_Id,
                                                "UserId" : userId!,
                                                "IsSerology" : IsSerology,
                                                "Sequence_no" : index])
            }
        }
        
        
        let cat_vaccinInfoDetailArr = (dict).value(forKey: "cat_vaccinInfoDetailArr")  as? [[String : Any]] ?? []
        var vaccineInfoDetailsViewModelArr = [[String : Any]]()
        if cat_vaccinInfoDetailArr.count > 0 {
            
            print("cat_vaccinInfoDetailArr.count-\(cat_vaccinInfoDetailArr.count)")
            for (index, val) in cat_vaccinInfoDetailArr.enumerated(){
                
                var expDate = ""
                if val["expDate"] as! String == "" {
                    expDate = "12/12/1900"
                }else{
                    expDate = val["expDate"] as! String
                }
                
                var Vaccine_Other = String()
                var Vaccine_Id = Int()
                
                if val["man_id"] as! Int == 17 {
                    Vaccine_Other = val["name"] as! String
                    Vaccine_Id = 0
                }else{
                    Vaccine_Other = ""
                    Vaccine_Id = val["name_id"] as! Int
                }
                
                let noteeeee = val["note"] ?? ""
                let serotype = val["serotype"] as? [String] ?? [""]
                let serotype_id = val["serotype_id"] as? [String] ?? [""]
                let antigenOther = val["otherAntigen"] ?? ""
                let serotype_idStr = (serotype_id.map{String($0)}).joined(separator: ",")
                
                var antigenViewModelArr = [[String : Any]]()
                
                for (index , val) in serotype_id.enumerated() {
                    
                    antigenViewModelArr.append(["Vaccine_Id" :Vaccine_Id , "Antigen_Id" : val , "Vaccine_Other": ""  , "Antigen_Other" : antigenOther , "Assessment_Detail_Id" : Assessment_Detail_Id , "Device_Id": deviceId!, "Sequence_no" : index , "UserId" :userId! , "Antigen_Name" : serotype[index]])
                }
                
                
                vaccineInfoDetailsViewModelArr.append(["Id" : id,
                                                       "Vaccine_Mfg_Id" : val["man_id"] ?? 0,
                                                       "Vaccine_Id" : Vaccine_Id,
                                                       "Serotype_Id" :  serotype_idStr ,
                                                       "Serial" : val["serial"] ?? "",
                                                       "Exp_Date" : expDate,
                                                       "Site_Injct_Id" : val["siteOfInj_id"] ?? "",
                                                       "UserId" : userId!,
                                                       "Assessment_Detail_Id" : Assessment_Detail_Id,
                                                       "Device_Id" : deviceId!,
                                                       "Vaccine_Mfg_Other": "",
                                                       "Vaccine_Other": Vaccine_Other,
                                                       "Serotype_Other": val["otherAntigen"] ?? "",
                                                       "Site_Injct_Other": "",
                                                       "showMore": val["showMore"] ?? "",
                                                       "Note": val["note"] ?? "",
                                                       "antigenDetailsViewModel" : antigenViewModelArr,
                                                       "Sequence_no" : index])
                
            }
        }
        
        let HousingId = (dict).value(forKey: "housingId")  as? Int
        let VaccineInfoType = (dict).value(forKey: "cat_selectedVaccineInfoType")  as? String
        let CrewLeaderName = (dict).value(forKey: "cat_crewLeaderName")  as? String
        let CrewEmailId = (dict).value(forKey: "cat_crewLeaderEmail")  as? String
        let CrewTelephoneNo = (dict).value(forKey: "cat_crewLeaderMobile")  as? String
        let CompFieldRepName = (dict).value(forKey: "cat_companyRepName")  as? String
        let CompFieldRepEmailId = (dict).value(forKey: "cat_companyRepEmail")  as? String
        let CompFieldRepPhone = (dict).value(forKey: "cat_companyRepMobile")  as? String
        
        var tempCrewDetailsViewModel = [String : Any]()
        tempCrewDetailsViewModel.merge(dict: ["Id" : id])
        tempCrewDetailsViewModel.merge(dict: ["UserId" : userId!])
        tempCrewDetailsViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
        tempCrewDetailsViewModel.merge(dict: ["Device_Id" : deviceId!])
        tempCrewDetailsViewModel.merge(dict: ["Module_cat_id" : Module_cat_id])
        tempCrewDetailsViewModel.merge(dict: ["HousingId" : HousingId!])
        tempCrewDetailsViewModel.merge(dict: ["No_of_Catchers" : cat_NoOfCatchersDetailsArr.count])
        tempCrewDetailsViewModel.merge(dict: ["No_of_Vaccinator" : cat_NoOfVaccinatorsDetailsArr.count])
        tempCrewDetailsViewModel.merge(dict: ["VaccineInfoType" : VaccineInfoType!])
        tempCrewDetailsViewModel.merge(dict: ["CrewLeaderName" : CrewLeaderName!])
        tempCrewDetailsViewModel.merge(dict: ["CrewEmailId" : CrewEmailId!])
        tempCrewDetailsViewModel.merge(dict: ["CrewTelephoneNo" : CrewTelephoneNo!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepName" : CompFieldRepName!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepEmailId" : CompFieldRepEmailId!])
        tempCrewDetailsViewModel.merge(dict: ["CompFieldRepPhone" : CompFieldRepPhone!])
        let isFreeSerology = (dict).value(forKey: "isFreeSerology")  as? Bool
        if isFreeSerology == true{
            tempCrewDetailsViewModel.merge(dict: ["IsSerology" : isFreeSerology ?? 0])
        }else{
            tempCrewDetailsViewModel.merge(dict: ["IsSerology" : isFreeSerology ?? 0])
        }
        
        let WasDyeAdded = (dict).value(forKey: "vacEval_DyeAdded")  as? Bool
        let Comments_observations = (dict).value(forKey: "vacEval_Comment")  as? String
        var evaluationNoteViewModel = [String : Any]()
        evaluationNoteViewModel.merge(dict: ["Id" : id])
        evaluationNoteViewModel.merge(dict: ["UserId" : userId!])
        evaluationNoteViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
        evaluationNoteViewModel.merge(dict: ["Device_Id" : deviceId!])
        evaluationNoteViewModel.merge(dict: ["WasDyeAdded" : WasDyeAdded!])
        evaluationNoteViewModel.merge(dict: ["Note" : Comments_observations!])
        evaluationNoteViewModel.merge(dict: ["ModuleCategoryId" : Module_cat_id])
        
        var choleraArr = [[String : Any]]()
        
        for n in 1...5 {
            var choleraVaccinesViewModel = [String : Any]()
            choleraVaccinesViewModel.merge(dict: ["Id" : id])
            choleraVaccinesViewModel.merge(dict: ["UserId" : userId!])
            choleraVaccinesViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
            choleraVaccinesViewModel.merge(dict: ["Device_Id" : deviceId!])
            choleraVaccinesViewModel.merge(dict: ["Assessment_Id" : 134])
            choleraVaccinesViewModel.merge(dict: ["Module_Assessment_Cat_Id" : Module_cat_id])
            
            var LeftWingInj = Double()
            var RightWingInj = Double()
            if n == 1{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Center (good)"])
                LeftWingInj = (dict).value(forKey: "injCenter_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injCenter_RightWing_Field") as! Double
                
                
                let LeftPerInj = (dict).value(forKey: "injCenter_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injCenter_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injCenter_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 2{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Wing Band"])
                LeftWingInj = (dict).value(forKey: "injWingBand_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injWingBand_RightWing_Field") as! Double
                
                let LeftPerInj = (dict).value(forKey: "injWingBand_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injWingBand_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injWingBand_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 3{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Muscle Hit"])
                LeftWingInj = (dict).value(forKey: "injMuscleHit_LeftWing_Field") as! Double
                RightWingInj = (dict).value(forKey: "injMuscleHit_RightWing_Field")  as! Double
                
                let LeftPerInj = (dict).value(forKey: "injMuscleHit_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injMuscleHit_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injMuscleHit_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 4{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Missed"])
                LeftWingInj = (dict).value(forKey: "injMissed_LeftWing_Field")  as! Double
                RightWingInj = (dict).value(forKey: "injMissed_RightWing_Field")  as! Double
                
                let LeftPerInj = (dict).value(forKey: "injMissed_LeftWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : LeftPerInj!])
                
                let RightPerInj = (dict).value(forKey: "injMissed_RightWing_Percent")
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : RightPerInj!])
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                let PerTotal = (dict).value(forKey: "injMissed_LeftRight_PercentLbl") as! Double
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 5{
                choleraVaccinesViewModel.merge(dict: ["SiteofInjection" : "Total"])
                
                LeftWingInj = (dict).value(forKey: "subQLeftTotal") as! Double
                RightWingInj = (dict).value(forKey: "subQRightTotal") as! Double
                
                let totalling = LeftWingInj + RightWingInj
                choleraVaccinesViewModel.merge(dict: ["TotalInj" : totalling])
                
                choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : 100])
                if LeftWingInj == 0 {
                    choleraVaccinesViewModel.merge(dict: ["LeftPerInj" : 0])
                }
                choleraVaccinesViewModel.merge(dict: ["RightPerInj" : 100])
                if RightWingInj == 0 {
                    choleraVaccinesViewModel.merge(dict: ["RightPerInj" : 0])
                }
                
                choleraVaccinesViewModel.merge(dict: ["PerTotal" : 100])
                if totalling == 0 {
                    choleraVaccinesViewModel.merge(dict: ["PerTotal" : 0])
                }
            }
            
            choleraVaccinesViewModel.merge(dict: ["LeftWingInj" : LeftWingInj])
            choleraVaccinesViewModel.merge(dict: ["RightWingInj" : RightWingInj])
            
            let score = (dict).value(forKey: "scoreCholeraVaccine") as! Double
            choleraVaccinesViewModel.merge(dict: ["Score" : score])
            
            choleraArr.append(choleraVaccinesViewModel)
            
        }
        
        var inactivatedVacArr = [[String : Any]]()
        
        for n in 1...3 {
            var inactivatedVaccinesViewModel = [String : Any]()
            inactivatedVaccinesViewModel.merge(dict: ["Id" : id])
            inactivatedVaccinesViewModel.merge(dict: ["UserId" : userId!])
            inactivatedVaccinesViewModel.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
            inactivatedVaccinesViewModel.merge(dict: ["Device_Id" : deviceId!])
            inactivatedVaccinesViewModel.merge(dict: ["Assessment_Id" : 135])
            inactivatedVaccinesViewModel.merge(dict: ["Module_Assessment_Cat_Id" : Module_cat_id])
            
            var IntraInj = Double()
            var SubInj = Double()
            
            if n == 1{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Hits"])
                IntraInj = (dict).value(forKey: "injMuscleHit_IntramusculerInj_Field")  as! Double
                SubInj = (dict).value(forKey: "injMuscleHit_SubcutaneousInj_Field")  as! Double
                
                let PerIntra = (dict).value(forKey: "injMuscleHit_IntramusculerInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : PerIntra!])
                
                let PerSub = (dict).value(forKey: "injMuscleHit_SubcutaneousInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : PerSub!])
                
                let TotalInj = (dict).value(forKey: "injMuscleHit_Total")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = (dict).value(forKey: "injMuscleHit_Percent") as! Double
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
            }
            if n == 2{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Missed"])
                IntraInj = (dict).value(forKey: "injMissed_IntramusculerInj_Field")  as! Double
                SubInj = (dict).value(forKey: "injMissed_SubcutaneousInj_Field")  as! Double
                
                let PerIntra = (dict).value(forKey: "injMissed_IntramusculerInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : PerIntra!])
                
                let PerSub = (dict).value(forKey: "injMissed_SubcutaneousInj_Percent")
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : PerSub!])
                
                let TotalInj = (dict).value(forKey: "injMissed_Total")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = (dict).value(forKey: "injMissed_Percent") as! Double
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                
            }
            if n == 3{
                inactivatedVaccinesViewModel.merge(dict: ["SiteofInjection" : "Total"])
                
                IntraInj = (dict).value(forKey: "intraInjLeftTotal")  as! Double
                SubInj = (dict).value(forKey: "subInjRightTotal")  as! Double
                
                inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : 100])
                if IntraInj == 0 {
                    inactivatedVaccinesViewModel.merge(dict: ["PerIntra" : 0])
                }
                
                inactivatedVaccinesViewModel.merge(dict: ["PerSub" : 100])
                if SubInj == 0 {
                    inactivatedVaccinesViewModel.merge(dict: ["PerSub" : 0])
                }
                
                let TotalInj = (dict).value(forKey: "injTotal_For_Inactivated")
                inactivatedVaccinesViewModel.merge(dict: ["TotalInj" : TotalInj!])
                
                let PerTotal = 100
                inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : PerTotal])
                if (IntraInj + SubInj) == 0{
                    inactivatedVaccinesViewModel.merge(dict: ["PerTotal" : 0])
                }
            }
            
            inactivatedVaccinesViewModel.merge(dict: ["IntraInj" : IntraInj])
            inactivatedVaccinesViewModel.merge(dict: ["SubInj" : SubInj])
            
            let score = (dict).value(forKey: "scoreInactivatedVaccine") as! Double
            inactivatedVaccinesViewModel.merge(dict: ["Score" : score])
            
            inactivatedVacArr.append(inactivatedVaccinesViewModel)
        }
        
        if selectedBirdTypeId == 13{
            selectedBirdTypeId = 2
        }else{
            selectedBirdTypeId = 1
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="MM/dd/YYYY HH:mm:ss Z"
        let date = dateFormatter.string(from: objEvaluationDate) as String
        
        let evaluationDate = (dict).value(forKey: "evaluationDate")  as? String
        
        var tempBreedOfBirdsId = ""
        if breedOfBirdsId == 0 {
            tempBreedOfBirdsId = ""
        }else{
            tempBreedOfBirdsId = "\(breedOfBirdsId ?? 0)"
        }
        
        let json = [
            "Id" : 0,
            "App_Assessment_Detail_Id": syncId!,
            "Evaluation_Date" : evaluationDate!,
            "Evaluation_For_Id" : evaluationForId!,
            "Customer_Id" : customerId ?? 0,
            "Complex_Id" : complexId ?? 0,
            "Zoetis_Account_Manager_Id" : accountManagerId!,
            "Evaluator_Id" : evaluatorId!, // need to set in db
            "Breed_Id" : tempBreedOfBirdsId,
            "Breed_of_Birds_Other": breedOfBirdsOther!,
            "Breed_Female_Id" : breedOfBirdsFemaleId!,
            "Breed_Female_Other": breedOfBirdsFemaleOther!,
            "Housing_Id" : housingId!,
            "Farm_Name" : farm!,
            "House_No" : houseNumber!,
            "Age_of_Birds" : ageOfBirds!,
            "Camera" : cameraEnabled,
            "No_of_Birds" : noOfBirds!,
            "Type_of_Bird" : selectedBirdTypeId!,
            "Notes" : notes!,
            "Device_Id" : deviceId!,
            "UserId" : userId!,
            "Save_type": type!,
            
            "CreatedBy" : userId ?? 0,
            "CreatedAt" : createdAt!,
            "syncId" : syncId!,
            
            "vaccineInformationCrewDetailsViewModel" : tempCrewDetailsViewModel,
            "catchersViewModel" : catchersViewModelArr,
            "vaccinatorsViewModel" : vaccinatorsViewModelArr,
            "vaccineInfoDetailsViewModel" : vaccineInfoDetailsViewModelArr,
            "evaluationNoteViewModel" : evaluationNoteViewModel,
            "choleraVaccinesViewModel" : choleraArr,
            "inactivatedVaccinesViewModel" : inactivatedVacArr
        ] as Dictionary<String, AnyObject>
        
        
        return json as [String : AnyObject]
        
    }
    
    func getQuestionsDetails(dict: AnyObject) -> [[String: Any]] {
        
        let id = 0
        let Module_cat_id = 2
        let Assessment_Detail_Id = 0
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        
        let selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId", syncId: syncId!) as? Int
        
        let assessmentArr = CoreDataHandlerPVE().getSyncdAssementsArr(selectedBirdTypeId: selectedBirdTypeId!, type: "sync", syncId: syncId!)
        let seq_NumberArr = assessmentArr.value(forKey: "seq_Number")  as? NSArray ?? NSArray()
        
        var scoreArr = [[String : Any]]()
        for (_, seq_Number) in seq_NumberArr.enumerated() {
            
            var scoreDict = [String : Any]()
            
            let questionsArr = CoreDataHandlerPVE().fetchDraftAssQuestion(seq_Number as! NSNumber, type: "sync", syncId: syncId!) as NSArray
            
            for (_, currentQObj) in questionsArr.enumerated() {
                scoreDict.merge(dict: ["syncId" : syncId!])
                scoreDict.merge(dict: ["Id" : id])
                scoreDict.merge(dict: ["UserId" : userId!])
                scoreDict.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
                scoreDict.merge(dict: ["Device_Id" : deviceId!])
                if (currentQObj as AnyObject).value(forKey: "isSelected") as! Bool == true {
                    scoreDict.merge(dict: ["Score" : (currentQObj as AnyObject).value(forKey: "max_Score") as! Int])
                } else {
                    scoreDict.merge(dict: ["Score" : (currentQObj as AnyObject).value(forKey: "min_Score") as! Int])
                }
                
                scoreDict.merge(dict: ["Assessment_Id" : (currentQObj as AnyObject).value(forKey: "id") as! Int])
                scoreDict.merge(dict: ["Assessment_Type" : (currentQObj as AnyObject).value(forKey: "types") as! String])
                scoreDict.merge(dict: ["TextFieldValue" : (currentQObj as AnyObject).value(forKey: "enteredText") as! String])
                
                scoreDict.merge(dict: ["LiveVaccineType" : (currentQObj as AnyObject).value(forKey: "liveVaccineSwitch") as! Bool])
                scoreDict.merge(dict: ["LiveVaccineTypeComment" : (currentQObj as AnyObject).value(forKey: "liveComment") as! String])
                scoreDict.merge(dict: ["InactivatedVaccineType" : (currentQObj as AnyObject).value(forKey: "inactiveVaccineSwitch") as! Bool])
                scoreDict.merge(dict: ["InactivatedVaccineTypeComment" : (currentQObj as AnyObject).value(forKey: "inactiveComment") as! String])
                
                
                var commentDict = [String : Any]()
                commentDict.merge(dict: ["Id" : id])
                commentDict.merge(dict: ["UserId" : userId!])
                commentDict.merge(dict: ["Assessment_Detail_Id" : Assessment_Detail_Id])
                commentDict.merge(dict: ["Device_Id" : deviceId!])
                commentDict.merge(dict: ["Assessment_Id" : (currentQObj as AnyObject).value(forKey: "id") as! Int])
                commentDict.merge(dict: ["Comment" : (currentQObj as AnyObject).value(forKey: "comment") as! String])
                commentDict.merge(dict: ["ModuleId" : Module_cat_id])
                
                let commntStr = (currentQObj as AnyObject).value(forKey: "comment") ?? ""
                if commntStr as! String == "" {
                    scoreDict.merge(dict: ["assessmentCommentsViewModel" : NSDictionary()])
                } else {
                    scoreDict.merge(dict: ["assessmentCommentsViewModel" : commentDict])
                }
                scoreArr.append(scoreDict)
            }
        }
        return scoreArr
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
}


extension PVEViewSNASession: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return  self.assesssmentCellHeight
        case 1:
            return  250
        default:
            return 0
        }
        
    }
    
    fileprivate func cameraSetting(_ cameraState: String?, _ cell: StartNewAssignmentCell) {
        if cameraState == "true" {
            cell.switchBtn.isOn = true
        } else {
            cell.switchBtn.isOn = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SessionStartNewAssignmentCell", for: indexPath) as! StartNewAssignmentCell
            cell.selectionStyle = .none
            cell.timeStampStr = currentTimeStamp
            
            
            cell.customerTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "customer") as? String
            cell.siteIdTxtfield.text = sharedManager.getCustomerAndSitePopupValueFromDB(key: "complexName") as? String
            
            
            let valuee = CoreDataHandlerPVE().fetchCurrentSessionInDB()
            if valuee.count > 0 {
                
                cell.evaluationDateTxtfield.text = getDraftValueForKey(key: "evaluationDate") as? String
                cell.accManagerTxtfield.text = getDraftValueForKey(key: "accountManager") as? String
                cell.breedOfBirdsTxtfield.text = getDraftValueForKey(key: "breedOfBirds") as? String
                cell.breedOfBirdsFemaleTxtfield.text = getDraftValueForKey(key: "breedOfBirdsFemale") as? String
                cell.housingTxtfield.text = getDraftValueForKey(key: "housing") as? String
                cell.evaluationForTxtfield.text = getDraftValueForKey(key: "evaluationFor") as? String
                cell.breedOfBirdsOtherTxtfield.text = getDraftValueForKey(key: "breedOfBirdsOther") as? String
                cell.breedOfBirdsFemaleOtherTxtfield.text = getDraftValueForKey(key: "breedOfBirdsFemaleOther") as? String
                cell.farmNameTxtfield.text = getDraftValueForKey(key: "farm") as? String
                cell.houseNoTxtfield.text = getDraftValueForKey(key: "houseNumber") as? String
                cell.noOfBirdsTxtfield.text = "\(getDraftValueForKey(key: "noOfBirds"))"
                cell.evaluatorTxtfield.text = getDraftValueForKey(key: "evaluator") as? String
                cell.ageOfBirdsTxtfield.text = "\(getDraftValueForKey(key: "ageOfBirds"))"
                
                if getDraftValueForKey(key: "noOfBirds") as! Int == 0 {
                    cell.noOfBirdsTxtfield.text = ""
                }
                if getDraftValueForKey(key: "ageOfBirds") as! Int == 0 {
                    cell.ageOfBirdsTxtfield.text = ""
                }
                
                let cameraState = getDraftValueForKey(key: "cameraEnabled") as? String
                cameraSetting(cameraState, cell)
                
            
                var  selectedBirdTypeId = getDraftValueForKey(key: "selectedBirdTypeId") as! Int
                if selectedBirdTypeId == 14 {
                    cell.birdWelfareImg.image = UIImage(named: "checkIconPE")
                    cell.birdPresentationImg.image = UIImage(named: "uncheckIconPE")
                }else{
                    cell.birdWelfareImg.image = UIImage(named: "uncheckIconPE")
                    cell.birdPresentationImg.image = UIImage(named: "checkIconPE")
                }
                
                cell.backgroundColor = UIColor.clear
                
            }
            return cell
        }
            
        default: do {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.addNote_StartNewAssCell, for: indexPath) as! AddNote_StartNewAssCell
            cell.notetxtView.isEditable = false
            
            cell.notetxtView.isScrollEnabled = true
            cell.notetxtView.textContainer.lineFragmentPadding = 12
            cell.selectionStyle = .none
            cell.timeStampStr = currentTimeStamp
            cell.notetxtView.text = getDraftValueForKey(key: "notes") as? String
            
            cell.backgroundColor = UIColor.clear
            
            return cell
            
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
}
//  MARK:------------------------------Button Action and Set Values in Fields-----------------

extension PVEViewSNASession{
    
    @IBAction func evaluationDateBtnAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.selection, bundle:nil)
        let datePickerPopupViewController = storyBoard.instantiateViewController(withIdentifier:  Constants.ControllerIdentifier.datePickerPopupViewController) as! DatePickerPopupViewController
        datePickerPopupViewController.isPVE = true
        present(datePickerPopupViewController, animated: false, completion: nil)
    }
    
    @IBAction func customerBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "Customer_PVE")
        let namesArray = array.value(forKey: "customerName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.customer, dropDownArr: namesArray)
    }
    
    @IBAction func evaluationForBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_EvaluationFor")
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.evaluationFor, dropDownArr: namesArray)
    }
    
    @IBAction func siteIdBtnAction(_ sender: UIButton) {
        
        let dataArr = CoreDataHandlerPVE().fetchCurrentSessionInDB()
        let arr = dataArr.value(forKey: "customerId") as! NSArray
        let custId = arr[0] as! Int
        let namesArray = CoreDataHandlerPVE().fetchCustomerWithCustId( custId as NSNumber)
        let  siteNameArr = namesArray.value(forKey: "complexName") as? NSArray ?? NSArray()
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.siteId, dropDownArr: siteNameArr as? [String])
    }
    
    @IBAction func accountManagerBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AssignUserDetails")
        let namesArray = array.value(forKey: "fullName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.accountManager, dropDownArr: namesArray)
    }
    
    @IBAction func evaluatorBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Evaluator")
        let namesArray = array.value(forKey: "fullName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.evaluationDetails, dropDownArr: namesArray)
    }
    
    @IBAction func breedOfBirdsBtnAction(_ sender: UIButton) {
        
        let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
        let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 1)
        
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.breedOfBirds, dropDownArr: namesArray)
    }
    
    @IBAction func breedOfBirdsFemaleBtnAction(_ sender: UIButton) {
        
        let evaluationForId = getDraftValueForKey(key: "evaluationForId") as! Int
        let array = CoreDataHandlerPVE().fetchDetailsForBreedOfBirds(evaluationForId: NSNumber(value: evaluationForId), type: 2)
        
        let namesArray = array.value(forKey: "name") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.breedOfBirdsFemale, dropDownArr: namesArray)
    }
    
    @IBAction func ageOfBirdsBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_AgeOfBirds")
        let namesArray = array.value(forKey: "age") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.ageOfBirds, dropDownArr: namesArray)
    }
    
    @IBAction func syncToWebBtnAction(_ sender: UIButton) {
        let errorMSg = "Are you sure, you want to sync this session data to web?"
        let alertController = UIAlertController(title: "PVE", message: errorMSg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            _ in
            self.singleDataSync()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func singleDataSync(){
        if ConnectionManager.shared.hasConnectivity() {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: PVEDashboardViewController.self) {
                    Constants.syncToWebTapped = true
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "forceSync"),object: nil, userInfo:["id": currentTimeStamp]))
                    self.navigationController!.popToViewController(controller, animated: true)
                }
            }
        }
        else {
           Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
       }
      
    }
    @IBAction func housingBtnAction(_ sender: UIButton) {
        let array = CoreDataHandlerPVE().fetchDetailsFor(entityName: "PVE_Housing")
        let namesArray = array.value(forKey: "housingName") as! [String]
        setDropdrown(sender, clickedField: Constants.ClickedFieldStartNewAssPVE.housing, dropDownArr: namesArray)
    }
    
    func setDropdrown(_ sender: UIButton, clickedField:String, dropDownArr:[String]?){
        
        if  dropDownArr!.count > 0 {
            self.dropDownVIewNew(arrayData: dropDownArr!, kWidth: sender.frame.width, kAnchor: sender, yheight: sender.bounds.height) {  selectedVal,index  in
                self.tblView.reloadData()
                self.tblView.reloadInputViews()
            }
            self.dropHiddenAndShow()
        } else {
            print(appDelegateObj.testFuntion())
        }
        
      
    }
    
    func reloadCellUI(cell:StartNewAssignmentCell)  {
        
        let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "sync", syncId: currentTimeStamp)
        
        let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        
        if evaluationForId == 4 {
            cell.breesOfBirdsTitleLbl.text = "Breed of Birds*"
            cell.breesOfBirdsSuperView.isHidden = true
        }
        else if evaluationForId == 5 {
            cell.breesOfBirdsTitleLbl.text = "Breed of Birds (Male)"
            cell.breesOfBirdsSuperView.isHidden = false
        }
        
        var viewHeight : CGFloat = 0
        let viewX : CGFloat = cell.frame.size.width - cell.cameraToggleSuperView.frame.size.width
        
        if evaluationForId == 4{
            
            self.assesssmentCellHeight = 435.0
            viewHeight = 170 + 60 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 4 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 65 + 45 + 5
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        
        if evaluationForId == 5 {
            
            viewHeight = 170
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String != "Other" {
            self.assesssmentCellHeight = 435.0
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
        }
        
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirdsFemale") as? String == "Other" {
            
            self.assesssmentCellHeight = 475.0 + 5
            viewHeight = 170 + 10
            let viewY : CGFloat = cell.frame.size.height - viewHeight
            
            cell.cameraToggleSuperView.frame = CGRect(x: viewX, y: viewY, width: cell.cameraToggleSuperView.frame.size.width, height: viewHeight)
            
        }
        
        
        self.setupOtherFields(cell: cell)
        
    }
    
    
    func setupOtherFields(cell:StartNewAssignmentCell) {
        
        cell.breesOfBirdsFemaleOtherSuperView.isHidden = true
        
        let dataSavedInDB = CoreDataHandlerPVE().fetchDraftForSyncId(type: "sync", syncId: currentTimeStamp)
        
        let arr = dataSavedInDB.value(forKey: "evaluationForId") as! NSArray
        let evaluationForId = arr[0] as! Int
        
        if evaluationForId == 4 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
            
        }else if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirds") as? String == "Other"  {
            cell.breesOfBirdsMaleOtherSuperView.isHidden = false
        }else{
            cell.breesOfBirdsMaleOtherSuperView.isHidden = true
        }
        
        
        if evaluationForId == 5 && getDraftValueForKey(key: "breedOfBirdsFemale") as? String == "Other"  {
            cell.breesOfBirdsFemaleOtherSuperView.isHidden = false
        }else{
            cell.breesOfBirdsFemaleOtherSuperView.isHidden = true
        }
        
    }
    
    func getTodayDateSring() -> String {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.MMddyyyyStr
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        return DateInFormat
    }
    
    
    func setBorderBlueForCalender(btn:UIButton) {
        let superviewCurrent = btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of: UIButton.self), view == btn {
                view.setDropdownStartAsessmentView(imageName: "calendarIconPE")
            }
        }
    }
    
    func setBorderBlue(btn: UIButton) {
        let superviewCurrent = btn.superview
        for view in superviewCurrent!.subviews {
            if view.isKind(of: UIButton.self), view == btn {
                view.setDropdownStartAsessmentView(imageName: "dd")
            }
        }
    }
    
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        //checkValidation()
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.Storyboard.pveStoryboard, bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PVEViewFinalizeAssement") as! PVEViewFinalizeAssement
        vc.currentTimeStamp = currentTimeStamp
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

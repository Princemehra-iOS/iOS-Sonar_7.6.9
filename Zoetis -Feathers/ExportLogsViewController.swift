//
//  UnsyncedDataVC.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 5/23/25.
//

import UIKit
import Foundation


protocol UnsyncedDelegate: AnyObject {
    func exportTapped(index:Int)
}

class ExportLogsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let closeButton = UIButton(type: .system)
    var peAssessmentSyncArray: [PENewAssessment]?
    var pveAssessmentSynArray: NSArray?
    let peHeaders = ["Date", "Customer", "Site","Export Logs"]
    let pveHeaders = ["Date", "Evaluator", "Evaluation For","Export Logs"]
    weak var delegateUnsynced: UnsyncedDelegate?
    let rowHeight: CGFloat = 60
    let headerHeight: CGFloat = 50
    let maxHeightFraction: CGFloat = 0.8
    var isPE = true
    let titleLabel = UILabel()
    let font = UIFont(name:"HelveticaNeue-Medium", size: 16.0)
    
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No data available"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Initially hidden
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("<<<<",self)
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        setupTableView()
        applyHeightConstraint()
        tableView.allowsSelection = false
        titleLabel.text = "Assessment"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleBackgroundImageView = UIImageView()
        titleBackgroundImageView.image = UIImage(named: "headerNavigation") // Replace with your image name
        titleBackgroundImageView.contentMode = .scaleAspectFill
        titleBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleBackgroundImageView)
        self.view.addSubview(titleLabel)
        //setupCloseButton()
        layoutViews()
        // Update constraints
        NSLayoutConstraint.activate([
            titleBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackgroundImageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        view.addSubview(noDataLabel)
        noDataLabel.isHidden = true
        noDataLabel.font = font
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 20),
            noDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        updateUI()
    }
    
    func updateUI() {
        
        if isPE {
            if let data = peAssessmentSyncArray, !data.isEmpty {
                noDataLabel.isHidden = true
                tableView.isHidden = false
            } else {
                noDataLabel.isHidden = false
                tableView.isHidden = true
            }
        } else {
            if let data = pveAssessmentSynArray , !(data.count == 0) {
                noDataLabel.isHidden = true
                tableView.isHidden = false
            } else {
                noDataLabel.isHidden = false
                tableView.isHidden = true
            }
        }
        
        
    }

    private func setupCloseButton() {
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.systemRed, for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExportLogsTableCell.self, forCellReuseIdentifier: "ExportLogsTableCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
//            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
//            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func applyHeightConstraint() {
        var totalRows = 0
        if isPE {
            totalRows = peAssessmentSyncArray!.count + 1
        } else {
            totalRows = pveAssessmentSynArray!.count + 1
        }
        let estimatedTableHeight = CGFloat(totalRows) * rowHeight
        let safeHeight = UIScreen.main.bounds.height * maxHeightFraction
        let finalHeight = min(estimatedTableHeight + headerHeight, safeHeight)

        preferredContentSize = CGSize(width: 600, height: finalHeight)

        tableView.isScrollEnabled = estimatedTableHeight + headerHeight > safeHeight
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPE {
            return peAssessmentSyncArray!.count + 1
        } else {
            return pveAssessmentSynArray!.count + 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 55
        }
        return rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExportLogsTableCell", for: indexPath) as? ExportLogsTableCell else {
            return UITableViewCell()
        }

        if indexPath.row == 0 {
            if isPE {
                cell.configure(peData: nil,PVEData: nil, headerData: peHeaders, isHeader: true, indexPath: indexPath)
            } else {
                cell.configure(peData: nil,PVEData: nil, headerData: pveHeaders, isHeader: true, indexPath: indexPath)
            }
            cell.backgroundColor = UIColor.systemGray6
        } else {
            cell.exportButton.tag = indexPath.row
            cell.exportButton.setTitle("Export", for: .normal)
            cell.exportButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.exportButton.addTarget(self, action: #selector(exportTapped(_:)), for: .touchUpInside)
            if isPE {
                let rowData = peAssessmentSyncArray?[indexPath.row - 1]
                cell.configure(peData: rowData,PVEData: nil, headerData: nil, isHeader: false, indexPath: indexPath)
                cell.backgroundColor = .white
            } else {
                if let rowData = pveAssessmentSynArray {
                    let val = rowData[indexPath.row-1] as AnyObject
                    let dict = val as AnyObject
                    let json = createSyncRequest(dict: dict)
                    // let currentAssessmentQuestJson = getQuestionsDetails(dict: val as AnyObject)
                    // let forImgArrJson = getImageDetails(dict: val as AnyObject)
                    cell.configure(peData: nil,PVEData: json, headerData: nil, isHeader: false,isPE: isPE, indexPath: indexPath)
                    cell.backgroundColor = .white
                }
            }
        }
        
        return cell
    }
    
    @objc private func exportTapped(_ sender:UIButton) {
        print(sender.tag)
        self.dismiss(animated: false) {
            self.delegateUnsynced?.exportTapped(index: sender.tag-1)
        }
    }
    
    func createSyncRequest(dict: AnyObject) -> [String: AnyObject] {
        
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
        let createdAt = (dict).value(forKey: "createdAt")  as? String
        let deviceId = (dict).value(forKey: "deviceId")  as? String
        let evaluatorId = (dict).value(forKey: "evaluatorId")  as? Int
        
        let customerId = (dict).value(forKey: "customerId")  as? Int
        let complexId = (dict).value(forKey: "complexId")  as? Int
        let userId = (dict).value(forKey: "userId")  as? Int
        let syncId = (dict).value(forKey: "syncId")  as? String
        let type = (dict).value(forKey: "type")  as? String
        let evaluator = (dict).value(forKey: "evaluator")  as? String
        let evaluationFor = (dict).value(forKey: "evaluationFor")  as? String
        
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
            "evaluator":evaluator!,
            "evaluationFor":evaluationFor!,
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
}

//
//  PulletSelectionViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/01/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

class PulletSelectionViewController: BaseViewController {
    
    @IBOutlet weak var hatcheryButton: UIButton!
    @IBOutlet weak var breederButton: UIButton!
    @IBOutlet weak var growoutButton: UIButton!
    @IBOutlet weak var processEvalBtn: UIButton!
    @IBOutlet weak var pveLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblVersion: UILabel!
    let verStr = "Version "
    var bottomViewController:BottomViewController!
    var path: UIBezierPath!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupHeader()
        processEvalBtn.alpha = 0.3
        pveLabel.alpha = 0.3
        processEvalBtn.isUserInteractionEnabled = false
        
      
        let ModuleIdsArray =   UserDefaults.standard.string(forKey:"ModuleIdsArray")
        let arr = ModuleIdsArray?.components(separatedBy: "~")
        
        if (arr?.contains("23") ?? false) {
            processEvalBtn.alpha = 1
            pveLabel.alpha = 1
            processEvalBtn.isUserInteractionEnabled = true
        }
        
        var liveAlbums = 3
        let environmentIs = Constants.Api.versionUrl
        
        if environmentIs.contains("stageapi") {
            liveAlbums = 0
        } else if environmentIs.contains("devapi") {
            liveAlbums = 1
        } else if environmentIs.contains("supportapi") {
            liveAlbums = 2
        } else {
            liveAlbums = 3
        }
        
        
        switch liveAlbums {
        case 0:
            lblVersion.text = verStr + Bundle.main.versionNumber + " (UAT)"
            
        case 1:
            lblVersion.text = verStr + Bundle.main.versionNumber + " (Dev)"
            
        case 2:
            lblVersion.text = verStr + Bundle.main.versionNumber + " (Dev Support)"
            
        case 3:
            lblVersion.text = verStr + Bundle.main.versionNumber
            
        default:
            lblVersion.text = verStr + Bundle.main.versionNumber
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print(appDelegateObj.testFuntion())
    }
    
    // MARK:  **********Setup Header **************************************/
    private func setupHeader() {
        bottomViewController = BottomViewController()
        self.footerView.addSubview(bottomViewController.view)
        self.topviewConstraint(vwTop: bottomViewController.view)
    }

    // MARK: Breeder Button Action
    @IBAction func clickedBreeder(_ sender: Any) {
        transitionAnimationPVE(view: breederButton, animationOptions: .transitionCrossDissolve, isReset: true)
    }
    // MARK: Hatchery Button Action
    @IBAction func clickedHatchery(_ sender: Any) {
        transitionAnimationPE(view: hatcheryButton, animationOptions: .transitionCrossDissolve, isReset: true)
    }
    // MARK: Flock Health Button Action
    @IBAction func clickedGrowout(_ sender: Any) {
        self.navigateToGrownoutSelectionPE()
    }
    // MARK: Microbial Button Action
    @IBAction func microbialBtnClicked(_ sender: Any) {
        appDelegateObj.testFuntion()
    }
    // MARK: Process Evaluation Button Action
    @IBAction func processEvalBtnClicked(_ sender: Any) {
        
        self.showGlobalProgressHUDWithTitle(self.view, title: "")
        UserDefaults.standard.set("PVE", forKey: "userType")
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        let keychainHelper = AccessTokenHelper()
        let FCMToken = keychainHelper.getFromKeychain(keyed: "Token")//keychainHelper.getFromKeychain(keyed: "Token”)

       // let FCMToken =  UserDefaults.standard.value(forKey:"Token") as? String ?? ""
        let udid = UserDefaults.standard.value(forKey: "ApplicationIdentifier") as? String ?? ""
        let param = ["UserId":userID,"ModuleId":23,"FCMToken":FCMToken,"DeviceId":udid] as JSONDictionary
        ZoetisWebServices.shared.sendFCMTokenDataToServer(controller: self, parameters: param, completion: { [weak self] (json, error) in
            guard let self = self, error == nil else { return }
            
            
        })
        self.dismissGlobalHUD(self.view)
        Constants.baseUrl = Constants.Api.pveBaseUrl
        let vc = UIStoryboard.init(name: Constants.Storyboard.pveStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: "PVEDashboardViewController") as? PVEDashboardViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    // MARK:  ********** Animation Transition for PE **************************************/
    func transitionAnimationPE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
        self.navigateToModuleSelectionPE()
        
    }
    // MARK:  ********** Animation Transition for PVE **************************************/
    func transitionAnimationPVE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
        self.navigateToModuleSelectionPVE()
        
    }
    // MARK:  ********** Navigate to Hatchery Selection Module **************************************/
    private func navigateToModuleSelectionPE(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "HatcherySelectionViewController") as? HatcherySelectionViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    // MARK:  ********** Navigate to Growout Selection Module **************************************/
    private func navigateToGrownoutSelectionPE(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GrownoutSelectionViewController") as? GrownoutSelectionViewController
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    private func navigateToModuleSelectionPVE(){
        print(appDelegateObj.testFuntion())
    }

    // MARK:  ********** Download PDF file **************************************/
    @IBAction func injectionSheetPDFDownloadBtnAction(_ sender: Any) {
        
        let baseURL = Constants.Api.pveBaseUrl
        let userInput = "/PDF/SummaryReport.pdf"

        // Safely construct the URL
        var injectSheeetURL: URL!
        if let sanitizedURL = URL(string: baseURL)?.appendingPathComponent(userInput) {
            injectSheeetURL = sanitizedURL
        }
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
        
        DispatchQueue.main.async {
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataPath = documentDirectory.appendingPathComponent("Emergency injection sheet.PDF")
            let fileExists = FileManager().fileExists(atPath: dataPath.path)
            
            if fileExists
            {
                print("File already exists at \(dataPath)")
               // self.showtoast(message: "file already downloaded")
                return
            }
            
            self.showtoast(message: "Downloading")
            
            if let pdfURL = injectSheeetURL {
                let url1 = URL(string: pdfURL.absoluteString)
                let destination = dataPath.appendingPathComponent("")
                self.loadingBlankPdfUrl(url: url1!, to: destination)
            } else {
                print("pdfURL is nil")
            }
         
        }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download pdf file.", comment: ""))
        }
      
    }

    
    func loadingBlankPdfUrl(url: URL,  to localURl: URL) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request){(tempLocalUrl , responce , error) in
            
            if let tempLocalUrl = tempLocalUrl , error == nil {
                
                if let statusCode = (responce as? HTTPURLResponse)?.statusCode{
                    print("Sucess:\(statusCode)")
                    
                    DispatchQueue.main.async {
                        self.showtoast(message: "PDF Downloaded Sucessfully..")
                    }
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localURl)
                }
                catch(let writeError){
                    print("error Writting Files\(localURl) : \(writeError)")
                }
            } else{
                print("Failuer : %@ " , error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
}

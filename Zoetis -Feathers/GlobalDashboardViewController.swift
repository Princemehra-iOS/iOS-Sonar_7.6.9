//
//  GlobalDashboardViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 28/01/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import SwiftyJSON

class GlobalDashboardViewController: BaseViewController {
    
    @IBOutlet weak var bannerImageview: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnGrowOut: UIButton!
    @IBOutlet weak var btnBreeder: UIButton!
    @IBOutlet weak var btnHatchery: UIButton!
    @IBOutlet weak var lblAppVersion: UILabel!
    
    @IBOutlet weak var sessionLabel: UILabel!
    
    let versionStr = "Version "
    var index = 0
    let animationDuration: TimeInterval = 0.75
    let switchingInterval: TimeInterval = 5
    var bottomViewController:BottomViewController!
    let images  = [UIImage(named: "Poultry_App_1908x802.jpg")!,
                   UIImage(named: "embrex_banner_graphic_1786x432.jpg")!,
                   UIImage(named: "PoulvacEcoli_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "PoulvacIB_banner_graphic_1908x802.jpg")!,
                   UIImage(named: "Rotecc_banner_graphic_1908x802.jpg")!]
    
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupHeader()
        bannerImageview.startAnimating()
        animateImageView()
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
            lblAppVersion.text = versionStr + Bundle.main.versionNumber + " (UAT)"
            
        case 1:
            lblAppVersion.text = versionStr + Bundle.main.versionNumber + " (Dev)"
            
        case 2:
            lblAppVersion.text = versionStr + Bundle.main.versionNumber + " (Dev Support)"
            
        case 3:
            lblAppVersion.text = versionStr + Bundle.main.versionNumber
            
        default:
            lblAppVersion.text = versionStr + Bundle.main.versionNumber
        }
        
        
        if (UserDefaults.standard.value(forKey: "showAgain") == nil) || ((UserDefaults.standard.value(forKey: "showAgain") as? Bool) != true){
            if WebClass.sharedInstance.connected() {
                self.getVersionCheck()
            }
            else
            {
                Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"No Internet connection, please check your internet connection.")
            }
            
        }
        
        
        
//        TimeManager.shared.onTick = { [weak self] timeString in
//            self?.sessionLabel.text = timeString
//        }
//        
//        TimeManager.shared.onSessionExpired = { [weak self] in
//            self?.performAutoLogout()
//        }
//        
//        TimeManager.shared.startTimer()
//        
//        // Optional: Check at load
//        if TimeManager.shared.isSessionExpired() {
//            performAutoLogout()
//        }
        
    }
    
    func performAutoLogout() {
         TimeManager.shared.clearSession()
        
        
         // Navigate to login screen
//         let loginVC = LoginViewController() // Replace with your actual login view controller
//         let nav = UINavigationController(rootViewController: loginVC)
//         UIApplication.shared.windows.first?.rootViewController = nav
//         UIApplication.shared.windows.first?.makeKeyAndVisible()
     }
    
    func getRemainingTimeForAutoLogout() -> TimeInterval? {
        guard let loginDate = UserDefaults.standard.object(forKey: "LoginDate") as? Date else { return nil }
        let expiryDate = Calendar.current.date(byAdding: .day, value: 7, to: loginDate)!
        let remainingTime = expiryDate.timeIntervalSinceNow
        return remainingTime > 0 ? remainingTime : nil
    }
    
    
    // MARK:  ********** Check App Version **************************************/
    func getVersionCheck(){
        ZoetisWebServices.shared.getAppVersionCheck(controller: self, parameters: [:]) { json, error in
            
            let dict = json[0]
            let result = dict["Result"].boolValue
            let updateMessage = dict["AlertMsg"].stringValue
            if error != nil {
                Helper.showAlertMessage(self,titleStr:Constants.alertStr , messageStr:"API is Not Working...")
            }            
            
            
            if !result{
                let notNowButton = UIAlertAction(title: "OK, I will do later", style: .default)
                
                let alert = UIAlertController(title: "An updated version is now available.", message: updateMessage, preferredStyle: .alert)
                let updateAction = UIAlertAction(title: "Update Now", style: .default) { _ in
                    self.updateNow()
                }
                alert.addAction(updateAction)
                alert.addAction(notNowButton)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // MARK:  ********** Update App Function **************************************/
    func updateNow() {
        
        guard let url = URL(string: "https://itunes.apple.com/us/app/poultryview-360/id1228196698?mt=8") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    // MARK: - Banner Animation
    
    func animateImageView() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = DispatchTime.now() + Double(Int64(self.switchingInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        bannerImageview.layer.add(transition, forKey: kCATransition)
        bannerImageview.image = images[index]
        CATransaction.commit()
        index = index < images.count - 1 ? index + 1 : 0
    }
    // MARK:  ********** Setup Header **************************************/
    private func setupHeader() {
        bottomViewController = BottomViewController()
        self.bottomView.addSubview(bottomViewController.view)
        self.topviewConstraint(vwTop: bottomViewController.view)
    }
    
    func curveAnimation(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
        let combinedAnimationOptions: UIView.AnimationOptions = [animationOptions, .allowUserInteraction]
        
        let defaultXMovement: CGFloat = 240
        UIView.animate(withDuration: 0.5, delay: 0, options: combinedAnimationOptions, animations: {
            view.transform = isReset ? .identity : CGAffineTransform.identity.translatedBy(x: defaultXMovement, y: 0)
        }, completion: nil)
    }
    
    func transitionAnimationPE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
        self.navigateToModuleSelectionPE()
        
    }
    
    func transitionAnimationPVE(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
        self.navigateToModuleSelectionPVE()
        
    }
    
    // MARK:  ********** Hatchery Button Action **************************************/
    @IBAction func btnHatcheryClicked(_ sender: Any) {
        transitionAnimationPE(view: btnHatchery, animationOptions: .transitionCrossDissolve, isReset: true)
    }
    // MARK:  ********** PVE Button Action **************************************/
    @IBAction func btnBreederClicked(_ sender: Any) {
        self.navigateToModuleSelectionPVE()
    }
    // MARK:  ********** Growout Button Action **************************************/
    @IBAction func btnGrowoutClicked(_ sender: Any) {
        
        self.navigateToGrownOutSelectionPVE()
    }
    // MARK:  ********** Navigate to PE Module **************************************/
    private func navigateToModuleSelectionPE(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "HatcherySelectionViewController") as? HatcherySelectionViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK:  ********** Navigate to PVE Module **************************************/
    private func navigateToModuleSelectionPVE(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "PulletSelectionViewController") as? PulletSelectionViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK:  ********** Navigate to Flock Health Module **************************************/
    private func navigateToGrownOutSelectionPVE(){
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GrownoutSelectionViewController") as? GrownoutSelectionViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

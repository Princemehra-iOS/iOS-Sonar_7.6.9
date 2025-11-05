//
//  BirdsSelectionVC.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 12/03/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Reachability
import SystemConfiguration

class BirdsSelectionVC: UIViewController {
    
    // MARK: - OUTLET
    @IBOutlet weak var userNameLbl: UILabel!
    // MARK: - VARIABLE
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var accestoken = String()
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        UserDefaults.standard.set(false, forKey: "BirdDetailsChicken")
        UserDefaults.standard.set(false, forKey: "BirdDetailsTurkey")
        UserDefaults.standard.set(3, forKey: "birdTypeId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        UserDefaults.standard.set(3, forKey: "LastScreenRef")
    }
    // MARK: 🐔 Chicken Selection Action
    @IBAction func chickenSelectionAction(_ sender: Any) {
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        if lngId == 3 {
            LanguageUtility.setAppleLAnguageTo(lang: "fr")
        }
        
        UserDefaults.standard.set(false, forKey: "turkeyReport")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(4, forKey: "chick")
        if ConnectionManager.shared.hasConnectivity() {
            
            UserDefaults.standard.set(true, forKey: "chickenSyncStatus")
            UserDefaults.standard.set(false, forKey: "turkeySyncStatus")
            UserDefaults.standard.set(false, forKey: "ChickenBird")
            UserDefaults.standard.set(true, forKey: "Chicken")
            UserDefaults.standard.set(false, forKey: "turkey")
            UserDefaults.standard.set(true, forKey: "BirdDetailsChicken")
            let checkC = UserDefaults.standard.bool(forKey: "TermsChicken")
            
            if checkC == true {
                UserDefaults.standard.set(true, forKey: "TermsChicken")
                let navigateDashZoetis = storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as! DashViewController
                self.navigationController?.pushViewController(navigateDashZoetis, animated: false)
            }
            if checkC == false {
                UserDefaults.standard.set(true, forKey: "TermsChicken")
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "helpView") as? HelpViewController
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            }
        } else {
            let custArr = CoreDataHandler().fetchCustomer()
            if custArr.count>0{
                let navigateDashZoetis = storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as! DashViewController
                self.navigationController?.pushViewController(navigateDashZoetis, animated: false)
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please connect to Internet, switching species is only allowed when device is connected to Internet.", comment: ""))
            }
        }
    }
    // MARK: 🦃 Turkey Selection Action
    @IBAction func turkeySelectionAction(_ sender: Any) {
        
        LanguageUtility.setAppleLAnguageTo(lang: "en")
        UserDefaults.standard.set(5, forKey: "chick")
        UserDefaults.standard.set(true, forKey: "turkeyReport")
        UserDefaults.standard.synchronize()
        
        if ConnectionManager.shared.hasConnectivity() {
            UserDefaults.standard.set(true, forKey: "turkeySyncStatus")
            UserDefaults.standard.set(false, forKey: "chickenSyncStatus")
            UserDefaults.standard.set(true, forKey: "turkey")
            UserDefaults.standard.set(false, forKey: "Chicken")
            UserDefaults.standard.set(true, forKey: "BirdDetailsTurkey")
            UserDefaults.standard.set(false, forKey: "TurkeyBird")
            
            let checkC = UserDefaults.standard.bool(forKey: "TermsTurkey")
            if checkC == true {
                UserDefaults.standard.set(true, forKey: "TermsTurkey")
                let navigateDashTurkey = storyboard?.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as! DashViewControllerTurkey
                self.navigationController?.pushViewController(navigateDashTurkey, animated: false)
            }
            if checkC == false {
                UserDefaults.standard.set(true, forKey: "TermsTurkey")
                let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HelpScreenVcTurkey") as? HelpScreenVcTurkey
                self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            }
        } else {
            let custArr = CoreDataHandlerTurkey().fetchCustomerTurkey()
            if custArr.count>0{
                let navigateDashTurkey = storyboard?.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as! DashViewControllerTurkey
                self.navigationController?.pushViewController(navigateDashTurkey, animated: false)
            }
            else {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please connect to Internet, switching species is only allowed when device is connected to Internet.", comment: ""))
            }
        }
    }
}

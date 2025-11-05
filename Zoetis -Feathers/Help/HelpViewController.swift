//
//  HelpViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 1/17/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Reachability
import Gigya
import GigyaTfa
import GigyaAuth



class HelpViewController: UIViewController, userLogOut, UIScrollViewDelegate, syncApi {
    
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    let objApiSync = ApiSync()
    var customPopView1: UserListView!
    let buttonbg1 = UIButton()
    let buttonbg = UIButton()
    @IBOutlet weak var userNameLabel: UILabel!
    let gigya = Gigya.sharedInstance(GigyaAccount.self)
    var lngId = NSInteger()

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        acceptButton.alpha = 1
        gifView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        objApiSync.delegeteSyncApi = self
        
        if UserDefaults.standard.integer(forKey: "lngId") == 3 {
            let jeremyGif = UIImage.gifImageWithName("chicken_french_2")
            let imageView = UIImageView(image: jeremyGif)
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gifView.addSubview(imageView)
        } else {
            let jeremyGif = UIImage.gifImageWithName("chicken")
            let imageView = UIImageView(image: jeremyGif)
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gifView.addSubview(imageView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lngId = UserDefaults.standard.integer(forKey: "lngId")
    }
    
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        
        clickHelpPopUp()
    }
    
    @IBAction func slidebtnAction(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView, indexValue: String) {
        
        if indexValue == "Log Out" {
            
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected()  == true {
                self.ssologoutMethod()
                CoreDataHandler().deleteAllData("Custmer")
            }
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "viewC") as? ViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
            buttonbg.removeFromSuperview()
            customPopView1.removeView(view)
            
        }
    }
    // MARK:  /*********** Logout SSO Account **************/
    func ssologoutMethod()
    {
        gigya.logout() { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clickHelpPopUp() {
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 668)
        buttonbg1.addTarget(self, action: #selector(HelpViewController.buttonPressed11), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 0.3)
        self.view .addSubview(buttonbg1)
        
        customPopView1 = UserListView.loadFromNibNamed("UserListView") as! UserListView
        customPopView1.logoutDelegate = self
        customPopView1.layer.cornerRadius = 8
        customPopView1.layer.borderWidth = 3
        customPopView1.layer.borderColor =  UIColor.clear.cgColor
        self.buttonbg1 .addSubview(customPopView1)
        customPopView1.showView(self.view, frame1: CGRect(x: self.view.frame.size.width - 200, y: 60, width: 150, height: 60))
        
    }
    @objc func buttonPressed11() {
        customPopView1.removeView(view)
        buttonbg1.removeFromSuperview()
    }
    
    @IBAction func acceptButton(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "termsAcceptedTrue")
        self.dasBoradPush()
    }
    
    func dasBoradPush() {
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashView_Controller") as? DashViewController
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    @IBAction func synvBtnAction(_ sender: AnyObject) {
        
        if self.allSessionArr().count > 0 {
            if WebClass.sharedInstance.connected()  == true {
                
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                
                self.callSyncApi()
            } else {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("Data not available for syncing.", comment: ""))
        }
    }
    
    func allSessionArr() -> NSMutableArray {
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1 {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId {
                    necArrWithoutPosting.remove(c)
                }
                
            }
            
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            let sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            let sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
    func callSyncApi() {
        objApiSync.feedprogram()
    }
    
    // MARK: - - Delegate SyNC Api
    func failWithError(statusCode: Int) {
        
        Helper.dismissGlobalHUD(self.view)
        //   self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        } else {
            
            if lngId == 1 {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: "There are problem in data syncing please try again. \n(\(statusCode))")
                
            } else if lngId == 3 {
                Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: "Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
            }
            
        }
    }
    func failWithErrorInternal() {
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    
    func didFinishApi() {
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnection() {
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString(Constants.offline, comment: ""))
    }
    
}

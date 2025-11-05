//
//  TrainingEducationViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 1/17/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import SystemConfiguration
import CoreData

import Gigya
import GigyaTfa
import GigyaAuth




class TrainingEducationViewController: UIViewController,userLogOut,syncApi {
    // MARK: - VARIABLES

 
    var customPopView1 :UserListView!
    let buttonbg1 = UIButton ()
    let buttonbg = UIButton ()
    var accestoken = String()
    var lngId = NSInteger()
    let objApiSync = ApiSync()
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - OUTLET
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var syncNotificationLbl: UILabel!
    let gigya =  Gigya.sharedInstance(GigyaAccount.self)
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        let val = UserDefaults.standard.integer(forKey: "chick")
        if val  ==  4 {
            //Take Action on Notification
            UserDefaults.standard.set(0, forKey: "postingId")
            UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
            appDelegate.sendFeedVariable = ""
            let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PostingViewController") as? PostingViewController
            self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
            
        }else {

            UserDefaults.standard.set(0, forKey: "postingId")
            UserDefaults.standard.set(false, forKey: "ispostingIdIncrease")
            appDelegate.sendFeedVariable = ""
            let navigateTo = self.storyboard?.instantiateViewController(withIdentifier: "PostingVCTurkey") as! PostingVCTurkey
            self.navigationController?.pushViewController(navigateTo, animated: true)
        }
    }
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        let val = UserDefaults.standard.integer(forKey: "chick")
        if val  ==  4 {
            NotificationCenter.default.addObserver(self, selector: #selector(TrainingEducationViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
            
        }  else {
        
            NotificationCenter.default.addObserver(self, selector: #selector(TrainingEducationViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierTurkey"), object: nil)
            
        }
        
        pageControl.addTarget(self, action: #selector(TrainingEducationViewController.didChangePageControlValue), for: .valueChanged)
        objApiSync.delegeteSyncApi = self
        Helper.dismissGlobalHUD(self.view)
        
    }
    
    // MARK: - Walkthrough delegate -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.printSyncLblCount()
        lngId = UserDefaults.standard.integer(forKey: "lngId")

        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        
    }
    // MARK: - IBACTIONS
    @IBAction func shareButtonPress(_ sender: AnyObject) {
        
        var name = String()
        var pass = String()
        
        let alert = UIAlertController(title:NSLocalizedString("Enter credentials to share data", comment: "") ,
                                      message: "",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                               style: UIAlertAction.Style.default) { (action: UIAlertAction) in
                                
                                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                                    
                                    name = alertTextField.text!
                                }
                                if let alertTextField2 = alert.textFields?[1], alertTextField2.text != nil {
                                    // pass.secureTextEntry = true
                                    pass = alertTextField2.text!
                                }
                                
                                let login  = CoreDataHandler().fetchLoginType() as NSArray
                                let user = login.object(at: 0) as! Login
                                let userName = user.username
                                let signal = user.signal
                                
                                let formatter = DateFormatter()
                                // initially set the format based on your datepicker date / server String
                                formatter.dateFormat = Constants.MMddyyyyStr
                                
                                let myString = formatter.string(from: Date()) // string purpose I add here
                                print("\(String(describing: user.username)) "+myString)
                                
                                if userName == name && signal == pass{
                                    let DB = self.appDelegate.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
                                    let activityViewController = UIActivityViewController(activityItems:[DB,"\(String(describing: user.username!)) "+myString], applicationActivities: nil)
                                    activityViewController.setValue("\(String(describing: user.username!)) "+myString, forKey: "subject")
                                    activityViewController.popoverPresentationController?.sourceView = self.view
                                    self.navigationController?.present(activityViewController, animated: true, completion: nil)
                                }
                                else{
                                    Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Please enter the valid credentials.", comment: ""))
                                }
                      }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "") ,
                                   style: UIAlertAction.Style.cancel,
                                   handler: nil)
        
        alert.addTextField { (textField: UITextField) in
            
               textField.placeholder = "Username"
            if self.lngId == 3 {
                textField.placeholder = "Nom d'utilisateur"

            }
            
            
        }
        
        alert.addTextField { (textField2: UITextField) in
            
              textField2.placeholder = "Password"
            if self.lngId == 3 {
                textField2.placeholder = "Mot de passe"

            }

            textField2.isSecureTextEntry = true
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    @objc func didChangePageControlValue() {
        
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }

    


    @IBAction func slideMenuAction(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        clickHelpPopUp()
    }
    // MARK: - METHODS AND FUNCTIONS
    func leftController(_ leftController: UserListView, didSelectTableView tableView: UITableView ,indexValue : String){
        
        if indexValue == "Log Out"
        {
            
            UserDefaults.standard.removeObject(forKey: "login")
            if WebClass.sharedInstance.connected()  == true{
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
        
        buttonbg1.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        buttonbg1.addTarget(self, action: #selector(TrainingEducationViewController.buttonPressed11), for: .touchUpInside)
        buttonbg1.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
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
    
    
    
    @IBAction func syncBtnAction(_ sender: AnyObject) {
        
        
        if self.allSessionArr().count > 0
        {
            if WebClass.sharedInstance.connected()  == true{
                
                Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Data syncing...", comment: ""))
                
                self.callSyncApi()
            }
            else
            {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
                
            }
            
        }
            
            
        else{
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("Data not available for syncing.", comment: ""))
        }
        
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandler().fetchAllPostingSessionWithisSyncisTrue(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandler().FetchNecropsystep1WithisSync(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyData
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyData
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
                
            }
            
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSession
            var  sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyData
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    func callSyncApi()
    {
        objApiSync.feedprogram()
    }
    
    //MARK -- Delegate SyNC Api
    
    func failWithError(statusCode:Int)
    {
        
        Helper.dismissGlobalHUD(self.view)
        self.printSyncLblCount()
        
        if statusCode == 0 {
            Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("There are problem in data syncing please try again.(NA))", comment: ""))
        }
        else{
            
            
            if lngId == 1 {
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
                
                
            } else if lngId == 3 {
                
                Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"Problème de synchronisation des données, veuillez réessayer à nouveau. \n(\(statusCode))")
                
            }
            //Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:"There are problem in data syncing please try again. \n(\(statusCode))")
        }
    }
    func failWithErrorInternal()
    {
        Helper.dismissGlobalHUD(self.view)
        
        
        self.printSyncLblCount()
        
        //Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:" Server error please try again .")
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString("No internet connection. Please try again!", comment: ""))
    }
    
    func didFinishApi()
    {
        self.printSyncLblCount()
        
        Helper.dismissGlobalHUD(self.view)
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.dataSyncCompleted, comment: ""))
    }
    
    func failWithInternetConnection()
    {
        
        self.printSyncLblCount()
        
        Helper.dismissGlobalHUD(self.view)
        
        Helper.showAlertMessage(self,titleStr:NSLocalizedString(Constants.alertStr, comment: "") , messageStr:NSLocalizedString(Constants.offline, comment: ""))
    }
    
    
    
    func printSyncLblCount()
    {
        
        syncNotificationLbl.text = String(self.allSessionArr().count)
    }
    
}

extension TrainingEducationViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        
    }
}


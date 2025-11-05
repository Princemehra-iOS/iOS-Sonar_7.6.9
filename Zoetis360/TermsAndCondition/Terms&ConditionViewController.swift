//
//  Terms&ConditionViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 09/02/17.
//  Copyright © 2017 "". All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import Reachability
import SystemConfiguration
import WebKit
import SwiftyJSON


class Terms_ConditionViewController: UIViewController,WKUIDelegate,WKNavigationDelegate{
    @IBOutlet weak var wkwebView: WKWebView!
    var isLinkedClicked = Bool()
    var isFirstTimeLoad = Bool()
    var accestoken = String()
    var webLoads = Int()
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var acceptOutlet: UIButton!
    @IBAction func clickOnBackButton(_ sender: AnyObject) {
        
        if wkwebView.canGoBack {
            wkwebView.goBack()
        }
    }
    var lngId = UserDefaults.standard.integer(forKey: "lngId")
    // MARK: 🟠 View Life cycle
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        backBtn.isHidden = true
        wkwebView.uiDelegate = self
        
        wkwebView.navigationDelegate = self
        Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString("Logging in...Please Wait", comment: ""))
        webLoads = 0
        loadHtmlFile()
        acceptOutlet.layer.borderWidth = 1
        acceptOutlet.layer.cornerRadius = 4.0
        acceptOutlet.layer.borderColor = UIColor.clear.cgColor
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.wkwebView.stopLoading()
        self.wkwebView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "Terms&Condition")
    }
    
    func loadHtmlFile() {
        if lngId == 1{
            
            let url = Bundle.main.url(forResource: "terms-of-use", withExtension:"html")
            let request = URLRequest(url: url!)
            wkwebView.load(request)
            
        } else if lngId == 3{
            let url = Bundle.main.url(forResource: "index(1)", withExtension:"html")
            let request = URLRequest(url: url!)
            wkwebView.load(request)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        Helper.dismissGlobalHUD(self.view)
        
        if self.webLoads != 1 {
            self.webLoads -= 1
        }
        
        if lngId == 1 {
            var navigationAction: WKNavigationAction?
            
            if let url = navigationAction?.request.url,
               !(url.absoluteString.lowercased().range(of: "terms-of-use.html") != nil)
            {
                print("exists")
                isFirstTimeLoad = true
            } else {
                isFirstTimeLoad = false
            }
        }
        else if lngId == 3 {
            var navigationAction: WKNavigationAction?
            
            if let url = navigationAction?.request.url,
               !(url.absoluteString.lowercased().range(of: "index(1).html") != nil)
            {
                print("exists")
                isFirstTimeLoad = true
            } else {
                isFirstTimeLoad = false
            }
        }
        if wkwebView.isLoading {
            print(appDelegateObj.testFuntion())
        } else {
            if isLinkedClicked == true && isFirstTimeLoad == false {
                backBtn.isHidden = false
            } else {
                backBtn.isHidden = true
            }
        }
    }
    // MARK: 🟠 Accept Button Action
    @IBAction func acceptBtn(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "Terms&Condition")
        UserDefaults.standard.set(false, forKey: "Terms")
        self.postTermsCond()
        
        UserDefaults.standard.set(true, forKey: "login")
        
        let birdTypeId = UserDefaults.standard.integer(forKey: "birdTypeId")
        if birdTypeId == 2 {
            UserDefaults.standard.set(false, forKey: "TermsTurkey")
            UserDefaults.standard.set(true, forKey: "TurkeyBird")
            UserDefaults.standard.set(5, forKey: "chick")
            navToDashboard()
        } else if birdTypeId == 1 {
            UserDefaults.standard.set(false, forKey: "TermsChicken")
            UserDefaults.standard.set(true, forKey: "ChickenBird")
            UserDefaults.standard.set(4, forKey: "chick")
            navToDashboard()
        }
        else if birdTypeId == 3 {
            navToDashboard()
        }
        else{
            navToDashboard()
        }
    }
    // MARK: 🟠 Global Dashboard Button action
    func navToDashboard(){
        UserDefaults.standard.set(true, forKey: "newlogin")
        let vc = UIStoryboard.init(name: Constants.Storyboard.selection, bundle: Bundle.main).instantiateViewController(withIdentifier: "GlobalDashboardViewController") as? GlobalDashboardViewController
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    // MARK: 🟠 Web view Load term & Conditions
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if (navigationAction.navigationType == .linkActivated){
            isLinkedClicked = true
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webLoads -= 1;
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webLoads -= 1;
    }
    // MARK: 🟠 Post term & Condition to server
    func postTermsCond() {
        
        if WebClass.sharedInstance.connected() {
            let Id = UserDefaults.standard.integer(forKey: "Id")
            
            ZoetisWebServices.shared.getTermConditionResponceResponce(controller: self, parameters: ["userId" :Id,"TermsAccepted": "true"], completion: { [weak self] (json, error) in
                guard let _ = self, error == nil else {
                   // self?.showToastWithTimer(message: "Failed to get Bird Size list", duration: 3.0)
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                    return
                }
                
                let jsonResponse = JSON(json)
                // Check for the "errorResult" key and handle errors
                if let errorResult = jsonResponse["errorResult"].dictionary {
                    let errorMsg = errorResult["errorMsg"]?.string ?? Constants.unknownErrorStr
                    let errorCode = errorResult["errorCode"]?.string ?? Constants.unknowCode
                    
                    print("Error from get Route list API : \(errorMsg) (Code: \(errorCode))")
                    if errorCode == "401" || errorCode == "404"{
//                        self!.loginMethod()
                    }
                } else {
                    self?.dismissGlobalHUD(self?.view ?? UIView())
                }
            })
        }
    }
}

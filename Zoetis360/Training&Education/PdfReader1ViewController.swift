//
//  PdfReader2ViewController.swift
//  Zoetis -Feathers
//
//  Created by    on 5/29/17.
//  Copyright © 2017   . All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import WebKit

class PdfReader2ViewController: UIViewController, UIWebViewDelegate , URLSessionDataDelegate , URLSessionDelegate , URLSessionTaskDelegate,WKUIDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var progressview: UIProgressView!
    @IBOutlet weak var wkwebView: WKWebView!
    @IBOutlet weak var labelProgress: UILabel!
    var dataToDownload: NSMutableData?
    var downloadSize: Float = 0.0
    @IBOutlet weak var lblOfflineMessage: UILabel!
    var hud1 : MBProgressHUD = MBProgressHUD()
    @IBOutlet weak var webView: WKWebView!
    var accestoken = String()
    var pathArr = NSMutableArray()
    var defaultSession: Foundation.URLSession?
    let pdfFileNameOne = "pdf1.pdf"
    @IBOutlet weak var subHeader: UILabel!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.loadWebView()
    }
    func loadWebView(){
        wkwebView.navigationDelegate = self
        
        wkwebView.isUserInteractionEnabled  = true
        wkwebView.scrollView.isScrollEnabled = true
        wkwebView.clearsContextBeforeDrawing = true
        
        wkwebView.scrollView.maximumZoomScale = 4.0
        wkwebView.scrollView.minimumZoomScale = 1.0
        wkwebView.uiDelegate = self

        self.subHeader.text = NSLocalizedString("Necropsy Manual", comment: "")
        self.makeBodyBackgroundTransparent()
        
        
    }
    func callWebApiforTutorial(_ completion: @escaping (_ status: Bool) -> Void)  {
        
        if WebClass.sharedInstance.connected() {
            debugPrint("intewrnet is connected.")
        }
    }
    func makeBodyBackgroundTransparent() {
        
        
        for subview: UIView in wkwebView.subviews {
            subview.isOpaque = false
            subview.backgroundColor = UIColor.clear
        }
        wkwebView.isOpaque = false
        wkwebView.backgroundColor = UIColor.clear
        wkwebView.layer.backgroundColor = UIColor.clear.cgColor
        
    }
    
    func checkLastPdfPathFromServerIsChanged()
    {
        if let lastPath = UserDefaults.standard.string(forKey: "pdf1Path") {
            self.callWebApiforTutorial { (status) in
                if status == true
                {
                    let currentPath = self.pathArr.object(at: 1) as! String
                    if currentPath == lastPath
                    {
                        self.lblOfflineMessage.isHidden = true
                        self.loadHtmlFile()
                        self.progressview.isHidden = true
                        self.labelProgress.isHidden = true
                    }
                    else{
                        self.progressview.isHidden = false
                        self.labelProgress.isHidden = false
                        self.lblOfflineMessage.isHidden = true
                        self.downloadSize = 0.0
                        self.dataToDownload = NSMutableData()                        
                    }
                }
            }
        }
        else{
            self.lblOfflineMessage.isHidden = true
            self.loadHtmlFile()
            self.progressview.isHidden = true
            self.labelProgress.isHidden = true
            
        }
        
    }
    
    func loadLoader()  {
        if MBProgressHUD.forView(self.view) == nil {
            hud1 = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud1.contentColor = UIColor.white
            hud1.bezelView.color = UIColor.black
            hud1.label.text = appDelegateObj.loadingStr
        }
    }
    
    
    func callPdfApiandDownload()
    {
        progressview.progress = 0.0
        progressview.transform =   CGAffineTransform(scaleX: 1.0, y: 2.0)
        progressview.isHidden = false
        labelProgress.isHidden = false
        
        self.lblOfflineMessage.isHidden = true
        
        self.downloadSize = 0.0
        dataToDownload = NSMutableData()
        
        
        self.callWebApiforTutorial { (status) in
            if status == true
            {
                self.downloadAndStorePDFFromURLWithString(self.pathArr.object(at: 1) as! String, completion: { (status) in
                    
                    if status == true
                    {
                        debugPrint(status)
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if WebClass.sharedInstance.connected() {
            if self.checkPdfExitOnLocal() == true
            {
                self.lblOfflineMessage.isHidden = true
                progressview.isHidden = true
                labelProgress.isHidden = true
                self.loadLoader()
                self.checkLastPdfPathFromServerIsChanged()
            }
            else
            {
                self.callPdfApiandDownload()
            }
        }
        else{
            if self.checkPdfExitOnLocal() == true
            {
                self.lblOfflineMessage.isHidden = true
                self.loadHtmlFile()
                progressview.isHidden = true
                labelProgress.isHidden = true
            }
            else
            {
                self.lblOfflineMessage.isHidden = false
                progressview.isHidden = true
                labelProgress.isHidden = true
            }
            
        }
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func loadHtmlFile() {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(pdfFileNameOne).absoluteString
        let req = URLRequest(url: URL(string: filePath)!)
        wkwebView.load(req)
        
    }
    func removeFileContentsInLocally(_ filePath : String)
    {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func sizeForLocalFilePath(_ filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]  {
                return (fileSize as! NSNumber).uint64Value
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func checkPdfExitOnLocal() -> Bool
    {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(pdfFileNameOne).path

        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            return true
        } else {
            print("FILE NOT AVAILABLE")
            return false
        }
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud1.hide(animated: true)
        progressview.isHidden = true
        labelProgress.isHidden = true
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressview.isHidden = true
        labelProgress.isHidden = true
    }
    
    
    func downloadAndStorePDFFromURLWithString(_ stringURL: String,completion: (_ status: Bool) -> Void) {
        progressview.progress = 0.0
        labelProgress.text = "0 %"
        progressview.isHidden = false
        let configuration = URLSessionConfiguration.default
        defaultSession = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let dataTask: URLSessionDataTask? = defaultSession!.dataTask(with: URL(string: stringURL)!)
        configuration.timeoutIntervalForResource = 20000
        dataTask?.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        progressview.progress = 0.0
        downloadSize = Float(response.expectedContentLength)
        dataToDownload = NSMutableData()
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        DispatchQueue.main.async(execute: {
            
            if let datalocal = self.dataToDownload {
                self.dataToDownload?.append(data)
                
                if self.downloadSize != 0.0
                {
                    self.progressview.progress = Float(datalocal.length) / self.downloadSize
                    self.labelProgress.text =  NSString(format: "%d %%", Int(Float(datalocal.length) * 100 / self.downloadSize)) as String
                }
            }
        })
    }
    func urlSession(_ session: Foundation.URLSession, didBecomeInvalidWithError error: Error?) {
        print("Error \(error.debugDescription)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("failed: \(error.debugDescription)")
        }
        else if dataToDownload != nil {
            
            let finaldata = dataToDownload?.copy() as! Data
            
            self.wkwebView.load(finaldata as Data, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: Bundle.main.bundleURL)
            
            var docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            docURL = docURL?.appendingPathComponent(pdfFileNameOne)
            try? finaldata.write(to: docURL!, options: [.atomic])
            
            if self.checkPdfExitOnLocal() == false {
                self.callPdfApiandDownload()
            }
            
        }
        else {
            print("responseData is nil")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.downloadSize = 0.0
        hud1.hide(animated: true)
        dataToDownload = nil
        self.defaultSession?.invalidateAndCancel()
        if self.pathArr.count > 1{
            UserDefaults.standard.setValue(self.pathArr.object(at: 1) as! String, forKey: "pdf1Path")
        }
    }
}


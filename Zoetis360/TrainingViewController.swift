//
//  TrainingViewController.swift
//  Zoetis -Feathers
//
//  Created by MobileProgramming on 11/03/22.
//

import UIKit
import WebKit
import Alamofire


class TrainingViewController: UIViewController, WKUIDelegate{
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var subHeader: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: - VARIABLES
    var pages = [WKWebView]()
    let webView1: WKWebView = WKWebView()
    let webView2: WKWebView = WKWebView()
    let webView3: WKWebView = WKWebView()
    var accestoken = String()
    var count = 0
    var pathArr = NSMutableArray()
    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)[0]
    private let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return Session(configuration: configuration)
    }()

    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.subHeader.isHidden = true
        self.loadHtmlFile()
        view.bringSubviewToFront(pageControl)
        self.subHeader.text = NSLocalizedString("Diagnosing Coccidiosis And Enteritis", comment: "")
        self.headerLabel.text = NSLocalizedString("Training & Education", comment: "")
        self.userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
    }

    // MARK: 🟢 - METHODS AND FUNCTIONS

    
    fileprivate func handlePathsDict(_ paths: NSDictionary,_ completion: @escaping (_ status: Bool) -> Void) {
        for (i, value) in paths {
            let fileName = self.documentDirectory.appendingPathComponent("my\(i).pdf")
            if self.checkPdfExitOnLocal(fileName: "my\(i).pdf"){
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = URL(fileURLWithPath: path)
                let filePath = url.appendingPathComponent("my\(i).pdf").absoluteURL
                self.pathArr.add(filePath)
            } else {
                self.downloadFile(serverUrl: URL(string: value as! String)!, fileName: fileName) { status in
                    completion(status)
                }
            }
        }
    }
    
    fileprivate func loadOffLineSavedFile() {
        for i in 1..<3 {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = URL(fileURLWithPath: path)
            let filePath = url.appendingPathComponent("myURL\(i).pdf").absoluteURL
            self.pathArr.add(filePath)
        }
    }
    
    func callWebApiforTutorial(_ completion: @escaping (_ status: Bool) -> Void)  {
        
        if WebClass.sharedInstance.connected() {
            Helper.showGlobalProgressHUDWithTitle(self.view, title: NSLocalizedString(appDelegateObj.loadingStr, comment: ""))
            accestoken = AccessTokenHelper().getFromKeychain(keyed: Constants.accessToken)!
            
            let headerDict: HTTPHeaders = [
                Constants.authorization: accestoken,
                Constants.cacheControl: Constants.noStoreNoCache
            ]
            let Url = WebClass.sharedInstance.webUrl + "PostingSession/GetTutorial"
            
            sessionManager.request(Url, method: .get, headers: headerDict).responseJSON { response in
                switch response.result {
                case let .success(value):
                    self.pathArr.removeAllObjects()
                    let dict : NSDictionary = value as! NSDictionary
                    if let paths = dict["PDFPath"] as? NSDictionary {
                        self.count = paths.count
                        self.handlePathsDict(paths) { status in
                            completion(status)
                        }
                        if self.pathArr.count == self.count {
                            completion(true)
                        }
                    }
                    break
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    break
                }
            }
        } else {
            self.loadOffLineSavedFile()
            if self.pathArr.count == 2{
                completion(true)
            }
        }
    }
    // MARK: 🟠 - Side Menu Button Action
    @IBAction func sideMenuBtnAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    func isValidURL(_ url: URL) -> Bool {
        let allowedHosts = ["trusted.com", "api.trusted.com"] // Replace with your allowed hosts
        return allowedHosts.contains(url.host ?? "")
    }
    
    func isSafeURL(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        let forbiddenIPs = ["127.0.0.1", "localhost"] // Add more as needed
        return !forbiddenIPs.contains(host)
    }
        
    // MARK: Download PDF file.
    func downloadFile(serverUrl: URL, fileName: URL, completion: @escaping (_ status: Bool) -> Void) {
        // Define a safe directory for saving files
        let safeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Validate that the fileName is within the safe directory
        let standardizedFilePath = fileName.standardizedFileURL
        guard standardizedFilePath.path.hasPrefix(safeDirectory.path) else {
            debugPrint("Error: File path is outside the safe directory")
            completion(false)
            return
        }

        guard let fileUrl = URL(string: serverUrl.absoluteString) else {
            debugPrint("Error: Invalid URL")
            completion(false)
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: fileUrl)
        request.httpMethod = "GET"

        let task = session.downloadTask(with: request) { (tempFileUrl, response, error) in
            if let error = error {
                debugPrint("Error during download: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let tempFileUrl = tempFileUrl else {
                debugPrint("Error: Temp file URL is nil")
                completion(false)
                return
            }

            do {
                let fileManager = FileManager.default
                try fileManager.moveItem(at: tempFileUrl, to: standardizedFilePath)
                self.pathArr.add(standardizedFilePath)
            } catch {
                debugPrint("Error: \(error.localizedDescription)")
                completion(false)
                return
            }

            if self.pathArr.count == self.count {
                completion(true)
            }
        }
        task.resume()
    }
    
    // MARK: 🟠 Check PDF file exist on Local
    func checkPdfExitOnLocal(fileName: String) -> Bool
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(fileName).path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return true
        } else {
            return false
        }
    }
    // MARK: 🟠 Setup Scroll View.
    func setupScrollView(pages: [WKWebView]) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pages.count), height: scrollView.frame.height)
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
    
}

// MARK: 🟠 - EXTENSION
extension TrainingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        if pageIndex == 0{
            self.subHeader.isHidden = true
        }else if pageIndex == 1{
            self.subHeader.isHidden = false
            self.subHeader.text = NSLocalizedString("Diagnosing Coccidiosis And Enteritis", comment: "")
        }else if pageIndex == 2{
            self.subHeader.isHidden = false
            self.subHeader.text = NSLocalizedString("Necropsy Manual", comment: "")
        }
    }
    // MARK: 🟠 Load HTML File
    fileprivate func loadWebView() {
        DispatchQueue.main.async {
            if self.pathArr.count > 0{
                for i in 0..<self.pathArr.count{
                    let url = self.pathArr[i]
                    if i == 0{
                        self.webView2.load(URLRequest(url: url as! URL))
                        self.webView2.uiDelegate = self
                        self.pages.append(self.webView2)
                    }else if i == 1{
                        self.webView3.load(URLRequest(url: url as! URL))
                        self.webView3.uiDelegate = self
                        self.pages.append(self.webView3)
                    }
                }
                Helper.dismissGlobalHUD(self.view)
                self.setupScrollView(pages: self.pages)
                self.pageControl.numberOfPages = self.pages.count
                self.pageControl.currentPage = 0
            }
        }
    }
    
    @objc func loadHtmlFile() {
        
        let lngId = UserDefaults.standard.integer(forKey: "lngId")
        let pathToReportHTMLTemplate : String?
        if lngId == 3{
            let val = UserDefaults.standard.integer(forKey: "chick")
            if val  ==  4 {
                pathToReportHTMLTemplate = Bundle.main.path(forResource: "video-details_4", ofType: "html")
            }
            else {
                pathToReportHTMLTemplate = Bundle.main.path(forResource: "video-details", ofType: "html")
            }
        } else{
            pathToReportHTMLTemplate = Bundle.main.path(forResource: "video-details", ofType: "html")
        }
        let HTMLContent = try? String(contentsOfFile: pathToReportHTMLTemplate!, encoding: String.Encoding.utf8)
        webView1.loadHTMLString(HTMLContent!, baseURL: Bundle.main.bundleURL)
        webView1.uiDelegate = self
        self.pages.append(webView1)
        self.callWebApiforTutorial { (status) in
            if status == true
            {
                self.loadWebView()
            }
        }
    }
}

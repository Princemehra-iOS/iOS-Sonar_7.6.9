//
//  peWebViewController.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 13/05/24.
//

import UIKit
import WebKit

class peWebViewController: BaseViewController {
    
    @IBOutlet weak var pdfBackView: UIView!
    @IBOutlet weak var peWebView: WKWebView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var downLoadBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var base64Data = ""
    var showShareAndDownload = Bool()
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        if showShareAndDownload
        {
            shareBtn.isHidden = false
            downLoadBtn.isHidden = false
            doneBtn.isHidden = true
        }
        else
        {
            shareBtn.isHidden = true
            downLoadBtn.isHidden = true
            doneBtn.isHidden = false
        }
        
        let data = Data(base64Encoded: base64Data)
        peWebView.load(data!, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(string: "https://www.google.com")!)
        
    }
    
    // MARK: Close Button Action .
    @IBAction func closeBtnAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Done Button Action .
    @IBAction func doneeBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Download Blank PDF File in iPad Device .
    @IBAction func downLoadBtnAction(_ sender: Any) {
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
            
            DispatchQueue.main.async {
                
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                debugPrint("docDire " + String(describing: documentDirectory))
                let dataPath = documentDirectory.appendingPathComponent("SummaryReport.PDF")
                let fileExists = FileManager().fileExists(atPath: dataPath.path)
                
                if fileExists{
                    self.showtoast(message: "file already downloaded")
                    return
                }
                
            }
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to download pdf file.", comment: ""))
        }
    }
}

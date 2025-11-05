//
//  BlankPDFViewController.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 06/06/22.
//

import UIKit
import PDFKit

class BlankPDFViewController: BaseViewController {
    var pdfURL: URL!
    
    
    @IBOutlet weak var pdfBackView: UIView!
    private var pdfView: PDFView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var downLoadBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(pdfURL)
        self.navigationItem.title = "Hello"
        self.setPDFView()
        self.fetchPDF()
    }
    
    // MARK: Setup PDF View .
    private func setPDFView() {
        DispatchQueue.main.async {
            self.showGlobalProgressHUDWithTitle(self.view, title: appDelegateObj.loadingStr)
            self.pdfView = PDFView(frame: self.pdfBackView.bounds)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.pdfView.maxScaleFactor = 3;
            self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
            self.pdfView.autoScales = true;
            self.pdfView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.pdfBackView.layer.cornerRadius = 10
            self.pdfView.layer.cornerRadius = 5
            self.pdfBackView.addSubview(self.pdfView)
        }
    }
    
    // MARK: Fetch PDF .
    private func fetchPDF() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: self.pdfURL), let document = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                    self.stopHud()
                  
                }
            }
        }
    }
    
    // MARK: Dismiss the Loader .
    func stopHud() {
        dismissGlobalHUD(self.view)
    }
   
    
    // MARK: Close Button Action .

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Share Blank PDF File in iPad Device .
    @IBAction func shareBtnAction(_ sender: Any) {
        
        let request = URLRequest(url:  URL(string: "\(pdfURL as URL)")!)
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if error == nil, let pdfData = data {
                let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\("Blank").PDF")
                do {
                    try pdfData.write(to: pathURL, options: .atomic)
                } catch {
                    print("Error while writting")
                }
                
                DispatchQueue.main.async {
                    debugPrint(pathURL)
                    
                    let fileManager = FileManager.default
                    let documentoPath = "Blank.PDF"
                    if fileManager.fileExists(atPath: documentoPath){
                        let url = URL(fileURLWithPath: documentoPath)
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView=self.view
                        self.present(activityViewController, animated: true, completion: nil)
                    } else {
                        let url = URL(fileURLWithPath: "\(pathURL)")
                        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                        vc.popoverPresentationController?.sourceView = self.view
                        vc.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                        vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
                        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                        self.present(vc, animated: true)
                    }
                }
            }
        }); task.resume()
    }
 
    // MARK: Download Blank PDF File in iPad Device .
    @IBAction func downLoadBtnAction(_ sender: Any) {
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable{
        
        DispatchQueue.main.async {
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dataPath = documentDirectory.appendingPathComponent("SummaryReport.PDF")
            let fileExists = FileManager().fileExists(atPath: dataPath.path)
            
            if fileExists
            {
                self.showtoast(message: "file already downloaded")
                return
            }
            
            self.showtoast(message: "Downloading")
            
            if let pdfURL = self.pdfURL {
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
  
  
    
    func loadingBlankPdfUrl(url: URL, to localURL: URL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                print("Failure: \(error?.localizedDescription ?? Constants.unknownErrorStr)")
                return
            }
            
            // Validate the status code
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                print("Success: \(statusCode)")
                
                DispatchQueue.main.async {
                    self.showtoast(message: "PDF Downloaded Successfully.")
                }
            }
            
            do {
                // Define a safe directory
                let safeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // Validate the localURL
                let standardizedLocalURL = localURL.standardizedFileURL
                guard standardizedLocalURL.path.hasPrefix(safeDirectory.path) else {
                    print("Error: Attempt to write outside the allowed directory")
                    return
                }
                
                // Copy the file to the validated destination
                try FileManager.default.copyItem(at: tempLocalUrl, to: standardizedLocalURL)
            } catch {
                print("Error writing file \(localURL): \(error)")
            }
        }
        task.resume()
    }    
}

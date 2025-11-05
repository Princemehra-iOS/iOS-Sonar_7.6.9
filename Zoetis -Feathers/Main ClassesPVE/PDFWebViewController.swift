//
//  JourneyDetailHeader.swift
//  mobile Programming
//
//  Created by CFF on 2/5/22.
//  Copyright © 2022 Mobile Programming . All rights reserved.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController {
    var pdfURL: URL!
    
    @IBOutlet weak var pdfBackView: UIView!
    private var pdfView: PDFView!
    
    @IBOutlet weak var shareBtn: UIButton!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        
        self.setPDFView()
        self.fetchPDF()
    }
    
    private func setPDFView() {
        DispatchQueue.main.async {
            self.pdfView = PDFView(frame: self.pdfBackView.bounds)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.pdfView.maxScaleFactor = 3;
            self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
            self.pdfView.autoScales = true;
            self.pdfView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.pdfBackView.addSubview(self.pdfView)
        }
    }
    
    private func fetchPDF() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: self.pdfURL), let document = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                    
                }
            }
        }
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        
        let request = URLRequest(url:  URL(string: "\(pdfURL as URL)")!)
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if error == nil, let pdfData = data {
                let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\("Self_Injection").PDF")
                do {
                    try pdfData.write(to: pathURL, options: .atomic)
                } catch {
                    print("Error while writting")
                }
                
                DispatchQueue.main.async {
                    debugPrint(pathURL)
                    
                    let fileManager = FileManager.default
                    let documentoPath = "Self_Injection.PDF"
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
        });
        task.resume()
    }
}

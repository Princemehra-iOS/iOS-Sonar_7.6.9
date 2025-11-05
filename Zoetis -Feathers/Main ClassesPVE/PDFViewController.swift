//
//  PDFViewController.swift
//  PDFDownloader
//
//  Created by Prince on 16/05/22.
//

import UIKit
import PDFKit
class PDFViewController: UIViewController {

    var pdfView = PDFView()
    var pdfURL: URL?
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPDFData()
    }
    
    private func loadPDFData(){
        view.addSubview(pdfView)
        
        guard let pdfURL = pdfURL, let pdfDoc = PDFDocument(url: pdfURL) else  {
           return
        }
        
        pdfView.document = pdfDoc
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = view.frame
    }
    
}

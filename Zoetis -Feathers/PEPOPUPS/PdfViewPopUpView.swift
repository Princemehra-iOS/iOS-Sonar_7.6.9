//
//  FlockAgePopupView.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 27/12/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SwiftyJSON
import PDFKit

protocol FlockAgePopupViewProtocol {
    func okButtonTapped()
}

class PdfViewPopUpView: BaseViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var infoText: UILabel!
    
    var pdfName = ""
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        infoText.text = pdfName
        var name = pdfName
        name = name.replacingOccurrences(of: ".pdf", with: "")
        let fileURL = Bundle.main.url(forResource: name, withExtension: "pdf")
        
        // Add PDFView to view controller.
        if #available(iOS 11.0, *) {
            let pdfViewIs = PDFView(frame: self.pdfView.bounds)
            pdfViewIs.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.pdfView.addSubview(pdfViewIs)
            pdfViewIs.autoScales = true
            pdfViewIs.document = PDFDocument(url: fileURL!)
            
        }  else {
            print(appDelegateObj.testFuntion())
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first ?? UITouch()
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func crossClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
}

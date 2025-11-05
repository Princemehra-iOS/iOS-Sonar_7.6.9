//
//  InfoPVEViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 13/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class InfoPVEViewController: BaseViewController {
    
    @IBOutlet weak var lblQuestionText: UILabel!
    @IBOutlet weak var lblQText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var boldText  = ""
    var questionStr  = String()
    var imageUrlString = String()

    var questionId = String()

    @IBOutlet weak var viewPdfBtn: UIButton!
    var questionDescriptionIs = ""
    var questionIs = ""
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        lblQText.text = questionIs
        lblQuestionText.text = questionDescriptionIs
        viewPdfBtn.isHidden = true
        
        let imageUrl = URL(string: imageUrlString)!
        if let imageData = try? Data(contentsOf: imageUrl) {
            imgView.image = UIImage(data: imageData)
        }
        if questionId == "104" || questionId == "106" {
            viewPdfBtn.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func crossClicked(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pdfBtnAction(_ sender: UIButton) {
        
        if CodeHelper.sharedInstance.reachability?.connection != .unavailable {
            
            let pdfUrl = URL(string: Constants.Api.pveBaseUrl + "/PDF/Accidental_Self_Injection_Wallet_Card.pdf")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "PVEStoryboard", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PdfViewController") as! PdfViewController
            vc.pdfURL = pdfUrl
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: false, completion: nil)
            
        } else {
            Helper.showAlertMessage(self, titleStr: NSLocalizedString(Constants.alertStr, comment: ""), messageStr: NSLocalizedString("You are currently offline. Please go online to view PDF.", comment: ""))
        }
        
   
                
      // self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARKS: DROP DOWN HIDDEN AND SHOW
     func dropHiddenAndShow(){
         if dropDown.isHidden{
             let _ = dropDown.show()
         } else {
             dropDown.hide()
         }
     }
}


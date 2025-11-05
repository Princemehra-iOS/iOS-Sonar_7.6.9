//
//  customAlertView.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 01/02/24.
//

import Foundation

import UIKit

class customAlertView: BaseViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var customHeightConstraint: NSLayoutConstraint!
    var viewHeight : Int = 0
    var AllMessages = [String]()
    
    @IBOutlet weak var okButton: PESubmitButton!
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        imageView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        okButton.setNextButtonUI()
        updateUI()
    }

    @objc func updateUI() {

        let bullet = "•  "
  
        AllMessages = AllMessages.map { return bullet + $0 }
        label.adjustsFontForContentSizeCategory
        
        self.mainView.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: viewHeight)
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.preferredFont(forTextStyle: .body)
        attributes[.foregroundColor] = UIColor.black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = (bullet as NSString).size(withAttributes: attributes).width
        attributes[.paragraphStyle] = paragraphStyle

        let string = AllMessages.joined(separator: "\n\n")
        label.attributedText = NSAttributedString(string: string, attributes: attributes)
    }
    
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

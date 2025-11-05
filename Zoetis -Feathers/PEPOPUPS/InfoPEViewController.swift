//
//  InfoPEViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 21/02/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class InfoPEViewController: BaseViewController {
    
    // MARK: - OUTLETS

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imageViewInfo: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    
    // MARK: - VARIABLES

    var questionDescriptionIs = ""
    var infotextIs = ""
    var imageDataBase64 = ""
    var boldText  = ""

    // MARK: - METHODS

    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        DispatchQueue.main.async {
//            delay(0.1) {
                self.gradientView.setCornerRadiusFloat(radius: 24)
                self.gradientView.setGradient(topGradientColor: UIColor.getGradientUpperColor(), bottomGradientColor: UIColor.getGradientLowerColor())
//            }
        }
        let attributes = [NSAttributedString.Key: Any]()
        let str =  questionDescriptionIs + "\n\n\n" + infotextIs
        infoText.attributedText = NSAttributedString(string: str, attributes: attributes)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first ?? UITouch()
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func dropHiddenAndShow(){
        if dropDown.isHidden{
            let _ = dropDown.show()
        } else {
            dropDown.hide()
        }
    }
    // MARK: - IB ACTIONS

    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - EXTENSION FOR UILABEL

extension UILabel {
    
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
}

//  Zoetis -Feathers
//
//  Created by "" ""on 08/11/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MBProgressHUD
extension UIViewController {

    
    @objc func showGlobalProgressHUDWithTitle(_ vc: UIView, title: String)  {
        
        if MBProgressHUD.forView(vc) == nil {
            let hud = MBProgressHUD.showAdded(to: vc, animated: true)
            hud.contentColor = UIColor.white.withAlphaComponent(0.7)
            hud.backgroundView.color = UIColor.black.withAlphaComponent(0.4)
            hud.bezelView.color = UIColor.white
            hud.label.text = title
            hud.label.textColor = UIColor.black
            hud.label.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        }
    }
    
    func showGlobalProgressHUDWithTitleWithoutHudBack(_ vc: UIView, title: String) {
        
        if MBProgressHUD.forView(vc) == nil {
            let hud = MBProgressHUD.showAdded(to: vc, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.color = UIColor(red: 0, green: 0/255, blue: 0, alpha: 1)
            hud.label.text = title
            hud.label.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        }
    }
    
    func dismissGlobalHUD(_ vc: UIView) {
        MBProgressHUD.hide(for: vc, animated: true)
    }
    
    func showAlertViewWithMessageAndActionHandler(_ title: String = Constants.alertStr, message: String, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { _ in
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertViewWithSuccessMessageAndActionHandler(_ title: String = "Success", message: String, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { _ in
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertViewWithMessageAndTwoActionHandler(_ title: String, _ leftTitle: String = "No", _ rightTitle: String = "Yes", message: String, leftActionHandler: (() -> Void)?, rightActionHandler:(() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let leftAction = UIAlertAction(title: NSLocalizedString(leftTitle, comment: leftTitle), style: .default) { _ in
            if let _ = leftActionHandler {
                leftActionHandler!()
            }
        }
        let rightAction = UIAlertAction(title: NSLocalizedString(rightTitle, comment: rightTitle), style: .destructive) { _ in
            if let _ = rightActionHandler {
                rightActionHandler!()
            }
        }
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

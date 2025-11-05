//
//  Helper.swift
//  Zoetis -Feathers
//
//  Created by Rahul Shrivastava on 2/24/17.
//  Copyright © 2017 "". All rights reserved.
//

import Foundation
import MBProgressHUD
class Helper{
    static func postRequest() -> [String:String] {
        // do a post request and return post data
        return ["someData" : "someData"]
    }


     static func showAlertMessage(_ vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    }

    static func showGlobalProgressHUDWithTitle(_ vc: UIView,title: String) -> MBProgressHUD{

        let hud = MBProgressHUD.showAdded(to: vc, animated: true)
        hud.contentColor = UIColor.white
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.4)
        hud.bezelView.color = UIColor(red: 0, green: 0/255, blue: 0, alpha: 1)
        hud.label.text = title
        hud.label.numberOfLines = 0;
        hud.label.textColor = .black
        hud.label.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        return hud
    }
    static func showGlobalProgressHUDWithTitleWithoutHudBack(_ vc: UIView,title: String) -> MBProgressHUD{
        
        let hud = MBProgressHUD.showAdded(to: vc, animated: true)
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor(red: 0, green: 0/255, blue: 0, alpha: 1)
        hud.label.text = title
        hud.label.numberOfLines = 0;
        hud.label.textColor = .black
        hud.label.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        return hud
    }
    static func dismissGlobalHUD(_ vc: UIView) -> Void{

        MBProgressHUD.hide(for: vc, animated: true)
    }
    
    
}


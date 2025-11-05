//
//  HelpScreenVcTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 4/30/18.
//  Copyright © 2018 MP. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Reachability

class HelpScreenVcTurkey: UIViewController{
    
    // MARK: - VARIABLES
    let buttonbg1 = UIButton ()
    let buttonbg = UIButton ()
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var gifView: UIView!
    @IBOutlet weak var acceptButton1: UIButton!
    @IBOutlet weak var declineButton1: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let terms =  UserDefaults.standard.bool(forKey: "termsAcceptedTrue")
        if terms == true{
            acceptButton1.alpha = 1
            gifView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        }
        else{
            acceptButton1.alpha = 0
            gifView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        }
        let jeremyGif =  UIImage.gifImageWithName("turkey")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height)
        view.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - IBACTION
    @IBAction func slideBtnAction1(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("LeftMenuBtnNoti"), object: nil, userInfo: nil)
    }
    
    @IBAction func acceptButton1(_ sender: AnyObject) {
        debugPrint("accepted button pressed")
        UserDefaults.standard.set(false, forKey: "termsAcceptedTrue")
        self.dasBoradPush()
    }
    
   
    
    // MARK: - METHODS AND FUNCTIONS
    func dasBoradPush()  {
        UserDefaults.standard.set(false, forKey: "Terms")
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "DashViewControllerTurkey") as? DashViewControllerTurkey
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: false)
    }
    
    
}


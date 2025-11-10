//
//  BaseViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 24/10/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import CoreData
import SwiftyJSON

class BaseViewController: UIViewController , SlideMenuDelegate{
    
    let dropDown = DropDown()
    typealias CompletionHandler = (_ selectedVal:String) -> Void
    typealias CompletionHandlerWithIndex = (_ selectedVal:String, _ index:Int) -> Void
    
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
    func postRequest() -> [String: String] {
        // do a post request and return post data
        return ["someData": "someData"]
    }
    
    func showAlertMessage(_ vc: UIViewController, titleStr: String, messageStr: String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    func topviewConstraint(vwTop:UIView){
        vwTop.translatesAutoresizingMaskIntoConstraints = false;
        let dict:Dictionary = ["view":vwTop];
        let constraint = NSLayoutConstraint.constraints(withVisualFormat:"H:|-0-[view]-0-|" , options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views:dict )
        let vertical = NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[view]-0-|" , options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views:dict)
        NSLayoutConstraint.activate(constraint)
        NSLayoutConstraint.activate(vertical)
        
    }
    
    func showtoast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0) //UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 3
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastWithTimer(message : String, duration: TimeInterval ) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0) //UIFont(name: "Montserrat-Light", size: 14.0)
        toastLabel.text = message
        toastLabel.numberOfLines = 3
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    func updateLabelFrame(label:UILabel) {
        let maxSize = CGSize(width: 400, height: 80)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100), size: size)
    }
    
    //slide
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        switch(index) {
        case 0:
            self.navigationController?.popViewController(animated: true)
            break
        case 1:
            break
        default:
            break
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController  = UIStoryboard.init(name: Constants.Storyboard.peStoryboard, bundle: Bundle.main).instantiateViewController(withIdentifier: strIdentifier)
        let topViewController : UIViewController = self.navigationController!.topViewController!
        if topViewController != destViewController {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton() {
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        let defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "PEStoryboard", bundle:nil)
        let menuVC : MenuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 60, width: 158, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 60, width: 158, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    
    //MARKS: DROP DOWN VIEW
    func dropDownforDistrict(arrayData:[String], kWidth:CGFloat,kAnchor:UIView,yheight:CGFloat,completionHandler:@escaping CompletionHandler){
        var updateArray = [Any]();
        for obj in arrayData {
            var district = obj;
            district = (district.contains("(BO)")) ? district.replacingOccurrences(of: "(BO)", with: "") : district.replacingOccurrences(of: "(MOA)", with: "")
            updateArray.append(district)
        }
        dropDown.dataSource = updateArray as [AnyObject];
        dropDown.width = kWidth
        dropDown.anchorView = kAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y:yheight+20)
        self.dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDown.deselectRowAtIndexPath(index)
            completionHandler(item);
        }
    }
    
    func getDropListSelectedIDDistrict(dropSelected:String,fullObjArry:[Any],key:String)->Int{
        var index:Int = -1;
        
        var updateArray = [Any]()
        for objs in fullObjArry {
            let dictObj = objs as? [String:Any] ?? [String:Any]();
            var districts = dictObj["districtName"] as? String ?? ""
            districts = (((districts) as AnyObject).contains("(BO)")) ? districts.replacingOccurrences(of: "(BO)", with: "") : districts.replacingOccurrences(of: "(MOA)", with: "")
            updateArray.append(districts);
            
        }
        for obj in updateArray {
            index = index + 1;
            let val = obj as? String ?? "";
            if val == dropSelected {
                break;
            }
        }
        return index;
    }
    
    //MARKS: DROP DOWN VIEW
    func dropDownVIew(arrayData:[String], kWidth:CGFloat,kAnchor:UIView,yheight:CGFloat,completionHandler:@escaping CompletionHandler){
        dropDown.dataSource = arrayData as [AnyObject];
        dropDown.width = kWidth
        dropDown.anchorView = kAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y:yheight+20)
        self.dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDown.deselectRowAtIndexPath(index)
            completionHandler(item);
        }
    }
    
    func dropDownVIewNew(arrayData:[String], kWidth:CGFloat,kAnchor:UIView,yheight:CGFloat,completionHandler:@escaping CompletionHandlerWithIndex){
        dropDown.dataSource = arrayData as [AnyObject];
        dropDown.width = kWidth
        dropDown.anchorView = kAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y:yheight+1)
        self.dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDown.deselectRowAtIndexPath(index)
            completionHandler(item, index);
        }
    }
    func dropDownVIewNewNew(arrayData:[String], kWidth:CGFloat,kAnchor:UIView,yheight:CGFloat,completionHandler:@escaping CompletionHandlerWithIndex){
        dropDown.dataSource = arrayData as [AnyObject];
        dropDown.width = kWidth
        dropDown.anchorView = kAnchor
        dropDown.bottomOffset = CGPoint(x: 0, y:18)
        self.dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDown.deselectRowAtIndexPath(index)
            completionHandler(item, index);
        }
    }
    //Marks:  GET DROP LIST ARRAY
    func getDropArrayList(array:Array<Any>,key:String)->[String]{
        var dropArray = Array<String>();
        for obj in array {
            let dictObj = obj as? Dictionary<String,Any> ?? Dictionary<String,Any>();
            dropArray.append(dictObj[key] as? String ?? "");
        }
        return dropArray;
    }
    
    func convertDictToJson(dict : JSONDictionary, apiName:String? = "") -> (Data,String)? {        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!

             if apiName == "Extended" {
                print("Post Request Params of Extended.  : \(jsonDataString)")

            }
            return (jsonData,jsonDataString)
        } catch {
        }
        
        return nil
    }
    
    //MARKS: GET DROW DOWN OBJECT INDEX
    func getDropListSelectedID(dropSelected:String,fullObjArry:[Any],key:String)->Int{
        var index:Int = -1;
        for obj in fullObjArry {
            index = index + 1;
            let dictObj = obj as? Dictionary<String,Any> ?? Dictionary<String,Any>();
            let val = dictObj[key] as? String ?? "";
            if val == dropSelected {
                break;
            }
        }
        return index;
    }
    
    //Marks:  GET DROP LIST ARRAY
    func getIntDropArrayList(array:Array<Any>,key:String)->[Int]{
        var dropArray = Array<Int>();
        for obj in array {
            let dictObj = obj as? Dictionary<String,Any> ?? Dictionary<String,Any>();
            dropArray.append(dictObj[key] as? Int ?? 0);
        }
        return dropArray;
    }
    
    //MARKS: GET DROW DOWN OBJECT INDEX
    func getIntDropListSelectedID(dropSelected:Int,fullObjArry:[Any],key:String)->Int{
        var index:Int = -1;
        for obj in fullObjArry {
            index = index + 1;
            let dictObj = obj as? Dictionary<String,Any> ?? Dictionary<String,Any>();
            let val = dictObj[key] as? Int ?? 0;
            if val == dropSelected {
                break;
            }
        }
        return index;
    }
    
    func shadowButton(btn:UIButton){
        btn.layer.cornerRadius = 6.0
        btn.layer.masksToBounds = false
        //  btn.layer.shadowColor = UIColor.getUIColorWithRGB(126, g: 20, b: 0).cgColor;
        btn.layer.shadowOffset = CGSize(width: 0,height: 5.0)
        btn.layer.shadowRadius = 0.0
        btn.layer.shadowOpacity = 1.0
        btn.layer.shouldRasterize = true
    }
    
    func deleteAllData(_ entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch let error as NSError {
            //   print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func deleteAllDataWithUserID(_ entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let userID =  UserDefaults.standard.value(forKey:"Id") as? Int ?? 0
        fetchRequest.predicate = NSPredicate(format: "userID == %d", userID)
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
        } catch let error as NSError {
            //   print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    
    func saveJSON(json: JSON, key:String){
        if let jsonString = json.rawString() {
            UserDefaults.standard.setValue(jsonString, forKey: key)
        }
    }
    
    func getJSON(_ key: String)-> JSON? {
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key) {
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}

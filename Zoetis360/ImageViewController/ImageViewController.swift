//
//  ImageViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 29/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit
import Reachability


class ImageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    /**********************************************/
    
    // MARK: - VARIABLES
    var bgButton = UIButton()
    var imgView = UIView()
    var showImage = UIImageView()
    var necId = Int()
    var farmname = String()
    var postingIdFromExistingNavigate = String()
    var existingArray = NSMutableArray()
    var imageDict = NSMutableDictionary()
    var  labelTitlte = UILabel()
    var lngId = NSInteger()
    
    // MARK: - OUTLET
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageTableView: UITableView!
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        userNameLabel.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        if postingIdFromExistingNavigate == "Exting" {
            existingArray  = CoreDataHandler().fecthPhotoWithFormName(farmname,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
        }
        else{
            let necroId = self.imageDict.value(forKey: "necId") as! Int
            existingArray  = CoreDataHandler().fecthPhotoWithCatnameWithBirdAndObservationID((self.imageDict.value(forKey: "birdNo") as! Int) as NSNumber, farmname: self.imageDict.value(forKey: "formName") as! String, catName: self.imageDict.value(forKey: "catName") as! String, Obsid: (self.imageDict.value(forKey: "obsid") as! Int) as NSNumber, obsName:  self.imageDict.value(forKey: "obsName") as! String,necId: necroId as NSNumber) .mutableCopy() as! NSMutableArray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lngId = UserDefaults.standard.integer(forKey: "lngId")
        
    }
    
    // MARK: - 🟢  TABLE VIEW DATA SOURCE AND DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:imageTableViewCell = self.imageTableView.dequeueReusableCell(withIdentifier: "cell") as! imageTableViewCell
        let posting :BirdPhotoCapture  = existingArray.object(at: indexPath.row) as! BirdPhotoCapture
        let frNme1 = posting.farmName
        
        let range = frNme1?.range(of: ".")
        if range != nil{
            cell.farmNamelabel.text = String((frNme1?[range!.upperBound...])!) as NSString as String
        }
        cell.observationLabel.text  = posting.obsName
        
        
        if posting.catName == "skeltaMuscular"{
            cell.cateNamelabel.text = NSLocalizedString("Skeletal/Muscular/Integumentary", comment: "")
        }
        else if  posting.catName == "Coccidiosis"{
            cell.cateNamelabel.text = NSLocalizedString("Coccidiosis", comment: "")
        }
        
        else if posting.catName == "GITract"{
            cell.cateNamelabel.text = NSLocalizedString("GI Tract", comment: "")
            
        }
        else if posting.catName == "Resp"{
            cell.cateNamelabel.text = NSLocalizedString("Respiratory", comment: "")
            
        }
        else if posting.catName == "Immune"{
            cell.cateNamelabel.text = NSLocalizedString("Immune/Others", comment: "")
            
        }
        cell.birdNumberLabl.text  = String(posting.birdNum as! Int)
        let image : UIImage = UIImage(data: posting.photo! as Data)!
        cell.cameraImageView.image = image
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let posting :BirdPhotoCapture  = existingArray.object(at: indexPath.row) as! BirdPhotoCapture
        let image : UIImage = UIImage(data: posting.photo! as Data)!
        let stringObs = posting.obsName
        popImage(image,lblObs: stringObs!)
    }
    
    // MARK: - 🟢  METHODS AND FUNCTIONS
    
    func popImage (_ image: UIImage,lblObs: String)  {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imgView.isHidden = false
            self.imgView.alpha = 1.0
        }, completion: nil)
        
        bgButton.alpha = 1
        bgButton.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        bgButton.addTarget(self, action: #selector(ImageViewController.buttonPressed11), for: .touchUpInside)
        bgButton.backgroundColor = UIColor(red: 45/255, green:45/255, blue:45/255, alpha:0.3)
        self.view .addSubview(bgButton)
        
        imgView.frame = CGRect(x: 100, y: 100, width: self.view.frame.size.width - 200, height: self.view.frame.size.height - 200)
        imgView.layer.borderWidth = 1
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = UIColor.white
        imgView.layer.borderColor = UIColor.clear.cgColor
        
        bgButton .addSubview(imgView)
        labelTitlte = UILabel(frame: CGRect(x: 0, y: 10, width: imgView.frame.size.width, height: 30))
        labelTitlte.textAlignment = NSTextAlignment.center
        labelTitlte.text = lblObs
        imgView.addSubview(labelTitlte)
        
        self.showImage.frame = CGRect(x: 0, y: 50, width: self.imgView.frame.size.width, height: self.imgView.frame.size.height - 60)
        
        self.showImage.image = image
        self.imgView .addSubview(self.showImage)
        
    }
    // MARK: - 🟠 IBACTIONS
    @objc func buttonPressed11()  {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imgView.alpha = 0.0
            self.bgButton.alpha = 0
            self.labelTitlte.text = ""
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - 🟠 Back Button Action.
    @IBAction func backBtn(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}


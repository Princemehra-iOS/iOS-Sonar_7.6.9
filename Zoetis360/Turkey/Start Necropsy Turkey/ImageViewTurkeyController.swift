//
//  ImageViewTurkeyController.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 28/03/18.
//  Copyright © 2018 . All rights reserved.
//
import UIKit

class ImageViewTurkeyController: UIViewController {
    
    
    // MARK: - VARIABLES
    var bgButton = UIButton()
    var imgView = UIView()
    var showImage = UIImageView()
    let buttonbg1 = UIButton ()
    let buttonbg = UIButton ()
    var necId = Int()
    var farmname = String()
    var postingIdFromExistingNavigate = String()
    var existingArray = NSMutableArray()
    var imageDict = NSMutableDictionary()
    var  labelTitlte = UILabel()
    
    // MARK: - OUTLET
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        userNameLbl.text! = UserDefaults.standard.value(forKey: "FirstName") as! String
        if postingIdFromExistingNavigate == "Exting" {
            existingArray  = CoreDataHandlerTurkey().fecthPhotoWithFormNameTurkey(farmname,necId:necId as NSNumber).mutableCopy() as! NSMutableArray
            print(existingArray)
        }
        else{
            let existingNecId = self.imageDict.value(forKey: "necId") as! Int
            existingArray  = CoreDataHandlerTurkey().fecthPhotoWithCatnameWithBirdAndObservationIDTurkey((self.imageDict.value(forKey: "birdNo") as! Int) as NSNumber, farmname: self.imageDict.value(forKey: "formName") as! String, catName: self.imageDict.value(forKey: "catName") as! String, Obsid: (self.imageDict.value(forKey: "obsid") as! Int) as NSNumber, obsName:  self.imageDict.value(forKey: "obsName") as! String,necId: existingNecId as NSNumber) .mutableCopy() as! NSMutableArray
        }
    }
    
    @IBAction func bckBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func popImage (_ image: UIImage,lblObs: String)  {
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imgView.isHidden = false
            self.imgView.alpha = 1.0
        }, completion: nil)
        
        bgButton.alpha = 1
        bgButton.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        bgButton.addTarget(self, action: #selector(ImageViewTurkeyController.buttonPressed11), for: .touchUpInside)
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
    @objc func buttonPressed11()  {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.imgView.alpha = 0.0
            self.bgButton.alpha = 0
            self.labelTitlte.text = ""
        }, completion: nil)
    }
    
    func allSessionArr() ->NSMutableArray{
        
        let postingArrWithAllData = CoreDataHandlerTurkey().fetchAllPostingSessionWithisSyncisTrueTurkey(true).mutableCopy() as! NSMutableArray
        let cNecArr = CoreDataHandlerTurkey().FetchNecropsystep1WithisSyncTurkey(true)
        let necArrWithoutPosting = NSMutableArray()
        
        for j in 0..<cNecArr.count
        {
            let captureNecropsyData = cNecArr.object(at: j)  as! CaptureNecropsyDataTurkey
            necArrWithoutPosting.add(captureNecropsyData)
            for w in 0..<necArrWithoutPosting.count - 1
            {
                let c = necArrWithoutPosting.object(at: w)  as! CaptureNecropsyDataTurkey
                if c.necropsyId == captureNecropsyData.necropsyId
                {
                    necArrWithoutPosting.remove(c)
                }
            }
        }
        
        let allPostingSessionArr = NSMutableArray()
        
        for i in 0..<postingArrWithAllData.count
        {
            let pSession = postingArrWithAllData.object(at: i) as! PostingSessionTurkey
            var sessionId = pSession.postingId!
            allPostingSessionArr.add(sessionId)
        }
        
        for i in 0..<necArrWithoutPosting.count
        {
            let nIdSession = necArrWithoutPosting.object(at: i) as! CaptureNecropsyDataTurkey
            var sessionId = nIdSession.necropsyId!
            allPostingSessionArr.add(sessionId)
        }
        
        return allPostingSessionArr
    }
    
}
extension ImageViewTurkeyController :UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ImageTableViewCellTurkey = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ImageTableViewCellTurkey
        
        let posting :BirdPhotoCaptureTurkey  = existingArray.object(at: indexPath.row) as! BirdPhotoCaptureTurkey
        //cell.farmNamelabel.text  = posting.farmName
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
            cell.cateNamelabel.text = NSLocalizedString("Microscopy", comment: "")
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
        
        let posting :BirdPhotoCaptureTurkey  = existingArray.object(at: indexPath.row) as! BirdPhotoCaptureTurkey
        let image : UIImage = UIImage(data: posting.photo! as Data)!
        let stringObs = posting.obsName
        popImage(image,lblObs: stringObs!)
    }
    
}

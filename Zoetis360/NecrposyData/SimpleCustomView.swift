//
//  SimpleCustomView.swift
//  CustomXIBSwift
//
//  Created by Karthik Prabhu Alagu on 06/08/15.
//  Copyright © 2015 KPALAGU. All rights reserved.
//
import UIKit

protocol infoLinkk: class {
    func cancelBtnAction (_ btnTag: Int, data:CaptureNecropsyViewData)
}
@IBDesignable class SimpleCustomView:UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - VARIBALES
    var view:UIView!
    var birdImages = [String]()
    var obsNmae = String()
    var finailValue = Int()
    var btnIndex = Int()
    var necId = Int()
    var obsDescArr = NSMutableArray()
    var infoImages = NSMutableArray()
    var obsData : CaptureNecropsyViewData!
    var infoLinkkDelegate :infoLinkk?
    var finalizeValue :Int!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBInspectable var lblTitleText : String?
    {
        get{
            return lblTitle.text;
        }
        set(lblTitleText) {
            lblTitle.text = lblTitleText!;
        }
    }
    // MARK: - METHOD & FUNCTIONS
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SimpleCustomView", bundle: bundle)
        let sampleView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        sampleView.frame = bounds
        sampleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(sampleView)
        
        self.infoCollectionView.delegate = self
        self.infoCollectionView.dataSource = self
        let nibName = UINib(nibName: "infocollection", bundle:nil)
        infoCollectionView.register(nibName, forCellWithReuseIdentifier: "infocollection")
    }
    // MARK: 🟠 - Close button action
    @IBAction func closeBttn(_ sender: AnyObject) {
        self.infoLinkkDelegate!.cancelBtnAction(btnIndex, data: obsData)
    }
    
    // MARK: 🟠 - COLLECTION VIEW DATA SOURCE AND DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.infoImages.count
    }
    
    fileprivate func stageSetupForIndexLabelTxt(_ indexPath: IndexPath, _ cell: infocollection) {
        if [1955, 1958, 1956, 1952 , 1960].contains(obsData.obsID) {
            if indexPath.row == 0{
                cell.indexLbl.text = "1"
            }
            else if indexPath.row == 1{
                cell.indexLbl.text = "0"
            }
        }
    }
    
    fileprivate func devSetupForIndexLabelTxt(_ indexPath: IndexPath, _ cell: infocollection) {
        if [1870, 1874, 1875, 1873 , 1878].contains(obsData.obsID) {
            if indexPath.row == 0{
                cell.indexLbl.text = "1"
            }
            else if indexPath.row == 1{
                cell.indexLbl.text = "0"
            }
        }
    }
    
    fileprivate func productionSetupForIndexLabelTxt(_ indexPath: IndexPath, _ cell: infocollection) {
        if [2033, 2035, 2030, 2034].contains(obsData.obsID) {
            if indexPath.row == 0{
                cell.indexLbl.text = "1"
            }
            else if indexPath.row == 1{
                cell.indexLbl.text = "0"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "infocollection", for: indexPath) as! infocollection
        let image = infoImages[indexPath.row] as! UIImage
        cell.infoImageView.image = image
        lblHeader.text = obsNmae
        cell.indexLbl.layer.cornerRadius = cell.indexLbl.frame.size.width / 2
        cell.indexLbl.clipsToBounds = true
        if obsNmae == "Bursa Size" || obsNmae == "Taille Bourses de Fabricius" {
            if indexPath.row == 0{
                cell.indexLbl.text = "1"
            }
            else if indexPath.row == 1{
                cell.indexLbl.text = "4"
            }
            else if indexPath.row == 2{
                cell.indexLbl.text = "8"
            }
        }
        else{
            cell.indexLbl.text = String(indexPath.row)
        }
        
        let environmentIs = Constants.Api.versionUrl
        if environmentIs.contains("stageapi") {
            stageSetupForIndexLabelTxt(indexPath, cell)
        }
        else if environmentIs.contains("devapi") {
            devSetupForIndexLabelTxt(indexPath, cell)
        }
        else
        {
            productionSetupForIndexLabelTxt(indexPath, cell)
        }
        cell.obsDesc.setContentOffset(CGPoint.zero, animated: false)
        cell.obsDesc.scrollRangeToVisible(NSMakeRange(0, 0))
        cell.obsDesc.text = obsDescArr[indexPath.row] as! String
        cell.obsDesc.layoutIfNeeded()
        cell.obsDesc.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
        let cellSize:CGSize = CGSize(width: 252, height: 380)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        finailValue =  UserDefaults.standard.value(forKey: "finalizeValue") as! Int
        
        if finailValue == 1{
            return
        } else {
            if obsData.measure ==  "Y,N" {
                
                if indexPath.item == 0 {
                    CoreDataHandler().updateCaptureSkeletaInDatabaseOnSwitchMethod(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, switchValue: false ,necId: necId as NSNumber)
                }
                else {
                    CoreDataHandler().updateCaptureSkeletaInDatabaseOnSwitchMethod(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, switchValue: true, necId: necId as NSNumber)
                }
                self.infoLinkkDelegate!.cancelBtnAction(btnIndex, data: obsData)
            }
             else {
                if  obsData.refId == 58{
                    
                    if indexPath.row == 0 {
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        CoreDataHandler().updateCaptureSkeletaInDatabaseOnStepper(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[0])!, necId: necId as NSNumber)
                    }
                    else if indexPath.row == 1 {
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        CoreDataHandler().updateCaptureSkeletaInDatabaseOnStepper(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[3])!, necId: necId as NSNumber)
                    }
                    else if indexPath.row == 2{
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        CoreDataHandler().updateCaptureSkeletaInDatabaseOnStepper(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[7])!, necId: necId as NSNumber)
                    }
                }
                else {
                    let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    CoreDataHandler().updateCaptureSkeletaInDatabaseOnStepper(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[indexPath.row])!, necId: necId as NSNumber)
                }
                self.infoLinkkDelegate!.cancelBtnAction(btnIndex, data: obsData)
            }
        }
    }
}


//
//  SimpleCustomViewTurkey.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 06/04/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit

protocol infoLinkkTurkey: class {
    func cancelBtnActionTurkey (_ btnTag: Int, data:CaptureNecropsyViewDataTurkey)
}

@IBDesignable class SimpleCustomViewTurkey:UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - VARIABLES
    var view:UIView!
    var birdImages = [String]()
    var obsNmae = String()
    var finailValue = Int()
    var btnIndex = Int()
    var necId = Int()
    var obsDescArr = NSMutableArray()
    var infoImages = NSMutableArray()
    var obsData : CaptureNecropsyViewDataTurkey!
    var items = ["1", "2","3","4"]
    var infoLinkkDelegateT :infoLinkkTurkey?
    var finalizeValue :Int!
    
    // MARK: - OUTLETS
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBInspectable var lblTitleText : String?
    {
        get{
            return lblTitle.text;
        }
        set(lblTitleText)
        {
            lblTitle.text = lblTitleText!;
        }
    }
    
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
        let nib = UINib(nibName: "SimpleCustomViewTurkey", bundle: bundle)
        let simpleCustomeview = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        simpleCustomeview.frame = bounds
        simpleCustomeview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(simpleCustomeview)
        
        self.infoCollectionView.delegate = self
        self.infoCollectionView.dataSource = self
        
        let nibName = UINib(nibName: "TurkeyInfoCollectionViewCell", bundle:nil)
        infoCollectionView.register(nibName, forCellWithReuseIdentifier: "TurkeyInfoCollectionViewCell")
    }
    
    @IBAction func closeBttn(_ sender: AnyObject) {
        
        self.infoLinkkDelegateT!.cancelBtnActionTurkey(btnIndex, data: obsData)
    }
    
    // MARK: - COLLECTION VIEW DATA SOURCE AND DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.infoImages.count
    }
    
    fileprivate func setIndexLblText(_ indexPath: IndexPath, _ cell: TurkeyInfoCollectionViewCell) {
        if indexPath.row == 0{
            cell.indexLbl.text = "1"
        }
        else if indexPath.row == 1{
            cell.indexLbl.text = "0"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "TurkeyInfoCollectionViewCell", for: indexPath) as! TurkeyInfoCollectionViewCell
        let image = infoImages[indexPath.row] as! UIImage
        if obsData.obsID == 1960 && indexPath.row == 0 {
            cell.birdImgView.image = image
        } else {
            cell.infoImageView.image = image
        }
        lblHeader.text = obsNmae
        cell.indexLbl.layer.cornerRadius = cell.indexLbl.frame.size.width / 2
        cell.indexLbl.clipsToBounds = true
        
        cell.indexLbl.text = String(indexPath.row)
        cell.obsDesc.text = obsDescArr[indexPath.row] as! String
        cell.obsDesc.layoutIfNeeded()
        cell.obsDesc.contentMode = .scaleAspectFit
        
        let environmentIs = Constants.Api.versionUrl
        
        if environmentIs.contains("stageapi") {
            if [1955, 1958, 1956, 1952 , 1960].contains(obsData.obsID) {
                setIndexLblText(indexPath, cell)
            }
        }
        else if environmentIs.contains("devapi") {
            if [1870, 1874, 1876, 1873 , 1878 ].contains(obsData.obsID) {
                setIndexLblText(indexPath, cell)
               // 1876
            }
            
        }
        else
        {
            if [1955, 2036, 1956, 1952 , 2037].contains(obsData.obsID) {
                setIndexLblText(indexPath, cell)
            }
        }
    
        
        return cell
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {
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
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwitchMethodTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, switchValue: false ,necId: necId as NSNumber)
                }
                else{
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnSwitchMethodTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, switchValue: true, necId: necId as NSNumber)
                }
                
                self.infoLinkkDelegateT!.cancelBtnActionTurkey(btnIndex, data: obsData)
                
            }
             else {
                if  obsData.refId == 58{
                    
                    if indexPath.row == 0 {
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnStepperTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[0])!, necId: necId as NSNumber)
                        
                    }
                    else if indexPath.row == 1 {
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnStepperTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[3])!, necId: necId as NSNumber)
                        
                    }
                    else if indexPath.row == 2{
                        let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        let array = (trimmed.components(separatedBy: ",") as [String])
                        
                        CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnStepperTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[7])!, necId: necId as NSNumber)
                    }
                } else {
                    let trimmed = obsData.measure!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let array = (trimmed.components(separatedBy: ",") as [String])
                    
                    CoreDataHandlerTurkey().updateCaptureSkeletaInDatabaseOnStepperTurkey(obsData.catName!, obsName: obsData.obsName!, formName: obsData.formName!, birdNo: obsData.birdNo!, obsId: obsData.obsID!, index :Int(array[indexPath.row])!, necId: necId as NSNumber)
                    
                }
                self.infoLinkkDelegateT!.cancelBtnActionTurkey(btnIndex, data: obsData)
            }
        }
    }
}

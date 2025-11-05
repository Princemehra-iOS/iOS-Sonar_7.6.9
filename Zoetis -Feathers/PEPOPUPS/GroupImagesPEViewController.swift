//
//  GroupImagesPEViewController.swift
//  Zoetis -Feathers
//
//  Created by "" ""on 06/03/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit

class GroupImagesPEViewController: BaseViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var bigBackImage: UIImageView!
    @IBOutlet weak var collectionSuperViewBackImage: UIImageView!
    @IBOutlet weak var collectionSuperView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - VARIABLES
    
    var imagesArray : [Int] = []
    var imagesDataArray : [Data] = []
    
    // MARK: - METHODS
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        for id in imagesArray{
            let data = CoreDataHandlerPE().getImageByImageID(idArray:id)
            imagesDataArray.append(data)
        }
        collectionView.reloadData()
        hideBigView()
    }
    
    func hideBigView(){
        bigImageView.isHidden = true
        bigView.isHidden = true
        bigBackImage.isHidden = true
        collectionSuperViewBackImage.isHidden = false
        collectionSuperView.isHidden = false
        collectionView.isHidden = false
    }
    
    func hideCollectionView(){
        collectionSuperViewBackImage.isHidden = true
        collectionSuperView.isHidden = true
        collectionView.isHidden = true
        bigImageView.isHidden = false
        bigView.isHidden = false
        bigBackImage.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 264, height: 195)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first!
        if (touch.view?.tag == 1111){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossClickedBigView(_ sender: Any) {
        hideBigView()
    }
    
}

// MARK: - EXTENSION FOR COLLECTION VIEW DATA SOURCE

extension GroupImagesPEViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionPE", for: indexPath) as? UICollectionViewCell
        if let optionView = cell?.contentView.viewWithTag(23) as? UIImageView {
            DispatchQueue.main.async() {
                optionView.image = UIImage(data: self.imagesDataArray[indexPath.row])
            }
        }
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - EXTENSION FOR COLLECTION VIEW DELEGATE

extension GroupImagesPEViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async() {
            self.bigImageView.image = UIImage(data: self.imagesDataArray[indexPath.row])
            self.hideCollectionView()
        }
    }
}

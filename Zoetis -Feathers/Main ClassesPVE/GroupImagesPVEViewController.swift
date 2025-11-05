//
//  GroupImagesPVEViewController.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 13/03/20.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import UIKit

class GroupImagesPVEViewController: BaseViewController {

    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var bigBackImage: UIImageView!
    @IBOutlet weak var collectionSuperViewBackImage: UIImageView!
    @IBOutlet weak var collectionSuperView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imagesArray : [Int] = []
    var imagesDataArray : [Data] = []
    
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
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
        if (touch.view?.tag == 1111) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossClickedBigView(_ sender: Any) {
        hideBigView()
    }
}


extension GroupImagesPVEViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionPVE", for: indexPath) as! UICollectionViewCell
        if let optionView = cell.contentView.viewWithTag(23) as? UIImageView {
        DispatchQueue.main.async() {
            optionView.image = UIImage(data: self.imagesDataArray[indexPath.row])
               }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
           let cellSize: CGSize = CGSize(width: 264, height: 195)
           return cellSize
       }
}

extension GroupImagesPVEViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
        DispatchQueue.main.async() {
            self.bigImageView.image = UIImage(data: self.imagesDataArray[indexPath.row])
            self.hideCollectionView()
        }
    }
}

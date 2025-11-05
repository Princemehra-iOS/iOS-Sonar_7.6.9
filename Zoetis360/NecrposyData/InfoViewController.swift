//
//  InfoViewController.swift
//  Zoetis -Feathers
//
//  Created by "" on 12/2/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - VARIABLES
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        print("<<<<",self)
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 🟠 - COLLECTION VIEW DATA SOURCE AND DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CaptureNecropsyCollectionViewCell
        let image = UIImage(named: "Image02")
        cell.infoImage.image = image
        
        return cell
    }
    
}


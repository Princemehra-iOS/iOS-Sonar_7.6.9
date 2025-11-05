//
//  allBirdsTableViewCell.swift
//  Zoetis -Feathers
//
//  Created by "" on 18/11/16.
//  Copyright © 2016 "". All rights reserved.
//

import UIKit

class allBirdsTableViewCell: UITableViewCell{

    
    @IBOutlet weak var obsCollectonView: UICollectionView!
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        obsCollectonView.delegate = dataSourceDelegate
        obsCollectonView.dataSource = dataSourceDelegate
        obsCollectonView.tag = row
        obsCollectonView.setContentOffset(obsCollectonView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        obsCollectonView.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { obsCollectonView.contentOffset.x = newValue }
        get { return obsCollectonView.contentOffset.x }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

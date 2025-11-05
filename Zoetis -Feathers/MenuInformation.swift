//
//  MenuInformation.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 07/01/20.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

struct MenuInformation {
    
    let title: String
    let creator: String
    let image: UIImage?
    let selectedInd: String
    
    init(title: String, creator: String, image: UIImage?, SelIndx: String) {
        self.title = title
        self.creator = creator
        self.image = image
        self.selectedInd = SelIndx
    }
    
    static func allCats() -> [MenuInformation] {
        return [
            MenuInformation(title: "Dropdown example", creator: "Single silection", image: UIImage(named: "ID-100113060.jpg"), SelIndx: "0"),
            MenuInformation(title: "Multiple Selection Dropdown", creator: "Multiple selection", image: UIImage(named: "ID-10022760.jpg"), SelIndx: "1"),
            MenuInformation(title: "Google Place mark", creator: "Location info", image: UIImage(named: "ID-10091065.jpg"), SelIndx: "2"),
        ]
    }
    
    static func allDogs() -> [MenuInformation] {
        return [
            MenuInformation(title: "White Dog Portrait", creator: "photostock", image: UIImage(named: "ID-10034505.jpg"), SelIndx: "0"),
            MenuInformation(title: "Black Labrador Retriever", creator: "Michal Marcol", image: UIImage(named: "ID-1009881.jpg"), SelIndx: "1"),
            MenuInformation(title: "Anxious Dog", creator: appDelegateObj.nameJames, image: UIImage(named: "ID-100120.jpg"), SelIndx: "2"),
            MenuInformation(title: "Husky Dog", creator: appDelegateObj.nameJames, image: UIImage(named: "ID-100136.jpg"), SelIndx: "3"),
            MenuInformation(title: "Puppy", creator: appDelegateObj.nameJames, image: UIImage(named: "ID-100140.jpg"), SelIndx: "4"),
            MenuInformation(title: "Black Labrador Puppy", creator: appDelegateObj.nameJames, image: UIImage(named: "ID-10018395.jpg"), SelIndx: "5"),
        ]
    }
}

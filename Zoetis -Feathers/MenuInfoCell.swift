//
//  MenuInfoCell.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 07/01/20.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class MenuInfoCell: UITableViewCell {
  
  @IBOutlet weak var animalImageView: UIImageView!
  @IBOutlet weak var imageNameLabel: UILabel!
  @IBOutlet weak var imageCreatorLabel: UILabel!
  @IBOutlet weak var bottomLineLbl: UILabel!

  func configureForAnimal(_ animal: MenuInformation) {
    animalImageView.image = animal.image
    imageNameLabel.text = animal.title
  }
}

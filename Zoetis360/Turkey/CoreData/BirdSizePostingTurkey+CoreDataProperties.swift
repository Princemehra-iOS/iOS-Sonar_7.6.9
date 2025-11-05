//
//  BirdSizePostingTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension BirdSizePostingTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BirdSizePostingTurkey> {
        return NSFetchRequest<BirdSizePostingTurkey>(entityName: "BirdSizePostingTurkey")
    }

    @NSManaged public var birdSizeId: NSNumber?
    @NSManaged public var birdSize: String?
    @NSManaged public var scaleType: String?

}

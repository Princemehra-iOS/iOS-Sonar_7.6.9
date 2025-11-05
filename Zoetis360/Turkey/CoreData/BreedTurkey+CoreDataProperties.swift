//
//  BreedTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension BreedTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreedTurkey> {
        return NSFetchRequest<BreedTurkey>(entityName: "BreedTurkey")
    }

    @NSManaged public var breedId: NSNumber?
    @NSManaged public var breedName: String?
    @NSManaged public var breedType: String?

}

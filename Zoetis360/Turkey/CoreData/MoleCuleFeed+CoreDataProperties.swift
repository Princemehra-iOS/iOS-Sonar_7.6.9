//
//  MoleCuleFeed+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by  on 11/17/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension MoleCuleFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoleCuleFeed> {
        return NSFetchRequest<MoleCuleFeed>(entityName: "MoleCuleFeed")
    }

    @NSManaged public var moleculeId: NSNumber?
    @NSManaged public var catId: NSNumber?
    @NSManaged public var desc: String?
    @NSManaged public var lngId: NSNumber?

}

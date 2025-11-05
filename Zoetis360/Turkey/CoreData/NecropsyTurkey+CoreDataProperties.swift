//
//  NecropsyTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension NecropsyTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NecropsyTurkey> {
        return NSFetchRequest<NecropsyTurkey>(entityName: "NecropsyTurkey")
    }

    @NSManaged public var switchcheck: NSNumber?
    @NSManaged public var name: String?

}

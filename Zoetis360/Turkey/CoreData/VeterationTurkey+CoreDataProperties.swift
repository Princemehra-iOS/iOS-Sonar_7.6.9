//
//  VeterationTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension VeterationTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VeterationTurkey> {
        return NSFetchRequest<VeterationTurkey>(entityName: "VeterationTurkey")
    }

    @NSManaged public var vtName: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var vetarId: NSNumber?

}

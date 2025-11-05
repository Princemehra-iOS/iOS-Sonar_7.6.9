//
//  IdTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension IdTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IdTurkey> {
        return NSFetchRequest<IdTurkey>(entityName: "IdTurkey")
    }

    @NSManaged public var autoId: NSNumber?

}

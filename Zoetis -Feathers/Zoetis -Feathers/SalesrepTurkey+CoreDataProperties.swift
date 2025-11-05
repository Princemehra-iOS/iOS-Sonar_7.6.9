//
//  SalesrepTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension SalesrepTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SalesrepTurkey> {
        return NSFetchRequest<SalesrepTurkey>(entityName: "SalesrepTurkey")
    }

    @NSManaged public var salesRepName: String?
    @NSManaged public var salesReptId: NSNumber?

}

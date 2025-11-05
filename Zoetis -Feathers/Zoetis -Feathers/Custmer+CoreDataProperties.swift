//
//  Custmer+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by "" on 2/7/17.
//  Copyright © 2017 "". All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Custmer {

    @NSManaged var complexId: NSNumber?
    @NSManaged var custId: NSNumber?
    @NSManaged var custName: String?
    @NSManaged var loginSessionId: NSNumber?
    @NSManaged var postingId: NSNumber?

}

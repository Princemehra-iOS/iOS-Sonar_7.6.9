//
//  Login+CoreDataProperties.swift
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

extension Login {

    @NSManaged var loginId: NSNumber?
    @NSManaged var signal: String?
    @NSManaged var status: NSNumber?
    @NSManaged var userId: NSNumber?
    @NSManaged var username: String?
    @NSManaged var userTypeId: NSNumber?

}

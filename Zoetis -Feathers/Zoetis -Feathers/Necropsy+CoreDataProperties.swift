//
//  Necropsy+CoreDataProperties.swift
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

extension Necropsy {

    @NSManaged var name: String?
    @NSManaged var switchcheck: NSNumber?
    @NSManaged var camraimage: NSSet?
    @NSManaged var coccidiosis: NSSet?
    @NSManaged var gitract: NSSet?
    @NSManaged var immune: NSSet?
    @NSManaged var respiratory: NSSet?
    @NSManaged var skeleta: NSSet?

}

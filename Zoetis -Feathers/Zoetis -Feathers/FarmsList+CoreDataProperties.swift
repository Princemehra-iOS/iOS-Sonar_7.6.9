//
//  FarmsList+CoreDataProperties.swift
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

extension FarmsList {

    @NSManaged var city: String?
    @NSManaged var countryId: NSNumber?
    @NSManaged var countryName: String?
    @NSManaged var farmId: NSNumber?
    @NSManaged var farmName: String?
    @NSManaged var stateId: NSNumber?
    @NSManaged var stateName: String?

}

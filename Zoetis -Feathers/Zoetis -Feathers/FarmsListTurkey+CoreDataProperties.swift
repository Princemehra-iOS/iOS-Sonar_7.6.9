//
//  FarmsListTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension FarmsListTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FarmsListTurkey> {
        return NSFetchRequest<FarmsListTurkey>(entityName: "FarmsListTurkey")
    }

    @NSManaged public var countryId: NSNumber?
    @NSManaged public var farmId: NSNumber?
    @NSManaged public var stateId: NSNumber?
    @NSManaged public var city: String?
    @NSManaged public var countryName: String?
    @NSManaged public var farmName: String?
    @NSManaged public var stateName: String?

}

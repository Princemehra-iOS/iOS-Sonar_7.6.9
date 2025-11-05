//
//  AntiboticFeedTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension AntiboticFeedTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AntiboticFeedTurkey> {
        return NSFetchRequest<AntiboticFeedTurkey>(entityName: "AntiboticFeedTurkey")
    }

    @NSManaged public var coccidiosisVaccineId: NSNumber?
    @NSManaged public var dosage: String?
    @NSManaged public var feedId: NSNumber?
    @NSManaged public var feedProgram: String?
    @NSManaged public var feedType: String?
    @NSManaged public var formName: String?
    @NSManaged public var fromDays: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var molecule: String?
    @NSManaged public var moleculeId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var toDays: String?

}

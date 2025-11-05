//
//  MyCotoxinBindersFeed+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 12/29/17.
//  Copyright © 2017   . All rights reserved.
//
//

import Foundation
import CoreData

extension MyCotoxinBindersFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCotoxinBindersFeed> {
        return NSFetchRequest<MyCotoxinBindersFeed>(entityName: "MyCotoxinBindersFeed")
    }

    @NSManaged public var coccidiosisVaccineId: NSNumber?
    @NSManaged public var dosage: String?
    @NSManaged public var feedId: NSNumber?
    @NSManaged public var feedProgram: String?
    @NSManaged public var feedType: String?
    @NSManaged public var formName: String?
    @NSManaged public var fromDays: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var molecule: String?
    @NSManaged public var moleculeId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var toDays: String?
    @NSManaged public var lngId: NSNumber?

}

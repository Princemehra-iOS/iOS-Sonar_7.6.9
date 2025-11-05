//
//  RespiratoryTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension RespiratoryTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RespiratoryTurkey> {
        return NSFetchRequest<RespiratoryTurkey>(entityName: "RespiratoryTurkey")
    }

    @NSManaged public var observationId: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var refId: NSNumber?
    @NSManaged public var information: String?
    @NSManaged public var measure: String?
    @NSManaged public var observationField: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var quicklinks: NSNumber?
    @NSManaged public var visibilityCheck: NSNumber?

}

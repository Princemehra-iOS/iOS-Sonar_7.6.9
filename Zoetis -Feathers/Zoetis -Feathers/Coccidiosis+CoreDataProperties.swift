//
//  Coccidiosis+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 1/22/18.
//  Copyright © 2018   . All rights reserved.
//
//

import Foundation
import CoreData

extension Coccidiosis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coccidiosis> {
        return NSFetchRequest<Coccidiosis>(entityName: "Coccidiosis")
    }

    @NSManaged public var information: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var measure: String?
    @NSManaged public var observationField: String?
    @NSManaged public var observationId: NSNumber?
    @NSManaged public var quicklinks: NSNumber?
    @NSManaged public var visibilityCheck: NSNumber?
    @NSManaged public var refId: NSNumber?
    @NSManaged public var necropsy: NSSet?

}

// MARK: Generated accessors for necropsy

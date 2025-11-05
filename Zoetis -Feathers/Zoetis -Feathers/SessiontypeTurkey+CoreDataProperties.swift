//
//  SessiontypeTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/21/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension SessiontypeTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessiontypeTurkey> {
        return NSFetchRequest<SessiontypeTurkey>(entityName: "SessiontypeTurkey")
    }

    @NSManaged public var sesionId: NSNumber?
    @NSManaged public var sesionType: String?
    @NSManaged public var lngId: NSNumber?

}

//
//  Complex_PVE+CoreDataProperties.swift
//  
//
//  Created by NITIN KUMAR KANOJIA on 29/12/19.
//
//

import Foundation
import CoreData


extension Complex_PVE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Complex_PVE> {
        return NSFetchRequest<Complex_PVE>(entityName: "Complex_PVE")
    }

    @NSManaged public var complexId: NSNumber?
    @NSManaged public var complexName: String?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var userId: NSNumber?

}

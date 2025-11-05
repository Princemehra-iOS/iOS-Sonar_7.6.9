//
//  PVE_AssignUserDetails+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_AssignUserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_AssignUserDetails> {
        return NSFetchRequest<PVE_AssignUserDetails>(entityName: "PVE_AssignUserDetails")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var lastName: String?

}

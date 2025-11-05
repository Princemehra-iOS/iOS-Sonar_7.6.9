//
//  PVE_LoginRespone+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 18/01/20.
//
//

import Foundation
import CoreData


extension PVE_LoginRespone {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_LoginRespone> {
        return NSFetchRequest<PVE_LoginRespone>(entityName: "PVE_LoginRespone")
    }

    @NSManaged public var token_type: String?
    @NSManaged public var access_token: String?
    @NSManaged public var userTypeId: NSNumber?
    @NSManaged public var roleId: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var firstName: String?
    @NSManaged public var countryId: NSNumber?
    @NSManaged public var complexTypeId: NSNumber?
    @NSManaged public var birdTypeId: NSNumber?

}

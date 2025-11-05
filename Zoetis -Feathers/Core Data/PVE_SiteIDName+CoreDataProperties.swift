//
//  PVE_SiteIDName+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_SiteIDName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SiteIDName> {
        return NSFetchRequest<PVE_SiteIDName>(entityName: "PVE_SiteIDName")
    }

    @NSManaged public var site_Name: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var site_Id: NSNumber?
    @NSManaged public var complex_Id: NSNumber?
    @NSManaged public var customer_Id: NSNumber?

}

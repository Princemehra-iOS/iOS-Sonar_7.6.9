//
//  PVE_UserInfo+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Nitin kumar Kanojia on 22/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_UserInfo> {
        return NSFetchRequest<PVE_UserInfo>(entityName: "PVE_UserInfo")
    }

    @NSManaged public var customer: String?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var session: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userId: NSNumber?

}

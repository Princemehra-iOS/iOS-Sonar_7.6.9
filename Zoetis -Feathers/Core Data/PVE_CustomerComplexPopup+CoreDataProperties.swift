//
//  PVE_CustomerComplexPopup+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 01/02/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_CustomerComplexPopup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_CustomerComplexPopup> {
        return NSFetchRequest<PVE_CustomerComplexPopup>(entityName: "PVE_CustomerComplexPopup")
    }

    @NSManaged public var customer: String?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var userId: NSNumber?

}

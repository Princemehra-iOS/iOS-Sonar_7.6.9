//
//  PVE_ImageEntity+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 14/05/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_ImageEntity> {
        return NSFetchRequest<PVE_ImageEntity>(entityName: "PVE_ImageEntity")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var imageData: Data?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var syncId: String?
    @NSManaged public var imgSyncId: String?
    @NSManaged public var type: String?

}

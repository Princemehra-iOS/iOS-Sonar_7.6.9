//
//  PVE_ImageEntitySync+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 17/06/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_ImageEntitySync {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_ImageEntitySync> {
        return NSFetchRequest<PVE_ImageEntitySync>(entityName: "PVE_ImageEntitySync")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var imageData: Data?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var syncId: String?
    @NSManaged public var imgSyncId: String?
    @NSManaged public var type: String?

}

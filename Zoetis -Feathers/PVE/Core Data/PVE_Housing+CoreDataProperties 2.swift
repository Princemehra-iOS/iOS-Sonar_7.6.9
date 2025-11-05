//
//  PVE_Housing+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_Housing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_Housing> {
        return NSFetchRequest<PVE_Housing>(entityName: "PVE_Housing")
    }

    @NSManaged public var housingId: NSNumber?
    @NSManaged public var housingName: String?

}

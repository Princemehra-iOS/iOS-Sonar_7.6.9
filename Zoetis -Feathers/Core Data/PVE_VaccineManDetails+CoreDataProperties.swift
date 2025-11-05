//
//  PVE_VaccineManDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_VaccineManDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_VaccineManDetails> {
        return NSFetchRequest<PVE_VaccineManDetails>(entityName: "PVE_VaccineManDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?

}

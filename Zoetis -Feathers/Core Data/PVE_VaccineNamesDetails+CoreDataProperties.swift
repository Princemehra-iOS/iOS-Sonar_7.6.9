//
//  PVE_VaccineNamesDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_VaccineNamesDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_VaccineNamesDetails> {
        return NSFetchRequest<PVE_VaccineNamesDetails>(entityName: "PVE_VaccineNamesDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var mfg_Id: NSNumber?

}

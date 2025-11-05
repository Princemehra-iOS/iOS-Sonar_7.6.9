//
//  PVE_SerotypeDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_SerotypeDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SerotypeDetails> {
        return NSFetchRequest<PVE_SerotypeDetails>(entityName: "PVE_SerotypeDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var type: String?

}



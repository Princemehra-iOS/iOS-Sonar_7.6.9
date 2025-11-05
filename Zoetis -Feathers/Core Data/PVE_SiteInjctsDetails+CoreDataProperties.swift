//
//  PVE_SiteInjctsDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_SiteInjctsDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SiteInjctsDetails> {
        return NSFetchRequest<PVE_SiteInjctsDetails>(entityName: "PVE_SiteInjctsDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?

}

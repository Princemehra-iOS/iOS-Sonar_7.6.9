//
//  CocoiVaccineTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by  on 11/21/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension CocoiVaccineTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocoiVaccineTurkey> {
        return NSFetchRequest<CocoiVaccineTurkey>(entityName: "CocoiVaccineTurkey")
    }

    @NSManaged public var cocoiiVacname: String?
    @NSManaged public var cocvaccId: NSNumber?
    @NSManaged public var lngId: NSNumber?

}

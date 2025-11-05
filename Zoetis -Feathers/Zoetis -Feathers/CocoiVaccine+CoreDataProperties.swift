//
//  CocoiVaccine+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/19/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension CocoiVaccine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocoiVaccine> {
        return NSFetchRequest<CocoiVaccine>(entityName: "CocoiVaccine")
    }

    @NSManaged public var cocvaccId: NSNumber?
    @NSManaged public var cocoiiVacname: String?
    @NSManaged public var lngId: NSNumber?

}

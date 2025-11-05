//
//  Sessiontype+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/20/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension Sessiontype {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sessiontype> {
        return NSFetchRequest<Sessiontype>(entityName: "Sessiontype")
    }

    @NSManaged public var sesionId: NSNumber?
    @NSManaged public var sesionType: String?
    @NSManaged public var lngId: NSNumber?

}

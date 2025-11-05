//
//  RouteTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/21/18.
//  Copyright © 2 018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension RouteTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteTurkey> {
        return NSFetchRequest<RouteTurkey>(entityName: "RouteTurkey")
    }

    @NSManaged public var routeId: NSNumber?
    @NSManaged public var routeName: String?
    @NSManaged public var lngId: NSNumber?

}

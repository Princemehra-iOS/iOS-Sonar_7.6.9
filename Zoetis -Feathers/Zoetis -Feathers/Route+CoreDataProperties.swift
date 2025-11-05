//
//  Route+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/17/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var routeId: NSNumber?
    @NSManaged public var routeName: String?
    @NSManaged public var lngId: NSNumber?

}

//
//  Id+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 1/10/18.
//  Copyright © 2018   . All rights reserved.
//
//

import Foundation
import CoreData


extension Id {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Id> {
        return NSFetchRequest<Id>(entityName: "Id")
    }

    @NSManaged public var autoId: NSNumber?

}

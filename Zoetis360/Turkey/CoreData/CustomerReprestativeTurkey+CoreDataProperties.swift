//
//  CustomerReprestativeTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension CustomerReprestativeTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerReprestativeTurkey> {
        return NSFetchRequest<CustomerReprestativeTurkey>(entityName: "CustomerReprestativeTurkey")
    }

    @NSManaged public var userid: NSNumber?
    @NSManaged public var customername: String?

}

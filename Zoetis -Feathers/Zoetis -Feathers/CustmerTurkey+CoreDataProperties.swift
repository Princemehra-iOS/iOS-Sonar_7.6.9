//
//  CustmerTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension CustmerTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustmerTurkey> {
        return NSFetchRequest<CustmerTurkey>(entityName: "CustmerTurkey")
    }

    @NSManaged public var custId: NSNumber?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var custName: String?

}

//
//  ComplexPostingTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension ComplexPostingTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComplexPostingTurkey> {
        return NSFetchRequest<ComplexPostingTurkey>(entityName: "ComplexPostingTurkey")
    }

    @NSManaged public var complexId: NSNumber?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var complexName: String?

}

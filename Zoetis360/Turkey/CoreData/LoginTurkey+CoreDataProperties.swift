//
//  LoginTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension LoginTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginTurkey> {
        return NSFetchRequest<LoginTurkey>(entityName: "LoginTurkey")
    }

    @NSManaged public var signal: String?
    @NSManaged public var username: String?
    @NSManaged public var loginId: NSNumber?
    @NSManaged public var userId: NSNumber?
    @NSManaged public var userTypeId: NSNumber?
    @NSManaged public var status: NSNumber?

}

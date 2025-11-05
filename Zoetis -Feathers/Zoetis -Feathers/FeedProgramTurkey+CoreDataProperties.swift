//
//  FeedProgramTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension FeedProgramTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedProgramTurkey> {
        return NSFetchRequest<FeedProgramTurkey>(entityName: "FeedProgramTurkey")
    }

    @NSManaged public var lngId: NSNumber?
    @NSManaged public var feedId: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var feddProgramNam: String?
    @NSManaged public var formName: String?
    @NSManaged public var isSync: NSNumber?

}

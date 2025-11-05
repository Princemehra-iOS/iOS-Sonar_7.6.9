//
//  FeedProgram+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 12/29/17.
//  Copyright © 2017   . All rights reserved.
//
//

import Foundation
import CoreData

extension FeedProgram {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedProgram> {
        return NSFetchRequest<FeedProgram>(entityName: "FeedProgram")
    }

    @NSManaged public var feddProgramNam: String?
    @NSManaged public var feedId: NSNumber?
    @NSManaged public var formName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var lngId: NSNumber?

}

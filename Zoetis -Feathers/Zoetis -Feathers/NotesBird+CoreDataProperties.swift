//
//  NotesBird+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 12/29/17.
//  Copyright © 2017   . All rights reserved.
//
//

import Foundation
import CoreData

extension NotesBird {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesBird> {
        return NSFetchRequest<NotesBird>(entityName: "NotesBird")
    }

    @NSManaged public var catName: String?
    @NSManaged public var formName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var noofBirds: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var lngId: NSNumber?

}

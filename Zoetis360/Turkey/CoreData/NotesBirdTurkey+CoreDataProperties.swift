//
//  NotesBirdTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension NotesBirdTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesBirdTurkey> {
        return NSFetchRequest<NotesBirdTurkey>(entityName: "NotesBirdTurkey")
    }

    @NSManaged public var lngId: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var noofBirds: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var catName: String?
    @NSManaged public var formName: String?
    @NSManaged public var notes: String?
    @NSManaged public var isSync: NSNumber?

}

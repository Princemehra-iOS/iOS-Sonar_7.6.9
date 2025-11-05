//
//  FieldVaccination+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 12/29/17.
//  Copyright © 2017   . All rights reserved.
//
//

import Foundation
import CoreData

extension FieldVaccination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FieldVaccination> {
        return NSFetchRequest<FieldVaccination>(entityName: "FieldVaccination")
    }

    @NSManaged public var isSync: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var route: String?
    @NSManaged public var strain: String?
    @NSManaged public var type: String?
    @NSManaged public var vaciNationProgram: String?
    @NSManaged public var lngId: NSNumber?

}

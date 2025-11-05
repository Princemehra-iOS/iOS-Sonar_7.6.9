//
//  FieldVaccinationTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension FieldVaccinationTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FieldVaccinationTurkey> {
        return NSFetchRequest<FieldVaccinationTurkey>(entityName: "FieldVaccinationTurkey")
    }

    @NSManaged public var lngId: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var route: String?
    @NSManaged public var strain: String?
    @NSManaged public var type: String?
    @NSManaged public var vaciNationProgram: String?
    @NSManaged public var isSync: NSNumber?

}

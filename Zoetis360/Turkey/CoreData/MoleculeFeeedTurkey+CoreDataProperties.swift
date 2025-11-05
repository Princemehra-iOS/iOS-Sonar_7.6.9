//
//  MoleculeFeeedTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by  on 11/21/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension MoleculeFeeedTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoleculeFeeedTurkey> {
        return NSFetchRequest<MoleculeFeeedTurkey>(entityName: "MoleculeFeeedTurkey")
    }

    @NSManaged public var catId: NSNumber?
    @NSManaged public var desc: String?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var moleculeId: NSNumber?

}

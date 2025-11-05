//
//  PVE_BreedOfBirds+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_BreedOfBirds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_BreedOfBirds> {
        return NSFetchRequest<PVE_BreedOfBirds>(entityName: "PVE_BreedOfBirds")
    }
    
    @NSManaged public var evaluationId: NSNumber?
    @NSManaged public var type: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var id: NSNumber?

}

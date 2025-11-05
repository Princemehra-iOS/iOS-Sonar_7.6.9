//
//  PVE_AgeOfBirds+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_AgeOfBirds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_AgeOfBirds> {
        return NSFetchRequest<PVE_AgeOfBirds>(entityName: "PVE_AgeOfBirds")
    }

    @NSManaged public var age: String?
    @NSManaged public var bird_Id: NSNumber?
    @NSManaged public var id: NSNumber?

}

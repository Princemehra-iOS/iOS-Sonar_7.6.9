//
//  PVE_Evaluator+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_Evaluator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_Evaluator> {
        return NSFetchRequest<PVE_Evaluator>(entityName: "PVE_Evaluator")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var id: NSNumber?

}

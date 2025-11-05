//
//  PVE_EvaluationFor+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_EvaluationFor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_EvaluationFor> {
        return NSFetchRequest<PVE_EvaluationFor>(entityName: "PVE_EvaluationFor")
    }

    @NSManaged public var isDeletd: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?

}

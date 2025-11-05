//
//  PVE_EvaluationType+CoreDataProperties.swift
//  
//
//  Created by Nitin kumar Kanojia on 31/12/19.
//
//

import Foundation
import CoreData


extension PVE_EvaluationType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_EvaluationType> {
        return NSFetchRequest<PVE_EvaluationType>(entityName: "PVE_EvaluationType")
    }

    @NSManaged public var isDeletd: NSNumber?
    @NSManaged public var evaluationId: NSNumber?
    @NSManaged public var evaluationName: String?
    @NSManaged public var module_Id: NSNumber?

}

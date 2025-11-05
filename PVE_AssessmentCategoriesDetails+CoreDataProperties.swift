//
//  PVE_AssessmentCategoriesDetails+CoreDataProperties.swift
//  
//
//  Created by NITIN KUMAR KANOJIA on 11/01/20.
//
//

import Foundation
import CoreData


extension PVE_AssessmentCategoriesDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_AssessmentCategoriesDetails> {
        return NSFetchRequest<PVE_AssessmentCategoriesDetails>(entityName: "PVE_AssessmentCategoriesDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var hatchery_Module_Id: NSNumber?
    @NSManaged public var category_Name: String?
    @NSManaged public var evaluation_Type_Id: NSNumber?
    @NSManaged public var max_Mark: NSNumber?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var assessmentQuestion: NSObject?

}

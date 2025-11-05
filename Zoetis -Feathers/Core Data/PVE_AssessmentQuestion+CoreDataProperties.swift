//
//  PVE_AssessmentQuestion+CoreDataProperties.swift
//  
//
//  Created by NITIN KUMAR KANOJIA on 13/01/20.
//
//

import Foundation
import CoreData


extension PVE_AssessmentQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_AssessmentQuestion> {
        return NSFetchRequest<PVE_AssessmentQuestion>(entityName: "PVE_AssessmentQuestion")
    }

    @NSManaged public var assessment: String?
    @NSManaged public var assessment2: String?
    @NSManaged public var max_Mark: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var isSelected: NSNumber?
    @NSManaged public var max_Score: NSNumber?
    @NSManaged public var mid_Score: NSNumber?
    @NSManaged public var min_Score: NSNumber?
    @NSManaged public var module_Cat_Id: NSNumber?
    @NSManaged public var pVE_Vacc_Type: String?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var types: String?
    @NSManaged public var information: String?
    @NSManaged public var comment: String?
    @NSManaged public var image_Name: String?
    @NSManaged public var folder_Path: String?


}

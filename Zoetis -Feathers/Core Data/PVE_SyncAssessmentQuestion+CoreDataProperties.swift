//
//  PVE_SyncAssessmentQuestion+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 01/04/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_SyncAssessmentQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SyncAssessmentQuestion> {
        return NSFetchRequest<PVE_SyncAssessmentQuestion>(entityName: "PVE_SyncAssessmentQuestion")
    }

    @NSManaged public var assessment: String?
    @NSManaged public var assessment2: String?
    @NSManaged public var comment: String?
    @NSManaged public var enteredText: String?
    @NSManaged public var evaluation_Type_Id: NSNumber?
    @NSManaged public var folder_Path: String?
    @NSManaged public var hatchery_Module_Id: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var image_Name: String?
    @NSManaged public var information: String?
    @NSManaged public var isSelected: NSNumber?
    @NSManaged public var max_Mark: NSNumber?
    @NSManaged public var max_Score: NSNumber?
    @NSManaged public var mid_Score: NSNumber?
    @NSManaged public var min_Score: NSNumber?
    @NSManaged public var module_Cat_Id: NSNumber?
    @NSManaged public var pVE_Vacc_Type: String?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var syncId: String?
    @NSManaged public var type: String?
    @NSManaged public var types: String?

}

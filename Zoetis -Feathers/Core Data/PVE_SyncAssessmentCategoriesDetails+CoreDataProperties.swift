//
//  PVE_SyncAssessmentCategoriesDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 01/04/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_SyncAssessmentCategoriesDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SyncAssessmentCategoriesDetails> {
        return NSFetchRequest<PVE_SyncAssessmentCategoriesDetails>(entityName: "PVE_SyncAssessmentCategoriesDetails")
    }

    @NSManaged public var assessmentQuestion: NSObject?
    @NSManaged public var category_Name: String?
    @NSManaged public var evaluation_Type_Id: NSNumber?
    @NSManaged public var hatchery_Module_Id: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var max_Mark: NSNumber?
    @NSManaged public var seq_Number: NSNumber?
    @NSManaged public var syncId: String?
    @NSManaged public var type: String?

}

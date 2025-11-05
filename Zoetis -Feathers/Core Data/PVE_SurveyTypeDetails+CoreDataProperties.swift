//
//  PVE_SurveyTypeDetails+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 27/01/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_SurveyTypeDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_SurveyTypeDetails> {
        return NSFetchRequest<PVE_SurveyTypeDetails>(entityName: "PVE_SurveyTypeDetails")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var surveyName: String?
    @NSManaged public var surveyType: String?

}

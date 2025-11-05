//
//  PVE_Sync+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by NITIN KUMAR KANOJIA on 22/03/20.
//  Copyright © 2020 . All rights reserved.
//
//

import Foundation
import CoreData


extension PVE_Sync {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PVE_Sync> {
        return NSFetchRequest<PVE_Sync>(entityName: "PVE_Sync")
    }

    @NSManaged public var accountManager: String?
    @NSManaged public var accountManagerId: NSNumber?
    @NSManaged public var ageOfBirds: NSNumber?
    @NSManaged public var ageOfBirdsId: NSNumber?
    @NSManaged public var breedOfBirds: String?
    @NSManaged public var breedOfBirdsFemale: String?
    @NSManaged public var breedOfBirdsFemaleId: NSNumber?
    @NSManaged public var breedOfBirdsFemaleOther: String?
    @NSManaged public var breedOfBirdsId: NSNumber?
    @NSManaged public var breedOfBirdsOther: String?
    @NSManaged public var cameraEnabled: String?
    @NSManaged public var cat_companyRepEmail: String?
    @NSManaged public var cat_companyRepMobile: String?
    @NSManaged public var cat_companyRepName: String?
    @NSManaged public var cat_crewLeaderEmail: String?
    @NSManaged public var cat_crewLeaderMobile: String?
    @NSManaged public var cat_crewLeaderName: String?
    @NSManaged public var cat_NoOfCatchersDetailsArr: NSObject?
    @NSManaged public var cat_NoOfVaccinatorsDetailsArr: NSObject?
    @NSManaged public var cat_selectedVaccineInfoType: String?
    @NSManaged public var cat_vaccinInfoDetailArr: NSObject?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var complexName: String?
    @NSManaged public var customer: String?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var evaluationDate: String?
    @NSManaged public var evaluationFor: String?
    @NSManaged public var evaluationForId: NSNumber?
    @NSManaged public var evaluator: String?
    @NSManaged public var evaluatorId: NSNumber?
    @NSManaged public var farm: String?
    @NSManaged public var firstName: String?
    @NSManaged public var houseNumber: String?
    @NSManaged public var housing: String?
    @NSManaged public var housingId: NSNumber?
    @NSManaged public var injCenter_LeftWing_Field: NSNumber?
    @NSManaged public var injCenter_RightWing_Field: NSNumber?
    @NSManaged public var injMissed_IntramusculerInj_Field: NSNumber?
    @NSManaged public var injMissed_LeftWing_Field: NSNumber?
    @NSManaged public var injMissed_RightWing_Field: NSNumber?
    @NSManaged public var injMissed_SubcutaneousInj_Field: NSNumber?
    @NSManaged public var injMuscleHit_IntramusculerInj_Field: NSNumber?
    @NSManaged public var injMuscleHit_LeftWing_Field: NSNumber?
    @NSManaged public var injMuscleHit_RightWing_Field: NSNumber?
    @NSManaged public var injMuscleHit_SubcutaneousInj_Field: NSNumber?
    @NSManaged public var injWingBand_LeftWing_Field: NSNumber?
    @NSManaged public var injWingBand_RightWing_Field: NSNumber?
    @NSManaged public var noOfBirds: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var objEvaluationDate: Date?
    @NSManaged public var selectedBirdTypeId: NSNumber?
    @NSManaged public var serveyNo: String?
    @NSManaged public var sessionId: NSNumber?
    @NSManaged public var siteId: NSNumber?
    @NSManaged public var siteName: String?
    @NSManaged public var userId: NSNumber?
    @NSManaged public var vacEval_Comment: String?
    @NSManaged public var vacEval_DyeAdded: NSNumber?
    @NSManaged public var xPage: NSObject?
    @NSManaged public var xSelectedCategoryIndex: NSNumber?
    @NSManaged public var categoryArray: NSObject?
    @NSManaged public var scoreArray: NSObject?
    @NSManaged public var syncId: String?
    @NSManaged public var type: String?

    @NSManaged public var maxScoreArray: NSObject?

    @NSManaged public var createdAt: String?
    @NSManaged public var deviceId: String?
    @NSManaged public var syncedStatus: NSNumber?

}

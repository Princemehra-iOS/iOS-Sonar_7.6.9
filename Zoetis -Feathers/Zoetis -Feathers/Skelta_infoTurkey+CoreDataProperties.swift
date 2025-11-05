//
//  Skelta_infoTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension Skelta_infoTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Skelta_infoTurkey> {
        return NSFetchRequest<Skelta_infoTurkey>(entityName: "Skelta_infoTurkey")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var infoText_chinese: String?
    @NSManaged public var infoText_english: String?
    @NSManaged public var infoText_purtugise: String?
    @NSManaged public var infoText_spanish: String?
    @NSManaged public var obsName_chinese: String?
    @NSManaged public var obsName_english: String?
    @NSManaged public var obsName_purutugise: String?
    @NSManaged public var obsName_spanish: String?
    @NSManaged public var necId: NSNumber?
    @NSManaged public var obsId: NSNumber?

}

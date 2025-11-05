//
//  Skelta_info+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 1/8/18.
//  Copyright © 2018   . All rights reserved.
//
//

import Foundation
import CoreData

extension Skelta_info {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Skelta_info> {
        return NSFetchRequest<Skelta_info>(entityName: "Skelta_info")
    }

    @NSManaged public var obsId: NSNumber?
    @NSManaged public var necId: NSNumber?
    @NSManaged public var obsName_english: String?
    @NSManaged public var infoText_english: String?
    @NSManaged public var infoText_chinese: String?
    @NSManaged public var infoText_spanish: String?
    @NSManaged public var infoText_purtugise: String?
    @NSManaged public var obsName_chinese: String?
    @NSManaged public var obsName_spanish: String?
    @NSManaged public var obsName_purutugise: String?
    @NSManaged public var imageName: String?

}

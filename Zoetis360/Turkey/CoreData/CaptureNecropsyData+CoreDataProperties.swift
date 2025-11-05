//
//  CaptureNecropsyData+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by  on 06/06/19.
//  Copyright © 2019 . All rights reserved.
//
//

import Foundation
import CoreData


extension CaptureNecropsyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaptureNecropsyData> {
        return NSFetchRequest<CaptureNecropsyData>(entityName: "CaptureNecropsyData")
    }

    @NSManaged public var actualTimeStamp: String?
    @NSManaged public var age: String?
    @NSManaged public var complexDate: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var complexName: String?
    @NSManaged public var custmerId: NSNumber?
    @NSManaged public var farmId: NSNumber?
    @NSManaged public var farmName: String?
    @NSManaged public var feedId: NSNumber?
    @NSManaged public var feedProgram: String?
    @NSManaged public var flockId: String?
    @NSManaged public var houseNo: String?
    @NSManaged public var imageId: NSNumber?
    @NSManaged public var isChecked: NSNumber?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var noOfBirds: String?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var sick: NSNumber?
    @NSManaged public var timeStamp: String?
    @NSManaged public var farmcount: NSNumber?

}

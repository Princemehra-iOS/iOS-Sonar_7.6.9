//
//  CaptureNecropsyDataTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 06/06/19.
//  Copyright © 2019 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension CaptureNecropsyDataTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaptureNecropsyDataTurkey> {
        return NSFetchRequest<CaptureNecropsyDataTurkey>(entityName: "CaptureNecropsyDataTurkey")
    }

    @NSManaged public var abf: String?
    @NSManaged public var actualTimeStamp: String?
    @NSManaged public var age: String?
    @NSManaged public var breed: String?
    @NSManaged public var complexDate: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var complexName: String?
    @NSManaged public var custmerId: NSNumber?
    @NSManaged public var farmId: NSNumber?
    @NSManaged public var farmName: String?
    @NSManaged public var farmWeight: String?
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
    @NSManaged public var sex: String?
    @NSManaged public var sick: NSNumber?
    @NSManaged public var timeStamp: String?
    @NSManaged public var farmcount: NSNumber?

}

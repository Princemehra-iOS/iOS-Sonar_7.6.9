//
//  BirdPhotoCaptureTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension BirdPhotoCaptureTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BirdPhotoCaptureTurkey> {
        return NSFetchRequest<BirdPhotoCaptureTurkey>(entityName: "BirdPhotoCaptureTurkey")
    }

    @NSManaged public var birdNum: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var obsId: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var catName: String?
    @NSManaged public var farmName: String?
    @NSManaged public var obsName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var photo: NSData?

}

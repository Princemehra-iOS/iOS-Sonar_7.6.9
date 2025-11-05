//
//  BirdPhotoCapture+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 12/29/17.
//  Copyright © 2017   . All rights reserved.
//
//

import Foundation
import CoreData


extension BirdPhotoCapture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BirdPhotoCapture> {
        return NSFetchRequest<BirdPhotoCapture>(entityName: "BirdPhotoCapture")
    }

    @NSManaged public var birdNum: NSNumber?
    @NSManaged public var catName: String?
    @NSManaged public var farmName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var obsId: NSNumber?
    @NSManaged public var obsName: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var lngId: NSNumber?

}

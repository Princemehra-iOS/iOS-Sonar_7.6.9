//
//  CaptureNecropsyViewDataTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension CaptureNecropsyViewDataTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaptureNecropsyViewDataTurkey> {
        return NSFetchRequest<CaptureNecropsyViewDataTurkey>(entityName: "CaptureNecropsyViewDataTurkey")
    }

    @NSManaged public var lngId: NSNumber?
    @NSManaged public var refId: NSNumber?
    @NSManaged public var birdNo: NSNumber?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var obsID: NSNumber?
    @NSManaged public var obsPoint: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var quickLink: NSNumber?
    @NSManaged public var actualText: String?
    @NSManaged public var catName: String?
    @NSManaged public var formName: String?
    @NSManaged public var measure: String?
    @NSManaged public var notes: String?
    @NSManaged public var obsImageDesc: String?
    @NSManaged public var obsName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var objsVisibilty: NSNumber?
    @NSManaged public var cameraImage: NSData?
    @NSManaged public var farmWeight: String?
    @NSManaged public var breed: String?
    @NSManaged public var sex: String?
    @NSManaged public var abf: String?

}

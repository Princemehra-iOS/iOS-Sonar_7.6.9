//
//  CaptureNecropsyViewData+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 1/22/18.
//  Copyright © 2018   . All rights reserved.
//
//

import Foundation
import CoreData

extension CaptureNecropsyViewData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaptureNecropsyViewData> {
        return NSFetchRequest<CaptureNecropsyViewData>(entityName: "CaptureNecropsyViewData")
    }

    @NSManaged public var actualText: String?
    @NSManaged public var birdNo: NSNumber?
    @NSManaged public var cameraImage: NSData?
    @NSManaged public var catName: String?
    @NSManaged public var formName: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var measure: String?
    @NSManaged public var necropsyId: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var objsVisibilty: NSNumber?
    @NSManaged public var obsID: NSNumber?
    @NSManaged public var obsImageDesc: String?
    @NSManaged public var obsName: String?
    @NSManaged public var obsPoint: NSNumber?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var quickLink: NSNumber?
    @NSManaged public var refId: NSNumber?

}

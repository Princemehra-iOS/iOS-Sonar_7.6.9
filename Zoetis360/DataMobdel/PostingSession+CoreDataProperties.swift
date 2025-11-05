//
//  PostingSession+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by    on 1/24/18.
//  Copyright © 2018   . All rights reserved.
//
//

import Foundation
import CoreData


extension PostingSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostingSession> {
        return NSFetchRequest<PostingSession>(entityName: "PostingSession")
    }

    @NSManaged public var actualTimeStamp: String?
    @NSManaged public var antiboitic: String?
    @NSManaged public var birdBreedId: NSNumber?
    @NSManaged public var birdBreedName: String?
    @NSManaged public var birdBreedType: String?
    @NSManaged public var birdSize: String?
    @NSManaged public var birdSizeId: NSNumber?
    @NSManaged public var catptureNec: NSNumber?
    @NSManaged public var cocciProgramId: NSNumber?
    @NSManaged public var cociiProgramName: String?
    @NSManaged public var complexId: NSNumber?
    @NSManaged public var complexName: String?
    @NSManaged public var convential: String?
    @NSManaged public var customerId: NSNumber?
    @NSManaged public var customerName: String?
    @NSManaged public var customerRepId: NSNumber?
    @NSManaged public var customerRepName: String?
    @NSManaged public var female: String?
    @NSManaged public var finalizeExit: NSNumber?
    @NSManaged public var imperial: String?
    @NSManaged public var isSync: NSNumber?
    @NSManaged public var lngId: NSNumber?
    @NSManaged public var loginSessionId: NSNumber?
    @NSManaged public var mail: String?
    @NSManaged public var metric: String?
    @NSManaged public var notes: String?
    @NSManaged public var postingId: NSNumber?
    @NSManaged public var salesRepId: NSNumber?
    @NSManaged public var salesRepName: String?
    @NSManaged public var sessiondate: String?
    @NSManaged public var sessionTypeId: NSNumber?
    @NSManaged public var sessionTypeName: String?
    @NSManaged public var timeStamp: String?
    @NSManaged public var vetanatrionName: String?
    @NSManaged public var veterinarianId: NSNumber?
    @NSManaged public var isfarmSync: NSNumber?
    @NSManaged public var productionTypeId: NSNumber?
    @NSManaged public var productionTypeName: String?
    
    @NSManaged public var avgAge: String?
    @NSManaged public var avgWeight: String?
    @NSManaged public var dayMortality: String?
    @NSManaged public var fcr: String?
    @NSManaged public var livability: String?
    @NSManaged public var outTime: String?
    
}

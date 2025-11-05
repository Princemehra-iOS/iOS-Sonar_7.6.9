//
//  CamraImageTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Manish Behl on 30/05/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension CamraImageTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CamraImageTurkey> {
        return NSFetchRequest<CamraImageTurkey>(entityName: "CamraImageTurkey")
    }

    @NSManaged public var localimage: NSData?

}

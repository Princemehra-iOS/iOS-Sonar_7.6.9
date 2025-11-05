//
//  CocciProgramPosting+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by  on 11/17/18.
//  Copyright © 2018 . All rights reserved.
//
//

import Foundation
import CoreData


extension CocciProgramPosting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocciProgramPosting> {
        return NSFetchRequest<CocciProgramPosting>(entityName: "CocciProgramPosting")
    }

    @NSManaged public var cocciProgramId: NSNumber?
    @NSManaged public var cocciProgramName: String?
    @NSManaged public var lngId: NSNumber?

}

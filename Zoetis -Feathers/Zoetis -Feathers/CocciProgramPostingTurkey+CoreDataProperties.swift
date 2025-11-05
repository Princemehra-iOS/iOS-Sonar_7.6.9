//
//  CocciProgramPostingTurkey+CoreDataProperties.swift
//  Zoetis -Feathers
//
//  Created by Alok Yadav on 11/21/18.
//  Copyright © 2018 Alok Yadav. All rights reserved.
//
//

import Foundation
import CoreData

extension CocciProgramPostingTurkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocciProgramPostingTurkey> {
        return NSFetchRequest<CocciProgramPostingTurkey>(entityName: "CocciProgramPostingTurkey")
    }

    @NSManaged public var cocciProgramId: NSNumber?
    @NSManaged public var cocciProgramName: String?
    @NSManaged public var lngId: NSNumber?

}

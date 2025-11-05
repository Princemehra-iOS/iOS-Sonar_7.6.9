//
//  Microbial_AllMediaTypes.swift
//  Zoetis -Feathers
//
//  Created by Siva Preasad Reddy on 24/02/22.
//

import Foundation
import CoreData

public class Microbial_AllMediaTypes: NSManagedObject {

    @NSManaged public var id: NSNumber?
    @NSManaged public var text: String?
}



public class Microbial_SamplingMethodTypes: NSManagedObject {

    @NSManaged public var id: NSNumber?
    @NSManaged public var text: String?
}


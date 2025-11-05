//
//  Customer_PVE+CoreDataProperties.swift
//  
//
//  Created by NITIN KUMAR KANOJIA on 29/12/19.
//
//

import Foundation
import CoreData


extension Customer_PVE {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer_PVE> {
        return NSFetchRequest<Customer_PVE>(entityName: "Customer_PVE")
    }

    @NSManaged public var customerName: String?
    @NSManaged public var customerId: NSNumber?

}

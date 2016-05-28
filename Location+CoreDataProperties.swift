//
//  Location+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var creationDate: NSDate?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var totalPagesForImages: NSNumber?
    @NSManaged var images: NSSet?

}

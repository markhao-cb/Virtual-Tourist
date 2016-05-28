//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Yu Qi Hao on 5/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var creationDate: NSDate?
    @NSManaged var image: NSData?
    @NSManaged var imageUrl: String?
    @NSManaged var location: Location?

}

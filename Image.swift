//
//  Image.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import CoreData


class Image: NSManagedObject {

    convenience init(url: String, location: Location, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(Constants.CoreDataEntities.Image, inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.imageURL = url
            self.location = location
            self.creationDate = NSDate()
            
        } else {
            fatalError("Could not find entity named: \(Constants.CoreDataEntities.Image)")
        }
    }

}

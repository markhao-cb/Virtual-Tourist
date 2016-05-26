//
//  Location.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {

    convenience init(longtitude: Float, latitude: Float, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(Constants.CoreDataEntities.Location, inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.latitude = latitude
            self.longtitude = longtitude
            self.creationDate = NSDate()
            
        } else {
            fatalError("Could not find entity named: \(Constants.CoreDataEntities.Location)")
        }
    }
}

//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import MapKit

class VTAnnotation: MKPointAnnotation {
    
    var location: Location?
    
    convenience init(location: Location) {
        self.init()
        self.location = location
    }
}

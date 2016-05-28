//
//  VTImage.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

struct VTImage : Equatable {
    
    var imageUrl: String?
    var imageData: NSData?
    
    init(dictionary: [String: AnyObject]) {
        imageUrl = dictionary[FlickrClient.ResponseKey.SquareURL] as? String
    }
    
    init(data: NSData) {
        imageData = data
    }
    
    static func imagesForLocationFrom(results: [[String: AnyObject]] ) -> [VTImage] {
        
        var images = [VTImage]()
        
        for result in results {
            images.append(VTImage(dictionary: result))
        }
        
        return images
    }
    
    static func imageForLocationFrom(set: NSSet) -> [VTImage] {
        
        var images = [VTImage]()
        
        for image in set {
            let image = image as! Image
            images.append(VTImage(data: image.image!))
        }
        
        return images
    }
}

func ==(lhs: VTImage, rhs: VTImage) -> Bool {
    return lhs.imageUrl == rhs.imageUrl
}
//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation


extension FlickrClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    // MARK: Flickr Parameter Keys
    struct ParametersKey {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Longtitude = "lon"
        static let Latitude = "lat"
        static let PerPage = "per_page"
    }
    
    // MARK: Flickr Parameter Values
    struct ParametersValue {
        static let ApiKey = "3621fe11b1fdf875f11015b3790577d6"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let PhotosSearchMethod = "flickr.photos.search"
        static let SquareURL = "url_q"
        static let ImagePerPage = "21"
    }
    
    // MARK: Flickr Response Keys
    struct ResponseKey {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let SquareURL = "url_q"
        static let Pages = "pages"
    }
    
    // MARK: Flickr Response Values
    struct ResponseValues {
        static let OKStatus = "ok"
    }
}
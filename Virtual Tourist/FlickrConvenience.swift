//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation


extension FlickrClient {
    
    func getImagesFromLocation(location: Location, page: Int, completionHandlerForGetImages: (success: Bool, pages: Int?,images: [[String : AnyObject]]?, errorMessage: String?) -> Void) {
        let page = String(page)
        
        let parameters = [
            ParametersKey.APIKey : ParametersValue.ApiKey,
            ParametersKey.Method : ParametersValue.PhotosSearchMethod,
            ParametersKey.Format : ParametersValue.ResponseFormat,
            ParametersKey.NoJSONCallback : ParametersValue.DisableJSONCallback,
            ParametersKey.Extras : ParametersValue.SquareURL,
            ParametersKey.BBox : bboxString(location),
            ParametersKey.PerPage : ParametersValue.ImagePerPage,
            ParametersKey.Page : page
        ]
        
        let method = ""
        
        taskForGETMethod(method, parameters: parameters) { (result, error) in
            guard (error == nil) else {
                completionHandlerForGetImages(success: false, pages: nil, images: nil, errorMessage: error?.localizedDescription)
                return
            }
            
            guard let stat = result[ResponseKey.Status] as? String where stat == ResponseValues.OKStatus else {
                completionHandlerForGetImages(success: false, pages: nil, images: nil, errorMessage: "Api status is other than OK")
                return
            }
            
            guard let photos = result[ResponseKey.Photos] as? [String: AnyObject], pages = photos[ResponseKey.Pages] as? Int, photo = photos[ResponseKey.Photo] as? [[String: AnyObject]] else  {
                completionHandlerForGetImages(success: false, pages: nil, images: nil, errorMessage: "Could not get required data.")
                return
            }
            
            completionHandlerForGetImages(success: true, pages: pages, images: photo, errorMessage: nil)
            
        }
    }
    
    
    private func bboxString(location: Location) -> String {
        // ensure bbox is bounded by minimum and maximums
        let latitude = Double(location.latitude!)
        let longitude = Double(location.longtitude!)
        let minimumLon = max(longitude - Flickr.SearchBBoxHalfWidth, Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Flickr.SearchBBoxHalfHeight, Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Flickr.SearchBBoxHalfWidth, Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Flickr.SearchBBoxHalfHeight, Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
}
//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation


extension FlickrClient {
    
    func getImagesFromLocation(location: Location, completionHandlerForGetImages: (success: Bool, pages: Int?,images: [[String : AnyObject]]?, errorMessage: String?) -> Void) {
        
        let longtitude = String(location.longtitude!)
        let latitude = String(location.latitude!)
        
        let parameters = [
            ParametersKey.APIKey : ParametersValue.ApiKey,
            ParametersKey.Method : ParametersValue.PhotosSearchMethod,
            ParametersKey.Format : ParametersValue.ResponseFormat,
            ParametersKey.NoJSONCallback : ParametersValue.DisableJSONCallback,
            ParametersKey.Extras : ParametersValue.SquareURL,
            ParametersKey.Longtitude : longtitude,
            ParametersKey.Latitude : latitude,
            ParametersKey.PerPage : ParametersValue.ImagePerPage
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
    
}
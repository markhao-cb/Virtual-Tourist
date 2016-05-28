//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Yu Qi Hao on 5/27/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    //Create Singleton
    static let sharedInstance = FlickrClient()
    private override init() {}
    
    
    
    func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error : NSError?) -> Void) -> NSURLSessionDataTask {
        
        let url = Utilities.BuildURLFrom(FlickrClient.Constants.ApiScheme, host: FlickrClient.Constants.ApiHost, path: FlickrClient.Constants.ApiPath, parameters: parameters, withPathExtension: method)
        print(url)
        let request = NSURLRequest(URL: url)
        
        let task = Utilities.session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            Utilities.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        
        return task
    }
}

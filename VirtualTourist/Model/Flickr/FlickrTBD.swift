//
//  FlickrTBD.swift
//  VirtualTourist
//
//  Created by NTG on 11/11/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation




import CoreData

struct FlickrClient {
    
    // inject core data
    var datacontroller: DataController!
    

    struct Photos: Decodable {
        let photos: Photos
        
    }
    
    struct PhotoDetails: Decodable {
        let photo: [Photo]
        let page: Int
        let pages: int
        
    }
    
    
    // MARK: HELPER FUNCTIONS
    
    // create a URL from parameters
    // SOURCE: used in The Movie Manager udacity sub-project (Section 5: Network Requests)
    func clearFlickrResults() {
        photoResults = []
        photoURLs = []
    }
    
    
    
    func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
            var components = URLComponents()
            components.scheme = FlickrConstants.FlickrAPI.APIScheme
            components.host = FlickrConstants.FlickrAPI.APIHost
            components.path = FlickrConstants.FlickrAPI.APIPath
            return components.url!
        }
    
    
    
    
    
    
}
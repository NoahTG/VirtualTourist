//
//  FlickrClient+Constants.swift
//  VirtualTourist
//
//  Created by NTG on 11/11/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation

extension FlickrClient {
        
        enum FlickrAPI {
                static let APIScheme = "https"
                static let APIHost = "api.flickr.com"
                static let APIPath = "/services/rest"
            }
        
        enum FlickrKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Latitude = "lat"
            static let Longitude = "lon"
            static let Radius = "radius"
            static let ResultsPerPage = "per_page"
            static let format = "format"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        enum FlickrValues {
            static let SearchMethod = "flickr.photos.search"
            static let APIKey = "a4b05476985821daf2c794037c702ac8"
            static let ResponseRadius = "1" // 1 mile radius
            static let ResponseFormat = "json"
            static let ResponseResultsPerPage = "100"
            static let DisableJSONCallback = "1" // 1 means "yes"
            static let galleryPhotosMethod = "flickr.galleries.getphotos"
        }
    

}

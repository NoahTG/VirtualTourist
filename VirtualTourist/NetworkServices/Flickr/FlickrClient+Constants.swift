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
    
        enum FlickrMethods {
            static let PhotoSearchMethod = "flickr.photos.search"
            static let galleryPhotosMethod = "flickr.galleries.getphotos"
        }

        
        enum FlickrKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Extra = "extras"
            static let Latitude = "lat"
            static let Longitude = "lon"
            static let Radius = "radius"
            static let Text = "text"
            static let BoundingBox = "bbox"
            static let ResultsPerPage = "per_page"
            static let Format = "format"
            static let NoJsonCallback = "nojsoncallback"
        }
        
        enum FlickrDefaultValues {
            static let ResponseRadius = "1" // 1 mile radius
            static let ResponseFormat = "json"
            static let ResponseResultsPerPage = "100"
            static let NoJsonCallback = "1" // 1 means "yes"
            static let ExtraMediumURL = "url_m"

        }
    

}

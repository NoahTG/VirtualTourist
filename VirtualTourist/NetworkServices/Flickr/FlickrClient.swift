//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by NTG on 11/11/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlickrClient: NSObject {
    
    // inject core data
    var datacontroller: DataController!

    
    // MARK: HELPER FUNCTIONS
    
    // create a URL from parameters
//    // SOURCE: used in The Movie Manager udacity sub-project (Section 5: Network Requests)
//    func clearFlickrResults() {
//        photoResults = []
//        photoURLs = []
//    }
//    
    
    
//    func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
//            var components = URLComponents()
//            components.scheme = FlickrConstants.FlickrAPI.APIScheme
//            components.host = FlickrConstants.FlickrAPI.APIHost
//            components.path = FlickrConstants.FlickrAPI.APIPath
//            return components.url!
//        }
//
    
    
    
    
    
}



// Protocol for retrieving and persisting data from Flicker API
protocol FlickrClientProtocol {
    /// Retrieves photos from Flickr for a specified map pin.
    /// - Parameters:
    ///     - pin: the map pin to be populated with photos.
    ///     - page: the page to grab photos from. Each page contains up to 100 photos.
    ///     - completionHandler: function that will be called following the compeltion of this method.
    func getFlickrPhotosForPin(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (Pin?, Int?, Error?) -> Void)

    /// Download the image from Flickr via image URL
    /// - Parameters:
    ///        - url: Image Url.
    ///        - completionHandler: function that will be called following the completion of this method.
    func downloadPhotoFromFlickr(fromUrl url: URL, completionHandler: @escaping (UIImage?, URLSessionTask.TaskHasError?) -> Void )
}

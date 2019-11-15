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

class FlickrClient: FlickrClientProtocol {
    
    // MARK: Properties
    
    
      // inject core data
    var datacontroller: DataController!

    let apiClient: APIClientProtocol
    
    static let sharedInstance = FlickrClient()
    
    // Flicker API key
    private let flickrAPIKey: String
    
    private static let jsonDecoder = JSONDecoder()
    
    
    // Create baseURL for Flickr requests
       private lazy var baseURL: URL = {
           var components = URLComponents()
           components.scheme = FlickrAPI.APIScheme
           components.host = FlickrAPI.APIHost
           components.path = FlickrAPI.APIPath
           return components.url!
       }()
    
    
    // MARK: Initializers

    private init(){}

    // MARK: Imperatives
    
    // TODO -------
    func getFlickrPhotosForPin(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (Pin?, Int?, Error?) -> Void) {
        
        let pinId = pin.objectID
        
        requestImages(completionHandler)
    }
    
    func downloadPhotoFromFlickr(fromUrl url: URL, completionHandler: @escaping (UIImage?, URLSessionTask.TaskHasError?) -> Void) {
        
    }
    
  
        
    // MARK: Helper Functions
    
    
    func requestImages(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (FlickrResponse?, Error?) -> Void) {
        let queryParms = [
            FlickrKeys.APIKey: FlickrValues.APIKey,
            FlickrKeys.Format: FlickrValues.ResponseFormat,
            FlickrKeys.NoJsonCallback: FlickrValues.NoJsonCallback,
            FlickrKeys.Method: FlickrValues.PhotosSearch,
            FlickrKeys.Extra: FlickrValues.ExtraMediumURL,
            FlickrKeys.Page: String(page),
            FlickrKeys.RadiusUnits: FlickrValues.RadiusUnits,
            FlickrKeys.Radius: FlickrValues.Radius,
            FlickrKeys.ResultsPerPage: FlickrValues.ResultsPerPage,
            FlickrKeys.Sort: FlickrValues.Sort,
            FlickrKeys.Latitude: String(pin.latitude),
            FlickrKeys.Longitude: String(pin.longitude)
        ]

        let dataTask = FlickrClient.sharedInstance.
        
        (withUrl: baseURL, queryParms: queryParms, headers: nil) { (data, error) in

            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }

            let jsonDecoder = JSONDecoder()

            do {
                let flickrResponse = try jsonDecoder.decode(FlickrResponse.self, from: data)
                completionHandler(flickrResponse, nil)
            } catch {
                do {
                    let flickrError = try jsonDecoder.decode(FlickrErrorResponse.self, from: data)
                    completionHandler(nil, flickrError)
                } catch {
                    completionHandler(nil, error)
                }
            }
            
        }
        dataTask.resume()
    }
    
    
    
    
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

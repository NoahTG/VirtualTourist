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
        
        requestImages(forPin: pin, resultsForPage: page) { (data, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
                return
            }
            
            let pinContext = self.datacontroller.viewContext.object(with: pinId) as! Pin
            
            
        }
    }
    
    func downloadPhotoFromFlickr(fromUrl url: URL, completionHandler: @escaping (UIImage?, URLSessionTask.TaskHasError?) -> Void) {
     
        
        let dataTask = apiClient.createGETDataTask(
            withURL: url,
            parameters: [:],
            headers: [:]) { (data, error) in
             
            guard let data = data,
                
        }
        
        //TODO
              
               }
               
//               let decoder = JSONDecoder()
//               do {
//                   let flickrGETResponse = try decoder.decode(FlickrResponse.self, from: data)
//                   completionHandler(flickrGETResponse, nil)
//               } catch {
//                   completionHandler(nil, URLSessionTask.TaskHasError.malformedJsonResponse)
//                       }
//                   }
//                   dataTask.resume()
//
//
//
//
        
    
    
  
        
    // MARK: Helper Functions
    
    
    func requestImages(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (FlickrResponse?, Error?) -> Void) {
        let queryParameters = [
            FlickrKeys.APIKey: FlickrDefaultValues.APIKey,
            FlickrKeys.Format: FlickrDefaultValues.ResponseFormat,
            FlickrKeys.NoJsonCallback: FlickrDefaultValues.NoJsonCallback,
            FlickrKeys.Method: FlickrMethods.PhotoSearchMethod,
            FlickrKeys.Radius: FlickrDefaultValues.ResponseRadius,
            FlickrKeys.ResultsPerPage: FlickrDefaultValues.ResponseResultsPerPage,
            FlickrKeys.Latitude: String(pin.latitude),
            FlickrKeys.Longitude: String(pin.longitude)
        ]
        
        
        let dataTask = FlickrClient.sharedInstance.apiClient.createGETDataTask(withURL: baseURL, parameters: queryParameters, headers: nil) { (data, error)
            in
            guard error == nil, let data = data else {
                completionHandler (nil, error!)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let flickrGETResponse = try decoder.decode(FlickrResponse.self, from: data)
                completionHandler(flickrGETResponse, nil)
            } catch {
                completionHandler(nil, URLSessionTask.TaskHasError.malformedJsonResponse)
                    }
                }
                dataTask.resume()
            }
    
    
    
}


static func bboxString(for cordinates: CLLocationCoordinate2D)-> String{
    let lat = cordinates.latitude
    let long = cordinates.longitude
    
    let minLat = max(lat - Constants.Flickr.SEARCH_HEIGHT, Constants.Flickr.SEARCH_LAT.0)
    let maxLat = min(lat + Constants.Flickr.SEARCH_HEIGHT, Constants.Flickr.SEARCH_LAT.1)
    let minLong = max(long - Constants.Flickr.SEARCH_WIDTH, Constants.Flickr.SEARCH_LONG.0)
    let maxLong = min(long + Constants.Flickr.SEARCH_WIDTH, Constants.Flickr.SEARCH_LONG.1)
    
    return "\(minLong),\(minLat),\(maxLong),\(maxLat)"
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

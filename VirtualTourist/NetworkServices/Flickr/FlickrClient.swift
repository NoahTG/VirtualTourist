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
    
    let apiClient: APIClientProtocol
        
    var dataController: DataController
    
    var albumPersist: AlbumPersistence
    
    static let sharedInstance = FlickrClient()
    
    // Flicker API key
    private let flickrAPIKey: String
        
    // Create baseURL for Flickr requests & lazy means code only runs when called
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
        
        let pinObjectId = pin.objectID
        
    
        requestFlickrImages(forPin: pin, resultsForPage: page) { (data, error) in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
                return
            }
    
            let pinContext = self.dataController.viewContext.object(with: pinObjectId) as! Pin

            DispatchQueue.main.async {
                do {
                    try self.albumPersist.setPagingInformation(
                        currentPage: Int16(data.searchResults.page),
                        totalPages: Int16(data.searchResults.page),
                        forAlbum: pinContext.toAlbum!)
                    try self.albumPersist.addPhotos(
                        images: data.searchResults.photos,
                        toPhotoAlbum: pinContext.toAlbum!)
                    completionHandler(pin, data.searchResults.pages, nil)
                } catch {
                    completionHandler(nil, nil, error)
                }
            }
    
            
            func downloadPhotoFromFlickr(fromUrl url: URL, completionHandler: @escaping (UIImage?, URLSessionTask.TaskHasError?) -> Void) {
     
        
                let dataTask = self.apiClient.createGETDataTask(
                    withURL: url,
                    parameters: [:],
                    headers: [:]) { (data, error) in
                     
                        guard let data = data, error == nil else {
                            completionHandler(nil, error)
                            return
                                
                        }
                        
                        guard let image = UIImage(data: data) else {
                            completionHandler(nil, .unexpectedResource)
                            return
                        }
                        completionHandler(image, nil)
                    }
                dataTask.resume()
            }
        
        }
    }

    // MARK: Helper Functions
    
    
    func requestFlickrImages(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (FlickrResponse?, Error?) -> Void) {
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
            guard let data = data, error == nil else {
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

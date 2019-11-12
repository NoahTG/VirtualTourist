//
//  APIClient.swift
//  VirtualTourist
//
//  Created by NTG on 11/11/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation



class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
               
               let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                   guard let data = data else {
                       DispatchQueue.main.async {
                           completion(nil, error)
                       }
                       return
                   }
                   let range = 5..<data.count
                   let newData = data.subdata(in: range) /* subset response data! */
                   
                   do {
                       let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                       DispatchQueue.main.async {
                           completion(responseObject, nil)
                       }
                   }
                   catch {
                       do {
                           let errorMessage = try JSONDecoder().decode(UdacityErrorMessages.self, from:newData)
                           DispatchQueue.main.async {
                               completion(nil, errorMessage)
                           }
                       }
                       catch {
                           DispatchQueue.main.async{
                           completion(nil, error)
                           }
                       }
                   }
               }
           task.resume()
           return task
           }









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

//
//  FlickrDataResponse.swift
//  VirtualTourist
//
//  Created by NTG on 11/12/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation


extension FlickrClient {

    struct Photos: Decodable {
        let photos: Photos
    
    }

    struct PhotoDetails: Decodable {
        let photo: [Photo]
        let page: Int
        let pages: int
        
    }

    struct Photo: Decodable {
           //    Variables needed:
           //    Farm ID = “farm”
           //    Server ID = “server”
           //    ID = “id”
           //    Secret = “secret”
           let farm: Int
           let server: String
           let id: String
           let secret: String
           let url_m: String
       }




// The response data returned from the flickr API.
struct FlickrSearchResponseData: Codable {
    let data: FlickrSarchData
    let status: String

    enum CodingKeys: String, CodingKey {
        case data = "photos"
        case status = "stat"
    }
}

/// The search response data returned from the flickr API.
struct FlickrSarchData: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let photos: [FlickrImage]

    enum CodingKeys: String, CodingKey {
        case page
        case pages

        case perPage = "perpage"
        case photos = "photo"
    }
}

/// The image data returned from the flickr api.
struct FlickrImage: Codable {
    let id: String
    let title: String
    let mediumUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case title

        case mediumUrl = "url_m"
    }
}

}

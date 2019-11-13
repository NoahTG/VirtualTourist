//
//  FlickrDataResponse.swift
//  VirtualTourist
//
//  Created by NTG on 11/12/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation


extension FlickrClient {

    // Response from Flickr photo search API.
    struct FlickrResponse: Codable {
        let searchResults: FlickrPhotoResults
        let status: String
    
        
        enum CodingKeys: String, CodingKey {
            case searchResults = "photos"
            case status = "status"
        }
    }

    // Pagination data from Flickr API photos search
    struct FlickrPhotoResults: Codable {
        let photos: [FlickrPhoto]
        let page: Int
        let pages: Int
        let photosPerPage: Int
        
        enum codingKeys: String, CodingKey {
            case page
            case pages
            case photosPerPage = "perpage"
            case photos = "photo"
            
        }
    }

    // Image Data from Flickr API
    struct FlickrPhoto: Codable {
        let id: String
        let title: String
        let mediumURL: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case mediumURL = "url_m"
        }
        
    }




}

//
//  Album+Extensions.swift
//  VirtualTourist
//
//  Created by NTG on 11/16/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import CoreData

extension Album {
    
    // MARK: Properties

    
    // Flag indicating if the album has images.
       var isEmpty: Bool {
           return (toPhotos?.count ?? 0) == 0
       }
    
    // MARK: Life cycle
    
    override public func awakeFromInsert() {
          super.awakeFromInsert()

          creationDate = Date()
          id = UUID().uuidString
    }
    
}


struct AlbumPersistence: AlbumPersistenceProtocol {
    
    // create property to hold persisted photo
    let photoPersist : PhotoPersistence
    
    func addPhotos(images: [FlickrPhoto], toPhotoAlbum photoAlbum: Album) throws {
        guard let context = photoAlbum.managedObjectContext else {
            preconditionFailure("Album instance has no context.")
        }

        images.forEach { (flickrImage) in
            _ = photoPersist.createPhoto(flickrImage: flickrImage, inAlbum: photoAlbum)
        }
        
        try context.save()
        
    }
    
    func setPagingInformation(currentPage: Int16, totalPages: Int16, forAlbum photoAlbum: Album) throws {
        guard let context = photoAlbum.managedObjectContext else {
            preconditionFailure("Album instance has no context.")
        }
        photoAlbum.currentPage = currentPage
        photoAlbum.totalPages = totalPages

        try context.save()
    }
    
   
}


// Utility for adding photos to Album Managed Object
protocol AlbumPersistenceProtocol {
    
    /// Create and save images to the photo album.
    /// - Parameters:
    ///        - images: the images from the flickr response
    ///        - photoAlbum: album populated with images
    func addPhotos(images: [FlickrPhoto], toPhotoAlbum photoAlbum: Album) throws
    
    
    
    /// Set pages for the specified album.
    /// - Parameters:
    ///        - currentPage: the current page of photos for the specified album.
    ///        - pages: the total number of pages of photos for the specified album.
    ///        - photoAlbum: album to be populated with page count.
    func setPagingInformation(currentPage: Int16, totalPages: Int16,  forAlbum photoAlbum: Album) throws
  
}


//
//  Photo+Extensions.swift
//  VirtualTourist
//
//  Created by NTG on 11/5/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    // MARK: Life cycle

    //called on initial object creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    
        }
}


struct PhotoPersistence: PhotoPersistenceProtocol {
   
   private init(){}

   func createPhoto(flickrImage: FlickrPhoto, inAlbum album: Album) -> Photo {
    guard let context = album.managedObjectContext else {
        preconditionFailure("Failed to set album context.")
    }

    let photo = Photo(context: context)
    photo.title = flickrImage.title
    photo.imageUrl = URL(string: flickrImage.mediumURL)
    photo.id = flickrImage.id
    photo.toAlbum = album
    return photo
}
    
    func getFetchedResultsController(forAlbum album: Album, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo> {
           
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(format: "toAlbum == %@", album)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
       }
       
}
      

// Utility for Creating Photo Managed Object
protocol PhotoPersistenceProtocol {
    /// Creates a new Photo NSManagedObject
    /// - Parameters:
    ///     - flickrImage: flickr image to be persisted.
    ///     - album: the album associted with the image.
    func createPhoto(flickrImage: FlickrPhoto, inAlbum album: Album) -> Photo

    /// Retrieve Fetched results controller for the associated album.
    /// - Parameters:
    ///     - photoAlbum: the album that photos will be retrieved from.
    ///        - context: the managed object context to be fetched.
    /// - Returns: the fetched results controller.
    func getFetchedResultsController(forAlbum album: Album, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo>
}

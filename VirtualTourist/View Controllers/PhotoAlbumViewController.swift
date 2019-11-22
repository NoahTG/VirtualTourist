//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by NTG on 11/6/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import UIKit

class PhotoAlbumViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //MARK: Controller Properties
            
    var dataController:DataController!

    /// The fetched results controller in charge of populating the collection view.
    var photosFetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var photo: Photo!
    var photoAlbumPopulating: PhotoAlbumPopulating!
    var flickrClient: FlickrClient!
    var pinPersistence: PinPersistence!
    var photoPersistence: PhotoPersistence!
    
    //MARK:- View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePhotoAlbum()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureFlowLayout()
        reloadPhotos()
        collectionView.reloadData()
    }

    //MARK:- Class Methods
    
    func downloadImages(forPage page: Int = 1){
        photoAlbumPopulating.setState(state: .downloading)
    
        flickrClient.getFlickrPhotosForPin(forPin: pin, resultsForPage: page) {[weak self] (pin, pages, error)
            in
            guard let weakSelf = self else { return }
            guard error == nil, let pin = pin else {
                weakSelf.showAlert(title: "Cannot download images", message: error!.localizedDescription)
                weakSelf.photoAlbumPopulating.setState(state: .noImagesFound)
                return
            }
            
            guard let photoAlbum = pin.toAlbum else {
                weakSelf.showAlert(title: "Cannot download images", message: error!.localizedDescription)
                weakSelf.photoAlbumPopulating.setState(state: .noImagesFound)
                return
            }
            
            if photoAlbum.isEmpty {
                weakSelf.photoAlbumPopulating.setState(state: .noImagesFound)
            } else {
                weakSelf.photoAlbumPopulating.setState(state: .displayImages)
                weakSelf.reloadPhotos()
            }
            
            weakSelf.setUpButtons(enabled: true)
        }
    }
    
    
    func configurePhotoAlbum(){
        guard let pin = pin, let album = pin.toAlbum else {
            showAlert(title: "Cannot load photo album", message: "Please try again")
            fatalError("Missing pin")
        }
        // set up all views and buttons
        setUpAlbumMapView()
        setUpCollectionView()
        setUpButtons(enabled: false)
        setUpAlbumStatusView()

        if album.isEmpty {
            downloadImages()
        } else {
            photoAlbumPopulating.setState(state: .displayImages)
            setUpButtons(enabled: true)
        }

        photosFetchedResultsController =  photoPersistence.getFetchedResultsController(forAlbum: album, fromContext: dataController.viewContext)
        
        photosFetchedResultsController.delegate = self
        
    }
    
    
    
    /// Fetch album from core data and reload the collection view.
    fileprivate func reloadPhotos(){

        do {
            try photosFetchedResultsController.performFetch()
        } catch {
            fatalError("Unable to fetch photos: \(error.localizedDescription)")
        }
        collectionView.reloadData()
    }
    
    /// Set Up the initial AlbumStatusView.
    fileprivate func setUpAlbumStatusView() {
        photoAlbumPopulating = PhotoAlbumPopulating(frame: self.collectionView.frame)
        photoAlbumPopulating.setState(state: .downloading)
        self.view.addSubview(photoAlbumPopulating)
    }

    /// Set the new collection button and delete button funtionality.
    /// - Parameter enabled: Enable or disable the buttons.
    fileprivate func setUpButtons(enabled: Bool){
        deleteButton.isEnabled = enabled
        newCollectionButton.isEnabled = enabled
    }


    //MARK:- IBActions

    @IBAction func deleteButtonPressed(_ sender: Any) {
        pinPersistence.deletePin(pin: self.pin, fromContext: self.dataController.viewContext)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        guard let album = pin.toAlbum else { return }
         guard album.totalPages > 1 else {
            self.showAlert(title: "No more images available", message: "Flickr has no more photos for this location")
             return
         }

         newCollectionButton.isEnabled = false
         photoAlbumPopulating.setState(state: .downloading)

         photosFetchedResultsController.fetchedObjects?.forEach { (photo) in
            self.dataController.viewContext.delete(photo)
         }
         
         do {
            try self.dataController.viewContext.save()
         } catch {
             print("Unable to save context after clearing album")
         }

         let currentPage = Int(album.currentPage)
         let totalPages = Int(album.totalPages)

         var nextPage: Int

         // If the randomly generated number happens to be the same page as current, get a different random number.
         repeat {
             nextPage = Int.random(in: 1...totalPages)
         } while nextPage == currentPage

         downloadImages(forPage: nextPage)
        
    }
    
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //END of class
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {

    // MARK: Fetched results controller delegate methods

    func fetchedResultsController(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
        ) {
        switch type {
        case .delete:
            collectionView.deleteItems(at: [indexPath!])

        default: break
        }
    }
}




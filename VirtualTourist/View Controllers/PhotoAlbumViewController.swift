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
    
    @IBOutlet weak var collectionViewCell: UICollectionViewCell!
    
    
    //MARK: Controller Properties
            
    var dataController:DataController!
    
    /// The fetched results controller in charge of populating the collection view.
    var photosFetchedResultsController: NSFetchedResultsController<Photo>!
        
    var pin: Pin!

    /// The reuse identifier of the collection cells.
    private let reuseIdentifier = "cellPhoto"


    override func viewDidLoad() {
         super.viewDidLoad()
  }

    
    //MARK:- Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let image = sender as! Photo
        let photoAlbumVC = segue.destination as! PhotoAlbumViewController
        photoAlbumVC.image = photo
        photoAlbumVC.fetchedResultsViewController = fetchedResultsController
        photoAlbumVC.fetchedResultsViewControllerDelegate = self
    }

    
    //END BRACK
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

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return (photosFetchedResultsController.sections ?? []).isEmpty ? 0 : 1
       }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photosFetchedResultsController.sections?[section].numberOfObjects ?? 0
       }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: reuseIdentifier,
        for: indexPath) as? CollectionCell else {
               preconditionFailure("The cell must be of photo type.")}
        
        cell.collectionPhoto.setPhoto(photosFetchedResultsController)
        return cell
    }







}

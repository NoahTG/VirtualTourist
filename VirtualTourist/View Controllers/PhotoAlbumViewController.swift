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
        
    
    //MARK: Controller Properties
            
    var dataController:DataController!

    /// The fetched results controller in charge of populating the collection view.
    var photosFetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var photoAlbumPopulating: PhotoAlbumPopulating!

    
    //MARK:- View Lifecycle methods
    
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



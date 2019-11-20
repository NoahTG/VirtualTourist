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
    
    //MARK: Properties
            
      // add property to hold data from persistence store
      var dataController:DataController!
    
      var photo:Photo!
    
       var pin: Pin!

       override func viewDidLoad() {
             super.viewDidLoad()
      }
    
    //END BRACK
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {

    // MARK: Fetched results controller delegate methods

    func controller(
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

//
//  PhotoAlbumVC+CollectionView.swift
//  VirtualTourist
//
//  Created by NTG on 11/21/19.
//  Copyright © 2019 NTG. All rights reserved.
//
import UIKit

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

 func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (photosFetchedResultsController.sections ?? []).isEmpty ? 0 : 1
    }

 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
 
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
     let cell = collectionView.dequeueReusableCell(
     withReuseIdentifier: "photoCell",
     for: indexPath) as? PhotoCell
     
     let currentImage = photosFetchedResultsController.object(at: indexPath)
     
     cell?.photo = currentImage
     cell?.setUpPhotoCell()
     
     DispatchQueue.main.async {
             do {
                 try self.dataController.viewContext.save()
             } catch {
                 print("Cannot save image from flickr")
             }
         }

     return cell!

     }

     /// Set up the Collection View.
     func setUpCollectionView() {
         // Set up Collection View
         collectionView.dataSource = self
         collectionView.delegate = self
         configureFlowLayout()
     }
    
    
    /// Set up the flow layout for the Collection View.
    func configureFlowLayout() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellSideLength = (collectionView.frame.width/3) - 1
            flowLayout.itemSize = CGSize(width: cellSideLength, height: cellSideLength)
        }
    }
    
}

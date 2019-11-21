//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by NTG on 11/20/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoLoadingActivityIndicator: UIActivityIndicatorView!
    
// MARK:- Class Properties
    public static let reuseId = "photoCell"
    var photo: Photo!
    var flickrClient: FlickrClient!
    var pin: Pin!

    // MARK:- Class Methods
    
    // Set up  view by downloading or reusing photos that are downloaded.
    func setUpPhotoCell() {
        if #available(iOS 13.0, *) {
            photoLoadingActivityIndicator.style = .large
        } else {
            photoLoadingActivityIndicator.style = .whiteLarge
        }

        photoLoadingActivityIndicator.startAnimating()

        // Populate cell imageview
        if let data = photo.imageData {
            // Photo data already exists in photo object. But has not yet been converted to a UIImage
            let image = UIImage(data: data)
            imageView.image = image
            photoLoadingActivityIndicator.stopAnimating()
        } else {
            // No photo currently downloaded. Request image from flickr
            photoLoadingActivityIndicator.startAnimating()
                        
            flickrClient.downloadPhotoFromFlickr(fromUrl: photo.imageUrl!){ [weak self] (imageData, url, error)
                in
                guard let weakSelf = self else { return }
                            
                guard let imageData = imageData else {
                    preconditionFailure("Failed to download image: \(error.debugDescription)")
                }

                DispatchQueue.main.async {
                    if url != weakSelf.photo.imageUrl?.absoluteString {
                        return
                    }

                    weakSelf.photo.imageData = imageData.jpegData(compressionQuality: 1)
                    weakSelf.imageView.image = imageData
                    weakSelf.activityIndicator.stopAnimating()
                    }
            }
        }
    }
    
    // MARK: Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage()
        self.photoLoadingActivityIndicator.startAnimating()
    }
}

    
    
    


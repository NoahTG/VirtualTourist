//
//  PhotoAlbumPopulating.swift
//  VirtualTourist
//
//  Created by NTG on 11/21/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import UIKit


 // Updates stats of photo album populating
class PhotoAlbumPopulating : UIView {
    
    // MARK: Class Properties
    var activityIndicator: UIActivityIndicatorView!
    var activityStatusLabel: UILabel!
    
    
    enum State: String {
        case noImagesFound = "No Images found for this location."
        case downloading = "Downloading Images..."
        case displayImages
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Class Methods


    /// Set up a new AlbumStatusView.
    func setUpView() {
        // Set up label
        activityStatusLabel = UILabel()
        addSubview(activityStatusLabel)
        activityStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        activityStatusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityStatusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activityStatusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        activityStatusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        activityStatusLabel.sizeToFit()
        activityStatusLabel.textAlignment = .center
        
        // Set up activity indicator
        activityIndicator = UIActivityIndicatorView()

        if #available(iOS 13.0, *){
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
            activityIndicator.color = .black
        }
        

        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: activityStatusLabel.topAnchor, constant: -10).isActive = true

    }

    /// Set the state of the album status.
    /// - Parameter state: Album status view state.
    func setState(state: State) {
        switch state {
        case .downloading:
            activityIndicator.startAnimating()
            activityStatusLabel.text = state.rawValue
            self.isHidden = false
        case .noImagesFound:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            activityStatusLabel.text = state.rawValue
            self.isHidden = false
        case .displayImages:
            activityIndicator.stopAnimating()
            self.isHidden = true
        }
    }



}


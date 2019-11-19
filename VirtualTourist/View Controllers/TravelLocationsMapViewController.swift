//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by NTG on 11/3/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import MapKit
import CoreData
import UIKit

class TravelLocationsMapViewController: UIViewController {
    
    //MARK: Properties
            
      // add property to hold data from persistence store
    var dataController:DataController!
    
    // protocol for pulling photos from Flickr and populating album
    var flickrClient: FlickrClientProtocol
    
    // protocol for persisting new pin
    var pinPersistence: PinPersitenceProtocol
    
    // protocol for persisting photo album associated with pin
    var albumPersistence: AlbumPersistenceProtocol
    
   // MARK: Life Cycle

       override func viewDidLoad() {
             super.viewDidLoad()
      }
    
    
    
    
    
    
    
    
    
}



extension

var annotations = [MKPointAnnotation]()

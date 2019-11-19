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
        
        mapView.delegate = self
        
      }
    
    
    
    
    
    
    
    
    
    
}



extension

var annotations = [MKPointAnnotation]()




extension MKMapView {
    /// Set all map interaction on or off
    /// - Parameter enabled: Whether to enable or disable map interaction.
    func isInteractionEnabled(_ enabled: Bool) {
        isScrollEnabled = enabled
        isZoomEnabled = enabled
        isPitchEnabled = enabled
        isRotateEnabled = enabled
    }

    // Add  pin managed object to the Map View.
    // - Parameter pin: Pin Managed Object to be added.
    func addPinAnnotation(pin: Pin){
        addAnnotation(PinAnnotations(pin: pin))
    }

    // Clear annotations from the map.
    func clearAnnotations(){
        removeAnnotations(annotations)
    }
}

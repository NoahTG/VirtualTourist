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
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           loadPins()
       }

    
    
    //MARK:- Class Methods
    
    
    

    
    /// Loads persisted pins on the map.
       private func loadPins() {
           mapView.deleteAnnotations()

           // Make the fetch for pins and add them to the map.
           let request: NSFetchRequest<Pin> = Pin.fetchRequest()
           request.sortDescriptors = [
               NSSortDescriptor(key: "creationDate", ascending: false)
           ]

           dataController.viewContext.perform {
               do {
                   let pins = try self.dataController.viewContext.fetch(request)
                   self.mapView.addAnnotations(pins.map { pin in PinAnnotations(pin: pin) })
               } catch {
                self.showAlert(title: "Error!", message: "Can't load pins!")
               }
           }
       }
    
    
    //MARK:- IBActions
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {

        if sender.state == .began{
            // Update Instruction Label
            instructionLabel.setState(.releaseToAddPin)

        } else if sender.state == .ended {
            // Get the coordinates of the tapped location on the map.
            let locationCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            instructionLabel.setState(.readyForNewPin)
            createGeocodedAnnotation(from: locationCoordinate)
        }
    }
    
    
    //MARK:- Segue
    
   func prepareSegue(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoAlbumViewController = segue.destination as? PhotoAlbumViewController else { return }

        let newPinAnnotation: PinAnnotations = sender as! PinAnnotations

        photoAlbumViewController.pin = newPinAnnotation.pin
    }
    
    
    
    
    
    
//CLOSING BRACKET
}






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
    func deleteAnnotations(){
        removeAnnotations(annotations)
    }
}


extension MKMapViewDelegate {
    
    
    
    
    
}

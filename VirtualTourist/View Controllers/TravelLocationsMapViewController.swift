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
    
    // MARK:- IBOutlets
    
    

    //MARK: Properties
            
      // add property to hold data from persistence store
    var dataController:DataController!
    
    var pinPersistence: PinPersistence
    
    var savedLocationKey: String = "persistedMapView"
    //var presentLocation: [String : CLLocationDegrees]
    
   // MARK: Life Cycle

   override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self
            loadPersistedMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           loadPins()
       }
        
    // MARK: Imperatives

    
    ///  Creates a new pin and persists it using a coordinate.
       /// - Parameter coordinate: the user's  long press gesture creates a new coordinate for a persisted pin
    private func createNewPin(for coordinate: CLLocationCoordinate2D){
        
        // Geocode coordinate to get more data
        let geocoder = CLGeocoder()
        
        // assign coord values
         let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard let placemark = placemarks?.first else { return }
            let locationName = placemark.name ?? "Location TBD"
            
            let newPin = self.pinPersistence.createPin(
                usingContext: self.dataController.viewContext,
                withLocation: locationName,
                andCoordinate: coordinate)
            
            // assign title to new pin
            let annotatedPin = PinAnnotations(pin: newPin)
            annotatedPin.title = locationName
            
            // Save new pin
            do {
                try self.dataController.save()
            } catch {
                self.showAlert(title: "Cannot Save Pin", message: "\(error)")
            }
    
            //add pin to map
            self.mapView.addAnnotation(annotatedPin)
                                      
            }
    }
        
        
        
    /// Loads persisted pins on the map.
       private func loadPins() {
           // delete old pins
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
    
    

     //MARK:- Segue
     
    func prepareSegue(for segue: UIStoryboardSegue, sender: Any?) {
         guard let photoAlbumViewController = segue.destination as? PhotoAlbumViewController else { return }

         let newPinAnnotation: PinAnnotations = sender as! PinAnnotations

         photoAlbumViewController.pin = newPinAnnotation.pin
     }
     
    
    //MARK:- IBActions
    
    @IBAction func addNewPin(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let tappedMapCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            createNewPin(for: tappedMapCoordinate)
        default:
            break
        }
    }
    
//CLOSING BRACKET
}

extension TravelLocationsMapViewController: MKMapViewDelegate {
            
    func setMapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        // persist the annonation and title it
        let pinAnnotation = annotation as! PinAnnotations
        pinAnnotation.title = pinAnnotation.pin.locationName

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.markerTintColor = .green

        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
 
    // Persist map view location in user defaults
    func PersistMapView() {
        let location = [
            "long":mapView.centerCoordinate.longitude,
            "lat":mapView.centerCoordinate.latitude,
            "latDelta":mapView.region.span.latitudeDelta,
            "longDelta":mapView.region.span.longitudeDelta
        ]
        
        UserDefaults.standard.set(location, forKey: savedLocationKey)
    }
    
    // Persist mapview if changess
    func mapViewDidChange(_ mapView: MKMapView) {
        PersistMapView()
    }


    func loadPersistedMapView() {
         // call up last mapView
        if let mapRegion = UserDefaults.standard.dictionary(forKey: savedLocationKey) {
              // retrieve stored positions and map span
             let mapData = mapRegion as! [String : CLLocationDegrees]
             let center = CLLocationCoordinate2D(latitude: mapData["lat"]!,longitude: mapData["long"]!)
             let span = MKCoordinateSpan(latitudeDelta: mapData["latDelta"]!, longitudeDelta: mapData["longDelta"]!)
             
             // load persisted map
             mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
         }
     }
     
    
    // go to segue
    func mapViewDidSelect(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        let pinAnnotation = annotation as! PinAnnotations

        performSegue(withIdentifier: "showPhotoAlbum", sender: pinAnnotation)
          
        // sets delay for de-selected annotation after closing album view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }
  
        
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

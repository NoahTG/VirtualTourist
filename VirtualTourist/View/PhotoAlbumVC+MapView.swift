//
//  PhotoAlbumVC+MapView.swift
//  VirtualTourist
//
//  Created by NTG on 11/21/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import MapKit

extension PhotoAlbumViewController: MKMapViewDelegate {
    
    
// Set up map just like the travel map VC but no need to persist annotation
    func albumMapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.markerTintColor = .green
        } else {
            pinView!.annotation = annotation
        }

        // Specify selected pin for map
        pinView?.isSelected = true
        pinView?.isUserInteractionEnabled = false

        return pinView
    }
    

    /// Set up the Album MapView.
    func setUpAlbumMapView(){
        mapView.delegate = self
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.isInteractionEnabled(false)
        mapView.addAnnotation(PinAnnotations(pin: pin))
    }
    
}

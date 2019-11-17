//
//  PinAnnotations.swift
//  VirtualTourist
//
//  Created by NTG on 11/17/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotations: MKPointAnnotation {
    
    var pin: Pin
    
    init(pin: Pin){
        self.pin = pin
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }

    
}

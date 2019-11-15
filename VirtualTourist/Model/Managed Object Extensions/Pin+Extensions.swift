//
//  Pin+Extentions.swift
//  VirtualTourist
//
//  Created by NTG on 11/3/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import MapKit

extension Pin: MKAnnotation  {
    
    //called on initial object creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    
        }
        
    // set coordinates
    public var coordinate : CLLocationCoordinate2D{
        set{
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    func compare(to cordinates: CLLocationCoordinate2D) -> Bool {
        return (latitude == cordinates.latitude && longitude == cordinates.longitude)
    }
    
    
}

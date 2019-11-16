//
//  Pin+Extentions.swift
//  VirtualTourist
//
//  Created by NTG on 11/3/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Pin  {
    
    // MARK: Life cycle
    //called on initial object creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
        self.toAlbum = Album(context: managedObjectContext!)
        }

// A store in charge of creating new Pin  instances and persisting them using core data.

    
}



protocol PinPersitenceProtocol {

    // MARK: Imperatives

    /// Creates and persists a pin object.
    /// - Parameters:
    ///     - context: the managed object context used to persist the pin.
    ///     - namet: the name of the location associated with the pin.
    ///     - coordinate: the coordinates of the pin.
    /// - Returns: the created pin object.
    func createPin(
        usingContext context: NSManagedObjectContext,
        withLocatione location: String?,
        andCoordinate coordinate: CLLocationCoordinate2D
    ) -> Pin
    
    /// Deletes the specified pin object.
    /// - Parameters:
    ///        - pin: the pin that will be deleted.
    ///     - context: the NSManagedObjectContext responsible for the pin.
    func deletePin(pin: Pin, fromContext context: NSManagedObjectContext)
}

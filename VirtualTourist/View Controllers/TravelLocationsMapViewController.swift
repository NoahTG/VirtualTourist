//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by NTG on 11/3/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import UIKit

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
            
      // add property to hold data from persistence store
      var dataController:DataController!
    
      var pin:Pin!
    
      var annotations = [MKPointAnnotation]()

       override func viewDidLoad() {
        
             super.viewDidLoad()
      }
    
    
    
}

//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by NTG on 11/3/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "VirtualTourist")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
          // inject datacontroller dependency into vc
        
          let navigationController = window?.rootViewController as! UINavigationController
          let travelVC = navigationController.topViewController as! TravelLocationsMapViewController
          travelVC.dataController = dataController
        
        dataController.load()

        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            saveViewContex()
        
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
           saveViewContex()
       }
    
    func saveViewContex() {
        try? dataController.viewContext.save()
        
    }

}


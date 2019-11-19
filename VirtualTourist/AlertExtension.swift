//
//  AlertExtension.swift
//  VirtualTourist
//
//  Created by NTG on 11/5/19.
//  Copyright © 2019 NTG. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {
    
    
    // Reusable method for presenting a standard Error Alert.
    /// - Parameter title: Title Bar Message.
    /// - Parameter message: Detailed body message.
   
    func showAlert(title: String, message: String?){
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK",
                                        style: .default,
                                        handler: nil))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

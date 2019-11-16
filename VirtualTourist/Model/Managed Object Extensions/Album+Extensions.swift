//
//  Album+Extensions.swift
//  VirtualTourist
//
//  Created by NTG on 11/16/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import CoreData

extension Album {
    
    // MARK: Life cycle
    
    override public func awakeFromInsert() {
          super.awakeFromInsert()

          creationDate = Date()
          id = UUID().uuidString
    }
}




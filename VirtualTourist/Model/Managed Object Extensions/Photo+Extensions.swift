//
//  Photo+Extensions.swift
//  VirtualTourist
//
//  Created by NTG on 11/5/19.
//  Copyright © 2019 NTG. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    //called on initial object creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    
        }
}

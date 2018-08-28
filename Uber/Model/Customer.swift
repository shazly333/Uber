//
//  Customer.swift
//  Uber
//
//  Created by El-Shazly on 8/1/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import Foundation
import MapKit
class Customer {
    let name: String
    var location : CLLocationCoordinate2D?
    var destionation : CLLocationCoordinate2D?
    init(hisName name: String) {
        self.name = name
    }
    
}

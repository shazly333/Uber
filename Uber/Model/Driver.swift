//
//  Driver.swift
//  Uber
//
//  Created by El-Shazly on 8/1/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import Foundation
import MapKit
class Driver  {
    let name: String
    var location : CLLocationCoordinate2D?
    var isFree : Bool = true
    init(hisName name: String) {
        self.name = name
    }
    
}

//
//  Request.swift
//  Uber
//
//  Created by El-Shazly on 8/25/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import Foundation
import MapKit
import Firebase
import GeoFire
import Alamofire
import SwiftyJSON
import SVProgressHUD

class Request{
    static var request = Request()
    var geoFireRef: DatabaseReference!
    var geoFire: GeoFire!
    var startLocation = CLLocation()
    var distance = 0.0
    var driverId = ""

    private init(){
        
    }
    
    func makeRequest(myLocation customerLocation: CLLocation) {
        geoFireRef = Database.database().reference().child("AvailableDrivers")
        geoFire = GeoFire(firebaseRef: geoFireRef)
        var userId = ""
        let circleQuery = geoFire!.query(at: customerLocation, withRadius: Double(1))
        for i in 1...1000 {
            circleQuery.center = customerLocation
            circleQuery.radius = Double(i)
            circleQuery.observe(GFEventType.keyEntered, with: { (key, location) in
                if userId == ""{
                    userId = key
                    Database.database().reference().child("Drivers/\(userId)").setValue(["longitude":customerLocation.coordinate.longitude, "latitude": customerLocation.coordinate.latitude])
                    self.driverId = userId
                    SVProgressHUD.dismiss()
                    
                }
                
                circleQuery.removeAllObservers()
            })
        }
    }
    
    
    func getPath(startLocation: CLLocation, endLocation: CLLocation) -> String {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        self.startLocation = startLocation
        return url
    }
    func getRequset(){
        DriverMap.driverNotAvailable(stopUpdateLocation: false)
        
    }
    func pickupCustomer(){
        Database.database().reference().child("Drivers/\((Auth.auth().currentUser?.uid)!)/").removeValue()

    }
    func dropDownCustomer()->Int{
        Database.database().reference().child("Request/\((Auth.auth().currentUser?.uid)!)/").removeValue()
        let cost = distance*0.000002
        distance = 0
        return Int(cost)
    }
    func newPoint(currentLocation newPoint: CLLocation){
        
        distance = distance + startLocation.distance(from: newPoint)
        startLocation = newPoint
        Database.database().reference().child("Request/\((Auth.auth().currentUser?.uid)!)/").setValue(["latitude": newPoint.coordinate.latitude, "longitude": newPoint.coordinate.longitude])
    }

}

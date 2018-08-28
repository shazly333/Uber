//
//  CustomerMap.swift
//  Uber
//
//  Created by El-Shazly on 8/22/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import FirebaseAuth
import FirebaseDatabase
import GeoFire
import SVProgressHUD
class CustomerMap: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
   
    var mapView:GMSMapView!
    let locationManager = CLLocationManager()
    var geoFireRef: DatabaseReference!
    var geoFire: GeoFire!
    var customerLocation = CLLocation()
    var firstUpdate = true
    @IBOutlet weak var map: UIView!
    var marker : GMSMarker? = nil
    var firstzoom = true

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = self.view as! GMSMapView? 
        self.mapView.delegate = self
        self.view = mapView

        /// get user location
        DriverMap.locationManager.delegate = self
        DriverMap.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        DriverMap.locationManager.requestWhenInUseAuthorization()
        DriverMap.locationManager.startUpdatingLocation()


    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        customerLocation = (manager.location)!
        if firstUpdate {
            firstUpdate = false
            let camera=GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 14)
            mapView.camera = camera
        }

        if marker == nil {
            marker = GMSMarker()
            marker?.position = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
            marker?.map = mapView
        }
        else{
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            marker?.position = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
            CATransaction.commit()
        }
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func orderDriver(_ sender: Any) {
        Request.request.makeRequest(myLocation: customerLocation)
        locationManager.stopUpdatingLocation()
        SVProgressHUD.show()
        var latitude=0.0
        Database.database().reference().child("Request/\(Request.request.driverId)/latitude").observe(.value) { (snapShot) in
            if snapShot.key == "latitude"{
                if let request = (snapShot.value)  {
                    if let q = request as? Double{
                        latitude = q

                    }
                }
            }
        }
        Database.database().reference().child("Request/\(Request.request.driverId)/longitude").observe(.value) { (snapShot) in

             if snapShot.key == "longitude" {
                if let value = (snapShot.value)  {
                    if let request = value as? Double{
                        print("Observe")
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(1.0)
                        self.marker?.position = CLLocationCoordinate2DMake(latitude,request)
                        CATransaction.commit()
                        if self.firstzoom {
                            self.firstzoom = false
                            let camera=GMSCameraPosition.camera(withLatitude: latitude, longitude: request, zoom: 14)
                            self.mapView = self.view as! GMSMapView?
                            self.mapView.camera = camera
                    }
                        self.marker?.map = self.mapView
                    }
                
                }
            }
        }
    }
        
    
    @IBAction func logOut(_ sender: Any) {
        Database.database().reference().child("Drivers/\((Auth.auth().currentUser?.uid)!)").removeAllObservers()
        AppDelegate.logOut()
        dismiss(animated: true, completion: nil)
    }
    
}

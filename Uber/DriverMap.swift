//
//  DriverMap.swift
//  Uber
//
//  Created by El-Shazly on 8/22/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GoogleMaps
import FirebaseAuth
import FirebaseDatabase
import GeoFire
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DriverMap: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var mapView:GMSMapView!
    static let locationManager = CLLocationManager()
    static var geoFireRef: DatabaseReference!
    static var geoFire: GeoFire!
    var requestLocation = CLLocation(latitude: 0, longitude: 0)
    var marker : GMSMarker? = nil
    var getRequest = false
    var polyline: GMSPolyline? = nil
    var firstUpdate = true
    var customerMarker: GMSMarker? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = self.view as! GMSMapView?
        self.mapView.delegate = self
        self.view = mapView

        DriverMap.locationManager.delegate = self
        DriverMap.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        DriverMap.locationManager.requestWhenInUseAuthorization()
        DriverMap.locationManager.startUpdatingLocation()
        DriverMap.geoFireRef = Database.database().reference().child("AvailableDrivers")
        DriverMap.geoFire = GeoFire(firebaseRef: DriverMap.geoFireRef)
        
        
        // Observe Request
        Database.database().reference().child("Drivers/\((Auth.auth().currentUser?.uid)!)").observe(.childAdded) { (snapShot) in
            let request = (snapShot.value)! as! Double
            if snapShot.key == "latitude"{
                self.requestLocation = CLLocation(latitude: request, longitude: self.requestLocation.coordinate.longitude)
            }
            else{
                self.requestLocation = CLLocation(latitude: self.requestLocation.coordinate.latitude, longitude: request)
                self.getRequest = true
                
            }
        }
        
    }
    //MARK:- Update Location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (manager.location) != nil {
            DriverMap.geoFire.setLocation(CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!), forKey: (Auth.auth().currentUser?.uid)!)
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
            if getRequest == true{
                Request.request.newPoint(currentLocation: manager.location!)
                drawPath(startLocation: (manager.location)!, endLocation: requestLocation)
            }
        }
    }
    //MARK:- Driver Available??
    
    static func driverNotAvailable(stopUpdateLocation: Bool){
        Database.database().reference().child("AvailableDrivers/\((Auth.auth().currentUser?.uid)!)/").removeValue()
        geoFire.removeKey((Auth.auth().currentUser?.uid)!)
        if stopUpdateLocation == true{
            DriverMap.locationManager.stopUpdatingLocation()
        }
    }
    static func driverAvailable(){
        DriverMap.locationManager.startUpdatingLocation()
    }
    
    //MARK:- Drawing Path

    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let url = Request.request.getPath(startLocation: startLocation, endLocation: endLocation)
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue

            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                 self.polyline?.map = nil
                self.polyline = GMSPolyline.init(path: path)
                self.polyline!.strokeWidth = 4
                self.polyline!.strokeColor = UIColor.red
                self.polyline!.map = self.mapView
                
            }
            
        }
         customerMarker = GMSMarker(position: CLLocationCoordinate2DMake(endLocation.coordinate.latitude, endLocation.coordinate.longitude))
        customerMarker?.map = mapView
    }
    
    //MARK:- Pick Customer And Drop Him Down

    @IBAction func PickUpCustomer(_ sender: Any) {
        getRequest = false
        polyline?.map = nil
        customerMarker?.map = nil
        Request.request.pickupCustomer()
        
    }
    

    @IBAction func DropDown(_ sender: Any) {
        let price = Request.request.dropDownCustomer()
        let alert = UIAlertController(title: "The Cost is \(price) $", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    @IBAction func logOut(_ sender: Any) {
        Database.database().reference().child("Drivers/\((Auth.auth().currentUser?.uid)!)").removeAllObservers()
        AppDelegate.logOut()
        DriverMap.locationManager.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }
}

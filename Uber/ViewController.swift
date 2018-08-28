//
//  ViewController.swift
//  Uber
//
//  Created by El-Shazly on 8/1/18.
//  Copyright © 2018 Shazly. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import FirebaseAuth
import FirebaseDatabase
import GeoFire

class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    var mapView:GMSMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var TopButton: UIButton!
    @IBOutlet weak var LowerButton: UIButton!
    @IBOutlet weak var DriverLabel: UILabel!
    @IBOutlet weak var CustomerLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var DriverCustomerSwitch: UISwitch!
    var signUpMode = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera=GMSCameraPosition.camera(withLatitude: 27.18096, longitude: 31.18368, zoom: 10)
        mapView=GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.delegate = self
        /// get user location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate =  self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.camera = camera
       // self.view=mapView
      

    }
    
    
@IBAction func topButtonClicked(_ sender: Any) {
    if EmailTextField.text == "" || PasswordField.text == "" {
    displayAlert(title:  "Missing Information", message: "You must provide both a email and password")
    }
    if let email = EmailTextField.text, let password = PasswordField.text {
        if signUpMode {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    print("Sign Up Success")
                    if self.DriverCustomerSwitch.isOn {
                        // DRIVER
                        let req = Auth.auth().currentUser?.createProfileChangeRequest()
                        req?.displayName = "Driver"
                        req?.commitChanges(completion: nil)
                        Database.database().reference().child("Drivers/\((Auth.auth().currentUser?.uid)!)").setValue((Auth.auth().currentUser?.uid)!)
                        self.performSegue(withIdentifier: "DriverMap", sender: nil)
                    } else {
                        // RIDER
                        let req = Auth.auth().currentUser?.createProfileChangeRequest()
                        req?.displayName = "Rider"
                        req?.commitChanges(completion: nil)
                        self.performSegue(withIdentifier: "CustomerMap", sender: nil)
                    }
                    
                }
            })
        } else {
            // LOG IN
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    print("Log In Success")
                    let name = Auth.auth().currentUser?.displayName
                    if name == "Driver" {
                        // DRIVER
                        Database.database().reference().child("AvailabeDirvers")
                        self.performSegue(withIdentifier: "DriverMap", sender: nil)
                    } else {
                        // RIDER
                        self.performSegue(withIdentifier: "CustomerMap", sender: nil)
                    }
                }
            })
        }
        
        
    }
    
    
    
}
func displayAlert(title:String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
    self.present(alert,animated: true,completion: nil)
    
    
}
    @IBAction func lowerButtonClicked(_ sender: Any) {
        
        if signUpMode {
            TopButton.setTitle("Sign In", for: .normal)
            LowerButton.setTitle("Sign Up", for: .normal)
            CustomerLabel.isHidden = true
            DriverLabel.isHidden = true
            DriverCustomerSwitch.isHidden = true
            signUpMode = false
        } else {
            TopButton.setTitle("Sign Up", for: .normal)
            LowerButton.setTitle("Sign In", for: .normal)
            CustomerLabel.isHidden = false
            DriverLabel.isHidden = false
            DriverCustomerSwitch.isHidden = false
            signUpMode = true
        }
        
    }



}


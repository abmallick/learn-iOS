//
//  ViewController.swift
//  Location Tracker
//
//  Created by Abhinav Kumar on 23/01/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.checkAccess()
    }
    
    func checkAccess() -> Void {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined, .denied:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    @IBAction func showLocation(_ sender: Any) {
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            latitude.text = String(location.coordinate.latitude)
            longitude.text = String(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Failure", message: "Enable location access", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

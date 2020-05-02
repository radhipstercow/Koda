//
//  MapViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/14/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
        
    var locationManager:CLLocationManager?
    var lastKnownLocation:CLLocation?
    
    var shop:Shop?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show the blue dot for theuser if the location is known
        mapView.showsUserLocation = true
        
        // Create and configure the location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check for a place and plot the pin
        if shop != nil {
            plotPin(shop!)
        }
    }
    
    func plotPin(_ s:Shop) {
        
        // Create the pin
        let pin = MKPointAnnotation()
        
        CLGeocoder().geocodeAddressString(s.address!) {place, error in
            
            if let lat = place?.first?.location?.coordinate.latitude, let long = place?.first?.location?.coordinate.longitude {
                
                pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                pin.title = s.shopName!
                
                // Add the pin
                self.mapView.addAnnotation(pin)
                
                // Center the map around the pin
                self.mapView.showAnnotations([pin], animated: true)

            }
        }
            
    }
    
    func showGeoLocationError() {
        
        // Create the error alert
        let alert = UIAlertController(title: "Geolocation failed", message: "Location serivices are turned off or this app doesn't have permission to geolocatate. Check your setting to continue.", preferredStyle: .alert)
        
        // Create the settings button
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alert) in
            
            let url = URL(string: UIApplication.openSettingsURLString)
            
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(settingsAction)
        
        // Create the cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        // Dismiss the map view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goTapped(_ sender: Any) {
        
        guard shop != nil && shop!.address != nil else {
            return
        }
        
        // Replace all spaces with +
        let newAddress = shop!.address!.replacingOccurrences(of: " ", with: "+")
        
        let url = URL(string: "http://maps.apple.com/?address=" + newAddress)
        
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func myLocationTapped(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Check the authorization status
            let status = CLLocationManager.authorizationStatus()
        
            if status == .denied || status == .restricted {
                
                // Show the error popup
                showGeoLocationError()
                
            }
            else if status == .authorizedWhenInUse || status == .authorizedAlways {
                
                // Start geolocating the user
                locationManager?.startUpdatingLocation()
                
                // Center the map around the last known location
                if let lastKnownLocation = lastKnownLocation {
                    mapView.setCenter(lastKnownLocation.coordinate, animated: true)
                }
                
            }
            else if status == .notDetermined {
                
                // Ask the user for permission
                locationManager?.requestWhenInUseAuthorization()
                
            }
        }
        else {
            
            // Location services turned off
            showGeoLocationError()
        }
    }
    
    
}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        if let location = location {
            
            // Center the map around this location, only if it's the first time location the user
            if lastKnownLocation == nil {
                mapView.setCenter(location.coordinate, animated: true)
            }
            
            lastKnownLocation = location
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .denied || status == .restricted {
            
            // User chose don't allow
            showGeoLocationError()
            
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            // Start locationg the user
            locationManager?.startUpdatingLocation()
        }
    }
}

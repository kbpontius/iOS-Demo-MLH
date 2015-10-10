//
//  Locator.swift
//  iOS-MLH-Demo
//
//  Created by Kyle on 10/10/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import Foundation
import CoreLocation

class Locator: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let locationDelegate: LocationDelegate!
    let errorDelegate: ErrorHandlingDelegate!
    var currentLocation: CLLocationCoordinate2D?
    
    init(errorHandlingDelegate: ErrorHandlingDelegate, locationDelegate: LocationDelegate) {
        self.errorDelegate = errorHandlingDelegate
        self.locationDelegate = locationDelegate
        super.init()
        
        setupLocationManager()
    }
    
    // MARK: - LOCATION MANAGER METHODS
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == CLAuthorizationStatus.Denied {
            let message = "You tied me up! I'm not allowed to retrieve your GPS location. \nPlease Check GPS Permission: \nSettings > Privacy \n> Location Services > \"Stormy\""
            errorDelegate.showError("GPS Error", message: message)
        }
        else if status == CLAuthorizationStatus.Restricted {
            let message = "Oh no! The parental permissions have denied me GPS permission. \nPlease Check GPS Permission: \nGeneral > Restrictions \n> Location Services > \"Stormy\""
            
            errorDelegate.showError("Restrictions Error", message: message)
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        getLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        locationDelegate.receivedLocation(newLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - HELPER METHODS
    func getPlacemarkFromLocation(location: CLLocation, onCompletion: (String)->Void) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Reverse geodcode lookup fail: \(error!.localizedDescription)")
            }
            else {
                let result = placemarks![0] as CLPlacemark
                
                // Dictionary containing formatted placemark information. (e.g. "Street", "City", "State", etc)
                var locationDictionary = result.addressDictionary
                let cityName: AnyObject = locationDictionary!["City"]!
                let stateName: AnyObject = locationDictionary!["State"]!
                
                onCompletion("\(cityName), \(stateName)")
            }
        }
    }
}
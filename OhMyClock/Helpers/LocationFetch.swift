//
//  LocationFetch.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-15.
//

import CoreLocation

import CoreLocation

class LocationFetch: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completion: ((CLLocationCoordinate2D) -> Void)?

    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        completion?(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
}



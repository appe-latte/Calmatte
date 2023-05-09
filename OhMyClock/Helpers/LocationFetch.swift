//
//  LocationFetch.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-15.
//

import SwiftUI
import CoreLocation

class LocationFetch: NSObject, CLLocationManagerDelegate {
    @Published var currCity : String = ""
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse {
              locationManager.startUpdatingLocation()
          }
      }

      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location = locations.first else { return }
          print(location.coordinate.latitude)
          print(location.coordinate.longitude)

          let geoCoder = CLGeocoder()
          geoCoder.reverseGeocodeLocation(location) { placemarks, error in
              if let error = error {
                  print(error.localizedDescription)
              } else if let placemark = placemarks?.first {
                  if let city = placemark.locality {
                      DispatchQueue.main.async {
                          self.currCity = city
                      }
                  }
              }
          }

          locationManager.stopUpdatingLocation()
      }
}



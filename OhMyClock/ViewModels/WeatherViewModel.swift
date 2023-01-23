//
//  WeatherViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import Foundation
import CoreLocation

class WeatherViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var title : String = "_"
    @Published var descriptionText : String = "_"
    @Published var temp : String = "_"
    @Published var timezone : String = "_"
    @Published var feels_like : String = "_"
    @Published var humidity : String = "_"
    
    @State var latitude : Double = 0.0
    @State var longitude : Double = 0.0
    let locationManager = CLLocationManager()
    let weatherAPI = WeatherAPI()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        fetchWeather()
    }
    
    func fetchWeather() {
        weatherAPI.fetchWeather(latitude: self.latitude, longitude: self.longitude) { weather in
            DispatchQueue.main.async {
                self.title = weather.current.weather.first?.main ?? "Missing Title"
                self.descriptionText = weather.current.weather.first?.description ?? "Missing Title"
                self.temp = "\(weather.current.temp)°"
                self.timezone = weather.timezone
                self.feels_like = "\(weather.current.feels_like)°C"
                self.humidity = "\(weather.current.humidity)%"
            }
        }
    }
}

class WeatherAPI {
    let baseURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,daily,minutely&units=metric&appid=bd0c1f8057a7f8807d1d6df0901c2163"
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherModel) -> Void) {
        guard let url = URL(string: "\(baseURL)&lat=\(latitude)&lon=\(longitude)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(weather)
            } catch {
                print("Failed to retrieve weather data")
            }
        }
        task.resume()
    }
}

//
//  WeatherViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import Foundation

class WeatherViewModel : ObservableObject {
    @Published var title : String = "_"
    @Published var descriptionText : String = "_"
    @Published var temp : String = "_"
    @Published var timezone : String = "_"
    @Published var feels_like : String = "_"
    @Published var humidity : String = "_"
    
    init() {
        fetchWeather()
    }
    
    func fetchWeather() {
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,daily,minutely&lat=51.0501&lon=-114.0853&units=metric&appid=bd0c1f8057a7f8807d1d6df0901c2163") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // MARK: Convert to model
            do {
                let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.title = model.current.weather.first?.main ?? "Missing Title"
                    self.descriptionText = model.current.weather.first?.description ?? "Missing Title"
                    self.temp = "\(model.current.temp)°"
                    self.timezone = model.timezone
                    self.feels_like = "\(model.current.feels_like)°C"
                    self.humidity = "\(model.current.humidity)%"
                }
            }
            catch {
                print("Failed to retrieve weather data")
            }
        }
        task.resume()
    }
}


//
//  WeatherViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import Foundation

class WeatherViewModel : ObservableObject {
    @Published var temperature : Double = 0.0
    @Published var humidity : Double = 0.0
    @Published var condition : String = "N/A"
    
    func populateWeather() async {
        do {
            let weather = try await WeatherService().getWeather()
            temperature = weather.temperature
            humidity = weather.humidity
            condition = weather.conditionCode
        } catch {
            print(error)
        }
    }
}

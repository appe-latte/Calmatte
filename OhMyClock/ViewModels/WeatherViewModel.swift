//
//  WeatherViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import Foundation
import WeatherKit
import CoreLocation

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

//class WeatherViewModel: ObservableObject {
//    @Published private(set) var currTemp = String()
//    @Published private(set) var currCondition = String()
//    @Published private(set) var dailyHighLow = "H:0 L:0"
//    @Published private(set) var hourlyForecast = [HourWeather]()
//
//    private let weatherService = WeatherService()
//    private let currLocation = CLL()
//
//}

//
//  WeatherViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published private(set) var currTemp = String()
    @Published private(set) var currCondition = String()
    @Published private(set) var currWeatherSymbol = String()
    @Published private(set) var currHumidity = Double()
    @Published private(set) var dailyHigh = "H:0"
    @Published private(set) var dailyLow = "L:0"
    @Published private(set) var hourlyForecast = [HourWeather]()
    
    private let weatherService = WeatherService()
    private var currLocation: CLLocation? = nil
    
    private var timer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        startFetchingTimer()
    }
    
    deinit {
        stopFetchingTimer()
    }
    
    func startFetchingTimer() {
        // Invalidate any existing timer to prevent multiple timers running simultaneously
        stopFetchingTimer()
        
        // Schedule a new timer to fetch weather data every 30 minutes
        timer = Timer.scheduledTimer(withTimeInterval: 30 * 60, repeats: true) { [weak self] _ in
            self?.fetchWeather()
        }
    }
    
    func stopFetchingTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currLocation = location
            fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: ", error)
    }
    
    func fetchWeather() {
        guard let location = self.currLocation else { return }
        
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                DispatchQueue.main.async {
                    //                    self.currTemp = weather.currentWeather.temperature.formatted()
                    self.currTemp = String(format: "%.0f°", weather.currentWeather.temperature.value)
                    self.currHumidity = weather.currentWeather.humidity
                    self.currCondition = weather.currentWeather.condition.description
                    self.currWeatherSymbol = weather.currentWeather.symbolName
                    //                    self.dailyHigh = "High:\(weather.dailyForecast.forecast[0].highTemperature.formatted().dropLast())"
                    self.dailyHigh = "High: \(String(format: "%.0f°", weather.dailyForecast.forecast[0].highTemperature.value))"
                    //                    self.dailyLow = "Low:\(weather.dailyForecast.forecast[0].lowTemperature.formatted().dropLast())"
                    self.dailyLow = "Low: \(String(format: "%.0f°", weather.dailyForecast.forecast[0].lowTemperature.value))"
                    
                    
                    // MARK: Hourly Forecast
                    weather.hourlyForecast.forecast.forEach {
                        if self.isSameHourOrLater(date1: $0.date, date2: Date()) {
                            self.hourlyForecast.append(HourWeather(time: self.hourFormatter(date: $0.date), symbolName: $0.symbolName, temperature: "\($0.temperature.formatted().dropLast())"))
                        }
                        
                        self.objectWillChange.send()
                    }
                }
            } catch {
                print("Error fetching weather data: ", error)
            }
        }
    }
    
    // MARK: Weather function declaration
    
    func hourFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ha"
        
        let calendar = Calendar.current
        
        let inputDateComponents = calendar.dateComponents([.day, .hour], from: date)
        let currentDateComponents = calendar.dateComponents([.day, .hour], from: Date())
        
        if inputDateComponents == currentDateComponents {
            return "Now"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    func isSameHourOrLater(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(date1, to: date2, toGranularity: .hour)
        
        return comparisonResult == .orderedSame || comparisonResult == .orderedDescending
    }
    
    func dayFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let calendar = Calendar.current
        
        let inputDateComponents = calendar.dateComponents([.day], from: date)
        let currentDateComponents = calendar.dateComponents([.day], from: Date())
        
        if inputDateComponents == currentDateComponents {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
}

struct HourWeather {
    let time : String
    let symbolName : String
    let temperature : String
}

struct DayWeather: Hashable {
    let day : String
    let symbolName : String
    let lowTemperature : String
    let highTemperature : String
}

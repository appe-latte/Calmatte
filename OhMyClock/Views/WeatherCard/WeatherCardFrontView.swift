//
//  WeatherCardFrontView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-14.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherCardFrontView: View {
    @StateObject private var weatherModel = WeatherViewModel()
    let locationManager = CLLocationManager()
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    @State private var refreshTrigger = false
    @State private var temperatureLabel = ""
    @State private var humidityLabel : Double = 0.0
    @State private var conditionLabel = ""
    @State private var weatherSymbolLabel = ""
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Label("Current Weather", systemImage: "")
                    .font(.caption)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(10)
            
            HStack(spacing: 10) {
                Image(systemName: "\(weatherSymbolLabel).fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Spacer()
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 10) {
                    // MARK: Temperature
                    VStack(alignment: .leading) {
                        Text("Temperature:")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                        
                        Text("\(temperatureLabel)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                    }
                    
                    // MARK: Humidity
                    VStack(alignment: .leading) {
                        Text("Humidity:")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                        
                        Text("\(String(format: "%.0f", humidityLabel * 100))%")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                    }
                    
                    // MARK: Weather Condition
                    VStack(alignment: .leading) {
                        Text("Condition:")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                        
                        Text("\(conditionLabel)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                    }
                }
            }
            
            // MARK: WeatherKit Trademark
            HStack {
                Text("Powered by  Weather. Weather data provided by WeatherKit.")
                    .font(.system(size: 5))
                    .fontWeight(.semibold)
                    .kerning(2)
                    .textCase(.uppercase)
            }
            .padding(5)
        }
        .frame(maxWidth: screenWidth - 40, maxHeight: screenHeight * 0.25)
        .background(np_jap_indigo)
        .foregroundColor(np_white)
        .ignoresSafeArea()
        .cornerRadius(10)
        .edgesIgnoringSafeArea(.bottom)
        .padding(.bottom, 5)
        .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            //                weatherModel.fetchWeather()
        }
        .onReceive(weatherModel.objectWillChange) { _ in
            let updatedTemperature = weatherModel.currTemp
            let updatedHumidity = weatherModel.currHumidity
            let updaterWeatherSymbol = weatherModel.currWeatherSymbol
            let updatedDailyHigh = weatherModel.dailyHigh
            let updatedDailyLow = weatherModel.dailyLow
            let updatedCondition = weatherModel.currCondition
            let updatedForecast = weatherModel.hourlyForecast
            
            // MARK: Update Weather data
            temperatureLabel = "\(updatedTemperature)"
            humidityLabel = updatedHumidity
            conditionLabel = "\(updatedCondition)"
            weatherSymbolLabel = "\(updaterWeatherSymbol)"
        }
        .onAppear {
            // Start the timer to refresh the view every 10 minutes
            Timer.scheduledTimer(withTimeInterval: 10 * 60, repeats: true) { _ in
                refreshTrigger.toggle()
            }
        }
        .onChange(of: refreshTrigger) { _ in
            weatherModel.fetchWeather()
        }
    }
}

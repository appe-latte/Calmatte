//
//  WeatherCardBackView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-14.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherCardBackView: View {
    @StateObject private var weatherModel = WeatherViewModel()
    let locationManager = CLLocationManager()
    let locationFetch = LocationFetch()
    
    @State private var refreshTrigger = false
    @State private var weatherSymbolLabel = ""
    @State private var dailyHighLabel = ""
    @State private var dailyLowLabel = ""
    @State private var forecastHourly = ""
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Label("12-Hour Forecast", systemImage: "clock")
                    .font(.caption)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(10)
            
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(weatherModel.hourlyForecast.prefix(12), id: \.time) {
                        weather in
                        VStack(spacing: 15) {
                            Text(weather.time)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                            
                            Image(systemName: "\(weather.symbolName).fill")
                                .font(.title)
//                                .foregroundColor(np_black)
                                .symbolRenderingMode(.multicolor)
                            
                            Text(weather.temperature)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // MARK: Daily High / Low
            HStack {
                Text("\(dailyHighLabel)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
                
                Spacer()
                
                Text("\(dailyLowLabel)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // MARK: WeatherKit Trademark
            HStack {
                Text("Powered by  Weather. Weather data provided by WeatherKit.")
                    .font(.system(size: 6))
                    .fontWeight(.semibold)
                    .kerning(2)
                    .textCase(.uppercase)
            }
            .padding(5)
        }
        .frame(maxWidth: screenWidth - 20, maxHeight: screenHeight * 0.30)
        .background(np_gray)
        .foregroundColor(np_black)
        .ignoresSafeArea()
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        .onReceive(weatherModel.objectWillChange) { _ in
            let updaterWeatherSymbol = weatherModel.currWeatherSymbol
            let updatedDailyHigh = weatherModel.dailyHigh
            let updatedDailyLow = weatherModel.dailyLow
            let updatedForecast = weatherModel.hourlyForecast
            
            // MARK: Update Weather data
            dailyLowLabel = "\(updatedDailyLow)"
            dailyHighLabel = "\(updatedDailyHigh)"
            weatherSymbolLabel = "\(updaterWeatherSymbol)"
            forecastHourly = "\(updatedForecast)"
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 10 * 60, repeats: true) { _ in
                refreshTrigger.toggle()
            }
        }
        .onChange(of: refreshTrigger) { _ in
            weatherModel.fetchWeather()
        }
    }
}

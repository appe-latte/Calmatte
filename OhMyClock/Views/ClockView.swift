//
//  ClockView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ClockView: View {
    @StateObject private var weatherModel = WeatherViewModel()
    let locationManager = CLLocationManager()
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    @State private var temperatureLabel = ""
    @State private var humidityLabel : Double = 0.0
    @State private var conditionLabel = ""
    @State private var weatherSymbolLabel = ""
    @State private var dailyHighLabel = ""
    @State private var dailyLowLabel = ""
    @State private var forecastHourly = ""
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    // MARK: Date + Salutation
                    HStack {
                        VStack(spacing: 10) {
                            HStack {
                                Text(greeting)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .minimumScaleFactor(0.5)
                                    .textCase(.uppercase)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(Date().formatted(.dateTime.month().day().year()))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                
                                Spacer()
                            }
                        }
                        .padding(10)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(5)
                    
                    HStack(spacing: 15) {
                        FlipView(viewModel: viewModel.flipViewModels[0])
                        
                        FlipView(viewModel: viewModel.flipViewModels[1])
                        
                        FlipView(viewModel: viewModel.flipViewModels[2])
                        
                        FlipView(viewModel: viewModel.flipViewModels[3])
                    }
                    .frame(maxWidth: screenWidth - 20)
                    
                    // MARK: Time Zone
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Text("timezone:")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                            
                            Text(Date().formatted(.dateTime.timeZone()))
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 35)
                    
                    Spacer(minLength: 0)
                    
                    Divider()
                        .padding(.top, 10)
                    
                    // MARK: Weather Conditions
                    VStack {
                        HStack {
                            Label("Today's Weather", systemImage: "thermometer.sun.fill")
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
                                .foregroundColor(np_black)
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            Spacer()
                                .frame(width: 25)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                // Temperature
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
                                
                                // Humidity
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
                                
                                // Weather Condition
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
                                .font(.system(size: 6))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                        }
                        .padding(5)
                    }
                    .frame(maxWidth: screenWidth - 20, maxHeight: screenHeight * 0.65)
                    .background(np_white)
                    .foregroundColor(np_black)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.bottom)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: Hourly Forecast
                    HStack {
                        Label("12-Hour Forecast", systemImage: "clock")
                            .font(.caption)
                            .fontWeight(.bold)
                            .kerning(2)
                            .textCase(.uppercase)
                        
                        Spacer()
                    }
                    .padding(10)
                    
                    VStack(spacing: 15) {
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
                                            .foregroundColor(np_black)
                                        
                                        Text(weather.temperature)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .textCase(.uppercase)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
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
                        .padding(.bottom, 20)
                        
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
                    .background(np_white)
                    .foregroundColor(np_black)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                weatherModel.fetchWeather()
            }
            .onReceive(weatherModel.objectWillChange) { _ in
                // Update the view when weather data changes
                // For example, update the temperature and condition labels
                // based on the new data in the WeatherViewModel
                
                // Access the weather data from the WeatherViewModel and update the view accordingly
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
                dailyLowLabel = "\(updatedDailyLow)"
                dailyHighLabel = "\(updatedDailyHigh)"
                weatherSymbolLabel = "\(updaterWeatherSymbol)"
                forecastHourly = "\(updatedForecast)"
            }
        }
        .background(np_black)
    }
    
    // MARK: Salutation function
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12:
            return "Mid-day"
        case 13..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
    }
}

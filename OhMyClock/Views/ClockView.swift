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
    
    @State private var refreshTrigger = false
    
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
                            
                            Text(TimeZone.current.abbreviation() ?? "")
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
                    
                    // MARK: Weather Conditions Card
                    WeatherCardFrontView()
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: Hourly Forecast Card
                    WeatherCardBackView()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(np_black)
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

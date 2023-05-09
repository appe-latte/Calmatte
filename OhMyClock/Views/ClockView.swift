//
//  ClockView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct ClockView: View {
    @EnvironmentObject var timerModel : TimerModel
    @StateObject private var vm = WeatherViewModel()
    let locationManager = CLLocationManager()
    
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    
                    HStack {
                        VStack(spacing: 10) {
                            // MARK: "Morning / Afternoon / Evening"
                            
                            HStack {
                                    Text(greeting)
                                        .font(.system(size: 28))
                                        .fontWeight(.bold)
                                        .kerning(5)
                                        .minimumScaleFactor(0.5)
                                        .textCase(.uppercase)
                                    
                                    Spacer()
                            }
                            
                            // MARK: Date
                            HStack {
                                Text(Date().formatted(.dateTime.month().day().year()))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .kerning(5)
//                                    .minimumScaleFactor(0.5)
                                    .textCase(.uppercase)
                                
                                Spacer()
                            }
                        }
                        .padding(10)
                        .padding(.top, 30)
                        
                        Spacer(minLength: 0)
                        
                    }
                    .padding()
                    
                    HStack(spacing: 15) {
                        FlipView(viewModel: viewModel.flipViewModels[0])
                        
                        FlipView(viewModel: viewModel.flipViewModels[1])
                        
                        FlipView(viewModel: viewModel.flipViewModels[2])
                        
                        FlipView(viewModel: viewModel.flipViewModels[3])
                    }
                    .frame(maxWidth: width - 20)
                    
                    HStack {
                        Spacer()
                        
                        // MARK: Time Zone
                        
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
                    
                    // MARK: Weather Conditions
                    
                    VStack {
                        // Temperature
                        VStack {
                            Text("Temperature:")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(vm.temperature)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                        
                        // Humidity
                        VStack {
                            Text("Humidity:")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(vm.humidity * 100)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                        
                        // Weather Condition
                        VStack {
                            Text("Weather:")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(vm.condition)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                    }
                    .frame(maxWidth: width - 20, maxHeight: height * 0.65)
                    .background(np_white)
                    .foregroundColor(np_black)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    .padding(.top, 20)
                    .edgesIgnoringSafeArea(.bottom)
                    .task {
                        await vm.populateWeather()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                locationManager.delegate
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
        .background(np_black)
    }
    
    // MARK: "Greeting"
    
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

//
//  MainView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON
import CoreLocation
import WeatherKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct MainView: View {
    @ObservedObject var moodModel: MoodModel
    @ObservedObject var moodModelController = MoodModelController()
    @ObservedObject var authModel = AuthViewModel()
    @StateObject private var weatherModel = WeatherViewModel()
    @Binding var tabBarSelection: Int
    
    @State private var insightsMode: InsightsType = .today
    @State private var showProfileSheet = false
    @State private var temperatureLabel = ""
    @State private var humidityLabel : Double = 0.0
    @State private var conditionLabel = ""
    @State private var refreshTrigger = false
    @State var userFname = ""
    
    // Constants
    let locationManager = CLLocationManager()
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    // VAriables
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        let firstName = authModel.user?.firstName ?? ""
        
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    // MARK: Profile Sheet
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 5) {
                            Button(action: {
                                self.showProfileSheet.toggle()
                            },
                                   label: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(np_gray)
                            })
                        }
                    }
                    .padding(10)
                    
                    // MARK: Date + Salutation
                    VStack(spacing: 10) {
                        HStack {
                            Text(greeting)
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .kerning(5)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                            
                            Spacer()
                        }
                        .padding(.leading, 10)
                        
                        // MARK: Username
                        HStack {
                            Text("\(firstName).")
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                                .kerning(5)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                            
                            Spacer()
                        }
                        .padding(.leading, 10)
                        
                        // MARK: Weather Info.
                        HStack {
                            HStack {
                                Text("Temp.")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                
                                Text("\(temperatureLabel)")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                            }
                            
                            HStack {
                                Text("Hum.")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                
                                Text("\(String(format: "%.0f", humidityLabel * 100))%")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                            }
                            
                            HStack {
                                Text("•")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                
                                Text("\(conditionLabel)")
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                            }
                        }
                        .frame(width: width, height: 20)
                        .background(np_white)
                        .foregroundColor(np_jap_indigo)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // MARK: Quote View
                    VStack {
                        HStack {
                            Label("Quote of the day", systemImage: "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        QuoteView()
                    }
                    
                    // MARK: Month View
                    VStack {
                        HStack {
                            Label("This Month", systemImage: "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        MoodCalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, moodController: moodModelController)
                            .frame(maxWidth: width - 40, maxHeight: height * 0.75)
                            .background(np_jap_indigo)
                            .foregroundColor(np_white)
                            .ignoresSafeArea()
                            .cornerRadius(10)
                            .edgesIgnoringSafeArea(.bottom)
                            .padding(.bottom, 5)
                            .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: self.$showProfileSheet) {
            ProfileView(showProfileSheet: $showProfileSheet)
                .environmentObject(authModel)
                .presentationDetents([.height(height * 0.3)])
        }
        .background(background())
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        .onReceive(weatherModel.objectWillChange) { _ in
            let updatedTemperature = weatherModel.currTemp
            let updatedHumidity = weatherModel.currHumidity
            let updatedCondition = weatherModel.currCondition
            
            // MARK: Update Weather data
            temperatureLabel = "\(updatedTemperature)"
            humidityLabel = updatedHumidity
            conditionLabel = "\(updatedCondition)"
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
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
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
            return "good morning,"
        case 12:
            return "mid-day,"
        case 13..<17:
            return "good afternoon,"
        case 17..<22:
            return "good evening,"
        default:
            return "good night,"
        }
    }
}

// MARK: Segmented Picker for "Insights"
struct CustomSegmentedPickerView: View {
    @Binding var selection: InsightsType
    let items: [InsightsType]
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Text(item.rawValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .kerning(2)
                    .textCase(.uppercase)
                    .padding(15)
                    .foregroundColor(self.selection == item ? np_white : np_white)
                    .background(Capsule().fill(self.selection == item ? np_orange : Color.clear))
                    .onTapGesture {
                        withAnimation {
                            self.selection = item
                        }
                    }
            }
        }
        .background(
            Capsule()
                .fill(np_gray)
                .opacity(0.2))
    }
}


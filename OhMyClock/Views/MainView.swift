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
    
    @EnvironmentObject var appLockViewModel: AppLockViewModel
    
    @State private var insightsMode: InsightsType = .today
    @State private var showProfileSheet = false
    @State private var showSettingsSheet = false
    @State private var temperatureLabel = ""
    @State private var humidityLabel : Double = 0.0
    @State private var conditionLabel = ""
    @State private var refreshTrigger = false
    
    @State var userFname = ""
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    @State var showJournalEntry = false
    
    // Constants
    let locationManager = CLLocationManager()
    let locationFetch = LocationFetch()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        let firstName = authModel.user?.firstName ?? ""
        
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    // MARK: Profile / Settings Sheet
                    HStack(spacing: 30) {
                        Spacer()
                        
                        Button(action: {
                            self.showSettingsSheet.toggle()
                        }, label: {
                            Image(systemName: "gearshape.circle.fill")
                                .font(.system(size: 25))
                                .foregroundColor(np_jap_indigo)
                        })
                        .padding(5)
                        .frame(width: 30, height: 30)
                        .background(np_gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: np_black, radius: 0.1, x: 5, y: 5)
                    }
                    .padding(10)
                    
                    // MARK: Date + Salutation
                    VStack(spacing: 10) {
                        HStack {
                            Text(greeting)
                                .scaledToFill()
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
                                .scaledToFill()
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
                    
                    HStack {
                        // MARK: Profile Sheet
                        Button(action: {
                            self.showProfileSheet.toggle()
                        }, label: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(np_jap_indigo)
                        })
                        .padding(.vertical, 5)
                        .frame(width: 35, height: 35)
                        .background(np_gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: np_black, radius: 0.1, x: 5, y: 5)
                        
                        // MARK: "Add Journal Entry" Button
                        Button {
                            self.txt = ""
                            self.docID = ""
                            self.showJournalEntry.toggle()
                        } label: {
                            Text("Log Daily Mood")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .kerning(2)
                                .textCase(.uppercase)
                        }
                        .padding(.vertical, 5)
                        .foregroundColor(np_jap_indigo)
                        .frame(width: width * 0.85, height: 35)
                        .background(np_white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: np_black, radius: 0.1, x: 5, y: 5)
                    }
                    .frame(width: width - 40)
                    .padding(.bottom, 30)
                    
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
        .sheet(isPresented: self.$showJournalEntry) {
            MoodAddDiaryView(moodModelController: self.moodModelController)
        }
        .sheet(isPresented: self.$showSettingsSheet) {
            SettingsView()
                .environmentObject(authModel) // Use the existing authViewModel
                .environmentObject(appLockViewModel) // Use the existing appLockViewModel
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                        ReminderManager.scheduleReminders()
                    } else {
                        ReminderManager.cancelScheduledReminders()
                    }
                }
                .presentationDetents([.height(height)])
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

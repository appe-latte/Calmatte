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
    @State private var showProfileSheet = false
    
    // Constants
    let locationManager = CLLocationManager()
    let locationFetch = LocationFetch()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        let firstName = authModel.user?.firstName ?? ""
        
        ZStack {
            VStack {
                // MARK: "Share" / Settings Sheets
                HStack(spacing: 30) {
                    Button(action: {
                        shareSheet()
                    }, label: {
                        Image("share")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_white)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.showSettingsSheet.toggle()
                    }, label: {
                        Image("settings")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_white)
                    })
                }
                .padding(10)
                
                // MARK: Date + Salutation
                VStack(spacing: 10) {
                    HStack {
                        Text(greeting)
                            .scaledToFill()
                            .font(.custom("Butler", size: 27))
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
                            .font(.custom("Butler", size: 36))
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
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(temperatureLabel)")
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                        
                        HStack {
                            Text("Hum.")
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(String(format: "%.0f", humidityLabel * 100))%")
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                        
                        HStack {
                            Text("•")
                                .kerning(5)
                                .textCase(.uppercase)
                            
                            Text("\(conditionLabel)")
                                .kerning(5)
                                .textCase(.uppercase)
                        }
                    }
                    .font(.system(size: 8))
                    .fontWeight(.bold)
                    .frame(width: width, height: 20)
                    .background(np_white)
                    .foregroundColor(np_jap_indigo)
                }
                
                Spacer()
                    .frame(height: 30)
                
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
                .frame(width: width - 40, height: 35)
                .background(np_white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: np_black, radius: 0.1, x: 5, y: 5)
                .padding(.bottom, 30)
                
                // MARK: "This Week" view
                VStack {
                    HStack {
                        Label("This Week", systemImage: "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .foregroundColor(np_jap_indigo)
                            .padding(5)
                            .background(np_white)
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    WeeklyMoodView(moodModelController: MoodModelController())
                        .frame(maxWidth: width - 40, maxHeight: height * 0.5)
                        .background(np_jap_indigo)
                        .foregroundColor(np_white)
                        .ignoresSafeArea()
                        .cornerRadius(10)
                        .edgesIgnoringSafeArea(.bottom)
                        .padding(.bottom, 5)
                        .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
                }
                .padding(.bottom, 30)
                
                // MARK: Quote View
                VStack {
                    HStack {
                        Label("Daliy Affirmation", systemImage: "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .foregroundColor(np_jap_indigo)
                            .padding(5)
                            .background(np_white)
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    AffirmationView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: self.$showJournalEntry) {
            MoodAddDiaryView(moodModelController: self.moodModelController)
        }
        .sheet(isPresented: self.$showSettingsSheet) {
            SettingsView(showProfileSheet: $showProfileSheet)
                .environmentObject(authModel) // Use the existing authViewModel
                .environmentObject(appLockViewModel) // Use the existing appLockViewModel
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                        let reminderTimeDouble = UserDefaults.standard.double(forKey: "reminderTime")
                        let reminderTime = Date(timeIntervalSince1970: reminderTimeDouble)
                        ReminderManager.scheduleReminders(for: reminderTime)
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
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "good morning,"
        case 12..<17:
            return "good afternoon,"
        case 17..<22:
            return "good evening,"
        default:
            return "good night,"
        }
    }
}

// MARK: "Share sheet" function
func shareSheet() {
    guard let data = URL(string: "https://apps.apple.com/us/app/ohmyclock/id1667124410") else { return }
    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
}

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
    @ObservedObject var userViewModel = UserViewModel()
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
    
    // Constants
    let locationManager = CLLocationManager()
    let locationFetch = LocationFetch()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        let firstName = authModel.user?.firstName ?? ""
        NavigationStack {
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
                        
                        //                    Button(action: {
                        //                        self.showSettingsSheet.toggle()
                        //                    }, label: {
                        //                        Image("settings")
                        //                            .resizable()
                        //                            .frame(width: 25, height: 25)
                        //                            .padding(5)
                        //                            .foregroundColor(np_white)
                        //                    })
                        
                        NavigationLink(destination: SettingsView(userViewModel: userViewModel)){
                            Image("settings")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(5)
                                .foregroundColor(np_white)
                        }
                    }
                    .padding(10)
                    
                    // MARK: Salutation
                    VStack(spacing: 2) {
                        HStack {
                            Text(greeting)
                                .scaledToFill()
                                .font(.system(size: 27, weight: .bold, design: .rounded))
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
                                .font(.system(size: 36, weight: .bold, design: .rounded))
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
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .foregroundColor(np_white)
                        .frame(width: width - 40, height: 60)
                        .overlay {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading)  {
                                    Text("Mood Check-In")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .kerning(2)
                                        .textCase(.uppercase)
                                    
                                    Text("How was your day?")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .kerning(2)
                                }
                                
                                Spacer()
                                
                                Button {
                                    self.txt = ""
                                    self.docID = ""
                                    self.showJournalEntry.toggle()
                                } label: {
                                    Text("Log")
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .kerning(2)
                                        .textCase(.uppercase)
                                }
                                .padding(.vertical, 5)
                                .foregroundColor(np_jap_indigo)
                                .frame(width: 100, height: 35)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(np_white)
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.bottom, 15)
                    
                    // MARK: "This Week" view
                    VStack {
                        HStack {
                            Label("This Week", systemImage: "")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        WeeklyMoodView(moodModelController: MoodModelController())
                    }
                    .padding(.bottom, 15)
                    
                    // MARK: Quote View
                    VStack {
                        HStack {
                            Label("Daily Affirmation", systemImage: "")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                                .padding(5)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        AffirmationView()
                    }
                }
            }
            .background(background())
            .frame(maxWidth: .infinity)
            .sheet(isPresented: self.$showJournalEntry) {
                MoodAddDiaryView(moodModelController: self.moodModelController)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                let reminderTimeDouble = UserDefaults.standard.double(forKey: "reminderTime")
                let reminderTime = Date(timeIntervalSince1970: reminderTimeDouble)
                ReminderManager.scheduleReminders(for: reminderTime)
            } else {
                ReminderManager.cancelScheduledReminders()
            }
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
            
            Image("img-bg")
                .resizable()
                .scaledToFill()
                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_arsenic)
                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
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

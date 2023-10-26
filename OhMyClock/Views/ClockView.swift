//
//  ClockView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-05-09.
//

import SwiftUI
import WeatherKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

struct ClockView: View {
    @StateObject private var weatherModel = WeatherViewModel()
    let locationManager = CLLocationManager()
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    @ObservedObject var authModel = AuthViewModel()
    @State var userFname = ""
    
    @State private var refreshTrigger = false
    
    @ObservedObject private var moodModel = MoodModel()
    @State private var insightsMode: InsightsType = .today
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    @State private var showProfileSheet = false
    
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
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(np_gray)
                            })
                            
                            Text("Profile")
                                .font(.system(size: 8))
                                .fontWeight(.bold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: Date + Salutation
                    VStack {
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
                        
                        // MARK: Weather Information
                            WeatherCardFrontView()
                            .padding(  )
                    }
                    .padding(5)
                    .foregroundColor(np_white)
                    
                    Spacer()
                    
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
                }
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: self.$showProfileSheet) {
            ProfileView(showProfileSheet: $showProfileSheet)
                .environmentObject(authModel)
                .presentationDetents([.height(screenHeight * 0.3)])
        }
        .background(background())
        .onChange(of: refreshTrigger) { _ in
            weatherModel.fetchWeather()
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_arsenic, np_arsenic], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // MARK: Tint
            Rectangle()
                .fill(np_arsenic).opacity(0.85)
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
    
    // MARK: Day / Night Theme
    private var background_theme : String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<19:
            return "snow-mountain"
        default:
            return "mountain-pond"
        }
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView()
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

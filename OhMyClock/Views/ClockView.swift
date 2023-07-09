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
    
    @ObservedObject private var moodModel = MoodModel()
    @State private var insightsMode: InsightsType = .today
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                    .foregroundColor(np_white)
                    
                    // MARK: Flip Clock
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
                    .foregroundColor(np_white)
                    .padding(.bottom, 20)
                    
                    Spacer(minLength: 0)
                    
                    // MARK: Weather Information
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            Label("Weather", systemImage: "cloud.sun.fill")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        HStack(spacing: 15){
                            // MARK: Weather Conditions Card
                            WeatherCardFrontView()
                            
                            // MARK: Hourly Forecast Card
                            WeatherCardBackView()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: Mood Diary
                    HStack {
                        Label("How do you feel today?", systemImage: "face.dashed")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(2)
                            .textCase(.uppercase)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        
                        MoodSelectorTileView(moodModel: moodModel)
                    }
                    .frame(maxWidth: screenWidth - 40, maxHeight: screenHeight * 0.65)
                    .background(np_white)
                    .foregroundColor(np_black)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    
                    // MARK: Mood Insights
                    HStack {
                        Label("mood insights", systemImage: "chart.xyaxis.line")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(2)
                            .textCase(.uppercase)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        
                        // MARK: Today / This Week Picker
                        CustomSegmentedPickerView(selection: $insightsMode, items: InsightsType.allCases)
                            .padding()
                            .onChange(of: insightsMode) { newValue in
                                self.moodModel.didChangeInsights(type: newValue)
                            }
                        
                        // MARK: Insights List
                        MoodInsightsListView(screenWidth: screenWidth, moodModel: moodModel)
                            .padding()
                        
                    }
                    .frame(maxWidth: screenWidth - 40, maxHeight: screenHeight * 0.65)
                    .background(np_white)
                    .foregroundColor(np_black)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(background())
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
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_black, np_black, np_black], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // MARK: Tint
            Rectangle()
                .fill(np_black).opacity(0.5)
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
                    .foregroundColor(self.selection == item ? np_white : np_black)
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

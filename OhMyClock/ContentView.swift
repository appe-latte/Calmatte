//
//  ContentView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var realmManager = OmcRealmManager()
    @State var showMenuSheet = false
    @EnvironmentObject var timerModel : TimerModel
    
    init() {
        let tabBarTintColor = UITabBarAppearance()
        tabBarTintColor.configureWithOpaqueBackground()
        tabBarTintColor.selectionIndicatorTintColor = UIColor.init(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
        UITabBar.appearance().scrollEdgeAppearance = tabBarTintColor
        UITabBar.appearance().standardAppearance = tabBarTintColor
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255))
        
        tabBarTintColor.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabBarTintColor
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Home", image: "home")
                }
            
            MeditationView(meditationViewModel: MeditationViewModel(meditation: Meditation.data))
                .colorScheme(.light)
                .tabItem {
                    Label("Meditation", image: "zen")
                }
            
            TimerView()
                .tabItem {
                    Label("Timer", image: "timer")
                }
            
            MilestonesView()
                .environmentObject(realmManager)
                .colorScheme(.light)
                .tabItem {
                    Label("Milestones", image: "collections")
                }
            
            SettingsView()
                .colorScheme(.light)
                .tabItem {
                    Label("More", image: "more")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioManager())
            .environmentObject(TimerModel())
    }
}


//
//  ContentView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import CoreData
import CoreLocation

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @StateObject var realmManager = OmcRealmManager()
    @State var showMenuSheet = false
    @EnvironmentObject var timerModel : TimerModel
    
    var audioManager = AudioManager()
    
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
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        TabView {
            MainView()
                .colorScheme(.dark)
                .tabItem {
                    Label("Home", image: "home")
                }
            
            MeditationView(meditationViewModel: MeditationViewModel(meditation: Meditation.data))
                .colorScheme(.light)
                .environmentObject(audioManager)
                .tabItem {
                    Label("Meditation", image: "zen")
                }
            
            TimerView()
                .colorScheme(.light)
                .environmentObject(TimerModel())
                .tabItem {
                    Label("Timer", image: "timer")
                }
            
            TaskManagerView(taskManager: taskManager)
                .colorScheme(.light)
                .tabItem {
                    Label("Tasks", image: "collections")
                }
            
            SettingsView()
                .colorScheme(.light)
                .tabItem {
                    Label("More", image: "more")
                }
        }
    }
}

extension UIScreen {
    func setBrightnessLevel() {
        if UIApplication.shared.isIdleTimerDisabled {
            self.brightness = 0.2 // Set the brightness level to 20% when the idle timer is disabled
        } else {
            self.brightness = 1.0 // Set the brightness level to 100% when the idle timer is enabled
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


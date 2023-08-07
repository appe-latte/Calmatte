//
//  ContentView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import Combine
import CoreData
import CoreLocation
import UserNotifications

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State var showMenuSheet = false
    
    var audioManager = AudioManager()
    
    @EnvironmentObject var authViewModel: AuthViewModel
       @EnvironmentObject var appLockViewModel: AppLockViewModel
       
       @ObservedObject var moodModel: MoodModel
       @Binding var tabBarSelection: Int
    
    init(moodModel: MoodModel = MoodModel(), tabBarSelection: Binding<Int> = .constant(0)) {
        self.moodModel = moodModel
        self._tabBarSelection = tabBarSelection
        
        let tabBarTintColor = UITabBarAppearance()
        tabBarTintColor.configureWithOpaqueBackground()
        tabBarTintColor.selectionIndicatorTintColor = UIColor.init(Color(red: 195 / 255, green: 184 / 255, blue: 222 / 255))
        UITabBar.appearance().scrollEdgeAppearance = tabBarTintColor
        UITabBar.appearance().standardAppearance = tabBarTintColor
        UITabBar.appearance().backgroundColor = UIColor(Color(red: 48 / 255, green: 58 / 255, blue: 72 / 255))
        
        tabBarTintColor.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabBarTintColor
    }
    
    var body: some View {
        TabView {
            MainView(moodModel: moodModel, tabBarSelection: $tabBarSelection)
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
            
            MoodDiaryView()
                .colorScheme(.light)
                .tabItem {
                    Label("Journal", image: "journal")
                }
            
            TaskManagerView(taskManager: taskManager)
                .colorScheme(.light)
                .tabItem {
                    Label("Tasks", image: "tasks")
                }
            
            SettingsView()
                .environmentObject(AppLockViewModel())
                .environmentObject(AuthViewModel())
                .colorScheme(.light)
                .tabItem {
                    Label("More", image: "more")
                }
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                        ReminderManager.scheduleReminders()
                    } else {
                        ReminderManager.cancelScheduledReminders()
                    }
                }
        }
    }
}

// MARK: Screen Brightness
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
    }
}

struct CustomShape: Shape {
    var corner : UIRectCorner
    var radii : CGFloat
    
    func path(in rect : CGRect) -> Path{
        let path = UIBezierPath(
            roundedRect : rect,
            byRoundingCorners: corner,
            cornerRadii: CGSize(
                width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}

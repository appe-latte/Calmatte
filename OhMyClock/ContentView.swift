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
            
            MoodDiaryView()
                .colorScheme(.light)
                .tabItem {
                    Label("Reports", image: "report")
                }
            
            MoodDiaryView()
                .colorScheme(.light)
                .tabItem {
                    Label("Journal", image: "calendar")
                }
            
            MeditationView(meditationViewModel: MeditationViewModel(meditation: Meditation.data))
                .colorScheme(.light)
                .environmentObject(audioManager)
                .tabItem {
                    Label("Meditation", image: "zen")
                }
            
            TaskManagerView(taskManager: taskManager)
                .colorScheme(.light)
                .tabItem {
                    Label("Tasks", image: "paper")
                }
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

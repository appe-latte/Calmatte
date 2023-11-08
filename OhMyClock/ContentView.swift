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
import FirebaseFirestore
import UserNotifications

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State var showMenuSheet = false
    
    var audioManager = AudioManager()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appLockViewModel: AppLockViewModel
    
    @ObservedObject var moodModel: MoodModel
    @Binding var tabBarSelection: Int
    
    @State private var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @State private var isHide = false
    @State private var isLoading = false
    @Namespace var animation
    
    @State private var selectedTab = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
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
        VStack(spacing: 0) {
            switch selectedTab {
            case 0: MainView(moodModel: moodModel, tabBarSelection: $tabBarSelection)
            case 1: AnalyticsView(start: Date(), monthsToShow: 2, moodController: MoodModelController())
            case 2: MoodDiaryView()
            case 3: MeditationView(meditationViewModel: MeditationViewModel(meditation: Meditation.data))
            case 4: TaskManagerView(taskManager: taskManager)
            default: Text("Not found")
            }
            
            // MARK: Custom Tab Bar
            ZStack {
                Rectangle()
                    .fill(np_jap_indigo)
                    .frame(width: width, height: 90)
                    .cornerRadius(15, corners: [.topRight, .topLeft])
                
                HStack {
                    tabItem(icon: "home", selectedIcon: "home", text: "Home", index: 0)
                    Spacer()
                    
                    tabItem(icon: "report", selectedIcon: "report", text: "Analytics", index: 1)
                    Spacer()
                    
                    tabItem(icon: "calendar", selectedIcon: "calendar", text: "Journal", index: 2)
                    Spacer()
                    
                    tabItem(icon: "zen", selectedIcon: "zen", text: "Meditation", index: 3)
                    Spacer()
                    
                    tabItem(icon: "paper", selectedIcon: "paper", text: "Tasks", index: 4)
                }
                .padding(.horizontal, 30)
                .frame(height: 60)
            }
        }
        .background(np_arsenic)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func tabItem(icon: String, selectedIcon: String, text: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack {
                Circle()
                    .fill(selectedTab == index ? np_white : np_arsenic)
                    .frame(width: 7, height: 7)
                    .clipShape(Circle())
                
                Image(selectedTab == index ? selectedIcon : icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(np_white)
                
                Text(text)
                    .font(.system(size: 8))
                    .foregroundColor(selectedTab == index ? np_gray : np_white)
                    .textCase(.uppercase)
                    .kerning(2)
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

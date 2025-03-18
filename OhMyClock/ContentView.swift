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
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State var showMenuSheet = false
    
    var audioManager = AudioManager()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appLockViewModel: AppLockViewModel
    @StateObject private var moodModelController = MoodModelController()
    @StateObject private var soundPlayerViewModel = SoundPlayerViewModel()
    @StateObject var progressView = AppViewModel()
    
    @ObservedObject var moodModel: MoodModel
    @Binding var tabBarSelection: Int
    
    @State private var top = UIApplication.shared.windows.first?.safeAreaInsets.top
    @State private var isHide = false
    @State private var isLoading = false
    @Namespace var animation
    
    @State private var selectedTab = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    // Define an array of colors for the tabs
    let tabColors: [Color] = [np_turq, np_orange, np_purple, np_tan, np_red]
    
    // MARK: Check for signed in user
    var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
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
        NavigationView {
            if isUserSignedIn {
                ZStack {
                    VStack(spacing: 0) {
                        // MARK: Top Tab Bar
                        HStack(spacing: 0) {
                            topTabItem(text: "Home", index: 0, tabColor: tabColors[0])
                            topTabItem(text: "Journal", index: 1, tabColor: tabColors[1])
                            topTabItem(text: "Tasks", index: 2, tabColor: tabColors[2])
                            topTabItem(text: "Wellness", index: 3, tabColor: tabColors[3])
                            topTabItem(text: "Settings", index: 4, tabColor: tabColors[4])
                        }
                        .padding(.horizontal)
                        .background(np_white)
                        Divider()

                        // MARK: Tab Content Views
                        switch selectedTab {
                        case 0: MainView(moodModel: moodModel, tabBarSelection: $tabBarSelection)
                        case 1: JournalView()
                        case 2: TaskView(taskManager: taskManager)
                        case 3: WellnessView(moodModel: moodModel)
                        case 4: SettingsView()
                        default: Text("Not found")
                        }
                        
                        Spacer()
                    }
                    .background(np_white)
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    // MARK: Progress Loading
                    if progressView.isLoading {
                        ProgressLoadingView()
                    }
                }
                .onAppear {
                    progressView.loadData()
                }
            } else {
                LoginView()
            }
        }
    }
    
    private func topTabItem(text: String, index: Int, tabColor: Color) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 0) {
                Text(text)
                    .font(.system(size: 14, weight: .semibold)) // Adjust font to match image
                    .foregroundColor(selectedTab == index ? np_jap_indigo : np_gray) // Selected tab text color
                    .padding(.vertical, 10)
                
                // Indicator line
                if selectedTab == index {
                                    Rectangle()
                                        .fill(tabColor) // Use the passed tabColor here
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "tab_indicator", in: animation)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity) // Distribute tabs evenly
        }
        .buttonStyle(.plain) // Remove button styling
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

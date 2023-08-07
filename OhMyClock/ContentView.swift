//
//  ContentView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import CoreData
import CoreLocation
import UserNotifications

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State var showMenuSheet = false
    
    var audioManager = AudioManager()
    
    @ObservedObject var moodModel: MoodModel
    //    @ObservedObject var appLockViewModel : AppLockViewModel
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
                    // Check if reminders are enabled, and trigger notifications accordingly
                    if UserDefaults.standard.bool(forKey: "RemindersEnabled") {
                        scheduleReminders()
                    } else {
                        cancelScheduledReminders()
                    }
                }
        }
    }
    
    // MARK: Reminders
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                scheduleReminders()
            } else {
                // Handle authorization denial or error
            }
        }
    }
    
    func scheduleReminders() {
        let content = UNMutableNotificationContent()
        content.title = "Log Your Mood"
        content.body = "Don't forget to log your mood!"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let reminderHours = [12, 20] // Reminders sent at mid-day and 8pm
        
        for (index, hour) in reminderHours.enumerated() {
            var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let identifier = "moodReminder_\(index)"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully: \(identifier)")
                }
            }
        }
    }
    
    
    func sendReminderEnabledNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminders Enabled"
        content.body = "You will now receive reminders to log your mood."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger notification immediately
        
        let request = UNNotificationRequest(identifier: "reminderEnabledNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully: reminderEnabledNotification")
            }
        }
    }
    
    func sendReminderDisabledNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Reminders Disabled"
        content.body = "You have disabled reminders to log your mood."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Trigger notification immediately
        
        let request = UNNotificationRequest(identifier: "reminderDisabledNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully: reminderDisabledNotification")
            }
        }
    }
    
    func cancelScheduledReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["moodReminder"])
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

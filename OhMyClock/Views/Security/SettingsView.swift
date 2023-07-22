//
//  SettingsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import StoreKit
import FirebaseCore
import FirebaseAuth
import UserNotifications
import FirebaseFirestore
import LocalAuthentication

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    @State var emailAlert : Bool = false
    
    // MARK: Authentication
    @EnvironmentObject var appLockViewModel : AppLockViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    var isAppLockEnabled = false
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @State var rowHeight = 65.0
    
    // MARK: Reminders
    @AppStorage("RemindersEnabled") private var remindersEnabled = false
    
    var body: some View {
        NavigationView {
            ZStack {
                np_jap_indigo
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        // MARK: "Developer Website"
                        Button(action: {
                            openURL(URL(string: "https://www.appe-latte.ca")!)
                        }, label: {
                            HStack(spacing: 5) {
                                Image("country")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(np_white)
                                
                                Text("our website")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                        })
                        
                        Spacer()
                        
                        // MARK: "Share App"
                        Button(action: {
                            shareSheet()
                        }, label: {
                            HStack {
                                Image("share")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(np_white)
                                
                                Text("Share")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                        })
                    }
                    .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                // MARK: Logo
                VStack(alignment: .center, spacing: 3) {
                    Image("logo-text")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(np_white)
                        .frame(width: 150, height: 180)
                    
                    Text("Developed with \(Image(systemName: "heart.fill")) by: Appè Latte")
                        .font(.system(size: 10))
                        .fontWeight(.thin)
                        .kerning(4)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    // MARK: App Version + Build Number
                    HStack(spacing: 10) {
                        Text("App Version:")
                            .font(.system(size: 9.5))
                            .fontWeight(.thin)
                            .kerning(5)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        
                        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                            
                            Text("\(UIApplication.appVersion!) (\(buildNumber))")
                                .font(.system(size: 9.5))
                                .fontWeight(.regular)
                                .kerning(9.5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.top, 75)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 20) {
                    
                    Spacer()
                    
                    // MARK: Settings
                    HStack {
                        Label("Settings", systemImage: "info.bubble")
                            .font(.caption)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    .frame(width: screenWidth - 30)
                    .padding()
                    
                    Group {
                        // MARK: FaceID ON/OFF
                        VStack {
                            HStack {
                                Image("scan")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_purple)
                                
                                Toggle("Unlock with FaceID", isOn: $appLockViewModel.isAppLockEnabled)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 62 / 255, green: 201 / 255, blue: 193 / 255)))
                            .onChange(of: appLockViewModel.isAppLockEnabled, perform: { value in
                                appLockViewModel.appLockStateChange(appLockState: value)
                            })
                            
                            HStack {
                                Text("Enable to unlock with FaceID.")
                                    .font(.system(size: 8))
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_gray)
                                    .padding(1)
                                    .padding(.leading, 20)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .background(np_gray)
                        
                        // MARK: "Reminders"
                        HStack(spacing: 10) {
                            Image("notification")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(5)
                                .foregroundColor(np_turq)
                            
                            Toggle("Enable Reminders", isOn: $remindersEnabled)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .onChange(of: remindersEnabled, perform: { enabled in
                                    if enabled {
                                        requestNotificationAuthorization()
                                        sendReminderEnabledNotification()
                                    } else {
                                        cancelScheduledReminders()
                                        sendReminderDisabledNotification()
                                    }
                                })
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 62 / 255, green: 201 / 255, blue: 193 / 255)))
                        }
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .background(np_gray)
                        
                        // MARK: "Legal Source"
                        Button(action: {
                            openURL(URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                        }, label: {
                            HStack(spacing: 10) {
                                Image("note")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_tan)
                                
                                HStack {
                                    Text("Weather Data Source")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                Image(systemName: "chevron.right")
                            }
                        })
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .background(np_gray)
                        
                        // MARK: "Contact Developer"
                        Button(action: {
                            let urlWhatsApp = "https://wa.me/15874384450?text=Hello,%20I'm%20interested%20in%20your%20app%20development%20services."
                            
                            guard let url = URL(string: urlWhatsApp) else { return }
                            
                            if UIApplication.shared.canOpenURL(url) {
                                openURL(url)
                            }
                            else {
                                print("WhatsApp not installed")
                            }
                        }, label: {
                            HStack(spacing: 10) {
                                Image("chat")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_green)
                                
                                HStack {
                                    Text("Let's Chat")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Text("(Whatsapp)")
                                        .font(.system(size: 8))
                                        .fontWeight(.semibold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                Image(systemName: "chevron.right")
                            }
                        })
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .background(np_gray)
                        
                        // MARK: "Write A Review"
                        Button(action: {
                            requestReview()
                        }, label: {
                            HStack(spacing: 10) {
                                Image("review")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_orange)
                                
                                HStack {
                                    Text("Write A Review")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                Image(systemName: "chevron.right")
                            }
                        })
                        .padding(.horizontal, 20)
                        
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        for i in 0..<6 {
            // Create a separate trigger for each reminder time
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create a unique identifier for each notification
            let identifier = "moodReminder_\(i)"
            
            // Create a notification request
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // Schedule the notification
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully: \(identifier)")
                }
            }
            
            // Increment the date components by 2 hours for the next reminder
            dateComponents.hour! += 2
            if dateComponents.hour! >= 21 {
                // If it's 9 pm or later, reset the hour to 8 am on the next day
                dateComponents.hour = 8
                dateComponents.day! += 1
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

// MARK: "App Version" extension
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: "Share sheet" function
func shareSheet() {
    guard let data = URL(string: "https://apps.apple.com/us/app/ohmyclock/id1667124410") else { return }
    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
}

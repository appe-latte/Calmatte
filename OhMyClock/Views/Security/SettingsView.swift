//
//  SettingsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import StoreKit
import AlertToast
import FirebaseAuth
import FirebaseCore
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
    
    // MARK: Alert - "Reminders" + "FaceID"
    @State var showRemindersAlert = false
    @State private var showAlert = false
    @State private var remindersTitle = ""
    @State private var remindersMessage = ""
    
    @State private var showAppLockAlert = false
    @State private var appLockTitle = ""
    @State private var appLockMessage = ""
    
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
                        .font(.system(size: 8))
                        .fontWeight(.thin)
                        .kerning(4)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    // MARK: App Version + Build Number
                    HStack(spacing: 10) {
                        Text("App Version:")
                            .font(.system(size: 7.5))
                            .fontWeight(.thin)
                            .kerning(5)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        
                        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                            
                            Text("\(UIApplication.appVersion!) (\(buildNumber))")
                                .font(.system(size: 7.5))
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
                            .onChange(of: appLockViewModel.isAppLockEnabled, perform: { value in
                                appLockViewModel.appLockStateChange(appLockState: value)
                                if value {
                                    appLockTitle = "Face ID Enabled"
                                    appLockMessage = "You have enabled Face ID for this app."
                                } else {
                                    appLockTitle = "Face ID Disabled"
                                    appLockMessage = "You have disabled Face ID for this app."
                                }
                                showAppLockAlert = true
                            })
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 62 / 255, green: 201 / 255, blue: 193 / 255)))
                            
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
                                        ReminderManager.requestNotificationAuthorization()
                                        ReminderManager.sendReminderEnabledNotification()
                                        remindersTitle = "Reminders Enabled"
                                        remindersMessage = "You will now receive reminders to log your mood."
                                    } else {
                                        ReminderManager.cancelScheduledReminders()
                                        ReminderManager.sendReminderDisabledNotification()
                                        remindersTitle = "Reminders Disabled"
                                        remindersMessage = "You have disabled reminders to log your mood."
                                    }
                                    showRemindersAlert = true
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
                            VStack {
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
                                
                                HStack {
                                    Text("Powered by  Weather. Weather data provided by WeatherKit.")
                                        .font(.system(size: 6))
                                        .fontWeight(.semibold)
                                        .kerning(5)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_gray)
                                        .padding(1)
                                        .padding(.leading, 20)
                                    
                                    Spacer()
                                }
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
            .toast(isPresenting:$showRemindersAlert) {
                AlertToast(type: .regular, title: "\(remindersTitle)", subTitle: "\(remindersMessage)")
            }
            .toast(isPresenting:$showAppLockAlert) {
                AlertToast(type: .regular, title: "\(appLockTitle)", subTitle: "\(appLockMessage)")
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: "App Version" extension
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

// MARK: "Share sheet" function
func shareSheet() {
    guard let data = URL(string: "https://apps.apple.com/us/app/ohmyclock/id1667124410") else { return }
    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
}

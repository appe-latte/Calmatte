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
    
    @State private var firstName = ""
    
    // MARK: Load the current user's first name
    private func loadUserFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data(), let name = data["first_name"] as? String {
                firstName = name
            } else if let error = error {
                print("Error fetching user: \(error)")
            }
        }
    }
    
    // MARK: Alert Toast
    @State var showDeleteAlert = false
    @State private var errTitle = ""
    @State private var errMessage = ""
    
    // MARK: Save the updated first name
    private func saveFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).updateData([
            "first_name": firstName
        ]) { error in
            if let error = error {
                errTitle = "Error"
                errMessage = "An error occurred: \(error.localizedDescription)"
                showAlert = true
            } else {
                errTitle = "Success"
                errMessage = "Successfully updated your name."
                showAlert = true
            }
        }
    }
    
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
                    
                    HStack {
                        Text("Developed with")
                            .font(.system(size: 8))
                            .fontWeight(.thin)
                            .kerning(4)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Text("\(Image(systemName: "heart.fill"))")
                            .font(.system(size: 8))
                            .fontWeight(.thin)
                            .kerning(4)
                            .textCase(.uppercase)
                            .foregroundColor(np_red)
                        
                        Text("by: Appè Latte")
                            .font(.system(size: 8))
                            .fontWeight(.thin)
                            .kerning(4)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                    
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
                    
                    // MARK: Social Media links
                    HStack(spacing: 10) {
                        
                        // MARK: Instagram
                        Button(action: {
                            openURL(URL(string: "https://www.instagram.com/appe.latte")!)
                        }, label: {
                            Image("instagram")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(np_gray)
                        })
                        
                        // MARK: Facebook
                        Button(action: {
                            openURL(URL(string: "https://www.facebook.com/appelatteltd")!)
                        }, label: {
                            Image("facebook")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(np_gray)
                        })
                        
                        // MARK: Twitter
                        Button(action: {
                            openURL(URL(string: "https://www.twitter.com/appe_latte")!)
                        }, label: {
                            Image("twitter")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(np_gray)
                        })
                    }
                    .padding(5)
                    
                    Spacer()
                }
                .padding(.top, 25)
                
                Spacer()
                
                // MARK: Settings
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
                        // MARK: "edit" name
                        VStack {
                            HStack {
                                Image("edit")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_turq)
                                
                                Text("Edit Name: ")
                                    .font(.footnote)
                                    .kerning(3)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                
                                TextField("\(firstName)", text: $firstName)
                                    .font(.footnote)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                                
                                Spacer()
                                
                                Button(action: {
                                    saveFirstName()
                                }, label: {
                                    Text("Save")
                                        .font(.system(size: 10))
                                        .bold()
                                        .kerning(3)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_turq)
                                })
                            }
                        }
                        .onAppear(perform: loadUserFirstName)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .background(np_gray)
                        
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
                                .foregroundColor(np_orange)
                            
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
                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 236 / 255, green: 151 / 255, blue: 48 / 255)))
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
                        
                        // MARK: "Logout" Button
                        Button(action: {
                            authViewModel.signOut()
                        }, label: {
                            HStack(spacing: 10) {
                                Image("logout")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_turq)
                                
                                HStack {
                                    Text("Logout")
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
                        
                        // MARK: "Logout" Button
                        Button(action: {
                            self.showDeleteAlert = true
                        }, label: {
                            HStack(spacing: 10) {
                                Image("trash")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(5)
                                    .foregroundColor(np_red)
                                
                                HStack {
                                    Text("Delete My Account")
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
                        .alert(isPresented:$showDeleteAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete your account?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    authViewModel.deleteUser()
                                },
                                secondaryButton: .cancel()
                            )
                        }
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

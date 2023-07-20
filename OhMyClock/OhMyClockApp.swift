//
//  OhMyClockApp.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

@main
struct OhMyClockApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var audioManager = AudioManager()
    @StateObject var timerModel: TimerModel = .init()
    @State private var isActive = false
    
    // MARK: Authentication
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var appLockViewModel = AppLockViewModel()
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Store last timer stamp
    @State var lastActiveTimeStamp : Date = Date()
    
    init() {
        // MARK: Firebase initialization
        FirebaseApp.configure()
        
        // MARK: Set the screen brightness to 0.65 after 2 minutes of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            UIScreen.main.brightness = 0.65
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.userSession != nil {
                // The rest of your code...
                if appLockViewModel.isAppLockEnabled && appLockViewModel.needsUnlock {
                    BiometricLoginView(appLockViewModel: appLockViewModel)
                        .environmentObject(authViewModel)
                } else {
                    ContentView()
                        .environmentObject(AudioManager())
                    // The rest of your code...
                }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                // App becomes active
                // Check whether it needs unlock
                if appLockViewModel.needsUnlock {
                    appLockViewModel.isAppUnlocked = false
                }
            case .inactive, .background:
                // App goes to the background
                // Mark needsUnlock as true
                appLockViewModel.needsUnlock = true
            @unknown default:
                break
            }
        }
    }
}

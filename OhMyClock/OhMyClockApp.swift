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
            Group {
                    if authViewModel.userSession != nil {
                        if appLockViewModel.isAppLockEnabled && appLockViewModel.needsUnlock {
                            BiometricLoginView(appLockViewModel: appLockViewModel)
                        } else {
                            ContentView()
                                .environmentObject(AudioManager())
//                                .environmentObject(authViewModel)
//                                .environmentObject(appLockViewModel)
                        }
                    } else {
                        LoginView()
                    }
                }
                .environmentObject(authViewModel)
                .environmentObject(appLockViewModel)
        }
        .onChange(of: scenePhase) { newScenePhase in            switch newScenePhase {
            case .active:
                // App becomes active
                if appLockViewModel.isAppLockEnabled && appLockViewModel.needsUnlock {
                    appLockViewModel.isAppUnlocked = false
                }
            case .inactive, .background:
                // App goes to the background
                if appLockViewModel.isAppLockEnabled {
                    appLockViewModel.needsUnlock = true
                }
            @unknown default:
                break
            }
        }
    }
}

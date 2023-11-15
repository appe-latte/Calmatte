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
    @StateObject var audioManager = AudioManager()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var appLockViewModel = AppLockViewModel()
    @StateObject var moodModelController = MoodModelController()
    
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            contentView
                .environmentObject(audioManager)
                .environmentObject(authViewModel)
                .environmentObject(appLockViewModel)
                .environmentObject(moodModelController)
        }
        .onChange(of: scenePhase, perform: handleScenePhase)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if authViewModel.userSession != nil {
            if appLockViewModel.isAppLockEnabled && appLockViewModel.needsUnlock {
                BiometricLoginView(appLockViewModel: appLockViewModel)
            } else {
                ContentView()
            }
        } else {
            LoginView()
        }
    }
    
    private func handleScenePhase(_ newScenePhase: ScenePhase) {
        switch newScenePhase {
        case .active:
            if appLockViewModel.isAppLockEnabled {
                appLockViewModel.isAppUnlocked = false
            }
        case .inactive, .background:
            if appLockViewModel.isAppLockEnabled {
                appLockViewModel.needsUnlock = true
            }
        @unknown default:
            break
        }
    }
}


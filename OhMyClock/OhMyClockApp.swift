//
//  OhMyClockApp.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI
import UIKit

@main
struct OhMyClockApp: App {
    @StateObject var audioManager = AudioManager()
    @StateObject var timerModel: TimerModel = .init()
    @State private var isActive = false
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Store last timer stamp
    @State var lastActiveTimeStamp : Date = Date()
    
    init() {
        // MARK: Set the screen brightness to 0.65 after 2 minutes of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            UIScreen.main.brightness = 0.65
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environmentObject(audioManager)
//                    .environmentObject(timerModel)
                    .onAppear {
                        // Prevent the screen from sleeping
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    .onDisappear {
                        // Allow the screen to sleep
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
            } else {
                SplashScreenView()
            }
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if timerModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        timerModel.isStarted = false
                        timerModel.totalSeconds = 0
                        timerModel.isFinished = true
                    } else {
                        timerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}


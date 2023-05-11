//
//  OhMyClockApp.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI

@main
struct OhMyClockApp: App {
    @StateObject var audioManager = AudioManager()
    @StateObject var timerModel: TimerModel = .init()
    
    // MARK: Scene phase
    @Environment(\.scenePhase) var phase
    
    // MARK: Store last timer stamp
    @State var lastActiveTimeStamp : Date = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(timerModel)
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
    
    init() {
        // MARK: Disable the idle timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // MARK: Set the screen brightness to 0.65 after 2 minutes of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            UIScreen.main.brightness = 0.65
        }
    }
}


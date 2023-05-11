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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(timerModel)
        }
    }
    
    init() {
        // Disable the idle timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Set the screen brightness to 0.5 after 2 minutes of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            UIScreen.main.brightness = 0.5
        }
    }
}

